---
layout: post
image: assets/images/dialogo-ia-antropologia.jpg
image-ref: Photo by <a href="https://unsplash.com/@markusspiske">Markus Spiske</a>
title: Criando um blog gratuito com github + obsidian
author: marllus
date: 2024-03-10 23:00:00
categories:
  - tecnologia
id-ref: git-blog-obsidian
tags:
  - tecnologia
  - obsidian
  - git
  - blog
---

Este é um tutorial sobre como criar um blog usando github e obsidian, de uma forma relativamente fácil de manter e gratuita. O conteúdo do blog será servido de arquivos estáticos (javascript, css, html), como preconiza a arquitetura minimalista e eficiente jamstack.
Ao final, para postar no blog, você só precisará abrir o obsidian, escrever e publicar, sem sair do editor. 
Acompanhe.
- - -

Para quem não sabe, o github é um serviço de versionamento de códigos, muita utilizado por desenvolvedores no âmbito de compartilhamento de código online. Mas ele pode ser usado tanto para manter códigos como qualquer outro texto. Como é uma ferramenta que te dá gratuitamente um local para armazenar seus arquivos, além de ter a sólida base de comunidade por muitos profissionais que a utilizam, escolhi utilizá-la como base para manter nossos arquivos do Obsidian. Então, antes de mais nada, o serviço github também servirá de backup para suas notas de blog.

