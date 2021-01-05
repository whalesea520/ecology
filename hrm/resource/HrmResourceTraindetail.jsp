<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String applyworkflowid = "" ;
rs.executeSql("select id from workflow_base  where formid = 48 and isbill='1' and isvalid = '1' ");
if( rs.next() ) applyworkflowid = Util.null2String(rs.getString("id"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function jsApply(trainplanid){
	openFullWindowForXtable("/workflow/request/AddRequest.jsp?workflowid=<%=applyworkflowid%>&TrainPlanId="+trainplanid);
}
</script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;

if(resourceid.equals("")) resourceid=String.valueOf(user.getUID());

char separator = Util.getSeparator() ;

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(6156,user.getLanguage());
String needfav ="1";
String needhelp ="";

String qname = Util.null2String(request.getParameter("flowTitle"));
String planname = Util.null2String(request.getParameter("planname"));
String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}
String fromdatetoselect = Util.null2String(request.getParameter("fromdatetoselect"));
String fromdateto=Util.fromScreen(request.getParameter("fromdateto"),user.getLanguage());
String enddateto=Util.fromScreen(request.getParameter("enddateto"),user.getLanguage());
if(!fromdatetoselect.equals("") && !fromdatetoselect.equals("0")&& !fromdatetoselect.equals("6")){
	fromdateto = TimeUtil.getDateByOption(fromdatetoselect,"0");
	enddateto = TimeUtil.getDateByOption(fromdatetoselect,"1");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<form id="searchfrm" name="searchfrm" method="post" action="HrmResourceTraindetail.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(33589,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="planname" name="planname" class="inputStyle" value='<%=planname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
			<wea:item>
				<select name="fromdateselect" id="fromdateselect" onchange="changeDate(this,'spanFromdate');" style="width: 135px">
	    		<option value="0" <%=fromdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value="1" <%=fromdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
	    		<option value="2" <%=fromdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
	    		<option value="3" <%=fromdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
	    		<option value="4" <%=fromdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
	    		<option value="5" <%=fromdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
	    		<option value="6" <%=fromdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
	    	</select>
	       <span id=spanFromdate style="<%=fromdateselect.equals("6")?"":"display:none;" %>">
	      		<BUTTON class=Calendar type="button" id=selectFromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON>
	       		<SPAN id=fromdatespan ><%=fromdate%></SPAN>－

	       		<BUTTON class=Calendar type="button" id=selectEnddate onclick="getDate(enddatespan,enddate)"></BUTTON>
	       		<SPAN id=enddatespan ><%=enddate%></SPAN>
	       </span>
	       <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>">
	       <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
			<wea:item>
			<select name="fromdatetoselect" id="fromdatetoselect" onchange="changeDate(this,'spanFromdateto');" style="width: 135px">
	    		<option value="0" <%=fromdatetoselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value="1" <%=fromdatetoselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
	    		<option value="2" <%=fromdatetoselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
	    		<option value="3" <%=fromdatetoselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
	    		<option value="4" <%=fromdatetoselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
	    		<option value="5" <%=fromdatetoselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
	    		<option value="6" <%=fromdatetoselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
	    	</select>
	       <span id=spanFromdateto style="<%=fromdatetoselect.equals("6")?"":"display:none;" %>">
	      		<BUTTON class=Calendar type="button" id=selectFromdateto onclick="getDate(fromdatetospan,fromdateto)"></BUTTON>
	       		<SPAN id=fromdatetospan ><%=fromdateto%></SPAN>－

	       		<BUTTON class=Calendar type="button" id=selectEnddateto onclick="getDate(enddatetospan,enddateto)"></BUTTON>
	       		<SPAN id=enddatetospan ><%=enddateto%></SPAN>
	       </span>
	       <input class=inputstyle type="hidden" id="fromdateto" name="fromdateto" value="<%=fromdateto%>">
	       <input class=inputstyle type="hidden" id="enddateto" name="enddateto" value="<%=enddateto%>"> 
			</wea:item>
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
    <%
		int i=0;
	
	    ArrayList al = new ArrayList();
	    al = TrainPlanComInfo.getTrainPlanByResource(resourceid);
		  String trainplanids = "";
	    for(int j = 0; j<al.size(); j++){
			  String trainplanid = (String)al.get(j);
			  if(trainplanids.length()>0)trainplanids+=",";
			  trainplanids+=trainplanid;
		  }
	   
	    
    String backfields = " id, planname, createrid, planorganizer, planstartdate, planenddate"; 
    String fromSql  = " from HrmTrainPlan ";
    String sqlWhere = " where 1=1 ";
    String orderby = " id " ;
    String tableString = "";
    
    if(trainplanids.length()>0){
    	sqlWhere += " and id in("+trainplanids+") ";
    }else{
    	sqlWhere += " and 1=2 ";
    }

		if(qname.length()>0){
			sqlWhere+=" and planname like '%"+qname+"%'";
		}
		
		if(planname.length()>0){
			sqlWhere+=" and planname like '%"+planname+"%'";
		}
		
		if(!fromdate.equals("")){
			sqlWhere+=" and planstartdate >='"+fromdate+"'";
		}

		if(!enddate.equals("")){
			sqlWhere+=" and (planenddate>='"+enddate+"' or planenddate is null)";
		}
		if(!fromdateto.equals("")){
			sqlWhere+=" and (planstartdate<='"+enddateto+"' and planstartdate is not null and planstartdate <> '')";
		}

		if(!enddateto.equals("")){
		 	sqlWhere+=" and (planenddate<='"+enddateto+"' and planenddate is not null and planenddate <> '')";
		}
		
		//操作字符串

		String  operateString= "";
		operateString = "<operates width=\"20%\">";
		 	       //operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
		 	       operateString+="     <operate href=\"javascript:jsApply()\" text=\""+SystemEnv.getHtmlLabelName(129,user.getLanguage())+"\" column=\"id\" index=\"0\"/>";
		 	       operateString+="</operates>";	
		tableString =" <table pageId=\""+PageIdConst.HRM_ResourceTrainDetail+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceTrainDetail,user.getUID(),PageIdConst.HRM)+"\" >"+
				"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    operateString+
		    "			<head>"+
		    "				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(33589,user.getLanguage())+"\" column=\"planname\" orderkey=\"planname\" />"+
		    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(16141,user.getLanguage())+"\" column=\"planorganizer\" orderkey=\"planorganizer\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename\" />"+
		    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"planstartdate\" orderkey=\"planstartdate\" />"+
		    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+ "\" column=\"planenddate\" orderkey=\"planenddate\" />"+
		    "			</head>"+
		    " </table>";
		%>
		 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceTrainDetail %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
