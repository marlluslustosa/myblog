---
title: "Upgrade/Update no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post

---
Olá amigo(a), tudo bem?

Hoje falarei sobre update e upgrade de hosts XenServer.
  
Bem, para conceituar os termos:

**Update**: Atualização (hotfixes) de procedimentos críticos e não críticos de segurança, adição de drivers ou correção de bugs em pacotes → Trivial;

**Upgrade**: Atualização de versão do sistema de virtualização XenServer, o que pode aglomerar melhorias nos drivers de dispositivos, adicionar funcionalidades, alterar versões de SO usado (neste caso, o GNU/Linux CentOS) e aumento na capacidade de processamento do próprio sistema operacional → (Geralmente crítica e menos trivial [lê-se: trabalhosa]);

O que ocorre?

Muito sysadmin deixa o seu ambiente funcional, perfeitinho e redondinho e enquanto ele estiver funcionando não meche nele porque “não se meche com quem tá queto”.

Nos meus tempos usando XenServer e GNU/Linux aprendi uma coisa: Sempre tente deixar seus sistemas com as últimas versões de atualização. Updates são lançados para serem usados, eles contém novos drivers, patches de segurança, novas versões de softwares com bugs, otimização de código, enfim, não ache que porque seu sistema está no ar que ele não pode cair amanhã por um erro que você já devia tê-lo imunizado.
  
Te garanto que é doloroso você ter que atualizar o seu ambiente com vários hotfixes na fila de espera, pois cada update vai gerar um mini ataque cardíaco em você.

Para realizar procedimento de update até a versão 6.2 do xenserver open source você teria que ir para a CLI (Linha de comando) e aplicar os passos mostrados neste tutorial:
  
<a href="http://support.citrix.com/article/CTX132791" target="_blank">http://support.citrix.com/article/CTX132791</a>

Curiosidade: Na época em que tínhamos que ir para a linha de comando na versão sem licença paga, vários usuários da comunidade elaboraram suas próprias soluções para realização de update do ambiente. E é disso que estou sempre falando: Compartilhamento de conhecimento!!
  
Olhem os links:
  
<a href="http://discussions.citrix.com/topic/310573-script-to-update-xenserver-with-powershell/" target="_blank">http://discussions.citrix.com/topic/310573-script-to-update-xenserver-with-powershell/</a>
  
<a href="https://www.citrix.com/blogs/2014/09/10/scripting-automating-vm-operations-on-xenserver-using-powershell/" target="_blank">https://www.citrix.com/blogs/2014/09/10/scripting-automating-vm-operations-on-xenserver-using-powershell/</a>
  
<a href="https://www.virtualexperience.no/2012/11/30/ctxupdate-a-powershell-script-to-download-any-citrix-updates/" target="_blank">https://www.virtualexperience.no/2012/11/30/ctxupdate-a-powershell-script-to-download-any-citrix-updates/</a>

Felizmente hoje, a partir da versão 6.5 (versão atual até a última atualização deste tutorial), como o código do XenCenter foi liberado (assim como o código de quase todas as partes do XenServer), foi inevitável liberar a opção no GUI do próprio XenCenter para realizar operações de update.
  
Isso te dá a possibilidade de deixar a cargo do XenCenter baixar as atualizações e automaticamente aplicar e reiniciar (quando for o caso) o host, sem que se precise fazer de forma manual (apesar de ele também disponibilizar a opção de reiniciar o servidor manualmente).

Por padrão, o XenCenter já vem configurado para sempre checar se existem atualizações disponíveis para hosts xen nele conectados.

Quando for tornada disponível a update, ela vai aparecer na aba de notificações do seu XenCenter, e clicando com o botão direito do mouse em cima dela você pode baixar ou obter informações sobre ela. Antes de atualizar, leia o máximo possível sobre a mesma afim de reconhecer os impactos esperados na pré e pós atualização do ambiente.

Antes disso, realize backup de suas informações como metadados do pool, hosts, e VM. Saiba como realizar backup disso tudo neste **<a href="http://ports.marllus.com/?p=164" target="_blank">aqui</a>**:

Eu criei um desenho do fluxo processual que me baseio sempre na hora de realizar procedimentos de update em ambientes XenServer, o qual disponibilizo abaixo:

&nbsp;

<a href="http://i567.photobucket.com/albums/ss113/marlluslustosa/update_xen_host_zpsp4q0deig.jpg~original" target="_blank"><img class="" src="http://i567.photobucket.com/albums/ss113/marlluslustosa/update_xen_host_zpsp4q0deig.jpg~original" alt="update" width="818" height="589" border="0" /></a>

&nbsp;

Nele, mostro que devemos sempre checar a criticidade e impactos institucionais e técnicos antes do procedimento de update, após isso será agendada a atualização (se tiver paradas no servidor, deverão ser previamente relatadas), realizar backups do pool, Vms e xen host (quando houver recurso para o último), desabilitar o HA (requisito técnico) e só depois iniciar a atualização.

Alguns procedimentos minuciosos, bem como todo o passo a passo e pré requisitos de configuração necessários para a realização de um processo de update podem ser conferidos neste link da documentação oficial:
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-updates-applying.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-updates-applying.html</a>

Com relação à Upgrades (atualização de versão) no Xenserver, existe a possibilidade de realização do procedimento de maneira live, sem que as Vms parem, claro, se você tiver storage compartilhado. As Vms podem ser migradas de um Xenserver para outro com uma versão igual ou superior da de origem, por exemplo de um xenserver 6.2 para um 6.5. Isso é vantajoso neste tipo de atualização, onde a troca das versões é crucial.

Procedimentos e detalhes técnicos de realização de upgrade em um pool (Rolling Pool Upgrade) você pode continuar a leitura do link que passei anteriormente, até chegar nessa parte:
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-upgrade.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-upgrade.html</a>

E a mesma imagem para guiar você no processo de update (colocada acima) pode ser usada no processo de upgrade, claro, alterando os detalhes de ordem técnica (na fase de “install update”), mas, o fluxo geral é o mesmo.

Espero que tenha ficado claro para vocês a importância e os procedimentos da documentação oficial que disponibilizei para você.

Grande abraço.

Referências:
  
<a href="http://support.citrix.com/article/CTX132791" target="_blank">http://support.citrix.com/article/CTX132791</a>
  
<a href="http://discussions.citrix.com/topic/310573-script-to-update-xenserver-with-powershell/" target="_blank">http://discussions.citrix.com/topic/310573-script-to-update-xenserver-with-powershell/</a>
  
<a href="https://www.citrix.com/blogs/2014/09/10/scripting-automating-vm-operations-on-xenserver-using-powershell/" target="_blank">https://www.citrix.com/blogs/2014/09/10/scripting-automating-vm-operations-on-xenserver-using-powershell/</a>
  
<a href="https://www.virtualexperience.no/2012/11/30/ctxupdate-a-powershell-script-to-download-any-citrix-updates/" target="_blank">https://www.virtualexperience.no/2012/11/30/ctxupdate-a-powershell-script-to-download-any-citrix-updates/</a>
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-updates-applying.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-updates-applying.html</a>
  
<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-upgrade.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-updates/xs-xc-upgrade.html</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
