<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="workType" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
if(!HrmUserVarify.checkUserRight("WFEC:SETTING", user))
{
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
%>
<%
	String navName = "";
	int typeid = Util.getIntValue(Util.null2String(request.getParameter("typeid")),0);
	int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
	int _fromURL = Util.getIntValue(Util.null2String(request.getParameter("_fromURL")),1);
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),0);
	String changetype = "1";
	
	int isclose = Util.getIntValue(Util.null2String(request.getParameter("isclose")),0);
	String wftypeid = Util.null2String(request.getParameter("wftypeid"));
	String wfid = Util.null2String(request.getParameter("wfid"));
if(isclose==1){
%>	
	<script type="text/javascript">
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/exchange/managelist.jsp?reflush=1&wfid=<%=wfid%>&wftypeid=<%=wftypeid%>&subcompanyid=<%=subcompanyid%>";
	dialog.close();
	</script>
<%
}	
	//String url = "/workflow/exchange/rdata/automaticsettingEdit.jsp?viewid="+mainid;
	String tempwhere = "wfid="+wfid+"&wftypeid="+wftypeid+"&subcompanyid="+subcompanyid ;
	
	String url = "";
	String workflowid = "";
	String formid = "";
	String isbill = "";
	String showname = "";
	RecordSet.executeSql("select workflowid,name from wfec_indatawfset where id="+mainid);
	if(RecordSet.next()){
		workflowid = RecordSet.getString(1);
		showname = RecordSet.getString(2);
		formid = WorkflowComInfo.getFormId(workflowid);
		isbill = WorkflowComInfo.getIsBill(workflowid);
	}
	if(_fromURL==1){
		url = "/workflow/exchange/sdata/sdataEdit.jsp?_fromURL=1&viewid="+mainid+"&"+tempwhere;
	}else if(_fromURL==2){
		//url = "/workflow/exchange/sdata/automaticsettingAddDetail.jsp?_fromURL=2&typename=&viewid="+mainid ;
		url = "/workflow/ruleDesign/ruleMappingList.jsp?rulesrc=5&ruleid=&formid="+formid+"&isbill="+isbill+"&linkid="+mainid+"&wfid="+workflowid+"&isnew=&nodeid=&rownum=";
	}else if(_fromURL ==3 ){
		url = "/workflow/exchange/sdata/sdataAddDetail.jsp?_fromURL=3&changetype="+changetype+"&viewid="+mainid;
	}else if(_fromURL==4){
		url = "/workflow/exchange/sdata/sdataTableField.jsp?_fromURL=4&changetype="+changetype+"&viewid="+mainid;
	}else if(_fromURL==5){
		url = "/workflow/exchange/sdata/sdataAction.jsp?_fromURL=4&viewid="+mainid;
	}else if(_fromURL==6){
		url = "/workflow/exchange/sdata/sdatacallback.jsp?_fromURL=6&viewid="+mainid;
	}
	if(typeid == 0){
			navName = SystemEnv.getHtmlLabelName(82487,user.getLanguage());
	}else{
		navName = workType.getWorkTypename(typeid+"");
	}
	navName = showname ;
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 

jQuery(document).ready(function(){ setTabObjName("<%=navName%>"); });
</script>
</head>
<BODY scroll="no">
	<div class="e8_box demo2">
	      <div class="e8_boxhead">
		    <div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
			<div>
	   
		    <ul class="tab_menu">
			        <li <%if(_fromURL<=1){%> class="current"<%} %>>
				        <a href="/workflow/exchange/sdata/sdataEdit.jsp?_fromURL=1&viewid=<%=mainid %>&<%=tempwhere %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></a>
				    </li>
				    <li <%if(_fromURL==2){%> class="current"<%} %>>
					  	<a href="/workflow/ruleDesign/ruleMappingList.jsp?rulesrc=5&ruleid=&formid=<%=formid %>&isbill=<%=isbill %>&linkid=<%=mainid %>&wfid=<%=workflowid %>&isnew=&nodeid=&rownum=" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(125366,user.getLanguage())%></a>
					</li>
					<li <%if(_fromURL==3){%> class="current"<%} %>>
					  	<a href="/workflow/exchange/sdata/sdataAddDetail.jsp?_fromURL=3&changetype=<%=changetype %>&viewid=<%=mainid %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(84593,user.getLanguage())%></a>
					</li>
					<li <%if(_fromURL==4){%> class="current"<%} %>>
					  	<a href="/workflow/exchange/sdata/sdataTableField.jsp?_fromURL=4&changetype=<%=changetype %>&viewid=<%=mainid %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(84594,user.getLanguage())%></a>
					</li>
					<li <%if(_fromURL==5){%> class="current"<%} %>>
					  	<a href="/workflow/exchange/sdata/sdataAction.jsp?_fromURL=4&viewid=<%=mainid %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33085,user.getLanguage())%></a>
					</li>
					<li <%if(_fromURL==6){%> class="current"<%} %>>
					  	<a href="/workflow/exchange/sdata/sdatacallback.jsp?_fromURL=6&viewid=<%=mainid %>" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(84676,user.getLanguage())%></a>
					</li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
	function mnToggleleft(){
		var f = window.parent.oTd1.style.display;
		if (f != null) {
			if(f==''){
				window.parent.oTd1.style.display='none';
				<%if(detachable==1){%>
				window.parent.parent.oTd1.style.display='none';
				<%}%>
			}else{ 
				window.parent.oTd1.style.display='';
				var divHeght = window.parent.wfleftFrame.setHeight();
				<%if(detachable==1){%>
				window.parent.parent.leftframe.setHeight(divHeght);
				window.parent.parent.oTd1.style.display='';
				<%}%>
			}
		}
	}
	<%
	if(isclose==2){
    %>	
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
		parentWin.location.href="/workflow/exchange/managelist.jsp?reflush=1&wfid=<%=wfid%>&wftypeid=<%=wftypeid%>&subcompanyid=<%=subcompanyid%>";
	<%}%>
</script>
</html>
