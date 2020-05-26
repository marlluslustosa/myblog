---
title: "Backup no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/casulo-vm.jpeg
image-ref: Photo by <a href="https://unsplash.com/@scw1217" target=_blank>Suzanne D. Williams </a>
---

Tão falado, mas tão pouco usado, o backup no XenServer parece ser complicado, mas é mais simples do que se imagina.

Primeiro, existem três níveis de backup no XenServer:

**Pool**: Esse backup guarda informações a respeito do pool, ou seja, o arquivo gerado por esse backup geralmente é bem pequeno e contém informações a respeito de quais Vms estão em cada host do pool, quantas NICs e quais os Ips dessas NICs, se tem VLAN configurada e quais os storages conectados a ele. Se você “crashar” um pool e ele se perder, esse aquivo permite você criar outro pool idêntico novamente.

**Host**: Esse backup geralmente é bem grande e contém os dados escritos no disco local do host xen. Não é recomendado você guardar este backup dentro do próprio host, pois o mesmo é bem grande (dependendo da quantidade de dados escritos no disco local do próprio host). Esse backup é interessante quanto se quer ter a instalação do XenServer com todos os patches, updates e alterações em arquivos em diretórios do SO Dom0, ou seja, quando se quer ter o mesmo host xen idêntico ao que era antes, sem maiores trabalhos. A desvantagem disso é que o arquivo gerado será bem maior que um backup de pool.

**VM**: Esse é o backup quando se quer tirar uma cópia/clone de uma VM. Geralmente se utiliza esse backup quando se quer guardar uma VM completa para ser importada em outro ambiente xenserver ou guardá-la para futuros backups. A vantagem desse procedimento é que, se você quiser uma VM consistente, terá que realizar um backup em um intervalo bem pequeno de tempo. Muitos administradores realizam esse tipo de backup uma vez no ciclo de vida de uma VM e, ao longo do tempo, vai realizando backup do SO (<a href="http://blog.bacula.org/about-bacula/what-is-bacula/" target="_blank">Bacula</a>, por exemplo).

O ideal é se planejar um backup utilizando todos esses níveis, para compor uma solução onde eu tenho tanto a agilidade de recuperação de uma VM, de um host e de um pool. Porém, muitas vezes por falta de recursos disponíveis (lê-se: espaço de armazenamento), elaboramos abordagens que se focam mais em backups de pool e Vms, pois a partir desses dois, pode se construir novamente um pool falhado. A janela de recuperação, nesse caso, será um pouco menor, mas, dependendo do nível de criticidade do ambiente, tende a ser aceitável.

As possibilidades são inúmeras e se diferenciam para cada ambiente. O “know-how” do backup é definir o planejamento dele. Após isso, só passo-a-passo.

Para compor sua solução open source de backup, sugiro pesquisar sobre o software Bacula: <a href="http://blog.bacula.org/about-bacula/what-is-bacula/" target="_blank">http://blog.bacula.org/about-bacula/what-is-bacula/</a>

Os procedimentos para realização dos diversos tipos de backup no Xenserver está disponível na documentação oficial, a qual se encontra aqui:

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#backups" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#backups</a>

Abraços e espero que tenham gostado da explicação sobre os níveis de backup existentes no Xenserver!

Referências:

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#backups" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#backups</a>

<a href="http://blog.bacula.org/about-bacula/what-is-bacula/" target="_blank">http://blog.bacula.org/about-bacula/what-is-bacula/</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
