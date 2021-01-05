<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String departmentmark = Util.null2String(request.getParameter("departmentmark"));
String departmentname = Util.null2String(request.getParameter("departmentname"));
String sqlwhere = "";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!departmentmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where costcentermark like '%";
		sqlwhere += Util.fromScreen2(departmentmark,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and costcentermark like '%";
		sqlwhere += Util.fromScreen2(departmentmark,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!departmentname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where costcentername like '%";
		sqlwhere += Util.fromScreen2(departmentname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and costcentername like '%";
		sqlwhere += Util.fromScreen2(departmentname,user.getLanguage());
		sqlwhere += "%'";
	}
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CostcenterBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>
<TR class=Spacing style="height: 1"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=departmentmark value="<%=departmentmark%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=departmentname value="<%=departmentname%>"></TD>
</TR>
<TR class=Spacing style="height: 1"><TD class=Line1 colspan=4></TD></TR>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1"><TH colspan="4" ></TH></TR>

<%
int i=0;
sqlwhere = "select * from HrmCostcenter "+sqlwhere;
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
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr").bind("click",function(){
		// window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText&"-"& e.parentelement.cells(2).innerText,e.parentelement.cells(2).innerText)	
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()+"-"+$(this).find("td:first").next().next().text(),other1:$(this).find("td:first").next().next().text()};
			window.parent.close()
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
	window.parent.returnValue = {id:"0",name:"",other1:""};
	window.parent.close()
}
  
</script>
</BODY></HTML>