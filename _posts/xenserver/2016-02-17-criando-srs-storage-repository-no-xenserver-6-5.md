---
title: "Criando SRs (Storage Repository) no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/storage-vm.jpeg
image-ref: Photo by <a href="https://unsplash.com/@erdaest" target=_blank>Erda Estremera</a>

---

Existem três tipos de mapeamentos de armazenamento físico (SR) para um VDI, são eles:

**VHD baseado em volume lógico (LVM) em uma LUN**: Nesse caso, a LUN é fornecida como um dispositivo de bloco para o XenServer. Nesta LUN serão criados os VHDs que correspondem aos VDIs das VM&#8217;s. Os VDIs são representado como volumes e guardados em formato VHD. A conexão para a LUN pode ser através de Fiber Channel (SR do tipo LVMoHBA), iSCSI (SR do tipo LVMoiSCSI), SAS (SR do tipo LVMoHBA) ou ainda criada localmente no host XenServer (SR local do Tipo Local LVM).

**VHD baseado em arquivo em um sistema de arquivo**: Nesse caso, o SR é criado a partir de algum compartilhamento NFS ou local (do tipo EXT). Neste SR, as VMs são criadas como VHDs, ocupando somente o espaço de escrita “naquele momento”, ou seja, são thin-provisioned.

**LUN por VDI**: Neste caso, você espeta diretamente a LUN na VM. Então, a LUN será o próprio VDI da VM. Ela escreverá diretamente na LUN, que pode estar guardada em um storage SAN, por exemplo.

Para resumir os três tipos de SR e em que casos são utilizados:

SR Volume-Based: Local LVM, iSCSI/FC/SAS.

SR File-Based: Local EXT, NFS.

VDI é uma abstração de um Hard Disk Drive (Drive de disco rígido). O formato padrão dessa abstração é o VHD (Virtual Hard Disk), que é o mesmo padrão que a Microsoft utiliza para os discos virtuais no Hyper-v (Hypervisor que ela mantém). Nesse VHD contém tudo que um HDD conteria: tabelas de partições, metadados referentes ao tamanho do dispositivo de bloco, cilindros, etc.

Como a Microsoft liberou as especificações desse padrão para a comunidade, o xensource (consequemente o Xenserver – <a href="http://support.citrix.com/article/CTX138342" target="_blank">a partir da versão 5.5 update 2</a>) o adotou para compor o formato padrão de VDI.

Portanto, quando você criar um VDI ele será gravado, por padrão, no formato VHD. Além desse formato existe também o RAW (pior performance) que você pode escolher utilizando a linha de comando (apenas) do próprio XenServer. A menos que seja um caso específico, não recomendo utilizar raw.

Com relação ao LVM e File, vai depender do tipo de armazenamento físico que você usará para ser SR no seu ambiente. Como falei anteriormente, se for utilizar iSCSI/FC/SAS ou uma partição local como LVM, você irá utilizar VHD em formato LVM. Porém, se utilizar um compartilhamento NFS como seu SR ou uma partição local formatada como EXT, os VHDs guardados nesses locais serão no formato de arquivo (File).

Agora vem a pergunta: Qual a diferença do LVM para o File? Bem, se você não leu meu artigo sobre snapshots, recomendo que leia <a href="http://ports.marllus.com/2016/02/17/snapshots-no-xenserver-6-5/" target="_blank">aqui</a>.

Mas, a diferença é que VDIs escritos em SR do tipo LVM são thick-provisioned. Já os escritos em SR do tipo File são thin-provisioned.

Para entender como funcionam esses dois &#8220;modelos&#8221; de escrita em disco, recomendo a leitura sobre isso no blog do Cleriston: <a href="http://cleriston.com.br/post/19582513172/thick-or-thin-provisioning" target="_blank">http://cleriston.com.br/post/19582513172/thick-or-thin-provisioning</a>

Quando eu estava escrevendo esse artigo, li sobre o lançamento da nova versão do Xenserver (<a href="http://xenserver.org/discuss-virtualization/virtualization-blog/entry/xenserver-dundee-beta-1-available.html" target="_blank">7 – Dundee</a>). Descobri que o mesmo vai vir com a opção de usar thin-provisioning em SR do tipo LVM. É um avanço, sem dúvidas (desde à versão 5.5 a comunidade aguarda essa feature). Porém, muito cuidado ao utilizar thin-provisioning no lado do hypervisor, pois, lembre-se que o espaço consumido no SR sempre é o que está escrito nos discos virtuais do seu ambiente naquele momento, e nunca o tamanho total desses discos. Isso abre a possibilidade de você criar, sem problemas, discos de tamanhos que, se somados, podem passar do total da capacidade física.

Imagine isso acontecendo e todos os discos virtuais atingindo sua capacidade máxima.

Dados vão para o ar! Ou melhor: pro limbo. Cuidado.

A descrição para a criação de vários tipos de SR está disponível na documentação oficial, a qual você pode conferir aqui:

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-storage/xs-xc-storage-pools-add.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-storage/xs-xc-storage-pools-add.html</a>

Grande abraço e espero que tenha ensinado de forma satisfatória sobre os pontos inerentes ao SR.

Referências:

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-storage/xs-xc-storage-pools-add.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-storage/xs-xc-storage-pools-add.html</a>

<a href="http://support.citrix.com/article/CTX125884" target="_blank">http://support.citrix.com/article/CTX125884</a>

<a href="https://en.wikipedia.org/wiki/Connectix" target="_blank">https://en.wikipedia.org/wiki/Connectix</a>

<a href="http://serverfault.com/questions/277294/what-kvm-disk-layout-to-use" target="_blank">http://serverfault.com/questions/277294/what-kvm-disk-type-to-use</a>

<a href="http://xenserver.org/discuss-virtualization/virtualization-blog/entry/xenserver-dundee-beta-1-available.html" target="_blank">http://xenserver.org/discuss-virtualization/virtualization-blog/entry/xenserver-dundee-beta-1-available.html</a>

<a href="http://cleriston.com.br/post/19582513172/thick-or-thin-provisioning" target="_blank">http://cleriston.com.br/post/19582513172/thick-or-thin-provisioning</a>

<a href="http://ports.marllus.com/2016/02/14/snapshots-no-xenserver-6-5" target="_blank">http://ports.marllus.com/2016/02/14/snapshots-no-xenserver-6-5</a>

<a href="http://support.citrix.com/article/CTX138342" target="_blank">http://support.citrix.com/article/CTX138342</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
