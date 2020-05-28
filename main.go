package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
)

func main() {
	http.HandleFunc("/", uploadHandler)

	http.ListenAndServe(":5051", nil)
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	location := r.Header.Get("Content-Location")
	fmt.Println(location)

	documentId := r.Header.Get("X-Document-Id")
	documentIndex := r.Header.Get("X-Document-Index")
	documentIndexDecoded, err := url.QueryUnescape(documentIndex)
	if err != nil {
		panic(err)
	}

	body, err := ioutil.ReadAll(r.Body)

	err = ioutil.WriteFile(location, body, 0644)
	if err != nil {
		panic(err)
	}

	//add file to index
	url := "http://188.212.37.221:8095/api/citation-corpus/" + documentId

	var jsonStr = []byte(documentIndexDecoded)
	indexRequest, err := http.NewRequest("PUT", url, bytes.NewBuffer(jsonStr))

	client := &http.Client{}
	resp, err := client.Do(indexRequest)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	w.WriteHeader(200)
}

func gitPush() {
	app := "echo"

	arg0 := "-e"
	arg1 := "Hello world"
	arg2 := "\n\tfrom"
	arg3 := "golang"

	cmd := exec.Command(app, arg0, arg1, arg2, arg3)
	stdout, err := cmd.Output()

	if err != nil {
		Println(err.Error())
		return
	}

	Print(string(stdout))
}

// curl -X POST -H "Content-Type: text/plain" -H "Content-Location: /home/claudius/uuid-00304040-4a2d-47d9-b040-404a2d87d948-copy.xml" -H "X-Document-Id: uuid-00304040-4a2d-47d9-b040-404a2d87d948" -H 'X-Document-Index: {"a":"marius.clim","s":"corrected","l":"TEST5șț"}' --data '@/home/claudius/workspace/repositories/git/citation-corpus-data/files/xml/uuid-00304040-4a2d-47d9-b040-404a2d87d948.xml' http://127.0.0.1:5050

// curl -X PUT http://localhost:8095/api/citation-corpus/$base_name -d @$file_name
