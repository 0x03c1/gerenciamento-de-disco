#!/usr/bin/env bash
# Funções compartilhadas pelos scripts do laboratório. Não rode este arquivo diretamente.
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Podem ser alterados por variável de ambiente, ex.: DURACAO=10 ./scripts/1_dois_testes.sh
ARQUIVO="${ARQUIVO:-$RAIZ/teste.fio}"   # arquivo de teste (1 GB), reutilizado por todos os passos
DURACAO="${DURACAO:-30}"                # segundos de cada teste
TAMANHO="${TAMANHO:-1G}"

if ! command -v fio >/dev/null 2>&1; then
  echo "ERRO: o fio não está instalado."
  echo "  Linux (Debian/Ubuntu): sudo apt install fio"
  echo "  macOS:                 brew install fio"
  echo "  Windows:               veja docs/windows.md"
  exit 1
fi

# O --iodepth só tem efeito com um motor de E/S assíncrono.
case "$(uname -s)" in
  Linux)  MOTOR="libaio" ;;
  Darwin) MOTOR="posixaio" ;;
  *)
    echo "Sistema não reconhecido ($(uname -s)). No Windows, siga docs/windows.md."
    exit 1
    ;;
esac

# rodar "Título" [opções do fio...]
# Mostra a saída completa do fio e, no fim, só as linhas que interessam.
rodar() {
  local titulo="$1"; shift
  local saida
  saida="$(mktemp)"

  echo
  echo "=================================================================="
  echo "  $titulo"
  echo "  (${DURACAO} segundos — aguarde)"
  echo "=================================================================="
  echo "+ fio $*"
  echo

  fio "$@" | tee "$saida"

  echo
  echo "------------------------- RESUMO ---------------------------------"
  echo "  $titulo"
  grep -E 'IOPS=|^ +lat .*min=' "$saida" || echo "  (não encontrei as linhas de resumo; leia a saída acima)"
  echo "  IOPS= operações por segundo | BW= throughput | lat avg= latência média"
  echo "  Atenção à unidade da latência: usec = microssegundo, msec = milissegundo"
  echo "------------------------------------------------------------------"
  rm -f "$saida"
}

# Opções comuns a todos os testes
BASE=(--filename="$ARQUIVO" --size="$TAMANHO" --ioengine="$MOTOR" --runtime="$DURACAO" --time_based)
