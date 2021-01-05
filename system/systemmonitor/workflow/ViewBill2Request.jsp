<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<%
boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int start =Util.getIntValue(request.getParameter("start"),1);
String  isrequest=Util.null2String(request.getParameter("isrequest"));

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","b2");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
%>
<%
String requestname="";
int workflowid=0;
int formid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int creater=0;
int deleted=0;
int isremark=0;

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
}

if(isrequest.equals("1")) canview=true;

if(creater==userid){
	canview=true;
	canactive=true;
}

RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+requestid+"");
if(RecordSet.next())	hasright=1;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==1 ||isremark==1){
	canview=true;
	canactive=true;
}

%>


<form name="frmmain" method="post" action="RequestBill1Operation.jsp">
<div>
<BUTTON class=btn accessKey=R onClick="location.href='WorkflowMonitor.jsp?start=<%=start%>'"><U>R</U>-返回</BUTTON>
</div>
<br>
<table class=form>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <TR class=Section>
    	  <TH colSpan=2>
    	  <%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>:<%=Util.toScreen(status,user.getLanguage())%>
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
  	<td>说明</td>
  	<td class=field><%=Util.toScreen(requestname,user.getLanguage())%>
  	<input type=hidden name=requestname value="<%=requestname%>"></td>
  </tr>
<%
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
RecordSet.next();
formid=RecordSet.getInt("formid");

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

RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");
int billid = 0;
if(RecordSet.next()){
	billid = RecordSet.getInt("billid");
}

RecordSet.executeProc("LgcStockInOut_SelectById",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	
	fieldvalues.add(RecordSet.getString(fieldname));
	
}

ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet1.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet1.next()){
	isviews.add(RecordSet1.getString("isview"));
	isedits.add(RecordSet1.getString("isedit"));
	ismands.add(RecordSet1.getString("ismandatory"));
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
<%}%>   	<td class=field>
<%
	if(fieldhtmltype.equals("1")){%>
		<%=Util.toScreen(fieldvalue,user.getLanguage())%>
<%	}		
	else if(fieldhtmltype.equals("2")){%>
		<%=Util.toScreen(fieldvalue,user.getLanguage())%>
<%
	}
	else if(fieldhtmltype.equals("3")){
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
		String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
		String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		int intfieldvalue=Util.getIntValue(fieldvalue,0);
		String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
		RecordSet1.executeSql(sql);
		RecordSet1.next();
		String showname=RecordSet1.getString(1);
		if(fieldtype.equals("2"))	showname=fieldvalue;
		if(linkurl.equals("")){
		%>
			<span id="field<%=fieldid%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
		<%}else{%>
		<a href='<%=linkurl%><%=intfieldvalue%>'><span id="field<%=fieldid%>span"><%=Util.toScreen(showname,user.getLanguage())%></span></a>
		<%}
	}
	else if(fieldhtmltype.equals("4")){
	%>
		<input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
	<%}
%>
   	</td>
   </tr>
<%
   }
}
%>


<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field><%=RecordSet.getString("datefield"+i)%></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><%=RecordSet.getString("numberfield"+i)%></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%> disabled >
          </TD>
        </TR>
		<%}
	}
}
%>
</table>

<table Class=ListShort>
      	<COLGROUP>
  	<COL width="14%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="13%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  	<TR class=Section>
    	  <TH colSpan=8>
    	  资产
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=8></TD></TR>
    	  
    	   <tr class=header> 
            <td>资产</td>
            <td>批号</td>
            <td>数量</td>
            <td>单价</td>
            <td>税率(%)</td>
            <td>金额</td>
            <td>税额</td>
            <td>税价合计</td>
            </tr>
            
<%
  int linecolor=0;
RecordSet.executeProc("LgcStockInOutDetail_Select",billid+"");
while(RecordSet.next())
{
%>
 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
  <td><%=AssetAssortmentComInfo.getAssortmentName(RecordSet.getString("assetid"))%></td>
  <td><%=RecordSet.getString("batchmark")%></td>
  <td><%=RecordSet.getString("number_n")%></td>
  <td><%=RecordSet.getString("unitprice")%></td>
  <td><%=RecordSet.getString("taxrate")%></td>
  <td><%=(RecordSet.getFloat("number_n")*RecordSet.getFloat("unitprice"))%></td>
  <td><%=(RecordSet.getFloat("number_n")*RecordSet.getFloat("unitprice"))*(RecordSet.getInt("taxrate")/100.0)%></td>
  <td><%=(RecordSet.getFloat("number_n")*RecordSet.getFloat("unitprice"))*(1+RecordSet.getInt("taxrate")/100.0)%></td>
</tr>
 <%
  if(linecolor==0) linecolor=1;
          else linecolor=0;
 }
 %>           
  </table>
  

<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>


<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
</form>
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>