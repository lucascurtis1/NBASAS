libname nbaproj '/home/u64430304/NBAPROJ';

*
taking playoff team advanced stats (primarily wins and losses) to make a connection between
3pt scoring prowess and winning the most important games.
;

data nbaproj.Team_Advanced_Playoffs;
	infile "/home/u64430304/NBAPROJ/Team_Playoff_Advanced.csv" dsd dlm=','
		firstobs = 2;
	input Rk Tm $ Age W L WLpct ORtg DRtg NRtg Pace FTr _3PAr TSpct;
	
run;