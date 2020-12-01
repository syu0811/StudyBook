# StudyBook
勉強ノートを効率的に管理するアプリ
こちらは、Webアプリ・API機能を持つRailsアプリです。
クライアントアプリはStudyBookClientに存在します。

# 動作環境（確認済み）
Dockerが動作する環境下
- Ubuntu 18.04
- CentOS 7
- macOS Big Sur 11.0.1

## 他ツール
- Git: 2.28.0
- Docker 19.03.13
- docker-compose 1.27.4

# 動作方法
Git, Docker, DockerComposeは公式ドキュメント等より構築して下さい。

# 開発環境構築(以下bashコマンド)

- リポジトリよりクローン
```bash
git clone git@github.com:BMuscle/StudyBook.git
```

- ビルド
```bash
cd StudyBook
docker-compose build
docker-compose run web yarn install
# 再度起動
docker-compose up
```
- DB作成・初期データ投入（開発用）
```bash
# コンテナを起動した状態
docker-compose exec web bash
# 接続を確認後
rails db:create db:migrate db:seed
```
- ブラウザにてログイン
```
初期管理者ユーザ
# Email
admin@example.com
# パスワード
password

初期一般ユーザ
# Email
general@example.com
# パスワード
password
```

# 開発中コマンド

## コンテナ接続時
- webpackのコンパイル
```bash
./bin/webpack-dev-server
```
## 構文チェックツール系
```bash
# rails
rubocop
# js, html/css
lint
```
## テスト
```bash
rspec
```

## 本番環境構築(現状不備の可能性あり)
CentOS 7 にて確認
現状、docker-compose.prcへパスワード直書きなので注意。(後々修正)
webpackerのコンパイルでエラーが出ているので、コンパイル方式が、開発環境と同等の状態で動かしている。(後々修正)

1. docker-compose.ymlを削除し、docker-compose.prc.ymlへ置き換え
```bash
rm docker-compose.yml
mv docker-compose.prc.yml docker-compose.yml
```
2. build
```bash
docker-compose build
```
3. 起動
```bash
docker-compose up
```
4. DB作成・初期データ投入(別ターミナル or 上記コマンドにて -d オプション)
```
docker-compose exec app bash
# コンテナに接続後
rails db:create db:migrate db:seed
```
