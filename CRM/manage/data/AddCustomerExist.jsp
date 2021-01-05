
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 


<%--@ page import="weaver.general.Util" --%>

<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String type = Util.null2String(request.getParameter("type"));
String name = Util.null2String(request.getParameter("name"));
String CRM_CustomerInfo_SelectName = "";
String TooManyRecord = "";
if(!name.equals("")){
	CRM_CustomerInfo_SelectName = "select count(id) recordcount from CRM_CustomerInfo where deleted<>1 and name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%'" ;
	RecordSet.executeSql(CRM_CustomerInfo_SelectName);
	if(RecordSet.next()){

		if(RecordSet.getInt("recordcount")>20){
			TooManyRecord="true";
		}else{
			CRM_CustomerInfo_SelectName = "select * from CRM_CustomerInfo where deleted<>1 and name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%'" ;
			RecordSet.executeSql(CRM_CustomerInfo_SelectName);
			TooManyRecord="false";
		}
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}

function doNext() {
 
  //alert ("/CRM/data/AddCustomer.jsp?name1="+document.weaver.name.value+"&type1="+document.weaver.type.value);
  //modify by xhheng @20050221 for TD 1321
  document.location.href="/CRM/data/AddCustomer.jsp?name1="+document.weaver.name.value+"&type1="+document.weaver.type.value;<%--Modified by xwj for td1552 on 2005-03-22--%>
}

</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

if(TooManyRecord.equals("false")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1256,user.getLanguage())+",javascript:doNext(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=continue1 name= continue1 action="/CRM/data/AddCustomer.jsp" method=post >
<input type="hidden" name="name1" value="<%=name%>">
<input type="hidden" name="type1" value="<%=type%>">
</form>

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

<FORM id=weaver name= weaver action="/CRM/data/AddCustomerExist.jsp" method=post onsubmit='return check_form(this,"name")'>

	  <TABLE class=ViewForm width=250>
        <COLGROUP>
		<COL width="50">
  		<COL width="200">
        <TBODY>
<TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>

          <td class=Field id=txtLocation>
		  <select class=InputStyle  name=type>
		  <%
			String isSelect="";
			while (CustomerTypeComInfo.next()) {
				isSelect="";
				if(type.equals(CustomerTypeComInfo.getCustomerTypeid())){
					isSelect="Selected";
				}
		  %>
		  <option value="<%=CustomerTypeComInfo.getCustomerTypeid()%>"  <%=isSelect%>><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(),user.getLanguage())%></option>
		  <%
		  }
		  %>

		  </select>
          </TD>
        </TR>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="name" onchange='checkinput("name","Nameimage")' STYLE="width:300" value="<%=name%>"><SPAN id=Nameimage><%if(name.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
		  </TD>
        </TR>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

        <TR>
          <TD colSpan=2><%=SystemEnv.getHtmlLabelName(20272,user.getLanguage())%></TD>
        </TR>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

        <TR>
          <TD colSpan=2><%=SystemEnv.getHtmlLabelName(20273,user.getLanguage())%></TD>
        </TR>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

	  </TBODY>
	 </TABLE>
     <br>
</FORM>
<%if(TooManyRecord.equals("true")){%>
<P><span class=fontred><%=SystemEnv.getHtmlLabelName(15126,user.getLanguage())%>!</span></P>
<%}else if(TooManyRecord.equals("false")){
	if(!(RecordSet.getCounts()>0)){
%>
	<script language="javascript">
	    document.continue1.submit() ;
    </script>
<%
	}
%>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></th>

  </tr>
<TR class=Line style="height: 1px"><TD colSpan=5 style="padding: 0px"></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("type")),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString("createdate"),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(CityComInfo.getCityname(RecordSet.getString("city")),user.getLanguage())%></TD>
		<TD><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a></TD>
	</TR>
<%
	}
%>
 </TABLE>
<%}%>

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



</BODY>
</HTML>
