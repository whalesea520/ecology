<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetL" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("18553",user.getLanguage())+",javascript:onCompare(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="weaver" id="weaver">
<input type="hidden" name="projid" value="<%=ProjID%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important;display:none;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("18553",user.getLanguage())%>" class="e8_btn_top"  onclick="onCompare()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


</form>

<%

String sqlWhere = "where t1.prjid='"+ProjID+"' ";

int perpage=16;                                 
String backfields = " t1.version,t1.creater,t1.createdate,t1.createtime ";
String fromSql  = " prj_taskinfo t1  ";
String orderby =" t1.version,t1.creater,t1.createdate,t1.createtime  ";
//String groupby =" t1.version,t1.creater,t1.createdate,t1.createtime   ";


String tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				//" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"   sqlprimarykey=\"t1.version\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("567",user.getLanguage())+"\" column=\"version\" orderkey=\"version\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("882",user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("722",user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\"   />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("1339",user.getLanguage())+"\" column=\"createtime\" orderkey=\"createtime\"   />"+
                "       </head>"+
                /**"		<operates>"+
					"		<operate href=\"javascript:onDetail();\" text=\""+SystemEnv.getHtmlLabelName(1293,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+ **/                
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

<script type="text/javascript">
function onBtnSearchClick(){
	weaver.submit();
}

function onCompare(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	//console.log("typeids:"+typeids);
	var vArr= typeids.split(",");
	if(vArr&&vArr.length!=3){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83932",user.getLanguage())%>");
		return;
	}
	var url="/proj/process/ViewPrjCompare.jsp?ProjID=<%=ProjID %>&versions="+typeids+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("18553",user.getLanguage())%>";
	openDialog(url,title,750,400);
	
}

$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>
</BODY>
</HTML>
