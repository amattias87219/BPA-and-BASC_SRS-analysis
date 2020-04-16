
/**THIS IS THE MAIN ONE**/

proc freq data=work.Cmd_srs_setup_2;
table cum_cmc_cat_v2 prepreg_bmi_cat;
run;


/*BMI Only*/
proc glm data=work.Cmd_srs_setup_2 order=data;
class prepreg_bmi_cat (ref='1');
model srs_t_tot=prepreg_bmi_cat/solution clparm;
title "BMI categories (Normal, Overweight, Obese)";
ods output parameterestimates=unadj_glm_bmi; run; quit;

proc print data=unadj_glm_bmi; run;

proc genmod data=work.Cmd_srs_setup_2;
class prepreg_bmi_cat(ref='1') center (ref='7') mom_edu (ref='0') Income_binary (ref='0') 
	  momrace_binary (ref='0')/param=reference;
model srs_t_tot=prepreg_bmi_cat Age_Yrs center mom_edu Income_binary 
					 momrace_binary;
title "BMI categories (Normal, Overweight, Obese)";
ods output parameterestimates=adj_glm_bmi; run; quit;

proc print data=adj_glm_bmi; run;

/*All others*/
%macro uni(var, nameone, unadj, nametwo, adj);

proc glm data=work.Cmd_srs_setup_2  order=data;
class &var (ref='0');
model srs_t_tot=&var/solution clparm;
title &nameone;
ods output parameterestimates=&unadj;
run; quit;

proc print data=&unadj; run;

proc genmod data=work.Cmd_srs_setup_2;
class &var (ref='0') center (ref='7') mom_edu (ref='0') Income_binary (ref='0') 
	  momrace_binary (ref='0')/param=reference;
model srs_t_tot=&var Age_Yrs center mom_edu Income_binary 
					 momrace_binary;
title &nametwo;
ods output parameterestimates=&adj;
run; quit;

proc print data=&adj; run;

%mend;

%uni(prepreg_dm, "Prepregnancy DM (GLM unadjusted)", pp_dm_unadj, "Prepregnancy DM - Adjusted", pp_dm_adj);
%uni(GDM_any_confirmed, "GDM (GLM unadjusted)", gdm_unaj, "GDM - Adjusted", gdm_adj);
%uni(any_dm_confirmed, "Any confirmed DM through pregnancy (GLM unadjusted)", any_dm_unadj, "Any DM - Adjusted", any_dm_adj);
%uni(prepreg_htn_1, "Prepregnancy HTN (GLM unadjusted)", prepreg_htn_unadj, "Prepregnancy HTN - Adjusted", prepreg_htn_adj);
%uni(gestational_htn, "Gestational HTN (GLM unadjusted)", gest_htn_unadj, "Gestational HTN - Adjusted", gest_htn_adj); /*this is the only one that is vaguely interesting*/
%uni(preeclampsia_with_super, "Any Preeclampsia (GLM unadjusted)", preec_unadj, "Any Preeclampsia - Adjusted", preec_adj);
%uni(htn_all, "Any HDP(GLM unadjusted)", hdp_unadj, "Any HDP - Adjusted" , hdp_adj);
%uni(cumulative_cmc, "All CMCs (GLM unadjusted)", cumcmc_unadj, "All CMCs - Adjusted" ,cumcmc_adj);
%uni(cumulative_cmc_cat, "CMCs - 0, 1, 2 or more (GLM unadjusted)", cumcmccat_unadj, "CMCs - 0, 1, 2 or more Adjusted" , cumcmccat_adj);
%uni(cum_cmc_cat_v2, "CMCs - 0, 1, 2, 3 or more (GLM unadjusted)", cumcmccatv2_unadj,  "CMCs - 0, 1, 2, 3 or more Adjusted", cumcmccatv2_adj);
%uni(cum_cmc_binary, "Binary CMCs (at least one) (GLM unadjusted)", bincmc_unadj, "Binary CMCs - Adjusted", bincmc_adj);
%uni(pp_cmc, "Prepregancy CMC (GLM unadjusted)", ppcmc_unadj, "Prepregancy CMC - Adjusted", ppcmc_adj); 
%uni(during_cmc, "CMC during Pregnancy (GLM unadjusted)", duringcmc_unadj, "CMC during Pregnancy Adjusted", duringcmc_adj);


/*proc print parameter estimate tables of all iterations of exposure variables*/
%macro print_exp_srstotal(unadj_data, unadj_title, adj_data, adj_title);
proc print data=&unadj_data; 
title &unadj_title; run;

proc print data=&adj_data; 
title &adj_title; run;
%mend; 

