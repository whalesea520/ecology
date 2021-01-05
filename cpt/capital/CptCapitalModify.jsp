
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:modify", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}else{
	rightStr = "CptCapital:modify";
	session.setAttribute("cptuser",rightStr);
}
String CurrentUser = ""+user.getUID();

String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;
String	departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());/*部门*/
if (departmentid.equals("0")){ departmentid="";}
String	resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
if (resourceid.equals("0")){ resourceid="";}
String  mark = Util.fromScreen(request.getParameter("mark"),user.getLanguage()) ;				/*编号*/
mark=mark.trim();

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID
String from = Util.null2String(request.getParameter("from"));
if(subcompanyid1.equals("") && !from.equals("location") && !from.equals("search") && detachable==1 )
{
	String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing style=\"height:1px;\"><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}


String  enddate = Util.fromScreen(request.getParameter("enddate"),user.getLanguage()) ;				//生效至  开始日期
String  enddate1  = Util.fromScreen(request.getParameter("enddate1"),user.getLanguage()) ;				//生效至  结束日期
String	belongdepartmentid = Util.fromScreen(request.getParameter("belongdepartmentid"),user.getLanguage());/*部门*/


if(!from.equals("1")){
// added by lupeng 2004-07-27 for TD590
CptSearchComInfo.resetSearchInfo();
CptSearchComInfo.setIsData("2");
CptSearchComInfo.setDepartmentid(departmentid);
CptSearchComInfo.setMark(mark);
CptSearchComInfo.setResourceid(resourceid);
CptSearchComInfo.setBlongdepartment(belongdepartmentid);
if(detachable == 1){
	CptSearchComInfo.setCapblsubid(subcompanyid1);
}

CptSearchComInfo.setEnddate(enddate);
CptSearchComInfo.setEnddate1(enddate1);
// end.
}
//添加判断权限的内容--new
//String TableName = "";
String tempsearchsql = CptSearchComInfo.FormatSQLSearch();

String titlename = "";
String imagefilename = "/images/hdHRMCard_wev8.gif";
titlename = SystemEnv.getHtmlLabelName(6055,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",/cpt/search/CptSearch.jsp?from=cptmodify,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",javascript:redirectPage(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(883,user.getLanguage())+",javascript:redirectPage(2),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6051,user.getLanguage())+",javascript:redirectPage(3),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6054,user.getLanguage())+",javascript:redirectPage(4),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6052,user.getLanguage())+",javascript:redirectPage(5),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(22459,user.getLanguage())+",javascript:redirectPage(6),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6055,user.getLanguage())+",/cpt/capital/CptCapitalModifyOperation.jsp?isdata=2,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",javascript:redirectPage(7),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15306,user.getLanguage())+",javascript:redirectPage(8),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15307,user.getLanguage())+",javascript:redirectPage(9),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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

			<TABLE class=ViewForm>	
			<FORM name=frmain id=frmain action="CptCapitalModify.jsp" method=get>
			<input class=inputstyle type="hidden" name="subcompanyid1" value="<%=subcompanyid1%>">
			<input class=inputstyle type="hidden" name="from">
			 <COLGROUP>
			  <COL width="5%">
			  <COL width="20%">
			  <COL width="5%">
			  <COL width="20%">
			  <COL width="5%">
			  <COL width="20%">
			  <COL width="5%">
			  <COL width="20%">
			 <tr> 
						<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
						<td class=Field><input class=InputStyle maxlength=60 name="mark" size=20 value="<%=mark%>">
						<input type = "hidden" class=InputStyle name="isdata" value = "2">
						</td>
						<td><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></td>
						 <td class=field><button type=button  class=browser onClick="onShowResource()"></button>
						  <input type=hidden name=resourceid value="<%=resourceid%>"><span id=viewerspan><%if(!resourceid.equals("")){%><A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=ResourceComInfo.getLastname(resourceid)%></a><%}%></span>
						 </td>
						 <td><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></td>
					  <TD class=Field><button type=button  class=Browser id=SelDeparment onClick="ShowDeparment()" ></button> 
					   <input id=departmentid type=hidden name="departmentid" value="<%=departmentid%>"><span id=FromDeparment><%if(!departmentid.equals("")){%><A href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=DepartmentComInfo.getDepartmentname(departmentid)%></a><%}%></span></TD>
						<td><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></td>
						 <td class=field>
						    <button type=button  class=Calendar id=selectenddate onClick="getDate(enddateSpan,enddate)"></button> 
						    <span id=enddateSpan ><%=enddate%></span> 
						    <input type="hidden" name="enddate" value="<%=enddate%>">
						    -<button type=button  class=Calendar id=selectenddate1 onClick="getDate(enddate1Span,enddate1)"></button> 
						    <span id=enddate1Span ><%=enddate1%></span> 
						    <input type="hidden" name="enddate1" value="<%=enddate1%>">
						 </td>
			 </tr>
			 <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR> 
			 <tr> 
				<td><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></td>
				<TD class=Field><button type=button  class=Browser id=SelDeparment onClick="ShowBelongDeparment('belongdepartmentid', 'FromBelongDeparment')" ></button> 
				<input id=belongdepartmentid type=hidden name="belongdepartmentid" value="<%=belongdepartmentid%>"><span id=FromBelongDeparment><%if(!belongdepartmentid.equals("")){%><A href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=belongdepartmentid%>"><%=DepartmentComInfo.getDepartmentname(belongdepartmentid)%></a><%}%></span></TD>
			 </tr>
			 <TR style="height:1px;"><TD class=Line colSpan=8></TD></TR> 
			 </FORM>
			</TABLE>
            <%
                        String backfields = "t1.id,t1.mark,t1.name,t1.fnamark,t1.capitalspec,t1.capitalgroupid,t1.blongsubcompany,t1.resourceid,t1.departmentid,t1.stateid";
                        String fromSql  = "";
                        String sqlWhere = "";
                        fromSql  = " from CptCapital  t1  , CptShareDetail  t2 ";
                        if(null != tempsearchsql && !"".equals(tempsearchsql))
                        {
                            sqlWhere = tempsearchsql + " and t1.id = t2.cptid and t2.userid="+ CurrentUser + " and t2.usertype = "+logintype;
                        }
                        String orderby = "mark" ;
                        String tableString = "";
                        tableString =" <table instanceid=\"cptcapitalDetailTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19799,user.getLanguage())+"\" column=\"blongsubcompany\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"mark\" orderkey=\"mark\" />"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/cpt/capital/CptCapitalEdit.jsp\" target=\"_fullwindow\" />"+
                                                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(15293,user.getLanguage())+"\" column=\"fnamark\"  />"+
                                                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(904,user.getLanguage())+"\" column=\"capitalspec\"  />"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(831,user.getLanguage())+"\" column=\"capitalgroupid\" orderkey=\"capitalgroupid\"  transmethod=\"weaver.cpt.maintenance.CapitalAssortmentComInfo.getAssortmentName\" />"+
                                               	 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(1508,user.getLanguage())+"\" column=\"resourceid\"  orderkey=\"resourceid\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\" />"+
                                                 "				<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"stateid\"  orderkey=\"stateid\" transmethod=\"weaver.cpt.maintenance.CapitalStateComInfo.getCapitalStatename\" />"+
                                                 "			</head>"+
                                                 "         <operates width=\"10%\">"+
                                                 "            <operate href=\"/cpt/capital/CptCapitalModifyView.jsp\"  linkvaluecolumn=\"id\"  linkkey=\"capitalid\" text=\""+SystemEnv.getHtmlLabelName(18519,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+
                                                 "         </operates>"+
                                                 "</table>";
             %>
             <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
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
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowResource() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle("viewerspan")
			, $GetEle("resourceid")
			, false
			, "/hrm/resource/HrmResource.jsp?id=");
}

function ShowDeparment() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $GetEle("departmentid").value
			, $GetEle("FromDeparment")
			, $GetEle("departmentid")
			, false
			, "/hrm/company/HrmDepartmentDsp.jsp?id=");
}

