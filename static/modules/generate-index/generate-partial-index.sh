
#!/bin/bash

current_dir=$(pwd)
echo $current_dir
xml_files_dir=../../../../tmp/alloting-citations-output/
json_files_dir=../../../../tmp/generate-partial-index/json
index_name="citation-corpus"

rm -rf "$json_files_dir"
mkdir -p "$json_files_dir"
time java -jar /home/claudius/workspace/software/saxon-he/saxon9he.jar -s:"$xml_files_dir" -xsl:"generate-index.xsl" -o:"$json_files_dir/"

cd "$current_dir"
for file_name in  "$json_files_dir"/*.json
do
    base_name=$(basename "$file_name" | cut -d. -f1)
    curl -f -X PUT http://188.212.37.221:8095/api/$index_name/$base_name -d @$file_name --fail --silent --show-error
done
