
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ page import="weaver.general.TimeUtil"%><%--xwj for td2551 20050822--%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsCheck" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2551 20050902--%>
<jsp:useBean id="rsCheck_" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2551 200509022--%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
<style type="text/css">
#rangetypespan{
 height:20px!important;
 overflow: hidden;
}
</style>
</HEAD>

<%
String info = (String)request.getParameter("infoKey");
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("1".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(76,user.getLanguage())%>")
 <%}
 else if("2".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(77,user.getLanguage())%>")
 <%}
 
 else if("3".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(78,user.getLanguage())%>")
 <%}
 else if("4".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(79,user.getLanguage())%>")
 <%}
 else if("5".equals(info)){%>
 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26802,user.getLanguage())%>")
 <%}
  
  
 }%>
</script>


<script language="JavaScript">
function stopBar(scrollarea,mainarea){
	var scroll_area = scrollarea;
	var main_area = mainarea;
	 scroll_area.style.display='none';
   // main_area.style.display='inline';
}

</script>
<script type="text/javascript">
	var dialog =parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	var iscolse = "<%=isclose%>";
	if(iscolse === "1")
	{
		parentWin._table.reLoad();
		//鍒锋柊椤甸潰浣垮彸閿彍鍗曟秷澶?

	    parentWin.frmmain.submit();
	    dialog.close();
	}
</script>

<script language=javascript>
function closeCancle(){
 
 parent.getDialog(window).close();
 
}
 
</script>
<%
ArrayList arr = new ArrayList();
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//闇€瑕佸鍔犵殑浠ｇ爜
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//闇€瑕佸鍔犵殑浠ｇ爜
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//闇€瑕佸鍔犵殑浠ｇ爜
int userid=user.getUID();
String alluserID = String.valueOf(user.getUID());
String belongtoshow = "0";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userid);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
alluserID = alluserID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
String isDialog = Util.null2String(request.getParameter("isdialog"));
//added by xwj for td2551 20050902
String changeBeagentId = (String)request.getParameter("changeBeagentId");
if(changeBeagentId != null && !"".equals(changeBeagentId)){
userid = Integer.parseInt(changeBeagentId);
}
String checked="";
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18461,user.getLanguage());
String needfav ="1";
String needhelp ="";
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
  usertype = 1;
String seclevel = user.getSeclevel();

int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
String workflowname=WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));

boolean haveAgentAllRight=false;
if(HrmUserVarify.checkUserRight("WorkflowAgent:All", user)){
  haveAgentAllRight=true;
}

//int beagenterId=0; xwj for td2551 20050902
int agenterId=0;
String beginDate="";
String beginTime="";
String endDate="";
String endTime="";
int isCreateAgenter=0;
int rowsum=0;

if(!haveAgentAllRight){
   //beagenterId=userid;   xwj for td2551 20050902
  if (workflowid!=-1)
{
  rs.executeSql("select * from Workflow_Agent where workflowid="+workflowid+ " and beagenterId="+userid); // xwj for td2551 20050822
  if(rs.next()){
    agenterId=rs.getInt("agenterId");
    beginDate=rs.getString("beginDate");
    beginTime=rs.getString("beginTime");
    endDate=rs.getString("endDate");
    endTime=rs.getString("endTime");
    isCreateAgenter=rs.getInt("isCreateAgenter");
  }
}
}

%>

