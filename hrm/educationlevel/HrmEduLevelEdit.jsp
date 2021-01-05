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
 rs.executeProc("HrmEducationLevel_SelectByID",""+id);
 
	String name = "";
	String description = "";
 if(rs.next()){
	name = rs.getString("name");
	description = rs.getString("description");
	}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(818,user.getLanguage())+":"+name;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
<%if(isclose.equals("1")){%>
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();
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
if(HrmUserVarify.checkUserRight("HrmEducationLevelEdit:Edit", user)){
	canEdit = true;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="EduLevelOperation.jsp" method=post>
<%if(msgid!=-1){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage()) + SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="namespan" required="true" value='<%=name%>'>
					<%if(canEdit){%><input class=inputstyle type=text maxlength="30" name="name"  value="<%=name%>" onchange="checkinput('name','namespan')">
          <%}else{%><%=name%><%}%>
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(818,user.getLanguage()) + SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="descriptionspan" required="true" value='<%=description%>'>
					<%if(canEdit){%><input class=inputstyle type=text size=60 maxlength="60" name="description" value="<%=description%>" onchange='checkinput("description","descriptionspan")'>
          <%}else{%><%=description%><%}%>
				</wea:required>
			</wea:item>
		</wea:group>
	</wea:layout>
  <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
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
 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'name,description')){
		var ajax=ajaxinit();
		ajax.open("POST", "/hrm/educationlevel/EduLevelCheck.jsp", true);
		ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		ajax.send("saveType=edit&id=<%=id%>&name="+jQuery("input[name='name']").val());
		ajax.onreadystatechange = function() {
		if (ajax.readyState == 4 && ajax.status == 200) {
			try{
				if(ajax.responseText==1){
					document.frmMain.operation.value="edit";
					document.frmMain.submit();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("818,195,24943",user.getLanguage())%>");
					return false;
				}
			}catch(e){
				return false;
			}
		}
		}
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY>
</HTML>
