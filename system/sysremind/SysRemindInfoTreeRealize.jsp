<%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="java.util.ArrayList,java.lang.reflect.Method" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><jsp:useBean id="userSetting" class="weaver.systeminfo.setting.HrmUserSettingComInfo" scope="page" /><%response.setHeader("Cache-Control","no-store");response.setHeader("Pragrma","no-cache");response.setDateHeader("Expires",0);%><%User user = HrmUserVarify.getUser(request,response);%><?xml version="1.0" encoding="UTF-8"?><TreeNode xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Title="envelope" xsi:type="TreeNode"><TreeNode Title="<%= SystemEnv.getHtmlLabelName(19090,user.getLanguage()) %>" Icon="/images/treeimages/global_wev8.gif"  Target="contentframe" Href="SysRemindInfoDefault.jsp">
<%if(user == null)  return ;
String s = "", sql="";
int userid=user.getUID();
int usertype= Util.getIntValue(user.getLogintype(),1)-1;
//Remind
//if(rs.getDBType().equals("oracle")){
//sql = "select a.type, sum(a.counts) as counts, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"' and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3'))  or isremark='5') and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1  and (dbms_lob.instr(t1.coworkers,',"+userid+",',1,1)>0 or t1.creater="+userid+") and dbms_lob.instr(t1.isnew,',"+userid+",',1,1)<=0))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
//}
//else
//{
//sql = "select a.type, sum(a.counts) as counts, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"' and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3'))  or isremark='5') and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1 and (t1.coworkers like '%,"+userid+",%' or t1.creater="+userid+") and t1.isnew not like '%,"+userid+",%'))   or type in (2,3,4,6,7,8,11,12,13)) group by a.type";
//}
//td19003 因协作提醒参与人条件改变而且可能涉及较多人员，导致协作提交回复会很慢，考虑去掉协作提醒
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+"");
    String resourceids =userid+"";
    if(belongtoshow.equals("1")&&"0".equals(user.getAccount_type())){
        String belongtoids = user.getBelongtoids();
        resourceids=resourceids+","+belongtoids;
}
sql = "select a.type, sum(a.counts) as counts, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link " +
"from SysPoppupRemindInfoNew a " +
"where  a.userid in("+resourceids+") " +
"and a.usertype='"+usertype+"' " +
"and ( " +
"(a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+resourceids+") and usertype='"+usertype+"' and islasttimes=1 and isremark in ('0','1','8','9','7') and workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3')) ) )   " +
"or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+resourceids+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) " +
"or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+resourceids+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) " +
"or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and islasttimes=1 and userid in (102,61641) AND usertype='0'))  " +
"or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1)) "+
" or( a.type = 15 and requestid in ( select id from MailResource where resourceid in ("+resourceids+") and status = 0 and folderid=0 ))" +
"or type in (2,3,4,6,7,8,11,12,13,21,25)"+
") " +
"group by a.type";
//System.out.print(sql);
rs.executeSql(sql);
while(rs.next()){
if(rs.getString("statistic").equals("y"))
s += "<TreeNode  Title=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"("+rs.getInt("counts")+")"+"\" Icon=\"/images/treeimages/Home_wev8.gif\" Target=\"contentframe\" Href=\""+rs.getString("link")+"\" />";
else
s += "<TreeNode  Title=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"\" Icon=\"/images/treeimages/Home_wev8.gif\" Target=\"contentframe\" Href=\""+rs.getString("link")+"\" />";
}
out.print(s+"</TreeNode></TreeNode>");
%>