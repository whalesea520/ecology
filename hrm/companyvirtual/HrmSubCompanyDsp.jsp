<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String id = Util.null2String(request.getParameter("id"),"0"); 
String subcompanyname = SubCompanyVirtualComInfo.getSubCompanyname(id);
String subcompanydesc = SubCompanyVirtualComInfo.getSubCompanydesc(id);
String companyid = Util.null2String(SubCompanyVirtualComInfo.getCompanyid(id),"0");
String companyname = CompanyVirtualComInfo.getVirtualType(companyid);
String supsubcomid=SubCompanyVirtualComInfo.getSupsubcomid(id);
String showorder=SubCompanyVirtualComInfo.getShowOrder(id);
String canceled = SubCompanyVirtualComInfo.getCompanyiscanceled(id);
String subcompanycode = SubCompanyVirtualComInfo.getSubCompanycode(id);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	parent.parent.jsReloadTree();
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	var url = "";
	dialog.Width = 600;
	dialog.Height = 300;
  if(cmd=="editSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyEditVirtual&id=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,141", user.getLanguage())%>";
	}else if(cmd=="addSiblingSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAddVirtual&method=addSiblingSubCompany&subcompanyid=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17897", user.getLanguage())%>";
	}else if(cmd=="addChildSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAddVirtual&method=addChildSubCompany&subcompanyid=<%=id%>&supsubcomid=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17898", user.getLanguage())%>";
	}else if(cmd=="addDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAddVirtual&subcompanyid=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,27511", user.getLanguage())%>";
		dialog.Height = 350;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addSiblingSubCompany()
{
	openDialog("addSiblingSubCompany");
}

function addChildSubCompany()
{
	openDialog("addChildSubCompany");
}

function addDepartment()
{
	openDialog("addDepartment");
}

function submitData() {
 openDialog('editSubCompany');
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
	 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>", function(){
	 		var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	              //onBtnSearchClick();
	            }else{
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22253, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
	 })
}

 function doISCanceled(){
 	 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>", function(){
 	 		var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	              //onBtnSearchClick();
	            }
            }catch(e){
                return false;
            }
        }
     }
 	 });
 }
 
function delSubCompany(){
	jQuery.ajax({
		url:"/hrm/ajaxData.jsp?cmd=checksubcompany&subcompanyid=<%=id%>",
		type:"post",
		async:true,
		success:function(data,status){
			if(data.trim()=="1"){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
					searchfrm.action="SubCompanyOperation.jsp";
					searchfrm.operation.value="deletesubcompany";
					searchfrm.submit();
				})
			}else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22688, user.getLanguage())%>");
			}
		},
	});
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
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
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+companyname+"-"+subcompanyname;
String needfav ="1";
String needhelp ="";
String navName = "";
if(!id.equals("0")){
	navName = subcompanyname;
}else if(!companyid.equals("0")){
	navName = companyname;
}
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
	//编辑
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	//删除
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delSubCompany(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17897,user.getLanguage())+",javascript:addSiblingSubCompany(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17898,user.getLanguage())+",javascript:addChildSubCompany(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())+",javascript:addDepartment(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
	if(("0".equals(canceled) || "".equals(canceled))){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+");,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=searchfrm name=searchfrm action="HrmSubCompanyDsp.jsp" method=post >
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=companyid value="<%=companyid%>">
 <input class=inputstyle type=hidden name=id value="<%=id%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){ %>
		<input type=button class="e8_btn_top" onclick="addSiblingSubCompany()" value="<%=SystemEnv.getHtmlLabelNames("82,17897",user.getLanguage())%>"></input>
		<%}if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){ %>
		<input type=button class="e8_btn_top" onclick="openDialog('editSubCompany')" value="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"></input>
		<%if(("0".equals(canceled) || "".equals(canceled))){ %>
		<input type=button class="e8_btn_top" onclick="doCanceled()" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%>"></input>
		<%}else{ %>
		<input type=button class="e8_btn_top" onclick="doISCanceled()" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage())%>"></input>
		<%}} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
	  <wea:item><%=subcompanyname%><%=canceled.equals("1")?"("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")":""%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
	  <wea:item><%=subcompanydesc%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("596,141",user.getLanguage())%></wea:item>
	  <wea:item><%=SubCompanyVirtualComInfo.getSubCompanyname(""+supsubcomid)%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>  
	  <wea:item><%=showorder%></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></wea:item>  
	  <wea:item><%=subcompanycode%></wea:item>
	</wea:group>
</wea:layout>
</FORM>
</BODY>
</HTML>
