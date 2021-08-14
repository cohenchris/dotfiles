#!/bin/bash

function redshift_on () {
  if [[ "$REDSHIFT_VAL" == "" ]]; then
    return 0
  else
    return 1
  fi
}

REDSHIFT_VAL=
DEFAULT=1500

type=$1

if [[ "$type" == "up" ]]; then
  redshift_on
  if [[ $? == 0 ]]; then
    REDSHIFT_VAL="$DEFAULT"
    redshift -PO $REDSHIFT_VAL
  elif [[ $? == 1 ]]; then
    export REDSHIFT_VAL=$REDSHIFT_VAL+5
    redshift -PO $REDSHIFT_VAL
  fi
  echo $?
elif [[ "$type" == "down" ]]; then
  redshift_on
  echo $?
elif [[ "$type" == "off" ]]; then
  redshift -x
else
  # function not supported
  echo
fi
