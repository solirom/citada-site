package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/blevesearch/bleve"
	_ "github.com/blevesearch/bleve/config"
	bleveHttp "github.com/blevesearch/bleve/http"
	"github.com/gorilla/mux"
)

const indexDir = "indexes"

func init() {

	router := mux.NewRouter()
	router.StrictSlash(true)

	searchHandler := bleveHttp.NewSearchHandler("")
	searchHandler.IndexNameLookup = indexNameLookup
	router.Handle("/api/search/{indexName}", searchHandler).Methods("POST")

	router.PathPrefix("/").Handler(http.FileServer(http.Dir("./static/")))

	router.PathPrefix("/").HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "static/index.html")
	})

	http.Handle("/", router)

	log.Printf("opening indexes")
	// walk the data dir and register index names
	dirEntries, err := ioutil.ReadDir(indexDir)
	if err != nil {
		log.Printf("error reading data dir: %v", err)
		return
	}

	for _, dirInfo := range dirEntries {
		indexPath := indexDir + string(os.PathSeparator) + dirInfo.Name()

		if !dirInfo.IsDir() {
			log.Printf("see file %s, this is not supported in the appengine environment", dirInfo.Name())
		} else {
			i, err := bleve.OpenUsing(indexPath, map[string]interface{}{
				"read_only": true,
			})
			if err != nil {
				log.Printf("error opening index %s: %v", indexPath, err)
			} else {
				log.Printf("registered index: %s", dirInfo.Name())
				bleveHttp.RegisterIndexName(dirInfo.Name(), i)
			}
		}
	}
}

func muxVariableLookup(req *http.Request, name string) string {
	return mux.Vars(req)[name]
}

func indexNameLookup(req *http.Request) string {
	return muxVariableLookup(req, "indexName")
}
