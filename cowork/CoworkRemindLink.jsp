
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18822,user.getLanguage());
String needfav ="1";
String needhelp ="";

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;

String userid = ""+user.getUID();
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+",javascript:setReadBatch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
	String name = Util.null2String(request.getParameter("name"));
	String backfields = "t1.id,t1.name,t1.lastdiscussant,t1.lastupdatedate,t1.lastupdatetime,t2.typename ";
	String sqlWhere = "";
	if(RecordSet.getDBType().equals("oracle")){
		sqlWhere = "where t1.status=1 and t1.typeid=t2.id ";
	}else{
		sqlWhere = "where t1.status=1 and t1.typeid=t2.id ";
	}
	
	if(!"".equals(name)){
		sqlWhere += " and name like '%"+name+"%'";
	}
	
	sqlWhere+=" and   t1.typeid=t2.id and t1.id in (select requestid from syspoppupremindinfonew where userid="+userid+" and type=9) ";
	String fromSql  = "from cowork_items t1,cowork_types t2 ";
	String orderby = "t1.id " ;
	String operateString= "<operates width=\"15%\">";
   	 		operateString+="     <operate href=\"javascript:setRead()\"  text=\""+SystemEnv.getHtmlLabelName(18492,user.getLanguage())+"\" target=\"_blank\"  index=\"0\"/>";
    		operateString+="</operates>";

	String tableString = " <table instanceid=\"info\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
						"	 <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
						"		<head>"+
						"			<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(18831,user.getLanguage())+"\" column=\"name\" orderkey=\"t1.name\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/cowork/ViewCoWork.jsp\" target=\"_blank\"/>"+
						"			<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(20899,user.getLanguage())+"\" column=\"lastdiscussant\" orderkey=\"t1.lastdiscussant\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\" />"+
						"			<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(23066,user.getLanguage())+"\" column=\"lastupdatedate\" orderkey=\"t1.lastupdatedate,t1.lastupdatetime\" otherpara=\"column:lastupdatetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
						"			<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+"\" column=\"typename\" orderkey=\"t2.typename\" />"+
						"		</head>"+operateString+
						"</table>";
%>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18822,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="setReadBatch()" type="button" value="<%=SystemEnv.getHtmlLabelName(18492,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=name%>" />
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<script type="text/javascript">
$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
	jQuery("#hoverBtnSpan").hoverBtn();
});
function searchName(){
	
	var searchName = jQuery("#searchName").val();
	location.href = "/cowork/CoworkRemindLink.jsp?name="+searchName;
	
}

function setReadBatch(){
	var ids = _xtable_CheckedCheckboxId();
	if("" == ids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	setRead(ids);
}


function setRead(ids){
	jQuery.post("/cowork/CoworkOperation.jsp",{"method":"coworkRemindLink","ids":ids},function(){
		_table.reLoad();
	});
}
</script>
</BODY>
</HTML>
