---
description: src/main/java 全体の使用禁止語（テストダブル混入防止）
paths:
  - "**/src/main/java/**/*.java"
---

# 使用禁止語（テストダブル混入防止）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

- `src/main/java` 配下（本番コード**全体**）では `dummy` / `mock` / `fake` / `stub` 等の語を使用禁止。
  - 大文字小文字無視の部分一致。**クラス名・メソッド名・変数名・文字列・コメント**等、ソーステキスト全体が対象。
  - 1 つでも現れればエラー。
- `src/test` 配下は対象外。
- 禁止語は外部設定 `prohibited-words.txt` で定義（`app/` の内外を問わず `src/main/java` 全体を走査）。
