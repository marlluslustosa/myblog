---
title: Troubleshooting – Resolução de problemas – XenServer 6.5
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/trouble.jpg
---

Hoje, o assunto é sobre troubleshooting, ou, para os menos familiarizados (adeptos do “se está funcionando, está bom” rs) sobre resolução de PROBLEMAS!! Até porque só tem problemas aqueles que fuçam na coisa!

De acordo com a <a href="https://pt.wikipedia.org/wiki/Troubleshooting" target="_blank">wikipedia</a>:

“Troubleshooting é uma forma de resolver problemas, muitas vezes aplicada na reparação de produtos ou processos falhados. É uma busca sistemática e lógica pela raiz de um problema, de modo a que possa ser resolvido e o produto ou processo possa ficar novamente operacional.”

Portanto, partindo do princípio da busca sistemática e lógica, utilizarei sempre diagramas sistêmicos e fluxogramas para descrever processos de troubleshooting.

Mas, porque trabalhar com fluxogramas em troubleshooting?
  
Bem, a literatura educacional já tem uma muita pesquisa sobre isso ([<a href="http://www.fctl.ucf.edu/TeachingAndLearningResources/SelectedPedagogies/TeachingMethods/" target="_blank">1</a>], [<a href="http://www.beds.ac.uk/jpd/volume-4-issue-2/teaching-with-infographics" target="_blank">2</a>], [<a href="http://www.academia.edu/6192606/Effectiveness_of_Flowchart_Proof_on_Selected_Topics_in_Geometry" target="_blank">3</a>], por exemplo), mas em resumo e tomando como questões também pessoais: Entendeu ou quer que eu desenhe?
  
Sim, esta frase, muitas vezes tratada de professor para uma sala de aula ou de um amigo que é o “sabichãozão” para com os outros, é lembrada com um tom arrogante. O que quero é tirar este rótulo.
  
No sentido literal, acredito que tudo deveria ser “desenhado”. A simples forma de uma desenho e a capacidade que ele tem de armazenar várias informações em uma única imagem torna a imersão no conhecimento mais divertida e muito menos enfadonha. Para mim, este é o verdadeiro papel do professor. Aquele que guia e consegue tornar trivial um conteúdo complexo.
  
Ler slides e livros até o google voice faz.

Você pode perceber que na maioria dos meus tutoriais eu encaixo um desenho que tenta generalizar um processo ou a arquitetura de um sistema que estou explicando. Sempre com uma única imagem.
  
Acredito neste tipo de imersão educacional. Só não esqueçamos que as referências escritas, mesmo que muitas vezes chatas, tem de ser levadas em suma consideração. Desenhos são generalizações que quase sempre não são perfeitas. A ideia dele é fazer com que o leitor desperte um interesse ou que o processo de melhoria/releitura de um conteúdo ocorra de forma mais eficiente (em menos tempo).

Bem, em processos de resolução de problemas não seria diferente. Na comunidade do xenserver temos muito pouca (ou nenhuma) documentação de troubleshooting através de fluxogramas. Claro que usuários do fórum oficial (<a href="https://discussions.citrix.com/" target="_blank">Discussion Citrix</a>) e comunidades (<a href="https://groups.google.com/forum/#!forum/xen-br" target="_blank">xen-br</a>, <a href="https://groups.google.com/forum/#!forum/gc-br" target="_blank">gc-br</a>, Telegram Xenserver) ajudam bastante, mas, é como se o conhecimento estivesse espalhado e disperso em fóruns e dúvidas de usuários. Não há algo conciso, neste caso.

Bem, uma vez fui aplicar 5 hotfixes em um xenserver 6.2 (desculpe, me atrasei). Seguindo a documentação oficial era como roubar doce de criança (mil maravilhas), mas, na prática não é bem esse carnaval não. É como você recompilar um kernel Linux achando que ele não vai dar pelo menos um bug. Inocência.
  
Caí em várias armadilhas e situações adversas neste processo e sempre resolvia tentando encontrar soluções naquele momento. Resultado: Sanei os problemas, atualizei meu ambiente e o trabalhão que deu não foi documentado. POOFF na cara da comunidade (e na minha)!

A partir daí, resolvi documentar, no estilo de fluxogramas, os processos de troubleshooting do xenserver em determinadas fases de manutenção.
  
Atualmente, realizei a criação de um fluxograma do processo referente ao troubleshooting de erros na aplicação de updates no XenServer 6.5. Disponibilizo este documento logo abaixo:

<a href="http://marllus.com/xenserver/trouble_update.html" target="_blank">Troubleshooting update – XenServer 6.5</a>:

Para muitos que sofrem com bugs quando vão atualizar seu ambiente, creio que este processo irá ser de grande ajuda.

Meu objetivo é fazer com que usuários contribuam com processos que podem ser melhorados/otimizados no fluxograma. Remodelando o documento através do perfil da comunidade, por meio de críticas e sugestões de usuários, poderemos compilar uma documentação ainda mais concisa do que disponibilizo aqui para você.

Com o passar do tempo creio que este post vai crescer bastante, pois novos fluxogramas irão sendo disponibilizados por mim e pela comunidade. É o que quero.

Um abraço! Até mais.

Referências:
  
<a href="https://pt.wikipedia.org/wiki/Troubleshooting" target="_blank">https://pt.wikipedia.org/wiki/Troubleshooting</a>
  
<a href="https://discussions.citrix.com/" target="_blank">https://discussions.citrix.com/</a>
  
<a href="https://groups.google.com/forum/#!forum/xen-br" target="_blank">https://groups.google.com/forum/#!forum/xen-br</a>
  
<a href="https://groups.google.com/forum/#!forum/gc-br" target="_blank">https://groups.google.com/forum/#!forum/gc-br</a>

&nbsp;

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
