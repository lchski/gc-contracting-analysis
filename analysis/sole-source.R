source("load.R")

sole_sourced_contracts <- contracts %>%
  filter(solicitation_procedure == "TN") ## see data dictionary "Solicitation Procedure": https://www.tbs-sct.gc.ca/pol/doc-eng.aspx?id=14676

sole_sourced_contracts_for_gcrs_q <- sole_sourced_contracts %>%
  mutate(fy = str_remove_all(reporting_period, "-Q[0-9]$")) %>% ## normalize FYs from reporting periods [maybe should use contract date but it's probably fine]
  filter(fy %in% c("2016-2017", "2017-2018", "2018-2019", "2019-2020", "2020-2021", "2021-2022")) %>% ## only years with substantial reporting
  filter(commodity_type %in% c("S", "G")) %>% ## only services or goods, no construction / uncategorized
  mutate(original_value_1000s = plyr::round_any(original_value, 1000, floor)) ## use original value since it's what procurement would first review (we assume)

sole_sourced_contracts_for_gcrs_q %>%
  group_by(fy, original_value_1000s) %>%
  summarize(count = n()) %>%
  mutate(prop = round(count / sum(count), 3)) %>%
  top_n(4) %>%
  arrange(fy, -prop) %>%
  mutate(prop_magnitude_vs_next = round(prop / lead(prop), 2)) %>%
  top_n(3) %>%
  write_csv("data/out/2021-11-22-gcr-sole-source-limits/top_3_rounded_original_values_by_fy.csv")

sole_sourced_contracts_for_gcrs_q %>%
  group_by(fy, commodity_type, original_value_1000s) %>%
  summarize(count = n()) %>%
  mutate(prop = round(count / sum(count), 3)) %>%
  top_n(4) %>%
  arrange(commodity_type, fy, -prop) %>%
  mutate(prop_magnitude_vs_next = round(prop / lead(prop), 2)) %>%
  top_n(3) %>%
  write_csv("data/out/2021-11-22-gcr-sole-source-limits/top_3_rounded_original_values_by_commodity_type_by_fy.csv")
