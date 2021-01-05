delete from HtmlLabelIndex where id=126884 
GO
delete from HtmlLabelInfo where indexid=126884 
GO
INSERT INTO HtmlLabelIndex values(126884,'为') 
GO
INSERT INTO HtmlLabelInfo VALUES(126884,'为',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126884,'is',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126884,'為',9) 
GO
delete from HtmlLabelIndex where id=126892 
GO
delete from HtmlLabelInfo where indexid=126892 
GO
INSERT INTO HtmlLabelIndex values(126892,'总部：取系统中所有与字段中人员的岗位相同的人员。例：字段中选择人员A、B，则节点操作者为所有和A岗位相同的人员及和B的岗位相同的人员。') 
GO
delete from HtmlLabelIndex where id=126894 
GO
delete from HtmlLabelInfo where indexid=126894 
GO
INSERT INTO HtmlLabelIndex values(126894,'本部门：取与字段中人员同部门、同岗位的人员。例：字段中选择人员A、B，则节点操作者为与人员A同部门、同岗位的人员以及与人员B同部门、同岗位的人员。') 
GO
delete from HtmlLabelIndex where id=126895 
GO
delete from HtmlLabelInfo where indexid=126895 
GO
INSERT INTO HtmlLabelIndex values(126895,'本部门及下级部门：取与字段中人员同部门及下级部门人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同部门及下级部门人员中，与人员A同岗位的人，加上与人员B同部门及下级部门人员中，与人员B同岗位的人员。') 
GO
delete from HtmlLabelIndex where id=126896 
GO
delete from HtmlLabelInfo where indexid=126896 
GO
INSERT INTO HtmlLabelIndex values(126896,'本部门及上级部门：取与字段中人员同部门及上级部门人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同部门及上级部门人员中，与人员A同岗位的人，加上与人员B同部门及上级部门人员中，与人员B同岗位的人员。') 
GO
delete from HtmlLabelIndex where id=126897 
GO
delete from HtmlLabelInfo where indexid=126897 
GO
INSERT INTO HtmlLabelIndex values(126897,'本分部：取与字段中人员同分部、同岗位的人员。例：字段中选择人员A、B，则节点操作者为与人员A同分部、同岗位的人员以及与人员B同分部、同岗位的人员。') 
GO
delete from HtmlLabelIndex where id=126899 
GO
delete from HtmlLabelInfo where indexid=126899 
GO
INSERT INTO HtmlLabelIndex values(126899,'本分部及下级分部：取与字段中人员同分部及下级分部人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同分部及下级分部人员中，与人员A同岗位的人，加上与人员B同分部及下级分部人员中，与人员B同岗位的人员。') 
GO
delete from HtmlLabelIndex where id=126901 
GO
delete from HtmlLabelInfo where indexid=126901 
GO
INSERT INTO HtmlLabelIndex values(126901,'本分部及上级分部：取与字段中人员同分部及上级分部人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同分部及上级分部人员中，与人员A同岗位的人，加上与人员B同分部及上级分部人员中，与人员B同岗位的人员。') 
GO
delete from HtmlLabelIndex where id=126902 
GO
delete from HtmlLabelInfo where indexid=126902 
GO
INSERT INTO HtmlLabelIndex values(126902,'指定部门：取指定部门中岗位是所选岗位的人。') 
GO
delete from HtmlLabelIndex where id=126904 
GO
delete from HtmlLabelInfo where indexid=126904 
GO
INSERT INTO HtmlLabelIndex values(126904,'指定分部：取指定分部中岗位是所选岗位的人。') 
GO
delete from HtmlLabelIndex where id=126905 
GO
delete from HtmlLabelInfo where indexid=126905 
GO
INSERT INTO HtmlLabelIndex values(126905,'总部：取字段中所选岗位的所有人。') 
GO
delete from HtmlLabelIndex where id=126906 
GO
delete from HtmlLabelInfo where indexid=126906 
GO
INSERT INTO HtmlLabelIndex values(126906,'表单字段：取所选岗位下，部门分部是表单字段部门或分部的人。例：表单字段选择分部1、分部2，岗位字段选择岗位A、岗位B，则节点操作者为：分部1、分部2中岗位A的人，和分部1分部2岗位B的人。（注：明细字段按行找人。）') 
GO
INSERT INTO HtmlLabelInfo VALUES(126906,'表单字段：取所选岗位下，部门分部是表单字段部门或分部的人。例：表单字段选择分部1、分部2，岗位字段选择岗位A、岗位B，则节点操作者为：分部1、分部2中岗位A的人，和分部1分部2岗位B的人。（注：明细字段按行找人。）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126906,'Form field: take the selected positions under section is the form field department or division of the people. Example: 1, select the form field division division 2, post field selection post A, post B, the node operator: Division 1, Division 2 post A, and division 1 Division 2 people post B. (Note: according to the detail field for people.)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126906,'表單欄位：取所選崗位下，部門分部是表單欄位部門或分部的人。例：表單欄位選擇分部1、分部2，崗位欄位選擇崗位A、崗位B，則節點操作者為：分部1、分部2中崗位A的人，和分部1分部2崗位B的人。（注：明細欄位按行找人。）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126905,'总部：取字段中所选岗位的所有人。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126905,'Headquarters: all take field in selected positions.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126905,'總部：取欄位中所選崗位的所有人。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126904,'指定分部：取指定分部中岗位是所选岗位的人。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126904,'The specified segment: the segment in the specified position is selected jobs.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126904,'指定分部：取指定分部中崗位是所選崗位的人。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126902,'指定部门：取指定部门中岗位是所选岗位的人。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126902,'The designated department: Post designated department in selected positions people.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126902,'指定部門：取指定部門中崗位是所選崗位的人。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126901,'本分部及上级分部：取与字段中人员同分部及上级分部人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同分部及上级分部人员中，与人员A同岗位的人，加上与人员B同分部及上级分部人员中，与人员B同岗位的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126901,'The division and superior segment: take and field personnel with superior segment and office staff, and field personnel with jobs. Example: the selection of personnel A, B field, the node for the operator and staff with A segment and superior segment of staff, and staff positions with A, coupled with the same segment and superior segment of B personnel personnel, personnel and staff positions with B.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126901,'本分部及上級分部：取與欄位中人員同分部及上級分部人員中，與欄位中人員同崗位的人。例：欄位中選擇人員A、B，則節點操作者為與人員A同分部及上級分部人員中，與人員A同崗位的人，加上與人員B同分部及上級分部人員中，與人員B同崗位的人員。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126899,'本分部及下级分部：取与字段中人员同分部及下级分部人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同分部及下级分部人员中，与人员A同岗位的人，加上与人员B同分部及下级分部人员中，与人员B同岗位的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126899,'The division and the lower division: take and field personnel with branches and subordinate office staff, and field personnel with jobs. Example: the selection of personnel A, B field, the node for the operator and staff with A segment and lower segment of staff, and staff positions with A, coupled with the B segment and the lower segment with the staff, staff and staff positions with B.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126899,'本分部及下級分部：取與欄位中人員同分部及下級分部人員中，與欄位中人員同崗位的人。例：欄位中選擇人員A、B，則節點操作者為與人員A同分部及下級分部人員中，與人員A同崗位的人，加上與人員B同分部及下級分部人員中，與人員B同崗位的人員。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126897,'本分部：取与字段中人员同分部、同岗位的人员。例：字段中选择人员A、B，则节点操作者为与人员A同分部、同岗位的人员以及与人员B同分部、同岗位的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126897,'This division: take and field personnel with the division, with staff positions. Example: the selection of personnel A, B field, the node for the operator and A with the same position, the division of personnel and personnel and the B division, with staff positions.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126897,'本分部：取與欄位中人員同分部、同崗位的人員。例：欄位中選擇人員A、B，則節點操作者為與人員A同分部、同崗位的人員以及與人員B同分部、同崗位的人員。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126896,'本部门及上级部门：取与字段中人员同部门及上级部门人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同部门及上级部门人员中，与人员A同岗位的人，加上与人员B同部门及上级部门人员中，与人员B同岗位的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126896,'The Department and superior departments and personnel in the field: take the same department and superior departments and personnel, field personnel with jobs. Example: the selection of personnel A, B field, the node operator for A and personnel department and superior departments and personnel, personnel A the same positions, coupled with the B department and superior departments of personnel, personnel and staff positions with B.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126896,'本部門及上級部門：取與欄位中人員同部門及上級部門人員中，與欄位中人員同崗位的人。例：欄位中選擇人員A、B，則節點操作者為與人員A同部門及上級部門人員中，與人員A同崗位的人，加上與人員B同部門及上級部門人員中，與人員B同崗位的人員。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126895,'本部门及下级部门：取与字段中人员同部门及下级部门人员中，与字段中人员同岗位的人。例：字段中选择人员A、B，则节点操作者为与人员A同部门及下级部门人员中，与人员A同岗位的人，加上与人员B同部门及下级部门人员中，与人员B同岗位的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126895,'The Department and subordinate departments: take and field personnel with departments and subordinate department personnel, and field personnel with jobs. Example: the selection of personnel A, B field, the node for the operator and staff with A departments and subordinate department personnel, and personnel A the same positions, coupled with the staff of B with departments and subordinate department personnel, personnel and staff positions with B.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126895,'本部門及下級部門：取與欄位中人員同部門及下級部門人員中，與欄位中人員同崗位的人。例：欄位中選擇人員A、B，則節點操作者為與人員A同部門及下級部門人員中，與人員A同崗位的人，加上與人員B同部門及下級部門人員中，與人員B同崗位的人員。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126894,'本部门：取与字段中人员同部门、同岗位的人员。例：字段中选择人员A、B，则节点操作者为与人员A同部门、同岗位的人员以及与人员B同部门、同岗位的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126894,'The Department: take and field personnel with the Department, with staff positions. Example: the selection of personnel A, B field, the node operator for personnel and personnel departments, with the same A staff positions and personnel departments, the same position with B.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126894,'本部門：取與欄位中人員同部門、同崗位的人員。例：欄位中選擇人員A、B，則節點操作者為與人員A同部門、同崗位的人員以及與人員B同部門、同崗位的人員。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126892,'总部：取系统中所有与字段中人员的岗位相同的人员。例：字段中选择人员A、B，则节点操作者为所有和A岗位相同的人员及和B的岗位相同的人员。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126892,'Headquarters: take the system in all fields with the same personnel staff positions. Example: the selection of personnel A, B field, the node operator for all staff positions and the same as A and B positions of the same personnel.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126892,'總部：取系統中所有與欄位中人員的崗位相同的人員。例：欄位中選擇人員A、B，則節點操作者為所有和A崗位相同的人員及和B的崗位相同的人員。',9) 
go
delete from HtmlNoteIndex where id=4090 
GO
delete from HtmlNoteInfo where indexid=4090 
GO
INSERT INTO HtmlNoteIndex values(4090,'共享级别') 
GO
delete from HtmlNoteIndex where id=4091 
GO
delete from HtmlNoteInfo where indexid=4091 
GO
INSERT INTO HtmlNoteIndex values(4091,'的所有人') 
GO
delete from HtmlNoteIndex where id=4092 
GO
delete from HtmlNoteInfo where indexid=4092 
GO
INSERT INTO HtmlNoteIndex values(4092,'的角色成员') 
GO
delete from HtmlNoteIndex where id=4093 
GO
delete from HtmlNoteInfo where indexid=4093 
GO
INSERT INTO HtmlNoteIndex values(4093,'的部门成员') 
GO
delete from HtmlNoteIndex where id=4094 
GO
delete from HtmlNoteInfo where indexid=4094 
GO
INSERT INTO HtmlNoteIndex values(4094,'的分部成员') 
GO
delete from HtmlNoteIndex where id=4095 
GO
delete from HtmlNoteInfo where indexid=4095 
GO
INSERT INTO HtmlNoteIndex values(4095,'安全级别为') 
GO
INSERT INTO HtmlNoteInfo VALUES(4095,'安全级别为',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4095,'The security level is',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4095,'安全級別為',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4094,'的分部成员',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4094,'The member',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4094,'的分部成員',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4093,'的部门成员',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4093,'The members of the Department',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4093,'的部門成員',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4092,'的角色成员',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4092,'The members of the role',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4092,'的角色成員',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4091,'的所有人',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4091,'Of all the people',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4091,'的所有人',9) 
GO
INSERT INTO HtmlNoteInfo VALUES(4090,'共享级别',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4090,'Sharing level',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4090,'共亯級別',9) 
GO