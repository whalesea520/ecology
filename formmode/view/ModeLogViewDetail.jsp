
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<html>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage());//日志
String needfav ="";
String needhelp ="";

String modeId = Util.null2String(request.getParameter("modeId"));
String relatedId = Util.null2String(request.getParameter("relatedId"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSubmit(),_self}";//搜索
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<form name="frmSearch" id="frmSearch" method="post" action="/formmode/view/ModeLogViewDetail.jsp">
<input type="hidden" name="modeId" value="<%=modeId %>"/>
<input type="hidden" name="relatedId" value="<%=relatedId %>"/>
<input type="hidden" name="fieldid" value="<%=fieldid %>"/>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10px">
<col width="*">
<col width="10px">
</colgroup>
<tr>
	<td></td>
	<td valign="top">
		<table class="e8_tblForm" style="margin: 10px 0;">
			<COLGROUP>
				<COL width="15%">
				<COL width="35%">
				<COL width="15%">
				<COL width="35%">
			</COLGROUP>
			<tr>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%><!-- 操作者 --></td>
				<td class="e8_tblForm_field">
					<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid%>' 
									browserOnClick="onShowResourceID('resourceid','resourceidspan')"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="135px" 
									browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>'>
							</brow:browser>
				</td>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><!-- 日期 --></td>
				<td class="e8_tblForm_field">
					<button class="Calendar" id="SelectDate" onclick="getLimitStartDate('fromdatespan','fromdate','todatespan','todate')" type="button"></button>&nbsp;
					<span id="fromdatespan"><%=fromdate %></span> -&nbsp;&nbsp;
					<button class="Calendar" id="SelectDate2" onclick="getLimitEndDate('fromdatespan','fromdate','todatespan','todate')" type="button"></button>&nbsp; 
					<span id="todatespan"><%=todate %></span>
					<input name="fromdate" id="fromdate" type="hidden" value="<%=fromdate %>">
					<input name="todate" id="todate" type="hidden" value="<%=todate %>">
				</td>
			</tr>
			<tr style="height:1px"><td colspan=4 class=Line></td></tr>
		</table>

		<%
		String perpage = "10";
		String concatS = CommonConstant.DB_CONCAT_SYMBOL;
		String backFields = "a.id, a.fieldid, a.fieldvalue, b.operateuserid, b.operatedate"+concatS+"' '"+concatS+"b.operatetime as operatedatetime, b.operatedesc,c.fieldhtmltype,c.type,c.fielddbtype,c.viewtype ";
		String sqlFrom = " from ModeLogFieldDetail a left join ModeViewLog_"+modeId+" b on a.viewlogid=b.id left join Workflow_billfield c on a.fieldid=c.id ";
		String sqlWhere = " where a.fieldid = "+fieldid+" and b.relatedid = " + relatedId+ " and a.modeId = " + modeId;
		if(!"".equals(resourceid))
		{
		    sqlWhere += " and b.operateuserid = " + resourceid;
		}
		if(!"".equals(fromdate))
		{
		    sqlWhere += " and b.operatedate >= '" + fromdate + "'";				    
		}
		if(!"".equals(todate))
		{
		    sqlWhere += " and b.operatedate <= '" + todate + "'";
		}
		String sqlOrderBy = " operatedate , operatetime ";
		String tableString=""+
					  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
						  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"b.id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+sqlOrderBy+"\" />"+
						  "<head>"+   //操作者            
								  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"operateuserid\" orderkey=\"operateuserid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
								  //类型
								  "<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"operatedesc\" orderkey=\"operatedesc\" />"+
								  //日期时间
								  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(82281,user.getLanguage())+"\" column=\"operatedatetime\" orderkey=\"operatedate\" />"+
								  //值
								  "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(19113,user.getLanguage())+"\" column=\"fieldvalue\" transmethod=\"weaver.formmode.service.FormInfoService.getFieldname\" otherpara=\""+user.getLanguage()+"+column:fieldid+column:fieldhtmltype+column:type+column:fielddbtype+column:viewtype\" orderkey=\"fieldvalue\" />"+//TODO 字段值按照类型转换
						  "</head>"+
					  "</table>";
		%>
		
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
		
	</td>
	<td></td>
</tr>
</table>
<script type="text/javascript">
function OnSubmit(){
	var frmSearch = document.getElementById("frmSearch");
	frmSearch.submit();
}

function onShowResourceID(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
		
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
	    		"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (datas) {
		if (datas.id!= "") {
			
			$("#"+spanname).html("<A href='javascript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</A>");

			$("input[name="+inputname+"]").val(datas.id);
		}else{
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
		}
	}
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
