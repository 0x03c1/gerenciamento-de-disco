#!/usr/bin/env bash
# Apaga o arquivo de teste de 1 GB criado pelo laboratório.
set -euo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARQUIVO="${ARQUIVO:-$RAIZ/teste.fio}"

if [ -f "$ARQUIVO" ]; then
  rm -f "$ARQUIVO"
  echo "Removido: $ARQUIVO"
else
  echo "Nada para remover ($ARQUIVO não existe)."
fi
