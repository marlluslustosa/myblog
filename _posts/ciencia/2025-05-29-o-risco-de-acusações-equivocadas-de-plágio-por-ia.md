---
layout: post
image: assets/images/plagioia.jpg
image-ref: Cortesia <a href="https://chatgpt.com">ChatGPT</a>
title: O risco de acusações equivocadas de plágio por IA
author: marllus
date: 2025-05-28 23:39:08
categories: ciencia
id-ref: ia-plagio
tags:
  - ciencia
  - IA
  - maquina
  - plagio
---
Imagine receber uma acusação de plágio e descobrir que, na verdade, foi um algoritmo que se enganou. Em 2023, Ernesto Spinak publicou no blog Scielo “*[IA: Cómo detectar textos producidos por chatbox y sus plagios](https://blog.scielo.org/es/2023/11/17/ia-como-detectar-textos-producidos-por-chatbox-y-sus-plagios/)*”[](#sdendnote1sym) uma reflexão sobre como distinguimos textos humanos de textos gerados por inteligência artificial. Na mesma época, um grupo de pesquisadores publicou um artigo no periódico *International Journal for Educational Integrity*, intitulado “*[Testing of detection tools for AI-generated text](https://edintegrity.biomedcentral.com/articles/10.1007/s40979-023-00146-z)”*, colocando fogo na discussão ao testar 14 das ferramentas mais populares de detecção de IA.

Algumas abordagens de detecção de plágio por IA são comumentes citadas na [literatura](https://link.springer.com/chapter/10.1007/978-981-97-7423-4_13) — métodos baseados em linguagem, métodos baseados em estatística e métodos baseados em aprendizagem[](#sdendnote2sym). Spinak as listou em seu post, mas careceu de evidências empíricas robustas sobre a precisão das ferramentas que acoplam essas abordagens.

A pesquisa supracitada encontrou os seguintes resultados:

> “As ferramentas de detecção disponíveis **não são precisas nem confiáveis** e tendem a classificar textos gerados por IA como se tivessem sido escritos por humanos. Além disso, técnicas simples de ofuscação de conteúdo **pioram significativamente** seu desempenho.”[](#sdendnote3sym)

Vale destacar que falhas como falsos positivos e falsos negativos já foram documentadas em diversos outros estudos na literatura, reforçando a necessidade de cautela antes de tomar decisões unicamente amparadas por essas ferramentas.

Além disso, os casos reais desses tipos de erros em detecções de plágio por IA aumentam rapidamente. A [tese](https://www.mozillafoundation.org/pt-BR/blog/who-wrote-that-evaluating-tools-to-detect-ai-generated-text/) central: “*o texto gerado por IA simplesmente não é diferente o suficiente do texto gerado por humanos para ser capaz de diferenciá-los de forma consistente”*[](#sdendnote4sym)*.*

Esses achados acendem um alerta: estamos prontos para cobrar autores por suposto plágio quando a decisão parte de um sistema com viés e limitações claras?

##### **Por que a detecção falha: o problema da indução**

Para entender por que essas ferramentas se perdem, precisamos voltar ao século XVIII, quando David Hume questionou o fundamento da inferência indutiva: como podemos generalizar para toda uma categoria, a partir de alguns casos observados? No contexto das ferramentas de detecção de IA:

1. **Aprendizado indutivo**: algoritmos observam inúmeros exemplos de texto gerado por IA e humanos. A partir daí, inferem regras (por exemplo, “se o texto tiver perplexidade \[1][](#sdendnote5sym) X e repetição Y, provavelmente é de IA”).
2. **Limites da indução**: como Hume e mais tarde Popper apontaram, nenhuma quantidade de casos positivos prova universalmente uma regra; basta um único texto ofuscado (isto é, intencionalmente modificado) para derrubar a generalização.

Em outras palavras, cada técnica de ofuscação — trocar palavras por sinônimos, alterar a pontuação, inserir trechos aleatórios, mudar tonalidade da escrita — adiciona novas exceções à regra. E não há como testar infinitamente todos esses contornos.

##### **O motor do jogo de gato e rato**

Com o avanço da engenharia de prompt (*prompt engineering*[](#sdendnote6sym) \[2]), basta um comando simples para pedir ao ChatGPT: “*Reescreva este parágrafo de modo a não ser identificado como gerado por IA.”* Pronto: temos um novo exemplo que derruba a regra original. É o mesmo dilema descrito pelos positivistas lógicos de Viena e refutado por Popper: tentar verificar universalmente uma hipótese pela indução é uma briga sem fim.

##### **E agora? perguntas para refletir**

*Diante das reflexões finais de Spinak, principalmente sobre a autoria do conteúdo gerado por IA, adiciono outras:*

1. **Detectar IA ou avaliar qualidade?** Será que não faz mais sentido concentrar esforços em medir a originalidade e relevância do texto — seja humano ou artificial — do que em descobrir quem (ou o quê) o escreveu?
2. **Quem dá o veredito final?** Até que ponto podemos delegar à algoritmos a autoridade de julgar plágio ou criar políticas sobre uso de IA na escrita?
3. **Plágio de IA é plágio?** Se um pesquisador incorpora *insights* de um modelo de linguagem em seu próprio texto, isso configura plágio ou inovação colaborativa?

##### **Jogo do “quem é quem?”**

**Utilizando apenas sua intuição, responda nos comentários qual dos parágrafos abaixo foi escrito por IA.**

Em meio às ruínas do eu, o que resta do sujeito senão fragmentos dispersos por entre as ruínas conceituais? Marx arrancou as bases materiais, Freud escavou o inconsciente e Nietzsche incendiou as certezas, enquanto Heidegger questionava o próprio ser-no-mundo. No pós-guerra, os desconstrutores deram as cartas: Althusser revirou o marxismo, Lacan traduziu a mente em códigos cifrados e, pouco depois, Foucault, Derrida e Deleuze armaram labirintos de discurso onde o “eu” se perde e se remix. Hoje, a identidade se revela menos uma essência e mais um mosaico de vozes que ecoam na malha digital — um “sujeito” cuja existência depende de algoritmos tanto quanto de ideias. Será que ainda nos interessa manter esse fantasma de individualidade, ou já somos apenas polifonia de fragmentos sem dono?

A curiosa “certeza” de que o amanhã será como hoje anda de licença permanente desde que David Hume, todo desconfiado, apontou que não há justificativa lógica para acreditar que o sol voltará a nascer só porque nasceu ontem. Foi preciso que Kant chegasse, todo empolgado, e inventasse uma bagagem de “formas a priori” para manter o trem nos trilhos, mas logo a trupe dos positivistas logicamente radicais veio provar que nossas belas leis não passam de aglomerados de convenções linguísticas. No fim, Popper, com seu revólver de falsificações, encerrou o espetáculo: melhor atirar num palpite do que amarrar-se a promessas de previsões infalíveis. Então me digam, caros positivistas lógicos: como ainda depositam sua confiança na indução — esse artifício de acumular observações como se garantissem leis universais — quando, do ponto de vista científico, só a corajosa tentativa de falsificação nos aproxima de teorias verdadeiramente robustas, e insistir na indução é um convite à ilusão epistemológica?

**Para conferir o resultado, clique [aqui](https://chatgpt.com/share/681b6493-2334-8011-b802-950697d89a50).**

Após isso, avalie o texto a partir de ferramentas de detecção de plágio por IA, usando [ZeroGPT](https://www.zerogpt.com/) ou [undetectableAI](https://undetectable.ai/) e se surpreenda

**Notas explicativas:**

[](#sdendnote5anc)\[1] **Perplexidade:** termo originado da linguística computacional e adotado em aprendizado de máquina para descrever o grau de incerteza de um modelo de linguagem ao prever a próxima palavra de um texto. Modelos com perplexidade menor exibem previsões mais confiáveis e coerentes, enquanto valores altos indicam maior dificuldade em “adivinhar” termos em contextos variados.

[](#sdendnote6anc)\[2] **Engenharia de prompt:** abordagem que consiste em formular e ajustar instruções, exemplos ou perguntas de forma estratégica para direcionar o comportamento de modelos de IA, como ChatGPT. Dominar essa técnica permite obter saídas mais relevantes, precisas e alinhadas aos objetivos do usuário, minimizando ambiguidades e resultados indesejados.

**Referências:**

DALALAH, Doraid and DALALAH, Osama M. A., 2023. The false positives and false negatives of generative AI detection tools in education and academic research: The case of ChatGPT. *The International Journal of Management Education*. 1 July 2023. Vol. 21, no. 2, p. 100822. DOI [10.1016/j.ijme.2023.100822](https://doi.org/10.1016/j.ijme.2023.100822).

KHALIL, Mohammad and ER, Erkan, 2023. Will ChatGPT Get You Caught? Rethinking of Plagiarism Detection. In: ZAPHIRIS, Panayiotis and IOANNOU, Andri (eds.), *Learning and Collaboration Technologies*. Cham: Springer Nature Switzerland. 2023. p. 475–487. ISBN 978-3-031-34411-4. DOI [10.1007/978-3-031-34411-4_32](https://doi.org/10.1007/978-3-031-34411-4_32).

LIANG, Weixin, YUKSEKGONUL, Mert, MAO, Yining, WU, Eric and ZOU, James, 2023. GPT detectors are biased against non-native English writers. . Online. 2023. DOI [10.48550/ARXIV.2304.02819](https://doi.org/10.48550/ARXIV.2304.02819). \[Accessed 25 April 2024].

TIWARI, Shreeji, SHARMA, Rohit, SIKARWAR, Rishabh Singh, DUBEY, Ghanshyam Prasad, BAJPAI, Nidhi and SINGHATIYA, Smriti, 2024. Detecting AI Generated Content: A Study of Methods and Applications. In: KUMAR, Sandeep, HIRANWAL, Saroj, GARG, Ritu and PUROHIT, S. D. (eds.), *Proceedings of International Conference on Communication and Computational Technologies*. Singapore: Springer Nature. 2024. p. 161–176. ISBN 978-981-9774-23-4. DOI [10.1007/978-981-97-7423-4_13](https://doi.org/10.1007/978-981-97-7423-4_13).

Estudante falsamente acusado por detectores de IA - Undetectable AI - Blog, 2023. Online. Available from: <https://undetectable.ai/blog/br/estudante-falsamente-acusado-por-detectores-de-ia/>. \[Accessed 7 May 2025].

Descubra como se proteger contra falsas acusações de fraude de IA e defender sua integridade acadêmica. Available from: <https://www.estadao.com.br/link/cultura-digital/foi-acusado-de-trapacear-usando-ia-veja-o-que-fazer/>. \[Accessed 7 May 2025].

STYLINGIRL289, 2023. I was falsely accused of AI cheating and successfully appealed my case to the Department Chair at my school. Here’s how I did it. *r/college*. Online. 17 November 2023. Available from: <https://www.reddit.com/r/college/comments/17x954b/i_was_falsely_accused_of_ai_cheating_and/> \[Accessed 7 May 2025].

Uso do ChatGPT gera conflitos na sala de aula e acusações de plágio sem provas, \[no date]. Online. Available from: <https://www.aosfatos.org/noticias/chatgpt-alunos-professores-plagio/> \[Accessed 7 May 2025].