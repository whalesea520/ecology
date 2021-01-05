<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
String isfromProjTab = Util.null2String(request.getParameter("isfromCptTab"));
String querystr=request.getQueryString();
String url="/cpt/report/CptRpCapital.jsp?isfromCptTab=1";
if(!"1".equals(isfromProjTab)){
	response.sendRedirect("/cpt/capital/CapitalBlankTab.jsp"+"?url="+url);
	return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/cpt/js/common_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	onSearch();
}
$(function(){
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(1439,user.getLanguage()) %>");
	}catch(e){}
});
</script>
</head>
<%
String userid =""+user.getUID();
/*权限判断,资产管理员以及其所有上级
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where resourceid>=1 and roleid in (select roleid from SystemRightRoles where rightid=161)";
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
权限判断结束*/
String rightStr= "";
if(!HrmUserVarify.checkUserRight("CptRpCapital:Display", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}else{
	rightStr="CptRpCapital:Display";
}
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(535,user.getLanguage());
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("cptdetachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID

if(subcompanyid1.equals("") && detachable==1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}

String browserUrl="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM action=CptSearch.jsp method=post name=frmain>
<input type="hidden" name="operation">
<input type="hidden" name="isdata" value="2">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="onSearch();" />
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" ></div>

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle maxlength=60 size=30 name="mark"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle maxlength=60 name="name" size=30></wea:item>
<%
String subcompanybrowserurl="";
String departmentbrowserurl="";
String resourcebrowserurl="";
if(detachable == 1){
	subcompanybrowserurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?rightStr="+rightStr+"&selectedids="+subcompanyid1;
	departmentbrowserurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr="+rightStr;
	resourcebrowserurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr="+rightStr;
}else{
	subcompanybrowserurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+subcompanyid1;
	departmentbrowserurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
	resourcebrowserurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
}
%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="blongsubcompany" 
					browserValue='<%= ""+subcompanyid1 %>'  
					browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1))%>'
					browserUrl='<%=subcompanybrowserurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=164" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="departmentid" 
					browserValue=""  
					browserSpanValue=""
					browserUrl='<%=departmentbrowserurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=4" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="resourceid" 
					browserValue=""  
					browserSpanValue=""
					browserUrl='<%=resourcebrowserurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="stateid" 
					browserValue=""  
					browserSpanValue=""
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=243" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="capitalgroupid" 
					browserValue=""  
					browserSpanValue=""
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=25" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="capitaltypeid" 
					browserValue=""  
					browserSpanValue=""
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=242" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="selectstartdate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="startdate" value="">
			    <input class=wuiDateSel  type="hidden" name="startdate1" value="">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="selectenddate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="enddate" value="">
			    <input class=wuiDateSel  type="hidden" name="enddate1" value="">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="stockindate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="stockindate" value="">
			    <input class=wuiDateSel  type="hidden" name="stockindate1" value="">
			</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle id=isinner name=isinner>
			  <option value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			  <option value=0 ><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
			  <option value=1 ><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
			</select>
		</wea:item>
		
	</wea:group>
</wea:layout>


</FORM>
<SCRIPT language=javascript>
function onSearch(){
	document.frmain.action="../search/SearchOperation.jsp?from=report";
	frmain.submit();
}
</SCRIPT>
<SCRIPT language=VBS>
sub onShowResourceID()
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
	end if
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
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
	if id(0)<> "" then
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

sub onShowSubcompany(tdname,inputename)
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&document.all(inputename).value)
	if NOT isempty(id) then
	    if id(0)<> "" then        
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        document.all(inputename).value = resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
           
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        document.all(tdname).innerHtml = sHtml
        <%--
        document.all(tdname).innerHtml ="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+id(0)+"'>"+ id(1)+"</a>"
        document.all(inputename).value=id(0)
        --%>
        else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value=""
        end if
	end if
end sub


sub onShowSubcompany1(tdname,inputename,rightStr)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp?selectedids="&document.all(inputename).value&"&rightStr="&rightStr)
	if NOT isempty(id) then
	        if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		document.all(inputename).value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&curname&"&nbsp"
		wend
		sHtml = sHtml&resourcename&"&nbsp"
		document.all(tdname).innerHtml = sHtml
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

sub onShowDepartment1()
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="&frmain.departmentid.value)
end if
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
