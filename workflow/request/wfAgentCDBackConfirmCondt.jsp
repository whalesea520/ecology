<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceCominfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>

<%

int agentid = Util.getIntValue(request.getParameter("agentid"),0);
int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
String agentrange = Util.fromScreen(request.getParameter("agentrange"),user.getLanguage());
String rangetype = Util.fromScreen(request.getParameter("rangetype"),user.getLanguage());
int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
int isPendThing=Util.getIntValue(request.getParameter("isPendThing"),0);
String overlapagentstrid=Util.null2String(request.getParameter("overlapagentstrid"));
String isnotchecked=Util.null2String(request.getParameter("isnotchecked"));
int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);


int isCreateAgenter = 0;
if(Util.getIntValue(request.getParameter("isCreateAgenter"),0) == 1){
  isCreateAgenter = 1;
}
int isProxyDeal = 0;
if(Util.getIntValue(request.getParameter("isProxyDeal"),0) == 1){
	isProxyDeal = 1;
}
int overlapAgent=Util.getIntValue(request.getParameter("overlapAgent"),0);

%>
  <%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:sumbitform(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


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
 
 
<script type="text/javascript">
 
	var dialog = parent.parent.getDialog(parent.window);
    var parentWin =parent.getParentWindow(window) ;
	var iscolse = "<%=isclose%>";
	if(iscolse=="1")
	{
	   	 parentWin._table.reLoad();
	   	 parent.getDialog(window).close();
	}
	
	function closeCancle(){
	
		parent.getDialog(window).close();
		
	}
</script>
</HEAD>
 
<BODY>
<FORM id=weaver name=weaver action="/workflow/request/wfAgentOperatorNew.jsp" method=post>
<input type="hidden" name="source" value="Approach">
<input type="hidden" name="agentid" value="<%=agentid %>" >
<input type="hidden" name="workflowid" value="<%=workflowid %>" >
<input type="hidden" name="beagenterId" value="<%=beagenterId %>" >
<input type="hidden" name="agenterId" value="<%=agenterId %>" >
<input type="hidden" name="beginDate" value="<%=beginDate %>" >
<input type="hidden" name="beginTime" value="<%=beginTime %>" >
<input type="hidden" name="endDate" value="<%=endDate %>" >
<input type="hidden" name="endTime" value="<%=endTime %>" >
<input type="hidden" name="agentrange" value="<%=agentrange%>" >
<input type="hidden" name="rangetype" value="<%=rangetype %>" >
<input type="hidden" name="isCreateAgenter" value="<%=isCreateAgenter %>" >
<input type="hidden" name="isProxyDeal" value="<%=isProxyDeal %>" >
<input type="hidden" name="isPendThing" value="<%=isPendThing %>" >
<input type="hidden" name="overlapagentstrid" value="<%=overlapagentstrid %>" >
<% if(isnotchecked.equals("1")){%>
<br>
<%} %>
<table width="98%"   border="0" >
  <tr  >
    <td   width="60px" rowspan="2" valign="middle" align="right"><img style="margin-right: 10px;" id="Icon_undefined" align="absmiddle" src="/wui/theme/ecology8/skins/default/rightbox/icon_alert_wev8.png" width="26" height="26"></td>
	<td   width="331" valign="middle" align="left"><%=SystemEnv.getHtmlLabelName(82666,user.getLanguage()) %>  <a href="#" style="color:#0000FF" onclick="onagentedit()"><%=overlapAgent %></a>  <%=SystemEnv.getHtmlLabelName(82667,user.getLanguage()) %></td>
  </tr>
  <tr>
   <td align="left" height="20px"><%=SystemEnv.getHtmlLabelName(82668,user.getLanguage()) %></td>
  </tr>
  <% if(isnotchecked.equals("1")){%>
  <tr  >
    <td align="left" valign="middle" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
    <input type="radio" checked="checked" name="overlapAgenttype" value="1"><%=SystemEnv.getHtmlLabelName(82669,user.getLanguage()) %>&nbsp;</td>
  </tr>
  <%} %>
  <tr >
    <td align="left" valign="middle" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
    <input type="radio"  <%if(!isnotchecked.equals("1")){ %> checked="checked" <%} %>  name="overlapAgenttype" value="2"><%=SystemEnv.getHtmlLabelName(82670,user.getLanguage()) %>&nbsp;</td>
  </tr>
</table>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit"  class="zd_btn_submit" onclick="sumbitform()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCancle()">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>
<script type="text/javascript">
function sumbitform(){
 var overlapAgenttype="1";
 var obj = document.getElementsByName("overlapAgenttype");
    for(var i=0; i<obj.length; i ++){
        if(obj[i].checked){
           overlapAgenttype=obj[i].value;
        }
    }
	jQuery(parentWin.document).find("#overlapAgenttypes").val(overlapAgenttype);
	jQuery(parentWin.document).find("#overlapagentstrids").val("<%=overlapagentstrid %>");
     parentWin.frmmain.submit();
	 parent.getDialog(window).close();
 	//document.weaver.submit();
}

 function onagentedit(){
  var   dialog2 = new window.top.Dialog();
	    dialog2.currentWindow = window;
 
		var url = "/workflow/request/wfAgentMyCondit.jsp?agentFlag=0&agented=0&overlapagentstrid=<%=overlapagentstrid%>";
		dialog2.Title = "<%=SystemEnv.getHtmlLabelName(82671,user.getLanguage()) %>";
		dialog2.Width = 750;
		dialog2.Height =570;
		 
		dialog2.Drag = true;
		dialog2.URL = url;
		dialog2.show();
}
</script>
</HTML>