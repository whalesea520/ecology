<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%	//      check user's right about current request operate
String newfromdate="a";
String newenddate="b";

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
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
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
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

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;
RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next())	isremark=1;

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

String isreopen="";
String isreject="";
String isend="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	isend=RecordSet.getString("isend");
}
//~~~~~~~~~~~~~get submit button title~~~~~~~~~~~~~~~
String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());

//~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

String needcheck="requestname";
%>
<form name="frmmain" method="post" action="BillLeaveJobOperation.jsp">
<input type=hidden name=isremark >
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<div>
<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
<BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?requestid=<%=requestid%>'"><U>M</U>-<%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></button>
<%}}%>

<%if(!isend.equals("1")){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
<%}%>

<%if(isremark!=1){%>
<%if(isreopen.equals("1") && false){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}%>
<%if(nodetype.equals("0")){%>
<BUTTON class=btnDelete accessKey=D type=button onclick="if(isdel()){doDelete();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
<%}%><%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></button>
</div>
  <table class="viewform">
    <colgroup> <col width="20%"> <col width="80%">  
    <TR class="Spacing"> 
      <TD class="Line1" colSpan=2></TD>
    </TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field> 
      <%=Util.toScreen(requestname,user.getLanguage())%> 
        <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span>
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      </span>
      </td>
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
ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}

RecordSet.executeProc("Bill_LeaveJob_SelectByID",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
}

for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldname=(String)fieldnames.get(i);
	String fieldvalue=(String)fieldvalues.get(i);
	String isview=(String)isviews.get(i);
	String isedit=(String)isedits.get(i);
	String ismand=(String)ismands.get(i);
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	if(fieldhtmltype.equals("3") && fieldvalue.equals("0")) fieldvalue = "" ;
	if(fieldname.equals("begindate")) newfromdate="field"+fieldid;
	if(fieldname.equals("enddate")) newenddate="field"+fieldid;
	if(fieldname.equals("manager")){
	String tmpmanagerid = ResourceComInfo.getManagerID(""+userid);%>
	<input type=hidden name="field<%=fieldid%>" value="<%=tmpmanagerid%>"	
	<%
	}
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
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" style="width:50%">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:50%">
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
        <input type=text class=inputstyle  name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
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
        <textarea class=inputstyle  name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" 
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
		String showname="";
		String showid="" ;
		String sql="";
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		if(fieldtype.equals("2") ||fieldtype.equals("19")  )	showname=fieldvalue;
		else if(fieldtype.equals("17")||fieldtype.equals("18")){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				showid = RecordSet.getString(1);
				String tmpname=RecordSet.getString(2);
				if(!linkurl.equals("")){
					if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                	{
                		showname = "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + tmpname + "</a>&nbsp";
                	}
    				else
						showname +="<a href='"+linkurl+showid+"'>"+tmpname+"</a>&nbsp";
				}else{
					showname += tmpname+" ";	
				}	
			}			    
		}
		else {
			int intfieldvalue=Util.getIntValue(fieldvalue,0);
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
			RecordSet.executeSql(sql);
			RecordSet.next();
			if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
        	{
        		showname = "<a href='javaScript:openhrm(" + intfieldvalue + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
        	}
			else
				showname = "<a href='"+linkurl+intfieldvalue+"'>"+RecordSet.getString(1)+"</a>&nbsp";
		}
		%>
        <%if(isedit.equals("1")&&isremark==0){%>
        <button class=Browser onclick="onShowBrowser('<%=fieldid%>','<%=url%>','<%=linkurl%>','<%=fieldtype%>','<%=ismand%>')"></button>
        <%}%>
        <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreen(fieldvalue,user.getLanguage())%>">
        <span id="field<%=fieldid%>span">
        <%=Util.toScreen(showname,user.getLanguage())%>
        <%if(ismand.equals("1")){%>
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        <%	needcheck+=",field"+fieldid;	
			}%></span>
        <%
	}
	else if(fieldhtmltype.equals("4")){%> 
		<%if(isedit.equals("0")||isremark==1){%>
        <input type=checkbox value=1 name="prefield_<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>> 
        <input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <input type=checkbox value=1 name="field<%=fieldid%>" <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <%}
    }
	else if(fieldhtmltype.equals("5")){%>
		<%if(isedit.equals("0")||isremark==1){%>
        <select class=inputstyle  name="field<%=fieldid%>" DISABLED >
	<%
	rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
	<input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <select class=inputstyle  name="field<%=fieldid%>">
		<%
		rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
		while(rs.next()){
			int tmpselectvalue = rs.getInt("selectvalue");
			String tmpselectname = rs.getString("selectname");
		%>
		<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
		<%}%>
		</select>
        <%}}
%>
      </td>
    </tr>
    <%
   }else { %>
   <input type=hidden name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>">
 <%}
}
%>
	<tr><td height=15></td></tr>
<%
if(nodetype.equals("2")){
        RecordSet.executeProc("Bill_LeaveJob_SelectByID",billid+"");
    	RecordSet.next();
    	String leaveresource=RecordSet.getString("resourceid");
		boolean islight=true;
		RecordSet.executeProc("CptCapital_SelectByRandR",""+userid+flag+leaveresource);
		if(RecordSet.getCounts()>0){
%>
    <tr><td colspan=2>
	<table class=liststyle cellspacing=1  >
	<tr class="Title"><th colspan=3><%=SystemEnv.getHtmlLabelName(1017,user.getLanguage())%></th></tr>
	<tr class=header>
	    <td><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(1018,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(1019,user.getLanguage())%></td>
	</tr>
<%
		}
		while(RecordSet.next()){
			String cptid=RecordSet.getString("id");
			String cptmark=RecordSet.getString("mark");
			String cptname=RecordSet.getString("name");
			String capitalspec=RecordSet.getString("capitalspec");
			String capitalnum=RecordSet.getString("capitalnum");
		%>
	<tr <%if(islight){%> class=datalight <%} else {%> class=datadark<%}%>>
		<td><%=Util.toScreen(cptmark+"-"+cptname,user.getLanguage())%></td>
		<td><%=Util.toScreen(capitalspec,user.getLanguage())%></td>
		<td><%=Util.toScreen(capitalnum,user.getLanguage())%></td>
	</tr>
		<%	islight=!islight;
		}
%>
    </table>
    </td></tr>
<%	
}%>
  </table>
  </td>
  </tr>  
  </table><br>
  <br>
  <%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
 
<script language=javascript>
	function doRemark(){
		parastr = "<%=needcheck%>" ;
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{  
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else 
                return true;
            }
            }
        else
        return true;
        }
}

	
	function checktimeok(){
	if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != ""){
				YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
				MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
				DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
				YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
				MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
				DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
				// window.alert(YearFrom+MonthFrom+DayFrom);
	                   if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
	        window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	         return false;
	  			 }
	  }
	     return true; 
	}

	
	function doSave(){
		parastr = "<%=needcheck%>" ;
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='save';
//			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok()){
				//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
			}
		}
	}
	
	function doSubmit(){
		parastr = "<%=needcheck%>" ;
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='submit';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			if(checktimeok()){
				//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
			}
		}
	}
	function doReject(){
		document.frmmain.src.value='reject';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
        if(onSetRejectNode()){
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
	function doReopen(){
		document.frmmain.src.value='reopen';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
		document.frmmain.src.value='delete';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
</script>
<script language=vbs>
sub getTheDate(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script>
</body>
</html>
