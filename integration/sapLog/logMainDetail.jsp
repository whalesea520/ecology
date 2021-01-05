<%@page import="com.weaver.integration.log.LogInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<script language="javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>

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
		
		String Logtype=Util.null2String(request.getParameter("Logtype"));
		String opera=Util.null2String(request.getParameter("opera"));
		String fromdate2=Util.null2String(request.getParameter("fromdate2"));
		String todate2=Util.null2String(request.getParameter("todate2"));
		String sid=Util.null2String(request.getParameter("sid"));
		String allidstr=Util.null2String(request.getParameter("allidstr"));
		String allidname=Util.null2String(request.getParameter("allidname"));
		String poolid = "";//连接池id
		String hpid = "";//所属异构系统id
		String regserviceid = "";//注册服务的id
		String servicesid="";
		if(!"".equals(allidstr)){
				poolid=allidstr.split("_")[2];
				hpid=allidstr.split("_")[1];
				regserviceid=allidstr.split("_")[3];
				servicesid=3+"_"+hpid+"_"+poolid+"_"+regserviceid;
		}
		if("delete".equals(opera)&&!"".equals(sid)){
			if(!"".equals(sid)&&(sid.length()==(sid.lastIndexOf(",")+1))){//去掉最后一个逗号
				sid=sid.substring(0,(sid.length()-1));
			}
			RecordSet.execute("delete int_saplog where id in("+sid+")");
			RecordSet.execute("delete int_saplogpar where baseid in("+sid+")");
			RecordSet.execute("delete int_saplogstu where baseid in("+sid+")");
			RecordSet.execute("delete int_saplogtab  where baseid in("+sid+")");
			RecordSet.execute("delete int_saplogsql  where baseid in("+sid+")");
			
		}else  if("deleteAll".equals(opera)){
				RecordSet.execute("delete int_saplog ");
				RecordSet.execute("delete int_saplogpar ");
				RecordSet.execute("delete int_saplogstu ");
				RecordSet.execute("delete int_saplogtab  ");
				RecordSet.execute("delete int_saplogsql ");
		}
		
		
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = ""+SystemEnv.getHtmlLabelName(31701,user.getLanguage());
		String needhelp ="";
		String tableString="";
		String sqlwhere=" where 1=1 ";
		if(!"".equals(Logtype)){
			sqlwhere+=" and Logtype='"+Logtype+"'";
		}
		if(!"".equals(fromdate2)){
			sqlwhere+=" and logcreateData >='"+fromdate2+"'";
		}
		if(!"".equals(todate2)){
			sqlwhere+=" and logcreateData <='"+todate2+"'";
		}

		if(!"".equals(poolid)){
			sqlwhere+=" and poolid ='"+poolid+"'";
		}
		if(!"".equals(hpid)){
			sqlwhere+=" and hpid ='"+hpid+"'";
		}
		if(!"".equals(regserviceid)){
			sqlwhere+=" and regserviceid ='"+regserviceid+"'";
		}


		int  language=user.getLanguage();
		String backfields=" Logtype, logcreateData,id,logcreatetime,hpid,regserviceid,"+language+" language " ;
		String perpage="10";
		String para1="column:logcreatetime";
		String para2="column:poolid+column:hpid+column:regserviceid";
		String para3="column:language";
		
		
		String fromSql=" int_saplog "; 
		tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				"<checkboxpopedom     popedompara=\"column:id\"    showmethod=\"com.weaver.integration.util.IntegratedMethod.publicshowBox\"  />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(31702,user.getLanguage())+"\" column=\"Logtype\"  transmethod=\"com.weaver.integration.util.IntegratedMethod.getLogtype\"  otherpara=\""+para3+"\"/>"+
				"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(31703,user.getLanguage())+"\" column=\"logcreateData\"   transmethod=\"com.weaver.integration.util.IntegratedMethod.getLogDataStr\" otherpara=\""+para1+"\"/>"+
				"           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(31639,user.getLanguage())+"\" column=\"id\"   transmethod=\"com.weaver.integration.util.IntegratedMethod.getLogRegname\"  otherpara=\""+para2+"\" />"+
				"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(31704,user.getLanguage())+"\" column=\"id\"   transmethod=\"com.weaver.integration.util.IntegratedMethod.getSapLog\"  otherpara=\""+para3+"\"/>"+
                "       </head>"+
                " </table>";
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(16335,user.getLanguage())+",javascript:doDeleteAll(this),_self} " ;
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" class="e8_btn_top" onclick="doDeleteAll(this);">
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

				<form action="/integration/sapLog/logMainDetail.jsp" method="post" name="sapserlist" id="sapserlist">
				<input type=hidden name="servicesid" id="servicesid" value="<%=servicesid%>">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(31702,user.getLanguage())%></wea:item>
    <wea:item>
        <select name="Logtype">
			<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
			<option value="0" <%if("0".equals(Logtype)){out.println("selected='selected'");} %> ><%=SystemEnv.getHtmlLabelName(31705,user.getLanguage()) %></option>
			<option value="1" <%if("1".equals(Logtype)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(31706,user.getLanguage()) %></option>
			<option value="2" <%if("2".equals(Logtype)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(695,user.getLanguage()) %></option>
			<option value="3" <%if("3".equals(Logtype)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(31634,user.getLanguage()) %></option>
			<option value="4" <%if("4".equals(Logtype)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(31707,user.getLanguage()) %></option>
		</select>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(31703,user.getLanguage())%></wea:item>
    <wea:item>
        <BUTTON type="button" class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
		<SPAN id=fromdatespan2 ><%=fromdate2%></SPAN>
		-&nbsp;&nbsp;
		<BUTTON type="button" class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
		<SPAN id=todatespan2 ><%=todate2%></SPAN>
		<input type="hidden" name="fromdate2" value="<%=fromdate2%>">
		<input type="hidden" name="todate2" value="<%=todate2%>">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(31708,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}"> 
		<brow:browser viewType='0' name='allidstr' browserValue='<%=allidstr%>'
			browserOnClick='' browserUrl='/integration/browse/IntegrationServiceBrower.jsp?selectedids='
			hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
			browserSpanValue='<%=allidname %>'></brow:browser>
    	<input  name="allidname" id="showAllidname"value="<%=allidname%>" type="hidden">
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
		
	function onchangeservice()
	{		
			var selectedids=$("#servicesid").val();
			var sid = window.showModalDialog("/integration/browse/IntegrationServiceBrower.jsp?selectedids="+selectedids, "", "dialogWidth:550px;dialogHeight:550px;");
			if(sid)
			{	
				$("#servicesid").attr("value",sid.id);
				if(sid.id!=""){
					$("#servicename").html(sid.name);
					$("#allidname").attr("value",sid.name);
					$("#allidstr").attr("value",sid.id);
				}else{
					$("#servicename").html("");
					$("#allidname").attr("value","");
					$("#allidstr").attr("value","");
					$("#servicesid").attr("value","");
				}
			}
	}
		//在其子页面中，调用此方法打开相应的界面
		function openDialog(title,url) {
					var dlg=new Dialog();//定义Dialog对象
					dlg.Model=true;
					dlg.Width=800;//定义长度
					dlg.Height=600;
					dlg.URL=url;
					dlg.Title=title;
					dlg.show();
		}


		function doRefresh(){
			$("#showAllidname").val($("#innerallidstrdiv a").html());
			$("#sapserlist").submit();
		}
		function loadLogDetail(logid){
			
			openDialog("<%=SystemEnv.getHtmlLabelName(31709,user.getLanguage()) %>","/integration/sapLog/logMainDetailAJAX.jsp?logid="+logid);
			/*if(logid){
					$.post("/integration/sapLog/logMainDetailAJAX.jsp",{logid:logid},function(data){ 
					if(data["content"]) {
							//$("#logdetailshow").html(data["content"]);
							openDialog(data["content"].serialize(),"/integration/sapLog/logMainDetailAJAX.jsp");
					}
	 				
				},"json");
			}*/
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
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!"))
				{
				window.location.href="/integration/sapLog/logMainDetail.jsp?opera=delete&sid="+requestids;
				}
			}		
		}
		
		function doDeleteAll(){
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>!")){
					window.location.href="/integration/sapLog/logMainDetail.jsp?opera=deleteAll";
				}
		}
	</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>

