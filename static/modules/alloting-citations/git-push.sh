

#!/bin/bash

cd /var/web/solirom-admin-site/modules/citations/citation-corpus-data/
git add .
git commit -m $1
git push origin master
