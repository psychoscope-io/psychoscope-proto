---
name: evoluir-contrato
description: Adicionar ou alterar mensagens do contrato Protocol Buffers do Psychoscope (ipc.proto ou control.proto) com compatibilidade. Use ao criar novos pedidos, métricas, campos de evento ou qualquer mudança no .proto.
---
# Evoluir o contrato

1. **Decida se é aditivo.** Se exigir remover, renomear ou renumerar, pare e pergunte ao dono: é uma versão incompatível.
2. Edite o `.proto` (veja `.claude/rules/proto.md`): campo novo, número livre, comentário de semântica.
3. `buf format -w && make check` (lint, formato, geração sem diff, crate Rust compila) e `make breaking AGAINST='.git#tag=<última>'`.
4. Atualize o `README.md` (seção "Versões") dizendo o que mudou e se módulos antigos continuam compatíveis.
5. Commit com `gen/` regenerado no mesmo commit. **Não crie a tag**: entregue o comando; a tag anotada nasce da publicação do dono (ou local, só se for preciso calcular o `go.sum`, avisando).
6. Consumidores, depois da tag: core (`go get ...@vX.Y.Z`, `go mod tidy`) e, se o `ipc.proto` mudou, sensor (`tag` no `Cargo.toml` e `cargo update -p psychoscope-proto`). Antes da tag no GitHub: `source scripts/local-deps.sh`.
7. Verifique os consumidores sem `go.work`: `GOWORK=off go test ./...` no core e `scripts/e2e.sh` no sensor.
