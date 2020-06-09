---
title: "P2V / V2V – Conversão de ambientes – XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
id-ref: p2v-v2v-conversion
tags: xenserver
image: assets/images/migration.jpg
---

Bem, P2V e V2V são termos que remetem à migração de sistemas. E migração (desde antes de cristo &#8211; <del><a href="http://www.webartigos.com/artigos/quarenta-anos-da-caminhada-do-povo-de-deus-no-deserto/77137/" target="_blank">40 anos de migração dos hebreus a Canaã</a> </del>rs) é um processo doloroso e às vezes dispendioso (de tempo e recursos físicos).

**P2V (Physical to Virtual)**: É usado quando você quer transformar uma máquina física para virtual (Migração de um PC ou notebook para um virtualizador – ex. Xenserver);

**V2V (Virtual to Virtual)**: É usada quando você quer transformar uma máquina virtual em outra virtual (geralmente quando se vai migrar Vms entre Virtualizadores distintos – ex.Vmware->Xenserver)

Bem, em meus tutoriais gosto sempre de explicar o “estado da arte” ou o “alicerce” para construção de seu próprio conhecimento através de informações precisas e minuciosas do ponto estudado. Na minha cabeça, somente um how-to passo-a-passo, sem os porquês, torna-se meramente um “cale a boca e siga-me”.

É por isso que, em quase todos os tutoriais que fiz, quando chego na parte da “mão na massa” posto links com os procedimentos. Se você consegue levantar questões a respeito do que queres fazer e planejar as soluções para tal, até um robô fará o passo a passo.

Te garanto que se sempre seguir este princípio, sua vida mudará, pois os porquês se tornarão cada vez mais frequentes. Lembre-se disso.

Bem, voltando, sem mais delongas, irei apresentar (em passos) como ocorre o processo de migração de uma máquina física ou virtual para uma VM no Xenserver 6.5. Estes procedimentos são genéricos. Os softwares utilizados para realizar as operações podem ser vários. No final, colocarei tutoriais para você seguir que citam ferramentas úteis para a realização dos procedimentos.

1. Criar uma imagem do disco rígido da máquina;

1.1. Neste passo, geralmente se inicia um cd/usb de boot de algum programa de backup (clonezilla, G4L, etc) na máquina e é copiado o disco rígido inteiro, gerando uma imagem no final do processo. Essa imagem deverá ser guardada.

2. Criar uma VM com as mesmas características de CPU, memória RAM, disco rígido e SO (caso tenha template para ela na lista de templates do XenServer – caso contrário utilizar o template other media install).

2.1. Esse passo é bem simples, só não instale nenhum SO na VM. Somente crie-a e deixe lá desligada.

3. Iniciar a VM por cd/usb de boot a partir do mesmo programa que fez backup da máquina de origem e restaurar essa imagem no novo disco que você acabou de criar para a VM.

3.1. Quando o processo de restauração concluir, geralmente ocorre de a VM não conseguir iniciar ainda, pois as informações do initrd/grub (caso a máquina seja GNU/Linux) ainda estão apontando para o kernel antigo.

Se a VM em questão não for GNU/Linux, então pule para o passo 5.

4. Atualizar imagem initrd, grub e caminhos dos discos no /etc/fstab

4.1. Nesta etapa, basicamente, você terá que montar todos os diretórios da VM em chroot a partir de um livecd/usb Linux e então criar uma nova imagem para o initrd.

5. Após isso, você terá uma VM funcional dentro do seu ambiente de virtualização Xenserver.

Somente esses 5 passos são necessários para a migração V2V ou P2V Windows/GNU/Linux onde o destino é o Xenserver 6.5

Passos adicionais são necessários para a otimização da VM, como a conversão da mesma de HVM para PV (modos de virtualização &#8211; se não sabe o que é isto clique <a href="http://ports.marllus.com/2016/02/17/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao/" target="_blank">aqui</a>) e a instalação do xentools (drivers xen para Network/disco &#8211; se não sabe o que é clique <a href="http://ports.marllus.com/2016/02/17/o-xenserver-tools-xenserver-6-5/" target="_blank">aqui</a>)

Bem, como falei, esses são os passos genéricos para se subir uma VM em um ambiente de virtualização Xenserver onde a origem era uma VM advinda de um outro sistema de virtualização ou de uma máquina física.

O PDF a seguir, originado de um colega (Germano Dias) da instituição onde trabalho (Universidade Federal do Ceará) irá embasar a parte prática de todas as informações que repassei neste fluxo. Nele é usado o software Clonezilla (GPL) para realizar o backup e restore dos discos.

Baixe <a href="http://ports.marllus.com/wp-content/uploads/2016/02/GNU-Linux-P2V-e-V2V-para-XenServer-6.5.pdf" target="_blank">aqui</a> o PDF.

Outros tutoriais podem servir como complemento ou até alternativa para esse procedimento:

Tutorial usando o comando dd: <a href="http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver" target="_blank">http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver</a>

Outro tutorial usando o clonezilla: <a href="http://www.ibm.com/developerworks/br/library/l-clonezilla/" target="_blank">http://www.ibm.com/developerworks/br/library/l-clonezilla/</a>

Você pode usar também o programa G4L Ghost 4 Linux para backup do disco (em alternativa ao clonezilla) e que vem no pacote Hiren&#8217;s bootCD 15.2: <a href="http://www.hiren.info/pages/bootcd" target="_blank">http://www.hiren.info/pages/bootcd</a>

Bom, espero que tenham gostado e até a próxima!

Dúvidas e sugestões serão bem vindas!

Abraços!

&nbsp;

Referências:

<a href="http://www.ibm.com/developerworks/br/library/l-clonezilla/" target="_blank">http://www.ibm.com/developerworks/br/library/l-clonezilla/</a>

<a href="http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver" target="_blank">http://www.lewan.com/blog/2011/04/14/p2v-conversion-of-linux-virtual-machine-for-xenserver</a>

<a href="http://www.ppgia.pucpr.br/~jamhour/RSS/TCCRSS08A/Diego%20Lima%20Santos%20-%20Artigo.pdf" target="_blank">http://www.ppgia.pucpr.br/~jamhour/RSS/TCCRSS08A/Diego%20Lima%20Santos%20-%20Artigo.pdf</a>

<a href="http://www.hiren.info/pages/bootcd" target="_blank">http://www.hiren.info/pages/bootcd</a>

<a href="http://ports.marllus.com/2016/02/17/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao/" target="_blank">http://clonezilla.org/lecture-materials/015_OSC_Tokyo_Spring_2014/slides/OSC2014-Tokyo-Spring.pdf<br /> http://ports.marllus.com/wp-content/uploads/2016/02/GNU-Linux-P2V-e-V2V-para-XenServer-6.5.pdf<br /> http://ports.marllus.com/2016/02/12/o-xenserver-tools-xenserver-6-5<br /> http://ports.marllus.com/2016/02/12/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao<br /> http://www.webartigos.com/artigos/quarenta-anos-da-caminhada-do-povo-de-deus-no-deserto/77137/</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>

&nbsp;
