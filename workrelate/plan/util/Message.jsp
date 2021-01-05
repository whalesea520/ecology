<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	int type = Util.getIntValue(request.getParameter("type"),0);
	String message = "";
	if(type==0){
		message = "您暂时无权限查看此页面！";
	}else if(type==1){
		message = "此信息不存在或您暂时无权限查看！";
	}else if(type==2){
		message = "暂未开启任何计划报告周期！<a href='/workrelate/plan/base/BaseFrame.jsp' target='_blank'>设置</a>";
	}else if(type==3){
		message = "保存数据出错，请联系系统管理员！";
	}else if(type==4){
		message = "请在设置中选择查看周期！";
	}
%>
<HTML>
	<HEAD>
		<title>提示</title>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
	</HEAD>
	<BODY>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">

								<TABLE class=ViewForm>
									<TR>
										<TD valign=top>
											<TABLE>
												<TR class=Section>
													<TH style="font-size: 13px;">
														提示：<font style="color:red"><%=message %></font>
													</TH>
												</TR>
											</TABLE>
										</TD>

									</TR>
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