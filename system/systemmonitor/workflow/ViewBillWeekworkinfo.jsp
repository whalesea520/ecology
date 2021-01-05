<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
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
<form name="frmmain" method="post" action="BillWeekWorkinfoOperation.jsp">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<div>
<BUTTON class=btn accessKey=R onClick="location.href='WorkflowMonitor.jsp?start=<%=start%>'"><U>R</U>-返回</BUTTON>
</div>
<table class=form>
	<colgroup> <col width="20%"> <col width="80%"> 
	<tr class=separator> 
	  <td class=Sep1 colspan=4></td>
	</tr>
	<tr> 
      <td>说明</td>
      <td class=field colspan=3> 
      <%=Util.toScreen(requestname,user.getLanguage())%>
        <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">  
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span id=levelspan>
      <%if(requestlevel.equals("0")){%>正常 <%}%>
      <%if(requestlevel.equals("1")){%>重要 <%}%>
      <%if(requestlevel.equals("2")){%>紧急 <%}%>
      </span>
      </td>
    </tr>
<%
ArrayList fieldids=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList fieldvalues=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
}
RecordSet.executeProc("Bill_workinfo_SelectByID",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
}

ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}
for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldvalue=(String)fieldvalues.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	
	if(isview.equals("1")){
%>
    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class=field> 
        <%
	if(fieldhtmltype.equals("1")){%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <%	}		
	else if(fieldhtmltype.equals("2")){%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <%
	}
	else if(fieldhtmltype.equals("3")){
		String showname="" ;
		String showid="" ;
		String sql="";
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		if(fieldtype.equals("2") || fieldtype.equals("19")){%>
			<%=fieldvalue%>
		<%}
		else if(fieldtype.equals("17")|| fieldtype.equals("18")){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			if(fieldvalue.equals(""))
				fieldvalue="0";
			sql="select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				showid = RecordSet.getString(1);
				showname=RecordSet.getString(2);
				if(!linkurl.equals("")){
				%>
			        <a href='<%=linkurl%><%=showid%>'><%}%>
			        <%=Util.toScreen(showname,user.getLanguage())%>
			        <%if(!linkurl.equals("")){%></a><%}
			}
			    
		}else {
			int intfieldvalue=Util.getIntValue(fieldvalue,0);
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
			RecordSet.executeSql(sql);
			RecordSet.next();
			showname=RecordSet.getString(1);
			if(!linkurl.equals("")){
			%>
		        <a href='<%=linkurl%><%=intfieldvalue%>'><%}%><%=Util.toScreen(showname,user.getLanguage())%><%if(!linkurl.equals("")){%></a>
		        <%}
		}
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <%}else if(fieldhtmltype.equals("5")){
	%>
	<select name="field<%=fieldid%>" DISABLED >
	<%
	rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
        <%}
%>
      </td>
    </tr>
    <%
   }
}
%>   
		
    <tr> 
		<th colspan=2 align=center>上周工作总结</th>
	</tr>
	<tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <!-- 完成事项 -->
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=3 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>主要事项</td>
	        <td>完成结果</td>
	      </tr>
<%	boolean islight=true;
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  </tr>
<%
		islight=!islight;
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>
    <tr class=Section>
      <td colspan=2>
	  <table class=form>
	  <!-- 未完成事项 -->
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=3 id="oTable2">
	      <COLGROUP> 
	      <COL width="10%"><COL width="40%"> <COL width="50%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>未完成事项</td>
	        <td>原因或改进措施</td>
	      </tr>
<%	islight=true;
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"2");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("workname");
		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  </tr>
<%
		islight=!islight;
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr>
    
    <tr> 
		<th colspan=2 align=center>本周工作计划</th>
	</tr>
	<tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <!-- 下周计划事项 -->
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=4 id="oTable3">
	      <COLGROUP> 
	      <COL width="10%"><COL width="30%"> <COL width="20%"><COL width="40%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>主要计划事项</td>
	        <td>预计完成时间</td>
	        <td>关键因素</td>
	      </tr>
<%	islight=true;
	RecordSet.executeProc("bill_workinfodetail_SByType",""+billid+flag+"3");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("workname");
		String curdate=RecordSet.getString("forecastdate");
		String curworkdesc=RecordSet.getString("workdesc");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curdate,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  </tr>
<%
		islight=!islight;
	}
%>
	    </table>
	   </td></tr>
  	   <tr><td height=15></td></tr>
      </table>
      </td>
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
