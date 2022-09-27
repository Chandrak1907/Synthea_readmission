/* Below scripts are used to create features for machine learning */

/* Below  script will:
1. Identify the patients with an inpatient event
2. Calculates the duration between successive inpatient events
3. Selects the inpatient events that occurred in less than 31 days - These are avoidable readmission events and positive classes for ML
*/ 
<<<<<<< HEAD


=======
>>>>>>> 31fdb30fe30ddb7689fa9b789baff374b8372c5c
drop table A1;
CREATE table  A1 as
with temp1 as 
( select patient, start_new, stop, (stop-start_new) as inp_duration, 
lead(start_new,1) over (order by patient,start_new) as next_inpatient,
(lead(start_new,1) over (order by patient,start_new) - stop ) as dif_two_visits,
lead(patient,1) over(order by patient) as next_patient
from encounters 
where trim(ENCOUNTERCLASS)='inpatient'
GROUP by patient, start_new, stop, (stop-start_new)
order by patient, start_new, stop),
temp2 as (
select *
from temp1 where 
dif_two_visits < 31 and
 patient=next_patient )
select temp2.* ,rank() over(PARTITION by temp2.patient order by temp2.start_new) as rnk from temp2;



/* Below  script will join above table with original encounters table and filters out all patients that had an inpatient event. This will
1. Identify the patients that did not have an inpatient event 
*/ 
<<<<<<< HEAD

=======
>>>>>>> 31fdb30fe30ddb7689fa9b789baff374b8372c5c
drop table B2;
Create table B2 as 
with temp1 as 
(select encounters.patient, encounters.start_new, encounters.stop, A1.patient as p2, (encounters.stop-encounters.start_new) as inp_duration
from encounters
left join A1 on
encounters.patient = A1.PATIENT
where trim(encounters.ENCOUNTERCLASS)='inpatient')
select temp1.* ,rank() over(PARTITION by temp1.patient order by temp1.start_new) as rnk 
from temp1
where p2 is null;

<<<<<<< HEAD
/* selecting all patients without an avoidable readmission event. Included the first inpatient event*/
drop table sample_table_no_rap;
CREATE table  sample_table_no_rap as
select patient, start_new, stop, inp_duration from B2 where rnk=1;


=======

/* selecting all patients without an avoidable readmission event. Included the first inpatient event*/
CREATE table  sample_table_no_rap as
select patient, start_new, stop, inp_duration from B2 where rnk=1;

>>>>>>> 31fdb30fe30ddb7689fa9b789baff374b8372c5c
/* One patient could have multiple readmission events. Included the first event as an avoidable readmission event */
drop table sample_table;
CREATE table  sample_table as
select patient, start_new, stop, inp_duration from A1 where rnk=1;

ALTER TABLE sample_table_no_rap ADD readmission VARCHAR2(1) DEFAULT 'N';
ALTER TABLE sample_table ADD readmission VARCHAR2(1) DEFAULT 'Y';

drop table rap_table;
CREATE table  rap_table as
select * from sample_table_no_rap
union
select * from sample_table;

<<<<<<< HEAD
=======
/* Adding readmission date - 12 months as start_1yr. This will be useful in feature generation */
select count(*) from rap_table;
select rap_table.*, add_months(rap_table.start_new,-12) as start_1yr  from rap_table;

select * from allergies;
>>>>>>> 31fdb30fe30ddb7689fa9b789baff374b8372c5c

drop table allergy_features;
create table allergy_features as
select allergies.patient, allergies.code_new, allergies.description_new, allergies.description1, allergies.description2
from rap_table inner join allergies
on rap_table.patient = allergies.PATIENT
where  rap_table.start_new >= allergies.start_new;

drop table allergy_features1;
create table allergy_features1 as
select patient, code_new, count(code_new) as allergy_cnt
from allergy_features
group by patient, code_new;


drop table careplan_features;
create table careplan_features as
select careplans.patient, careplans.code_new, careplans.description_new, careplans.reasondescription
from rap_table inner join careplans
on rap_table.patient = careplans.PATIENT
where  careplans.start_new between add_months(rap_table.start_new,-12) and rap_table.start_new;

drop table careplan_features1;
create table careplan_features1 as
select patient, code_new, count(code_new) as careplan_cnt
from careplan_features
group by patient, code_new;


drop table claim_features;
create table claim_features as
with temp1 as
(select distinct patient_id, service_date, diagnosis1, diagnosis2, diagnosis3, diagnosis4,diagnosis5,diagnosis6,diagnosis7,diagnosis8
from claims )
select rap_table.patient, temp1.diagnosis1,temp1.diagnosis2,temp1.diagnosis3,temp1.diagnosis4,temp1.diagnosis5,temp1.diagnosis6,temp1.diagnosis7,temp1.diagnosis8
from rap_table inner join temp1
on rap_table.patient = temp1.patient_id
where  temp1.service_date between add_months(rap_table.start_new,-12) and rap_table.start_new;


drop table claim_features1 ;
create table claim_features1 as
select patient, diagnosis1, count(diagnosis1) as diagnosis1_cnt
from claim_features
group by patient, diagnosis1;


drop table claim_features2 ;
create table claim_features2 as
select patient, diagnosis2, count(diagnosis2) as diagnosis2_cnt
from claim_features
group by patient, diagnosis2;

