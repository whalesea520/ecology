
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		
	</head>
	<%
		String imagefilename = "/images/hdReport_wev8.gif";
		String titlename = "客户来源数量统计";
		String needhelp = "";
		
		String sqlWhere = "";

		String init = Util.fromScreen3(request.getParameter("init"), user.getLanguage());

		String dateFrom = Util.fromScreen3(request.getParameter("dateFrom"), user.getLanguage());
		String dateTo = Util.fromScreen3(request.getParameter("dateTo"), user.getLanguage());
		if(init.equals("")){
			dateFrom = TimeUtil.getCurrentDateString();
			dateTo = TimeUtil.getCurrentDateString();
		}

		if (!dateFrom.equals("")) {
			sqlWhere += " and t2.createdate >= '" + dateFrom + "'";
		}

		if (!dateTo.equals("")) {
			sqlWhere += " and t2.createdate <= '" + dateTo + "'";
		}
		String sql = "select t1.id,t1.fullname,(select COUNT(t2.id) from CRM_CustomerInfo t2 where (t2.deleted=0 or t2.deleted is null) and t2.source=t1.id "+sqlWhere+") as amount"
			+" from CRM_ContactWay t1 where t1.id in (2,8,14,19,30,31,32)";
	%>
	<BODY  style="overflow: hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="frmMain" name="frmMain" action="SourceStat.jsp" method="post">
		<input type="hidden" name="init" value="0">
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0" valign="top">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr style="height: 10px;">
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top" align="center">
								<table class="ViewForm" style="width: 60%">
									<COLGROUP>
										<COL width="60%">
										<COL width="40%">
									</COLGROUP>
									<TR>
										<TD colspan="2">创建日期：&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(dateFrom,dateFromSpan)"></BUTTON>
												<SPAN id="dateFromSpan"><%=dateFrom%></SPAN>
												<input type="hidden" name="dateFrom" value="<%=dateFrom%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(dateTo,dateToSpan)"></BUTTON>
												<SPAN id="dateToSpan"><%=dateTo%></SPAN>
												<input type="hidden" name="dateTo" value="<%=dateTo%>" />
										</TD>
									</TR>
									<tr style="height: 1px;"><td class=Line colspan=2></td></tr>
									<tr class="header"><td class="Field" style="padding-left: 5px;">类型</td><td class="Field">数量</td></tr>
									<%
										rs.executeSql(sql);
										while(rs.next()){
									%>
									<tr>
										<td><%=Util.null2String(rs.getString("fullname")) %></td><td><%=Util.getIntValue(rs.getString("amount"),0) %></td>
									</tr>
									<tr style="height: 1px;"><td class=Line colspan=2></td></tr>
									<%	} %>
								</table>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
		</table>
		</form>
		<script type="text/javascript">
			function onSearch(){
				jQuery("#frmMain").submit();   
			}
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){    
			    	onSearch();   
			    }    
			}
		</script>
	</BODY>
</HTML>