<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/> 
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82595, user.getLanguage()) %>"/>
	</jsp:include>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" class="e8_btn_top middle" id='zd_btn_submit' onclick="doSave(this)">
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM name="frmmain" action="/workflow/request/wfAgentOperatorNew.jsp" method="post">
	<input type="hidden" value="<%=haveAgentAllRight%>" name="haveAgentAllRight">
  	<input type="hidden" value="<%=workflowid%>" name="workflowid">
  	<input type="hidden" value="addAgent" name="method">
  	<input type="hidden" value="<%=usertype%>" name="usertype" id="usertype"/>
	<wea:layout  >
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">	
			<table  id="table" class="ListStyle"  width="100%">
		     <tr >
		       <td height="44" class="fieldName" width="160px"><!--琚唬鐞嗕汉  -->
		       <%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%>
		       </td>
		       <td	class="field" colspan="3">
			       <%if (haveAgentAllRight) {%>
						<brow:browser viewType="0" name="beagenterId" browserValue='<%=userid+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename((new Integer(userid)).toString()),user.getLanguage())%>'></brow:browser> 
	    			<%} else {%>  
	      				<SPAN id="agentidspan"><A href="javaScript:openhrm(<%=userid%>);" onclick='pointerXY(event);'>
	      					<%=user.getUsername()%></A></SPAN>
	  				
					<%if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){ %>
						<select class=inputstyle id="agentmainsub" name=agentmainsub  style='height:25px;width:100px;' onchange="changemainsub(this)" >
						<option value="0"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30368, user.getLanguage())%></option>
						 <%
																for(int k=0;k<userlist.size();k++){
																int belongtouserid=Util.getIntValue((String)userlist.get(k),0);	
																String username=ResourceComInfo.getResourcename((String)userlist.get(k));
																String ownDepid = ResourceComInfo.getDepartmentID((String)userlist.get(k));
																String depName = DepartmentComInfo.getDepartmentname(ownDepid);	
																 %>				
								<option value=<%=belongtouserid%>><%=Util.toScreen(username,user.getLanguage())%>/<%=Util.toScreen(depName,user.getLanguage())%> </option>
					<%}%>
					</select>
	              		
	  				<%}%>
					<INPUT type="hidden" name="beagenterId" id="beagenterId" value="<%=userid%>">
  				<%}%>
  				</td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
		     <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 浠ｇ悊浜? -->
			 <%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%>
			 </td>
			 <td	class="field"  colspan="3">
			 <brow:browser viewType="0" name="agenterId"   browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="185px" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue=""></brow:browser></td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 寮€濮嬫棩鏈? 鏃堕棿  -->
			 <%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <button type="button"   class="Calendar" id="SelectBeginDate" onclick="onshowAgentBDateNew()"></BUTTON> 
      			<SPAN id="begindatespan"><%if (!beginDate.equals("")) {%><%=beginDate%><%}%></SPAN> 
      				&nbsp;&nbsp;&nbsp;
      			<button type="button"   class="Clock" id="SelectBeginTime" onclick="onshowAgentTime('begintimespan','beginTime')"></BUTTON>
      			<SPAN id="begintimespan"><%if (!beginTime.equals("")) {%><%=beginTime%><%}%></SPAN> 
       
       			<INPUT type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>"  >
       			<INPUT type="hidden" name="beginTime" id="beginTime" value="<%=beginTime%>">
			 
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 缁撴潫鏃ユ湡, 鏃堕棿  -->
			 <%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <button type="button"   class="Calendar" id="SelectEndDate" onclick="onshowAgentEDateNew()"></BUTTON> 
      			<SPAN id="enddatespan"><%if (!endDate.equals("")) {%><%=endDate%><%}%></SPAN> 
      			&nbsp;&nbsp;&nbsp;
      			<button type="button"   class="Clock" id="SelectEndTime" onclick="onshowAgentTime('endtimespan','endTime')"></BUTTON>
      			<SPAN id="endtimespan"><%if (!endTime.equals("")) {%><%=endTime%><%}%></SPAN>  
       			<INPUT type="hidden" name="endDate" id="endDate" value="<%=endDate%>"  >
       			<INPUT type="hidden" name="endTime" id="endTime" value="<%=endTime%>">
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 浠ｇ悊鍒涘缓鏉冮檺 -->
			 	<%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%>
			 </td>
			 <td	class="field" colspan="3">
			 <INPUT class=InputStyle tzCheckbox="true" type=checkbox  id="isCreateAgenter" name='isCreateAgenter'>
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
	        <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 浠ｇ悊娴佺▼澶勭悊 -->
			 	<%=SystemEnv.getHtmlLabelName(82585,user.getLanguage())%>
			 </td>
			 <td	class="field" >
			 <INPUT class=InputStyle   checked  tzCheckbox="true" type=checkbox id="isProxyDeal" style="display:" name='isProxyDeal' onclick="ShowFnaHidden(this,'isPendThing')" >
			 </td>
			 <td height="44"   class="field"  colspan="2"  ><!-- 浠ｇ悊宸叉湁寰呭姙浜嬪疁 -->
			 <div id="isPendThingtr" >
			  <%=SystemEnv.getHtmlLabelName(33250,user.getLanguage())%>
			 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 <INPUT class=InputStyle tzCheckbox="true" type=checkbox    id="isPendThing"  name='isPendThing' >
			 </div>
			 </td>
		     </tr>
		     <tr class="Spacing" style="height: 1px !important;" jQuery1425871165066="63">
				<td class="paddingLeft0" colSpan="4" jQuery1425871165066="64">
				<div class="intervalDivClass"/>
				</td>
			</tr>
			
			  <tr >
			 <td height="44" class="fieldName"	width="160px"><!-- 涓嬪暒椤?-->
			 	<%=SystemEnv.getHtmlLabelName(32611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19467,user.getLanguage())%>
			 </td>
			 <td	class="field"  style='height:25px;width:100px;'>
				  <select class=inputstyle id="agentrange" name=agentrange  style='height:25px;width:100px;'  onChange="changeRange(this)">
						<option value="1"><%=SystemEnv.getHtmlLabelName(33251, user.getLanguage())%></option>
						<option value="0"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
					</select>	
			 </td>
			 <td height="44" class="field"	 colspan="2"  ><!-- 閫夋嫨娴佺▼ -->
			 <span id="rangeSpan" >
					<brow:browser browserDialogHeight="650px;" viewType="0" name="rangetype" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids=" idKey="id" nameKey="name"  hasInput="true"  width="300px" isSingle="false" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=workflowBrowser"  browserSpanValue=""></brow:browser>
				</span>
				&nbsp; 
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
</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#to').val(1);checkSubmit();">
					<span class="e8_sep_line">|</span>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="checkSubmit()">
					<span class="e8_sep_line">|</span> --%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCancle()">
					 
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
</body>

