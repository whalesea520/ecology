<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.workflow.workflow.*"%>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="multiLangFilter" class="weaver.filter.MultiLangFilter" scope="page" />
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	boolean haspermission = new WfRightManager().hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String type = Util.null2String(request.getParameter("type"));
	String src = Util.null2String(request.getParameter("src"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String nodename = "";
	
	String backName = Util.null2String(request.getParameter("backName"));
	String backName7 = Util.processBody(backName, "7");
	String backName8 = Util.processBody(backName, "8");
	String backName9 = Util.processBody(backName, "9");
	String nobackName = "";
	String nobackName7 = "";
	String nobackName8 = "";
	String nobackName9 = "";
	
	rs.executeSql("select * from workflow_nodecustomrcmenu where wfid=" + wfid + " and nodeid=" + nodeid);
	if("save".equals(src)) {
		nobackName = Util.null2String(request.getParameter("nobackName"));
		nobackName7 = Util.processBody(nobackName, "7");
		nobackName8 = Util.processBody(nobackName, "8");
		nobackName9 = Util.processBody(nobackName, "9");
		
		String sql = "";
		if(rs.next()) { // update
			if("sub".equals(type)) { // 提交/批准
				sql = "update workflow_nodecustomrcmenu set subbackCtrl = 2, hasback = '1', hasnoback = '1' "
					+ " , subbackName7='" + Util.toHtml100(backName7) + "', subbackName8='" + Util.toHtml100(backName8) + "', subbackName9='" + Util.toHtml100(backName9) + "' "
					+ " , subnobackName7='" + Util.toHtml100(nobackName7) + "', subnobackName8='" + Util.toHtml100(nobackName8) + "', subnobackName9='" + Util.toHtml100(nobackName9) + "' "
					+ " , submitName7='" + Util.toHtml100(backName7) + "', submitName8='" + Util.toHtml100(backName8) + "', submitName9='" + Util.toHtml100(backName9) + "' "
					+ " where wfid=" + wfid + " and nodeid=" + nodeid;
			}else if("forhand".equals(type)) { // 转办
				sql = "update workflow_nodecustomrcmenu set forhandbackCtrl = 2, hasforhandback = '1', hasforhandnoback = '1' "
					+ " , forhandbackName7='" + Util.toHtml100(backName7) + "', forhandbackName8='" + Util.toHtml100(backName8) + "', forhandbackName9='" + Util.toHtml100(backName9) + "' "
					+ " , forhandnobackName7='" + Util.toHtml100(nobackName7) + "', forhandnobackName8='" + Util.toHtml100(nobackName8) + "', forhandnobackName9='" + Util.toHtml100(nobackName9) + "' "
					+ " , forhandName7='" + Util.toHtml100(backName7) + "', forhandName8='" + Util.toHtml100(backName8) + "', forhandName9='" + Util.toHtml100(backName9) + "' "
					+ " where wfid=" + wfid + " and nodeid=" + nodeid;
			}else if("forsub".equals(type)) { // 转发接收人批注
				sql = "update workflow_nodecustomrcmenu set forsubbackCtrl = 2, hasforback = '1', hasfornoback = '1' "
					+ " , forsubbackName7='" + Util.toHtml100(backName7) + "', forsubbackName8='" + Util.toHtml100(backName8) + "', forsubbackName9='" + Util.toHtml100(backName9) + "' "
					+ " , forsubnobackName7='" + Util.toHtml100(nobackName7) + "', forsubnobackName8='" + Util.toHtml100(nobackName8) + "', forsubnobackName9='" + Util.toHtml100(nobackName9) + "' "
					+ " , forsubName7='" + Util.toHtml100(backName7) + "', forsubName8='" + Util.toHtml100(backName8) + "', forsubName9='" + Util.toHtml100(backName9) + "' "
					+ " where wfid=" + wfid + " and nodeid=" + nodeid;
			}else if("ccsub".equals(type)) { // 抄送接收人批注
				sql = "update workflow_nodecustomrcmenu set ccsubbackCtrl = 2, hasccback = '1', hasccnoback = '1' "
					+ " , ccsubbackName7='" + Util.toHtml100(backName7) + "', ccsubbackName8='" + Util.toHtml100(backName8) + "', ccsubbackName9='" + Util.toHtml100(backName9) + "' "
					+ " , ccsubnobackName7='" + Util.toHtml100(nobackName7) + "', ccsubnobackName8='" + Util.toHtml100(nobackName8) + "', ccsubnobackName9='" + Util.toHtml100(nobackName9) + "' "
					+ " , ccsubName7='" + Util.toHtml100(backName7) + "', ccsubName8='" + Util.toHtml100(backName8) + "', ccsubName9='" + Util.toHtml100(backName9) + "' "
					+ " where wfid=" + wfid + " and nodeid=" + nodeid;
			}else if("takingOpinions".equals(type)) { // 意见征询接收人回复
				sql = "update workflow_nodecustomrcmenu set takingOpinionsbackCtrl = 2, hastakingOpinionsback = '1', hastakingOpinionsnoback = '1' "
					+ " , takingOpinionsbackName7='" + Util.toHtml100(backName7) + "', takingOpinionsbackName8='" + Util.toHtml100(backName8) + "', takingOpinionsbackName9='" + Util.toHtml100(backName9) + "' "
					+ " , takingOpinionsnobackName7='" + Util.toHtml100(nobackName7) + "', takingOpinionsnobackName8='" + Util.toHtml100(nobackName8) + "', takingOpinionsnobackName9='" + Util.toHtml100(nobackName9) + "' "
					+ " , takingOpinionsName7='" + Util.toHtml100(backName7) + "', takingOpinionsName8='" + Util.toHtml100(backName8) + "', takingOpinionsName9='" + Util.toHtml100(backName9) + "' "
					+ " where wfid=" + wfid + " and nodeid=" + nodeid;
			}
		}else { // insert
			if("sub".equals(type)) { // 提交/批准
				sql = "insert into workflow_nodecustomrcmenu (wfid, nodeid, subbackCtrl, forhandbackCtrl, forsubbackCtrl, ccsubbackCtrl, takingOpinionsbackCtrl, hasback, hasnoback "
					+ " , subbackName7, subbackName8, subbackName9 "
					+ " , subnobackName7, subnobackName8, subnobackName9 "
					+ " , submitName7, submitName8, submitName9 "
					+ " ) values(" + wfid + ", " + nodeid + ", 2, 0, 0, 0, 0, '1', '1' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " , '" + Util.toHtml100(nobackName7) + "', '" + Util.toHtml100(nobackName8) + "', '" + Util.toHtml100(nobackName9) + "' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " ) ";
			}else if("forhand".equals(type)) { // 转办
				sql = "insert into workflow_nodecustomrcmenu (wfid, nodeid, subbackCtrl, forhandbackCtrl, forsubbackCtrl, ccsubbackCtrl, takingOpinionsbackCtrl, hasforhandback, hasforhandnoback "
					+ " , forhandbackName7, forhandbackName8, forhandbackName9 "
					+ " , forhandnobackName7, forhandnobackName8, forhandnobackName9 "
					+ " , forhandName7, forhandName8, forhandName9 "
					+ " ) values(" + wfid + ", " + nodeid + ", 0, 2, 0, 0, 0, '1', '1' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " , '" + Util.toHtml100(nobackName7) + "', '" + Util.toHtml100(nobackName8) + "', '" + Util.toHtml100(nobackName9) + "' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " ) ";
			}else if("forsub".equals(type)) { // 转发接收人批注
				sql = "insert into workflow_nodecustomrcmenu (wfid, nodeid, subbackCtrl, forhandbackCtrl, forsubbackCtrl, ccsubbackCtrl, takingOpinionsbackCtrl, hasforback, hasfornoback "
					+ " , forsubbackName7, forsubbackName8, forsubbackName9 "
					+ " , forsubnobackName7, forsubnobackName8, forsubnobackName9 "
					+ " , forsubName7, forsubName8, forsubName9 "
					+ " ) values(" + wfid + ", " + nodeid + ", 0, 0, 2, 0, 0, '1', '1' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " , '" + Util.toHtml100(nobackName7) + "', '" + Util.toHtml100(nobackName8) + "', '" + Util.toHtml100(nobackName9) + "' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " ) ";
			}else if("ccsub".equals(type)) { // 抄送接收人批注
				sql = "insert into workflow_nodecustomrcmenu (wfid, nodeid, subbackCtrl, forhandbackCtrl, forsubbackCtrl, ccsubbackCtrl, takingOpinionsbackCtrl, hasccback, hasccnoback "
					+ " , ccsubbackName7, ccsubbackName8, ccsubbackName9 "
					+ " , ccsubnobackName7, ccsubnobackName8, ccsubnobackName9 "
					+ " , ccsubName7, ccsubName8, ccsubName9 "
					+ " ) values(" + wfid + ", " + nodeid + ", 0, 0, 0, 2, 0, '1', '1' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " , '" + Util.toHtml100(nobackName7) + "', '" + Util.toHtml100(nobackName8) + "', '" + Util.toHtml100(nobackName9) + "' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " ) ";
			}else if("takingOpinions".equals(type)) { // 意见征询接收人回复
				sql = "insert into workflow_nodecustomrcmenu (wfid, nodeid, subbackCtrl, forhandbackCtrl, forsubbackCtrl, ccsubbackCtrl, takingOpinionsbackCtrl, hastakingOpinionsback, hastakingOpinionsnoback "
					+ " , takingOpinionsbackName7, takingOpinionsbackName8, takingOpinionsbackName9 "
					+ " , takingOpinionsnobackName7, takingOpinionsnobackName8, takingOpinionsnobackName9 "
					+ " , takingOpinionsName7, takingOpinionsName8, takingOpinionsName9 "
					+ " ) values(" + wfid + ", " + nodeid + ", 0, 0, 0, 0, 2, '1', '1' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " , '" + Util.toHtml100(nobackName7) + "', '" + Util.toHtml100(nobackName8) + "', '" + Util.toHtml100(nobackName9) + "' "
					+ " , '" + Util.toHtml100(backName7) + "', '" + Util.toHtml100(backName8) + "', '" + Util.toHtml100(backName9) + "' "
					+ " ) ";
			}
		}
		rs.executeSql(sql);
	}else {
		backName7 = Util.null2String(request.getParameter("backName7")); // 显示时优先从父页面获取
		if(rs.next()){
			if("sub".equals(type)) { // 提交/批准
				if("".equals(backName7) && "".equals(backName8) && "".equals(backName9)) { // 父页面未填写则从数据库中取
					backName7 = Util.null2String(rs.getString("subbackName7"));
					backName8 = Util.null2String(rs.getString("subbackName8"));
					backName9 = Util.null2String(rs.getString("subbackName9"));
				}
				nobackName7 = Util.null2String(rs.getString("subnobackName7"));
				nobackName8 = Util.null2String(rs.getString("subnobackName8"));
				nobackName9 = Util.null2String(rs.getString("subnobackName9"));
			}else if("forhand".equals(type)) { // 转办
				if("".equals(backName7) && "".equals(backName8) && "".equals(backName9)) { // 父页面未填写则从数据库中取
					backName7 = Util.null2String(rs.getString("forhandbackName7"));
					backName8 = Util.null2String(rs.getString("forhandbackName8"));
					backName9 = Util.null2String(rs.getString("forhandbackName9"));
				}
				nobackName7 = Util.null2String(rs.getString("forhandnobackName7"));
				nobackName8 = Util.null2String(rs.getString("forhandnobackName8"));
				nobackName9 = Util.null2String(rs.getString("forhandnobackName9"));
			}else if("forsub".equals(type)) { // 转发接收人批注
				if("".equals(backName7) && "".equals(backName8) && "".equals(backName9)) { // 父页面未填写则从数据库中取
					backName7 = Util.null2String(rs.getString("forsubbackName7"));
					backName8 = Util.null2String(rs.getString("forsubbackName8"));
					backName9 = Util.null2String(rs.getString("forsubbackName9"));
				}
				nobackName7 = Util.null2String(rs.getString("forsubnobackName7"));
				nobackName8 = Util.null2String(rs.getString("forsubnobackName8"));
				nobackName9 = Util.null2String(rs.getString("forsubnobackName9"));
			}else if("ccsub".equals(type)) { // 抄送接收人批注
				if("".equals(backName7) && "".equals(backName8) && "".equals(backName9)) { // 父页面未填写则从数据库中取
					backName7 = Util.null2String(rs.getString("ccsubbackName7"));
					backName8 = Util.null2String(rs.getString("ccsubbackName8"));
					backName9 = Util.null2String(rs.getString("ccsubbackName9"));
				}
				nobackName7 = Util.null2String(rs.getString("ccsubnobackName7"));
				nobackName8 = Util.null2String(rs.getString("ccsubnobackName8"));
				nobackName9 = Util.null2String(rs.getString("ccsubnobackName9"));
			}else if("takingOpinions".equals(type)) { // 意见征询接收人回复
				if("".equals(backName7) && "".equals(backName8) && "".equals(backName9)) { // 父页面未填写则从数据库中取
					backName7 = Util.null2String(rs.getString("takingOpinionsbackName7"));
					backName8 = Util.null2String(rs.getString("takingOpinionsbackName8"));
					backName9 = Util.null2String(rs.getString("takingOpinionsbackName9"));
				}
				nobackName7 = Util.null2String(rs.getString("takingOpinionsnobackName7"));
				nobackName8 = Util.null2String(rs.getString("takingOpinionsnobackName8"));
				nobackName9 = Util.null2String(rs.getString("takingOpinionsnobackName9"));
			}
		}
		boolean enableMultiLang = Util.isEnableMultiLang();
    	backName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{backName7, backName8, backName9}) : backName7;
    	nobackName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{nobackName7, nobackName8, nobackName9}) : nobackName7;
    	
    	rs.executeSql("select * from workflow_nodebase where id=" + nodeid);
    	if(rs.next()) {
    		nodename = Util.null2String(rs.getString("nodename"));
    	}
	}
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
function closeWindow(src) {
	var dialog = parent.getDialog(window);
	if("save" == src) {
		var parentWin = parent.getParentWindow(window);
		parentWin.onShowBackButtonNameBrowserCallback();
	}
	dialog.close();
}
<% if("save".equals(src)) { %>
closeWindow("save");
<% } %>
</script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ", javascript:onSave(), _self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=nodename %>" />
</jsp:include>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top" onclick="onSave();" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM NAME="SearchForm" id=SearchForm STYLE="margin-bottom: 0" action="showButtonNameBack.jsp" method="post">
		<input type="hidden" name="wfid" value="<%=wfid %>" />
		<input type="hidden" name="nodeid" value="<%=nodeid %>" />
		<input type="hidden" name="type" value="<%=type %>" />
		<input type="hidden" name="src" value="save" />
		<wea:layout type="2col">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(126341, user.getLanguage()) %>">
				<wea:item><%=SystemEnv.getHtmlLabelName(21761, user.getLanguage()) %></wea:item>
				<wea:item>
					<INPUT class=InputStyle maxLength=10 size=14 name="backName" value="<%=backName %>" />
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126349, user.getLanguage()) + "+“（" + SystemEnv.getHtmlLabelName(21761, user.getLanguage()) + "）”" %>">
						<img src="/images/tooltip_wev8.png" align="absMiddle" />
					</span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(21762, user.getLanguage()) %></wea:item>
				<wea:item>
					<INPUT class=InputStyle maxLength=10 size=14 name="nobackName" value="<%=nobackName %>" />
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126349, user.getLanguage()) + "+“（" + SystemEnv.getHtmlLabelName(21762, user.getLanguage()) + "）”" %>">
						<img src="/images/tooltip_wev8.png" align="absMiddle" />
					</span>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeWindow('')">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</body>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
	jQuery("span[class='e8tips']").wTooltip({
  		html : true
  	});
});

function onSave() {
	document.SearchForm.submit();
}
</script>
</html>
