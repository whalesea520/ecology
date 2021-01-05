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
	boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user);  //判断当前用户的权限
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

	//构建分页控件需要的where语句
	String andSql = ""; //拼接查询条件
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
			
			 //删除
            function onDelete(){
              	if(_xtable_CheckedCheckboxId()==""){
              		alert("请选择你要删除的数据！");
              	}else if(confirm("确定要删除？")){
              		document.getElementById("markIds").value =_xtable_CheckedCheckboxId();
              		HandwrittenSignatureList.opera.value="deletelist";
	                HandwrittenSignatureList.action="UploadHandwrittenSignature.jsp";
	                HandwrittenSignatureList.submit();
              	}
              }
              
              //上一页
              function onTopPage(){
                  _table.prePage();
              }
			   //下一页
              function onNextPage(){
                _table.nextPage();
              }
              //首页
              function onFirstPage(){
               _table.firstPage();
                
              }
               //尾页
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
			
			RCMenu += "{删 除" + ",javascript:onDelete()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{首  页 " + ",javascript:onFirstPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{上一页 " + ",javascript:onTopPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{下一页" + ",javascript:onNextPage()',_top} ";
			RCMenuHeight += RCMenuHeightStep;

			RCMenu += "{尾  页 " + ",javascript:onEndPage()',_top} ";
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
											<!-- 按名字 -->
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

																String backfields = "markId,markName,hrmresid,markDate,lastmodificationtime"; // 返回字段
																String fromSql = tableName; //查询的表
																String fromWhere = "where" + andSql; //查询条件 sqlwhere=\""+Util.toHtmlForSplitPage(fromWhere)+"\" 需要需在经过Util.toHtmlForSplitPage()方法进行转换,去除”<”,”>”,”’”三种符号
																//查询表头的名称
																String name = SystemEnv.getHtmlLabelName(413, user.getLanguage()); //姓名
																String markName = SystemEnv.getHtmlLabelName(30491, user.getLanguage()); //电子签章名称
																String markDate = SystemEnv.getHtmlLabelName(30494, user.getLanguage()); //电子签章创建时间
																String lastModificationTime = SystemEnv.getHtmlLabelName(30495,user.getLanguage()); //电子签章最后修改时间
																String operation = SystemEnv.getHtmlLabelName(30495, user.getLanguage()); //操作
																String edit = SystemEnv.getHtmlLabelName(93, user.getLanguage()); //编辑
															//	String popedomOtherpara2 = "column:markId+column:markName+column:hrmresid+column:markDate+column:lastmodificationtime";
																//backfields - 返回字段名  fromSql - 查询的表  sqlorderby - 排序条件  sqlprimarykey - 此表中所需的主键（必填字段） 
																//sqlsortway - 排序方式   sqlwhere - 查询条件  sqldistinct - 是否排除重复操作
																//col  第一行 使用transmethod 属性 需要进行转换的类   也就是把 id数值换成 图标

																//分页控件的使用
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