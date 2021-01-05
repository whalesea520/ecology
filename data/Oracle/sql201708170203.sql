create sequence hp_nonstandard_function_seq increment by 1 start with 1 nomaxvalue nocycle cache 10
/
create table  hp_nonstandard_function_info(
	id int not null,
	num varchar(32) not null,
	name varchar(1000) not null,
	classpath varchar(1000) not null,
	status int 
)
/
create or replace trigger hp_nonstandard_trigger
before insert on hp_nonstandard_function_info for each row
begin
select hp_nonstandard_function_seq.nextval into :new.id 

 from dual;
end;
/
insert into hp_nonstandard_function_info(num,name,classpath) values('001','考勤功能','com.weaver.upgrade.domain.Upgrade001')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('002','短信通用接口','com.weaver.upgrade.domain.Upgrade002')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('005','集成登录接口','com.weaver.upgrade.domain.Upgrade005')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('006','流程中自定义浏览框','com.weaver.upgrade.domain.Upgrade006')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('008','文档全文检索','com.weaver.upgrade.domain.Upgrade008')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('009','目标绩效考核','com.weaver.upgrade.domain.Upgrade009')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('011','分权系统','com.weaver.upgrade.domain.Upgrade011')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('012','英文版','com.weaver.upgrade.domain.Upgrade012')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('013','指纹登录','com.weaver.upgrade.domain.Upgrade013')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('014','主从帐号','com.weaver.upgrade.domain.Upgrade014')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('015','计划任务管理','com.weaver.upgrade.domain.Upgrade015')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('017','外部XML报表接口','com.weaver.upgrade.domain.Upgrade017')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('019','取消右键按钮','com.weaver.upgrade.domain.Upgrade019')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('020','字段联动','com.weaver.upgrade.domain.Upgrade020')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('022','二维条码（需购买控件）','com.weaver.upgrade.domain.Upgrade022')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('023','公文使用WPS','com.weaver.upgrade.domain.Upgrade023')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('025','手机版','com.weaver.upgrade.domain.Upgrade025')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('026','外部数据触发流程','com.weaver.upgrade.domain.Upgrade026')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('027','繁体版','com.weaver.upgrade.domain.Upgrade027')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('032','公文交换','com.weaver.upgrade.domain.Upgrade032')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('033','待办事宜定时提醒','com.weaver.upgrade.domain.Upgrade033')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('037','E-Message3.8(Windows64位服务器)','com.weaver.upgrade.domain.Upgrade037')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('039','右键复制与粘贴','com.weaver.upgrade.domain.Upgrade039')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('042','微博','com.weaver.upgrade.domain.Upgrade042')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('045','流程暂停','com.weaver.upgrade.domain.Upgrade045')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('046','表单建模','com.weaver.upgrade.domain.Upgrade046')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('047','SAP接口','com.weaver.upgrade.domain.Upgrade047')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('048','微搜','com.weaver.upgrade.domain.Upgrade048')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('049','微信集成（服务号）','com.weaver.upgrade.domain.Upgrade049')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('050','证照管理','com.weaver.upgrade.domain.Upgrade050')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('051','执行力平台之目标管理','com.weaver.upgrade.domain.Upgrade051')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('052','执行力平台之计划报告','com.weaver.upgrade.domain.Upgrade052')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('053','执行力平台之任务管理','com.weaver.upgrade.domain.Upgrade053')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('054','执行力平台之绩效考核','com.weaver.upgrade.domain.Upgrade054')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('056','外部集成考勤','com.weaver.upgrade.domain.Upgrade056')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('057','WebService注册','com.weaver.upgrade.domain.Upgrade057')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('058','HR同步','com.weaver.upgrade.domain.Upgrade058')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('059','财务凭证','com.weaver.upgrade.domain.Upgrade059')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('060','客户模块','com.weaver.upgrade.domain.Upgrade060')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('061','资产模块','com.weaver.upgrade.domain.Upgrade061')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('062','项目模块','com.weaver.upgrade.domain.Upgrade062')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('063','车辆管理','com.weaver.upgrade.domain.Upgrade063')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('064','预算管理','com.weaver.upgrade.domain.Upgrade064')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('065','协同区','com.weaver.upgrade.domain.Upgrade065')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('066','移动引擎','com.weaver.upgrade.domain.Upgrade066')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('067','NC集成','com.weaver.upgrade.domain.Upgrade067')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('068','EAS集成','com.weaver.upgrade.domain.Upgrade068')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('069','U8集成','com.weaver.upgrade.domain.Upgrade069')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('070','K3集成','com.weaver.upgrade.domain.Upgrade070')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('071','运维中心','com.weaver.upgrade.domain.Upgrade071')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('072','相册','com.weaver.upgrade.domain.Upgrade072')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('073','公文管理','com.weaver.upgrade.domain.Upgrade073')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('074','流程交换','com.weaver.upgrade.domain.Upgrade074')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('076','档案集成','com.weaver.upgrade.domain.Upgrade076')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('081','统一待办中心集成','com.weaver.upgrade.domain.Upgrade081')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('089','移动门户','com.weaver.upgrade.domain.Upgrade089')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('090','CAS集成','com.weaver.upgrade.domain.Upgrade090')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('091','WebSEAL集成','com.weaver.upgrade.domain.Upgrade091')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('092','小e助手','com.weaver.upgrade.domain.Upgrade092')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('093','CoreMail集成','com.weaver.upgrade.domain.Upgrade093')
/