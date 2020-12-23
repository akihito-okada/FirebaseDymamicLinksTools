#!/bin/bash

if [ "$1" == "-h" ]; then
  echo "Usage: $(basename "$0") [token] [durationDays]"
  exit 0
fi

if [ $# != 3 ]; then
  echo "Usage: $(basename "$0") [token] [durationDays]"
  exit 1
fi

baseDir=$(cd $(dirname $0) || exit; pwd)
tempFile="${baseDir}/temp.csv"
outputFile="${baseDir}/output.csv"

token=$1
durationDays=$2
csvFileName=$3

rm -f "$tempFile"
rm -f "$outputFile"

echo "short name,event,platform,count" >> "$tempFile"
while read row; do
  column1=$(echo "${row}" | cut -d , -f 1)
  column2=$(echo "${row}" | cut -d , -f 2)
  curl -s --request GET --header "Authorization: Bearer ${token}" "https://firebasedynamiclinks.googleapis.com/v1/${column2}/linkStats?durationDays=${durationDays}" | jq -r ".linkEventStats[] | [\"${column1}\", .event, .platform, .count] |@csv" >> "$tempFile"
done < "$csvFileName"

sed "s/\"//g" "$tempFile" >> "$outputFile"

rm -f "$tempFile"