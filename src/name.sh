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
  # get the list of books from the API to get the book number
  BOOKS=$(curl -s "https://getbible.net/v2/${VERSION}/books.json")
  BOOK_NAME=$(echo "$BOOKS" | jq -r ".[] | select(.nr == ${BOOKNAME}) | .name")
  # get chapter and verses numbers
  NUMBERS=$(echo "${QUERY/$BOOKNAME/}" | xargs echo -n)
  # get chapter and verses numbers
  echo "${BOOK_NAME} ${NUMBERS}"
else
  echo "$QUERY"
fi

exit 0
