<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%	//      check user's right about current request operate

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
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
if(RecordSet.next()){
	isremark=1;
}

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

String needcheck="name";
%>

<form name="frmmain" method="post" action="BillCptCarFeeOperation.jsp">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<input type=hidden name=isremark >
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


<%if(!nodetype.equals("0")){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-返回</button>
</div>
  <br>
  <table class=form>
    <colgroup> <col width="15%"> <col width="85%">
    <tr class=separator> 
      <td class=Sep1 colspan=4></td>
    </tr>
    <tr>
      <td>说明</td>
      <td class=field> 
      <%=Util.toScreen(requestname,user.getLanguage())%> 
        <input type=hidden name=name value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span>
      <%if(requestlevel.equals("0")){%>正常 <%}%>
      <%if(requestlevel.equals("1")){%>重要 <%}%>
      <%if(requestlevel.equals("2")){%>紧急 <%}%>
      </span>
      </td>
    </tr>
    <tr><td>&nbsp</td></tr>
<TR class=Section>
    	  <TH colSpan=2>
    	  国际战略投资有限公司行政管理部车辆费用报销单
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
 <table Class=ListShort cols=9 id="oTable"><COLGROUP>
      	
   <tr class=header> 
    	    <td  width="15%">日期</td>    	   
    	   <td  width="10%">车号</td>
    	   <td  width="10%">驾驶员</td> 
    	   <td  width="10%">燃油费</td> 
    	   <td  width="10%">停车过桥费</td> 
    	   <td  width="10%">修理费</td> 
    	   <td  width="10%">电话费</td> 
    	   <td  width="10%">清洁费用</td> 
    	   <td  width="15%">备注</td> 
            </tr>
             <%
          int linecolor=0;  
          int rowindex = 0;
        String sql = " select * from bill_CptCarFee where requestid ="+requestid;
        RecordSet.executeSql(sql);
        while(RecordSet.next()){
        %> 
 <% if(!nodetype.equals("0")){%>
 
          
    <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
         <td><%=RecordSet.getString("usedate")%></td>
        
    <td><a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("carno")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("carno")),user.getLanguage())%> </a></td>
     <td><a href="javaScript:openhrm(<%=RecordSet.getString("driver")%>);" onclick='pointerXY(event);'> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("driver")),user.getLanguage())%></a></td>
    
     <td><%=RecordSet.getString("oilfee")%></td>
         <td><%=RecordSet.getString("bridgefee")%></td>
         <td><%=RecordSet.getString("fixfee")%></td>
         <td><%=RecordSet.getString("phonefee")%></td>
         <td><%=RecordSet.getString("cleanfee")%></td>
         <td><%=RecordSet.getString("remax")%></td> 
 <%}else{%>  
 <input type="hidden" name = node_<%=rowindex%>_id value="<%=RecordSet.getString("id")%>">
     <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
         <td>
         <button class=Browser onClick='getDate(node_<%=rowindex%>_datespan,node_<%=rowindex%>_date)'></button> 
         <span class=saveHistory id=node_<%=rowindex%>_datespan><%=RecordSet.getString("usedate")%></span> 
    	<input type='hidden' name='node_<%=rowindex%>_date' id='node_<%=rowindex%>_date' value="<%=RecordSet.getString("usedate")%>" ></td>
        
         <td>
         <button class=Browser onClick='onShowResource(node_<%=rowindex%>_driverspan,node_<%=rowindex%>_driver)'></button>
	<span class=saveHistory id=node_<%=rowindex%>_driverspan><a href="javaScript:openhrm(<%=RecordSet.getString("driver")%>);" onclick='pointerXY(event);'> 
              <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("driver")),user.getLanguage())%></a></span> 
	<input type='hidden' name='node_<%=rowindex%>_driver' id='node_<%=rowindex%>_driver' value="<%=RecordSet.getString("driver")%>">
         </td>
    <td>
    <button class=Browser onClick='onShowAsset(node_<%=rowindex%>_carnospan,node_<%=rowindex%>_carno)'></button> 
	<span class=saveHistory id=node_<%=rowindex%>_carnospan><a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("carno")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("carno")),user.getLanguage())%> </a></span> 
	<input type='hidden' name='node_<%=rowindex%>_carno' id='node_<%=rowindex%>_carno' value="<%=RecordSet.getString("carno")%>">
    </td>
     
     <td><input type='text' style=width:100%  name='node_<%=rowindex%>_oilfee' value="<%=RecordSet.getString("oilfee")%>"></td>
     <td><input type='text' style=width:100%  name='node_<%=rowindex%>_bridgefee' value="<%=RecordSet.getString("bridgefee")%>"></td>
     <td><input type='text' style=width:100%  name='node_<%=rowindex%>_fixfee' value="<%=RecordSet.getString("fixfee")%>"></td>
     <td><input type='text' style=width:100%  name='node_<%=rowindex%>_phonefee'  value="<%=RecordSet.getString("phonefee")%>"></td>
     <td><input type='text' style=width:100%  name='node_<%=rowindex%>_cleanfee'  value="<%=RecordSet.getString("cleanfee")%>"></td>
         
     
    	<td><input type='text' name='node_<%=rowindex%>_remax' style=width:100% value="<%=RecordSet.getString("remax")%>"></td>
        
         <%}%>
</tr>
<%
rowindex ++;}%>
  </table>
  </tr>  
  
<input type="hidden" name="nodesnum" value=<%=rowindex%>>
  </tr>  
  </table>
  <br>
 <%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<script language=vbs>
sub onShowTime(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub

sub onShowResource(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowDepartment(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
	else
		spanname.innerHtml = ""
		inputname.value=""
	end if
	end if
end sub

sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2' and capitalgroupid=9 ")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
		spanname.innerHtml = ""
		inputname.value=""
		end if
	end if
end sub
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub
</script>   
</form>
<script language=javascript>

function changenumber(rowval){
	document.all("node_"+rowval+"_number").innerHTML = (document.all("node_"+rowval+"_endnumber").value)/1.0 - (document.all("node_"+rowval+"_beginnumber").value)/1.0;
	
}
	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='save';
//			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='submit';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
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
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
