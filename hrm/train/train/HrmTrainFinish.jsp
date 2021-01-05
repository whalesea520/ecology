<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = request.getParameter("id");
%>
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
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(405,user.getLanguage());
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
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+id+",_self} " ;
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
<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(16153,user.getLanguage())%> </wea:item>
   	<wea:item>            
     <input type="text" id="fare" name="fare" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("fare")' > 	      
		</wea:item>	   
    <wea:item><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></wea:item>
    <wea:item>
    	<brow:browser viewType="0" name="faretype" browserValue="" 
     		browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=1"
     		hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
     		completeUrl="/data.jsp?type=FnaBudgetfeeType">
    	</brow:browser>  
    	<!-- 
    	<BUTTON class=Browser onClick="onShowBudgetType()"></BUTTON> 
	  	<span class=inputStyle id=faretypespan></span> 
	  	<INPUT class=inputStyle id=faretype type=hidden name=faretype>  
    	 -->          
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></wea:item>
    <wea:item><textarea class=inputstyle cols=50 rows=4 name=advice></textarea></wea:item>  
	</wea:group>
</wea:layout>
<input type="hidden" name=operation> 
<input type=hidden name=id value=<%=id%>>
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
sub onShowBudgetType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'")
	if Not isempty(id) then
	if id(0)<> 0 then
	faretypespan.innerHtml = id(1)
	frmMain.faretype.value=id(0)
	else
	faretypespan.innerHtml = ""
	frmMain.faretype.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function dosave(){      
    document.frmMain.operation.value="finish";
    document.frmMain.submit();
  } 
 </script>
 </BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
 </HTML>
