delete from HtmlLabelIndex where id=126506 
GO
delete from HtmlLabelInfo where indexid=126506 
GO
INSERT INTO HtmlLabelIndex values(126506,'sqlwhere�����Զ��嵥ѡ���Զ����ѡ������ֶΣ� �˹���������ʵ�ֿ�Ƭ�ϵ��Զ���������ֶθ��ݿ�Ƭ�ϵ������ֶ�ֵ���й������ݡ�') 
GO
delete from HtmlLabelIndex where id=126508 
GO
delete from HtmlLabelInfo where indexid=126508 
GO
INSERT INTO HtmlLabelIndex values(126508,'��ʽΪ��sqlwhere=objzdy=$obj1$ and $obj2$(����objzdyΪ�Զ��������������е��У�obj1,obj2Ϊ��Ƭ�ϵ��ֶ�)��') 
GO
delete from HtmlLabelIndex where id=126509 
GO
delete from HtmlLabelInfo where indexid=126509 
GO
INSERT INTO HtmlLabelIndex values(126509,'sqlcondition�����Զ��嵥ѡ���Զ����ѡ������ֶΣ��˹���������ʵ�ֿ�Ƭ��ĳЩ�ֶε�ֵ��Ϊ�Զ��������Ĳ�ѯ����Ĭ����������Ӧ�����ݡ�') 
GO
delete from HtmlLabelIndex where id=126510 
GO
delete from HtmlLabelInfo where indexid=126510 
GO
INSERT INTO HtmlLabelIndex values(126510,'treerootnode�����Զ������ε�ѡ���Զ������ζ�ѡ���˹���������ʵ�ֿ�Ƭ�ϵ��Զ������ε�ѡ�Ͷ�ѡ�ֶ�ȡ��Ƭ�ϵ������ֶ�ֵ��Ϊ���θ��ڵ�����ֵ') 
GO
delete from HtmlLabelIndex where id=126511 
GO
delete from HtmlLabelInfo where indexid=126511 
GO
INSERT INTO HtmlLabelIndex values(126511,'�Ӷ��ﵽ��̬�������θ��ڵ㡣��ʽΪ��treerootnode=objzdy=$obj1$,$obj2$(����objzdyΪ�Զ��������������е��У�obj1,obj2Ϊ��Ƭ�ϵ������ֶ�)��') 
GO
delete from HtmlLabelIndex where id=126512 
GO
delete from HtmlLabelInfo where indexid=126512 
GO
INSERT INTO HtmlLabelIndex values(126512,'��ʽΪ��sqlcondition=objzdy=$obj1$,$obj2$(����objzdyΪ�Զ��������������е��У�obj1,obj2Ϊ�˿�Ƭ�ϵ��ֶ�)��') 
GO
INSERT INTO HtmlLabelInfo VALUES(126512,'��ʽΪ��sqlcondition=objzdy=$obj1$,$obj2$(����objzdyΪ�Զ��������������е��У�obj1,obj2Ϊ�˿�Ƭ�ϵ��ֶ�)��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126512,'Format: sqlcondition = objzdy = $obj1 $, $obj2 $(including objzdy for custom navigation box association columns in a table, obj1, obj2 card for this field).',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126512,'��ʽ����sqlcondition=objzdy=$obj1$,$obj2$(����objzdy���Զ��x��[���P���е��У�obj1,obj2���˿�Ƭ�ϵ��ֶ�)��',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126511,'�Ӷ��ﵽ��̬�������θ��ڵ㡣��ʽΪ��treerootnode=objzdy=$obj1$,$obj2$(����objzdyΪ�Զ��������������е��У�obj1,obj2Ϊ��Ƭ�ϵ������ֶ�)��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126511,'So as to achieve the dynamic filter tree root node. Format for: treerootnode = objzdy = $$, obj1 obj2 $(including objzdy for custom navigation box association columns in a table, obj1, obj2 for other fields on the card).',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126511,'�Ķ��_����̬�^�V���θ����c����ʽ����treerootnode=objzdy=$obj1$,$obj2$(����objzdy���Զ��x��[���P���е��У�obj1,obj2����Ƭ�ϵ������ֶ�)��',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126510,'treerootnode�����Զ������ε�ѡ���Զ������ζ�ѡ���˹���������ʵ�ֿ�Ƭ�ϵ��Զ������ε�ѡ�Ͷ�ѡ�ֶ�ȡ��Ƭ�ϵ������ֶ�ֵ��Ϊ���θ��ڵ�����ֵ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126510,'Treerootnode is used to customize the tree radio and custom tree pops up. This function is used to implement the card custom tree radio and multiselect fields take card the other field values as the root node in a tree on the primary key value',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126510,'treerootnode�����Զ��x���Ά��x���Զ��x���ζ��x���˹��������ڌ��F��Ƭ�ϵ��Զ��x���Ά��x�Ͷ��x�ֶ�ȡ��Ƭ�ϵ������ֶ�ֵ�������θ����c���Iֵ',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126509,'sqlcondition�����Զ��嵥ѡ���Զ����ѡ������ֶΣ��˹���������ʵ�ֿ�Ƭ��ĳЩ�ֶε�ֵ��Ϊ�Զ��������Ĳ�ѯ����Ĭ����������Ӧ�����ݡ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126509,'Sqlcondition for custom radio and custom multi-select navigation box field, this function is used to implement the card the values of certain fields as custom navigation box default search out the corresponding data query conditions.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126509,'sqlcondition�����Զ��x���x���Զ��x���x��[���ֶΣ��˹��������ڌ��F��Ƭ��ĳЩ�ֶε�ֵ�����Զ��x��[��Ĳ�ԃ�l��Ĭ�J�����������Ĕ�����',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126508,'��ʽΪ��sqlwhere=objzdy=$obj1$ and $obj2$(����objzdyΪ�Զ��������������е��У�obj1,obj2Ϊ��Ƭ�ϵ��ֶ�)��',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126508,'Format for: sqlwhere = objzdy = $$and $obj2 obj1 $(including objzdy for custom navigation box association columns in a table, obj1, obj2 for field) on the card.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126508,'��ʽ����sqlwhere=objzdy=$obj1$ and $obj2$(����objzdy���Զ��x��[���P���е��У�obj1,obj2����Ƭ�ϵ��ֶ�)��',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(126506,'sqlwhere�����Զ��嵥ѡ���Զ����ѡ������ֶΣ� �˹���������ʵ�ֿ�Ƭ�ϵ��Զ���������ֶθ��ݿ�Ƭ�ϵ������ֶ�ֵ���й������ݡ�',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126506,'Sqlwhere for custom radio and custom multi-select navigation box field, this function is used to implement the card custom navigation box field according to the other field values to filter the data on the card.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126506,'sqlwhere�����Զ��x���x���Զ��x���x��[���ֶΣ� �˹��������ڌ��F��Ƭ�ϵ��Զ��x��[���ֶθ�����Ƭ�ϵ������ֶ�ֵ�M���^�V������',9) 
GO