<script language="JavaScript">


var Htmlmessage="<%=SystemEnv.getHtmlLabelName(127683,user.getLanguage())%>"; 

function ShowFnaHidden(obj,tdname){
	var tzCheckBox = $("input[name='"+tdname+"']").next(".tzCheckBox");
    if(obj.checked){
        $G(tdname).disabled=false;
        tzCheckBox.attr("disabled",false);
        $("#isPendThingtr").css("display",""); 
        
    }else{
        $G(tdname).checked=false;
        $G(tdname).disabled=true;
        var isChecked = tzCheckBox.hasClass("checked");
        if(isChecked){
        	tzCheckBox.toggleClass("checked");
        }
        tzCheckBox.attr("disabled",true);
          $("#isPendThingtr").css("display","none");
    }
}

function changeRange(obj)
{
	if($(obj).val()==0){
	    $("#rangeSpan").css("display","none");
	}else{
	   $("#rangeSpan").removeAttr("style");
	}
}
function changemainsub(obj)
{
	//var opts = document.getElementById('agentmainsub').options.value;
	
	var beagenterid = $('#agentmainsub').find("option:selected").val();
	if(beagenterid==0){
	beagenterid = "<%=alluserID%>";
	}
	document.frmmain.beagenterId.value = beagenterid;
	 //alert($(obj).find("option:selected").val());
	//alert(hidden);
	
}
<%if(!"".equals(Belongtoids) && "1".equals(belongtoshow)){ %>
jQuery(document).ready(function(jQuery){ 
	window.setInterval(changemainsub(this),1000);
	});
	<%}%>

 
function selecAll(){
var flag = document.all('selectAll').checked;
var len = document.frmmain.elements.length;
var i=0;
var mainKey;
var subKey;

<%for(int h=0; h<arr.size(); h++){%>
mainKey = "t"+<%=arr.get(h)%>;
document.all(mainKey).checked=flag;
if(flag)
{
  $(document.all(mainKey)).next("span").addClass("jNiceChecked");
}else
{
 $(document.all(mainKey)).next("span").removeClass("jNiceChecked");
}
for( i=0; i<len; i++) {
   subKey = "w"+<%=arr.get(h)%>;
   if (document.frmmain.elements[i].name==subKey) {
        document.frmmain.elements[i].checked= flag ;
			if(flag)
			{
			  $(document.frmmain.elements[i]).next("span").addClass("jNiceChecked");
			}else
			{
			 $(document.frmmain.elements[i]).next("span").removeClass("jNiceChecked");
			}
      } 
  }

<%}%> 
}
<!--added by xwj for td2551 20050822 end-->

