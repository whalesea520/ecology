<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*,java.io.File" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.org.layout.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.hrm.common.*,weaver.hrm.chart.domain.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="showDepLayoutToPicServlet" class="weaver.org.layout.ShowDepLayoutToPicServlet" scope="page" />
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String fnarightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All",user) ;

	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(562,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sorgid = Util.null2String(request.getParameter("sorgid"),"1");
	String docStatus = Util.null2String(request.getParameter("docStatus"));
%>
<HTML>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css"/>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/orgchart_wev8.css"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<style type="text/css">
		.ellipsis {
			padding:1px;
			white-space:nowrap;
			overflow:hidden;
			text-overflow:ellipsis;
		}
		.wpoint{
			position:absolute;
			overflow:hidden;
			width:1px;
			height:1px;
			background:#000;
			border:0;
			border:0;
		}
		</style>
		<script>
			var sorgid = "<%= sorgid%>";
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function resetSelect(){
				var obj = $GetEle("docStatus");
				if(obj)changeSelectValue(obj.id,"0");
			}
		</script>
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type="hidden" name="sorgid" value="<%=sorgid%>">
			<table id="topTitle" class="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" id="docStatus" name="docStatus">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <%=docStatus.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></option>
								<option value="1" <%=docStatus.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%></option>
								<option value="2" <%=docStatus.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								<option value="3" <%=docStatus.equals("3")?"selected":""%>><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
								<option value="4" <%=docStatus.equals("4")?"selected":""%>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
								<option value="5" <%=docStatus.equals("5")?"selected":""%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
								<option value="6" <%=docStatus.equals("6")?"selected":""%>><%=SystemEnv.getHtmlLabelName(19564,user.getLanguage())%></option>
								<option value="7" <%=docStatus.equals("7")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option>
								<option value="8" <%=docStatus.equals("8")?"selected":""%>><%=SystemEnv.getHtmlLabelName(15358,user.getLanguage())%></option>
								<option value="9" <%=docStatus.equals("9")?"selected":""%>><%=SystemEnv.getHtmlLabelName(21556,user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();resetSelect()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<div id="contentDiv" style="position:relative;height:100%;bottom:4px;width:100%;overflow:auto;">
			<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="zIndex:-1" >
				<tr>
					<td align="center" valign="center">
						<div style="width:170px;border:1px solid #d0d0d0;"><img src="/images/loading2_wev8.gif" align="absmiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></div>
					</td>
				</tr>
			</table>
		</div>
<%
RecordSet.executeSql("select needupdate from orgchartstate");
    int needupdate = 1;
    if (RecordSet.next())
        needupdate = RecordSet.getInt("needupdate");


int companyid = Util.getIntValue(request.getParameter("companyid"),1);
String departids="\"\"";


RecordSet.executeProc("HrmSubCompany_SByCompanyID",""+companyid);

int subcompanycount = RecordSet.getCounts();
int clientwidth = 125*subcompanycount;

int top = 210;
int cellHeight = 66;
int cellWidth = 105;
int cellWidth2 = 420;
int lineHeight1 = 7;
int lineHeight2 = 73;
int lineWidth = 5;
int cellSpace = 20;
int linestep = 17;


String charttype = Util.null2String(request.getParameter("charttype"));

String doctype_a = Util.null2String(request.getParameter("doctype_a"));
String doctype_p = Util.null2String(request.getParameter("doctype_p"));
String doctype_o = Util.null2String(request.getParameter("doctype_o"));
String doctype_d = Util.null2String(request.getParameter("doctype_d"));
String docstatus = docStatus;

if(charttype.equals(""))
	charttype = "D";

int topMargin = 210;
int leftMargin = 20;
DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false, user);

dl.buildObjectRef();
dl.checkAndAutoset(10, 10, 20, 20);
%>
<table width="<%=dl.getMaxPos().x+60%>" height="<%=dl.getMaxPos().y+300%>" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<FORM action="OrgChartDoc.jsp" id=Baco name=Baco method=post>
				<%

				DocSearchComInfo.resetSearchInfo();
				if (docStatus!= null && docStatus.length() > 0) {
					DocSearchComInfo.addDocstatus(docStatus);
				}
				%>
				

			<div id=oDiv STYLE="POSITION:absolute;Z-INDEX:100;TOP:<%=topMargin%>;LEFT:<%=leftMargin%>;height:<%=dl.getMaxPos().y%>;width:<%=dl.getMaxPos().x%>">
			<%
			out.print(showDepLayoutToPicServlet.gerLine(request,response));
			int curnum = 0;
			for (int i=0;i<dl.departments.size();i++) {
				Department depart = (Department)dl.departments.get(i);
				String tmpnum="";
				departids +=",\"";
				departids += depart.id;
				departids +="\"";
				curnum += 1;
				
				String whereclause = "";
				if (depart.type == Department.TYPE_ZONGBU) {
			%>
				<TABLE class="org_node_c_inner_company" cellpadding=1 cellspacing=1 STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;cursor:hand;">
					<TR height=22px><TD colspan=2 style="color:#000079" id=t align="center" title="<%=depart.name%>"><br><%=Tools.vString(depart.name, 12)%></TD></TR>
					<TR height=20px>
					<%
						tmpnum = "";
						whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
						DocSearchManage.getSelectResultCount(whereclause,user) ;
						tmpnum=""+DocSearchManage.getRecordersize();
					%>
					<TD align="center" width="100%" style="padding-bottom:3px;color:#000079"><%=tmpnum%></TD>
					</TR>
				</TABLE>		
			<%
				} else if (depart.type == Department.TYPE_FENBU) {
					int subcompanyid = depart.id;
			%>
				<TABLE class="org_node_c_inner_subcompany" cellpadding=1 cellspacing=1
					STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;background-repeat:no-repeat;">
					<TR height=28px><TD align="center" onclick="doShowOrg('subcompany','<%=depart.id%>');" style="color:#eee;cursor:pointer" colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>px;display:inline-block;overflow:hidden;"><span><%=Tools.vString(depart.name, 12)%></span></span></TD></TR>
					<TR height=14px>
					<%
						tmpnum = "";
						whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
						whereclause +=  " and docdepartmentid in ( " +
										" select id from HrmDepartment where subcompanyid1= " +
										subcompanyid + "  or  subcompanyid1  in (select id from hrmsubcompany where supsubcomid="+subcompanyid+") ) ";
						DocSearchManage.getSelectResultCount(whereclause,user) ;
						tmpnum=""+ DocSearchManage.getRecordersize();
					%>
					<TD align="center" width=100% style="padding-bottom:0px;color:#eee;cursor:pointer" onclick="doShow('subcompany','<%=depart.id%>');"><%=tmpnum%></TD>
					</TR>		
				</TABLE>
			<%
				} else if (depart.type == Department.TYPE_COMMON_DEPARTMENT) {
			%>
				<TABLE class="org_node_c_inner_dept" cellpadding=1 cellspacing=1 
					STYLE="POSITION:absolute;Z-INDEX:100;;TOP:<%=depart.y%>px;LEFT:<%=depart.x%>px;height:<%=depart.getWidthHeight().y+1%>px;width:<%=depart.getWidthHeight().x%>px;cursor:hand;background-repeat:no-repeat;">
					<TR height=28px><TD onclick="doShowOrg('department','<%=depart.id%>');" align="center" style="color:#eee;cursor:pointer" colspan=1 TITLE="<%=depart.name%>" id=t><span class="ellipsis" style="width:<%=depart.getWidthHeight().x%>px;display:inline-block;overflow:hidden;"><span ><%=Tools.vString(depart.name, 12)%></span></span></TD></TR>
					<TR height=14px>
					<%
						tmpnum = "";
						whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ; 
						whereclause +=  " and docdepartmentid = " +  depart.id;

						DocSearchManage.getSelectResultCount(whereclause,user) ;
						tmpnum=""+DocSearchManage.getRecordersize();
					%>
					<TD align="center" width=100% style="padding-bottom:0px;color:#eee;cursor:pointer" onclick="doShow('department','<%=depart.id%>');"><%=tmpnum%></TD>
					</TR>
				</TABLE>
			<%  } // end of if
			} // end of for
			%>
			</div>
			<DIV style="position:absolute;top:947;left:804;visibility:hidden;width:1;height:1;"></DIV>
			<SCRIPT language=VBScript>
			oc_DivisionList=array(<%=departids%>)
			dim oc_CurrentMenu
			dim oc_CurrentIndex

			Sub oc_ShowMenu(Index,elMenu)
				dim t
				on error resume next
				oc_CurrentMenu.style.visibility="hidden"
				on error goto 0
				Set oc_CurrentMenu=elMenu
				oc_CurrentIndex = Index

				' title
				set elFrom = window.event.srcElement
				do while elFrom.tagName<>"TABLE"
					set elFrom = elFrom.parentElement
				loop
				elMenu.all("t").innerText = elFrom.all("t").innerText

				st = document.body.scrollTop
				oh = document.body.offsetHeight
				t = (st + window.event.clientY) - 2
				l = (document.body.scrollLeft + window.event.clientX) -10
				h = elMenu.clientHeight
				w = elMenu.clientWidth

				if ((l + w) > (document.body.scrollLeft + document.body.offsetWidth)) then l = l - (w-20)
				if ((t + h) > (document.body.scrollTop + document.body.offsetHeight)) then t = t - (h+2)

				elMenu.style.left = l
				elMenu.style.top = t
				elMenu.style.visibility = "visible"
			End Sub

			Sub oc_CurrentMenuOnMouseOut()
				set el = window.event.srcElement
				if (el.tagName = "A") then set el = el.parentElement
				if (el.tagName = "IMG") then set el = el.parentElement
				if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopup"
			End Sub

			Sub oc_CurrentMenuOnMouseOver()
				set el = window.event.srcElement
				if (el.tagName = "A") then set el = el.parentElement
				if (el.tagName = "IMG") then set el = el.parentElement
				if (el.tagName = "TD" AND el.className <> "MenuPopupSelected" AND el.className <> "NoHand") then el.className = "MenuPopupFocus"
			End Sub

			Sub document_onmouseover
				on error resume next
				If window.event.srcElement.tagName = "BODY" Then
					oc_CurrentMenu.style.visibility = "hidden"
				End If
			End Sub

			Sub document_onmouseup
				on error resume next
				If window.event.srcElement.tagName = "BODY" Then
					oc_CurrentMenu.style.visibility = "hidden"
				End If
			End Sub

			Function oc_getAllDivisions(isQuoted)
				oc_getAllDivisions = Null
				For i = 1 To UBound(oc_DivisionList)
					d = oc_DivisionList(i)
					If isQuoted Then d = "'" & d & "'"
					oc_getAllDivisions = oc_getAllDivisions + "," & d
				Next
			End Function
			</SCRIPT>


				<DIV id="oc_divMenuTop" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD>
				</TR>
				
				</TABLE>
				</DIV>
				<DIV id="oc_divMenuGroup" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
				
				</TABLE>
				</DIV>
				<DIV id="oc_divMenuDivision" style="visibility:hidden; LEFT:0px; POSITION:absolute; TOP:0px; WIDTH:240px; Z-INDEX: 200">
				<TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript onclick="return oc_CurrentMenuOnClick()" onmouseout="return oc_CurrentMenuonmouseout()" onmouseover="return oc_CurrentMenuonmouseover()" style="HEIGHT: 79px; WIDTH: 246px">
				<TR><TD class="NoHand" style=text-align:center;color:white id=t>Title</TD></TR>
				
					 <TR id=D1><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD></TR>
				
					 <TR id=D2><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%></TD></TR>
					 
					 <TR id=D3><TD class=MenuPopup><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD></TR>
				
				</TABLE>
				</DIV>
				<SCRIPT LANGUAGE=VBScript>
				Sub oc_CurrentMenuOnClick
					set el = window.event.srcElement
					if (el.tagName = "A") then set el = el.parentElement
					select case el.parentElement.id
					
						case "D1"
							r="/hrm/company/HrmDepartmentDsp.jsp?id=" & oc_DivisionList(oc_CurrentIndex)
						case "D2"
							r="/docs/news/DocNews.jsp?depid=" & oc_DivisionList(oc_CurrentIndex)
						case "D3"
							r="/docs/search/DocSearchTemp.jsp?docstatus=<%=docstatus%>&departmentid=" & oc_DivisionList(oc_CurrentIndex)
					end select
					oc_CurrentMenu.style.visibility = "hidden"
					if (r <> "") then
						window.event.returnValue = false
						window.location.href = r
					end if
				End Sub
				</SCRIPT>

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
<script language="javascript">
 function onSubmit(){ 	
	document.Baco.submit();
 }
 function doShow(type, id){
	if(type === "subcompany"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&from=hrmorg&virtualtype="+sorgid+"&subcompanyid1="+id);
	} else if(type === "department"){
		window.open("/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&from=hrmorg&virtualtype="+sorgid+"&departmentid="+id);
	}
}
	jQuery(document).ready(function(){
		if (typeof onBtnSearchClick != "undefined" && onBtnSearchClick instanceof Function) {
			$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
		}
		document.all("contentDiv").style.display = "none";
	});
</script>
</BODY>
</HTML>
