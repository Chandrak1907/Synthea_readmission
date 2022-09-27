/* Below scripts are used to create tables in ADW from csv files in object storage */
/*Oracle Live labs for Manage and monitoring Autonomous Database: https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/?p210_workshop_id=553*/

set define off
begin
  DBMS_CLOUD.create_credential(
    credential_name => 'OBJ_STORE_CRED_new',
    username => 'oracleidentitycloudservice/chandrashekar.konda@oracle.com',
    password => 'EI9iH1yBGsr-V;2lTpY#'
  );
end;
/

set define on
define file_uri_base = 'https://objectstorage.us-ashburn-1.oraclecloud.com/n/orasenatdoracledigital01/b/Synthea/o'
/

drop table allergies;
CREATE TABLE allergies (
    start_new             date      NOT NULL,
    Stop                date     ,
    patient             varchar(50)   NOT NULL,
    encounter           varchar(50)   NOT NULL,
    code_new            varchar(50)   NOT NULL,
    system            varchar(50),
    description_new     varchar(50)   NOT NULL,
    type_new            varchar(50),
    category            varchar(50),
    reaction1           varchar(50),
    description1        varchar(50),
    severity1           varchar(50),
    reaction2           varchar(50),
    description2        varchar(50),
    severity2           varchar(50));

begin
 dbms_cloud.copy_data(
    table_name =>'allergies',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/allergies.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
 );
 end;

/
drop table conditions;
CREATE TABLE conditions(
start_new   Date    NOT NULL,
Stop    Date    ,
Patient varchar(50) NOT NULL,
Encounter   varchar(50) NOT NULL,
Code1    varchar(50) NOT NULL,
Description1 varchar(100) NOT NULL);

begin
  dbms_cloud.copy_data(
    table_name =>'conditions',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/conditions.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
 );
end;
/
drop table claims;
CREATE TABLE claims (
ID  varchar(50) NOT NULL,
Patient_ID  varchar(50) NOT NULL,
Provider_ID varchar(50) NOT NULL,
Primary_Patient_Insurance_ID    varchar(50) ,
Secondary_Patient_Insurance_ID  varchar(50) ,
Department_ID   Numeric NOT NULL,
Patient_Department_ID   Numeric NOT NULL,
Diagnosis1  varchar(50) ,
Diagnosis2  varchar(50) ,
Diagnosis3  varchar(50) ,
Diagnosis4  varchar(50) ,
Diagnosis5  varchar(50) ,
Diagnosis6  varchar(50) ,
Diagnosis7  varchar(50) ,
Diagnosis8  varchar(50) ,
Referring_Provider_ID   varchar(50) ,
Appointment_ID  varchar(50) ,
Current_Illness_Date    Date    NOT NULL,
Service_Date    Date    NOT NULL,
Supervising_Provider_ID varchar(50) ,
Status1 varchar(50) ,
Status2 varchar(50) ,
StatusP varchar(50) ,
Outstanding1    Numeric ,
Outstanding2    Numeric ,
OutstandingP    Numeric ,
LastBilledDate1 Date    ,
LastBilledDate2 Date    ,
LastBilledDateP Date    ,
HealthcareClaimTypeID1  Numeric ,
HealthcareClaimTypeID2  Numeric );


begin
 dbms_cloud.copy_data(
    table_name =>'claims',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/claims.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1,'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
 );
end;
/

drop table careplans;
CREATE TABLE careplans (
    id     varchar(50)  NOT NULL,
    start_new  date   NOT NULL,
    Stop   date,
    patient varchar(50)   NOT NULL,
    encounter varchar(50)   NOT NULL,
    code_new  varchar(50)   NOT NULL,
    description_new  varchar(100)   NOT NULL,
    reasoncode varchar(50) ,
    reasondescription varchar(100) );

begin
 dbms_cloud.copy_data(
    table_name =>'careplans',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/careplans.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
 );
end;

/

drop table devices;
CREATE TABLE devices (
start_new   Date    NOT NULL,
Stop    Date    ,
Patient varchar(50) NOT NULL,
Encounter   varchar(50) NOT NULL,
Code    varchar(50) NOT NULL,
Description varchar(100) NOT NULL,
UDI varchar(100) NOT NULL);
begin
 dbms_cloud.copy_data(
    table_name =>'devices',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/devices.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
 );
end;


/

