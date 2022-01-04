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
SCRIPTURE="${1:-62 3:16-18}"
# set the translation (default: kjv)
: "${VERSION:=kjv}"

# check if we have options
while :; do
  case $1 in
  -s | --scripture) # Takes an option argument; ensure it has been specified.
    if [ "$2" ]; then
      SCRIPTURE=$2
      shift
    else
      echo >&2 '"--scripture" requires a non-empty option argument.'
      exit 17
    fi
    ;;
  -s=?* | --scripture=?*)
    SCRIPTURE=${1#*=} # Delete everything up to "=" and assign the remainder.
    ;;
  -s= | --scripture=) # Handle the case of an empty --scripture=
    echo >&2 '"--scripture=" requires a non-empty option argument.'
    exit 17
    ;;
  -v | --version) # Takes an option argument; ensure it has been specified.
    if [ "$2" ]; then
      VERSION=$2
      shift
    else
      echo >&2 '"--version" requires a non-empty option argument.'
      exit 17
    fi
    ;;
  -v=?* | --version=?*)
    VERSION=${1#*=} # Delete everything up to "=" and assign the remainder.
    ;;
  -v= | --version=) # Handle the case of an empty --version=
    echo >&2 '"--version=" requires a non-empty option argument.'
    exit 17
    ;;
  *) # Default case: No more options, so break out of the loop.
    break ;;
  esac
  shift
done

# get the name from the query TODO: find better filter
BOOK_NAME=$(echo "${SCRIPTURE%%[0-9][0-9]?:*}" | xargs echo -n)
BOOK_NAME=$(echo "${BOOK_NAME%%[0-9]?:*}" | xargs echo -n)
BOOK_NAME=$(echo "${BOOK_NAME%%[0-9]:*}" | xargs echo -n)

# check if the name was given by number
re='^[0-9]+$'
if [[ "$BOOK_NAME" =~ $re ]]; then
  # get the list of books from the API to get the book number
  BOOKS=$(curl -s "https://getbible.net/v2/${VERSION}/books.json")
  BOOK_FULL_NAME=$(echo "$BOOKS" | jq -r ".[] | select(.nr == ${BOOK_NAME}) | .name")
  # get chapter and verses numbers
  NUMBERS=$(echo "${SCRIPTURE/$BOOK_NAME/}" | xargs echo -n)
  # get chapter and verses numbers
  echo "${BOOK_FULL_NAME} ${NUMBERS}"
else
  echo "$SCRIPTURE"
fi

exit 0
