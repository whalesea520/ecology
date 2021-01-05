<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>

<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery.js"></script>
</head>
<%
String hasReportItem = Util.null2String(request.getParameter("hasReportItem"));
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
rs.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
rs.next() ;

String inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(rs.getString("inpreptablename")) ;
String inprepbugtablename = Util.null2String(rs.getString("inprepbugtablename")) ;
String inprepfrequence = Util.null2String(rs.getString("inprepfrequence")) ;
String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
String inprepbudgetstatus = Util.null2String(rs.getString("inprepbudgetstatus")) ;
String inprepforecast = Util.null2String(rs.getString("inprepforecast")) ;
String startdate = Util.null2String(rs.getString("startdate")) ;
String enddate = Util.null2String(rs.getString("enddate")) ;
String modulefilename = Util.toScreenToEdit(rs.getString("modulefilename"),user.getLanguage()) ;  //模板文件名称
int helpdocid = Util.getIntValue(rs.getString("helpdocid"),0) ;  //帮助文档

String isInputMultiLine = Util.null2String(rs.getString("isInputMultiLine")) ;
int billId = Util.getIntValue(rs.getString("billId"),0) ;  //单据id

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15184,user.getLanguage()) +"：" +inprepname;
String needfav ="1";
String needhelp ="";
//String subnames1 = "关闭预算输入";
//String subnames2 = "打开预算输入";

%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",InputReportAdd.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<% if(inprepbudget.equals("1")) {%>
<% if(inprepbudgetstatus.equals("1")) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16618,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%} else {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16619,user.getLanguage())+",javascript:onOpen(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%}}%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<%
String hasInputReportItemType="false";
rs.executeSql("select itemTypeId from T_InputReportItemType where inprepId="+inprepid);
if(rs.next()){
	hasInputReportItemType="true";
}
%>
<iframe width="0" height="0" src="about:blank" id="uploadFrm" name="uploadFrm"></iframe>
<form action="saveCustomeTemplate.jsp" name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" target="uploadFrm">
<div id="fileDiv" style="position:absolute;display:none;width:80%;">
<input type="file" class="InputStyle" size="50" name="customTemplate" id="customTemplate" />
<%
//inprepbugtablename
String userTemplateName="User_"+inpreptablename/*getTableNameByInprepId(inprepId)*/+"0";
String sTmp=getExistUserExcelTemplate(userTemplateName);
if(sTmp!=null)out.print("<a href=\"/datacenter/inputexcellfile/"+sTmp+"\" target=\"_blank\">"+sTmp+"</a>");
%>
<input type="hidden" name="fileName" value="<%=userTemplateName%>" />
</div>
</form>
<form id=weaver name=frmMain action="InputReportOperation.jsp" method=post>



<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<table class=Shadow>
		<tr>
		<td valign="top">
<%if(hasReportItem.equals("1")){%>
		    <span style="COLOR: RED"><%=SystemEnv.getHtmlLabelName(20806,user.getLanguage())%></span> 
<%}%>


<table class=viewform>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <tbody>
  <tr class=title>
      <th colSpan=2><%=SystemEnv.getHtmlLabelName(20787,user.getLanguage())%></th>
    </tr>
  <TR class=Spacing style="height: 1px">
    <td class=line1 colSpan=2 ></td></tr>
  <tr>
          <td><%=SystemEnv.getHtmlLabelName(15185,user.getLanguage())%></td>
          <td class=Field><input type=text class="InputStyle" size=50 name="inprepname" onchange='checkinput("inprepname","inprepnameimage")' value="<%=inprepname%>"> 
          <span id=inprepnameimage></span></td>
        </tr>  <TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></td>
          <td class=Field><%=inpreptablename%></td>
        </tr> <TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
<!--
		<% if(inprepbudget.equals("1")) { %>
		<TR>
          <TD>数据库预算表名</TD>
          <TD class=Field><%=inprepbugtablename%></TD>
        </TR> <TR class=Spacing style="height: 1px">
    <TD class=line colSpan=2 ></TD></TR>
		<%}%>
        <% if(inprepforecast.equals("1")) { %>
		<TR>
          <TD>数据库预测表名</TD>
          <TD class=Field><%=inpreptablename%>_forecast</TD>
        </TR> <TR class=Spacing style="height: 1px">
    <TD class=line colSpan=2 ></TD></TR>
		<%}%>
