library(pROC)
library(caret)

glm_fit <- readRDS("saved_models/glm_fit.rds")
rf_fit  <- readRDS("saved_models/rf_fit.rds")
xgb_fit <- readRDS("saved_models/xgb_fit.rds")
df <- readRDS("df_model_ready.rds")

train_idx <- createDataPartition(df$addicted, p = 0.7, list = FALSE)
test <- df[-train_idx, ]

p_glm <- predict(glm_fit, test, type="prob")[,2]
p_rf  <- predict(rf_fit,  test, type="prob")[,2]
p_xgb <- predict(xgb_fit, test, type="prob")[,2]

w <- c(auc(roc(test$addicted,p_glm)), auc(roc(test$addicted,p_rf)), auc(roc(test$addicted,p_xgb)))
w <- w / sum(w)

ens <- w[1]*p_glm + w[2]*p_rf + w[3]*p_xgb
ens_class <- factor(ifelse(ens>0.5,"yes","no"), levels=c("no","yes"))
cm_ens <- confusionMatrix(ens_class, test$addicted, positive="yes")

print(cm_ens)
saveRDS(w, "saved_models/light_ensemble_meta.rds")
