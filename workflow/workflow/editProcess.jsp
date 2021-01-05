
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("id"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >

var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	try{
		parentWin._table.reLoad();
	}catch(e){}
	dialog.close();	
}
function onSave(){
	if(check_form(weaver,"label")){
		weaver.submit();
	}
}

</script>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
int linkType = 1;
rs.executeSql("select * from workflow_processdefine where id="+id);
String label = "";
String sortorder = "0.00";
int showlabelid = -1;
String nameSim = "";
String nameEn = "";
String nameTrand = "";
int isSys = 0;
if(rs.next()){
	label = Util.null2String(rs.getString("label"));
	sortorder = rs.getString("sortorder");
	showlabelid = Util.getIntValue(rs.getString("shownamelabel"),-1);
	isSys = Util.getIntValue(rs.getString("isSys"),0);
	if(showlabelid!=-1){
		nameSim = SystemEnv.getHtmlLabelName(showlabelid,7,true);
		nameEn = SystemEnv.getHtmlLabelName(showlabelid,8,true);
		nameTrand = SystemEnv.getHtmlLabelName(showlabelid,9,true);
	}
	linkType = Util.getIntValue(rs.getString("linktype"),1);
}

%>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=label%>");
	}catch(e){
	}
</script>
</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=weaver name="weaver" action="processOperation.jsp" method=post>
	<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelNames("26528,33691",user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%if(isSys==1){ %>
					<%=label %>
				<%}else{ %>
					<wea:required id="labelspan" required="true" value='<%=label %>'>
						<input  value="<%=label %>" temptitle="<%=SystemEnv.getHtmlLabelNames("26528,33691",user.getLanguage())%>" type="text" class="InputStyle" name="label" id="label" onchange="checkinput('label','labelspan');"/>
					</wea:required>
				<%} %>
				
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelNames("30828",user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input  value="<%=nameSim %>" type="text" class="InputStyle" name="nameSimple" id="nameSimple"/>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelNames("15513",user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input type="text" class="InputStyle"  value="<%=sortorder %>" name="sortorder" id="sortorder" value="0.0"/>
			</wea:item>
		</wea:group>
	</wea:layout>

			<input type="hidden" name="isdialog" value="<%=isDialog%>">
		<input type="hidden" id = "id" name="id" value="<%=id %>">
		<input type="hidden" id = "shownamelabel" name="shownamelabel" value="<%=showlabelid %>">
          <input type=hidden value="editProcess" name="src">
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY></HTML>

