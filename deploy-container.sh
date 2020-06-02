
#!/bin/bash

project_name=${PWD##*/}
port=7002
data_git_url=ssh://claudius@188.212.37.221/home/git/solirom/citation-corpus-data.git

output_dir=./tmp/html/


go build -tags netgo -a -v

# transform the data in HTML format
mkdir -p ./tmp/${project_name}

git clone -b master --depth=1 $data_git_url ./tmp/${project_name}
rmdir -rf ./tmp/${project_name}/.git

rm -rf "$output_dir"
mkdir "$output_dir"

java -jar ~/workspace/repositories/git/solirom-xquery-service/bin/saxon9he.jar -s:"./tmp/${project_name}/files/xml/" -xsl:"./static/modules/tei-to-html/tei-to-html.xsl" -o:"$output_dir"

#time sudo docker build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" -t ${project_name} .

#sudo docker save ${project_name}:latest | gzip > /home/claudius/workspace/repositories/go/bin/${project_name}-latest.tar.gz

#rsync -P -rsh=ssh /home/claudius/workspace/repositories/go/bin/${project_name}-latest.tar.gz claudius@85.186.121.41:/home/claudius/

#echo "sudo docker stop ${project_name} && sudo docker load -i ${project_name}-latest.tar.gz && sudo docker run --restart always --name ${project_name} -d -p ${port}:7777 ${project_name}:latest"
