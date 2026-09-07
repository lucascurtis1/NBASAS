*
LUCAS CURTIS
5 27 2026
Project on 3pt shooting, regular season
;

*
data from sports-reference.com
for use with this code, get regular season player stats into csv format and then 
-delete columns: Awards Player-Additional
-rename column: 'Team' -> 'Tm'
-delimeter is comma
-for regular season, firstobs is 3 in data step
;
libname nbaproj '/home/u64430304/NBAPROJ';

*******************************;
*2022 nbaregular;
*******************************;

data nbaproj.nbaregular22untouched;
	infile "/home/u64430304/NBAPROJ/nbaregular2022.csv" dsd dlm=',' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Age Tm $ Pos $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
	if Tm = '2TM' or Tm = '3TM' or Tm = '4TM' then delete;
run;

data nbaproj.nbaregular22;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.nbaregular22untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;

***********************************
Point Guards 2022
***********************************;

proc summary data=nbaproj.nbaregular22 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats_reg22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot_reg22;
    set nbaproj.team_pg_thrpt_stats_reg22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot_reg22;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot_reg22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2022;
***********************************;
proc summary data=nbaproj.nbaregular22 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats_reg22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot_reg22;
    set nbaproj.team_sg_thrpt_stats_reg22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot_reg22;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot_reg22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2022;
***********************;

proc summary data=nbaproj.nbaregular22 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats_reg22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot_reg22;
    set nbaproj.team_sf_thrpt_stats_reg22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot_reg22;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot_reg22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2022;
***********************;

proc summary data=nbaproj.nbaregular22 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats_reg22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot_reg22;
    set nbaproj.team_pf_thrpt_stats_reg22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot_reg22;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot_reg22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2022;
***********************;

proc summary data=nbaproj.nbaregular22 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats_reg22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot_reg22;
    set nbaproj.team_c_thrpt_stats_reg22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot_reg22;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot_reg22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2022;
*****************;

proc summary data=nbaproj.nbaregular22 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats22
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot_reg22;
    set nbaproj.team_thrpt_stats22;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot_reg22;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot_reg22;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2022 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=.25 max=.45;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

**************************;
*2023 nbaregular;
**************************;


data nbaproj.nbaregular23untouched;
	infile "/home/u64430304/NBAPROJ/nbaregular2023.csv" dsd dlm=',' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Age Tm $ Pos $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
	if Tm = '2TM' or Tm = '3TM' or Tm = '4TM' then delete;
run;

data nbaproj.nbaregular23;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.nbaregular23untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;


***********************************
Point Guards 2023
***********************************;

proc summary data=nbaproj.nbaregular23 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats_reg23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot_reg23;
    set nbaproj.team_pg_thrpt_stats_reg23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot_reg23;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot_reg23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2023;
***********************************;
proc summary data=nbaproj.nbaregular23 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats_reg23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot_reg23;
    set nbaproj.team_sg_thrpt_stats_reg23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot_reg23;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot_reg23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2023;
***********************;

proc summary data=nbaproj.nbaregular23 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats_reg23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot_reg23;
    set nbaproj.team_sf_thrpt_stats_reg23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot_reg23;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot_reg23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2023;
***********************;

proc summary data=nbaproj.nbaregular23 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats_reg23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot_reg23;
    set nbaproj.team_pf_thrpt_stats_reg23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot_reg23;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot_reg23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2023;
***********************;

proc summary data=nbaproj.nbaregular23 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats_reg23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot_reg23;
    set nbaproj.team_c_thrpt_stats_reg23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot_reg23;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot_reg23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2023;
*****************;

proc summary data=nbaproj.nbaregular23 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats23
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot_reg23;
    set nbaproj.team_thrpt_stats23;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot_reg23;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot_reg23;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2023 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=.25 max=.45;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

************************************
2024 nbaregular
************************************;


