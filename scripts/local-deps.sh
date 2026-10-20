#!/usr/bin/env bash
# Resolve as dependencias "github.com/psychoscope-io/psychoscope-proto" (Go e Cargo) a partir
# deste checkout local, em vez do GitHub. Util antes da publicacao ou offline.
#
#   source ../psychoscope-proto/scripts/local-deps.sh   # dentro do core ou do sensor
#
# As tags/commits precisam existir neste repositorio local (ex.: v0.1.0). Para iterar no
# contrato SEM criar tags, use um go.work (Go) ou [patch] em .cargo/config.toml (Cargo).
_psy_proto_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# git reescreve a URL do GitHub para o checkout local (so neste processo e filhos)
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0="url.${_psy_proto_dir}.insteadOf"
export GIT_CONFIG_VALUE_0="https://github.com/psychoscope-io/psychoscope-proto"

# Go: busca direto por VCS (sem proxy/sumdb publicos) e permite o protocolo file
export GOPRIVATE="github.com/psychoscope-io/*"
export GOPROXY=direct
export GIT_ALLOW_PROTOCOL="file:https:ssh:git"

# Cargo: usa o git do sistema (respeita a reescrita acima)
export CARGO_NET_GIT_FETCH_WITH_CLI=true
unset _psy_proto_dir
