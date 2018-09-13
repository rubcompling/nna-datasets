

# Loading basedata
pron.tokens <- read.delim("../pronouns/tokens_parsed.tsv", 
                          encoding = "UTF-8", stringsAsFactors = F)
sn.tokens <- read.delim("../shellnouns-de/tokens_parsed.tsv",
                        encoding = "UTF-8", stringsAsFactors = F)


# Gold-standard annotations

## pronouns
### anaphors
gold.ana <- read.delim("../pronouns/gold/anaphors.tsv", stringsAsFactors = F)

### antecedents
gold.ante <- read.delim("../pronouns/gold/antecedents.tsv", stringsAsFactors = F)

### linked
gold.prolinks <- read.delim("../pronouns/gold/linktable.tsv")
gold.pro <- full_join(full_join(gold.ana, 
                                gold.prolinks, by = c("id" = "ana"), suffix=c(".ana", ".link")),
                      gold.ante, by = c("ante" = "id"), suffix = c(".ana", ".ante"))

### Add distance and lemma information (pronouns)
gold.pro$distance <- calc.distance(gold.pro$iset.ana, gold.pro$iset.ante)
gold.pro$lowercase <- tolower(gold.pro$text.ana)

### Pronoun lemma frequencies
pro.freqs <- table(gold.pro %>% filter(!is.na(distance)) %>% select(lowercase))
gold.pro$lemma.freq <- sapply(gold.pro$lowercase, function(x) { pro.freqs[x] })

### Antecedent types
gold.pro$category <- sapply(gold.pro$iset.ante, 
                            function(x) { 
                              if (!is.na(x)) 
                                get.category(pron.tokens[iset.expand(x),]) 
                              else
                                NA
                            })


## shell nouns

### anaphors
gold.sn <- read.delim("../shellnouns-de/gold/shellnouns.tsv", stringsAsFactors = F)

### antecedents
gold.cp <- read.delim("../shellnouns-de/gold/contentphrases.tsv", stringsAsFactors = F)

### linking (all pairs)
gold.links <- read.delim("../shellnouns-de/gold/linktable.tsv")
gold.all <- full_join(full_join(gold.sn, 
                                gold.links, by = c("id" = "sn"), suffix=c(".sn", ".link")),
                      gold.cp, by = c("cp" = "id"), suffix = c(".sn", ".cp"))

### Add distance and lemma information
gold.all$distance <- calc.distance(gold.all$iset.sn, gold.all$iset.cp)
gold.all$lemma <- as.character(sn.tokens[gold.all$iset.sn,]$lemma)

### Correcting silly lemmas 
correct.lemmas <- function(dataset) {
  dataset[dataset$lemma == "planen" & !is.na(dataset$shellnoun),]$lemma <- "Plan"
  dataset[dataset$lemma == "zielen" & !is.na(dataset$shellnoun),]$lemma <- "Ziel"
  dataset[dataset$lemma == "versuchen" & !is.na(dataset$shellnoun),]$lemma <- "Versuch"
  dataset[dataset$lemma == "gründen" & !is.na(dataset$shellnoun),]$lemma <- "Grund" 
  dataset[dataset$lemma == "aufgeben" & !is.na(dataset$shellnoun),]$lemma <- "Aufgabe"
  dataset[dataset$lemma == "Schlussfolgerungen" & !is.na(dataset$shellnoun),]$lemma <- "Schlussfolgerung"
  return(dataset)
}
gold.all <- correct.lemmas(gold.all)

### frequency of *postive* cases
sn.freqs <- table(gold.all %>% filter(!is.na(distance)) %>% select(lemma))
gold.all$lemma.freq <- sapply(gold.all$lemma, function(x) { sn.freqs[x] } )

### Adding antecedent categories
gold.all$category <- sapply(gold.all$iset.cp, 
                            function(x) { 
                              if (!is.na(x)) 
                                get.category(sn.tokens[iset.expand(x),]) 
                              else
                                NA
                            })




# Unmerged annotations
## pronouns 
### anaphors 
a1.ana <- read.delim("../pronouns/annotator1/anaphors.tsv", 
                     encoding="UTF-8", stringsAsFactors = F)
a2.ana <- read.delim("../pronouns/annotator2/anaphors.tsv", 
                     encoding = "UTF-8", stringsAsFactors = F)

### antecedents
a1.ante <- read.delim("../pronouns/annotator1/antecedents.tsv", 
                      encoding="UTF-8", stringsAsFactors = F)
