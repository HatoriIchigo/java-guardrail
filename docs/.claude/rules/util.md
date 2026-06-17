---
description: app/util/ 配下（汎用ツール）のルール
paths:
  - "**/app/util/*.java"
  - "**/app/util/**/*.java"
---

# util/ のルール（汎用ツール）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`util/*.java` は下位の汎用ツール。上位・連携レイヤーへ依存してはならない。

## import 制限

- `util/*.java` は `layer<数値>`・`top`・`repository` パッケージを import 不可。
- 外部ツール連携の import も不可（`repository/` でのみ許可）。

## 文字列リテラル / 固定値

- 文字列リテラルのハードコードは禁止（`constants/` か `validation/` に集約）。
- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。

## その他

- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
