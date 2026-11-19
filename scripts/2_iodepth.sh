#!/usr/bin/env bash
# Passo 2 — O efeito das filas.
# O mesmo teste aleatório de 4 KB, primeiro com 1 pedido por vez, depois com 32.
source "$(dirname "${BASH_SOURCE[0]}")/comum.sh"

rodar "ALEATÓRIO 4 KB — iodepth=1 (um pedido por vez)" \
  --name=rand-qd1 --rw=randread --bs=4k --direct=1 --iodepth=1 "${BASE[@]}"

rodar "ALEATÓRIO 4 KB — iodepth=32 (32 pedidos ao mesmo tempo)" \
  --name=rand-qd32 --rw=randread --bs=4k --direct=1 --iodepth=32 "${BASE[@]}"

echo
echo "Pergunta da dupla: o IOPS mudou muito? Por quê? (Pense nas filas do NVMe.)"
