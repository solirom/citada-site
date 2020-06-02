
#!/bin/bash

current_dir=$(pwd)
echo $current_dir

output_dir=./output
rm -rf "$output_dir"
mkdir "$output_dir"
java -jar ~/workspace/repositories/git/solirom-xquery-service/bin/saxon9he.jar -s:"./input/" -xsl:"/home/claudius/workspace/repositories/go/src/solirom.ro/solirom/citada-site/static/modules/tei-to-html/tei-to-html.xsl" -o:"./output/"

