---
layout: post
image: assets/images/linux_lapidacao.jpg
image-ref: Lapidando sistemas
title: Aumentando performance em servidor GNU/Linux para ambiente de containers
  (K8s, Swarm, Nomad)
author: marllus
date: 2025-11-10 17:35:08
categories: tecnologia
tags:
  - linux
  - performance
---
Ao provisionar um novo cluster de orquestração, seja Docker Swarm, Kubernetes ou Nomad, a expectativa é de alta performance. No entanto, é comum que, após a implantação, os nós (nodes) apresentem gargalos inexplicáveis, baixa taxa de I/O e alta latência, mesmo com hardware robusto.

A problemática é que uma instalação padrão do GNU/Linux não é otimizada para cargas de trabalho de containers.

O kernel padrão é configurado para um equilíbrio entre desktops e servidores, não para a alta rotatividade de pacotes de rede, escritas de log e operações de I/O em camadas de imagens que um orquestrador exige.

A boa notícia é que podemos usar o `cloud-init` para criar um "template de ouro" (*golden image*), aplicando um conjunto de otimizações de performance no *primeiro boot* da máquina.

Este post detalha procedimentos para extrair o máximo de desempenho de máquinas virtualizadas. Além do cloud-config, também forneço um script shell para aplicar as mesmas otimizações em uma máquina já instalada.

### O Perigo das "Otimizações" em Ambientes Virtuais

Antes de apresentar a receita, uma lição crucial que aprendi ao longo desse processo foi: **nem toda otimização é universal.**

Em testes em um ambiente virtualizado (XCP-ng), descobri que as "otimizações de I/O" mais comuns encontradas na internet, como:

1. Ajustar `vm.dirty_ratio` e `vm.dirty_background_ratio` (cache de escrita).
2. Forçar `noatime` no `/etc/fstab` via `sed`.
3. Forçar um I/O scheduler (`mq-deadline`) via regras `udev`.

...causaram um colapso catastrófico de performance. O I/O do sistema caiu de \~2100 transações/s para \~127 transações/s.

O que eu tirei disso foi que, em ambientes virtualizados, o hipervisor (Dom0 - no caso Xen) já está gerenciando o I/O. Então, algumas otimizações de I/O dentro da VM (guest DomU) conflita com o host e destrói a performance. A melhor otimização de I/O é deixar o kernel padrão fazer o seu trabalho, na maioria das vezes.

Mas, na tentativa de analisar mais profundamente o cerne da performance em sistemas operacionais *cloud-native* - como na maioria do casos -, decidi estudar e tomar como referência alguns livros, que me ajudaram muito por sinal:

!\[[Livros_performance.png]]

- - -

### Configuração top performance

Com base nas recomendações do materiais consultados, todas as otimizações que comprovadamente funcionaram foram: **Rede, Memória e CPU.**
Esse post focará em RAM e CPU.

O `cloud-config` abaixo aplica o seguinte:

* **Rede:** Habilita `BBR` + `FQ` para controle de congestionamento, aumenta os buffers de TCP e os limites de `conntrack`.
    
* **Memória:** Ajusta `vm.swappiness` para `0` (evita swap agressivamente) e desabilita `Transparent Huge Pages (THP)` (que causa latência em DBs e containers).
    
* **CPU:** Desabilita C-states profundos (`intel_idle.max_cstate=1`) via GRUB para eliminar a latência de "despertar" da CPU.
    
* **Docker:** Instala o Docker pelo método oficial e configura o `daemon.json` para `overlay2` e logging rotativo (evitando sobrecarga de disco).
    

- - -

### Método 1: O `cloud-config` (Para Provisionamento)

Use este código no campo "user-data" ao criar uma nova VM. Ele é 100% automatizado.

YAML

