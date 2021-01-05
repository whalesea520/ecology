<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAssetAddOtherCountry:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;

String assortmentid =Util.null2String(AssetComInfo.getAssortmentId(assetid)) ;
String assetmark = Util.toScreen(AssetComInfo.getAssetMark(assetid),user.getLanguage());

RecordSet.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSet.next();
String assortmentname = Util.toScreen(RecordSet.getString("assortmentname"),user.getLanguage());


RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);


String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage())+"-"+assortmentname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
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
  <DIV><BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-保存</BUTTON> </DIV>
	
<input type="hidden" name="assetid" value="<%=assetid%>">
<input type="hidden" name="operation" value="addassetothercountry">

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
          </tr>
          <tr> 
            <td>名称</td>
            <td class=FIELD> 
              <input accesskey=Z name=assetname size="30" onChange='checkinput("assetname","assetnameimage")'>
              <span id=assetnameimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span> 
            </td>
          </tr>
          <tr> 
            <td>国家</td>
            <td class=Field id=txtLocation> <button class=Browser id=SelectCountryID onClick="onShowCountryID()"></button> 
              <span id=countryidspan style="width:40%"></span> 
              <input id=assetcountyid type=hidden name=assetcountyid>
            </td>
          </tr>
          <tr>
            <td>默认</td>
            <td class=Field>
              <input type=checkbox  name="isdefault" value="1">
            </td>
          </tr>
          <tr> 
            <td>生效日</td>
            <td class=Field><button class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
              <span id=startdatespan ></span> 
              <input type="hidden" name="startdate">
            </td>
          </tr>
          <tr> 
            <td>生效至</td>
            <td class=Field><button class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
              <span id=enddatespan ></span> 
              <input type="hidden" name="enddate">
            </td>
          </tr>
          <tr> 
            <td>部门</td>
            <td class=Field colspan=2> <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span <input class=InputStyle  id=departmentspan></span> 
              <input id=departmentid type=hidden name=departmentid>
            </td>
          </tr>
          <tr> 
            <td>人力资源</td>
            <td class=Field> <button class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
              <span id=resourceidspan></span> 
              <input <input class=InputStyle  type=hidden name=resourceid>
            </td>
          </tr>
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
          <tr class=Spacing> 
            <td class=sep2></td>
          </tr>
          <tr> 
            <td valign=top> 
              <textarea <input class=InputStyle  style="WIDTH: 100%" name=assetremark rows=8></textarea>
            </td>
          </tr>
          </tbody> 
        </table>
        <table class=ViewForm>
          <colgroup> <col width=120> <tbody> 
          <tr class=Title> 
            <th colspan=2>空闲字段</th>
          </tr>
          <tr class=Spacing> 
            <td class=Line1 colspan=2></td>
          </tr>
          <%
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+11).equals("1"))
		{%>
          <tr> 
            <td><%=Util.toScreen(RecordSet.getString(i*2+10),user.getLanguage())%></td>
            <td class=Field> <button class=Calendar onClick="getdate(<%=i%>)"></button> 
              <span id=datespan<%=i%> ></span> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
            </td>
          </tr>
          <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+21).equals("1"))
		{%>
          <tr> 
            <td><%=RecordSet.getString(i*2+20)%></td>
            <td class=Field> 
              <input <input class=InputStyle  maxlength=30 name="nff0<%=i%>" value="0.0" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff0<%=i%>")'  style="width:95%">
            </td>
          </tr>
          <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+31).equals("1"))
		{%>
          <tr> 
            <td><%=RecordSet.getString(i*2+30)%></td>
            <td class=Field> 
              <input <input class=InputStyle  maxlength=100 name="tff0<%=i%>" style="width:95%">
            </td>
          </tr>
          <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+41).equals("1"))
		{%>
          <tr> 
            <td><%=RecordSet.getString(i*2+40)%></td>
            <td class=Field> 
              <input type=checkbox  name="bff0<%=i%>" value="1">
            </td>
          </tr>
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
          <tr class=Spacing> 
            <td class=sep2 colspan=3></td>
          </tr>
          <tr> 
            <td>币种</td>
            <td class=Field><button class=Browser 
            id=selectcurrency onClick="onShowCurrencyID()"></button> <span <input class=InputStyle  
            id=currencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></span> 
              <input <input class=InputStyle  id=currencyid type=hidden value=<%=defcurrenyid%> name=currencyid>
            </td>
          </tr>
          <tr> 
            <td>售价</td>
            <td class=Field> 
              <input <input class=InputStyle  id=salesprice size=14 value=0.00 name=salesprice>
            </td>
          </tr>
          <tr> 
            <td>成本</td>
            <td class=Field> 
              <input <input class=InputStyle  id=CostPriceStandard size=14 value=0.00 name=costprice>
            </td>
          </tr>
          </tbody> 
        </table>
      </TD>
      <TD></TD>
    </TR>
    </TBODY> 
  </TABLE>
</FORM>
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
		document.frmain.submit();
	}
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
