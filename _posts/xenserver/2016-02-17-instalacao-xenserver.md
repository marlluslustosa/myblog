---
title: "Instalação XenServer"
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@jramos10" target=_blank>Josue Figueroa</a>
image: assets/images/instalacao-xen.jpeg

---

<p class="p1">
  Neste tutorial, guiarei você no processo de instalação do XenServer.
</p>

<p class="p1">
  Pois bem, primeiro de tudo é preparar a mídia de boot do XenServer. Você pode instalá-la em um CD/DVD pendrive, basta baixar a imagem .iso de instalação do mesmo e gravá-la na mídia em questão. Neste tutorial, iniciarei os procedimentos como se estivesse gravando a mídia em um pendrive através de um sistema operacional GNU/Linux, como creio que hoje o acesso a esta mídia é muito mais facilitada do que as antigas (e dispensando o serviço do estagiário de ir comprar na esquina o CD/DVD virgem pra você, rs).
</p>

<p class="p1">
  Seguem os passos:
</p>

<p class="p1">
  Pré requisitos e recomendações de hardware:
</p>

<p class="p1">
  <span class="Apple-converted-space">    </span>&#8211; Um ou mais CPU(s) 64-bit x86, mínimo de 1.5GHz.<span class="Apple-converted-space">  </span>É recomendado 2 GHz ou superior.
</p>

<p class="p1">
  OBS:Para suporte de VMs Windows, CPU com suporte às tecnologias Intel VT or AMD-V 64-bit x86<span class="Apple-converted-space"> é requerido.</span>
</p>

<p class="p1">
  <span class="Apple-converted-space">    </span>&#8211; RAM: Mínimo de 2GB. Recomendado 4GB ou mais.
</p>

<p class="p1">
  <span class="Apple-converted-space">    </span>&#8211; Disco rígido: Armazenamento local (PATA, SATA, SCSI) de 16GB é o mínimo requerido. Recomenda-se um disco de tamanho a partir de 60GB local ou SAN HBA (exceto via software) se instalado com multipathing boot SAN. OBS: A instalação do Xenserver no host produz duas partições de 4GB no disco onde será instalado.
</p>

<p class="p1">
  <span class="Apple-converted-space">    </span>&#8211; Rede: Mínimo de 100Mbit/s ou superior. Uma ou mais NICs gigabit são recomendadas para aumentar a velocidade de P2V, exportação/importação e migrações ao vivo de VMs, etc.
</p>

<p class="p1">
  Passo a passo da instalação:
</p>

<p class="p1">
  Baixe a imagem de instalação do XenServer neste link: http://downloadns.citrix.com.edgesuite.net/10175/XenServer-6.5.0-xenserver.org-install-cd.iso
</p>

<p class="p1">
  Após baixar a imagem para o seu computador, conecte o pendrive e execute o passo abaixo:
</p>

<p class="p1">
  OBS: onde você vai substituir o /dev/sdX pelo caminho do seu pendrive (ex: se você tiver dois discos na sua máquina e adicionar o pendrive, você provavelmente terá estes dispositivos: /dev/sda (primeiro disco), /dev/sdb (segundo disco), /dev/sdc (pendrive, aêêêê)). Confirme o caminho do seu pendrive e execute o seguinte comando no terminal:
</p>

<p class="p1">
  # sudo dd if=XenServer-6.5.0-xenserver.org-install-cd.iso of=/dev/sdX
</p>

<p class="p1">
  Deve demorar uns 4-5min (em um core i7) até completar a gravação, aproveite para ir ao banheiro ou conversar um pouco na copa com as #amigas!
</p>

<p class="p1">
  Próximo passo: espete o pendrive na máquina onde será instalada o XenServer e &#8220;mande brasa&#8221; no boot!
</p>

<p class="p1">
  Brevemente você verá esta tela, quando o boot da mídia começar:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.40.54_zpsd0sncnnz.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.40.54_zpsd0sncnnz.png" alt=" photo Captura de tela 2015-07-23 as 18.40.54_zpsd0sncnnz.png" width="559" height="417" border="0" /></a>

<p class="p1">
  Após alguns segundos de letras pretas descendo na tela, você verá esta tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2022.41.34_zpsloj34tjq.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2022.41.34_zpsloj34tjq.png" alt=" photo Captura de tela 2015-07-22 as 22.41.34_zpsloj34tjq.png" width="559" height="310" border="0" /></a>

