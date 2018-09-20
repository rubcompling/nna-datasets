# `nna-datasets`
Datasets and scripts for the analysis of anaphora with non-nominal antecedents

## Citation

For the pronominal dataset:

Dipper, S. & Zinsmeister, H. (2012). Annotating abstract anaphora. *Language Resources and Evaluation*, 46, pp. 37&ndash;52.

And the shell nouns dataset:

Simonjetz, F. & Roussel, A. (2016). Crosslinguistic Annotation of German and English Shell Noun Complexes. *Proceedings of the 13th Conference on Natural Language Processing (KONVENS)*, pp. 265&ndash;278.



## Usage


The datasets are provided in the form of TSV tables, which can be easily read
into R or Pandas as required. Each dataset contains basedata in the form of
`tokens.tsv` tables, containing tokens only, and `tokens_parsed.tsv` tables,
which contain POS tags, lemmas, and dependency parses from the [SpaCy
toolkit](https://spacy.io).

R scripts with utility functions (`util.R`), for loading data (`loadData.R`), and for generating tables and graphics (`graphics.R`) are provided in the `./scripts` directory.

If you use the `loadData.R` script to load the data, you should end up with a few useful data tables:
* `pro.tokens` -- complete corpus with SpaCy annotations (pronouns)
* `sn.tokens` -- "    " (SNs)
* `both.sns` -- shell nouns (just anaphor annotations from both annotators)
* `both.pro.withante` -- pronoun data from both annotators with antecedents
* `both.sn.withcp` -- shell noun data from both annotators (only pairs where both annotators marked just one antecedent)
* `gold.pro` -- pronouns with content (all pairs)
* `gold.all` -- shell nouns with content (all pairs)



Link tables contain rows referring to anaphor and antecedent instances (n:m
relation) and can be used to join anaphor and antecedent tables (the `loadData.R` script takes care of this).




## Directory layout

<pre><font color="#729FCF"><b>.</b></font>
├── LICENSE
├── <font color="#729FCF"><b>pronouns</b></font>
│   ├── <font color="#729FCF"><b>annotator1</b></font>
│   │   ├── anaphors.tsv
│   │   ├── antecedents.tsv
│   │   └── linktable.tsv
│   ├── <font color="#729FCF"><b>annotator2</b></font>
│   │   ├── anaphors.tsv
│   │   ├── antecedents.tsv
│   │   └── linktable.tsv
│   ├── <font color="#729FCF"><b>gold</b></font>
│   │   ├── anaphors.tsv
│   │   ├── antecedents.tsv
│   │   └── linktable.tsv
│   ├── tokens_parsed.tsv
│   └── tokens.tsv
├── README.md
├── <font color="#729FCF"><b>scripts</b></font>
│   ├── annotation-nouns.de
│   ├── graphics.R
│   ├── loadData.R
│   └── util.R
├── <font color="#729FCF"><b>shellnouns-de</b></font>
│   ├── <font color="#729FCF"><b>annotator1</b></font>
│   │   ├── contentphrases.tsv
│   │   ├── linktable.tsv
│   │   └── shellnouns.tsv
│   ├── <font color="#729FCF"><b>annotator2</b></font>
│   │   ├── contentphrases.tsv
│   │   ├── linktable.tsv
│   │   └── shellnouns.tsv
│   ├── <font color="#729FCF"><b>gold</b></font>
│   │   ├── contentphrases.tsv
│   │   ├── linktable.tsv
│   │   └── shellnouns.tsv
│   ├── tokens_parsed.tsv
│   └── tokens.tsv
└── <font color="#729FCF"><b>shellnouns-en</b></font>
    ├── <font color="#729FCF"><b>annotator1</b></font>
    │   ├── contentphrases.tsv
    │   ├── linktable.tsv
    │   └── shellnouns.tsv
    ├── <font color="#729FCF"><b>annotator2</b></font>
    │   ├── contentphrases.tsv
    │   ├── linktable.tsv
    │   └── shellnouns.tsv
    ├── <font color="#729FCF"><b>gold</b></font>
    │   ├── contentphrases.tsv
    │   ├── linktable.tsv
    │   └── shellnouns.tsv
    ├── tokens_parsed.tsv
    └── tokens.tsv
</pre>