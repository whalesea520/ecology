<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.docs.category.security.AclManager "%>
<%@ page import="weaver.docs.category.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.PageManagerUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="HandwrittenSignatureManager" class="weaver.mobile.webservices.workflow.soa.HandwrittenSignatureManager" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
	boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user);  //�жϵ�ǰ�û���Ȩ��
	if (!HrmUserVarify.checkUserRight("HandwrittenSignatureList:List",user)) {
		response.sendRedirect("/notice/noright.jsp");
	}
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = "<b>"
			+ SystemEnv.getHtmlLabelName(30493, user.getLanguage())
			+ "</b>";
	String needfav = "1";
	String needhelp = "1";
	
	RecordSet rs = new RecordSet();
	int uid = 0;
	String  deptid = Util.null2String(request.getParameter("deptid"));
	String username = Util.null2String(request.getParameter("username"));
	if(!("".equals(username))){
		request.setAttribute("username",username);
	}
	String sql = "select id from HrmResource where lastname = '"+username+"'";
	rs.executeSql(sql);
	if(rs.next()){
		uid = rs.getInt("id");
	}

	//������ҳ�ؼ���Ҫ��where���
	String andSql = ""; //ƴ�Ӳ�ѯ����
	String tableName= "";
	if ((!"".equals(deptid))&&("".equals(username))){
		tableName = "HandwrittenSignature as hs,HrmResource as hr";
		andSql = " hs.hrmresid=hr.id and hr.departmentid= "+deptid ;
	}if((!"".equals(username))&&("".equals(deptid))){
		tableName = "HandwrittenSignature as hs";
		andSql = " hs.hrmresid = "+uid+"";
	}if((!"".equals(deptid)) && (!"".equals(username))){
		tableName = "HandwrittenSignature as hs,HrmResource as hr";
		andSql = " hs.hrmresid=hr.id and hr.departmentid= '"+deptid+"' and hs.hrmresid = "+uid+"";
	}if(("".equals(deptid)) && ("".equals(username))){
		tableName = "HandwrittenSignature";
		andSql+=" 1=1";
	}
		//out.println("andSql:" + andSql);
