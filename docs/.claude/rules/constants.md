---
description: app/constants/ 配下（定数）のルール
paths:
  - "**/app/constants/*.java"
  - "**/app/constants/**/*.java"
---

# constants/ のルール（定数）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`constants/*.java` は定数を集約する場所。

## 文字列リテラル

- 文字列リテラルのハードコードは `constants/` と `validation/` でのみ許可される（他のレイヤーは全面禁止）。
- ただし `constants/` でも **例外なく禁止** されるもの:
  - **SQL 文字列**: `SELECT` / `INSERT` / `UPDATE` / `DELETE` / `MERGE` / `CREATE` / `DROP` /
    `ALTER` / `TRUNCATE` で始まる文字列。生 SQL を集約せず、SQL mapper（MyBatis / JPA 等）を使う。
  - **外部化すべき値（値の形式）**: PEM 秘密鍵ヘッダ、AWS アクセスキー `AKIA…`/`ASIA…`、
    GitHub PAT `ghp_…`、Slack トークン `xox?-…`、JDBC `jdbc:…`、URL `scheme://…`。
  - **外部化すべき値（定数名）**: 定数名が `secret-keywords.txt` のキーワード
    （シークレット系 `password`/`secret`/`token`/`apiKey` 等、ユーザ名系 `username`/`userId` 等、
    DB 系 `jdbc`/`datasource`/`dbHost`/`schema` 等、URL 系 `url`/`endpoint`/`host` 等。
    大文字小文字無視の部分一致）に該当し、かつ文字列リテラルで初期化されている定数。
- 接続情報・シークレット・URL 等の環境依存値は `constants/` に置かず、`application.yaml` +
  環境変数（`@Value` / `System.getenv` / `System.getProperty`）経由で注入すること。

## 値フロー（外部連携への流入）

- `repository/` の外部クライアント呼び出し／生成に渡る値が `constants/` 由来（直接参照・同一クラス内の
  別名経由を含む）だとエラー。接続情報・認証情報は `constants/` ではなく注入で供給すること。

## 処理の禁止

- 条件・繰り返し処理（`if` / `for` / 拡張 `for` / `while` / `do-while` / `switch` 文・式 / 三項演算子）は禁止。

## その他

- 固定値（リテラル）の `return` 規制（リテラルの直接 return 禁止）は `constants/` では **対象外**。
- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
