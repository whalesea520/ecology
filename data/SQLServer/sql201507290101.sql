delete from HtmlNoteIndex where id=3657 
GO
delete from HtmlNoteInfo where indexid=3657 
GO
INSERT INTO HtmlNoteIndex values(3657,'���ݱ���ɹ�') 
GO
INSERT INTO HtmlNoteInfo VALUES(3657,'���ݱ���ɹ�',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3657,'Save Data Success',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3657,'��������ɹ�',9) 
GO

delete from HtmlNoteIndex where id=3658 
GO
delete from HtmlNoteInfo where indexid=3658 
GO
INSERT INTO HtmlNoteIndex values(3658,'���ݱ���ʧ��') 
GO
INSERT INTO HtmlNoteInfo VALUES(3658,'���ݱ���ʧ��',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3658,'Data Save failed',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3658,'��������ʧ��',9) 
GO

delete from HtmlLabelIndex where id=124999 
GO
delete from HtmlLabelInfo where indexid=124999 
GO
INSERT INTO HtmlLabelIndex values(124999,'�����ݱ������뵼���ļ�Excelģ��ĵ�һ��sheet��') 
GO
INSERT INTO HtmlLabelInfo VALUES(124999,'�����ݱ������뵼���ļ�Excelģ��ĵ�һ��sheet��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(124999,'The first sheet card data must fill the import file template in Excel',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(124999,'�򿨔���������댧���ļ�Excelģ雵ĵ�һ��sheet��',9) 
GO

delete from HtmlLabelIndex where id=125000 
GO
delete from HtmlLabelInfo where indexid=125000 
GO
INSERT INTO HtmlLabelIndex values(125000,'ģ���еĵ�һ��Ϊ�����У�����ռ�á����ݱ���ӵڶ��п�ʼ���м䲻���п���') 
GO
INSERT INTO HtmlLabelInfo VALUES(125000,'ģ���еĵ�һ��Ϊ�����У�����ռ�á����ݱ���ӵڶ��п�ʼ���м䲻���п���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125000,'The first act of the template can not be occupied. The data must be started from the second row, with no blank line',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125000,'ģ��еĵ�һ�Р����}�У�����ռ�á�������횏ĵڶ����_ʼ�����g�����п���',9) 
GO

delete from HtmlLabelIndex where id=125001 
GO
delete from HtmlLabelInfo where indexid=125001 
GO
INSERT INTO HtmlLabelIndex values(125001,'�������ݵ�Excel��ÿһ�����ݸ�ĸ�ʽ����Ϊ�ַ���') 
GO
INSERT INTO HtmlLabelInfo VALUES(125001,'�������ݵ�Excel��ÿһ�����ݸ�ĸ�ʽ����Ϊ�ַ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125001,'The format of each data grid in the import data Excel must be a character type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125001,'���딵����Excel��ÿһ��������ĸ�ʽ��횠��ַ���',9) 
GO

delete from HtmlLabelIndex where id=125002 
GO
delete from HtmlLabelInfo where indexid=125002 
GO
INSERT INTO HtmlLabelIndex values(125002,'ͬһ���ݿɵ����Σ�ϵͳ���Զ��ų���ͬ������') 
GO
INSERT INTO HtmlLabelInfo VALUES(125002,'ͬһ���ݿɵ����Σ�ϵͳ���Զ��ų���ͬ������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125002,'The same data can be imported many times, the system will automatically rule out the same data',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125002,'ͬһ�����Ɍ����Σ�ϵ�y���Ԅ��ų���ͬ�Ĕ���',9) 
GO

delete from HtmlLabelIndex where id=125003 
GO
delete from HtmlLabelInfo where indexid=125003 
GO
INSERT INTO HtmlLabelIndex values(125003,'��ӦOAϵͳ�е���Ա��ţ����ݱ��ȡ��Ӧ����Աid�������Ա�ؼ��ֶ�Ӧ�ֶ�ѡ���˱�ţ����ֶα��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125003,'��ӦOAϵͳ�е���Ա��ţ����ݱ��ȡ��Ӧ����Աid�������Ա�ؼ��ֶ�Ӧ�ֶ�ѡ���˱�ţ����ֶα��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125003,'Personnel number corresponding to the OA system, according to numbers from corresponding personnel ID (if number is chosen by the keywords corresponding to the field, the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125003,'����OAϵ�y�е��ˆT���ţ���������ȡ�������ˆTid������ˆT�P�I�֌����ֶ��x���˾��ţ�ԓ�ֶα��',9) 
GO

delete from HtmlLabelIndex where id=125004 
GO
delete from HtmlLabelInfo where indexid=125004 
GO
INSERT INTO HtmlLabelIndex values(125004,'��ӦOAϵͳ�е���������������ȡ��Ӧ����Աid�������Ա�ؼ��ֶ�Ӧ�ֶ�ѡ�������������ֶα��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125004,'��ӦOAϵͳ�е���������������ȡ��Ӧ����Աid�������Ա�ؼ��ֶ�Ӧ�ֶ�ѡ�������������ֶα��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125004,'In OA system of corresponding name, according to the name take corresponding personnel ID (if name is chosen by the keywords corresponding to the field, the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125004,'����OAϵ�y�е���������������ȡ�������ˆTid������ˆT�P�I�֌����ֶ��x����������ԓ�ֶα��',9) 
GO

delete from HtmlLabelIndex where id=125005 
GO
delete from HtmlLabelInfo where indexid=125005 
GO
INSERT INTO HtmlLabelIndex values(125005,'��ӦOAϵͳ���ڱ��еĿ������1����ʾǩ����2����ʾǩ�ˣ����ֶα��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125005,'��ӦOAϵͳ���ڱ��еĿ������1����ʾǩ����2����ʾǩ�ˣ����ֶα��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125005,'Attendance category, attendance table corresponding to the OA system 1: 2: sign, sign and return (the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125005,'����OAϵ�y���ڱ��еĿ����1����ʾ������2����ʾ���ˣ�ԓ�ֶα��',9) 
GO

delete from HtmlLabelIndex where id=125006 
GO
delete from HtmlLabelInfo where indexid=125006 
GO
INSERT INTO HtmlLabelIndex values(125006,'��ӦOAϵͳ���ڱ��еĿ������ڣ����ڸ�ʽ��2014-01-01�����ֶα��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125006,'��ӦOAϵͳ���ڱ��еĿ������ڣ����ڸ�ʽ��2014-01-01�����ֶα��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125006,'The attendance date, attendance table corresponding to the OA date format: 2014-01-01 (the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125006,'����OAϵ�y���ڱ��еĿ������ڣ����ڸ�ʽ��2014-01-01��ԓ�ֶα��',9) 
GO

delete from HtmlLabelIndex where id=125007 
GO
delete from HtmlLabelInfo where indexid=125007 
GO
INSERT INTO HtmlLabelIndex values(125007,'��ӦOAϵͳ���ڱ��еĿ���ʱ�䣬ʱ���ʽ��09:31��14:04�����ֶα��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125007,'��ӦOAϵͳ���ڱ��еĿ���ʱ�䣬ʱ���ʽ��09:31��14:04�����ֶα��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125007,'Time attendance, attendance system corresponding to the OA table in time format: 09:31, 14:04 (the field required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125007,'����OAϵ�y���ڱ��еĿ��ڕr�g���r�g��ʽ��09:31��14:04��ԓ�ֶα��',9) 
GO

delete from HtmlLabelIndex where id=125008 
GO
delete from HtmlLabelInfo where indexid=125008 
GO
INSERT INTO HtmlLabelIndex values(125008,'��ӦOAϵͳ���ڱ��е�IP��ַ�����ڱ�ʶ�û������ĸ��򿨻��ϴ�Ŀ������ֶηǱ����ģ��������ɾ����') 
GO
INSERT INTO HtmlLabelInfo VALUES(125008,'��ӦOAϵͳ���ڱ��е�IP��ַ�����ڱ�ʶ�û������ĸ��򿨻��ϴ�Ŀ������ֶηǱ����ģ��������ɾ����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125008,'Corresponding OA system in the attendance table IP address for user identification is playing cards in which the punch card machines (the field is not required, but the template, please do not delete)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125008,'����OAϵ�y���ڱ��е�IP��ַ�����ڱ��R�Ñ������Ă��򿨙C�ϴ�Ŀ���ԓ�ֶηǱ����ģ���Ո��ɾ����',9) 
GO

delete from HtmlLabelIndex where id=125010 
GO
delete from HtmlLabelInfo where indexid=125010 
GO
INSERT INTO HtmlLabelIndex values(125010,'��֯��������ͳ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125010,'��֯��������ͳ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125010,'Organization adjustment operation statistics',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125010,'�M���{�������yӋ',9) 
GO

delete from HtmlLabelIndex where id=125011 
GO
delete from HtmlLabelInfo where indexid=125011 
GO
INSERT INTO HtmlLabelIndex values(125011,'Ȩ�޵�������ͳ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125011,'Ȩ�޵�������ͳ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125011,'Authority adjustment operation statistics',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125011,'�����{�������yӋ',9) 
GO

delete from HtmlLabelIndex where id=32687 
GO
delete from HtmlLabelInfo where indexid=32687 
GO
INSERT INTO HtmlLabelIndex values(32687,'Ĭ������') 
GO
INSERT INTO HtmlLabelInfo VALUES(32687,'Ĭ������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32687,'The default settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32687,'Ĭ�J�O��',9) 
GO

delete from HtmlLabelIndex where id=125012 
GO
delete from HtmlLabelInfo where indexid=125012 
GO
INSERT INTO HtmlLabelIndex values(125012,'�鿴��Χ����') 
GO
INSERT INTO HtmlLabelInfo VALUES(125012,'�鿴��Χ����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125012,'View range settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125012,'�鿴�����O��',9) 
GO

delete from HtmlLabelIndex where id=125013 
GO
delete from HtmlLabelInfo where indexid=125013 
GO
INSERT INTO HtmlLabelIndex values(125013,'�鿴��������') 
GO
INSERT INTO HtmlLabelInfo VALUES(125013,'�鿴��������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125013,'View object settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125013,'�鿴�����O��',9) 
GO

delete from HtmlLabelIndex where id=125014 
GO
delete from HtmlLabelInfo where indexid=125014 
GO
INSERT INTO HtmlLabelIndex values(125014,'������ѡ��һ������!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125014,'������ѡ��һ������!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125014,'Please select at least one of the data!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125014,'Ո�����x��һ�l����!',9) 
GO

delete from HtmlLabelIndex where id=125015 
GO
delete from HtmlLabelInfo where indexid=125015 
GO
INSERT INTO HtmlLabelIndex values(125015,'����ɾ���ɹ�!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125015,'����ɾ���ɹ�!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125015,'Data deletion success!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125015,'����ɾ���ɹ�!',9) 
GO
 
delete from HtmlLabelIndex where id=125016 
GO
delete from HtmlLabelInfo where indexid=125016 
GO
INSERT INTO HtmlLabelIndex values(125016,'����ɾ��ʧ��!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125016,'����ɾ��ʧ��!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125016,'Data deletion failed!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125016,'����ɾ��ʧ��!',9) 
GO

delete from HtmlLabelIndex where id=125017 
GO
delete from HtmlLabelInfo where indexid=125017 
GO
INSERT INTO HtmlLabelIndex values(125017,'�������쳣!') 
GO
INSERT INTO HtmlLabelInfo VALUES(125017,'�������쳣!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125017,'Server exception!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125017,'����������!',9) 
GO

delete from HtmlNoteIndex where id=4010 
GO
delete from HtmlNoteInfo where indexid=4010 
GO
INSERT INTO HtmlNoteIndex values(4010,'���ݱ���ɹ�!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4010,'���ݱ���ɹ�!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4010,'Data preservation success!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4010,'��������ɹ�!',9) 
GO

delete from HtmlNoteIndex where id=4011 
GO
delete from HtmlNoteInfo where indexid=4011 
GO
INSERT INTO HtmlNoteIndex values(4011,'���ݱ���ʧ��!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4011,'���ݱ���ʧ��!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4011,'Data save failed!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4011,'��������ʧ��!',9) 
GO

delete from HtmlNoteIndex where id=4012 
GO
delete from HtmlNoteInfo where indexid=4012 
GO
INSERT INTO HtmlNoteIndex values(4012,'��ʾ������Ϊ��!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4012,'��ʾ������Ϊ��!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4012,'Display name can not be empty!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4012,'�@ʾ�����ܠ���!',9) 
GO

delete from HtmlNoteIndex where id=4013 
GO
delete from HtmlNoteInfo where indexid=4013 
GO
INSERT INTO HtmlNoteIndex values(4013,'�ֶ���ֻ�ܰ�����ĸ�����֣����ܺ�����!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4013,'�ֶ���ֻ�ܰ�����ĸ�����֣����ܺ�����!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4013,'Field names can only contain letters and numbers, not chinese!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4013,'�ֶ����b�ܰ�����ĸ�͔��֣����ܺ�����!',9) 
GO

delete from HtmlNoteIndex where id=4014 
GO
delete from HtmlNoteInfo where indexid=4014 
GO
INSERT INTO HtmlNoteIndex values(4014,'�ֶ�����������!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4014,'�ֶ�����������!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4014,'Field names must be unique!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4014,'�ֶ�����������!',9) 
GO

delete from HtmlNoteIndex where id=4015 
GO
delete from HtmlNoteInfo where indexid=4015 
GO
INSERT INTO HtmlNoteIndex values(4015,'�Զ����������Ϊ��!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4015,'�Զ����������Ϊ��!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4015,'Custom browse box can not be empty!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4015,'�Զ��x��[���ܠ���!',9) 
GO

delete from HtmlNoteIndex where id=4016 
GO
delete from HtmlNoteInfo where indexid=4016 
GO
INSERT INTO HtmlNoteIndex values(4016,'�ֶ�������Ϊ��!') 
GO
INSERT INTO HtmlNoteInfo VALUES(4016,'�ֶ�������Ϊ��!',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(4016,'Field name cannot be empty!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(4016,'�ֶ������ܠ���!',9) 
GO

delete from HtmlLabelIndex where id=125018 
GO
delete from HtmlLabelInfo where indexid=125018 
GO
INSERT INTO HtmlLabelIndex values(125018,'�����ַ�ĸ�ʽ����ȷ��Ϊ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(125018,'�����ַ�ĸ�ʽ����ȷ��Ϊ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125018,'The format of the mailbox address is not correct or empty',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125018,'�]���ַ�ĸ�ʽ����ȷ�򠑿�',9) 
GO