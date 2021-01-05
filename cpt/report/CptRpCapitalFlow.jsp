<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String isfromProjTab = Util.null2String(request.getParameter("isfromCptTab"));
String querystr=request.getQueryString();
String url="/cpt/report/CptRpCapitalFlow.jsp?isfromCptTab=1";
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
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelName(1501,user.getLanguage()) %>");
	}catch(e){}
});
</script>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(datasql){
    var ajax=ajaxinit();
    ajax.open("POST", "CptRpCapitalFlowData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("datasql="+encodeURIComponent(datasql)+"&Language=<%=user.getLanguage()%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("showdatadiv").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
function expExcel(){
	$("#ExcelOut").attr("src","/weaver/weaver.file.ExcelOut");
	//window.location.href="/weaver/weaver.file.ExcelOut";
}

</script>
</head>
<%
String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql = "select resourceid from HrmRoleMembers where resourceid>=1 and roleid in (select roleid from SystemRightRoles where rightid=162)";
RecordSet.executeSql(tempsql);
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
		break;
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
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("cptdetachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID

if(subcompanyid1.equals("") && detachable==1)
{
	String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing style='height: 1px;'><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
	if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
	else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
	out.println(s);
	return;
}

String isrefresh = Util.null2String(request.getParameter("isrefresh"));

int TotalCount = Util.getIntValue(request.getParameter("TotalCount"),0);

String sql="";
String capitalgroupid=Util.null2String(request.getParameter("capitalgroupid"));
String capitalid = Util.null2String(request.getParameter("capitalid"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere1"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
//System.out.println("subcompanyid============================="+subcompanyid);
String resourceid = Util.null2String(request.getParameter("resourceid"));
String status = Util.null2String(request.getParameter("status"));
String location = Util.null2String(request.getParameter("location"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));


//分页相关
//int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
//if(perpage<=1 )	perpage=10;
//
//String temptable = "cpttemptable"+ Util.getRandom() ;

if(! sqlwhere1.equals("")) {
	sql = sqlwhere1 ;
}

if(! departmentid.equals("")) {
	sql += " and t1.usedeptid = " + departmentid ;
}

if(! subcompanyid.equals("")){
	sql += " and t2.blongsubcompany in ("+subcompanyid + ")";
}

if(! resourceid.equals("")) {
	sql += " and t1.useresourceid = " + resourceid ;
}

if(! status.equals("")) {
	sql += " and t1.usestatus = " + status ;
}

if(! location.equals("")) {
	sql += " and t1.useaddress like '%" + location +"%'";
}

if(! fromdate.equals("")) {
	sql += " and t1.usedate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	sql += " and t1.usedate <= '" + todate + "' " ;
}

if(! capitalid.equals("")) {
	sql += " and t1.capitalid = " + capitalid ;
}

if(!capitalgroupid.equals("")){
    sql+=" and t2.capitalgroupid in ("
                 +" select id from CptCapitalAssortment where (supassortmentstr like '%|"+capitalgroupid+"|%' )"
                                                        +" or ( id = " + capitalgroupid + ")"
                 +")";
}


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1501,user.getLanguage());
String needfav ="1";
String needhelp ="";

String browserUrl="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!isrefresh.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onResearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("17416",user.getLanguage())+"Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmain action="CptRpCapitalFlow.jsp?isfromCptTab=1&isrefresh=1" method=post>
<input type="hidden" id=sqlwhere1 name="sqlwhere1" value="<%=xssUtil.put(sqlwhere1)%>">
<input type="hidden" id=subcompanyid1 name="subcompanyid1" value="<%=subcompanyid1%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
<%
if(!isrefresh.equals("1")){
	%>
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="submitData();" />
	<%
}else{
	%>
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("364",user.getLanguage())%>" onclick="onResearch();" />
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("17416",user.getLanguage()) %>Excel" onclick="expExcel();" />
	<%
}
%>
			<span id="advancedSearch" class="advancedSearch" style="display:<%=!"1".equals(isrefresh)?"none;":"" %>;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
if("1".equals(isrefresh)){
%><div class="advancedSearchDiv" id="advancedSearchDiv" style="display:;" >
<%
}else{
%><div id="searchinfo" style="display:">
<%
}
%>



<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="capitalid" 
					browserValue='<%= ""+capitalid %>'  
					browserSpanValue='<%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?inculdeNumZero=1"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=23" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="capitalgroupid" 
					browserValue='<%= ""+capitalgroupid %>'  
					browserSpanValue='<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=25" />
		</wea:item>
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
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="subcompanyid" 
					browserValue='<%= ""+subcompanyid %>'  
					browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getMoreSubCompanyname(subcompanyid),user.getLanguage())%>'
					browserUrl='<%=subcompanybrowserurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=164" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="departmentid" 
					browserValue='<%=departmentid%>'  
					browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>'
					browserUrl='<%=departmentbrowserurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=4" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="resourceid" 
					browserValue='<%=resourceid %>'  
					browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>'
					browserUrl='<%=resourcebrowserurl %>'
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></wea:item>
		<wea:item><input name=location class="InputStyle" value=<%=location%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="status" 
					browserValue='<%=status %>'  
					browserSpanValue='<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(status),user.getLanguage())%>'
					browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=243" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="selectstartdate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate %>">
			    <input class=wuiDateSel  type="hidden" name="todate" value="<%=todate %>">
			</span>
		</wea:item>
	</wea:group>
<%
if("1".equals(isrefresh)){
%>
    <wea:group context="">
        <wea:item type="toolbar">
            <input class="zd_btn_submit" type="button" name="search" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
            <input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
            <input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
        </wea:item>
    </wea:group>
<%
}
%>


</wea:layout>	
</div>
			<% if(isrefresh.equals("1")){%>
			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <COL width="11%">
			  <COL width="13%">
			  <COL width="10%">
			  <COL width="10%">
			  <COL width="11%">
			  <COL width="11%">
			  <COL width="11%">
			  <COL width="11%">
			  <COL width="12%">
			  <TBODY>
			  <%--
			  <TR class=header>
				<TH colSpan=9><%=SystemEnv.getHtmlLabelName(1501,user.getLanguage())%></TH>
			  </TR>
			  --%>
			<%
			 ExcelSheet es = new ExcelSheet() ;
			 ExcelRow er = es.newExcelRow () ;

			 er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(195,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1394,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1434,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1435,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1436,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1380,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(22562,user.getLanguage())) ;
			 er.addStringValue(SystemEnv.getHtmlLabelName(1380,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())) ;

			 es.addExcelRow(er) ;

            sql = "select t1.*,t2.startprice,t2.sptcount,t2.mark from CptUseLog t1,CptCapital t2 where t1.capitalid = t2.id"+sql+" order by t2.mark ,t1.id";
			%>
			<TR><TD colSpan=9>
				<div id="showdatadiv" style="margin-left:-10px!important;margin-right:-5px!important;"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
					<script>showdata("<%=xssUtil.put(sql)%>");</script>
				</div>
			</TD></TR>
			<%
			rs.executeSql(sql);
			//out.println("sql:"+sql);
			int needchange = 0;
			double usecountall = 0;
			double feeall = 0;
				while(rs.next()){
					int  id = rs.getInt("id");
					
					String	tempcapitalid=Util.toScreen(rs.getString("capitalid"),user.getLanguage());
					String	usedate=Util.toScreen(rs.getString("usedate"),user.getLanguage());
					String	olddeptid=rs.getString("olddeptid");
					String	usedeptid=rs.getString("usedeptid");
					String  useresourceid = rs.getString("useresourceid");
					String  usestatus = rs.getString("usestatus");
					String  usecount = Util.toScreen(rs.getString("usecount"),user.getLanguage());
					String  useaddress = Util.toScreen(rs.getString("useaddress"),user.getLanguage());
					String  fee = Util.toScreen(rs.getString("fee"),user.getLanguage());
					String  mark = rs.getString("mark");
                    String	sptcount=rs.getString("sptcount");
                    double	startprice=Util.getDoubleValue( rs.getString("startprice"),0);
                    if(!"1".equals(sptcount)){
                        if( "2".equals(usestatus)||"3".equals(usestatus)||"-4".equals(usestatus)){
                            fee=""+(startprice*Util.getDoubleValue( usecount,0));
                        }
                    }

					usecountall += Util.getDoubleValue(usecount,0);
					feeall += Util.getDoubleValue(fee,0);
				   try{
			
				 er = es.newExcelRow () ;
				 er.addStringValue(Util.toScreen(CapitalComInfo.getMark(tempcapitalid),user.getLanguage())) ;
				 er.addStringValue(Util.toScreen(CapitalComInfo.getCapitalname(tempcapitalid),user.getLanguage())) ;
				 er.addStringValue(usedate) ;
				 er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(olddeptid),user.getLanguage())) ;
				 er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())) ;
				 er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())) ;
				 er.addStringValue(CapitalStateComInfo.getCapitalStatename(usestatus)) ;
				 er.addValue(usecount) ; 
				 er.addValue(fee) ; 

				 es.addExcelRow(er) ;

			 // if(hasNextPage){
			//		totalline+=1;
			//		if(totalline>perpage)	break;
			//	 }
				  }catch(Exception e){
					//System.out.println(e.toString());
				  }
				};
			// rs.executeSql("drop table "+temptable);
			%>  
			
			 </TBODY></TABLE>
			<% 
			 ExcelFile.init() ;
			 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(1501,user.getLanguage())) ;
			 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(1501,user.getLanguage()), es) ;
			}//end of judge if it is first in 
			%>

