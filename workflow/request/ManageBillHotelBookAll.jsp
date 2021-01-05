<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdPRMWorkFlow_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1027,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%	//      check user's right about current request operate
String workflowid=Util.fromScreen(request.getParameter("workflowid"),user.getLanguage());
String logintype = user.getLogintype();

String requestid="";
String requestname="";
String requestlevel="";
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

String sqlStr="";
char flag=Util.getSeparator() ;

RecordSet.executeSql("select * from workflow_currentoperator where workflowid="+workflowid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;
RecordSet.executeSql("select * from workflow_currentoperator where workflowid="+workflowid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next())	isremark=1;

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

ArrayList requestids=new ArrayList();
sqlStr="select * from workflow_Requestbase where workflowid=" + workflowid +" and currentnodetype='2' and deleted=0";
RecordSet.executeSql(sqlStr);
while(RecordSet.next()){
    requestids.add(RecordSet.getString("requestid"));
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
String submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String datestr=CurrentDate.substring(0,4)+CurrentDate.substring(5,7)+CurrentDate.substring(8,10);

String needcheck="requestname";
int rowindex=0;
%>
<form name="frmmain" method="post" action="BillHotelBookAllOperation.jsp">
<input type=hidden name=isremark >
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="src">
<input type=hidden name="iscreate" value="0">
<div>
<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
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
<table class="viewform" border=1>
<tr><td>
<%  
for(int i=0;i<requestids.size();i++){
    rowindex=0;
    String resourceid="";
    String departmentid="";
    String begindate="";
    String enddate="";
    String payterm="";
    String liveperson="";
    String amount="";
    
    requestid=(String) requestids.get(i);
    //~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
    RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
    if(RecordSet.next()){	
    	nodeid=RecordSet.getInt("currentnodeid");
    	nodetype=RecordSet.getString("currentnodetype");
    	requestname=RecordSet.getString("requestname");
    	status=RecordSet.getString("status");
    	creater=RecordSet.getInt("creater");
    	creatertype = RecordSet.getInt("creatertype");	
    	requestlevel=RecordSet.getString("requestlevel");
    }
    RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
    RecordSet.next();
    formid=RecordSet.getInt("billformid");
    billid=RecordSet.getInt("billid");
    
    RecordSet.executeProc("Bill_HotelBook_SelectByID",billid+"");
    RecordSet.next();
    resourceid=RecordSet.getString("resourceid");
    departmentid=RecordSet.getString("departmentid");
    begindate=RecordSet.getString("begindate");
    enddate=RecordSet.getString("enddate");
    payterm=RecordSet.getString("payterm");
    liveperson=RecordSet.getString("liveperson");
    amount=RecordSet.getString("amount");
%>
    <input type=hidden name="nodeid<%=requestid%>" value="<%=nodeid%>">
    <input type=hidden name="nodetype<%=requestid%>" value="<%=nodetype%>">
    <table class="viewform">
    <col width=5%><col width=15%><col width=30%><col width=15%><col width=35%>
    <tr><td colspan=5 height=10 bgcolor="f0f0bd"></td></tr> 
    <tr>
        <td ><input type=checkbox name="requestids" value=<%=requestid%>></td>
        <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
        <td class=field><%=Util.toScreen(requestname,user.getLanguage())%>
        &nbsp;&nbsp;&nbsp;&nbsp;
      <span>
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      </span>
        </td>
        <td><%=SystemEnv.getHtmlLabelName(16318,user.getLanguage())%></td>
        <td class=field><%=datestr%><%=Util.add0(Util.getIntValue(requestid),5)%></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td ><%=SystemEnv.getHtmlLabelName(368,user.getLanguage())%></td>
        <td class=field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></td> 
        <td><%=SystemEnv.getHtmlLabelName(6141,user.getLanguage())%></td>
        <td class=field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></td> 
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td ><%=SystemEnv.getHtmlLabelName(1028,user.getLanguage())%></td>
        <td class=field>
        <button class=calendar onclick=getDate(begindatespan_<%=requestid%>,begindate_<%=requestid%>)></button>
        <span id='begindatespan_<%=requestid%>'><%=begindate%></span>
        <input type=hidden name="begindate_<%=requestid%>" value="<%=begindate%>">
        </td> 
        <td><%=SystemEnv.getHtmlLabelName(1029,user.getLanguage())%></td>
        <td class=field>
        <button class=calendar onclick=getDate(enddatespan_<%=requestid%>,enddate_<%=requestid%>)></button>
        <span id='enddatespan_<%=requestid%>'><%=enddate%></span>
        <input type=hidden name="enddate_<%=requestid%>" value="<%=enddate%>">
        </td> 
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td ><%=SystemEnv.getHtmlLabelName(577,user.getLanguage())%></td>
        <td class=field>
        <select class=inputstyle  size=1 name="payterm_<%=requestid%>">
            <option value="0" <%if(payterm.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16319,user.getLanguage())%></option>
            <option value="1" <%if(payterm.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16320,user.getLanguage())%></option>
            <option value="2" <%if(payterm.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16321,user.getLanguage())%></option>
        </select>
        </td> 
        <td><%=SystemEnv.getHtmlLabelName(1030,user.getLanguage())%></td>
        <td class=field>
        <input type=text class=inputstyle  name="liveperson_<%=requestid%>" value="<%=Util.toScreenToEdit(liveperson,user.getLanguage())%>">
        </td> 
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td><%=SystemEnv.getHtmlLabelName(16322,user.getLanguage())%></td>
        <td colspan=3><input type=text class=inputstyle  name="amount_<%=requestid%>" value="<%=Util.toScreenToEdit(amount,user.getLanguage())%>"
        onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);checkinput('amount_<%=requestid%>','amountspan_<%=requestid%>')">
        <span id="amountspan_<%=requestid%>"><%if(amount.equals("")){%>
        <img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span></td>
    </tr>
<%  RecordSet.executeProc("bill_HotelBookDetail_SByBooki",billid+"");%>
    <tr>
    <td colspan=2><%=SystemEnv.getHtmlLabelName(16323,user.getLanguage())%></td>
    <td colspan=3>&nbsp;</td>
    </tr>
    <tr class="Title"> 
      <td colspan=5>
	  <table class="viewform">
	  <!-- 详细信息 -->  
	  <tr><td>
		<BUTTON Class=Btn type=button accessKey=A onclick="addRow<%=requestid%>()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow<%=requestid%>();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
		<br> </td>
      </tr>
      <TR class="Spacing">
    	  <TD class="Line1"></TD></TR>
	  <tr><td>
	    <table class=liststyle cellspacing=1   cols=4 id="oTable<%=requestid%>">
	      <COLGROUP> 
	      <COL width="10%"><COL width="35%"> <COL width="35%"><COL width="20%">
	      <tr class=header> 
	        <td>&nbsp;</td>
	        <td><%=SystemEnv.getHtmlLabelName(16324,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16325,user.getLanguage())%></td>
	        <td><%=SystemEnv.getHtmlLabelName(16326,user.getLanguage())%></td>
	      </tr>
<%
          boolean islight=true;
          while(RecordSet.next()){
              String curhotelid=RecordSet.getString("hotelid");
              String curroomstyle=RecordSet.getString("roomstyle");
              String curroomsum=RecordSet.getString("roomsum");
              String curhotelname=CustomerInfoComInfo.getCustomerInfoname(curhotelid);
%>
          <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td><input type='checkbox' name='check_type_<%=requestid%>' value='0'></td>
            <td>
            <button class=browser onclick=onShowHotel(hotelid_<%=rowindex%>_<%=requestid%>,hotelspan_<%=rowindex%>_<%=requestid%>)></button>
            <span id="hotelspan_<%=rowindex%>_<%=requestid%>"><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=curhotelid%>"><%=Util.toScreen(curhotelname,user.getLanguage())%></a></span>
            <input type=hidden name="hotelid_<%=rowindex%>_<%=requestid%>" value="<%=curhotelid%>">
            </td>
            <td><input type=text class=inputstyle  name="roomstyle_<%=rowindex%>_<%=requestid%>" 
            value="<%=Util.toScreenToEdit(curroomstyle,user.getLanguage())%>"></td>
            <td><input type=text class=inputstyle  name="roomsum_<%=rowindex%>_<%=requestid%>" onKeyPress="ItemCount_KeyPress()" value="<%=Util.toScreenToEdit(curroomsum,user.getLanguage())%>"
            onBlur="checkcount1(this)">
			</td>
          </tr>
<%
                islight=!islight;
                rowindex++;
            }    
%> 
    </table>
    </td></tr>
    <input type=hidden name="nodesnum<%=requestid%>" value="<%=rowindex%>">  
    </table>
<script language=javascript>
rowindex<%=requestid%> = <%=rowindex%> ;

function addRow<%=requestid%>()
{	
	ncol = oTable<%=requestid%>.cols;
	oRow = oTable<%=requestid%>.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type_<%=requestid%>' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=browser name='hotel_"+rowindex<%=requestid%>+"_browser' "+
				        " onclick=onShowHotel(hotelid_"+rowindex<%=requestid%>+"_<%=requestid%>,hotelspan_"+rowindex<%=requestid%>+"_<%=requestid%>)>"+
				        " </button> <input type=hidden name='hotelid_"+rowindex<%=requestid%>+"_<%=requestid%>'> "+
				        " <span id='hotelspan_"+rowindex<%=requestid%>+"_<%=requestid%>'></span>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' name='roomstyle_"+rowindex<%=requestid%>+"_<%=requestid%>'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break; 
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<nobr><input type='text'  id='roomsum_"+rowindex<%=requestid%>+"_<%=requestid%>' name='roomsum_"+
				rowindex<%=requestid%>+"_<%=requestid%>' onKeyPress='ItemCount_KeyPress()' onBlur='checkcount1(this)'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv); 
				break;  
		}
	}
	rowindex<%=requestid%> = rowindex<%=requestid%>*1 +1;
	frmmain.nodesnum<%=requestid%>.value=rowindex<%=requestid%> ;
	
}

function deleteRow<%=requestid%>()
{
	var flag = false;
	var ids = document.getElementsByName('check_type_<%=requestid%>');
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
                if (document.forms[0].elements[i].name=='check_type_<%=requestid%>')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_type_<%=requestid%>'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable<%=requestid%>.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
</script>
<%}%>
</td></tr>
</table>
</form>
 
<script>
	function doSave(){
		len = document.forms[0].elements.length;
    	var i=0;
    	var isselected=false;
    	for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=='requestids')
    			if(document.forms[0].elements[i].checked)
    			    isselected=true;
    	}
    	if(!isselected){
    	    alert("<%=SystemEnv.getHtmlLabelName(16327,user.getLanguage())%>");
    	    return;
    	}    
		else{
			document.frmmain.src.value='save';
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		len = document.forms[0].elements.length;
    	var i=0;
    	var isselected=false;
    	for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=='requestids')
    			if(document.forms[0].elements[i].checked)
    			    isselected=true;
    	}
    	if(!isselected){
    	    alert("<%=SystemEnv.getHtmlLabelName(16327,user.getLanguage())%>");
    	    return;
    	}  
		else{
			document.frmmain.src.value='submit';
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doDelete(){
		document.frmmain.src.value='delete';
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
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>