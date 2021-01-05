<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%	
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));


int userid=user.getUID();
String logintype = user.getLogintype();
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

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="";
int rowsum=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
%>
<form name="frmmain" method="post" action="BillCptCarFeeOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
 <input type=hidden name="formid" value=<%=formid%>>
<input type="hidden" value="0" name="nodesnum">
  <div> 
    <BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button> 
    <BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button> 
  </div>
  <br>
  <table class=form>
    <colgroup> <col width="15%"> <col width="85%">
    <tr class=separator> 
      <td class=Sep1 colspan=2></td>
    </tr>
    <tr>
      <td>说明</td>
      <td class=field> 
        <input type=text name="name" onChange="checkinput('name','namespan')" size=40 maxlength=25
        value="<%=Util.toScreenToEdit(workflowname+"-"+username+"-"+currentdate,user.getLanguage())%>">
        <span id=namespan></span> 
        <input type=radio value="0" name="requestlevel" checked>正常
        <input type=radio value="1" name="requestlevel">重要
        <input type=radio value="2" name="requestlevel">紧急 
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
  <table Class=ListShort cols=10 id="oTable"><COLGROUP>
      	
   <tr class=header> 
    	   <td  width="2%">选中</td>
    	   <td  width="13%">日期</td>    	   
    	   <td  width="10%">车号</td>
    	   <td  width="10%">驾驶员</td> 
    	   <td  width="10%">燃油费</td> 
    	   <td  width="10%">停车过桥费</td> 
    	   <td  width="10%">修理费</td> 
    	   <td  width="10%">电话费</td> 
    	   <td  width="10%">清洁费用</td> 
    	   <td  width="15%">备注</td> 
    	  </tr>
  </table>
  
  </tr>  
  <div>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-添加</BUTTON>
<BUTTON Class=Btn type=button accessKey=E onclick="deleteRow1();"><U>E</U>-删除</BUTTON></div>
    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="">
        <textarea name=remark rows=4 cols=40 style="width=80%;display:none" ></textarea>
<script defer>
function funcremark_log(){
	FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
	FCKEditorExt.toolbarExpand(false);
}
funcremark_log();
</script>
      </td>
    </tr>
    <tr><td class=Line2 colSpan=2></td></tr>  
    <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
  </table>
</form> <script language=javascript>
rowindex = "<%=rowsum%>";
needcheck = "<%=needcheck%>";
function addRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);  
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick='onShowDate(node_"+rowindex+"_datespan,node_"+rowindex+"_date)'></button> " + 
        					"<span class=saveHistory id=node_"+rowindex+"_datespan></span> "+
        					"<input type='hidden' name='node_"+rowindex+"_date' id='node_"+rowindex+"_date'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick='onShowAsset(node_"+rowindex+"_carnospan,node_"+rowindex+"_carno)'></button> " + 
        					"<span class=saveHistory id=node_"+rowindex+"_carnospan></span> "+
        					"<input type='hidden' name='node_"+rowindex+"_carno' id='node_"+rowindex+"_carno'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button class=Browser onClick='onShowResource(node_"+rowindex+"_driverspan,node_"+rowindex+"_driver)'></button> " + 
        					"<span class=saveHistory id=node_"+rowindex+"_driverspan></span> "+
        					"<input type='hidden' name='node_"+rowindex+"_driver' id='node_"+rowindex+"_driver'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' style=width:100%  name='node_"+rowindex+"_oilfee'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' style=width:100%  name='node_"+rowindex+"_bridgefee'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' style=width:100%  name='node_"+rowindex+"_fixfee'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' style=width:100%  name='node_"+rowindex+"_phonefee'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' style=width:100%  name='node_"+rowindex+"_cleanfee'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;								
			case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='text' name='node_"+rowindex+"_remax' style=width:100%>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv); 
				break;	
		}
	}
	rowindex = rowindex*1 +1;
	
}



function deleteRow1()
{
    var flag = false;
	var ids = document.getElementsByName('check_node');
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
                if (document.forms[0].elements[i].name=='check_node')
                    rowsum1 += 1;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_node'){
                    if(document.forms[0].elements[i].checked==true) {
                        oTable.deleteRow(rowsum1);
                    }
                    rowsum1 -=1;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
	
}	

	function doSave(){
		if(check_form(document.frmmain,needcheck)){
			document.frmmain.src.value='save';
			document.frmmain.nodesnum.value=rowindex;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,needcheck)){
			document.frmmain.src.value='submit';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			document.frmmain.nodesnum.value=rowindex;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	
</script>
<script language=vbs>

sub onShowDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub

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
</script>