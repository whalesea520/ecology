<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

String jobtitlemark = Util.null2String(request.getParameter("jobtitlemark"));
String jobtitlename = Util.null2String(request.getParameter("jobtitlename"));
String jobactivityname = Util.null2String(request.getParameter("jobactivityname"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("6086",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e);
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}
		catch(e){}
	</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="javascript:document.SearchForm.submit();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<div class="zDialog_div_content">
<FORM id=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="JobTitlesBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON id=btnSearch class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
</DIV>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=jobtitlename value='<%=jobtitlename%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=jobtitlemark value='<%=jobtitlemark%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=jobactivityname value='<%=jobactivityname%>'></wea:item>
	</wea:group>
</wea:layout>
</FORM>
<%
String backfields = " a.id as id,a.jobtitlemark as jobtitlemark,a.jobtitlename as jobtitlename, b.jobactivityname as jobactivityname"; 
String fromSql  = " from HrmJobTitles a left join HrmJobActivities b on a.jobactivityid=b.id";
String sqlWhere = " where 1=1 "+sqlwhere;
String orderby = " a.id " ;
String tableString = "";

if (!"".equals(jobtitlemark)) {
	sqlWhere += " and a.jobtitlemark like '%"+jobtitlemark+"%'";
}  	  	

if (!"".equals(jobtitlename)) {  
	sqlWhere += " and a.jobtitlename like '%"+jobtitlename+"%'"; 	  	
}
if (!"".equals(jobactivityname)) {  
	sqlWhere += " and b.jobactivityname like '%"+jobactivityname+"%'"; 	  	
}
tableString =" <table pageId=\""+PageIdConst.HRM_JobTitlesBrowser+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_JobTitlesBrowser,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    "			<head>"+
    "				<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(15767,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\" />"+
    "				<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(399,user.getLanguage())+"\" column=\"jobtitlemark\" orderkey=\"jobtitlemark\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1915,user.getLanguage())+"\" column=\"jobactivityname\" orderkey=\"jobactivityname\"/>"+
    "			</head>"+
    " </table>";
%>
 <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_JobTitlesBrowser %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"  class="zd_btn_submit" id="btnclear" onclick="btnclear_onclick();" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
        <input type="button"  class="zd_btn_cancle" id="btncancel" onclick="btncancel_onclick()" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
	</wea:layout>		
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</div>
 <script type="text/javascript">
	function btnOnSearch(){
	  jQuery("#btn_Search").trigger("click");
	}
 
 function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.parent.close();
	}
}

function afterDoWhenLoaded(){
	$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
		var tr = jQuery(this);
		tr.bind("click",function(){
			var id = tr.children("td:first").find("input[type=checkbox]").val();
			var name = tr.children("td:first").next().text().replace(",","，");
			var returnjson = {'id':id,'name':name};	 
			if(dialog){
				try{
          dialog.callback(returnjson);
     }catch(e){}

			try{
			   dialog.close(returnjson);
			 }catch(e){}
			}else{
	    	window.parent.parent.returnValue = returnjson;
	    	window.parent.parent.close();
		 	}
		});
	});
}

function btnclear_onclick()
{
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
	       dialog.callback(returnjson);
	  		}catch(e){}
	
		try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{ 
	  window.parent.parent.returnValue  = returnjson;
	  window.parent.parent.close();
	}
}
</script>
</BODY>
</HTML>