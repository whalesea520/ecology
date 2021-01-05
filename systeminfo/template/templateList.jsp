
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isDetachable=hpu.isDetachable(request);
int operatelevel=0;
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));


if(isDetachable){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"SystemTemplate:Edit",subCompanyId);
    if(operatelevel<2){
    	response.sendRedirect("/notice/noright.jsp");
		return;
    }
}else{
    if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}
//int userId = 0;
//int userDeptId = 0;
//userId = user.getUID();
//userDeptId = user.getUserDepartment();

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("portaldetachable")),0);
String sqlWhere ="";
if(subCompanyId==-1){
	if(detachable==1){
		if(user.getUID()!=1){
			sqlWhere=" WHERE companyId in (select b.subcompanyid from hrmrolemembers a, SysRoleSubcomRight b where a.roleid = b.roleid and a.resourceid = "+user.getUID();
		}else{
			sqlWhere=" where 1=1 ";
		}
	}else{
		if(user.getUID()!=1){
			sqlWhere=" where 1!=1 ";
		}else{
			sqlWhere=" where 1=1 ";
		}
	}
}else{
	if(user.getUID()!=1){
		sqlWhere= " WHERE companyId="+subCompanyId;
	}else{
		sqlWhere= " WHERE companyId=0 OR companyId="+subCompanyId;
		
	}

}



String sql = "";

int defaultTemplateId = -1;
sql = "SELECT templateId FROM SystemTemplateSubComp WHERE subcompanyid="+subCompanyId+"";
rs.executeSql(sql);
if(rs.next()){
	defaultTemplateId = rs.getInt("templateId");
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script type="text/javascript">
var radios;
var oSelectedIndex = -1;
var isClear = false;
function afterDoWhenLoaded(){
	isClear = false;
	radios = document.getElementsByName("tId");
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			oSelectedIndex = "r"+radios[i].value;
			//alert(oSelectedIndex)
			break;
		}
	}
}


function detectRadioStatus(){
	var span = window.event.srcElement;
	var e = $(span).parent().find("input")[0];
	//alert(oSelectedIndex+"$"+e.id)
	if(oSelectedIndex==e.id && !isClear){
		clearRadioSelected();	
	}else{
		oSelectedIndex = e.id;
		e.checked=true;
		$(e).parent().find(".jNiceRadio").addClass("jNiceChecked");
		isClear = false;
	}
}

function clearRadioSelected(){
	for(var i=0;i<radios.length;i++){
		radios[i].checked = false;
		$(radios[i]).parent().find(".jNiceRadio").removeClass("jNiceChecked");
	}
	isClear = true;
}

