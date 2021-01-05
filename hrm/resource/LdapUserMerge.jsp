<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	   
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(33269,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	int ldapUserId = Util.getIntValue(request.getParameter("id"),0);
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	
	String sql = "";
	sql = "select loginid,lastname from HrmResource where id="+ldapUserId;
	
	String ldapUserAccount = "";
	String ldapUserLastName = "";
	rs.executeSql(sql);
	if(rs.next()){
		ldapUserAccount = Util.null2String(rs.getString("loginid"));
		ldapUserLastName = Util.null2String(rs.getString("lastname"));
	}
	
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.doRefresh();
				dialog.closeByHand();
				//parentWin.delLine(<%=ldapUserId%>);
			}
			
			function doMerge() {
				if($.trim($("#resourceid").val())){
					document.resource.submit();
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				}
				parentWin.location.reload();
			}
		</script>
	</head>
	<BODY>
		<div class="zDialog_div_content">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(216,user.getLanguage())+",javascript:doMerge(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(216,user.getLanguage())%>" class="e8_btn_top" onclick="doMerge();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=resource name=resource action="/hrm/resource/LdapUserMergeOperator.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(33268,user.getLanguage())%></wea:item>
					<wea:item><%=ldapUserAccount%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33270,user.getLanguage())%></wea:item>
					<wea:item><%=ldapUserLastName%></wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33210,user.getLanguage())%></wea:item>
					<wea:item>
					
					<brow:browser viewType="0" name="resourceid" browserValue='<%= ""+resourceid %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqltag=0"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' 
								completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
								browserSpanValue='<%=Util.toScreen(resourceComInfo.getResourcename(resourceid+""),user.getLanguage())%>'></brow:browser>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input class=inputstyle type=hidden name=operation value="merge">
			 <input class=inputstyle type=hidden name=ldapUserId value="<%=ldapUserId%>">
			 <input class=inputstyle type=hidden name=ldapUserAccount value="<%=ldapUserAccount%>">
		</form>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</BODY>
</HTML>
