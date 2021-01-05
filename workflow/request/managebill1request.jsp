<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%	//  check user's right about current request operate 
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String requestname="";
int workflowid=0;
int formid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int isremark=0;

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","b1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
	
char flag=Util.getSeparator() ;

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
}

RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+requestid+"");
if(RecordSet.next())	hasright=1;
RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark='1'");
if(RecordSet.next())	isremark=1;

String user_fieldid="";
String isreopen="";
String isreject="";
String isend="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	user_fieldid=RecordSet.getString("userids");
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	isend=RecordSet.getString("isend");
}

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}
/*
String clientip=request.getRemoteAddr();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+""+flag+userid+""+flag+CurrentDate+flag+CurrentTime+flag+clientip);
*/
%>


<form name="frmmain" method="post" action="RequestBill1Operation.jsp">
<input type=hidden name=isremark >
<%
String needcheck="requestname";

String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());
%>
<div>

<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
<BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?requestid=<%=requestid%>'"><U>M</U>-<%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></button>
<%}}%>

<% if(!isend.equals("1")){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
<%}%>

<%if(isremark!=1){%>
<%if(isreopen.equals("1")){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}%>
<BUTTON class=btnDelete accessKey=S type=button onclick="doDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>

<%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></button>
</div>
<!--
  <div align="center"> <font style="font-size:14pt;FONT-WEIGHT: bold">资产借用申请单</font> 
  </div>
  -->
  <table class="viewform" cellpadding="3" cellspacing="3" border="1">
    <colgroup> <col width="20%"> <col width="80%"> 
    <TR class="Spacing"> 
      <TD class="Line1" colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <% // if(nodetype.equals("1")){%>
      <!-- td class=field>
        <input type=text name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>"
  	onChange="checkinput('requestname','requestnamespan')" size=40 maxlength=25 -->
        <%// if(requestname.equals("")){%>
        <!-- span id=requestnamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle -->
        <%// }%>
        <!-- /span> </td -->
      <%// } else {%>
      <td class=field><%=Util.toScreen(requestname,user.getLanguage())%> 
        <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
      </td>
      <%// }%>
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

RecordSet.executeProc("bill_itemusage_Select",billid+"");
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
	
	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;

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
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text class=inputstyle name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
		else if(fieldtype.equals("2")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
		else if(fieldtype.equals("3")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>
        <%}
			}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
		}
	}
	else if(fieldhtmltype.equals("2")){
		if(isedit.equals("1")&&isremark==0){
			if(ismand.equals("1")) {%>
        <textarea  class=inputstyle name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" 
		 rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea class=inputstyle  name="field<%=fieldid%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <%}
		}else{
		%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
        <%
			}
	}
	else if(fieldhtmltype.equals("3")){
		String showname= "" ;
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		int intfieldvalue=Util.getIntValue(fieldvalue,0);
		
		if(fieldtype.equals("2"))	showname=fieldvalue;
		else {
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			String sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
			RecordSet1.executeSql(sql);
			RecordSet1.next();
			showname=RecordSet1.getString(1);
		}
		%>
        <%if(isedit.equals("1")&&isremark==0){%>
        <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=fieldtype%>','<%=ismand%>','<%=linkurl%>')"></button>
        <%}%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreen(fieldvalue,user.getLanguage())%>">
        <span id="field<%=fieldid%>span"><%if(!linkurl.equals("")){%><a href='<%=linkurl%><%=intfieldvalue%>'><%}%><%=Util.toScreen(showname,user.getLanguage())%><%if(!linkurl.equals("")){%></a><%}%>
        <%if(ismand.equals("1")){%>
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        <%	needcheck+=",field"+fieldid;	
			}%></span>
        <%
	}
	else if(fieldhtmltype.equals("4")){
	%> <input type=checkbox value=1 name="field<%=fieldid%>" 
		<%if(isedit.equals("0")||isremark==1){%> DISABLED <%}%> <%if(fieldvalue.equals("1")){%> checked <%}%>> 
        <%}
%>
      </td>
    </tr>
    <%
   }else { %>
   <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
 <%}
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
      <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Calendar onclick="getDate(<%=i%>)"></BUTTON> 
        <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
        <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield"+i)%>">
      </TD>
    </TR>
    <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
    <TR> 
      <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=Inputstyle maxLength=30 size=30 name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>">
      </TD>
    </TR>
    <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
    <TR> 
      <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=Inputstyle maxLength=100 size=30 name="tff0<%=i%>" value="<%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%>">
      </TD>
    </TR>
    <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
    <TR> 
      <TD><%=Util.toScreen(RecordSetFF.getString(i*2+30),user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked<%}%>>
      </TD>
    </TR>
    <%}
	}
}
%>
  </table>
  <br>
  <br>
 <%@ include file="/workflow/request/WorkflowManageSign.jsp" %>

<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
</form>

<script language=javascript>
	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.frmmain.remark.disabled=false ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='save';
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='submit';
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doReject(){
			document.frmmain.src.value='reject';
			document.frmmain.remark.disabled=false ;
        if(onSetRejectNode()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
	function doReopen(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='reopen';
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
			document.frmmain.src.value='delete';
			document.frmmain.remark.disabled=false ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
</script>