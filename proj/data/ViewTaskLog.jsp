<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetL" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String log=Util.null2String(request.getParameter("log"));

RecordSetL.executeProc("Task_Log_Select",ProjID);

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage())+" - <a href='/proj/data/ViewTaskModify.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"</a>"+" - "+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":<a href='/proj/process/ViewProcess.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/process/ViewProcess.jsp?log=n&ProjID="+ProjID+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form">
<input type="hidden" name="projid" value="<%=ProjID%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important;display:none;">
			<input type="text" class="searchInput"  name="flowTitle"  value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:none"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


</form>

<%

String sqlWhere = "where projectid='"+ProjID+"' ";

if(!"".equals(nameQuery)){
	//sqlWhere+=" and assortmentname like '%"+nameQuery+"%'";
}

String orderby =" submitdate,submittime ";
String tableString = "";
int perpage=10;                                 
String backfields = " t1.*,t2.subject ";
String fromSql  = " Task_Log t1 left outer join prj_taskprocess t2 on t2.id=t1.taskid ";

tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
				//" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"submitdate\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(97,user.getLanguage())+"\" column=\"submitdate\" orderkey=\"submitdate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\" column=\"submittime\" orderkey=\"submittime\"   />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(616,user.getLanguage())+"\" column=\"submiter\" orderkey=\"submiter\"  transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(108,user.getLanguage())+"\" column=\"clientip\" orderkey=\"clientip\"   />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara='"+user.getLanguage()+"' transmethod='weaver.proj.util.ProjectTransUtil.getPrjTaskLogTypeName' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1332,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\"  />"+
                "       </head>"+
                /**"		<operates>"+
					"		<operate href=\"javascript:onDetail();\" text=\""+SystemEnv.getHtmlLabelName(1293,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+ **/                
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

</BODY>
</HTML>
