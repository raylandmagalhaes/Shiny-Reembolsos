library(reembolsos)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(treemap)
library(gridExtra)
library(scales)
library(DT)

camara=bind_rows(list(camara2009,camara2010,camara2011,camara2012,camara2013,camara2014,camara2015,camara2016,camara2017,camara2018,camara2019)) %>% filter(total_net_value>0) %>% data.frame(check.names = F) %>% 
  filter(!is.na(total_net_value)&!is.na(document_value)) 
