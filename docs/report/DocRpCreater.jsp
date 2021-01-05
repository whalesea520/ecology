<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<%@ page import="weaver.docs.docs.reply.DocReplyUtil"%>

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
String creater = Util.null2String(request.getParameter("creater")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String publish = Util.null2String(request.getParameter("publish")) ;
String hrmstatus = Util.null2String(request.getParameter("hrmstatus")) ;
String doccreatedateselect = Util.null2String(request.getParameter("doccreatedateselect"));
if(doccreatedateselect.equals(""))doccreatedateselect="0";
boolean  isusenewreply=DocReplyUtil.isUseNewReply();
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
	whereclause+="and departmentid in ("+department+") ";
	
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
String creatername = "";
if(!creater.equals("")){
	whereclause+="and id in ("+creater+") ";
	String[] tmpArr = creater.split(",");
	for(int i=0;i<tmpArr.length;i++){
		if(creatername.equals("")){
			creatername = Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
		}else{
			creatername = creatername+","+Util.toScreen(ResourceComInfo.getLastname(tmpArr[i]),user.getLanguage());
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
	<FORM id=report name=report action=DocRpCreater.jsp method=post>
	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	     <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
	    <wea:item>
	    <brow:browser viewType="0" name="creater" browserValue='<%= ""+creater %>' 
				browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp" 
				browserSpanValue='<%=creatername%>'>
		</brow:browser>
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
	    <wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<span class="wuiDateSpan" selectId="doccreatedateselect" selectValue="<%= doccreatedateselect%>">
			    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
			    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
			</span>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelNames("30042,25005",user.getLanguage())%></wea:item>
	    <wea:item>
	      <SELECT class=InputStyle  id=hrmstatus name=hrmstatus>
	        <OPTION value=0><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
	        <OPTION value=1 <%if(hrmstatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%>
	        <OPTION value=5 <%if(hrmstatus.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%>
	      </SELECT>
	    </wea:item>
	      <wea:item><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></wea:item>
	    <wea:item>
	     <SELECT  class=InputStyle id="publish" name="publish">
		   <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		   <option value="1" <%if (publish.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></option>
		   <option value="2" <%if (publish.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></option>
		   <option value="3" <%if (publish.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24986,user.getLanguage())%></option>
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
	String doccount = "select COUNT(id) from DocDetail d where t.id = d.doccreaterid and (ishistory is null or ishistory = 0) and usertype>0 and docstatus in ('1','2','5')";
	String notreply = "select COUNT(id) from DocDetail d where t.id = d.doccreaterid and (ishistory is null or ishistory = 0) and usertype>0 and docstatus in ('1','2','5') and (d.isreply=0 or d.isreply is null)";
	String onlyreply = "select COUNT(id) from DocDetail d where t.id = d.doccreaterid and (ishistory is null or ishistory = 0) and usertype>0 and docstatus in ('1','2','5') and (d.isreply=1)";
	if(!fromdate.equals("")){
		doccount+=" and d.doccreatedate >= '"+fromdate+"'";
		notreply+=" and d.doccreatedate >= '"+fromdate+"'";
		onlyreply+=" and d.doccreatedate >= '"+fromdate+"'";
	}
	if(!todate.equals("")){
		doccount+=" and d.doccreatedate <= '"+todate+"'";
		notreply+=" and d.doccreatedate <='"+todate+"'";
		onlyreply+=" and d.doccreatedate <='"+todate+"'";
	}
	if(!publish.equals("")){
		doccount+=" and d.doctype='"+publish+"'";
		notreply+=" and d.doctype='"+publish+"'";
		onlyreply+=" and d.doctype='"+publish+"'";
	}
	String tabletype="none";
	String backfields="t.id,t.lastname,t.departmentid,"+
	"("+doccount+") as doccount,"+
	"("+notreply+") as notreplydoccount,"+
	"("+onlyreply+") as replydoccount";
	String sqlform = "hrmresource t";
	if(isdepartmentvirid){	
	sqlform = "(  select tv1.subcompanyid ,tv1.departmentid ,tv2.id,tv2.lastname,tv2.status from HrmResourceVirtual tv1,HrmResource tv2 where tv1.resourceid=tv2.id ) t";
	}
	String colString="";
	if(isusenewreply){
		colString="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" column=\"id\"  orderkey=\"lastname\"/>"+
			 "<col width=\"20%\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.general.KnowledgeTransMethod.getDepartmentName\" otherpara=\""+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"doccount\" orderkey=\"doccount\" text=\""+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"doccount\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\" molecular=\"doccount\" denominator=\"sum:doccount\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\"/>"; 
	}else{
		colString="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" column=\"id\"  orderkey=\"lastname\"/>"+
			 "<col width=\"20%\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.general.KnowledgeTransMethod.getDepartmentName\" otherpara=\""+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"doccount\" orderkey=\"doccount\" text=\""+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"doccount\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\" molecular=\"doccount\" denominator=\"sum:doccount\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"notreplydoccount\" orderkey=\"notreplydoccount\" text=\""+SystemEnv.getHtmlLabelName(18467,user.getLanguage())+"\"/>"+
			 "<col width=\"10%\" column=\"replydoccount\" orderkey=\"replydoccount\" text=\""+SystemEnv.getHtmlLabelName(18468,user.getLanguage())+"\"/>"+
			 "<col width=\"20%\" column=\"notreplydoccount\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" algorithmdesc=\""+SystemEnv.getHtmlLabelNames("18467,30041,31143",user.getLanguage())+"="+SystemEnv.getHtmlLabelName(18467,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(31626,user.getLanguage())+"\" molecular=\"notreplydoccount\" denominator=\"doccount\" text=\""+SystemEnv.getHtmlLabelNames("18467,30041,31143",user.getLanguage())+"\"/>"; 	 
	}
	String tableString=""+
	   "<table pageId=\""+PageIdConst.DOC_CREATERLIST+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_CREATERLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sumColumns=\"doccount,notreplydoccount,replydoccount\"  sqlform=\""+sqlform+"\" sqlwhere=\""+Util.toHtmlForSplitPage(whereclause)+"\" sqlorderby=\"doccount\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   "<head>"+colString+
	   "</head>"+
	   "</table>";
%>
	<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_CREATERLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</HTML>