function detectTemplateStatus(obj){
	var e = window.event.srcElement;
	var e2 = e;
	while(e.tagName!="TR"){
		e = e.parentElement;
	}
	
	if(document.getElementById("r"+obj.value).checked){
		alert("<%=SystemEnv.getHtmlLabelName(18990,user.getLanguage())%>!");
		obj.checked = true;
		$(obj).parent().find(".jNiceCheckbox").addClass("jNiceChecked");
	}
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(subCompanyId>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelChecked(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="tabDiv">
	<span id="hoverBtnSpan">
		<span id="portalTheme"  class="selectedTitle" ></span>
	</span>
</div>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" onclick="doAdd()"></input>
			<%if(subCompanyId>0){ %>
			<input type=button class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="checkSubmit()"></input>
			<%} %>
			<input type=button class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" onclick="doDelChecked()"></input>
		
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="frmMain" id="frmMain" method="post" action="templateOperation.jsp">
<input type="hidden" id="subCompanyId" name="subCompanyId" value="<%=subCompanyId%>"/>
<input type="hidden" id="operationType" name="operationType" value="open"/>
<input type="hidden" id="openStr" name="openStr"/>
<input type="hidden" id="templateid" name="templateid"/>
<input type="hidden" id = "isClear" name = "isClear"/>
<%
//得到pageNum 与 perpage
int perpage =10;
//设置好搜索条件
String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\">"
  + "<checkboxpopedom popedompara=\"column:isOpen+column:companyid\" showmethod=\"weaver.splitepage.transform.SptmForSystemTemplate.getTemplateDel\"/>"
  + "<sql backfields=\" id,isOpen,templatename,companyid,extendtempletid \" sqlform=\" from SystemTemplate \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\""+sqlWhere+"\" sqlisdistinct=\"false\" />"+
	"<head >"+
		"<col width=\"5%\"   text=\"ID\"   column=\"id\"/>"+
		"<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(18151,user.getLanguage())+"\"   column=\"templatename\" otherpara=\"column:id+column:extendtempletid+column:companyid\" transmethod=\"weaver.splitepage.transform.SptmForSystemTemplate.getTemplateName\" />"+
		"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\"   column=\"companyid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForSystemTemplate.getSubCompanyName\"/>";
		if(subCompanyId!=-1){

			tableString+="<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\"   column=\"isOpen\" otherpara=\"column:id\" transmethod=\"weaver.splitepage.transform.SptmForSystemTemplate.getIsOpen\" />"+
			"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(17908,user.getLanguage())+"\"   column=\"id\" otherpara=\"column:isOpen+"+subCompanyId+"\" transmethod=\"weaver.splitepage.transform.SptmForSystemTemplate.getIsDefault\"/>";
		}else{
			tableString+="<col width=\"15%\" text=''/><col text='' width=\"20%\"/>";
		}
		tableString+="</head>"
	 + "<operates><popedom otherpara=\"column:isOpen+column:companyid\" transmethod=\"weaver.splitepage.transform.SptmForSystemTemplate.getOperate\"></popedom> "
	 + "<operate href=\"javascript:doPreview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
	 + "<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"1\"/>";
	 //if(subCompanyId!=-1){
		 tableString+="<operate href=\"javascript:doSaveAs();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
	 //}
	 tableString+="<operate href=\"javascript:doEditContent();\" text=\""+SystemEnv.getHtmlLabelName(33671,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>";

	 tableString+="<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"4\"/>"

	 + "</operates></table>";						
%>
<TABLE width="100%">
	<TR>
		<TD valign="top">
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
		</TD>
	</TR>
</TABLE>
<div id="saveAsTable" style="display:none">
	<table id="saveAsTable1" name="saveAsTable" width="100%" style="margin-top:30px">
	<tr>
		<td width="60px" style="padding-left:30px">
			<%=SystemEnv.getHtmlLabelName(28050,user.getLanguage()) %>:
		</td>
		<td>
			<input type="text" class="inputstyle styled input" name="saveAsName" id ="saveAsName" style="width:90% !important" onchange="checkinput('saveAsName','saveAsNameSpan')">
			
          <span id="saveAsNameSpan"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span></td>
		
	</tr>
</table>
</div>

</form>
</body>
</html>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript"><!--

jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle();
	jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	jQuery("#tabDiv").remove();		
});
function checkSubmit(){
	$("#isClear").val(isClear);

	var notLessThanOne = false;
	var strIDs = "";
	var strValues = "";
	var o = document.getElementsByName("isOpen");
	for(var i=0;i<o.length;i++){
		strIDs += o[i].id.substr(1,o[i].id.length) +",";
		if(o[i].checked){
			strValues += "1,";
			notLessThanOne = true;
		}else{
			strValues += "0,";
		}
	}
	document.getElementById("openStr").value = strIDs.substr(0,strIDs.length-1)+"*"+strValues.substr(0,strValues.length-1);
	
	document.frmMain.submit();
	window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	
}

function doAdd(){
 	var title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"; 
 	var url ="/systeminfo/template/PortalTemplateTabs.jsp?subCompanyId=<%=subCompanyId%>&type=add";
	showDialog(title,url,650,300,true);
}

function doEdit(ptid){
 	var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
 	var companyid = $("#template_"+ptid).attr("companyid")
 	var url = "/systeminfo/template/PortalTemplateTabs.jsp?id="+ptid+"&subCompanyId="+companyid+"&type=edit";
 	showDialog(title,url,650,300,false);
}

function doEditContent(ptid){
 	var title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
 	var companyid = $("#template_"+ptid).attr("companyid")
 	var url = "/systeminfo/template/PortalTemplate.jsp?id="+ptid+"&subCompanyId="+companyid+"&type=edit";
 	showDialog(title,url,top.document.body.clientWidth,top.document.body.clientHeight,true);
}

/*另存为*/	
function doSaveAs(id){
	 
 	//var companyid = $("#template_"+ptid).attr("companyid")
 	var url = "/systeminfo/template/templateSaveAs.jsp?id="+id;
 	
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 350;
 	menuStyle_dialog.Height = 50;
 	menuStyle_dialog.maxiumnable=false;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
 	menuStyle_dialog.URL =url;
 	menuStyle_dialog.show();
 	//menuStyle_dialog.ShowButtonRow = true;
 	/*menuStyle_dialog.OKEvent =function(){
 		var saveAsName = $(menuStyle_dialog.getDialogDiv()).find("#saveAsName").val()
 		
 		$("#saveAsName").val(saveAsName)
 		
 		if(check_form(frmMain,"saveAsName")){
	 		$("#operationType").val("saveAs")
			$("#templateid").val(id);
 			//document.frmMain.submit();
 			menuStyle_dialog.close()
			$.post("templateOperation.jsp",{operationType:"saveAs",saveAsName:saveAsName,templateid:id},function(data){
				if(data.indexOf("SUCCESS")!=-1)location.reload();
			})
 		}
 	}
 	menuStyle_dialog.CancelEvent =function(){
 		menuStyle_dialog.close();
 		$("#saveAsName").val("");
 	}*/
 	
}

function doPreview(id){
	//var url = $("#template_"+id).attr("extendtempletUrl");
	//var extendtempletid = $("#template_"+id).attr("extendtempletid");
	
	url = '/systeminfo/template/templatePreview.jsp?id='+id+'&subcompanyId=<%=subCompanyId%>';
	
 	var title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
 	showDialogMax(title,url,700,500,true);
}

function doDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		$("#operationType").val("delete")
		$("#templateid").val(id);
		document.frmMain.submit();
	})
}

function doDelChecked(){
	doDel(_xtable_CheckedCheckboxId());	
}

function showDialog(title,url,width,height,showMax){
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = width;
 	Show_dialog.Height = height;
 	Show_dialog.maxiumnable = showMax;
 	Show_dialog.Modal = true;
 	Show_dialog.Title = title;
 	Show_dialog.URL = url;
 	Show_dialog.show();
}


function showDialogMax(title,url,width,height,showMax){
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = width;
 	Show_dialog.Height = height;
 	Show_dialog.maxiumnable = showMax;
 	Show_dialog.Modal = true;
 	Show_dialog.DefaultMax = true;
 	Show_dialog.Title = title;
 	Show_dialog.URL = url;
 	Show_dialog.show();
}
--></script>
