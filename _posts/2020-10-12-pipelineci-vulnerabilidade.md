---
title: DevSecOps - Pipeline CI para gestão de vulnerabilidades em imagens Docker com Trivy e Github Actions
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/github-actions.webp
image-ref: <a href="https://github.com/features/actions"> Github actions</a>
tags:
- pipeline ci
- vulnerabilidade
- github actions
- github
- segurança
- devsecops
id-ref: pipelineci-vulnerabilidade
---

Este é o primeiro artigo sobre a temática <mark>DevSecOps</mark>, e nele, trago uma abordagem que relaciona automação na detecção de vulnerabilidades e abertura de tickets, a partir do próprio repositório de código que hospeda os arquivos que mantém a imagem atualizada. Tudo isso através do uso do recurso Github Actions. Não conseguiu entender? Continue a leitura. 

#### Github actions

Github Actions é um recurso criado pelo Github, que possibilita a criação e execução de fluxos de trabalho (workflows), destinados aos mais diversos cenários de build/deploy/delivery, a partir de uma linguagem declarativa (YAML). Em resumo, dá pra você criar fluxos interessantes, que vão desde testar um build em um Dockerfile, até mesmo implantar essa imagem na produção, em algum provedor de nuvem. Tudo de forma automatizada. E a vantagem: é gratuito para projetos públicos (ou 33 horas/mês para repositórios privados com conta uma free)

