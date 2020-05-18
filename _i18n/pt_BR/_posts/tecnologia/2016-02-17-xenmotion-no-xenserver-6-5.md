---
title: XenMotion no XenServer 6.5
author: marllus
layout: post
categories: tecnologia
image: assets/images/motion.jpg
lang: en
---

XenMotion é um recurso bem interessante e muito importante dentro de ambiente de virtualização do XenServer. É com ele que o HA (High Availability), WLB (Work Load Balancing &#8211; Versão paga do XenServer &#8211; 🙁  ) e Rolling Pool Upgrade funcionam direitinho, habilitando a possibilidade de mover as VMs entre hosts do mesmo pool sem (ou quase sem) downtime (geralmente 1 ou 2 pings perdidos).

O XenMotion já vem habilitado no XenServer na versão gratuita. E ele serve, basicamente (e como falei acima), para você poder movimentar VMs &#8220;à quente&#8221; entre hosts xen em um mesmo pool, ou seja, o storage (SR) têm de ser compartilhado entre as VMs (Geralmente um storage, adicionado em um pool, do tipo iscsi, fc, nfs).

Mas, quais os requisitos mais específicos para utilizar o XenMotion?

&#8211; O XenServer tools deve estar instalado na VM;
  
&#8211; O host xen destino têm de ter a mesma ou versão superior do XenServer do host de origem;
  
&#8211; O host xen destino têm que ter memória suficiente para o provisionamento da VM, caso contrário a VM não completará o processo de migração (isso é meio lógico, rs);
  
&#8211; O drive de DVD deve estar setado como empty (não deve ter nenhuma .iso anexada ou nenhum cd/dvd dentro do drive do host físico);
  
&#8211; Ter um SR compartilhado no pool (NFS, iSCSI/FC SAN);

Mas, e em quais situações você vai usar o XenMotion (fora ficar brincando de jogar uma VM de um host pra outro só pra ver como é lindo isso funcionando, rs)?
  
Você pode usar isso, por exemplo, quando for atualizar um host xen, migrando as VMs nele contidas para um outro host xen. Além disso, você pode usar pra migrar VMs enquanto faz manutenção em um host ou até planejar um script balanceador de carga entre hosts físicos (o que o Work Loading Balancig faz &#8211; na versão do Xenserver com linceça). Enfim, as possibilidades são muitas. Só a produção e o dia a dia que vai te desafiar com situações como estas. É só pensar sobre os benefícios e planejá-los bem!

Para saber como migrar uma VM através do XenCenter, acesse esse tutorial (<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html</a>).

Tutoriais/ explicações em vídeo:
  
<a href="https://www.youtube.com/watch?v=hTlwlNjc86M" target="_blank">https://www.youtube.com/watch?v=hTlwlNjc86M</a>
  
<a href="https://www.youtube.com/watch?v=05Zc0ze5CpQ" target="_blank">https://www.youtube.com/watch?v=05Zc0ze5CpQ</a>
  
<a href="https://www.youtube.com/watch?v=vcPzrnrnYCU" target="_blank">https://www.youtube.com/watch?v=vcPzrnrnYCU</a>

Até breve!
  
Abraço!

&nbsp;

Referências:
  
<a href="http://support.citrix.com/article/CTX115813" target="_blank">http://support.citrix.com/article/CTX115813</a>
  
<a href="http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X" target="_blank">http://www.amazon.com.br/Mastering-Citrix-Xenserver-Martez-Reed/dp/178328739X</a>
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-manage/xs-xc-vms-relocate.html</a>
  
<a href="https://msinhore.wordpress.com/2012/09/20/storage-xenmotion/" target="_blank">https://msinhore.wordpress.com/2012/09/20/storage-xenmotion/</a>
  
<a href="https://www.youtube.com/watch?v=hTlwlNjc86M" target="_blank">https://www.youtube.com/watch?v=hTlwlNjc86M</a>
  
<a href="https://www.youtube.com/watch?v=05Zc0ze5CpQ" target="_blank">https://www.youtube.com/watch?v=05Zc0ze5CpQ</a>
  
<a href="https://www.youtube.com/watch?v=vcPzrnrnYCU" target="_blank">https://www.youtube.com/watch?v=vcPzrnrnYCU</a>
  
<a href="https://www.citrix.com/content/dam/citrix/en_us/documents/products-solutions/storage-xenmotion-live-storage-migration-with-citrix-xenserver.pdf?accessmode=direct" target="_blank">https://www.citrix.com/content/dam/citrix/en_us/documents/products-solutions/storage-xenmotion-live-storage-migration-with-citrix-xenserver.pdf?accessmode=direct</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
