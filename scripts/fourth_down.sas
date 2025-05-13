/* ===================================================================== */
/* NFL 4th Down Decision Modeling Project
   Author: Satkar Karki
   Created: 05/06/2025
   Description: End-to-end SAS pipeline for modeling 4th down decisions  */
/* ===================================================================== */

/* --------------------------------------------------------------------- */
/* PHASE 1: DATA PREPARATION                                             */
/* --------------------------------------------------------------------- */

/* Step 1: Import the 2024 NFL play-by-play data */
title 'Importing the NFL 2024 Play-by-Play Data';
proc import datafile="/home/u64132146/sasuser.v94/PG2/data/play_by_play_2024.csv"
	out=work.nfl_pbp_2024
	dbms=csv
	replace;
	getnames=yes;
run;

/* Step 2: Review variable names and attributes */
title 'Variable List and Attributes for Raw NFL Play-by-Play Data';
proc contents data=work.nfl_pbp_2024;
run;

/* Step 3: Filter for 4th down plays only */
title 'Filtering for 4th Down Plays';
data work.fourth_down_raw;
	set work.nfl_pbp_2024;
	where down=4;
run;

/* Step 4: Engineer binary outcome and retain relevant predictors */
title 'Creating go_for_it Variable and Selecting Predictors';
data work.fourth_down_clean;
	set work.fourth_down_raw;
	
	/* Create the binary outcome variable */
	if play_type in ('run', 'pass') then go_for_it = 1;
	else if play_type in ('punt', 'field_goal') then go_for_it = 0;
	else go_for_it = .;
	
	/* Retain only variables needed for analysis */
	keep game_id qtr game_seconds_remaining down ydstogo yardline_100 
		posteam defteam posteam_type score_differential play_type epa 
		posteam_timeouts_remaining defteam_timeouts_remaining go_for_it;
run;

/* Step 5: Review cleaned dataset structure and sample records */
title 'Contents of Cleaned 4th Down Dataset';
proc contents data=work.fourth_down_clean;
run;

title 'First 10 Observations of Cleaned 4th Down Dataset';
proc print data=work.fourth_down_clean(obs=10);
run;

/* Step 6: Frequency distribution of go_for_it (all 4th downs) */
title 'Frequency Distribution of go_for_it Variable';
proc freq data=work.fourth_down_clean;
	tables go_for_it / nocum nopercent;
run;

/* Step 7: Investigate missing go_for_it values by play_type */
title 'Distribution of play_type for Missing go_for_it';
proc freq data=work.fourth_down_clean;
	tables play_type;
	where go_for_it = .;
run;

/* Step 8: Create analysis-ready dataset (go_for_it = 0 or 1) */
title 'Analysis-Ready 4th Down Dataset';
data work.fourth_down_final;
	set work.fourth_down_clean;
	if go_for_it in (0,1);
run;

title 'Frequency Distribution of go_for_it (Final Dataset)';
proc freq data=work.fourth_down_final;
	tables go_for_it / nocum nopercent;
run;

title; 

/* --------------------------------------------------------------------- */
/* PHASE 2: EXPLORATORY DATA ANALYSIS (EDA)                             */
/* --------------------------------------------------------------------- */

/* Step 1: Frequency tables for key categorical variables */
title 'Frequency Distribution for Categorical Variables';
proc freq data=work.fourth_down_final;
	tables qtr go_for_it play_type posteam_type / nocum;
run;

/* Bar chart: Frequency distribution of Quarter (qtr) */
title 'Bar Chart: Frequency Distribution of Quarter (qtr)';
proc sgplot data=work.fourth_down_final;
	vbar qtr / datalabel;
	xaxis label='Quarter';
	yaxis label='Frequency';
run;

/* Bar chart: Frequency distribution of Go-For-It Decision */
title 'Bar Chart: Frequency Distribution of Go-For-It Decision';
proc sgplot data=work.fourth_down_final;
	vbar go_for_it / datalabel;
	xaxis label='Go For It (1 = Yes, 0 = Kick)';
	yaxis label='Frequency';
run;

/* Bar chart: Frequency distribution of Play Type */
title 'Bar Chart: Frequency Distribution of Play Type';
proc sgplot data=work.fourth_down_final;
	vbar play_type / datalabel;
	xaxis label='Play Type';
	yaxis label='Frequency';
run;

/* Bar chart: Frequency distribution of Posteam Type (Home/Away) */
title 'Bar Chart: Frequency Distribution of Posteam Type (Home/Away)';
proc sgplot data=work.fourth_down_final;
	vbar posteam_type / datalabel;
	xaxis label='Posteam Type (0 = Away, 1 = Home)';
	yaxis label='Frequency';
run;

/* Step 2: Summary statistics for key continuous variables */
title 'Summary Statistics for Key Continuous Variables';
proc means data=work.fourth_down_final n mean std min max;
	var game_seconds_remaining ydstogo yardline_100 score_differential epa posteam_timeouts_remaining defteam_timeouts_remaining;
