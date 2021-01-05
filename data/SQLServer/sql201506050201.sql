delete from HtmlLabelIndex where id=84607 
GO
delete from HtmlLabelInfo where indexid=84607 
GO
INSERT INTO HtmlLabelIndex values(84607,'矩阵名称已存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(84607,'矩阵名称已存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84607,'Matrix name already exists',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84607,'矩陣名稱已存在',9) 
GO

delete from HtmlLabelIndex where id=84454 
GO
delete from HtmlLabelInfo where indexid=84454 
GO
INSERT INTO HtmlLabelIndex values(84454,'部门字段需填写该部门的全路径，显示格式为“分部1>分部1.1>分部1.1.1||部门1>部门1.1>部门1.1.1”，分部与部门之间用“||”分隔，多部门之间用“;”分隔。') 
GO
INSERT INTO HtmlLabelInfo VALUES(84454,'部门字段需填写该部门的全路径，显示格式为“分部1>分部1.1>分部1.1.1||部门1>部门1.1>部门1.1.1”，分部与部门之间用“||”分隔，多部门之间用“;”分隔。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84454,'Field departments need to fill out the full path to the Department, display format for segment 1 Department of 1 segment 1.1> segment 1.1.1|| Department 1.1> Department 1.1.1 &quot;, between branch and branch with&quot; || separated and between departments &quot;;&quot; sepa',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84454,'部門字段需填寫該部門的全路徑，顯示格式爲“分部1>分部1.1>分部1.1.1||部門1>部門1.1>部門1.1.1”，分部與部門之間用“||”分隔，多部門之間用“;”分隔。',9) 
GO

delete from HtmlLabelIndex where id=84457 
GO
delete from HtmlLabelInfo where indexid=84457 
GO
INSERT INTO HtmlLabelIndex values(84457,'岗位需填写全路径的部门加岗位，格式为“分部1>分部1.1>分部1.1.1||部门1>部门1.1>部门1.1.1>岗位” 分部与部门之间用“||”分隔，多岗位之间用“;”分隔。') 
GO
INSERT INTO HtmlLabelInfo VALUES(84457,'岗位需填写全路径的部门加岗位，格式为“分部1>分部1.1>分部1.1.1||部门1>部门1.1>部门1.1.1>岗位” 分部与部门之间用“||”分隔，多岗位之间用“;”分隔。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84457,'Jobs need to fill in the full path of the departments and posts, format between branch and sector of the &quot;Division 1 Department of 1 segment 1.1> segment 1.1.1|| Department Department of 1.1> 1.1.1> post&quot; used &quot;|| separated, between more jobs with&quot;; &quot;sepa',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84457,'崗位需填寫全路徑的部門加崗位，格式爲“分部1>分部1.1>分部1.1.1||部門1>部門1.1>部門1.1.1>崗位” 分部與部門之間用“||”分隔，多崗位之間用“;”分隔。',9) 
GO
