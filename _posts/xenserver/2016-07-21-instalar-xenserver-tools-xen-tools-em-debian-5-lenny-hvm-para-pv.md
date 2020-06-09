---
title: Instalar Xenserver Tools (xen-tools) em Debian 5 (Lenny) (HVM para PV)
author: marllus
categories:
- tecnologia
layout: post
tags: xenserver
image: assets/images/installdebian.jpg
---

O tutorial de hoje é sobre como intalar o XenTools em uma VM Debian 5.0 (Lenny) em um Xenserver que não tem suporte a mesma (support guests), como ocorre a partir da versão 6.2.

Bem, instalar o xen-tools vai habilitar o administrador a realizar diversas operações com a VM, como gerenciar a network da mesma, monitorar o uso de memória RAM, realizar Xen Motion além de fornecer drivers para otimização de I/O de disco e rede.

As vezes, ocorre de você ter um sistema legado (ex. Debian 5.0), exportado de um outro hypervisor ou de uma máquina física, no seu ambiente de virtualização. Baseado nesse tipo de situação, deixo aqui um tutorial de como facilmente você pode instalar o xen-tools nessa VM e de quebra realizar a paravirtualização da mesma (HVM para PV).

Os passos a seguir mostram como instalar o xen-tools em um Debian 5 estando em um XenServer 7 &#8211; Dundee. Pode ser feito também em outras versões do XenServer, como 6.2 e 6.5.

Primeiro, vamos baixar o xen tools do XenServer 6.0 (Não é fácil encontrá-lo separado na internet, então instalei o mesmo e o peguei da pasta /_opt_/_xensource_/packages/iso/) e o coloquei em uma pasta pública para donwload. O link está abaixo:
  
https://dl.dropboxusercontent.com/u/4912938/xentools6.0.iso

Com a VM ligada, baixe o arquivo para dentro da mesma. Abaixo cito um exemplo usando wget:
  
\# _wget https://dl.dropboxusercontent.com/u/4912938/xentools6.0.iso_

Após isso, monte o arquivo .iso:
  
\# _mount -o loop xentools6.0.iso /mnt_

OBS: O diretório /mnt foi colocado como exemplo. Se tiver outro diretório onde queira montar, altere-o.

Entre no diretório de execução do script do xen-tools e execute-o:
  
\# _cd /mnt/Linux/_
  
\# _./install_

O script vai gerar um informação na tela relatando que reconheceu o sistema operacional Debian 5.0 e que vai atualizar diversos arquivos, incluindo o kernel do sistema (que é um kernel paravirtualizado).

Pressione a tecla &#8216;y&#8217; para confirmar a instalação e configuração.

Aguarde um instante e logo terminará a instalação. No final do relatório o testo irá relatar para reiniciar a VM.
  
**NÃO REINICIE AINDA.**
  
**NÃO REINICIE AINDA.**
  
**NÃO REINICIE AINDA.**

Se você reiniciar, o sistema não vai iniciar, pois ainda faltam configurações adicionais para o boot conseguir ser realizado.

Primeiro, entre no arquivo de configuração da inicialização do grub.
  
\# _vim /boot/grub/menu.lst_

No meu caso, o script do xen-tools instalou o kernel 2.6.32-5-amd64,  e o mesmo adicionou como partição do arquivo initrd e kernel a /dev/hda1.
  
A forma que o XenServer utiliza para gerenciar dispositivos de bloco virtuais de VMs é a xvda/xvdb&#8230; ao invés de hda/hdb&#8230; ou sda/sdb&#8230;. É aí que surge o problema. Se você deixar /dev/hda, quando o boot da VM ocorrer ele tentará iniciar o kernel paravirtualizado 2.6.32-5-amd64 e não irá conseguir, pois o mesmo está referenciado por /dev/xvd*, por isso, temos que alterar no arquivo do grub.

A imagem abaixo é para mostrar como ficará o arquivo menu.lst.
  
Percebam o &#8216;root=/dev/xvda1&#8217; para mostrar que o novo dispositivo de bloco que contém o kernel e initrd estão nesse dispositivo de bloco.

