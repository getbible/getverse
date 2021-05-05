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
# set the query (default: 1 John 3:16-18)
QUERY="${1:-62 3:16-18}"
# set the translation (default: kjv)
VERSION="${2:-kjv}"
# get the name from the query TODO: find better filter
BOOKNAME=$(echo ${QUERY%%[0-9][0-9]?:*} | xargs echo -n)
BOOKNAME=$(echo ${BOOKNAME%%[0-9]?:*} | xargs echo -n)
BOOKNAME=$(echo ${BOOKNAME%%[0-9]:*} | xargs echo -n)
# check if the name was given by number
re='^[0-9]+$'
if [[ "$BOOKNAME" =~ $re ]]; then
  BOOK_NR="${BOOKNAME}"
else
  # get the list of books from the API to get the book number
  BOOKS=$(curl -s "https://getbible.net/v2/${VERSION}/books.json")
  BOOK_NR=$(echo "$BOOKS" | jq -r ".[] | select(.name == \"${BOOKNAME}\") | .nr")
fi
# get chapter and verses numbers
NUMBERS=$(echo "${QUERY/$BOOKNAME/}" | xargs echo -n)
# get chapter number
CHAPTER_NR=$(echo "${NUMBERS%:*}" | xargs echo -n)
# get verses numbers
VERSES_NR=$(echo "${NUMBERS#*:}" | xargs echo -n)
# get chapter text from getBible API
CHAPTER=$(curl -s "https://getbible.net/v2/${VERSION}/${BOOK_NR}/${CHAPTER_NR}.json")
# read verses into array by comma separator
IFS=',' read -ra VERSES_NR_ARRAY <<<"${VERSES_NR}"
# start the scripture array
SCRIPTURE=()
# load the verses in this loop over the verse numbers sets
for VER_NR in "${VERSES_NR_ARRAY[@]}"; do
  # check if this is a range of verses
  if [[ "${VER_NR}" == *"-"* ]]; then
    IFS='-' read -ra VER_NR_ARRAY <<<"${VER_NR}"
    START=${VER_NR_ARRAY[0]}
    END=${VER_NR_ARRAY[-1]}
    while [ "$START" -le "$END" ]; do
      VERSE=$(echo "$CHAPTER" | jq -r ".verses[] | select(.verse == ${START})")
      TEXT=$(echo "$VERSE" | jq -r '.text')
      SCRIPTURE+=("${START} ${TEXT}")
      START=$(($START + 1))
    done
  else
    VERSE=$(echo "$CHAPTER" | jq ".verses[] | select(.verse == ${VER_NR})")
    TEXT=$(echo "$VERSE" | jq -r '.text')
    SCRIPTURE+=("${VER_NR} ${TEXT}")
  fi
done
# we return the scripture one verse per/line
IFS=$'\n'; echo "${SCRIPTURE[*]}"
