
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="pc" class= "weaver.page.PageCominfo" scope="page" />
 
<%
    int hpid = Util.getIntValue(request.getParameter("hpid"),0); 	
    String  hpname = pc.getInfoname(""+hpid);
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

	
    String titlename = SystemEnv.getHtmlLabelName(19911,user.getLanguage())+": "+ hpname ;
    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %> 
    <%
      
		RCMenu += "{"+SystemEnv.getHtmlLabelName(18645,user.getLanguage())+",javascript:doAdd(this),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:delPrm(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
    %>
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doAdd()">						
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="delPrm('')">
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
								<form  name="frmAdd" method="post" action="HomepageShareOperation.jsp">
									<input type="hidden"  name="method">
                                    <input type="hidden"  name="hpid" value="<%=hpid%>">

                         
													
													
														<%
														/* String strSql="select id,type,content from shareinnerhp where hpid="+hpid;
														 rs.executeSql(strSql);
														 while(rs.next()){		
															 String shareid=Util.null2String(rs.getString("id"));
															 String sharetype=Util.null2String(rs.getString("type"));
															 String sharecontent=Util.null2String(rs.getString("content"));
															 String shareStr="";
															  if(sharetype.equals("1")) {
																	shareStr+=rc.getResourcename(sharecontent);
																} else if(sharetype.equals("2")) {
																	 shareStr+=scc.getSubCompanyname(sharecontent);
																}  else if(sharetype.equals("3")) {
																	 shareStr+=dci.getDepartmentname(sharecontent);
																} else if(sharetype.equals("5")) { 		
																	shareStr+=SystemEnv.getHtmlLabelName(1340,user.getLanguage());
																}
															  */
														
													
													
													
		int perpage =10;
		//设置好搜索条件
		String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
		  + "<checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.splitepage.transform.SptmForMenuShare.getCheckbox\"/>"
		  + "<sql backfields=\" id,type,content,seclevel,seclevelmax,sharelevel,includeSub,jobtitlelevel,jobtitlesharevalue \" sqlform=\" from shareinnerhp \" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlwhere=\"hpid="+hpid+"\" sqlisdistinct=\"false\" />"+
			"       <head>"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"type\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"type\" transmethod=\"weaver.splitepage.transform.SptmForMenuShare.getMenuShareType\" />"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"content\" otherpara=\"column:type+column:sharelevel+"+user.getLanguage()+"+column:includeSub+column:content+column:jobtitlelevel+column:jobtitlesharevalue"+"\" transmethod=\"weaver.splitepage.transform.SptmForMenuShare.getMenuShareValue\" />"+
			"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" otherpara=\"column:type+column:seclevelmax"+"\"  transmethod=\"weaver.splitepage.transform.SptmForMenuShare.getSeclevel\" />"+
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
    
    var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
	dialog.close();
}
function doAdd(obj){ 
    
    showDialogWin("<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>","/homepage/maint/HomepageShareAddBrowser.jsp?hpid=<%=hpid%>",500,400) 
	//window.location="HomepageShareAddBrowser.jsp?hpid=<%=hpid%>";  
}
function onCancel(){
		var dialog = parent.getDialog(window);
		dialog.close();
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
	$.post("/homepage/maint/HomepageShareOperation.jsp",{method:"delShare",ids:ids},function(datas){
		document.location.reload();
	});
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
//-->
</SCRIPT>


