library(randomForest)
library(rpart)
library(class)

# Get input from Flask
args <- commandArgs(trailingOnly = TRUE)

age <- as.numeric(args[1])
income <- as.numeric(args[2])
loan <- as.numeric(args[3])
credit <- as.numeric(args[4])
employment <- as.numeric(args[5])
existing <- as.numeric(args[6])


# Create applicant data
new_data <- data.frame(
  Age = age,
  Income = income,
  LoanAmount = loan,
  CreditScore = credit,
  EmploymentYears = employment,
  ExistingLoans = existing
)


# ==========================
# RANDOM FOREST
# ==========================

rf_model <- readRDS(
  "models/random_forest.rds"
)

rf_result <- predict(
  rf_model,
  new_data
)


# ==========================
# DECISION TREE
# ==========================

dt_model <- readRDS(
  "models/decision_tree.rds"
)

dt_result <- predict(
  dt_model,
  new_data,
  type = "class"
)


# ==========================
# KNN
# ==========================

knn_model <- readRDS(
  "models/knn_model.rds"
)

new_scaled <- scale(
  new_data,
  center = knn_model$center,
  scale = knn_model$scale
)

knn_result <- knn(
  train = knn_model$data,
  test = new_scaled,
  cl = knn_model$target,
  k = 3
)


# ==========================
# DISPLAY RESULT
# ==========================

cat("Random Forest: ", as.character(rf_result), "\n")
cat("Decision Tree: ", as.character(dt_result), "\n")
cat("KNN: ", as.character(knn_result), "\n")