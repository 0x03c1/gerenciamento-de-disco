#!/usr/bin/env bash
# Passo 0 — Que disco eu tenho? (HDD, SSD SATA ou NVMe)
set -euo pipefail

case "$(uname -s)" in
  Linux)
    echo "ROTA 1 = HDD (gira) | ROTA 0 = SSD | TRAN = interface (sata ou nvme)"
    echo
    lsblk -d -o NAME,ROTA,TRAN,SIZE,MODEL
    if grep -qi microsoft /proc/version 2>/dev/null; then
      echo
      echo "AVISO: você está no WSL. O disco aqui é virtual: use os números para"
      echo "comparar um teste com o outro, não como valor real do hardware."
    fi
    ;;
  Darwin)
    echo "Procure 'Medium Type' (SSD ou Rotational) e 'Protocol' (NVMe, SATA, Apple Fabric...)"
    echo
    system_profiler SPStorageDataType | grep -E 'Device Name|Medium Type|Protocol' | sort -u
    ;;
  *)
    echo "No Windows, abra o PowerShell e rode:"
    echo "  Get-PhysicalDisk | Select FriendlyName, MediaType, BusType"
    ;;
esac
