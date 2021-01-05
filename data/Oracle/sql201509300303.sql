drop  index dshareIndexDoc_sourceid
/
drop  index shareoutIndexDoc_sourceid
/
create  index dshareIndexDoc_sourceid on shareinnerdoc (sourceid desc)
/
create  index shareoutIndexDoc_sourceid on ShareouterDoc (sourceid desc)
/