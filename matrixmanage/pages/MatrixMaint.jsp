
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style type="text/css">
.tab_box {
	overflow: visible !important;
}
</style>
</head>
<%

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33941,user.getLanguage());
String temptitlename = titlename;
String needfav ="1";
String needhelp ="";

boolean canmaint=HrmUserVarify.checkUserRight("Matrix:Maint", user);

String  matrixid = Util.null2String(request.getParameter("matrixid"));


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(611, user.getLanguage())
			+ ",javascript:doAdd("+matrixid+"),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{" + SystemEnv.getHtmlLabelName(23777, user.getLanguage())
	+ ",javascript:doDel(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="resource"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19909, user.getLanguage())+SystemEnv.getHtmlLabelName(33508, user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
				<span title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="doAdd(<%=matrixid %>)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"/>
				</span>
				<span title="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="doDel()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(23777, user.getLanguage())%>"/>
				</span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"   class="cornerMenu"></span>
			</td>
		</tr>
	</table>

<form name=frmmain action="MatrixMaintOperation.jsp" method=post onsubmit="return check_form(this,'subject,creater,begindate')">


<div class="advancedSearchDiv" id="advancedSearchDiv"  >
		  
</div>

<input type=hidden name=matrixid value="<%=matrixid%>">
<input type=hidden name="method" value="add">

		<%
			
			String sqlWhere = "1=1";
			if(!matrixid.equals("")){
				sqlWhere = " matrixid = "+matrixid+"";
			}
			
			//判断类型
			String typeLink = "column:type+column:resourceid+column:roleid+column:seclevel+column:rolelevel+"+user.getLanguage();
			//获取类型名称
			String typeName = "column:type+"+user.getLanguage();
			
			String tableString=""+
			   "<table instanceid=\"matrixMouldTable\" pageId=\""+PageIdConst.Voting_VotingTypeListTable+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Voting_VotingTypeListTable,user.getUID(),PageIdConst.VOTING)+"\" tabletype=\"checkbox\">"+
			   " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.matrix.MatrixManager.getMatrixMaintDel\"  popedompara=\"column:type\" />"+
			   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"MatrixMaintInfo\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
			   "<head>"+							 
			   "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" otherpara=\""+typeName+"\" transmethod=\"weaver.matrix.MatrixManager.getTypeName\"/>"+
			   "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" otherpara=\""+typeLink+"\" transmethod=\"weaver.matrix.MatrixManager.getTypeLink\"/>"+
			   "</head>"+
			   "</table>";
		%> <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

</form>
<script type="text/javascript">
var dialog = null;
function doAdd(matrixid){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33940, user.getLanguage())%>";
    dialog.URL = "/matrixmanage/pages/MatrixMaintAdd.jsp?matrixid="+matrixid;
	dialog.Width = 660;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

function MainCallback(){
	dialog.close();
	_table.reLoad();
}



 function doDel(){
	 var ids=_xtable_CheckedCheckboxId();
	 if(ids.length==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>!");
	 }else{
		 ids=ids.substr(0,ids.length-1);
		 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>？",function(){
	        $.post("/matrixmanage/pages/MatrixMaintOperation.jsp?method=delete&delids="+ids+"&matrixid=<%=matrixid%>",{},function(){
				// _table.reLoad();	
				window.location.reload();
			 })
	     });
	 }
	 
 }
  

</script>

</body>
</html>