</FORM>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
function check(object){

   if(object=='undefined')  return false;
   else return true;
}
</script>
 <script language=vbs>
sub onShowCapitalgroupid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and check(id(1)) then
	capitalgroupidspan.innerHtml = id(1)
	frmain.capitalgroupid.value=id(0)
	else
	capitalgroupidspan.innerHtml = ""
	frmain.capitalgroupid.value=""
	end if
	end if
end sub

sub onShowResourceID()
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	else 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowserByRight.jsp?rightStr=<%=rightStr%>")
	end if
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


 sub onShowDepartmentID()
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
	departmentidspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowStateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	stateidspan.innerHtml = id(1)
	frmain.status.value=id(0)
	else
	stateidspan.innerHtml = ""
	frmain.status.value=""
	end if
	end if
end sub

sub onShowCapitalID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?inculdeNumZero=1")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	capitalidspan.innerHtml = id(1)
	frmain.capitalid.value=id(0)
	else 
	capitalidspan.innerHtml = ""
	frmain.capitalid.value=""
	end if
	end if
end sub
</script>
<script language="javascript">
function submitData()
{
	frmain.submit();
}
function onResearch(){
	location.href="/cpt/report/CptRpCapitalFlow.jsp?isfromCptTab=1&subcompanyid1=<%=subcompanyid%>";
}
function onBtnSearchClick(){
}
$(function(){
    try{
        $("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
    }catch(e){}

});
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
