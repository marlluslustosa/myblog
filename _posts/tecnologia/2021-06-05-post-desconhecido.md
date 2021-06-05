---
title: Como um desconhecido pode escrever no meu blog - sem lhe entregar nenhuma senha
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/postagem_desconhecida.jpg
image-ref: Photo by <a href="https://unsplash.com/@cameramandan83">Dan Dennis</a>
tags:
- desconhecido
- escrita
- blog
- github
id-ref: desconhecido-postagem
---

Este artigo tem por objetivo iniciar qualquer pessoa no mundo do [git](https://pt.wikipedia.org/wiki/Git), que é uma forma bem eficiente de promover colaboração na criação de artefatos digitais. Apesar de a maioria dos artigos que falam sobre o assunto serem voltados para o público técnico (área da TI em geral), essa ferramenta pode ser utilizada por qualquer um que deseja colaborar com um objeto digital que foi produzido por alguém, como escritores e designers. Então, o tema abordado aqui é sobre como qualquer pessoa pode contribuir com publicações no meu blog, sem que eu precise criar um e-mail e senha em algum serviço de blogs, ou pedir que ela me envie o conteúdo por e-mail, ou até mesmo repassar instruções sobre como criar um site do zero. Por isso, esse artigo não possui uma linguagem técnica, mas sim voltada a um público que só quer versionar de forma simples uma postagem na web.

#### Git - história

Sabe aqueles artigos em `.docx` ou `.odt` escritos por você e depois editados, gerando, após um tempo, uma lista de arquivos em uma pasta com nomes que identificam a versão, como `artigo1.odt`, `artigo1_ver1_1.odt` e até mesmo `artigo1_ver2_agoraFunciona_versaoFinal1.0.odt`? Se identificou?

É claro que esse processo tem uma alta probabilidade de tornar a contrução do artigo final bem confusa, penosa e até impraticável. Como exemplo, pense em uma mescla de inclusões em uma versão bem antiga com a mais nova, sem ter que procurar manualmente as diferenças entre as versões e sem substituir um elemento antigo no lugar de um novo que já está terminado, portanto, sem quebrar o conteúdo. É uma tarefa em que a dificuldade vai aumentando exponecialmente, a medida em que você  vai editando e versionando seus arquivos.

Imagine esse problema, só que agora com arquivos de código fonte de programas. Um dia,[ em 2005](https://pt.wikipedia.org/wiki/Git), certo rapaz se indignou com os problemas de certas ferramentas e resolveu criar a sua própria. Então surgiu o git. Esse mesmo rapaz, nada menos que [Linus Torvalds](https://pt.wikipedia.org/wiki/Linus_Torvalds), anos antes, já tinha ganho fama por ter criado uma tal kernel Linux. Então, a partir daí, é até hoje a ferramenta de controle de versão mais utilizada no mundo.

#### Contribuindo com um artigo no meu site

Como falei, este post não tem qualquer menção à parte técnica sobre funcionamento do git (se você buscar na internet `o que é git`, vai achar bastante conteúdo). A única coisa que deve saber para contribuir com o meu blog é que: **1 - você vai criar uma versão de algo que é meu (um clone)**, então, **2 - editar o que acabou de clonar** e **3 -  enviar para mim uma proposta de alteração**. Simples assim. E vamos ao passo a passo.

##### Passo 1 - Criar um conta no github e bifurcar meu repositório

O repositório contendo os arquivos do meu blog foi criado no serviço GitHub que, conforme o próprio nome, é um gerenciador web do serviço git. Note que ele não é o git em si, mas uma casca web que o utiliza por baixo para fazer versionamento de coisas lá hospedadas.

Manter um repositório lá dentro tem custo muito baixo de infraestrutura tecnológica, por isso quase todos os [gerenciadores web de git](https://itsfoss.com/github-alternatives/) são gratuitos para repositórios ilimitados. Na verdade, a grande vantagem não é o repositório em si (um local para armazenar dados) mas a possibilidade de usar os benefícios do git, como controle de versão e colaboração entre os usuários da plataforma.

Você pode acessar a lista de arquivos do repositório referente ao meu blog [aqui](https://github.com/marlluslustosa/myblog). Para poder editar qualquer arquivo e mandar sugestões para mim, precisa criar uma conta no [GitHub](https://github.com/). Após o cadastro, bifurque (fork) o repositório do meu site. Em resumo, ele clonará o meu repositório para sua conta, o que o torna ainda ligado à origem, em outras palavras, o seu será o filho, e o meu, o pai. Isso é importante para seguir o fluxo do git, em que alterações nos repositório "filhos" podem ser enviadas ao repositório principal (pai). Interiorize isso, pois essa é a base da colaboração nessa arquitetura.

Então, conforme explicado, bifurque o repositório, indo em sua página e clicando em fork, conforme figura abaixo.

{% include image.html url="/assets/images/forkbutton.png" description="" %} <br>

Ao clicar no botão, aguarde um pouco, enquanto o processo é terminado. Depois de bifurcado, ele carregará o seu repositório, que é, como falado acima, exatamente o clone do meu. Perceba na página que agora o caminho mudou, e nele consta o seu usuário, seguido do nome do repositório (myblog), tendo como pai o meu repositório. Para ilustrar isso, segue abaixo uma imagem de um fork que realizei a partir da minha robô Araphen.

{% include image.html url="/assets/images/araphenfork.png" description="" %}<br>

Percebeu o `forked from marlluslustosa/myblog` ? Se tiver visto isso é porque deu certo e você já pode tentar incluir alterações. Isso é uma opção bem viável quando eu não conheço quem está por trás de uma solicitação para alterar um arquivo de um repositório, então, a bifurcação é justamente para garantir que um desconhecido só poderá **pedir** para alterar, mas não terá permissões suficientes para alterar diretamente o repositório.

##### Passo 2 - Criar uma postagem e incluir como autor (opcional)

Todos os artigos do meu site estão na pasta `_posts`. Lá você poderá ver os artigos separados por categorias (que são as pastas), como `poesia`, `tecnologia` e `arte`. Então, navegue no seu repositório, recém criado, vá à pasta que deseja escrever e crie um novo arquivo lá, clicando, na parte parte superior direita em `Add file` e então `Create new file`, confome figura abaixo. Você pode fazer upload de um arquivo também, se quiser.

{% include image.html url="/assets/images/araphen_createnew.png" description="" %}<br>

No nome do arquivo, coloque a data atual de inclusão, seguido do nome do post e terminando com `.md`, que se refere ao tipo de arquivo ([markdown](https://pt.wikipedia.org/wiki/Markdown)), um formato que o meu gerenciador de criação de sites ([Jekyll](https://jekyllrb.com/)) utiliza. Coloque o formato do nome nesse padrão `AAAA-MM-DD-nome-do-arquivo.md`, conforme mostrado na imagem abaixo.

{% include image.html url="/assets/images/araphen_name.png" description="" %}<br>

Para o conteúdo dele, cole esse artigo de exemplo, ou então, se quiser customizar o texto, pode ver [aqui](https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open) os tipos de marcações disponíveis no formato markdown.

```markdown
---
title: Um post de exemplo
author: marllus
categories:
- poesia
layout: post
image: assets/images/fila.jpg
tags:
- poesia
- sociedade
- reflexao
- pensamento
---

Um exemplo de quebra de linha<br>
Você pode escrever alguma história incrível aqui!
```

Essa parte inicial (entre o primeiro e o segundo `---` ), que é chamada *frontmatter*, **sempre tem que existir**, e é ela que vai receber informações para gerar a página html final do seu artigo, pegando as informações como título (`title`), tags, imagem de capa (`image`), etc. Caso não queira cadastrar autor, coloque `anonimo` no lugar de `marllus`. Se quiser se incluir como autor, com toda a sua descrição e um avatar no cabeçalho do artigo, edite o arquivo `_config.yml`, na pasta principal do repositório, e adicione suas informações. Basta copiar e colocar as linhas referentes ao autor, conforme imagem abaixo, onde incluí a minha robô Araphen.

 {% include image.html url="/assets/images/araphen_autora.png" description="" %}<br>

Respeite todos os espaços padronizados, pois são importantes para geração final do arquivo. Com a imagem de capa do artigo é a mesma coisa. Nesse exemplo eu coloquei uma que já existia no repositório, mas você pode chamar alguma da web ou até fazer upload de uma imagem no diretório `assets/images` e referenciá-la pelo nome (como o exemplo mostra), que também funcionará.

Depois de ter inserido o texto no arquivo, clique em `Commit new file`, no rodapé da página de criação dele, conforme imagem abaixo.

{% include image.html url="/assets/images/araphen_commit.png" description="" %}<br>

##### Passo 3 - Abrir uma solicitação para alteração do site

Feito isso, terá que abrir um Pull Request (PR), que basicamente é uma forma de enviar as alterações do seu repositório ao repositório pai (o principal). Ao clicar em `Pull Request`, na tela inicial do seu repositório, vai aparecer uma imagem bem explicativa, com uma setinha indo do seu repositório para o meu, conforme imagem abaixo.

{% include image.html url="/assets/images/araphen_pr3.png" description="" %}<br>

Na imagem abaixo, ainda no Pull request, quer dizer você está pronto para enviar alterações do seu repositório (filho) para o repositório principal (pai), ou seja, as alterações estão elegíveis (*Able to merge*) para serem mescladas. Perceba, na parte inferior, que o GitHub reconhece até quais arquivos incluídos e quais alterações você fez em cada um, em nível de linhas adicionadas/removidas.

 {% include image.html url="/assets/images/araphen_pr.png" description="" %}<br>

E então, ao clicar em `Create pull request`:

{% include image.html url="/assets/images/araphen_pr2.png" description="" %}<br>

Crie um título e/ou faça uma comentário sobre sua criação (opcional) e clique novamente em `Create pull request`. 

Após isso, a PR será aberta e eu serei notificado. Para facilitar a minha análise, eu programei ações para serem realizadas, como um teste de construção do site com sua postagem anexada e um teste de segurança. Esses pré testes são chamados de [pipelines CI](https://www.redhat.com/pt-br/topics/devops/what-cicd-pipeline) (Integração Contínua). Se passar nos dois testes, sua postagem vai conter um notificação na cor verde, com a descrição `All checks have passed`:

{% include image.html url="/assets/images/araphen_pr4.png" description="" %}<br>

Esse botão `Merge pull request` só vai aparecer para o proprietário do repositório ou para usuários adicionados como membros. Neste caso, minha robô Araphen é uma contribuidora do repositório, então, se ela quisesse acionar o botão *merge request*, todo o conteúdo iria ser mesclado ao repositório principal e o post em poucos minutos entraria no ar.

Quando você realizar esse procedimento, eu, como proprietário, irei verificar seu conteúdo e aprovar suas alterações. Lembrando que existe a possibilidade de eu comentar na PR, solicitando que você revise algo que esqueceu ou um outro problema sintático ou semântico no texto. 

Com isso, antes de publicar, deu pra perceber que podemos debater por meio de comentários sobre a postagem, a fim de analisarmos juntos, até que eu aprove para publicação. É assim que é feito na colaboração de código fonte de software, onde, por exemplo, alguém identifica uma falha nesse código e ele mesmo tem a capacidade de abrir uma solicitação de alteração (Pull request), para sanar um problema e melhorar um artefato, mesmo sendo um ator de fora da equipe de desenvolvimento principal desse software. Essa é a magia da colaboração do software livre - e no meu caso, do <mark>texto livre</mark> :)

Quer escrever sobre algum assunto no meu blog? Agora você já sabe e te convido a isso! É desenvolvedor ou Designer e acha que pode melhorar minha página ou consertar bugs? Te convido à mesma coisa, que com certeza analisarei com carinho.

Grande abraço!
