---
description: app/log/ 配下（ログ関連）のルール
paths:
  - "**/app/log/*.java"
  - "**/app/log/**/*.java"
---

# log/ のルール（ログ関連）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`log/*.java` はログ関連。

## 文字列リテラル / 固定値

- 文字列リテラルのハードコードは禁止（ログメッセージ等の文字列も `constants/` か `validation/` に集約）。
- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。

## その他

- 外部ツール連携の import は不可（`repository/` でのみ許可）。
- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
