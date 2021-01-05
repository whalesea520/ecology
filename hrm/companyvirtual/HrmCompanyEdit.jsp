<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String id = Util.null2String(request.getParameter("id"),"1");
//String companyname = Util.null2String(CompanyVirtualComInfo.getCompanyname(id));
//String companydesc = Util.null2String(CompanyVirtualComInfo.getCompanydesc(id));
String virtualtype = Util.null2String(CompanyVirtualComInfo.getVirtualType(id));
String virtualtypedesc = Util.null2String(CompanyVirtualComInfo.getVirtualTypeDesc(id));
String showorder = Util.null2String(CompanyVirtualComInfo.getShowOrder(id));
String companyname = virtualtype;
String companydesc = virtualtype;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage())+":"+companyname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;   
if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){
	canEdit = true;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="CompanyOperation.jsp" method=post>
<input class=inputStyle type=hidden id="id" name="id" value=<%=id%>>
<input class=inputStyle type=hidden name="cmd" value="edit">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'> 
   <wea:item><%=SystemEnv.getHtmlLabelName(34069,user.getLanguage())%></wea:item>
   <wea:item><%if(canEdit){%>
   <INPUT class=inputStyle maxLength=60 size=50 id="virtualtype" name="virtualtype" value="<%=virtualtype%>" onchange='checkinput("virtualtype","virtualtypeimage")'> 
   <SPAN id=virtualtypeimage></SPAN>         
   <%}else{%><%=virtualtype%><%}%></wea:item>  
   <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
   <wea:item><%if(canEdit){%>
   <INPUT class=inputStyle maxLength=60 size=50 name="virtualtypedesc" value="<%=virtualtypedesc%>" onchange='checkinput("virtualtypedesc","virtualtypedescimage")'>
   <SPAN id=virtualtypedescimage></SPAN>
   <%}else{%><%=virtualtypedesc%><%}%></wea:item>   
   <wea:item><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></wea:item>
   <wea:item><%if(canEdit){%>
   <INPUT class=inputStyle maxLength=60 size=50 name="showorder" value="<%=showorder%>">
   <%}else{%><%=virtualtypedesc%><%}%></wea:item>    
	</wea:group>
</wea:layout>
 </form>
    <%if("1".equals(isDialog)){ %>
    </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
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
function submitData() {
 if(check_form(frmMain,'virtualtype,virtualtypedesc')){
	//校验重复名
 	var id = jQuery("#id").val();
 	var virtualtype = jQuery("#virtualtype").val();
 	jQuery.ajax({
		url:"/hrm/ajaxData.jsp?cmd=checkvirtualtype&virtualtype="+virtualtype+"&id="+id,
		type:"post",
		async:true,
		success:function(data,status){
			if(data.trim()=="1"){
				frmMain.submit();
			}else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26603, user.getLanguage())%>");
			}
		},
	});
 }
}
</script>
</BODY></HTML>
