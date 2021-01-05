
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20773,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
boolean issimple = Util.null2String(request.getParameter("issimple")).equals("false")?false:true;

%>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(23803, user.getLanguage()) + ",/workflow/search/CustomSearch.jsp?issimple="+issimple+",_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=subform method=post>
<%

ArrayList CustomQueryTypeids = new ArrayList();
ArrayList CustomQueryTypenames = new ArrayList();
ArrayList CustomQuerys = new ArrayList();

ArrayList Customids = new ArrayList();
ArrayList Customnames = new ArrayList();
String temptypeid="";
String temptypename="";
String typeid="";
String typename="";
String sql = "";
    String tempbillworkflowids="";
    String tempfromworkflowids="";
    RecordSet.execute("select * from workflow_custom ");
    while(RecordSet.next()){
        String isbill = Util.null2String(RecordSet.getString("isbill"));
        String formID = Util.null2String(RecordSet.getString("formid"));
        String tempworkflowids = Util.null2String(RecordSet.getString("workflowids"));
        if (tempworkflowids.trim().equals("")) {
            rs.executeSql("select id from workflow_base where (isvalid='1' or isvalid='3') and formid=" + formID + " and isbill='" + isbill + "'");
            while (rs.next()) {
                if (tempworkflowids.trim().equals("")) {
                    tempworkflowids = rs.getString("id");
                } else {
                    tempworkflowids += "," + rs.getString("id");
                }
            }
        }
        if (!tempworkflowids.trim().equals("")) {
            if (isbill.equals("1")) {
                if (tempbillworkflowids.trim().equals("")) {
                    tempbillworkflowids = tempworkflowids;
                } else {
                    tempbillworkflowids += "," + tempworkflowids;
                }
            } else {
                if (tempfromworkflowids.trim().equals("")) {
                    tempfromworkflowids = tempworkflowids;
                } else {
                    tempfromworkflowids += "," + tempworkflowids;
                }
            }
        }
    }
    String tempwfids="";
    if(!tempbillworkflowids.equals("")){
        RecordSet.executeSql("select distinct a.workflowid from workflow_createdoc a,workflow_billfield b where (b.viewtype is null or b.viewtype !='1') and a.flowdocfield=b.id and a.status='1' and a.workflowid in("+ WorkflowVersion.getAllVersionStringByWFIDs(tempbillworkflowids) +")");
        while(RecordSet.next()){
            String tmpworkflowid=RecordSet.getString("workflowid");
                if(tempwfids.equals("")){
                    tempwfids=tmpworkflowid;
                }else{
                    tempwfids+=","+tmpworkflowid;
                }
            }
    }
    if(!tempfromworkflowids.equals("")){
        RecordSet.executeSql("select distinct c.workflowid from workflow_createdoc c,workflow_formfield a ,workflow_formdict b where a.fieldid=b.id and (a.isdetail is null or a.isdetail !='1') and c.flowdocfield=a.fieldid and c.status='1' and c.workflowid in("+WorkflowVersion.getAllVersionStringByWFIDs(tempfromworkflowids)+")");
        while(RecordSet.next()){
            String tmpworkflowid=RecordSet.getString("workflowid");
                if(tempwfids.equals("")){
                    tempwfids=tmpworkflowid;
                }else{
                    tempwfids+=","+tmpworkflowid;
                }
        }
    }
    if(!tempwfids.equals("")){
        sql="select distinct b.id as typeid,b.typename,a.customname,a.id from workflow_custom a,workflow_customQuerytype b,(select  formid,isbill,id from workflow_base  where (isvalid='1' or isvalid='3')  and formid in (select formid from workflow_custom where isbill=workflow_base.isbill)  and (id in("+tempwfids+") or exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=workflow_base.id and userid="+userid+" and usertype='"+usertype+"')))c";
    }else{
        sql="select distinct b.id as typeid,b.typename,a.customname,a.id from workflow_custom a,workflow_customQuerytype b,(select  formid,isbill,id from workflow_base  where (isvalid='1' or isvalid='3') and formid in (select formid from workflow_custom where isbill=workflow_base.isbill)  and exists (select 1 from workflow_currentoperator where workflow_currentoperator.workflowid=workflow_base.id and userid="+userid+" and usertype='"+usertype+"'))c";
    }
    if(RecordSet.getDBType().equals("oracle")){
        sql+=" where a.querytypeid=b.id and a.formid=c.formid and a.isbill=c.isbill and (','||a.workflowids||',' like '%,'||to_char(c.id)||',%' or a.workflowids is null)  order by b.id,a.id";
    }else{
        sql+=" where a.querytypeid=b.id and a.formid=c.formid and a.isbill=c.isbill and (','+convert(varchar,a.workflowids)+',' like '%,'+convert(varchar,c.id)+',%' or convert(varchar,a.workflowids)='' or a.workflowids is null) order by b.id,a.id";
    }
