---
title: Secure Message
layout: page
permalink: "/contato"
comments: false
---

<div class="row justify-content-between">
<div class="col-md-8 pr-5">

Me envie uma mensagem segura, usando minha chave Pública PGP. <br>
Digite a mensagem abaixo e clique em <b>Encrypt</b>.  <br>
	Após isso, copie o texto gerado e me envie por <a href="mailto:marlluslustosa@riseup.net">e-mail</a>, <a href="https://t.me/lulusto"  target="_blank"> telegram</a>, <a href="https://instagram.com/ganartedigital"  target="_blank">instagram</a> ou qualquer outra comunicação textual. <br>
	Somente <b>eu</b> conseguirei abrir a mensagem.
	
<p><textarea id="input" class="contact-form" style="width: 300px; height: 140px;"></textarea><br>
<button id="button" class="btn btn-warning">Encrypt</button> <button id="button" class="btn btn-warning" onclick="copy()">Copy</button>
	
	<p>A cifragem acima foi realizada através da biblioteca <a href="https://openpgpjs.org/">OpenPGP.js</a>, mantida pelo <a href="https://protonmail.com/blog/openpgpjs-3-release/">ProtonMail</a>.
		
<script>
	function copy() {
  let textarea = document.getElementById("input");
  textarea.select();
  document.execCommand("copy");
}
	</script>
	
	
<script src="{{ site.baseurl }}/assets/js/jquery.min.js"></script>
	<script src="{{ site.baseurl }}/assets/js/openpgp.min.js"></script>
	<script src="{{ site.baseurl }}/assets/js/crypto.min.js"></script>
