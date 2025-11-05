library(tidyverse)

df <- readRDS("df_cleaned.rds")

usage_vars <- intersect(c("screen_time_hrs_day","social_media_time_hrs_day",
                          "gaming_time_hrs_day","streaming_time_hrs_day",
                          "data_usage_gb_month","number_of_apps_installed"), names(df))

z <- scale(df[usage_vars])
wts <- rep(1, ncol(z))
names(wts) <- colnames(z)
wts["screen_time_hrs_day"] <- 1.4
wts["social_media_time_hrs_day"] <- 1.2
wts["gaming_time_hrs_day"] <- 1.2

df$usage_score <- as.numeric(z %*% wts / sum(wts))
threshold <- quantile(df$usage_score, 0.80)
df$addicted <- factor(ifelse(df$usage_score >= threshold, "yes", "no"), levels = c("no","yes"))

saveRDS(df, "df_model_ready.rds")
