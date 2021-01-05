<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
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
RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

String needcheck="requestname";
String resourceid="";
int rowindex=0;
%>
<form name="frmmain" method="post" action="BillHotelBookOperation.jsp">
<input type=hidden name=isremark >
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<input type="hidden" value="0" name="nodesnum">
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
<%if(isreopen.equals("1") && false){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}%>
<%if(nodetype.equals("0")){%>
<BUTTON class=btnDelete accessKey=D type=button onclick="if(isdel()){doDelete();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
<%}%><%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-返回</button>
</div>
  <table class=form>
    <colgroup> <col width="20%"> <col width="80%">  
    <TR class=separator> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    <tr>
      <td>说明</td>
      <td class=field> 
      <%=Util.toScreen(requestname,user.getLanguage())%> 
        <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span>
      <%if(requestlevel.equals("0")){%>正常 <%}%>
      <%if(requestlevel.equals("1")){%>重要 <%}%>
      <%if(requestlevel.equals("2")){%>紧急 <%}%>
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

RecordSet.executeProc("Bill_HotelBook_SelectByID",billid+"");
RecordSet.next();
resourceid=RecordSet.getString("resourceid");
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
	continue;
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
        <select name="field<%=fieldid%>1" size=1 DISABLED >
            <option value="0" <%if(fieldvalue.equals("0")){%> selected <%}%>>老三样</option>
            <option value="1" <%if(fieldvalue.equals("1")){%> selected <%}%>>自己支付</option>
            <option value="2" <%if(fieldvalue.equals("2")){%> selected <%}%>>公司全付</option>
        </select>
	    <input type= hidden name="field<%=fieldid%>" value=<%=fieldvalue%>>
        <%} else {%>
        <select name="field<%=fieldid%>" size=1>
            <option value="0" <%if(fieldvalue.equals("0")){%> selected <%}%>>老三样</option>
            <option value="1" <%if(fieldvalue.equals("1")){%> selected <%}%>>自己支付</option>
            <option value="2" <%if(fieldvalue.equals("2")){%> selected <%}%>>公司全付</option>
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

    RecordSet.executeProc("bill_HotelBookDetail_SByBooki",billid+"");
%>
    <tr>
    <td>宾馆预定详细信息</td>
    <td>&nbsp;</td>
    </tr>
    <tr class=Section> 
      <td colspan=2>
	  <table class=form>
	  <!-- 详细信息 -->
	<%if(nodetype.equals("0")){%>  
	  <tr><td>
		<BUTTON Class=Btn type=button accessKey=A onclick="addRow1()"><U>A</U>-添加</BUTTON>
		<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow1();"><U>E</U>-删除</BUTTON>
		<br> </td>
      </tr>
    <%}%>
      <TR class=separator>
    	  <TD class=Sep1></TD></TR>
	  <tr><td>
	    <table Class=ListShort cols=4 id="oTable1">
	      <COLGROUP> 
	      <COL width="10%"><COL width="35%"> <COL width="35%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td>宾馆名称</td>
	        <td>房型</td>
	        <td>房间数</td>
	      </tr>
<%
    if(!nodetype.equals("0")){
        boolean islight=true;
        while(RecordSet.next()){
            String curhotelid=RecordSet.getString("hotelid");
            String curroomstyle=RecordSet.getString("roomstyle");
            String curroomsum=RecordSet.getString("roomsum");
            String curhotelname=CustomerInfoComInfo.getCustomerInfoname(curhotelid);
%>
          <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td>&nbsp;</td>
            <td><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=curhotelid%>"><%=Util.toScreen(curhotelname,user.getLanguage())%></a></td>
            <td><%=Util.toScreen(curroomstyle,user.getLanguage())%></td>
            <td><%=Util.toScreen(curroomsum,user.getLanguage())%></td>
          </tr>
<%
            islight=!islight;
        }
    } else {    
            boolean islight=true;
            while(RecordSet.next()){
            String curhotelid=RecordSet.getString("hotelid");
            String curroomstyle=RecordSet.getString("roomstyle");
            String curroomsum=RecordSet.getString("roomsum");
            String curhotelname=CustomerInfoComInfo.getCustomerInfoname(curhotelid);
%>
          <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><input type='checkbox' name='check_type' value='<%=rowindex%>'></td>
            <td>
            <button class=browser onclick=onShowHotel(hotelid_<%=rowindex%>,hotelspan_<%=rowindex%>)></button>
            <span id="hotelspan_<%=rowindex%>"><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=curhotelid%>"><%=Util.toScreen(curhotelname,user.getLanguage())%></a></span>
            <input type=hidden name="hotelid_<%=rowindex%>" value="<%=curhotelid%>">
            </td>
            <td><input type=text name="roomstyle_<%=rowindex%>" 
            value="<%=Util.toScreenToEdit(curroomstyle,user.getLanguage())%>"></td>
            <td><input type=text name="roomsum_<%=rowindex%>" onKeyPress="ItemCount_KeyPress()" value="<%=Util.toScreenToEdit(curroomsum,user.getLanguage())%>"
            onBlur="checkcount1(this)">
			</td>
          </tr>
<%
            islight=!islight;
            rowindex++;
        }    
    }%>  
    </table>
  </td></tr>  
  </table><br>
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>
 
<script language=javascript>
rowindex1 = <%=rowindex%> ;

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
				var sHtml = "<button class=browser name='hotel_"+rowindex1+"_browser' "+
				        " onclick=onShowHotel(hotelid_"+rowindex1+",hotelspan_"+rowindex1+")>"+
				        " </button> <input type=hidden name='hotelid_"+rowindex1+"'> "+
				        " <span id='hotelspan_"+rowindex1+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' name='roomstyle_"+rowindex1+"' style='width=80%'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break; 
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<nobr><input type='text' style=width:50%  id='roomsum_"+rowindex1+"' name='roomsum_"+
				rowindex1+"' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>";
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

	function doRemark(){
		parastr = "<%=needcheck%>" ;
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.frmmain.nodesnum.value=rowindex1;
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
    	len = document.forms[0].elements.length;
    	var i=0;
    	var rowsum1 = 0;
    	for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=='check_type')
    			parastr+=",hotelid_"+document.forms[0].elements[i].value;
    	}
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='save';
			document.frmmain.nodesnum.value=rowindex1;
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
		len = document.forms[0].elements.length;
    	var i=0;
    	var rowsum1 = 0;
    	for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=='check_type')
    			parastr+=",hotelid_"+document.forms[0].elements[i].value;
    	}
		if(check_form(document.frmmain,parastr)){
			document.frmmain.src.value='submit';
			document.frmmain.nodesnum.value=rowindex1;
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
		document.frmmain.nodesnum.value=rowindex1;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
        if(onSetRejectNode()){
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}
	function doReopen(){
		document.frmmain.src.value='reopen';
		document.frmmain.nodesnum.value=rowindex1;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
		document.frmmain.src.value='delete';
		document.frmmain.nodesnum.value=rowindex1;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
</script>
<script language=vbs>
sub onShowHotel(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
	inputname.value=""
	end if
	end if
end sub
</script>
</body>
</html>
