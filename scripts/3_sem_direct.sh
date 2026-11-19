#!/usr/bin/env bash
# Passo 3 — A armadilha: o teste sequencial SEM --direct=1.
# Roda duas vezes: a primeira pode ainda ler do disco; a segunda já encontra o arquivo em cache.
source "$(dirname "${BASH_SOURCE[0]}")/comum.sh"

rodar "SEQUENCIAL 1 MB — SEM direct (1ª rodada)" \
  --name=seq-cache-1 --rw=read --bs=1M "${BASE[@]}"

rodar "SEQUENCIAL 1 MB — SEM direct (2ª rodada)" \
  --name=seq-cache-2 --rw=read --bs=1M "${BASE[@]}"

echo
echo "Pergunta da dupla: o número explodiu? O que vocês mediram de verdade?"
