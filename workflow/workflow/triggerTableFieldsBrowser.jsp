<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<script type="text/javascript">
		//var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
	</script>
</HEAD>
<%

String searchtablename = Util.null2String(request.getParameter("searchtablename"));
String searchfieldname = Util.null2String(request.getParameter("searchfieldname"));
String datasourceid = request.getParameter("datasourceid");
String tablenames = Util.toHtmlForSplitPage(Util.null2String(request.getParameter("tablenames")));
ArrayList tablenamesArray = Util.TokenizerString(tablenames,",");
String tablenameOptions = "<option></option>";
RecordSet rs=new RecordSet();
RecordSet rs1=new RecordSet();
RecordSet rs3=new RecordSet();
RecordSetDataSource rsd=new RecordSetDataSource();
for(int i=0;i<tablenamesArray.size();i++){
	String tempS = (String)tablenamesArray.get(i);
	String formid = "";
	String tablename = "";
	String[] tempsarry = tempS.split("~");
	formid = tempsarry[0] ;//tempS.substring(0,tempS.indexOf("~"));
	tablename = tempsarry[1] ; //tempS.substring(tempS.indexOf("~")+1,tempS.length());
	String diyname = "";
	String formidspan = "";
	if(tempsarry.length==4){
		diyname = tempsarry[2] ;
		formidspan = tempsarry[3] ;
	}
	if(datasourceid!=null&&!datasourceid.equals("")){//外部数据源表
		String selected = "";
        //String tempSql = "select * from "+tablename;
		if(tablename.equals(searchtablename)) selected = " selected ";
		//rs3.executeSql(tempSql);
		tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablename+"</option>";
	}else{
	if(!"".equals(formid)&&!"0".equals(formid)){//旧表单
		String selected = "";
		String tablelable = "";
		int groupId = 0;
		if(tablename.equals("workflow_formdetail")){
			groupId = Util.getIntValue(formid.substring(formid.indexOf("_")+1,formid.length()),0)+1;
			formid = formid.substring(0,formid.indexOf("_"));
		}
		if(formid.equals(searchtablename)) selected = " selected ";
		rs3.executeSql("select formname from workflow_formbase where id="+formid);
		if(rs3.next()) tablelable = rs3.getString("formname");
		if(tablename.equals("workflow_formdetail")) tablenameOptions += "<option value="+formid+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+groupId+")"+"</option>";
		else tablenameOptions += "<option value="+formid+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";
	}else if(!tablename.equals("")){//新表单，单据，其它模块
		String selected = "";
		if(tablename.equals(searchtablename)) selected = " selected ";
		String tablelable = "";
		rs3.executeSql("select namelabel from workflow_bill where tablename='"+tablename+"'");//新表单,单据主表
		if(rs3.next()){
			tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
			tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";
		}
		
		rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+tablename+"'");//单据明细表1
		if(rs3.next()){
			tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
			rs.executeSql("select tablename from Workflow_billdetailtable where tablename='"+tablename+"'");
			if(!rs.next()){
				tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
				tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)"+"</option>";
			}
		}
		
		rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+tablename+"'");//新表单,单据明细表2
		if(rs3.next()){
			String billid = rs3.getString("billid");
			rs3.executeSql("select namelabel from workflow_bill where id="+billid);
			if(rs3.next()) tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
			
			rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+billid+"  ORDER BY orderid");
			int detailIndex = 0;
			while(rs3.next()){
				detailIndex++;
				String detailtablename = Util.null2String(rs3.getString("tablename"));
				if(detailtablename.equals(tablename)){
					tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")"+"</option>";
				}
			}
		}
		
		String tempSql = "";
		if(user.getLanguage()==7) tempSql = "select tabledesc from Sys_tabledict where tablename='"+tablename+"'";
		if(user.getLanguage()==8) tempSql = "select tabledescen from Sys_tabledict where tablename='"+tablename+"'";
		rs3.executeSql(tempSql);//其它模块
		if(rs3.next()){
			tablelable = rs3.getString(1);
			tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";
		}
	}
	}
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="triggerTableFieldsBrowser.jsp" method=post>
<input type="hidden" id="tablenames" name="tablenames" value="<%=tablenames%>">
<input type="hidden" id="datasourceid" name="datasourceid" value="<%=datasourceid%>">

<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input name=searchfieldname class="InputStyle" value='<%=searchfieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33523,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="searchtablename" name="searchtablename" style="width:120px;">
				<%=tablenameOptions%>
			</select>		
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item>&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			
			
			<% 
				String tableString=""+
				   "<table pageId=\""+PageIdConst.WF_WORKFLOW_TRIGGERTABLEFIELDSBROWSER+"\" datasource=\"weaver.workflow.workflow.WfDataSource.getWorkflowTableField\" sourceparams=\"searchtablename:"+searchtablename+"+searchfieldname:"+searchfieldname+"+datasourceid:"+datasourceid+"+tablenames:"+tablenames+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_TRIGGERTABLEFIELDSBROWSER,user.getUID())+"\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
						 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"fieldname\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldlabel\"/>"+
						 "<col width=\"50%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"tablelabel\" text=\""+SystemEnv.getHtmlLabelName(33523,user.getLanguage())+"\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"tablename\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"tabfix\"/>"+
				   "</head>"+
				   "</table>";
			%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_WORKFLOW_TRIGGERTABLEFIELDSBROWSER %>"/>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
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
<script type="text/javascript">
function afterDoWhenLoaded(){
	hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var tabletype = $(this).find("td:eq(5)").text() ;
		tabletype = unescape(tabletype)
		var returnjson = {id:tabletype+$(this).find("td:eq(1)").text(),name:tabletype+$(this).find("td:eq(2)").text(),other1:$(this).find("td:eq(4)").text()};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}		
	});
}

function submitClear(){
	var returnjson = {id:"",name:"",other1:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function onClear(){
	submitClear() ;
}

function onSubmit(){
	SearchForm.submit();
}

function onClose(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close() ;
	}
}
</script>
</BODY>
</HTML>
