# psychoscope-proto

Contrato canônico (Protocol Buffers v3) do Psychoscope MODR. Repositório passivo: sem binários.

- `proto/psychoscope/v1/ipc.proto` — contrato IPC (versionado por Git tags).
- `gen/go/` — código Go gerado (commitado). `go get github.com/Bandeira27/psychoscope-proto@v0.1.0`,
  import `github.com/Bandeira27/psychoscope-proto/gen/go/psychoscope/v1`.
- `rust/` — crate `psychoscope-proto` (prost, protoc vendorizado). `psychoscope-proto = { git = "https://github.com/Bandeira27/psychoscope-proto", tag = "v0.1.0" }`.
- `testdata/framing_vectors.json` — golden vectors do framing; cada consumidor vendoriza uma cópia.

## Framing

`[uint32 big-endian: N][N bytes: MensagemIPC]`, com `1 <= N <= 1 MiB`. O leitor valida N **antes** de alocar.

## Desenvolvimento

Requer `buf` e `protoc-gen-go` (`go install`). `make lint`, `make gen`, `make check`.
Regra de evolução: nunca reutilizar números de campo; `buf breaking` roda no CI.
