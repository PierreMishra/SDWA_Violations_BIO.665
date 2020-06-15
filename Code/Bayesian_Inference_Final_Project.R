source("../clarkFunctions2020.r")
library (dplyr)
library (rjags)
library (coda)
library (tidyr)
library (ggplot2)
library (maps)
library (plotly)

# setting ggplot theme
peaceful.theme <- theme_classic(base_size = 14) +
  theme(axis.text = element_text(color = "black")) +
  theme(legend.position = "bottom")

# reading and exploring SDWA violation dataset
states <- read.csv("Data/us_states.csv", header = FALSE)
vl <- read.csv("Data/SDWA_VIOLATIONS.csv") 

# filtering relevant columns
violations <- select (vl, PWSID, PWS_NAME, STATE_NAME, 
                      PWS_TYPE_CODE, SOURCE_WATER, 
                      POPULATION_SERVED_COUNT, RULE_NAME,
                      STATE_NAME, BEGIN_YEAR,
                      ACUTE_HEALTH_BASED, HEALTH_BASED)

# lowering alphabets
names(violations) <- tolower(names(violations))

# converting binary variables to 0 and 1
violations <- violations %>%
  mutate(acute_health_based = ifelse(acute_health_based == "N",0,1)) %>%
  mutate(health_based = ifelse(health_based == 'N',0,1))
violations$acute_health_based <- as.factor(violations$acute_health_based)
violations$health_based <- as.factor(violations$health_based)

# checking class of each column
sapply(violations, class)

# saving violations dataset
# write.csv(violations[c(1:10000),],"violations.csv")

# subsetting 50 states and from year 2007
violations.subset <- violations %>%
  filter(state_name %in% states$V2) %>%
  droplevels

violations.subset <- violations.subset[which(violations.subset$begin_year > 2006),]
nrow(violations.subset)

#-------------------------Part I-------------------------------#

# creating model matrix
tmp <- model.frame(acute_health_based ~ source_water + pws_type_code + population_served_count, violations.subset[c(1:500000),])
X <- model.matrix(acute_health_based ~ source_water + pws_type_code + population_served_count, violations.subset[c(1:500000),])
Y <- tmp$acute_health_based
Y <- as.numeric(as.character(Y))
n <- length(Y)

# logistic regression using glm function
mle <- glm(Y ~ source_water + pws_type_code + population_served_count, data = tmp, family="binomial")
summary(mle)

# jags
file <- "model_1_jags_logistic.txt"
cat("model {
    for (i in 1:n) {
      Y[i] ~ dbern(q[i])
      logit(q[i]) <- inprod(beta[],X[i,])
    }
    
    for (i in 1:p){
      beta[i] ~ dnorm(0,0.1)
    }
}", file = file)
                    
data_jags <- list(Y = Y, X = X, n = nrow(X), p = ncol(X))
save(data_jags, file = 'model_1_jags_logistic.Rdata')

# performing jags
model_1_jags <- jags.model(data=data_jags, inits = NULL, file=file, n.chains=3, n.adapt=500)

# fitting model
params <- 'beta'
model_1_jags <- coda.samples(model_1_jags, params, n.iter=2500)
summary(model_1_jags)
plot(model_1_jags)

# #---------------------Truncated version----------------------#
# 
# # creating model matrix
# tmp <- model.frame(acute_health_based ~ population_served_count + source_water + pws_type_code, data = violations.subset[c(1:100),])
# X <- model.matrix(acute_health_based ~ population_served_count + source_water + pws_type_code, data = violations.subset[c(1:100),])
# Y <- tmp$acute_health_based
# n <- length(Y)
# 
# # Frequentist analysis
# mle <- glm(Y~violations.subset$source_water[c(1:100)], family="binomial")
# summary(mle)
# 
# # jags
# file <- "SDWA_violations.txt"
# cat("model {
#     for (i in 1:n) {
#     Y[i] ~ dbern(q[i])
#     logit(q[i]) <- beta[1] + beta[2]*X[i,2] + beta[3]*X[i,3] + beta[4]*X[i,4] +
#                     beta[5]*X[i,5]
#     }
#     
#     for (i in 1:p){
#     beta[i] ~ dnorm(0,0.1)
#     }
# }", file = file)
# 
# datalist <- list(Y = Y, X = X, n = nrow(X), p = ncol(X))
# save(datalist, file = 'jags.Rdata')
# 
# # performing jags
# outjags <- jags.model(data=datalist, file = file, n.chains = 3, quiet = TRUE)
# 
# # fitting model
# params <- 'beta'
# output <- coda.samples(outjags, params, n.iter=4000)
# summary(output)
# plot(output)

