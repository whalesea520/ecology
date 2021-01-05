alter table SystemSet add  mailAutoCloseLeft char(1) default '1'
/
update SystemSet set mailAutoCloseLeft='1'
/

alter table SystemSet add  rtxAlert char(1) default '1'
/
update SystemSet set rtxAlert='1'
/