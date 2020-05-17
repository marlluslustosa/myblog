---
title: "DMC – Dynamic Memory Control – XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post

---
E aí, tb bem?

Você já deve ter visto esse intervalo mínimo e máximo de memória que é mostrado no XenCenter (nas configurações de memória RAM de uma VM). Talvez, possa até ter imaginado que o XenServer vai disponibilizar memória para uma VM de acordo com este intervalo, não é verdade?

É isso mesmo que acontece. Isso é o controle dinâmico de memória (DMC &#8211; Dynamic Memory Control). As vezes chamado de &#8220;dynamic memory optimization&#8221;, &#8220;memory overcommit&#8221; ou &#8220;memory ballooning&#8221;.

Quando o DMC é habilitado nas VMs, acontece o seguinte: Se tiver muita memória RAM sobrando no host xen físico, ele libera mémoria máxima para cada VM, ou seja, o valor máximo de memória que você definiu no intervalo é dado a ela (e as VMs ficam bem felizes com isso). Caso falte memória no servidor, o SenServer neste caso faz um cálculo e distribui uma fatia de memória (dentro do intervalo de memória definido em cada VM) para cada VM, não deixando nenhuma delas desamparada e também abrindo oportunidades de novas VMs serem criadas, pois sempre o XenServer irá fazer essas otimizações com o objetivo de todas serem alimentadas com memória suficiente para dar o boot (pelo menos).

Bacana, não é? Show.
  
Mas, como nem tudo são flores, ter este recurso habilitado requer o dobro de atenção na hora do planejamento de distribuição de memória entre as VMs de seu ambiente.

Imagine a seguinte situação:
  
Você tem 10 VMs com 1GB de ram funcionando no seu host xen (que tem 12GB de ram). Ou seja, até então você tem pouca memória disponível no seu Dom0 (Xen Hypervisor). Daí você vai criar mais duas VMs de 1GB de ram, então, por causa do DMC ativado em cada VM, o XenServer vai reduzir a memória de cada uma delas afim de ter memória disponível para essas duas VMs novas. Mas, esse ambiente pode entrar em colapso (elas travarem) se as VMs ficarem sem memória suficiente para funcionar, além da memória reservada para o Dom0. Então, tenha bastante cuidado no limite mínimo que você vai colocar para sempre sobrar memória disponível no servidor físico, e assim poder utilizar esse recurso tão bacana sem efeitos colaterais.

Os passos para habilitar/desabilitar o DMC em uma VM, bem como definir um tamanho fixo de memória para ela, está disponível neste link (<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-memory/xs-xc-dmc-edit.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-memory/xs-xc-dmc-edit.html</a>)

Referências:
  
<a href="http://www.thegenerationv.com/2010/04/xenserver-56-preview-part-1-dynamic.html" target="_blank">http://www.thegenerationv.com/2010/04/xenserver-56-preview-part-1-dynamic.html</a>
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-memory/xs-xc-dmc-edit.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-vms-configuring/xs-xc-vms-memory/xs-xc-dmc-edit.html</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
