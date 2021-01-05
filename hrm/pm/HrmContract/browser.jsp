<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-07-15[合同维护] -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(33741, user.getLanguage());
	String qCondition = strUtil.vString(request.getParameter("sqlwhere"), "where 1 = 1");
	String contractname = strUtil.vString(request.getParameter("contractname"));
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var dialog = parent.parent.getDialog(parent);
			try{parent.setTabObjName("<%=titlename%>");}catch(e){}

			function setValue(value) {
				if(dialog) {
					try{dialog.callback(value);}catch(e){}
					try{dialog.close(value);}catch(e){}
				} else {
					window.parent.returnValue = value;
					window.parent.close();
				}
			}

			function cancelValue() {
				if(dialog) dialog.close();
				else window.parent.close();
			}

			function clearValue() {
				setValue({id:"", name:""});
			}

			function afterDoWhenLoaded() {
				$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
					var tr = jQuery(this);
					tr.bind("click",function(){
						var id = tr.children("td:first").children().val();
						var name = tr.children("td:first").next().attr("title");
						setValue({"id":id, "name":name});
					});
				});
			}

		</script>
	</head>
	<body style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.addRight(SystemEnv.getHtmlLabelName(197,user.getLanguage()), "document.searchfrm.submit()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(199,user.getLanguage()), "document.searchfrm.reset()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(311,user.getLanguage()), "clearValue()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(201,user.getLanguage()), "cancelValue()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div class="zDialog_div_content" style="width:100%;height:100%">
			<form id="searchfrm" name="searchfrm" action="">
				<input type="hidden" id="sqlwhere" name="sqlwhere" value="<%=xssUtil.put(qCondition)%>">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right;">
							<%topMenu.show();%>
							<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></wea:item>
						<wea:item>
							<input class="inputstyle" type="text" maxlength="1000" name="contractname" value="<%=contractname%>">
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
			<%
				//TD 391648 tbei 2018-04-28
				String sqlField = "id, contractname,lastname, contractman, contracttypeid, contractstartdate, contractenddate";
				String sqlFrom = "from (select t.id, t.contractname,hr.lastname, t.contractman, t.contracttypeid, t.contractstartdate, t.contractenddate from HrmContract t, hrmresource hr where t.contractman = hr.id ) t";
				String sqlWhere = qCondition;
				if(contractname.length() > 0) {
					sqlWhere += " and contractname like '%"+contractname+"%'";
				}
				SplitPageTagTable table = new SplitPageTagTable(out, user);
				table.addAttribute("tabletype", "none");
				table.addAttribute("sqlsortway", "desc");
				table.setSql(sqlField, sqlFrom, Util.toHtmlForSplitPage(sqlWhere), "id");
				table.addCol("19%", SystemEnv.getHtmlLabelName(15142,user.getLanguage()), "contractname");
				table.addCol("19%", SystemEnv.getHtmlLabelName(15776,user.getLanguage()), "lastname");
				table.addCol("19%", SystemEnv.getHtmlLabelName(6158,user.getLanguage()), "contracttypeid");
				table.addCol("19%", SystemEnv.getHtmlLabelName(1970,user.getLanguage()), "contractstartdate");
				table.addCol("19%", SystemEnv.getHtmlLabelName(15236,user.getLanguage()), "contractenddate");
			%>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=table.toString()%>' selectedstrs="" mode="run"/>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="btnSearch" class="zd_btn_cancle" onclick="document.searchfrm.submit();"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="btnClear" class="zd_btn_cancle" onclick="clearValue();"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="btnCancel" class="zd_btn_cancle" onclick="cancelValue();"/>
					</wea:item>
				</wea:group>
			</wea:layout>
			<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
		</div>
	</body>
</html>
