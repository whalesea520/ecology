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

RecordSet.executeProc("workflow_Requestbase_SelectByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
	creater=RecordSet.getInt("creater");
	deleted=RecordSet.getInt("deleted");
	creatertype = RecordSet.getInt("creatertype");	
}

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;
RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next())	isremark=1;

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

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
//~~~~~~~~~~~~~get submit button title~~~~~~~~~~~~~~~
String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());

//~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
RecordSet.executeProc("workflow_form_SelectByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
int thismonth=today.get(Calendar.MONTH) + 1;

String needcheck="requestname";
int rowindex1=0 ;
%>

<form name="frmmain" method="post" action="BillMonthWorkPlanOperation.jsp">
<input type=hidden name=isremark >
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type="hidden" value="0" name="nodesnum">
<input type=hidden name="billid" value=<%=billid%>>
<div>
<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-提交</button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
<BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?requestid=<%=requestid%>'"><U>M</U>-转发</button>
<%}}%>

<%if(!isend.equals("1")){%>
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
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-返回</button>
</div>
  <table class=form>
    <colgroup> <col width="15%"> <col width="85%">  
    <TR class=separator> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    <tr>
      <td>说明</td>
      <td class=field> 
      <%=Util.toScreen(requestname,user.getLanguage())%> 
        <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
      </td>
    </tr>
    <%
RecordSet.executeProc("workflow_Workflowbase_SelectByID",workflowid+"");
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

RecordSet.executeProc("Bill_workinfo_SelectByID",billid+"");
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
    if(fieldname.equals("thismonth")){
    	if(isedit.equals("1")&&isremark==0){
	%>
		<select name="field<%=fieldid%>" size=1>
			<option value=1 <%if(thismonth==1){%> selected <%}%>>1</option>
			<option value=2 <%if(thismonth==2){%> selected <%}%>>2</option>
			<option value=3 <%if(thismonth==3){%> selected <%}%>>3</option>
			<option value=4 <%if(thismonth==4){%> selected <%}%>>4</option>
			<option value=5 <%if(thismonth==5){%> selected <%}%>>5</option>
			<option value=6 <%if(thismonth==6){%> selected <%}%>>6</option>
			<option value=7 <%if(thismonth==7){%> selected <%}%>>7</option>
			<option value=8 <%if(thismonth==8){%> selected <%}%>>8</option>
			<option value=9 <%if(thismonth==9){%> selected <%}%>>9</option>
			<option value=10 <%if(thismonth==10){%> selected <%}%>>10</option>
			<option value=11 <%if(thismonth==11){%> selected <%}%>>11</option>
			<option value=12 <%if(thismonth==12){%> selected <%}%>>12</option>
		</select>
	<%
		}else{
	%>
		<%=thismonth%><input type=hidden name=name="field<%=fieldid%>" value="<%=thismonth%>">
	<%	
		}
		continue;
	}
	if(fieldhtmltype.equals("1")){
		if(fieldtype.equals("1")){
			if(isedit.equals("1")&&isremark==0){
				if(ismand.equals("1")) {%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" style="width:50%">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>" style="width:50%">
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
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
		onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this);checkinput('field<%=fieldid%>','field<%=fieldid%>span')">
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
					needcheck+=",field"+fieldid;
				}else{%>
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
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
        <input type=text name="field<%=fieldid%>" value="<%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>"
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
        <textarea name="field<%=fieldid%>" onChange="checkinput('field<%=fieldid%>','field<%=fieldid%>span')" 
		 rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
        <span id="field<%=fieldid%>span">
        <%if(fieldvalue.equals("")){%>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
        <%}%>
        </span> 
        <%
				needcheck+=",field"+fieldid;
			}else{%>
        <textarea name="field<%=fieldid%>" rows="4" cols="40" style="width:80%"><%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%></textarea>
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
			showname ="<a href='"+linkurl+intfieldvalue+"'>"+RecordSet.getString(1)+"</a>&nbsp";
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
	<input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <select name="field<%=fieldid%>">
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
    
    <tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <tr><td height=15></td></tr>
	<%if(!nodetype.equals("0")) {%>
    <tr> 
		<th colspan=2 align=center>本月工作目标</th>
	</tr>
	<tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <!-- 完成事项 -->
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=5 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="20%"> <COL width="20%"><COL width="20%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>本月工作目标</td>
	        <td>达成结果</td>
	        <td>完成日期</td>
	        <td>权重指数</td>
	      </tr>
<%	boolean islight=true;
	RecordSet.executeProc("bill_monthinfodetail_SelectByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("targetname");
		String curworkdesc=RecordSet.getString("targetresult");
		String curdate=RecordSet.getString("forecastdate");
		String curscale=RecordSet.getString("scale");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td>&nbsp;</td>
		  <td><%=Util.toScreen(curworkname,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curworkdesc,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curdate,user.getLanguage())%></td>
		  <td><%=Util.toScreen(curscale,user.getLanguage())%>%</td>
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
	<%} else {%>
    <tr> 
		<th colspan=2 align=center>本月工作目标</th>
	</tr>
	<tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <!-- 完成事项 -->
	  <tr><td>
		<BUTTON Class=Btn type=button accessKey=A onclick="addRow1()"><U>A</U>-添加</BUTTON>
		<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow1()"><U>E</U>-删除</BUTTON>
		<br> </td>
      </tr>
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=5 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="20%"> <COL width="20%"><COL width="20%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>本月工作目标</td>
	        <td>达成结果</td>
	        <td>完成日期</td>
	        <td>权重指数</td>
	      </tr>
<%	boolean islight=true;
	RecordSet.executeProc("bill_monthinfodetail_SelectByType",""+billid+flag+"1");
	while(RecordSet.next()){
		String curworkname=RecordSet.getString("targetname");
		String curworkdesc=RecordSet.getString("targetresult");
		String curdate=RecordSet.getString("forecastdate");
		String curscale=RecordSet.getString("scale");
%>
		  <tr <%if(islight){%>class=datalight <%} else {%>class=datadark<%}%>>
		  <td><input type=checkbox name="check_type" value=<%=rowindex1%>></td>
		  <td><input type=input name="type_<%=rowindex1%>_name"> style=width:80% value=<%=Util.toScreenToEdit(curworkname,user.getLanguage())%></td>
		  <td><input type=input name="type_<%=rowindex1%>_name"> style=width:80% value=<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%></td>
		  <td><button class=Calendar onClick='getTheDate(type_<%=rowindex1%>_date,type_<%=rowindex1%>_datespan)'></button>
		  <span id=type_<%=rowindex1%>_datespan><%=curdate%></span>
		  <input type=hidden name=type_<%=rowindex1%>_date value="<%=curdate%>">
		  </td>
		  <td><input type=input name="type_<%=rowindex1%>_scale" style=width:80% 
		  value=<%=Util.toScreenToEdit(curworkdesc,user.getLanguage())%>
		  onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%</td>
		  </tr>
<%
		islight=!islight;
		rowindex1++;
	}
%>
	    </table>
	   </td></tr>
      </table>
      </td>
    </tr> 
	<%}%>
    </td>
  </tr>
  <tr><td height=15></td></tr>
  </table>
  </td>
  </tr>  
  </table><br>
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
 
<script language=javascript>
rowindex1 = <%=rowindex1%> ;
function addRow1()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' name='type_"+rowindex1+"_name' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' name='type_"+rowindex1+"_desc' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break; 
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Calendar onClick='getTheDate(type_"+rowindex1+"_date,type_"+rowindex1+"_datespan)'></button> " + 
        					"<span class=saveHistory id=type_"+rowindex1+"_datespan></span> "+
        					"<input type='hidden' name='type_"+rowindex1+"_date' id='type_"+rowindex1+"_date'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' name='type_"+rowindex1+"_scale' style='width=60%' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>%";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
		}
	}
	rowindex1 = rowindex1*1 +1;
}

function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_type');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable1.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
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

	function doRemark(){
		parastr = "<%=needcheck%>" ;
		
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		<% if(nodetype.equals("0")) {%>
		document.frmmain.nodesnum.value=rowindex1;
		<%}%>
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doSave(){
		parastr = "<%=needcheck%>" ;
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='save';
			<% if(nodetype.equals("0")) {%>
			document.frmmain.nodesnum.value=rowindex1;
			<%}%>
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
			<% if(nodetype.equals("0")) {%>
			document.frmmain.nodesnum.value=rowindex1;
			<%}%>
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
</body>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
</html>