%print_exp_srstotal(pp_dm_unadj, "Prepregnancy DM (GLM unadjusted)", pp_dm_adj, "Prepregnancy DM - Adjusted");
%print_exp_srstotal(gdm_unaj, "GDM (GLM unadjusted)", gdm_adj, "GDM - Adjusted");
%print_exp_srstotal(any_dm_unadj, "Any confirmed DM through pregnancy (GLM unadjusted)", any_dm_adj, "Any DM - Adjusted");
%print_exp_srstotal(prepreg_htn_unadj, "Prepregnancy HTN (GLM unadjusted)",  prepreg_htn_adj, "Prepregnancy HTN - Adjusted");
%print_exp_srstotal(gest_htn_unadj, "Gestational HTN (GLM unadjusted)", gest_htn_adj, "Gestational HTN - Adjusted");
%print_exp_srstotal(preec_unadj, "Any Preeclampsia (GLM unadjusted)", preec_adj, "Any Preeclampsia - Adjusted");
%print_exp_srstotal(hdp_unadj, "Any HDP(GLM unadjusted)", hdp_adj, "Any HDP - Adjusted" );
%print_exp_srstotal(cumcmc_unadj,"All CMCs (GLM unadjusted)", cumcmc_adj, "All CMCs - Adjusted");
%print_exp_srstotal(bincmc_unadj, "Binary CMCs (at least one) (GLM unadjusted)", bincmc_adj, "Binary CMCs - Adjusted");
%print_exp_srstotal(ppcmc_unadj, "Prepregancy CMC (GLM unadjusted)", ppcmc_adj,	"Prepregancy CMC - Adjusted");
%print_exp_srstotal(duringcmc_unadj, "CMC during Pregnancy (GLM unadjusted)", duringcmc_adj, "CMC during Pregnancy Adjusted");
%print_exp_srstotal(cumcmccatv2_unadj, "CMCs - 0, 1, 2, 3 or more (GLM unadjusted)", cumcmccatv2_adj, "CMCs - 0, 1, 2, 3 or more Adjusted");
/****************************************************************************************************/



/*Unadjusted (GLM) for all SRS Summary Scores*/
%macro unadj(vari, databoy, datagirl, dataall);
proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0');
model &vari=cum_cmc_cat_v2/solution clparm;
where srs_sex=1;
ods output parameterestimates=&databoy;
run; quit;

proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0');
model &vari=cum_cmc_cat_v2/solution clparm;
where srs_sex=2;
ods output parameterestimates=&datagirl;
run; quit;

proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref="0");
model &vari=cum_cmc_cat_v2/solution clparm;
ods output parameterestimates=&dataall;
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

/******************************************
Now, adjust for age, income, education for
		-social Cognition
		-Restricted Repetitive Behavior
		-Social communication and interaction
		-Total score
/******************************************/
			%macro modelone_adj(subscale, boyadj, girladj, alladj);
			/*Boys*/
			proc genmod data=work.Cmd_srs_setup_2;
			class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
			model &subscale=cum_cmc_cat_v2 Age_Yrs mom_edu Income_binary;
			ods output parameterestimates=&boyadj;
			where srs_sex=1;
			run; quit;

			/*Girls*/
			proc genmod data=work.Cmd_srs_setup_2;
			class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
			model &subscale=cum_cmc_cat_v2 Age_Yrs mom_edu Income_binary;
			ods output parameterestimates=&girladj;
			where srs_sex=2;
			run; quit;

			/*All*/
			proc genmod data=work.Cmd_srs_setup_2;
			class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
			model &subscale=cum_cmc_cat_v2 Age_Yrs mom_edu Income_binary;
			ods output parameterestimates=&alladj;
			run; quit;
			%mend;
			%modelone_adj(rsrs_t_cog,cog_boy_adj, cog_girl_adj, cog_all_adj);
			%modelone_adj(srs_t_rrb, rrb_boy_adj, rrb_girl_adj, rrb_all_adj);
			%modelone_adj(srs_t_sci, sci_boy_adj, sci_girl_adj, sci_all_adj);
			%modelone_adj(srs_t_tot, total_boy_adj, total_girl_adj, total_all_adj);

	/*Proc prints*/
			%macro pp_adj(databoy, boytitle, datagirl, girltitle, dataall, alltitle);
				proc print data=&databoy noobs;
				var parameter Estimate StdErr 		ProbChiSq			LowerWaldCL		UpperWaldCL;
				format Estimate	8.2    StdErr 8.2	ProbChiSq PVALUE8.6	LowerWaldCL	8.2 UpperWaldCL 8.2;
				title &boytitle; run;

				proc print data=&datagirl noobs;
				var parameter Estimate StdErr 		ProbChiSq			LowerWaldCL		UpperWaldCL;
				format Estimate	8.2    StdErr 8.2	ProbChiSq PVALUE8.6	LowerWaldCL	8.2 UpperWaldCL 8.2;
				title &girltitle; run;

				proc print data=&dataall noobs;
				var parameter Estimate StdErr 		ProbChiSq			LowerWaldCL		UpperWaldCL;
				format Estimate	8.2    StdErr 8.2	ProbChiSq PVALUE8.6	LowerWaldCL	8.2 UpperWaldCL 8.2;
				title &alltitle; run;
			%mend;

			ods word file="J:\PM\TIDES_Data\RESEARCH\Output data for analyses\Cardiometabolic disease and SRS\Adjusted Parameter Estimates.docx"
			options (body_title='On');

			%pp_adj(cog_boy_adj, "SRS Social Cognition Subscale Score regressed on CMCs - Boy adjusted",
							cog_girl_adj, "SRS Social Cognition Subscale Score regressed on CMCs - Girl adjusted",
							cog_all_adj, "SRS Social Cognition Subscale Score regressed on CMCs - All adjusted");
		
			%pp_adj(rrb_boy_adj, "Repititive Behavior Score regressed on CMCs - Boy Adjusted",
							rrb_girl_adj, "Repititive Behavior Score regressed on CMCs - Girl Adjusted",
							rrb_all_adj, "Repititive Behavior Score regressed on CMCs - All Adjusted");
							
			%pp_adj(sci_boy_adj, "SCI subscale score regressed on CMCs - Boy adjusted",
							sci_girl_adj, "SCI subscale score regressed on CMCs - Girl adjusted",
							sci_all_adj, "SCI subscale score regressed on CMCs - All adjusted");
							
			%pp_adj(total_boy_adj, "SRS Total Score regressed on CMCs - Boy adjusted",
							total_girl_adj, "SRS Total Score regressed on CMCs - Girl adjusted",
							total_all_adj, "SRS Total Score regressed on CMCs - All adjusted");
			ods word close;






