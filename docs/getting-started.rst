Getting started
===============

Obtaining data
--------------

SCARAP works mainly with faa files: amino acid sequences of all (predicted) genes in a genome assembly. You can obtain faa files in at least three ways:

* You can run a gene prediction tool like `Prodigal <https://github.com/hyattpd/Prodigal>`_ on genome assemblies of your favorite strains, or a complete annotation pipeline such as `Prokka <https://github.com/tseemann/prokka>`_ or `Bakta <https://github.com/oschwengers/bakta>`_.
* You can search your favorite taxon on `NCBI genome <https://www.ncbi.nlm.nih.gov/datasets/genome/>`_ and manually download assemblies in the following way: click on an assembly, click "Download", select "Protein (FASTA)" as file type and click "Download" again.
* Given a list of assembly accession numbers (i.e. starting with GCA/GCF), you can use `ncbi-genome-download <https://github.com/kblin/ncbi-genome-download/>`_ to download the corresponding faa files.

Given a list of accessions in a file called ``accessions.txt``, you can use ncbi-genome-download to download faa files as follows: ::
    
    ncbi-genome-download -P \
    --assembly-accessions accessions.txt \
    --section genbank \
    --formats protein-fasta \
    bacteria

Inferring a pangenome
---------------------

If you want to infer the pangenome of a set of genomes, you only need their faa files (fasta files with protein sequences) as input. If the faa files are stored in a folder ``faas``, you can infer the pangenome using 16 threads by running: ::

    scarap pan ./faas ./pan -t 16

The pangenome will be stored in ``pan/pangenome.tsv``
The pangenome is stored in a "long format": a table with the columns gene, genome and orthogroup.

Inferring a core genome
-----------------------

If you want to infer the core genome of a set of genomes directly, without inferring the full pangenome first, you can also do this with SCARAP. The reason you might want to do this, is because it is faster and because you sometimes don't need more than the core genome (e.g. when you are planning to infer a phylogeny).

You can infer the core genome, given a set of faa files in a folder ``faas``, in the following way: ::

    scarap core ./faas ./core -t 16

The core genome will be stored in ``core/genes.tsv``.

Subsampling a set of genomes
---------------------------

If you have a (large) dataset of genomes that you wish to subsample in a
representative way, you can do this using the ``sample`` module. You
will need to precompute the pangenome or core genome to do this; SCARAP
calculates average amino acid identity (AAI) or core amino acid identity
(cAAI) values in the subsampling process, and it uses the single-copy
orthogroups from a pan- or core genome to do this.

For example, if you want to sample 100 genomes given a set of faa files
in a folder ``faas``:

::

     scarap core ./faas ./core -t 16
     scarap sample ./faas ./core/genes.tsv ./representatives -m 100 -t 16
     

The representative genomes will be stored in
``representatives/seeds.txt``.

Important remark: by default, the per-gene amino acid identity values
are estimated from alignment scores per column by MMseqs (`alignment
mode
1 <https://github.com/soedinglab/MMseqs2/wiki#how-does-mmseqs2-compute-the-sequence-identity>`__).
For AAI values > 90%, these estimations are on average smaller than the
exact values. It is possible to calculate exact AAI values by adding the
``--exact`` option to the sample module, but this will be slower.

You can also sample genomes based on average nucleotide identity (ANI)
or core nucleotide identity (cANI) values. In that case, you need to
supply nucleotide sequences of predicted genes, e.g. in a folder
``ffns``:

::

     scarap core ./faas ./core -t 16
     scarap sample ./ffns ./core/genes.tsv ./representatives -m 100 -t 16

Building a “supermatrix” for a set of genomes
----------------------------------------------

You can build a concatenated alignment of core genes (“supermatrix”) for
a set of genomes using the ``concat`` module.

Let’s say you want to build a supermatrix of 100 core genes for a set of
genomes, with faa files given in a folder ``faas``:

::

     scarap core ./faas ./core -m 100 -t 16
     scarap concat ./faas ./core/genes.tsv ./supermatrix -t 16
     

The amino acid supermatrix will be saved in
``supermatrix/supermatrix_aas.fasta``.

If you want to produce a nucleotide-level supermatrix, this can be
achieved by giving a folder with ffn files (nucleotide sequences of
predicted genes) as an additional argument:

::

     scarap concat ./faas ./core/genes.tsv ./supermatrix -n ./ffns -t 16
     

The nucleotide-level supermatrix will be saved in
``supermatrix/supermatrix_nucs.fasta``.
