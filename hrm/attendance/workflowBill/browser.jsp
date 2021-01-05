<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-05-21[流程表单] -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(34130,user.getLanguage());
	String qCondition = strUtil.vString(request.getParameter("sqlwhere"), "where 1 = 1");
	String namelabel = strUtil.vString(request.getParameter("namelabel"));
	int isBill = strUtil.parseToInt(request.getParameter("isBill"));
	String wfid = strUtil.vString(request.getParameter("wfid"));
	String subCompanyIds = "";
	if(manageDetachComInfo.isUseWfManageDetach()) {
		int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowManage:All");
		for(int i = 0; i < subCompany.length; i++) subCompanyIds += (subCompanyIds.length()==0?"":",") +subCompany[i];
	}
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
						//var name = tr.children("td:first").next().attr("title");
						var name = tr.children("td:first").next().text();
						if(name){
							name = name.replace("\n","").replace("\r","").trim();
						}
						//换行模式下不会设置title属性，导致选择后显示为空
						setValue({"id":id, "name":name});
					});
				});
			}

		</script>
	</head>
	<body>
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
				<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
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
						<wea:item><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="isBill">
								<option value="" <% if(isBill == -1) { %> selected <% } %> ></option>
								<option value="0" <% if(isBill == 0) { %> selected <% } %> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
								<option value="1" <% if(isBill == 1) { %> selected <% } %> ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
							</select>		
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="namelabel" name="namelabel" class="inputStyle" value='<%=namelabel %>'></wea:item>
					</wea:group>
				</wea:layout>
			</form>
			<%
				String sqlField = "id, labelname, formdes";
				String sqlFrom = "from ( select t.id, t.subcompanyid, t2.labelname, t.formdes from workflow_bill t left join HtmlLabelInfo t2 on t.namelabel = t2.indexid and t2.languageid = "+user.getLanguage()+") t";
				String sqlWhere = qCondition;
				if(namelabel.length() > 0) {
					sqlWhere += " and labelname like '%"+namelabel+"%'";
				}
				if(subCompanyIds.length() > 0){
					sqlWhere += " and subcompanyid in ("+subCompanyIds+")";
				}
				if(isBill != -1) {
					sqlWhere += Util.toHtmlForSplitPage(" and id "+(isBill==0?"<":">")+" 0");
				}
				if(wfid.length() > 0) {
					sqlWhere += " and id in (select formid from workflow_base where id = "+wfid+")";
				}
				SplitPageTagTable table = new SplitPageTagTable("Hrm_WorkflowBill", out, user);
				table.addAttribute("tabletype", "none");
				table.addSqlAttribute("sqlsortway", "desc");
				table.setSql(sqlField, sqlFrom, sqlWhere, "id");
				table.addCol("48%", SystemEnv.getHtmlLabelName(195,user.getLanguage()), "labelname");
				table.addCol("47%", SystemEnv.getHtmlLabelName(433,user.getLanguage()), "formdes");
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
