
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>
<head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
if(!HrmUserVarify.checkUserRight("Email:monitor",user)){
	response.sendRedirect("/notice/noright.jsp") ;
}
%>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String resource = Util.null2String(request.getParameter("resource"));
String subject = Util.null2String(request.getParameter("subject"));
String department = Util.null2String(request.getParameter("department"));
String subdepartment = Util.null2String(request.getParameter("subdepartment"));
String datetype = Util.null2String(request.getParameter("datetype"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
%>
<script type="text/javascript">

function searchName(){
	var searchName = jQuery("#searchName").val();
	location.href = "MailMonitorLog.jsp?subject="+searchName;
}	

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

jQuery(function(){
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
});

function searchInfo(){
	document.frmmain.submit();	
}
</script>
<%

String sqlWhere="1=1";

if(!"".equals(resource)){
	sqlWhere += " and resourceid = '"+resource+"'";
}

if(!"".equals(subject)){
	sqlWhere += " and subject like '%"+subject+"%'";
}

if(!"".equals(department)){
	sqlWhere += " and submiter in (SELECT id FROM HrmResource WHERE departmentid = "+department+")";
}

if(!"".equals(subdepartment)){
	sqlWhere += " and submiter in (SELECT id FROM HrmResource WHERE subcompanyid1 = "+subdepartment+")";
}

if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlWhere += " and submitdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
	sqlWhere += " and submitdate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 23:59:59'";
}

if("6".equals(datetype) && !"".equals(startdate)){
	sqlWhere += " and submitdate > '"+startdate+" 00:00:00'";
}

if("6".equals(datetype) && !"".equals(enddate)){
	sqlWhere += " and submitdate < '"+enddate+" 23:59:59'";
}


String backfields = "*";
String fromSql ="MailLog";

sqlWhere = Util.toHtmlForSplitPage(sqlWhere);
String orderby = "id";
String tableString =" <table instanceid=\"readinfo\" tabletype='none'  pageId=\""+PageIdConst.Email_MonitorLog+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_MonitorLog,user.getUID(),PageIdConst.EMAIL)+"\" >"+ 
       "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"/>"+
       "<head>"+
       "<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(15502,user.getLanguage()) +"\" column=\"submitdate\" />"+ 
       "<col width=\"15%\"  target=\"_fullwindow\" text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"submiter\""+
  		" orderkey=\"resourceid\" href=\"/hrm/resource/HrmResource.jsp?1=1\"  linkkey=\"id\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"  />"+
       "<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" column=\"logtype\""+
       "  transmethod=\"weaver.email.MailSettingTransMethod.getMailMonitorType\"/>"+ 
       "<col width=\"50%\"  text=\""+ SystemEnv.getHtmlLabelName(106,user.getLanguage()) +"\" column=\"subject\""+
       "  transmethod=\"weaver.email.MailSettingTransMethod.getMailSubject\"/>"+ 
	   "<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(25060,user.getLanguage()) +"\" column=\"clientip\" />"+ 
	   "</head>"+   			
	   "</table>";			
%>
<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31704,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		    <span title="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="searchInfo()" type="button"  value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<!-- 高级搜索 -->
<div class="zDialog_div_content" style="height:526px;">
<form id="frmmain" name="frmmain" action="MailMonitorLog.jsp" method="post">
	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(83117,user.getLanguage())%></wea:item>
	        <wea:item>
	        	<brow:browser viewType="0" name="resource" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		         browserValue='<%=resource%>' 
		         browserSpanValue = '<%=ResourceComInfo.getResourcename(resource)%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp" width="80%" ></brow:browser>        
	        </wea:item> 
	        
  				<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="subdepartment" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
		         browserValue='<%=subdepartment%>' 
		         browserSpanValue = '<%=SubCompanyComInfo.getSubCompanyname(subdepartment)%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=164" width="80%" ></brow:browser> 
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="department" 
		         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
		         browserValue='<%=department%>' 
		         browserSpanValue = '<%=DepartmentComInfo.getDepartmentName(department)%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=4" width="80%" ></brow:browser> 
			</wea:item>
			
	        <wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
	        <wea:item>
	        	<input type="text" id="subject" name="subject" value="<%=subject%>"/>       
	        </wea:item> 
	        
	        
	        <wea:item><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></wea:item>
	        <wea:item>
        		<span>
		        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 120px;">
					  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
					  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
					  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
					  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
					  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
					  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
					</SELECT> 
			 	</span>  
				<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
			        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)" value="<%=startdate%>"></button>
					<span id="startdatespan"><%=startdate%></span>
					<input type="hidden" id="startdate" name="startdate">
					－
					<button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
					<span id="enddatespan"><%=enddate%></span>
					<input type="hidden" id="enddate" name="enddate">
				</span>
	        </wea:item>
	     </wea:group>
	</wea:layout>	        
</form>
<div class="zDialog_div_content" style="height:396px;">

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_MonitorLog%>">	
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" />

</body>
<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
