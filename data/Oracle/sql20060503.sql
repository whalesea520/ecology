INSERT INTO HtmlLabelIndex values(18818,'超时设置') 
/
INSERT INTO HtmlLabelInfo VALUES(18818,'超时设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18818,'overtime setting',8) 
/
INSERT INTO HtmlLabelIndex values(18842,'超时提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(18842,'超时提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18842,'overtime remind',8) 
/
INSERT INTO HtmlLabelIndex values(18843,'提前提醒时间') 
/
INSERT INTO HtmlLabelInfo VALUES(18843,'提前提醒时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18843,'remind time',8) 
/
INSERT INTO HtmlLabelIndex values(18844,'工作流提醒') 
/
INSERT INTO HtmlLabelIndex values(18845,'邮件提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(18844,'工作流提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18844,'workflow remind',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18845,'邮件提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18845,'e-mail remind',8) 
/
INSERT INTO HtmlLabelIndex values(18846,'指定对象') 
/
INSERT INTO HtmlLabelIndex values(18847,'指定干预对象') 
/
INSERT INTO HtmlLabelInfo VALUES(18846,'指定对象',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18846,'select object',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18847,'指定干预对象',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18847,'select intervenor',8) 
/
INSERT INTO HtmlLabelIndex values(18848,'超时处理') 
/
INSERT INTO HtmlLabelInfo VALUES(18848,'超时处理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18848,'overtime process',8) 
/
INSERT INTO HtmlLabelIndex values(18849,'自动流转至下一操作者') 
/
INSERT INTO HtmlLabelInfo VALUES(18849,'自动流转至下一操作者',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18849,'to move with next operator',8) 
/
INSERT INTO HtmlLabelIndex values(18850,'出口条件设置') 
/
INSERT INTO HtmlLabelInfo VALUES(18850,'出口条件设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18850,'node link condition setting',8) 
/
INSERT INTO HtmlLabelIndex values(18853,'请先设置节点超时时间') 
/
INSERT INTO HtmlLabelInfo VALUES(18853,'请先设置节点超时时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18853,'please,first setting node overtime',8) 
/
INSERT INTO HtmlLabelIndex values(18854,'提醒时间不能大于节点超时时间') 
/
INSERT INTO HtmlLabelInfo VALUES(18854,'提醒时间不能大于节点超时时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18854,'remind time can not over node pass time',8) 
/
INSERT INTO HtmlLabelIndex values(18868,'请选择提醒人') 
/
INSERT INTO HtmlLabelIndex values(18869,'请选择处理方式') 
/
INSERT INTO HtmlLabelIndex values(18867,'请选择提醒方式') 
/
INSERT INTO HtmlLabelInfo VALUES(18867,'请选择提醒方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18867,'please,select remind mode',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18868,'请选择提醒人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18868,'please,select remind object',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18869,'请选择处理方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18869,'please,select process mode',8) 
/
INSERT INTO HtmlLabelIndex values(18910,'流程超时提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(18910,'流程超时提醒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18910,'workflow overtime remind',8) 
/
INSERT INTO HtmlLabelIndex values(18911,'将超时') 
/
INSERT INTO HtmlLabelInfo VALUES(18911,'将超时',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18911,'will overtime',8) 
/
INSERT INTO HtmlLabelIndex values(18912,'流程图') 
/
INSERT INTO HtmlLabelInfo VALUES(18912,'流程图',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18912,'workflow chart',8) 
/
INSERT INTO HtmlLabelIndex values(18913,'流程干预') 
/
INSERT INTO HtmlLabelInfo VALUES(18913,'流程干预',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18913,'workflow intervenor',8) 
/
INSERT INTO HtmlLabelIndex values(18914,'流转至节点') 
/
INSERT INTO HtmlLabelInfo VALUES(18914,'流转至节点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18914,'flow to node',8) 
/
INSERT INTO HtmlLabelIndex values(18915,'流转至节点操作者') 
/
INSERT INTO HtmlLabelInfo VALUES(18915,'流转至节点操作者',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18915,'flow to node operator',8) 
/


alter table workflow_nodelink add nodepasshour integer 
/

alter table workflow_nodelink add nodepassminute integer 
/

alter table workflow_nodelink add isremind char(1) 
/

alter table workflow_nodelink add remindhour integer
/

alter table workflow_nodelink add remindminute integer
/

alter table workflow_nodelink add FlowRemind char(1) 
/

alter table workflow_nodelink add MsgRemind char(1) 
/

alter table workflow_nodelink add MailRemind char(1) 
/

alter table workflow_nodelink add isnodeoperator char(1) 
/

alter table workflow_nodelink add iscreater char(1) 
/

alter table workflow_nodelink add ismanager char(1) 
/

alter table workflow_nodelink add isother char(1) 
/

alter table workflow_nodelink add remindobjectids varchar2(100) 
/


alter table workflow_nodelink add isautoflow char(1) 
/

alter table workflow_nodelink add flownextoperator char(1) 
/

alter table workflow_nodelink add flowobjectids varchar2(100) 
/

alter table workflow_currentoperator add isreminded char(1)
/

alter table workflow_currentoperator add isprocessed char(1)
/
insert into syspoppupinfo(type,link,description,statistic,typedescription) values(10,'/workflow/search/WFSearchTemp.jsp?overtime=1','工作流超时提醒','y','工作流超时提醒')
/

CREATE TABLE workflow_modeview ( 
    formid integer,	
    nodeid integer,	
    isbill integer,	
    fieldid integer,	
    isview char(1),	
    isedit char(1),
    ismandatory char(1)	
)
/
