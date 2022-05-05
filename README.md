# Overview:

A patient being admitted within a specific time period, 30 days or 90 days, following the previous hospital visit of a discharged patient is called as a readmission event. Number of readmission events are a metric for US healthcare system. Avoidable readmission events cost /$41.3B anual cost. 

For demoing the predictive modeling of readmission use case, we used synthetic patient data from [Synthea](https://github.com/synthetichealth/synthea). This repo has the code for end-to-end machine learing i.e., creating synthetic data from Synthea, storing data in object storage, creating ADW tables, engineering the features and training & deploying model using Oracle ADS.


# Business use:

Health insurance companies spend 80\% of the cost on 20\% of the insured members. One of the main contributors to this cost is readmission events. Health insurance companies have specialized nurse support to outreach members with an in-hospital admission, to ensure that they are properly treated at the hospital and to send them to a right triage after discharge. Readmission predictive model would help health insurance companies to utilize their nurse resources to target members with high risk of readmission and reduce the medical cost.

In US, Center for Medicare and Medicaid services (CMS) provides STARs rating to hospital quality summarizing a variety of measures across 5 areas (mortality, safety of care, readmission, patient experience and timely & effective care) of quality for each hospital.  Readmission being one of the key measures, predictive model would help hospitals to identify the patients that are at high risk of readmission and improve their quality of care


# Data set:

Synthea is the best alternative to get medical data for creating demo assets without any PHI/PII issues. Process of generating the data is mentioned in Synthea's [README](https://github.com/synthetichealth/synthea). For the purpose of this ML model, synthetic data in csv format is created for 1M patients.

# Meta data:

Synthea creates below csv files. Of these "patients.csv" is the key file with "ID" column as the primary key to link all other csvs


|File 	                   	|Description|
|---------------------------|-------------------|
|patients.csv 				|Patient demographic data.|
|allergies.csv 				|Patient allergy data.|
|careplans.csv			 	|Patient care plan data, including goals.|
|claims.csv 				|Patient claim data.|
|claims_transactions.csv 	|Transactions per line item per claim.|
|conditions.csv 			|Patient conditions or diagnoses.|
|devices.csv 				|Patient-affixed permanent and semi-permanent devices.|
|encounters.csv			 	|Patient encounter data.|
|imaging_studies.csv 		|Patient imaging metadata.|
|immunizations.csv 			|Patient immunization data.|
|medications.csv 			|Patient medication data.|
|observations.csv 			|Patient observations including vital signs and lab reports.|
|organizations.csv 			|Provider organizations including hospitals.|
|payer_transitions.csv 		|Payer Transition data (i.e. changes in health insurance).|
|payers.csv 				|Payer organization data.|
|procedures.csv 			|Patient procedure data including surgeries.|
|providers.csv 				|Clinicians that provide patient care.|
|supplies.csv 				|Supplies used in the provision of care.|

CSV file data dictionary is available [here](https://github-wiki-see.page/m/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary).


# OCI Product/Services used in this demo:
1. [Object storage](https://docs.oracle.com/en-us/iaas/Content/Object/home.htm)
2. [Autonomous data warehouse](https://docs.oracle.com/en/cloud/paas/autonomous-data-warehouse-cloud/)
3. [Data science platform](https://docs.oracle.com/en-us/iaas/data-science/using/data-science.htm)
4. [Model catalog](https://docs.oracle.com/en-us/iaas/data-science/using/models-about.htm)
5. [Model deployment](https://docs.oracle.com/en-us/iaas/data-science/using/model-dep-about.htm)


# Reference architecture diagram

# Pre-requisites
1. On desktop machine, install [OCI Command Line Interface](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm).  
2. Install 'generalml_p37_cpu_v1' conda environment in datascience notebook
3. Upgrade ads package using below: 
```
pip uninstall  oracle-ads==2.5.9
pip Install oracle_ads==2.5.9
```



# How to use this repo?
1. Follow [README](https://github.com/synthetichealth/synthea) section of Synthea and create a dataset of atleast 100K patients 
2. Create a bucket in OCI object storage and load all CSVs to object storage. [(Reference)](https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.8.1/oci_cli_docs/cmdref/os/object/put.html)
3. Provision autonomous database as mentioned in this [live lab](https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/workshop-attendee-2?p210_workshop_id=553&p210_type=2&session=117445891684673)
3. "data_prep" folder has "001_load_tables.sql" script to load CSVs to tables in ADW
4.  In ADW, run scripts in '002_create_features.sql' in SQL worksheet. Refer to [livelab](https://oracle.github.io/learning-library/data-management-library/autonomous-database/shared/workshops/freetier-indepth/?lab=adb-query)
5. Run 001_combine_features.ipynb to create ML ready dataframe. Run to [livelab](https://oracle.github.io/learning-library/data-management-library/autonomous-database/shared/workshops/freetier-indepth/?lab=adw-connection-wallet) for getting ADW wallets
6. Run 001_build_model.ipynb to create , catalog and deploy a ML model using Oracle ADS
