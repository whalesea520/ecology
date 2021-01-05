<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String desc = Util.null2String(request.getParameter("desc"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!desc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where desc_n like '%";
		sqlwhere += Util.fromScreen2(desc,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and desc_n like '%";
		sqlwhere += Util.fromScreen2(desc,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>

<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15534",user.getLanguage())%>");
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


<BODY scroll="auto">
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" onclick="btnOnSearch()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=C onclick="onClose()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<form name="SearchForm">
<wea:layout type="4col">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
	<wea:item><input class=inputstyle name=name value='<%=name%>'></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
	<wea:item><input class=inputstyle name=desc value='<%=desc%>'></wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
  	<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
  </wea:group>
  <wea:group context="" attributes="{'groupDisplay':'none'}">
 	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
	   <wea:layout type="table"  attributes="{'formTableId':'BrowseTable','cols':'3'}" needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
				<%
				int i=0;

				//modified by lupeng 2004.2.3
				//the orginal source code is:sqlwhere = "select * from DocInstancyLevel "+sqlwhere;
				sqlwhere = "select * from DocInstancyLevel "+sqlwhere + "order by showOrder asc";
				//end

				RecordSet.execute(sqlwhere);
				while(RecordSet.next()){
				%>
					<wea:item><A HREF=#><%=RecordSet.getString(1)%></A></wea:item>
					<wea:item><%=RecordSet.getString(2)%></wea:item>
					<wea:item><%=RecordSet.getString(3)%></wea:item>
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
			var resultJson = {id:$(this).find("td:first").text().trim(),name:$(this).find("td:first").next().text().trim()};
			if(dialog){
				try{
					dialog.callback(resultJson);
				}catch(e){}
				try{
					dialog.close(resultJson);
				}catch(e){}
			}else{
				window.parent.returnValue = resultJson;
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
