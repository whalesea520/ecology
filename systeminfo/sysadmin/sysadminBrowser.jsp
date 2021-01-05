<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("17870",user.getLanguage())%>");
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
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17870,user.getLanguage());
String needfav ="1";
String needhelp ="";
String lastname = Util.null2String(request.getParameter("lastname"));
String description = Util.null2String(request.getParameter("description"));
String _from = Util.null2String(request.getParameter("_from"));

String languageid = ""+user.getLanguage();
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!lastname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where creator="+user.getUID()+" and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and creator="+user.getUID()+" and lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' ";
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where creator="+user.getUID()+" and description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and creator="+user.getUID()+" and description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
}

if(sqlwhere.equals("") && "".equals(_from)) sqlwhere=" where creator="+user.getUID();
String sqlstr = "select id,lastname,description from hrmresourcemanager " +sqlwhere;

sqlstr += " order by id " ;
%>
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
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="sysadminBrowser.jsp" method=post>
<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
 <DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:resetData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel_Onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onblur="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=lastname value='<%=lastname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=description value='<%=description%>'></wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0;width:100%">
<TR class=DataHeader>
	  <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
	  <TH width=65%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
	  </TR>
<TR class=Line><TH colspan="4" ></TH></TR> 

<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage());
	description = Util.toScreen(RecordSet.getString("description"),user.getLanguage());
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=lastname%></TD>
	<TD><%=description%></TD>
</TR>
<%}
%>

</TABLE>
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
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
<script type="text/javascript">
function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.close();
	}
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{ 
		  window.parent.returnValue  = returnjson;
		  window.parent.close();
		}
		})
})


function submitClear()
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
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}

function resetData(){
	document.SearchForm.lastname.value = "";
	document.SearchForm.description.value = "";
	document.SearchForm.submit();
}
  
</script>
</BODY></HTML>
