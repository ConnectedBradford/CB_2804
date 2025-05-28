#this script is to calculate the sample size for external validation of the ACMI model in secondary care
#will calculate sample size in for full RPM and ACMi score alone. 
#calculation based off paper by riley et al. doi: 10.1136/bmj-2023-074821
#load packages
library(tidyverse)
library(pmvalsampsize)
library(pmsampsize)
#first is to calculate sample size for domain validation of for delirium.
#rate of outcome events (i.e. post-op 4at score of 4 or above) over 7 day post-operative period is assumed to be 0.25/7 days = 0.04/day 
# anticipiated c-statistic: c-statistic in external validation as 0.732
# assume calibration slope of 1 
pmsampsize(
  type = "b",
  nagrsquared = 0.04,
  parameters = 13,
  prevalence = 0.39

)


#next is to calculate sample size for validation of outcome for falls
#ra te is based on paper by singh et al. 2020, https://doi.org/10.1093/ageing/afz179 which found inpatient falls rate at a single UK teaching hospital to 8.7/1000 bed days
#average length of stay in hip fractures patients in bradford is 14.9 days 
pmsampsize(
  type = "b",
  nagrsquared = 0.04,
  csrsquared = NA,
  rsquared = NA,
  parameters = 8,
  shrinkage = 0.9,
  prevalence = NA,
  cstatistic = 0.732,
  seed = 123456,
  rate = 0.0087,
  timepoint = 14.9,
  meanfup = 14.9,
  intercept = NA,
  sd = NA,
  mmoe = 1.1
)
