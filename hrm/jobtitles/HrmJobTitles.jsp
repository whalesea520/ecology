<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String jobtitlenameq = "";
String qname = Util.null2String(request.getParameter("flowTitle"));
if(qname.length()>0&&jobtitlenameq.length()==0)jobtitlenameq=qname;

String departmentid = Util.null2String(request.getParameter("departmentid"));
String jobgroup = Util.null2String(request.getParameter("jobgroup"));
String jobactivite= Util.null2String(request.getParameter("jobactivite"));
String jobtitles= Util.null2String(request.getParameter("jobtitles"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

String businessKind = Util.null2String(request.getParameter("businessKind"));
String business = Util.null2String(request.getParameter("business"));
String stationShort = Util.null2String(request.getParameter("stationShort"));
String stationAll = Util.null2String(request.getParameter("stationAll"));
if(qname.length()==0 && stationAll.length()>0)qname = stationAll;
if(stationAll.length()==0&&qname.length()>0)stationAll=qname;
String navName = "";
if(jobtitles.length()>0){
	navName = JobTitlesComInfo.getJobTitlesname(jobtitles);
}else if(jobactivite.length()>0){
	navName = JobActivitiesComInfo.getJobActivitiesname(jobactivite);
}else if(jobgroup.length()>0){
	navName = JobGroupsComInfo.getJobGroupsname(jobgroup);
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmSearch").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;//记录一共要删除的条数
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"JobTitlesOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;//剩余条数
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesAdd&jobactivite=<%=jobactivite%>";
	}
	dialog.Width = 700;
	dialog.Height = 593;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=26 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=26")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<script type="text/javascript">
jQuery(document).ready(function(){
	<%if(navName.length()>0){%>
	parent.setTabObjName("<%= navName %>");
	<%}%>
})
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:document.frmSearch.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
if(departmentid.length()==0){
	if(HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}

	if(HrmUserVarify.checkUserRight("HrmJobTitles:Log", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog();,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

   String sqlwhere =" where 1=1 "  ;
   String searchSql = "" ;

   if(!"".equals(jobtitlenameq)){
  	 searchSql += " and jobtitlename like '%"+jobtitlenameq+"%' ";
		}
   
   if(!qname.equals("")){
  	 searchSql += " and a.jobtitlename like '%"+qname+"%'";
  	}		
   
  if (!"".equals(businessKind)) {
  	searchSql = searchSql + " AND EXISTS (SELECT 1 FROM HrmJobGroups , HrmJobActivities  WHERE a.jobactivityid = HrmJobActivities.id and HrmJobGroups.id=HrmJobActivities.jobgroupid AND HrmJobGroups.id= "+businessKind+")" ;
  }
  if (!"".equals(business)) {
  	searchSql = searchSql + " and a.jobactivityid ="+business ;
  }
  if (!"".equals(stationShort)) {
  	searchSql = searchSql + " and a.jobtitlemark like '%"+stationShort+"%'" ;
  }
  if (!"".equals(stationAll)) {
     searchSql = searchSql + " and a.jobtitlename like '%"+stationAll+"%'" ;
  }
  if (!"".equals(jobtitles)) {
    searchSql = searchSql + " and a.id ="+jobtitles ;
 	}
  
  if (!"".equals(jobactivite)) {
     searchSql = searchSql + " and a.jobactivityid ="+jobactivite ;
  }

  if (!"".equals(jobgroup)) {
     searchSql = searchSql + " AND EXISTS (SELECT 1 FROM HrmJobGroups , HrmJobActivities  WHERE a.jobactivityid = HrmJobActivities.id and HrmJobGroups.id=HrmJobActivities.jobgroupid AND HrmJobGroups.id= "+jobgroup+")" ;
  }
  
  if (!"".equals(departmentid)) {
    searchSql = searchSql + " and EXISTS (SELECT 1 FROM hrmresource d WHERE a.id=d.jobtitle AND d.departmentid="+departmentid+")" ;
 	}
  
  if (!"".equals(searchSql)) {
  	 sqlwhere = sqlwhere + searchSql ;
  }

String backfields = "a.id, jobtitlemark, jobtitlename, jobactivityid ";
String fromSql  = " from HrmJobTitles a ";
String orderby = " a.jobactivityid, a.id " ;
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
	       operateString+=" <popedom transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitleOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmJobTitles:log", user)+":"+HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)+"\"></popedom> ";
	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
	       operateString+="</operates>";	
String tabletype="checkbox";
if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
	tabletype = "checkbox";
}

String tableString =" <table pageId=\""+PageIdConst.HRM_JobTitles+"\" tabletype=\""+tabletype+"\" pagesize=\""+ PageIdConst.getPageSize(PageIdConst.HRM_JobTitles,user.getUID(),PageIdConst.HRM)+"\">"+
								 "<checkboxpopedom showmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitleCheckbox\" id=\"checkbox\"  popedompara=\"column:id\" />"+
								 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"a.id\"   sqlsortway=\"Asc\" />"+
                 operateString+
                 "			<head>"+
                 "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelNames("6086,399",user.getLanguage())+"\" column=\"jobtitlemark\" orderkey=\"jobtitlemark\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmOpenDialogName\" otherpara=\"column:id\"/>"+
                 "				<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelNames("6086,15767",user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\" />"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(15855,user.getLanguage())+"\" column=\"jobactivityid\" orderkey=\"jobactivityid\" transmethod=\"weaver.hrm.job.JobActivitiesComInfo.getJobActivitiesname\"/>"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(805,user.getLanguage())+"\" column=\"jobactivityid\" orderkey=\"jobactivityid\" transmethod=\"weaver.hrm.job.JobActivitiesComInfo.getJobGroupsname\"/>"+               
                 "			</head>"+
                 " </table>";
  %>
<!--add by dongping for fiveStar request-->
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(departmentid.length()==0){ %>
		<%if(HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){%>
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
		<%}if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)){ %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%} %>
			<%} %>
			<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname %>" onchange="setKeyword('flowTitle','stationAll','frmSearch');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="frmSearch" id="frmSearch" method="post" action="">
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0"  name="businessKind" browserValue='<%=businessKind %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobgroups/JobGroupsBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=jobgroup" width="120px" linkUrl=""
      browserSpanValue='<%=JobGroupsComInfo.getJobGroupsname(businessKind)%>'>
      </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15855,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0"  name="business" browserValue='<%=business %>' 
      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobactivities/JobActivitiesBrowser.jsp?selectedids="
      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl="/data.jsp?type=jobactivity" width="120px"
      linkUrl="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id="
      browserSpanValue='<%=JobActivitiesComInfo.getJobActivitiesname(business)%>'>
      </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input type="text" name="stationShort" class="inputStyle" value=<%=stationShort%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="stationAll" name="stationAll" class="inputStyle" value=<%=stationAll%>></wea:item>
	</wea:group>
	<wea:group context="">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
    </div>
</form>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_JobTitles %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>'  mode="run" />
 
</BODY></HTML>
