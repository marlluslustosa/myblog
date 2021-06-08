---
title: "Importação/Exportação de VMs no XenServer 6.5"
featured: true
hidden: true
rating: 3
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@diegocatto" target=_blank>Diego Catto</a>
tags: xenserver
image: assets/images/exportacao-vm.jpeg
---

Para exemplificar os formatos aceitos na exportação, vou colocar cada um como tópico e logo abaixo as situações preferidas para utilizá-lo.

OVA/OVF (Formatos abertos &#8211; muitos hypervisors o utilizam):

* &#8211; Compartilhar vApps e VMs com outros plataformas de virtualização que suportam OVF;
* &#8211; Salvar mais que uma VM de uma vez;
* &#8211; Garantir um vApp ou VM de corrupção e falsificação;
* &#8211; Simplificar a distribuição de um vApp armazenando um pacote OVF em um arquivo OVA;

XVA (Formato do próprio XenServer &#8211; também aberto):

* &#8211; Compartilhar VMs com versões do XenServer anteriores à 6.0 (mas que também funciona em versões posteriores);
  
  &#8211; Importar/Exportar VMs por meio de scritps via linha de comando (CLI);

Importação e exportação de VMs pode ocorrer entre hypervisors XenServer bem como de outros hypervisors para o XenServer. Quando você for importar para o XenServer uma VM que foi exportada de um outro hypervisor (ex. VMware, Hyper-V, VirtualBox, etc.) você terá que rodar um sistema de verificação e correção de erros de boot que vem por padrão oferecido pelo XenServer. Basicamente é uma .iso chamada &#8220;Operating System Fixup tool&#8221;. É ela que tentará garantir a interoperabilidade (compatibilidade) no boot de uma VM &#8220;estrangeira&#8221; dentro do XenServer.

Mas, que tipo de bruxaria essa ferramenta de Fixup faz com as VMs?

&#8220;Simples&#8221;, quando a VM é iniciada, arrancando a .iso no boot, a ferramenta Fixup vai ver qual o sistema operacional da VM, se Windows ou GNU/Linux. Caso seja Windows, a ferramenta vai selecionar drivers genéricos críticos de boot da própria base de dados do sistema operacional e registrar para o boot da VM. Caso seja GNU/Linux, a ferramenta vai entrar no arquivo do GRUB e alterar as referências para os discos de inicialização de SCSI para IDE (ex. /dev/sda1 -> /dev/hda1). Outra coisa que a ferramenta faz é retirar ou desabilitar ferramentas de boot ou virtualização vindas de outros hypevisors e que podem comprometer o desempenho no XenServer.

OBS: Neste caso do Fixup, a VM é readequada, não convertida.

Outra informação importante é que em cada processo de importação ou exportação de uma VM como OVF/OVA e/ou imagem de disco (VHD e VMDK) entre o Xenserver e o local onde estão os arquivos, é feita uma intermediação entre a cópia origem-destino.

Como assim?

Sempre que uma VM, neste caso citado, é importada ou exportada, é criada uma VM (chamada &#8220;TransferVM&#8221;) para receber os dados do(s) disco(s) dela, aos poucos estes dados vão sendo transferidos para o disco/arquivo de origem. Pense na TransferVM como um firewall que filtra tudo que está passando entre uma origem (que pode ser um SR no Xenserver) e destino (que pode ser um compartilhamento NFS).

Para import/export de VMs entre repositórios remotos, você deve configurar os parâmetros de network que aparecerá na tela para TransferVM.

Caso o import/export seja localmente (de uma VM para um repositorório local do XenServer) a TransferVM é criada mas não é pedido nenhum IP. Ele já assume que está na mesma network.

Para saber como realizar importação, exportação, conhecer detalhes dos formatos disponíveis e configurações extras, pode clicar neste link (<a href="http://docs.citrix.com/en-us/xencenter/6-1/xs-xc-vms-exportimport/xs-xc-vms-exportimport-about.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-1/xs-xc-vms-exportimport/xs-xc-vms-exportimport-about.html</a>).

Vídeos sobre procedimentos:

Citrix Xenserver VM Import and Export:

<a href="https://www.youtube.com/watch?v=XcHbOF-D-l0" target="_blank">https://www.youtube.com/watch?v=XcHbOF-D-l0<br /> </a>Citrix XenServer &#8211; Step by Step &#8211; 5. part -Import & Export Virtual machine: <a href="https://www.youtube.com/watch?v=nZ4D0w0V8g8" target="_blank">https://www.youtube.com/watch?v=nZ4D0w0V8g8<br /> </a>Citrix XenServer 6 &#8211; Copying, Importing, Exporting, and Moving VMs:

<a href="https://www.youtube.com/watch?v=E5KnWR2JbrU" target="_blank">https://www.youtube.com/watch?v=E5KnWR2JbrU<br /> </a>Importando uma Máquina Virtual (VM) no Citrix XenCenter:

<a href="https://www.youtube.com/watch?v=qhtBQgy-vmA" target="_blank">https://www.youtube.com/watch?v=qhtBQgy-vmA<br /> </a>Citrix XenServer VM-Export:

<a href="https://www.youtube.com/watch?v=OWaca8gEIJ8" target="_blank">https://www.youtube.com/watch?v=OWaca8gEIJ8</a>

&nbsp;

Referências:

<a href="http://docs.citrix.com/en-us/xencenter/6-1/xs-xc-vms-exportimport/xs-xc-vms-exportimport-about.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-1/xs-xc-vms-exportimport/xs-xc-vms-exportimport-about.html</a>

<a href="http://support.citrix.com/article/CTX124961" target="_blank">http://support.citrix.com/article/CTX124961</a>

<a href="https://www.youtube.com/watch?v=XcHbOF-D-l0" target="_blank">https://www.youtube.com/watch?v=XcHbOF-D-l0</a>

<a href="https://www.youtube.com/watch?v=nZ4D0w0V8g8" target="_blank">https://www.youtube.com/watch?v=nZ4D0w0V8g8</a>

<a href="https://www.youtube.com/watch?v=E5KnWR2JbrU" target="_blank">https://www.youtube.com/watch?v=E5KnWR2JbrU</a>

<a href="https://www.youtube.com/watch?v=qhtBQgy-vmA" target="_blank">https://www.youtube.com/watch?v=qhtBQgy-vmA</a>

<a href="https://www.youtube.com/watch?v=OWaca8gEIJ8" target="_blank">https://www.youtube.com/watch?v=OWaca8gEIJ8</a>

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
