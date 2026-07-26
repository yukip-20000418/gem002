
# 開発環境を gemini に聞いてやってみた no2

ほぼそのままコピペしたので、ちょっとへんなとこもある。

---
## google cloud 初期設定

### 1. SSH 鍵の生成（Enter キーを 3 回押す）
`ssh-keygen -t ed25519`

### 2. 公開鍵の表示（出力された文字列をコピー）
`cat ~/.ssh/id_ed25519.pub`


### 3. github に　SSHキーを登録

### 4. Git のグローバルユーザー設定
`git config --global user.name "yukip"`
`git config --global user.email "yukip.20000418@gmail.com"`


## go + flutter の開発

### 1. バージョン確認
`go version`

`config --global --add safe.directory /google/flutter`
`flutter --version`


### 2. リポジトリをクローン
`cd ~`
`git clone git@github.com:yukip-20000418/gem002.git`

作成する場合
`git init`
`git add .`
`git commit -m "init"`

```
cat << 'EOF' > .gitignore
front/.dart_tool/
front/build/

#.dart_tool/
#build/

#back/server
EOF
```

`cd ~/gem002`
`git remote add origin git@github.com:yukip-20000418/gem002.git`
`git branch -M main`
`git push -u origin main`



### 3. Flutter Web のビルド
`cd ~/gem002/front`
`flutter build web`


### 4. Go サーバーの起動
`cd ~/gem002/back`
`go run main.go`



## cloud run にデプロイ

### 1. デプロイ対象の設定
 .gcloudignore を作成して、 /build/web を対象にしておく

```
.gcloudignore
.git
.gitignore

# Flutterのビルド成果物だけは無視リストから除外してアップロードする
!front/build/web/
```


### 2. デプロイに必要な権限
 ```
 gcloud projects add-iam-policy-binding <プロジェクトID> \
  --member="serviceAccount:<プロジェクト番号>-compute@developer.gserviceaccount.com" \
  --role="roles/storage.admin"
```

### 3. デプロイ
`cd ~/gem002`

`gcloud run deploy gem002 --source . --region asia-northeast2 --allow-unauthenticated`

---
