---
title: Criptografia de dados em repouso com git e blackbox
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/cofre-mar.jpg
image-ref: <a href="https://www.reddit.com/r/blender/comments/1zn20x/treasure_chest_floating_in_the_ocean_it_turned/">Treasure chest floating in the ocean</a>
tags:
- criptografia
- criptografia git
- gitlab
- blackbox
- devsecops
- criptografia em repouso
- dados em repouso
id-ref: cripto-blackbox
---

Continuando com a temática [DevSecOps]({{site.baseurl}}/tags#devsecops), esse artigo apresenta o conceito de criptografia de dados em repouso e trás um HandsOn sobre essa proteção, apresentando um design de criptografia, que utiliza dados em repositórios git e chaves assimétricas GPG.

#### Criptografia em repouso

Pode-se considerar dados em repouso como qualquer dado que não esteja em trânsito, ou seja, que está localizado em algum armazenamento físico ou virtual, seja o disco local do seu notebook ou um storage em nuvem.

Com sistemas de controle de versão - VCS (como o git), compartilhados entre equipes e que são armazenados em servidores centrais, para prover o acesso a todos, não seria diferente: <mark>dados em repouso!</mark>

> Um exemplo de criptografia que protege dados em repouso é a encriptação de “disco inteiro” (também chamada às vezes de “encriptação de dispositivo”). Habilitar a encriptação de disco inteiro criptografa todas as informações armazenadas num dispositivo, protegendo-as com uma frase-chave ou com outro método de autenticação. Num dispositivo móvel ou num laptop, isto geralmente se parece com uma tela de bloqueio normal, que exige uma senha, uma frase-chave ou uma impressão digital. No entanto, bloquear o seu dispositivo (exigindo uma senha para desbloqueá-lo, por exemplo) nem sempre significa que a encriptação de disco inteiro está habilitada.
> 
> [O que eu deveria saber sobre criptografia? - Autodefesa contra Vigilância](https://ssd.eff.org/pt-br/module/o-que-%C3%A9-criptografia)

Imagine o caso: Você tem um arquivo docker-compose.yml com variáveis de ambiente setadas em seu conteúdo, além de arquivos .env separados, contendo senhas, usuários e outras configurações sensíveis, que serão passadas como parâmetro no ato da execução dos containers em questão. Imagine que este repositório é privado, porém, compartilhado 'somente leitura' com várias equipes externas ao setor. E aí, como resolver o problema, considerando que deverá disponibilizar os arquivos dentro do repositório, porém, torná-los acessíveis somente por membros definidos?

<mark>Criptografia em repouso!</mark>

Dessa forma, os arquivos serão criptografados via GPG no lado do cliente, utilizando sua chave pública e, com um programa gestor de criptografia de chaves GPG com suporta ao git, poderá incluir as chaves públicas de outros usuários que acessarão os mesmos arquivos. Logo, com os arquivos criptografados em repouso no lado local, poderá enviá-lo para o repositório (push) para ser guardado e disponibilizado aos outros usuários. Os arquivos serão acessíveis a todos para baixar (pull), mas só poderão ser descriptografados - somente no lado do cliente - pelos usuários definidos na lista de chaves permitidas. Parece um pouco confuso, mas só parece.

#### GitLab e blackbox

Aqui, mostrarei a resolução do problema na prática, utilizando para isso o GitLab junto à ferramenta [blackbox](https://github.com/StackExchange/blackbox) (a que vai criptografar via GPG e gerenciar permissões nos arquivos).

Como o blackbox funciona? Uma rápida consultada na documentação, nos explica de forma simples:

> O GPG possui muitas maneiras diferentes de criptografar um arquivo. O BlackBox usa o modo que permite especificar uma lista de chaves que podem descriptografar a mensagem. 
> 
> Se você tiver 5 pessoas ("administradores") que devem ser capazes de acessar os segredos, cada um cria uma chave GPG e adiciona sua chave pública às chaves. O comando GPG usado para criptografar o arquivo lista todos os 5 nomes de chave e, portanto, qualquer 1 chave pode descriptografar o arquivo. 
> 
> Para remover o acesso de alguém, remova o nome da chave do administrador (ou seja, endereço de e-mail) da lista de administradores e criptografe novamente todos os arquivos. Eles ainda podem ler o arquivo .gpg (presumindo que tenham acesso ao repositório), mas não podem mais descriptografá-lo.
> 
> [blackbox - How is the encryption done?](https://github.com/StackExchange/blackbox#how-is-the-encryption-done)

Caso não tenha um par de chaves GPG, crie-o através do comando `gpg --gen-key` (considerando que você está em um sistema Unix Like, como GNU/Linux). O pacote em questão é o [gnupg](https://www.gnupg.org/gph/en/manual/c14.html). No site oficial contém versões para todos os sistemas operacionais.

Após criar o par de chaves, instale a ferramenta [blackbox](https://github.com/StackExchange/blackbox#installation-instructions). Uma das formas é baixar o repositório e setar um comando para criar links simbólicos para os binários no diretório `/usr/local/bin` do seu SO. Resumindo:

```bash
git clone https://github.com/StackExchange/blackbox.git 
cd blackbox
make symlinks-install
```

Após isso, você vai inicializar o blackbox no seu repositório git e incluir a chave pública PGP do seu usuário, criado no passo anterior à instalação do blackbox.

```bash
cd blackbox_crypt_test
blackbox_initialize #inicializa o blackbox no repositório
blackbox_addadmin <gpg-key> #gpg-key pode ser o fingerprint da chave ou e-mail cadastrado
```

Agora, crie um arquivo hipotético com dado sensível, inclua-o para ser gerenciado pelo blackbox e edite-o.

```bash
touch super_secret.txt
blackbox_register_new_file super_secret.txt #registra o arquivo para ser criptografado
blackbox_edit super_secret.txt #abre o arquivo utilizando o editor padrão, quando fechá-lo, ele irá criptografá-lo automaticamente
```

Caso utilize alguma ferramenta GUI (como o VScode) para editar arquivos, existe o comando `blackbox_edit_start super_secret.txt` para descriptografá-lo e não abrí-lo automaticamente. Então, depois de alterá-lo, pode digitar `blackbox_edit_end super_secret.txt` que ele o criptografará novamente. Só não esqueça desse último comando, antes do último commit de envio para o repositório, pois, como disse, ele serve para manter os arquivos em texto plano até que finalize a edição ou procedimentos que necessitariam deles abertos por mais tempo.

Perceba que qualquer comando que aplicar usando o blackbox, ele irá adicionar sugestões de commit para o repositório. Se tudo tiver dado certo, é só confirmar.

```bash
git commit -m"super_secret.txt.gpg updated" "super_secret.txt.gpg"
git push
```

Pronto, você terá um repositório git com dados criptografados que só poderão ser descriptografados por usuários que tiveram suas chaves adicionadas pelo blackbox e que podem ser vistos através do comando `blackbox_list_admins`. Na pasta `.blackbox` ele guardará as chaves públicas e listará os administradores (`blackbox-admins.txt`) que poderão descriptografar a pasta. 

Caso alguém baixe o repositório e queira adicionar uma chave pública através de um usuário que não tem chaves previamente cadastradas, ele dará um erro de permissão, pois cosultará localmente via chave privada se aquele usuário é admin no blackbox. Então, para adicionar um novo usuário, algum admin da lista tem de adicioná-lo previamente com o comando que você já conhece: `blackbox_addadmin` (passando como parâmetro a chave pública do usuário que será adicionado)

Criei um repositório exemplo de teste, seguindo esse artigo. A lista de commits pode ser vista aqui [blackbox_crypt_test · GitLab](https://gitlab.com/mlustosa/blackbox_crypt_test/-/commits/master/) 

Dúvidas nos comentários.<br>Abraços e até mais! :)
