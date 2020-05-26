---
title: "Criando VMs (Máquinas Virtuais) no XenServer 6.5"
author: marllus
categories: [ tecnologia ]
layout: post
image: assets/images/criando-vms.jpeg
image-ref: Photo by <a href="https://unsplash.com/@noah_n" target=_blank>Noah Negishi</a>

---

Hoje, guiarei você no processo de criação de uma máquina virtual no Xenserver. Para isso, utilizaremos o XenCenter. Vamos lá.

Abra o Xencenter, selecione o pool ou XenServer onde você quer que a VM seja criada e vá no menu &#8220;VM&#8221; e clique em &#8220;New VM&#8221;.

Após isso, quando abrir a janela do &#8220;New VM Wizard&#8221;, aparecerá uma opção para você escolher na lista um template disponível. Escolha um template referente ao sistema operacional que você instalará e clique em &#8220;Next&#8221;. Para saber mais sobre templates, clique **AQUI**.

Após isso, digite um nome e descrição para a VM e clique em &#8220;Next&#8221;.

ex:

Nome: GNU/Linux Ubuntu Banco Producao

Descrição: VM Linux ubuntu referente ao banco de produção da filial bla bla bla

Agora, especifique qual mídia de instalação usará no processo. Você pode especificar um servidor NFS de rede com a ISO, usar o drive de CD/DVD do servidor físico, instalar através da URL (nfs, ftp, http) ou usar boot de rede (<a href="http://www.howtogeek.com/57601/what-is-network-booting-pxe-and-how-can-you-use-it/" target="_blank">PXE network boot</a>).

Ao final, clique em &#8220;Next&#8221;.

Na próxima etapa, você pode nomear um servidor físico à VM. Este servidor é que liberará os recursos de hardware (ram, network e CPU) necessários ao funcionamento desta. Esse passo é opcional quando você tem um pool, pois no final da criação o xenserver vai eleger um servidor ativo com recursos (hardware) disponíveis para subir a VM. Se você estiver criando a VM em um servidor específico, selecione o servidor e clique em &#8220;Next&#8221;. Caso queria deixar a escolha aleatória (pelo próprio Hypervisor), não marque nenhum servidor e clique em &#8220;Next&#8221;.

Nesta etapa, selecione a quantidade de CPUs virtuais (vCPUs) e a quantidade de memória RAM da mesma. A partir da versão 6.5 o XenServer disponibilidade agora, de forma intuitiva, a possibilidade de você configurar a topologia das vCPUs, como a escolha de quantos cores por socket a VM terá. Lógico, sempre respeitando o limite físico disponível, sob pena de perca de performance da VM.

ex. 2 vCPUs com topologia 2 cores e um socket.

4 vCPUs com topologia 4 cores e 2 sockets ou 4 cores e 1 socket.

Fica seu critério.

Na próxima etapa, você irá realizar a configuração dos discos virtuais que a VM terá. Crie o(s) disco(s) e clique em &#8220;Next&#8221;.

O último passo é configurar as placas de rede da VM. Por, padrão o xenserver já adicionará toda as placas disponíveis à VM. Você pode desvincular todas elas e deixar só a placa referente ao dhcp da sua rede, por exemplo. Pode realizar a customização do endereço MAC e definir QoS.

Então, complete a configuração da VM definindo no campo de seleção abaixo se a mesma iniciará automaticamente após criada.

Em alguns instantes (geralmente na espera de criação dos vdisks) a VM estará criada e prontinha para uso.

Existem outros métodos usados para criação de VMs. Eles também são descritos na documentação oficial da Citrix, neste link: <a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_overview" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_overview</a>

É isso!

Referências:

<a href="http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_overview" target="_blank">http://docs.vmd.citrix.com/XenServer/6.5.0/1.0/en_gb/guest.html#creatingVMs_overview<br /> </a><a href="http://www.howtogeek.com/57601/what-is-network-booting-pxe-and-how-can-you-use-it/" target="_blank">http://www.howtogeek.com/57601/what-is-network-booting-pxe-and-how-can-you-use-it/</a>

<p style="text-align: center;">
  <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license"><img style="border-width: 0;" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="Licença Creative Commons" /></a><br /> Este trabalho de <a href="http://ports.marllus.com">Marllus</a>, está licenciado com uma Licença <a href="http://creativecommons.org/licenses/by-sa/4.0/" rel="license">Creative Commons &#8211; Atribuição-CompartilhaIgual 4.0 Internacional</a>.
</p>
