<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %> 
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowSearchCustom" class="weaver.workflow.search.WorkflowSearchCustom" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="dateutil" class="weaver.general.DateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
<%
String ownerdepartmentid="";
String bname="";
String helpdocid="";
String hrmcreaterid="";
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body  >
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="frmmain" action="/workflow/request/wfAgentOperatorNew.jsp" method="post">

<%
ArrayList arr = new ArrayList();
int userid=user.getUID();
String isDialog = Util.null2String(request.getParameter("isdialog"));
//added by xwj for td2551 20050902
String changeBeagentId = (String)request.getParameter("changeBeagentId");
if(changeBeagentId != null && !"".equals(changeBeagentId)){
userid = Integer.parseInt(changeBeagentId);
}
String checked="";

String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
  usertype = 1;
String seclevel = user.getSeclevel();
int workflowid = -1;
int beagenterid =-1;
int agentid = Util.getIntValue(request.getParameter("agentid"),-1);//主键
rs.executeSql("select * from workflow_Agent  where agentId="+agentid);

String isCreateAgenter="";
String isProxyDeal="";
String isPendThing="";
String agenterid ="";
String beginDate="";
String beginTime="";
String endDate = "";
String endTime="";
String agenttype="";

String iseditenddate="";
String iseditendtime="";
String iseditstartdate="";
String iseditstarttime="";
if(rs.next()){
	isCreateAgenter=Util.null2String(rs.getString("isCreateAgenter"));
	 
	isPendThing=Util.null2String(rs.getString("isPendThing"));
	workflowid=Util.getIntValue(rs.getString("workflowid"));
	agenterid=Util.null2String(rs.getString("agenterid"));
	beagenterid=Util.getIntValue(rs.getString("beagenterid"));
	
	beginDate=Util.null2String(rs.getString("begindate"));
	beginTime=Util.null2String(rs.getString("begintime"));
	endDate=Util.null2String(rs.getString("enddate"));
	endTime=Util.null2String(rs.getString("endtime"));
	
	iseditenddate=Util.null2String(rs.getString("iseditenddate"));
	iseditendtime=Util.null2String(rs.getString("iseditendtime"));
	
	iseditstartdate=Util.null2String(rs.getString("iseditstartdate"));
	iseditstarttime=Util.null2String(rs.getString("iseditstarttime"));
	
	agenttype=Util.null2String(rs.getString("agenttype"));
}
isProxyDeal=wfAgentCondition.isProxyDeal(""+agentid,""+agenttype);


// out.println(iseditenddate+"=="+iseditendtime+"=="+iseditstartdate +"==="+iseditstarttime);
if(iseditenddate.equals("1")){
	endDate="";
}
if(iseditendtime.equals("1")){
	endTime="";
}
if(iseditstartdate.equals("1")){
	beginDate="";
}
if(iseditstarttime.equals("1")){
	beginTime="";
}




String infoKey=Util.null2String(request.getParameter("infoKey"));
String workflowname=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));

boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}

%>

<script language=javascript>
  
	var dialog =parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	var infoKey = "<%=infoKey%>";
	if(infoKey === "1")
	{
		parentWin._table.reLoad();
		dialog.close();
	}
    if(infoKey === "3")//弹出当前页面
	{
	   	dialog.close();
	}
	 if(infoKey === "4")//弹出当前页面
	{
	  	parentWin._table.reLoad();
		//dialog.close();
		parent.getDialog(window).close();
		dialog.close();
	   
	}
	
	function closeCancle(){
		parentWin._table.reLoad();
		parent.getDialog(window).close();
	}

