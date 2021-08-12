#/!bin/bash

#files=$(ls *.tex | wc -l)
#if [ $files -ne 1 ]; then
#  echo "ERROR: There needs to be only 1 valid LaTeX file to edit..."
#  exit
#fi

if [ $# -ne 1 ]; then
  echo "ERROR: There needs to be 1 argument (the filename to edit)"
  exit
fi

FILENAME=$1

pdf=$(ls | grep *.pdf | wc -l)
if [ $pdf -ne 1 ]; then
  ~/Projects/scripts/tex/texcompile.sh $FILENAME>> /dev/null
  exit
fi

okular *.pdf &
vim $FILENAME
