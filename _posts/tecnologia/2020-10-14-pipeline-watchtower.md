---
title: DevOps - Pipeline CI/CD para atualização de containers Docker em produção - e com notificação
featured: true
hidden: true
rating: 2
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/devops-watchtower.webp
image-ref:
tags:
- pipeline cicd
- watchtower
- github actions
- github
- devops
id-ref: pipelinecicd-watchtower
---

Continuando nos assuntos sobre Dev* (DevOps, DevSecOps, WhataF*ckOps...) , neste artigo, trago uma abordagem para atualização de containers Docker (pull image, start/stop) de forma automatizada, através de um pipeline CI/CD, unindo [Github Actions](https://docs.github.com/pt/free-pro-team@latest/actions), [Watch Tower](https://github.com/containrrr/watchtower) e [Send Grid](https://sendgrid.com/). Esse artigo tem como foco e motivação a abordagem de cenários onde não são utilizados recursos nativos de cluster, como kubernetes.

#### Atualização de containers Docker

Você é um analista de infraestrutura renovado (sysadmin old). Então, começou a administrar os mais diversos artefatos que os desenvolvedores da equipe começaram a entregar, como imagens, containers Docker e aplicações [cloud native](https://www.cncf.io/), além disso, faz de tudo para ficar de olho nos processos que estão rodando nas VMs que administra os Docker Hosts. Como você está iniciando nesse mundo, ainda não teve coragem de investir em um cluster (apesar de ouvir muito falarem disso na internet), pois acha que será muito difícil aprender a usar o swarm ou kubernetes e colocá-lo em produção, além disso, não acredita que o seu ambiente é grande o suficiente para a preocupação com isso - pelo menos agora. Esse é seu caso, até aqui?

Se sim, então você tem o seguinte cenário: Desenvolvedores - ou você mesmo - atualizam imagens docker para um registry, e você - ou o próprio dev - com um acesso SSH ao Docker host, onde estão os containers, agendam aquele tempinho para fazer a implantação da nova atualização com um `docker pull image`, seguido de  `docker stop container` , `docker rm container` e `docker start container`, correto?

Pois bem, com o tempo esse processo começa a ficar efadonho, até você tomar a atitude de enviar as credenciais do Docker host para o dev e pedir pra ele mesmo fazer isso, enquanto sua eficiência vai pro brejo (além de minar a segurança e seu próprio trabalho).

Bem, na literatura DevOps, quando há uma implantação replicável, descritiva e automatizada, dizemos que esse processo faz parte de um CD (Continuous Deployment). E aqui, proponho um pipeline CI/CD para este cenário, onde terei as seguintes ações:

1. <mark>Build da imagem Docker (CI);</mark>

2. <mark>Push dessa imagem para um registry (CD - Continuous Delivery);</mark>

3. <mark>Notificação, por e-mail, da entrada de uma nova imagem no registry (passo anterior);</mark>

4. <mark>Pull da imagem e atualização dos containers (CD - Continuous Deployment);</mark>

5. <mark>Notificação, por e-mail, da atualização dos containers (passo anterior);</mark>

Com estes passos, todas as vezes que uma atualização de imagens no repositório ocorrer, ela irá ser testada e enviada para o registry e, automaticamente, será feita a atualização (pull) dessa imagem no Docker host que a hospeda, além disso, os containers também serão atualizados. Neste cenário, o seu trabalho passará a ser a espera de novas notificações sobre os processos de build, push e pull das imagens para a produção (trabalho muito difícil - :)) rs

#### Montando o pipeline (Integration/Delivery)

Com o repositório setado no github, você criará o seguinte workflow, dentro da pasta `.github/workflows`:

<script src="https://gist.github.com/marlluslustosa/f2818a483765b1700c50b9d0a2faaf04.js"></script>

Esse workflow contempla as ações 1, 2 e 3, que correspondem ao build (CI), push da imagem no registry (CD) e notificação via e-mail. Usei este mesmo workflow (passos 1 e 2) como parte de outro, que escrevi [neste artigo](https://marllus.com/tecnologia/2020/10/12/pipelineci-vulnerabilidade.html). Então, a explicação de seu funcionamento está lá. A única diferença é que agora eu coloquei outra action, do repo [mmichailidis/sendgrid-mail-action](https://github.com/mmichailidis/sendgrid-mail-action), que usa a API do Send Grid para enviar e-mails, via SMTP. Eles te dão um limite de 100 e-mails grátis por dia, na versão gratuita. Então, é um ótima escolha para projetos pequenos. 

Após criar uma conta [lá](https://sendgrid.com/), veja o [tutorial](https://sendgrid.com/docs/API_Reference/SMTP_API/getting_started_smtp.html#-Sending-a-test-SMTP-email-with-Telnet) para definir uma chave para API SMTP e crie suas credenciais, além de aprovar um e-mail sender para colocar como FROM, nos seus envios. `sendgrid-token` é seu token criado no sendgrid para usar a API, `mail` são os e-mails para os quais deseja enviar a mensagem de notificação, `from` é o e-mail aprovado no sendgrid (e-mail sender), que estará autorizado a enviar emails, usando o token criado. `subject` é o assunto e  `text` o corpo da mensagem.

Depois de definidos todos esses parâmetros e criadas as variáveis Secrets, dentro do repositório do github, você já pode commitar e enviar para o repositório. O workflow vai seguir com o build, push e irá fazer o executar o último job (email), que é a notificação que existe uma nova imagem no repositório.

#### Montando o pipeline (Deployment)

Para implantação contínua, iremos utilizar o serviço [Watch Tower](https://github.com/containrrr/watchtower), que age como um verificador automático de novas imagens em um repositório remoto. Basicamente, ele testa o hash `sha256` da imagem local e compara com a remota mais recente, para saber se são iguais, caso contrário ele faz um `docker pull` e já atualiza automaticamente os containers (aquele trabalho chato que citei no início). Ele é bem utilizado na litetura ([6.6k](https://github.com/containrrr/watchtower/stargazers) estrelas e [403](https://github.com/containrrr/watchtower/network/members) forks, na data de escrita deste artigo) e conta com vários tipos de variáveis de ambiente, como por exemplo notificação após atualização dos containers, através de envio SMTP (que é o que iremos utilizar, já considerando as credenciais sendgrid criadas anteriormente).

Então, no mesmo Docker host onde estão os containers referentes às imagens que acabou de atualizar, você vai subir um container do Watch Tower, já passando todos os parâmetros necessários:

<script src="https://gist.github.com/marlluslustosa/23c21d5fa92d83743edda1b0056abb8c.js"></script>

 O comando acima sobe um container Watch Tower que vai monitorar todas as imagens, em um intervalo padrão de 5min, e caso alguma atualização aconteça, ele enviará uma notificação para o email setado (`EMAIL_TO`). Existem vários argumentos que ele suporta, inclusive, colocá-lo para monitorar hosts remotos, modo HTTP API, para somente aceitar triggers remotas, alterar o intervalo de monitoramento, excluir as imagens antigas, após a atualização, dentre vários outros pontos definidos na [documentação](https://containrrr.dev/watchtower/arguments/). Você pode também definir um `docker-compose.yml` para a subida do serviço, colocando as senhas e tokens como [arquivos env](https://docs.docker.com/compose/environment-variables/#the-env_file-configuration-option), e criptografá-los em repouso, usando, por exemplo, o [blackbox](https://github.com/StackExchange/blackbox), caso não queira deixá-los em texto plano.

Com isso, finalizamos a definição de nosso pipeline CI/CD com integração, entrega e implantação contínuas de microsserviços Docker em produção, com notificação para todos os membros integrantes do processo. Fica a dica para implantar também um Job para análise de vulnerabilidade na imagem gerada, como escrevi [neste post](https://marllus.com/tecnologia/2020/10/12/pipelineci-vulnerabilidade.html). São muitas as possibilidades...

Abraço e deixe um comentário, se gostou (ou não)!<br>:)
