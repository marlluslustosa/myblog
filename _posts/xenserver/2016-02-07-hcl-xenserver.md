---
title: HCL Xenserver
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/compatib.jpg
---

O assunto aqui é sobre compatibilidade de hardware e XenServer.

 A Citrix mantém uma site (<a href="http://hcl.xenserver.org/">http://hcl.xenserver.org/</a>) contendo todo o conjunto de hardware homologado por ela junto a diversos fabricantes de equipamentos, como Dell, HP, Supermicro, IBM. Todo equipamento que obteve êxito nesse teste é adicionado à essa lista de compatibilidade (HCL).

<p class="p1">
  Mas, o que é essa tal de compatibilidade? Ela serve para oficializar que o XenServer vai conseguir &#8220;enxergar&#8221; (instalar os drivers) qualquer hardware que contenha na lista em questão. <span class="Apple-converted-space">   </span>
</p>

<p class="p1">
  Pois bem, quando você estiver elaborando um projeto de especificação de equipamentos (servidores, storages, placas de rede (NICs), etc.) e quiser utilizar o XenServer neste ambiente, o primeiro passo é entrar no site (<a href="http://hcl.xenserver.org/">http://hcl.xenserver.org/</a>) e procurar o hardware em questão no campo de busca do mesmo. Você poderá também selecionar algum tipo de equipamento e fazer a listagem dos homologados. Observe a imagem<span class="Apple-converted-space">  </span>do site abaixo que mostra esses duas opções que mencionei:
</p>

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/xen1_zps6fzsarnf.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/xen1_zps6fzsarnf.png" alt=" photo xen1_zps6fzsarnf.png" width="637" height="159" border="0" /></a>

<p class="p1">
  Mas, não se preocupe se o servidor onde você irá instalar o seu XenServer não está aí. Na verdade, necessariamente, isso não é um pré requisito para este fantástico virtualizador funcionar. Neste caso, ele poderá até reconhecer e instalar todos os drivers do equipamento mas não terá suporte oficial pela Citrix, se você tiver em mente de adquirir uma licença.
</p>

<p class="p1">
  Recapitulando: Ter um hardware na HCL não é requisito para a total plenitude de funcionamento do XenServer neste ou conectado a este hardware (storages, servidores, NICs, etc.)!<span class="Apple-converted-space">  </span>
</p>

<p class="p1">
  Abraços e até mais!
</p>

<p class="p1">
  Referências:
</p>

<a href="http://hcl.xenserver.org/" target="_blank">http://hcl.xenserver.org/</a>
