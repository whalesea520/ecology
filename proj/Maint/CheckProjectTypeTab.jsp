<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<% if(!HrmUserVarify.checkUserRight("EditProjectType:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

String id = request.getParameter("id");
String nameQuery = Util.null2String(request.getParameter("nameQuery"));



String fullname="";
String wfid="";
String description="";
String protypecode="";
String insertworkplan="";
String dsporder="";

RecordSet.executeProc("Prj_ProjectType_SelectByID",id);
if(RecordSet.next()){
	fullname= Util.null2String(RecordSet.getString("fullname"));
	wfid= Util.null2String(RecordSet.getString("wfid"));
	description= Util.null2String(RecordSet.getString("description"));
	protypecode= Util.null2String(RecordSet.getString("protypecode"));
	insertworkplan= Util.null2String(RecordSet.getString("insertworkplan"));
	dsporder= Util.null2String(RecordSet.getString("dsporder"));
}
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
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
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(586,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
/**
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep;
**/
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/proj/Maint/ProjectTypeOperation.jsp" method=post>

  <input type="hidden" name="method" value="edit">
  <INPUT type="hidden" name="id" value="<%=id%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		


  
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(15795,user.getLanguage())%></wea:item>
		<wea:item>
			<span ><%=fullname %></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=protypecode %></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=WorkflowComInfo.getWorkflowname(wfid) %></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33130,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="insertWorkPlan" value="1" <%="1".equals(insertworkplan)?"checked":"" %> disabled  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<span ><%=description %></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=dsporder %></span>
		</wea:item>
	</wea:group>
</wea:layout>	
	
			<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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

</FORM>
<script language="javascript">
function save()
{
	if (check_form(weaver,'type,approvewfid')){
		//weaver.submit();
		var form=jQuery("#weaver");
		var form_data=form.serialize();
		var form_url=form.attr("action");
		jQuery.ajax({
			url : form_url,
			type : "post",
			async : true,
			data : form_data,
			dataType : "json",
			contentType: "application/x-www-form-urlencoded; charset=utf-8", 
			success: function do4Success(msg){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
				try{
					if(parent.parentWin._table){
						parent.parentWin._table.reLoad();
					}
				}catch(e){}
				
			}
		});
	}
}

function onDetailEdit(id){
	var url="/proj/Maint/EditProjectType.jsp?isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("83843",user.getLanguage())%>";
	openDialog(url,title,600,350);
}
</script>
</BODY>
</HTML>
