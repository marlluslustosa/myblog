---
title: Xencenter
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/bikechildren.jpg
---

<p class="p1">
  O assunto agora é sobre gerenciamento do XenServer. Neste caso, falaremos sobre XenCenter, que é o software OFICIAL de gerência do XenServer.
</p>

<p class="p1">
  Antes de começar a falar sobre ele, muita gente (principalmente os #linuxUsers) tem a seguinte dúvida: Existe alguma ferramenta de gerência do XenServer que rode na web ou que rode em Linux, já que o XenCenter só funciona por padrão no Windows?
</p>

<p class="p1">
  Resposta: Sim! Existem inúmeras ferramentas que fazem esse tipo de gerenciamento do Xen (assim como outros hypervisors [esxi, kvm..]) e que funcionam tanto na plataforma web como versão desktops.
</p>

<p class="p1">
  Ex:
</p>

<p class="p1">
  Web:
</p>

<p class="p1">
  &#8211; XenOrcherstra;
</p>

<p class="p1">
  &#8211; XAC;
</p>

<p class="p1">
  &#8211; Archipel;
</p>

<p class="p1">
  GNU/Linux / Windows:
</p>

  * OpenXenManager;
  * OpenXenCenter;
  * Libvirt;

<p class="p1">
  Explicando:
</p>

<p class="p1">
  Porém, caro usuário, a bola da vez é o seguinte dilema: Como ter eficácia/eficiência junto com estabilidade? Se queres o primeiro, significa que você quer ter uma relação perfeita, além de harmoniosa, entre que tipo de cliente (Web/Desktop) você irá usar para acessar sua infra-estrutura de virtualização e as ações que você espera o mesmo retornar a partir de seus comandos. Nem sempre é padrão a estabilidade vir com a utilização de ferramentas recomendadas oficialmente (como por muitos anos o internet explorer, arg…), mas, neste caso o que o ocorre é que várias ferramentas de terceiros (muito boas) como Xen Orcherstra e Archipel, em fase de crescimento na comunidade open source, ainda não atingiram a maturidade suficiente para ATESTAR que podem realizar, com sucesso, todos os comandos para ações realizadas em um ambiente de produção.
</p>

<p class="p1">
  No ano de 2014 vi a oportunidade de pesquisa nesta área (ainda) obscura, então, comecei a escrever minha monografia (especialização) sobre o tema, entitulada &#8220;Análise de ferramentas open-source de administração de ambientes heterogêneos de virtualização&#8221;. Defendi com sucesso a mesma em 2015.
</p>

<p class="p1">
  Como resultados desta pesquisa, concluí que, a menos que você utilize estas ferramentas para medidas de montagem de ambientes futuros e testes, não é recomendado, em ambientes de alta criticidade. Imagine a seguinte situação: Acontece um congelamento da tela do programa (ou janela), por causa de um erro interno, no momento de uma operação de migração ou cópia de uma VM. Você não consegue mais visualizar os processos nem utilização dos recursos do XenServer e nem os logs e não sabe ver, rapidamente, se o processo travou, se o XAPI caiu ou se a VM está no ar ou se foi desligada.
</p>

<p class="p1">
  Resultado: Os transtornos podem ser enormes. Fora a busca por problemas, em fóruns oficiais da ferramenta, que se torna limitada pelo fato de você já estar utilizando uma ferramenta para gerenciamento do XenServer que não a oficial.
</p>

<p class="p1">
  Atenção: Não estou promovendo o uso do Windows nem desmotivando a colaboração para com a comunidade cada vez mais livre. No entanto, preste bem atenção no que você irá colocar em produção na infra-estrutura de seu trabalho (nas suas costas!). Teste bem e crie uma documentação sobre todos os testes que fizer com ela (listando o que está dando bugs e o que funciona &#8220;redondinho&#8221;).
</p>

<p class="p1">
  Para saber como instalar o XenCenter, deixo aqui os procedimentos da documentação oficial:
</p>

<p class="p1">
  <a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-intro-welcome/xs-xc-intro-start.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-intro-welcome/xs-xc-intro-start.html</a>
</p>

<p class="p1">
  <a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/installation.html#center_installation" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/installation.html#center_installation</a>
</p>

<p class="p1">
  Espero que tenham gostado da explicação e das vantagens/desvantagens de utilização de ferramentas não oficiais.
</p>

<p class="p1">
  Abraços e até a próxima!
</p>

<p class="p1">
  Referências:
</p>

<p class="p1">
  <a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-intro-welcome/xs-xc-intro-start.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-intro-welcome/xs-xc-intro-start.html</a>
</p>

<p class="p1">
  <a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/installation.html#center_installation" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/installation.html#center_installation</a>
</p>

<p class="p1">
  <a href="http://xenserver.org/open-source-virtualization-download.html" target="_blank">http://xenserver.org/open-source-virtualization-download.html</a>
</p>
