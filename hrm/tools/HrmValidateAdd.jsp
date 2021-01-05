<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String id = Util.null2String(request.getParameter("id"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();	
	}
jQuery(document).ready(function(){
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
});
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32744,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<FORM id=weaver name=frmMain action="HrmValidateOperation.jsp" method=post >
<input class=inputstyle type=hidden name=method value="add">
<%
String name= "";
String validate_n= "";
String tab_url= "";
String tab_type= "";
String tab_index= "";
if(id.length()==0)
{
	rs.executeSql("select max(id) from hrmlistvalidate ");
	if(rs.next())
	{
		id = String.valueOf(rs.getInt(1)+1);
		validate_n = "1";
	}
}
else
{
	rs.executeSql("select id, name, validate_n, tab_url, tab_type, tab_index from hrmlistvalidate where id =" +id);
	if(rs.next())
	{
		id = rs.getString("id"); 
		name= rs.getString("name");
		validate_n= rs.getString("validate_n");
		tab_url= rs.getString("tab_url");
		tab_type= rs.getString("tab_type");
		tab_index= rs.getString("tab_index");
	}
}
%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text name=name size="30" maxlength="30" value='<%=name %>' onchange="checkinput('name','namespan')">
    	<span id="namespan"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text name=tab_url size="50" maxlength="250" value='<%=tab_url %>' onchange="checkinput('tab_url','tab_urlspan')">
    <span id="tab_urlspan">
    <IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15603,user.getLanguage())%></wea:item>
    <wea:item>
    	<input tzCheckbox="true" class=inputstyle type=checkbox name=validate value="1" <%=validate_n.equals("1")?"checked":"" %> >
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></wea:item>
    <wea:item>
    	<input class=inputstyle type=text name=tab_index value="<%=tab_index%>">
    	<input class=inputstyle type=hidden name=id value="<%=id%>">
    	<input class=inputstyle type=hidden name=tab_type value="2">
    </wea:item>
	</wea:group>
</wea:layout>
  </form>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="" >
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			checkinput('name','namespan');
			checkinput('tab_url','tab_urlspan');
		});
	</script>
<%} %>

<script language=javascript>  
function submitData() {
 if(check_form(frmMain,'name,tab_url')){
 	frmMain.submit();
 }
}
</script>

</BODY></HTML>
