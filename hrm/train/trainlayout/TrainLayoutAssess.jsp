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
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var Pdialog = parent.parent.getDialog(parent);

function onBtnSearchClick(){
	jQuery("#weaver").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=TrainLayoutAssessAdd&isdialog=1&id=<%=id%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(16161,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 403;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%
int userid = user.getUID();

String currentDate ="";
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
currentDate = format.format(Calendar.getInstance().getTime()) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6101,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6102,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<%
/**
 * Add by Charoes Huang For
 */
boolean isAssessor = TrainLayoutComInfo.isAssessor(userid,id);
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isAssessor){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
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
		<%if(isAssessor){ %>
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
		<%} %>	
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>				
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainLayoutAssess.jsp" method=post >
<input class=inputstyle type=hidden name=id value="<%=id%>">
<%
String backfields = " id, assessdate, implement, explain, advice, assessorid "; 
String fromSql  = " from HrmTrainLayoutAssess ";
String sqlWhere = " where layoutid =  "+id;
String orderby = " id " ;
String tableString = "";
	
tableString =" <table pageId=\""+PageIdConst.Hrm_TrainLayoutAssess+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_TrainLayoutAssess,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.job.SpecialityComInfo.getSpecialtityCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    "			<head>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15696,user.getLanguage()) +"\" column=\"assessdate\" orderkey=\"assessdate\" />"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15695,user.getLanguage())+"\" column=\"assessorid\" orderkey=\"assessorid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(16158,user.getLanguage())+"\" column=\"implement\" orderkey=\"implement\" transmethod=\"weaver.hrm.HrmTransMethod.getImplementName\" otherpara=\""+user.getLanguage()+"\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"explain\" orderkey=\"explain\" />"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(16159,user.getLanguage())+"\" column=\"advice\" orderkey=\"advice\" />"+
    "			</head>"+
    " </table>";
%>
 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_TrainLayoutAssess %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</form>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="Pdialog.closeByHand();">
    	</wea:item>
   	</wea:group>
  </wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
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
