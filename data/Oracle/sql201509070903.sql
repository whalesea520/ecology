ALTER table  votingquestion  ADD testnakedpp clob
/
update   votingquestion set testnakedpp = subject
/
ALTER table  votingquestion  drop column subject
/
ALTER table votingquestion rename column testnakedpp to subject
/

ALTER table  votingoption  ADD testnakedpp clob
/
update   votingoption set testnakedpp = description
/
ALTER table  votingoption  drop column description
/
ALTER table votingoption rename column testnakedpp to description
/