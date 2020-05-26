---
title: "Docker no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/docker-vm.jpeg
image-ref: Photo by <a href="https://unsplash.com/@vidarnm" target=_blank>Vidar Nordli-Mathisen</a>


---

Esse post é sobre Docker, porém, como o objetivo desta série de tutoriais do &#8220;Guia Zen do XenServer&#8221; é falar sobre XenServer e virtualização não vou explicar o porquê de utilizar containers e a importância de sua aplicação em ambientes de desenvolvimentos de software, mesmo sabendo que docker (o &#8220;boom&#8221; do momento) é bem importante e cada vez mais utilizado por grandes empresas.

Se você quiser entender o que é Docker e containers, veja esse vídeo que explica sobre o assunto: <a href="https://www.youtube.com/watch?v=0cDj7citEjE" target="_blank">https://www.youtube.com/watch?v=0cDj7citEjE</a>

É importante ressaltar também que o XenServer consegue gerenciar instalações Docker em VMs dentro do seu ambiente de virtualização. Consequentemente, o docker, neste caso, ainda vai ter o overhead do hypervisor, pois ele não é instalado direto no hardware, como exemplifica o conceito de container.

Informações a respeito dos benefícios de se gerenciar Docker pelo XenServer (diretamente pelo XenCenter) e o passo a passo sobre como instalar o &#8220;Container Management Supplemental pack&#8221; (pack de software para gerenciar docker) para permitir todo o resto além da instalação do coreOS (e outros Guests), está disponível nestes links:

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-container-manage.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-container-manage.html</a>

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#container_management" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#container_management</a>

Um vídeo interessante que demonstra a integração do Docker no Xenserver.

<a href="https://www.youtube.com/watch?v=sUBluy3u3Mo" target="_blank">https://www.youtube.com/watch?v=sUBluy3u3Mo</a>

Abraços e até+!

&nbsp;

Referências:

<a href="https://www.youtube.com/watch?v=0cDj7citEjE" target="_blank">https://www.youtube.com/watch?v=0cDj7citEjE</a>

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-container-manage.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-container-manage.html</a>

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#container_management" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#container_management</a>

<a href="https://www.youtube.com/watch?v=sUBluy3u3Mo" target="_blank">https://www.youtube.com/watch?v=sUBluy3u3Mo</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
