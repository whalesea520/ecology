<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAssetEditOtherCountry:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetcountryid = paraid ;
RecordSet.executeProc("LgcAssetCountry_SelectByID",assetcountryid);
RecordSet.next();

String assetid = RecordSet.getString("assetid");
String assetmark = Util.toScreen(AssetComInfo.getAssetMark(assetid),user.getLanguage());
String assortmentid = Util.toScreen(AssetComInfo.getAssortmentId(assetid),user.getLanguage());
String assetname = RecordSet.getString("assetname");
String assetcountyid = RecordSet.getString("assetcountyid");
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String departmentid = RecordSet.getString("departmentid");
String resourceid = RecordSet.getString("resourceid");
String assetremark = RecordSet.getString("assetremark");
String currencyid = RecordSet.getString("currencyid");
String salesprice = RecordSet.getString("salesprice");
String costprice = RecordSet.getString("costprice");
String isdefault = RecordSet.getString("isdefault");

String dff01 = RecordSet.getString("datefield1");
String dff02 = RecordSet.getString("datefield2");
String dff03 = RecordSet.getString("datefield3");
String dff04 = RecordSet.getString("datefield4");
String dff05 = RecordSet.getString("datefield5");
String nff01 = RecordSet.getString("numberfield1");
String nff02 = RecordSet.getString("numberfield2");
String nff03 = RecordSet.getString("numberfield3");
String nff04 = RecordSet.getString("numberfield4");
String nff05 = RecordSet.getString("numberfield5");
String tff01 = RecordSet.getString("textfield1");
String tff02 = RecordSet.getString("textfield2");
String tff03 = RecordSet.getString("textfield3");
String tff04 = RecordSet.getString("textfield4");
String tff05 = RecordSet.getString("textfield5");
String bff01 = RecordSet.getString("tinyintfield1");
String bff02 = RecordSet.getString("tinyintfield2");
String bff03 = RecordSet.getString("tinyintfield3");
String bff04 = RecordSet.getString("tinyintfield4");
String bff05 = RecordSet.getString("tinyintfield5");

String createrid = RecordSet.getString("createrid");
String createdate = RecordSet.getString("createdate");
String lastmoderid = RecordSet.getString("lastmoderid");
String lastmoddate = RecordSet.getString("lastmoddate");

RecordSetFF.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSetFF.next();

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+assetname;
String needfav ="1";
String needhelp ="1";
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