```
#cloud-config
#
# #####################################################################
# ## CLOUD-CONFIG: PERFORMANCE DE NÓ (DOCKER/K8S/SWARM)
# ## Foco: Rede, Memória e CPU (Otimizações de I/O removidas)
# ## Autor: Marllus Lustosa (Baseado em testes de performance)
# #####################################################################
#

# ---
# FASE 1: Escrita de Arquivos de Configuração
# ---
write_files:
  
  # 1.1 Otimizações de Kernel (Rede, Memória, FS)
  # O coração do tuning. Aumenta buffers, habilita BBR,
  # otimiza o uso de swap e define limites de arquivos.
  - path: /etc/sysctl.d/99-docker-performance.conf
    permissions: '0644'
    content: |
      # === Tuning de Rede (BBR + Buffers) ===
      net.core.default_qdisc = fq
      net.ipv4.tcp_congestion_control = bbr
      
      # Aumenta buffers de rede para links de alta velocidade (10GbE+)
      net.core.rmem_max = 16777216
      net.core.wmem_max = 16777216
      net.core.rmem_default = 1048576
      net.core.wmem_default = 1048576
      net.ipv4.tcp_rmem = 4096 87380 16777216
      net.ipv4.tcp_wmem = 4096 65536 16777216
      
      # Aumenta filas de backlog para picos de tráfego
      net.core.netdev_max_backlog = 30000
      net.core.somaxconn = 8192
      net.ipv4.tcp_max_syn_backlog = 8192
      
      # Reuso rápido de sockets
      net.ipv4.tcp_tw_reuse = 1
      net.ipv4.tcp_fastopen = 3
      net.ipv4.tcp_slow_start_after_idle = 0
      
      # === Tuning de Memória (v5) ===
      # vm.swappiness=0: Evita swap agressivamente
      vm.swappiness = 0
      # Mantém caches de FS (dentry/inode) por mais tempo
      vm.vfs_cache_pressure = 50
      
      # === Tuning de FS e Sistema ===
      fs.inotify.max_user_watches = 524288
      fs.inotify.max_user_instances = 512
      fs.file-max = 2097152
      
      # === Requisitos de Rede do Docker/K8s ===
      net.ipv4.ip_forward = 1
      net.bridge.bridge-nf-call-iptables = 1
      net.bridge.bridge-nf-call-ip6tables = 1
      net.netfilter.nf_conntrack_max = 1048576

  # 1.2 Otimização do Daemon do Docker
  # Usa overlay2 e logging rotativo para evitar sobrecarga de disco
  - path: /etc/docker/daemon.json
    permissions: '0644'
    content: |
      {
        "storage-driver": "overlay2",
        "log-driver": "json-file",
        "log-opts": {
          "max-size": "10m",
          "max-file": "3"
        },
        "live-restore": true
      }

  # 1.3 Limites de Sistema (ulimits)
  # Aumenta limites de arquivos abertos (nofile) e processos (nproc)
  - path: /etc/security/limits.d/99-docker-limits.conf
    permissions: '0644'
    content: |
      * soft nofile 1048576
      * hard nofile 1048576
      * soft nproc 1048576
      * hard nproc 1048576

  # 1.4 Módulos do Kernel
  # Garante que módulos essenciais sejam carregados no boot
  - path: /etc/modules-load.d/docker-performance.conf
    permissions: '0644'
    content: |
      br_netfilter
      overlay
      tcp_bbr
      nf_conntrack

  # 1.5 Desabilitar Transparent Huge Pages (THP)
  # THP pode causar picos de latência em workloads de DB/containers
  - path: /etc/rc.local
    permissions: '0755'
    content: |
      #!/bin/bash
      # Desabilita Transparent Huge Pages (THP)
      echo never > /sys/kernel/mm/transparent_hugepage/enabled
      echo never > /sys/kernel/mm/transparent_hugepage/defrag
      exit 0

# ---
# FASE 2: Atualizações e Pacotes
# ---
package_update: true
package_upgrade: true
packages:
  # Pacotes de Monitoramento e Performance
  - htop
  - iotop
  - pcp  # Substituto moderno do dstat
  - atop
  - iperf3
  - ethtool
  - linux-cpupower
  - bpfcc-tools
  - bpftrace
  - linux-headers-amd64
  # Pré-requisitos para instalação do Docker
  - curl
  - gnupg
  - ca-certificates
  # Pacotes utilitários
  - iptables
  - psmisc
  - screen

# Configurar APT
apt:
  preserve_sources_list: false
  sources_list: |
    deb http://deb.debian.org/debian trixie main
    deb http://security.debian.org/debian-security trixie-security main
    deb http://deb.debian.org/debian trixie-updates main

# ---
# FASE 3: Comandos de Configuração
# ---
runcmd:
  # 3.1 Aplicar Módulos e Sysctl
  - modprobe overlay
  - modprobe br_netfilter
  - modprobe tcp_bbr
  - sysctl --system
  
  # 3.2 Otimização de C-State (Latência de CPU) no GRUB
  # Reduz latência de "despertar" da CPU em ambientes virtualizados
  - sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="intel_idle.max_cstate=1 processor.max_cstate=1 /' /etc/default/grub
  - update-grub
  
  # 3.3 Desabilitar serviços desnecessários
  - systemctl disable --now bluetooth.service cups.service ModemManager.service avahi-daemon.service smartd.service irqbalance.service
  
  # 3.4 Habilitar rc.local (para desabilitar THP)
  - systemctl enable rc-local.service
  - systemctl start rc-local.service

  # 3.5 Instalação do Docker (Método Oficial)
  - |
      echo "=== Instalando Docker Engine (Método Oficial) ==="
      apt-get update
      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
      chmod a+r /etc/apt/keyrings/docker.asc
      
      echo "Types: deb" > /etc/apt/sources.list.d/docker.sources
      echo "URIs: https://download.docker.com/linux/debian" >> /etc/apt/sources.list.d/docker.sources
      echo "Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")" >> /etc/apt/sources.list.d/docker.sources
      echo "Components: stable" >> /etc/apt/sources.list.d/docker.sources
      echo "Signed-By: /etc/apt/keyrings/docker.asc" >> /etc/apt/sources.list.d/docker.sources
      
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - systemctl enable --now docker

# ---
# FASE 4: Finalização
# ---
final_message: "CloudInit concluído em $UPTIME segundos. Nó de performance pronto."
power_state:
  mode: reboot
  message: "Reiniciando para aplicar configurações de kernel (GRUB)"
  timeout: 15
  condition: true
```

