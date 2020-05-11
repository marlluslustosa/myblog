---
title: Secure Message
layout: page
permalink: "/contato"
comments: false
---

<div class="row justify-content-between">
<div class="col-md-8 pr-5">

Me envie uma mensagem segura, usando minha chave Pública PGP (Pretty Good Privacy). <br>
Digite a mensagem abaixo e clique em <b>Encrypt</b>.  <br>
Após isso, copie o texto gerado e me envie por E-mail, Telegram, Instagram ou qualquer outro chat de rede social. <br>
	Somente <b>eu</b> conseguirei abrir a mensagem.
	
<p><textarea id="input" class="contact-form" style="width: 300px; height: 140px;"></textarea><br>
<button id="button" class="btn btn-warning">Encrypt</button> <button id="button" class="btn btn-warning" onclick="copy()" data-clipboard-target="#input">Copy</button>
	
	<p>A cifragem acima foi feita através da biblioteca <a href="https://openpgpjs.org/">OpenPGP.js</a>, criada e utilizada pelo <a href="https://protonmail.com/blog/openpgpjs-3-release/">ProtonMail</a>.
		
<script>
	function copy() {
  let textarea = document.getElementById("input");
  textarea.select();
  document.execCommand("copy");
}
	</script>
	
	<script src="{{ site.baseurl }}/assets/js/clipboard.min.js"></script>
	
<script src="{{ site.baseurl }}/assets/js/jquery.min.js"></script>
	<script src="{{ site.baseurl }}/assets/js/openpgp.min.js"></script>
	<script src="{{ site.baseurl }}/assets/js/crypto.min.js"></script>