<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=LgcAssetOtherCountryOperation.jsp?Action=2 method=post>
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-保存</BUTTON>
<% 
if(HrmUserVarify.checkUserRight("LgcAssetEditOtherCountry:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onclick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
 </DIV>
<input type="hidden" name="operation" value="editassetothercountry">
<input type="hidden" name="assetid" value="<%=assetid%>">
<input type="hidden" name="assetcountryid" value="<%=assetcountryid%>">

  <TABLE class=ViewForm width="641">
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <!-- Item info -->
        <table class=ViewForm>
          <colgroup> <col width=120> <tbody> 
          <tr class=Title> 
            <th colspan=3>一般</th>
          </tr>
          <tr class=Spacing> 
            <td class=Line1 colspan=3></td>
          </tr>
          <tr> 
            <td>标识</td>
            <td class=FIELD><%=assetmark%></td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr> 
            <td>名称</td>
            <td class=FIELD> 
              <input class=InputStyle accesskey=Z name=assetname size="30" onChange='checkinput("assetname","assetnameimage")' value='<%=assetname%>'>
              <span id=assetnameimage></span> 
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr> 
            <td>国家</td>
            <td class=Field id=txtLocation> <button class=Browser id=SelectCountryID onClick="onShowCountryID()"></button> 
              <span id=countryidspan style="width:40%" > <%if (assetcountyid.equals("0")) {%>全球 
            <% } else {%>
            <%=Util.toScreen(CountryComInfo.getCountrydesc(assetcountyid),user.getLanguage())%> 
            <%}%></span> 
              <input id=assetcountyid type=hidden name=assetcountyid value='<%=assetcountyid%>'>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr>
            <td>默认</td>
            <td class=Field>
              <input type=checkbox  name="isdefault" value="1" <%if (isdefault.equals("1")) {%>checked disabled<%}%>>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr> 
            <td>生效日</td>
            <td class=Field><button class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
              <span id=startdatespan ><%=Util.toScreen(startdate,user.getLanguage())%></span> 
              <input type="hidden" name="startdate" value='<%=Util.toScreen(startdate,user.getLanguage())%>'>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr> 
            <td>生效至</td>
            <td class=Field><button class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
              <span id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></span> 
              <input type="hidden" name="enddate" value='<%=Util.toScreen(enddate,user.getLanguage())%>'>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr> 
            <td>部门</td>
            <td class=Field colspan=2> 
			  <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span <input class=InputStyle  id=departmentspan><a  href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a></span> 
              <input id=departmentid type=hidden name=departmentid value='<%=Util.toScreen(departmentid,user.getLanguage())%>'>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          <tr> 
            <td>人力资源</td>
            <td class=Field>
			<BUTTON class=Browser id=SelectResourceID onClick="onShowResourceID()"></BUTTON> 
			<span id=resourceidspan><A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></span> 
              <INPUT <input class=InputStyle  type=hidden name=resourceid value='<%=resourceid%>'>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          </tbody> 
        </table>
      </TD>
      <TD></TD>
      <TD vAlign=top rowspan="2"> 
        <table class=ViewForm>
          <tbody> 
          <tr class=Title> 
            <th>备注</th>
          </tr>
<tr><td class=Line1 colspan=2></td></tr>
          <tr> 
            <td valign=top> 
            <TEXTAREA <input class=InputStyle  style="WIDTH: 100%" name=assetremark rows=8><%=Util.toScreen(assetremark,user.getLanguage())%></TEXTAREA>
            </td>
          </TR><tr><td class=Line colspan=2></td></tr>
          </tbody> 
        </table>
        <table class=ViewForm>
          <colgroup> <col width=120> <tbody> 
          <tr class=Title> 
	<TH colSpan=2>空闲字段</TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
<%
	String tmpstr="";
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{
			if (i==1) tmpstr = dff01;
			if (i==2) tmpstr = dff02;
			if (i==3) tmpstr = dff03;
			if (i==4) tmpstr = dff04;
			if (i==5) tmpstr = dff05;
		%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getdate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=Util.toScreen(tmpstr,user.getLanguage())%></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=tmpstr%>">
          </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{
			if (i==1) tmpstr = nff01;
			if (i==2) tmpstr = nff02;
			if (i==3) tmpstr = nff03;
			if (i==4) tmpstr = nff04;
			if (i==5) tmpstr = nff05;
		%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT <input class=InputStyle  maxLength=30 name="nff0<%=i%>" value="<%=Util.toScreen(tmpstr,user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{
			if (i==1) tmpstr = tff01;
			if (i==2) tmpstr = tff02;
			if (i==3) tmpstr = tff03;
			if (i==4) tmpstr = tff04;
			if (i==5) tmpstr = tff05;	
		%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field><INPUT <input class=InputStyle  maxLength=100 name="tff0<%=i%>" STYLE="width:95%" value="<%=Util.toScreen(tmpstr,user.getLanguage())%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+41).equals("1"))
		{
			if (i==1) tmpstr = bff01;
			if (i==2) tmpstr = bff02;
			if (i==3) tmpstr = bff03;
			if (i==4) tmpstr = bff04;
			if (i==5) tmpstr = bff05;
		%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+40)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  name="bff0<%=i%>" <%if (tmpstr.equals("1")) {%>checked <%}%> value='1'></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
		<%}
	}
%>
          </tbody> 
        </table>
      </TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <table class=ViewForm>
          <colgroup> <col width=120> <tbody> 
          <tr class=Title> 
            <th colspan=3>价格</th>
          </tr>
<TR><TD class=Line1 colSpan=3></TD></TR>
          <tr> 
            <td>币种</td>
            <td class=Field><BUTTON class=Browser 
            id=selectcurrency onClick="onShowCurrencyID()"></BUTTON> <SPAN <input class=InputStyle  
            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></SPAN> 
              <INPUT <input class=InputStyle  id=currencyid type=hidden value=2 name=currencyid value='<%=currencyid%>'>
            </td>
          </TR><tr><td class=Line colspan=3></td></tr>
          <tr> 
            <td>售价</td>
            <TD class=Field> 
              <INPUT <input class=InputStyle  id=salesprice size=14  name=salesprice value='<%=Util.toScreen(salesprice,user.getLanguage())%>'>
            </TD>
          </TR><tr><td class=Line colspan=3></td></tr>
          <tr> 
            <td>成本</td>
           <TD class=Field> 
              <INPUT <input class=InputStyle  id=CostPriceStandard size=14  name=costprice value='<%=Util.toScreen(costprice,user.getLanguage())%>'>
			</TD>
          </TR><tr><td class=Line colspan=3></td></tr>
          </tbody> 
        </table>
      </TD>
      <TD></TD>
    </TR>
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
<SCRIPT language=VBS>
sub onShowCountryID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	countryidspan.innerHtml = id(1)
	frmain.assetcountyid.value=id(0)
	else 
	countryidspan.innerHtml = ""
	frmain.assetcountyid.value="0" //"0" means global
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
	end if
	end if
end sub

sub onShowCurrencyID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		currencyidspan.innerHtml = id(1)
		frmain.currencyid.value=id(0)
		else
		currencyidspan.innerHtml = ""
		frmain.currencyid.value= ""
		end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"assetname"))
	{	
		document.frmain.isdefault.disabled = false;
		document.frmain.submit();
	}
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="deleteassetothercountry";
			document.frmain.submit();
		}
}

</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
