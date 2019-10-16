#!/bin/bash

Time=0
PATH_TO_DUMP=/usr/lib/wso2/wso2am/2.6.0/repository/logs/

#Find any Backup File defined by the time constraint
find $PATH_TO_DUMP -type f -mtime $Time -not -path "*.gz" -name "*.log.*" | while read file
do

  #To verify if $file is empty or has some value
  if [ ! -n "$file" ]; then
    echo "No Earlier Backups were found to compress"
  else
    echo "Earlier Backups $file will be compressed"
    gzip "$file"
  fi

done