#!/usr/bin/env bats

setup() {
    din=testdata/data/faas
    dout=testresults
    mkdir -p $dout
    ls $din/*.faa.gz | head -3 > $dout/faapaths.txt
    cat $dout/faapaths.txt | head -4 | tail -1 > $dout/qpath.txt
}

@test "Can run a search" {
    scarap pan $dout/faapaths.txt $dout/pan -t 16 
    scarap build $dout/faapaths.txt $dout/pan/pangenome.tsv $dout/build \
      -p 90 -f 95 -m 100
    scarap search $dout/faapaths.txt $dout/build $dout/search
    [ -s $dout/search/genes.tsv ]
}

teardown() {
    rm -r $dout
}
