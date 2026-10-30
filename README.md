# psychoscope-proto

Contrato canônico (Protocol Buffers v3) do Psychoscope MODR. Repositório passivo: sem binários.

- `proto/psychoscope/v1/ipc.proto` — contrato IPC core↔módulos (versionado por Git tags).
- `proto/psychoscope/v1/control.proto` — canal de controle CLI↔core (`ctl.sock`): módulos, comandos, alertas.
- `gen/go/` — código Go gerado (commitado). `go get github.com/psychoscope-io/psychoscope-proto@v0.6.0`,
  import `github.com/psychoscope-io/psychoscope-proto/gen/go/psychoscope/v1`.
- `rust/` — crate `psychoscope-proto` (prost, protoc vendorizado). `psychoscope-proto = { git = "https://github.com/psychoscope-io/psychoscope-proto", tag = "v0.6.0" }`.
- `testdata/framing_vectors.json` — golden vectors do framing; cada consumidor vendoriza uma cópia.

## Framing

`[uint32 big-endian: N][N bytes: MensagemIPC]`, com `1 <= N <= 1 MiB`. O leitor valida N **antes** de alocar.

## Desenvolvimento

Requer `buf` e `protoc-gen-go` (`go install`). `make lint`, `make gen`, `make check`.
Regra de evolução: nunca reutilizar números de campo; `buf breaking` roda no CI.

## Publicar e consumir

```
git tag -a v0.6.0 -m "psychoscope-proto v0.6.0"
git push origin main v0.6.0
```

Consumidores:

- Go: `go get github.com/psychoscope-io/psychoscope-proto@v0.6.0`
- Rust: `psychoscope-proto = { git = "https://github.com/psychoscope-io/psychoscope-proto", tag = "v0.6.0" }`

Antes de publicar (ou offline), `source scripts/local-deps.sh` faz Go e Cargo resolverem a dependencia a partir deste checkout local.
Nunca mova uma tag ja publicada: o Go grava o hash do modulo em `go.sum`; mudanças exigem uma nova versao.

## Licença

Apache License 2.0 — veja [LICENSE](LICENSE).

## Compatibilidade

- **O que é compatível (sem mudar `versao_protocolo`):** adicionar campo, mensagem, variante de `oneof` ou valor de enum, sempre com número novo. Quem foi compilado contra uma versão anterior ignora o que não conhece: um Core que recebe um `EventoTelemetria` de variante desconhecida a ignora (o `oneof` chega vazio), e um módulo ignora campos novos das respostas do Core.
- **O que é incompatível:** remover, renomear ou renumerar, mudar o tipo ou a semântica de um campo, e mudar o framing. Exige subir `versao_protocolo` (hoje `1`) e uma versão maior do contrato; não há planos para isso.
- **Como o módulo declara a versão que fala:** no `HelloModulo.versao_protocolo`, junto de `versao_modulo` (a versão do próprio módulo, só informativa).
- **Como o Core reage a uma versão desconhecida:** recusa o Hello com `HelloResposta.aceito = false` e a `mensagem_erro` com a versão que o Core aceita, e encerra a sessão. Nunca tenta adivinhar.
- **Módulo e Core de versões diferentes do repositório** (por exemplo, módulo em `v0.4.0` e Core em `v0.6.0`) conversam enquanto `versao_protocolo` for igual, porque as mudanças entre elas são aditivas.

## Versões

- `v0.6.0`: `EventoTelemetria.dado` ganha a variante `generico` (`EventoGenerico`: `tipo`, `timestamp` e `atributos` em texto), para módulos de terceiros e o módulo de exemplo que ainda não têm variante própria. Aditivo: um Core de versão anterior ignora a variante nova, e módulos compilados contra versões anteriores continuam compatíveis. Os limites do `EventoGenerico` estão documentados no `ipc.proto`.
- `v0.5.0`: `ModuloInfo` ganha `versao_modulo` (versão declarada no `HelloModulo`) e `conectado_desde` (início da conexão ativa), ambos aditivos e vazios quando o módulo não está conectado. `ipc.proto` não mudou: módulos compilados contra versões anteriores continuam compatíveis, e CLIs antigas ignoram os campos novos.
- `v0.4.0`: `StatusModulo` ganha `contadores` (mapa de contadores do módulo; as chaves do `mod-net-sensor` estão documentadas no `ipc.proto`) e `CampoConfig` ganha `rotulo` (nome para exibir ao usuário), ambos aditivos. Módulos e Cores compilados contra `v0.3.0` continuam compatíveis: ignoram os campos novos.
- `v0.3.0`: `control.proto` ganha leitura e aplicação de configuração (`PedidoLerConfig`, `PedidoAplicarConfig`, `ListaConfig`, `CampoConfig`), aditivo. A escrita é restrita ao root pelo Core (UID por `SO_PEERCRED`). `ipc.proto` não mudou.
- `v0.2.0`: `control.proto` ganha consulta de alertas persistidos (`PedidoListarAlertas`) e métricas (`PedidoMetricas`), aditivo. `ipc.proto` não mudou: módulos compilados contra `v0.1.0` continuam compatíveis.
- `v0.1.0`: contrato inicial (`ipc.proto` e `control.proto`).
