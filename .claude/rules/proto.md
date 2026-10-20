---
paths:
  - "proto/**/*.proto"
---
# Regras dos arquivos .proto

- Mensagens, campos e enums em português, como o contrato existente. Valores de enum seguem o padrão do arquivo (`ESTADO_CONECTADO`, `PROTO_TCP`); as exceções de lint (`ENUM_VALUE_PREFIX`, `ENUM_ZERO_VALUE_SUFFIX`) estão em `buf.yaml`.
- Todo campo novo é comentado com a semântica, as unidades e o valor "ausente" (por exemplo, "0 = padrão do Core").
- Campos novos ganham o próximo número livre e valor zero inofensivo. Nunca remova nem renumere; para aposentar um campo, marque `[deprecated = true]` e documente o substituto.
- Mudança de comportamento do framing (tamanho máximo, endianness) é mudança de contrato: atualize os golden vectors e avise os consumidores.
- Formate com `buf format -w` antes de commitar.
