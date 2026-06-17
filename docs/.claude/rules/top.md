---
description: app/top/ 配下（最上位層・外部接続ありエンドポイント）のルール
paths:
  - "**/app/top/*.java"
  - "**/app/top/**/*.java"
---

# top/ のルール（最上位層）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

`top/*.java` は最上位層。**外部接続ありエンドポイント**のエントリを置く。

## import 制限

- `top/*.java` は最大番号のレイヤー（`layer<最大>`）のみ import 可能。それ以外のレイヤーを import すると
  エラー（例: layer が 1〜3 あるなら top は layer3 のみ import 可）。
- 外部ツール連携の import は不可（`repository/` でのみ許可）。外部連携は `top → layer → repository` で行う。

## IF仕様書（OpenAPI）との対応

- `x-internal` 省略／`false`（外部接続あり・既定）のエンドポイントのエントリクラスは `top/` に置く。
- `operationId` をエントリクラス名（PascalCase）に対応付ける（例: `loginAccount` → `top/LoginAccount.java`）。

## 文字列リテラル / 固定値

- 文字列リテラルのハードコードは禁止（`constants/` か `validation/` に集約）。
- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。

## その他

- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
