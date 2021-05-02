#!/bin/bash

# Do some prep work
command -v jq >/dev/null 2>&1 || {
	echo >&2 "We require jq for this script to run, but it's not installed.  Aborting."
	exit 1
}
command -v curl >/dev/null 2>&1 || {
	echo >&2 "We require curl for this script to run, but it's not installed.  Aborting."
	exit 1
}
# set the query
QUERY="${1:-1 John 3:16-18}"
# set the translation
VERSION="${2:-kjv}"
# get the name from the query
BOOKNAME=$(echo ${QUERY%%[0-9]?:*} | xargs echo -n)
BOOKNAME=$(echo ${BOOKNAME%%[0-9]:*} | xargs echo -n)
BOOKS=$(curl -s "https://getbible.net/v2/${VERSION}/books.json")
NUMBERS=$(echo "${QUERY//$BOOKNAME/}" | xargs echo -n)
CHAPTER_NR=$(echo "${NUMBERS%:*}" | xargs echo -n)
VERSES_NR=$(echo "${NUMBERS#*:}" | xargs echo -n)
BOOK_NR=$(echo "$BOOKS" | jq -r ".[] | select(.name == \"${BOOKNAME}\") | .nr")
CHAPTER=$(curl -s "https://getbible.net/v2/${VERSION}/${BOOK_NR}/${CHAPTER_NR}.json")
IFS=',' read -ra VERSES_NR_ARRAY <<< "${VERSES_NR}"
SCRIPTURE=()
for VER_NR in "${VERSES_NR_ARRAY[@]}"
do
   if [[ "${VER_NR}" == *"-"* ]]; then
     IFS='-' read -ra VER_NR_ARRAY <<< "${VER_NR}"
     START=${VER_NR_ARRAY[0]}
     END=${VER_NR_ARRAY[-1]}
     while [ "$START" -le "$END" ]; do
      VERSE=$(echo "$CHAPTER" | jq -r ".verses[] | select(.verse == ${START})")
      TEXT=$(echo "$VERSE" | jq -r '.text' )
      SCRIPTURE+=("${START} ${TEXT}")
      START=$(($START + 1))
     done
   else
     VERSE=$(echo "$CHAPTER" | jq ".verses[] | select(.verse == ${VER_NR})")
     TEXT=$(echo "$VERSE" | jq -r '.text' )
     SCRIPTURE+=("${VER_NR} ${TEXT}")
   fi
done

# we return the scripture one verse per/line
IFS=$'\n'; echo "${SCRIPTURE[*]}"
