
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script>

var canDelete="<%=Util.null2String(request.getParameter("state"))%>";
if(canDelete=="nodelete")top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21799,user.getLanguage())%>");
var dialog = parent.parent.getDialog(parent); 
</script>

<style>
table td.interval{
  border:none;
}
table td.fieldName{
  border:none;
}
table tr.Spacing td{
  border:none;
}
table tr.intervalTR>td{
  border:none;
}
table td.field{
  border:none;
}

</style>

</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
int detachable = 0;
ManageDetachComInfo comInfo =  new ManageDetachComInfo();
boolean isUseHrmManageDetach=comInfo.isUseDocManageDetach();
if(isUseHrmManageDetach){
	detachable=1;
}
boolean canEdit=HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user);
int subcompanyid1 =  Util.getIntValue(request.getParameter("subcompanyid1"),0);
String urlfrom = request.getParameter("urlfrom");
String isDialog = Util.null2String(request.getParameter("isdialog"));
session.setAttribute("DocMouldDsp_",String.valueOf(subcompanyid1));
String mouldname,mouldtext;
int mouldType,subcompanyid;
	MouldManager.setId(id);
	MouldManager.getMouldInfoById();
	MouldManager.getMouldSubInfoById();
	mouldname=MouldManager.getMouldName();
	mouldtext=MouldManager.getMouldText();
	mouldType= MouldManager.getMouldType();
	subcompanyid = MouldManager.getSubcompanyid1();
	MouldManager.closeStatement();

boolean canNotDelete = false;
RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 where t1.mouldId = "+id+" and mouldType in(2,4,6,8)");
if(RecordSet.getCounts()>0){
    canNotDelete = true;
}
	//System.out.println("MouldText:"+mouldtext);
	//System.out.println("id:"+id);


if(mouldType > 1){//Modify by 杨国生 2004-10-25 For TD1271
	if(canEdit){
    response.sendRedirect("DocMouldEditExt.jsp?isdialog=2&id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1);
	}else{
	 response.sendRedirect("DocMouldDspExt.jsp?isdialog=2&id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1);
	}
	return;
}else{
    if(canEdit){
    response.sendRedirect("DocMouldEdit.jsp?isdialog=2&id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1);
	return;
	}
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String log_id = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
  log_id ="110";
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"："+mouldname;
  log_id ="75";
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("2".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=urlfrom value="<%=urlfrom%>">
<%if(!isDialog.equals("2")){ %>
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/docs/mouldfile/DocMouldEdit.jsp?isdialog=2&id="+id+"&urlfrom="+urlfrom+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/docs/mouldfile/DocMouldAdd.jsp?isdialog=1&urlfrom="+urlfrom+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere="+xssUtil.put("where operateitem=75 and relatedid="+id)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+",_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
</DIV>
<%} %>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		<wea:item>
		<%=id%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
		<%=mouldname%>
		</wea:item>
		<%if(urlfrom.equals("hr")){%>
		<%if(detachable==1){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		<wea:item>
		<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>
		</wea:item>
		<%}%>
		<%}%>
		<wea:item attributes="{'colspan':'full','samePair':'imgfield','display':'none'}">
			<div></div>
		</wea:item>
		<wea:item attributes="{'colspan':'full'}">
			<%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%=mouldtext%>
		</wea:item>
	</wea:group>
</wea:layout>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=mouldname value="<%=mouldname%>">
<textarea id="mouldtext" name=mouldtext style="display:none;width:100%;height=500px">##<%=mouldtext%></textarea>
</FORM>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("2".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
</body>

<script>
try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}
function onDelete(){

	if(<%=canNotDelete%>){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23134,user.getLanguage())%>");
		return;
	}

	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.weaver.operation.value='delete';
		document.weaver.submit();
	});
}

</script>
