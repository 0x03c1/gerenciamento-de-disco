# Relatório do laboratório — Gerenciamento de Disco: HDD, SSD SATA e NVMe

**Sala nº:** ___

| | Integrante 1 | Integrante 2 |
| --- | --- | --- |
| Nome | | |
| Sistema operacional | | |
| Tipo de disco (HDD, SSD SATA ou NVMe) | | |
| Modelo do disco | | |
| Ferramenta usada (fio, CrystalDiskMark, WSL) | | |

## Passo 1 — Os dois testes

| Teste | Integrante | IOPS | Throughput (MB/s) | Latência média (com unidade) |
| --- | --- | --- | --- | --- |
| A — Sequencial 1 MB | 1 | | | |
| B — Aleatório 4 KB | 1 | | | |
| A — Sequencial 1 MB | 2 | | | |
| B — Aleatório 4 KB | 2 | | | |

**Pergunta 1.** Quantas vezes o throughput do teste A é maior que o do B? Quantas vezes o IOPS do B é maior que o do A? Qual era a resposta certa da enquete?

> 

**Conferência.** Escolham um teste e verifiquem: throughput ≈ IOPS × tamanho do bloco.

> ______ IOPS × ______ = ______ MB/s (medido: ______ MB/s)

## Passo 2 — O efeito das filas

| Integrante | IOPS com `iodepth=1` | IOPS com `iodepth=32` | Quantas vezes maior |
| --- | --- | --- | --- |
| 1 | | | |
| 2 | | | |

**Pergunta 2.** O IOPS mudou muito? Por quê?

> 

## Passo 3 — A armadilha do cache

| Integrante | Throughput com `--direct=1` (do passo 1) | Throughput sem `--direct=1` (2ª rodada) |
| --- | --- | --- |
| 1 | | |
| 2 | | |

**Pergunta 3.** O número explodiu? O que vocês mediram de verdade?

> 

## Passo 4 — Desafio

| Aplicação | Métrica que decide | Disco escolhido | Número que justifica |
| --- | --- | --- | --- |
| A) Servidor de vídeo 4K (arquivos de 50 GB) | | | |
| B) Banco de transações (milhares de leituras de 4 KB/s) | | | |

**Pergunta 4.** Justifiquem as duas escolhas em até quatro linhas, usando os números medidos.

> 

## Para o debate

A frase que a dupla vai dizer na sala principal (1 minuto):

> 
