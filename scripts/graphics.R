##### Table #######
# Agreement on the non-NA anaphoric status of shell noun candidates by lemma.
# (Only cases with $n > 5$ shown.)
raw.agreement.bylemma <- both.sns %>% group_by(lemma) %>% 
  filter(!is.na(shellnoun.a1) & !is.na(shellnoun.a2)) %>% 
  summarise( raw = round(sum(shellnoun.a1 == shellnoun.a2)/n(), 2), n = n())

print(xtable(# filter by abs. freq (to save space)
             raw.agreement.bylemma %>% filter(n > 5) %>%
               arrange(desc(raw)) %>% select(1:2), 
             caption = "Agreement on the non-NA anaphoric status of shell noun candidates by lemma. (Only cases with $n > 5$ shown.)",
             label = "tbl:agreebylemma", auto = T), 
      floating = T, latex.environments = "center", booktabs = T,
      include.rownames = FALSE)




##### Figure #######
# Replacement noun mismatches
## pronouns only
plotdat <- as.data.frame(table(both.pro.withante$np_replfirst_noun.a1, 
                               both.pro.withante$np_replfirst_noun.a2))

# correcting labels
plotdat$Var1 <- str_to_title(plotdat$Var1)
plotdat$Var2 <- str_to_title(plotdat$Var2)
plotdat$Var1<- str_replace(plotdat$Var1, "ae", "ä")
plotdat$Var1 <- str_replace(plotdat$Var1, "oe", "ö")
plotdat$Var2 <- str_replace(plotdat$Var2, "oe", "ö")
plotdat$Var2 <- str_replace(plotdat$Var2, "ae", "ä")
plotdat[plotdat$Var1 == "Na","Var1"] <- "NA"
plotdat[plotdat$Var2 == "Na","Var2"] <- "NA"

heatmap <- ggplot(plotdat, aes(x = Var1, y = Var2)) + 
                  geom_point(aes(size = Freq)) + 
                  scale_size_continuous(range = c(-1, 10)) +
                  labs(y = "Annotator 1", x = "Annotator 2") + 
                  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0))





##### Table #######
# Antecedent types (shell nouns)

fixed.cols <- c("sent", "quest", "dass", "Wh-ind", "zu", "V-fin", "V-part", 
                "V-other", "NP", "PP", "other")

g1 <- gold.all %>% filter(lemma.freq > 2 & !is.na(category)) %>% 
        group_by(lemma, category) %>%
        summarise(n = n()) %>% mutate(relfreq = round(n / sum(n), 2)) %>%
        dcast(lemma ~ category, fill = "--")
row.names(g1) <- g1$lemma
## (if you want to sort columns by overall frequency) 
# my.col.order <- order(colSums(mutate_all(g1[,-1], 
#                                          function(x) as.numeric(x)), 
#                               na.rm = T),
#                       decreasing = T)
print(xtable(
             # lemma.vs.category[,order(colSums(lemma.vs.category), decreasing = T)], 
             # 1. don't order by lemma.vs.category -> doesn't exist
             # 2. note that vals in g1 are already converted to character
             g1[,-1][,fixed.cols], 
             caption = "Per-lemma distribution of antecedent types",
             label = "tbl:anteTypesSN", auto = T), 
      floating = T, latex.environments = "center", booktabs = T)

## Calculating the relative frequency of each category 
# g1.colsums <- colSums(mutate_all(g1[,-1], function(x) as.numeric(x)), na.rm = T)
# g1.total.colsums <- sum(g1.colsums)
# thing <- sapply(g1.colsums, function(x) { x / g1.total.colsums } ) %>% round(2)
# thing[fixed.cols]




##### Table #######
# Antecedent types (pronouns)

g2 <- gold.pro %>% filter(lemma.freq > 2 & !is.na(category)) %>% 
        group_by(lowercase, category) %>%
        summarise(n = n()) %>% mutate(relfreq = round(n / sum(n), 2)) %>%
        dcast(lowercase ~ category, fill = "--")
row.names(g2) <- g2$lowercase 
#my.col.order.pro <- order(colSums(mutate_all(g2[,-1], function(x) as.numeric(x)), 
#                                  na.rm = T), decreasing = T)
## fill-in missing column
g2$quest <- "--"
print(xtable(g2[,-1][,fixed.cols], 
             caption = "Per-lemma distribution of antecedent types",
             label = "tbl:anteTypesPRO", auto = T), 
      floating = T, latex.environments = "center", booktabs = T)

## Calculating the relative frequency of each category 
# g2.colsums <- colSums(mutate_all(g2[,-1], function(x) as.numeric(x)), na.rm = T)
# g2.total.colsums <- sum(g2.colsums)
# thing2 <- sapply(g2.colsums, function(x) { x / g2.total.colsums } ) %>% round(2)
# thing2[fixed.cols]




##### Figure #######

# Boxplot of antecedent distribution for various SN lemmas
sn.boxplot <- ggplot(gold.all %>% filter(lemma.freq > 2 & !is.na(distance)), 
                     aes(fct_reorder(lemma, distance), distance)) + 
                     geom_boxplot(outlier.size = 0.5, outlier.alpha = 0.70) +
                     # scale_color_gradient(low = "grey", high = "black") +
                     coord_flip() + ylim(-100, 150) +
                     labs(x = "Lemma", y = "Distance in tokens") 

# and for pronouns
pronouns.plot <- ggplot(gold.pro %>% filter(!is.na(distance)), 
                        aes(fct_reorder(lowercase, distance), distance)) + 
                        geom_boxplot() + coord_flip() + ylim(-100, 150) +
                        labs(x = "Lemma", y = "Distance in tokens")