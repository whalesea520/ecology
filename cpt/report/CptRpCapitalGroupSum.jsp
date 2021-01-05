<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String isfromProjTab = Util.null2String(request.getParameter("isfromCptTab"));
String querystr=request.getQueryString();
String url="/cpt/report/CptRpCapitalGroupSum.jsp?isfromCptTab=1";
if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/cpt/capital/CapitalBlankTab.jsp"+"?url="+url);
	return;
}
%>

<%
String CurrentUser = ""+user.getUID();
if(!HrmUserVarify.checkUserRight("CptRpCapital:Display", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("cptdetachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID

if(subcompanyid1.equals("") && detachable==1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script type="text/javascript" src="/cpt/js/common_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#report").submit();
}
$(function(){
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(16597,user.getLanguage()) %>");
	}catch(e){}
});
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
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String assortmentid = Util.null2String(request.getParameter("assortmentid"));

%>
<FORM id="report" name="report" action="" method=post>
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
	
	
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
	     <wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
	    <wea:item>
		    <brow:browser viewType="0" name="assortmentid" browserValue='<%= ""+assortmentid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp?resourceids="
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=25" 
					browserSpanValue='<%=CapitalAssortmentComInfo .getAssortmentName (assortmentid) %>'>
			</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<span class="wuiDateSpan" selectId="selectDate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
			    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate%>">
			</span>
	    </wea:item>
	      
	  </wea:group>
	  <wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
			<input type="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>

</FORM>

<% 
/**
String sqlstr = "select id from CptCapitalAssortment where supassortmentid=0 ";
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String tempid = RecordSet.getString("id");
	if(detachable == 0){
		sqlstr= " select count(distinct id) from CptCapital  t1,CptShareDetail  t2 where t1.isdata='2' and t1.capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+tempid+"|%' or id = " + tempid + ") and  t1.id=t2.cptid  and t2.userid="+CurrentUser;
	}else{
		sqlstr= " select count(distinct id) from CptCapital  t1,CptShareDetail  t2 where t1.blongsubcompany = "+subcompanyid1+" and t1.isdata='2' and t1.capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+tempid+"|%' or id = " + tempid + ") and  t1.id=t2.cptid  and t2.userid="+CurrentUser;
	}
	//注意某些产品的类别在CptCapitalAssortment表里不存在！比如id=741的传真机它的类别是36
	//out.println(sqlstr);
	rs.executeSql(sqlstr);
	if(rs.next()){
		resultids.add(tempid);
		resultcounts.add(rs.getString(1));
	}
}
**/

String sqlwhere=" where t1.isdata='2'  and  exists( select 1 from CptCapitalShareInfo  t2 where  t1.id=t2.relateditemid  and ( "+CommonShareManager.getShareWhereByUser("cpt", user)+" ) ) " ;
if(!"".equals(assortmentid )){
	sqlwhere+=" and t1.capitalgroupid='"+assortmentid+"' ";
}
if(!fromdate.equals("")){
	sqlwhere+=" and t1.createdate>='"+fromdate+"' ";
}
if(!todate.equals("")){
	sqlwhere+=" and t1.createdate<='"+todate+"' ";
}
if(!subcompanyid1.equals("")){
	sqlwhere+=" and t1.blongsubcompany='"+subcompanyid1 +"' ";
}

String tabletype="none";
String backfields=" t5.lv1groupid,COUNT(t1.id) AS resultcount ";
String sqlform = " CptCapital  t1   ";
if("sqlserver".equalsIgnoreCase( RecordSet.getDBType())){
	sqlform+=" join ( select t4.id as cptgroupid,t3.id as lv1groupid,t3.assortmentname from CptCapitalAssortment t3,CptCapitalAssortment t4 where ( t4.supassortmentstr like '%|'+convert(varchar,t3.id)+'|%' or t4.id=t3.id ) and t3.supassortmentid = 0 ) t5 on t5.cptgroupid=t1.capitalgroupid";
}else{
    sqlform+=" join ( select t4.id as cptgroupid,t3.id as lv1groupid,t3.assortmentname from CptCapitalAssortment t3,CptCapitalAssortment t4 where ( t4.supassortmentstr like '%|'||to_char(t3.id)||'|%' or t4.id=t3.id ) and t3.supassortmentid = 0 ) t5 on t5.cptgroupid=t1.capitalgroupid";
}

String groupby=" t5.lv1groupid ";
String orderby=" resultcount ";
String primarykey=" t5.lv1groupid ";
String sumColumns="resultcount";

//out.println("select "+backfields+" from "+sqlform+" "+sqlwhere+" group by "+groupby+" order by "+orderby);

//out.println("commonsharewhere:"+CommonShareManager.getShareWhereByUser("cpt", user));




String tableString=""+
   "<table pageId=\""+PageIdConst.DOC_CREATERLIST+"\"  instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_CREATERLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sumColumns=\""+sumColumns+"\"  sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlgroupby=\""+groupby+"\" sqlorderby=\""+orderby+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
   "<head>"+							 
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(831,user.getLanguage())+"\" column=\"lv1groupid\"  orderkey=\"lv1groupid\" transmethod='weaver.cpt.maintenance.CapitalAssortmentComInfo.getAssortmentName' />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("535,1331",user.getLanguage())+"\" column=\"resultcount\" orderkey=\"resultcount\" />"+
		 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(1464,user.getLanguage())+"\" column=\"resultcount\" algorithmdesc=\""+SystemEnv.getHtmlLabelName(1464,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\" molecular=\"resultcount\" denominator=\"sum:resultcount\" />"+
   "</head>"+
   "</table>";
%>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_CREATERLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

	
</BODY>
	
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
