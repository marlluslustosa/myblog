---
title: "Resizing vDisks (VDIs) – XenServer 6.5"
featured: true
hidden: true
rating: 2
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/resizing-vdi.jpg
tags: xenserver
---

Bem, o tema discutido de hoje será redimensionamento de disco virtual no XenServer.

Muitas vezes, por falta de planejamento ou fatos inesperados, o tamanho do disco de uma VM precisa ser aumentado. Por conta deste problema, alguns administradores, com a visão estática de sistemas não virtualizados, não conseguem compreender com clareza como redimensionar um disco virtual.

Se você prestar atenção, o XenServer deixa você alterar o tamanho de um disco de uma VM. Para isso, é só ir na aba configurações do storage da VM e alterar o valor do tamanho dele. Mas, calma que o tamanho da partição la ná VM não vai alterar automaticamente! rs. (assim você quer demais).

Primeiro vamos entender o que é um disco de uma VM. A partir das imagens abaixo, explicarei sucintamente.

**O conjunto do relacionamento de objetos de storage do XenServer:**

**Desenhado pela <a href="http://docs.vmd.citrix.com/XenServer/5.5.0/1.0/en_gb/images/sr-diagram.png" target="_blank">Citrix</a>**:

<a href="http://docs.vmd.citrix.com/XenServer/5.5.0/1.0/en_gb/images/sr-diagram.png" target="_blank"><img class="" src="http://docs.vmd.citrix.com/XenServer/5.5.0/1.0/en_gb/images/sr-diagram.png" alt=" objects_storage_Vdi.png" width="607" height="335" border="0" /></a>

**Desenhado por <a href="http://www.amazon.com/Implementing-Citrix-XenServer-Quickstarter-Gohar/dp/1849689822" target="_blank">Gohar Ahmed</a>**:

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/storage_objects_zpshoh9pelj.jpg~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/storage_objects_zpshoh9pelj.jpg~original" alt=" objects_storage_Vdi.png" width="584" height="491" border="0" /></a>

&nbsp;

**Desenhado por <a href="http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X" target="_blank">Martez Reed</a>**:

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/storage_obj_zpsmeccoytj.jpeg~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/storage_obj_zpsmeccoytj.jpeg~original" alt=" objects_storage_Vdi.png" width="422" height="490" border="0" /></a>

&nbsp;

As três imagens demonstram os mesmos relacionamentos, só que com representações diferentes (para uma melhor didática).

Todo dispositivo relacionado com armazenamento (um disco rídigo, por exemplo) que é conectado ao XenServer será reconhecido como um PBD (dispositivo de bloco físico). Então, quando você cria um SR (repositório de storage – storage repository) dentro do XenServer, está justamente configurando este(s) PBD(s) para ser(em) o armazenamento deste SR.

Dentro deste SR eu posso ter vários VDI (imagem de disco virtual – virtual disk image), que é um objeto criado pelo XenServer que fornece uma abstração de um HDD (Disco Físico) e contém informações sobre a mídia física no qual se encontra (tipo de SR, se é compartilhável, se a mídia física é somente leitura, etc.).

O VBD (Dispositivo de Bloco Virtual), por sua vez, é uma abstração necessária para fazer a ponte entre a VM e o VDI. Ele representa o conteúdo do VDI. Caso não existisse o VBD, a VM não conseguiria utilizar o espaço que o VDI oferece dentro do SR. O VBD dá a possibilidade de a VM enxergá-lo como um dispositivo de bloco (neste caso um disco rígido) que pode ser formatado em um tipo de sistemas de arquivos. Por fim, o VBD contém atributos que ligam o VDI a VM, como QoS, atributos de leitura/escrita, se o disco é bootável, etc.

Ainda não entendeu?

Deixa eu explicar melhor:

Imagine um PC físico com um disco rígido e você instalando um debian 8 nele. Blz né? Pois bem, analogicamente, temos uma VM sendo criada no XenServer com um disco virtual. Esse disco virtual é o nosso VBD. Por trás dele teremos o VDI correspondente, que por sua vez está dentro de um SR e este SR é composto por um ou vários PBDs.

Agora, continuando o objetivo do tutorial, segue a pergunta: Como faço pra aumentar o tamanho de um disco de uma VM?

Bem, como sabemos agora, um disco de uma VM é um VBD, que por sua vez tem um correspondente VDI. Até agora beleza!

Os procedimentos genéricos padrão para aumentar (expandir) um vDisk são:

1- Ir no xencenter, configurações do storage da VM e aumentar o tamanho do disco especificado (neste ponto, você aumentou o tamanho do VDI);

2 &#8211; A partir deste ponto, o VBD irá ter um espaço adicional (não alocado) dentro dele, referente a esse aumento do VDI. Com qualquer “fdisk -l” ou “parted” você poderá ver esse espaço adicional;