#-------------------------------PART II----------------------------------# 
#-------------------------------(Trend)------------------------------------#

tmp <- model.frame(acute_health_based ~ state_name + begin_year, data = violations)
tmp$acute_health_based <- as.numeric(as.factor(tmp$acute_health_based))
#tmp$begin_year <- as.character(tmp$begin_year)
#tapply(tmp$Y, list(state=tmp$state_name, year = tmp$begin_year), sum, na.rm = T)
#combine <- by(tmp[,1], tmp[,2], FUN=sum)
#aggregate(tmp$acute_health_based, by=tmp$state_name, FUN=sum)

# summing up for each state and pivoting year to columns
combine <- tmp %>%
  select(state_name, begin_year, acute_health_based) %>%
  group_by(state_name, begin_year) %>%
  summarise(acute_health_based = sum(acute_health_based))

#pivot_data <- combine %>%
#  spread(begin_year, acute_health_based)

#abc <- pivot_data %>%
#  filter(state_name %in% states$V2)                   START PREVIOUS MODEL FROM 2007


# Only selecting the 50 states
final_data <- combine %>%
  filter(state_name %in% states$V2) %>%
  droplevels

modmat <- model.frame(acute_health_based ~ state_name*begin_year, data = final_data)
X <- model.matrix(acute_health_based ~ state_name*begin_year, data = final_data)
Y <- modmat$acute_health_based
n <- length(Y)

# poisson regression using glm function
mean(modmat$acute_health_based)
var(modmat$acute_health_based)
hist(modmat$acute_health_based, breaks = 100)
mle_states <- glm(acute_health_based ~ state_name*begin_year, data = final_data, family=poisson (link = "log"))
summary(mle)
names(mle$coefficients)

# jags poisson
file <- "model_2_jags_poisson.txt"

cat(" model {
for (i in 1:n) {
  Y[i] ~ dpois(lam[i])
  lam[i] <- exp( inprod(beta[],X[i,]) )
}
    for(i in 1:p){
    beta[i] ~ dnorm(0,0.1)
}}", file = file)

data_jags = list(Y = Y, X = X, n = nrow(X), p = ncol(X))
save(data_jags,file='Output/model_2_jags_poisson.Rdata')
outjags <- jags.model(data=data_jags, inits=NULL, file=file, n.chains=3, n.adapt=40000 )
update(outjags, 40000)

# fitted model
params <- 'beta'
output <- coda.samples( outjags, params, n.iter=120000)
summary(output)
plot(output)

# Renaming columns to state names
coefficients <- data.frame()
coefficients <- output[,1:100]
class(coefficients)
coefficients <- as.data.frame(as.matrix(coefficients))
colnames(coefficients) <- names(mle_states$coefficients[1:100])

# Calculating mean coefficient for each state
state_coefficients <- coefficients[,1:100]
col_num <- ncol(state_coefficients)
state_coefficients_mean <- data.frame(matrix(ncol=2, nrow=50))
state_coefficients_mean[,1] <- states$V2
state_coefficients_mean[,1] <- tolower(state_coefficients_mean[,1])
colnames(state_coefficients_mean) <- c("region", "coefficient")

# Alabama coefficient
state_coefficients_mean[1,2] <- mean(state_coefficients$begin_year)
# Other states coefficient
for (i in 2:50){
  state_coefficients_mean[i,2] <- mean(state_coefficients[,i+50]) +
                                  mean(state_coefficients$begin_year)
}

#d <- density(coefficients[,62]) #to create density plot

# creating US map with violations posing health risk trend
us_states <- map_data("state")
final_states <- left_join(us_states,state_coefficients_mean)
ggplot(data = final_states,
       mapping = aes(x = long, y = lat, group = group, fill = coefficient)) +
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_continuous(low = "white",
                        high = "purple") +
  labs(fill = "Ln Year Coefficient") +
  theme_void() + theme(legend.position = c(0.90, 0.20))
  
# Line plot for each state
plot_ly(final_data, x=~begin_year, y=~acute_health_based, mode = 'lines',
        color = final_data$state_name) %>%
  add_lines() %>%
  layout(xaxis = list(title = "Year",
                      zeroline = FALSE),
         yaxis = list(title = "Acute SDWA Violations",
                      zeroline = FALSE))

#saving large files
# write.csv(final_states)
# write.csv(coefficients)
# write.csv(state_coefficients)
# write.csv(state_coefficients_mean)
# write.csv(final_data)




