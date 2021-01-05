<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF="/css/Weaver_wev8.css">
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(83001,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
	</script>	
</HEAD>
<%
String formid = Util.null2String(request.getParameter("formid"));
int tabletype = 0;
String actionname = Util.null2String(request.getParameter("actionname"));
int actiontype = Util.getIntValue(Util.null2String(request.getParameter("actiontype")),-1);
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/workflow/SingleActionBrowser.jsp" method=post>
<input type="hidden" id="formid" name="formid" value="<%=formid%>">

<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(83001,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%></wea:item>
		<wea:item><input name=actionname class="InputStyle" value='<%=actionname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(83001,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="actiontype" name="actiontype">
				<option value=-1 <%if(actiontype==-1){%>selected<%}%>></option>
				<option value=1 <%if(actiontype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82986,user.getLanguage())%></option>
				<option value=2 <%if(actiontype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82987,user.getLanguage())%></option>
				<option value=3 <%if(actiontype==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(82988,user.getLanguage())%></option>
			</select>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83001,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			<% 
				String tableString=""+
								"<table  datasource=\"weaver.workflow.action.ActionDataSource.getActionTable\" sourceparams=\"actiontype:"+actiontype+"+actionname:"+actionname+"+formid:"+formid+"\" instanceid=\"Table\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_SINGLEACTIONBROWSER,user.getUID())+"\" tabletype=\"none\">"+
								    " <checkboxpopedom  id=\"none\" />"+
								   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
								   "<head>"+
										 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"id\"/>"+
										 "<col width=\"50%\" hide=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(83001,user.getLanguage())+SystemEnv.getHtmlLabelName(82755,user.getLanguage())+"\" column=\"actionname\"/>"+
										 "<col width=\"50%\" hide=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(83001,user.getLanguage())+SystemEnv.getHtmlLabelName(33234,user.getLanguage())+"\" column=\"fromtypename\"/>"+
										 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"fromtype\"/>"+
									"</head>"+
								   "</table>";
			%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
				<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_SINGLEACTIONBROWSER %>"/>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick='submitClear();'></input>
	        	<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick='onClose();'></input>
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
</HTML>


<script language="javascript">

function afterDoWhenLoaded(){
	//hideTH();
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
		//alert('sdfsdfdf');
		//alert($(this).find("td:first").text())
		datatype = $(this).find("td:first").next().next().next().next().text();
		dataid = $(this).find("td:first").next().text();
		linkname = $(this).find("td:first").next().next().text();
		if(datatype == '1'){
			linkname = "<a href='/workflow/dmlaction/FormActionSettingEdit.jsp?fromintegration=1&actionid="+dataid+"' target='_blank'>"+linkname+"</a>";
		}else if(datatype == '2'){
			linkname = "<a href='/workflow/action/WsFormActionEditSet.jsp?fromintegration=1&operate=editws&actionid="+dataid+"' target='_blank'>"+linkname+"</a>";
		}else if(datatype == '3'){
		    linkname = "<a href='/servicesetting/actionsettingnew.jsp?fromintegration=1&operate=editws&pointid="+dataid+"' target='_blank'>"+linkname+"</a>";
		}
		var returnjson = {id:dataid,name:linkname,type:datatype};
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
	var returnjson ={id:"",name:"",type:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function btnclear_onclick(){
	var returnjson = {id:"",name:"",type:""};
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
