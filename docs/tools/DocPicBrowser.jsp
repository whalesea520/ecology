<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">

	function afterDoWhenLoaded(){
		
		jQuery("input[name='_allselectcheckbox']").closest("td").css("visibility","hidden");
		jQuery("#_xTable table.ListStyle").children("tbody").children("tr").children("td").bind("click",function(){
				if(jQuery(this).closest("tr.e8EmptyTR").length==0){
					var id = jQuery(this).find(":checkbox").attr("id");
					var name = jQuery(this).find(":checkbox").next("span").text();
					if(dialog){
						try{
						dialog.callback({id:id,name:name});
						}catch(e){}
						try{
						dialog.close({id:id,name:name});
						}catch(e){}

					}else{
						window.parent.returnValue = {id:id,name:name};
						window.parent.close();
					}
				}
			});
	}
	
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("74",user.getLanguage())%>");
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
<%
String pictype =Util.null2String(request.getParameter("pictype"));
String searchdes = Util.null2String(request.getParameter("searchdes"));
String sqlwhere = "";
int ishead = 0;
if(!searchdes.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " picname like '%";
		sqlwhere += Util.fromScreen2(searchdes,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!pictype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " pictype=";
		sqlwhere += pictype;
	}
	else{
		sqlwhere += " and pictype=";
		sqlwhere += pictype;
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

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
<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0" action="DocPicBrowser.jsp" method=post>
<input type=hidden name="pictype" value="<%=pictype%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=1 onclick=""><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input  class=InputStyle name=searchdes value='<%=searchdes%>'></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<%
		String browser="<browser imgurl=\"/weaver/weaver.docs.docs.ShowDocsImageServlet\" linkkey=\"imagefileid\" linkvaluecolumn=\"imagefileid\" />";
		String tableString=""+
		   "<table instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\"thumbnail\">"+
		   " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getImageCheckbox2\"  popedompara=\"column:id\" />"+
		   browser+
		   "<sql backfields=\"id,pictype,picname,imagefilesize,imagefileid\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlform=\"DocPicUpload\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   "<head>"+							 
				 "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(85,user.getLanguage())+"\" column=\"picname\" orderkey=\"picname\"/>"+
		   "</head>"+
		   "</table>"; 
		   %>
		   <wea:layout needImportDefaultJsAndCss="false" attributes="{'formTableId':'BrowserTable'}">
		   	<wea:group context="" attributes="{'groupDisplay':'none'}">
		   		<wea:item attributes="{'isTableList':'true'}">
		   			<wea:SplitPageTag isShowThumbnail="true" isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
		   		</wea:item>	
		   	</wea:group>
		   </wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>

</FORM>
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
