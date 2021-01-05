<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String mode = Util.null2String(request.getParameter("mode"));
//String modetype = Util.null2String(request.getParameter("modetype"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere1 = sqlwhere ;
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!mode.equals("")){
	if(ishead==0){
		ishead=1;
		if(mode.equals("1"))
			sqlwhere += " where modetype = '1' " ;
		else
			sqlwhere += " where modetype = '2' " ;
	}else{
		if(mode.equals("1"))
			sqlwhere += " and modetype = '1' " ;
		else
			sqlwhere += " and modetype = '2' " ;
	}
	
}
/*if(!modetype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where modetype = '" + modetype+ "' " ;
	}
	else 
		sqlwhere += " and modetype = '" + modetype +"' " ;
}
*/
if(ishead==0) sqlwhere += " where modestatus != '0' " ;
else sqlwhere += " and modestatus != '0' " ;

String sqlstr = "select * "+
			    "from LgcStockMode " + sqlwhere ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcStockModeBrowser.jsp" method=post>
<DIV align=right style="display:none">
<!--
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
-->
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<!--
  <table width=100% class=ViewForm>
    <TR class=Spacing> 
      <TD class=Line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=15%>类型</TD>
      <TD width=35% class=field>
        <select class=InputStyle id=State name=modetype>
		  <option value=""></option>
          <option value="1" >入库</option>
          <option value="2" >出库</option>
        </select>
      </TD>
      <TD width=15%>&nbsp;</TD>
      <TD width=35%>&nbsp; </TD>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colspan=4></TD>
    </TR>
  </table>
  -->
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"></TH>      
      <TH width=20%>名称</TH>
      <TH width=15%>类型</TH>
	  <TH width=65%>说明</TH></tr><TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String modenames = Util.toScreen(RecordSet.getString("modename"),user.getLanguage());
	String modetypes = Util.toScreen(RecordSet.getString("modetype"),user.getLanguage());
	String modedescs = Util.toScreen(RecordSet.getString("modedesc"),user.getLanguage());
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
	<TD width=0% style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=modenames%></TD>
	<TD>
	<% if(modetypes.equals("1")) {%>入库
	<%}else if(modetypes.equals("2")) {%>出库 <%}%>
	</TD>
	  <TD><%=modedescs%></TD>
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere1)%>">
</FORM>
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
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
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
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
  
</script>
</BODY></HTML>