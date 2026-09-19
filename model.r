library(randomForest)
library(rpart)
library(class)

# Read CSV
data <- read.csv("loan_data.csv")

# Convert Approved to factor
data$Approved <- as.factor(data$Approved)

# Create models folder
if (!dir.exists("models")) {
    dir.create("models")
}


# ==========================
# RANDOM FOREST
# ==========================

set.seed(123)

rf_model <- randomForest(
    Approved ~ Age + Income + LoanAmount +
        CreditScore + EmploymentYears + ExistingLoans,
    data = data,
    ntree = 100
)

saveRDS(
    rf_model,
    "models/random_forest.rds"
)


# ==========================
# DECISION TREE
# ==========================

dt_model <- rpart(
    Approved ~ Age + Income + LoanAmount +
        CreditScore + EmploymentYears + ExistingLoans,
    data = data,
    method = "class"
)

saveRDS(
    dt_model,
    "models/decision_tree.rds"
)


# ==========================
# KNN
# ==========================

x <- data[, c(
    "Age",
    "Income",
    "LoanAmount",
    "CreditScore",
    "EmploymentYears",
    "ExistingLoans"
)]

y <- data$Approved

x_scaled <- scale(x)

knn_model <- list(
    data = x_scaled,
    target = y,
    center = attr(x_scaled, "scaled:center"),
    scale = attr(x_scaled, "scaled:scale")
)

saveRDS(
    knn_model,
    "models/knn_model.rds"
)


print("================================")
print("ALL 3 MODELS CREATED SUCCESSFULLY")
print("================================")