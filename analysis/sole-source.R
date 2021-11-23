source("load.R")

sole_sourced_contracts <- contracts %>%
  filter(solicitation_procedure == "TN") ## see data dictionary "Solicitation Procedure": https://www.tbs-sct.gc.ca/pol/doc-eng.aspx?id=14676

sole_sourced_contracts %>%
  mutate(fy = str_remove_all(reporting_period, "-Q[0-9]$")) %>% ## normalize FYs from reporting periods [maybe should use contract date but it's probably fine]
  filter(fy %in% c("2016-2017", "2017-2018", "2018-2019", "2019-2020", "2020-2021", "2021-2022")) %>% ## only years with substantial reporting
  filter(commodity_type %in% c("S", "G")) %>% ## only services or goods, no construction / uncategorized
  mutate(contract_value_1000s = plyr::round_any(contract_value, 1000, floor)) %>%
  count_group(fy, commodity_type, contract_value_1000s) %>%
  top_n(3) %>%
  arrange(fy, commodity_type, -prop)

