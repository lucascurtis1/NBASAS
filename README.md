# NBA Statistical Analysis and Data Visualization in SAS and Python (in progress)

## SAS PORTION
- Aggregated individual player 3PT Shooting stats into team stats, filtered by position
- Developed comprehensive scatter plot that compares teams position-by-position

## Python PORTION
- Used Pandas dataframes and dictionaries in order to cleanly access sas7bdat data from the SAS Portion
- Assigned custom point values as a metric for 3pt success, factoring in positional value. +1 for above league avg %, and +1 for above 1.5, 3.5 or 4.5 3PM P/G based on position.

## SKILLS USED, SAS
- PROC SUMMARY
- PROC SGPLOT
- DATA CLEANING/IMPORT

## SKILLS USED, Python
- Pandas (Reading in data, dataframes, series)
- Functions
- For loops (and nested for loops)
- Dictionaries (including the use of defaultdict from collections)

## FILES
- NBA_Py_Code -> Files of code done in Python
- NBA_SAS_Code -> Files of code done in SAS
- NBA_Season_Stats -> csv files of both regular season and playoff player stats
- NBA_Team_Playoff_Stats -> Contains Advanced Playoff Statistics, not yet used
- SAS_Datasets_NBA3PT -> Contains sas7bdat files for moving playoff statistic data to python after sas portion is done.
- SAS_Datasets_NBA3PT_RegularSeason -> Same as above, but for regular season.
- 3pt_Playoff_Plot_21_22.pdf -> an example plot of what the sas portion delivers.
- README.md -> well, this.
