spotify <- read.csv("/Users/namijain/STAT 4214/STAT 4214 - Final Project/top2018.csv")
colnames(spotify)
head(spotify)
summary(spotify)

missing_values <- colSums(is.na(spotify))
missing_values
spotify$time_signature <- as.numeric(gsub(" beats", "", spotify$time_signature))
head(spotify)

library(corrplot)
name_index = spotify$name
spotify$id = 1:nrow(spotify)

# Randomized data because we were seeing a uniform shape 
# rank was dependent on the order of observations
set.seed(42)  # for reproducibility
spotify <- spotify[sample(nrow(spotify)), ]

artist_index = spotify$artists

x_column_idx <- !(names(spotify) %in% c('name', 'id', 'artists'))
cor(spotify[,x_column_idx])
corrplot(cor(spotify[,x_column_idx]), method="color")


# loudness & energy
# valence & danceability
# energy & acousticness
# acousticness & loudness
plot(spotify, lower.panel = NULL, pch = 16)


# Regression Model
spotify_mdl <- lm(id ~ danceability + energy + key + loudness + mode + 
                    speechiness + acousticness + instrumentalness + liveness + 
                    valence + tempo + duration_ms + time_signature, data = spotify)
summary(spotify_mdl)

# Check for Multicolinearity
library(car)
vif(spotify_mdl)
### all predictors seem to be independent from one another (no dependency)

library(MASS)

# Stepwise using AIC (default)
stepAIC(spotify_mdl, direction = "both")

# Stepwise using BIC
k <- log(nrow(spotify))  # BIC penalty factor
stepAIC(spotify_mdl, direction = "both", k = k)

### New Regression Model Using AIC
spotify_mdl_aic <- lm(id ~ danceability + key + loudness + liveness + valence + 
                        tempo, data = spotify)
summary(spotify_mdl_aic)
vif(spotify_mdl_aic)

# Visualize Liveness vs ID
plot(spotify$liveness, spotify$id, pch = 19, col = "skyblue",
     main = "Song ID vs. Liveness", xlab = "Liveness", ylab = "Song ID",
     ylim = c(100, 1)) # flipped y-axis to be able to understand rank as popularity
abline(lm(id ~ liveness, data = spotify), col = "red", lwd = 2)


# Calculate studentized residuals
rstudent_vals <- rstudent(spotify_mdl_aic)

# Plot them
plot(rstudent_vals, pch = 19, col = "black", main = "Studentized Residuals", ylab = "rstudent")
abline(h = c(-3, 3), col = "red", lty = 2)  # common cutoff


# Cook's distance plot
cooks <- cooks.distance(spotify_mdl_aic)

plot(cooks, type = "p", main = "Cook's Distance", ylab = "Cook's D")
abline(h = 4 / nrow(spotify), col = "red", lty = 1)
# Calculate Cook's D
cooks <- cooks.distance(spotify_mdl)

### Should threshold be 1?
# Set threshold (rule of thumb: 4 / n)
threshold <- 4 / nrow(spotify)

# Find influential points
influential_idx <- which(cooks > threshold)

# Print them
influential_idx
spotify[influential_idx, ]

# Calculate studentized residuals
rstudent_vals <- rstudent(spotify_mdl_aic)

# Find outlier indices based on ±2.5 threshold
outlier_idx <- which(abs(rstudent_vals) > 2.5)

# Print the indices and corresponding data
outlier_idx
spotify[outlier_idx, ] # result shows no observations had studentized residuals greater than ±2.5.

# Constant Variance
plot(spotify_mdl_aic$fitted.values, rstudent(spotify_mdl_aic),
     main = "Studentized Residuals vs Fitted",
     xlab = "Fitted Values", ylab = "Studentized Residuals",
     pch = 19, col = "steelblue")
abline(h = 0, col = "red", lwd = 2)

# QQ Plot
qqnorm(rstudent(spotify_mdl_aic), 
       main = "Q-Q Plot of Studentized Residuals", 
       pch = 19, col = "darkblue")
qqline(rstudent(spotify_mdl_aic), col = "red", lwd = 2)

shapiro.test(rstudent(spotify_mdl_aic)) # Residuals are normal

# Durbin-Watson
install.packages("lmtest")  # If not installed already
library(lmtest)


#####-------------------------------------

# dance, key, loud, live, valence, tempo
library(ggplot2)

time_signature_counts <- table(spotify$key)

# Convert the table into a data frame
time_signature_df <- as.data.frame(time_signature_counts)
colnames(time_signature_df) <- c("time_signature", "count")

# Create the pie chart
ggplot(time_signature_df, aes(x = "", y = count, fill = as.factor(time_signature))) +
  geom_bar(stat = "identity", width = 1, color = "black") +  # Add black outline
  coord_polar(theta = "y") +
  theme_void() +
  labs(title = "Distribution of Time Signatures in Spotify Data", fill = "Time Signature")

#####-------------------------------------

library(tidyr)

spotify_long <- spotify %>%
  gather(key = "variable", value = "value", danceability, liveness, energy, acousticness)

# Create the plot with facet_wrap
ggplot(spotify_long, aes(x = value, fill = variable)) +
  geom_histogram(binwidth = 0.05, color = "black", alpha = 0.7) +
  facet_wrap(~variable, scales = "free_x") +  # Create separate plots for each variable
  labs(title = "Histograms of Danceability, Liveness, and Loudness",
       x = "Value", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = c("skyblue", "orange", "green", 'red'), 
                    name = "Variables",
                    labels = c("Danceability", "Liveness", "Energy", "Acousticness"))

#####-------------------------------------

plot(spotify$id, spotify$tempo,
     main = "Scatterplot of Tempo by ID",  # Title of the plot
     xlab = "ID",                        # Label for the x-axis
     ylab = "Tempo",                     # Label for the y-axis
     pch = 19,                           # Point type (solid circle)
     col = "skyblue",                    # Color of the points
     cex = 0.7)                          # Size of the points



#### MODEL 2 - BIC

mdl_liveness <- lm(id ~ liveness, data = spotify)

# Create a full model with all predictors (same as before)
mdl_full <- lm(id ~ danceability + energy + key + loudness + mode + 
                 speechiness + acousticness + instrumentalness + liveness + 
                 valence + tempo + duration_ms + time_signature, data = spotify)

# Set BIC penalty factor
k_bic <- log(nrow(spotify)) # 4.60517

# Run stepwise selection using BIC, starting from liveness-only model
step_bic_liveness <- stepAIC(mdl_liveness,
                             scope = list(lower = mdl_liveness, upper = mdl_full),
                             direction = "both",
                             k = k_bic)

# Display summary of final BIC-selected model
summary(step_bic_liveness)


### Accuracy
library(Metrics)

# Fit both models
mdl_bic <- lm(id ~ liveness, data = spotify)
summary(mdl_bic)
mdl_aic <- lm(id ~ danceability + key + loudness + liveness + valence + tempo, data = spotify)
summary(mdl_aic)

# Predictions
pred_bic <- predict(mdl_bic)
pred_aic <- predict(mdl_aic)

# Actual values
actual <- spotify$id

# Calculate metrics
results <- data.frame(
  Model = c("BIC (liveness only)", "AIC (selected model)"),
  RMSE = c(rmse(actual, pred_bic), rmse(actual, pred_aic)),
  MAE = c(mae(actual, pred_bic), mae(actual, pred_aic)),
  R_Squared = c(summary(mdl_bic)$r.squared, summary(mdl_aic)$r.squared)
)

# Print results table
print(results)





