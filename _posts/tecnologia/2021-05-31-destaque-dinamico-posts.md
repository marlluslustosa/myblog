---
title: Destaque dinâmico de posts em um site estático - com notificações por e-mail e telegram
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/teia.jpg
image-ref: Photo by <a href="https://unsplash.com/@joshcala">Josh Calabrese</a>
tags:
- goatcounter
- jekyll
- javascript
- github actions
- popularidade
- destaque posts
id-ref: destaque-dinamico
---

Por [definição](https://en.wikipedia.org/wiki/Static_web_page), um site estático, ou uma página que foi gerada por geradores de sites estáticos - SSG, é aquela cujo conteúdo não pode ser alterado facilmente no lado do servidor, ou seja, não é dinâmico o suficiente para suportar alterações *server side*. Mas será que é isso mesmo? Bem, é o que veremos. :)

#### A inquietação

Há uma grande vantagem e outra desvantagem no mesmo nível entre o mundo dos sites estáticos. A primeira é que o conteúdo final gerado torna-se bem rápido de ser carregado (consegui o recorde de [0.8 segundos](https://www.webpagetest.org/result/210531_AiDcA2_db665fc676bb41970c884837e3492bd8/) no tempo de carregamento do meu site), porém, o lado ruim disso é a dificuldade em se trabalhar bem com conteúdo dinâmico, que precisa ser alterado no lado do servidor, ou seja, uma alteração que seja efetiva para todos os usuários que o acessam. Com base nisso, muitas pessoas preferem adotar ferramentas, como o Wordpress, que tornam esse processo de implantação menos dramático e sofrido. Mas, meu objetivo não era jogar as cartas na mesa.

Pensando nisso, veio uma inquietação. No meu blog, feito com [Jekyll](https://jekyllrb.com/), tem uma opção de colocar uma quantidade de estrelas nos artigos (que vai de 1 a 5), além de na página inicial ter uma seção de destaques, ou os artigos mais lidos. Por exemplo, sempre que escrevo um post, na página `.md`, existem dois parâmetros a serem definidos, chamados `featured` e `rating`, que servem pra especificar que o artigo é um destaque e quantas estrelas ele possuirá, respectivamente. Eu posso definir como eu quiser. Claro, em um site estático, essa informação se torna fictícia, pois por padrão fica a meu cargo  especificar, ou seja, não é automático, com base em avaliação dos usuários ou na quantidade que aquele artigo foi realmente visto pelo público. Um processo puramente manual.

Então, pensei se não tinha uma opção de tornar isso mais dinâmico. Resumindo, queria utilizar a informação sobre a contagem de acesso aos posts, que utilizo via [GoatCounter](https://www.goatcounter.com/) (ótimo serviço, por sinal), e em um intervalo de tempo um script seria executado, em algum servidor, pela web louca por aí, pra analisar os mais lidos, com o fim de ele mesmo fazer isso, ou seja, alterar os artigos em destaque automaticamente e me notificar sobre tal mudança. Ufa.. meio trabalhoso, pensei. Mas enquanto eu procurava mentalmente um lugar onde esse script poderia ser executado, sem ter que alugar uma VM completa, me veio uma luz... Opa... E se eu usasse o próprio [Github Actions](https://docs.github.com/pt/actions/learn-github-actions) para isso? Hum... As coisas estavam começando a desenrolar, pois poderia fazer todo o procedimento onde já hospedo o meu blog: no github. 

Para quem não sabe, o github disponibiliza uma espécie de ferramenta executora de scripts no próprio repositório dos usuários, simulando um [sistema operacional](https://github.com/actions/virtual-environments). A ideia é realizar testes de integração, entrega e implantação de forma automatizada, a partir de quaisquer eventos que acontecem no próprio repositório (daí vem os [pipelines CI/CD](https://www.redhat.com/pt-br/topics/devops/what-is-ci-cd) - uma das bases para o fluxo de trabalho DevOps). E olha só, um desses eventos pode ser disparado de forma [agendada](https://docs.github.com/pt/actions/reference/events-that-trigger-workflows#) (em formato `cron`). Resumindo, é uma infra "barata" pelo fato de esse ambiente ser compartilhado e não dedicado 24h para tal ação. Confira os [limites de uso](https://docs.github.com/pt/actions/reference/usage-limits-billing-and-administration). Uma outra opção é o [Gitlab CI](https://docs.gitlab.com/ee/ci/), que também faz a mesma coisa e tem limites generosos na opção gratuita.

Então, sem saber se iria realmente dar certo, montei o seguinte cronograma de desenvolvimento:

- Capturar e tratar informações sobre o número de visitas ao site;

- Criar um script para gerar um arquivo com os artigos mais vistos;

- Criar um script para retirar os artigos antigos da tela de destaques e adicionar os novos mais vistos (4 últimos);

- Criar uma forma de atualizar os arquivos da página no github com as novas informações, sem precisar ter que atualizar manualmente;

- Por fim, ser notificado das mudanças;

Parece meio cheio, né? Mas, felizmente, a saga, que durou pouco mais de dois restos de dias, resolveu todas as questões para execução do fluxo. Apesar de a solução ter ficado bastante personalizada para a minha necessidade, esse artigo, com um leve tom fantástico, tem por objetivo mostrar que é possível fazer esse tipo de alteração no lado do servidor, mesmo em sites estáticos, dotando-o, portanto, de mais autonomia para se modificar dinamicamente.

#### Tratando as informações sobre os acessos - GoatCounter

No [site](https://www.goatcounter.com/code/api) do GoatCounter existe uma boa documentação sobre como usar a sua API para processar os dados sobre visitas ao site. Adaptei um script que já estava lá para puxar esses dados e assim ficou:

<script src="https://gist.github.com/marlluslustosa/d2df55799c05cb838fbd3a79bc4a2401.js"></script>

Basicamente o script bash acima acessa a API do goatcounter e imprime na tela o arquivo referente a todos os acessos ao blog. Agora, com os dados brutos, iniciei o processo de tratamento, afim de tonar a visualização fácil, em outras palavras, ter um arquivo com os 4 artigos mais vistos e a quantidade de visitas de cada um.

<script src="https://gist.github.com/marlluslustosa/84d615ad0e702f1085a5262b69016431.js"></script>

Agora perceba que esse script trabalha com o arquivo `export.txt`, que é o conteúdo da saída do script anterior `export_goat.sh`, ou seja, os dados brutos de acesso. Aqui eu usei o `sed`, meu editor preferido para tramento de grandes volumes de dados. Através do uso de expressões regulares para limpá-lo, o script gerou dois arquivos: `ranking_posts` e `ranking_posts_name`. O primeiro, que contém, linha por linha, os nomes dos últimos 4 artigos, foi usado no loop (linha 16) para percorrê-los e adicionar os parâmetros `featured=true` (artigo em destaque) e estrelas (`rating`), em ordem decrescente. Como o GoatCounter funciona basicamente como uma catraca (contando acessos e nada mais), utilizei a lógica de 5 estrelas para o primeiro artigo mais lido, 4 para o segundo, 3 para o terceiro e 2 para o quarto. Isso tem por objetivo saber, logo na visualização da primeira página, qual a ordem dos destaques mais vistos, com base nas estrelas. Perceba que antes dessa alteração, na linha 9,  ele percorre todos os artigos do site (`*.md`) e remove qualquer menção anterior ao `featured` ou `rating`, afim de não gerar artigos com essas informações duplicadas. Poderia ter colocado tudo no mesmo loop? Sim, poderia. Esse é o lado bom de programar: múltiplas formas.

E quanto ao arquivo `ranking_posts_name`? Ele contém o texto já tratado que servirá no disparo das notificações. Então, pensando nisso, pensei em brincar com mensageria, além do e-mail ([sendgrid](https://sendgrid.com/)), que já usei [aqui](https://marllus.com/tecnologia/2020/10/14/pipeline-watchtower.html). Na versão [gratuita](https://sendgrid.com/pricing/) do sendgrid, você tem um limite de envio de 100 emails por dia, o que dará para esse trabalho. Para quem não tem experiência em criação de bots no telegram, pode conferir a documentação [aqui](https://core.telegram.org/bots).

#### O fluxo completo - goatcounter, commit/push, sendgrid e telegram

Depois de ter explicado as partes menores, agora vou detalhar o resultado do todo, que une essas partes e as integra em uma lógica de execução. É aí que entra o papel do Github Actions, que vai executar as partes. Aqui está meu workflow:

<script src="https://gist.github.com/marlluslustosa/0f77d3d9927604141d1c299efdf25b87.js"></script>

Linha 4 e linha 7 representam o momento em que este workflow será executado, ou seja, em todo `push` para `branch master` (em outras palavras, todas as vezes que você fizer alterações no site) e todos os dias às 7h da manhã. Detalhes de sintaxe à parte, aqui você precisa saber que `steps` indica as etapas do processo de trabalho definido (`job build`). Então, na lógica sequencial, o primeiro `step` (`Create local changes`) vai executar o script `export_goat.sh`. As variáveis `secrets.TOKEN_GOAT` e `secrets.API_URL_GOAT`, como o próprio nome já diz, são variáveis do tipo secretas, necessárias para autenticar na conta GoatCounter configurada no blog, para obter os dados de acesso. Eu as defini assim como secrets para não ficarem expostas, já que tanto o script como o workflow completo é aberto ao público. Uma das vantagens [desse recurso](https://docs.github.com/pt/actions/reference/encrypted-secrets) do github é você poder criptografar qualquer string ou valor que deseja esconder, incluindo senhas e tokens de acesso. Durante a execução do fluxo, somente o ambiente executor virtual privado é que terá acesso ao conteúdo dessas variáveis, portanto, longe de olhos atentos.

A lógica que eu desenvolvi para o processo global foi: 

- 1 - Execute o script para para obter os dados de acesso e escreva no arquivo `export.txt`; 

- 2 - Antes de gerar um novo arquivo `ranking_posts`, faça uma cópia dele, nomeando-do `ranking_posts_old`, e após isso compare os dois. Caso sejam iguais, então não houve alteração na ordem dos mais vistos, portanto mantenha o log de ranking atual, caso contrário, registre isso em uma variável (`NEWFILERANKING=true`) para ser lida nos passos de notificação;

- 3 - Altere o repositório (commit/push) de acordo com as mudanças - caso algum arquivo seja alterado -, em outras palavras, somente se no passo anterior ele encontrar alterações no ranking dos mais vistos;

- 4 - Caso o arquivo referente ao ranking tenha sido alterado (ou seja, se variável `NEWFILERANKING` registrar isso no passo 2), então envie um e-mail e notifique via telegram sobre as mudanças;

Basicamente são esses passos, que traduzindo sua lógica para um fluxograma simples, é algo como isso:

<!--- 
retire as barras antes do hífen para funcionar. coloquei somente porque o jekyll estava reconhecendo como fechamento do comentário.
criar o fluxo: https://mermaid-js.github.io/mermaid-live-editor
downloag svg file: https://jakearchibald.github.io/svgomg/ 
graph TD
    A[Inicia execução] \-\->|job build| B(Create local changes)
    B \-\-> M{commit/push}
    M \-\-> |sim| M
    M \-\-> |não| J
    M \-\-> |sim| C{ranking_posts alterado}
    C \-\-> |sim| E[Telegram]
    E \-\-> H[Notify telegram bot]
    C \-\-> |sim| F[Email]
    C \-\-> |não| J[finaliza]
    F \-\-> G[SendGrid Actions]
--->

 {% include image.html url="/assets/images/chart1_ghactions.svg" description="" %} 

<br>

As variáveis secrets necessárias para os dois últimos `steps` de notificação (`SendGrid Action` e `Notify telegram bot`) são basicamente, no primeiro, `SENDGRID_API_KEY`(token para consumir a API da sua conta sendgrid) e no segundo, `TELEGRAM_TO` e `TELEGRAM_TOKEN` que é o ID do chat do seu usuário com o bot e o token desse bot. Depois de tudo configurado - scripts `export_goat.sh` e `edit_ranking.sh` na pasta principal e arquivo workflow `ranking_featured.yml` dentro da pasta `.github/workflows` -, o resultado de uma execução padrão, com alteração no ranking, é visto assim, nos logs da aba Actions do repositório:

{% include image.html url="/assets/images/workflow1.png" description="" %}

<br>

E o disparo final no meu telegram:

{% include image.html url="/assets/images/telegram-notify.jpeg" description="" %}

<br>

E então, ao conferir a página inicial:

{% include image.html url="/assets/images/marllus-featured.png" description="Artigos em destaque e estrelinhas nos seus lugares" %}<br>

Desafio aceito e saga concluída. Agora os destaques serão automaticamente reorganizados no meu blog e ainda serei notificado sobre isso por e-mail e telegram! Tudo isso de graça, usando *Github Actions*, *Jekyll* e o contador "catraca" *Goatcounter*. As possibilidades são inúmeras, pois como viu, da pra pensar em fluxos bem poderosos, como exemplo os [fluxos hierárquicos](https://docs.github.com/pt/actions/reference/events-that-trigger-workflows#), onde a execução de um depende de outros terminarem, com sucesso ou falha. 

Enfim, me despeço com um velho ditado que sempre sigo: <mark>o mais importante é focar na resolução mental do problema, pois o resto é só ferramenta!</mark> Um abraço e espero que tenha iluminado um pouco seu caminho!<br>Pensou em um fluxo e não sabe se é possível? Comenta aí!<br>:)
