var hash = {
    "&#354;": "&#538;",
    "&#355;": "&#539;",
    "&#351;": "&#537;",
    "&#350;": "&#536;"    
};

new ClipboardJS(".btn", {
    target: function(trigger) {
        return trigger.nextElementSibling;
    }
});    

$("#search-button").click(function() {
    search();
});

$("#search-string").keypress(function (event) {
    var code = event.keyCode || event.which;
    
    if (code == 13) {
        search();
    }
});    

function search() {
    const searchResultContainer = document.querySelector("#search-result tbody");
    searchResultContainer.innerHTML = '<i class="fas fa-spinner fa-spin-reverse fa-3x"></i>';    
    
    $("#search-button > i").toggleClass("fa-search fa-spinner fa-spin");    
    var searchString = $("#search-string").val();
    searchString = searchString.split("").map((letter) => hash[letter] || letter).join("");
    
    if (!searchString.includes(':')) {
        searchString = "l:" + searchString;
    }
    if (searchString != "") {
        fetch("/api/citation-corpus/_search", {
            method: "POST",
            body: '{"size": 2000, "from": 0, "query": {"boost": 1, "query": "' + searchString + '"}, "fields": ["*"]}'
        })
        .then((response) => response.json())
        .then((data) => {
            var processedData = [];
            
            data.hits.forEach(element => {
                var item = {
                    "headword": element.fields.s,
                    "id": element.id,
                    "l":  element.fields.l                        
                }
                processedData.push(item)
            });
            processedData.sort((a, b) => (a.l > b.l) ? 1 : -1)
            
            var results = document.createDocumentFragment();
            
            processedData.forEach((element, index) => {
                var row = document.createElement("tr");
                var indexCell = document.createElement("td");
                indexCell.innerHTML = index + 1;
                
                var lemmaCell = document.createElement("td");
                lemmaCell.innerHTML = element.l;
                
                row.appendChild(indexCell);
                row.appendChild(lemmaCell);
                
                results.appendChild(row);
                /*
                const entryStatus = element.status;
                
                var entryDiv = document.createElement("div");
                entryDiv.setAttribute("id", element.id);
                
                var titleSpan = document.createElement("span");
                titleSpan.innerHTML = element.headword;
                entryDiv.appendChild(titleSpan);     
                
                entryDiv.addEventListener('click', event => {
                    if (!document.querySelector("#save-button").disabled) {
                        alert("Salvați intrarea curentă înainte de a edita alta!");
                    } else {
                        const uuid = entryDiv.getAttribute("id");
                        solirom.dataInstances.uuid = uuid;
                        //solirom.dataInstances.url = "/data/api/v1/repos/solirom/citation-corpus-data/contents/files/xml/" + solirom.dataInstances.uuid + ".xml?access_token=a6ddbb24ea29bee69670815cd4aca6b6703940cc";
                        solirom.dataInstances.url = "/modules/citations/citation-corpus-data/files/xml/" + solirom.dataInstances.uuid + ".xml";
                        
                        fetch(solirom.dataInstances.url, {
                            headers: {
                                "Cache-Control": "no-store, no-cache, must-revalidate"                            
                            }
                        })
                        .then((response) => response.text())
                        .then((data) => {
                            //solirom.dataInstances.sha = data.sha;
                            //var content = data.content;
                            //content = solirom.actions.b64DecodeUnicode(content);
                            teian.editor.setAttribute("status", "edit");
                            teian.editor.setAttribute("src", "data:application/xml;" + data);
                        })
                        .catch((error) => {
                            console.error('Error:', error);
                        });                         
                    }
                });  
                
                var entryStyle = entryDiv.style;
                switch (entryStatus) {
                    case "elaborated":
                    entryStyle.backgroundColor = "#f5f2bc";
                    break;
                    case "corrected":
                    entryStyle.backgroundColor = "#9bf47e";
                    break;
                    default:
                }         */           
            });            
            
            searchResultContainer.innerHTML = "";
            searchResultContainer.appendChild(results);  
            $("#search-button > i").toggleClass("fa-search fa-spinner fa-spin"); 
        })
        .catch((error) => {
            console.error('Error:', error);
        });   
    }    
}