-->
        <tr> 
      <td><%=SystemEnv.getHtmlLabelName(18776,user.getLanguage())%></td>
      <td class=Field>
         <select class="InputStyle" name="inprepfrequence">
          <option value="0" <% if(inprepfrequence.equals("0")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%></option>
		  <option value="1" <% if(inprepfrequence.equals("1")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(20616,user.getLanguage())%></option>
          <option value="6" <% if(inprepfrequence.equals("6")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(20729,user.getLanguage())%></option>
		  <option value="7" <% if(inprepfrequence.equals("7")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
          <option value="2" <% if(inprepfrequence.equals("2")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(20617,user.getLanguage())%></option>
		  <option value="3" <% if(inprepfrequence.equals("3")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(20618,user.getLanguage())%></option>
		  <option value="4" <% if(inprepfrequence.equals("4")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(20619,user.getLanguage())%></option>
		  <option value="5" <% if(inprepfrequence.equals("5")) { %> selected <%}%>><%=SystemEnv.getHtmlLabelName(20620,user.getLanguage())%></option>
         </select>
      </td>
    </tr> <TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
<!--
    <TR> 
      <TD>有否预算</TD>
      <TD class=FIELD> 
      <input type="checkbox" name="inprepbudget" value="1" <% if(inprepbudget.equals("1")) { %> checked<%}%>>
      </TD>
    </TR> <TR class=Spacing style="height: 1px">
    <TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD>有否预测</TD>
      <TD class=FIELD> 
      <input type="checkbox" name="inprepforecast" value="1" <% if(inprepforecast.equals("1")) { %> checked<%}%>>
      </TD>
    </TR> <TR class=Spacing style="height: 1px">
    <TD class=line colSpan=2 ></TD></TR>
-->
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(20612,user.getLanguage())%></td>
      <td class=FIELD> 
      <input type="hidden" name="isInputMultiLine" value="<%=isInputMultiLine%>">
<%if("1".equals(isInputMultiLine)){%>
        <%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
<%}else{%>
        <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
<%}%>
      </td>
    </tr> <TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(20788,user.getLanguage())%></td>
      <td class=FIELD> 
        <button class=Calendar type="button" onClick="getDate(startdatespan, startdate)"></button> 
              <span id=startdatespan style="FONT-SIZE: x-small"><%=startdate%></span> 
              <input type="hidden" name="startdate" id="startdate" value="<%=startdate%>">
      </td>
    </tr> <TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(20789,user.getLanguage())%></td>
      <td class=FIELD> 
        <button class=Calendar type="button" onClick="getDate(enddatespan, enddate)"></button> 
              <span id=enddatespan style="FONT-SIZE: x-small"><%=enddate%></span> 
              <input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
      </td>
    </tr> <TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(20719,user.getLanguage())%></td>
      <td class=Field><input type=text class=inputstyle size=50 name="modulefilename" value="<%=modulefilename%>"></td>
    </tr>
	<TR class=Spacing style="height: 1px"><td class=line colSpan=2 ></td></tr>
	<tr><td><%=SystemEnv.getHtmlLabelName(73,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())%><!--自定义模板--></td><td class="Field" id="customExcel"></td></tr>
	<TR class=Spacing style="height: 1px"><td class=line colSpan=2 ></td></tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></td>
      <td class=FIELD> 
      
        <%
        String docName="";
        if(helpdocid!=0){
        	docName = "<a href='/docs/docs/DocDsp.jsp?id="+helpdocid+">"+Util.toScreen(DocComInfo.getDocname(""+helpdocid),user.getLanguage())+"</a>";
        }%>   
 
        
        <input class=wuiBrowser _displayText="<%=docName %>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" type=hidden name="helpdocid" size="80" value="<%=helpdocid%>">
      </td>
    </tr><TR class=Spacing style="height: 1px">
    <td class=line colSpan=2 ></td></tr>
	<tr class=title>
      <td ><b><%=SystemEnv.getHtmlLabelName(15199,user.getLanguage())%></b></td>
      <td align=right colspan=2 >
	  <button type="button" class=btn accessKey=T onClick="location.href='InputReportItemtypeAdd.jsp?inprepid=<%=inprepid%>'"><u>T</u>-<%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></button>
	  <button type="button" class=btn style="width: 135px!important;" accessKey=M onClick="location.href='InputReportItemtypeMultiEdit.jsp?inprepid=<%=inprepid%>'"><u>M</u>-<%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage())%></button>	  
	  <button type="button" class=btn accessKey=I onClick="javascript:OnAddItem()"><u>I</u>-<%=SystemEnv.getHtmlLabelName(15200,user.getLanguage())%></button>
	  <button type="button" class=btn accessKey=B onClick="javascript:OnMultiEditItem()"><u>B</u>-<%=SystemEnv.getHtmlLabelName(15200,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage())%></button>
      <button type="button" class=btn accessKey=S onClick="location.href='InputReportItemClose.jsp?inprepid=<%=inprepid%>'"><u>S</u>-<%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%></button>
      </td>
    </tr>
	<TR class=Spacing style="height: 1px">
    <td class=line1 colSpan=2 ></td></tr>
        <input type="hidden" name=operation>
        <input type="hidden" name=oldinprepbudget value="<%=inprepbudget%>">
        <input type="hidden" name=oldinprepforecast value="<%=inprepforecast%>">
        <input type="hidden" name=inpreptablename value="<%=inpreptablename%>">
		<input type=hidden name=inprepid value="<%=inprepid%>">
		<input type=hidden name=billId value="<%=billId%>">
 </TBODY></table>
  <br>
  <table class=liststyle cellspacing=1 >
  <colgroup>
  <col width="25%">
  <col width="25%">
  <col width="10%">
  <col width="15%">
  <col width="20%">
  <col width="5%">
    <tbody>
	<%
	int waittime = 0;
	String getItemtypeJsStr = "";
	rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
	while(rs.next()) {
		String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
		String itemtypename = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
		getItemtypeJsStr += ("window.setTimeout(function(){getItemtypeJs('"+itemtypeid+"','"+(new sun.misc.BASE64Encoder().encode(itemtypename.getBytes()))+"');},"+(200*(waittime++))+");" + "\n");
	%>
	<tr><td colspan="6"><div id="itemtypediv_<%=itemtypeid%>"><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></div></td></tr>
	<%}%>
    </tbody>
  </table>
  <br>
  <table class=liststyle cellspacing=1 >
    <colgroup> <col width="90%"> <col width="10%"> 
    <tbody> 
    <tr class=header> 
      <td><b><%=SystemEnv.getHtmlLabelName(20793,user.getLanguage())%></b></td>
      <td align=right> <button t class=btn accesskey=A onClick="onShowResourceID()"><u>A</u>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%></button> 
      </td>
    </tr><tr class=Line><td colspan="2" ></td></tr> 
    <% 
	this.rs=rs;
	this.req=request;
	String hrmIdString="";
	List list1=this.getCanInputHrm(inprepid);
	Map map1=null;
	int iSizes=list1.size();
	for(int i=0;i<iSizes;i++){
		map1=(Map)list1.get(i);
		hrmIdString+=map1.get("hrmId").toString();
		hrmIdString+=(i!=iSizes-1)?",":"";
  	%>
    <tr class=datadark>
      <td><a href="InReportHrmSecurity.jsp?id=<%=map1.get("id")%>&inprepid=<%=inprepid%>"><%=resourceComInfo.getLastname(map1.get("hrmId").toString())%></a></td>
      <td><a href="javascript:delHrm(<%=map1.get("id")%>);"><img border="0" src="/images/icon_delete.gif"></a></td>
    </tr>
    <%}%>
    </tbody> 
  </table>
</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>

</body></html>
<script language=javascript>
String.prototype.endsWith=function(suffix){
	return this.substring(this.length-suffix.length).toLowerCase()==suffix.toLowerCase();
}

 function onSave(obj){
	if(check_form(document.frmMain,'inprepname')){
		var xslFname=document.getElementById("customTemplate").value;
		obj.disabled=true;
	 	document.frmMain.operation.value="edit";
		if(xslFname!=""){
			if(!xslFname.endsWith(".xls")){
				alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
				obj.disabled=false;
				return ;
			}
			//设置监控自定义模板文件上传。
			var frmDoc=document.getElementById("uploadFrm");
			frmDoc.attachEvent("onreadystatechange",function(){
				if(frmDoc.readyState=="complete"){
					document.frmMain.submit();
				}//End if.
			});
			document.fileForm.submit();//上传模板文件
		}else document.frmMain.submit();
		
	}
 }

function getItemtypeJs(itemtypeid,itemtypename){
	jQuery.ajax({
		url : "/datacenter/maintenance/inputreport/InputReportEditAjax.jsp",
		type : "post",
		processData : false,
		data : "languageid=<%=user.getLanguage()%>&itemtypeid="+itemtypeid+"&itemtypename="+itemtypename,
		dataType : "html",
		success: function do4Success(msg){
			
			document.getElementById("itemtypediv_"+itemtypeid).innerHTML = msg;//其中第2个fieldid，只是用来区分当前字段是主字段还是明细字段，所以在这里用fieldid代替
		}
	});


}

var isfirsttime = 1;
function _initFileInput(){
	function _getPosition(o){
		var p1= o.offsetLeft,p2= o.offsetTop;
		do {
			o = o.offsetParent;
			p1 += o.offsetLeft;
			p2 += o.offsetTop;
		}while( o.tagName.toLowerCase()!="body");
		return {"x":p1,"y":p2};
	}
	var pos=_getPosition(document.getElementById('customExcel'));
	var oDiv=document.getElementById("fileDiv");
	oDiv.style.left=pos.x+"px";
	oDiv.style.top=pos.y+"px";
	//oDiv.style.width="70%";
	oDiv.style.display="inline";
	
	if(isfirsttime == 1){
		try{
		<%=getItemtypeJsStr%>
		}catch(e){alert(e)}
	}
	isfirsttime = 0;
}
//window.attachEvent('onload',_initFileInput);
//window.attachEvent('onresize',_initFileInput);

jQuery(window).bind("resize",_initFileInput);
jQuery(document).ready(function(){_initFileInput();})
 
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}

function onClose(){
			document.frmMain.operation.value="close";
			document.frmMain.submit();
}
function onOpen(){
			document.frmMain.operation.value="open";
			document.frmMain.submit();
}
function delHrm(id){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
		var sUrl="InReportHrmSecurity.jsp?action=delHrm&inprepid=<%=inprepid%>&id="+id;
		window.location.href=sUrl;
	}
}

function OnAddItem(){
	if(<%=hasInputReportItemType%>){
		var sUrl="InputReportItemAdd.jsp?inprepid=<%=inprepid%>";
		window.location.href=sUrl;
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(20857,user.getLanguage())%>");
	}
}

function OnMultiEditItem(){
	if(<%=hasInputReportItemType%>){
		var sUrl="InputReportItemMultiEdit.jsp?inprepid=<%=inprepid%>";
		window.location.href=sUrl;
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(20857,user.getLanguage())%>");
	}
}


</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

<script language="vbscript" type="text/vbscript">
Sub onShowResourceID()
	Dim url,id,oldHrmIds
	oldHrmIds="<%=hrmIdString%>"
	//url="/hrm/resource/browser/hire/MutiResourceBrowser.jsp?resourceids=" & oldHrmIds
	url="/hrm/resource/MutiResourceBrowser.jsp?resourceids=" & oldHrmIds
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" & url)
	If IsEmpty(id) Then Exit Sub
	If id(0)<> "" Then
		window.location.href="InReportHrmSecurity.jsp?action=addHrm&inprepid=<%=inprepid%>&hrmIds=" & id(0) & "&oldHrmIds=" & oldHrmIds
	End If
End Sub

sub getDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
		inputname.value= returndate
		spanname.innerHtml = returndate
    else 
        inputname.value= ""
		spanname.innerHtml = ""
	end if
end sub

sub onShowCustomer()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		window.location = "InputReportOperation.jsp?operation=addcrm&inprepid=<%=inprepid%>&crmid=" & id(0)
	end if
	end if
end sub

sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		weaver.helpdocid.value=id(0)&""
		Documentname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub

</script>
 