function ShowBelongDeparment(inputname,inputspan) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $GetEle(inputname).value
			, $GetEle(inputspan)
			, $GetEle(inputname)
			, false
			, "/hrm/company/HrmDepartmentDsp.jsp?id=");
}
</script>
 <script language="javascript">
 function onSubmit(){
	 $GetEle("from").value = "location";
	 $GetEle("frmain").submit();
 }
 </script>
<script language="javascript">
 function back()
{
	window.history.back(-1);
}
 
function redirectPage(type){
	var detachable='<%=detachable %>';
	var url="";
	switch(type){
		case 1:
			url="/cpt/capital/CptCapitalUse.jsp";
			break;
		case 2:
			url="/cpt/capital/CptCapitalMove.jsp";
			break;
		case 3:
			url="/cpt/capital/CptCapitalLend.jsp";
			break;
		case 4:
			url="/cpt/capital/CptCapitalLoss.jsp";
			break;
		case 5:
			url="/cpt/capital/CptCapitalDiscard.jsp";
			break;
		case 6:
			url="/cpt/capital/CptCapitalMend.jsp";
			break;
		case 7:
			url="/cpt/capital/CptCapitalBack.jsp";
			break;
		case 8:
			url="/cpt/capital/CptCapitalInstock1.jsp";
			break;
		case 9:
			url="/cpt/search/CptInstockSearch.jsp";
			break;
		default:
			break;
			
	}
	
	if(detachable==1&&window.parent.frames[0].name=="leftframe"){
		window.parent.location.href=url;
	}else{
		window.location.href=url;
	}
}
 
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
