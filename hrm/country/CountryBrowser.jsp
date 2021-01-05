<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("377",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->CountryBrower3.jsp");
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
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(377,user.getLanguage());
String needfav ="1";
String needhelp ="";

String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String countryname = Util.null2String(request.getParameter("countryname"));
String countrydesc = Util.null2String(request.getParameter("countrydesc"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(ishead == 1){
	sqlwhere += " and (canceled is null or canceled = 0) ";
}else{
	ishead = 1;
	sqlwhere += " where (canceled is null or canceled = 0) ";
}
if(!countryname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where countryname like '%";
		sqlwhere += Util.fromScreen2(countryname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and countryname like '%";
		sqlwhere += Util.fromScreen2(countryname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!countrydesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where countrydesc like '%";
		sqlwhere += Util.fromScreen2(countrydesc,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and countrydesc like '%";
		sqlwhere += Util.fromScreen2(countrydesc,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
<div class="zDialog_div_content" style="width:100%;height:100%">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CountryBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(377,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=countryname value='<%=countryname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=countrydesc value='<%=countrydesc%>'></wea:item>
	</wea:group>
</wea:layout>

<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;height:100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>

<%
int i=0;
sqlwhere = "select * from HrmCountry "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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
	<TD><A HREF=#><%=RecordSet.getString(1)%></A></TD>
	<TD><%=RecordSet.getString(2)%></TD>
	<TD><%=RecordSet.getString(3)%></TD>
	
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:eq(1)").next().text()};
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
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	var returnjson = {id:"0",name:""};
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
}
  
	function btncancel_onclick(){
		if(dialog){
			dialog.closeByHand();
		}else{
	  	window.parent.close();
		}
	}
</script>
</BODY></HTML>
