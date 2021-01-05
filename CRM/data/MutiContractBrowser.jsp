<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>

<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String name = Util.null2String(request.getParameter("name"));
String lowsum = Util.null2String(request.getParameter("lowsum"));//金额区间1
String highsum = Util.null2String(request.getParameter("highsum"));//金额区间2
String CustomerID = Util.null2String(request.getParameter("customer"));
String typeId = Util.null2String(request.getParameter("typeId"));
String status = Util.null2String(request.getParameter("status"));

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

/*==========*/
String check_per = ","+Util.null2String(request.getParameter("contractids"))+",";
String contractids = "" ;
String contractnames ="";
String strtmp = "select id,name from CRM_Contract ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){
		 	
		 	contractids +="," + RecordSet.getString("id");
		 	contractnames += ","+RecordSet.getString("name");
	}
}
/*==========*/


if(!sqlwhere.equals("")) {
    if(!name.equals("")){
     sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";	
    }   	
}
else{
    if(!name.equals("")){
     sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";	
    }  
}

if(!sqlwhere.equals("")) {
    if(!lowsum.equals("")){
     sqlwhere += " and t1.price >=" + Util.fromScreen2(lowsum,user.getLanguage()) ;	
    }   	
}
else{
    if(!lowsum.equals("")){
     sqlwhere += " where t1.price >=" + Util.fromScreen2(lowsum,user.getLanguage()) ;	
    }  
}

if(!sqlwhere.equals("")) {
    if(!highsum.equals("")){
     sqlwhere += " and t1.price <=" + Util.fromScreen2(highsum,user.getLanguage()) ;	
    }   	
}
else{
    if(!highsum.equals("")){
     sqlwhere += " where t1.price <=" + Util.fromScreen2(highsum,user.getLanguage()) ;	
    }  
}


if(!sqlwhere.equals("")) {
    if(!CustomerID.equals("")){
     sqlwhere += " and t1.crmId =" + Util.fromScreen2(CustomerID,user.getLanguage()) ;	
    }   	
}
else{
    if(!CustomerID.equals("")){
     sqlwhere += " where t1.crmId =" + Util.fromScreen2(CustomerID,user.getLanguage()) ;	
    }  
}


if(!sqlwhere.equals("")) {
    if(!typeId.equals("")){
     sqlwhere += " and t1.typeId =" + Util.fromScreen2(typeId,user.getLanguage()) ;	
    }   	
}
else{
    if(!typeId.equals("")){
     sqlwhere += " where t1.typeId =" + Util.fromScreen2(typeId,user.getLanguage()) ;	
    }  
}



if(!sqlwhere.equals("")) {
    if(!status.equals("")){
     sqlwhere += " and t1.status =" + Util.fromScreen2(status,user.getLanguage()) ;	
    }   	
}
else{
    if(!status.equals("")){
     sqlwhere += " where t1.status =" + Util.fromScreen2(status,user.getLanguage()) ;	
    }  
}

String sqlstr ="";
String userid=""+user.getUID();
String leftjointable = CrmShareBase.getTempTable(userid);
if(!sqlwhere.equals("")){
    sqlstr = "select distinct  t1.* from CRM_Contract t1 ,"+leftjointable+" t2 "+sqlwhere+" and t1.crmId = t2.relateditemid order by t1.id  desc ";
}
else{
    sqlstr = "select distinct  t1.* from CRM_Contract t1 ,"+leftjointable+" t2 where  t1.crmId = t2.relateditemid order by t1.id  desc ";
}


%>

</HEAD>

<BODY>
<TR class=Line><TH colSpan=4></TH></TR>

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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiContractBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.btnsub.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:SearchForm.btnok.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=C id=btnclear><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing>
<TD class=Line1 colspan=5></TD></TR>
<TR>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></TD>
    <TD width=35% class=field>
        <input class=InputStyle  name=name value="<%=name%>" size=10>
    </TD>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>  </TD>
    <TD class=Field width=35%><BUTTON class=Browser onClick="onShowCustomerID()"></BUTTON> <span 
    id=customerspan><a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=CustomerID%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())%></a></span> 
    <INPUT class=InputStyle type=hidden name="customer" value="<%=CustomerID%>"></TD>


