<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css"></HEAD>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.parent.getParentWindow(parent.parent);
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(e){}
</script>
<%
String modeId = Util.null2String(request.getParameter("modeId"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")),0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean hasSqlwhere = false;
if("".equals(sqlwhere) && !"".equals(modeId)){
	hasSqlwhere = false;
}else{
	hasSqlwhere = true;
}
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(hasSqlwhere == false){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;//搜索
RCMenuHeight += RCMenuHeightStep ;
}

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
		<td class="rightSearchSpan" style="text-align:right;"><!-- 搜索 -->
			<input type="button" onclick="onSubmit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span><!-- 确定 -->
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldBrowserIframe.jsp" method=post>
<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'><!-- 查询条件 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item><!-- 字段名称 -->
		<wea:item><input name=fieldname class="InputStyle" value='<%=fieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26734,user.getLanguage())%></wea:item><!-- 所属表类型 -->
		<wea:item>
			<select id="tabletype" name="tabletype">
				<option value=0 <%if(tabletype==0){%>selected<%}%>></option>
				<option value=1 <%if(tabletype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option><!-- 主表 -->
				<option value=2 <%if(tabletype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option><!-- 明细表 -->
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
				   "<table  datasource=\"weaver.formmode.browser.FormModeBrowserDataSource.getFormModeTableTriggerField\" sourceparams=\"modeId:"+modeId+"+fieldname:"+fieldname+"+tabletype:"+tabletype+"+sqlwhere:"+sqlwhere+"\" instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
						 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"fieldid\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\"/>"+//字段名称
						 "<col width=\"50%\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" column=\"tabletype\" text=\""+SystemEnv.getHtmlLabelName(26734,user.getLanguage())+"\"/>"+//所属表类型
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"isdetail\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"tempoption\"/>"+
				   "</head>"+
				   "</table>";
			%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
</BODY>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
</script>
<script language="javascript">
function afterDoWhenLoaded(){
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
}

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


<script language="javascript">

</script>
