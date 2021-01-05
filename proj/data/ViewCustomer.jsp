
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="VerifyPower" class="weaver.proj.VerifyPower" scope="page" />

<%
String ProjID = Util.null2String(request.getParameter("ProjID"));

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

VerifyPower.init(request,response,ProjID);
if(logintype.equals("1")){
	iscreater = VerifyPower.isCreater();
	ismanager = VerifyPower.isManager();
	if(!ismanager){
		ismanagers = VerifyPower.isManagers();
	}
	if(!ismanagers){
		isrole = VerifyPower.isRole();
	}
	if(!iscreater && !ismanager && !ismanagers && !isrole){
		ismember = VerifyPower.isMember();
	}
	if(!iscreater && !ismanager && !ismanagers && !isrole && !ismember){
		isshare = VerifyPower.isShare();
	}
}
if(iscreater || ismanager || ismanagers || isrole || ismember || isshare || !iscustomer.equals("0")){
	canview = true;
}

if(iscreater || ismanager || ismanagers || isrole){
	canedit = true;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":<a href='/proj/data/ViewProject.jsp?log=n&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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



<%if(canedit){%>



<FORM id=weaverA action="ProjCustomerOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="ProjID" value="<%=ProjID%>">

<TABLE class=viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=35%>
  <COL width="15%">
  <COL width=35%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=4></TD></TR>
           <TR>
          <TD colSpan=4>
		 <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:weaverA.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> </TD>
        </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
          <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowCustomer()"></button> 
              <span class=inputstyle id=Customerspan></span> 
              <input type=hidden name=CustomerID value=0>
		  </TD>
          <TD><%=SystemEnv.getHtmlLabelName(1291,user.getLanguage())%></TD>
          <TD class=Field>
				<select class=inputstyle  name=powerlevel>
				  <option value="0"><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>
				  <option value="1" selected><%=SystemEnv.getHtmlLabelName(1292,user.getLanguage())%>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(1293,user.getLanguage())%>
				</SELECT>
		  </TD>
        </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field>
              <input name=reasondesc class=inputstyle maxLength=100 style="width=100%">
		  </TD>
        </TR>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="ProjCustomerOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">
<input type="hidden" name="ProjID" value="<%=ProjID%>">

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2>
		  
				 <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:weaverD.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=liststyle cellspacing=1 >
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(1291,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
	    </TR>
		<TR class=Line><Th colspan="4" ></Th></TR> 


<%
RecordSet.executeProc("Prj_Find_Customer",ProjID);
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><input type=checkbox name=CustomerIDs value="<%=RecordSet.getString("customerid")%>"></th>
			<td><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("customerid")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid")),user.getLanguage())%></a></td>
			<td>
				<%if(RecordSet.getString("powerlevel").equals("1")){%>
						<%=SystemEnv.getHtmlLabelName(1292,user.getLanguage())%>
				<%}else if(RecordSet.getString("powerlevel").equals("2")){%>
						<%=SystemEnv.getHtmlLabelName(1293,user.getLanguage())%>
				<%}else{%>
						<%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%>
				<%}%>
						

			</td>
			<td><%=RecordSet.getString("reasondesc")%></td>
    </tr>
<%	
	isLight = !isLight;
}%>
	  </TBODY>
	  </TABLE>
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

<script language=vbs>

sub onShowCustomer()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaverA.CustomerID.value=id(0)
	else 
	Customerspan.innerHtml = ""
	weaverA.CustomerID.value="0"
	end if
	end if
end sub

</script>

</body>
</html>


