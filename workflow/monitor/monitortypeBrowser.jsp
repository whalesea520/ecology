<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id=Util.null2String(request.getParameter("selectedids"));
	RecordSet.executeSql("select * from Workflow_MonitorType order by typeorder");
%>
<HTML><HEAD>
	<link REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
		var parentWin = parent.parent.getParentWindow(parent);
		var dialog = parent.parent.getDialog(parent);
		
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%>");
	</script>
</HEAD>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:returnValue(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:isConfirm(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout type="2col">
	<wea:group context='' attributes="{\"groupDisplay\":\"none\"}">
		<wea:item attributes="{'isTableList':'true'}">
			<Table width='100%' class='ListStyle'>
				<colgroup>
					<col width='10%'>
					<col width='90%'>
				</colgroup>
			<%
				boolean trClass = false;
				while(RecordSet.next())
				{
					String ids = Util.null2String(RecordSet.getString("id"));
					String typename = Util.null2String(RecordSet.getString("typename"));
			%>
				<tr class="DataLight">
					<td class=field><input type="radio" name="typeid" value="<%=ids%>" <%if(id.equals(ids)){out.print("checked");} %> ></td>
					<td class=field><%=typename%><input type="hidden" name="typename_<%=ids%>" value="<%=typename%>"></td>
				</tr>
			<%
				}
			%>
			</table>		
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="returnValue();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="isConfirm();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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

<script type="text/javascript">
function returnValue(){
	var id="";
	var name="";
	
	for(var i=0;i<document.getElementsByName("typeid").length;i++){
			if(document.getElementsByName("typeid")[i].checked){
				id=document.getElementsByName("typeid")[i].value;	
			}		
	}
	if(id!=""){
		name=document.all("typename_"+id).value;
	}
	
	var returnjson = {id:""+id,name:""+name};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
		return returnjson;
	}	
}

function isConfirm(){

	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function onClose(){
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}
</script>
</html>
