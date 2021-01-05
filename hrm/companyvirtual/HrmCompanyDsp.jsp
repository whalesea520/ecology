<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String id = Util.null2String(request.getParameter("id"),"0");
String cmd = Util.null2String(request.getParameter("cmd"));
String virtualtype = Util.null2String(CompanyVirtualComInfo.getVirtualType(id)); 
String virtualtypedesc = Util.null2String(CompanyVirtualComInfo.getVirtualTypeDesc(id));
String showorder = Util.null2String(CompanyVirtualComInfo.getShowOrder(id));
String companyname = virtualtype;
String companydesc = virtualtype;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage())+":"+companyname;
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
<%if(cmd.equals("del")){%>
 parent.parent.location.href="/hrm/companyvirtual/HrmCompany_frm.jsp";
<%}%>
jQuery(document).ready(function(){
 parent.setTabObjName('<%=companyname%>')
});

function setID(id){
	jQuery("#id").val(id);
}

function onBtnSearchClick(){
	parent.parent.jsReloadTree();
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	
	if(id==null)id="";
	var url = "";
	if(cmd=="add"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCompanyAddVirtual&virtualtype=<%=id%>";
		dialog.Width = 500;
		dialog.Height = 239;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,34069", user.getLanguage())%>";
	}else if(cmd=="edit"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCompanyEditVirtual&id=<%=id%>&virtualtype=<%=id%>";
		dialog.Width = 500;
		dialog.Height = 239;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,34069", user.getLanguage())%>";
	}else if(cmd=="addSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAddVirtual&companyid=<%=id%>&virtualtype=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,141", user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 300;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addCompany(id)
{
	openDialog("add",id);
}

function editCompany(id)
{
	openDialog("edit",id);
}

function delCompany(){
	jQuery.ajax({
		url:"/hrm/ajaxData.jsp?cmd=checkcompany&companyid=<%=id%>",
		type:"post",
		async:true,
		success:function(data,status){
			if(data.trim()=="1"){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
					searchfrm.action="CompanyOperation.jsp";
					searchfrm.cmd.value="del";
					searchfrm.submit();
				})
			}else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22688, user.getLanguage())%>");
			}
		},
	});
}

function addSubCompany(id)
{
	openDialog("addSubCompany",id);
}


function onLogCom(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=412 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=412")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onLogSubCom(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=413 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=413")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%	
	if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){
		//新建总部
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,34069",user.getLanguage())+",javascript:addCompany(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)&&!id.equals("0")){
		//编辑总部
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("93,34069",user.getLanguage())+",javascript:editCompany(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)&&!id.equals("0")){
		//删除
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delCompany(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)&&!id.equals("0")){
		//新建分部
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,141",user.getLanguage())+",javascript:addSubCompany(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)&&!id.equals("0")){
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("140,83",user.getLanguage())+",javascript:onLogCom("+id+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	
	if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)&&!id.equals("0")){
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("141,83",user.getLanguage())+",javascript:onLogSubCom("+id+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="searchfrm" id="searchfrm" method=post action="HrmCompanyDsp.jsp">
	<input class=inputStyle type=hidden id="id" name="id" value=<%=id%>> 
	<input class=inputStyle type=hidden id="cmd" name="cmd"> 
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){ %>
				<input type=button class="e8_btn_top" onclick="addCompany();" value="<%=SystemEnv.getHtmlLabelNames("82,34069", user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)&&!id.equals("0")){ %>
				<input type=button class="e8_btn_top" onclick="editCompany();" value="<%=SystemEnv.getHtmlLabelNames("93,34069", user.getLanguage())%>"></input>
			<%}if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)&&!id.equals("0")){%>
				<input type=button class="e8_btn_top" onclick="addSubCompany();" value="<%=SystemEnv.getHtmlLabelNames("82,141", user.getLanguage())%>"></input>
			<%}%>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"  class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>  
			<wea:item><%=SystemEnv.getHtmlLabelName(34069,user.getLanguage())%></wea:item>
	    <wea:item><%=virtualtype%></wea:item>    
	    <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
	    <wea:item><%=virtualtypedesc%></wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
	    <wea:item><%=showorder%></wea:item>
  
		</wea:group>
	</wea:layout>
 </form>
</BODY>
</HTML>
