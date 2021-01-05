insert into HrmDepartment (departmentmark,departmentname,countryid,addedtax,website,startdate,enddate,currencyid,seclevel,subcompanyid1,subcompanyid2,subcompanyid3,subcompanyid4,createrid,createrdate,lastmoduserid,lastmoddate) 
values ('Default','Default',1,'','','','',1,10,1,2,3,4,1,'2003-01-01',1,'2003-01-01')
/
insert into HrmCostcenter (costcentermark,costcentername,activable,departmentid,ccsubcategory1,ccsubcategory2,ccsubcategory3,ccsubcategory4)
values ('Default','Default','1',1,1,2,3,4)
/
insert into HrmJobTitles (jobtitlemark,jobtitlename,seclevel,joblevelfrom,joblevelto,jobtitleremark,jobgroupid,jobactivityid) values ('Default','Default',10,0,5,'',1,1)
/
insert into HrmResource(id,loginid,password,firstname,lastname,aliasname,systemlanguage,jobtitle,seclevel,titleid,countryid,resourcetype,startdate,enddate,departmentid,subcompanyid1,subcompanyid2,subcompanyid3,subcompanyid4,costcenterid,managerid) 
values (1,'weaveradmin','C4CA4238A0B923820DCC509A6F75849B','','weaveradmin','weaveradmin',7,1,30,1,1,2,'','',1,1,0,0,0,0,1)
/
insert into HrmResource(id,loginid,password,firstname,lastname,aliasname,systemlanguage,jobtitle,seclevel,titleid,countryid,resourcetype,departmentid,subcompanyid1,subcompanyid2,subcompanyid3,subcompanyid4,costcenterid,managerid,startdate,enddate) 
values (2,'sysadmin','C4CA4238A0B923820DCC509A6F75849B','','sysadmin','sysadmin',7,1,30,1,1,2,1,1,2,3,4,1,1,'','')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (1,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (2,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (3,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (4,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (5,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (6,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (7,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (8,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (9,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (10,2,'2')
/
insert into HrmRoleMembers (roleid,resourceid,rolelevel) values (11,2,'2')
/
insert into Meeting_Service2 (meetingid,hrmid,name,desc_n) values (0,0,'0','0')
/
insert into Meeting_Member2 (meetingid,membertype,memberid,membermanager,isattend,begindate,begintime,enddate,endtime,bookroom,roomstander,bookticket,ticketstander,othermember) values (0,0,0,0,'','','','','','','','','','')
/