Primeiro, faça seu cadastro na plataforma (https://github.com), se ainda não tiver.

Depois, vem a parte de escolher um template para seu blog. Abaixo eu listo uma recomendação:
https://github.com/henrythemes/jekyll-minimal-theme
https://github.com/marlluslustosa/kiko-now
https://github.com/DavideBri/Gesko
https://github.com/ronv/sidey

Se você preferir, pode também acessar https://jamstackthemes.dev/ e mergulhar por centenas de templates de sites estáticos construídos nos mesmos moldes para funcionar com este tutorial. Tudo que você precisa ter é o repositório github do template, como algum dos quais listei acima.

Bem, para nosso tutorial, vou escolher o template https://github.com/DavideBri/Gesko. Então, clique nele e vamos forkeá-lo!
Fork significa uma ramificação ou filho, ou uma cópia do repositório disponibilizado por alguma pessoa no github (ou repositório pai). Neste caso, faremos uma cópia do template para nosso blog.
Para realizar o fork, basta acessar https://github.com/DavideBri/Gesko/fork ou entrar dentro do repositório em questão e clicar no botão fork:

{% include image.html url="/assets/images/fork-git.jpg" description="Fork de um repositório'" %}<br>

Após criar o fork, um repositório aparecerá na sua lista de repositórios com o mesmo nome do pai, assim: https://github.com/marlluslustosa/Gesko. Neste caso, como eu forkeei o repositório Gesko do usuário DavideBri, o mesmo entrou para minha lista pessoal marlluslustosa/Gesko. Agora tudo que eu alterar no meu repositório não irá para o repositório dele, a não ser que eu faça isso explicitamente (o que não é o objetivo desse tutorial). Sacou mais ou menos como funciona? Pois bem, essa é um pouco da magia do compartilhamento de códigos em muitas comunidades virtuais hoje. Baixo o que o outro fez, melhoro, compartilho, etc.

Antes de colocar o site no ar, precisamos alterar algumas configurações do antigo dono, como metadados e url do site, senão vamos ter problemas de redirecionamentos de links e cairemos em páginas do repositório pai.
Para isso, vamos editar o arquivo _config.yml. 

{% include image.html url="/assets/images/gitconfig.jpg" description="Editando arquivo _config.yml'" %}<br>

Quando entrar, clique no símbolo de edição do arquivo e vamos alterar algumas linhas.

{% include image.html url="/assets/images/gitconfig2.jpg" description="Editando arquivo _config.yml'" %}<br>

Neste arquivo, você encontrará vários parâmetros relativos ao dono do site, como nome, descrição, autor, url, etc. Mas, o único parâmetro necessário (pelo menos agora) para permitir que o redirecionamento de links funcione de forma correta e não corra o risco de atingir um link do repositório pai do template é o:

	URL settings
	url: "https://DavideBri.github.io" # Domain Name of host [username].github.io for github pages 

Portanto, no lugar de DavideBri, coloque o seu nome de usuário. Após isso, caso não queira alterar mais nada relativo à identidade do site, clique em "*commit changes*", no botão verde no canto superior direito. Ao abrir a seguinte tela, clique em "*commit changes*". E então, as alterações já estarão disponíveis em seu repositório.

Agora vamos fazer o deploy do blog, através do próprio recurso do github, chamado Github Pages. Ainda na tela do repositório, clique então em *Settings > Pages*.

{% include image.html url="/assets/images/githubpages.jpg" description="Criando uma página web do repositório'" %}<br>

Na tela seguinte vão aparecer alguns opções, em *"build and deployment"*, você selecionará "*deploy from a branch*" e em Branch marque "*Master*". Ao terminar de setar esses dois parâmetros, você verá uma mensagem que sua página estará sendo construído para deploy.

{% include image.html url="/assets/images/githubpages2.jpg" description="Criando uma página web do repositório'" %}<br>

Em pouco tempo o site estará no ar. Então, atualize essa mesma página (Settings>Pages) para ver se algum texto aparece no topo. E então, em poucos minutos (ou menos), aparecerá a seguinte página, com informações do seu nome de domínio e blog provisionado na web.

{% include image.html url="/assets/images/githubpages3.jpg" description="Página no ar!'" %}<br>

Agora o site está no ar https://marlluslustosa.github.io/Gesko/

Agora seja curioso para saber como funcionam as páginas, os locais para alterar os estilos de página, html, css e coisas e tal...
Mas, de antemão, para criar qualquer post novo você precisará incluir dentro da pasta "_posts" do repositório um arquivo com o padrão "AAAA-MM-DD-titulo-do-post.md". Após fazer o deploy (commit changes) o post então entrará no ar. Fácil né? Você já poderia parar o tutorial aqui mesmo, pois já tem um blog no ar, podendo alterar seus arquivos e incluir novos artigos via github.

Mas, o objetivo é fazer isso diretamente do obsidian. Ou seja, ele conectará no repositório e entregará para o github diretamente, sem precisar ir no github commitar alterações.

Para isso, o obsidian conta com um plugin da comunidade chamado Git, que é quem faz a comunicação entre sua máquina local e o seu repositório remoto (do github). Então, após criar uma pasta cofre em branco no obsidian, vá em settings > community plugins e procure por Git. Instale e ative-o.

{% include image.html url="/assets/images/git-obsidian.jpg" description="Plugin para obsidian usar o github'" %}<br>

Agora, não menos importante, precisamos garantir que seu computador vai conectar com suas credenciais a sua conta no github. Para isso, vamos criar uma chave ssh local e adicioná-la a sua conta github. O objetivo é fazer com que o plugin Git do obsidian consiga enviar seus arquivos para o repositório remoto, pois o mesmo não tem suporte a pedir usuário e senha para fazer upload dos arquivos. Então, o obsidian lerá a chave ssh local que já estará incluída na sua conta github, que por sua vez autenticará a conexão.   

O bom é que vc só precisará fazer isso uma só vez, por computador. São 2 passos.
Passo 1 - [Gere as chaves ](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux#generating-a-new-ssh-key): dependendo do sistema operacional que utilizar, é mais ou menos parecido, e conta com basicamente dois comandos no terminal. Substitua pelo seu e-mail. Usando o GNU/Linux como referência:

```shell
ssh-keygen -t ed25519 -C "seu-email@email.com"
```

E então, ao prosseguir, ele vai perguntar onde quer guardar a chave, então deixe padrão (GNU/Linux: /home/user/.ssh/id_ed25519 e no Windows: c:/Users/user/.ssh/id_ed25519) e clique enter sem digitar nada.
```shell
> Enter a file in which to save the key (/home/user/.ssh/id_ed25519):[Press enter]
```

Após isso, pedirá uma senha para a chave, e mais uma vez deixe em branco e clique enter. Se você colocar uma senha, certifique-se de que todas as vezes que iniciar a chave (em geral quando reiniciar o sistema), terá que digitar sua senha senha no terminal. Para usuários avançados, isso não é problema, mas para fins desse tutorial, melhor deixar em branco e garantir mais velocidade em detrimento de menos reforço na segurança (além disso, deixar em branco uma senha de chave ssh é menos inseguro do que digitar usuário/senha - ou criptografia simétrica, em outros termos).

Pronto, após a chave criada você vai garantir que ela seja lida pelo agente ssh do sistema, pois é ele quem gerenciará essa chave. Então, inicialize o agente ssh (exemplo GNU/Linux):

```shell
$ eval "$(ssh-agent -s)"
```

E adicione a chave recém criada:

```shell
ssh-add ~/.ssh/id_ed25519
```

Para fazer esses dois comandos usando o Windows, é ligeiramente diferente, mas segue a mesma forma. Para conferir, basta [clicar aqui](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=windows#adding-your-ssh-key-to-the-ssh-agent)

Resumindo: O que acabamos de criar foi um par de chaves (uma pública e outra privada). A chave pública vai ser inserida dentro da sua conta do github e servirá para autenticar uma conexão vinda da sua máquina local, a partir da sua chave privada.

Prontinho, vamos prosseguir pro último passo. 

Dê o seguinte comando para listar o conteúdo da sua chave pública e que será inserida na sua conta github. Certifique-se que o final da chave tenha **.pub**, que é a referência da sua chave pública. A chave privada é só "id_ed25519", sem terminação.

```shell
$ cat ~/.ssh/id_ed25519.pub
```

Após isso, copie o conteúdo que aparecerá na tela e vamos para o segundo passo.

Passo 2 - [Inserir sua chave pública no github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux)

Clique no link https://github.com/settings/ssh/new para adicionar uma chave pública de autenticação.

{% include image.html url="/assets/images/git-ssh.jpg" description="Inserindo a chave pública no github.'" %}<br>

E terminamos os passos para autenticação local->remoto. Seu obsidian agora já estará comunicando com o github. Agora, vamos puxar nosso repositório remoto para nossa máquina local.

Vá na paleta de comandos do Obsidian e digite "git clone". E então vai aparecer um comando que já é referente ao plugin. Esse comando copia todos os arquivos do seu repositório remoto para sua máquina local, para você poder alterar localmente e depois enviar para o repositório remoto; e então quando as alterações alcançarem o repositório remoto, o site atualizará as informações, já que o github já faz isso automaticamente. Esse é o fluxo.

{% include image.html url="/assets/images/git-clone.jpg" description="Clonando repositório'" %}<br>

Ao solicitar a url do repositório, você vai colocar a sua.

{% include image.html url="/assets/images/git-clone2.jpg" description="Clonando repositório'" %}<br>

No próximo passo ele pedirá para criar uma pasta, então dê um nome para a pasta local. Pode ser qualquer nome, inclusive o nome do site. Depois ele perguntará se você quer puxar todo o repositório com todas as branches, então clique enter sem inserir nenhum campo. Em questão de segundos o obsidian irá carregar o repositório localmente e pedirá para reiniciar o programa. Então o faça.

Ao abrir o obsidian novamente, você já vai conseguir ver os arquivos do repositório localmente.

{% include image.html url="/assets/images/git-obsidian2.jpg" description="Repositório baixado localmente'" %}<br>

Então, agora crie uma página de exemplo dentro da pasta "_posts" e defina o formato que falei acima. Para facilitar, você pode fazer uma cópia de um post já existente, então, altere o título e data de publicação. Exemplo abaixo.

{% include image.html url="/assets/images/git-obsidian3.jpg" description="Post novo criado'" %}<br>

Após criar o post, vá na paleta de comandos do obsidian e procure por "git create backup". E então clique nele. Esse comando realiza os commits das alterações locais e as envia para o repositório remoto automaticamente. Em alguns segundos você já pode ir no repositório remoto e ver se atualizou.

{% include image.html url="/assets/images/github-action.jpg" description="Repositório remoto atualizado'" %}<br>

E agora se você clicar na opções Actions, no github, verá que o serviço está implantando as novas alterações no site. Até que ele terminar o deploy, aparecerá isso:

{% include image.html url="/assets/images/github-action2.jpg" description="Site provicionado ou 'aka deployado''" %}<br>

Por debaixo dos panos, o github ao reconhecer novas alterações na estrutura, recompila os arquivos e gera novamente o site estático. Para confirmar isso, vamos acessar a página que acabamos de criar: https://marlluslustosa.github.io/Gesko/2024/03/11/site-obsidian-com-git. E prontinha, está lá!

{% include image.html url="/assets/images/git-page.jpg" description="Post no ar!" %}<br>

Então, dica rápida para um bom fluxo com obsidian + git:

Ao abrir o Obsidian:
Paleta de comandos > Opção **'Git Pull'** > Escreva um ou mais posts > **'Git create backup'**.
E então seus artigos estarão na web em minutos!

Opções para personalização de domínios, senha em páginas web e outras opções de customização do blog deixarei para próximos capítulos.

Até mais!
