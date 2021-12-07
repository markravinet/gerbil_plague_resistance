# simulations - fst distributions

rm(list = ls())

library(tidyverse)
library(here)
library(ggpubr)

## selection

fst_files <- list.files(here("simulations", "fst", "selection"), pattern = "*.fst", full.names = T)

# sort out windowed and standard fst
idx <- grepl("windowed", fst_files)
fst_w_files <- fst_files[idx]
fst_files <- fst_files[!idx]

# calculate means and 95th percentiles
fst <- lapply(fst_files, read_tsv)

est <- sapply(fst, function(x){
  mean_fst <- mean(x$WEIR_AND_COCKERHAM_FST, na.rm = T)
  quan_fst <- quantile(x$WEIR_AND_COCKERHAM_FST, 0.975, na.rm = T)
  c(mean_fst, quan_fst)
}) %>% t()

colnames(est) <- c("mean", "u95")
est_s <- as_tibble(est)

## neutral 

fst_files <- list.files(here("simulations", "fst", "neutral"), pattern = "*.fst", full.names = T)

fst <- lapply(fst_files, read_tsv)

est <- sapply(fst, function(x){
  mean_fst <- mean(x$WEIR_AND_COCKERHAM_FST, na.rm = T)
  quan_fst <- quantile(x$WEIR_AND_COCKERHAM_FST, 0.975, na.rm = T)
  c(mean_fst, quan_fst)
}) %>% t()

colnames(est) <- c("mean", "u95")
est_n <- as_tibble(est)

## build plot
## neutral
# mean
a <- ggplot(est_n, (aes(mean))) + geom_histogram(fill = "grey", colour = "black")
a <- a + geom_vline(xintercept = est_n %>% colMeans() %>% .[1], lty = 2,  colour = "red", size = 1)
a <- a + xlab(expression(italic(F)[ST])) + theme_light() + xlim(-0.1, 0.045)
# u95
b <- ggplot(est_n, (aes(u95))) + geom_histogram(fill = "grey", colour = "black")
b <- b + geom_vline(xintercept = est_n %>% colMeans() %>% .[2], lty = 2,  colour = "red", size = 1)
b <- b + xlab("95th percentile") + theme_light() + xlim(0.05, 0.5)
## selection
# mean
c <- ggplot(est_s, (aes(mean))) + geom_histogram(fill = "grey", colour = "black")
c <- c + geom_vline(xintercept = est_s %>% colMeans() %>% .[1], lty = 2,  colour = "red", size = 1)
c <- c + xlab(expression(italic(F)[ST])) + theme_light() + xlim(-0.1, 0.045)
# u95
d <- ggplot(est_s, (aes(u95))) + geom_histogram(fill = "grey", colour = "black")
d <- d + geom_vline(xintercept = est_s %>% colMeans() %>% .[2], lty = 2,  colour = "red", size = 1)
d <- d + xlab("95th percentile") + theme_light() + xlim(0.05, 0.5)
# combine
ggarrange(a, b, c, d, ncol = 2, nrow = 2, labels = c("A", "B", "C", "D"))
ggsave(here("appeal", "sim_plot_all_011021.pdf"), height = 4, width = 8)

### sliding window
# calculate means and 95th percentiles
fst_w <- lapply(fst_w_files, read_tsv)

# set thresholds
threshold_n <- 0.12
threshold_s <- 0.22

# calculate power
# for neutral
power_n <- sapply(fst_w, function(x){
  # identify outliers
  outliers <- x %>% filter(WEIGHTED_FST > threshold_n)
  # calc distance from adaptive mutation
  outliers <- outliers %>% mutate(mid = BIN_START + 2500) %>% mutate(dist = abs(50000 - mid))
  outlier_logical <- sum(outliers$dist < 10000)
  outlier_logical >=1
})
# for selection
power_s <- sapply(fst_w, function(x){
  # identify outliers
  outliers <- x %>% filter(WEIGHTED_FST > threshold_s)
  # calc distance from adaptive mutation
  outliers <- outliers %>% mutate(mid = BIN_START + 2500) %>% mutate(dist = abs(50000 - mid))
  outlier_logical <- sum(outliers$dist < 10000)
  outlier_logical >=1
})

# neutral power
sum(power_n)/length(power_n)
# selection power
sum(power_s)/length(power_s)


