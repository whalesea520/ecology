<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="weaver.meeting.MeetingBrowser"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>

<%
//会议提醒模板
if(!HrmUserVarify.checkUserRight("Meeting:Remind", user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
/*权限判断结束*/

int id=Util.getIntValue(request.getParameter("id"));
if(id<=0){
	response.sendRedirect("/notice/noright.jsp");	
	return;	
}

String method=Util.null2String(request.getParameter("method"));
String type="";
String mode="";
String titlemsg=Util.null2String(request.getParameter("titlemsg"));
String desc_n=Util.null2String(request.getParameter("desc_n"));
String bodymsg=Util.null2String(request.getParameter("bodymsg"));
String needclose="false";
if("edit".equals(method)){
	RecordSet.execute("update meeting_remind_template set title='"+titlemsg+"',body='"+bodymsg+"',desc_n='"+desc_n+"' where id="+id);
	needclose="true";
}else{
	RecordSet.execute("select * from meeting_remind_template where id="+id);
	if(RecordSet.next()){
		type=RecordSet.getString("type");
		mode=RecordSet.getString("modetype");
		titlemsg=RecordSet.getString("title");
		desc_n=RecordSet.getString("desc_n");
		bodymsg=RecordSet.getString("body");
	}else{
		response.sendRedirect("/notice/noright.jsp");	
		return;	
	}
}
String titlename = SystemEnv.getHtmlLabelName(32714,user.getLanguage());
int langid=user.getLanguage();
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">


var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);	
function jsOK(){
	$('#myForm').submit();	
}
var obj;
function insertTemplate(value){
	if(obj){
		jQuery(obj).insertContent(value);
	}else{
		jQuery("#bodymsg").insertContent(value);
	}
}

function changefoucus(thisobj){
	obj=thisobj;
}

function changeTitle(){
	if($("#type").find("option:selected").attr("hastitle")=='1'){
		showEle("titletr", true);
	}else{
		hideEle("titletr", true);
		obj=null;
	}
}

$(document).ready(function() {
	 changeTitle();
	 jQuery("#remindVariable").perfectScrollbar();
	 if("<%=needclose%>"=="true"){
	 	parentWin.closeDlgARfsh();
	 }
});
</script>
<style>
	.e8_btn{
		white-space:nowrap;
	}
</style>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:jsOK();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="jsOK();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="myForm" name="myForm" action="remindInfo.jsp" method="post">
	<input name="id" type="hidden" value="<%=id %>">
	<input name="method" type="hidden" value="edit">
 	<table cellspacing="0" style="background-color: rgb(248,248,248)">
 		<tr>
 		 <td width="70%" valign="top">
 		 	<wea:layout type="2col">
		 		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage()) %>' attributes="{'groupSHBtnDisplay':'none'}">
		 			<wea:item>
		 				<%=SystemEnv.getHtmlLabelName(18713, user.getLanguage()) %>
		 			</wea:item>
		 			<wea:item>
		 				<select id="type" name="type"  onchange="changeTitle()" disabled>
		 					<%RecordSet.execute("select * from meeting_remind_type");
		 					while(RecordSet.next()){
		 						String i=RecordSet.getString("id");
							 %>	
							 <option value="<%=i %>"  hastitle="<%=RecordSet.getInt("hastitle") %>" <%=i.equals(type)?"selected":"" %>><%=MeetingBrowser.getRemindName(Util.getIntValue(i),langid)%></option> 
							 <%	}%>
		 				</select>
		 			</wea:item>
		 			<wea:item>
		 				<%=SystemEnv.getHtmlLabelName(82212, user.getLanguage()) %>
		 			</wea:item>
		 			<wea:item>
		 				<select name="mode" disabled>
		 					<%RecordSet.execute("select * from meeting_remind_mode");
		 					while(RecordSet.next()){
		 						String i=RecordSet.getString("type");
							 %>	
							 <option value="<%=i %>" <%=i.equals(mode)?"selected":"" %>><%=RecordSet.getString("name")%></option> 
							 <%	}%>
		 				</select>
		 			</wea:item>
		 			<wea:item  attributes="{'samePair':'titletr'}">
		 				<%=SystemEnv.getHtmlLabelNames("64,229", user.getLanguage()) %>
		 			</wea:item>
		 			<wea:item  attributes="{'samePair':'titletr'}">
		 				<input type="text" id="titlemsg" name="titlemsg" value="<%=titlemsg %>" class="InputStyle" onfocus="changefoucus(this)"  style="width:90%">
		 			</wea:item>
		 			<wea:item>
		 				<%=SystemEnv.getHtmlLabelName(18693, user.getLanguage()) %> 
		 			</wea:item>
		 			<wea:item>
		 				<textarea rows="8" style="width:90%" id="bodymsg" name="bodymsg" value="<%=bodymsg %> " onfocus="changefoucus(this)"><%=bodymsg %> </textarea> 
		 			</wea:item>
		 		</wea:group>
		 	</wea:layout>	
 		 </td>
 		 <td  width="30%">
 		 	<table class="LayoutTable" id="" style="display:;width:100%;">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr class="intervalTR" _samepair="" style="display:">
						<td colspan="2">
							<table class="LayoutTable" style="width:100%;">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<tbody><tr class="groupHeadHide">
									<td class="interval">
										<span class="groupbg"> </span>
										<span class="e8_grouptitle"><%=SystemEnv.getHtmlLabelNames("33415,33748", user.getLanguage()) %></span>
									</td>
									<td class="interval" colspan="2" style="text-align:right;">
												<span class="toolbar">
												</span>
										<span _status="0" class="hideBlockDiv" style="display:none">
											<!----><img src="/wui/theme/ecology8/templates/default/images/2_wev8.png"> 
										</span>
									</td>
								</tr>
							</tbody></table>
						</td>
					</tr>
					<tr class="Spacing" style="height:1px;display:">
						<td class="Line" colspan="2">
					</td></tr>
			</tbody>
	    </table>
		<div id="remindVariable" style="height:270px;overflow: hidden">	
			<div style="background-color: rgb(248,248,248) !important">
 				<%
 				MeetingFieldManager hfm = new MeetingFieldManager(1);
 				List<String> fieldList=hfm.getTemplateField();
				for(String fieldid:fieldList){
					int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
					String template="#["+MeetingFieldComInfo.getFieldname(fieldid)+"]";
				%>	
					<button style="padding-left: 0px !important; padding-right: 0px !important" type=button  class="e8_btn" onclick="insertTemplate('<%=template %>')"><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"-"+template%></button><br> 
				<%	
				}
 				%>
 			</div>
		</div>					
 		 </td>
 		</tr>
 		<tr style="height:1px!important;display:;" class="Spacing">
			<td class="paddingLeft" colspan="2">
				<div class="intervalDivClass">
			</div></td>
		</tr>
 	</table>
 	
 	<div></div>
 	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    </td></tr>
	</table>
</div>
</form>
</BODY>
</HTML>
