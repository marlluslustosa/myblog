---
title: Na trilha com Qubes OS - Parte 1
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/qubes-logo.jpg
image-ref: <a href="https://www.qubes-os.org/"> Qubes OS</a>
tags:
- sandbox
- qubesos
- segurança
- isolamento
- privacidade
id-ref: qubesos-parteum
---

Em meados de 2018, conheci o sistema operacional Qubes OS (Um sistema operacional razoavelmente seguro - em tradução literal). Na época, não tinha tanta memória RAM (um dos principais requisitos para utilizá-lo de forma eficaz). Por conta disso, minha experiência não foi legal, apesar de admirar o sistema. Com a pandemia, tive que reformar minha estação de trabalho, para poder melhorar a agilidade na entrega - agora à distância -, e conciliar um notebook para uso pessoal e profissional.

Comprei uma memória RAM de 16GB e a anexei ao segundo slot vazio do meu note, totalizando 26GB (com os 8 que já tinha). Então, é chegada a hora de retorno aos meus  testes com o Qubes OS, nessa trilha com sol escaldante e poucos suprimentos. 

Nesta jornada, compartilharei minha experiência de uso, em formato de diário digital.

Este é o primeiro artigo de uma série chamada: "<mark>Na trilha com Qubes OS</mark>".

#### Afinal, por que escolhi o Qubes OS?

Primeiro, me considero um entusiasta dos mais diversos tipos de estratégias/metodologias/ferramentas que vão aparecendo no mundo da tecnologia. Além disso, tenho um pé nas áreas de virtualização, redes de computadores, segurança e uma intensa vontade de buscar a melhoria da proteção e privacidade do usuário comum. 

