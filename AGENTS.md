# AGENTS.md — psychoscope-proto

Contrato canônico (Protocol Buffers v3) do Psychoscope MODR. Repositório passivo: sem binários.

## Estrutura

- `proto/psychoscope/v1/ipc.proto`: IPC entre o Core e os módulos (framing `uint32` big-endian + payload, máximo 1 MiB).
- `proto/psychoscope/v1/control.proto`: canal de controle da CLI/TUI (`ctl.sock`): módulos, comandos, alertas, métricas.
- `gen/go/`: código Go **gerado e versionado** (`go.mod` na raiz; módulo `github.com/psychoscope-io/psychoscope-proto`).
- `rust/`: crate `psychoscope-proto` (prost, `protoc` vendorizado) consumido por `git` + `tag`.
- `testdata/framing_vectors.json`: golden vectors do framing; core e sensor guardam cópias.
- `scripts/local-deps.sh`: faz Go e Cargo resolverem este repositório localmente (antes de publicar uma tag).

## Comandos

```bash
make lint                                  # buf lint + buf format --exit-code
make gen                                   # regenera gen/go
make check                                 # lint + gen sem diff + fmt/clippy do crate Rust
make breaking AGAINST='.git#tag=v0.2.0'    # compatibilidade com a última tag
```

## Regras e skills

Regras (`.claude/rules/`): `fluxo-de-trabalho`, `principios-de-design`, `organizacao-do-codigo`, `testes-e-verificacao`, `git-e-publicacao`, `seguranca`, `contrato-proto`, `estilo-e-idioma` (compartilhadas) e `proto` (deste repositório).
Skills (`.claude/skills/`): `evoluir-contrato`, `refatorar-sem-quebrar`, `revisar-pr-dependabot`, `publicar-versao`.

## Armadilhas conhecidas

- Mexer em `gen/` à mão ou esquecer `make gen` quebra o CI (`git diff --exit-code gen/`).
- Reescrever histórico ou mover a tag `vX.Y.Z` invalida o `go.sum` e o `Cargo.lock` dos consumidores.
