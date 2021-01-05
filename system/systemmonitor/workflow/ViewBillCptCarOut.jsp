<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<%
boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int start =Util.getIntValue(request.getParameter("start"),1);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();

String requestname="";
String requestlevel="";
int workflowid=0;
int formid=0;
int billid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int creater=0;
int deleted=0;
int isremark=0;
int creatertype = 0;

int usertype = 0;
if(logintype.equals("1"))
	usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
	
char flag=Util.getSeparator() ;

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
	creater=RecordSet.getInt("creater");
	deleted=RecordSet.getInt("deleted");
	creatertype = RecordSet.getInt("creatertype");	
	requestlevel=RecordSet.getString("requestlevel");
}

if(isrequest.equals("1")) canview=true;

if(creater==userid && creatertype==usertype){
	canview=true;
	canactive=true;
}


RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+""+usertype+flag+requestid+"");
if(RecordSet.next())	canview=true;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next()){
	hasright=1;
}

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==1 ||isremark==1){
	canview=true;
	canactive=true;
}


RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

%>

<form name="frmmain" method="post" action="BillCptOutOperation.jsp">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<div>
<BUTTON class=btn accessKey=R onClick="location.href='WorkflowMonitor.jsp?start=<%=start%>'"><U>R</U>-返回</BUTTON>
</div>
  <br>
  <table class=form>
    <colgroup> <col width="15%"> <col width="85%">
    <tr class=separator> 
      <td class=Sep1 colspan=4></td>
    </tr>
    <tr> 
      <td>说明</td>
      <td class=field colspan=3> 
      <%=Util.toScreen(requestname,user.getLanguage())%>
        <input type=hidden name=name value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">  
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span id=levelspan>
      <%if(requestlevel.equals("0")){%>正常 <%}%>
      <%if(requestlevel.equals("1")){%>重要 <%}%>
      <%if(requestlevel.equals("2")){%>紧急 <%}%>
      </span>
      </td>
    </tr>
<tr><td>&nbsp</td></tr>
<TR class=Section>
    	  <TH colSpan=2>
    	  德隆国际战略投资有限公司行政管理部驱车记录单
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
 <table Class=ListShort cols=14 id="oTable"><COLGROUP>
      	
   <tr class=header> 
    	   <td rowspan=2 width="7%">日期</td>
    	   <td rowspan=2 width="7%">驾驶员</td>
    	   <td rowspan=2 width="7%">车号</td>
    	   <td colspan=2 width="14%">出发时间</td>
    	   <td colspan=2 width="14%">
    	   到达时间
    	   </td>
  	   <td rowspan=2 width="12%">起始地点</td>
  	   <td colspan=3 width="21%">行驶公里数</td>    	   
    	   <td rowspan=2 width="7%">使用人</td>
    	   <td rowspan=2 width="7%">使用部门</td>
    	   <td rowspan=2 width="2%">是否外地</td>    
            </tr>
            <tr class=header>  
             <td width="7%">日期</td><td width="7%">小时</td><td width="7%">日期</td><td width="7%">小时</td>
             <td width="7%">出车前</td><td width="7%">出车后</td><td width="7%">小计</td>
            </tr>
        <%
          int linecolor=0;  
        String sql = " select * from bill_CptCarOut where requestid ="+requestid;
        RecordSet.executeSql(sql);
        while(RecordSet.next()){
        %>    
     <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
         <td><%=RecordSet.getString("usedate")%></td>
         <td><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("driver")%>"> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("driver")),user.getLanguage())%></a></td>
    <td><a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("carno")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("carno")),user.getLanguage())%> </a>
     <td><%=RecordSet.getString("begindate")%></td>
         <td><%=RecordSet.getString("begintime")%></td>
         <td><%=RecordSet.getString("enddate")%></td>
         <td><%=RecordSet.getString("endtime")%></td>
         <td><%=RecordSet.getString("frompos")%></td>
         <td><%=RecordSet.getString("beginnumber")%></td>
         <td><%=RecordSet.getString("endnumber")%></td>
         <td><%=RecordSet.getString("number_n")%></td>
         <td><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("userid")%>"> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%></a></td>
         <td><a 
      href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("userdepid")%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("userdepid")),user.getLanguage())%></a></TD>
         <td><%if(RecordSet.getString("isotherplace").equals("1")){%>是 <%}else{%>否 <%}%></td> 
      </tr>
      <%}%>
  </table>
  </tr>  
  </table>
  
  <br>
  <br>
 <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>
 
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>
</body>
</html>
