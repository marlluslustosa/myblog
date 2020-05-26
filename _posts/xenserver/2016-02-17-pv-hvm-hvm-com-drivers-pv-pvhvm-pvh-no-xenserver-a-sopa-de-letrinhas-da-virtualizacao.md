---
title: "PV, HVM, HVM com Drivers PV, PVHVM, PVH no XenServer (A sopa de letrinhas da virtualização)"
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@meemeeno" target=_blank>Do mee</a>
image: assets/images/sopaletrinhas.jpeg
---

Hoje falarei sobre os termos PV, HVM e seus derivados. Sinceramente, esse assunto é meio tenso, pois, na internet vejo muita confusão sobre isso. Modos, grupos, grupos de modos, melhorias, tipos de virtualização, emulação&#8230; é uma sopa de letras e que no final só machuca a cabeça de quem tenta entender. Por isso, vou tentar (<del>espero</del>), da melhor forma possível, explicar pra você qual a diferença entre estes modos, suas melhorias e as vantagens e desvantagens de usar um ou outro, parafraseando o <a href="http://wiki.xenproject.org/wiki/Understanding_the_Virtualization_Spectrum" target="_blank">xenwiki</a>, sem que você sofra um aneurisma! rs

Na verdade, tudo surgiu com o modo &#8216;Totalmente Virtualizado (Fully Virtualized &#8211; FV) na <a href="https://en.wikipedia.org/wiki/Full_virtualization" target="_blank">IBM</a> em 1960&#8242;. Mas só era eficiente usá-lo nos <a href="https://www-950.ibm.com/events/wwe/grp/grp019.nsf/vLookupPDFs/7%20-%20VM-45-JahreHistory-EA-J-Elliott%20%5BKompatibilit%C3%A4tsmodus%5D/$file/7%20-%20VM-45-JahreHistory-EA-J-Elliott%20%5BKompatibilit%C3%A4tsmodus%5D.pdf" target="_blank">mainframes da IBM</a>, pois o mesmo era muito lento em arquiteturas x86.

Já em 2003, com o lançamento do projeto <a href="http://lwn.net/Articles/52033/" target="_blank">Xen 1.0</a>, foi criado o modo:

**PV (Paravirtualization ou OS Assisted Virtualization)**: Quando uma VM é executada neste modo, o seu kernel foi modificado na tentativa de proporcionar maior desempenho com utilização de hypercalls.

Hyper.. o quê?

&#8220;Simples&#8221;, por meio deste kernel modificado a VM &#8220;sabe&#8221; que está sendo virtualizada. Isto quer dizer que VMs podem realizar chamadas diretamente para o hypervisor (essa característica é conhecida como hypercalls) e isso torna o acesso ao hardware muito mais eficiente.

OBS: Essas modificações no kernel, descritas acima, geralmente são referentes ao kernel Linux. O Windows hoje não tem kernels paravirtualizados (<a href="https://sourceforge.net/p/xen/news/2003/10/xen-10-stable-released/" target="_blank">até tentaram, em vão</a>).

Porém, o tempo foi passando e surgiram tecnologias de hardware na tentativa de melhorar e tornar possível a &#8220;Full Virtualization &#8211; FV&#8221; na arquitetura x86. Foi pelo advento destas tecnologias que o projeto Xen, em 2005, lançou o suporte à HVM Guests, que conhecemos como o modo:

