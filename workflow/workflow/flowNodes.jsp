
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
	</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16980,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	// 工作流主键
	int wfid = Util.getIntValue(request.getParameter("workflowId"));
	// 已选节点
	String oldNodeIds = Util.null2String(request.getParameter("oldNodeIds"));

	String tilteName = Util.null2String(request.getParameter("tilteName"));
	tilteName = "".equals(tilteName) ? "128306" : tilteName;

	List<String> nodeIds = new ArrayList<String>();
	if(!"".equals(oldNodeIds)) {
		nodeIds.addAll(Arrays.asList(oldNodeIds.split(",")));
	}
	%>
	<div class="zDialog_div_content">
	
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow"/>
			<jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames(tilteName,user.getLanguage()) %>'/>
	    </jsp:include> 

		<form style="margin-bottom:0" action="" method="post">
			<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
			<table id="nodeTable" class="ListStyle" cellspacing="0">
				<TR class=header>
					<TH width="10%"></TH>
					<TH width="45%"><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
					<TH width="45%"><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></TH>
				</TR>
				<%
				String sql = "SELECT b.id as nodeId,b.nodename as nodeName,a.nodetype AS nodeType FROM workflow_flownode a LEFT JOIN workflow_nodebase b ON a.nodeid = b.id WHERE (b.IsFreeNode IS NULL OR b.IsFreeNode <> '1') AND a.workflowid = "+wfid+" ORDER BY a.nodeorder ASC";
				RecordSet.execute(sql);
				String nodeId = null;	
				String nodeName = null;
				String nodeType = null;
				String nodeTypeText = null;
				while(RecordSet.next()){
					nodeId = Util.null2String(RecordSet.getString("nodeId"));
					nodeName = Util.null2String(RecordSet.getString("nodeName"));
					nodeType = Util.null2String(RecordSet.getString("nodeType"));
					if("0".equals(nodeType)) {// 创建
						nodeTypeText = SystemEnv.getHtmlLabelName(125,user.getLanguage());
					} else if("1".equals(nodeType)) {// 批准
						nodeTypeText = SystemEnv.getHtmlLabelName(142,user.getLanguage());
					} else if("2".equals(nodeType)) {// 提交
						nodeTypeText = SystemEnv.getHtmlLabelName(615,user.getLanguage());
					} else if("3".equals(nodeType)) {// 归档
						nodeTypeText = SystemEnv.getHtmlLabelName(251,user.getLanguage());
					}
				%>
				<TR class=DataDark>
					<TD><input class="Inputstyle" type="checkbox" value="<%=nodeId%>" name="nodeIdBox"  <% if(nodeIds.contains(nodeId)) { %> checked <% } %>></TD>
					<TD class="data"><%=nodeName%></TD>
					<TD><%=nodeTypeText%></TD>
				</TR>
				<%
				}
				%>
			</table>
		</form>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context="<%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%>">
				<wea:item type="toolbar">
					<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSubmit();">
					<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
					<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</BODY>
</HTML>

<script language="javascript">

function onClear(){
	var returnjson = Array("","");
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}
function onSubmit(){
	var nodeIdArr = [];
	var nodeNameArr = [];
	jQuery("input[name='nodeIdBox']:checked").each(function(index,item) {
		nodeIdArr.push(jQuery(item).val());
		nodeNameArr.push(jQuery(item).closest("tr").find("td.data").html());
	});
	//console.log("nodeIds="+nodeIdArr.toString()+",nodeNames="+nodeNameArr.toString());
	var returnjson = Array(nodeIdArr.toString(), nodeNameArr.toString());
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}	
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>