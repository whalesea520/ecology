<%@ page import="weaver.general.Util,
                 weaver.hrm.resign.ResignProcess" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.authority.manager.EmailManager"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<% if(!HrmUserVarify.checkUserRight("Resign:Main",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language=javascript src="/js/weaver_wev8.js"></SCRIPT>
<script type="text/javascript">
function jsSubmit(e,datas,name){
frmmain.submit();
}
</script>
</HEAD>

<%
String resourceid=Util.null2String(request.getParameter("resourceid"));
if(resourceid.equals("undefined"))resourceid="";
String resourceid_kwd=Util.null2String(request.getParameter("resourceid_kwd"));
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(18133,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmmain method=get action="Resign.jsp" >
<input id="resourceid" name="resourceid" type="hidden" value="<%=resourceid %>">
<%
String[] resourceids = null;

if(resourceid.length()>0){
	resourceids = resourceid.split(",");
}
if(resourceids!=null&&resourceids.length>0){
	if(resourceid_kwd.length()==0)resourceid_kwd = resourceids[0];
}
%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33047,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18133,user.getLanguage())%></wea:item>
    <wea:item>
    		<%
	  String lastname = "";
	  if(resourceid_kwd.length()>0) lastname = ResourceComInfo.getLastname(resourceid_kwd);
	  %>
      <span>
	  	<brow:browser viewType="0" name="resourceid_kwd" browserValue='<%=resourceid_kwd %>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="120px"
            _callback="jsSubmit"
            browserSpanValue='<%=lastname %>'></brow:browser>
       	</span>
			<!-- 
			 <INPUT class="wuiBrowser" type=hidden name="resourceid" value="<%=resourceid_kwd%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/dismiss/ResourceBrowser.jsp" _required="yes"
		_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
		_callback="frmmain.submit()";
		_displayText="<A href='/hrm/resource/HrmResource.jsp?id=<%=resourceid_kwd%>'><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid_kwd),user.getLanguage())%></A>">
			 -->
    </wea:item>
	</wea:group>
	<%if(resourceid_kwd.length()>0){ %>
<wea:group context='<%=SystemEnv.getHtmlLabelName(33202,user.getLanguage())%>' >
<wea:item attributes="{'isTableList':'true'}">
<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'30%,30%,40%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></wea:item>
	<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></wea:item>
	<%
    if( ! resourceid_kwd.equals("") ) {
    int wf_count=ResignProcess.countWorkFlows(resourceid_kwd);
    int doc_count=ResignProcess.countDocuments(resourceid_kwd);
    int cus_count=ResignProcess.countCustoms(resourceid_kwd);
    RecordSet.executeSql("select count(*) from Prj_ProjectInfo t1 where t1.manager ="+resourceid_kwd);
    int task_count=0;
    if(RecordSet.next()){
       task_count=RecordSet.getInt(1);
    }
	String sqlStr1 = "Select count(*) From Prj_TaskProcess t1, Prj_ProjectInfo t2 Where t1.isdelete =0 and t1.hrmid="+resourceid_kwd+" and (t1.begindate<='"+CurrentDate+"' or t1.begindate='x') and ( t1.enddate>='"+CurrentDate+"' or t1.enddate='-' ) and t2.id = t1.prjid and t2.status not in (0,6,7)";
	RecordSetM.executeSql(sqlStr1);
	//out.println("=====sqlStr1:"+sqlStr1);
	int count1 = 0;
	if(RecordSetM.next()){
	count1 = RecordSetM.getInt(1);
	}
	String sqlStr2 = "Select count(*) From Prj_TaskProcess t1, Prj_ProjectInfo t2 Where t1.isdelete =0 and t1.hrmid="+resourceid_kwd+" and (t1.enddate<'"+CurrentDate+"' and t1.enddate <>'-') and (t1.Finish < 100 or (t1.Finish = 100 and t1.Status <> 0 )) and t2.id = t1.prjid and t2.status not in (0,6,7)";
	RecordSetT.executeSql(sqlStr2);
	//out.println("=====sqlStr2:"+sqlStr2);
	int count2 = 0;
	if(RecordSetT.next()){
	count2 = RecordSetT.getInt(1);
	}
	int duty_count =count1+count2;
    double debt_count=ResignProcess.countDebts(resourceid_kwd);
    int cap_count=ResignProcess.countCapitals(resourceid_kwd);
    int role_count=ResignProcess.countRoles(resourceid_kwd);
    int cowork_count=ResignProcess.countCoworks(resourceid_kwd);
    int undualEmail_count = new EmailManager().getAllNum("","Temail001",resourceid_kwd) ;
    	
%>
   <wea:item><%=SystemEnv.getHtmlLabelName(17569,user.getLanguage())%></wea:item>
   <wea:item><%=wf_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Workflows&id=<%=resourceid_kwd%>&total=<%=wf_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(17570,user.getLanguage())%></wea:item>
   <wea:item><%=doc_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Documents&id=<%=resourceid_kwd%>&total=<%=doc_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(17571,user.getLanguage())%></wea:item>
   <wea:item><%=cus_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Customers&id=<%=resourceid_kwd%>&total=<%=cus_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(17572,user.getLanguage())%></wea:item>
   <wea:item><%=task_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Tasks&id=<%=resourceid_kwd%>&total=<%=task_count%>"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(21699,user.getLanguage())%></wea:item>
   <wea:item><%=duty_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Duty&id=<%=resourceid_kwd%>&total=<%=duty_count%>"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(17573,user.getLanguage())%></wea:item>
   <wea:item><%=debt_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Debts&id=<%=resourceid_kwd%>&total=<%=debt_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(17574,user.getLanguage())%></wea:item>
   <wea:item><%=cap_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Capitals&id=<%=resourceid_kwd%>&total=<%=cap_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(17575,user.getLanguage())%></wea:item>
   <wea:item><%=role_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Roles&id=<%=resourceid_kwd%>&total=<%=role_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></wea:item>
   <wea:item><%=cowork_count%></wea:item>
   <wea:item><A target="_blank" href="/hrm/HrmTab.jsp?_fromURL=Coworks&id=<%=resourceid_kwd%>&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
   <wea:item><%=SystemEnv.getHtmlLabelNames("15746,24714",user.getLanguage())%></wea:item>
   <wea:item><%=undualEmail_count%></wea:item>
   <wea:item><A target="_blank" href="/email/transfer/EmailTab.jsp?folderid=0&isHidden=true&_fromURL=Temail001&fromid=<%=resourceid_kwd %>&type=Temail001IdStr"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></wea:item>
<%}%>
	</wea:group>
</wea:layout>
</wea:item>
</wea:group>
	<%} %>
</wea:layout>
</FORM>
<script type="text/javascript">
function onShowResource(tdname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(results){
	  if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	  	jQuery($GetEle(tdname)).html("<a href='javascript:openhrm("+wuiUtil.getJsonValueByIndex(results,0)+")'>"+wuiUtil.getJsonValueByIndex(results,1)+"</a>");
	     jQuery("input[name='"+inputename+"']")[0].value=wuiUtil.getJsonValueByIndex(results,0);
	  }else{
	     jQuery($GetEle(tdname)).html("");
	     jQuery("input[name='"+inputename+"']").val("");
	  }
	}
}
</script>
<script language=vbs>
sub onShowResource1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/dismiss/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid_kwd.value=id(0)
	frmmain.action="Resign.jsp"
    frmmain.submit()
	else 
	resourcespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmmain.resourceid_kwd.value=""
	end if
	end if
end sub
</script>

</body>
</html>
