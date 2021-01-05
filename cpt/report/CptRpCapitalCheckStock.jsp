<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}

if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(915,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<FORM method=post name=frmain>
  <TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
    <TBODY> 
    <TR> 
 <TD vAlign=top>
 <BUTTON class=btnSearch accessKey=S onClick="onSearch()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON> 
 <BUTTON class=btnReset accessKey=R type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON> 
        <input type="hidden" name="operation">
        <input type="hidden" name="isdata" value="2">
        <TABLE class=Form width="414">
          <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
          <TR> 
            <TD vAlign=top> 
              <TABLE width="100%">
                <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
                <TR class=Section> 
                  <TH colSpan=2>&nbsp;</TH>
                </TR>
                <TR class=Separator> 
                  <TD class=Sep1 colSpan=2></TD>
                </TR>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
                  <td class=Field> 
                    <input class=saveHistory maxlength=60 size=30 name="mark">
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
                  <td class=Field> 
                    <input class=saveHistory maxlength=60 name="name" size=30>
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
                  <td class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
                    <span class=saveHistory id=departmentspan></span> 
                    <input id=departmentid type=hidden name=departmentid>
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
                  <td class=Field><button class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
                    <span 
            id=resourceidspan></span> 
                    <input class=saveHistory id=resourceid type=hidden name=resourceid >
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
                  <td class=Field> <button class=Browser onClick="onShowStateid()"></button> 
                    <span id=stateidspan></span> 
                    <input type=hidden name=stateid>
                  </td>
                </tr>
                </TBODY> 
              </TABLE>
            </TD>
            <TD vAlign=top> 
              <TABLE width="100%">
                <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
                <TR class=Section> 
                  <TH colSpan=2>&nbsp;</TH>
                </TR>
                <TR class=Separator> 
                  <TD class=Sep1 colSpan=2></TD>
                </TR>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
                  <td class=Field><button class=Calendar id=selectstartdate onClick="getDate(startdatespan,startdate)"></button> 
                    <span id=startdatespan ></span> 
                    <input type="hidden" name="startdate" >
                    - <button class=Calendar id=selectstartdate1 onClick="getDate(startdate1span,startdate1)"></button> 
                    <span id=startdate1span ></span> 
                    <input type="hidden" name="startdate1">
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
                  <td class=Field><button class=Calendar id=selectenddate onClick="getDate(enddatespan,enddate)"></button> 
                    <span id=enddatespan ></span> 
                    <input type="hidden" name="enddate" >
                    -<button class=Calendar id=selectenddate1 onClick="getDate(enddate1span,enddate1)"></button> 
                    <span id=enddate1span ></span> 
                    <input type="hidden" name="enddate1">
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
                  <td class=Field> <button class=Browser onClick="onShowCapitalgroupid()"></button> 
                    <span id=capitalgroupidspan></span> 
                    <input type=hidden name=capitalgroupid>
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></td>
                  <td class=Field> 
                    <select class=saveHistory id=isinner name=isinner>
                      <option value=0 selected></option>
                      <option value=1 ><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
                      <option value=2 ><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
                  <td class=Field> 
				   <button class=Browser onClick="onShowCapitaltypeid()"></button> 
		             <span id=capitaltypeidspan></span> 
		           <input type=hidden name=capitaltypeid>

                  </td>
                </tr>
                </TBODY> 
              </TABLE>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    </TBODY>
  </TABLE>
</FORM>
<SCRIPT language=javascript>
function onSearch(){
	document.frmain.action="../search/SearchOperation.jsp?from=checkstock";
	frmain.submit();
}
</SCRIPT>
<SCRIPT language=VBS>
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

sub onShowCustomerid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	customeridspan.innerHtml = id(1)
	frmain.customerid.value=id(0)
	else
	customeridspan.innerHtml = ""
	frmain.customerid.value=""
	end if
	end if
end sub

sub onShowStateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	Stateidspan.innerHtml = id(1)
	frmain.Stateid.value=id(0)
	else
	Stateidspan.innerHtml = ""
	frmain.Stateid.value=""
	end if
	end if
end sub

sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	capitalgroupidspan.innerHtml = id(1)
	frmain.capitalgroupid.value=id(0)
	else
	capitalgroupidspan.innerHtml = ""
	frmain.capitalgroupid.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowCapitaltypeid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	capitaltypeidspan.innerHtml = id(1)
	frmain.capitaltypeid.value=id(0)
	else
	capitaltypeidspan.innerHtml = ""
	frmain.capitaltypeid.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
