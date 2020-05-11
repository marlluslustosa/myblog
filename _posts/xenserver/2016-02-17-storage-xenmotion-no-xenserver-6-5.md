---
title: "Storage XenMotion no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post

---
Olá, td bem?

Falei, anteriormente <a href="http://ports.marllus.com/2016/02/17/xenmotion-no-xenserver-6-5/" target="_blank">aqui</a> sobre &#8220;XenMotion&#8221;. Hoje irei falar sobre &#8220;Storage XenMotion&#8221;.
  
Storage XenMotion nos remete a ideia de &#8220;XenMotion entre storages&#8221;, e é exatamente isso que este recurso (fascinante) faz. A partir dele, a VM pode ser transferida entre storages distintos, ou seja, os discos da VM (VDIs) podem ser migrados entre pools diferentes (entre dois sites XenServer). Tudo isso com o mínimo de downtime possível, pois geralmente se perde alguns pings quando se é re-setado a placa de rede virtual e a rota é alterada.
  
E não é propaganda Tekpix, o recurso existe e é disponível com código fonte liberado (aêêêêêê)!!!
  
OBS: Convido você a ir no site da VMware e ver a bagatela que é a licença com o recurso equivalente (<a href="http://store.vmware.com/store/vmware/en_US/pd/productID.284281000?src=WWW_eBIZ_productpage_vSphere_EnterprisePlus_Buy_US" target="_blank">VMware Storage vMotion</a>) habilitado.

Muitos dos requisitos necessários para utilizar Storage XenMotion são do próprio XenMotion.
  
A lista com todos é essa:

&#8211; O XenServer tools deve estar instalado na VM;
  
&#8211; O host xen destino têm de ter a mesma ou versão superior do XenServer do host de origem;
  
&#8211; O host xen destino têm que ter memória suficiente para provisionar a VM, caso contrário a VM não completará o processo de migração (isso é meio lógico, rs);
  
&#8211; O drive de DVD deve estar setado como empty (não deve ter nenhuma .iso anexada ou nenhum cd/dvd dentro do drive do host);
  
&#8211; Se as CPUs dos hosts de origem e destino forem diferentes, então a CPU do servidor de destino deve suportar todos os recursos da do servidor de origem, o que, por consequência, é muito improvável que as CPUs sejam de fabricantes diferentes, ou seja, é muito recomendável você trabalhar mesmo com o mesmo fabricante de processador (por exemplo, Intel ou AMD).
  
&#8211; Não é possível migrar VMs que tenham mais de um snapshot (leia <a href="http://ports.marllus.com/2016/02/17/snapshots-no-xenserver-6-5/" target="_blank">aqui</a> meu outro tutorial sobre snapshots e saiba o porquê disso);
  
OBS: Se a VM conter um snapshot, planeje a alocação de seu espaço no storage do host destino. Caso não entenda, o link acima sobre snapshots explica tudo isso.
  
&#8211; Não é possível migrar VMs que tenham mais que 6 VDIs anexados (como somente um VDI é transferido por vez, creio que 7 VDIs iria comprometer bastante a VM em caso de um possível falha na migração).

Limitações do Storage XenMotion:

&#8211; Não deve ser usado em ambientes com XenDesktop (<a href="https://en.wikipedia.org/wiki/Desktop_virtualization" target="_blank">Virtual Desktop Infrastructure</a>);
  
&#8211; VMs que usam PCI pass-thru não podem ser migradas;
  
&#8211; A perfomance da VM irá ser reduzida no processo de migração, então, cuidado com o horário de rush;
  
&#8211; Deve ser desabilitado qualquer HA ou WLB configurado no pool de origem ou destino;

Storage XenMotion é bastante utilizado em casos de Upgrade de Xenserver Standalone (hosts xen sem pool).

Para saber como migrar uma VM através do XenCenter, acesse esse tutorial (<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html</a>).

Vídeo demonstração do Storage XenMotion:
  
https://www.youtube.com/watch?v=YWGu3tT6Z18

Até breve!
  
Abraço!

&nbsp;

Referências:
  
<a href="http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X" target="_blank">http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X</a>
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html</a>
  
<a href="http://ports.marllus.com/2016/02/17/xenmotion-no-xenserver-6-5/" target="_blank">https://msinhore.wordpress.com/2012/09/20/storage-xenmotion/</a>
  
<a href="https://www.youtube.com/watch?v=YWGu3tT6Z18" target="_blank">https://www.youtube.com/watch?v=YWGu3tT6Z18</a>
  
<a href="https://www.citrix.com/content/dam/citrix/en_us/documents/products-solutions/storage-xenmotion-live-storage-migration-with-citrix-xenserver.pdf?accessmode=direct" target="_blank">https://www.citrix.com/content/dam/citrix/en_us/documents/products-solutions/storage-xenmotion-live-storage-migration-with-citrix-xenserver.pdf?accessmode=direct<br /> http://ports.marllus.com/2016/02/15/xenmotion-no-xenserver-6-5<br /> http://store.vmware.com/store/vmware/en_US/pd/productID.284281000?src=WWW_eBIZ_productpage_vSphere_EnterprisePlus_Buy_US<br /> https://en.wikipedia.org/wiki/Desktop_virtualization<br /> </a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
