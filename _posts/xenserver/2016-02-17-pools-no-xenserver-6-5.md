---
title: "Pools no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image-ref: Photo by <a href="https://unsplash.com/@gofabio" target=_blank>Fábio Hanashiro</a>
image: assets/images/pools.jpeg
---

Um pool de recursos é um termo usado para designar um grupo de instalações XenServer (hosts xen). Esse grupo pode ser um laboratório de hosts xen de teste, produção ou qualquer outro conjunto de servidores em operação para um determinado fim.

Em todo e qualquer pool existirá o membro master (host que roteia a comunicação para outros membros do pool quando necessário) e os restantes slaves. Cada membro têm consigo um base de dados que contém informações a respeito de todos os membros existentes no pool, ou seja, qualquer host no pool sabe quem é master e quem é slave e quem está no pool.

Quando neste pool existe um storage compartilhado, que é um local onde todos os hosts xen têm acesso para leitura/escrita de dados, VMs podem ser migradas, (quase) sem dowtime, entre estes hosts. Essa migração é o recurso no XenServer chamado XenMotion. Se a característica de Alta Disponibilidade (HA) estiver habilitada no pool e um host xen falhar/desligar/se perder/bugar, qualquer VM (definida por você) será movida automaticamente para outro host xen vivo, bem como um novo host membro master será eleito, se este host perdido for o membro master do pool. O limite máximo é de 16 hosts xen em um mesmo pool.

Existem dois tipos de pools, os homogêneos e os heterogêneos.

Em um pool homogêneo, as seguintes características são necessárias:

&#8211; As CPU&#8217;s de todos os hosts xen no pool devem ser as mesmas (em modelo, marca e características);

&#8211; Todos os hosts xen devem ter a mesma versão de software XenServer, bem como os mesmos hotfixes (updates) aplicados;

Já em um pool heterogêneo:

&#8211; As CPU&#8217;s de todos os hosts xen precisam ter somente os mesmos fabricantes (ex. AMD, Intel).

&#8211; As CPU&#8217;s de todos os hosts xen devem ter suporte à tecnologia Intel FlexMigration (em caso de CPU&#8217;s Intel) ou AMD Enhanced Migration (em caso de CPU&#8217;s AMD);

&#8211; Todos os hosts xen devem ter a mesma versão de software XenServer, bem como os mesmos hotfixes aplicados;

Você deve estar se perguntando qual tipo de pool utilizar, se homogêneo ou heterogêneo. O recomendável é usar CPU&#8217;s com o máximo de equivalência possível, assim, a compatibilidade é melhor aproveitada entre elas, possibilitando transtornos mínimos em processo migratórios que possam vir a calhar no ambiente. Isso reforça a ideia de hoje ainda não ser trivial uma total compatibilidade entre CPU&#8217;s distintas. Estas tecnologias supracitadas, como FlexMigration (Intel), nada mais são que &#8220;gambiarras tecnológicas&#8221; criadas afim de resolverem parte destes problemas. No futuro, eu espero que a informação em tornos das CPU&#8217;s seja totalmente abstrata (de forma nativa) para o sistema operacional, consequentemente para a compilação de aplicações e VM&#8217;s em ambientes virtualizados. Sem dúvida isso facilitará, e muito, o processo de realocação de serviços neste tipo de infra-estrutura, tão volátil que é.

Abaixo eu listo uma série de requisitos necessários (e obrigatórios) ao host xen para se criar um pool homogêneo.

&#8211; Ele não deve ser membro de um pool já existente;

&#8211; Ele não deve ter nenhum storage compartilhado configurado;

&#8211; Caso o pool já tenha sido criado e você queira adicionar um host ao mesmo, este host não deve ter nenhuma VM rodando ou em estado de suspensão ou nenhuma operação ativa em progresso na VM, como um desligamento, por exemplo;

Outros requisitos bem importantes, que também devem ser seguidos:

&#8211; Cheque se o serviço de tempo está sincronizado entre todos os hosts (use algum servidor NTP confiável, se possível);

&#8211; Não configure bond na interface de rede de gerência (se for fazer isso, faça após a criação do pool);

&#8211; Certifique-se que o ip de gerência do pool é estático (configurado manualmente ou &#8220;amarrando&#8221; por DHCP);

Passos para se criar um pool:

Abra o XenCenter e siga os passos abaixo:

1. Abra a caixa de diálogo &#8220;New Pool&#8221; e depois clique na toolbar &#8220;New Pool&#8221;.

2. Coloque um nome para o novo pool e uma descrição opcional e selecione o servidor que será o pool master. Adicione também o restante dos servidores que comporão o pool, através da lista de membros adicionais que aparecerá ou adicionando um novo membro através do botão &#8220;Add New Server&#8221;.

3. Clique em &#8220;Create Pool&#8221; para criar o pool e feche a caixa de diálogo

4. Pronto, pool criado!

Para adicionar um host a um pool já criado:

1. Clique com o botão direito em cima do pool e vá opção &#8220;Add Server&#8221;.

2. Na janela que abrirá, digite o ip do servidor e as credenciais do mesmo e clique em &#8220;Add&#8221;.

3. Pronto, servidor adicionado!

Informação adicional:

A Citrix recomenda que você tenha um storage compartilhado em mãos antes de criar um pool, pois este é um pré-requisito para você poder utilizar a maioria dos recursos (além de outros) que citei no início do artigo.

Referências:

<a href="http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-pools/xs-xc-pools-about.html" target="_blank">http://docs.citrix.com/en-us/xencenter/6-5/xs-xc-pools/xs-xc-pools-about.html</a>

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#hosts_and_pools" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/reference.html#hosts_and_pools</a>

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
