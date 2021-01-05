<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetDataSource" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs0" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
<script type="text/javascript">
	var parentWin = parent.parent.parent.getParentWindow(parent.parent);
	var dialog = parent.parent.parent.getDialog(parent.parent);
</script>	
</HEAD>
<%

String searchtablename = Util.null2String(request.getParameter("searchtablename"));
String searchfieldname = Util.null2String(request.getParameter("searchfieldname"));
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
if("Nan".equalsIgnoreCase(datasourceid)){
	String queryString = request.getQueryString();
	if(queryString!=null){
	int index = queryString.indexOf("datasourceid=");
	datasourceid = queryString.substring(index+"datasourceid=".length());
	if(index!=-1){
		int nextIndex = datasourceid.indexOf("&");
		if(nextIndex!=-1){
			datasourceid = datasourceid.substring(0,nextIndex);
		}
	}
	}
}
String datasourceidTemp = datasourceid;
if(!"".equals(datasourceid)){
	datasourceid = xssUtil.put(datasourceid);
}
String tablenames = Util.null2String(request.getParameter("tablenames"));
ArrayList tablenamesArray = Util.TokenizerString(tablenames,",");
String tablenameOptions = "<option></option>";
RecordSet rs=new RecordSet();
RecordSet rs1=new RecordSet();
RecordSet rs3=new RecordSet();
RecordSetDataSource rsd=new RecordSetDataSource();
String tablenamesTemp = "";
for(int i=0;i<tablenamesArray.size();i++){
	String tempS = (String)tablenamesArray.get(i);
	String formid = "";
	String tablename = "";
	String[] tempsarry = tempS.split("~");
	formid = tempsarry[0] ;
	tablename = tempsarry[1] ;
	tablenamesTemp += ","+tempS;
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
		if(!formid.equals("")&&("workflow_form".equals(tablename) || "workflow_formdetail".equals(tablename))){//旧表单
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
			if(tablename.equals("workflow_formdetail")) tablenameOptions += "<option value="+formid+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+groupId+")"+"</option>";//明细表
			else tablenameOptions += "<option value="+formid+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";//主表
		}else if(!tablename.equals("")){//新表单，单据，其它模块
			String selected = "";
			if(tablename.equals(searchtablename)) selected = " selected ";
			String tablelable = "";
			rs3.executeSql("select namelabel from workflow_bill where tablename='"+tablename+"'");//新表单,单据主表
			if(rs3.next()){
				tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
				tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";//主表
			}
			
			rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+tablename+"'");//单据明细表1
			if(rs3.next()){
				tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
				rs.executeSql("select tablename from Workflow_billdetailtable where tablename='"+tablename+"'");
				if(!rs.next()){
					tablelable = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
					tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)"+"</option>";//明细表
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
						tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")"+"</option>";//明细表
					}
				}
			}
			
			String tempSql = "";
			if(user.getLanguage()==7) tempSql = "select tabledesc from Sys_tabledict where tablename='"+tablename+"'";
			if(user.getLanguage()==8) tempSql = "select tabledescen from Sys_tabledict where tablename='"+tablename+"'";
			rs3.executeSql(tempSql);//其它模块
			if(rs3.next()){
				tablelable = rs3.getString(1);
				tablenameOptions += "<option value='"+tablename+"'"+selected+">"+tablelable+"("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")"+"</option>";//主表
			}
		}
	}
}
if(!"".equals(tablenamesTemp)){
	tablenamesTemp = tablenamesTemp.substring(1);
	tablenames = tablenamesTemp;
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;//取消
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;//清除
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="onSubmit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span><!-- 确定 -->
		</td>
	</tr>
</table>
<input type="hidden" id="datasourceidTemp" name="datasourceidTemp" value="<%=datasourceidTemp%>">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="triggerTableFieldsBrowserIframe.jsp?datasourceid=<%=datasourceidTemp%>" method=post>
<input type="hidden" id="tablenames" name="tablenames" value="<%=tablenames%>">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'><!-- 查询条件 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item><!-- 字段名称 -->
		<wea:item><input name=searchfieldname class="InputStyle" value='<%=searchfieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15186,user.getLanguage())%></wea:item><!-- 数据表名 -->
		<wea:item>
			<select id="searchtablename" name="searchtablename">
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
				   "<table datasource=\"weaver.formmode.browser.FormModeBrowserDataSource.getFormModeTableField\" sourceparams=\"searchtablename:"+searchtablename+"+searchfieldname:"+searchfieldname+"+datasourceid:"+datasourceid+"+tablenames:"+tablenames+"\" 		instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\"none\">"+
				   " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+	
				   		 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"@@\" column=\"fieldname\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldlabel\"/>"+//字段名称
						 "<col width=\"50%\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" column=\"tablelabel\" text=\""+SystemEnv.getHtmlLabelName(33523,user.getLanguage())+"\"/>"+//数据库表
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"tablename\" name=\"tablename\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"tabfix\" name=\"tabfix\"/>"+
				   "</head>"+
				   "</table>";
			%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<script type="text/javascript">
function afterDoWhenLoaded(){
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var tablename = $(this).find("td:eq(3)").text()+"." ;
		var returnjson = {id:$(this).find("td:eq(1)").text(),name:tablename+$(this).find("td:eq(2)").text(),other1:$(this).find("td:eq(4)").text()};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	})
}


function submitClear()
{
	var returnjson = {id:"",name:"",other1:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}
function onClear()
{
	submitClear();
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
</BODY>
</HTML>
