---
description: app/repository/ 配下（外部ツール連携）のルール
paths:
  - "**/app/repository/*.java"
  - "**/app/repository/**/*.java"
---

# repository/ のルール（外部ツール連携）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`repository/*.java` は外部ツール（DB・外部接続・AWS 等）との連携を担う層。

## 外部連携 import

- DB・外部接続・AWS（Cognito 等）といった外部ツール連携を表すパッケージの import は、
  **`repository/` でのみ許可**される。それ以外のレイヤーでの import はエラー。
- 「外部連携」とみなすパッケージ接頭辞は拒否リスト `external-packages.txt` で定義する
  （例: `java.sql` / `javax.sql` / `jakarta.persistence` / `org.hibernate` /
  `org.springframework.data` / `org.mybatis` / `com.zaxxer.hikari` 等）。

## 文字列リテラル / SQL

- 文字列リテラルのハードコードは禁止（`constants/` か `validation/` に集約）。
- 生 SQL 文字列は禁止。SQL mapper（MyBatis / JPA 等）の仕様を優先する。

## DTO の対応

- `repository/Foo.java` には同名の `dto/in/Foo.java` と `dto/out/Foo.java`
  （ベース名完全一致）が対応して存在すること。

## 値フロー（外部化すべき値の流入禁止・クロスクラス）

- 外部クライアントの**呼び出し／生成に渡す引数**に `constants/` 由来の値（直書きの定数。同一クラス内で
  別名のローカル変数・フィールドに束ねた場合を含む）を使ってはならない。
- 接続情報・シークレットは `constants/` ではなく `application.yaml` + 環境変数
  （`@Value` / `System.getenv`・`System.getProperty`）経由で注入すること。

## 処理の禁止

- 条件・繰り返し処理（`if` / `for` / 拡張 `for` / `while` / `do-while` / `switch` 文・式 / 三項演算子）は禁止。

## その他

- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。
- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
