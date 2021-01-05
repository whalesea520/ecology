<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
try{
	parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19456",user.getLanguage())%>");
}catch(e){
	if(window.console)console.log(e+"-->DocDocSecCategoryTmplBrowser.jsp");
}
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}
function btnOnSearch(){
	SearchForm.submit();
}
function onClose(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close();
	}
}
</script>
</HEAD>
<%
String sname = Util.null2String(request.getParameter("name"));

%>
<BODY>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="DocSecCategoryTmplBrowser.jsp" method=post>


<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=Inputstyle name=name value='<%=sname%>'></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<%
	String tableString = "";
	String sqlWhere = "";
	if(!"".equals(sname)){
	    sqlWhere += " name like '%"+sname+"%'";
	}
	String pageIdStr = "10";
	tableString ="<table instanceid=\"\" name=\"fieldList\" tabletype=\"none\"  pagesize=\"10\" >"+
    "<sql backfields=\"id,name,fromdir\" sqlform=\"DocSecCategoryTemplate\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />";
    tableString += " <head>";
    tableString+="<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\"/>";
   	tableString+="<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"  />";
   	tableString+="<col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(19996,user.getLanguage())+"\" column=\"fromdir\" transmethod=\"weaver.general.KnowledgeTransMethod.getMSSPath\"  />";
   	tableString+="</head></table>";
	%>
	<wea:SplitPageTag tableString='<%=tableString%>' mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
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
</BODY></HTML>



<script language="javascript">
function afterDoWhenLoaded(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#_xTable table.ListStyle").find("tr[class!='Spacing']").bind("click",function(){
		if(dialog){
			try{
				dialog.callback({id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text()});
			}catch(e){}
			try{
				dialog.close({id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text()});
			}catch(e){}
		}else{
			window.parent.returnValue = {id:$(this).find("td:first").next().text(),name:$(this).find("td:first").next().next().text()};
			window.parent.close();
		}
	});
}


function submitClear()
{	
	if(dialog){
		try{
			dialog.callback({id:"",name:""});
		}catch(e){}
		try{
			dialog.close({id:"",name:""});
		}catch(e){
		
		}
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close();
	}
}
</script>
