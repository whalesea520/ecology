
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>

<%

String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String departmentid=Util.null2String(request.getParameter("departmentid"));

String lastname = Util.null2String(request.getParameter("lastname"));
String resource = Util.null2String(request.getParameter("resource"));
String jobtitle = Util.null2String(request.getParameter("jobtitle"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

int userId = Util.getIntValue(request.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript">



var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
	_table.reLoad();
}

function addBatch(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/AddMailSpace.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33511,34246",user.getLanguage()) %>";
	dialog.Width = 450;
	dialog.Height = 300;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editInfo(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/editMailSpace.jsp?id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,34246",user.getLanguage()) %>";
	dialog.Width = 450;
	dialog.Height = 250;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();

}


function searchLastname(){
	var lastname = jQuery("#lastname").val();
	location.href = "MailSpaceList.jsp?lastname="+lastname+"&subcompanyid=<%=subcompanyid%>&departmentid=<%=departmentid%>";
}

</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("20839,68",user.getLanguage())+",javascript:addBatch(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%


String sqlWhereTemp = " 1=1";
if(!"".equals(subcompanyid)){
	sqlWhereTemp+= " and subcompanyid1 = "+subcompanyid;
}

if(!"".equals(departmentid)){
	sqlWhereTemp+= " and departmentid = "+departmentid;
}

if(!"".equals(lastname)){
	sqlWhereTemp+= " and lastname like '%"+lastname+"%' ";
}

if(!"".equals(resource)){
	sqlWhereTemp+= " and id = '"+resource+"' ";
}

if(!"".equals(jobtitle)){
	sqlWhereTemp+= " and jobtitle = '"+jobtitle+"' ";
}


String backFields = "t1.* , occupyspace occupyspace_n";
String sqlFrom = "HrmResource t1";
String sqlwhere = sqlWhereTemp + " and (status = 0 or status = 1 or status = 2 or status = 3)  and status != 10 ";
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailMaintTransMethod.getMailSpaceOpreatePopedom\" column=\"id\"></popedom> ";
       operateString+="     <operate href=\"javascript:editInfo()\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	   operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_SpaceList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_SpaceList,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"none\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\"  sqlsortway=\"asc\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"15%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" column=\"lastname\"/>";
       tableString+="<col width=\"20%\"  target=\"_fullwindow\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\""+
       		" orderkey=\"subcompanyid1\" href=\"/hrm/company/HrmDepartment.jsp\"  linkkey=\"subcompanyid\"  transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\"  />";
       tableString+="<col width=\"15%\"  target=\"_fullwindow\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\""+
       		" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkkey=\"id\" href=\"/hrm/company/HrmDepartmentDsp.jsp\"/>";
       //tableString+="<col width=\"20%\"  target=\"_fullwindow\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" "+
       //	    " orderkey=\"jobtitle\" linkkey=\"id\"  transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" href=\"/hrm/jobtitles/HrmJobTitlesEdit.jsp\"/>";
       tableString+="<col width=\"15%\"   text=\"总空间(MB)\" column=\"totalspace\"/>";
       tableString+="<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(20005,user.getLanguage())+"(MB)\" column=\"occupyspace_n\"/>";
       tableString+="<col width=\"30%\"  target=\"_self\" column=\"occupyspace\" text=\"邮箱空间(MB)使用情况\""+
       	  " algorithmdesc=\""+SystemEnv.getHtmlLabelName(20005,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(20005,user.getLanguage())+"/总空间\""+
          " molecular=\"occupyspace\" denominator=\"totalspace\"/>";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>
<body>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="addBatch()" type="button" value="<%=SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="lastname" name="lastname" value="<%=lastname %>"
				onchange="searchLastname()"/>
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form id="weaver" method="post" action="MailSpaceList.jsp">
		<wea:layout type="4Col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="resource" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         browserValue='<%=resource%>' 
			         browserSpanValue = '<%=ResourceComInfo.getResourcename(resource)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp" width="80%" ></brow:browser> 
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="subcompanyid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
			         browserValue='<%=subcompanyid%>' 
			         browserSpanValue = '<%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=164" width="80%" ></brow:browser> 
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="departmentid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         browserValue='<%=departmentid%>' 
			         browserSpanValue = '<%=DepartmentComInfo.getDepartmentNames(departmentid)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=4" width="80%" ></brow:browser> 
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="jobtitle" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
			         browserValue='<%=jobtitle%>' 
			         browserSpanValue = '<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=hrmjobtitles" width="80%" ></brow:browser> 
				</wea:item>
				
			</wea:group>
			
			<wea:group context="" attributes="{'Display':'none'}">
				<wea:item type="toolbar">
					<input type="submit" class="e8_btn_submit" value="搜索" id="searchBtn"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="重置" class="e8_btn_cancel" onclick="resetCondition()"/>
					<span class="e8_sep_line">|</span>
					<input type="button" value="取消" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_SpaceList%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
<script>
jQuery(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
});
</script>
</body>
</html>
