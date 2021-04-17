-- from pdb sys
grant unlimited tablespace to pdbadmin;
grant resource, connect, dba to pdbadmin;
commit;

-- from pdbadmin
create table pdb_19c (message varchar2(200));
insert into pdb_19c values ('Welcome to Pluggable DB');
commit;
select * from pdb_19c; 

SELECT banner FROM v$version WHERE ROWNUM = 1;
select * from dba_user_role where grantee = 'cric_batch_user';

CREATE USER cric_batch_user IDENTIFIED BY "pwd";
grant create session to cric_batch_user;
alter user cric_batch_user quota unlimited on users;
grant create any table to cric_batch_user;

CREATE USER test_schema no authentication;
alter user test_schema quota unlimited on users;

create table test_schema.test_table (s_no number, p_name varchar2(50));
grant select, insert, update, delete on test_schema.test_table to cric_batch_user;

insert into test_schema.test_table select 1,'jayashree' from dual;
insert into test_schema.test_table select 2,'chandrasekar' from dual;
commit;

select * from user_users;
select * from test_schema.test_table;
-----------------------------------------------------
-- Creating tgt_dbo schema for table creation
CREATE USER tgt_t20_dbo no authentication;
alter user tgt_t20_dbo quota unlimited on users;