function doSave(obj){
	//鍔犲叆鎻愪氦鍓嶇殑鏃堕棿鍒ゆ柇
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
 
	 
 
   if(!document.getElementById("isCreateAgenter").checked&&!document.getElementById("isProxyDeal").checked){
     Dialog.alert("<%=SystemEnv.getHtmlLabelName(82665,user.getLanguage())%>");
    return;
    }
	
   document.all("method").value="addAgent";
   if(document.frmmain.beagenterId.value==0){
       Dialog.alert("<%=SystemEnv.getHtmlNoteName(81,user.getLanguage())%>");
   }
   else if(document.frmmain.agenterId.value==0){
       Dialog.alert("<%=SystemEnv.getHtmlNoteName(82,user.getLanguage())%>");
   }
   else if(document.frmmain.beagenterId.value==document.frmmain.agenterId.value){
       Dialog.alert("<%=SystemEnv.getHtmlNoteName(83,user.getLanguage())%>");
   } else if (jQuery('#agentrange').val() == 1 && !check_form(frmmain, 'rangetype')) {
   		return;
   } else {
  
    var returnstrs=wfoverlapAgent();//涓?鏍囩ず褰撳墠浠ｇ悊璁剧疆娌℃湁鍙犲姞閲嶅椤广€備负1鏍囩ず鏈?锛屽鏋滄湁鍒欓渶瑕佸彟澶栧鐞?
    if(returnstrs=='2'){
    	 if(document.getElementById("isCreateAgenter").checked){
		    document.getElementById("isCreateAgenter").value="1";
		 }
		  if(document.getElementById("isProxyDeal").checked){
		 	document.getElementById("isProxyDeal").value="1";
		 }
		  if(document.getElementById("isPendThing").checked){
			 document.getElementById("isPendThing").value="1";
		 }
	     $("#zd_btn_submit").attr("disabled","disabled"); 
		 e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>",true); 
    	window.document.frmmain.submit();
    	obj.disabled = true;
    }
   }
 
}


function goBack() {
	document.location.href="/workflow/request/wfAgentStatistic.jsp" //xwj for td3218 20051201
}

function wfoverlapAgent(){
		var beagenterId=document.getElementById("beagenterId").value;
		var agenterId=document.getElementById("agenterId").value;
		var beginDate=document.getElementById("beginDate").value;
		var beginTime=document.getElementById("beginTime").value;
		var endDate=document.getElementById("endDate").value;
		var endTime=document.getElementById("endTime").value;
		var agentrange=document.getElementById("agentrange").value;
		var rangetype=document.getElementById("rangetype").value;
		var usertype=document.getElementById("usertype").value;
		var isCreateAgenter="0"
		var isProxyDeal="0";
		var isPendThing="0"
		 if(document.getElementById("isCreateAgenter").checked){
		    isCreateAgenter="1";
		 }
		  if(document.getElementById("isProxyDeal").checked){
		 	isProxyDeal="1";
		 }
		  if(document.getElementById("isPendThing").checked){
			 isPendThing="1";
		 }
	
		var returnstr="2";
		jQuery.ajax({
			 type: "POST",
			 url: "/workflow/request/WFAgentConditeAjax.jsp",
			 data: "beagenterId="+beagenterId+"&usertype="+usertype+"&agenterId="+agenterId+"&beginDate="+beginDate+"&beginTime="+beginTime+"&endDate="+endDate+"&endTime="+endTime+"&agentrange="+agentrange+"&rangetype="+rangetype+"&isCreateAgenter="+isCreateAgenter+"&isProxyDeal="+isProxyDeal+"&isPendThing="+isPendThing,
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
					  	 
					  	dialog = new window.top.Dialog();
						dialog.currentWindow = window; 
					  	
						var url = "/workflow/request/wfAgentCDBackConfirm.jsp?method=addAgent&overlapAgent="+_data.overlapAgent+"&beagenterId="+beagenterId+"&usertype="+usertype+"&agenterId="+agenterId+"&beginDate="+beginDate+"&beginTime="+beginTime+"&endDate="+endDate+"&endTime="+endTime+"&agentrange="+agentrange+"&rangetype="+rangetype+"&isCreateAgenter="+isCreateAgenter+"&isProxyDeal="+isProxyDeal+"&isPendThing="+isPendThing;
						dialog.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage()) %>";
						dialog.URL = url;
						dialog.Modal = true;
						<%
						 if(user.getLanguage()==7){%>
						  dialog.Width="355px"; 
						<% }else{
						%>
					 	dialog.Width="455px";
					 	<%}%>
						dialog.show();
					  }else{
					 	returnstr="2";
					  }
			 	    }
			 	 }
				}else{
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(84530,user.getLanguage())%>"+msg.done.info);
				   	returnstr="2";
				}
			 }
		 });
		 	 
		 	return returnstr;
}
 


