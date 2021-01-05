ALTER table votingquestion ADD test varchar2(400)
/
update votingquestion set test = subject
/
ALTER table votingquestion drop column subject
/
ALTER TABLE votingquestion RENAME COLUMN test TO subject
/
