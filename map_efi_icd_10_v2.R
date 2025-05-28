# this script will map SNOMED codes for the predictors in the ACMI prediction model to ICD-10 codes
# i will start with mapping one deficit and then map the rest

#load packges
library(tidyverse)
install.packages("CommonDataModel")
#read in efi deficits
efi_codes <- read.csv("codelists/CTV3Codes_eFI.csv")
#snomed codes are spread across two columns so need to combine both columns to get complete list of SNOMED codes for efi deficits, not sure why 
#this has happened however, need to ask Jose 
efi_codes$concept_code <- coalesce(efi_codes$SCT_CONCEPTID.x,efi_codes$SCT_CONCEPTID.y)
#read in OMOP relationship tables
concept_relationship <- read.table("OMOP_vocabularies/CONCEPT_RELATIONSHIP.csv",
                                   sep = "\t",fill = TRUE, 
                                   na.strings = "",header=TRUE) 
#read in OMOP concept tables
concept <- read.table("OMOP_vocabularies/CONCEPT.csv",
                                   sep = "\t",fill = TRUE, 
                                   na.strings = "",header=TRUE) 
concept$concept_code <- as.numeric(concept$concept_code)

#subset concept table by efi snomedcodes, generating 76 concepts for efi deficits 
efi_concepts <- concept[concept$concept_code %in% efi_codes$concept_code, ] %>% filter(vocabulary_id == "SNOMED")
#left join deficit 
efi_concept_group<- left_join(efi_concepts, efi_codes %>% select(concept_code, GROUP),
                                     by =join_by(x$concept_code == y$concept_code))
efi_concept_group$GROUP %>% n_distinct()
#this identifies vocab for 24 deficits of the 36 deficits, many of the deficits are not listed in the concepts even though i could find them on
#athena browser which doesn't make sense to me. 
#search relationship table for standardised concepts for efi deficits in concept_id_2 
#in order to identify non-standard concepts for efi deficits 
concept_efi_relationship <- concept_relationship[concept_relationship$concept_id_2 %in% efi_concept_group$concept_id,] %>% 
                            filter(relationship_id == "Maps to")

#filter concept dataframe by concept_id_1 (non standard conepts which map to standardised concepts)
#select concept id 1 which are the non standard concept ids for efi deficits
non_standardised_efi_concept_id <- concept_efi_relationship[1]

concept_icd_10 <- concept %>% filter(vocabulary_id == "ICD10")

concept$vocabulary_id %>% unique()