function checkMain(id) {
    len = document.frmmain.elements.length;
    var mainchecked=document.all("t"+id).checked ;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='w'+id) {
            document.frmmain.elements[i].checked= mainchecked ;
			 if(mainchecked)
            $(document.frmmain.elements[i]).next("span").addClass("jNiceChecked");  
			 else
            $(document.frmmain.elements[i]).next("span").removeClass("jNiceChecked");  
        } 
    } 
}


function checkSub(id) {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
    if (document.frmmain.elements[i].name=='w'+id) {
    	if(!document.frmmain.elements[i].checked){
    		document.all("t"+id).checked = false;
			$(document.all("t"+id)).next("span").removeClass("jNiceChecked");  
    		return;
    		}
    	} 
    }
    document.all("t"+id).checked = true; 
   $(document.all("t"+id)).next("span").removeClass("jNiceChecked"); 
   $(document.all("t"+id)).next("span").addClass("jNiceChecked"); 
}

function submitData()
{
	if (check_form(weaver,''))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
function show(obj,usertype){
    var imgs="img"+obj;
    var sss="s"+obj; 
    if(document.all(sss).style.display=="none"){
    	//added by cyril on 2008-08-25 for td:9236
    	document.all("scrollarea").style.display = "";
    	document.all("mainarea").style.display = "";
    	var req;
    	if (window.XMLHttpRequest) {
        	req = new XMLHttpRequest(); 
    	}
    	else if (window.ActiveXObject){ 
        	req = new ActiveXObject("Microsoft.XMLHTTP"); 
        }
        if(req){
            req.open("GET","wfAgentAddAjax.jsp?typeid="+obj+"&usertype="+usertype, true);
            req.onreadystatechange = function() {
            	if (req.readyState == 4 && req.status == 200) {
                	//alert(req.responseText);
                	document.all(sss).innerHTML = req.responseText;
                	document.all(sss).style.display="";
                	document.all(imgs).src="/images/btnDocCollapse_wev8.gif";
                	document.all("t"+obj).checked = true;
                    $(document.all("t"+obj)).next("span").removeClass("jNiceChecked");  
                    $(document.all("t"+obj)).next("span").addClass("jNiceChecked");    
                	req = null
                	stopBar(scrollarea,mainarea);
					$('body').jNice();
            	}
            }; 
            req.send(null);
        }
    	//end by cyril on 2008-08-25 for td:9236
    }else{
        document.all(sss).style.display="none";
        document.all(imgs).src="/images/btnDocExpand_wev8.gif";
    }
}

function onShowHrmBeAgent(spanname,inputename){
  var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if (results){
	  if (results.id!="") {
	    spanname.innerHTML= "<A href='javaScript:openhrm("+results.id+");' onclick='pointerXY(event);'>"+results.name+"</A>"
	    inputename.value=results.id
	    location.href = "/workflow/request/wfAgentAdd.jsp?changeBeagentId="+results.id;
	  }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	    inputename.value=""
	  }
  }
}
function onShowHrmAgent(spanname,inputename){
  var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if (results){
	  if (results.id!="") {
	    spanname.innerHTML= "<A href='javaScript:openhrm("+results.id+");' onclick='pointerXY(event);'>"+results.name+"</A>"
	    inputename.value=results.id
	  }else{ 
	    spanname.innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	    inputename.value=""
	  }
  }
}



</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</html>
