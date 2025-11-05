library(tidyverse)
set.seed(123)

# Load data
url <- "https://raw.githubusercontent.com/AbhishekG07701/mobile-phone-usage-analysis/main/Data/phone_usage_india.csv"
df <- read_csv(url, show_col_types = FALSE)

# Clean column names
library(stringr)
names(df) <- names(df) %>%
  str_replace_all("[ ()/]", "_") %>%
  str_replace_all("\\.", "_") %>%
  str_to_lower() %>%
  str_replace_all("_+", "_") %>%
  str_replace_all("^_|_$", "")

num_cols <- c("screen_time_hrs_day","data_usage_gb_month","calls_duration_mins_day",
              "number_of_apps_installed","social_media_time_hrs_day",
              "e_commerce_spend_inr_month","streaming_time_hrs_day",
              "gaming_time_hrs_day","monthly_recharge_cost_inr")

df[num_cols] <- lapply(df[num_cols], as.numeric)
df <- df %>% drop_na(all_of(num_cols))

saveRDS(df, "df_cleaned.rds")
