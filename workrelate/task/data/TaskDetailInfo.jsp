<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String titlename = SystemEnv.getHtmlLabelName(18505,user.getLanguage());
String userid = Util.null2String(request.getParameter("hrmid"));
if(userid==null || "".equals(userid)){
	userid = user.getUID()+"";
}
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchName(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
		//得到pageNum 与 perpage
		int perpage=10;
		//设置好搜索条件
		String name = Util.null2String(request.getParameter("name"));
		String backFields ="id,name,begindate,enddate,principalid,remark ";
		String fromSql = " TM_TaskInfo t1";
		
		String sqlwhere = " WHERE (deleted=0 or deleted is null)"
						+ " and (principalid="+userid+" or creater="+userid
						+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
						+ ")";
		
		if("oracle".equals(RecordSet.getDBType())){
			sqlwhere += " and (";
			sqlwhere += " (begindate >= to_char(sysdate,'yyyy') || '-01-01' and begindate<= to_char(sysdate,'yyyy') ||'-12-31')";
			sqlwhere += " or (enddate >=  to_char(sysdate,'yyyy') ||'-01-01' and enddate<= to_char(sysdate,'yyyy') ||'-12-31')";
			sqlwhere += ")";
		}else{
			sqlwhere += " and (";
			sqlwhere += " (t1.begindate >= convert(varchar(4),GetDate(),120)+'-01-01' and t1.begindate<= convert(varchar(4),GetDate(),120)+'-12-31')";
			sqlwhere += " or (t1.enddate >=  convert(varchar(4),GetDate(),120)+'-01-01' and t1.enddate<= convert(varchar(4),GetDate(),120)+'-12-31')";
			sqlwhere += ")";
		}
		
		if(name!=null && !"".equals(name)){
			sqlwhere +=" and name like '%"+name+"%'";
		}
		String orderBy = "id";
		String tableString=""+
			"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
			"<head>"+
				"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(1352,user.getLanguage())+"\" column=\"name\" orderkey=\"name\"  linkvaluecolumn=\"id\" linkkey=\"taskid\" href=\"/workrelate/task/data/Main.jsp\" target=\"_blank\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(22323,user.getLanguage())+"\" column=\"principalid\" orderkey=\"principalid\" linkkey=\"principalid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"begindate\" orderkey=\"begindate\" />"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\" />"+
				"<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"remark\" orderkey=\"remark\" />"+
			"</head>"+
			"</table>";
	%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18505,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="searchName()" type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"/>
			<input type="text" class="searchInput" placeholder="任务名称"  id="searchName" name="searchName" value="<%=name%>" />
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_SysRemindWorkPlan%>"/>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<script type="text/javascript">
$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
	jQuery("#hoverBtnSpan").hoverBtn();
});
function searchName(){
	var searchName = jQuery("#searchName").val();
	location.href = "/workrelate/task/data/TaskDetailInfo.jsp?hrmid=<%=userid%>&name="+searchName;
	
}
</script>
</BODY>
</HTML>