/*******MODELS WITH ALL COVARIATES*********/
%macro srs(subscale);
/*Boys*/
proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0');
model &subscale=cum_cmc_cat_v2/solution clparm;
title "Boys - Unadjusted";
where srs_sex=1;
run; quit;

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') center (ref='7') mom_edu (ref='0') 
	  Income_binary (ref='0') momrace_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 Age_Yrs center mom_edu Income_binary momrace_binary;
title "Boys - Adjusted";
where srs_sex=1;
run; quit;

/*Girls*/
proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0');
model &subscale=cum_cmc_cat_v2/solution clparm;
title "Girls - Unadjusted";
where srs_sex=2;
run; quit;

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') center (ref='7') mom_edu (ref='0') 
	  Income_binary(ref='0') momrace_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 Age_Yrs center mom_edu Income_binary momrace_binary;
title "Girls - Adjusted";
where srs_sex=2;
run; quit;

/*All*/
proc glm data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref="0");
model &subscale=cum_cmc_cat_v2/solution clparm;
Title "All - Unadjusted";
run; quit;

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') center (ref='7') mom_edu (ref='0') 
	  Income_binary (ref='0') momrace_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 Age_Yrs center mom_edu Income_binary momrace_binary;
Title "All - Adjusted";
run; quit;
%mend;

%srs(srs_t_awr);
%srs(rsrs_t_cog); 
%srs(srs_t_com);
%srs(srs_t_mot);
%srs(srs_t_rrb);
%srs(srs_t_sci);
%srs(srs_t_tot);


%macro model_adj(subscale);
/*Boys*/

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 Age_Yrs mom_edu Income_binary;
title "Boys - Adjusted";
where srs_sex=1;
run; quit;

/*Girls*/

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 Age_Yrs mom_edu Income_binary;
title "Girls - Adjusted";
where srs_sex=2;
run; quit;

/*All*/

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 Age_Yrs mom_edu Income_binary;
Title "All - Adjusted";
run; quit;
%mend;

%model_adj(srs_t_awr);
%model_adj(rsrs_t_cog); 
%model_adj(srs_t_com);
%model_adj(srs_t_mot);
%model_adj(srs_t_rrb);
%model_adj(srs_t_sci);
%model_adj(srs_t_tot);


%macro model_noage(subscale);
/*Boys*/

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 mom_edu Income_binary;
title "Boys - Adjusted";
where srs_sex=1;
run; quit;

/*Girls*/

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 mom_edu Income_binary;
title "Girls - Adjusted";
where srs_sex=2;
run; quit;

/*All*/

proc genmod data=work.Cmd_srs_setup_2;
class cum_cmc_cat_v2 (ref='0') mom_edu (ref='0') Income_binary (ref='0')/param=reference;
model &subscale=cum_cmc_cat_v2 mom_edu Income_binary;
Title "All - Adjusted";
run; quit;
%mend;

%model_noage(srs_t_awr);
%model_noage(rsrs_t_cog); 
%model_noage(srs_t_com);
%model_noage(srs_t_mot);
%model_noage(srs_t_rrb);
%model_noage(srs_t_sci);
%model_noage(srs_t_tot);
