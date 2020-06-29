#!/bin/bash

#time java -jar /home/claudius/workspace/repositories/git/solirom-xquery-service/bin/saxon9he.jar -s:"/home/claudius/workspace/repositories/xars/citation-corpus-data/xml/" -xsl:"/home/claudius/identity.xsl" -o:"/home/claudius/workspace/repositories/xars/citation-corpus-data/indented-xml/"

time java -jar /home/claudius/workspace/repositories/git/solirom-xquery-service/bin/saxon9he.jar -s:"/home/claudius/workspace/repositories/git/citation-corpus-data/files/xml/" -xsl:"/home/claudius/identity.xsl" -o:"/home/claudius/workspace/repositories/git/citation-corpus-data/files/indented-xml/"

