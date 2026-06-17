---
description: プロジェクト全体のディレクトリ構成・ファイル種別・app/ 配下の配置ルール
paths:
  - "**/src/main/java/**/*.java"
  - "**/src/test/java/**/*.java"
  - "**/src/main/resources/**"
  - "**/src/test/resources/**"
---

# ディレクトリ構成ルール

> このルールは java-builder（AST解析ツール）による検証を通すためのコード生成ガイドです。
> 違反は標準エラー出力に報告され、**exit code 1** で終了します。検証は Docker で実行します。

## プロジェクトルート構成

```
src/main/java/com/<projectName>/app/
```

- `<projectName>` は `^[0-9a-zA-Z-_]+$`（英数字・ハイフン・アンダースコア）にマッチすること。
- この構成でなければエラー終了。

## ソースツリーのファイル種別（main / test 共通）

- `src/main/java/`・`src/test/java/` 配下には `.java` ファイルのみ配置できる。
- `src/main/resources/`・`src/test/resources/` 配下には `.yaml`・`.yml` ファイルのみ配置できる。
- 対象ディレクトリが存在しない場合はスキップ。許可外の拡張子があればエラー。

## app/ 配下の構成

| パス | 概要 |
| -- | -- |
| `Application.java` | メイン（app 直下に置けるのはこのファイルのみ） |
| `top/*.java` | 最上位層（外部接続ありエンドポイントのエントリ） |
| `internal/*.java` | backend 完結エンドポイントのエントリ（外部接続なし。repository／外部連携への到達禁止） |
| `layer<数値>/*.java` | サービス層（`^layer[0-9]+$`、複数可。1始まりの連番であること） |
| `repository/*.java` | 外部ツールとの連携 |
| `dto/in/*.java` | in 側の DTO |
| `dto/out/*.java` | out 側の DTO |
| `log/*.java` | ログ関連 |
| `util/*.java` | util ツール |
| `validation/*.java` | バリデーション関連 |
| `constants/*.java` | 定数 |

- 上記以外の場所に `.java` ファイルがあればエラー。app 直下に置ける `.java` は `Application.java` のみ。
- `dto/in` と `dto/out` の `.java` ファイル数が一致しなければエラー。
- `layer<数値>` は 1 始まりの連番であること。歯抜け（例: layer1〜4・layer6〜7 で layer5 が欠番）はエラー。

## サイズ制限（全 `.java` 対象）

- 1 ファイル 500 行以内。
- 1 メソッド／コンストラクタ 100 行以内。
