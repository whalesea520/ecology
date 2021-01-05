<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
<script type="text/javascript">
		var parentWin = parent.parent.parent.getParentWindow(parent.parent);
		var dialog = parent.parent.parent.getDialog(parent.parent);
</script>	
</HEAD>
<%
String modeId = Util.null2String(request.getParameter("modeId"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = 0;
String tablename = Util.null2String(request.getParameter("tablename"));
int modetype = Util.getIntValue(Util.null2String(request.getParameter("modetype")),-1);
int searchflag = Util.getIntValue(Util.null2String(request.getParameter("searchflag")),-1);
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
<FORM NAME=SearchForm action="triggerTableBrowserIframe.jsp" method=get>
<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
<input type="hidden" id="searchflag" name="searchflag" value="<%=searchflag%>">

<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'><!-- 查询条件 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(33523,user.getLanguage())%></wea:item><!-- 数据库表 -->
		<wea:item><input name=tablename class="InputStyle" value='<%=tablename%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33522,user.getLanguage())%></wea:item><!-- 所属模块 -->
		<wea:item>
			<select id="modetype" name="modetype">
				<option value=-1 <%if(modetype==-1){%>selected<%}%>></option>
				<option value=0 <%if(modetype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option><!-- 工作流程 -->
				<option value=1 <%if(modetype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option><!-- 人力资源 -->
				<option value=2 <%if(modetype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></option><!-- 知识管理 -->
				<option value=3 <%if(modetype==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></option><!-- 客户管理 -->
				<option value=4 <%if(modetype==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></option><!-- 项目管理 -->
				<option value=5 <%if(modetype==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%></option><!-- 资产管理 -->
				<option value=6 <%if(modetype==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%></option><!-- 财务管理 -->
				<option value=7 <%if(modetype==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18442,user.getLanguage())%></option><!--  会议管理  -->
				<!--<option value=9 <%if(modetype==9){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20613,user.getLanguage())%></option>
				<option value=10 <%if(modetype==10){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></option>
				<option value=11 <%if(modetype==11){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16371,user.getLanguage())%></option>-->
			</select>		
		</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item>&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			<% 
				String tableString=""+
				   "<table  datasource=\"weaver.formmode.browser.FormModeBrowserDataSource.getFormModeTable\" sourceparams=\"modetype:"+modetype+"+tablename:"+tablename+"+searchflag:"+searchflag+"\" instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
						 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"id\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(33523,user.getLanguage())+"\" column=\"tablelabelname\"/>"+//数据库表
						 "<col width=\"50%\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" column=\"belongsTo\" text=\""+SystemEnv.getHtmlLabelName(33522,user.getLanguage())+"\"/>"+//所属模块
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"other1\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"other2\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"other3\"/>"+
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


</BODY>
</HTML>


<SCRIPT LANGUAGE=VBS>

</SCRIPT>
<script language="javascript">

function afterDoWhenLoaded(){
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		var returnjson = {id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text(),other1:$(this).find("td:first").next().next().next().next().text(),other2:$(this).find("td:first").next().next().next().next().next().text(),other3:$(this).find("td:first").next().next().next().next().next().next().text()};
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
	var returnjson ={id:"",name:"",type1:"",options:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function btnclear_onclick(){
	var returnjson = {id:"",name:"",other1:"",other2:"",other3:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}


function onClear()
{
	btnclear_onclick() ;
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