RecordSet.executeSql(sql);
while(RecordSet.next()){
    typeid=Util.null2String(RecordSet.getString("typeid"));
    typename=Util.null2String(RecordSet.getString("typename"));
    if(!temptypeid.equals("")&&!temptypeid.equals(typeid)){
        CustomQueryTypeids.add(temptypeid);
        CustomQueryTypenames.add(temptypename);
        ArrayList Customs = new ArrayList();
        Customs.add(Customids.clone());
        Customs.add(Customnames.clone());
        CustomQuerys.add(Customs);
        Customids.clear();
        Customnames.clear();
    }
    temptypeid=typeid;
    temptypename=typename;
    Customids.add(RecordSet.getString("id"));
    Customnames.add(Util.null2String(RecordSet.getString("customname")));
}
if(!typeid.equals("")){
    CustomQueryTypeids.add(typeid);
    CustomQueryTypenames.add(typename);
    ArrayList Customs = new ArrayList();
    Customs.add(Customids.clone());
    Customs.add(Customnames.clone());
    CustomQuerys.add(Customs);
}
int wftypetotal=CustomQueryTypeids.size();
int rownum=(wftypetotal+2)/3;
%>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="ViewForm">

   <tr class=field>
        <td width="30%" align=left valign=top>
<%
 	int i=0;
 	int needtd=rownum;
 	for(int k=0;k<CustomQueryTypeids.size();k++){
 		String wftypename=(String)CustomQueryTypenames.get(k);
        ArrayList wfCustomQuerys=(ArrayList)CustomQuerys.get(k);
 	%>
 	<table class="ViewForm">
		<tr>
		  <td>

 	<%
	needtd--;
    if(wfCustomQuerys!=null&&wfCustomQuerys.size()==2){
        ArrayList wfcustomids=(ArrayList)wfCustomQuerys.get(0);
        ArrayList wfcustomnames=(ArrayList)wfCustomQuerys.get(1);
        if(wfcustomids!=null&&wfcustomids.size()>0){
        %>
            <ul><li><b><%=Util.toScreen(wftypename,user.getLanguage())%></b>
                <%
	for(int m=0;m<wfcustomids.size();m++){
		String wfname=(String)wfcustomnames.get(m);
	 	String wfcustomid = (String)wfcustomids.get(m);
	%>
		<ul><li><a href="javascript:onSearchCustom(<%=wfcustomid%>);">
		<%=Util.toScreen(wfname,user.getLanguage())%></a></ul></li>
	<%
		}
            }
        }
	%>
		</ul></li></td></tr>
	</table>
	<%
		if(needtd<=0){
			needtd=rownum;
	%>
	</td><td width="30%" align=left valign=top>
	<%
		}
	}
	%>
	</td>
  </tr>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>
<script language=javascript>
function onSearchCustom(customid){
document.subform.action="WFCustomSearchBySimple.jsp?searchtype=querytype&customid="+customid+"&issimple=<%=issimple%>";
document.subform.submit();
}
</script>
</body>

</html>