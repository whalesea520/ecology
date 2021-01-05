
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="CategoryUtil" class="weaver.docs.category.CategoryUtil" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>

<%

//目前该功能只开发给文档管理员，因为可以查看到所有文档的文档名称。
if(!HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {//如果具有删除文档的权限,则认为是文档管理员
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String department = Util.null2String(request.getParameter("department")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String secid = Util.null2String(request.getParameter("secid"));
String treeDocFieldId = Util.null2String(request.getParameter("treeDocFieldId"));

int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = Util.getIntValue(request.getParameter("perpage"),100);

String path = "";
if (!secid.equals("")) {
    path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secid,0));
}


DocSearchComInfo.resetSearchInfo();
//调整为显示所有状态的文档
//DocSearchComInfo.addDocstatus("1");
//DocSearchComInfo.addDocstatus("2");
//DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setDocdepartmentid(department);
DocSearchComInfo.setDoccreatedateFrom(fromdate);
DocSearchComInfo.setDoccreatedateTo(todate);
DocSearchComInfo.setSeccategory(secid);
DocSearchComInfo.setTreeDocFieldId(treeDocFieldId);

String SqlWhere = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderbyclause = "" ;

String userid = ""+user.getUID();

//String backFields = "t1.id,t1.ownerid,t1.docdepartmentid";
String backFields = "t1.id,t1.doccode,t1.docSubject,t1.docedition,t1.docdepartmentid,t1.ownerid,t1.docapprovedate,t1.docinvaldate,t1.docStatus";

//String sqlFrom = " from DocDetail  t1, "+ ShareManager.getShareDetailTableByIDAndType("doc",userid, "1")+ " t2 ";
String sqlFrom = " from DocDetail  t1 ";
//String tableString=""+
//			"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
//			"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
//			"<head>"+
//				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\"  column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
//				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19549,user.getLanguage())+"\" column=\"docdepartmentid\" orderkey=\"docdepartmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"/>"+
//				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19547,user.getLanguage())+"\"  column=\"docinvaldate\" orderkey=\"docinvaldate\"/>"+
//				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19548,user.getLanguage())+"\"  column=\"docapprovedate\" orderkey=\"docapprovedate\"/>"+
//				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19542,user.getLanguage())+"\" column=\"doccode\" orderkey=\"doccode\"/>"+
//				"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19543,user.getLanguage())+"\" column=\"docedition\" orderkey=\"docedition\"/>"+
//			"</head>"+
//			"</table>";
String tableString=""+
			"<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\" sqlisdistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			"<head>"+
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19542,user.getLanguage())+"\" column=\"doccode\" orderkey=\"doccode\"/>"+
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" column=\"docSubject\" orderkey=\"docSubject\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19543,user.getLanguage())+"\" column=\"id\" orderkey=\"docedition\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocVersion\"/>"+
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19549,user.getLanguage())+"\" column=\"docdepartmentid\" orderkey=\"docdepartmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"/>"+
				"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\"  column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19548,user.getLanguage())+"\"  column=\"docapprovedate\" orderkey=\"docapprovedate\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19547,user.getLanguage())+"\"  column=\"docinvaldate\" orderkey=\"docinvaldate\"/>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"docStatus\" orderkey=\"docStatus\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>"+

			"</head>"+
			"</table>";
%>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(125,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.report.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
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
			<FORM id=report name=report action=DocCreateRp.jsp method=post>
			<TABLE class=ViewForm border=0>
				<COLGROUP> <COL width="15%"> <COL width="30%"> <COL width="15%"> <COL width="40%">
				<TBODY>
				<TR class=Spacing>
					<TD class=Line1 colSpan=4></TD>
				</TR>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
					<TD class=Field>
					
					<INPUT id=department  class=wuiBrowser _displayText="<%=DepartmentComInfo.getDepartmentname(department)%>"   type=hidden name=department value="<%=department%>" 
					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=<%=department%>"
					>
					</TD>
					<TD><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
					<TD class=field>
					<input type="hidden" class=wuiDate  name="fromdate" value="<%=fromdate%>">
					-&nbsp;&nbsp;
					<input class=wuiDate  type="hidden" name="todate" value="<%=todate%>">
			 		</TD>
				</TR>
				<TR style="height:2px"  ><TD class=Line colSpan=4></TD></TR>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
					<TD class=Field>
						<BUTTON  type="button" class=Browser onClick="onSelectCategory()" name=selectCategory></BUTTON>
				    	<span id=path name=path><%=path%></span>
						<INPUT  type=hidden name=secid value="<%=secid%>">
			 		</TD>
					<TD><%=SystemEnv.getHtmlLabelName(19485,user.getLanguage())%></TD>
					<TD class=Field>
						<input   class=wuiBrowser  _displayText='<%=Util.toScreen(DocTreeDocFieldComInfo.getAllSuperiorFieldName(treeDocFieldId),user.getLanguage())%>'  type="hidden" name="treeDocFieldId" value="<%=treeDocFieldId%>"
						_url="/docs/category/DocTreeDocFieldBrowserSingle.jsp?superiorFieldId=<%=treeDocFieldId%>"
						">
						
					</TD>
				</TR>
				<TR style="height:2px" ><TD class=Line colSpan=4></TD></TR>
			</TBODY>
			</TABLE>
			</FORM>
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
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
<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&report.department.value)
	if NOT isempty(id) then
		if id(0)<> 0 then
			departmentdesc.innerHtml = id(1)
			report.department.value=id(0)
		else
			departmentdesc.innerHtml = empty
			report.department.value=""
		end if
	end if
end sub

sub onShowTreeDocField(spanName,inputeName)
    treeDocFieldId=document.report.treeDocFieldId.value
    url=encode("/docs/category/DocTreeDocFieldBrowserSingle.jsp?superiorFieldId="+treeDocFieldId)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)

	if NOT isempty(id) then
	    if id(0)<> 0 then
            document.all(spanName).innerHtml = id(1)
		    document.all(inputeName).value=id(0)
		else
		    document.all(spanName).innerHtml = empty
		    document.all(inputeName).value="0"
		end if
	end if
end sub
</script>
<script language="javascript">
function encode(str){
    return escape(str);
}

function onSelectCategory() {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/PermittedCategoryBrowser.jsp?operationcode=0");
	if (result != null) {
	    if (result[0] > 0)  {
	    	document.all("secid").value=result[1];
	    	document.report.submit();
	        //location.href = "DocCreateRp.jsp?secid="+result[1];
    	} else {
    	    location.href = "DocCreateRp.jsp";
    	}
	}
}
function onReSearch(){
	departmentdesc.innerHTML="";
	report.department.value="";
	fromdatespan.innerHTML="";
	report.fromdate.value="";
	todatespan.innerHTML="";
	report.todate.value="";
	path.innerHTML="";
	report.secid.value="";
	treeDocFieldSpan.innerHTML="";
	report.treeDocFieldId.value="";
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
