---
description: app/validation/ 配下（バリデーション）のルール
paths:
  - "**/app/validation/*.java"
  - "**/app/validation/**/*.java"
---

# validation/ のルール（バリデーション）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

## 文字列リテラル

- 文字列リテラルのハードコードは `validation/` と `constants/` でのみ許可される（他のレイヤーは全面禁止）。
- ただし `validation/` でも **例外なく禁止** されるもの:
  - **SQL 文字列**: `SELECT` / `INSERT` / `UPDATE` / `DELETE` / `MERGE` / `CREATE` / `DROP` /
    `ALTER` / `TRUNCATE` で始まる文字列。SQL mapper（MyBatis / JPA 等）を使う。
  - **外部化すべき値（値の形式）**: PEM 秘密鍵ヘッダ、AWS アクセスキー `AKIA…`/`ASIA…`、
    GitHub PAT `ghp_…`、Slack トークン `xox?-…`、JDBC `jdbc:…`、URL `scheme://…`。
  - **外部化すべき値（定数名）**: 名前が `secret-keywords.txt` のキーワード（シークレット系・ユーザ名系・
    DB 系・URL 系。大文字小文字無視の部分一致）に該当し、文字列リテラルで初期化されている変数。
- 接続情報・シークレット・URL 等は `application.yaml` + 環境変数（`@Value` / `System.getenv`）経由で注入。

## その他

- 固定値（リテラル）の `return` 規制は `validation/` では **対象外**。
- 条件・繰り返し処理の禁止は `validation/` では **対象外**（禁止対象は `dto/**`・`repository/`・`constants/`）。
- 外部ツール連携の import は不可（`repository/` でのみ許可）。
- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
