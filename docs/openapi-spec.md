# IF仕様書（OpenAPI）との突合

[← 検証仕様トップ](README.md)

エンドポイントが「外部接続を伴うか（通常）／backend完結か（internal）」は、**IF仕様書（OpenAPI形式）**で宣言し、
ツールはその宣言とコード実態を突き合わせて検証する（declare + verify）。

- **指定方法**: IF仕様書のパスは**コマンドライン引数**で指定する。例の仕様書を
  `examples/openapi.yaml`（プロジェクトルート配下の `examples/`）に同梱する。
- **宣言（OpenAPI記載）**: operation レベルのベンダ拡張 `x-internal` で宣言する。
  - `x-internal: true` … 外部接続なし。エントリクラスは `app/internal/` に置く。
  - `x-internal` 省略／`false` … 外部接続あり（既定）。エントリクラスは `app/top/`。
- **マッピング**: `operationId` をエントリクラス名（PascalCase）に対応付ける。
  - 例: `checkHealth` → `internal/CheckHealth.java`、`loginAccount` → `top/LoginAccount.java`。
- **判定ロジック（検証）**:
  1. ゾーン整合: `x-internal: true` のエントリは `internal/` に、省略/false のエントリは `top/` に存在すること。
  2. internal の外部到達禁止（コード内容ルール10）: internal エントリの import 推移閉包に
     `repository`／外部連携パッケージが現れたらエラー（＝internal宣言が嘘でないことを保証）。
  3. 外部エントリは従来どおり `top → layer → repository` で外部連携する（ルール3/7/8/15）。

  ※ OpenAPI の標準フィールドからは外部接続要否を推論できないため、`x-internal` による明示宣言を正とし、
    コード側の到達可能性で検証する。
