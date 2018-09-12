# `nna-datasets`
Datasets and scripts for the analysis of non-nominal-antecedent anaphora


The datasets are provided in the form of TSV tables, which can be easily read
into R or Pandas as required

Link tables contain rows referring to anaphor and antecedent instances (n:m
relation) and can be used to join anaphor and antecedent tables

`tokens_parsed.tsv` tables contain POS tags, lemmas, and dependency parses from
the [SpaCy toolkit](https://spacy.io)


## Directory layout
```
├── LICENSE
├── pronouns
│   ├── annotator1
│   │   ├── anaphors.tsv
│   │   ├── antecedents.tsv
│   │   └── linktable.tsv
│   ├── annotator2
│   │   ├── anaphors.tsv
│   │   ├── antecedents.tsv
│   │   └── linktable.tsv
│   ├── gold
│   │   ├── anaphors.tsv
│   │   ├── antecedents.tsv
│   │   └── linktable.tsv
│   ├── tokens_parsed.tsv
│   └── tokens.tsv
├── README.md
├── scripts
├── shellnouns-de
│   ├── annotator1
│   │   ├── contentphrases.tsv
│   │   ├── linktable.tsv
│   │   └── shellnouns.tsv
│   ├── annotator2
│   │   ├── contentphrases.tsv
│   │   ├── linktable.tsv
│   │   └── shellnouns.tsv
│   ├── gold
│   │   ├── contentphrases.tsv
│   │   ├── linktable.tsv
│   │   └── shellnouns.tsv
│   ├── tokens_parsed.tsv
│   └── tokens.tsv
└── shellnouns-en
    ├── annotator1
    │   ├── contentphrases.tsv
    │   ├── linktable.tsv
    │   └── shellnouns.tsv
    ├── annotator2
    │   ├── contentphrases.tsv
    │   ├── linktable.tsv
    │   └── shellnouns.tsv
    ├── gold
    │   ├── contentphrases.tsv
    │   ├── linktable.tsv
    │   └── shellnouns.tsv
    ├── tokens_parsed.tsv
    └── tokens.tsv




```