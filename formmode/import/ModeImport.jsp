
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		</style>
	</head>
	<%
		if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		     response.sendRedirect("/notice/noright.jsp");
		     return;
     	}
		String imagefilename = "/images/hdSystem_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(31919,user.getLanguage());//"流程导入";24771
		String needfav = "1";
		String needhelp = "";
		
		String workflowid = Util.null2String(request.getParameter("workflowid"));
		String importtype = Util.null2String(request.getParameter("importtype"));
		String type = Util.null2String(request.getParameter("type"));
		String checkresult = Util.null2String(request.getParameter("checkresult"));
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		
		<div id="loading">
			<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
			<!-- 数据导入中，请稍等... -->
			<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%></span>
		</div>

		<div id="content">
		<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="ModeImportOperation.jsp" enctype="multipart/form-data">
			<table width=100% height=100% border="0" cellspacing="0"
				cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
								<%
									if(checkresult.equals("1")){//流程类型不相等
										out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28211,user.getLanguage())+"<font></span>");
										out.println("<br/>");
									}else if(checkresult.equals("2")){//
										out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28212,user.getLanguage())+"<font></span>");
										out.println("<br/>");
									}
								%>

									<TABLE class=ViewForm>
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
										<TBODY>
											<TR class=Title>
												<TH colSpan=2>
													<!-- 必要信息 -->
													<%=SystemEnv.getHtmlLabelName(25645,user.getLanguage())%>
												</TH>
											</TR>
											<TR class=Spacing style="height:1px;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 导入 -->
													<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>
												</td>
												<td class=Field>
													<button type=BUTTON  class=btnSave onclick="importwf();" title="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>">
														<!-- 开始导入-->
														<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>
													</button>
												</td>
											</tr>
											<TR class=Spacing style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											<tr>
												<td>
													<!-- 文件-->
													XML<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
												</td>
												<td class=Field>
													<input class=InputStyle  type=file size=40 name="filename" id="filename" onChange="checkinput('filename','filenamespan')">
													<span id="filenamespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
												</td>
											</tr>
											<TR style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											
											<TR id=ImportDesc>
												<TD colSpan=2>
													<br>
													<B><%=SystemEnv.getHtmlLabelName(21708,user.getLanguage())%></B>：<!-- 功能说明 -->
													<BR>
													<!-- 有关权限、页面扩展等部分功能由于存在关联性，因此不做导入，有关人力资源等相关设置，请在导入后检查设置-->
													1<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32194,user.getLanguage())%><BR>
													2<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32195,user.getLanguage())%><BR>
												</TD>
											</TR>
										</TBODY>
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
			<div id='divshowreceivied'
				style="background: #FFFFFF; padding: 3px; width: 100%; display: none"
				valign='top'>
			</div>
		</FORM>
		</div>
	</BODY>
	
	<script type="text/javascript">

	jQuery(document).ready(function(){
		jQuery("#loading").hide();
	})

	function importwf()
	{
		var parastr="filename";
		var filename = document.frmMain.filename.value;
		document.frmMain.action = "/formmode/import/ModeImportOperation.jsp";
		if(check_form(document.frmMain,parastr))
		{
			var pos = filename.length-4;
			if(filename.lastIndexOf(".xml")==pos)
			{
				jQuery("#loading").show();
				jQuery("#content").hide();
				//jQuery("#ImportDesc").hide();
				
				document.frmMain.submit();
			}
			else
			{
				alert("<%=SystemEnv.getHtmlLabelName(25644,user.getLanguage())%>");//选择文件格式不正确,请选择xml文件25644
				return;
			}
		}
	}
	</script>
</HTML>