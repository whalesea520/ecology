<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/e8Common_wev8.js"></script>
<script type="text/javascript">
/*
function onBtnSearchClick(){
  document.frmMain.action="/system/ModuleManageDetach.jsp";
	jQuery("#frmMain").submit();
}
*/
jQuery(document).ready(function(){
	onAppdetachinitChange();
	
})
function onAppdetachinitChange(){
	if($G("appdetachable").checked){
		showEle("item_appdetachinit");
	}else {
		hideEle("item_appdetachinit");
	} 
}
</script>
</head>
<%
boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24326,user.getLanguage()) ;//分权管理设置
String needfav ="1";
String needhelp ="";

if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String appdetachable = "";
String appdetachinit = "";

RecordSet.executeProc("SystemSet_Select","");
if(RecordSet.next()){
	appdetachable = Util.null2String(RecordSet.getString("appdetachable"));
	appdetachinit = Util.null2String(RecordSet.getString("appdetachinit"));
}
//System.out.println(">>>>>>>>>>>>>>>>>>>>qname="+qname);
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" id="frmMain" name=frmMain method=post action="/system/SystemSetOperation.jsp">


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<input type="hidden" name=operation  value="appdetachmanagement">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("26505,24327,68",user.getLanguage())%>' >
	 <wea:item>
	  <%=SystemEnv.getHtmlLabelNames("18624,26505,24327",user.getLanguage())%>
	 </wea:item>
	 <wea:item  attributes="{'colspan':'3'}">
      <input type="checkbox" id=appdetachable name=appdetachable  value="1" tzCheckbox="true" <% if(appdetachable.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="onAppdetachinitChange()">
   </wea:item>
   <wea:item attributes="{'samePair':'item_appdetachinit','display':'none'}"><%=SystemEnv.getHtmlLabelName(128555,user.getLanguage())%></wea:item>
   <wea:item attributes="{'colspan':'3','samePair':'item_appdetachinit','display':'none'}">
   	<select name="appdetachinit" style="width: 150px">
   		<option value=""></option>
   		<option value="1" <%=appdetachinit.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(81363,user.getLanguage())%></option>
   		<option value="2" <%=appdetachinit.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(81362,user.getLanguage())%></option>
   	</select>
   </wea:item>
	</wea:group>
</wea:layout>
  </FORM>
</BODY>
<script language="javascript">
function onSubmit(){
 	frmMain.submit();
}
</script>
</HTML>
