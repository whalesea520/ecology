delete from HtmlLabelIndex where id=128512 
GO
delete from HtmlLabelInfo where indexid=128512 
GO
INSERT INTO HtmlLabelIndex values(128512,'������ѡĿ¼�������¼�Ŀ¼') 
GO
INSERT INTO HtmlLabelInfo VALUES(128512,'������ѡĿ¼�������¼�Ŀ¼',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128512,'Export the selected directory and all the lower directories',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128512,'�������xĿ䛼������¼�Ŀ�',9) 
GO


delete from HtmlLabelIndex where id=128514 
GO
delete from HtmlLabelInfo where indexid=128514 
GO
INSERT INTO HtmlLabelIndex values(128514,'��������ѡĿ¼') 
GO
INSERT INTO HtmlLabelInfo VALUES(128514,'��������ѡĿ¼',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128514,'Export the selected directory only',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128514,'�H�������xĿ�',9) 
GO


delete from HtmlLabelIndex where id=128515 
GO
delete from HtmlLabelInfo where indexid=128515 
GO
INSERT INTO HtmlLabelIndex values(128515,'������ǰĿ¼�������¼�Ŀ¼') 
GO
INSERT INTO HtmlLabelInfo VALUES(128515,'������ǰĿ¼�������¼�Ŀ¼',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128515,'Export the current directory and all the lower directories',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128515,'������ǰĿ䛼������¼�Ŀ�',9) 
GO


delete from HtmlLabelIndex where id=128516 
GO
delete from HtmlLabelInfo where indexid=128516 
GO
INSERT INTO HtmlLabelIndex values(128516,'��������ǰĿ¼') 
GO
INSERT INTO HtmlLabelInfo VALUES(128516,'��������ǰĿ¼',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128516,'Export only the current directory',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128516,'�H������ǰĿ�',9) 
GO


