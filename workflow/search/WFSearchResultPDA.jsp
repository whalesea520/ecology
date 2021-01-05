
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<%



String sql="";
String sqlwhere="";
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
String complete1=Util.null2String(request.getParameter("complete"));
String CurrentUser = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;

if(logintype.equals("2")) usertype= 1;

String workflowidtemp=Util.null2String(request.getParameter("workflowid"));
String wftype=Util.null2String(request.getParameter("wftype"));
sql=" and t1.requestid=t2.requestid ";
if (!wftype.equals("")){
	sql="  and t1.workflowtype="+wftype;
}

if (!workflowidtemp.equals("")){
	sql+=" and t1.workflowid="+workflowidtemp;
}
if (complete1.equals("0")){//代办
	sql+=" and t1.isremark in( '0','1','5','8','9','7') and t1.islasttimes=1 ";
}else if (complete1.equals("3")) {//待办事宜，红色new标记
	sql +=" and t1.isremark in(  '0','1','8','9','5','7') ";
	sql += " and  t1.viewtype=0 and t1.islasttimes=1 and ((t1.isremark='0' and (t1.isprocessed is null or (t1.isprocessed<>'2' and t1.isprocessed<>'3'))) or t1.isremark='1' or t1.isremark='8' or t1.isremark='9' or t1.isremark='5' or t1.isremark='7') ";
}else if (complete1.equals("4")){//待办事宜，灰色new标记
	sql +=" and t1.isremark in( '0','1','8','9','5','7') ";
	sql += " and  t1.viewtype=-1 and t1.islasttimes=1 and ((t1.isremark='0' and (t1.isprocessed is null or (t1.isprocessed<>'2' and t1.isprocessed<>'3'))) or t1.isremark='1' or t1.isremark='8' or t1.isremark='9' or t1.isremark='5' or t1.isremark='7') ";
}else if (complete1.equals("8")){//超时事宜
	sql +=" and ((t1.isremark='0' and (t1.isprocessed='2' or t1.isprocessed='3'))  or t1.isremark='5') ";
	sql += " and t2.currentnodetype <> 3 ";
}else if(complete1.equals("1")){//办结事宜
	sql += " and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
}else if(complete1.equals("2")){//表示已办事宜
	sql += " and t1.isremark ='2' and t1.iscomplete=0  and  t1.islasttimes=1 ";
}else if(complete1.equals("5")){//已办事宜，灰色new标记
	sql += " and t1.isremark ='2'  and t1.iscomplete=0 and t1.islasttimes=1 and t1.viewtype=-1 ";
}else if(complete1.equals("50")){//已办事宜，红色new标记
	sql += " and t1.isremark ='2'  and t1.iscomplete=0 and t1.islasttimes=1 and t1.viewtype=0 and (agentType<>'1' or agentType is null) ";
}else if(complete1.equals("6")){//办结事宜，红色new标记
	sql += " and t1.currentnodetype = 3 and islasttimes=1 and t1.viewtype=0 ";
}else if(complete1.equals("7")){//办结事宜，灰色new标记
	sql += " and t1.currentnodetype = 3 and islasttimes=1 and t1.viewtype=-1 ";
}

if(RecordSet.getDBType().equals("oracle")||RecordSet.getDBType().equals("db2")) {
	sql="select  t2.creater,t2.requestid,t2.requestname,t1.receivedate ,t1.receivetime  from workflow_currentoperator t1,workflow_requestbase t2  where t1.requestid=t2.requestid  "+sql+" and userid=" +  CurrentUser  + " and usertype= " + usertype +"  order by t1.receivedate desc,t1.receivetime desc";
}else{
	sql="select top 100 percent t2.creater,t2.requestid,t2.requestname,t1.receivedate ,t1.receivetime  from workflow_currentoperator t1,workflow_requestbase t2  where t1.requestid=t2.requestid  "+sql+"  and userid=" +  CurrentUser  + " and usertype= " + usertype +"  order by t1.receivedate desc,t1.receivetime desc";
}

String temptable1="";
//out.print("******"+sql);
if(RecordSet.getDBType().equals("oracle")){
    temptable1="( select * from ("+sql+") t where rownum<"+ (pagenum*perpage+2) +")  s";
	
}else if(RecordSet.getDBType().equals("db2")){
    temptable1=" ("+ sql +" fetch  first "+(pagenum*perpage+1)+" rows only )  s" ;
    
}else{

    temptable1="( select  top "+(pagenum*perpage+1)+" * from ("+sql+") as t ) as s" ;

}

//System.out.print(temptable1);
RecordSet.executeSql("Select count(requestid) as RecordSetCounts from "+temptable1);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}

if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";

if(RecordSet.getDBType().equals("oracle")){
   
	sqltemp="select * from (select * from  "+temptable1+" order by receivedate ,receivetime ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
   
    sqltemp="select  * from "+temptable1+"  order by receivedate ,receivetime fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
    
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable1+"  order by receivedate ,receivetime ";
}



RecordSet.execute(sqltemp);
%>
<FORM id=weaver name=weaver method=post action="WFSearchResultPDA.jsp">



 <TABLE width="100%">
   <tr><td><%=SystemEnv.getHtmlLabelName(82151, user.getLanguage())%>：<%=ResourceComInfo.getResourcename(CurrentUser)%></td></tr>
  <tr><td height="25"></td></tr>
          <tr>
           <td valign="top">
		   <table  class="ListStyle" cellspacing=1>
		   <tr class="header"><td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td><td><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td></tr>
			<% 
					int totalline=1;
					int i=0;
					if(RecordSet.last()){
					do{
					if(i==0){
						i=1;
				%>
				<TR class=DataLight>
				<%
					}else{
						i=0;
				%>
				   <TR class=DataDark>
					<%
					}
					%>
				<td><%=ResourceComInfo.getResourcename(RecordSet.getString("creater"))%></td>
				<td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=RecordSet.getString("requestid")%>&fromPDA=1"><%=RecordSet.getString("requestname")%></a></td>
					</tr>
						<%
                       if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				 }while(RecordSet.previous());
				}
				%>
				</table> 
                  </td>
                 </tr>
			   <tr><td height="40">	
					<%
					int pagenumm=1;
					if(pagenum>1){
						pagenumm=pagenum-1;
						%>
						
						<a href="WFSearchResultPDA.jsp?workflowid=<%=workflowidtemp%>&wftype=<%=wftype%>&pagenum=<%=pagenumm%>&complete=<%=complete1%>" ><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage()) %></a>
						<%}%>&nbsp;&nbsp;
						<%if(hasNextPage){
							pagenumm=pagenum+1;
							%>
					
						<a href="WFSearchResultPDA.jsp?workflowid=<%=workflowidtemp%>&wftype=<%=wftype%>&pagenum=<%=pagenumm%>&complete=<%=complete1%>"><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage()) %></a>
						<%}%>
						&nbsp;	&nbsp;
						<a href="javascript:location.href='/workflow/request/RequestView.jsp' "><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %></a>
						</td>
						
						</tr>
                  </TABLE>

</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>


</html>