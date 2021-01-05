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
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33523",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
	</script>	
</HEAD>
<%
String wfid = Util.null2String(request.getParameter("wfid"));
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="triggerTableBrowser.jsp" method=post>
<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
<input type="hidden" id="searchflag" name="searchflag" value="<%=searchflag %>">

<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(33523,user.getLanguage())%></wea:item>
		<wea:item><input name=tablename class="InputStyle" value='<%=tablename%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33522,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="modetype" name="modetype">
				<option value=-1 <%if(modetype==-1){%>selected<%}%>></option>
				<option value=0 <%if(modetype==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></option>
				<option value=1 <%if(modetype==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<option value=2 <%if(modetype==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></option>
				<option value=3 <%if(modetype==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></option>
				<option value=4 <%if(modetype==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></option>
				<option value=5 <%if(modetype==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2116,user.getLanguage())%></option>
				<option value=6 <%if(modetype==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2117,user.getLanguage())%></option>
				<option value=7 <%if(modetype==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18442,user.getLanguage())%></option>
				<!--<option value=9 <%if(modetype==9){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20613,user.getLanguage())%></option>
				<option value=10 <%if(modetype==10){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></option>
				<option value=11 <%if(modetype==11){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16371,user.getLanguage())%></option>-->
			</select>		
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
			
			<% 
					String tableString=""+
					   "<table  datasource=\"weaver.workflow.workflow.WfDataSource.getWorkflowTable\" sourceparams=\"modetype:"+modetype+"+tablename:"+tablename+"+searchflag:"+searchflag+"\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_TRIGGERTABLEBROWSER,user.getUID())+"\" tabletype=\"none\">"+
					    " <checkboxpopedom  id=\"checkbox\" />"+
					   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>"+							 
							 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"id\"/>"+
							 "<col width=\"50%\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\""+SystemEnv.getHtmlLabelName(33523,user.getLanguage())+"\" column=\"tablelabelname\"/>"+
							 "<col width=\"50%\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"belongsTo\" text=\""+SystemEnv.getHtmlLabelName(33522,user.getLanguage())+"\"/>"+
							 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"other1\"/>"+
							 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"other2\"/>"+
							 "<col width=\"0%\" hide=\"true\"  transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"other3\"/>"+
					   "</head>"+
					   "</table>";
				%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
	
</wea:layout>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_TRIGGERTABLEBROWSER %>"/>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick='onClear();'></input>
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
		var returnjson = {id:$(this).find("td:eq(1)").text(),name:$(this).find("td:eq(2)").text(),other1:$(this).find("td:eq(4)").text(),other2:$(this).find("td:eq(5)").text(),other3:$(this).find("td:eq(6)").text()};
		if(dialog){
			if(dialog.callbackfun){
			    dialog.callbackfun(returnjson);
			    dialog.close();
			}else{
			    dialog.callback(returnjson);
		    }
		}else{
			window.parent.returnValue  = returnjson;
		    window.parent.close();
		}		
	});
};

function submitClear(){
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

function onClear(){
	btnclear_onclick() ;
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
