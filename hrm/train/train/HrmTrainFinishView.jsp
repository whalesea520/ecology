<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%	
String id = request.getParameter("id");
String isDialog = Util.null2String(request.getParameter("isdialog"));
String sql = "select * from HrmTrain where id = "+id;
rs.executeSql(sql);
rs.next();
String summarizer = Util.null2String(rs.getString("summarizer"));
String summarizedate = Util.null2String(rs.getString("summarizedate"));
String fare = Util.null2String(rs.getString("fare"));
String faretype = Util.null2String(rs.getString("faretype"));
String advice = Util.null2String(rs.getString("advice"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
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
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
   <wea:item><%=SystemEnv.getHtmlLabelName(16154,user.getLanguage())%> </wea:item>
   <wea:item><%=ResourceComInfo.getResourcename(summarizer)%></wea:item>	   
   <wea:item><%=SystemEnv.getHtmlLabelName(16155,user.getLanguage())%> </wea:item>
   <wea:item><%=summarizedate%></wea:item>	   
   <wea:item><%=SystemEnv.getHtmlLabelName(16153,user.getLanguage())%> </wea:item>
   <wea:item><%=fare%></wea:item>	   
   <wea:item><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></wea:item>
   <wea:item><%=BudgetfeeTypeComInfo.getBudgetfeeTypename(faretype)%></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></wea:item>
   <wea:item><%=advice%></wea:item>   
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
