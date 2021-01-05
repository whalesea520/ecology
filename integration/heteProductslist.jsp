
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>

<%
if(!HrmUserVarify.checkUserRight("intergration:SAPsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
%>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage()) %></title>
	</head>
	<%
		
		String hetename=Util.null2String(request.getParameter("hetename")).trim();
		String hetedesc=Util.null2String(request.getParameter("hetedesc")).trim();
		String flag=Util.null2String(request.getParameter("flag"));
		String sid=Util.null2String(request.getParameter("sid"));
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(30698,user.getLanguage());
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(hetename))
		{	
			sqlwhere+=" and hetename like '%"+hetename+"%'";
		}
		if(!"".equals(hetedesc))
		{	
			sqlwhere+=" and hetedesc like '%"+hetedesc+"%'";
		}
		if(!"".equals(sid))
		{	
			sqlwhere+=" and sid="+sid+"";
		}
		String backfields="* " ;
		String perpage="10";
		String fromSql="  ( select a.*,b.dataname  from int_heteProducts a left join int_dataInter b on a.sid=b.id) s"; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                " <checkboxpopedom    popedompara=\"column:id+column:sid\" showmethod=\"com.weaver.integration.util.IntegratedMethod.getHeteProductsShowBox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30693,user.getLanguage())+"\" column=\"hetename\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getHetename\"  otherpara=\"column:id\" />"+
				"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30694,user.getLanguage())+"\" column=\"dataname\"    />"+
				"           <col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(30696,user.getLanguage())+"\" column=\"hetedesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doAdd(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="doRefresh(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this);">
			&nbsp;&nbsp;&nbsp;
			<span title="菜单" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			
				<form action="/integration/heteProductslist.jsp" method="post" name="hetelist" id="hetelist">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(30693,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text" name="hetename" value="<%=hetename%>">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30694,user.getLanguage())%></wea:item>
    <wea:item>
        <%=SapUtil.getDataInterSelect("sid","",sid,"selectmax_width","     ")%>
    </wea:item>
	</wea:group>
</wea:layout>

<TABLE width="100%">
	<tr>
		<td valign="top">  
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
		</td>
	</tr>
</TABLE>

			</form>

	<script type="text/javascript">
		function doRefresh(obj)
		{
			$("#hetelist").submit(); 
		}
		function doAdd()
		{
			var url="/integration/heteProductsNew.jsp";
			var title="<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(31694,user.getLanguage())%>";
			showDialog(title,url,500,360,false);
		}
		function doUpdate(id)
		{
			var url="/integration/heteProductsNew.jsp?isNew=1&id="+id;
			var title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(31694,user.getLanguage())%>";
			showDialog(title,url,500,360,false);
		}
		
		function showDialog(title,url,width,height,showMax){
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
		
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30678,user.getLanguage()) %>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>"+"!"))
				{
				window.location.href="/integration/heteProductsOperation.jsp?opera=delete&ids="+requestids;
				}
			}		
		}
	</script>
	</body>
</html>

