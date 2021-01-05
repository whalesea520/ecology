<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-09 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("6131",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->UseDemandBrowser.jsp");
	}
  var parentWin = null;
  var dialog = null;
  try{
  	parentWin = parent.parent.getParentWindow(parent);
  	dialog = parent.parent.getDialog(parent);
  }catch(e){}
</script>
</HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
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
		sqlwhere += " where j.jobtitlename like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and j.jobtitlename like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6131,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div class="zDialog_div_content" style="width:100%;height:100%">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="UseDemandBrowser.jsp" method=post>
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
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(20379,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=name value='<%=name%>'></wea:item>
	</wea:group>
</wea:layout>


<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=50%><%=SystemEnv.getHtmlLabelName(20379,user.getLanguage())%></TH>
<TH width=50%><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())+SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
</tr>
<TR class=Line style="height: 1px"><TH colSpan=2></TH></TR>
<%
int i=0;
sqlwhere = "select a.id,j.jobtitlename as name,a.demandnum from HrmUseDemand a left join HrmJobTitles j on a.demandjobtitle = j.id "+sqlwhere;
rs.execute(sqlwhere);
while(rs.next()){
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
	<TD style="display:none"><%=rs.getString(1)%></TD>
	<TD>&nbsp;&nbsp;<%=rs.getString("name")%></TD>
	<TD>&nbsp;&nbsp;<%=rs.getString("demandnum")%></TD>
	
</TR>
<%}%>
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
			dialog.callback(returnjson);
		}else{ 
		  window.parent.returnValue  = returnjson;
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
	var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}
  
</script>
</BODY></HTML>
