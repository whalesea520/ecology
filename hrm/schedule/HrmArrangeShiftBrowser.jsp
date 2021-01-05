<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("16255",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->HrmArrangeShiftBrowser.jsp");
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
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16695,user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sql = "select * from HrmArrangeShift where ishistory='0'" + sqlwhere ;

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmArrangeShiftBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
 <TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
  <TH width=20%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
  <TH width=25%><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
  <TH width=25%><%=SystemEnv.getHtmlLabelName(19548,user.getLanguage())%></TH>
</tr>
<%
int i=0;
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String shiftid = Util.null2String( RecordSet.getString("id") ) ; 
	String shiftname = Util.toScreen(RecordSet.getString("shiftname"),user.getLanguage());
	String shiftbegintime = Util.null2String( RecordSet.getString("shiftbegintime") ) ; 
	String shiftendtime = Util.null2String( RecordSet.getString("shiftendtime") ) ; 
	String validedatefrom = Util.null2String( RecordSet.getString("validedatefrom") ) ; 
	//validedatefrom += "~" + Util.null2String( RecordSet.getString("validedateto") ) ; 
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
    <TD width=0% style="display:none"><%=shiftid%></TD>
	<TD><%=shiftname%></TD>
	<TD><%=shiftbegintime%></TD>	
    <TD><%=shiftendtime%></TD>
	<TD><%=validedatefrom%></TD>
	</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>

<SCRIPT LANGUAGE="JavaScript">
function btnclear_onclick(){
 var returnjson = {id:"",name:""};
 if(dialog){
 	dialog.callback(returnjson);
 }else{
  window.parent.parent.returnValue = returnjson;//Array("","")
	window.parent.parent.close();
 }

}

function btncancel_onclick(){
 if(dialog){
 	dialog.close();
 }else{
	window.parent.parent.close();
 }
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		var returnjson = {id:jQuery(this).find("td:first").text(),name:jQuery(this).find("td:first").next().text()};
		if(dialog){
			dialog.callback(returnjson);
		}else{
			window.parent.parent.returnValue = returnjson;
			window.parent.parent.close();
		}

		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected");
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected");
		})

});
</SCRIPT>
<!--
<SCRIPT LANGUAGE=VBS>

Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</SCRIPT>-->