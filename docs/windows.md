# Fazendo o laboratório no Windows

Os scripts da pasta `scripts/` são para Linux e macOS. No Windows há três caminhos; escolha um.

## Descobrir o disco (todos os caminhos)

No PowerShell:

```powershell
Get-PhysicalDisk | Select FriendlyName, MediaType, BusType
```

`MediaType` diz se é HDD ou SSD; `BusType` diz se a interface é SATA ou NVMe.

## Caminho 1 — CrystalDiskMark (mais simples)

Instale o CrystalDiskMark, deixe o tamanho de teste em 1GiB e clique em **All**.
Cada linha do programa corresponde a um teste do laboratório:

| Linha do CrystalDiskMark | Teste do laboratório | Passo |
| --- | --- | --- |
| SEQ1M Q1T1 (ou Q8T1) — Read | Sequencial, blocos de 1 MB | 1 |
| RND4K Q32T1 — Read | Aleatório 4 KB, 32 pedidos ao mesmo tempo | 1 e 2 |
| RND4K Q1T1 — Read | Aleatório 4 KB, 1 pedido por vez | 2 |

O programa mostra **MB/s**. Para obter o IOPS, use a fórmula da aula ao contrário:

```
IOPS ≈ throughput ÷ tamanho do bloco
Exemplo: 350 MB/s com blocos de 4 KB  ->  350.000 KB/s ÷ 4 KB ≈ 87.500 IOPS
```

O CrystalDiskMark sempre ignora o cache, então o **passo 3 não pode ser feito nele**:
quem faz o passo 3 é o colega da dupla que tem o `fio`.

## Caminho 2 — fio para Windows (PowerShell)

Instale o fio para Windows (links em https://fio.readthedocs.io) e rode numa pasta comum,
por exemplo `C:\Users\voce\lab-disco`. No Windows o fio já usa um motor assíncrono por padrão,
então não é preciso `--ioengine`.

```powershell
# Passo 1 — Teste A: sequencial, 1 MB
fio --name=seq --filename=teste.fio --rw=read --bs=1M --size=1G --direct=1 --runtime=30 --time_based

# Passo 1 — Teste B: aleatório, 4 KB, 32 pedidos
fio --name=rand --filename=teste.fio --rw=randread --bs=4k --size=1G --direct=1 --iodepth=32 --runtime=30 --time_based

# Passo 2 — o mesmo aleatório com 1 pedido por vez
fio --name=rand-qd1 --filename=teste.fio --rw=randread --bs=4k --size=1G --direct=1 --iodepth=1 --runtime=30 --time_based

# Passo 3 — sequencial SEM --direct=1 (rode duas vezes)
fio --name=seq-cache --filename=teste.fio --rw=read --bs=1M --size=1G --runtime=30 --time_based

# No fim
del teste.fio
```

## Caminho 3 — WSL

Dentro do WSL, use os scripts normalmente (`sudo apt install fio`).
Atenção: o WSL enxerga um **disco virtual**. Os números servem para comparar um teste com o outro,
mas não representam o valor real do seu hardware. Escreva isso no relatório.
