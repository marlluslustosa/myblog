---
title: "Entendendo templates – Xenserver 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/templates-vm.jpeg
image-ref: Photo by <a href="https://unsplash.com/@polarmermaid" target=_blank>VidarAnne Nygård</a>

---

Uma VM é um recipiente de software (muitas vezes chamada de Guest) que contém informações a respeito de CPU, sistema operacional, memória RAM e recursos de rede. Esta VM funciona &#8220;em cima&#8221; do hypervisor Xen.

Pois bem, um template nada mais é que uma VM encapsulada em um arquivo e que contém todas as informações (metadados) para seu rápido provisionamento. Por exemplo, uma destas informações pode ser o tamanho padrão do disco rígido que irá ser criado para ela, ou o máximo de RAM que poderá ser atribuída a ela ou quantos CPUs a VM terá. com estas informações, a criação de VMs fica muito mais rápida para o administrador.

Outro benefício é que, além dos templates padrão que o XenServer disponibiliza de vários sistemas operacionais, você também pode criar/deletar outros novos templates.

Mas, por que devo criar templates se o XenServer já me disponbiliza vários?

Te respondo com um exemplo: Você criou uma VM e teve o maior trabalho para configurar certinho um LAMP (Linux+Apache+MySQL+PHP). Tempos depis, na empresa que você trabalha você foi solicitado para entregar uma máquina com estas mesmas configurações. Neste caso, não é preciso criar a VM e configurar na unha todos os serviços novamente. Basta gerar um template a partir da VM que você criou (e no momento após a configuração de todos os serviços). Daí, a partir deste template, você criará (replicará) uma VM idêntica à original, depois é só alterar o nome dela, alterar o IP ou outras configurações e entregar ao setor que a solicitou.

Massa né?

A figura abaixo mostra qual as características dos templates e como podem ser usados, com base no exemplo que usei.

&nbsp;

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/templates_zpsh12h7izn.png~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/templates_zpsh12h7izn.png~original" alt=" photo templates_zpsh12h7izn.png" width="644" height="620" border="0" /></a>

Existem 4 formas de se criar templates no XenServer, através do XenCenter:

&#8211; Fazendo a cópia de um template existente;

&#8211; Convertendo uma VM existente em um template (olha o exemplo que citei);

&#8211; Salvando uma cópia de um **snapshot** de uma VM em um template;

&#8211; Importando um template de uma VM (em arquivo .xva) que foi exportado de um template existente ou snapshot de uma VM;

Todo o procedimento de cada um dos passos é descrito neste link (<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-templates-new.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-templates-new.html</a>).

Qualquer dúvida, só postar nos comentários ou no fórum xen-br@googlegroups.com.

Existe como também você editar templates existentes no XenServer (como os templates prontos que já vem por padrão no XenServer). Por exemplo, neste artigo da Citrix (<a href="http://support.citrix.com/article/CTX126320" target="_blank">http://support.citrix.com/article/CTX126320</a>) é descrito como você pode alterar o limite máximo de memória suportada para uma VM, que no caso do artigo, era de no máximo 16GB.

OBS: Um ponto importante para ser dito é sobre a questão da cópia de um template ou de uma VM existente (primeira opção na lista de ser criar templates que citei acima). Nesta cópia existem dois mecanismos: A cópia completa (full copy) e a clone rápido (fast clone). Muito cuidado ao copiar como fast clone. Eu recomendo antes de o fazer, saber usá-lo e evitar futuras dores de cabeça.

Para complementar, recomendo a leitura **deste tutorial**, onde explico sobre os tipos de snapshots.

Abraços e até+!

&nbsp;

Referências:

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-templates-new.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms/xs-xc-templates-new.html</a>

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html</a>

<a href="http://support.citrix.com/article/CTX126320" target="_blank">http://support.citrix.com/article/CTX126320</a>

<a href="http://blogs.citrix.com/2012/05/03/creating-vms-from-templates-in-xenserver-creates-a-fast-clone/" target="_blank">http://blogs.citrix.com/2012/05/03/creating-vms-from-templates-in-xenserver-creates-a-fast-clone/</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
