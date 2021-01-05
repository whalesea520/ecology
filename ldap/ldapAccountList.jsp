
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<head>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("81811",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->ldapAccountList.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
		parentWin = parent.parent.getParentWindow(parent);
	}catch(e){
	}
</script>
<script type="text/javascript">
$(document).ready(function(){
	jQuery("#BrowseTable").bind("click",browserTable_onclick);
})

function browserTable_onclick(e) {

    var e=e||event;
    var target=e.srcElement||e.target;

   if(target.nodeName =="TD"||target.nodeName =="A"){
   		var returnjson  = {id:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
   		
		if(dialog){
		    dialog.callback(returnjson);
		}else{  
		    window.parent.returnValue  = returnjson;
		    window.parent.close();
		}	 
	}
 }

 function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
		window.parent.close() ;
	}	
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function afterDoWhenLoaded(){
	$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
		var tr = jQuery(this);
		tr.bind("click",function(){
			var id = tr.children("td:first").next().text();
			var name = tr.children("td:first").next().next().text();
			var desc = "";
			try
			{
				desc = tr.children("td:first").next().next().next().text();
			}
			catch(e)
			{
			}
			
		
			var returnjson = {'id':id,'name':name};
			
			if(dialog){
				try{
			    	dialog.callback(returnjson);
			    }catch(e){}

				try{
				    dialog.close(returnjson);
				}catch(e){}
			}else{
		    	window.parent.returnValue = returnjson;
		    	window.parent.close();
		 	}
		});
	});
}
</script>
</head>
<body>
<%
String tableString=""+
					   "<table instanceid=\"BrowseTable\" class=\"ListStyle\" datasource=\"weaver.ldap.AccountList.getAccoutList\" pagesize=\"20\" tabletype=\"none\">"+
					   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>";
	tableString = tableString + "<col width='47%' text=\""+SystemEnv.getHtmlLabelName(413 ,user.getLanguage())+"\" column='displayName'/>";
	tableString = tableString + "<col width='47%' text=\""+SystemEnv.getHtmlLabelName(20970 ,user.getLanguage())+"\" column='account'/>";
	tableString = tableString +"</head></table>";

 %>
<form>
    	<TABLE width="100%">
		    <tr>
		        <td valign="top">  
		           	<wea:SplitPageTag  tableString='<%=tableString%>' mode="run" />
		        </td>
		    </tr>
		</TABLE>
</form>
</body>
</html>
