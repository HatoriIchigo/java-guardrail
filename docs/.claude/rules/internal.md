---
description: app/internal/ 配下（backend 完結エンドポイント）のルール
paths:
  - "**/app/internal/*.java"
  - "**/app/internal/**/*.java"
---

# internal/ のルール（backend 完結エンドポイント）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`internal/*.java` は **backend 完結（外部接続なし）** エンドポイントのエントリ。

## 外部到達の禁止

- internal エントリから import を推移的に辿った閉包に、`repository` パッケージまたは外部連携パッケージ
  （拒否リスト `external-packages.txt`）が含まれてはならない（含まれればエラー）。
- これにより「internal 宣言が嘘でない（本当に外部接続なし）」ことを保証する。

## IF仕様書（OpenAPI）との対応

- `x-internal: true`（外部接続なし）のエンドポイントのエントリクラスは `internal/` に置く。
- `operationId` をエントリクラス名（PascalCase）に対応付ける（例: `checkHealth` → `internal/CheckHealth.java`）。

## 文字列リテラル / 外部連携 / 固定値

- 文字列リテラルのハードコードは禁止（`constants/` か `validation/` に集約）。
- 外部ツール連携の import は不可（`repository/` でのみ許可）。
- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。

## その他

- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