delete from HtmlLabelIndex where id=128517 
GO
delete from HtmlLabelInfo where indexid=128517 
GO
INSERT INTO HtmlLabelIndex values(128517,'��ѡ����Ҫ���������ݣ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128517,'��ѡ����Ҫ���������ݣ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128517,'Please select the content that needs to be exported:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128517,'Ո�x����Ҫ���������ݣ�',9) 
GO


delete from HtmlLabelIndex where id=128518 
GO
delete from HtmlLabelInfo where indexid=128518 
GO
INSERT INTO HtmlLabelIndex values(128518,'��ϵͳ����Ŀ¼���и���') 
GO
INSERT INTO HtmlLabelInfo VALUES(128518,'��ϵͳ����Ŀ¼���и���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128518,'Update the existing directory of the system',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128518,'��ϵ�y����Ŀ��M�и���',9) 
GO


delete from HtmlLabelIndex where id=128519 
GO
delete from HtmlLabelInfo where indexid=128519 
GO
INSERT INTO HtmlLabelIndex values(128519,'����ģ������д��Ŀ¼����ϵͳ���Ѵ��ڣ���ѡ���Ƿ����Ŀ¼���ݡ�������Ϊ���£������������������롣') 
GO
INSERT INTO HtmlLabelInfo VALUES(128519,'����ģ������д��Ŀ¼����ϵͳ���Ѵ��ڣ���ѡ���Ƿ����Ŀ¼���ݡ�������Ϊ���£������������������롣',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128519,'Import template to fill in the directory, such as the system already exists, you can choose whether to update the directory data. Enable means to update, do not enable skip is not imported.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128519,'����ģ��Y���Ŀ�����ϵ�y���Ѵ��ڣ����x���Ƿ����Ŀ䛔����������⠑���£������Ät���^�����롣',9) 
GO

delete from HtmlLabelIndex where id=128520 
GO
delete from HtmlLabelInfo where indexid=128520 
GO
INSERT INTO HtmlLabelIndex values(128520,'��дģ�����ݺ��ļ��ϴ���') 
GO
INSERT INTO HtmlLabelInfo VALUES(128520,'��дģ�����ݺ��ļ��ϴ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128520,'After completing the template data will be uploaded to the file.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128520,'�ģ雔����Ὣ�ļ��ς���',9) 
GO


delete from HtmlLabelIndex where id=128521 
GO
delete from HtmlLabelInfo where indexid=128521 
GO
INSERT INTO HtmlLabelIndex values(128521,'���ĵ�Ŀ¼���ֶ�Ϊ��������ֶβ���дʱ������ȡĬ��ֵ��') 
GO
INSERT INTO HtmlLabelInfo VALUES(128521,'���ĵ�Ŀ¼���ֶ�Ϊ��������ֶβ���дʱ������ȡĬ��ֵ��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128521,'[document directory] fields are required, other fields are not complete, the default value of import.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128521,'���ęnĿ䛡��ֶΠ���������ֶβ���r������ȡĬ�Jֵ��',9) 
GO


delete from HtmlLabelIndex where id=128522 
GO
delete from HtmlLabelInfo where indexid=128522 
GO
INSERT INTO HtmlLabelIndex values(128522,'���ĵ�Ŀ¼����Ŀ¼�㼶��д���м��á�/���ָ�����ʽΪ��1��Ŀ¼/2��Ŀ¼/3��Ŀ¼������') 
GO
INSERT INTO HtmlLabelInfo VALUES(128522,'���ĵ�Ŀ¼����Ŀ¼�㼶��д���м��á�/���ָ�����ʽΪ��1��Ŀ¼/2��Ŀ¼/3��Ŀ¼������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128522,'[document catalogue] according to the level of the directory to fill in the middle with "/" separation, the format for the 1 directory /2 directory /3...".',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128522,'���ęnĿ䛡���Ŀ䛌Ӽ�������g�á�/���ָ�����ʽ����1��Ŀ�/2��Ŀ�/3��Ŀ䛡�����',9) 
GO


delete from HtmlLabelIndex where id=128523 
GO
delete from HtmlLabelInfo where indexid=128523 
GO
INSERT INTO HtmlLabelIndex values(128523,'��Ĭ������Ŀ¼����Ŀ¼�㼶��д���м��á�/���ָ�����ʽΪ��root/1��Ŀ¼/2��Ŀ¼/3��Ŀ¼��������root��������Ŀ¼��Ecology������дΪ��root/Ecology�����ɡ�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128523,'��Ĭ������Ŀ¼����Ŀ¼�㼶��д���м��á�/���ָ�����ʽΪ��root/1��Ŀ¼/2��Ŀ¼/3��Ŀ¼��������root��������Ŀ¼��Ecology������дΪ��root/Ecology�����ɡ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128523,'[default virtual directory] according to the level of the directory to fill in the middle with "/" separated, format for "root/1 directory /2 directory /3..." , such as root under the virtual directory "Ecology" is filled in as "root/Ecology" can be.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128523,'��Ĭ�J̓��Ŀ䛡���Ŀ䛌Ӽ�������g�á�/���ָ�����ʽ����root/1��Ŀ�/2��Ŀ�/3��Ŀ䛡�������root����̓��Ŀ䛡�Ecology���t�����root/Ecology�����ɡ�',9) 
GO



delete from HtmlLabelIndex where id=128524 
GO
delete from HtmlLabelInfo where indexid=128524 
GO
INSERT INTO HtmlLabelIndex values(128524,'�����ֶΰ���ͷ��ѡ����ʾ������д��') 
GO
INSERT INTO HtmlLabelInfo VALUES(128524,'�����ֶΰ���ͷ��ѡ����ʾ������д��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128524,'Other fields are indicated by the options of the column header.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128524,'�����ֶΰ����^���x���ʾ�M�����',9) 
GO


delete from HtmlLabelIndex where id=128525 
GO
delete from HtmlLabelInfo where indexid=128525 
GO
INSERT INTO HtmlLabelIndex values(128525,'���½�������ָ�����̡�������ӡ�������̡������ֶβ��ڵ���ģ���У�������Ҫ�뵼����ɺ��ֶ���д��') 
GO
INSERT INTO HtmlLabelInfo VALUES(128525,'���½�������ָ�����̡�������ӡ�������̡������ֶβ��ڵ���ģ���У�������Ҫ�뵼����ɺ��ֶ���д��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128525,'[new workflow specified process], [printing application process] two fields are not imported into the template, if necessary, please fill in the completion of the completion of the manual.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128525,'���½�������ָ�����̡�������ӡ��Ո���̡��ɂ��ֶβ��ڌ���ģ��У�������ҪՈ����������ք����',9) 
GO


delete from HtmlLabelIndex where id=128526 
GO
delete from HtmlLabelInfo where indexid=128526 
GO
INSERT INTO HtmlLabelIndex values(128526,'����ϵͳ����Ŀ¼���и��¡�Ĭ�ϲ�������������ģ�����ϵͳ����Ŀ¼ʱ�������е��룬��������ÿ��أ�����ʱ��ϵͳ����Ŀ¼���и��¡�') 
GO
INSERT INTO HtmlLabelInfo VALUES(128526,'����ϵͳ����Ŀ¼���и��¡�Ĭ�ϲ�������������ģ�����ϵͳ����Ŀ¼ʱ�������е��룬��������ÿ��أ�����ʱ��ϵͳ����Ŀ¼���и��¡�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128526,'The system has an existing directory to update the default does not open, when the import template system has the existing directory will not be imported, if the switch is turned on, the system has been updated to update the system.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128526,'����ϵ�y����Ŀ��M�и��¡�Ĭ�J���_����������ģ雴���ϵ�y����Ŀ䛕r�����M�Ќ��룬����_��ԓ�_�P���t����r��ϵ�y����Ŀ��M�и��¡�',9) 
GO


delete from HtmlLabelIndex where id=128527 
GO
delete from HtmlLabelInfo where indexid=128527 
GO
INSERT INTO HtmlLabelIndex values(128527,'��ѡ����ȷ��ģ�嵼��') 
GO
INSERT INTO HtmlLabelInfo VALUES(128527,'��ѡ����ȷ��ģ�嵼��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128527,'Please select the correct template to import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128527,'Ո�x����ȷ��ģ雌���',9) 
GO


delete from HtmlLabelIndex where id=128528 
GO
delete from HtmlLabelInfo where indexid=128528 
GO
INSERT INTO HtmlLabelIndex values(128528,'��ʹ��ģ���ļ���') 
GO
INSERT INTO HtmlLabelInfo VALUES(128528,'��ʹ��ģ���ļ���',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128528,'Please use the template file!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128528,'Ոʹ��ģ��ļ���',9) 
GO


delete from HtmlLabelIndex where id=128529 
GO
delete from HtmlLabelInfo where indexid=128529 
GO
INSERT INTO HtmlLabelIndex values(128529,'����') 
GO
INSERT INTO HtmlLabelInfo VALUES(128529,'����',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128529,'The following',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128529,'����',9) 
GO


delete from HtmlLabelIndex where id=128530 
GO
delete from HtmlLabelInfo where indexid=128530 
GO
INSERT INTO HtmlLabelIndex values(128530,'�е���ʧ��:') 
GO
INSERT INTO HtmlLabelInfo VALUES(128530,'�е���ʧ��:',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128530,'line import failed:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128530,'�Ќ���ʧ��:',9) 
GO
