<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-02 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	   
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(20839 ,user.getLanguage())+SystemEnv.getHtmlLabelName(19438,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	String ids = request.getParameter("id");
	int ldapUserId = Util.getIntValue(request.getParameter("id"),0);
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	
	if(ids.endsWith(",")) {
		ids = ids.substring(0, ids.length() - 1);
	}
	String sql = "";
	sql = "select loginid,lastname from HrmResourceTemp where id in ("+ids+")";
	
	ArrayList<String> ldapUserAccountList = new ArrayList<String>();
	ArrayList<String> ldapUserLastNameList = new ArrayList<String>();
	rs.executeSql(sql);
	while(rs.next()){
		ldapUserAccountList.add(Util.null2String(rs.getString("loginid")));
		ldapUserLastNameList.add(Util.null2String(rs.getString("lastname")));
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
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("20839",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("19438",user.getLanguage())%>");
		</script>
		<script type="text/javascript">
			
			function Designate() {
				if($.trim($("#departmentid").val()) !=""){
				var departmentid = $.trim($("#departmentid").val());
					$.ajax({
						url : "/ldap/DesignateOperation.jsp?operation=department&ids="+"<%=ids%>" +"&departmentid="+departmentid,
						type : "post",
						datatype : "json",
						success : function(res) {
							
							if(res.indexOf("success") > 0) {
								parentWin.doRefresh();
								dialog.closeByHand();
							} else {
								dialog.closeByHand();
							}
							
						}
					
					});
					return;
				}else{
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				}
				
			}
		</script>
		
	</head>
	<BODY>
	
		<div class="zDialog_div_content">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(20839 ,user.getLanguage())+SystemEnv.getHtmlLabelName(19438,user.getLanguage())+",javascript:Designate(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(20839 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>" class="e8_btn_top" onclick="Designate();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=resource1 name=resource1 action="/ldap/LdapDesignateDepartment.jsp" method=post >
		<input type="hidden" name="operation" value = "department"></input>
		<input type="hidden" name="ids" value = "<%=ids %>"></input>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(27511,user.getLanguage())%></wea:item>
					
					<wea:item >
					  	<brow:browser viewType="0" id="departmentid"  name="departmentid" browserValue='<%=departmentid %>' 
     						browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
     						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
     						completeUrl="/data.jsp?type=4"
							browserSpanValue='<%=Util.toScreen(departmentComInfo.getDepartmentname(departmentid+""),user.getLanguage())%>'>
						</brow:browser>
					
					<!--<input type="text" name="departmentid" id="departmentid" value="238">-->
				    </wea:item>
					
				</wea:group>
				
			</wea:layout>
			<TABLE class="ListStyle" cellspacing=1>
					<COLGROUP> 
						<COL width="50%">
						<COL width="50%">
					</COLGROUP>
					<TBODY>
					<TR class=header>
	  
					  <TH><nobr><b><%=SystemEnv.getHtmlLabelName(33451,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33268,user.getLanguage())%></b></nobr></TH>
					  <TH><nobr><b><%=SystemEnv.getHtmlLabelName(81812,user.getLanguage())%></b></nobr></TH>
					</TR>
					
				    <%for(int i = 0; i < ldapUserAccountList.size(); i++) { %>
				    <%
					int colorindex = 0;
					if(colorindex==0){
	    			%>
				    <TR class="DataDark">
				    <%
				        colorindex=1;
				    }else{
				    %>
				    <TR class="DataLight">
				    <%
				        colorindex=0;
				    }%>
				    <td><%=ldapUserAccountList.get(i)%></td>
				    <td><%=ldapUserLastNameList.get(i)%></td>
				    </TR>
				    <%}%>
					</TBODY>
				</TABLE>		
			
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
