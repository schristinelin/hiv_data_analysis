# hiv_data_analysis

Input data was retrieved on aidsinfo.unaids.org. They are publicly accessible by navigating to the Fact Sheets tab on the website, and go to 'Data Sheet' to export data as csv format.

Input files:
1. AIDS-related deaths_AIDS mortality per 1000 population_Population_ All.csv
2. AIDS-related deaths_AIDS-related deaths - All ages_Population_ All ages.csv
3. New HIV infections_HIV incidence per 1000 population - All ages_Population_ All.csv
4. New HIV infections_New HIV infections - All ages_Population_ All ages.csv
5. People living with HIV_People living with HIV - All ages_Population_ All.csv
6. Treatment cascade_People living with HIV receiving ART (#)_Population_ All ages.csv
7. Treatment cascade_People living with HIV receiving ART (%)_Population_ All ages.csv

filenames_dict.csv was made by me and used for variable naming and reference purposes. 

Data Processing script: data_cleanup_forecast.R - This script gathers all files, cleans up data, and forecasts to the year 2025. Important points are as follows:
1. All '...' in raw data were treated as missing values, and converted to 0 for graphing purposes.
2. All '<' and '>' were removed. For example, '<100' or '>100', were cleaned up into '100'. Imputing the average value does not make sense in this case, as it is technically not a missing value, a number can not be <100 and >100 at the same time and thus would change the data itself.
3. Forecasting was done by a simple moving average method, where the mean of the latest 3 values were calculated and used for the year after. For example, 2021=(2018+2019+2020)/3, 2022=(2019+2020+2021)/3, etc.
4. For clarity purposes, all data downloaded from UNAIDS were 'all ages, both genders, by country'. There are more detailed data on UNAIDS by age groups and genders for more complex analysis and visualizations.
Output of data_cleanup_forecast.R: hiv_data_2010_2025.csv

Data Visualization script: hiv_data_viz.R - This script plots values by country and categories by pair (incidence rate/number, mortality rate/number). Rate here is defined as rate per 100K population, and not as percentage.
Output: /hiv_data_analysis/plots/*.pdf



