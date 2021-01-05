
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
	<%
		String msg = "";
		//判断是否有批量转移权限
		if(!HrmUserVarify.checkUserRight("CRM_BatchTransfer:Operate", user)){
			msg = "您暂时没有客户批量转移权限，如需要可通过提交 <a href=\"javascript:openFullWindowHaveBar('/workflow/request/AddRequest.jsp?workflowid=258&isagent=0&beagenter=0');\">系统调整申请</a> 流程进行申请！";
		}else{
			//工作日需判断时间段
			if(HrmScheduleDiffUtil.getIsWorkday(TimeUtil.getCurrentDateString())){
				int transferStart = 0;
				int transferEnd = 23;
				rs.executeSql("select transferStart,transferEnd from CRM_BatchOperateSetting");
				if(rs.next()){
					transferStart = rs.getInt(1);
					transferEnd = rs.getInt(2);
				}
				msg = "为提高性能，系统";
				int hour = Integer.parseInt(TimeUtil.getFormartString(new Date(),"H"));
				//System.out.println("hour:"+hour);
				if(transferStart>transferEnd){
					msg += "只允许在<font color='red'>工作日</font> <b>"+transferStart+"</b> 点之后或者  <b>"+transferEnd+"</b> 点之前以及<font color='red'>非工作日</font>进行客户批量转移操作！";
					if(hour > transferStart || hour == transferStart || hour < transferEnd){
						response.sendRedirect("/CRM/search/SearchSimple.jsp?actionKey=batchTransfer");
						return;
					}
				}else{
					msg += "只允许在<font color='red'>工作日</font>  <b>"+transferStart+"</b> 点到  <b>"+transferEnd+"</b> 点之间以及<font color='red'>非工作日</font>进行客户批量转移操作！";
					if((hour > transferStart || hour == transferStart) && (hour < transferEnd)){
						response.sendRedirect("/CRM/search/SearchSimple.jsp?actionKey=batchTransfer");
						return;
					}
				}
			}else{
				response.sendRedirect("/CRM/search/SearchSimple.jsp?actionKey=batchTransfer");
				return;
			}
		}
	
		
		
		String imagefilename = "/images/hdNoAccess_wev8.gif";
		String titlename = "客户批量转移";
		String needfav = "";
		String needhelp = "";
	%>
<HTML>
	<HEAD>
		<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
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
									<TR style="height: 10px">
										<TD>&nbsp;</TD>
									</TR>
									<TR>
										<TD align="center"></TD>
									</TR>
									<TR>
										<TH style="font-size: 11pt;font-family: 微软雅黑 !important">系统提示：</TH>
									</TR>
									<TR>
										<TD align="center" style="font-size: 10pt;font-family: 微软雅黑 !important"><%=msg%></TD>
									</TR>
									<TR>
										<TD align="center"></TD>
									</TR>
									<TR class=spacing>
										<TD class=line1></TD>
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