drop table encounters;
CREATE TABLE encounters (
Id varchar(50) NOT NULL,
start_new   Date    NOT NULL,
Stop    Date    ,
Patient varchar(50) NOT NULL,
Organization    varchar(50) NOT NULL,
Provider    varchar(50) NOT NULL,
Payer   varchar(50) NOT NULL,
EncounterClass  varchar(50) NOT NULL,
Code    varchar(50) NOT NULL,
Description varchar(100) NOT NULL,
Base_Encounter_Cost Numeric NOT NULL,
Total_Claim_Cost    Numeric NOT NULL,
Payer_Coverage  Numeric NOT NULL,
ReasonCode  varchar(50) ,
ReasonDescription   varchar(100) );


begin
 dbms_cloud.copy_data(
    table_name =>'encounters',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/encounters.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
  );
end;

/


drop table immunizations;
CREATE TABLE immunizations (
"Date"    Date    NOT NULL,
Patient varchar(50) NOT NULL,
Encounter   varchar(50) NOT NULL,
Code    varchar(50) NOT NULL,
Description varchar(150) NOT NULL,
Cost    Numeric NOT NULL);

begin
 dbms_cloud.copy_data(
    table_name =>'immunizations',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/immunizations.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
  );
end;


/


drop table medications;

CREATE TABLE medications (
start_new   Date    NOT NULL,
Stop    Date,
Patient varchar(50) NOT NULL,
Payer   varchar(50) NOT NULL,
Encounter   varchar(50) NOT NULL,
Code    varchar(50) NOT NULL,
Description varchar(150) NOT NULL,
Base_Cost   Numeric NOT NULL,
Payer_Coverage  Numeric NOT NULL,
Dispenses   Numeric NOT NULL,
TotalCost   Numeric NOT NULL,
ReasonCode  varchar(50) ,
ReasonDescription   varchar(150)
);

begin
 dbms_cloud.copy_data(
    table_name =>'medications',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/medications.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
  );
end;
/

drop table observations;
CREATE TABLE observations (
"Date"    Date    NOT NULL,
Patient varchar(50) NOT NULL,
Encounter   varchar(50) NULL,
Code    varchar(50) ,
Description varchar(50) NOT NULL,
Value   varchar(250) NOT NULL,
Units   varchar(200) ,
Type    varchar(50) );


begin
 dbms_cloud.copy_data(
    table_name =>'observations',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/observations.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
  );
end;

/


drop table patients;
CREATE TABLE patients (
Id  varchar(50) NOT NULL,
BirthDate   Date    NOT NULL,
DeathDate   Date    ,
SSN varchar(50) NOT NULL,
Drivers varchar(50) ,
Passport    varchar(50) ,
Prefix  varchar(50) ,
First   varchar(50) NOT NULL,
Last    varchar(50) NOT NULL,
Suffix  varchar(50) ,
Maiden  varchar(50) ,
Marital varchar(50) ,
Race    varchar(50) NOT NULL,
Ethnicity   varchar(50) NOT NULL,
Gender  varchar(50) NOT NULL,
BirthPlace  varchar(150) NOT NULL,
Address varchar(50) NOT NULL,
City    varchar(50) NOT NULL,
State   varchar(50) NOT NULL,
County  varchar(50) ,
Zip varchar(50) ,
Lat varchar(50) ,
Lon varchar(50) ,
Healthcare_Expenses   numeric  NOT NULL,
Healthcare_Coverage   numeric  NOT NULL);

begin
 dbms_cloud.copy_data(
    table_name =>'patients',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/patients.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
  );
end;


/


drop table procedures;
CREATE TABLE procedures (
start_new   Date    NOT NULL,  
Stop    Date    ,
Patient varchar(50) NOT NULL,
Encounter   varchar(50) NOT NULL,
Code    varchar(50) NOT NULL,
Description varchar(150) NOT NULL,
Base_Cost   Numeric NOT NULL,
ReasonCode  varchar(50) ,
ReasonDescription   varchar(150));

begin
 dbms_cloud.copy_data(
    table_name =>'procedures',
    credential_name =>'OBJ_STORE_CRED_new',
    file_uri_list =>'&file_uri_base/procedures.csv',
    format => json_object('ignoremissingcolumns' value 'true', 'removequotes' value 'true','skipheaders' value 1, 'dateformat' value 'YYYY-MM-DD"T"HH24:mi:SS"Z"','delimiter' value ',') 
  );
end;
/