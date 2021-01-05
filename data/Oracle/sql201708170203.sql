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
insert into hp_nonstandard_function_info(num,name,classpath) values('001','���ڹ���','com.weaver.upgrade.domain.Upgrade001')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('002','����ͨ�ýӿ�','com.weaver.upgrade.domain.Upgrade002')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('005','���ɵ�¼�ӿ�','com.weaver.upgrade.domain.Upgrade005')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('006','�������Զ��������','com.weaver.upgrade.domain.Upgrade006')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('008','�ĵ�ȫ�ļ���','com.weaver.upgrade.domain.Upgrade008')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('009','Ŀ�꼨Ч����','com.weaver.upgrade.domain.Upgrade009')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('011','��Ȩϵͳ','com.weaver.upgrade.domain.Upgrade011')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('012','Ӣ�İ�','com.weaver.upgrade.domain.Upgrade012')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('013','ָ�Ƶ�¼','com.weaver.upgrade.domain.Upgrade013')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('014','�����ʺ�','com.weaver.upgrade.domain.Upgrade014')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('015','�ƻ��������','com.weaver.upgrade.domain.Upgrade015')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('017','�ⲿXML�����ӿ�','com.weaver.upgrade.domain.Upgrade017')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('019','ȡ���Ҽ���ť','com.weaver.upgrade.domain.Upgrade019')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('020','�ֶ�����','com.weaver.upgrade.domain.Upgrade020')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('022','��ά���루�蹺��ؼ���','com.weaver.upgrade.domain.Upgrade022')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('023','����ʹ��WPS','com.weaver.upgrade.domain.Upgrade023')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('025','�ֻ���','com.weaver.upgrade.domain.Upgrade025')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('026','�ⲿ���ݴ�������','com.weaver.upgrade.domain.Upgrade026')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('027','�����','com.weaver.upgrade.domain.Upgrade027')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('032','���Ľ���','com.weaver.upgrade.domain.Upgrade032')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('033','�������˶�ʱ����','com.weaver.upgrade.domain.Upgrade033')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('037','E-Message3.8(Windows64λ������)','com.weaver.upgrade.domain.Upgrade037')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('039','�Ҽ�������ճ��','com.weaver.upgrade.domain.Upgrade039')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('042','΢��','com.weaver.upgrade.domain.Upgrade042')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('045','������ͣ','com.weaver.upgrade.domain.Upgrade045')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('046','������ģ','com.weaver.upgrade.domain.Upgrade046')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('047','SAP�ӿ�','com.weaver.upgrade.domain.Upgrade047')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('048','΢��','com.weaver.upgrade.domain.Upgrade048')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('049','΢�ż��ɣ�����ţ�','com.weaver.upgrade.domain.Upgrade049')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('050','֤�չ���','com.weaver.upgrade.domain.Upgrade050')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('051','ִ����ƽ̨֮Ŀ�����','com.weaver.upgrade.domain.Upgrade051')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('052','ִ����ƽ̨֮�ƻ�����','com.weaver.upgrade.domain.Upgrade052')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('053','ִ����ƽ̨֮�������','com.weaver.upgrade.domain.Upgrade053')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('054','ִ����ƽ̨֮��Ч����','com.weaver.upgrade.domain.Upgrade054')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('056','�ⲿ���ɿ���','com.weaver.upgrade.domain.Upgrade056')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('057','WebServiceע��','com.weaver.upgrade.domain.Upgrade057')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('058','HRͬ��','com.weaver.upgrade.domain.Upgrade058')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('059','����ƾ֤','com.weaver.upgrade.domain.Upgrade059')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('060','�ͻ�ģ��','com.weaver.upgrade.domain.Upgrade060')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('061','�ʲ�ģ��','com.weaver.upgrade.domain.Upgrade061')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('062','��Ŀģ��','com.weaver.upgrade.domain.Upgrade062')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('063','��������','com.weaver.upgrade.domain.Upgrade063')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('064','Ԥ�����','com.weaver.upgrade.domain.Upgrade064')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('065','Эͬ��','com.weaver.upgrade.domain.Upgrade065')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('066','�ƶ�����','com.weaver.upgrade.domain.Upgrade066')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('067','NC����','com.weaver.upgrade.domain.Upgrade067')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('068','EAS����','com.weaver.upgrade.domain.Upgrade068')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('069','U8����','com.weaver.upgrade.domain.Upgrade069')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('070','K3����','com.weaver.upgrade.domain.Upgrade070')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('071','��ά����','com.weaver.upgrade.domain.Upgrade071')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('072','���','com.weaver.upgrade.domain.Upgrade072')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('073','���Ĺ���','com.weaver.upgrade.domain.Upgrade073')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('074','���̽���','com.weaver.upgrade.domain.Upgrade074')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('076','��������','com.weaver.upgrade.domain.Upgrade076')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('081','ͳһ�������ļ���','com.weaver.upgrade.domain.Upgrade081')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('089','�ƶ��Ż�','com.weaver.upgrade.domain.Upgrade089')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('090','CAS����','com.weaver.upgrade.domain.Upgrade090')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('091','WebSEAL����','com.weaver.upgrade.domain.Upgrade091')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('092','Сe����','com.weaver.upgrade.domain.Upgrade092')
/
insert into hp_nonstandard_function_info(num,name,classpath) values('093','CoreMail����','com.weaver.upgrade.domain.Upgrade093')
/