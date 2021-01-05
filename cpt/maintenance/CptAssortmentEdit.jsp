<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String paraid = Util.null2String(request.getParameter("paraid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String assortmentid = paraid;

RecordSet.executeProc("CptCapitalAssortment_SByID",assortmentid);
RecordSet.next();
int subcompanyid1 = Util.getIntValue(RecordSet.getString("subcompanyid1"),0) ;
String assortmentname = RecordSet.getString("assortmentname");
String assortmentmark = RecordSet.getString("assortmentmark");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String subassortmentcount= RecordSet.getString("subassortmentcount");
String capitalcount= RecordSet.getString("capitalcount");
String roleid= RecordSet.getString("roleid");

boolean canedit = HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage())+" : "+ Util.toScreen(assortmentname,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value="<%=CapitalAssortmentComInfo.getAssortmentName(paraid) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% 

if(canedit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
/**
if(HrmUserVarify.checkUserRight("CptAssortment:Log", user)){
if(RecordSet.getDBType().equals("db2")){
 RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) = 43 and relatedid="+assortmentid+",_self} " ;  
}else{

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid="+assortmentid+",_self} " ;
}
	
	RCMenuHeight += RCMenuHeightStep ;
}
**/
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
<%
if(canedit){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onEdit();">
	<%
}
%>		
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
if(msgid!=-1){
out.print( "<font color=red size=2>" + SystemEnv.getErrorMsgName(msgid,user.getLanguage()) +"</font>") ;
}
%>

<FORM name=frmMain id=frmMain action="CptAssortmentOperation.jsp" method=post >

<input type="hidden" name="assortmentid" value="<%=assortmentid%>">
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>

<%
if(subcompanyid1>0){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="subcompanyid1" browserValue='<%=subcompanyid1>0?""+subcompanyid1:""%>' browserSpanValue='<%=subcompanyid1>0? SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1)):""%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='0'
						completeUrl="/data.jsp?type=164" />
		
		</wea:item>
	<%
}

%>	
<%
if(Util.getIntValue( supassortmentid,0)>0){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelNames("596,831",user.getLanguage())%></wea:item>
		<wea:item>
			<span><%=CapitalAssortmentComInfo.getAssortmentName(supassortmentid) %> </span>
		</wea:item>
	<%
}

%>		
	
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="assortmentname_span" required="true" value='<%=Util.toScreenToEdit(assortmentname,user.getLanguage())%>'>
				<input class="InputStyle"  id=assortmentname  name=assortmentname onchange="checkinput(this.name,'assortmentname_span')"  size="30" value="<%=Util.toScreenToEdit(assortmentname,user.getLanguage())%>"  >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="assortmentmark_span" required="true" value='<%=Util.toScreenToEdit(assortmentmark,user.getLanguage())%>'>
				<input class="InputStyle"  id=assortmentmark  name=assortmentmark onchange="checkinput(this.name,'assortmentmark_span')"  size="30" value="<%=Util.toScreenToEdit(assortmentmark,user.getLanguage())%>"  >
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		<wea:item>
			<TEXTAREA  style="WIDTH:95%;overflow-x:visible;overflow-y:visible;" name=Remark rows=8><%=Util.toScreenToEdit(assortmentremark,user.getLanguage())%></TEXTAREA>
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
	


<script language=javascript>
 function onEdit(){
 	if(check_form(document.frmMain,'assortmentmark,assortmentname')){
 		document.frmMain.operation.value="editassortment";
		//document.frmMain.submit();
		var supassortmentid='<%=supassortmentid %>';
 		var form=jQuery("#frmMain");
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
				if(msg&&msg.msgid){
					if(msg.msgid==31||msg.msgid==162){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83665",user.getLanguage())%>");
					}else{
						parentWin._table.reLoad();
						parentWin.refreshLeftTree();
						parentWin.closeDialog();
					}
				}else{
					parentWin._table.reLoad();
					parentWin.refreshLeftTree();
					parentWin.closeDialog();
				}
			}
		});
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deleteassortment";
			document.frmMain.submit();
		}
}
 </script>

<SCRIPT language=VBS>
sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub 
</script>

</BODY></HTML>
