
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<%

String f_name = Util.null2String(request.getParameter("f_name"));
String f_desc = Util.null2String(request.getParameter("f_desc"));
String isDialog = Util.null2String(request.getParameter("isDialog"));
String sqlwhere =" where  1=1";

if(!f_name.equals("")){
		sqlwhere += "  and  f_name like '%" + f_name+"%' ";
}
if(!f_desc.equals("")){
		sqlwhere += " and f_desc like '%" +f_desc+"%' ";
}

String sqlstr = "select id,f_name,f_desc "+  "from fontinfo " + sqlwhere ;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3">

		<font style="font-family: "></font>
</td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/page/maint/style/FontSelect.jsp" method=post>
<input type="hidden" name="isDialog" value="<%=isDialog %>" />
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:submitReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON  class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
		<table width=100% class=ViewForm>
		    <TR class=spacing style="height: 1px"> 
		      <TD class=line1 colspan=4>
		      </TD>
		    </TR>
		    <TR > 
		      <TD width=15%><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%></TD>
		      <TD width=35% class=field> 
		        <input class=inputstyle  name=f_name    id=f_name   value="<%=f_name%>">
		      </TD>
		      <TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
		      <TD width=35% class=field> 
		        <input class=inputstyle name=f_desc     id=f_desc   value="<%=f_desc%>">
		      </TD>
		    </TR>
		    </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=30%><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%></TH>
      <TH width=55%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String currencynames = Util.toScreen(RecordSet.getString("f_name"),7);
	String currencydescs = Util.toScreen(RecordSet.getString("f_desc"),7);
if(i==0){
		i=1;
%>
<TR class="DataLight fonttr">
<%
	}else{
		i=0;
%>
<TR class="DataDark fonttr">
<%
}
%>
	<TD><A HREF=#><%=ids%></A></TD>
	<TD><%=currencynames%></TD>
	<TD><%=currencydescs%></TD>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
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
var parentWin = null;
var dialog = null;
try{
	//parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.parent.getDialog(parent);
}catch(e){}
jQuery(document).ready(function(){
	// alert(jQuery("#BrowseTable").find("tr.fonttr").length)
	jQuery("#BrowseTable").find("tr.fonttr").bind("click",function(){
		onSure({
            id:$(this).find("td:first").text(),
            name:$(this).find("td:first").next().text()
        });
    });
	jQuery("#BrowseTable").find("tr.fonttr").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
    jQuery("#BrowseTable").find("tr.fonttr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})
	
})

function onSure(returnjson){
	if('<%=isDialog%>'==1){
		try{
		     dialog.close(returnjson);
		
		 }catch(e){alert(e)}
	   try{
          dialog.callback(returnjson);
    	}catch(e){alert(e)}

		
	}else{
		window.parent.returnValue=returnjson;
		window.parent.close();
	}
}

function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
function submitReset(){
	jQuery("#f_name").val("");
	jQuery("#f_desc").val("");
	//document.getElementById("SearchForm").submit();
}

</script>
</BODY></HTML>

