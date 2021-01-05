<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
 rs.executeProc("HrmJobGroups_SelectById",""+id);
 
 	String jobgroupname = "";	
	String jobgroupremark = "";
 if(rs.next()){	
	jobgroupname = Util.toScreenToEdit(rs.getString("jobgroupname"),user.getLanguage());	
	jobgroupremark = Util.toScreenToEdit(rs.getString("jobgroupremark"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage())+":"+jobgroupname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
<%if(isclose.equals("1")){%>
	var data={id:"<%=id%>",name:"<%=jobgroupname%>"};
	parentWin._writeBackData("jobgroupid",1,data,false,true,true);
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();
	parentWin.leftTreeReload();
<%}%>
</script>
</head>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobGroupsEdit:Edit", user)){
	canEdit = true;
}
%>	
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
<FORM id=weaver name=frmMain action="JobGroupsOperation.jsp" method=post>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
    <wea:item>
	    <%if(canEdit){%><INPUT class=inputstyle type=text  name="jobgroupname" id="jobgroupname"  value="<%=jobgroupname%>" onchange='checkinput("jobgroupname","jobgroupnameimage")'>
	    <%}else{%><%=jobgroupname%><%}%><SPAN id=jobgroupnameimage></SPAN>
	  </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
    <wea:item>
      <%if(canEdit){%><input class=inputstyle type=text name=jobgroupremark  value="<%=jobgroupremark%>">
			<%}else{%><%=jobgroupremark%><%}%>
		</wea:item>
	</wea:group>
</wea:layout> 
 </form> 
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
 <script language=vbs>
sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		frmMain.docid.value=id(0)&""
		docidname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub
</script>

 <script language=javascript>
 function onSave(){
 if(checkNameValid()){
	if(check_form(document.frmMain,'jobgroupmark,jobgroupname')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
  }
 }
 function checkNameValid(){
	var a = jQuery("#jobgroupname").val();
	if(a.indexOf("<") != -1 || a.indexOf(">") != -1){ 
    	alert('<%=SystemEnv.getHtmlLabelName(83504,user.getLanguage()) %>'); 
    	return false;
	} 
	return true;
}
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
