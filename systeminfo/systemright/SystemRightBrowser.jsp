<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String rightname = Util.null2String(request.getParameter("rightname"));
String rightdesc = Util.null2String(request.getParameter("rightdesc"));
String righttype = Util.null2String(request.getParameter("righttype"));
String languageid = ""+user.getLanguage();
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!rightname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where rightname like '%" + Util.fromScreen2(rightname,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and rightname like '%" + Util.fromScreen2(rightname,user.getLanguage()) +"%' ";
}
if(!rightdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where SystemRightsLanguage.rightdesc like '%" + Util.fromScreen2(rightdesc,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and SystemRightsLanguage.rightdesc like '%" + Util.fromScreen2(rightdesc,user.getLanguage()) +"%' ";
}
if(!righttype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where righttype = '"+ righttype + "' ";
	}
	else
		sqlwhere += " and righttype = '"+ righttype + "' ";
}

String sqlstr = "select distinct SystemRightsLanguage.id,rightname,SystemRightsLanguage.rightdesc,righttype  "+
			    "from SystemRights , SystemRightsLanguage " + sqlwhere ;
if(ishead ==0) sqlstr += " where SystemRights.id = SystemRightsLanguage.id and languageid= "+languageid ;
else sqlstr += " and SystemRights.id = SystemRightsLanguage.id and languageid= "+languageid ;

sqlstr += " order by righttype , SystemRightsLanguage.id " ;

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SystemRightBrowser.jsp" method=post>
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

			  <table width=100% class=viewform>
				<TR> 
				  <TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
				  <TD width=35% class=field>
					<input name=rightname value="<%=rightname%>" class="InputStyle">
				  </TD>
				  <TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				  <TD width=35% class=field> 
					<input name=rightdesc value="<%=rightdesc%>" class="InputStyle">
				  </TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
				<TR> 
				  <TD width=15%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
				  <TD width=35% class=field> 
					<select class=saveHistory id=resourcetype name=righttype>
					  <option value=""></option>
					  <option value=0 <%if(righttype.equalsIgnoreCase("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></option>
					  <option value=1 <%if(righttype.equalsIgnoreCase("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
					  <option value=2 <%if(righttype.equalsIgnoreCase("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></option>
					  <option value=3 <%if(righttype.equalsIgnoreCase("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
					  <option value=8 <%if(righttype.equalsIgnoreCase("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
					  <option value=5 <%if(righttype.equalsIgnoreCase("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></option>
					  <option value=6 <%if(righttype.equalsIgnoreCase("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
					  <option value=7 <%if(righttype.equalsIgnoreCase("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></option>
					</select>
				  </TD>
				  <TD width=15%>&nbsp;</TD>
				  <TD width=35%>&nbsp; </TD>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
			  </table>
			  <BR>
			<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0" width="100%">
			<TR class=DataHeader>
				  <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
				  <TH width=40%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
				  <TH width=65%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
				  </TR>
			<TR class=Line style="height:1px;"><TH colspan="4" ></TH></TR> 

			<%
			int i=0;
			RecordSet.executeSql(sqlstr);
			while(RecordSet.next()){
				String ids = RecordSet.getString("id");
				String rightnames = Util.toScreen(RecordSet.getString("rightname"),user.getLanguage());
				String rightdescs = Util.toScreen(RecordSet.getString("rightdesc"),user.getLanguage());
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
				<TD><%=rightnames%></TD>
				<TD><%=rightdescs%></TD>
			</TR>
			<%}
			%>

			</TABLE>

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

<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
</FORM>
</BODY>
</HTML>

<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
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
-->
<script language="javascript">

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

});

function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}
</script>