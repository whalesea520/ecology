delete htmllabelindex where id in(271877,271878)
/
delete htmllabelinfo where indexid in (271877,271878)
/
insert into htmllabelindex(id,indexdesc) values(271879,'审批成功可以将流程主表字段值回写到当前模块中，比如：a=$A$,b=$B$')
/
insert into htmllabelinfo(indexid,labelname,languageid) values(271879,'审批成功可以将流程主表字段值回写到当前模块中，比如：a=$A$,b=$B$',7)
/
insert into htmllabelinfo(indexid,labelname,languageid) values(271879,'Success of examination and approval process can be the main table field value back to the current module, such as: a = $a$, b = $b$',8)
/
insert into htmllabelinfo(indexid,labelname,languageid) values(271879,'審批成功可以將流程主表字段值回寫到當前模塊中，比如：a=$A$,b=$B$',9)
/
insert into htmllabelindex(id,indexdesc) values(271878,'其中a,b为当前表单中的数据库字段名，A,B为流程主表字段名称。格式必须为：$字段名称$')
/
insert into htmllabelinfo(indexid,labelname,languageid) values(271878,'其中a,b为当前表单中的数据库字段名，A,B为流程主表字段名称。格式必须为：$字段名称$',7)
/
insert into htmllabelinfo(indexid,labelname,languageid) values(271878,'Among them a, b for the current database field name in the form, a, b for the process the main table field names. Format must be: $$field name',8)
/
insert into htmllabelinfo(indexid,labelname,languageid) values(271878,'其中a,b為當前表單中的數據庫字段名，A,B為流程主表字段名稱。格式必須為：$字段名稱$',9)
/