> Automatize, personalize e execute seus fluxos de trabalho de  desenvolvimento do software diretamente no seu repositório com o GitHub  Actions. Você pode descobrir, criar e compartilhar ações para realizar  qualquer trabalho que desejar, incluindo CI/CD, bem como combinar ações  em um fluxo de trabalho completamente personalizado. [[Documentação do GitHub Actions - GitHub Docs](https://docs.github.com/pt/free-pro-team@latest/actions)]

```yaml
name: Docker Image CI - Github Actions

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag my-image-name:$(date +%s)
```

O exemplo acima descreve um workflow para o Github Actions onde, intuitivamente, pode-se perceber que uma tarefa (job) será realizada: Testar se o arquivo Dockerfile consegue ser executado para geração de uma imagem. Caso a linha referente ao comando (run) não consiga passar no teste, os *executor* do workflow, na seção Actions do repositório, gerará uma mensagem de erro, além disso, você receberá um e-mail informando que o workflow falhou. O parâmetro *on*, especifica em que momentos o fluxo será executado. Nesse caso, em todos os `git push` e abertura de `Pull Request` na branch master. Existem dezenas de formas de execução de workflows, inclusive [eventos que acionam fluxos de trabalho](https://docs.github.com/pt/free-pro-team@latest/actions/reference/events-that-trigger-workflows#schedule) e  [workflows que ativam outros workflows](https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows#workflow_run). 

{% include image.html url="/assets/images/build-testci.jpg" description="Exemplo de log, na aba Actions, se o workflow executar com sucesso." %}

<br>

Como o que foi dito por funcionários do Github, no episódio sobre a temática, no [Hipsters ponto tech](https://hipsters.tech/integracao-continua-deploy-continuo-e-github-actions-hipsters-213/),  "a imaginação é o limite". Então, pensando nessa amplitude, montei um pipeline CI para gestão de vulnerabilidades de imagens Docker, contemplando os seguintes requisitos: 

1. Teste de build em um Dockerfile;

2. Entrega da imagem (push) para um registry;

3. Análise agendada de vulnerabilidades (incluindo Lint) nas versões de softwares e sistemas operacionais base, contidos na imagem gerada no passo anterior;

4. Abertura automática de uma issue no repositório, com a descrição da(s) vulnerabilidade(s).

5. Notificação automática, na forma de comentário na issue aberta no passo anterior, citando membros específicos do projeto, responsáveis por resolver esse tipo de tarefa.

<mark>Será que é possível fazer tudo isso, de forma automatizada?</mark> Acompanhe...

#### Pipeline CI - Unindo tudo

Após criar o repositório e adicionar um arquivo Dockerfile, crie o diretório `.github/workflows`, e dentro dele, crie o arquivo `pipelineci-vulnerability.yml` e adicione a seguinte descrição:

```yml
name: Workflow - build/push

on:
  push:
    branches:
      - master
  pull_request:

env:
  # Variavel de ambiente vista para qualquer job
  # nome da imagem - altere para o nome correto
  IMAGE_NAME: nome-imagem

jobs:
  # Teste de build
  # Ver mais https://docs.docker.com/docker-hub/builds/automated-testing/
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Executando testes
       # Testa se o arquivo 'builda'
        run: |
          if [ -f docker-compose.test.yml ]; then
            docker-compose --file docker-compose.test.yml build
            docker-compose --file docker-compose.test.yml run sut
          else
            docker build . --file Dockerfile
          fi

  # Push da imagem para o registry do github
  push:
    # Condicao para somente fazer o push se o job test executou com sucesso
    needs: test

    runs-on: ubuntu-18.04
    # Só executa se o evento atual for push (e não um PR)
    if: github.event_name == 'push'

    steps:
      - uses: actions/checkout@v2

      - name: Build image
        # chamada da variavel IMAGE_NAME definida em env 
        run: docker build . --file Dockerfile --tag $IMAGE_NAME

      - name: Login no GitHub Container Registry
      # Personal Access Token (PAT) criado e adicionado no Actions Secrets.
        run: echo "${{ secrets.CR_PAT }}" | docker login https://ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Push da imagem para GitHub Container Registry
        run: |
          IMAGE_ID=ghcr.io/${{ github.repository_owner }}/$IMAGE_NAME

          # Transformar nome da imagem de maiúsculas para minúsculas 
          IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')

          # Retira o prefixo git ref da versão
          VERSION=$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')

          # Retirar prefixo v da tag
          [[ "${{ github.ref }}" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')

          # Use tag latest como convenção para docker:latest
          [ "$VERSION" == "master" ] && VERSION=latest

          echo IMAGE_ID=$IMAGE_ID
          echo VERSION=$VERSION

          # comandos finais para push
          docker tag $IMAGE_NAME $IMAGE_ID:$VERSION
          docker push $IMAGE_ID:$VERSION

  # procura vulnerabilidades na imagem gerada no passo anterior
  scan:
    # somente faz scan se o job anterior concluiu com êxito
    needs: push
    name: Vulnerability Scan
    runs-on: ubuntu-18.04
    steps:
      - name: Pull docker image
        id: pullimage
        run: |
          docker pull ghcr.io/${{ github.repository_owner }}/$IMAGE_NAME
          # setar variavel local para repassar ao trivy
          echo ::set-output name=nome_imagem::$IMAGE_NAME

      # cria issue no repositório, se encontrar vulnerabilidades
      - uses: homoluctus/gitrivy@v1.0.0
        id: trivy
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          # imagem que foi 'pusheada' no job anterior
          image: ghcr.io/${{ github.repository_owner }}/${{ steps.pullimage.outputs.nome_imagem }}
          issue_title: Alerta de segurança

      # comenta issue, citando reponsavel para resolucao
      - name: responder issue
        env:
          REPO: ${{ github.event.repository.name }}
          OWNER: ${{ github.event.repository.owner.login }}
          ISSUE_NUMBER: ${{ steps.trivy.outputs.issue_number }}
        run: |
          # se variavel de retorno html_url (do step trivy) contiver algo, isso quer dizer que foi criada uma issue, entao, comente-a.
          if [ ! -z "${{ steps.trivy.outputs.html_url }}" ]; then
            curl -s -X POST https://api.github.com/repos/$OWNER/$REPO/issues/$ISSUE_NUMBER/comments -d '{"body":"Ei, @marlluslustosa, pode dar uma olhada nessa issue?"}' -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}"
          fi
```

O workflow acima define: Se o teste de build da imagem passar com sucesso (job test), faça um push na mesma (job push), usando o registry do github ([Github Container Registry](https://docs.github.com/pt/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages#autenticar-se-no-github-package-registry-1), então, caso esse passo termine com sucesso, baixe a imagem e a escaneie por vulnerabilidades (job scan). Esse workflow irá executar em todo push e Pull Request na branch master, sendo que, obviamente, o job push somente irá ser executado caso não seja um Pull Request (linha 40 - você não quer enviar uma imagem possivelmente quebrada para o registry, né?).

Antes de enviar este arquivo para o respositório, você terá que criar um token para se logar ao Github Container Registry. Então, terá que criar o Personal Token Access (PAT), porque este serviço - diferentemente do [GitHub Packages](https://github.com/features/packages) - não permite autenticação com o token [GITHUB_TOKEN](https://docs.github.com/pt/free-pro-team@latest/actions/reference/authentication-in-a-workflow#using-the-github_token-in-a-workflow). Clique [aqui](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) para seguir o passo a passo de criação do token PAT. Coloque o nome como `CR_PAT` e nas permissões marque `read:packages` and `write:packages`. Copie esse token, pois iremos usar no próximo passo.

Após o token criado e copiado, você terá que adicioná-lo como segredo criptografado, na opção Secrets, dentro do repositório em questão. O recurso [Secrets](https://docs.github.com/pt/free-pro-team@latest/actions/reference/encrypted-secrets) basicamente é uma forma segura que o Github criou para o runner que está trabalhando em um workflow conseguir usar variáveis contendo conteúdo sensível, como senhas e chaves privadas, sem precisar ser declarada em texto plano, dentro do mesmo arquivo `yml` do workflow. Nesse caso, somente o Github terá acesso à chave definida. Então, vá na página do repositório, clique em Settings > Secrets > New Secret. Defina o nome `CR_PAT` e cole o token copiado no passo anterior. [Aqui](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets) contém os passos para criação de uma variável Secrets.

{% include image.html url="/assets/images/secrets.webp" description="Token criado e adicionado como variável CR_PAT em Secrets." %}

<br>

 A ferramenta que faz o papel de scanner de vulnerabilidades em containers se chama [Trivy](https://github.com/aquasecurity/trivy), e eu usei  [esta](https://github.com/marketplace/actions/trivy-action) implementação, disponível no marketplace do Github, através da chamada na linha 91. Além de ela realizar o scan, automaticamente também reporta a informação, através da abertura de uma issue. Definição de outros parâmetros de entrada podem ser conferidos na [documentação](https://github.com/marketplace/actions/trivy-action).  

Agora, imaginemos que o tempo para atualização desta imagem no repositório seja longo, e que poucas PRs sejam abertas pela equipe ou comunidade. Então, todos ficarão um bom tempo sem ter noção de vulnerabilidades novas, que surgem ao longo do tempo. O que fazer para resolver isso?

Criar um novo workflow, mas agora agendado a partir de um cron (semanal). Então, crie um novo arquivo chamado `scan-agendado.yml`, também na pasta `.github/workflow/`, com o seguinte conteúdo:

```yml
name: Workflow - scan agendado

on:
  schedule:
    # toda segunda-feira às 5 horas da matina!
    - cron: '0 5 * * 1'

env:
  # Variavel de ambiente vista para qualquer job
  # nome da imagem - altere para o nome correto
  IMAGE_NAME: nome-imagem

jobs:
  # procura vulnerabilidades na imagem gerada no passo anterior
  scan:
    # somente faz scan se o job anterior concluiu com êxito
    needs: push
    name: Vulnerability Scan
    runs-on: ubuntu-18.04
    steps:
      - name: Pull docker image
        id: pullimage
        run: |
          docker pull ghcr.io/${{ github.repository_owner }}/$IMAGE_NAME
          # setar variavel local para repassar ao trivy
          echo ::set-output name=nome_imagem::$IMAGE_NAME

      # cria issue no repositório, se encontrar vulnerabilidades
      - uses: homoluctus/gitrivy@v1.0.0
        id: trivy
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          # imagem que foi 'pusheada' no job anterior
          image: ghcr.io/${{ github.repository_owner }}/${{ steps.pullimage.outputs.nome_imagem }}
          issue_title: Alerta de segurança

      # comenta issue, citando reponsavel para resolucao
      - name: responder issue
        env:
          REPO: ${{ github.event.repository.name }}
          OWNER: ${{ github.event.repository.owner.login }}
          ISSUE_NUMBER: ${{ steps.trivy.outputs.issue_number }}
        run: |
          # se variavel de retorno html_url (do step trivy) contiver algo, isso quer dizer que foi criada uma issue, entao, comente-a.
          if [ ! -z "${{ steps.trivy.outputs.html_url }}" ]; then
            curl -s -X POST https://api.github.com/repos/$OWNER/$REPO/issues/$ISSUE_NUMBER/comments -d '{"body":"Ei, @marlluslustosa, pode dar uma olhada nessa issue?"}' -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}"
          fi
```

Basicamente aqui eu copei o job scan do primeiro workflow e alterei o parâmetro *on*, agora para agendamento semanal, e caso encontre alguma vulnerabilidade, além de criar uma issue, vai comentá-la, citando um membro responsável, através do comando `curl` (nesse caso citei eu mesmo [@marlluslustosa](https://github.com/marlluslustosa)). Agora, toda manhã de segunda-feira, uma nova notificação poderá ser enviada ao responsável - para começar a semana ativo!! rsrs

Adicionei esses mesmos arquivos em um repositório de [exemplo](https://github.com/marlluslustosa/onionize-docker). E [aqui](https://github.com/marlluslustosa/onionize-docker/actions/runs/303001302) estão os logs de execução do workflow, referente ao arquivo  `pipelineci-vulnerability.yml`. Na aba Actions do mesmo repositório, verá o workflow referente ao arquivo `scan-agendado.yml`. 

Bem, é isso. Como você pôde perceber, a imaginação é realmente o limite para quem quer utilizar CI/CD com testes automatizados, relacionados à análise de segurança de aplicações e artefatos gerados em imagens Docker, utilizando o Github Actions como única ferramenta e usando uma linguagem declarativa, o que facilita ainda mais o entendimento de todo o pipeline do seu desenvolvimento, criação da infraestrutura e preocupação com a segurança (popularmente aglutinados no termo [DevSecOps](https://www.redhat.com/pt-br/topics/devops/what-is-devsecops)).

{% include image.html url="/assets/images/devsecops.webp" description="Conjunto DevSecOps." %}

<br>

Um abraço.<br>:) 
