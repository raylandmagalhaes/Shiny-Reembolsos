library(reembolsos)
library(tidyverse)

camara=bind_rows(list(camara2009,camara2010,camara2011,camara2012,camara2013,camara2014,camara2015,camara2016,camara2017,camara2018,camara2019,camara2020)) %>%
  filter(total_net_value>0) %>%
  data.frame(check.names = F) %>% 
  filter(!is.na(total_net_value)&!is.na(document_value)) %>%
  select(-congressperson_document,-document_id,-applicant_id,-numbers,-batch_number,-leg_of_the_trip,-passenger,-installment,-remark_value,-term_id,-term,-congressperson_document,-cnpj_cpf)

save(camara,file="camara_lite")
