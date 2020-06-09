---
title: "O XenServer Tools – XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@ashkfor121" target=_blank>Ashkan Forouzani</a>
tags: xenserver
image: assets/images/xentools.jpeg
---

Xen Tools (carinhosamente apelidado) é um pacote de drivers de rede e disco paravirtualizados. Existe tanto a versão para Guests Windows quanto GNU/Linux e o XenServer já traz, por padrão, este pacote habilitado para ser instalado em uma VM com alguns destes sistemas operacionais instalados (e suportados).

**O Xen Tools é importante?**

Sem dúvida. <a href="http://ports.marllus.com/2016/02/17/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao/" target="_blank">Neste tópico</a> falei muito sobre virtualização completa e paravirtualização. Mas, complementando este assunto, o Xen Tools contém drivers paravirtualizados de disco e rede, o que muito contribui no aumento de performance destas VMs no que diz respeito ao acesso ao disco virtual (vDisk) e transmissão/recepção de tráfego de rede.

**Tenho que instalar, obrigatoriamente, o Xen Tools?**

Você, absolutamente, não é obrigado a instalá-lo em uma VM recém criada (e nem eu vou lhe denunciar à Citrix porque você se recusa), mas, saiba que se esta VM tiver suporte para essa instalação, você estará deixando de ganhar bastante performance.

**E quais SOs das VMs são suportados para instalar o Xen Tools?**

Todas as versões dos SOs que contém na lista de templates disponíveis no XenServer. A lista destes sistemas operacionais está disponível aqui (<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_supported_OS_minimums" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_supported_OS_minimums</a>)

As instruções para instalação do Xen tools em Windows e GNU/Linux está disponível aqui (<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-installtools.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-installtools.html</a>)

&nbsp;

Referências

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_supported_OS_minimums" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_supported_OS_minimums</a>

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-installtools.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-installtools.html<br /> http://ports.marllus.com/2016/02/12/pv-hvm-hvm-com-drivers-pv-pvhvm-pvh-no-xenserver-a-sopa-de-letrinhas-da-virtualizacao</a>
