
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.general.GCONST" %>
<%
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));
String closeDialog = Util.null2String(request.getParameter("closeDialog"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String selectids = Util.null2String(request.getParameter("selectids"));
int infoId = Util.getIntValue(request.getParameter("id"),0);
String customid = Util.null2String(request.getParameter("customid"));
int userid=0;
userid=user.getUID();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
  </head>
  
  <body  width="100%">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33466,user.getLanguage())%>"/>  
</jsp:include>

  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  


  <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td width="160px">
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 500px !important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top"
						onclick="onAdd();" />
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>"
						class="e8_btn_top" onclick="delPrm('');" />
					
					
					&nbsp;&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
</div>
	<%String orderby =" id ";
	String tableString = "";
	int perpage=10;
	String sqlwhere=" where infoid='"+infoId+"'  and resourceid='"+resourceId+"' and menutype='"+type+"' and resourcetype='"+resourceType+"' ";
	if(!customid.equals("")){
		sqlwhere +=" and customid='"+customid+"'"; 
	}
	//System.out.println("["+sqlwhere+"]");                          
	String backfields = " id,infoid,resourceid,resourcetype,menutype,sharetype,sharevalue,seclevel,rolelevel,jobtitlelevel,jobtitlesharevalue";
	String fromSql  = " menushareinfo ";
	tableString =   " <table instanceid=\"\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
					" <checkboxpopedom width=\"30%\" id=\"checkbox\" popedompara=\"1\"  showmethod=\"weaver.splitepage.transform.SptmForMenuShare.getCheckbox\"  />"+
					"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"   sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"sharetype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"sharetype\" transmethod=\"weaver.splitepage.transform.SptmForMenuShare.getMenuShareType\" />"+
					"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"sharevalue\" otherpara=\"column:sharetype+column:rolelevel+"+user.getLanguage()+"+column:sharevalue+column:jobtitlelevel+column:jobtitlesharevalue\" orderkey=\"sharevalue\" transmethod=\"weaver.splitepage.transform.SptmForMenuShare.getMenuShareValue\" />"+
					"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\"  />"+
					"       </head>";
	 
	tableString +=  " </table>";
	//System.out.println(tableString);
	%>
<div class="zDialog_div_content" style="position:absolute;bottom:40px;top:62px;width: 100%;overflow:auto">	
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>

<script LANGUAGE="JavaScript">

function onAdd(){
	
	diag_vote = new window.top.Dialog();
	
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 400;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(33628, user.getLanguage())%>";
	diag_vote.URL = "/systeminfo/menuconfig/MenuMaintenanceShareAdd.jsp?dialog=1&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&type=<%=type%>&subCompanyId=<%=subCompanyId%>&infoid=<%=infoId%>&customid=<%=customid%>";
	diag_vote.show();
}

var dlg;
function delPrm(id){
	
	
	if(window.top.Dialog){
		dlg = window.top.Dialog
	} else {
		dlg = Dialog;
	}
	var ids = "";
	if(id==null ||id=="" || id == "NULL" || id == "Null" || id == "null"){
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				ids = ids +$(this).attr("checkboxId")+",";
		});
	} else {
		ids = id+",";
	}
	if(ids=="") {
		dlg.alert("<%=SystemEnv.getHtmlLabelName(84221, user.getLanguage())%>!") ;
	} else {
		dlg.confirm("<%=SystemEnv.getHtmlLabelName(84222, user.getLanguage())%>", function (){
		doDeletePrm(ids);
		}, function () {}, 300, 90, true, null, null, null, null, null);
	}
}

function doDeletePrm(ids){
	$.post("/systeminfo/menuconfig/MenuMaintenanceShareOperation.jsp",{method:"delShare",ids:ids},function(datas){
		document.location.reload();
	});
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}


jQuery(document).ready(function(){
	//resizeDialog(document);
	
});

</script>
</html>