Ao longo dos anos, fui colocando em prática conceitos da [segurança por isolamento](https://dance.csc.ncsu.edu/papers/CSUR2016.pdf), em níveis cada vez mais profundos. Até chegar um momento em que me vi usando um Fedora onde quase todas as aplicações utilizadas eram isoladas com o uso da ferramenta [firejail](https://firejail.wordpress.com/), com regras específicas de bloqueio/liberação para cada uma delas. Para você ter noção, eu desligava a network do aplicativo calculadora, com medo de backdoors...

Já escrevi sobre o firejail por [aqui](https://marllus.com/tecnologia/2020/07/03/sandbox-gnulinux.html). Fique à vontade para degustar.

Bem, então, como meu nível de paranóia não cedia, resolvi partir para um outro patamar de isolamento. Pensei comigo: Ou melhoro meu nível de segurança/privacidade ou fico logo doido. Nas duas possibilidades, certamente iria aprender novos conceitos - e foi o que me instigou a este caminho. Foi daí que comecei a adotar o uso diário do impressionante Qubes OS, criado originalmente por [Joanna Rutkowska](https://www.qubes-os.org/team/#joanna-rutkowska).

{% include image.html url="/assets/images/qubes-arquitetura.jpg" description="Qubes OS: onde quase tudo é isolado!" %}

<br>

#### Primeiros passos - uso básico

Terminada a instalação do sistema operacional, setado uma senha de encriptação LUKS do disco SSD, e após carregado o sistema básico, a fera de 7 cabeças mostrou sua face.

{% include image.html url="/assets/images/qubes-desktop.jpg" description="" %}

<br>

Nada demais, somente um xfce com algumas aplicações GNU/Linux pré instaladas, além de um gerenciador chamado *Dom0 Qube Manager*. Como o sistema tem por baixo o virtualizador Xen, Dom0 significa a primeira máquina virtual carregada, e que controla todo o hardware disponível, ou seja, é a primeira camada que tem acesso privilegiado à todo o hardware (e com isso, o isola). Para saber mais sobre Dom0 e DomU, leia a documentação [Xen](https://wiki.xenproject.org/wiki/Dom0).

Ao utilizar o Qubes, o usuário tem que ter em mente **uma forma isolada de utilizar as coisas**. Antigamente, no meu uso com firejail, mesmo utilizando diversas aplicações, ainda sim sabia que somente tinha um único sistema operacional como gerenciador do kernel principal. Com o Qubes OS, tenho vários kernels, o do Dom0, das DomUs (e estas podem ser máquinas templates ou autônomas/standalones). Isso quer dizer que, na linguagem do usuário comum, tenho um grande virtualbox, onde cada máquina virtual (VM) representa uma apliciação nesse ambiente.

Então, com isso em mente, comecei a criar cada um de meus *qubes* - é assim que cada VMzinha é chamada dentro dele -, para os mais diversos fins.

#### Isolamento e finalidades

Alguns modelos/templates já vêm pré instalados para utilização, como Fedora, Debian e Whonix. Bem como alguns qubes também. Você pode criar outros, para utilizar um programa específico, aplicativos de bancos, outro para senhas, e desabilitar a network desses qubes. Primeiro, tudo que for feito na zona de um qubes - e não no seu template - será apagado na próxima reinicialização do respectivo, exceto as pastas /rw e /home, que permanecerão sempre com persistência em disco. Então, como persistir a instalação de uma aplicação? **1.** Instalar a aplicação no template respectivo, **2.** editar o arquivo */rw/bin-dirs* e definir pastas específicas ou **3.** instalar a aplicação na */usr/local*. 

A vantagem da primeira estratégia é que você instalará o pacote normalmente no template, que por sua vez será replicado para o AppVM, após a próxima inicialização. A desvantagem é que qualquer AppVM baseado naquele template também terá esse aplicativo presente, o que pode não ser uma boa ideia, caso queira manter um aplicativo somente em um contexto de qubes.

Já a segunda e terceira abordagens exigem que você especifique, em um arquivo de configuração, quais pastas deverão ser persistidas, o que acaba por aumentar o nível de complexidade, caso seja um usuário sem tanta experiência em administração de pacotes de softwares em ambiente GNU/Linux. Se for um programa que será compilado no sistema, e quiser definir a instalação no próprio qubes - e não no template -, é só marcar *\-\-prefix=/usr/local/bin* no ato do *./configure*. 

Eu gosto de uma abordagem onde eu mesclo a primeira com a segunda estratégia, onde faço uma cópia de um template e o utilizo para algumas aplicações específicas, e nas configurações do AppVM, seto esse novo clone para ser a base do sistema operacional.

Você deve estar se perguntando como o Qubes OS faz esse tipo de gerenciamento, onde você pode setar diferentes kernels (como templates) para os qubes em questão.

Ele trabalha com volumes LVM em disco para realizar tal feito, além de funcionalidades do próprio Xen. Basicamente, o template contém os arquivos de sistema, como libs e binários específicos em LV's específicos gerenciados pelo Dom0. Ao iniciar um qubes (como AppVM), setando um template Fedora como base, por exemplo, ele carregará o espaço do usuário (/rw) e subirá o restante do sistema baseado no template especificado. Caso você altere de Fedora para Debian, o que irá mudar são os comandos e aplicativos instalados no mesmo. Mas a funcionalidade de carregamento seguirá com sucesso. Essa é uma grande vantagem no que diz respeito ao isolamento, que é a possibilidade de mudar as bases de kernel com um clique, permitindo que você possa remover templates recém infectados, além de setar quais qubes usarão certos templates.

#### Usando Docker

Minha experiência em usar Docker dentro de qubes específicos foi interessante. Primeiro, pensei em como faria para instalar esse gerenciador de containers em um qubes específico, sem precisar instalar e realizar a mesma configuração em todos os qubes. Instalei então o docker e docker-compose no template padrão. Após isso, fui no qubes e adicionei a seguinte configuração no arquivo */rw/bin-dirs/rc.local* (arquivo que será executado todas as vezes em que o qubes carregar):

```bash
dockerd --data-root /home/user/docker
systemctl enable docker
systemctl start docker
```

A primeira linha quer dizer que estou alterando a pasta onde as imagens serão gravadas, então, ao invés da padrão /etc/ e /var, todos os arquivos referentes à instalação docker serão gravados e lidos na nova pasta */home/user/docker* que - bingo - é local com persistência permante em disco, por padrão. Logo após isso, um docker enable e start para carregar a aplicação.

Perceba que somente adicionei isso em um único qubes, e não em todos, nem mesmo no template (que somente tinha o docker instalado). 

Após isso, aumentei o tamanho do armazenamento privado (*/rw*) do qubes para não encher tão rapidamente com imagens Docker. O outro armazenamento (sistema) é o que é compartilhado entre os diferentes qubes, que usam a mesma base de template. Por isso que quando se instala um software no template, ele aparece magicamente em todos os qubes que o utilizam como base.

> Então, você deve estar se perguntando: Como diabos eu não tenho um overhead maluco por conta de tantos qubes, já que todos eles são mini sistemas operacionais?

É aí onde mora a beleza. A forma como o sistema foi projetado faz com que ele crie uma ilusão de que cada qubes é autônomo - uma máquina virtual completa -, e que pode ler e escrever em todos os diretórios, inclusive na raiz (*/*). <mark>Mas é tudo ilusão</mark>, ou seja, você pode até tentar instalar uma aplicação localmente, e ela até funcionará, mas se reiniciar seu qubes, tudo será perdido, porque você instalou em um lugar fake, no contexto de AppVM.

 Segundo a [documentação oficial](https://www.qubes-os.org/doc/templates/), o sistema de TemplateVM tem benefícios significativos:

- **Segurança**: Cada qube tem acesso somente leitura ao TemplateVM no qual é baseado, então se um qube for comprometido, ele não pode infectar seu TemplateVM ou qualquer um dos outros qubes baseados naquele TemplateVM.

- **Armazenamento**: Cada qube baseado em um TemplateVM usa apenas o espaço em disco necessário para armazenar seus próprios dados (ou seja, seus arquivos em seu diretório inicial), o que economiza muito espaço em disco.

- **Velocidade**: É extremamente rápido criar novos TemplateBasedVMs, uma vez que o sistema de arquivos raiz já existe no TemplateVM.

- **Atualizações**: as atualizações são naturalmente centralizadas, já que atualizar um TemplateVM significa que todos os qubes baseados nele usarão automaticamente essas atualizações após serem reiniciadas.



{% include image.html url="/assets/images/qubes-dominios.jpg" description="Vai um isolamento aí?" %}

<br>

Deixarei você processar toda essa disrupção na utilização de um sistema operacional. Fique ligado nos próximos capítulos.

Um abraço!<br> :)
