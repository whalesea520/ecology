<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSetHrm" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>

<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


String sqlwhere="";


String check_per = ","+Util.null2String(request.getParameter("taskids"))+",";
String taskids ="";
String tasknames ="";
String strtmp = "select id,taskName from Prj_TemplateTask ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	
		 	taskids +="," + RecordSet.getString("id");
		 	tasknames += ","+RecordSet.getString("taskName");
	}
}


int k;
String log = Util.null2String(request.getParameter("log"));
String level = Util.null2String(request.getParameter("level"));
String subject= Util.fromScreen2(request.getParameter("subject"),user.getLanguage());
String begindate01= Util.null2String(request.getParameter("begindate01"));
String begindate02= Util.null2String(request.getParameter("begindate02"));
String enddate01= Util.null2String(request.getParameter("enddate01"));
String enddate02= Util.null2String(request.getParameter("enddate02"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
if(level.equals("")){
	level = "10" ;
}


String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

sqlwhere=" where templetId = "+ProjID+" ";
if(!subject.equals("")){
	sqlwhere+=" and taskName like '%"+subject+"%' ";
}
if(!begindate01.equals("")){
	sqlwhere+=" and begindate>='"+begindate01+"'";
}
if(!begindate02.equals("")){
	sqlwhere+=" and begindate<='"+begindate02+"'";
}
if(!enddate01.equals("")){
	sqlwhere+=" and enddate>='"+enddate01+"'";
}
if(!enddate02.equals("")){
	sqlwhere+=" and enddate<='"+enddate02+"'";
}
if(!hrmid.equals("")){
	sqlwhere+=" and taskManager='"+hrmid+"'";
}

String sqlstr = "select * from Prj_TemplateTask"+sqlwhere+ "order by parentTaskId" ;
if(!taskrecordid.equals("")){
    sqlstr = "select * from Prj_TemplateTask"+sqlwhere+" and id<>"+taskrecordid +" order by parentTaskId";
}
char flag = 2;
String ProcPara = "";
ProcPara = ProjID + flag + "" ;
RecordSetHrm.executeProc("Prj_Member_SumProcess",ProcPara);
%>

</HEAD>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiTaskBrowser.jsp" method=post>


<DIV align=left>
 <input type=hidden  name=ProjID value="<%=ProjID%>">
 <input type=hidden  name=taskrecordid value="<%=taskrecordid%>">


</DIV>

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
			  <tr>
				 <td width="60"><%=SystemEnv.getHtmlLabelName(2099,user.getLanguage())%></td>
				 <td class=field>&nbsp
					<select  name=level size=1 class=inputstyle >
					 <%for(k=1;k<=10;k++){%>
						 <option value="<%=k%>" <%if(level.equals(""+k)){%>selected<%}%>><%=k%></option>
						
					 <%}%>
					 </select>	
					  <input type=hidden name=level value="<%=k%>">
				 </td>
				 <td width="60" align=right><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></td>
				 <td class=field>&nbsp
					<input name=subject size=15 value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>" class=inputstyle>
					 <input type=hidden name=subject value="<%=Util.toScreenToEdit(request.getParameter("subject"),user.getLanguage())%>" class=inputstyle>
				 </td>
				 <td width="60" align=right><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></td>
				 <td class=field>&nbsp
					<select   name=hrmid size=1 class=inputstyle  >
						 <option value="" <%if(hrmid.equals("")){%>selected<%}%>></option>
					 <%while(RecordSetHrm.next()){%>
						 <option value="<%=RecordSetHrm.getString("hrmid")%>" <%if(RecordSetHrm.getString("hrmid").equals(""+hrmid)){%>selected<%}%>><%=ResourceComInfo.getResourcename(RecordSetHrm.getString("hrmid"))%></option>
					 <%}%>
					 </select>	 
					  <input type=hidden  name=hrmid value="<%=RecordSetHrm.getString("hrmid")%>">
				  </td>
			 </tr>
			 <tr><td colspan="6" class="Line"></td></tr>
		   <tr>  
			 <TD  width="60"><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
			 <TD class=Field colspan="2">&nbsp;
					  <BUTTON class=calendar id=SelectDate onclick=getDate(begindate01span,begindate01)></BUTTON>&nbsp;
					  <SPAN id=begindate01span ><%=begindate01%></SPAN>
					  <input type="hidden" name="begindate01" value="<%=begindate01%>">
					  －	<BUTTON class=calendar id=SelectDate onclick=getDate(begindate02span,begindate02)></BUTTON>&nbsp;
					  <SPAN id=begindate02span ><%=begindate02%></SPAN>
					  <input type="hidden" name="begindate02" value="<%=begindate02%>">
				  
			</TD>

			 <TD width="60"><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
			 <TD class=Field colspan="2">&nbsp;
					  <BUTTON class=calendar id=SelectDate onclick=getDate(enddate01span,enddate01)></BUTTON>&nbsp;
					  <SPAN id=enddate01span ><%=enddate01%></SPAN>
					  <input type="hidden" name="enddate01" value="<%=enddate01%>">
					  －	<BUTTON class=calendar id=SelectDate onclick=getDate(enddate02span,enddate02)></BUTTON>&nbsp;
					  <SPAN id=enddate02span ><%=enddate02%></SPAN>
					  <input type="hidden" name="enddate02" value="<%=enddate02%>">
				  
			</TD>
			</tr> 
	
			<TR class=spacing><TD class=line colspan=6></TD></TR>
		   <tr>
			<td colspan="6" height="19"> 
			  <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
			  <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
		  </tr> 
		</table>
		<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1">
		<TR class=DataHeader>
			  <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
			 <TH width=5%></TH>  
			 <TH width=35%><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
			  <TH width=8%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TH>
			  <TH width=13%><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TH>
			  <TH width=13%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TH></tr>
			  <TR class=Line><Th colspan="6" ></Th></TR> 
		<%
		RecordSet.executeSql(sqlstr);
		while(RecordSet.next()){
			int i=0;
			String ids = RecordSet.getString("id");
			subject = Util.toScreen(RecordSet.getString("taskName"),user.getLanguage());
			hrmid = Util.toScreen(RecordSet.getString("taskManager"),user.getLanguage());
			String workday = RecordSet.getString("workday");
			//String childnum =RecordSet.getString("childnum");
			//String level_n =RecordSet.getString("level_n");

			if(i==0){
				i=1;
		%>
		<TR class=DataLight>
		<%
			}else{
				i=0;
		%>
		<TR class=DataDark>
		<%}%>
			<TD style="display:none"><A HREF=#><%=ids%></A></TD>
			
			 <%
			 String ischecked = "";
			 if(check_per.indexOf(","+ids+",")!=-1){
				ischecked = " checked ";
			 }%>
			<TD><input type="checkbox" name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
				   
			<TD>
			 <%=RecordSet.getString("taskName")%>
				</TD>
			<TD><%=ResourceComInfo.getResourcename(RecordSet.getString("taskManager"))%></TD>
			 <td nowrap><%if(!RecordSet.getString("begindate").equals("x")){%><%=RecordSet.getString("begindate")%><%}%></td>
			<td nowrap><%if(!RecordSet.getString("enddate").equals("-")){%><%=RecordSet.getString("enddate")%><%}%></td>
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
  <input type="hidden" name="taskids" value="">
</FORM>
<SCRIPT LANGUAGE=VBScript>
taskids = "<%=taskids%>"
tasknames = "<%=tasknames%>"
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		taskids = replace(taskids,","&e.parentelement.cells(0).innerText,"")
   		tasknames = replace(tasknames,","&e.parentelement.cells(2).innerText,"")
   		
   	else
   		obj.checked = true
   		taskids = taskids & "," & e.parentelement.cells(0).innerText
   		tasknames = tasknames & "," & e.parentelement.cells(2).innerText
   	end if
  '   window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
   '   window.parent.Close
   ElseIf e.TagName = "A" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		taskids = replace(taskids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		tasknames = replace(tasknames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	else
   		obj.checked = true
   		taskids = taskids & "," & e.parentelement.parentelement.cells(0).innerText
   		tasknames = tasknames & "," & e.parentelement.parentelement.cells(2).innerText
   	end if
    '  window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     ' window.parent.Close
   ElseIf e.TagName = "INPUT" Then
   	if e.checked then 
	   	taskids = taskids & "," & e.parentelement.parentelement.cells(0).innerText
	   	tasknames = tasknames & "," & e.parentelement.parentelement.cells(2).innerText
	 else
	 	taskids = replace(taskids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		tasknames = replace(tasknames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	end if
    '  window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     ' window.parent.Close
   
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

Sub btnok_onclick()
    'modify by dongping for TD628 begin
	'alert (taskids+"<br>"+tasknames) 
    window.parent.returnvalue = Array(taskids,tasknames)
    window.parent.close
    ' end.
End Sub

Sub btnsub_onclick()
    document.all("taskids").value = taskids
    document.SearchForm.submit
End Sub

</SCRIPT>

<script language="javascript">
function CheckAll(checked) {
//	alert(taskids);
//	taskids = "";
//	tasknames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {	
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				taskids = taskids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		tasknames = tasknames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);			
		}
 	} 
 //	alert(taskids);
}
</script>

<script language="javascript">
function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}




</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>