drop table claim_features3 ;
create table claim_features3 as
select patient, diagnosis3, count(diagnosis3) as diagnosis3_cnt
from claim_features
group by patient, diagnosis3;


drop table conditions_features_tmp1;
create table conditions_features_tmp1 as
select rap_table.patient, code1, description1, conditions.start_new as starta, 
case when conditions.stop is null then rap_table.start_new else conditions.stop end as stopa,
add_months(rap_table.start_new,-12) as startb,
rap_table.start_new as stopb
from rap_table inner join conditions
on rap_table.patient = conditions.patient;

drop table conditions_features_tmp2;
create table conditions_features_tmp2 as
select * from conditions_features_tmp1
where  starta <= stopb and stopa >=startb;

drop table conditions_features;
create table conditions_features as
select distinct patient, code1, description1 from conditions_features_tmp2;

drop table conditions_features1;
create table conditions_features1 as
select patient, code1, count(code1) condition_cnt
from conditions_features
group by patient,code1;

drop table devices_tmp1;
create table devices_tmp1 as
select rap_table.patient, code, Description, devices.start_new as starta, 
case when devices.stop is null then rap_table.start_new else devices.stop end as stopa,
add_months(rap_table.start_new,-12) as startb,
rap_table.start_new as stopb
from rap_table inner join devices
on rap_table.patient = devices.patient;


drop table devices_tmp2;
create table devices_tmp2 as
select * from devices_tmp1
where  starta <= stopb and stopa >=startb;

drop table devices_features;
create table devices_features as
select distinct patient, code, description from devices_tmp2;

drop table devices_features1;
create table devices_features1 as
select patient, code, count(code) as devices_cnt
from devices_features
group by patient, code;


drop table encounters_1yr;
create table encounters_1yr as
select rap_table.patient, ENCOUNTERS.ENCOUNTERCLASS, encounters.code, encounters.start_new, encounters.stop, rap_table.start_new  as index_dt from rap_table inner join ENCOUNTERS
on rap_table.patient = encounters.patient
where  encounters.start_new <= rap_table.start_new  and encounters.stop >=add_months(rap_table.start_new,-12);

drop table encounters_1yr1;
create table encounters_1yr1 as
select patient, code, count(code) as encounter_cnt
from encounters_1yr
group by patient, code;


drop table encounters_6mo;
create table encounters_6mo as
select rap_table.patient, ENCOUNTERS.ENCOUNTERCLASS, encounters.code, encounters.start_new, encounters.stop, rap_table.start_new  as index_dt from rap_table inner join ENCOUNTERS
on rap_table.patient = encounters.patient
where  encounters.start_new <= rap_table.start_new  and encounters.stop >=add_months(rap_table.start_new,-6);

drop table encounters_6mo1;
create table encounters_6mo1 as
select patient, code, count(code) as encounter_cnt
from encounters_6mo
group by patient, code;


drop table immunization_features;
create table immunization_features as
select rap_table.patient, rap_table.start_new, immunizations.code, immunizations.description
from rap_table inner join IMMUNIZATIONS on
rap_table.patient = immunizations.patient 
where  immunizations."Date" between add_months(rap_table.start_new,-12) and rap_table.start_new;

drop table immunization_features1;
create table immunization_features1 as
select patient, code, count(code) as immunizations_cnt
from immunization_features
group by patient, code;



drop table medications_tmp1;
create table medications_tmp1 as
select rap_table.patient, medications.code, medications.description, medications.dispenses,
medications.start_new as starta,
case when medications.stop is null then rap_table.start_new else medications.stop end as stopa,
add_months(rap_table.start_new,-12) as startb,
rap_table.start_new as stopb
from rap_table inner join medications
on rap_table.patient = medications.patient;



drop table medications_features;
create table medications_features as
select distinct patient, code, description, dispenses, starta, stopa, startb, stopb, 
case when starta=stopa then 0 else ((stopb-startb)/(stopa-starta))*dispenses end as frac  from medications_tmp1
where  starta <= stopb and stopa >=startb;


drop table medications_features1;
create table medications_features1 as
select patient, code, sum(frac) as dispenses_cnt
from medications_features
group by patient, code;

drop table patients_tmp1;
create table patients_tmp1 as 
select rap_table.patient, rap_table.start_new, patients.birthdate, 
floor(months_between(rap_table.start_new, patients.birthdate) /12) as age,
(rap_table.start_new- patients.birthdate) as age1, patients.race, patients.ethnicity, patients.gender
from rap_table inner join patients
on rap_table.patient = patients.id;

drop table procedures_tmp1;
create table procedures_tmp1 as 
select rap_table.patient, rap_table.start_new as stopb, add_months(rap_table.start_new,-12) as startb,
procedures.start_new as starta, procedures.stop as stopa, 
procedures.code, procedures.description
from rap_table inner join procedures
on rap_table.patient = procedures.patient;


drop table procedures_features;
create table procedures_features as 
select distinct patient, starta, startb, stopa, stopb, code, description from procedures_tmp1
where  starta <= stopb and stopa >=startb;

drop table procedures_features1;
create table procedures_features1 as
select patient, code, count(code) as procedures_cnt
from procedures_features
group by patient, code;
