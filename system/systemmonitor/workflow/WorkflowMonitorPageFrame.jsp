
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</HEAD>
<BODY>
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(648, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(197,user.getLanguage()) +",javascript:submitForm(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(2022,user.getLanguage()) +",javascript:onReset(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
  <!--高级搜索-->		
<FORM id=weaver name=weaver method=post action="WorkflowMonitorList.jsp"><%--xwj for td2978 20051108--%>
	<input type='hidden' name='fromquery' value='1' />
  <table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:submitForm();"/>&nbsp;&nbsp;
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:onReset();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<div  id="advancedSearchDiv">
   <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
		    	<wea:item>
					<input type="text" style='width:80%;' name="requestname"  value="">
					<input type="hidden" name="pageId" id="pageId" value=""/>
					<input type="hidden" name="offical" id="offical" value="<%=offical %>"/>
					<input type="hidden" name="officalType" id="officalType" value="<%=officalType %>"/>
		    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></wea:item>
	    	<wea:item> <input type="text" name="workcode" style='width:80%;'  value='<%=Util.null2String(request.getParameter("workcode"))%>' ></wea:item>
	    	
	    	<%-- 
	    	<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
	    	<wea:item>
		    	 <brow:browser viewType="0" name="createrid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" hasInput="true" width="135px;float:left" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" _callback="getBrowserJson" browserSpanValue=""></brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>
	    	<wea:item>
		    	 <brow:browser viewType="0" name="createrid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" hasInput="true" width="135px;float:left" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" _callback="getBrowserJson" browserSpanValue=""></brow:browser> 
	    	</wea:item>
	    	--%>
    		<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
	    	<wea:item>
	    	
	    	<brow:browser viewType="0" name="typeid" browserValue=""
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser2.jsp"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser2"
								browserDialogWidth="600px"
								browserSpanValue=""></brow:browser>
	<%--
		    	 <span>
		    		<select id="typeid" name="typeid" onchange="setWFbyType(this)">
		    			<option value="0">&nbsp;</option>
    	  				<%
   	  						WorkTypeComInfo.setTofirstRow();
    	  					while(WorkTypeComInfo.next()){
						%>
						<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" ><%=WorkTypeComInfo.getWorkTypename()%></option>
						<%}%>
		    		</select>
		    	</span>  --%>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<% String wfbytypeBrowserURL = "/workflow/workflow/WFTypeBrowserContenter2.jsp";%>
		    	<brow:browser viewType="0" name="workflowid" browserValue="" browserOnClick="" browserUrl='<%=wfbytypeBrowserURL %>' hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=workflowBrowser2" width="80%" browserSpanValue=""> </brow:browser>
	    	</wea:item>
	    	
	    	<wea:item><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></wea:item>
	    	 <wea:item >
	    		<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
					<input class=wuiDateSel type="hidden" name="createdatefrom" value="<%=Util.null2String(request.getParameter("createdatefrom"))%>">
					<input class=wuiDateSel type="hidden" name="createdateto" value="<%=Util.null2String(request.getParameter("createdateto"))%>">
				</span>
	    	</wea:item>
	    	
	    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
	    	<wea:item >
	    		 <span style='float:left;width: 75px'>
						<select class=inputstyle name=creatertype width="75px" onchange="changeType(this.value,'createridselspan','createrid2selspan');">
						<%if (!user.getLogintype().equals("2")) {%>
						<option value="0"><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%></option>
						<%}%>
						<option value="1"><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></option>
					</select>
    			</span>
		   	   <span id="createridselspan">
                   <brow:browser viewType="0" name="createrid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue=""> 
				   </brow:browser> 
                </span>
				 <span id="createrid2selspan" style="display:none;float:left;">
	                      <brow:browser viewType="0" name="createrid2" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=7"  browserSpanValue=""> 
				         </brow:browser> 
				</span>
	    	</wea:item>
	    	
	    </wea:group>
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>' >
	    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<brow:browser viewType="0" name="ownerdepartmentid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue=""> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		 <brow:browser viewType="0" name="creatersubcompanyid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue=""> </brow:browser> 
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<select class=inputstyle name=requestlevel style='width:30%' size=1>
					<option value=""></option>
					<option value="0"><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
					<option value="1"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>
				 </select>
	    	</wea:item>
	    	
	    	<wea:item><%=SystemEnv.getHtmlLabelName(18376, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		  <input type="text" name="requestid" onkeyup="value=value.replace(/[^\d]/g,'')" style='width:80%' value="">
	    	</wea:item>
             <wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
			 <wea:item>
			       <select class=inputstyle size=1 name=nodetype style='width:30%'>
						<option value="">&nbsp;</option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%> </option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%> </option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%> </option>
						<option value="3" ><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%> </option>
			      </select>
			 </wea:item>
			 <wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
			 <wea:item>
			         <brow:browser viewType="0" name="unophrmid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue=""> </brow:browser>
			 </wea:item>
			 
			 <wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		  <select class=inputstyle size=1 name=gdzt style='width:30%'>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%> </option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%> </option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%> </option>
			      </select>
	    	</wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(82819, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		  <select class=inputstyle size=1 name=tszt style='width:30%'>
						<option value="">&nbsp;</option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(18360, user.getLanguage())%> </option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(20387, user.getLanguage())%> </option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(16210, user.getLanguage())%> </option>
			      </select>
	    	</wea:item>
			 
			 
			 <wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%> </wea:item>
			 <wea:item>
			        <brow:browser viewType="0" name="docids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('9')" width="80%" browserSpanValue=""> </brow:browser>
			 </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
			  <wea:item>
			         <brow:browser viewType="0" name="hrmids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue=""> </brow:browser>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
			  <wea:item>
			          <brow:browser viewType="0" name="crmids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('18')" width="80%" browserSpanValue=""> </brow:browser>
			  </wea:item>
			  <wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
			  <wea:item>
			         <brow:browser viewType="0" name="proids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('135')" width="80%" browserSpanValue=""> 
			         </brow:browser>
            </wea:item>
		
	    </wea:group>
	</wea:layout>


</div>	
</form>
<script type="text/javascript">
function getajaxurl(typeId){
	var url = "";
	if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
	   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
		url = "/data.jsp?type=" + typeId;			
	} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
		url = "/data.jsp";
	} else {
		url = "/data.jsp?type=" + typeId;
	}
	url = "/data.jsp?type=" + typeId;	
	//alert(typeId + "," + url);
    return url;
}
function submitForm()
{
	$GetEle("weaver").submit();
	parent.resettab_menu();
	parent.fromleftmenu = 0;
	$("#e8TreeSwitch",window.parent.document).css("display","block"); 
}

function changeType(type,span1,span2){
	if(type=="1"){
		jQuery("#"+span1).css("display","none");
		jQuery("#"+span2).css("display","");		
	}else{
		jQuery("#"+span2).css("display","none");
		jQuery("#"+span1).css("display","");
	}
}

function setSelectBoxValue(selector, value) {
	if (value == null) {
		value = jQuery(selector).find('option').first().val();
	}
	jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
}

function cleanBrowserValue(name) {
	_writeBackData(name, 1, {id:'',name:''});
}

function onReset() {
	//browser
	jQuery('#weaver .e8_os input[type="hidden"]').each(function() {
		cleanBrowserValue(jQuery(this).attr('name'));
	});
	//input
	jQuery('#weaver input').val('');
	//select
	jQuery('#weaver select').each(function() {
		setSelectBoxValue(this);
	});
}

</script>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