data nbaproj.nbaregular24untouched;
	infile "/home/u64430304/NBAPROJ/nbaregular2024.csv" dsd dlm=',' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Age Tm $ Pos $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
	if Tm = '2TM' or Tm = '3TM' or Tm = '4TM' then delete;
run;

data nbaproj.nbaregular24;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.nbaregular24untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;


***********************************
Point Guards 2024
***********************************;

proc summary data=nbaproj.nbaregular24 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats_reg24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot_reg24;
    set nbaproj.team_pg_thrpt_stats_reg24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot_reg24;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot_reg24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2024;
***********************************;
proc summary data=nbaproj.nbaregular24 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats_reg24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot_reg24;
    set nbaproj.team_sg_thrpt_stats_reg24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot_reg24;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot_reg24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2024;
***********************;

proc summary data=nbaproj.nbaregular24 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats_reg24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot_reg24;
    set nbaproj.team_sf_thrpt_stats_reg24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot_reg24;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot_reg24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2024;
***********************;

proc summary data=nbaproj.nbaregular24 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats_reg24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot_reg24;
    set nbaproj.team_pf_thrpt_stats_reg24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot_reg24;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot_reg24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2024;
***********************;

proc summary data=nbaproj.nbaregular24 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats_reg24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot_reg24;
    set nbaproj.team_c_thrpt_stats_reg24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot_reg24;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot_reg24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2024;
*****************;

proc summary data=nbaproj.nbaregular24 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats24
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot_reg24;
    set nbaproj.team_thrpt_stats24;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot_reg24;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot_reg24;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2024 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=.25 max=.45;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;


*****************************
2025 nbaregular
*****************************;


data nbaproj.nbaregular25untouched;
	infile "/home/u64430304/NBAPROJ/nbaregular2025.csv" dsd dlm=',' 
		firstobs=2;
	attrib Rk Player length=$30.;
	*extends space for player name variable, and keeps Rk in front;
	input Rk Player $ Age Tm $ Pos $ 
  G GS MP FG FGA FGpct _3P _3PA _3Ppct _2P _2PA _2Ppct eFGpct FT FTA FTpct 
		ORB DRB TRB AST STL BLK TOV PF PTS;
	if Tm = '2TM' or Tm = '3TM' or Tm = '4TM' then delete;
run;

data nbaproj.nbaregular25;
    *creates totals for 3p stats in order to get accurate team stats when merging players into teams;
    set nbaproj.nbaregular25untouched;
    Total_3PA = _3PA * G;
    Total_3P = _3P * G;
run;


***********************************
Point Guards 2025
***********************************;

proc summary data=nbaproj.nbaregular25 nway;
    class Tm;
    where Pos = "PG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pg_thrpt_stats_reg25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pgshoot_reg25;
    set nbaproj.team_pg_thrpt_stats_reg25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pgshoot_reg25;
	*TABULAR OUTPUT;
	title 
		"What team's Point Guards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*shows it as a % in tabular output;
run;

proc sgplot data=nbaproj.pgshoot_reg25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	*X AND Y AXIS LABELS;
	title 
		"What team's Point Guards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	*Graph shows % numbers on Y Axis Scale;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^ Each different position is scaled differently due to differences

		                        in general 3pt ability. i.e. Centers shoot less threes;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************************;
*SHOOTING GUARDS 2025;
***********************************;
proc summary data=nbaproj.nbaregular25 nway;
    class Tm;
    where Pos = "SG";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sg_thrpt_stats_reg25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sgshoot_reg25;
    set nbaproj.team_sg_thrpt_stats_reg25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sgshoot_reg25;
	*TABULAR OUTPUT;
	title 
		"What team's Shooting Guards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sgshoot_reg25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Shooting Guards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Small Forwards 2025;
***********************;

