package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	// API エンドポイント
	http.HandleFunc("/api/hello", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		fmt.Fprintf(w, "Hello from Go Backend!")
	})

	// 静的ファイルの参照先を判定
	// 1. Docker/Cloud Run 環境（./web）
	// 2. Cloud Shell ローカル開発環境（../my_frontend/build/web）
	staticDir := "./web"
	if _, err := os.Stat(staticDir); os.IsNotExist(err) {
		staticDir = "../front/build/web"
	}

	fs := http.FileServer(http.Dir(staticDir))
	http.Handle("/", fs)

	// Cloud Run が指定する PORT 環境変数に対応
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("Server running on port %s...\n", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		panic(err)
	}
}