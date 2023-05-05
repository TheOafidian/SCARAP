#!/usr/bin/env bats

setup() {
    din=testdata/data/faas
    dpan=testresults/pan
    dout=testresults
    dcheck=$dout/checkgenomes
    mkdir -p $dcheck
    ls $din/*.faa.gz | head -3 > $dout/faapaths.txt
}

@test "Check genomes" {
    scarap pan $dout/faapaths.txt $dpan -t 16 
    scarap checkgenomes $dpan/pangenome.tsv $dcheck
    [ -s $dcheck/genomes.tsv ]
}

teardown() {
    rm -r $dout
}
