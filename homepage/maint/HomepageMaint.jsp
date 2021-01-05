
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="hpc" class= "weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="rc" class= "weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class= "weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dci" class= "weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
 
<%
    String hpid = Util.null2String(request.getParameter("hpid")); 	
    String  hpname = hpc.getInfoname(hpid);
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
    <BODY>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="portal"/>
	   <jsp:param name="navName" value="<%=hpname %>"/> 
	</jsp:include>
    <%
    String imagefilename = "/images/hdReport_wev8.gif";

	
    String titlename = SystemEnv.getHtmlLabelName(19909,user.getLanguage())+": "+ hpname ;
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %> 
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+",javascript:doAdd(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+SystemEnv.getHtmlLabelName(19909,user.getLanguage())+",javascript:doDel(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
    %>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">
			</td>
			<td class="rightSearchSpan" style="text-align: right; width: 500px !important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(19909,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doAdd(this);">						
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="delPrm('')">
				&nbsp;&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form  name="frmAdd" method="post" action="HomepageMaintOperate.jsp">
	<input type="hidden"  name="method">
    <input type="hidden"  name="hpid" value="<%=hpid%>">
                                    
        <%
        int perpage =10;
		//设置好搜索条件
		String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
		  + "<checkboxpopedom popedompara=\"column:dirid\" showmethod=\"weaver.splitepage.transform.SptmForPortalRight.getCheckbox\"/>"
		  + "<sql backfields=\" mainid,dirid,seclevel,seclevelMax,departmentid,roleid,rolelevel,jobtitle,jobtitlelevel,jobtitlesharevalue,permissiontype,operationcode,userid,subcompanyid \" sqlform=\" from ptaccesscontrollist \" sqlorderby=\"mainid\"  sqlprimarykey=\"mainid\" sqlsortway=\"asc\" sqlwhere=\"dirid="+hpid+"\" sqlisdistinct=\"false\" />"+
			"       <head>"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"permissiontype\" transmethod=\"weaver.splitepage.transform.SptmForPortalRight.getPortalRightType\" />"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"permissiontype\" otherpara=\"column:subcompanyid+column:departmentid+column:roleid+column:userid+column:rolelevel+"+user.getLanguage()+"+column:jobtitle+column:jobtitlelevel+column:jobtitlesharevalue\" transmethod=\"weaver.splitepage.transform.SptmForPortalRight.getPortalRightInfo\" />"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"dirid\" otherpara=\"column:permissiontype+column:subcompanyid+column:departmentid+column:roleid\" orderkey=\"seclevelMax\"  transmethod=\"weaver.splitepage.transform.SptmForPortalRight.getPortalRightSeclevel\"/>"+
			"       </head>"
	 	+"</table>";			
	 	
		%>
	<TABLE width="100%">
		<TR>
			<TD valign="top">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
			</TD>
		</TR>
	</TABLE>

</form>
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
    </BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doSubmit(obj){
    obj.disabled = true ;

    var dialog =  parent.parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
	dialog.close();
}
function doAdd(obj){ 
	showDialogWin("<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(19909,user.getLanguage())%>","/homepage/maint/HomepageMaintAddBrowser.jsp?hpid=<%=hpid%>",500,400)
}
function showDialogWin(title,url,width,height,showMax){
	var Show_dialog = new window.top.Dialog();
	Show_dialog.currentWindow = window;   //传入当前window
 	Show_dialog.Width = width;
 	Show_dialog.Height = height;
 	Show_dialog.maxiumnable=showMax;
 	Show_dialog.Modal = true;
 	Show_dialog.Title = title;
 	Show_dialog.URL = url;
 	Show_dialog.show();
}
function onCancel(){
		var dialog = parent.getDialog(window);
		dialog.close();
}
function doDel(obj){ 
	if(jQuery("input:checkbox[checked]").length>0){
	    obj.disabled = true ; 
		frmAdd.method.value="delMaint";
		frmAdd.submit();   
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>")
	}
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
		dlg.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>") ;
	} else {
		dlg.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		doDeletePrm(ids);
		}, function () {}, 300, 90, true, null, null, null, null, null);
	}
}
function doDeletePrm(ids){
	$.post("/homepage/maint/HomepageMaintOperate.jsp",{method:"delMaint",ids:ids},function(datas){
		document.location.reload();
	});
}
//-->
</SCRIPT>