3 &#8211; Agora, você terá que fazer a expansão em nível de SO (sistema de arquivo) na VM, para fazer com que a partição que você quer aumentar (ou adicionar) tenha um novo tamanho, utilizando para isso do espaço que foi inserido.

4 &#8211; Após os comandos de expansão, que podem variar se o disco tiver uma estrutura LVM (mais simples) ou sem LVM (um pouco mais de trabalho), você deve realizar um comando, em nível de SO, que vai redimensionar a partição para utilizar a nova quantidade de blocos. Geralmente em GNU/Linux o comando final é o “resize2fs /dev/particao”;

OBS1:Caso a estrutura de partições esteja organizada na forma de LVM, você poderá expandir um disco também criando um novo disco para a VM (com o espaço que quer utilizar). Quando a VM reconhecer esse novo VBD, você o formata e o transforma em PV (Volume físico – estrutura LVM) e junta o mesmo ao PV existente na VM. O LVM trás a grande vantagem (além de simular um RAID 0) de tornar mais fácil e dar novas possibilidades à manipulação dos LVs (Volumes lógicos – pontos de montagem do SO &#8211; /home, /usr, etc..) e o redimensionamento do tamanho deles.

Bem, partindo destes passos listo abaixo uma série de tutoriais que poderão ser seguidos por você para redimensionar vDisks de Vms.

Aumentando o espaço de um vDisk com uma partição nativa Linux (sem LVM):

<a href="https://www.rootusers.com/use-gparted-to-increase-disk-size-of-a-linux-native-partition/" target="_blank">https://www.rootusers.com/use-gparted-to-increase-disk-size-of-a-linux-native-partition/</a>

Aumentando o espaço de um vDisk com uma estrutura LVM através da expansão do VDI:

<a href="https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-expanding-the-virtual-machine-disk/" target="_blank">https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-expanding-the-virtual-machine-disk/</a>

Aumentando o espaço de um vDisk com uma estrutura LVM através da adição de um outro VDI (como exemplificado no OBS1):

<a href="https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-adding-a-new-disk/" target="_blank">https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-adding-a-new-disk/</a>

Para expandir o tamanho de vDisks com SO MS Windows:

<a href="http://support.citrix.com/article/CTX117630" target="_blank">http://support.citrix.com/article/CTX117630</a>

Outros tutoriais e formas de expansão de vDisk:

<a href="https://maanasroyy.wordpress.com/2012/06/03/resize-a-linux-vm-lvm-disk-in-xenserver/" target="_blank">https://maanasroyy.wordpress.com/2012/06/03/resize-a-linux-vm-lvm-disk-in-xenserver/</a>

<a href="https://codesilence.wordpress.com/2013/03/14/live-resizing-of-an-ext4-filesytem-on-linux/" target="_blank">https://codesilence.wordpress.com/2013/03/14/live-resizing-of-an-ext4-filesytem-on-linux/</a>

OBS2 : Ainda não é possível diminuir (shrink) o tamanho de um VDI dentro do Xenserver. O motivo eu creio que deva ser porque na redução de um VDI, a probabilidade de afetar uma área com dados do sistema do usuário seria bem alta. Mesmo com LVM, um algoritmo que analisasse as áreas não alocadas para serem liberadas do disco, além de muito minucioso, poderia vir a corromper o sistema em uma exclusão errada, além do que o usuário teria que desalocar aquela região que seria liberada.

Considero um problema tanto trabalhoso para resolver, mas não impossível.

Há um meio de realizar esse processo (não muito “ortodoxo” &#8211; pra não dizer gambiarra).

Os passos são listados abaixo:

&#8211; Anexar um novo VDI na VM em questão e criar uma partição em toda sua extensão (o tamanho do VDI deve ser de pelo menos do tamanho dos dados do disco);

&#8211; Utilizar algum programa de clone de disco e dar o boot via ISO (exceto o <a href="http://clonezilla.org/" target="_blank">clonezilla</a>, pois ele tem uma limitação que jájá explicarei);

ex: <a href="https://www.miray.de/products/sat.hdclone.html" target="_blank">HD clone</a>, <a href="http://www.fsarchiver.org/Fsarchiver_vs_partimage" target="_blank">fsarchiver</a>, <a href="https://fogproject.org/" target="_blank">FOG project</a>, etc.

&#8211; Clonar o disco da VM jogando a imagem no VDI anexado na mesma;

&#8211; Criar uma nova VM no Xenserver com um disco menor do tamanho que você quer diminuir;

&#8211; Iniciar o programa de clonagem e anexar na VM o VDI que contém a imagem exportada e restaurar a imagem do disco antigo para o novo disco;

OBS3: O clonezilla têm a limitação que na restauração de um disco, o tamanho do disco de origem têm de ser maior ou igual ao do disco de destino, o que é é inviável na hora de um shrink.

OBS4: Alguns usuários na internet disseram que conseguiram shrink de discos como Clonezilla (mas somente quando o disco de destino era um pouco menor de tamanho que a origem). Você pode conferir os relatos <a href="https://community.spiceworks.com/topic/225979-clonezilla-restore-to-smaller-hard-drive" target="_blank">aqui</a>.

Perceba que vários tutorias utilizam o hypervisor Vmware, mas, não se preocupe. O entendimento que você tem que ter é de como funcionam as relações de PBDs, VDIs e VBDs com Vms.

O processo de criação de disco ou aumento do tamanho usando Xenserver (Xencenter) ou Vmware (vCenter) é só interface. Os passos genéricos padrão (citados acima) são os mesmos para qualquer hypervisor.

Espero que tenha gostado!

Grande abraço.

&nbsp;

Referências:

<a href="https://www.schirmacher.de/display/INFO/How+to+increase+XenServer+virtual+machine+root+or+swap+partition" target="_blank">https://www.schirmacher.de/display/INFO/How+to+increase+XenServer+virtual+machine+root+or+swap+<br /> partition</a>

<a href="https://thewiringcloset.wordpress.com/2013/01/09/extending-a-root-filesystem-in-linux-without-lvm/" target="_blank">https://thewiringcloset.wordpress.com/2013/01/09/extending-a-root-filesystem-in-linux-without-lvm/</a>

<a href="http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1007907" target="_blank">http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1007907</a>

<a href="http://discussions.citrix.com/topic/237812-extend-vm-disk-size-debian-guest/" target="_blank">http://discussions.citrix.com/topic/237812-extend-vm-disk-size-debian-guest/</a>

<a href="https://www.rootusers.com/use-gparted-to-increase-disk-size-of-a-linux-native-partition/" target="_blank">https://www.rootusers.com/use-gparted-to-increase-disk-size-of-a-linux-native-partition/</a>

<a href="https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-expanding-the-virtual-machine-disk/" target="_blank">https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-expanding-the-virtual-machine-disk/</a>

<a href="https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-adding-a-new-disk/" target="_blank">https://www.rootusers.com/how-to-increase-the-size-of-a-linux-lvm-by-adding-a-new-disk/</a>

<a href="https://www.rootusers.com/lvm-resize-how-to-decrease-an-lvm-partition/" target="_blank">https://www.rootusers.com/lvm-resize-how-to-decrease-an-lvm-partition/</a>

<a href="http://support.citrix.com/article/CTX117630" target="_blank">http://support.citrix.com/article/CTX117630</a>

<a href="https://maanasroyy.wordpress.com/2012/06/03/resize-a-linux-vm-lvm-disk-in-xenserver/" target="_blank">https://maanasroyy.wordpress.com/2012/06/03/resize-a-linux-vm-lvm-disk-in-xenserver/</a>

<a href="https://codesilence.wordpress.com/2013/03/14/live-resizing-of-an-ext4-filesytem-on-linux/" target="_blank">https://codesilence.wordpress.com/2013/03/14/live-resizing-of-an-ext4-filesytem-on-linux/</a>

<a href="http://cleriston.com.br/post/110578666928/identificando-vdi-no-xenserver-via-command-line" target="_blank">http://cleriston.com.br/post/110578666928/identificando-vdi-no-xenserver-via-command-line</a>

<https://discussions.citrix.com/topic/361767-convert-vm-from-hyper-v-2012-to-xenserver-62/>

<a href="https://www.miray.de/products/sat.hdclone.html" target="_blank">https://www.miray.de/products/sat.hdclone.html</a>

<a href="http://www.fsarchiver.org/Fsarchiver_vs_partimage" target="_blank">http://www.fsarchiver.org/Fsarchiver_vs_partimage</a>

<a href="https://fogproject.org/" target="_blank">https://fogproject.org/</a>

<a href="http://clonezilla.org/" target="_blank">http://clonezilla.org/</a>

<a href="https://community.spiceworks.com/topic/225979-clonezilla-restore-to-smaller-hard-drive" target="_blank">https://community.spiceworks.com/topic/225979-clonezilla-restore-to-smaller-hard-drive</a>

<a href="http://clonezilla.org/clonezilla-live/doc/02_Restore_disk_image/advanced/09-advanced-param.php" target="_blank">http://clonezilla.org/clonezilla-live/doc/02_Restore_disk_image/advanced/09-advanced-param.php</a>

<a href="http://docs.vmd.citrix.com/XenServer/5.5.0/1.0/en_gb/images/sr-diagram.png" target="_blank">http://docs.vmd.citrix.com/XenServer/5.5.0/1.0/en_gb/images/sr-diagram.png</a>

<a href="http://www.amazon.com/Implementing-Citrix-XenServer-Quickstarter-Gohar/dp/1849689822" target="_blank">http://www.amazon.com/Implementing-Citrix-XenServer-Quickstarter-Gohar/dp/1849689822</a>

<a href="http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X" target="_blank">http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X</a><a href="http://www.fsarchiver.org/Fsarchiver_vs_partimage" target="_blank"><br /> </a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
