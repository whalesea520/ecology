<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
</HEAD>
<%
String wfid = Util.null2String(request.getParameter("wfid"));
String htmltype = Util.null2String(request.getParameter("htmltype"));
String type = Util.null2String(request.getParameter("type"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")),0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean hasSqlwhere = false;
String isbill = "-1";
int isdetail = 0;
if("".equals(sqlwhere) && !"".equals(wfid)){
	hasSqlwhere = false;
}else{
	hasSqlwhere = true;
	isbill = Util.null2o(request.getParameter("isbill"));
	isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
}


String detailtable = Util.null2String(request.getParameter("detailtable"));
String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
String billid = Util.null2String(request.getParameter("billid"));
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
isbill = Util.null2String(request.getParameter("isbill"));
sqlwhere = " where fieldhtmltype="+fieldhtmltype+" and billid="+billid+" ";
if(!detailtable.equals("")){
    if(detailtable.startsWith("'")){
    	sqlwhere+=" and detailtable="+detailtable+" ";
    }else{
    	sqlwhere+=" and detailtable='"+detailtable+"' ";
    }
	
}
if(fieldid>0){
    sqlwhere+=" and id!="+fieldid+" ";
}


//System.out.println(sqlwhere);
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasSqlwhere == false){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldBrowser.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<%if (hasSqlwhere == false) {%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input name=fieldname class="InputStyle" value='<%=fieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26734,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="tabletype" name="tabletype">
				<option value=0 <%if(tabletype==0){%>selected<%}%>></option>
				<option value=1 <%if(tabletype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<option value=2 <%if(tabletype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>
			</select>		
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item>&nbsp;</wea:item>
	</wea:group>
	<%}%>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			
			<% 
				String tableString=""+
				   "<table pageId=\""+PageIdConst.WF_WORKFLOW_FIELDBROWSER+"\" datasource=\"weaver.workflow.workflow.WfDataSource.getWorkflowTableTriggerField\" sourceparams=\"htmltype:"+htmltype+"+type:"+type+"+isbill:"+isbill+"+isdetail:"+isdetail+"+wfid:"+wfid+"+fieldname:"+fieldname+"+tabletype:"+tabletype+"+sqlwhere:"+Util.toHtmlForSplitPage(sqlwhere)+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_FIELDBROWSER,user.getUID())+"\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
						 "<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"@@\" column=\"fieldid\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"tabletype\" text=\""+SystemEnv.getHtmlLabelName(26734,user.getLanguage())+"\"/>"+
						 "<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"isdetail\"/>"+
						 "<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"tempoption\"/>"+
				   "</head>"+
				   "</table>";
			%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.WF_WORKFLOW_FIELDBROWSER %>"/>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>

<script language="javascript">
function afterDoWhenLoaded(){
	hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var returnjson = {
			id:$($(this).children()[1]).text(),
			name:$($(this).children()[2]).text(),
			fieldtype:$($(this).children()[4]).text(),
			options:$($(this).children()[5]).text()
		};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	});

};


function submitClear()
{
	var returnjson = {id:"",name:"",fieldtype:"",options:""};
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
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

</script>
</HTML>