- - -

### Método 2: O Script Shell (Para VMs Existentes)

Se você já tem um Debian 13 instalado, baixe [esse script](https://github.com/marlluslustosa/tunning-performance-linux/blob/main/tune_node.sh) na máquina local, dê permissão (`chmod +x tune_node.sh`) e execute-o (`sudo ./tune_node.sh`).

- - -

### Teste de validação

Como forma de validar o tunning, criei um script de teste de stress e analisei o relatório gerado.

#### 1. Script de Teste de Stress

[Esse script](https://github.com/marlluslustosa/tunning-performance-linux/blob/main/stress_test.sh) ataca a CPU, Memória e I/O simultaneamente. Salve como `stress_test.sh`. (Pré-requisitos: `fio`, `sysbench`, `sysstat`, `stress-ng`).

Execute o script em duas VMs, uma com os patches de performance aplicados e outra sem eles, para realizar uma análise comparativa.

#### 2. Gerando o Relatório

Após gerar os dois arquivos relatórios (como arquivos .sar), [baixe esse script python](https://github.com/marlluslustosa/tunning-performance-linux/blob/main/sar_visualize.py) para gerar o relatório com o gráficos. E então execute, considerando como parâmetro de entrada os dois relatórios:

`python sar_visualize.py vm1_report.sar vm2_report.sar`

- - -

### Estudo de caso real

Os resultados abaixo são frutos de um teste que realizei em ambiente de virtualização, comparando uma VM2 "Base" (Debian 13 padrão) com a VM1 "Otimizada" (usando o script acima).

Configurações das máquinas:

* Debian 13 - Trixie
* RAM: 8GB
* vCPU: 4

![Séries temporais - Comparação de performance]( "Séries temporais - Comparação de performance")

Além disso, seguem as estatísticas resumidas também geradas pelo script, para as métricas analisadas (Utilização de CPU (usuário e sistema), Memória utilizada, Swap utilizada, Entrada/Saída em transações por segundo), utilizando a média como indicador de tendência central.

```
ESTATÍSTICAS RESUMIDAS  
================================================================================  
  
CPU_User:  
 VM1: Média=93.10, Max=100.00, Min=0.04  
 VM2: Média=88.64, Max=100.00, Min=0.00  
 Diferença Média: 4.45  
  
CPU_System:  
 VM1: Média=5.25, Max=23.21, Min=0.00  
 VM2: Média=3.45, Max=22.19, Min=0.00  
 Diferença Média: 1.79  
  
Memory_Used:  
 VM1: Média=8.24, Max=10.41, Min=1.98  
 VM2: Média=7.55, Max=10.77, Min=1.56  
 Diferença Média: 0.69  
  
Swap_Used:  
 VM1: Média=1.19, Max=44.10, Min=0.00  
 VM2: Média=9.80, Max=75.41, Min=0.00  
 Diferença Média: -8.62  
  
IO_TPS:  
 VM1: Média=1902.34, Max=16533.66, Min=0.00  
 VM2: Média=1563.17, Max=18947.00, Min=0.00  
 Diferença Média: 339.18  
  
Concluído. Gráfico salvo em 'series_temporais_comparacao.png'
```

Os gráficos anteriores mostraram as séries temporais, mas essas séries utilizam a média como medida de tendência central. Ocorre que a média nem sempre representa bem um conjunto de dados, especialmente quando a distribuição não é uniforme ou quando há valores muito altos ou muito baixos que puxam o resultado. Como aponta Brendan Gregg (Systems Performance, 2020), a forma da distribuição dos dados importa. Quando analisamos os gráficos de boxplot, podemos observar se os dados apresentam uma distribuição simétrica, deslocada ou até multimodal (com dois ou mais pontos onde os valores se concentram). Nesses casos, a média pode acabar posicionada em uma região onde quase não há dados. Ou seja, a média *parece representar o centro*, mas na prática não representa aquilo que realmente ocorre na maior parte do tempo.

Por isso, a mediana frequentemente é uma medida melhor para indicar o valor típico da métrica. A mediana é resistente a valores extremos: se acontecer um pico isolado de CPU ou I/O, a média sobe, porém a mediana permanece indicando o comportamento real da maior parte do período. Assim, quando a distribuição é muito irregular, a mediana se torna mais fiel que a média. 

Para avaliar isso de maneira objetiva, eu [desenvolvi um script](https://github.com/marlluslustosa/tunning-performance-linux/blob/main/CV_metric_final.py) que calcula o Coeficiente de Variação (CV) das métricas coletadas. Esse indicador mostra o quanto os valores flutuam em relação à média. Quando o CV é alto, isso é um sinal claro de que há oscilações ou picos, e nesses casos a mediana é um melhor indicador para interpretar o desempenho real da métrica analisada. A execução no ambiente produz o seguinte resultado comparativo por métrica:

\=== VM1 ===\
CPU_User    : Média=93.10 | Mediana=96.25 | Desvio=12.34 | CV=0.133\
  → Baixa variação → **Use Média**\
CPU_System  : Média=5.25 | Mediana=3.37 | Desvio=5.72 | CV=1.090\
  → Alta variação → **Use Mediana**\
Mem_Used    : Média=8.24 | Mediana=8.82 | Desvio=1.50 | CV=0.182\
  → Baixa variação → **Use Média**\
Swap_Used   : Média=1.19 | Mediana=0.17 | Desvio=5.88 | CV=4.961\
  → Alta variação → **Use Mediana**\
IO_TPS      : Média=1902.34 | Mediana=45.50 | Desvio=3530.65 | CV=1.856\
  → Alta variação → **Use Mediana**  

\=== VM2 ===\
CPU_User    : Média=88.64 | Mediana=97.27 | Desvio=25.78 | CV=0.291\
  → Baixa variação → **Use Média**\
CPU_System  : Média=3.45 | Mediana=2.01 | Desvio=4.33 | CV=1.254\
  → Alta variação → **Use Mediana**\
Mem_Used    : Média=7.55 | Mediana=8.14 | Desvio=2.06 | CV=0.272\
  → Baixa variação → **Use Média**\
Swap_Used   : Média=9.80 | Mediana=0.41 | Desvio=17.23 | CV=1.757\
  → Alta variação → **Use Mediana**\
IO_TPS      : Média=1563.17 | Mediana=448.00 | Desvio=3242.19 | CV=2.074\
  → Alta variação → **Use Mediana**  

Interpretação do CV:\
 CV <= 0.30  → Média representa bem (baixa variação)\
 CV >  1.00  → Mediana é mais confiável (muita oscilação / picos)

Quando o Coeficiente de Variação (CV) ultrapassa 1, isso significa que a dispersão dos dados é tão grande que a média deixa de ser um indicador confiável do comportamento real. Nesse caso, quem melhor representa o valor típico é a mediana. No presente conjunto de testes, os picos que justificam essa substituição ocorreram principalmente nas métricas IO_TPS e Swap_Used, que sofreram oscilações intensas durante o estresse, podendo distorcer a interpretação se apenas olharmos a média.

Com isso em mente, adaptei uma função em Python no script principal do relatório para gerar automaticamente os boxplots que mostram a distribuição das medições ([você pode baixá-lo aqui](https://github.com/marlluslustosa/tunning-performance-linux/blob/main/sar_visualize_boxsplot.py)). Esses gráficos representam visualmente como os valores se espalham ao longo do tempo e ajudam na comparação direta entre a VM1 e a VM2 durante a carga. A “caixa” (box) corresponde aos 50% centrais das medições (entre o 1º e o 3º quartil), ou seja, o comportamento considerado mais frequente. O topo da caixa (3º quartil) indica o limite superior desse comportamento típico antes de entrarmos nos valores extremos.

Então os gráficos:

{% include image.html url="assets/images/dist_io_tps_boxplot.png" description="Boxsplot IO - TPS." %}

{% include image.html url="assets/images/dist_swap_used_boxplot.png" description="Boxsplot Swap." %}

<br>Ao observarmos as distribuições das métricas por meio dos gráficos de boxplot, ficou evidente que algumas delas apresentaram grande variação durante o teste de estresse. 

No caso do IO_TPS, o boxplot mostra que a VM1 opera rotineiramente em níveis de IO bem mais altos: o topo da caixa está aproximadamente em \~2.200 TPS, enquanto na VM2 isso ocorre em torno de \~1.250 TPS. Mesmo desconsiderando picos, a faixa operacional normal da VM1 foi consistentemente superior. Já no gráfico de Swap_Used, observa-se uma diferença ainda mais marcante: a VM1 praticamente não usa swap, com a caixa comprimida em zero; enquanto a VM2 apresenta uma caixa alta, indicando que usar swap faz parte de seu comportamento normal, com presença de outliers que alcançam valores extremos, reforçando que ela trabalha sob pressão constante de memória.

Apesar disso, quando comparamos diretamente os valores numéricos de média e mediana dessas duas métricas, observa-se que a diferença entre elas não é tão grande a ponto de inviabilizar o uso da média como indicador geral. Ou seja, na prática, mesmo em IO_TPS e Swap_Used, a média ainda representa bem a tendência central, já que ela segue próxima à mediana e descreve adequadamente o comportamento típico ao longo do teste.

- - -

### CPU_User (processamento feito pelas aplicações do usuário)

|               | VM1                                                 | VM2        |
| ------------- | --------------------------------------------------- | ---------- |
| **Média**     | **93.10%**                                          | **88.64%** |
| **Diferença** | +4.45% (VM1 usa mais CPU diretamente no user space) |            |

<br>A VM1 apresentou maior uso de CPU em modo usuário (93% contra 89%), indicando que ela passou mais tempo executando cálculos reais da aplicação em vez de tarefas de supervisão do sistema. Isso sugere que a VM1 aproveitou melhor o processador para trabalho útil, enquanto a VM2 gastou um pouco mais de tempo em atividades indiretas ou espera. Na prática, a VM1 conseguiu converter mais tempo de CPU em produtividade real durante o teste de estresse.

- - -

### CPU_System (tempo gasto no kernel: drivers, IO, scheduler)

|               | VM1                             | VM2   |
| ------------- | ------------------------------- | ----- |
| **Média**     | 5.25%                           | 3.45% |
| **Diferença** | VM1 +1.79% mais gasto no kernel |       |

<br>A VM1 gastou um pouco mais de tempo no kernel (5.25% vs 3.45%), o que é esperado, pois ela estava processando mais operações e, portanto, fez mais chamadas de sistema, interrupções e gerenciamento de I/O. Esse valor ainda permanece dentro do normal para carga elevada e não indica problema. Em resumo, a VM1 chamou mais o kernel porque estava trabalhando mais, e não porque havia sobrecarga ou ineficiência.

- - -

### Memory_Used (uso de memória RAM)

|               | VM1                    | VM2     |
| ------------- | ---------------------- | ------- |
| **Média**     | 8.24 GB                | 7.55 GB |
| **Diferença** | VM1 usa ~0.7 GB a mais |         |

<br>O uso médio de RAM foi semelhante entre as máquinas, mas a VM1 utilizou cerca de 0.7 GB a mais, o que provavelmente significa que ela conseguiu manter mais dados úteis em cache durante o processamento. Isso é positivo: mais RAM efetivamente utilizada para trabalho significa menos ida ao disco e menor latência. Portanto, a VM1 estava aproveitando melhor a memória disponível, sem sinais de saturação.

- - -

### Swap_Used (uso de Swap)

|               | VM1                                                | VM2         |
| ------------- | -------------------------------------------------- | ----------- |
| **Média**     | **1.19 GB**                                        | **9.80 GB** |
| **Diferença** | VM2 usa **8.6 GB a mais de Swap** (isso é péssimo) |             |

<br>Aqui há uma diferença crítica: enquanto a VM1 praticamente não dependeu de swap (1.19 GB), a VM2 consumiu quase 10 GB, o que é um forte indicativo de que sua RAM efetiva não foi suficiente. Quando o sistema começa a usar swap intensivamente, a performance degrada porque o acesso ao disco é muito mais lento que o acesso à RAM. Por isso, a VM2 sofreu travamentos, maior latência e perda de desempenho. Ou seja, a VM2 estava visivelmente sob pressão de memória durante o teste.

- - -

### IO_TPS (operações por segundo de I/O)

|               | VM1                          | VM2         |
| ------------- | ---------------------------- | ----------- |
| **Média**     | **1902.34**                  | **1563.17** |
| **Diferença** | VM1 é ~339 ops/s mais rápida |             |

<br>A VM1 manteve um throughput de I/O mais consistente (1902 ops/s vs 1563 ops/s), o que significa que ela conseguiu realizar mais operações por segundo de forma estável. Mesmo que a VM2 tenha registrado picos maiores, esses foram momentâneos e não sustentados, o que indica instabilidade. Como o desempenho de I/O é fortemente afetado pelo uso de swap, é coerente que a VM1, com menos swap, tenha apresentado I/O mais rápido e estável.

- - -

## Síntese Geral

| Métrica        | Melhor             | Por quê                                        |
| -------------- | ------------------ | ---------------------------------------------- |
| CPU uso útil   | **VM1**            | Mais tempo executando trabalho real            |
| CPU sistema    | **Empate prático** | Diferenças normais de carga                    |
| Memória RAM    | **VM1**            | Está processando mais sem estourar             |
| Swap           | **VM1** (de longe) | VM2 está "engasgando" por falta de RAM efetiva |
| I/O Sustentado | **VM1**            | Menos swap → menos latência → mais TPS         |

- - -

### Conclusão

Otimizar um nó de container não é sobre aplicar todas as “dicas de performance” que aparecem por aí. Como demonstrado, algumas configurações populares de I/O simplesmente não fazem sentido em ambientes virtualizados e podem até piorar o throughput e a latência sob carga. A análise comparativa mostrou que o verdadeiro ganho está em ajustar os pontos estruturais: a pilha de rede com BBR para melhorar congestionamento e latência, as políticas de gerenciamento de memória com Swappiness e Transparent Huge Pages para evitar uso excessivo de swap, e os C-States para manter a CPU responsiva e estável em cargas variáveis.

Em resumo, não se trata de “otimizar tudo”, e sim de otimizar o que importa. Ajustando rede, memória e CPU da forma correta, o cluster passa a entregar mais desempenho, mais estabilidade e mais previsibilidade, garantindo que você esteja realmente extraindo 100% do hardware pelo qual está pagando.

Este tutorial também serviu como um exercício pedagógico, para mostrar como interpretar métricas de uso de recursos e por quê de, em muitos casos, a média não ser o indicador mais confiável de tendência. Em distribuições multimodais, ou quando há muitos picos extremos, a média pode "cair" em um ponto que não representa o comportamento real dos dados. Nesses cenários, a mediana (e a análise dos percentis por boxplots) traz uma visão mais fiel da realidade operacional. Entender isso é essencial para quem administra infraestrutura e depende de ferramentas de observabilidade para tomada de decisão.