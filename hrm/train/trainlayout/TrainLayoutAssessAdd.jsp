<%@ page import="weaver.general.Util,
                 java.text.SimpleDateFormat" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String id = request.getParameter("id");
int userid = user.getUID();
boolean isAssessor = TrainLayoutComInfo.isAssessor(userid,id);

if(!isAssessor){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
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
String currentDate ="";
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
currentDate = format.format(Calendar.getInstance().getTime()) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6101,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6102,user.getLanguage());
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
if(isAssessor){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id="+id+",_self} " ;
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
<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<%if(isAssessor){%>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
 		<wea:item><%=SystemEnv.getHtmlLabelName(16158,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<select class=inputstyle name=implement value="2">
	  		<option value="0"><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%></option>
		   	<option value="1"><%=SystemEnv.getHtmlLabelName(16160,user.getLanguage())%></option>
		   	<option value="2" selected><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
		   	<option value="3"><%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%></option>
		   	<option value="4"><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%></option>
	  	</select>
  	</wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%></wea:item>
  	<wea:item>
    	<SPAN id=assessdatespan ><%=currentDate%></SPAN>
    	<input class=inputstyle type="hidden" id="assessdate" name="assessdate" value="<%=currentDate%>" >
  	</wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
  	<wea:item>
    	<textarea class=inputstyle cols=50 rows=4 name=explain></textarea>
  	</wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelName(16159,user.getLanguage())%></wea:item>
  	<wea:item>
    	<textarea class=inputstyle cols=50 rows=4 name=advice></textarea>
  	</wea:item>
  	</wea:group>
 </wea:layout>
<%}%>
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
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
sub getDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script> 
<script language=javascript>
  function dosave(){
    document.frmMain.operation.value="addAssess";
    document.frmMain.submit();
  }  
</script>
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
