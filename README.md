# psychoscope-proto

Contrato canônico (Protocol Buffers v3) do Psychoscope MODR. Repositório passivo: sem binários.

- `proto/psychoscope/v1/ipc.proto` — contrato IPC core↔módulos (versionado por Git tags).
- `proto/psychoscope/v1/control.proto` — canal de controle CLI↔core (`ctl.sock`): módulos, comandos, alertas.
- `gen/go/` — código Go gerado (commitado). `go get github.com/psychoscope-io/psychoscope-proto@v0.2.0`,
  import `github.com/psychoscope-io/psychoscope-proto/gen/go/psychoscope/v1`.
- `rust/` — crate `psychoscope-proto` (prost, protoc vendorizado). `psychoscope-proto = { git = "https://github.com/psychoscope-io/psychoscope-proto", tag = "v0.2.0" }`.
- `testdata/framing_vectors.json` — golden vectors do framing; cada consumidor vendoriza uma cópia.

## Framing

`[uint32 big-endian: N][N bytes: MensagemIPC]`, com `1 <= N <= 1 MiB`. O leitor valida N **antes** de alocar.

## Desenvolvimento

Requer `buf` e `protoc-gen-go` (`go install`). `make lint`, `make gen`, `make check`.
Regra de evolução: nunca reutilizar números de campo; `buf breaking` roda no CI.

## Publicar e consumir

```
git tag -a v0.2.0 -m "psychoscope-proto v0.2.0"
git push origin main v0.2.0
```

Consumidores:

- Go: `go get github.com/psychoscope-io/psychoscope-proto@v0.2.0`
- Rust: `psychoscope-proto = { git = "https://github.com/psychoscope-io/psychoscope-proto", tag = "v0.2.0" }`

Antes de publicar (ou offline), `source scripts/local-deps.sh` faz Go e Cargo resolverem a dependencia a partir deste checkout local.
Nunca mova uma tag ja publicada: o Go grava o hash do modulo em `go.sum`; mudanças exigem uma nova versao.

## Licença

Apache License 2.0 — veja [LICENSE](LICENSE).

## Versões

- `v0.2.0`: `control.proto` ganha consulta de alertas persistidos (`PedidoListarAlertas`) e métricas (`PedidoMetricas`), aditivo. `ipc.proto` não mudou: módulos compilados contra `v0.1.0` continuam compatíveis.
- `v0.1.0`: contrato inicial (`ipc.proto` e `control.proto`).
