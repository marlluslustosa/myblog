---
title: Xenserver/XCP-ng - Cópia de VMs com RAM
featured: true
hidden: true
rating: 3
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/cofre-mar.jpg
image-ref: <a href="https://www.reddit.com/r/blender/comments/1zn20x/treasure_chest_floating_in_the_ocean_it_turned/">Treasure chest floating in the ocean</a>
tags:
- xenserver
- xcp-ng
- cópia vms
- ram
- snapshot
- cópia com memória
- disk and memory
id-ref: copia-vms-ram
---

O artigo a seguir tem como objetivo registrar um método utilizado para copiar VMs com memória RAM e disco, sem downtime entre hosts de virtualização Xenserver/XCP-ng.

#### O estado - e o problema

Como sabem, tanto o Xenserver como o XCP-ng disponibilizam de um recurso chamado Storage Xen Motion (versão para [Xenserver](https://docs.citrix.com/en-us/xenserver/7-1/vms/migrate.html) e [XCP-ng](https://xcp-ng.org/docs/updates.html#xcp-ng-7-5-7-6-and-live-migrations)), cuja função é migrar VMs ao vivo de um um lugar para outro, sem dependência de storage compartilhado, e, assim, manter o estado atual da RAM/CPU, ou seja, sem percas ou indisponibilidades de serviço. O problema é que, apesar de funcionar bem para *migração*, quando você quer **copiar** essa VM, as coisas complicam um pouco.

A questão é que, com a retirada de um *snapshot* com RAM ([disk and memory](https://docs.citrix.com/en-us/xencenter/7-1/vms-snapshots-about.html)), vc só poderá, por padrão, retornar a esse estado usando a própria VM na qual realizou o processo. Isso quer dizer que ou você migra a própria VM ou vai ter que copiá-la e religar esse clone no host de destino. Então, perderia o estado da RAM.

Passei por um problema que me desafiou recentemente. Precisei copiar uma VM para um outro ambiente de virtualização, porém, ela teria que ir com RAM, sem paradas e sem reinicializações. A máquina teria que ser um cópia, pois seria reutilizada para outros fins e necessitavam que ela estivesse da mesma forma que a VM original, sem reboot nem encerramento de processos em execução.

*OBS: a versão do host de virtualização de origem era Xenserver 7.0, então, não poderia usar o recurso de replicação contínua com RAM, presente no [XCP-ng](https://xen-orchestra.com/blog/devblog-6-backup-ram/)*.

Com isso, começei uma pequena saga; mais por achar que isso seria facilmente resolvido do que realmente pensar que este era um problema muito grande. Comecei tirando snaphots, exportando, criando templates, exportando, retornando e nada. Procurei manuais técnicos sobre cópia de VMs com RAM e nada. Só encontrava tutoriais passo a passo para retirada de snapshot com RAM e, no máximo, exportação desses para templates, mas, ora bolas, se eu faço um *snapshot* com RAM, é presumido que a sua exportação deveria ir, por padrão, com RAM habilitada, não?

Pois bem, um amigo sugeriu um parâmetro chamado "*preserve-power-state*", que eu nunca tinha usado, mas ouvia falar - tipo aquela história do caviar né. Testei copiar essa VM suspensa, preservando o estado, e não funcionou. Então, pensei que agora daria certo de exportar snaphost com RAM, habilitando esse parâmetro. Então, lá fui eu: 

Para *snapshot* com RAM, utilizei o xencenter marcando a opção disk and memory. Após término, setei que esse snapshot não seria um template:

```bash
xe snapshot-param-set is-a-template=false uuid=<snapshot uuid>
```

Depois exportei o snapshot para XVA com a bendita opção habilitada:

```bash
xe vm-export uuid=<snapshot uuid> filename=<umNomeaqui.xva> preserve-power-state=true 
```

O que aconteceu foi que após o último procedimento, a VM foi exportada como XVA. Então, transportei esse arquivo para outro host de virtualização (e agora testei tanto em outro Xenserver com igual versão como em um XCP-ng superior). Após o arquivo no outro lado, fiz um comando de importação simples:

```bash
xe vm-import filename=<umNomeaqui.xva> preserve=true sr-uuid=<uuid>
```

Após isso, magicamente a VM foi importada com estado suspenso, como se tivesse sido pausada (o estado do snapshot com RAM). Pelo Xencenter/XCP-center dá pra perceber esse estado através deste ícone <img src="/assets/images/suspended.png"> . Então, pelo xencenter/xcp-center (ou linha de comando) mesmo, cliquei em resumir (resume) e ela iniciou do ponto que havia retirado o *snapshot*, com RAM e sem nenhum tipo de processo parado. 

Bem, foi isso. Resolvi escrever este processo, além de documentar, por não ter conseguido achar nenhum outro artigo que falasse exatamente sobre esse ponto específico. Isso certamente poderá ajudar alguém no futuro!

*OBS: Como falado anteriormente, o Xen Orchestra tem um recurso chamado [replicação contínua](https://xen-orchestra.com/blog/devblog-6-backup-ram/), onde é possível replicar VMs entre hosts e storages distintos, com a RAM habilitada, o que elimina esses passos manuais que descrevi no artigo (que o recurso consegue fazer por debaixo dos panos). Mas, o meu caso foi que estava vindo do Xenserver e isso não funcionou nessa versão. Então, como se fala: CLI neles! :)*
