<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
/*
if(!HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
*/
String id = Util.null2String(request.getParameter("id"));
String sql = "Select * From HrmTrainTest Where ID = "+id;
String trainid = "";
String resourceid = "";
String testdate = "";
String result ="";
String explain = "";
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));

rs.executeSql(sql);
if(rs.next()){
	trainid = rs.getString("trainid");
	resourceid = rs.getString("resourceid");
	testdate = rs.getString("testdate");
	result = rs.getString("result");
	explain = rs.getString("explain");
}
%>	
<html>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6106,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainTest.jsp?trainid="+trainid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="dosave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainOtherOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
 		<wea:item><%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%> </wea:item>
    <wea:item>
     <span class=InputStyle id=actorspan>
		  <a href ="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>">
		  <%=ResourceComInfo.getResourcename(resourceid)%>
		  </a>
     </span> 
	   <INPUT class=InputStyle id=actor type=hidden name=actor value="<%=resourceid%>">
    </wea:item>	   
	   <wea:item><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></wea:item>
	   <wea:item>
	     <select class=InputStyle name=result>       
	       <option value=0 <%if(result.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%></option>
	       <option value=1 <%if(result.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%></option>
	       <option value=2 <%if(result.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
	       <option value=3 <%if(result.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
	     </select>
	   </wea:item>
	   <wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
	   <wea:item>
	      <textarea class=InputStyle cols=50 rows=4 name=explain><%=explain%></textarea>      
	   </wea:item>    
	</wea:group>
</wea:layout>
<input class=InputStyle type="hidden" name=operation> 
<input class=InputStyle type=hidden name=trainid value=<%=trainid%>>
<input class=inputstyle type=hidden name=id value=<%=id%>>
</form>
 <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function dosave(){
  if(check_form(document.frmMain,'actor')){      
    document.frmMain.operation.value="edittest";
    document.frmMain.submit();
    }
  } 
 </script>
 
</BODY></HTML>
