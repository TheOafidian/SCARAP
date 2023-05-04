#!/usr/bin/env bash

ls $DIN/*.faa.gz | head -3 > $DOUT/faapaths.txt

if [$TEST == 1]
then
# add redundant gene names --> should give ERROR
ls $DIN/{extra,redundant}/*.faa.gz >> $DOUT/faapaths.txt

elif [[$TEST == 2]]
then
scarap pan $DOUT/faapaths.txt $DOUT/pan -t 16 # with faapaths
else
scarap pan $DIN $DOUT/pan -t 16 # with faafolder
fi
