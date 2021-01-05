<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="LgcSearchComInfo" class="weaver.lgc.search.LgcSearchComInfo" scope="session" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String method=Util.null2String(request.getParameter("method"));
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);	
if(method.equals("empty"))
{
	LgcSearchComInfo.resetSearchInfo();
	mouldid=0;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE>
TABLE.PTable {
	WIDTH: 100%
}
TABLE.PTable TD.PLabel {
	WIDTH: 150px
}
</STYLE>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdLOGSearch_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(535,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid = user.getUID();

String hasassetmark ="";
String hasassetname  ="";
String hasassetcountry ="";
String hasassetassortment ="";
String hasassetstatus ="";
String hasassettype ="";
String hasassetversion ="";
String hasassetattribute ="";
String hasassetsalesprice ="";
String hasdepartment ="";
String hasresource ="";
String hascrm ="";

RecordSet.executeProc("LgcSearchDefine_SelectByID",""+userid);

if(RecordSet.next()){
       hasassetmark = RecordSet.getString("hasassetmark");
	   hasassetname = RecordSet.getString("hasassetname");
	   hasassetcountry = RecordSet.getString("hasassetcountry");
	   hasassetassortment = RecordSet.getString("hasassetassortment");
	   hasassetstatus = RecordSet.getString("hasassetstatus");
	   hasassettype = RecordSet.getString("hasassettype");
	   hasassetversion = RecordSet.getString("hasassetversion");
	   hasassetattribute = RecordSet.getString("hasassetattribute");
	   hasassetsalesprice = RecordSet.getString("hasassetsalesprice");
	   hasdepartment = RecordSet.getString("hasdepartment");
	   hasresource = RecordSet.getString("hasresource");
	   hascrm = RecordSet.getString("hascrm");
}


String assetmark ="";
String assetname ="";
String assetcountry ="";
String assetassortment ="";
String assetstatus ="";
String assettype ="";
String assetversion ="";
String assetattribute ="";		
String assetsalespricefrom ="";
String assetsalespriceto ="";
String departmentid ="";
String resourceid ="";
String crmid ="";	
	
RecordSet.executeProc("LgcSearchMould_SelectByMouldID",""+mouldid);
if(RecordSet.next()){		
	assetmark = Util.toScreenToEdit(RecordSet.getString("assetmark"),user.getLanguage());
	assetname   =Util.toScreenToEdit(RecordSet.getString("assetname"),user.getLanguage());
	assetcountry =Util.null2String(RecordSet.getString("assetcountry"));
	assetassortment =Util.null2String(RecordSet.getString("assetassortment"));
	assetstatus =Util.null2String(RecordSet.getString("assetstatus"));
	assettype = Util.null2String(RecordSet.getString("assettype"));
	assetversion = Util.toScreenToEdit(RecordSet.getString("assetversion"),user.getLanguage());
	assetattribute =Util.null2String(RecordSet.getString("assetattribute"));
	assetsalespricefrom =Util.null2String(RecordSet.getString("assetsalespricefrom"));
	assetsalespriceto =Util.null2String(RecordSet.getString("assetsalespriceto"));
	departmentid =Util.null2String(RecordSet.getString("departmentid"));
	resourceid =Util.null2String(RecordSet.getString("resourceid"));
	crmid =Util.null2String(RecordSet.getString("crmid"));
}
/*
else {
	 assetmark = Util.toScreenToEdit(LgcSearchComInfo.getAssetmark(),user.getLanguage());
	 assetname = Util.toScreenToEdit(LgcSearchComInfo.getAssetname(),user.getLanguage());
	 assetcountry = Util.null2String(LgcSearchComInfo.getAssetcountry());
	 assetassortment = Util.null2String(LgcSearchComInfo.getAssetassortment());
	 assetstatus =Util.null2String(RecordSet.getString("assetstatus"));
	 assettype = Util.null2String(LgcSearchComInfo.getAssettype());
	 assetversion = Util.toScreenToEdit(LgcSearchComInfo.getAssetversion(),user.getLanguage());
	 assetattribute = Util.null2String(LgcSearchComInfo.getAssetattribute());
	 assetsalespricefrom = Util.null2String(LgcSearchComInfo.getAssetsalespricefrom());
	 assetsalespriceto = Util.null2String(LgcSearchComInfo.getAssetsalespriceto());
	 departmentid = Util.null2String(LgcSearchComInfo.getDepartmentid());
	 resourceid = Util.null2String(LgcSearchComInfo.getResourceid());
	 crmid = Util.null2String(LgcSearchComInfo.getCrmid());
}
*/
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

<FORM name=frmmain id=weaver action=LgcSearchOperation.jsp method=post>
  <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TBODY> 
    <TR>
      <TD width="84%" valign="top">
      <div style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>      
      <BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
        <BUTTON class=btnReset accessKey=R type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:location.href='LgcSearch.jsp?method=empty',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
        <BUTTON class=btnReset id=Empty accessKey=E onclick="location.href='LgcSearch.jsp?method=empty'"><U>E</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",javascript:window.location='LgcSearchDefine.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}";
%>
        <BUTTON class=btnCustomize accessKey=C type=button onclick="window.location='LgcSearchDefine.jsp'"><U>C</U>-<%=SystemEnv.getHtmlLabelName(343,user.getLanguage())%></BUTTON> 
</div>
        <input type=hidden name=operation value="search">
		<input type="hidden" name="mouldid" value="<%=mouldid%>">
        <TABLE class=ViewForm cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD>
              <TABLE class=ViewForm>
                <!-- Section 1 -->
                <TBODY>
<tr><td class=Line1 colspan=2></td></tr>
				<%
				  if(hasassetmark.equals("1") && (mouldid==0||!(assetmark.equals("")))){
				%> 
                <TR> 
                  <TD class=PLabel>编号</TD>
                  <TD> 
                    <input class=InputStyle  size=25 name=assetmark  value="<%=assetmark%>">
                  </TD>
                </TR><td class=Line colspan=2></td></tr>
			    <%}%>
				<%
				  if(hasassetname.equals("1") && (mouldid==0||!(assetname.equals("")))){
				%> 
                <tr> 
                  <td class=PLabel>名称</td>
                  <td> 
                    <input class=InputStyle  size=25 name=assetname value="<%=assetname%>">
                  </td>
                </TR><tr><td class=Line colspan=2></td></tr>
			 	<%}%>
				<%
				  if(hasassetcountry.equals("1") && (mouldid==0||!(assetcountry.equals("")))){
				%> 
                <TR> 
                  <TD class=PLabel>国家</TD>
                  <TD><BUTTON class=Browser id=SelectCountryCode onclick="onShowCountryID(assetcountryspan,assetcountry)"></BUTTON> 
              <SPAN id=assetcountryspan><%=Util.toScreen(CountryComInfo.getCountrydesc(assetcountry),user.getLanguage())%></SPAN> 
              <input class=InputStyle  id=assetcountry type=hidden name=assetcountry value="<%=assetcountry%>"> </TD>
                </TR><tr><td class=Line colspan=2></td></tr>
				<%}%>
				<%
				  if(hasassetassortment.equals("1") && (mouldid==0||!(assetassortment.equals("")))){
				%> 
                <tr> 
                  <td class=PLabel>种类</td>
                  <td><button class=Browser id=SelectAssortment onClick="onShowAssortmentID(assortmentidspan,assetassortment)"></button> 
        <span class=InputStyle id=assortmentidspan><%=Util.toScreen(AssetAssortmentComInfo.getAssortmentMark(assetassortment),user.getLanguage())%>-<%=Util.toScreen(AssetAssortmentComInfo.getAssortmentName(assetassortment),user.getLanguage())%>
		</span> 
        <input class=InputStyle  id=assetassortment type=hidden name=assetassortment value="<%=assetassortment%>"> </td>
                </TR><tr><td class=Line colspan=2></td></tr>
				<%}%>
				<%
				  if(hasassetstatus.equals("1") && (mouldid==0||!(assetstatus.equals("")))){
				%> 
                <TR> 
                  <TD class=PLabel>状况</TD>
                  <TD> 
                    <select class=InputStyle  name="assetstatus">
                      <option value=""></option>
                      <option value="1" <%if(assetstatus.equals("1")) {%> selected <%}%>>活跃</option>
                      <option value="0" <%if(assetstatus.equals("0")) {%> selected <%}%>>不活跃</option>
                      <option value="2" <%if(assetstatus.equals("2")) {%> selected <%}%>>将来</option>
                    </select>
                  </TD>
                </TR><tr><td class=Line colspan=2></td></tr>
				<%}%>
				<%
				  if(hasassettype.equals("1") && (mouldid==0||!(assettype.equals("")))){
				%> 
                <tr> 
                  <td class=PLabel>类型</td>
                  <td><button class=Browser id=SelectAssetType onClick="onShowAssetType(assettypespan,assettype)"></button> 
        <span class=InputStyle id=assettypespan><%=Util.toScreen(AssetTypeComInfo.getAssetTypemark(assettype),user.getLanguage())%>-<%=Util.toScreen(AssetTypeComInfo.getAssetTypename(assettype),user.getLanguage())%>
		</span> 
        <input id=assettype type=hidden name=assettype value="<%=assettype%>"> </td>
                </TR><tr><td class=Line colspan=2></td></tr>
				<%}%>
				<%
				  if(hasassetversion.equals("1") && (mouldid==0||!(assetversion.equals("")))){
				%> 
                <tr> 
                  <td class=PLabel>版本</td>
                  <td> 
                    <input class=InputStyle  size=25 name=assetversion value="<%=assetversion%>">
                  </td>
                </TR><tr><td class=Line colspan=2></td></tr>
				<%}%>
               
		<%
		  if(hasassetattribute.equals("1") && (mouldid==0||!(assetattribute.equals("")))){
		%> 
        <TR class=Spacing>
          <TD class=Line1 colspan=2></TD></TR>
        <TR>
		<TD class=PLabel vAlign=top>属性</TD>
		<TD>
			<TABLE cellSpacing=0 cellPadding=0 width="100%">
			  <TBODY> 
			  <TR> 
				<TD>
				  <INPUT type=checkbox value=1 name=assetattribute <% if(assetattribute.indexOf("1|") >= 0) {%> checked <%}%>>
				  &nbsp;销售&nbsp;</TD>
				<TD>
				  <INPUT type=checkbox value=2 name=assetattribute <% if(assetattribute.indexOf("2|") >= 0) {%> checked <%}%>>
				  &nbsp;采购&nbsp;</TD>
				<TD>
				  <INPUT type=checkbox value=3 name=assetattribute <% if(assetattribute.indexOf("3|") >= 0) {%> checked <%}%>>
				  &nbsp;库存</TD>
				<TD>
				  <INPUT type=checkbox value=4 name=assetattribute <% if(assetattribute.indexOf("4|") >= 0) {%> checked <%}%>>
				  &nbsp;网上销售</TD>
			  </TR><tr><td class=Line colspan=2></td></tr>
			  <TR> 
				<TD>
				  <INPUT type=checkbox value=5 name=assetattribute <% if(assetattribute.indexOf("5|") >= 0) {%> checked <%}%>>
				  &nbsp;批号</TD>
				<TD>&nbsp;</TD>
				<TD>&nbsp;</TD>
				<TD>&nbsp;</TD>
			  </TR><tr><td class=Line colspan=2></td></tr>
			  
			  </TBODY>
			</TABLE>
		  </TD>
		</TR>
        <%}%>
		<%
		  if(hasassetsalesprice.equals("1") && (mouldid==0||!(assetsalespricefrom.equals("")) ||!(assetsalespriceto.equals("")))){
		%> 
        <TR>
		<TD class=PLabel>销售价</TD>
		<TD><input class=InputStyle  size=8 name=assetsalespricefrom onBlur='checknumber("assetsalespricefrom")' value="<%=assetsalespricefrom%>">
		  &nbsp;-&nbsp;<input class=InputStyle  size=8 name=assetsalespriceto onBlur='checknumber("assetsalespriceto")' value="<%=assetsalespriceto%>">
		   </TD>
		</TR><tr><td class=Line colspan=2></td></tr>
		<%}%>
			  <%
				  if(hasdepartment.equals("1") && (mouldid==0||!(departmentid.equals("")))){
			  %> 
                      <TR> 
                        <TD class=PLabel>部门</TD>
                        <TD><button class=Browser id=SelectDeparment onClick="onShowDepartment(departmentspan,departmentid)"></button> 
              <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
              <input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
                        </TD>
                      </TR><tr><td class=Line colspan=2></td></tr>
					  <%}%>
					<%
					  if(hasresource.equals("1") && (mouldid==0||!(resourceid.equals("")))){
					%> 
                      <TR> 
                        <TD class=PLabel>人力资源</TD>
                        <TD><BUTTON class=Browser id=SelectManagerID onClick="onShowResourceID(resourceidspan,resourceid)"></BUTTON> 
						<span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span> 
              <INPUT id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
                        </TD>
                      </TR><tr><td class=Line colspan=2></td></tr>
					  <%}%>
					<%
					  if(hascrm.equals("1") && (mouldid==0||!(crmid.equals("")))){
					%> 
                      <TR> 
                        <TD class=PLabel>CRM</TD>
                        <TD><button class=Browser id=SelectCrm onClick="onShowCrmID(crmidspan,crmid)"></button> 
        <span class=InputStyle id=crmidspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></span> 
        <input type=hidden id=crmid name=crmid value="<%=crmid%>">
                        </TD>
                      </TR><tr><td class=Line colspan=2></td></tr>
					  <%}%>
        <TR>
			<TD class=PLabel>排序依据</TD>
			<TD>
			  <select class=InputStyle  style="WIDTH: 98%" name=orderby>
				<OPTION value=assetmark>编号</OPTION>
				<OPTION value=assetname>名称</OPTION>
				<OPTION value=createdate>创建日期</OPTION>
				<OPTION value=lastmoddate>修改日期</OPTION>
			  </SELECT>
			</TD>
         </TR><tr><td class=Line colspan=2></td></tr>
     </TBODY></TABLE></TBODY></TABLE>
        <!-- Columns -->
      </TD>
    <TD vAlign=top width="16%">
      <TABLE class=ListStyle cellspacing=1>
        <TBODY>
        <TR class=header align=Center>
          <Td>搜索</Td></TR><TR class=Line><TD colSpan=1></TD></TR>
        <TR class=DataLight>
          <TD><A 
            href="#">翻译</A></TD></TR>
        <TR class=DataDark>
        <TD><A 
        href="#">合同</A></TD></TR>
        <TR class=DataLight>
          <TD><A href="#">序号</A></TD></TR>
        <TR>
          <TD>&nbsp;</TD></TR>
        <TR>
          <TH><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH></TR>
        <TR class=DataLight>
          <TD><a href="LgcSearch.jsp?mouldid=0"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></a></TD></TR>
        <TR>
          <% 
        int i=0;
        RecordSet.executeProc("LgcSearchMould_SelectByUserID",""+userid);
	while(RecordSet.next()){
        	if(i==0){%><TR class=DataDark><%i=1;}
        	else{%><TR class=DataLight><%i=0;}%>
          <td><a href="LgcSearch.jsp?mouldid=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></td>
        </TR>
        <%}
        if(mouldid==0){%>
        <TR>
          <TD align=center>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
            <BUTTON class=btnSave accessKey=2 style="display:none"  onClick="onSaveas()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%></BUTTON></TD>
        </TR>
		<TR id=oTrname style="display:none">
          <TD><font color=red><%=SystemEnv.getHtmlLabelName(554,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></font></TD>
        </TR>
        <TR>
          <TD><input class=InputStyle  type="text" name="mouldname" value=""></TD>
        </TR>
        <%}
        else{%>
        <tr>
          <td align=center>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>            
        <BUTTON class=btnSave accessKey=S  style="display:none"  onClick="onSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON></td>
        </tr>
        <tr>
          <td align=center>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:weaver.Delete.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>              
        <BUTTON class=btnDelete accessKey=D id=Delete  style="display:none"  onClick="if(isdel()){onDelete();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON></td>
        </tr>
        <%}%> 
		  
		  </TBODY></TABLE></TD></TR></TBODY></TABLE></FORM>

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
<script language=javascript>
function checkNewmould(){
	if(document.frmmain.mouldname.value==''){
		oTrname.style.display='';
		return false;
		}
	return true;
}
function onSaveas(){
	if(checkNewmould()){
	document.frmmain.operation.value="addmould";
	document.frmmain.submit();
	}
}        
function onSave(){
	document.frmmain.operation.value="updatemould";
	document.frmmain.submit();
}
function onDelete(){
	document.frmmain.operation.value="deletemould";
	document.frmmain.submit();
}
</script>

<SCRIPT language=VBS>
sub onShowCountryID(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowAssortmentID(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp ")
	if NOT isempty(id) then
	    if id(0)<> "" then
			spanname.innerHtml = id(1)
			inputname.value=id(0)
		else
			spanname.innerHtml = ""
			inputname.value=""
		end if
	end if
end sub

sub onShowAssetType(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetTypeBrowser.jsp ")
	if NOT isempty(id) then
	    if id(0)<> "" then
			spanname.innerHtml = id(1)
			inputname.value=id(0)
		else
			spanname.innerHtml = ""
			inputname.value=""
		end if
	end if
end sub

sub onShowDepartment(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowResourceID(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowCrmID(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
	else 
		spanname.innerHtml = ""
		inputname.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY></HTML>
