<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19369",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
	
	function btnOnSearch(){
		document.SearchForm.submit();
	}
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>

</HEAD>

<BODY scroll="auto">
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String doctype = request.getParameter("doctype");
if(doctype!=null&&"".equals(doctype)) doctype = "0";
else if(doctype!=null&&!"".equals(doctype)){
	if(doctype.equals(".htm")) doctype = "0";
	else if(doctype.equals(".doc")) doctype = "2";
	else if(doctype.equals(".xls")) doctype = "3";
	else if(doctype.equals(".wps")) doctype = "4";
}
%>
<FORM NAME=SearchForm STYLE="margin-bottom:0;margin-right:0">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=C onclick="onClose()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=L id=btnclear><U>L</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>


<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout type="table"  attributes="{'formTableId':'BrowseTable','cols':'2'}" needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<%
					int i=0;
					while(DocMouldComInfo.next()){
						if(Util.null2String(DocMouldComInfo.getDocMouldid()).equals("1"))continue;
						String currentDocType = DocMouldComInfo.getDocMouldType();
						//System.out.println(currentDocType+"::"+DocMouldComInfo.getDocMouldname());
						if(currentDocType==null||"".equals(currentDocType)||Util.getIntValue(currentDocType,0)<0) currentDocType = "0";
						
						if(doctype!=null&&!currentDocType.equals(doctype)) continue;
						
					%>
						<wea:item><A HREF=#><%=DocMouldComInfo.getDocMouldid()%></A></wea:item>
						<wea:item><%=DocMouldComInfo.getDocMouldname()%></wea:item>
					<%}%>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>

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

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr").bind("click",function(){
			
			if(dialog){
				try{
				dialog.callback({id:$(this).find("td:first").children().text(),name:$(this).find("td:first").next().text()});
				}catch(e){}
				try{
				dialog.close({id:$(this).find("td:first").children().text(),name:$(this).find("td:first").next().text()});
				}catch(e){}
			}else{
				window.parent.returnValue = {id:$(this).find("td:first").children().text(),name:$(this).find("td:first").next().text()};
				window.parent.close()
			}
		})
	jQuery("#BrowseTable").find("tr").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})
function submitClear()
{
	if(dialog){
		try{
		dialog.callback({id:"",name:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:""});
		}catch(e){}
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close()
	}
}
</script>
</BODY></HTML>