</TR><tr><td class=Line colspan=5></td></tr>
<tr>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></TD>

    <TD width=35% class=Field>
        <select class=InputStyle id=typeId 
        name=typeId>
        <option value="" <%if(typeId.equals("")){%> selected <%}%>> </option>
        <% 
        while(ContractTypeComInfo.next()){ %>
        <option value=<%=ContractTypeComInfo.getContractTypeid()%> <%if(typeId.equals(ContractTypeComInfo.getContractTypeid())){%> selected <%}%>><%=ContractTypeComInfo.getContractTypename()%></option>
        <%}%>
        </select>
    </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
<TD width=35% class=field>
  <select class=InputStyle id=status  name=status  style="width:80px">
    <option value="" <%if(status.equals("")){%> selected <%}%> ></option>
    <option value=0 <%if(status.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
    <option value=1 <%if(status.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
    <option value=2 <%if(status.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage())%></option>
	 <option value=3 <%if(status.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
    </TD>
</TR><tr><td class=Line colspan=5></td></tr>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input class=InputStyle  name=lowsum value="<%=lowsum%>" onKeyPress="ItemNum_KeyPress()" size=8>-- 
        <input class=InputStyle  name=highsum value="<%=highsum%>" onKeyPress="ItemNum_KeyPress()" size=8>
      </TD>
</TR><tr><td class=Line colspan=5></td></tr>

<tr> 
    <td colspan="5" height="19"> 
    <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
    <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
    </TR><tr><td class=Line colspan=5></td></tr>
<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>

</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1>
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
	 <TH width=5%></TH>  
     <TH width=20%><%=SystemEnv.getHtmlLabelName(15142,user.getLanguage())%></TH>      
      <TH width=20%><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%></TH>
      <TH width=25%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colSpan=5></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String price = RecordSet.getString("price");
	String crmId = RecordSet.getString("crmId");
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
	
	 <%
	 String ischecked = "";
	 if(check_per.indexOf(","+ids+",")!=-1){
	 	ischecked = " checked ";
	 }%>
	<TD><input type=checkbox name="check_per" value="<%=ids%>" <%=ischecked%>></TD>
	<TD><%=names%></TD>
	<TD><%=price%></TD>
	<TD><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())%></TD>
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="contractids" value="">
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
<SCRIPT LANGUAGE=VBS>
contractids = "<%=contractids%>"
contractnames = "<%=contractnames%>"
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
   		contractids = replace(contractids,","&e.parentelement.cells(0).innerText,"")
   		contractnames = replace(contractnames,","&e.parentelement.cells(2).innerText,"")
   		
   	else
   		obj.checked = true
   		contractids = contractids & "," & e.parentelement.cells(0).innerText
   		contractnames = contractnames & "," & e.parentelement.cells(2).innerText
   	end if
  '   window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
   '   window.parent.Close
   ElseIf e.TagName = "A" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		contractids = replace(contractids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		contractnames = replace(contractnames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	else
   		obj.checked = true
   		contractids = contractids & "," & e.parentelement.parentelement.cells(0).innerText
   		contractnames = contractnames & "," & e.parentelement.parentelement.cells(2).innerText
   	end if
    '  window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
     ' window.parent.Close
   ElseIf e.TagName = "INPUT" Then
   	if e.checked then 
	   	contractids = contractids & "," & e.parentelement.parentelement.cells(0).innerText
	   	contractnames = contractnames & "," & e.parentelement.parentelement.cells(2).innerText
	 else
	 	contractids = replace(contractids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		contractnames = replace(contractnames,","&e.parentelement.parentelement.cells(2).innerText,"")
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
	
     window.parent.returnvalue = Array(contractids,contractnames)
    window.parent.close
End Sub

Sub btnsub_onclick()
    document.all("contractids").value = contractids
    document.SearchForm.submit
End Sub
sub onShowCustomerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	SearchForm.customer.value=id(0)
	else 
	customerspan.innerHtml = ""
	SearchForm.customer.value=""
	end if
	end if
end sub

</SCRIPT>

<script language="javascript">
function CheckAll(checked) {
//	alert(contractids);
//	contractids = "";
//	contractnames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {	
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				contractids = contractids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		contractnames = contractnames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);			
		}
 	} 
 //	alert(contractids);
}
</script>
</BODY></HTML>