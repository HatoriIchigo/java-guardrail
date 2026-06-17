# ディレクトリ構成ルール

[← 検証仕様トップ](README.md)

## プロジェクトルート構成

```
src/main/java/com/<projectName>/app/
```

- `<projectName>` は `^[0-9a-zA-Z-_]+$`（英数字・ハイフン・アンダースコア）にマッチすること。
- 上記構成でなければエラー終了。

## ソースツリーのファイル種別（main / test 共通）

- `src/main/java/`・`src/test/java/` 配下には `.java` ファイルのみ配置できる。
- `src/main/resources/`・`src/test/resources/` 配下には `.yaml`・`.yml` ファイルのみ配置できる。
- 対象ディレクトリが存在しない場合はスキップ。許可外の拡張子があればエラー。

## app/ 配下の構成

| パス | 概要 |
| -- | -- |
| `Application.java` | メイン（app直下に置けるのはこのファイルのみ） |
| `top/*.java` | 最上位層（外部接続ありエンドポイントのエントリ） |
| `internal/*.java` | backend完結エンドポイントのエントリ（外部接続なし。repository/外部連携への到達禁止） |
| `layer<数値>/*.java` | サービス層（`^layer[0-9]+$`、複数可。1始まりの連番であること） |
| `repository/*.java` | 外部ツールとの連携 |
| `dto/in/*.java` | in側のDTO |
| `dto/out/*.java` | out側のDTO |
| `log/*.java` | ログ関連 |
| `util/*.java` | utilツール |
| `validation/*.java` | バリデーション関連 |
| `constants/*.java` | 定数 |

- 上記以外の場所に `.java` ファイルがあればエラー。
- `dto/in` と `dto/out` の `.java` ファイル数が一致しなければエラー。
- `layer<数値>` は1始まりの連番であること。歯抜け（例: layer1〜4, layer6〜7 で layer5 が欠番）はエラー。
