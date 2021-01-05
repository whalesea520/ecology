
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
	
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%

if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(178,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name = Util.null2String(request.getParameter("name"));
String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,category , sequence";
String fromSql  = " cowork_maintypes ";
String sqlWhere = " 1=1";
String orderby = " sequence  , id";

if(!"".equals(name)){
	sqlWhere+=" and typename like '%"+name+"%'";
}

tableString = " <table tabletype=\"checkbox\" pageId=\""+PageIdConst.Cowork_MainTypeList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_MainTypeList,user.getUID(),PageIdConst.COWORK)+"\" >"+
			  " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getMainTypeCheckBox\" />"+
			  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
              " <head>"+
              "	<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" orderkey=\"typename\" column=\"typename\" linkvaluecolumn=\"id\" href=\"javascript:editCoworkType('{0}')\"/>"+
              "	<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelNames("156,92",user.getLanguage())+"\" orderkey=\"category\" column=\"category\" transmethod=\"weaver.general.CoworkTransMethod.getMainTypeCategory\"/>"+
              "	<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" orderkey=\"sequence\" column=\"sequence\"/>"+
              "	</head>"+ 
              " <operates width=\"15%\">"+
              "     <popedom transmethod=\"weaver.general.CoworkTransMethod.getMainTypeOperates\"></popedom> "+
      		  "     <operate  href=\"javascript:editCoworkType()\"   text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"    target=\"_self\"  index=\"0\"/>"+
      		  "     <operate  href=\"javascript:delCowork()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"+
      		  " </operates>"+
              "</table>";

String sql="select * from cowork_maintypes ";
RecordSet.executeSql(sql);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchName(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:newCoworkType(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16493,user.getLanguage())%>"/>
</jsp:include>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="newCoworkType()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="name" name="name" value="<%=name %>" onchange="searchName()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_MainTypeList%>">	
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			
<script type="text/javascript">

var diag= null ;

$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});


function closeDialog(){
	if(diag)
		diag.close();
}

function MainCallback(){
	diag.close();
	_table.reLoad();
}

function newCoworkType(){
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(83198,user.getLanguage())%>";
	diag.URL = "/cowork/type/CoworkMainTypeAdd.jsp";
	diag.Width = 420;
	diag.Height = 250;
	diag.Drag = true;
	diag.show();
	document.body.click();
}

 function getCoworkDialog(title,width,height){
    diag =new window.top.Dialog();
    diag.currentWindow = window; 
	diag.Width =420;
	diag.Height =200;
	diag.ShowButtonRow=false;
	diag.Title = title;
}
 
 function editCoworkType(id){
 
 	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(83199,user.getLanguage())%>";
	diag.URL = "/cowork/type/CoworkMainTypeEdit.jsp?id="+id;
	diag.Width = 420;
	diag.Height = 250;
	diag.Drag = true;
	diag.show();
	document.body.click();
}

function delCowork(id){

	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>",function(){
		$.post("MainTypeOperation.jsp?operation=delete&id="+id,{},function(){
			_table.reLoad();
		})
	});
}

function batchDelete(){
	var ids = _xtable_CheckedCheckboxId();
	
	if("" == ids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	ids = ids.substring(0 ,ids.length - 1);
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>",function(){
		jQuery.post("MainTypeOperation.jsp",{"operation":"delete" ,"id":ids},function(){
			_table.reLoad();
		});
	});

}

function searchName(){
	var name = jQuery("#name").val();
	location.href="CoworkMainType.jsp?name="+name;
}
</script>

</BODY>
</HTML>
