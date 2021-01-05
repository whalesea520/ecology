<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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
int id = Util.getIntValue(request.getParameter("id"),0);
String companyname = CompanyComInfo.getCompanyname(""+id);

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
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="CompanyOperation.jsp" method=post>
<input class=inputStyle type=hidden name="id" value=<%=id%>>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
<%
  String sql = "select * from HrmCompany where id = "+ id;
  rs.executeSql(sql);
  if(rs.next()){
%>    
   <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
   <wea:item><%if(canEdit){%>
   <INPUT class=inputStyle maxLength=60 size=50 name="companyname" value="<%=companyname%>" onchange='checkinput("companyname","companynameimage")'>
   <SPAN id=companynameimage></SPAN>
   <%}else{%><%=rs.getString("companyname")%><%}%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
   <wea:item><%if(canEdit){%>
   <INPUT class=inputStyle maxLength=60 size=50 name="companydesc" value="<%=rs.getString("companydesc")%>" >          
   <%}else{%><%=rs.getString("companydesc")%><%}%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15768,user.getLanguage())%></wea:item>
   <wea:item><%if(canEdit){%>
   <INPUT class=inputStyle maxLength=60 size=50 name="companyweb" value="<%=rs.getString("companyweb")%>" >          
   <%}else{%><%=rs.getString("companyweb")%><%}%></wea:item>    
<%
}
%>        
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
 if(check_form(frmMain,'companyname')){
 frmMain.submit();
 }
}
</script>

</BODY></HTML>
