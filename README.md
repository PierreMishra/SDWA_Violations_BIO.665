#### Completed: April 2020

# Analyzing US Safe Drinking Water Act Violations since 1988

The results can be found at Output/Bayesian_Inference_Final_project.pptx 

## Summary

<b> Introduction </b>: Clean drinking water is one of the most basic necessity of a healthy lifestyle. In order to protect America's drinking water, the Environmental Protection Agency established several regulations and standards for more than 90 contaminants to protect public health. Since 1988, there have been approxiamtely 3 million SDWA violations by public water systems. According to the EPA, a violation is saide to pose pose acute health risks if it can result in an immediate illness. The goal of this project was to determine the effect of several characterisitics of a violation on its risk of causing acute health risks to the public. 

used Bayesian statistics to analyze the effects of  

Mention that I used Bayesian inference methods, priors, posteriors

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

#### 4. "RULE_NAME"

It describes the reason of a violation. There can be 19 possible reasons for an SDWA violation such as crossing the maximum permitted concentrations of arsenic, lead, copper, disinfectants, E.coli etc.


Full list of data elements and their description can be found at the Enforcement and Compliance History Online database:
https://echo.epa.gov/tools/data-downloads/sdwa-download-summary#filestructure
