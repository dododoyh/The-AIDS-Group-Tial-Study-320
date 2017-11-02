/* The AIDS Clinical Trials Group Study 320 */

FILENAME actg '/home/hy15c0/STA5244/actg320sample.csv';
proc import out = work.actg
 datafile = actg dbms=csv replace;
 getnames=yes;
 datarow=2;
run;
proc sort data = actg out = actg;
 by tx;
run;

/*Fit an exponential distribution for the primary outcome "time to AIDS defining event or death"
in each of the treatment groups (tx = 0; 1)*/

proc lifereg data = actg;
 by tx;
 model time*censor(0) =  / distribution = exponential;
run;

/*Assess whether the exponential distribution above is reasonable*/
proc lifetest data=actg plots=logsurv notable;
strata tx;
time time*censor(0);
run;

/*Plot the Kaplan-Meier estimators of the survival functions for each of the 
treatment groups (tx = 0; 1) and use the log rank test to determine whether 
the survival experience for the two treatment groups differs*/

proc lifetest data=actg plots=survival(atrisk cb) notable;
strata tx;
time time*censor(0);
run;


/*Fit a Cox proportional hazards regression model with tx as the sole predictor 
and assuming one unspecified baseline hazard function*/

proc phreg data = actg;
 class tx (ref = '0');
 model time*censor(0) = tx;
run;

/*Fit a Cox proportional hazards regression model with tx as the sole predictor and
allowing for different unspecifed baseline hazard functions for each CD4 strata*/
proc phreg data = actg;
 class tx (ref = '0') strat2;
 model time*censor(0) = tx;
 strata strat2;
run;


/* Fit a Cox proportional hazards regression model with tx, age and ivdrug as pre-
dictors*/

proc phreg data = actg;
 class tx (ref = '0') ivdrug strat2;
 model time*censor(0) = tx age ivdrug;
 strata strat2;
run;
title;

