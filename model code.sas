
/*Unadjusted (GLM) for all SRS Summary Scores*/
%macro unadj(vari, databoy, datagirl, dataall);
proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0');
model &vari=cum_cmc_cat_v2/solution clparm;
where srs_sex=1;
ods output parameterestimates=&databoy; /*This outputs money table into a new datasets*/
run; quit;

proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0');
model &vari=cum_cmc_cat_v2/solution clparm;
where srs_sex=2;
ods output parameterestimates=&datagirl; /*This outputs money table into a new datasets*/
run; quit;

proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref="0");
model &vari=cum_cmc_cat_v2/solution clparm;
ods output parameterestimates=&dataall; /*This outputs money table into a new datasets*/
run; quit;
%mend;


%unadj(srs_t_awr, awr_boy, awr_girl, awr_all);
%unadj(rsrs_t_cog, cog_boy, cog_girl, cog_all); 
%unadj(srs_t_com, com_boy, com_girl, com_all);
%unadj(srs_t_mot, mot_boy, mot_girl, mot_all);
%unadj(srs_t_rrb, rrb_boy, rrb_girl, rrb_all);
%unadj(srs_t_sci, sci_boy, sci_girl, sci_all);
%unadj(srs_t_tot, tot_boy, tot_girl, tot_all);

%macro unadj_subscale(databoy, boytitle, datagirl, girltitle, dataall, alltitle);
proc print data=&databoy noobs; 
var dependent Estimate    StdErr	Probt	LowerCL	UpperCL;
format Estimate	8.2 StdErr 8.2	Probt PVALUE8.6	LowerCL	8.2 UpperCL 8.2; 
title &boytitle; run;

proc print data=&datagirl noobs; 
var dependent Estimate    StdErr	Probt	LowerCL	UpperCL;
format Estimate	8.2 StdErr 8.2	Probt PVALUE8.6	LowerCL	8.2 UpperCL 8.2; 
title &girltitle; run;

proc print data=&dataall noobs; 
var dependent Estimate  StdErr Probt	LowerCL	UpperCL;
format Estimate	8.2 StdErr 8.2	Probt PVALUE8.6	LowerCL	8.2 UpperCL 8.2; 
title &alltitle; run;
%mend;


/*Prints the outputted datsets*/
ods word file="J:\PM\TIDES_Data\RESEARCH\Output data for analyses\Cardiometabolic disease and SRS\Unadjusted Parameter Estimates_2.docx"
options (body_title='On');

%unadj_subscale(awr_boy, "SRS Social Awareness Subscale Score regressed on CMCs - Boy Unadjusted", 
				awr_girl, "SRS Social Awareness Subscale Score regressed on CMCs - Girl Unadjusted", 
				awr_all, "SRS Social Awareness Subscale Score regressed on CMCs - All Unadjusted");
%unadj_subscale(cog_boy, "SRS Social Cognition Subscale Score regressed on CMCs - Boy Unadjusted",
	   			cog_girl, "SRS Social Cognition Subscale Score regressed on CMCs - Girl Unadjusted",
	   			cog_all, "SRS Social Cognition Subscale Score regressed on CMCs - All Unadjusted"); 
%unadj_subscale(com_boy, "SRS Social Communication Subscale Score regressed on CMCs - Boy Unadjusted",
	   			com_girl, "SRS Social Communication Subscale Score regressed on CMCs - Girl Unadjusted",
	   			com_all, "SRS Social Communication Subscale Score regressed on CMCs - All Unadjusted");
%unadj_subscale(mot_boy, "SRS Social Motivation Subscale Score regressed on CMCs - Boy Unadjusted",
	   			mot_girl, "SRS Social Motivation Subscale Score regressed on CMCs - Girl Unadjusted",
	   			mot_all, "SRS Social Motivation Subscale Score regressed on CMCs - All Unadjusted");
%unadj_subscale(rrb_boy, "Repititive Behavior Score regressed on CMCs - Boy Unadjusted",
	   			rrb_girl, "Repititive Behavior Score regressed on CMCs - Girl Unadjusted",
	   			rrb_all, "Repititive Behavior Score regressed on CMCs - All Unadjusted");
%unadj_subscale(sci_boy, "Social communicaiton/interaction subscale score regressed on CMCs - Boy Unadjusted", 
				sci_girl, "Social communicaiton/interaction subscale score regressed on CMCs - Girl Unadjusted",
				sci_all, "Social communicaiton/interaction subscale score regressed on CMCs - All Unadjusted");
%unadj_subscale(tot_boy, "SRS Total Score regressed on CMCs - Boy Unadjusted", 
				tot_girl, "SRS Total Score regressed on CMCs - Girl Unadjusted", 
				tot_all, "SRS Total Score regressed on CMCs - All Unadjusted");
ods word close;


