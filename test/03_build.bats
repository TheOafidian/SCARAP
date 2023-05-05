#!/usr/bin/env bats

setup() {
    din=testdata/data/faas
    dout=testresults
    mkdir -p $dout
    ls $din/*.faa.gz | head -3 > $dout/faapaths.txt
}

@test "Build" {
    scarap pan $dout/faapaths.txt $dout/pan -t 16 
    scarap build $dout/faapaths.txt $dout/pan/pangenome.tsv $dout/build \
      -p 90 -f 95 -m 100
    [ -s $dout/build/cutoffs.csv ]
}

teardown() {
    rm -r $dout
}
