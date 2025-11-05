library(caret)
library(randomForest)
library(xgboost)
library(pROC)
library(vip)
set.seed(123)

df <- readRDS("df_model_ready.rds")

preds <- c("screen_time_hrs_day","social_media_time_hrs_day","gaming_time_hrs_day",
           "streaming_time_hrs_day","data_usage_gb_month","number_of_apps_installed",
           "age","gender","os","phone_brand","location","primary_use","addicted")

model_df <- df %>% select(all_of(preds)) %>% drop_na()

factor_cols <- c("gender","os","phone_brand","location","primary_use")
model_df[factor_cols] <- lapply(model_df[factor_cols], factor)

train_idx <- createDataPartition(model_df$addicted, p = 0.7, list = FALSE)
train <- model_df[train_idx, ]
test <- model_df[-train_idx, ]

ctrl <- trainControl(method = "cv", number = 5, classProbs = TRUE, summaryFunction = twoClassSummary)

glm_fit <- train(addicted ~ ., data = train, method = "glm", family = "binomial", trControl = ctrl, metric = "ROC")
rf_fit  <- train(addicted ~ ., data = train, method = "rf", trControl = ctrl, metric = "ROC", tuneLength = 6)
xgb_fit <- train(addicted ~ ., data = train, method = "xgbTree", trControl = ctrl, metric = "ROC", tuneLength = 6)

saveRDS(glm_fit, "saved_models/glm_fit.rds")
saveRDS(rf_fit,  "saved_models/rf_fit.rds")
saveRDS(xgb_fit, "saved_models/xgb_fit.rds")