proc summary data=nbaproj.nbaregular25 nway;
    class Tm;
    where Pos = "SF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_sf_thrpt_stats_reg25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.sfshoot_reg25;
    set nbaproj.team_sf_thrpt_stats_reg25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.sfshoot_reg25;
	*TABULAR OUTPUT;
	title 
		"What team's Small Forwards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.sfshoot_reg25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Small Forwards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=8.5;
	*scaling the axis' ^;
	refline 4.5 / axis=x label="Over 4.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Power Forwards 2025;
***********************;

proc summary data=nbaproj.nbaregular25 nway;
    class Tm;
    where Pos = "PF";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_pf_thrpt_stats_reg25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.pfshoot_reg25;
    set nbaproj.team_pf_thrpt_stats_reg25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.pfshoot_reg25;
	*TABULAR OUTPUT;
	title 
		"What team's Power Forwards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.pfshoot_reg25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title 
		"What team's Power Forwards shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=6.5;
	*scaling the axis' ^;
	refline 3.5 / axis=x label="Over 3.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

***********************;
*Centers 2025;
***********************;

proc summary data=nbaproj.nbaregular25 nway;
    class Tm;
    where Pos = "C";
    var Total_3P Total_3PA G;
    output out=nbaproj.team_c_thrpt_stats_reg25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.centershoot_reg25;
    set nbaproj.team_c_thrpt_stats_reg25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
	array VariablesOfInterest _numeric_;

	do over VariablesOfInterest;

		if VariablesOfInterest=. then
			VariablesOfInterest=0;
	end;
	*The above 4 lines grabs the attention of all numeric values and replaces the missing

		  values with 0, which makes the data a little cleaner for me to play with.;
run;

proc print data=nbaproj.centershoot_reg25;
	*TABULAR OUTPUT;
	title "What team's Centers shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.centershoot_reg25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What team's Centers shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=0 max=.60;
	xaxis min=0 max=3;
	*scaling the axis' ^;
	refline 1.5 / axis=x label="Over 1.5 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;

*****************;
*ALL POSITIONS INCLUDED 2025;
*****************;

proc summary data=nbaproj.nbaregular25 nway;
    class Tm;
    var Total_3P Total_3PA G;
    output out=nbaproj.team_thrpt_stats25
        sum(Total_3P)=Made
        sum(Total_3PA)=Attempted
        max(G)=Team_Games;
run;

data nbaproj.teamshoot_reg25;
    set nbaproj.team_thrpt_stats25;
    Percentage = Made / Attempted;
    Made_Per_Game = Made / Team_Games;
    Attempted_Per_Game = Attempted / Team_Games;
    format Percentage percent7.1;
    drop _TYPE_ _FREQ_;
    rename Tm = Team;
run;

proc print data=nbaproj.teamshoot_reg25;
	*TABULAR OUTPUT;
	title "What teams shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
run;

proc sgplot data=nbaproj.teamshoot_reg25;
	*GRAPHICAL OUTPUT;
	label Made_Per_Game="3PT Shots Made" Percentage="3PT Shot %";
	title "What teams shot the best from 3 in the 2025 NBA Regular Season?";
	format Percentage PERCENT7.1;
	yaxis min=.25 max=.45;
	xaxis min=7.5 max=17.5;
	*scaling the axis' ^;
	refline 13 / axis=x label="Over 13 3PM/G" lineattrs=(color=red) 
		labelattrs=(color=red);
	refline .354 / axis=y label="League Average 3P%" lineattrs=(color=red) 
		labelattrs=(color=red);
	*adding reference lines ^ ;
	inset "High Volume, High Efficiency" / position=topright border;
	inset "Low Volume, High Efficiency" / position=topleft border;
	inset "Low Volume, Low Efficiency" / position=bottomleft border;
	inset "High Volume, Low Efficiency" / position=bottomright border;
	*adding text inside box ^ ;
	scatter x=Made_Per_Game y=Percentage / group=Team datalabel=Team jitter 
		markerattrs=(symbol=star);
	*scatter plot + options ^ ;
run;
