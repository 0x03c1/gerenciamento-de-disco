# Gerenciamento de Disco: HDD, SSD SATA e NVMe

Laboratório em duplas: medindo o seu disco com `fio`.

Atividade prática feita nas salas simultâneas (breakout rooms) do Zoom.
**Duração: 25 minutos. Formato: duplas.**

> **A pergunta do laboratório:** o mesmo disco, medido de duas formas, dá números muito
> diferentes. Qual número importa para cada aplicação?

---

## 1. O que vocês vão entregar

Ao fim dos 25 minutos, a dupla precisa ter:

- [ ] As **duas linhas da planilha da turma** preenchidas (uma por integrante) — link no chat do Zoom.
- [ ] O arquivo [`RELATORIO.md`](RELATORIO.md) preenchido, com as medições e as quatro respostas.
- [ ] Uma **escolha justificada** para o desafio (passo 4), pronta para defender em 1 minuto na sala principal.

## 2. Papéis da dupla

| Papel | O que faz |
| --- | --- |
| **Piloto** | Compartilha a tela na sala, roda os comandos e lê os números em voz alta |
| **Copiloto** | Anota no `RELATORIO.md` e na planilha, controla o tempo e faz a pergunta "o que esse número representa?" |

**Os papéis trocam no minuto 12** (o professor avisa nas salas). Se a sala tiver três pessoas, são dois Copilotos.

Quem não conseguiu instalar o `fio` ou está no celular fica de Copiloto o tempo todo e usa os números do colega: a análise é a mesma.

## 3. Antes de entrar na sala

1. Baixe este repositório:
   ```bash
   git clone https://github.com/0x03c1/gerenciamento-de-disco.git
   cd gerenciamento-de-disco
   ```
   (ou use **Code → Download ZIP** e abra a pasta no terminal)
2. Instale o `fio`:

   | Sistema | Comando |
   | --- | --- |
   | Linux (Debian/Ubuntu) | `sudo apt install fio` |
   | macOS | `brew install fio` |
   | Windows | veja [`docs/windows.md`](docs/windows.md) (CrystalDiskMark, fio para Windows ou WSL) |

3. Confira: `fio --version` deve mostrar um número de versão.
4. Tenha **1 GB livre** na pasta do repositório (o laboratório cria o arquivo `teste.fio`).

## 4. Cronograma dos 25 minutos

| Minuto | Passo | Script | O que anotar |
| --- | --- | --- | --- |
| 0 – 6 | **1.** Os dois testes | `./scripts/1_dois_testes.sh` | IOPS, throughput e latência de cada teste |
| 6 – 12 | **2.** O efeito das filas | `./scripts/2_iodepth.sh` | IOPS com 1 pedido e com 32 pedidos |
| 12 | **Troca de papéis** | — | — |
| 12 – 16 | **3.** A armadilha do cache | `./scripts/3_sem_direct.sh` | Throughput sem `--direct=1` |
| 16 – 23 | **4.** Desafio | — | A escolha da dupla e a justificativa |
| 23 – 25 | Fechar | `./scripts/limpar.sh` | Conferir planilha e relatório |

Cada teste dura 30 segundos. Enquanto ele roda, o Copiloto já prepara a tabela do relatório.

## 5. Passo a passo

### Passo 0 — Que disco eu tenho? (feito no início da aula)

```bash
./scripts/0_descobrir_disco.sh
```

Anote o tipo (HDD, SSD SATA ou NVMe) no relatório. Se ainda não fez, faça agora: leva 10 segundos.

### Passo 1 — Os dois testes (6 min)

```bash
./scripts/1_dois_testes.sh
```

O script roda o **mesmo disco** de duas formas:

| Teste | Tipo de leitura | Tamanho do bloco | Mede principalmente |
| --- | --- | --- | --- |
| A | Sequencial (dados vizinhos, um depois do outro) | 1 MB | **Throughput** (MB/s) |
| B | Aleatória (posições sorteadas) | 4 KB | **IOPS** (operações por segundo) |

**Anotem** IOPS, throughput e latência dos dois testes.

**Respondam (pergunta 1):** quantas vezes o throughput do teste A é maior que o do B? E quantas vezes o IOPS do B é maior que o do A? Qual era a resposta certa da enquete da aula?

### Passo 2 — O efeito das filas (6 min)

```bash
./scripts/2_iodepth.sh
```

Roda o teste aleatório de 4 KB duas vezes: com `--iodepth=1` (um pedido por vez) e com `--iodepth=32` (32 pedidos em andamento ao mesmo tempo).

**Respondam (pergunta 2):** o IOPS mudou muito? Por quê? Dica: pensem nas filas do NVMe (65.535 filas) contra a fila única do SATA (32 comandos), e no que acontece num HDD, que só tem um braço.

### — Minuto 12: troquem os papéis —

### Passo 3 — A armadilha do cache (4 min)

```bash
./scripts/3_sem_direct.sh
```

Roda o teste sequencial **sem** `--direct=1`, duas vezes seguidas.

**Respondam (pergunta 3):** o número explodiu? O que vocês mediram de verdade: o disco ou outra coisa?

### Passo 4 — Desafio (7 min)

