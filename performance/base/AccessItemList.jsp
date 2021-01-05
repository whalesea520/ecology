<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	boolean canEdit = false;
	if(HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		canEdit = true;
	}
	int msg = Util.getIntValue(request.getParameter("msg"));
	String titlename = "执行力-考核指标项";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<style type="text/css">
			table.ListStyle{background: #F2F2F2 !important;}
			table.ListStyle tr.Header th{background: #ECECEC !important;}
			table.ListStyle tr.DataDark td{background: #F7F7F7 !important;}
			table.ListStyle td{padding-top: 4px !important;padding-bottom: 4px !important;}
		</style>
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			if (HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)) {
				RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ",AccessItemAdd.jsp,_top} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr>
				<td height="2" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<%if(msg==1){ %>
								<font style="color: red">已存在相同名称的指标项！</font>
								<%} %>
								<TABLE class=ListStyle cellspacing=1>
									<COLGROUP>
										<COL width="20%">
										<COL width="30%">
										<COL width="10%">
										<COL width="10%">
										<COL width="20%">
										<COL width="10%">
									</COLGROUP>
									<TBODY>
										<TR class=Header>
											<th>指标名称</th>
											<th>指标描述</th>
											<th>指标类型</th>
											<th>数值单位</th>
											<th>计算公式</th>
											<th>是否启用</th>
										</tr>
										<%
											rs.executeSql("select id,itemname,itemdesc,itemtype,itemunit,isvalid,formula,formuladetail from GP_AccessItem");
											boolean isLight = false;
											while (rs.next()) {
												if (isLight = !isLight) {
										%>
										<TR CLASS=DataLight>
										<%
												} else {
										%>
										<TR CLASS=DataDark>
										<%
												}
										%>
											<TD>
												<%if(canEdit){ %>
													<a href="AccessItemEdit.jsp?id=<%=rs.getString(1)%>">
													<%=Util.toScreen(rs.getString("itemname"), user.getLanguage())%>
													</a>
												<%}else{ %>
													<%=Util.toScreen(rs.getString("itemname"), user.getLanguage())%>
												<%} %>
											</TD>
											<TD><%=Util.toScreen(rs.getString("itemdesc"), user.getLanguage())%></TD>
											<TD><%if("1".equals(rs.getString("itemtype"))){ %>定性<%}else{ %>定量<%} %></TD>
											<TD><%=Util.toScreen(rs.getString("itemunit"), user.getLanguage())%></TD>
											<TD>
												<%if("1".equals(rs.getString("formula"))){%>
													公式1[完成值/目标值*5]
												<%}else if("2".equals(rs.getString("formula"))){ %>
													公式2[项目收款]
												<%}else if("3".equals(rs.getString("formula"))){ %>
													公式3[项目验收]
												<%}else if("4".equals(rs.getString("formula"))){ %>
													公式4[技术任务量]
												<%}else if("5".equals(rs.getString("formula"))){ %>
													公式5[目标值/完成值*3.5]
												<%}else if("11".equals(rs.getString("formula"))){%>
													完成值/目标值*最大分制
												<%}else if("12".equals(rs.getString("formula"))){%>
												   <%=rs.getString("formuladetail").replace("gval","目标值").replace("cval","完成值") %>
												<%}else if("13".equals(rs.getString("formula"))){ %>
												   调用Java类：<%=rs.getString("formuladetail") %>
												<%} %>
											</TD>
											<TD><%=cmutil.getYN(Util.getIntValue(rs.getString("isvalid"),0)+"",user.getLanguage()+"")%></TD>
										</TR>
										<%
											}
										%>
								</TABLE>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
	</BODY>
</HTML>
