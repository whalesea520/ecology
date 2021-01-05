
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">		
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	</HEAD>

<%
    if(!HrmUserVarify.checkUserRight("WorkPlanMonitorSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
		
	int userid=user.getUID();
		
	String logintype = user.getLogintype();
	int usertype = 0;
	if(logintype.equals("2"))
	{
		usertype = 1;
	}
	
	//参数传递
	String hrmID = Util.null2String(request.getParameter("hrmID"));
	if(null == hrmID || "".equals(hrmID))
	{
	    hrmID = String.valueOf(userid);
	}
%>

<BODY>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(19793,user.getLanguage());
	String needfav = "1";
	String needhelp = "";	
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
	 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19793,user.getLanguage())%>"/>
</jsp:include>
<div class="zDialog_div_content" style="overflow:auto;">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
		   <td>
			</td>
			<td class="rightSearchSpan" style="text-align:right; ">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
					class="e8_btn_top middle" onclick="doSave()" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
			</td>
		</tr>
	</table>
<FORM name="frmmain" action="/system/systemmonitor/workplan/WorkPlanMonitorSetOperation.jsp" method="post">	
   	<!--================== 日程监控人 ================== -->
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(19794,user.getLanguage())%></wea:item>
			<wea:item>			
				<brow:browser viewType="0" name="hrmID" browserValue='<%=hrmID%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="100px"
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%= Util.toScreen(ResourceComInfo.getResourcename(hrmID),user.getLanguage()) %>'></brow:browser>
				<!--
				<INPUT type="hidden" class="wuiBrowser" name="hrmID" id ="hrmID" value=<%=hrmID%> _displayText="<%= Util.toScreen(ResourceComInfo.getResourcename(hrmID),user.getLanguage()) %>"
					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
					>
					-->
		    </wea:item>
		    <wea:item attributes="{'isTableList':'true'}">
		    <!--================== 日程类型列表 ================== -->
	<TABLE class="ListStyle" cellspacing=1>
		<TR class="header">
			<TH width="5%"><INPUT type=checkbox name="checkAll" id="checkAll" onclick="onCheckAll()"></TH>
			<TH width="95%"><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TH>
		</TR>
		<%
			String sql = "SELECT * FROM WorkPlanType ORDER BY workPlanTypeID ASC";
			RecordSet.executeSql(sql);
			int colorCount = 0;
			while(RecordSet.next())
			{		
				if(0 == colorCount)
				{
			        colorCount = 1;
		%>
			<TR class=DataLight>
		<%
			    }
				else
				{
			        colorCount = 0;
		%>
			<TR class=DataDark>
		<%
			  	}
		%>
			    <TD><INPUT id="workPlanTypeIDs" name="workPlanTypeIDs" type=checkbox value=<%= RecordSet.getInt("workPlanTypeID") %>></TD>
			    <TD><%=Util.forHtml(RecordSet.getString("workPlanTypeName")) %></TD>			    
			</TR>
		<%
			}
		%>
	</TABLE>
		    </wea:item>
		</wea:group>
	</wea:layout>
  
	
</FORM>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
		<tr>
			<td style="text-align: center;border-top:0px;border-bottom:0px;">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</td>
		</tr>
	</table>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>

</HTML>



<SCRIPT language="JavaScript">
function btn_cancle(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
jQuery(document).ready(function(){
	resizeDialog(document);
});

function doSave(obj)
{
   var typeids = document.getElementsByName('workPlanTypeIDs');
   var count = typeids.length;
   var cheked = 0;
   for(var i=0;i<count;i++){
      if(typeids[i].checked)
      cheked++
   }
   if(cheked == 0){
      window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>');
      return;
   }
   if(document.frmmain.hrmID.value==0)
   {
       window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19796,user.getLanguage())%>");
   }
   else
   {
       window.document.frmmain.submit();
       obj.disabled = true;
   }
}

function goBack() 
{
	document.location.href="/system/systemmonitor/workplan/WorkPlanMonitorStatic.jsp"
}

function onCheckAll()
{
	
	jQuery("input[name='workPlanTypeIDs']").each(function(){
		jQuery(this)[0].checked = jQuery("#checkAll")[0].checked;
		if(jQuery("#checkAll")[0].checked==true) {
			jQuery(this).siblings().addClass('jNiceChecked');
		} else {
			jQuery(this).siblings().removeClass('jNiceChecked');
		}
	});
}

function init()
{
<%
	if(!"".equals(hrmID) && null != hrmID)
	{
%>
		
<%
	    RecordSet.executeSql("SELECT * FROM WorkPlanMonitor WHERE hrmID = " + hrmID);
		
	    while(RecordSet.next())
	    {
	        String workPlanTypeID = RecordSet.getString("workPlanTypeID");
%>
			jQuery("input[name='workPlanTypeIDs']").each(function(){
				if(jQuery(this).val() == <%= workPlanTypeID %>)
				{
					jQuery(this)[0].checked = true;
					jQuery(this).siblings().addClass('jNiceChecked');
				}
			});
<%
	    }
%>
		var allChecked = true; 
		jQuery("input[name='workPlanTypeIDs']").each(function(){
			if(!jQuery(this)[0].checked)
			{
				allChecked = false;
			} 
		});
			
	    if(allChecked)
	    {
	    	jQuery("#checkAll")[0].checked = true;
			jQuery("#checkAll").addClass('jNiceChecked');
	    }
<%	    
	}
%>	
}

init();

</SCRIPT>