**HVM (Hardware Virtual Machine &#8211; também chamado de &#8216;Hardware Assisted Virtualization&#8217; e &#8216;Hardware Extensions to Full Virtualization&#8217;)**:

Neste modo, o hypervisor Xen usa o software &#8220;Qemu&#8221; para emular (via software &#8211; grande desvantagem) várias partes do host físico. Mas foi a partir das extensões HVM (criadas pela Intel e AMD e que fazem uma espécie de emulação de hardware) que foi possível &#8220;habilitar&#8221; esse modo na arquitetura x86. Essas extensões turbinam o acesso da VM à CPU do host físico, justamente onde o modo FV era mais fraco. Hoje, praticamente qualquer processador de médio porte já conta com este tipo de tecnologia (<a href="https://www.qnap.com/i/en/qa/con_show.php?op=showone&cid=258" target="_blank">Intel VTx e AMD SVM</a>).

Muito se vê os termos HVM e Full Virtualization como sendo iguais ou que um é a evolução do outro, mas, podemos dizer que as extensões HVM foram um meio para que fosse possível a utilização do FV na arquitetura x86.

Como praticamente toda a literatura se refere a HVM como um modo, também seguiremos a prática. Só não se engane nos conceitos.

Pois bem, a partir daqui é possível perceber que existem vantagens e desvantagens na utilização do modo PV bem como também no modo HVM. Partindo desse princípio, por que não tentar juntar o melhor dos dois mundos e gerar outras formas de virtualização?

Foi o que fizeram várias pessoas interessadas nisso. E ao longo dos anos, começaram a surgir melhorias, que tentavam utilizar a vantangem dos dois mundos, ou seja, a paravirtualização do modo PV com a extensão de virtualização que pode ser usada no modo HVM.

Dentre essas melhorias (vou chamá-las de derivados híbridos), podemos citar:

**HVM com drivers PV**: Modo HVM com os drivers de disco e rede paravirtualizados. Um exemplo disso, basicamente, é uma VM Windows com o XenServer tools (xentools) instalado. Este XenServer tools é um pacote de software que contém os drivers de disco e rede paravirtualizados para a VM Windows.

OBS: No caso de VM Linux, esses drivers já vêm embutidos na instalação.

**PVHVM**: Modo HVM com a paravirtualização dos drivers de disco e rede (xentools), controladores de interrupção e temporizadores. Um exemplo disso são as novas versões dos sistema operacionais suportados pelo XenServer 6.5 (RHEL 7, CentOS 7, Oracle Linux 7, Ubuntu 14.04). De acordo com a Citrix, todas as novas VMs instanciadas a partir destas versões serão criadas em modo HVM, pois estes sistemas operacionais suportam, nativamente, alternação da execução entre HVM e PV em determinadas tarefas.

OBS: Segundo <a href="https://xen-orchestra.com/blog/debian-pvhvm-vs-pv/" target="_blank">Olivier</a>, a versão padrão do Debian 7 (Wheezy) também é compilado com estes drivers, ou seja, se você instalá-lo como &#8220;Other media install&#8221; no XenServer 6.5, terá uma VM PVHVM.

**PVH**: Modo PV com a extensão de hardware em instruções privilegiadas e tabelas de páginas (ui ui ui, desculpa aê).

Esse modo com certeza é o maior refinamento do modo PV (com a junção das sempres legais extensões HVM) e talvez seja o que ficará e se perpetuará por bastante tempo em ambientes de virtualização com Hypervisor Xen. Mas, ainda não está disponível para ser testado no XenServer 6.5, só na versão do xen source 4.4 (<a href="http://wiki.xenproject.org/wiki/Linux_PVH" target="_blank">e ainda engatinhando</a>).

A imagem abaixo representa, no lado esquerdo, os modos existentes e suas respectivas melhorias (filhos híbridos) e no lado direito um comparativo do que cada modo e melhoria tem em comum ou que difere do outro, se tornando mais performático ou pior.

OBS: Como citado anteriormente, perceba que o Windows suporta somente os dois primeiros modos/derivados, &#8220;HVM&#8221; e &#8220;HVM com drivers PV&#8221;. Mas, por quê? Porque, para suportar a partir da melhoria &#8220;PVHVM&#8221; seria preciso a paravirtualização do APIC (Controlador Avançado de Interrupção Programável), consequentemente, seria necessário que o kernel do windows fosse recompilado com essa nova característica (reclame para a microsoft, rs).

Clique na imagem para aumentar o tamanho.

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/PV_HVM_zps1rp5ex6l.png~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/PV_HVM_zps1rp5ex6l.png~original" alt=" photo PV_HVM_zps1rp5ex6l.png" width="843" height="489" border="0" /></a>

A partir destes modos e suas melhorias, pode-se formular algumas perguntas:

**Qual o melhor modo, PV ou HVM?**

Depende. Em arquiteturas x86 o mais rápido é PV, já em x86\_64, é o HVM. Isso se deve a mudanças realizadas em x86\_64 pela AMD que acabaram deixando um pouco mais lenta a paravirtualização nessa arquitetura. Porém, pela preocupação com a memória extra despendida no &#8220;qemu&#8221; para a emulação da placa mãe e dispositivos PCI, muitos usuários preferem utilizar PV em VMs 64bits, mesmo que mais lento. Inclusive, a Citrix recomenda a utilização de PV (quando não há a possibilidade de PVHVM).

**Como escolher o modo ou melhoria para utilizar no meu ambiente XenServer 6.5?**

Deixo aqui um fluxograma para lhe ajudar na escolha dos modos/derivados híbridos para uma máquina virtual x86_64, que, segundo recomendado pelo próprio <a href="http://wiki.xenproject.org/wiki/Understanding_the_Virtualization_Spectrum" target="_blank">xen project</a>, irá servir para a maioria dos casos:

<img class="alignnone" src="https://wiki.xenproject.org/images/c/c2/Xen-mode-flow.png" alt="" width="359" height="466" />

Exceto as distros RHEL 7, CentOS 7, Oracle Linux 7, Ubuntu 14.04 e Debian 7 (que suportam PVHVM), e analisando o fluxograma acima, você poderá cair no modo HVM com Drivers PV, certo? Pois bem, eu, particularmente, utilizo o modo PV, mesmo em VMs (Guests) 64 bits. Apesar da rapidez adicional que eu poderia ganhar utilizando HVM, alguns fatores me levaram a adotar o PV: Recomendação da Citrix na utilização dos templates dela (PV), e vulnerabilidades importantes de segurança que afetavam somente VMs em HVM (como relatadas <a href="http://xenbits.xen.org/xsa/advisory-168.html" target="_blank">aqui</a>, <a href="http://xenbits.xen.org/xsa/advisory-169.html" target="_blank">aqui</a> e <a href="http://xenbits.xen.org/xsa/advisory-166.html" target="_blank">aqui</a>). Isso me fez repensar a importância do uso do PV até que se tivesse um modo ou melhoria que fosse MUITO vantajoso em termos de eficiência. É o caso do aparecimento do PVHVM. A própria Citrix fala isso na <a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#id533926" target="_blank">documentação oficial</a> e diz que vai começar a trabalhar com ele nos Guests que citei no início do parágrafo, apesar de não falar o nome PVHVM (creio que para não gerar um aneurisma no usuário, rs).

De forma rápida e direta (para a maioria dos casos):

**Se VM GNU/Linux e BSD:**

Use PVHVM, nos sistemas operacionais suportados. Caso contário, use PV.

**Se VM Windows:**

Use HVM com drivers PV, nos sistemas operacionais suportados. Se não, use HVM.

E o modo PVH, que é melhor? Estou aguardando poder testá-lo no XenServer. Mas, até agora só por gambiarras e ainda não é oficial, apesar de ele ter sido liberado na versão do xen 4.4, que o XenServer 6.5 incorpora.

Vamos ter que esperar um tempo até que comece a ser implementado de forma estável nas distros.

Bem, espero que tenha gostado do tutorial e da história de como surgiram os modos e suas melhorias e que saiba agora os benefícios e malefícios de cada um. O que não lhe impede de realizar testes para a comprovação destes dados (e contribuir para este tutorial).

Para mais informações, consulte as referências (espetaculares e que me ajudaram muito para a elaboração desse texto).

&nbsp;

Referências

<a href="http://hostel.ufabc.edu.br/~marcelo.nascimento/BC1518Q3/arquivos/virtualizacao_cap4-v2.pdf" target="_blank">http://hostel.ufabc.edu.br/~marcelo.nascimento/BC1518Q3/arquivos/virtualizacao_cap4-v2.pdf</a>

<a href="https://xen-orchestra.com/blog/debian-pvhvm-vs-pv/" target="_blank">https://xen-orchestra.com/blog/debian-pvhvm-vs-pv/</a>

<a href="http://wiki.xenproject.org/wiki/Understanding_the_Virtualization_Spectrum" target="_blank">http://wiki.xenproject.org/wiki/Understanding_the_Virtualization_Spectrum</a>

<a href="https://blog.xenproject.org/2012/10/23/the-paravirtualization-spectrum-part-1-the-ends-of-the-spectrum/" target="_blank">https://blog.xenproject.org/2012/10/23/the-paravirtualization-spectrum-part-1-the-ends-of-the-spectrum/</a>

<a href="https://blog.xenproject.org/2012/10/31/the-paravirtualization-spectrum-part-2-from-poles-to-a-spectrum/" target="_blank">https://blog.xenproject.org/2012/10/31/the-paravirtualization-spectrum-part-2-from-poles-to-a-spectrum/</a>

<a href="http://xenserver.org/blog/entry/creedence-debian-7-x-and-pvhvm-testing.html" target="_blank">http://xenserver.org/blog/entry/creedence-debian-7-x-and-pvhvm-testing.html</a>

<a href="http://xenproject.org/downloads/windows-pv-drivers.html" target="_blank">http://xenproject.org/downloads/windows-pv-drivers.html<br /> https://wiki.xenproject.org/images/c/c2/Xen-mode-flow.png</a>

<a href="http://www.gossamer-threads.com/lists/xen/devel/363836" target="_blank">http://www.gossamer-threads.com/lists/xen/devel/363836</a>

<a href="http://www.brendangregg.com/blog/2014-05-07/what-color-is-your-xen.html" target="_blank">http://www.brendangregg.com/blog/2014-05-07/what-color-is-your-xen.html</a>

<a href="http://www.gta.ufrj.br/grad/09_1/versao-final/virtualizacao/xen.html" target="_blank">http://www.gta.ufrj.br/grad/09_1/versao-final/virtualizacao/xen.html</a>

<a href="http://ovmnaveia.blogspot.com.br/2012/09/pvm-paravirtualizado-ou-hvm.html" target="_blank">http://ovmnaveia.blogspot.com.br/2012/09/pvm-paravirtualizado-ou-hvm.html</a>

<a href="http://www.informit.com/articles/article.aspx?p=2233978" target="_blank">http://www.informit.com/articles/article.aspx?p=2233978</a>

<a href="https://pt.wikipedia.org/wiki/Advanced_Programmable_Interrupt_Controller" target="_blank">https://pt.wikipedia.org/wiki/Advanced_Programmable_Interrupt_Controller</a>

<a href="http://www.vmware.com/files/pdf/VMware_paravirtualization.pdf" target="_blank">http://www.vmware.com/files/pdf/VMware_paravirtualization.pdf</a>

<a href="https://en.wikipedia.org/wiki/IBM_CP-40" target="_blank">https://en.wikipedia.org/wiki/IBM_CP-40</a>

<a href="https://sourceforge.net/p/xen/mailman/message/5533663/" target="_blank">https://sourceforge.net/p/xen/mailman/message/5533663/</a>

<a href="http://lwn.net/Articles/109789/" target="_blank">http://lwn.net/Articles/109789/</a>

<a href="https://en.wikipedia.org/wiki/Full_virtualization" target="_blank">https://en.wikipedia.org/wiki/Full_virtualization</a>

<a href="https://www-950.ibm.com/events/wwe/grp/grp019.nsf/vLookupPDFs/7%20-%20VM-45-JahreHistory-EA-J-Elliott%20%5BKompatibilit%C3%A4tsmodus%5D/$file/7%20-%20VM-45-JahreHistory-EA-J-Elliott%20%5BKompatibilit%C3%A4tsmodus%5D.pdf" target="_blank">https://www-950.ibm.com/events/wwe/grp/grp019.nsf/vLookupPDFs/7%20-%20VM-45-JahreHistory-EA-J-Elliott%20%5BKompatibilit%C3%A4tsmodus%5D/$file/7%20-%20VM-45-JahreHistory-EA-J-Elliott%20%5BKompatibilit%C3%A4tsmodus%5D.pdf</a>

<a href="http://lwn.net/Articles/52033/" target="_blank">http://lwn.net/Articles/52033/</a>

<a href="https://sourceforge.net/p/xen/news/2003/10/xen-10-stable-released/" target="_blank">https://sourceforge.net/p/xen/news/2003/10/xen-10-stable-released/<br /> </a> <a href="https://www.qnap.com/i/en/qa/con_show.php?op=showone&cid=258" target="_blank">https://www.qnap.com/i/en/qa/con_show.php?op=showone&cid=258</a>

<a href="http://wiki.xenproject.org/wiki/Linux_PVH" target="_blank">http://wiki.xenproject.org/wiki/Linux_PVH</a>

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#id533926" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#id533926</a>

<a href="http://pt.slideshare.net/xen_com_mgr/performance-tuning-xen-18477250" target="_blank">http://pt.slideshare.net/xen_com_mgr/performance-tuning-xen-18477250</a>

<a href="https://xen-orchestra.com/blog/debian-pvhvm-vs-pv/" target="_blank">https://xen-orchestra.com/blog/debian-pvhvm-vs-pv/</a>

<a href="http://www.brendangregg.com/blog/2014-05-09/xen-feature-detection.html" target="_blank">http://www.brendangregg.com/blog/2014-05-09/xen-feature-detection.html</a>

<a href="http://wiki.xen.org/old-wiki/xenwiki/XenLinuxPVonHVMdrivers.html" target="_blank">http://wiki.xen.org/old-wiki/xenwiki/XenLinuxPVonHVMdrivers.html</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
