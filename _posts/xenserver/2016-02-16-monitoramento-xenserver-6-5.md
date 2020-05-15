---
title: Monitoramento – XenServer 6.5
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/monitor.jpg
---

Olá, hoje o assunto é sobre Monitoramento do ambiente de virtualização XenServer.

O assunto é bem simples, mas pouca gente sabe o quão ampla é a gama de métricas que o XenServer consegue capturar no seu funcionamento.

Por padrão, é mostrado no XenCenter, na aba “performance” do host ou VM, gráficos de utilização de memória RAM, network e CPU.

Porém, você pode querer capturar outras méticas, como a quantidade de IOPS (Entra e saída por segundo) na escrita dos VDIs das VMs, a latência do disco ou rede de um host, dentre vários dados. Essas métricas são mostradas no Xencenter através de RRDs (<a href="https://pt.wikipedia.org/wiki/RRDTool" target="_blank">Base de dados Roud Robin</a>), que são arquivos que guardam diversos dados sobre as métricas de rede, CPU, RAM, Storage, etc.

Caso você queira pegar esses RRDs para utilizar em outras ferramentas, pode também capturá-los via HTTP. Como é mostrado aqui: <a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#analyzing_rrds" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#analyzing_rrds</a>

Você também pode querer adicionar o monitoramento de seu ambiente de virtualização em um software de monitoramento de ambiente, como o nagios ou cacti. Deixo um link aqui de um script para nagios para monitoramento de diversas informações em um pool de servidores XenServer. Ele é totalmente adaptável, abrindo facilmente a possibilidade de adição de novas métricas.
  
<a href="https://exchange.nagios.org/directory/Plugins/Operating-Systems/*-Virtual-Environments/Others/Check-XenServer/details" target="_blank">https://exchange.nagios.org/directory/Plugins/Operating-Systems/*-Virtual-Environments/Others/Check-XenServer/details</a>

O conjunto de métricas disponíveis no Xenserver para serem capturadas tanto no Host quanto nas VMs está disponível na documentação oficial do XenServer, que pode ser vista aqui:
  
<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#performance_monitoring" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#performance_monitoring</a>

Espero que tenha gostado da breve explicação. Qualquer dúvida, só chamar!
  
Abraço.

Referências:
  
<a href="https://pt.wikipedia.org/wiki/RRDTool" target="_blank">https://pt.wikipedia.org/wiki/RRDTool</a>
  
<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#performance_monitoring" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#performance_monitoring</a>
  
<a href="http://xenserver.org/partners/20-dev-hints/120-xs-pool-check-nagios.html" target="_blank">http://xenserver.org/partners/20-dev-hints/120-xs-pool-check-nagios.html</a>
  
<a href="https://exchange.nagios.org/directory/Plugins/Operating-Systems/*-Virtual-Environments/Others/Check-XenServer/details" target="_blank">https://exchange.nagios.org/directory/Plugins/Operating-Systems/*-Virtual-Environments/Others/Check-XenServer/details</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
