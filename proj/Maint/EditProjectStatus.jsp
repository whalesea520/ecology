<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />

<% if(!HrmUserVarify.checkUserRight("EditProjectStatus:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

int id =Util.getIntValue( request.getParameter("id"),-1);
String nameQuery = Util.null2String(request.getParameter("nameQuery"));


String fullname="";
String description="";
String dsporder="";
String summary="";
if(id!=-1){
	RecordSet.executeProc("Prj_ProjectStatus_SelectByID",""+id);
	if(RecordSet.next()){
		fullname= Util.null2String(RecordSet.getString("fullname"));
		description= Util.null2String(RecordSet.getString("description"));
		dsporder= Util.null2String(RecordSet.getString("dsporder"));
		summary= Util.null2String(RecordSet.getString("summary"));
	}
}else{
	RecordSet.executeSql("select (max(dsporder)+1) as newdsporder  from Prj_ProjectStatus ");
	if(RecordSet.next()){
		dsporder=""+Util.getDoubleValue( RecordSet.getString("newdsporder"),0.0);
	}
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(587,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
/**
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep;
**/
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/proj/Maint/ProjectStatusOperation.jsp" method=post>

  <input type="hidden" name="method" value="<%=id!=-1?"edit":"add" %>">
  <INPUT type="hidden" name="id" value="<%=id %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(HrmUserVarify.checkUserRight("EditProjectStatus:Edit", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="save()"/>
			<%
		}
		%>
			
			
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			
		</div>


  
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelNames("602,195",user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=20 name="type" value="<%=description %>" onchange='checkinput("type","typeimage")'><SPAN id=typeimage><%="".equals(fullname)?"<IMG src='/images/BacoError_wev8.gif' align=absMiddle>":"" %></SPAN>
			<span><img src='/wechat/images/remind_wev8.png' valign="middle" title="<%=SystemEnv.getHtmlLabelName(124997,user.getLanguage()) %>" /></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=150 size=50 name="desc" value="<%=summary %>">
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
function save()
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
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
				try{
					if(parentWin._table){
						parentWin._table.reLoad();
					}
					parentWin.closeDialog();
				}catch(e){}
				
			}
		});
	}
}
$(function(){
	try{
		var id='<%=id %>';
		if(id!=-1){
			parent.setTabObjName("<%=ProjectStatusComInfo.getProjectStatusdesc(""+id) %>");
		}
	}catch(e){
		
	}
	
});
</script>
</BODY>
</HTML>
