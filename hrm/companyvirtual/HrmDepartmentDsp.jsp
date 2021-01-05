<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String id = Util.null2String(request.getParameter("id"),"0");
String fromHrmTab = Util.null2String(request.getParameter("fromHrmTab"));
//如果不是来自HrmTab页，增加页面跳转
if(!fromHrmTab.equals("1")){
	String url = "/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id="+id;
	response.sendRedirect(url.toString()) ;
	return;
}
String departmentmark= Util.null2String(DepartmentVirtualComInfo.getDepartmentmark(id));
String departmentname = Util.null2String(DepartmentVirtualComInfo.getDepartmentname(id));;
String supdepid = Util.null2String(DepartmentVirtualComInfo.getDepartmentsupdepid(id));;
String allsupdepid = Util.null2String(DepartmentVirtualComInfo.getAllSupdepid(id));;
String subcompanyid=Util.null2String(DepartmentVirtualComInfo.getSubcompanyid1(id));
String companyid = SubCompanyVirtualComInfo.getCompanyid(subcompanyid);
String companyname =CompanyVirtualComInfo.getVirtualType(companyid);
String showorder = Util.null2String(DepartmentVirtualComInfo.getShowOrder(id));;
String canceled = Util.null2String(DepartmentVirtualComInfo.getDeparmentcanceled(id));
String departmentcode = Util.null2String(DepartmentVirtualComInfo.getDepartmentCode(id));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
	dialog.Height = 350;
  if(cmd=="editDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentEditVirtual&isdialog=1&id=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,27511", user.getLanguage())%>";
	}else if(cmd=="addSiblingDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAddVirtual&method=addSiblingDepartment&isdialog=1&id=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("1421,17899", user.getLanguage())%>";
	}else if(cmd=="addChildDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAddVirtual&method=addChildDepartment&isdialog=1&id=<%=id%>&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("1421,17587", user.getLanguage())%>";
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editDepartment()
{
	openDialog("editDepartment");
}

function addSiblingDepartment()
{
	openDialog("addSiblingDepartment");
}

function addChildDepartment()
{
	openDialog("addChildDepartment");
}

function delDepartment(){
	jQuery.ajax({
		url:"/hrm/ajaxData.jsp?cmd=checkdepartment&departmentid=<%=id%>",
		type:"post",
		async:true,
		success:function(data,status){
			if(data.trim()=="1"){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage())%>",function(){
					searchfrm.action="DepartmentOperation.jsp";
					searchfrm.operation.value="delete";
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
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=414 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=414")%>";
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
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = departmentname+","+departmentmark;
String needfav ="1";
String needhelp ="";

String navName = "";
if(!id.equals("0")){
	navName = departmentmark;
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
if(HrmUserVarify.checkUserRight("HrmDepartmentEdit:Edit", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	//删除
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delDepartment(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17899,user.getLanguage())+",javascript:addSiblingDepartment(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17900,user.getLanguage())+",javascript:addChildDepartment(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDepartmentEdit:Edit", user)){
	if("0".equals(canceled) || "".equals(canceled)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}else{
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	 	RCMenuHeight += RCMenuHeightStep ;
	}
}

if(HrmUserVarify.checkUserRight("HrmDepartment:Log", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}	
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=searchfrm name=searchfrm action="HrmDepartmentDsp.jsp" method=post>
<input class=inputstyle type=hidden name=id value="<%=id %>">
<input class=inputstyle type=hidden name=fromHrmTab value="<%=fromHrmTab %>">
<input class=inputstyle type=hidden name=operation value="add">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){%>
			<input type=button class="e8_btn_top" onclick="addSiblingDepartment();" value="<%=SystemEnv.getHtmlLabelNames("82,17899",user.getLanguage())%>"></input>
		<%}if(HrmUserVarify.checkUserRight("HrmDepartmentEdit:Edit", user)){%>
		<input type=button class="e8_btn_top" onclick="editDepartment();" value="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"></input>
		<%if(("0".equals(canceled) || "".equals(canceled))){%>
			<input type=button class="e8_btn_top" onclick="doCanceled();" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%>"></input>
			<%}else{ %>
			<input type=button class="e8_btn_top" onclick="doISCanceled();" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage())%>"></input>
		<%}} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
   <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
   <wea:item><%=departmentmark%><%=canceled.equals("1")?"("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")":""%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
   <wea:item><%=departmentname%></wea:item>
	 <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
   <wea:item><%=companyname%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15772,user.getLanguage())%></wea:item>
   <wea:item><%=DepartmentVirtualComInfo.getDepartmentname(supdepid)%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
   <wea:item><%=showorder%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(22279,user.getLanguage())%></wea:item>
   <wea:item><%=id%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></wea:item>
   <wea:item><%=departmentcode%></wea:item>
	</wea:group>
</wea:layout>
</FORM>
<script language=javascript>
function submitData() {
	editDepartment();
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
      ajax.send("deptorsupid=<%=id%>&userid=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmDepartmentDsp.jsp?fromHrmTab=1&id=<%=id%>";
	              //onBtnSearchClick();
	            }else{
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22157, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
	 	});
}

 function doISCanceled(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>", function(){
		var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&cancelFlag=1&userid=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmDepartmentDsp.jsp?fromHrmTab=1&id=<%=id%>";
	              //onBtnSearchClick();
				  return;
	            } 
                if(ajax.responseText == 0) {
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24296, user.getLanguage())%>");
	              return;
	            }
	            if(ajax.responseText == 2) {
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24297, user.getLanguage())%>");
	              return;
	            }
            }catch(e){
                return false;
            }
        }
     }
	});
 }
</script>

</BODY></HTML>