run;

/* Boxplots for continuous variables by go_for_it decision */
title 'Boxplot: Yards to Go by Go-For-It Decision';
proc sgplot data=work.fourth_down_final;
	vbox ydstogo / category=go_for_it;
	xaxis label='Go For It (1 = Yes, 0 = Kick)';
	yaxis label='Yards to Go';
run;

title 'Boxplot: Yardline_100 by Go-For-It Decision';
proc sgplot data=work.fourth_down_final;
	vbox yardline_100 / category=go_for_it;
	xaxis label='Go For It (1 = Yes, 0 = Kick)';
	yaxis label='Yardline_100 (Distance from Opponent Endzone)';
run;

title 'Boxplot: Game Seconds Remaining by Go-For-It Decision';
proc sgplot data=work.fourth_down_final;
	vbox game_seconds_remaining / category=go_for_it;
	xaxis label='Go For It (1 = Yes, 0 = Kick)';
	yaxis label='Game Seconds Remaining';
run;

title 'Boxplot: Score Differential by Go-For-It Decision';
proc sgplot data=work.fourth_down_final;
	vbox score_differential / category=go_for_it;
	xaxis label='Go For It (1 = Yes, 0 = Kick)';
	yaxis label='Score Differential';
run;

title 'Boxplot: EPA by Go-For-It Decision';
proc sgplot data=work.fourth_down_final;
	vbox epa / category=go_for_it;
	xaxis label='Go For It (1 = Yes, 0 = Kick)';
	yaxis label='Expected Points Added (EPA)';
run;

/* Step 3: Two-way cross-tabulation: quarter vs go_for_it */
title 'Two-way Cross-Tabulation: Quarter vs Go-For-It Decision';
proc freq data=work.fourth_down_final;
	tables qtr*go_for_it / nocol nopercent;
run;

/* Step 4: Chi-Square Test and Association Measures: Quarter vs Go-For-It */
title 'Chi-Square Test: Quarter vs Go-For-It Decision';
proc freq data=work.fourth_down_final;
	tables qtr*go_for_it / chisq expected cellchi2 nocol nopercent relrisk;
run;

/* Step 5: Early vs Late Quarters (period variable) */
title 'Creating Early vs Late Period Variable';
data work.fourth_down_period;
	set work.fourth_down_final;
	length period $5;
	if qtr in (1,2) then period='early';
	else if qtr in (3,4) then period='late';
run;

title 'Odds Ratio: Early vs Late Quarters for Go-For-It Decisions';
proc freq data=work.fourth_down_period;
	tables period*go_for_it/ chisq expected cellchi2 nocol nopercent relrisk;
run;

/* Step 6: Q1-3 vs Q4 Quarter Grouping */
title 'Creating Q1-3 vs Q4 Quarter Group Variable';
data work.fourth_down_qtrgroup;
	set work.fourth_down_final;
	length qtr_group $5;
	if qtr in (1,2,3) then qtr_group = 'Q1-3';
	else if qtr = 4 then qtr_group = 'Q4';
run;

title 'Odds Ratio: Q1-3 vs Q4 for Go-For-It Decision';
proc freq data=work.fourth_down_qtrgroup;
	tables qtr_group*go_for_it / chisq expected cellchi2 nocol nopercent relrisk;
run;

title; 

/* --------------------------------------------------------------------- */
/* PHASE 3: PREDICTIVE MODELING                                         */
/* --------------------------------------------------------------------- */

/* Step 1: Fit full logistic regression model with all candidate predictors */
title 'Full Logistic Regression Model: All Candidate Predictors';
ods noproctitle;
ods graphics / imagemap=on;
proc logistic data=WORK.FOURTH_DOWN_FINAL plots(only)=(oddsratio(cldisplay=serifarrow) roc);
	class qtr posteam_timeouts_remaining defteam_timeouts_remaining posteam_type / param=glm;
	model go_for_it(event='1') = qtr posteam_timeouts_remaining defteam_timeouts_remaining posteam_type ydstogo yardline_100 game_seconds_remaining score_differential epa
		/ link=logit clparm=pl clodds=pl alpha=0.05 technique=fisher;
run;

/* Step 2: Stepwise variable selection for model refinement */
title 'Stepwise Selection Logistic Regression Model';
ods noproctitle;
ods graphics / imagemap=on;
proc logistic data=WORK.FOURTH_DOWN_FINAL plots(only)=(oddsratio(cldisplay=serifarrow) roc);
	class qtr posteam_timeouts_remaining defteam_timeouts_remaining posteam_type / param=glm;
	model go_for_it(event='1') = qtr posteam_timeouts_remaining defteam_timeouts_remaining posteam_type ydstogo yardline_100 game_seconds_remaining score_differential epa
		/ selection=stepwise slentry=0.05 slstay=0.05 hierarchy=single link=logit clparm=pl clodds=pl alpha=0.05 technique=fisher;
run;

title; 