a2.ante <- read.delim("../pronouns/annotator2/antecedents.tsv", 
                      encoding = "UTF-8", stringsAsFactors = F)

### linking
a1.link <- read.delim("../pronouns/annotator1/linktable.tsv", encoding = "UTF-8")
a2.link <- read.delim("../pronouns/annotator2/linktable.tsv", encoding = "UTF-8")
a1.pron <- inner_join(inner_join(a1.ana, 
                                 a1.link, 
                                 by = c("id" = "ana"), 
                                 suffix = c(".ana", ".link")),
                      a1.ante,
                      by = c("ante" = "id"), 
                      suffix = c(".ana", ".ante"))
a2.pron <- inner_join(inner_join(a2.ana, 
                                 a2.link, 
                                 by = c("id" = "ana"), 
                                 suffix = c(".ana", ".link")),
                      a2.ante, 
                      by = c("ante" = "id"), 
                      suffix = c(".ana", ".ante"))

a1.pron$iset.ana <- as.integer(a1.pron$iset.ana)   # this correction is necessary for some reason 
both.pro.withante <- inner_join(a1.pron, a2.pron, by = "iset.ana", suffix = c(".a1", ".a2"))

### add data on antecedent string mismatches
both.pro.withante <- add.string.mismatches(both.pro.withante, pron.tokens, "iset.ante.a1", "iset.ante.a2")


## shell nouns
### anaphors
a1.sns <- read.delim("../shellnouns-de/annotator1/shellnouns.tsv", 
                     encoding = "UTF-8", stringsAsFactors = F)
a2.sns <- read.delim("../shellnouns-de/annotator2/shellnouns.tsv", 
                     encoding = "UTF-8", stringsAsFactors = F)

### antecedents
a1.cps <- read.delim("../shellnouns-de/annotator1/contentphrases.tsv", 
                     encoding = "UTF-8", stringsAsFactors = F)
a2.cps <- read.delim("../shellnouns-de/annotator2/contentphrases.tsv", 
                     encoding = "UTF-8", stringsAsFactors = F)

### comparison table (anaphors only)
both.sns <- full_join(a1.sns, a2.sns, by = "iset", suffix = c(".a1", ".a2"))

### adding some info to the annotations
nouns <- sn.nouns <- scan("annotation-nouns.de", what = character(), encoding = "UTF-8")
both.sns$lemma <- as.character(sn.tokens[both.sns$iset,]$lemma)
both.sns$sn.match <- both.sns$shellnoun.a1 == both.sns$shellnoun.a2

### Correcting weird Spacy lemmas
both.sns[both.sns$lemma == "planen",]$lemma <- "Plan"
both.sns[both.sns$lemma == "zielen",]$lemma <- "Ziel"
both.sns[both.sns$lemma == "versuchen",]$lemma <- "Versuch"
both.sns[both.sns$lemma == "gründen",]$lemma <- "Grund" 
both.sns[both.sns$lemma == "aufgeben",]$lemma <- "Aufgabe"
both.sns[both.sns$lemma == "Schlussfolgerungen",]$lemma <- "Schlussfolgerung"

### linking (1:1 pairs only)
a1.snlink <- read.delim("../shellnouns-de/annotator1/linktable.tsv", encoding="UTF-8")
a2.snlink <- read.delim("../shellnouns-de/annotator2/linktable.tsv", encoding = "UTF-8")

a1.snlink.single <- a1.snlink %>% distinct(sn, .keep_all = TRUE)
a2.snlink.single <- a2.snlink %>% distinct(sn, .keep_all = TRUE)

a1.sncp <- inner_join(inner_join(a1.sns, 
                                 a1.snlink.single, 
                                 by = c("id" = "sn"), 
                                 suffix = c("sn", ".link")),
                      a1.cps,
                      by = c("cp" = "id"), 
                      suffix = c(".sn", ".cp"))
a2.sncp <- inner_join(inner_join(a2.sns, 
                                 a2.snlink.single, 
                                 by = c("id" = "sn"), 
                                 suffix = c("sn", ".link")),
                      a2.cps,
                      by = c("cp" = "id"), 
                      suffix = c(".sn", ".cp"))

both.sn.withcp <- inner_join(a1.sncp, a2.sncp, by = "iset.sn", suffix = c(".a1", ".a2"))
both.sn.withcp <- add.string.mismatches(both.sn.withcp, sn.tokens, "iset.cp.a1", "iset.cp.a2")
