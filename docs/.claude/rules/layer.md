---
description: app/layer<数値>/ 配下（サービス層）のルール
paths:
  - "**/app/layer*/*.java"
  - "**/app/layer*/**/*.java"
---

# layer<数値>/ のルール（サービス層）

> このルールは java-builder による検証を通すためのコード生成ガイドです。違反は exit code 1。

サービス層は `layer<数値>/`（`^layer[0-9]+$`、複数可）。クラスの FQN は
`com.<projectName>.app.layer<N>.<ClassName>`（パッケージ＝ディレクトリ、クラス名＝ファイル名）。

## 連番

- `layer<数値>` は 1 始まりの連番であること。歯抜け（例: layer1〜4・layer6〜7 で layer5 欠番）はエラー。

## レイヤー間 import

- **layer1 は repository 利用必須**: `layer1/` の各クラスは repository パッケージ
  （`com.<projectName>.app.repository`）を import していること。
- **下位レイヤー依存**: `layer<N>`（N≥2）は下位レイヤー（`layer1`〜`layer<N-1>`）のいずれかを
  import していること（例: `layer3` は `layer2` か `layer1` を import）。

## レイヤー依存グラフ（クラス間 import）

- **飛び越し参照の禁止**: `C → B`（`B` が下位レイヤー）で、間のレイヤー（`B` より上・`C` より下）の
  クラス `A` が既に `B` を import している場合、`C` は `B` を直接 import できない（`A` を経由する）。
  ※ `A` が `B` を import していなければこの規則では制限しない。
- **同一レイヤーの依存包含**: 同レイヤーの 2 クラスで、一方の依存集合がもう一方を包含する場合、
  包含する側を昇格し、被包含クラスを import して利用する（重複する直接 import を禁止）。
- **同一レイヤーの依存重複**: 同レイヤーの 2 クラスが依存集合を部分的に共有する場合、共通依存を制御する
  新クラスへ切り出し、両者を昇格して共通依存の直接 import を禁止する。
- **レイヤー差の制限**: `X → Y` で `layer(X) - layer(Y) >= 2` の場合、`X` を `layer(Y)+1` へ降格する
  （基準は下位レイヤー）。

## 文字列リテラル / 外部連携 / 固定値

- 文字列リテラルのハードコードは禁止（`constants/` か `validation/` に集約）。
- 外部ツール連携の import は不可（`repository/` でのみ許可）。
- 固定値（リテラル）の直接 `return` は禁止（`return null;` は許可）。

## その他

- 1 ファイル 500 行以内、1 メソッド／コンストラクタ 100 行以内。
- 使用禁止語（`dummy`/`mock`/`fake`/`stub` 等）を含めない。
