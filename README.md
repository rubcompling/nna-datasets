# `nna-datasets`
Datasets and scripts for the analysis of non-nominal-antecedent anaphora

## Usage


The datasets are provided in the form of TSV tables, which can be easily read
into R or Pandas as required. Each dataset contains basedata in the form of
`tokens.tsv` tables, containing tokens only, and `tokens_parsed.tsv` tables,
which contain POS tags, lemmas, and dependency parses from the [SpaCy
toolkit](https://spacy.io)

R scripts with utility functions (`util.R`), for loading data (`loadData.R`), and for generating tables and graphics (`graphics.R`) are provided in the `./scripts` directory.

If you use the `loadData.R` script to load the data, you should end up with a few useful data tables:
* `pro.tokens` -- complete corpus with SpaCy annotations (pronouns)
* `sn.tokens` -- "    " (SNs)
* `both.sns` -- shell nouns (just anaphor annotations from both annotators)
* `both.pro.withante`
* `both.sn.withcp`
* `gold.pro` -- pronouns with content (all pairs)
* `gold.all` -- shell nouns with content (all pairs)



Link tables contain rows referring to anaphor and antecedent instances (n:m
relation) and can be used to join anaphor and antecedent tables




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