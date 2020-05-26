---
title: "Fast clone e full copy de VMs no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/clone-vm.jpeg
image-ref: Photo by <a href="https://unsplash.com/@ferguso" target=_blank>Fergus So</a>
---

Hoje explicarei sobre Fast Clone e Full Copy de VMs e templates. Meu papo será focado no entendimento destes dois pontos.

Se você nunca copiou uma VM ou template, a qualquer hora irá precisar fazer isto. VMs e templates são copiados a fim de vários motivos: Para realizar testes a partir de uma VM que está em produção, provisionar (subir) novas VMs rapidamente, criar templates a partir delas, etc.

Mas, quando você vai copiar uma VM pelo XenCenter, sempre abre uma tela que te pergunta dois modos de cópia para você escolher: O fast clone ou o full copy.

Bem, quando você olha o nome fast clone dá uma ideia de mais agilidade (rapidez). Creio que muitos administradores escolhem essa opção por isso, sem saber que podem pagar caro no futuro&#8230;

Explicando mais detalhadamente:

Quando uma VM ou template é copiado pelo modo fast clone, o novo VDI da VM/template acessa os blocos antigos do VDI de origem. Por exemplo, se eu tenho uma VM com o GNU/Linux Ubuntu recém instalado e copiar esta VM como fast clone, a nova VM criada vai usar os blocos antigos (neste caso a partição do sistema completo) do disco da VM original, todo arquivo criado ou alterado a partir desse momento será gravado no novo disco. Em outras palavras, toda região do VDI da nova VM referente ao que foi gravado na VM original é um ponteiro para o disco desta VM (não há duplicação de conteúdo, em nível de bloco).

Quando uma VM ou template é copiado como full copy, o novo VDI da VM/template é totalmente independente do VDI original (que foi copiado). Todo o conteúdo é copiado (literalmente) para o novo disco. Dá pra imaginar que essa cópia é um pouco mais demorada, por esse fato.

Mas o preço a se pagar pela rapidez do fast clone, é a questão do encadeamento (acorrentamento) dos VDIs. Por padrão, o limite máximo desta cadeia (chain) é de 30 VDIs. Na prática, se você chegar em mais da metade desse limite, o acesso aos dados será bastante degradado. Essa cadeia vai aumentado a partir do momento que você vai provisionando cada vez mais VMs e copiando templates como fast clone.

Por contrapartida, isso não ocorre com o método full copy, pois não existirá ponteiros entre VDIs novos e antigos nem encadeamento entre eles (chain=0).

Vou explicar com imagens:

**O que acontece no fast clone:**

&nbsp;

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/FastClone_fullcopy_zpssg0t9fut.png~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/FastClone_fullcopy_zpssg0t9fut.png~original" alt=" photo FastClone_fullcopy_zpssg0t9fut.png" width="727" height="554" border="0" /></a>

**O que acontece no modo full copy:**

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/fullcopy_FastClone_zpsijw7afcc.png~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/fullcopy_FastClone_zpsijw7afcc.png~original" alt=" photo FastClone_fullcopy_zpssg0t9fut.png" width="727" height="554" border="0" /></a>

Para você analisar essas árvores que são criadas e que crescem a partir do provisionamento de cada vez mais cópias fast, entre no host xen em questão e digite o comando:

\# vhd-util scan -f -m &#8220;VHD-*&#8221; -l VG_XenStorage- -p

O resultado deste comando será algo do tipo:

<a href="https://www.citrix.com/blogs/wp-content/uploads/2012/05/vhd-util-sample-1024x404.png" target="_blank"><img class="" src="https://www.citrix.com/blogs/wp-content/uploads/2012/05/vhd-util-sample-1024x404.png" alt=" photo Cli_fast_parent" width="780" height="334" border="0" /></a>

Perceba que a seta indica que o VHD (VDI) mostrado na linha tem um parent (nó de origem).

Quando o parâmetro &#8220;parent&#8221; está como &#8220;none&#8221; quer dizer que o VHD não tem um pai relacionado, ou seja, ele não foi criado com fast clone.

Assim como os snapshots, quando um VDI na cadeia é excluído, um evento de aglutinação (chamado coalescing) entre VDIs é feito (em qualquer tempo &#8211; assíncrono). Após isso, algum espaço em disco no SR deverá ser liberado.

Mas, se você não quer excluir VMs encadeadas, existem três formas de resolver o problema do &#8220;encadeamento infeliz&#8221;:

&#8211; Migrar a VM encadeada para outro SR no pool. Após isso o parâmetro parent será resetado (=none).

&#8211; Setar a prioridade de IO de disco (QoS) da VM encadeada como nível alto (use isto como um paleativo). Mais detalhes <a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#disk_qos" target="_blank">aqui</a>.

&#8211; Copiar a VM encadeada novamente (Xencenter ou &#8220;vm-copy&#8221; na linha de comando), mas, desta vez como full copy (o parent também irá resetar).

Bem, creio que você agora deve entender mais sobre esses dois tipos de cópias e seus prós e contras.

Para saber como realizar os procedimenos de cópia, clique neste link (<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-vms-copy.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-vms-copy.html</a>)

&nbsp;

Referências:

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#disk_qos" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#disk_qos</a>

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-vms-copy.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-vms-copy.html</a>

<a href="https://www.citrix.com/blogs/wp-content/uploads/2012/05/vhd-util-sample-1024x404.png" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#id541790<br /> https://www.citrix.com/blogs/wp-content/uploads/2012/05/vhd-util-sample-1024&#215;404.png<br /> </a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
