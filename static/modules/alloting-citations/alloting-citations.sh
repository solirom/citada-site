
#!/bin/bash

index_name="citation-corpus"
current_dir=$(pwd)
echo $current_dir
output_dir=$current_dir/../../../tmp/alloting-citations/
xml_files_dir=${output_dir}xml/
json_files_dir=${output_dir}json/

rm -rf "$xml_files_dir" "$json_files_dir"
mkdir -p "$xml_files_dir" "$json_files_dir"

# allot the citations
time java -jar ~/workspace/repositories/git/solirom-xquery-service/bin/saxon9he.jar -s:"./input/" -xsl:"alloting-citations.xsl" redactorId=$1 numberOfEntries=$2 -o:"$xml_files_dir"

# generate the index files
time java -jar ~/workspace/repositories/git/solirom-xquery-service/bin/saxon9he.jar -s:"$xml_files_dir" -xsl:"../generate-index/generate-index.xsl" -o:"$json_files_dir"

# copy the alloted files
time rsync -P -rsh=ssh $xml_files_dir claudius@188.212.37.221:/var/web/solirom-admin-site/modules/citations/citation-corpus-data/files/xml/

# git push the changes
ssh -t claudius@188.212.37.221 sudo bash /home/claudius/manual-indexing/citation-corpus/git-push.sh "$1 $2"

# git pull the changes
cd /home/claudius/workspace/repositories/git/citation-corpus-data/
git pull

# generate the index records
cd "$current_dir/$json_files_dir"
for file_name in  *.json
do
    base_name=$(basename "$file_name" | cut -d. -f1)
    curl -f -X PUT http://188.212.37.221:8095/api/$index_name/$base_name -d @$file_name --fail --silent --show-error
done
