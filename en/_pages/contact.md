---
title: Secure Message
layout: page
permalink: "/en/contact"
comments: false
---

<div class="row justify-content-between">
<div class="col-md-8 pr-5">

Send me a secure message using my <a href="https://memoria.rnp.br/keyserver/pks/lookup?op=get&search=0xBF2347A4E389C83D" target="_blank">PGP Public Key</a>.<br>
Type the message below and click <b>Encrypt</b>.<br>
After that, copy the generated text and send it to me by <a href="mailto:marlluslustosa@riseup.net">e-mail</a>, <a href="https://t.me/lulusto"  target="_blank"> telegram</a>, <a href="https://instagram.com/ganartedigital"  target="_blank">instagram</a>, <a href="{{ site.baseurl }}/{{page.lang}}/directmsg" target="_blank">anonymously</a> or any other form of textual communication.<br>
Only <b>i</b> will be able to open the message.

<p><textarea id="input" class="contact-form" style="width: 300px; height: 140px;"></textarea><br>
<button id="button" class="btn btn-warning">Encrypt</button> <button id="button" class="btn btn-warning" onclick="copy()">Copy</button>

    <p>The above encryption was performed through the library <a href="https://openpgpjs.org/">OpenPGP.js</a>, maintained by <a href="https://protonmail.com/blog/openpgpjs-3-release/">ProtonMail</a>.

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
