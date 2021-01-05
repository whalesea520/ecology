<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("15815",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->SalaryItemBrowser.jsp");
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
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CityBrowser.jsp" method=post>
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
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
 </tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = " select * from HrmSalaryItem "+sqlwhere;
rs.execute(sqlwhere);
while(rs.next()){
    String id = Util.null2String(rs.getString("id")) ;
    String itemname = Util.toScreen(rs.getString("itemname"),user.getLanguage()) ;
    String itemcode = Util.toScreen(rs.getString("itemcode"),user.getLanguage()) ;
    String itemtype = Util.null2String(rs.getString("itemtype")) ;

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
	<TD width=0% style="display:none"><A HREF=#><%=id%></A></TD>
	<TD><%=itemname%></TD>
    <TD><%=itemcode%></TD>
	<TD><%if( itemtype.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1804,user.getLanguage())%>
        <%} else if( itemtype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(15825,user.getLanguage())%>
        <%} else if( itemtype.equals("3")) {%><%=SystemEnv.getHtmlLabelName(15826,user.getLanguage())%>
        <%} else if( itemtype.equals("4")) {%><%=SystemEnv.getHtmlLabelName(449,user.getLanguage())%><%}%>
    </TD>
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
function btnclear_onclick(){
	if(dialog){
  	var returnjson = {id:"", name:""};
   	dialog.callback(returnjson);
  }else{
    window.parent.returnValue = {id:"", name:""};
    window.parent.close();
	}
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
    window.parent.close();
  }
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			var returnjson = {id:jQuery(this).find("td:first").text(),name:jQuery(this).find("td:first").next().text()};
			if(dialog){
		   	dialog.callback(returnjson);
		  }else{
		    window.parent.returnValue = returnjson;
		    window.parent.close();
			}
		})
		
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})
</SCRIPT>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
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
</SCRIPT>