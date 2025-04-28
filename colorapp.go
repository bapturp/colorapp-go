package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var addr = ":8080"

type Color string

func (c Color) Handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%s\n", c)
}

func main() {
	color := Color(os.Getenv("COLOR"))
	if color == "" {
		color = "No color set!"
	}

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	http.HandleFunc("/", color.Handler)

	log.Printf("Server listening on %v\n", addr)

	log.Fatal(http.ListenAndServe(addr, nil))
}
