<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<%
	
boolean canedit = HrmUserVarify.checkUserRight("EditWorkType:Edit",user);
if(!canedit){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String id = request.getParameter("id");
String referenced = request.getParameter("referenced");

String fullname="";
String description="";
String worktypecode="";
String dsporder="";

RecordSet.executeProc("Prj_WorkType_SelectByID",id);
if(RecordSet.next()){
	fullname= Util.null2String(RecordSet.getString("fullname"));
	description= Util.null2String(RecordSet.getString("description"));
	worktypecode= Util.null2String(RecordSet.getString("worktypecode"));
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
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" ;
if (canedit) {
  titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(432,user.getLanguage());
} else {
  titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(432,user.getLanguage());
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value="<%=WorkTypeComInfo.getWorkTypename(id) %>"/>
</jsp:include>  
<FORM id=weaver action="/proj/Maint/WorkTypeOperation.jsp" method=post onsubmit='return check_form(this,"type")'>
<%
if(HrmUserVarify.checkUserRight("EditWorkType:Edit", user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
}

if(HrmUserVarify.checkUserRight("EditWorkType:Delete", user)){

//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
//RCMenuHeight += RCMenuHeightStep;

}
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="id" value="<%=id%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(15795,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=20 name="type" value="<%=fullname %>" onchange='checkinput("type","typeimage")'><SPAN id=typeimage><%="".equals(fullname)?"<IMG src='/images/BacoError_wev8.gif' align=absMiddle>":"" %></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle name="txtWorktypecode" maxLength=150 size=50 value="<%=worktypecode %>" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=150 size=50 name="desc" value="<%=description %>" onchange=''>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle onkeyup="clearNoNum(this)" style="width:80px!important;" maxLength=8 size=10 name="dsporder" value="<%=dsporder %>"   >
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
if ("<%=referenced%>"=="yes") {
	//alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>") ;
 }
function submitData()
{
	if (check_form(weaver,'type')){
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
				parentWin._table.reLoad();
				parentWin.closeDialog();
			}
		});
	}
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
</script>
</BODY>
</HTML>