%>
<html>
	<head>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" type="text/css" href="/wui/common/css/base.css" />
		<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
		<SCRIPT language="javascript" src="/js/weaver.js"></script>
		<SCRIPT language="javascript">
			function onRefrush(){
			    weaver.submit();
			}
			
			function onNew(){
			    window.location="/mobile/plugin/1/HandwrittenSignatureAdd.jsp";
			}
			
			 //ɾ��
            function onDelete(){
              	if(_xtable_CheckedCheckboxId()==""){
              		alert("��ѡ����Ҫɾ�������ݣ�");
              	}else if(confirm("ȷ��Ҫɾ����")){
              		document.getElementById("markIds").value =_xtable_CheckedCheckboxId();
              		HandwrittenSignatureList.opera.value="deletelist";
	                HandwrittenSignatureList.action="UploadHandwrittenSignature.jsp";
	                HandwrittenSignatureList.submit();
              	}
              }
              
              //��һҳ
              function onTopPage(){
                  _table.prePage();
              }
			   //��һҳ
              function onNextPage(){
                _table.nextPage();
              }
              //��ҳ
              function onFirstPage(){
               _table.firstPage();
                
              }
               //βҳ
              function onEndPage(){
	             _table.lastPage();
	             
              }
		</script>

	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())+ ",javascript:onRefrush(),_top} ";
			RCMenuHeight += RCMenuHeightStep;
			if(HrmUserVarify.checkUserRight("HandwrittenSignatureAdd:Add", user)) {
				RCMenu += "{"+ SystemEnv.getHtmlLabelName(16387, user.getLanguage())+",javascript:onNew(),_top} ";
				RCMenuHeight += RCMenuHeightStep;
			}
			
			RCMenu += "{ɾ ��" + ",javascript:onDelete()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{��  ҳ " + ",javascript:onFirstPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{��һҳ " + ",javascript:onTopPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{��һҳ" + ",javascript:onNextPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{β  ҳ " + ",javascript:onEndPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>


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
								<form id="weaver" name="weaver" method="post" action="HandwrittenSignatureList.jsp">
									<table class=ViewForm>
										<colgroup>
											<col width="20%">
											<col width="80%">
										<tbody>
											<TR style="height: 1px !important;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></td>
												<td class=field>
													<input class="wuiBrowser"
														_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
														_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(deptid+ ""), user.getLanguage())%>"
														type="hidden" name="deptid" id="deptid" value="<%=deptid%>">
												</td>
											</tr>
											<TR style="height: 1px !important;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
											<!-- ������ -->
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(25034, user.getLanguage())%></td>
												<td class=field>
													<input id="username" name="username" type="text" 
													<%if((!"".equals(request.getParameter("username")))&&(null!=(request.getParameter("username"))) ) {%> value="<%=request.getParameter("username")%><%}%>">
												</td>
											</tr>
											<TR style="height: 1px !important;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
										</tbody>
									</table>
								</form>
								<br>

								<TABLE width=100% height=100% border="0" cellspacing="0">
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
											<form name="HandwrittenSignatureList" method="post">
											  <input type="hidden" name = "opera" id= "opera" >
								  			  <input type="hidden" name="markIds" id="markIds">
												<TABLE class=Shadow>
													<tr>
														<td valign="top">
															<%
																int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
																int perpage = UserDefaultManager.getNumperpage();
																if (perpage < 2)
																	perpage = 10;

																String backfields = "markId,markName,hrmresid,markDate,lastmodificationtime"; // �����ֶ�
																String fromSql = tableName; //��ѯ�ı�
																String fromWhere = "where" + andSql; //��ѯ���� sqlwhere=\""+Util.toHtmlForSplitPage(fromWhere)+"\" ��Ҫ���ھ���Util.toHtmlForSplitPage()��������ת��,ȥ����<��,��>��,���������ַ���
																//��ѯ��ͷ������
																String name = SystemEnv.getHtmlLabelName(413, user.getLanguage()); //����
																String markName = SystemEnv.getHtmlLabelName(30491, user.getLanguage()); //����ǩ������
																String markDate = SystemEnv.getHtmlLabelName(30494, user.getLanguage()); //����ǩ�´���ʱ��
																String lastModificationTime = SystemEnv.getHtmlLabelName(30495,user.getLanguage()); //����ǩ������޸�ʱ��
																String operation = SystemEnv.getHtmlLabelName(30495, user.getLanguage()); //����
																String edit = SystemEnv.getHtmlLabelName(93, user.getLanguage()); //�༭
															//	String popedomOtherpara2 = "column:markId+column:markName+column:hrmresid+column:markDate+column:lastmodificationtime";
																//backfields - �����ֶ���  fromSql - ��ѯ�ı�  sqlorderby - ��������  sqlprimarykey - �˱�������������������ֶΣ� 
																//sqlsortway - ����ʽ   sqlwhere - ��ѯ����  sqldistinct - �Ƿ��ų��ظ�����
																//col  ��һ�� ʹ��transmethod ���� ��Ҫ����ת������   Ҳ���ǰ� id��ֵ���� ͼ��

																//��ҳ�ؼ���ʹ��
																String tableString = ""
																		+ "<table instanceid=\"workflowRequestListTable\" pagesize=\""
																		+ perpage
																		+ "\" tabletype=\"checkbox\">"
																		
																		+ "<sql backfields=\""
																		+ backfields
																		+ "\" sqlform=\""
																		+ fromSql
																		+ "\" sqlsortway=\"Desc\" sqlprimarykey=\"markId\" sqlwhere=\""
																		+ Util.toHtmlForSplitPage(fromWhere)
																		+ "\" sqldistinct=\"true\" />"
																		
																		+ "<head>"
																		+ "<col width=\"20%\" text=\""
																		+ name
																		+ "\"  column=\"hrmresid\"  href=\"\" onclick=\"pointerXY(event)\" orderkey=\"hrmresid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"

																		+ "<col width=\"20%\" text=\""
																		+ markName
																		+ "\"  column=\"markName\"  orderkey=\"markId\"/>"

																		+ "<col width=\"20%\" text=\""
																		+ markDate
																		+ "\"  column=\"markDate\"  orderkey=\"markDate\"/>"

																		+ "<col width=\"20%\" text=\""
																		+ lastModificationTime
																		+ "\"  column=\"lastModificationTime\"  orderkey=\"lastModificationTime\"/>"

																		+"</head>"
																		+ "<operates width=\"20%\">"
																		+ 		"<operate href=\"/mobile/plugin/1/HandwrittenSignatureEdit.jsp\" linkkey=\"markId\" linkvaluecolumn=\"markId\" text=\""+ edit+ "\" target=\"_fullwindow\" index=\"1\"/>"
																		+ "</operates>"
																		+"</table>";
															%>
															<table width="100%">
																<tr>
																	<td valign="top">
																		<wea:SplitPageTag tableString="<%=tableString%>" mode="run"
																			isShowTopInfo="true" isShowBottomInfo="true" />
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</TABLE>
												</td>
												</tr>
											</form>
								</TABLE>
							</td>
						</tr>
					</TABLE>
				</td>
			</tr>
		</table>
	</body>
</html>