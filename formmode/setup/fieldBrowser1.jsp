<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<script type="text/javascript">
		$("#objName",window.parent.document).text("<%=SystemEnv.getHtmlLabelNames("21805,261",user.getLanguage()) %>");
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
</HEAD>
<%
String modeId = Util.null2String(request.getParameter("modeId"));
String htmltype = Util.null2String(request.getParameter("htmltype"));
String type = Util.null2String(request.getParameter("type"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
int tabletype = Util.getIntValue(Util.null2String(request.getParameter("tabletype")),-1);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean hasSqlwhere = false;
int isdetail = 0;
if("".equals(sqlwhere) && !"".equals(modeId)){
	hasSqlwhere = false;
}else{
	hasSqlwhere = true;
	isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
}
String formid = "";
rs.executeSql("select formid from modeinfo where id="+modeId);
if(rs.next()){
	formid = rs.getString("formid");
}
String sql = "select orderid from workflow_billdetailtable where billid="+formid ;
rs.executeSql(sql);
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="fieldBrowser1.jsp" method=post>
<input type="hidden" id="modeId" name="modeId" value="<%=modeId %>">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<%if (!hasSqlwhere) {%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item><input name=fieldname class="InputStyle" value='<%=fieldname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26734,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="tabletype" name="tabletype">
				<option value=-1 <%if(tabletype==-1){%>selected<%}%>></option>
				<option value=0 <%if(tabletype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<%
					for(int i = 1 ; i <detailcount+1 ;i++){
				%>
				<option value=<%=i %> <%if(tabletype==i){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i %></option>
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
				   "<table  datasource=\"weaver.formmode.browser.FormModeBrowserDataSource.getFormModeTableTriggerField\" sourceparams=\"modeId:"+modeId+"+fieldname:"+fieldname+"+tabletype:"+tabletype+"+sqlwhere:"+sqlwhere+"+isfrom:1\" instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\"none\">"+
				    " <checkboxpopedom  id=\"checkbox\" />"+
				   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
				   "<head>"+							 
						 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"fieldid\"/>"+
						 "<col width=\"50%\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\"/>"+//字段名称
						 "<col width=\"50%\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" column=\"tabletype\" text=\""+SystemEnv.getHtmlLabelName(26734,user.getLanguage())+"\"/>"+//所属表类型
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"isdetail\"/>"+
						 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"tempoption\"/>"+
						 "<col width=\"0%\"  hide=\"true\" transmethod=\"weaver.formmode.search.FormBrowserTransMethod.forHtml\" text=\"\" column=\"detailindex\"/>"+
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
			options:$($(this).children()[5]).text(),
			tabletype:$($(this).children()[6]).text(),
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
	var returnjson = {id:"",name:"",fieldtype:"",options:"",tabletype:""};
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
