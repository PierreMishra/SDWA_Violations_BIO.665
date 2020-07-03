#### Completed: April 2020

# Analyzing US Safe Drinking Water Act Violations since 1988

The results of the analyses can be found at Output/Bayesian_Inference_Final_project.pptx 

## Overview

<b> Introduction </b>: Clean drinking water is one of the most basic necessity of a healthy lifestyle. In order to protect America's drinking water, the Environmental Protection Agency established several regulations and standards for more than 90 contaminants to protect public health. Since 1988, there have been approxiamtely 3 million SDWA violations by public water systems. According to the EPA, a violation is said to pose acute health risks if it can result in an immediate illness.
The objective of this project was to investigate key factors associated with the risk of an SDWA violation posing acute health risks. 

<b> Method </b>: I used Bayesian statistics to perform two analysis. First, I performed logsitic regression using a logit function to investigate the effects on acute health-based violations by public water system type, number of population served by the water system and the source of water supply. Second, I aggregated the SDWA violations into count data by individual states to perform poisson regresson using a log link function and analyzed the temporal effect on frequency of acute-health based violations.

<b> Results </b>: According to the logistic regression model, surface water was positively associated to an acute health-based violation while groundwater was negatively associated. The likelihood of a violation posing public health risks for different public water systems was in the order of TNCWS > NTNCWS > CWS (abbreviation description in data definitions below) where TNCWS and NTNCWS water systems were positively linked to a violation posing acute health risks while CWS was negatively linked. Lastly, the number of population served by a public water system was inversely proportional to the likelihood of an acute-health based violation. The variables' coefficients can be viewed in the .pptx file in the output folder.

The poisson regression model compared the trend of acute health-based SDWA violations among different states. The result was geocoded on a US map with state boundaries that can be viewed in the .pptx file in the output folder.

<b> Conclusion </b>: In an event of an SDWA violation, a utility dependent on surface water is more likely to pose public health risks than the ones on ground water. Violations are more likely to pose health risk in areas served by TNCWS and NTNCWS public water systems while CWS systems are safer. Lastly, violations are more likely to pose acute health risks if a utility serves a smaller number of people. It is due to the fact that smaller customer base constitutes tax dollars insufficient to perform necessary repairs or upgrades to the water utilities. As a result, subpar infrastructure leads to public health risks. 

## Investigator

Pierre Mishra, Masters of Environmental Management, 2021, Nicholas School of the Environment, Duke University

Contact: prashank.mishra@duke.edu

## Keywords

safe drinking water act violations, public health, drinking water, bayesian inference, poisson regressions, logistic regression, environmental protection agency, R, spatial analysis, states

## Data Definitions

SDWA_VIOLATIONS.csv is used for this project. It is one of the files found in the ZIP file downloaded from Environmental Protection Agency's Safe Drinking Water Information System (SDWIS) database for public water systems. It contains information of all the SDWA violations since 1988 for different kinds of public water systems in the US. Source: https://echo.epa.gov/tools/data-downloads 

### Response Variable

#### ACUTE_HEALTH_BASED 

It indicates whether the violations are health based violations that have the potential to produce immediate illness. It takes binary values 0 (no) or 1 (yes).

### Predictor Variables

#### 1. PWS_TYPE_CODE 

It is a factor variable with 3 possible values that describes different kinds of public water systems:

* Community Water System (CWS): Systems serving at least 25 year-round residents. Example – Homes, apartments etc that are occupied as primary residences.

* Transient Non Community Water System (TNCWS): Systems serving less than 25 of the same people over six months per year. Example – A drinking water well serving campground or a highway rest stop.

* Non Transient Non Community Water System (NTNCWS): Non-community systems serving at least 25 of the same persons over six months per year. Example – Schools or hospitals having their own source of water.

#### 2. SOURCE_WATER

It is a factor variable with 2 possible outcomes:

* Surface Water (SW)

* Ground water (GW)

#### 3. "POPULATION_SERVED_COUNT"

It is a continuous variable describing the number of users that a water utility serves.


Full list of data elements and their description can be found at the Enforcement and Compliance History Online database:
https://echo.epa.gov/tools/data-downloads/sdwa-download-summary#filestructure
