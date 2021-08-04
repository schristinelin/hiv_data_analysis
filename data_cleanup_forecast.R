### this script reads in multiple datasets from https://aidsinfo.unaids.org/, processes the data and combine the outputs to a single csv
library('data.table')
library('dplyr')
library('rstudioapi')

### define the data cleaning function
clean_data <- function(df) {
  ### considering years from 2010-2020, as the on_ART dataset only contains info from 2010-2020
  df1 <- df[, c('Country', paste0(2010:2020))]
  df1 <- data.frame(lapply(df1, function(x) gsub("...", "0", x, fixed=TRUE))) # change all the missing values to 0
  df1 <- data.frame(lapply(df1, gsub, pattern=' ', replacement='')) # remove all spaces, as some values are '10 000'
  df1 <- data.frame(lapply(df1, gsub, pattern='<', replacement=''))
  df1 <- data.frame(lapply(df1, gsub, pattern='>', replacement=''))
  df1[,2:ncol(df1)] <- data.frame(lapply(df1[,2:ncol(df1)], as.numeric))
  
  ### doing a simple moving average forecast to forecast till 2025
  ### taking the three latest observations and calculate their mean
  df1$X2021 <- (rowSums(df1[, c('X2018', 'X2019', 'X2020')])) / 3
  df1$X2022 <- (rowSums(df1[, c('X2019', 'X2020', 'X2021')])) / 3
  df1$X2023 <- (rowSums(df1[, c('X2020', 'X2021', 'X2022')])) / 3
  df1$X2024 <- (rowSums(df1[, c('X2021', 'X2022', 'X2023')])) / 3
  df1$X2025 <- (rowSums(df1[, c('X2022', 'X2023', 'X2024')])) / 3
  
  ### melt data by country and convert back to data.tables
  df2 <- melt(setDT(df1), id = c("Country"))
  df2$variable <- gsub("X", "", as.character(df2$variable))
  colnames(df2)[which(names(df2) == "variable")] <- "year"
  
  return(df2)
}


# set the directory of input data
root <- paste0(dirname(rstudioapi::getSourceEditorContext()$path))
files <- list.files(paste0(root, '/input_data'), pattern = "*.csv")
filenames_dict <- fread(paste0(root, '/filenames_dict.csv'))

# set an empty data table with two column names
hiv_all <- data.table(Country=character(), year=character())


# apply the function to all files in input_data folder
for (file in files){
  print(paste0('reading file: ', file))
  df_name <- filenames_dict[filenames_dict$file_name == file]$df_name
  df <- fread(paste0(root, '/input_data/', file), header = TRUE)
  temp <- clean_data(df)
  colnames(temp)[which(names(temp) == "value")] <- df_name
  hiv_all <- merge(temp, hiv_all, by = c("Country", "year"), all = TRUE)
}

# output csv
write.csv(hiv_all, paste0(root, '/hiv_data_2010_2025.csv'), row.names = FALSE)


