<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6073,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));
String beginEvaluation=Util.fromScreen(request.getParameter("beginEvaluation"),user.getLanguage());
String endEvaluation=Util.fromScreen(request.getParameter("endEvaluation"),user.getLanguage());


String sqlwhere="";
if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.createdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.createdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if("6".equals(datetype) && !fromdate.equals("")){
	sqlwhere+=" and t1.createdate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlwhere+=" and t1.createdate<='"+enddate+"'";
}



String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="ContractExport()" type="button"  value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >
<form id=weaver name=frmmain method=post action="CRMEvaluationRpChild.jsp">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
		
		
		<%if(!user.getLogintype().equals("2")){%>
			  <wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
			  <wea:item>
			 	 <brow:browser viewType="0" name="viewer" 
					        browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					        browserValue='<%=resource+""%>' 
					        browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
					        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
					        completeUrl="/data.jsp" width="150px" ></brow:browser>
			  </wea:item>
		  <%}%>
		  
	  <wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
	  <wea:item>
		<span>
	        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
				  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
		</span>
        
       	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
		  <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
		  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
		  <input type="hidden" name="fromdate" value=<%=fromdate%>>
		  －
		  <BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
		  <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
		  <input type="hidden" name="enddate" value=<%=enddate%>>
		 </span>
	  </wea:item>
	  
    	<wea:item><%=SystemEnv.getHtmlLabelName(6073,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT text class=InputStyle maxLength=20 size=12 id="beginEvaluation" name="beginEvaluation"  
				 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("beginEvaluation");comparenumber()' value="<%=beginEvaluation%>" style="width: 80px;">
	     	-
	     	<INPUT text class=InputStyle maxLength=20 size=12 id="endEvaluation" name="endEvaluation"   
	     		onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("endEvaluation");comparenumber()' value="<%=endEvaluation%>" style="width: 80px;">
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<%
String backFields = "";
String fromSql = "";
String orderBy = "";
String isnull = "isnull";
if(RecordSet.getDBType().equals("oracle")){
	isnull = "nvl";
	backFields=" id,evaluation,manager,createdate ";
	orderBy = "t1.createdate";
	if(user.getLogintype().equals("1")){
		fromSql=" CRM_CustomerInfo  t1,"+leftjointable+"  t2";
		sqlwhere = sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid";
	}else{
		fromSql=" CRM_CustomerInfo  t1";
		sqlwhere = sqlwhere +"  and t1.deleted <>1 and t1.agent="+user.getUID();
	}
}else if(RecordSet.getDBType().equals("db2")){
	backFields=" id,evaluation,manager,createdate ";
	orderBy = "t1.createdate";
	if(user.getLogintype().equals("1")){
		fromSql=" CRM_CustomerInfo  t1,"+leftjointable+"  t2";
		sqlwhere = sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid";
	}else{
		fromSql=" CRM_CustomerInfo  t1";
		sqlwhere = sqlwhere +"  and t1.deleted <>1 and t1.agent="+user.getUID();
	}
}else{
	backFields=" id,evaluation,manager,createdate ";
	orderBy = "t1.createdate";
	if(user.getLogintype().equals("1")){
		fromSql=" CRM_CustomerInfo  t1,"+leftjointable+"  t2";
		sqlwhere = sqlwhere +" and t1.deleted <>1 and t1.id = t2.relateditemid";
	}else{
		fromSql=" CRM_CustomerInfo  t1";
		sqlwhere = sqlwhere +"  and t1.deleted <>1 and t1.agent="+user.getUID();
	}
}

backFields+=" , (SELECT "+isnull+"(sum(t5.field),0) FROM ( SELECT levelId * (SELECT proportion FROM CRM_Evaluation WHERE id = evaluationId)  AS field"+ 
	" FROM   CRM_Evaluation_LevelDetail WHERE customerID = t1.id) t5) AS evaluationValue";
//别名不支持做判断语句，嵌套一层select
if(!sqlwhere.equals("")){
	sqlwhere = sqlwhere.replaceFirst("and"," ");
}

fromSql = "(select "+backFields+" from "+fromSql+" where " +sqlwhere+") t8";
orderBy = "createdate";
backFields = "t8.id, t8.evaluation, t8.manager, t8.createdate , t8.evaluationValue";
sqlwhere = "";

if(!beginEvaluation.equals("")){
	sqlwhere+=" and t8.evaluationValue>="+Util.getFloatValue(beginEvaluation)*100+"";
}

if(!endEvaluation.equals("")){
	sqlwhere+=" and t8.evaluationValue<="+Util.getFloatValue(endEvaluation)*100+"";
}
if(!sqlwhere.equals("")){
	sqlwhere = sqlwhere.replaceFirst("and"," ");
}
String linkstr = "/CRM/data/ViewCustomer.jsp";
String tableString=""+
       "<table pageId=\""+PageIdConst.CRM_RPEvaluation+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPEvaluation,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+
       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlisdistinct=\"true\"/>"+
       "<head>"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" href=\""+linkstr+"\" linkkey=\"CustomerID\" linkvaluecolumn=\"id\"  transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"/>"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(6073,user.getLanguage())+"\" column=\"evaluationValue\" orderkey=\"evaluation\" "+
             	" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getEvaluationValue\" />"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1278,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\" />"+
       "</head>"+
       "</table>";
%>
			<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPEvaluation%>">
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<!-- modified by xwj 2005-03-25 for TD 1554 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
});
function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}  
  
function ContractExport(){
    _xtable_getAllExcel();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
