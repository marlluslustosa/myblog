---
title: "Snapshots no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@naomitamar" target=_blank>naomi tamar</a>
tags: xenserver
image: assets/images/snapshots.jpeg
---

Mas o que são snapshots? São arquivinhos (vou chamá-los assim) que possuem informações a respeito de um ponto na vida de uma VM. Essa informação serve para o administrador XenServer, por exemplo, voltar para um momento em que ele fez uma alteração na VM, como em uma pós configuração de um serviço PHP ou antes de uma trágica atualização de sistema (kernel panic, huuuuuuu).

Lembre do ponto de restauração presente no Windows. É praticamente a mesma lógica.

Os snapshots ajudam bastante em tarefas como estas, como &#8220;voltar&#8221; uma VM no tempo (<del>de volta para o futuro e mart macflein</del>) além de ser uma mão-na-roda para a realização de backups completos dela.

Para o caso de backups, eles são usados para complementar o processo de backup à quente (sem desligar a VM). Um dos métodos seria: Primeiro é tirado o snapshot da VM, depois a partir do snapshot é realizado uma cópia completa para um arquivo único de backup (.xva).

Porém, Snapshot, como muita gente acha, não é backup, de fato. Snapshot é informação da VM em um momento, ou seja, esse arquivinho grava os metadados da VM (cpu, ram, network, etc.) e o ponteiro que aponta para uma região do vDisk da VM naquele instante de tempo em que foi tirado o snapshot. Esse arquivo é realmente pequenininho.

Se você excluir sem querer um vDisk de uma VM e tentar recuperá-lo por meio de um snapshot, sinto muito meu amigo, ele não vai voltar no tempo trazendo o disco de volta, pois neste caso o próprio disco foi excluído. Como falei: Snapshot não é backup. Ele pode complementar um.

Então, você deve estar pensando, como esse arquivinho é pequeno, vou tirar vários snaphots a cada 2 segundos para ter todos os instantes de tempo da minha VM e voltar na hora que eu precisar!! ahahah

Maninho, não faça isso.

O motivo? Quando você tira um snapshot, outro disco (VDI &#8211; Virtual Disk Image) é criado na sequência, gerando uma espécie de árvore (com pai, filho, neto&#8230;), e caso o seu SR (Storage Repository) seja baseado em volume (LVM) esse novo disco ocupará um espaço bem relevante!

Para melhor explicar, desenhei o que acontece no SR (espaço consumido) em um ambiente XenServer quando se cria um snapshot de uma VM, quando o SR é iSCSI/FC ou Local LVM (onde os VDIs guardados estão em uma estrutura LVM) e quando é NFS ou Local EXT (onde os VDIs são guardados como arquivos VHD sem LVM).

**Para SR&#8217;s baseado em volume (iSCSI/FC, Local LVM):**

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/snapshots_VOlume-based_zpslrk0ifib.png~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/snapshots_VOlume-based_zpslrk0ifib.png~original" alt="" width="691" height="930" /></a>

**Para SR&#8217;s baseado em arquivo (NFS, Local EXT):**

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/Snapshots_File-based_zpsgbae9gvc.png~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/Snapshots_File-based_zpsgbae9gvc.png~original" alt="" width="691" height="930" /></a>

&nbsp;

Destas representações gráficas, podemos deduzir, de forma clara, que:

&#8211; Você deve se preocupar com o espaço alocado ao criar um snapshot quando estiver utilizando SR&#8217;s baseados em volume (Local LVM, iSCSI/FC).

Fique sempre ligado na seguinte fórmula do custo para se criar um snapshot:

**Custo (espaço gerado no SR após snapshot) = Dados escritos no disco atual + Tamanho do disco;**

Informações a respeito de criação, gerenciamento, exclusão, importação e exportação de snapshots você pode conferir nestes links:

(Xencenter GUI)

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-snapshots/xs-xc-vms-snapshots-take.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-snapshots/xs-xc-vms-snapshots-take.html</a>

(Linha de comando)

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#id555786" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#id555786</a>

Bem, de forma rápida expliquei qual o impacto da criação de snapshots em determinados tipos SR&#8217;s. Com essa informação, você já vai ter uma boa noção técnica para trabalhar com esses &#8220;arquivinhos&#8221;.

Porém, o assunto não acaba por aqui. Se você quiser aprender mais sobre eles, como o que acontece quando snapshots são excluídos (coalescing) e o espaço gerado por esta operação, o limite de criação de snapshots e o porquê disso, além de outras informações &#8220;ninjas&#8221; (como o porque de não ser possível excluir um snapshot por falta de espaço no xen host) você pode conferir nos links da referência (principalmente <a href="https://support.citrix.com/servlet/KbServlet/download/21626-102-714437/XenServer_Understanding_Snapshots.pdf" target="_blank">aqui</a> e <a href="http://xapi-project.github.io/features/snapshots/snapshots.html" target="_blank">aqui</a>).

Até mais e grande abraço!

&nbsp;

Referências:

<a href="http://avpaul.blogspot.com.br/2012/05/xenserver-losing-space-on-sr-and.html" target="_blank">http://avpaul.blogspot.com.br/2012/05/xenserver-losing-space-on-sr-and.html</a>

<a href="https://techblog.jeppson.org/2015/02/reclaim-lost-space-xenserver-6-5/" target="_blank">https://techblog.jeppson.org/2015/02/reclaim-lost-space-xenserver-6-5/</a>

<a href="https://community.spiceworks.com/topic/319881-citrix-xenserver-6-0-2-out-of-disk-space" target="_blank">https://community.spiceworks.com/topic/319881-citrix-xenserver-6-0-2-out-of-disk-space</a>

<a href="http://pt.slideshare.net/davidmcg/top-troubleshooting-tips-and-techniques-for-citrix-xenserver-deployments" target="_blank">http://pt.slideshare.net/davidmcg/top-troubleshooting-tips-and-techniques-for-citrix-xenserver-deployments</a>

<a href="http://discussions.citrix.com/topic/355832-how-to-reclaim-disk-space-from-deleted-snapshots-on-xenserver-62/" target="_blank">http://discussions.citrix.com/topic/355832-how-to-reclaim-disk-space-from-deleted-snapshots-on-xenserver-62/</a>

<a href="https://support.citrix.com/servlet/KbServlet/download/21626-102-714437/XenServer_Understanding_Snapshots.pdf" target="_blank">https://support.citrix.com/servlet/KbServlet/download/21626-102-714437/XenServer_Understanding_Snapshots.pdf</a>

<a href="http://xapi-project.github.io/features/snapshots/snapshots.html" target="_blank">http://xapi-project.github.io/features/snapshots/snapshots.html</a>

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#id555786" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#id555786</a>

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-snapshots/xs-xc-vms-snapshots-take.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-snapshots/xs-xc-vms-snapshots-take.html</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
