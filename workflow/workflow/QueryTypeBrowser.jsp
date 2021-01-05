<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
    <link REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
	<script type="text/javascript">
		var parentWin = null;
		var dialog = null;
		try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
		}catch(e){}
	</script>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" method=post>
<TABLE ID=BrowseTable class="ListStyle"  cellspacing="0" style="width:100%;" 
	>
<TR class=header>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr>
<%
int i=0;
RecordSet.executeSql("select * from workflow_customQuerytype order by showorder,typename");
while(RecordSet.next()){
%>
<TR class="DataLight">
	<TD><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD><%=RecordSet.getString("typename")%></TD>
	<TD><%=RecordSet.getString("typenamemark")%></TD>

</TR>
<%}%>
</TABLE>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
			parent.setTabObjName('<%=SystemEnv.getHtmlLabelName(23799,user.getLanguage())%>');
		});
	</script>
</div>
</BODY></HTML>
<script type="text/javascript">

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
   	 	var returnjson = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}
	}
}
function btnclear_onclick(e){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}	
}

function submitClear()
{
	btnclear_onclick();
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