</script>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/> 
	   <jsp:param name="navName" value="<%=workflowname %>"/>
	</jsp:include>
	<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave()">
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
	</table> 
	
	<wea:layout>
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
		<wea:item attributes="{'isTableList':'true'}">	
			<table  id="table" class="ListStyle"  width="100%">
		     
		      <tr >
		       <td height="150" class="fieldName" width="160px"><!--被代理人  -->
		       <%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%>
		       </td>
		       <td	class="field" colspan="3">
     			 <SPAN id="agentidspan"> 
     			 <%=ResourceComInfo.getLastname(""+beagenterid)%> </SPAN>
               <INPUT type="hidden" name="beagenterId" id="beagenterId" value="<%=beagenterid%>">
               
  				</td>
		     </tr>
		     
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
		     <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 代理人  -->
			 <%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%>
			 </td>
			 <td class="field" >
				  <SPAN id="agenterIdspan"><%=wfAgentCondition.getMulResourcename1("",""+agentid) %> </SPAN>
				  <input type=hidden  value="<%=agenterid %>" name="agenterId" id="agenterId">
		   </td>
			<td class="field" >	
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82586, user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>" class="e8_btn_top" onclick="onShowAgentCondition()">  
			</td>  
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	       
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 流程  -->
			 <%=SystemEnv.getHtmlLabelName(32611,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <%=workflowname %>
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 开始日期, 时间  -->
			 <%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <button type="button"   class="Calendar" id="SelectBeginDate" onclick="onshowAgentBDateNew()"></BUTTON> 
      			<SPAN id="begindatespan"><%=beginDate %></SPAN> 
      				&nbsp;&nbsp;&nbsp;
      			<button type="button"   class="Clock" id="SelectBeginTime" onclick="onshowAgentTime('begintimespan','beginTime')"></BUTTON>
      			<SPAN id="begintimespan"><%=beginTime %></SPAN> 
       
       			<INPUT type="hidden" name="beginDate" id="beginDate" value="<%=beginDate %>">
       			<INPUT type="hidden" name="beginTime" id="beginTime" value="<%=beginTime %>">
			 
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 结束日期, 时间  -->
			 <%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <button type="button"   class="Calendar" id="SelectEndDate" onclick="onshowAgentEDateNew()"></BUTTON> 
      			<SPAN id="enddatespan"><%=endDate %></SPAN> 
      			&nbsp;&nbsp;&nbsp;
      			<button type="button"   class="Clock" id="SelectEndTime" onclick="onshowAgentTime('endtimespan','endTime')"></BUTTON>
      			<SPAN id="endtimespan"><%=endTime %></SPAN>  
       			<INPUT type="hidden" name="endDate"  id="endDate" value="<%=endDate %>">
       			<INPUT type="hidden" name="endTime"  id="endTime" value="<%=endTime %>">
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        
		  
		   </table>	
		</wea:item>	
		</wea:group>
	</wea:layout>
	<div style="height:100px!important"></div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0 !important;">
		<div style="padding:5px 0px;">
			<wea:layout needImportDefaultJsAndCss="true">
				<wea:group context=""  attributes="{groupDisplay:none}">
					<wea:item type="toolbar">
			    	 <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCancle()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</div>
</div>
</div>

<br>
<%
String unophrmid="";

%>
<center>
	<input type="hidden" value="<%=haveAgentAllRight%>" name="haveAgentAllRight">
  	<input type="hidden" value="<%=workflowid%>" name="workflowid" id="workflowid">
  	<input type="hidden" value="editAgent" name="method">
  	<INPUT type="hidden" name="beagenterId" id="beagenterId" value="<%=beagenterid%>">
	<INPUT type="hidden" name="agentid" id="agentid" value="<%=agentid%>">
	 <INPUT type="hidden" name="isCreateAgenter" id="isCreateAgenter" value="<%=isCreateAgenter%>">
	 <INPUT type="hidden" name="isProxyDeal" id="isProxyDeal" value="<%=isProxyDeal%>">
	 <INPUT type="hidden" name="isPendThing" id="isPendThing" value="<%=isPendThing%>">
	 <INPUT type="hidden" name="workflowid" id="workflowid" value="<%=workflowid%>">
	 <INPUT type="hidden" name="usertype" id="usertype" value="<%=usertype%>">
	  <INPUT type="hidden" name="agenttype" id="agenttype" value="<%=agenttype%>">
	 
<center>
</div>
</div>
</form>
</body>

<script language="JavaScript">

var Htmlmessage="<%=SystemEnv.getHtmlLabelName(127683,user.getLanguage())%>"; 
function onShowAgentCondition(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/request/wfAgentCondition.jsp?agentid=<%=agentid%>&types=editcondition";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(82586,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 570;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}

function onShowBrowsers(wfid,formid,isbill){
 		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/request/agentruleMappingList.jsp?wfid=<%=workflowid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(82586,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 570;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
}
 
function doSave(obj){
		//加入提交前的时间判断
	var beginDate=document.frmmain.beginDate.value;
	var beginTime=document.frmmain.beginTime.value;
	var endDate=document.frmmain.endDate.value;
	var endTime=document.frmmain.endTime.value;
    if(beginTime!=''&&beginDate==''){
      Dialog.alert("<%=SystemEnv.getHtmlLabelName(127684,user.getLanguage())%>");
      return;
    }
	if(endTime==''){
		endTime='23:59';
	}else{
	  if(endDate==''){
	     Dialog.alert("<%=SystemEnv.getHtmlLabelName(127685,user.getLanguage())%>");
		 return;
	  }
	}
	
	if(endDate==''){
		endDate='2099-12-31';
	}
	var beginDateTime =beginDate+' '+beginTime;
	var endDateTime = endDate+' '+endTime;
 
	if(beginDateTime.valueOf()>=endDateTime.valueOf()) {
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(127683,user.getLanguage())%>");
		return;
	}
 

    var returnstrs=wfoverlapAgent();//为2标示当前代理设置没有叠加重复项。为1标示有 ，如果有则需要另外处理
    
   if(returnstrs=='2'){
  	   $("#zd_btn_submit").attr("disabled","disabled"); 
      e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>",true); 
 	  window.document.frmmain.submit();
      obj.disabled = true;
   }
}

function wfoverlapAgent(){
		var beagenterId=document.getElementById("beagenterId").value;
		var agenterId=document.getElementById("agenterId").value;
		var beginDate=document.getElementById("beginDate").value;
		var beginTime=document.getElementById("beginTime").value;
		var endDate=document.getElementById("endDate").value;
		var endTime=document.getElementById("endTime").value;
		var usertype=document.getElementById("usertype").value;
		var workflowid=document.getElementById("workflowid").value;
		var isCreateAgenter=document.getElementById("isCreateAgenter").value;
		var isProxyDeal=document.getElementById("isProxyDeal").value;
		var isPendThing=document.getElementById("isPendThing").value;
	
		var returnstr="2";
		jQuery.ajax({
			 type: "POST",
			 url: "/workflow/request/WFAgentConditeAjax.jsp",
			 data: "beagenterId="+beagenterId+"&workflowid="+workflowid+"&usertype="+usertype+"&agenterId="+agenterId+"&beginDate="+beginDate+"&beginTime="+beginTime+"&endDate="+endDate+"&endTime="+endTime+"&isCreateAgenter="+isCreateAgenter+"&isProxyDeal="+isProxyDeal+"&isPendThing="+isPendThing+"&agentid=<%=agentid%>",
			 cache: false,
			 async:false,
			 dataType: 'json',
			    success: function(msg){
				if(msg.done.success=="success"){
				  	 if(msg["data0"]){
				 	  var _data = msg["data0"];
				 	    if(_data.overlapAgent!=undefined&&_data.overlapAgent!='undefined'){
						  if(_data.overlapAgent>0){
						  	returnstr="1";
						  	//dialog.close();
						  	
							dialog = new window.top.Dialog();
							dialog.currentWindow = window; 
							var url = "/workflow/request/wfAgentCDBackConfirm.jsp?method=editAgent&overlapagentstrid="+_data.agentids+"&overlapAgent="+_data.overlapAgent+"&beagenterId="+beagenterId+"&workflowid="+workflowid+"&usertype="+usertype+"&agenterId="+agenterId+"&beginDate="+beginDate+"&beginTime="+beginTime+"&endDate="+endDate+"&endTime="+endTime+"&isCreateAgenter="+isCreateAgenter+"&isProxyDeal="+isProxyDeal+"&isPendThing="+isPendThing+"&agentid=<%=agentid%>&agenttype=<%=agenttype%>";
							dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage()) %>";
							dialog.URL = url;
						 	dialog.Width="355px";
							//dialog.Height="550px" ;
							dialog.show();
						  }else{
						 	returnstr="2";
						  }
				 	    }
				 	 }
				}else{
				  Dialog.alert("<%=SystemEnv.getHtmlLabelName(84530, user.getLanguage())%>"+msg.done.info);

				   	returnstr="2";
				}
			 }
		 });
		 	return returnstr;
}
 
  
function ShowFnaHidden(obj,trnames){
	var tr_names=trnames.split(',');
	for(var i=0;i<tr_names.length;i++){
	    if(obj.checked){
	    	 $("#"+tr_names[i]).show();
	    }else{
	     	$("#"+tr_names[i]).hide();
	    }
    }
}

</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>