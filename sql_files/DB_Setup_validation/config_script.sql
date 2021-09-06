-- Connect to PDB using SYS user and grant permissions to pdbadmin dba user
grant unlimited tablespace to pdbadmin;
grant resource, connect, dba to pdbadmin;
commit;

-- Connect to PDB from pdbadmin 
CREATE USER cric_batch_user IDENTIFIED BY "cric_b@tch_pwd";
grant create session to cric_batch_user;
alter user cric_batch_user quota unlimited on users;

CREATE USER test_schema no authentication;
alter user test_schema quota unlimited on users;

create table test_schema.test_table (s_no number, p_name varchar2(50));
grant select, insert, update, delete on test_schema.test_table to cric_batch_user;

CREATE USER tgt_t20_dbo no authentication;
alter user tgt_t20_dbo quota unlimited on users;

CREATE USER temp_tgt_dbo no authentication;
alter user temp_tgt_dbo quota unlimited on users;

CREATE USER tgt_100_dbo no authentication;
alter user tgt_100_dbo quota unlimited on users;

-- Connect to PDB from cric_batch_user
insert into test_schema.test_table select 1,'jayashree' from dual;
insert into test_schema.test_table select 2,'chandrasekar' from dual;
commit;

select * from user_users;
select * from test_schema.test_table;
