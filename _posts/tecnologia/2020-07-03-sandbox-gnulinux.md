---
title: Segurança por isolamento em aplicações GNU/Linux (Firejail Sandbox)
author: marllus
categories:
- tecnologia
layout: post
image: assets/images/sandbox-gnulinux.jpg
image-ref: Photo by <a href="https://unsplash.com/@kintecus">Ostap Senyuk</a>
tags:
- sandbox
- firejail
- segurança
- isolamento
- privacidade
id-ref: sandbox-gnulinux
---

Esse artigo abordará um conceito chamado <mark>segurança por isolamento</mark>. Aqui eu abordarei algumas questões sobre esse termo, bem como dicas práticas para se trabalhar com *sandboxies* no sistema operacional GNU/Linux, usando a ferramenta [Firejail](https://firejail.wordpress.com/).

#### Afinal, por que isolar aplicações?

Bem, a discussão sobre isolamento já permeia há tempos a academia, a vida pessoal de inúmeras pessoas, bem como o funcionamento de diversas organizações. Você mesmo, no dia a dia, pode utilizar e se usufruir de uma forma de isolamento e nem perceber. O simples fato de ter dois celulares já é uma forma de aplicar esse conceito.

Existe na literatura definições bem consolidadas sobre isolamento de segurança em ambiente computacional e um material muito esclarecedor sobre isso pode ser lido [aqui](https://dance.csc.ncsu.edu/papers/CSUR2016.pdf). No artigo anteriormente mencionando, os autores realizam uma análise das técnicas de isolamento de segurança existentes e detalham conceitos, além de discutirem *tradeoffs* entre diferentes opções de design e limitações das abordagens existentes. Basicamente, segundo o trabalho, existem esses tipos de isolamento: 

{% include image.html url="/assets/images/tipos-isol.jpg" description="" %}

<br>

Quando você está executando uma máquina virtual (VM) por meio do [virtualbox](https://www.virtualbox.org/), por exemplo, está fazendo uso do isolamento da Fig. 3, ou de Hypervisor tipo 2. Caso esteja executando uma aplicação em uma máquina virtual na Amazon AWS ou Azure, estará fazendo uso do isolamento de Hypervisor tipo 1. Da mesma forma, se estiver utilizando um container LXC ou Docker, estará usufruindo da mesma abordagem descrita na Fig. 5. Sendo a última abordagem apresentada como foco desse artigo.

 Um dos recursos que possibilitou a concepção do design de isolamento da Fig. 5 foi o [linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces). Ele tem a função de "agrupar um recurso global específico do sistema em uma abstração que faça parecer aos processos dentro do espaço do usuário que eles possuem sua própria instância isolada do recurso global" [[1](https://lwn.net/Articles/531114/)]. 

> O principal objetivo dos *namespaces* é oferecer suporte à implementação de containers, como Docker e LXC. Este recurso é considerado uma ferramenta para virtualização leve que fornece a um grupo de processos a ilusão de que eles são os únicos processos no sistema.

Mesmo sem você ser um especialista na área sistemas operacionais, deu pra entender o que mais ou menos significa esse tipo de isolamento, correto?

Tal abordagem destaca como principais vantagens um baixo custo 
computacional, além de prover uma interface simplificada, o que facilita o processo de implantação pelo usuário. Você não precisa dedicar uma máquina para instalar um hypervisor e virtualizar instâncias inteiras para realizar tarefas cotidianas, mas somente chamar *containers* para realizar um trabalho de forma isolada, como se fossem mini máquinas virtuais. E isso claramente está relacionado ao desempenho e utilização de recursos de sua máquina física, como memória RAM e CPU. Não estou dizendo que a utilização de VMs seja uma péssima opção, mas que cada abordagem destina-se a atender um determinado tipo de problema. Entretanto, a adoção de *containers* apresenta um melhor aproveitamento dos recursos de hardware, quando comparado com a utilização de VMs. Os detalhes sobre níveis de isolamentos em cada uma das técnicas podem ser conferidos no artigo que linkei anteriormente.

A forma mais simples e talvez a mais conhecida de se trabalhar com isolamento de aplicações em nível de sistema operacional, utilizando *namespaces* e *seccomp-bpf* é utilizando a ferramenta [Firejail](https://firejail.wordpress.com/). Segundo o autor:

> Firejail é uma *sandbox* de segurança genérica para namespaces do Linux , capaz de executar programas de interface gráfica e também servidores. A *sandbox* é leve e a sobrecarga é baixa. Não há conexões de soquete abertas, nem *daemons* sendo executados em segundo plano. Todos os recursos de segurança são implementados diretamente no kernel do Linux e disponíveis em qualquer computador Linux.

Firejail é tudo isso acima e muito mais. O que mais gosto dessa ferramenta é seu código, feito em [linguagem C](https://pt.wikipedia.org/wiki/C_(linguagem_de_programa%C3%A7%C3%A3o)). Isso trás muita complexidade ao software, mas, <mark>sem dúvida</mark>, é uma grande vantagem em eficiência na execução das aplicações. Quando os aplicativos são abertos, o baixo tempo de resposta torna praticamente imperceptível o *overhead* gerado pela camada de isolamento. Utilizar a linguagem C para isso, realmente foi uma ótima escolha para o desenvolvimento desse projeto.

Alguns recursos do Firejail:

- **lista negra** - negar acesso a arquivos e diretórios. As tentativas de acesso são relatadas ao syslog.

- **lista de permissões** - permite apenas os arquivos e diretórios especificados pelo usuário.

- **somente leitura, leitura e gravação, noexec** - define atributos de arquivo e diretório.

- **sistema de arquivos temporário** - montar um sistema de arquivos temporário em cima de um diretório.

- **bind** - montar um arquivo ou diretório em cima de outro arquivo ou diretório.

- **private** - montar cópias de arquivos e diretórios e descartá-los quando a sandbox for fechada.

- **Página inicial do usuário restrita** - apenas o diretório inicial do usuário atual está disponível dentro da sandbox. Isso também se reflete na estrutura dos *arquivos /etc/passwd* e */etc/group* .

- **vazamento reduzido de informações do sistema** - restringir o acesso à diretórios como */boot* , */proc* e */sys*.

Você deve estar se perguntando o porquê de isolar aplicações no sistema operacional. Bem, se ainda não está claro, saiba que muitos softwares expõem usuários a ataques de elevação de privilégios, execução de rotinas como sub processos dentro do sistema operacional, leitura de pastas e arquivos específicos... Resumindo, você tem a possibilidade de auditar manualmente o código fonte de todos os softwares que executar (quando for *open source*) ou executá-lo em uma *sandbox*, o que é muito mais simples. Pense em uma sandbox como um *playground* onde você pode testar ferramentas novas, bem como isolar aplicações de outras, como acesso à *internet banking*, *e-mails* e outros softwares que manipulam informações sensíveis.

Originalmente, o firejail foi feito para funcionar através da linha de comando, mesmo assim sua execução é bem intuitiva, disponibilizando de instruções fáceis de serem executadas para uso comum.

```bash
$ firejail firefox                       # Iniciar o Mozilla Firefox
$ firejail transmission-gtk              # Iniciar o Transmission BitTorrent 
$ firejail vlc                           # Iniciar o VLC
$ sudo firejail /etc/init.d/nginx start  # Iniciar um servidor web nginx
```

Sabe os [vazamentos de dados](https://canaltech.com.br/seguranca/vazamento-de-dados-do-zoom-compromete-mais-de-500-mil-usuarios-163316/) e as questões anteriores sobre segurança e privacidade, relacionadas com a falta de criptografia do software de vídeo conferência [Zoom](https://zoom.us/pt-pt/meetings.html)? Pois bem, se estivesse usando o Firejail, teria se livrado de vazamentos sobre o sistema operacional utilizado, bem como informações privilegiadas a respeito dele, além de ter diminuído a superfície de ataque, caso algum invasor tivesse acesso privilegiado ao programa, no ato da sua execução. Você pode conferir [aqui](https://github.com/alexjung/Run-Zoom-in-a-Sandbox) um perfil firejail para utilizar o Zoom em *sandbox*. Você pode alterar o DNS, características de interface de rede, VPN e <mark>qualquer informação editável no nível do usuário</mark>, usando a ferramenta. Confira a [documentação](https://firejail.wordpress.com/documentation-2/).

Caso você não tenha familiaridade com terminal ( se o acha meio trevoso 
hehe) o projeto [firetools](https://github.com/netblue30/firetools), mantido pela comunidade (sob licença de 
software livre GPL-v2), disponibiliza uma ferramenta com interface 
gráfica que auxilia no processo de configuração de um *sandbox*.

<iframe style="width:100%;" height="315" src="https://www.youtube.com/embed/J1ZsXrpAgBU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Se até aqui ficou meio nebuloso o processo de entendimento sobre o funcionamento desse tipo de isolamento, seguem [aqui](https://medium.com/@lets00/namespace-14c4e64d0559) e [aqui](https://www.redhat.com/pt-br/topics/virtualization/what-is-virtualization) alguns textos legais para o entendimento do conceitos iniciais sobre a temática.

Esse artigo contou com a revisão do amigo [Eugênio](https://github.com/eugeniucarvalho), e as alterações no texto sugeridas por ele podem ser conferidas neste [*commit*](https://github.com/marlluslustosa/myblog/commit/c6af8160ed6a36b04375b7792bec176feba7bbea#diff-2a07d11bb396a08c71442c36ab307dc2).

É isso! Dúvidas nos comentários!<br>Obrigado! <br>:)
