<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<script type="text/javascript">
		$("#objName",window.parent.document).text("<%=SystemEnv.getHtmlLabelNames("18015,261",user.getLanguage()) %>");
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
int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int FieldType = Util.getIntValue(Util.null2String(request.getParameter("FieldType")),-1);
int detailindex = Util.getIntValue(Util.null2String(request.getParameter("detailindex")),-1);
int browsertype = Util.getIntValue(Util.null2String(request.getParameter("bt")),-1);
if(browsertype==0){//取值浏览按钮
	tabletype = detailindex ;
}else{//赋值浏览按钮
	if(FieldType>0){
		tabletype = detailindex ;
	}
}
boolean hasSqlwhere = false;
String isbill = "";
int isdetail = 0;
if("".equals(sqlwhere) && !"".equals(wfid)){
	hasSqlwhere = false;
}else{
	hasSqlwhere = true;
	isbill = Util.null2o(request.getParameter("isbill"));
	isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
}
String formid = WorkflowComInfo.getFormId(wfid);
rs.executeSql("select formid,isbill from workflow_base where id="+wfid );
if(rs.next()){
	formid = rs.getString("formid");
	isbill = rs.getString("isbill");
}

ArrayList  detailgroupids = new ArrayList();
if(isbill.equals("0")){
	rs.executeSql("select distinct groupid from workflow_formfield where isdetail=1 and formid="+formid+" order by groupid ");
}else{
	rs.executeSql("select orderid from workflow_billdetailtable where billid="+formid+" order by orderid ");
}
while(rs.next()){
	if(isbill.equals("0")){
		detailgroupids.add((rs.getInt(1)+1)+"");
	}else{
		detailgroupids.add(rs.getString(1));
	}
}
int detailcount = rs.getCounts() ;
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasSqlwhere == false){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
			<input type="button" onclick="onSubmit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldBrowser4Trigger.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>" />
<input type="hidden" id="FieldType" name="FieldType" value="<%=FieldType %>" />
<input type="hidden" id="detailindex" name="detailindex" value="<%=detailindex %>" />
<input type="hidden" id="bt" name="bt" value="<%=browsertype %>" />
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<%if (hasSqlwhere == false) {%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input name=fieldname class="InputStyle" value='<%=fieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26734,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="tabletype" name="tabletype">
				<option value=-1 <%if(tabletype==-1){%>selected<%}%>></option>
				<option value=0 <%if(tabletype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<%
					for(int i = 0 ; i <detailgroupids.size() ;i++){
						int groupid = Util.getIntValue(detailgroupids.get(i).toString());
				%>
				<option value=<%=groupid %> <%if(tabletype==groupid){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1 %></option>
				<%} %>
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
				   "<table pageId=\""+PageIdConst.WF_WORKFLOW_FIELDBROWSER+"\" datasource=\"weaver.workflow.workflow.WfDataSource.getWorkflowTableTriggerField\" sourceparams=\"htmltype:"+htmltype+"+type:"+type+"+isbill:"+isbill+"+isdetail:"+isdetail+"+wfid:"+wfid+"+fieldname:"+fieldname+"+tabletype:"+tabletype+"+sqlwhere:"+Util.toHtmlForSplitPage(sqlwhere)+"+isfrom:1\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_FIELDBROWSER,user.getUID())+"\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
						 "<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"@@\" column=\"fieldid\"/>"+
						 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\"/>"+
						 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"tabletype\" text=\""+SystemEnv.getHtmlLabelName(17997,user.getLanguage())+"\"/>"+
						 "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"htmltype\"  otherpara=\"column:type"+"+"+user.getLanguage()+"+"+"column:fieldid"+"\" transmethod=\"weaver.workflow.design.WFDesignTransMethod.getFieldShowType\"  />"+
						 "<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"detailindex\"/>"+
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
			var tabletype = $($(this).children()[3]).text() ;
			var name = $($(this).children()[2]).text() ;
			if(tabletype!=''){
				name = tabletype+"."+name
			}
		var returnjson = {
			id:$($(this).children()[1]).text(),
			name: name ,
			fieldtype:$($(this).children()[4]).text(),
			options:$($(this).children()[6]).text(),
			isdetail:$($(this).children()[5]).text(),
			tabletype:tabletype,
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
	var returnjson = {id:"",name:"",fieldtype:"",options:"",isdetail:""};
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
