<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#report").submit();
	}
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(79,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.report.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String department = Util.null2String(request.getParameter("department")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String publish = Util.null2String(request.getParameter("publish")) ;
String hrmstatus = Util.null2String(request.getParameter("hrmstatus")) ;
String subcompany = Util.null2String(request.getParameter("subcompany"));
String resource = Util.null2String(request.getParameter("resource")) ;
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(doccreatedateselect.equals(""))doccreatedateselect="0";

if(!doccreatedateselect.equals("") && !doccreatedateselect.equals("0") && !doccreatedateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(doccreatedateselect,"0");
	todate = TimeUtil.getDateByOption(doccreatedateselect,"1");
}

if(hrmstatus.equals(""))hrmstatus="1";

//DocSearchComInfo.resetSearchInfo();
//DocSearchComInfo.addDocstatus("1");
//DocSearchComInfo.addDocstatus("2");
//DocSearchComInfo.addDocstatus("5");
//DocSearchComInfo.setDocdepartmentid(department);
//DocSearchComInfo.setDoccreatedateFrom(fromdate);
//DocSearchComInfo.setDoccreatedateTo(todate);
//DocSearchComInfo.setIsreply(isreply) ;




String whereclause = " where 1=1 ";
if(hrmstatus.equals("1")){
 whereclause+= "and (status != 5 or status is null) ";
}else if(hrmstatus.equals("5")){
	whereclause+="and status=5 ";
}
String departmentname = "";
boolean isdepartmentvirid=false;
if(!department.equals("")){
	whereclause+=" and departmentid in ("+department+") ";
	String[] tmpArr = department.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(Util.getIntValue(tmpArr[i],0)<0){
		isdepartmentvirid=true;
		}
		if(departmentname.equals("")){
			departmentname = Util.toScreen(DepartmentComInfo.getDepartmentname(tmpArr[i]),user.getLanguage());
		}else{
			departmentname = departmentname+","+Util.toScreen(DepartmentComInfo.getDepartmentname(tmpArr[i]),user.getLanguage());
		}
	}
}
String subcompanyname = "";
boolean issubcompanyvirid = false;
if(!subcompany.equals("")){
	 whereclause+= "and subcompanyid1 in("+subcompany+") ";
	 String[] tmpArr = subcompany.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(Util.getIntValue(tmpArr[i],0)<0){
		issubcompanyvirid=true;
		}
		if(subcompanyname.equals("")){
			subcompanyname = Util.toScreen(SubCompanyComInfo.getSubCompanyname(tmpArr[i]),user.getLanguage());
		}else{
			subcompanyname = subcompanyname+","+Util.toScreen(SubCompanyComInfo.getSubCompanyname(tmpArr[i]),user.getLanguage());
		}
	}
}
String resourcename = "";
if(!resource.equals("")){
	whereclause+="and id in ("+resource+") ";
	String[] tmpArr = resource.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(resourcename.equals("")){
			resourcename = Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}else{
			resourcename = resourcename+","+Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}
	}
}
//whereclause += "and " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
//DocRpManage.setOptional("creater") ;
//DocRpManage.getRpResult(whereclause,orderbyclause,""+user.getUID()) ;

%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<FORM id=report name=report action=DocRpReadStatistic.jsp method=post>
	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
	    <wea:item>
	    <brow:browser viewType="0" name="resource" browserValue='<%= ""+resource %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp" 
				browserSpanValue='<%=resourcename%>'>
		</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<brow:browser viewType="0" name="subcompany" browserValue='<%= ""+subcompany %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=164" 
				browserSpanValue='<%=subcompanyname%>'>
		</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelNames("260,31131",user.getLanguage())%></wea:item>
	    <wea:item>
	   <span class="wuiDateSpan" selectId="doccreatedateselect">
			<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
			<input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
		</span>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	    <wea:item>
	    <brow:browser viewType="0" name="department" browserValue='<%= ""+department %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=4" 
				browserSpanValue='<%=departmentname%>'>
		</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15890,user.getLanguage())%></wea:item>
	    <wea:item>
	      <SELECT class=InputStyle  id=hrmstatus name=hrmstatus>
	        <OPTION value=0><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
	        <OPTION value=1 <%if(hrmstatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%>
	        <OPTION value=5 <%if(hrmstatus.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%>
	      </SELECT>
	    </wea:item>
	      
	  </wea:group>
	  <wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	  </wea:layout>
	</FORM>
</div>
<% 
	String doccount = "select count(distinct docid) from DocDetailLog d where t.id=d.operateuserid and operatetype=0 and usertype=1";
	String readcount = "select count(id) from DocDetailLog d where t.id=d.operateuserid and operatetype=0 and usertype=1";
	if(!fromdate.equals("")){
		doccount+=" and d.operatedate >= '"+fromdate+"'";
		readcount+=" and d.operatedate >= '"+fromdate+"'";
	}
	if(!todate.equals("")){
		doccount+=" and d.operatedate <= '"+todate+"'";
		readcount+=" and d.operatedate <='"+todate+"'";
	}
	String tabletype="none";
	String backfields="t.id,t.subcompanyid1,t.lastname,t.departmentid,"+
	"("+doccount+") as doccount,"+
	"("+readcount+") as readcount";
	String sqlform = "hrmresource t";

	if(isdepartmentvirid||issubcompanyvirid){	
	sqlform = "(  select tv1.subcompanyid as subcompanyid1  ,tv1.departmentid ,tv2.id,tv2.lastname,tv2.status from HrmResourceVirtual tv1,HrmResource tv2 where tv1.resourceid=tv2.id ) t";
	}
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_READLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_READLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sumColumns=\"doccount,readcount\"  sqlform=\""+sqlform+"\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\" sqlorderby=\"readcount\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   "<head>"+							 
			 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" column=\"id\"  orderkey=\"lastname\"/>"+
			 "<col width=\"20%\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.general.KnowledgeTransMethod.getDepartmentName\" otherpara=\""+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" transmethod=\"weaver.general.KnowledgeTransMethod.getSubcompanyName\" otherpara=\""+user.getLanguage()+"\" column=\"subcompanyid1\"  orderkey=\"subcompanyid1\"/>"+
			 "<col width=\"20%\" column=\"readcount\" orderkey=\"readcount\" text=\""+SystemEnv.getHtmlLabelName(19584,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"doccount\" orderkey=\"doccount\" text=\""+SystemEnv.getHtmlLabelName(19585,user.getLanguage())+"\"/>"+
	   "</head>"+
	   "</table>";
%>
	<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_READLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</HTML>
