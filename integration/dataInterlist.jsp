
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
		<title><%=SystemEnv.getHtmlLabelName(26968 ,user.getLanguage())%></title>
	</head>
	<%
		
		String dataname=Util.null2String(request.getParameter("dataname")).trim();
		String datadesc=Util.null2String(request.getParameter("datadesc")).trim();
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(30703 ,user.getLanguage());
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(dataname))
		{	
			sqlwhere+=" and dataname like '%"+dataname+"%'";
		}
		if(!"".equals(datadesc))
		{	
			sqlwhere+=" and datadesc like '%"+datadesc+"%'";
		}
		String backfields=" * " ;
		String perpage="10";
		String fromSql=" int_dataInter "; 
		tableString =   " <table instanceid=\"sendDocListTable\"  ";
		tableString+=" tabletype=\"none\" ";
		tableString+=" pagesize=\""+perpage+"\" >";
			    tableString+=
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30704 ,user.getLanguage())+"\" column=\"dataname\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getDataname\"  otherpara=\"column:id\" />"+
				"           <col width=\"80%\"  text=\""+SystemEnv.getHtmlLabelName(30705 ,user.getLanguage())+"\" column=\"datadesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
			<%
			/**
			if(SapUtil.getIsOpendataInterAdd())
			{
				RCMenu += "{添加,javascript:doAdd(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{删除,javascript:doDelete(this),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			*/	
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doRefresh(this);">
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

				<form action="/integration/dataInterlist.jsp" method="post" name="sapserlist" id="sapserlist">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(30704,user.getLanguage())%></wea:item>
    <wea:item>
        <input  type="text" name="dataname" value="<%=dataname%>">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30706,user.getLanguage())%></wea:item>
    <wea:item>
        <input   type="text" name="datadesc" value="<%=datadesc%>">
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
			$("#sapserlist").submit(); 
		}
		function doAdd()
		{
			window.location.href="/integration/dataInterNew.jsp";
		}
		function doUpdate(id)
		{
			window.location.href="/integration/dataInterNew.jsp?isNew=1&id="+id;
		}
		function doDelete()
		{
			var requestids = _xtable_CheckedCheckboxId();	
			if(!requestids)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30678 ,user.getLanguage())%>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage())%>"+"!"))
				{
				window.location.href="/integration/dataInterOperation.jsp?opera=delete&sid="+requestids;
				}
			}		
		}
	</script>
	</body>
</html>

