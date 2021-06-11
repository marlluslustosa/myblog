---
title: Análise de dados - Como nossos deputados andam se alimentando?
author: marllus
categories: ciencia
layout: post
image: assets/images/serenata-capa.jpg
image-ref: Rosie - o robô da <a href="https://marllus.com/arte/2021/05/16/livro-antologia-poetica.html">serenata de amor</a>
tags:
- serenata de amor
- anticorrupção
- análise de dados
- alimentação
- deputados
- câmara federal
id-ref:
---

**Artigo originalmente publicado no [medium](https://medium.com/@marlluslustosa/an%C3%A1lise-de-dados-como-nossos-deputados-andam-se-alimentando-1d9a55f50ce7), em 06/06/18**.

____

Não me considero um cientista de dados, mas de um tempo pra cá andei 
brincando na área, nos meus ‘pseudo horários vagos’ que ando tendo 
(risos de alguém com uma dissertação pra terminar).  
Para fechar (ou abrir) um tema simples, tratado por mim como brincadeira inicial e que  acabou ficando bem sério, eu resolvi escrever sobre análise de dados 
públicos utilizando ferramentas computacionais. Esse, portanto, será o 
meu primeiro tópico sobre o assunto (e não sei se o último).

Ano passado, ao brincar com [*web scrapping*](https://pt.wikipedia.org/wiki/Screen_scraping#Web_scraping) *(coleta de dados)+*[*python*](https://pt.wikipedia.org/wiki/Python)*+*[*shell script*](https://pt.wikipedia.org/wiki/Shell_script)*,* eu conheci um projeto chamado [Serenata de amor](https://serenata.ai/),
 focado na promoção, detecção e combate à corrupção no governo federal 
do Brasil (na data de publicação desse artigo já estavam expandindo para
 municípios). A abordagem deles é bem interessante, e começou desde à 
criação de um portal com os dados indexados de forma padronizada até um 
robô virtual ([Rosie](https://twitter.com/rosiedaserenata)) que notifica via Twitter possíveis irregularidades realizadas por algum deputado federal, através de [*machine learning*](https://en.wikipedia.org/wiki/Machine_learning) (IA) aplicada a estes dados de reembolsos dos parlamentares (mais  especificamente a Cota Para o Exercício da Atividade Parlamentar -  CEAP).

> “Um projeto aberto que usa ciência de dados - as mesmas tecnologias 
> utilizadas por gigantes como Google, Facebook e Netflix - com a 
> finalidade de fiscalizar gastos públicos e compartilhar as informações 
> de forma acessível a qualquer pessoa.” [[Operação Serenata de Amor](https://serenata.ai/)]

No portal do serenata de amor existe um *front-end* com todas os dados que a Rosie vasculha a procura de irregularidades, chamado [Jarbas](https://jarbas.serenata.ai). Foi aí que uma ideia me veio em mente.

> E se eu usar *webscrapping* de todos os reembolsos de alimentação e analisar os valores gastos nas refeições dos deputados?

Bem, o que parecia um pequeno teste acabou virando uma bola de neve quando comecei a ver meus primeiros resultados…

> 131,50  
> 155,00  
> 80,40  
> 45,00  
> 77,00  
> 17,90  
> 53,30  
> ….

Encontrei alguns valores um pouco absurdos para uma refeição, pois seja 
almoço, jantar ou uma simples merenda, a legislação que trata da CEAP 
diz que o reembolso referente à alimentação somente será autorizado para
 despesas com o [**próprio**](http://www2.camara.leg.br/legin/int/atomes/2009/atodamesa-43-21-maio-2009-588364-normaatualizada-cd-mesa.html) parlamentar (nem assessor entra).  
A
 partir daí eu comecei a me perguntar se poderia existir algum deputado 
com reembolso de valores exorbitantes. Então, segui a estratégia inicial
 que os participantes do projeto serenata de amor usam para “programar” a
 Rosie: [**Elaboração, teste e implementação de hipóteses.**](https://medium.com/data-science-brigade/como-a-rosie-usa-machine-learning-na-serenata-de-amor-9168e0f1909d)

> **Minha hipótese:** Há valores absurdos no 
> conjunto de dados de reembolsos no tocante à subquota parlamentar 
> destinada à refeição dos parlamentares.

Então,
 eu transformei a hipótese em busca computacional na base de dados do 
Jarbas e encontrei todos os valores referentes à cota. Resgatei no total **201.600** reembolsos, no intervalo entre 2009 e 2017.

Nesse cenário, a Rosie iria muito mais a fundo, pois, a partir do aprendizado de máquina ela conseguiria identificar os gastos suspeitos através de diferenças 
substanciais geradas por esse ‘aprendizado’, e então iria apresentá-los 
(existe até um parâmetro ‘*suspicious’* no [JSON](https://pt.wikipedia.org/wiki/JSON) que você pode definir para receber somente os gastos suspeitos). Porém, meu pensamento era de analisar o todo, tentando ‘enxergar’ qual o  padrão de distribuição dos valores das refeições, considerando  reembolsos suspeitos ou não.

Fiz uma [estatística descritiva](https://pt.wikipedia.org/wiki/Estat%C3%ADstica_descritiva), [distribuição de frequência](https://pt.wikipedia.org/wiki/Distribui%C3%A7%C3%A3o_de_frequ%C3%AAncias) e [*Boxplot*](https://pt.wikipedia.org/wiki/Boxplot). Os resultados estão abaixo.

{% include image.html url="/assets/images/frequencia_all.png" description="Distribuição fortemente assimétrica. Elaboração própria. by LibreOffice Calc." %}<br>

Olhe como ficou a distribuição de frequência da série. Primeiro que o modal gira em torno de 201.189 refeições com valores médios de R$ 405,00 e o restante (411 refeições) se distribui em valores muito altos, chegando ao máximo de R$ 14.931,00!

Ao olhar para o histograma acima você pode pensar: Puts, o valor da maioria das refeições dos deputados gira em torno de R$ 405,00!!!
É verdade. E é por isso que somente **a média** nem sempre é um bom estimador/parâmetro no entendimento de como se comportam os dados.

> Sabe quanto deu a média geral na série como um todo?  
> **R$ 66,43**

Um desavisado (ou oportunista) poderia pegar o conjunto de dados dos 
valores de refeição, calcular a média, chegando nesse valor acima, e 
defender que R$ 66,43 é um bom valor para esse tipo de gasto, além de 
afirmar que os deputados usam esse recurso de forma consciente.

> **Viu como é fácil enganar com dados?**

A discrepância acima pode estar relacionado à valores muito altos (ou 
baixos) em toda a série de dados, fazendo com que a análise por 
média/mediana não seja tão adequada assim. Geralmente, quando se 
trabalha com estatística, retiram-se os valores discrepantes (*outliers*)
 antes de calcular esses parâmetros/estimativas, dependendo do objetivo e
 objeto da pesquisa. Porém, meu caso é que eu queria saber como eles 
estavam distribuídos em seu todo.

> “Em estatística, *outlier*, valor aberrante ou valor atípico, é uma 
> observação que apresenta um grande afastamento das demais da série (que 
> está “fora” dela), ou que é inconsistente.” [[2](https://pt.wikipedia.org/wiki/Outlier)]

E ***como faço para saber quais valores são* outliers*?***

Visualmente se pode tentar identificar quais são os *outliers* em uma distribuição de dados, logo, no caso acima, alguém poderia dizer
 que desde os que gastaram uma valor médio de R$ 1.212,00 (254 
deputados) até R$ 14.931,00 (1 deputado) em uma refeição são *outliers.* No entanto, essa informação pode estar correta ou não.  
Na estatística, existem inúmeras formas de identificação desses valores, e aqui eu utilizei a [amplitude interquartil](https://pt.wikipedia.org/wiki/Amplitude_interquartil) (IIQ). Sendo pragmático, apresento os dados que encontrei:

- Valor ‘normal’ para refeição: entre R$ 0,70 e R$ 156,43.
- Valor ‘bizarro’ para refeição: acima de R$ 156,43.

Através do gráfico *boxplot*,
 podemos ‘ver’ mais intuitivamente como se dá a dispersão desses 
valores. Os pontos em vermelho indicam todas as refeições ‘com valor 
aberrante’, ou seja, os *outliers.* Já a barra em azul representa todo o resto que está dentro da ‘normalidade’ da distribuição.

{% include image.html url="/assets/images/boxplot.png" description="Valor da refeição dos deputados. Elaboração própria. by R, plot.ly e draw.io" %}<br>

Descobri
 que 6,28% dos reembolsos para refeição são valores exorbitantes, sendo 
que boa parte desses se concentra entre R$ 2.000,00 e R$ 4.000,00 (para **um único** reembolso).

> Agora você já entendeu o porquê de **nem sempre a média** ser o melhor recurso para analisar padrões em distribuição de dados, o que, pelo senso comum ainda ocorre.
> 
> Existem casos até da própria assessoria parlamentar [não saber](https://medium.com/data-science-brigade/como-cidadãos-empoderados-podem-conversar-com-deputados-a24ad4020f1b) o que é uma **média.** Olhe abaixo a resposta que esta deu à equipe do serenata de amor, após ser questionada de um gasto suspeito do Deputado [Fábio Mitidieri](http://www.camara.leg.br/internet/deputado/Dep_Detalhe.asp?id=5830569). Parece brincadeira, mas não é.

{% include image.html url="/assets/images/mitidiere.png" description="Fonte: Resposta oficial do deputado, via Câmara Federal, Processo nº 100.548/2017, folha 8 (apud Cuducos)" %}<br>

Bem como também nem sempre somente *outliers* definem quem está provavelmente sendo corrupto ao realizar gastos nessa distribuição de dados. Através de técnicas de *machine learning*,
 programada na Rosie, muitos outros parâmetros são retirados e 
descobertos para melhorar sua inteligência artificial, dia após dia.  
Por exemplo, esse robô pode detectar que toda vez que um deputado é 
reembolsado em um restaurante de sua cidade natal (ex: Maceió) o gasto é
 muito maior do que o comumente capturado por ela, quando ele gasta em 
Brasília. Uma possível explicação para isso poderia ser que o deputado 
oferece banquetes em bons restaurantes em reuniões com aliados ou até 
mesmo com a família, ao chegar em sua cidade de origem.  
A Rosie, ao identificar a possível “anomalia”, vai prontamente definir aquele reembolso como ‘*suspicious=1*’
 na indexação do gasto. Logo em seguida ela notificará todos os 
seguidores via Twitter e estes, sendo cidadãos e compromissados com 
nosso dinheiro e o bem coletivo, abrirão processos na câmara federal 
sobre o gasto suspeito. É o passo a passo.

> “É a revolução de massa [P2P](https://pt.wikipedia.org/wiki/Peer-to-peer): Informações públicas descentralizadas na palma da mão!”

Eu ía disponibilizar como presente a informação do maior *outlier* da
 série estudada neste artigo, com valor nada mais nada menos que R$ 
15.000,00, mas, ao analisar o arquivo txt com os dados que recuperei vi 
que não puxei os parâmetros a respeito do nome do deputado nem código 
único do documento (*document_id*) pra poder auditar 
depois (como falei, inicialmente eu fiz a busca só querendo saber dos 
gastos). A única informação que tenho é que esse valor está na posição 
201.572 da busca, ou seja, o gasto é referente ao ano de 2009, pois foi 
perto do final do arquivo, além de eu ter feito a busca por ordem 
decrescente de ano.

Então, semana passada, eu fui atrás do [primeiro valor disponibilizado pelo Jarbas referente à subquota em questão](https://jarbas.serenata.ai/dashboard/chamber_of_deputies/reimbursement/?p=126&subquota_id=13&year=2009),
 do ano de 2009. Conferi a ordem dos últimos valores, abri o arquivo dos
 dados que eu já tinha e então percebi que estes valores da plataforma 
não batiam com os que eu tinha no arquivo de 2017. Por algum motivo o 
Jarbas não mostrou em 2018 o que ele mesmo tinha me retornado em 2017. 
Os dados que deixaram de aparecer estão entre a posição 201.501 e 
201.600 (99 valores). Então fui no [portal da transparência da câmara federal](http://www.camara.gov.br/cota-parlamentar/index.jsp) tentar achar esses gastos ‘na mão’. Clique vai, clique vem e ainda sim 
não achei nada! O mais pasmem disso tudo é que esses 99 valores 
concentram gastos **MUITO EXORBITANTES (incluindo o *master outlier*).** Abaixo listo alguns deles:

{% include image.html url="/assets/images/exorbitantes.png" description="Gastos que sumiram. Elaboração própria. By KWrite." %}<br>

Algumas explicações para isso:  

- Portal da câmara pode ter excluído esses 99 valores e o Jarbas ter reindexado a base de dados sem eles.  

- Jarbas pode não ter indexando corretamente os valores capturados do 
  portal da câmara. Essa é muito improvável, já que auditei diversos 
  pontos da lista de reembolsos (especificamente na ordem) que capturei 
  alguns dias atrás e ‘bateu’ com os meus dados antigos.

- Portal da câmara pode ter alocado estes reembolsos em outra subquota, que não a referente à alimentação do parlamentar.

Após a pausa para o mistério, vou disponibilizar dois gastos que eu acho que
 representam bem o que ocorre e como nossa política atual é ‘planejada’.  
Fica de reflexão para você.

> [*Liderança do PT: R$ 3.887,00*](https://jarbas.serenata.ai/layers/#/documentId/5736053)
> 
> [*Liderança do PSDB: R$ 3.687,50*](https://jarbas.serenata.ai/layers/#/documentId/5974689)

Enfim, neste artigo tentei falar de duas coisas: Como funciona um pouco o processo de *machine learning* e como realizar um pequeno estudo para aumentar o entendimento sobre 
uma distribuição de dados, usando, neste caso, os dados públicos dos 
reembolsos com refeição de parlamentares.

Como dever de casa, eu passo pra você calcular **quanto de dinheiro sobraria** se somente as refeições com valores discrepantes (os pontos vermelhos) 
tivessem uma média de R$ 50,00 cada uma. É uma conta simples, mas 
profunda quando você ‘bate o olho’ no resultado.

No mais, segue o link dos arquivos que utilizei neste trabalho, o que inclui os *scripts* e o conjunto de dados.  
[Análise de dados](https://github.com/marlluslustosa/myblog/blob/master/Analise_dados.tar.gz)

Abraços e vamos apoiar o serenata!  
[Operação Serenata de Amor](https://serenata.ai/)
