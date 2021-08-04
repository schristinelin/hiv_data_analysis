library('data.table')
library('ggplot2')
library('dplyr')
library('rstudioapi')

### get the filepath and target file
root <- dirname(rstudioapi::getSourceEditorContext()$path)
#setwd(root)
csv_name <- 'hiv_data_2010_2025.csv'

### read in dataset
hiv_data <- fread(paste0(root, '/', csv_name))
locs <- unique(hiv_data$Country)


### Define a plotting function
plot_vars <- function(loc){
  temp <- hiv_data[Country == loc]
  # Plot by category for clarity
  art <- melt(temp[, c('Country', 'year', 'on_ART_num', 'on_ART_rate')], id = c("Country", "year"))
  inc <- melt(temp[, c('Country', 'year', 'incidence_num', 'incidence_rate')], id = c("Country", "year"))
  mort <- melt(temp[, c('Country', 'year', 'mortality_num', 'mortality_rate')], id = c("Country", "year"))
  prev <- melt(temp[, c('Country', 'year', 'prevalence_num')], id = c("Country", "year"))
  
  plot1 <- ggplot(art, aes(year, value)) + 
    geom_point() + 
    stat_smooth() +
    facet_wrap(~variable, scales = 'free_y') +
    labs(title = paste0('Location: ', loc, ', 2010-2025 forecast'),
         subtitle = 'HIV data comparation - on ART treatment data by number and rate per 100k', 
         y = 'Value', x = 'Year')
  plot2 <- ggplot(inc, aes(year, value)) + 
    geom_point() + 
    stat_smooth() +
    facet_wrap(~variable, scales = 'free_y') +
    labs(title = paste0('Location: ', loc, ', 2010-2025 forecast'),
         subtitle = 'HIV data comparation - Incidence by number and rate per 100k', 
         y = 'Value', x = 'Year') 
  plot3 <- ggplot(mort, aes(year, value)) + 
    geom_point() + 
    stat_smooth() +
    facet_wrap(~variable, scales = 'free_y') +
    labs(title = paste0('Location: ', loc, ', 2010-2025 forecast'),
         subtitle = 'HIV data comparation - Mortality by number and rate per 100k', 
         y = 'Value', x = 'Year') 
  plot4 <- ggplot(prev, aes(year, value)) + 
    geom_point() + 
    stat_smooth() +
    facet_wrap(~variable, scales = 'free_y') +
    labs(title = paste0('Location: ', loc, ', 2010-2025 forecast'),
         subtitle = 'HIV data comparation - Prevalence by number and rate per 100k', 
         y = 'Value', x = 'Year') 
  print(plot1)
  print(plot2)
  print(plot3)
  print(plot4)

}


### Apply functions on all locations
for (loc in locs) {
  print(paste0('Plotting for: ', loc))
  pdf(file = paste0(root, '/plots/', loc, '.pdf'), width = 15, height = 10)
  plot_vars(loc)
  dev.off()
}