<p class="p1">
  OBS: Como estava sem tempo de fazer a instalação do XenServer 6.5 e não achei na net nenhuma imagem do procedimento, coloquei prints da instalação de um XenServer 6.2 (que encontrei na net), mas, não se preocupe pois são as mesmas imagens de instalação do XenServer 6.5 (a não ser pela frase &#8220;Version 6.2.0 (#70446c)&#8221; na parte de cima da imagem).
</p>

<p class="p1">
  Escolha, então, o teclado &#8220;[qwerty] br-abnt2&#8221; e clique em &#8220;Ok&#8221;.
</p>

<p class="p1">
  Após isso aparecerá a seguinte tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2022.46.54_zpsjsymb8gs.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2022.46.54_zpsjsymb8gs.png" alt=" photo Captura de tela 2015-07-22 as 22.46.54_zpsjsymb8gs.png" width="568" height="316" border="0" /></a>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  O texto diz que a ferramenta de instalação pode ser usada tanto para instalar um XenServer ou atualizar (upgrade) uma instalação de XenServer já existente e que a instalação nova vai apagar todos os dados existentes no disco (novidade! tsc…) e que para sua segurança é melhor ter um backup antes de proceder. O legal é que você pode também carregar drivers de algum periférico &#8220;desconhecido&#8221; da máquina (isso pode acontecer caso não tenha seguido os pré requisitos do <a href="http://ports.marllus.com/2016/02/07/hcl-xenserver/" target="_blank">HCL &#8211; Lista de Compatibilidade de Hardware</a>).
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Simplesmente, pressione a tecla &#8220;Ok&#8221;.
</p>

<p class="p1">
  A seguinte tela é mostrada:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2022.55.41_zpsmpiv9vum.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2022.55.41_zpsmpiv9vum.png" alt=" photo Captura de tela 2015-07-22 as 22.55.41_zpsmpiv9vum.png" width="564" height="314" border="0" /></a>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  O texto diz que será criado um repositório de armazenamento, e te dá a opção de criar agora ou não. Em cenários de recuperação de ambiente perdido, geralmente não marcamos disco para ser repositório de armazenamento, pois quando você faz isso, tudo dentro deste disco é apagado.
</p>

<p class="p1">
  A outra opção quer saber se você quer habilitar o &#8220;thin provisioning&#8221; e que a mesma serve para otimizar o armazenamento para utilização do XenDesktop (plataforma de virtualização de desktops (VDI) da Citrix).
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Como não estamos (ainda, rsrs) fazendo nenhum teste de recuperação de dados, marque a primeira opção, habilitando o disco para ser o repositório de armazenamento. Se tiver mais de um disco e quiser marcá-lo também, fica a seu critério, lembrando que como o XenServer utiliza LVM (Logical Volume Manager) (por padrão) para realizar a operação de criação e gerenciamento do armazenamento local, você pode adicionar ou remover discos facilmente depois de o sistema ser instalado, inclusive.
</p>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  Se seu plano é criar/salvar as VMs em repositórios de armazenamento do tipo externo (SAN (iSCSI, FC), NAS (NFS)) você só precisa se preocupar em utilizar um disco interno, que será a instalação do XenServer e SR local (repositório de armazenamento ou Storage Repository).
</p>

<p class="p1">
  Lembrando que é neste passo que você vai ver os discos já em RAID (via hardware, se você tiver feito). Quanto ao software RAID, oficialmente o XenServer 6.5 não suporta a característica, mas, como o &#8220;por baixo&#8221; dele é GNU/Linux (CentOS) você pode seguir, por sua conta e risco, diversos tutoriais ensinando como fazer raid via software após a instalação do XenServer. Lá em baixo coloquei uns links para alguns tutoriais desse tipo.
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Desmarque a segunda opção (Enable thin provisioning…), pois não estamos aqui em um ambiente XenDesktop e habilitá-la não surtiria efeito algum.
</p>

<p class="p1">
  Após isso, clique no &#8220;Ok&#8221; e verá a próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.15.55_zpsfptwt3j1.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.15.55_zpsfptwt3j1.png" alt=" photo Captura de tela 2015-07-22 as 23.15.55_zpsfptwt3j1.png" width="571" height="319" border="0" /></a>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  É perguntado aqui onde está a mídia de instalação. Lembrando que você pode também selecionar para instalar por HTTP ou FTP ou NFS (Servidor de rede em um PC com a imagem .iso do XenServer!).
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Neste caso, você vai clicar em &#8220;Local media&#8221;, pois nosso sistema está no pendrive. Selecione a opção e clique em &#8220;Ok&#8221;.
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.21.14_zpscz0jorug.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.21.14_zpscz0jorug.png" alt=" photo Captura de tela 2015-07-22 as 23.21.14_zpscz0jorug.png" width="569" height="318" border="0" /></a>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  Aqui é perguntado se você quer instalar algum &#8220;suplemental packs&#8221;. Exemplos de supplemental pack é a integração do sistema de container Docker com o XenServer 6.5 SP1. Supplemental packs geralmente são fornecedos pela Citrix (drivers, ferramentas adicionais para o XenServer…) e por terceiros (geralmente plugins de monitoramento e gerenciamento do XenServer).
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Não iremos instalar nenhum pack suplemental aqui, então clique em &#8220;No&#8221;.
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.29.40_zpseqie5ra4.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.29.40_zpseqie5ra4.png" alt=" photo Captura de tela 2015-07-22 as 23.29.40_zpseqie5ra4.png" width="582" height="323" border="0" /></a>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  Aqui é perguntado se você quer testar a mídia de instalação. Geralmente, por pressa, selecionamos para pular esta verificação, mas, por experiência própria, sempre é bom testar a mídia antes de instalar, pois alguns problemas podem acontecer com a pós instalação, fazendo com que você nem desconfie dela própria (no nosso caso o pendrive). #ficadica
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Clique em &#8220;Verify installation source&#8221;.
</p>

<p class="p1">
  Após isso teremos o teste se realmente a mídia de instalação está em perfeita ordem e vai copiar direitinho os arquivos (reduzindo o custo de um futuro troubleshooting).
</p>

<p class="p1">
  Depois vem a tela para configuração de acesso ao XenServer:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.34.41_zpshs1tf6op.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.34.41_zpshs1tf6op.png" alt=" photo Captura de tela 2015-07-22 as 23.34.41_zpshs1tf6op.png" width="588" height="328" border="0" /></a>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Aqui é mais fácil ainda, defina a senha de root do sistema. Ela será usada quando conectado diretamente ao XenServer via SSH ou via XenCenter.
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.36.26_zps4ifnmfxq.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-22%20as%2023.36.26_zps4ifnmfxq.png" alt=" photo Captura de tela 2015-07-22 as 23.36.26_zps4ifnmfxq.png" width="596" height="335" border="0" /></a>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Aqui você deve definir o nome do host XenServer e os campos de DNS. Tudo fica a seu critério. Atente para colocar nomes que vão lhe gerar uma possível organização, como xenprd01, xenhml02, etc.
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.19.45_zpsvnkune0d.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.19.45_zpsvnkune0d.png" alt=" photo Captura de tela 2015-07-23 as 18.19.45_zpsvnkune0d.png" width="600" height="335" border="0" /></a>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Agora é a fase de &#8220;batismo&#8221; do seu XenServer. Nesta primeira tela você pode escolher o continente onde você estará (America or not? rs) para efeito de fuso horário.
</p>

<p class="p1">
  Na próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.22.19_zpsszjus3ef.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.22.19_zpsszjus3ef.png" alt=" photo Captura de tela 2015-07-23 as 18.22.19_zpsszjus3ef.png" width="606" height="342" border="0" /></a>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Agora é registrar a certidão de nascimento escolhendo o seu local! Escolha seu estado, caso não tenha na lista, escolha um mais próximo e com o mesmo fuso horário.
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.25.15_zpsoqhdkvp2.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.25.15_zpsoqhdkvp2.png" alt=" photo Captura de tela 2015-07-23 as 18.25.15_zpsoqhdkvp2.png" width="609" height="339" border="0" /></a>

<p class="p1">
  Explicando:
</p>

<p class="p1">
  Atentai bem para esta tela, caro irmão(ã)!! De preferência, sugiro adicionar um servidor NTP que realmente funcione! Cuidado com entradas manuais de tempo e servidores de tempo bugados! Já tive problemas grandes em um XenServer em produção por conta disso! Até descobrir o problema eu já tinha efetuado várias atualizações e re-instalações!
</p>

<p class="p1">
  O problema em se ter hosts XenServer desatualizados é porque afeta a sincronização entre estes mesmos hosts em um pool. Por exemplo, se você tem um cenário de hora desatualizada nos seus servidores XenServer e fizer uma alteração simples no ip da placa de gerência ou storage em um deles pode comprometer a sincronização da mudança entre os outros, gerando um efeito não muito agradável para o seu ambiente (não pague pra ver)!
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Adicione algum servidor NTP que você tenha, caso não saiba, use os servidores NTP do ntp.br:
</p>

<p class="p1">
  a.ntp.br
</p>

<p class="p1">
  b.ntp.br
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.38.23_zpsxneas8py.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.38.23_zpsxneas8py.png" alt=" photo Captura de tela 2015-07-23 as 18.38.23_zpsxneas8py.png" width="611" height="339" border="0" /></a>

<p class="p1">
  Instalando o sistema base…..
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.39.04_zps1t8e61qr.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.39.04_zps1t8e61qr.png" alt=" photo Captura de tela 2015-07-23 as 18.39.04_zps1t8e61qr.png" width="620" height="349" border="0" /></a>

<p class="p1">
  Caso veja esta tela, show, o sistema foi instalado com sucesso!
</p>

<p class="p1">
  Praticando:
</p>

<p class="p1">
  Clique em ok!
</p>

<p class="p1">
  O computador agora vai reinicializar!
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.40.54_zpsd0sncnnz.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.40.54_zpsd0sncnnz.png" alt=" photo Captura de tela 2015-07-23 as 18.40.54_zpsd0sncnnz.png" width="634" height="473" border="0" /></a>

<p class="p1">
  Tela de inicialização do XenServer…
</p>

<p class="p1">
  Próxima tela:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.41.02_zpsha98hvgl.png" target="_blank"><img src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Captura%20de%20tela%202015-07-23%20as%2018.41.02_zpsha98hvgl.png" alt=" photo Captura de tela 2015-07-23 as 18.41.02_zpsha98hvgl.png" border="0" /></a>

<p class="p1">
  Pronto, você está na tela padrão de entrada de console do XenServer! Aqui você pode encontrar várias informações sobre a instalação, como o menu &#8220;network and management interface&#8221;, &#8220;Disk and Storage Repositories&#8221;, &#8220;Hardware end Bios Information&#8221;, informações sobre as VMs rodando no servidor no menu &#8220;Virtual machies&#8221;. Na lateral direita você tem informações a respeito da placa de rede definida para a gerência, os IPs atribuídos e características da máquina física onde foi instalado o XenServer, neste caso está aparecendo &#8220;Vmware, Inc&#8221; pois o XenServer foi instalado já de forma virtualidade em um servidor Vmware (isso é chamado de NESTED Virtualization [rodar um hypervisor dentro de uma VM] &#8211; Lembrando que o XenServer também fornece esse tipo de virtualização &#8211; você pode instalar um vmware dentro dele &#8211; e isso é usado geralmente para testes pois neste modo o desempenho do hypervisor é degradado).
</p>

<p class="p1">
  Até aqui é isso!
</p>

<p class="p1">
  Abraços e qualquer coisa poste aí nos comentários que lhe respondo!
</p>

<p class="p1">
  Referências:
</p>

<p class="p1">
  <a href="https://blog.trendelkamp.net/2015/02/configure-software-raid-xenserver-6-5/">https://blog.trendelkamp.net/2015/02/configure-software-raid-xenserver-6-5/</a>
</p>

<p class="p1">
  <a href="http://djlab.com/2014/03/xenserver-6-2-with-software-raid/">http://djlab.com/2014/03/xenserver-6-2-with-software-raid/</a>
</p>

<p class="p1">
  <a href="http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-65/xenserver65sp1_installation_guide.pdf">http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-65/xenserver65sp1_installation_guide.pdf</a>
</p>

<p class="p1">
  <a href="http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-65/XenServer-6.5.0_QuickStartGuide.pdf">http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-65/XenServer-6.5.0_QuickStartGuide.pdf</a>
</p>

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
