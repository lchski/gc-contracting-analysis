library(tidyverse)
library(janitor)

# download "Contracts over $10,000" from https://open.canada.ca/data/en/dataset/d8f85d91-7dec-4fd1-8055-483b77225d8b and store in `data/source/...` folder below
contracts <- read_csv("data/source/open.canada.ca/d8f85d91-7dec-4fd1-8055-483b77225d8b/contracts.csv")
