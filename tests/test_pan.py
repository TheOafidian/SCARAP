import os
import shutil

ENV_VARS = {"DIN" : "tests/data/faas", "DOUT":"testresults"}
pangenome_outf = os.path.join(ENV_VARS["DOUT"], "pan/pangenome.tsv")

def assert_pangenome_outf():
    """Asserts that the pangenome.tsv file is generated and cleans up results folder."""
    assert os.path.exists(pangenome_outf)
    shutil.rmtree(ENV_VARS["DOUT"])
 
def test_faapaths(bash):
    with bash(envvars=ENV_VARS) as s:
        s.run_script("tests/01_pan.sh")
    assert_pangenome_outf()
 
def test_faafolder(bash):
    ENV_VARS["TEST"] = "2" 
    with bash(envvars=ENV_VARS) as s:
        s.run_script("tests/01_pan.sh")
    assert_pangenome_outf()

def test_redundant_raise_error(bash):
    ENV_VARS["TEST"] = "1" 
    with bash(envvars=ENV_VARS) as s:
        s.run_script("tests/01_pan.sh")

 