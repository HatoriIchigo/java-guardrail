# コード内容ルール（AST検査 / JavaParser）

[← 検証仕様トップ](README.md)

1. **文字列ハードコードの集約**: 文字列リテラルは `constants/*.java` と `validation/*.java` のみ許可。
   それ以外の場所（`top` / `layer*` / `repository` / `dto/**` / `log` / `util` / `Application.java`）に
   文字列リテラルがあればエラー（アノテーション引数の文字列も対象）。
   - **SQL文字列の禁止（例外なし）**: `SELECT` / `INSERT` / `UPDATE` / `DELETE` / `MERGE` /
     `CREATE` / `DROP` / `ALTER` / `TRUNCATE` で始まる文字列リテラルは、`constants/`・`validation/`
     を含む**すべての場所で禁止**。生SQLを集約するのではなく、SQL mapper（MyBatis / JPA 等）の
     仕様を優先すること。エラーログにもその旨を出力する。
   - **外部化すべき値のハードコード禁止（例外なし）**: シークレット（パスワード・トークン・APIキー等）に
     加え、**ユーザ名系・DB接続情報系・URL系**といった環境依存の設定値は、`constants/`・`validation/` を
     含む**すべての場所で禁止**。`application.yaml` + 環境変数経由で注入すること（エラーログにもその旨を
     出力）。検出は2方式の併用:
     - **名前ベース**: 定数名が外部設定 `secret-keywords.txt`（既定: シークレット系
       `password`/`secret`/`token`/`apiKey` 等、ユーザ名系 `username`/`userId` 等、DB系
       `jdbc`/`datasource`/`dbHost`/`schema` 等、URL系 `url`/`endpoint`/`host` 等。大文字小文字無視の
       部分一致）に該当し、かつ文字列リテラルで初期化されている場合エラー。
       **検査対象は `constants/`・`validation/` のみ**（文字列リテラルが許可される場所。他のレイヤーは
       文字列リテラル自体がルール1で禁止のため重複検査しない）。
     - **値ベース**: 値が既知の外部化対象形式（PEM秘密鍵ヘッダ、AWSアクセスキー `AKIA…`/`ASIA…`、
       GitHub PAT `ghp_…`、Slackトークン `xox?-…`、JDBC `jdbc:…`、URL `scheme://…`）に一致する場合エラー
       （こちらは全レイヤー対象）。
     - 読み込み優先順位: `-Dsecret.keywords=<path>` → カレントの `secret-keywords.txt` →
       JAR同梱 `src/main/resources/secret-keywords.txt`（再ビルドなしで差し替え可能）。

1.1. **使用禁止語（テストダブル混入防止）**: `src/main/java` 配下（本番コード**全体**）では
   `dummy` / `mock` / `fake` / `stub` 等の語を使用禁止（大文字小文字無視の部分一致。クラス名・メソッド名・
   変数名・文字列・コメント等ソーステキスト全体が対象）。1つでも現れればエラー。`src/test` 配下は対象外。
   `app/` の内外を問わず `src/main/java` 全体を走査する（`ProhibitedWordValidator`）。
   - 禁止語は外部設定 `prohibited-words.txt`。読み込み優先順位:
     `-Dprohibited.words=<path>` → カレントの `prohibited-words.txt` →
     JAR同梱 `src/main/resources/prohibited-words.txt`（再ビルドなしで差し替え可能）。

2. **処理の禁止**: `dto/**/*.java`・`repository/*.java`・`constants/*.java` では条件・繰り返し処理
   （`if` / `for` / 拡張`for` / `while` / `do-while` / `switch`文・式 / 三項演算子）を禁止。
3. **layer1 は repository 利用必須**: `layer1/` の各クラスは repository パッケージ
   （`com.<projectName>.app.repository`）を import していること。
4. **repository と DTO の対応**: `repository/Foo.java` には同名の `dto/in/Foo.java` と
   `dto/out/Foo.java`（ベース名完全一致）が対応して存在すること。
5. **固定値 return の禁止**: リテラル（文字列・数値・真偽値・文字、符号付き数値含む）を直接返す
   `return` を禁止。`return null;` は許可。`constants/`・`validation/` は対象外。
6. **サイズ制限**: 1ファイル 500 行以内、1メソッド／コンストラクタ 100 行以内（全 `.java` 対象）。
7. **下位レイヤー依存**: `layer<N>`（N≥2）は下位レイヤー（`layer1`〜`layer<N-1>`）の
   いずれかを import していること（例: `layer3` は `layer2` か `layer1` を import）。
8. **top の import 制限**: `top/*.java` は最大番号のレイヤー（`layer<最大>`）のみ import 可能。
   それ以外のレイヤーを import するとエラー。
9. **util の import 制限**: `util/*.java` は `layer<数値>`・`top`・`repository` パッケージを
   import 不可（utilは下位の汎用ツールであり、上位・連携レイヤーへ依存してはならない）。
10. **internal の外部到達禁止**: `internal/*.java` は backend 完結（外部接続なし）のエントリ。
    そのエントリから推移的に辿った import 閉包に `repository` パッケージまたは外部連携パッケージ
    （拒否リスト）が含まれてはならない（含まれればエラー）。
