<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
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
</head>

<%

String parentid = Util.fromScreen(request.getParameter("paraid"),user.getLanguage());
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
boolean canedit = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);


%>


<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";

%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

if(canedit){
    RCMenu += "{"+SystemEnv.getHtmlLabelNames("611",user.getLanguage())+",javascript:onShare("+parentid+"),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:onPermissionDel(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}


%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="/proj/Maint/PrjTypeShareDsp.jsp" >
<input type="hidden" name="assortid" value="<%=parentid %>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<% 
if(canedit){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" class="e8_btn_top" onclick="onShare(<%=parentid %>);"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="onPermissionDel()"/>
	
	<%
}

%>		
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
</div>	

<%
	String sqlWhere = "typeid="+parentid+" and operationcode=0";
	String operateString="";
	String tabletype="none";
	String tableString = "";
	int perpage=6; 
	if(canedit){
		operateString = "<operates width=\"10%\">";
		 	       operateString+=" <popedom></popedom> ";
		 	       operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
		 	       operateString+="</operates>";	
	}
	
	 if(canedit){
	 	tabletype = "checkbox";
	 }
	tableString=""+
	   "<table instanceid=\"TypeCreateListTable\" pagesize=\""+perpage+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"prj_typecreatelist\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col width=\"30%\" transmethod=\"weaver.proj.util.ProjectTransUtil.getPermissionType\" text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"permissiontype\"/>"+
			 "<col width=\"30%\"  transmethod=\"weaver.proj.Maint.TypeMultiAclManager.getPermissionDesc\" column=\"permissiontype\" otherpara=\""+user.getLanguage()+"+column:secLevel+column:departmentid+column:roleid+column:roleLevel+column:usertype+column:userid+column:subcompanyid+column:id\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\"/>"+
			 "<col width=\"30%\" transmethod=\"weaver.proj.Maint.TypeMultiAclManager.getPermissionSeclevel\" column=\"secLevel\" otherpara=\""+user.getLanguage()+"+column:secLevelmax\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\"/>"+
		"</head>"+
	   "</table>";
	   
%> 
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
<script type="text/javascript">
function onShare(id){
	if(id){
		var url="/proj/Maint/PrjTypeAddCreate.jsp?isdialog=1&typeid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%><%=SystemEnv.getHtmlLabelNames("21945",user.getLanguage())%>";
		openDialog(url,title,500,290);
	}
}

function chkPermissionAllClick0(obj){
    var chks = document.getElementsByName("chkPermissionShareId0");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}
function doDel(id){
	 onPermissionDel(id);
}
function onPermissionDel(mainids){
    if(!mainids){
    	mainids = _xtable_CheckedCheckboxIdForCP();
    }
    if(!mainids)
    {
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26178,user.getLanguage())%>");  
    	return;
    }
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){ 
    	window.location = "/proj/Maint/PrjTypePermissionOperation.jsp?typeid=<%=parentid%>&isdialog=1&operationcode=0&method=delete&mainids="+mainids+"";
    });
}


</script>

<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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
</BODY>
</HTML>
