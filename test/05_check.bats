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

@test "Can filter" {
    scarap checkgroups $dpan/pangenome.tsv $dgroups
    awk '$2 == 1.0 {print $1}' $dgroups/orthogroups.tsv \
     > $dout/orthogroups_core.txt

    cat $dout/orthogroups_core.txt | head -n 10 > $dout/orthogroups_core_sub.txt

    scarap filter -c -o $dout/orthogroups_core_sub.txt \
     $dpan/pangenome.tsv $dout
    [ -s $dout/pangenome.tsv ]
}

teardown() {
    rm -r $dout
}
