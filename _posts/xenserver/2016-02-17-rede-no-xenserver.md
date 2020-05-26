---
title: "Rede no XenServer"
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@diesektion" target=_blank>Robert Anasch</a>
image: assets/images/rede.jpeg
---

Hoje estarei te guiando a criar e configurar redes virtuais no XenServer 6.5.

Mas, primeiro iniciarei conceituando os termos:

NIC: Adaptador de Rede (Network Interface Card). A NIC é a placa de rede física, propriamente dita, instalada no host XenServer.

PIF: Interface Física de rede (Physical Network Interface). Este termo refere-se a um objeto criado pelo XenServer para representar uma NIC física.

VIF: Interface de Rede Virtual (Virtual Network Interface). É um termo para batizar redes virtuais criadas dentro do XenServer. As VIFs são sempre associadas com NICs existentes no host XenServer. Por exemplo, você pode criar 3 VIFs associadas a uma mesma NIC e neste caso, todo tráfego destas interfaces virtuais sairão/entrarão pela mesma NIC.

Network: É um virtual switch ethernet. Esse tipo de objeto tem uma coleção de VIFs e PIFs conectada a ele. Cada host XenServer tem uma ou mais networks. Networks que não têm associação com PIFs são consideradas &#8220;internal&#8221; (o gateway é o próprio hypervisor) e são geralmente usadas para prover conectividade entre VMs em um mesmo host XenServer.

VLAN: Definidas pelo padrão IEEE 802.1Q, as Redes Locais Virtuais, habilitam uma simples rede física para suportar múltiplas redes lógicas. VLANs operam na camada 2 do modelo OSI e são bem usadas para segregar redes distintas utilizando o mesmo canal físico para transmissão.

BOND: Junção de duas ou mais NICs afim de realizar agregação/failover de links. Os modos disponíveis de BOND são:

active-active: como o nome diz, é realizada o aumento da &#8220;largura de banda&#8221; (lê-se: Taxa de transmissão) da rede da VM. Porém, vale lembrar que se um tráfego é enviado pela VM, através de uma NIC (do bond), somente um caminho vai ser eleito para este tráfego em específico. O algoritmo de análise de tráfego de rede do ambiente faz um teste, a cada 10 segundos, de quanto a VM está enviando/enviou pela rede. Resumindo, os tráfegos das VMs que estão com o bond conectados a elas são espalhados entre as NICs agrupadas do bond, mas, um único tráfego de uma VM não pode ser espalhado em várias NICs. Diferentemente ocorre com o storage multipathing (tipo de balanceamento de links entre host xen e storage), onde um tráfego pode ser dividido entre dois ou mais caminhos para o storage (em nível de bloco) (mais informações [<a href="http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-61/xs-design-iSCSI-multipathing-config.pdf" target="_blank">aqui</a>]).

active-passive: Uma NIC do bond falha, a outra assume.

LACP baseado em IP e porta: Funciona da mesma forma do bondig active-active, só que o algoritmo desse tipo de bond vai eleger o caminho para um tráfego baseado no ip e porta de origem, ou seja, várias aplicações podem usar caminhos diferentes nas NICs reais do bond. Isso é legal se você quer distribuir o tráfegos de várias aplicações que usam portas distintas na rede de uma VM entre NICs do bond.

LACP baseado em MAC address: A mesma coisa do anterior, porém, baseado no endereço MAC da VIF da VM, ou seja, o roteamento é selecionado em função da VM. Esse balanceamento é legal quando se vai utilizar várias VMs dentro de um mesmo host sem muitas aplicações funcionando em portas distintas.

A escolha desses modos irá se basear no tipo de aplicação que funcionará no ambiente, que tipo de arquitetura de rede foi planejada (quantidade de NICs, throughput, topologia, etc), que tipo de storage vai ser conectado, enfim, há uma série de pontos a serem levados em consideração para se dizer &#8220;esse é melhor do que aquele&#8221;.

OBS: XenServer 6.5 SP1 suporta o limite de 16 NICs por host xenserver e cada VM suporta até 7 VIFs associadas.

Desenhando:

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/ObjetosRedeXenserver%202_zps3y6xp1bd.png" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/ObjetosRedeXenserver%202_zps3y6xp1bd.png" alt=" photo ObjetosRedeXenserver 2_zps3y6xp1bd.png" width="614" height="405" border="0" /></a>

Para criação e gerenciamento de BONDs e outros tipos de objetos no xenserver, siga o manual oficial:

<http://docs.citrix.com/en-us/xencenter/6-2/xs-xc-hosts-manage/xs-xc-hosts-network/xs-xc-hosts-nics.html>

Praticando:

OBS: MTU significa Unidade Máxima de Transmissão e isso é um fator crucial (se bem configurado &#8211; Jumbo Frames) para uma maior eficiência na transmissão de dados para a VM, porém, existem certas limitações no Xenserver. Estas e outras informações mais detalhadas, você pode consultar no tópico &#8220;4.3.4. Jumbo frames&#8221; do &#8220;[Citrix XenServer 6.5 SP1 Administrator&#8217;s Guide][1]&#8220;.

Caso não saiba sobre MTU e nem o que colocar como valor no campo quando estiver criando um BOND ou VLAN, deixe o padrão 1500 e siga em frente.

Espero que tenha sido claro neste tutorial! Qualquer dúvida só perguntar nos comentários!

Abraço.

&nbsp;

Referências:

<http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html>

<http://support.citrix.com/article/CTX135690#LACP bonds>

<http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-61/xs-design-iSCSI-multipathing-config.pdf>

<http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#lacp-bond>

<http://docs.citrix.com/en-us/xencenter/6-2/xs-xc-hosts-manage/xs-xc-hosts-network/xs-xc-hosts-nics.html>

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>

 [1]: http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html
