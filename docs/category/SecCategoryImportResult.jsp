
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<% 
	if (!HrmUserVarify.checkUserRight("DocSecCategoryAdd:add",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String historyid = Util.null2String(request.getParameter("historyid"));
	int successnum=0;
	int failnum=0;
	String filepath="";
	String sql="select successnum,failnum,filepath from docseccategoryimporthistory where id="+historyid;
	rs.executeSql(sql);
	if(rs.next()){
		successnum=rs.getInt("successnum");
		failnum=rs.getInt("failnum");
		filepath=rs.getString("filepath");
	}
	int sum=successnum+failnum;
	int line_height=300;
	if(failnum>0){
		line_height=50;
	}
%>
<script type="text/javascript" language=javascript >
parent.jQuery("#over,#loading2").remove();
parent.jQuery("#openHistoryLog,#dosubmit,#mymenu").remove();
parent.jQuery("#objName").html("<%=SystemEnv.getHtmlLabelNames("16398,82341",user.getLanguage())%>")

var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);

</script>
</HEAD>

<body style="overflow:hidden;">


<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%	
String sqlWhere="historyid="+historyid;
					String tableString=""+
					   "<table  pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCLOG,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"none\">"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"docseccategoryimportfaildetail\" sqlorderby=\"failrow\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>";
					   		tableString+=	 	"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23201,user.getLanguage())+"\"  		column=\"failrow\"   		orderkey=\"failrow\" />";
							tableString+=	 	"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23202,user.getLanguage())+"\"  		column=\"failcol\"   		orderkey=\"failcol\" />";
					   		tableString += 		"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(16398,user.getLanguage())+"\"  		column=\"seccategoryname\" 	orderkey=\"seccategoryname\"/>";
							tableString +=	 	"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(24960,user.getLanguage())+"\" 			column=\"failreason\"  		orderkey=\"failreason\" />"+
					   "</head>"+
					   "</table>";
if(failnum>0){
%>
<div style="font-size:18px;text-align:center;padding-top:10px;;line-height:<%=line_height%>px;">
	<IMG src="/images/docs/success.png" align=absMiddle><span>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())+sum+SystemEnv.getHtmlLabelNames("30690",user.getLanguage())+"，"+successnum+SystemEnv.getHtmlLabelNames("18256,28450",user.getLanguage())%></span>
</div>
<div style="padding-bottom:6px">
	<span style="color:red;float:left;line-height:24px;">&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(128529,user.getLanguage())+failnum+SystemEnv.getHtmlLabelName(128530,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;</span><a href="/docs/category/failfile/<%=filepath%>" style="color: #30b5ff; font-size:14px;display:block;border:1px solid #30b5ff;float:left;width:40px;line-height:24px;text-align:center"><%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%></a>
	<div style="clear:both"></div>
</div>
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>   
<%}else{%>
<div style="font-size:18px;text-align:center;padding-top:10px;line-height:<%=line_height%>px;">
	<IMG src="/images/docs/success.png" align=absMiddle><span>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())+sum+SystemEnv.getHtmlLabelName(30690,user.getLanguage())+"，"+SystemEnv.getHtmlLabelNames("332,28450",user.getLanguage())%></span>		
</div>
<%}%>
        
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeDialog()">
				</wea:item>
			</wea:group>
		</wea:layout>
	
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			   resizeDialog(document);
			
		});


		function closeDialog(){
			if(parent == parent.parent){
				parent.getDialog(window).close();
			}else if(parent.parent == parent.parent.parent){
				parent.parent.getParentWindow(parent.window).parent.parent.location.href = parent.parent.getParentWindow(parent.window).parent.parent.location.href;
				parent.parent.getDialog(parent.window).close();	
			}
			
		}
	</script>
<%} %>
   
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

</SCRIPT>

