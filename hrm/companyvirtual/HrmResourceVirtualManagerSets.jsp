<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String ids = Util.null2String(request.getParameter("ids"));
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String virtualtype = DepartmentVirtualComInfo.getVirtualtype(departmentid);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
String sql = " SELECT lastname "
					 + " FROM HrmResourceVirtual a, HrmResource b "
					 + " WHERE a.resourceid = b.id AND a.id in( "+ids+")";
rs.executeSql(sql);
String lastname="";
while(rs.next()){
	if(lastname.length()>0)lastname+=",";
	lastname+=rs.getString("lastname");
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
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
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="ResourceOperation.jsp" method=post >
   <input type=hidden name=operation>
   <input type=hidden name=ids value="<%=ids%>">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
      <wea:item><%=lastname%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(34079,user.getLanguage())%></wea:item>
      <wea:item>
      <%
      String browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?show_virtual_org=-1&virtualtype="+virtualtype+"&selectedids=";
      String completeUrl="/data.jsp?virtualtype="+virtualtype;
      %>
	  	  <brow:browser viewType="0" name="managerid" browserValue="" 
	      browserUrl='<%=browserUrl %>'
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	      completeUrl='<%=completeUrl %>' width="200px"
	      browserSpanValue="">
	      </brow:browser>
      </wea:item>
		</wea:group>
	</wea:layout>
 </FORM>
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
	if(check_form(document.frmMain,'managerid')){
		document.frmMain.operation.value="setVirtualManagers";
		document.frmMain.submit();
	}
}
</script>
</BODY></HTML>
