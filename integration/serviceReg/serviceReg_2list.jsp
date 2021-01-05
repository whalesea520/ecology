
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<jsp:useBean id="ServiceReginfo" class="com.weaver.integration.util.ServiceRegTreeInfo" scope="page"/>
<html>
	<head>
		<title>sap<%=SystemEnv.getHtmlLabelName(26267,user.getLanguage()) %></title>
	</head>
	<%
		String hpid=Util.null2String(request.getParameter("hpid"));//异构产品的id
		String regname=Util.null2String(request.getParameter("regname"));
		String poolid=Util.null2String(request.getParameter("poolid"));
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename =ServiceReginfo.getHetename(hpid)+SystemEnv.getHtmlLabelName(30649,user.getLanguage()); //服务注册清单
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(hpid))
		{
			sqlwhere+=" and a.hpid='"+hpid+"'";
		}
		if(!"".equals(regname))
		{
			sqlwhere+=" and a.regname like '%"+regname+"%'";
		}
		if(!"".equals(poolid))
		{
			sqlwhere+=" and a.poolid ='"+poolid+"'";
		}
		String backfields=" a.*,b.poolname " ;
		String perpage="10";
		String fromSql="  ws_service a left join ws_datasource b on a.poolid=b.id "; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				"<checkboxpopedom     popedompara=\"column:a.id\"   showmethod=\"com.weaver.integration.util.IntegratedMethod.getIsShowBox2\"  />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"a.id\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"33%\"  text=\""+ SystemEnv.getHtmlLabelName(30644,user.getLanguage()) +"\" column=\"regname\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getRegname\"  otherpara=\"column:id\"  />"+
				"           <col width=\"33%\"  text=\""+ SystemEnv.getHtmlLabelName(30660,user.getLanguage()) +"\" column=\"poolname\"   />"+
				"           <col width=\"33%\"  text=\""+ SystemEnv.getHtmlLabelName(30625,user.getLanguage()) +"\" column=\"serdesc\"   />"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(611,user.getLanguage()) +",javascript:doAdd(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(197,user.getLanguage()) +",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(23777,user.getLanguage()) +",javascript:doDelete(this),_self} " ;
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top" onclick="doRefresh(this)" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this)" />
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

				<form action="/integration/serviceReg/serviceReg_2list.jsp" method="post" name="sapserlist" id="sapserlist">
				<input type="hidden" name="hpid" value="<%=hpid%>">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item>WEBSERVICE <%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
    <wea:item>
        <%=SapUtil.getDatasourceSelect("3","poolid","",poolid,"selectmax_width","   ") %>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30672,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text" name="regname" value="<%=regname%>">
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
			var url="/integration/serviceReg/serviceReg_2New.jsp?hpid=<%=hpid%>";
			var title="<%=SystemEnv.getHtmlLabelName(30685,user.getLanguage())%>";
			showDialog(title,url,500,360,false);
		}
		function doUpdate(id)
		{
			var url="/integration/serviceReg/serviceReg_2New.jsp?isNew=1&id="+id;
			var title="<%=SystemEnv.getHtmlLabelName(30687,user.getLanguage())%>";
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
				alert("<%=SystemEnv.getHtmlLabelName(30678,user.getLanguage())%>");
				return;
			}else
			{	
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"+"!"))
				{
				window.location.href="/integration/serviceReg/serviceReg_2Operation.jsp?opera=delete&ids="+requestids+"&hpid=<%=hpid%>";;
				}
			}		
		}
	</script>
	</body>
</html>

