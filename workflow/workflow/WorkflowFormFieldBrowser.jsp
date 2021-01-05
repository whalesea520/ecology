
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<TITLE><%=SystemEnv.getHtmlLabelNames("33251,23182", user.getLanguage())%></TITLE>
	</HEAD>
<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String needfav = "1";
	String needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(23182, user.getLanguage());

	String wfid = Util.null2String(request.getParameter("wfid"));
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String type = Util.null2String(request.getParameter("type"));

	rs.executeSql("SELECT isbill,formid FROM workflow_base WHERE id='"+wfid+"'");
    String isbill = "";
    String formid = "";
	if (rs.next()) {
		isbill = rs.getString("isbill");
		formid = rs.getString("formid");
    }

	String backfields = "";
	String fromSQL = "";
	String sqlWhere = "" ;
	String mkey = "";
	if ("0".equals(isbill)) {
		String isdetail = "";
		String groupId = "";
		rs.executeSql("SELECT isdetail,groupId FROM workflow_formfield WHERE formid='"+formid+"' AND fieldid='"+fieldid+"'");
		if (rs.next()) {
			isdetail = rs.getString("isdetail");
			groupId = rs.getString("groupId");
		}

		mkey = "t1.fieldid";
		backfields = " t1.fieldid AS id,fieldlable AS label,type,t1.groupId AS fieldsource";
		if ("1".equals(isdetail)) {
			//明细表（可以取得主表的字段）
			fromSQL = " FROM workflow_formfield t1 INNER JOIN workflow_fieldlable t2 ON t2.fieldid=t1.fieldid INNER JOIN workflow_formdictdetail t3 ON t3.id=t1.fieldid";
			sqlWhere = " WHERE t1.formid='"+formid+"' AND (t1.isdetail IS NULL OR t1.isdetail<>'1' OR (t1.isdetail='1' AND t1.groupId='"+groupId+"')) AND t2.formid='"+formid+"' AND t2.langurageid='7' AND t3.fieldhtmltype='3' AND t3.type IN ("+type+")";
		} else {
			//主表
			fromSQL = " FROM workflow_formfield t1 INNER JOIN workflow_fieldlable t2 ON t2.fieldid=t1.fieldid INNER JOIN workflow_formdict t3 ON t3.id=t1.fieldid";
			sqlWhere = " WHERE t1.formid='"+formid+"' AND (t1.isdetail IS NULL OR t1.isdetail<>'1') AND t2.formid='"+formid+"' AND t2.langurageid='7' AND t3.fieldhtmltype='3' AND t3.type IN ("+type+")";
		}
	} else {
		mkey = "id";
		backfields = " id,fieldlabel AS label,type,detailtable AS fieldsource";
		fromSQL = " FROM workflow_billfield";
		sqlWhere = " WHERE billid='"+formid+"' AND fieldhtmltype='3' AND type IN ("+type+") AND (detailtable='' OR detailtable IS NULL OR detailtable=(SELECT detailtable FROM workflow_billfield WHERE billid='"+formid+"' AND id='"+fieldid+"'))"; 
	}

	String tableString = ""+
	"<table pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWFORMFIELDBROWSER,user.getUID())+"\" tabletype=\"none\">"+
	"<sql backfields=\""+backfields+"\" showCountColumn=\"false\" sqlform=\""+Util.toHtmlForSplitPage(fromSQL)+"\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\"fieldsource,type\" sqlprimarykey=\""+mkey+"\" sqlsortway=\"asc\" />"+
	"<head>"+							 
			 "<col hide=\"true\" text=\"\" column=\"id\" />"+
			 "<col width=\"34%\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"label\" transmethod=\"weaver.workflow.search.WorkflowSearchUtil.getFieldNameFromTable\" otherpara=\""+isbill+"+"+user.getLanguage()+"\" />"+
			 "<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"type\" transmethod=\"weaver.workflow.search.WorkflowSearchUtil.getBrowserName\" otherpara=\""+user.getLanguage()+"\" />"+
			 "<col width=\"33%\" text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"fieldsource\" transmethod=\"weaver.workflow.search.WorkflowSearchUtil.getFieldSource\" otherpara=\""+user.getLanguage()+"\" />"+
	"</head>"+ 
	"</table>";
%>
	<BODY>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>

		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311, user.getLanguage())+",javascript:clearData(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmMain name=frmMain action="" method=post>
	            <input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_WORKFLOW_WORKFLOWFORMFIELDBROWSER%>"/>
				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />

						</wea:item>
					</wea:group>
				</wea:layout>

			</FORM>
		</div>

		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_submit" onclick="clearData();" style="width: 50px!important;">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 50px!important;">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<!-- end -->

	</BODY>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}

		function clearData() {
			selectData('', '');
		}

		function selectData(id, name) {
			var returnjson = {id: id, name: name};
			if(dialog){
				try {
					dialog.callback(returnjson);
				} catch(e) {}

				try {
					dialog.close(returnjson);
				} catch(e) {}
			}else{
				window.parent.parent.returnValue = returnjson;
				window.parent.parent.close();
			}
		}

		jQuery(function(){
			jQuery("#_xTable").bind("click",BrowseTable_onclick);
		});

		function BrowseTable_onclick(e){
		   var e=e||event;
		   var target=e.srcElement||e.target;

			if( target.nodeName =="TD"||target.nodeName =="A"  ){
				var pNode = target.parentNode;
				if(pNode.nodeName!="TR"){
					pNode = pNode.parentNode;
				}

				selectData(jQuery(jQuery(target).parents("tr")[0].cells[1]).text().trim(), jQuery(jQuery(target).parents("tr")[0].cells[2]).text().trim());
			}
		}
	</script>
</HTML>
