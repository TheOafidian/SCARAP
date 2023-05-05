#!/usr/bin/env bats

setup() {
    din=testdata/data/faas
    dpan=testresults/pan
    dout=testresults
    dgenomes=$dout/checkgenomes
    dgroups=$dout/checkgroups
    mkdir -p $dout
    ls $din/*.faa.gz | head -3 > $dout/faapaths.txt
    scarap pan $dout/faapaths.txt $dpan -t 16 
}

@test "Can run check genomes" {
    scarap checkgenomes $dpan/pangenome.tsv $dgenomes
    [ -s $dgenomes/genomes.tsv ]
}

@test "Can run check groups" {
    scarap checkgroups $dpan/pangenome.tsv $dgroups
    [ -s $dgroups/orthogroups.tsv ]
}

teardown() {
    rm -r $dout
}
