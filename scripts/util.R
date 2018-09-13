# tidyverse essentials
require(dplyr)
require(forcats)
require(stringr)
require(reshape2)

# IAA calculation
require(irr)

# generating plots and tables
require(ggplot2)
require(xtable)

iset.expand <- function(some.iset) {
  as.integer(unlist(strsplit(as.character(some.iset), " ")))
}

iset.collapse <- function(some.iset) {
  paste0(some.iset, collapse = " ")
}

add.string.mismatches <- function(dataset, source, col1name, col2name) {
  a1text.nota2 <- vector("character", nrow(dataset))
  a1iset.nota2 <- vector("integer", nrow(dataset))
  a2text.nota1 <- vector("character", nrow(dataset))
  a2iset.nota1 <- vector("integer", nrow(dataset))
  
  for (i in 1:nrow(dataset)) {
    a1.cp <- iset.expand(dataset[i, col1name])
    a2.cp <- iset.expand(dataset[i, col2name])
    
    i.a1nota2 <- setdiff(a1.cp, intersect(a1.cp, a2.cp)) 
    a1iset.nota2[i] <- iset.collapse(i.a1nota2)
    a1text.nota2[i] <- paste(source[i.a1nota2, "text"], collapse = " ")
    
    i.a2nota1 <- setdiff(a2.cp, intersect(a1.cp, a2.cp))
    a2iset.nota1[i] <- iset.collapse(i.a2nota1)
    a2text.nota1[i] <- paste(source[i.a2nota1, "text"], collapse = " ")
    
  }
  
  dataset$a1text.nota2 <- a1text.nota2
  dataset$a1iset.nota2 <- a1iset.nota2
  dataset$a2text.nota1 <- a2text.nota1
  dataset$a2iset.nota1 <- a2iset.nota1
  return(dataset)
}



# Get number of ids (tokens) in iset
ilen <- function(row) { 
  str_count(row, "\\d+")
}

# This bit will estimate for what proportion of the antecedents the annotators
# sequences overlapped 
# NB: pronominal data only ATM
percent.overlap <- function(dat) {
  # (a1only + a2only) / (a1 + a2)
  nonmatching.tokens <- ilen(dat[,"a1iset.nota2"]) + ilen(dat[,"a2iset.nota1"])
  alltokens <- ilen(dat[,"iset.ante.a1"]) + ilen(dat[,"iset.ante.a2"])
  (alltokens - nonmatching.tokens) / alltokens
}


# Calculate distance between shellnoun and content phrase
calc.distance <- function(sn.col, cp.col) {
  cp.starts <- as.integer(sapply(strsplit(as.character(cp.col), " "), first))
  cp.ends <- as.integer(sapply(strsplit(as.character(cp.col), " "), last))
  
  ifelse(cp.starts > sn.col,
         cp.starts - sn.col,
         cp.ends - sn.col)
}


# Antecedent types

# Find the highest token in a given token sequence
root <- function(tok.seq) {
  x <- head(tok.seq, n = 1)
  while (x$rel != "ROOT" & x$mother %in% tok.seq$id) {
    x <- tok.seq[tok.seq$id == x$mother,]
  }
  return(x)
}


# Show which tokens are dependents of a given token
daughters <- function(tok, tok.seq) {
  tok.seq[tok.seq$mother == tok$id & tok.seq$rel != "ROOT",]
}


# Determine the category of a given antecedent 
# (represented as a token sequence)
get.category <- function(tok.seq) {
  P.allowed <- c("auf", "bei", "für", "in", "mit", "nach", "um", 
                 "von", "zu")
  
  if (nrow(tok.seq) < 1) {
    return("empty")
  }
  
  last.token <- tail(tok.seq, n = 1)
  if (last.token$lemma == ".") {
    return("sent")
  } else if (last.token$lemma == "?") {
    return("quest")
  }
  
  if (nrow(tok.seq[tok.seq$pos == "VVIZU" | tok.seq$pos == "PTKZU",]) > 0) {
    return("zu")
  }
  
  first.token <- head(tok.seq, n = 1)
  first.lemma <- tolower(first.token$lemma)
  if (first.lemma == "daß" | first.lemma == "dass") {
    return("dass")
  } else if (first.lemma == "ob") {
    return("Wh-ind")
  } else if (first.lemma == "um") {
    return("um")
  }
  
  # starts with an interrogative pronoun
  else if (startsWith(first.token$pos, "PW")) {
    return("Wh-ind")
  }
  
  my.head <- root(tok.seq)
  head.daughters <- daughters(my.head, tok.seq)
  
  # is nominal 
  if (startsWith(my.head$pos, "N")) {
    # with prep (which prep?)
    if (nrow(head.daughters[startsWith(head.daughters$pos, "APPR") &
                            head.daughters$lemma %in% P.allowed,]) > 0) {
      return("PP")
    } else {
      return("NP")
    }
  } 
  
  else if (startsWith(my.head$pos, "APPR")) {
    if (my.head$lemma %in% P.allowed) {
      return("PP")
    } else {
      return("other")
    }
  }
  
  else if (startsWith(my.head$pos, "V")) {
    if (endsWith(my.head$pos, "PP")) {
      return("V-part")
    } else if (endsWith(my.head$pos, "FIN")) {
      return("V-fin")
    } else {
      return("V-other")
    }
  }
  
  else {
    return("other")
  }
  
}