[<img class=" alignnone" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/arquivos_configuracaoboot_zps8we50omg.jpeg~original" alt="" width="625" height="344" />][1]

&nbsp;

No kernel antigo (2.6.26-2-amd64) podem deixar como está, pois não mais precisaremos dele.

Saia e salve o arquivo:
  
Tecle Esc e digite:
  
:w!

Agora vá para o arquivo padrão de montagem de partições para atualizar o novo nome:

\# _vim /etc/fstab_

Altere todas as linhas que contém /dev/hdx\* por /dev/xvdx\*.
  
OBS: Substitua o &#8216;x&#8217; pela letra correspondente ao dispositivo de bloco correspondente e o * pelo número referente a partição.

No meu caso exemplo, o arquivo ficou dessa forma:

[<img class="alignnone" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/fstab_zps6q8iwbro.jpeg~original" alt="" width="579" height="201" />][2]

Salve e saia do arquivo:
  
Tecle esc e digite:
  
:w!

Agora, iremos alterar o console padrão do sistema (tty) para o padrão do XenServer (hvc):

Entre no arquivo /etc/inittab:
  
\# _vim /etc/inittab_

Adicione a linha:
  
co:2345:respawn:/sbin/getty hvc0 9600 linux
  
antes da linha:
  
1:2345:respawn:/sbin/getty/ 38400 tty1

Agora tenha em mãos o uuid da VM (você pode vê-lo através do xencenter na aba _General _da VM no canto inferior.)

Abra o console do XenServer e digite os comandos abaixo:

Setar o novo kernel e initrd da VM:
  
_\# xe vm-param-set uuid=<vm uuid> PV-bootloader-args=&#8221;&#8211;kernel <full path to xen kernel> &#8211;ramdisk <full path to xen initrd>&#8221;
  
_ No meu caso ficou assim:
  
# _xe vm-param-set uuid=<vm uuid> PV-bootloader-args=&#8221;&#8211;kernel /boot/vmlinuz-2.6.32-5-amd64 &#8211;ramdisk /boot/initrd.img-2.6.32-5-amd64&#8243;_

Setar o local dos arquivos do kernel e initrd da VM:
  
# _xe vm-param-set uuid=_<vm uuid>_ PV-args=&#8221;root=/dev/xvdx* ro quiet console=hvc0&#8243;
  
_ No meu caso ficou assim:
  
_\# xe vm-param-set uuid=__<vm uuid>__ PV-args=&#8221;root=/dev/xvda1 ro quiet console=hvc0&#8243;_

Setar o novo bootloader (grub) da VM:
  
_# xe vm-param-set uuid=<vm uuid> PV-bootloader=pygrub_

Setar em branco o boot antigo (HVM):
  
# _xe vm-param-set uuid=<vm uuid> HVM-boot-policy=&#8221;&#8221;_

Pronto, após todos os comandos sem nenhum erro, você pode reinicializar a VM.

Caso ocorra tudo bem, quando a mesma estiver ativa, no xencenter na aba _General_ veja seu estado de virtualização  (_Virtualization state_) e veja se está com status _Optimized_. Isso quer dizer que o xen-tools está instalado.
  
Para saber se a VM está rodando em modo PV, no campo &#8220;_Virtualization mode_&#8221; vai estar escrito PV. Caso esteja utilizando o XenServer 6.5 ou 6.2 digite o comando abaixo dentro da VM:
  
\# dmesg | egrep -i &#8220;xen|front&#8221;

Se ela estiver em PV (paravirtualizada), as seguintes linhas aparecerão, dentre outras informações:
  
_&#8230;_
  
_Booting paravirtualized kernel on Xen_
  
_&#8230;_
  
_blkfront: xvda: barriers enable_
  
_Initialising Xen virtual ethernet drive_

Abaixo deixo o print da tela de opções que serão habilitadas com o xen-tools instalado:

[<img class="alignnone" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/xen-tools_zpsd1fi5tkj.png~original" alt="" width="303" height="271" />][3]

Chegamos ao fim, enfim.
  
Grande abraço e qualquer dúvida poste nos comentários ou mande e-mail (marlluslustosa@gmail.com).

Se quiser ter acesso a uma série de tutorias sobre diversas funcionalidades do XenServer, acesse a página inicial do projeto: <a href="http://www.marllus.com/xenserver" target="_blank">http://www.marllus.com/xenserver</a>

Referências:
  
<a href="http://discussions.citrix.com/topic/307891-paravirtualizing-debian/" target="_blank">http://discussions.citrix.com/topic/307891-paravirtualizing-debian/</a>
  
<a href="http://discussions.citrix.com/topic/151259-howto-convert-hvm-to-paravirtmanual-p2v-rhel5sles10sp1/" target="_blank">http://discussions.citrix.com/topic/151259-howto-convert-hvm-to-paravirtmanual-p2v-rhel5sles10sp1/</a>
  
<a href="http://support.citrix.com/article/CTX121875" target="_blank">http://support.citrix.com/article/CTX121875</a>
  
<a href="http://discussions.citrix.com/topic/259891-tut-debian-lenny-paravirtualization-with-xentools-updated/" target="_blank">http://discussions.citrix.com/topic/259891-tut-debian-lenny-paravirtualization-with-xentools-updated/</a>

 [1]: http://i567.photobucket.com/albums/ss113/marlluslustosa/arquivos_configuracaoboot_zps8we50omg.jpeg~original
 [2]: http://i567.photobucket.com/albums/ss113/marlluslustosa/fstab_zps6q8iwbro.jpeg~original
 [3]: http://i567.photobucket.com/albums/ss113/marlluslustosa/xen-tools_zpsd1fi5tkj.png~original
