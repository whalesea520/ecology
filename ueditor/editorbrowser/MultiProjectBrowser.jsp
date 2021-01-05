<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.Hashtable"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/proj/js/multiPrjBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("101",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}

	var dialog = null;
	try{
		dialog = parent.getDialog(window);
	}catch(e){}
</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String worktype = Util.null2String(request.getParameter("worktype"));
String manager = Util.null2String(request.getParameter("manager"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String resourcenames = "";


%>

<script type="text/javascript">
	var btnok_onclick = function(){
			 dialog.OKEvent();
	}

	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>

</HEAD>

<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("101",user.getLanguage()) %>'/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

<div class="zDialog_div_content">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiProjectBrowser.jsp" onsubmit="return false;" method=post>
<input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>



<wea:layout type="4col">

	<wea:group context="查询条件">
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input name=name value='<%=name%>' class="InputStyle"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
			<wea:item>
				<select  class=inputstyle id=status name=status>
				<option value=""></option>
				<% while(ProjectStatusComInfo.next()) {  
					String tmpstatus = ProjectStatusComInfo.getProjectStatusid() ;
				%>
		          <option value=<%=tmpstatus%> <% if(tmpstatus.equals(status)) {%>selected<%}%>>
				  <%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage()),user.getLanguage())%></option>
				<% } %>
		        </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
			<wea:item>
				<select  class=inputstyle id=prjtype name=prjtype>
		        <option value=""></option>
		       	<%
		       	while(ProjectTypeComInfo.next()){
		       	%>		  
		          <option value="<%=ProjectTypeComInfo.getProjectTypeid()%>" <%if(prjtype.equalsIgnoreCase(ProjectTypeComInfo.getProjectTypeid())) {%>selected<%}%>><%=ProjectTypeComInfo.getProjectTypename()%></option>
		            <%}%>
		        </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
			<wea:item>
				<select  class=inputstyle id=worktype name=worktype>
		        <option value=""></option>
		       	<%
		       	while(WorkTypeComInfo.next()){
		       	%>		  
		          <option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%if(worktype.equalsIgnoreCase(WorkTypeComInfo.getWorkTypeid())) {%>selected<%}%>><%=WorkTypeComInfo.getWorkTypename()%></option>
		            <%}%>
		        </select>
			</wea:item>
	<%
	if(!user.getLogintype().equals("2")){
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="manager" 
					browserValue='<%=manager %>' browserSpanValue='<%=ResourceComInfo.getLastname(manager) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" />
			</wea:item>
		<%
	}
	
	%>	
	</wea:group>

	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>

	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item>
						<div id="dialog">
							<div id='colShow'></div>
						</div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>

		</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>

<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=resourceids %>");
});


</SCRIPT>
</BODY>
</HTML>
