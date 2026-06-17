---
description: app/dto/ 配下（in/out の DTO）のルール
paths:
  - "**/app/dto/*.java"
  - "**/app/dto/**/*.java"
---

# dto/ のルール（DTO）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`dto/in/*.java`（in 側）・`dto/out/*.java`（out 側）に配置する。

## 配置・対応

- `dto/in` と `dto/out` の `.java` ファイル数が一致すること。
- `repository/Foo.java` には同名の `dto/in/Foo.java` と `dto/out/Foo.java`（ベース名完全一致）が
  対応して存在すること。

## 処理の禁止

- 条件・繰り返し処理（`if` / `for` / 拡張 `for` / `while` / `do-while` / `switch` 文・式 / 三項演算子）は禁止。

## 文字列リテラル / 固定値

- 文字列リテラルのハードコードは禁止（`constants/` か `validation/` に集約）。
- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。

## その他

- 外部ツール連携の import は不可（`repository/` でのみ許可）。
- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
