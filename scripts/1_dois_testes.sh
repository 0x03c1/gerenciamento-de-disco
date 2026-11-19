#!/usr/bin/env bash
# Passo 1 — O mesmo disco medido de duas formas.
#   Teste A: leitura SEQUENCIAL, blocos de 1 MB  -> mede THROUGHPUT
#   Teste B: leitura ALEATÓRIA,  blocos de 4 KB  -> mede IOPS
source "$(dirname "${BASH_SOURCE[0]}")/comum.sh"

rodar "TESTE A — SEQUENCIAL, blocos de 1 MB" \
  --name=seq --rw=read --bs=1M --direct=1 "${BASE[@]}"

rodar "TESTE B — ALEATÓRIO, blocos de 4 KB, 32 pedidos ao mesmo tempo" \
  --name=rand --rw=randread --bs=4k --direct=1 --iodepth=32 "${BASE[@]}"

echo
echo "Anote IOPS, throughput (BW) e latência dos dois testes no RELATORIO.md e na planilha da turma."
