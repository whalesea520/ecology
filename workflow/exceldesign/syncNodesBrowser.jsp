<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	int layouttype = Util.getIntValue(request.getParameter("layouttype"), -1);
	int from_nodeid = Util.getIntValue(request.getParameter("from_nodeid"), 0);
	int from_modeid = Util.getIntValue(request.getParameter("from_modeid"), 0);
	int isclose = Util.getIntValue(request.getParameter("isclose"), 0);
%>
<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		var parentWin = parent.getParentWindow(window);
		var dialog = parent.getDialog(window);
		
		var isclose="<%=isclose %>";
		if(isclose=="1"){
			parentWin.location.reload();
		    dialog.close();
		}
	</script>
</HEAD>
<BODY>
<div class="zDialog_div_content" style="height: 100%!important;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(21738,user.getLanguage())+",javascript:onSyncAllNodes(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(125066, user.getLanguage())%>"/>
</jsp:include>
<TABLE id="browserTable" class=ListStyle cellspacing=0 STYLE="margin-top:0">
	<TR class=header>
		<TH width=20%><input type="checkbox" id="checknode_all" name="checknode_all"/></TH>
		<TH width=40%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
		<TH width=30%><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></TH>
	</tr>
<%
int rowNum=0;
String tempNodeid="",tempNodename="",tempNodetype="";
String sql = "select a.nodeId,b.nodeName,a.nodeType from  workflow_flownode a,workflow_nodebase b "
		   + "where a.workflowId="+wfid+" and a.nodeId<>"+from_nodeid+" and a.nodeid=b.id "
		   + " and (b.isFreeNode != '1' OR b.isFreeNode IS null) order by a.nodeorder";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	tempNodeid=Util.null2String(RecordSet.getString("nodeId"));
	tempNodename=Util.null2String(RecordSet.getString("nodeName"));
	tempNodetype=Util.null2String(RecordSet.getString("nodeType"));

	if(rowNum%2==0){
%>
<TR class=DataLight>
<%	}else{%>
<TR class=DataDark>
<%	}%>
	<TD>
		<input type="checkbox" name="checknode" value="<%=tempNodeid %>" >
	</TD>	
    <TD><%=tempNodename%></TD>
	<TD>
		<%if(tempNodetype.equals("0")){%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%}%>
		<%if(tempNodetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%><%}%>
		<%if(tempNodetype.equals("2")){%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%}%>
		<%if(tempNodetype.equals("3")){%><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%}%>
	</TD>

</TR>
<%
	rowNum++;
}
%>
</TABLE>
<FORM name="syncForm" action="excel_operation.jsp" method=post>
	<input type="hidden" name="operation" value="syncNodes"/>
	<input type="hidden" name="wfid" value="<%=wfid %>"/>
	<input type="hidden" name="layouttype" value="<%=layouttype %>"/>
	<input type="hidden" name="from_nodeid" value="<%=from_nodeid %>"/>
	<input type="hidden" name="from_modeid" value="<%=from_modeid %>"/>
	<input type="hidden" name="to_nodes" />
</FORM>
<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
</div>
<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:217px;position:absolute;z-index:9999;font-size:12px;">
	<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage())%></span>
	<div style="display:none;"><img src="/wui/theme/ecology8/skins/default/rightbox/icon_query_wev8.png" /></div>
</span>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="submitBtn" class="zd_btn_submit" onclick="onSure();">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="cancelBtn" class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</div>
</BODY>
</HTML>
<script language="javascript">
jQuery(document).ready(function(){
	jQuery("#checknode_all").click(function(){
		var state = jQuery("#checknode_all").attr("checked");
		jQuery("input[name='checknode']").each(function(){
			if(state){
				$(this).attr("checked",true).next().addClass("jNiceChecked");
			}else{
				$(this).attr("checked",false).next().removeClass("jNiceChecked");
			}
		});
	});
});
	
function onSure(){
	var obj=$("[name='checknode']:checked");
	if(obj.size()==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128086, user.getLanguage())%>");
	}else{
		__setloaddingeffect();
		
		var to_nodes="";
		obj.each(function(index){
			if(index!=0)	to_nodes +=",";
			to_nodes +=$(this).val();
		});
		$("[name='to_nodes']").val(to_nodes);
    	window.document.syncForm.submit();
    }
}

function onClose(){
	if(dialog){
	    dialog.close();
	}
}

function onSyncAllNodes(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129030, user.getLanguage())%>",function(){
		$("[name='checknode']").attr("checked",true).next().addClass("jNiceChecked");
		onSure();
	});
}

function __setloaddingeffect() {
	try {
		var pTop= document.body.offsetHeight/2 - (50/2);
		var pLeft= document.body.offsetWidth/2 - (217/2);
		jQuery("#submitloaddingdiv").css({"top":pTop, "left":pLeft, "display":"inline-block;"});
		jQuery("#submitloaddingdiv").show();
		jQuery("#submitloaddingdiv_out").show();
	} catch (e) {}
}
</script>