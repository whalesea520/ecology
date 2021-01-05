<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="WFSubDataAggregation" class="weaver.workflow.workflow.WFSubDataAggregation" scope="page" />
<%
//int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int subworkflowid = Util.getIntValue(request.getParameter("subworkflowid"),0);
String titlename = SystemEnv.getHtmlLabelName(82104,user.getLanguage());

//获取主流程所有字段信息
String formid = "0";
String isBill = "0";
rs.executeSql("SELECT formid,isBill FROM workflow_base WHERE id="+subworkflowid);
if (rs.next()) {
	formid = rs.getString(1);
	isBill = rs.getString(2);
}

//搜索
String fieldName = Util.null2String(request.getParameter("fieldName"));
String detailGroup = Util.null2String(request.getParameter("detailGroup"));
if("-1".equals(detailGroup)){
	detailGroup = "";
}
List<String> detailSelect = WFSubDataAggregation.getDetailSelect(formid,isBill);
%>
<html>
<head>	
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
.shouline{
	border:1px solid #DADADA;border-top:none;border-left:none;border-right:none;
}
</style>

<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("td[member='member']").closest("tr").addClass("shouline");
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
  	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
  	//$("#tabDiv").remove();	
});

function onBtnSearchClick(){
	document.SearchForm.submit();
}

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent.window);
	dialog =parent.parent.getDialog(parent.window);
}catch(e){}

function onClose(){
	dialog.close();
}

function fieldListSearch(){
	document.SearchForm.submit();
}

function afterDoWhenLoaded(){
	//hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var returnjson = {
			fieldId:$($(this).children()[4]).text(),
			fieldName:$($(this).children()[1]).text(),
			detailGroupid:$($(this).children()[5]).text(),
			detailGroup:$($(this).children()[2]).text(),
			fieldHtmlType:$($(this).children()[6]).text(),
			fieldType:$($(this).children()[7]).text(),
			fieldNames:$($(this).children()[8]).text()
		};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	});

}


function submitClear()
{
	var returnjson = {fieldId:"",fieldName:"",detailGroupid:"",detailGroup:"",fieldHtmlType:"",fieldType:"",fieldNames:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function onClear()
{
	submitClear() ;
}



</script>
</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:fieldListSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage()) %>" class="e8_btn_top"  onclick="fieldListSearch();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="zDialog_div_content" >

<FORM id="SearchForm" name="SearchForm" action="wfSubProcessFieldListTab.jsp" method="post">
<input type="hidden" name="pageId" id="pageId" _showCol=false value="10"/>
<input type="hidden" name="subworkflowid" value="<%=subworkflowid%>"/>

<%
//String sqlWhere = "";
String tableString = "";
tableString =   " <table datasource=\"weaver.workflow.workflow.WFSubDataAggregation.getSubwfFieldList\" sourceparams=\"subworkflowid:"+subworkflowid+"+fieldName:"+fieldName+"+detailGroup:"+detailGroup+"\" instanceid=\"WorkflowMonitorListTable\" pagesize=\"10\" tabletype=\"none\" >"+
                "       <sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
                "       <head>"+
                " 			<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(15456,user.getLanguage())+"\" column=\"fieldName\" orderkey=\"fieldName\" />"+
                " 			<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\" column=\"detailGroup\" orderkey=\"detailGroup\" />"+
                " 			<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"manifestation\" orderkey=\"manifestation\" />"+
                " 			<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"fieldId\"/>"+
				" 			<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"detailGroupid\"/>"+
				" 			<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"fieldHtmlType\"/>"+
				" 			<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"fieldType\"/>"+
				" 			<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"fieldNames\"/>"+
                //" 			<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldType\" orderkey=\"fieldType\" />"+
                "       </head>"+
                "		<operates>"+
                //otherpara=\"column:subworkflowid+column:typename\"
                //"		<operate href=\"javascript:dataSummary();\" otherpara=\"column:subworkflowid+column:workflowname\" text=\""+SystemEnv.getHtmlLabelName(125343,user.getLanguage())+"\"  target=\"_self\" index=\"0\"/>"+
				"		</operates>"+  
                " </table>";
%>

<wea:layout type="fourCol">
<%
//System.out.println("isBill = "+isBill);
String attributes = "{'customAttrs':'member=member'}";
%>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>">
		<wea:item attributes="<%=attributes%>"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="fieldName" value="<%=fieldName%>"/>  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17997,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle name="detailGroup" >
				<option value=-1 ></option>
				<option value=0 <%if("0".equals(detailGroup)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<%
					for(int f=0;f<detailSelect.size();f++){
				%>
						<option value=<%=detailSelect.get(f)%> <%if(detailSelect.get(f).equals(detailGroup)){%>selected<%}%>  ><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailSelect.get(f)%></option>
				<%	
					}
				%>
			</select>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE width="100%" cellspacing=0>
			    <tr>
			        <td valign="top">  
			            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
			        </td>
			    </tr>
			</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
</body>
</html>