A equipe de vocês precisa escolher o disco para **duas** aplicações:

- **A) Servidor de vídeo 4K** — arquivos de 50 GB, lidos do início ao fim.
- **B) Banco de transações** — milhares de leituras de 4 KB por segundo, espalhadas pelo disco.

**Respondam (pergunta 4):** qual métrica importa em cada caso? Dos discos medidos pela dupla (e pela turma, na planilha), qual vocês escolheriam para A e qual para B? **Justifiquem com os números de vocês**, não com os do slide.

### Fechar (2 min)

```bash
./scripts/limpar.sh
```

Apaga o arquivo `teste.fio` de 1 GB. Confiram se a planilha e o `RELATORIO.md` estão completos.

## 6. Como ler a saída do `fio`

O `fio` imprime muita coisa. Vocês só precisam de três números, que o script repete no **RESUMO** ao final de cada teste:

```text
read: IOPS=90.1k, BW=352MiB/s (369MB/s)
 lat (usec): min=95, max=4120, avg=354.60
```

| Onde olhar | O que é | O que representa |
| --- | --- | --- |
| `IOPS=` | Operações por segundo (`k` = mil) | Quantas "viagens" o disco faz. Importa para muitos arquivos pequenos |
| `BW=` | Throughput, em MB/s | Quanta "carga" passa. Importa para arquivos grandes |
| `lat ... avg=` | Latência média de uma operação | Quanto o usuário espera. Atenção à unidade: `usec` = microssegundo, `msec` = milissegundo |

A relação entre eles: **throughput ≈ IOPS × tamanho do bloco**. Confiram com os seus números.

## 7. O que cada opção do comando faz

Os scripts só montam estes comandos (abra-os, são curtos):

| Opção | O que faz |
| --- | --- |
| `--rw=read` / `--rw=randread` | Leitura sequencial / leitura em posições sorteadas |
| `--bs=1M` / `--bs=4k` | Tamanho de cada operação |
| `--size=1G` | Tamanho do arquivo de teste |
| `--direct=1` | Ignora o cache do sistema operacional: mede o disco, não a RAM |
| `--ioengine=libaio` (Linux) / `posixaio` (macOS) | Envio assíncrono de pedidos; sem isso o `--iodepth` não tem efeito |
| `--iodepth=32` | Mantém 32 pedidos em andamento ao mesmo tempo |
| `--runtime=30 --time_based` | Roda por 30 segundos exatos |

## 8. Regras e cuidados

- Os testes **só leem**: não há risco para os seus dados.
- Rode sempre **dentro da pasta do repositório**. Nunca aponte o `fio` para um dispositivo como `/dev/sda`.
- Feche programas pesados (jogos, downloads) durante os testes: eles disputam o disco e bagunçam os números.
- No **WSL** o disco é virtual: os números servem para comparar um teste com o outro, não como valor real do hardware. Escrevam isso no relatório.
- Números diferentes dos do slide são **normais**: cada disco é um disco. O que vale é a interpretação.
- Respostas com as próprias palavras. Copiar a frase do slide não conta.

## 9. Se algo der errado

| Problema | Solução |
| --- | --- |
| `fio: command not found` | Instale o `fio` (seção 3) ou vire Copiloto e use os números do colega |
| `Permission denied` ao rodar o script | `chmod +x scripts/*.sh` ou rode com `bash scripts/1_dois_testes.sh` |
| Disco sem 1 GB livre | `TAMANHO=256M ./scripts/1_dois_testes.sh` (use o mesmo valor em todos os passos) |
| O IOPS não muda entre `iodepth` 1 e 32 | Em HDD é esperado. Em SSD, confira se o comando mostrado tem `--ioengine` |
| No passo 3 o número não explodiu | Olhe a 2ª rodada; se ainda assim não, anote isso e pergunte ao professor |
| O tempo acabou antes do passo 4 | Pulem o passo 3 e façam o desafio: ele é a entrega principal |

## 10. Depois da sala: debate

De volta à sala principal, todas as duplas respondem no chat qual métrica decide cada caso do desafio, e duas duplas são chamadas para defender a escolha em 1 minuto, citando os próprios números. Em seguida vem o quiz.

## Estrutura do repositório

```text
.
├── README.md              este roteiro
├── RELATORIO.md           modelo que a dupla preenche
├── scripts/
│   ├── 0_descobrir_disco.sh   que disco eu tenho?
│   ├── 1_dois_testes.sh       passo 1: sequencial 1 MB e aleatório 4 KB
│   ├── 2_iodepth.sh           passo 2: 1 pedido contra 32 pedidos
│   ├── 3_sem_direct.sh        passo 3: sem --direct=1
│   ├── limpar.sh              apaga o arquivo de teste
│   └── comum.sh               funções usadas pelos outros scripts
└── docs/
    └── windows.md         como fazer no Windows
```

## Referências

- PATTERSON, D.; HENNESSY, J. *Organização e Projeto de Computadores*. Elsevier. Cap. 6.
- STALLINGS, W. *Arquitetura e Organização de Computadores*. Pearson.
- Documentação do `fio`: https://fio.readthedocs.io
