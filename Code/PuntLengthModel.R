options(java.parameters = "-Xmx8000m")

## Using BART Model to predict punt length. Evaluated BART and found XGBoost performed better out of sample.
## BartMachine Package: https://arxiv.org/pdf/1312.2171.pdf 

library(npcausal)
library(tidyr)
library(dplyr)
library(ggplot2)
library(predtools)
library(bartMachine)

#Read Data
punt <- read.csv('/Users/benjenkins/Desktop/ThesisProjectBDB/puntattempt.csv')
summary(punt)
dim(punt)

# Split into X and y
y <- punt$kickLength
X <- punt[,c(1:18)]

bart_machine <- bartMachine((X), y, use_missing_data=TRUE)
bart_machine

##make predictions on the training data 
y_hat = predict(bart_machine, X)

#variable selection
var_sel = var_selection_by_permute(bart_machine) 
print(var_sel$important_vars_local_names) 
print(var_sel$important_vars_global_max_names)

#variable selection via cross-validation
var_sel_cv = var_selection_by_permute_cv(bart_machine, k_folds = 3) 
print(var_sel_cv$best_method)
print(var_sel_cv$important_vars_cv)

#Diagnostics
plot_convergence_diagnostics(bart_machine)
check_bart_error_assumptions(bart_machine)
plot_y_vs_yhat(bart_machine, credible_intervals = TRUE) 
plot_y_vs_yhat(bart_machine, prediction_intervals = TRUE)

#K-Fold CV
k_fold_cv(X, y, k_folds = 5, use_missing_data=TRUE)

#get posterior distribution
posterior = bart_machine_get_posterior(bart_machine, X) 
print(posterior$y_hat)

#Feature importance: both global and partial dependence plot
investigate_var_importance(bart_machine, num_replicates_for_avg = 20)
pd_plot(bart_machine, j = "EZ_dist")
pd_plot(bart_machine, j = "Temperature")
pd_plot(bart_machine, j = "oppMateDistRatio")
pd_plot(bart_machine, j = "oppMean")
cov_importance_test(bart_machine, covariates = "oppMean")

#Interaction Effects
interaction_investigator(bart_machine, num_replicates_for_avg = 25, num_var_plot = 10, bottom_margin = 5)

#bartMachineCV(as.data.frame(X), y, use_missing_data=TRUE)
#rmse_by_num_trees(bart_machine, num_replicates = 1)
bart_machine_cv <- bartMachineCV(as.data.frame(X), y, use_missing_data=TRUE)
plot_convergence_diagnostics(bart_machine_cv)
plot_y_vs_yhat(bart_machine_cv, credible_intervals = TRUE) 
plot_y_vs_yhat(bart_machine_cv, prediction_intervals = TRUE)
investigate_var_importance(bart_machine_cv, num_replicates_for_avg = 20)
pd_plot(bart_machine_cv, j = "oppMean")
pd_plot(bart_machine_cv, j = "EZ_dist")
cov_importance_test(bart_machine_cv, covariates = "EZ_dist")
cov_importance_test(bart_machine_cv)

##make predictions on the training data 
y_hat = predict(bart_machine_cv, X)

#Create y_hat variable in punt dataframe
punt$y_hat <- y_hat
punt

ggplot(punt, aes(x=y_hat)) +
  geom_histogram(binwidth=.5, colour="black", fill="white") +
  geom_vline(aes(xintercept=mean(y_hat, na.rm=T)),   # Ignore NA values for mean
             color="red", linetype="dashed", size=1)

ggplot(punt, aes(x=kickLength, y=y_hat)) + geom_jitter()
calibration_plot(data = punt, obs = "kickLength", pred = "y_hat", xlab = "Predicted Punt Length",
                 ylab = "Actual Punt Length", 
                 title = "Calibration Plot for BART Punt Length Model")