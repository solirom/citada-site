#!/bin/bash

current_dir=$(pwd)
echo $current_dir
xml_files_dir=/var/web/solirom-admin-site/modules/citations/citation-corpus-data/files/xml
index_name="citation-corpus"
json_files_dir="$current_dir"/json

rm -rf "$json_files_dir"
mkdir "$json_files_dir"
time java -jar /var/web/solirom-xquery-service/saxon9he.jar -s:"$xml_files_dir" -xsl:"generate-index.xsl" -o:"$json_files_dir/"

cd "$current_dir"
time for file_name in  "$json_files_dir"/*.json
do
    base_name=$(basename "$file_name" | cut -d. -f1)
    curl -f -X PUT http://localhost:8095/api/$index_name/$base_name -d @$file_name
done

