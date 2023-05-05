#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    DIN=testdata/data/faas
    DOUT=testresults
    # Prepare data
    mkdir -p $DOUT
    ls $DIN/*.faa.gz | head -3 > $DOUT/faapaths.txt
}
    
@test "Can run with faapaths" {
    scarap pan $DOUT/faapaths.txt $DOUT/pan -t 16 # with faapaths
}

@test "Can run with faafolder" {
    scarap pan $DIN $DOUT/pan -t 16 # with faafolder
}

@test "Running with redundant genes should give error" {
    ls $DIN/{extra,redundant}/*.faa.gz >> $DOUT/faapaths.txt
    redundant_run() {
        scarap pan $DOUT/faapaths.txt $DOUT/pan -t 16
    }
    run redundant_run
    assert_failure
}

teardown() {
    rm -r $DOUT 
}
