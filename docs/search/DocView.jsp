
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>



</head>
<%
if(true){
	response.sendRedirect("/docs/search/DocMain.jsp?urlType=5&"+request.getQueryString());
	return;
}
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
String needfav ="1";
String needhelp ="";

String displayUsage=Util.null2o(request.getParameter("displayUsage"));
String showtype = Util.null2o(request.getParameter("showtype"));
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
String selectArr = "";
if(selectedContent!=null && selectedContent.startsWith("key_")){
	String menuid = selectedContent.substring(4);
	RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
	selectedContent = "";
	while(RecordSet.next()){
		String keyVal = RecordSet.getString(2);
		selectedContent += keyVal +"|";
	}
	if(selectedContent.indexOf("|")!=-1)
		selectedContent = selectedContent.substring(0,selectedContent.length()-1);
}
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
selectArr+="|";

String inMainCategoryStr = "";
String inSubCategoryStr = "";
String[] docCategoryArray = null;
if(fromAdvancedMenu==1){
	docCategoryArray = Util.TokenizerString2(selectArr,"|");
	if(docCategoryArray!=null&&docCategoryArray.length>0){
		for(int k=0;k<docCategoryArray.length;k++){
			if(docCategoryArray[k].indexOf("M")>-1)
				inMainCategoryStr += "," + docCategoryArray[k].substring(1);
			if(docCategoryArray[k].indexOf("S")>-1)
				inSubCategoryStr += "," + docCategoryArray[k].substring(1);
		}
		if(inMainCategoryStr.substring(0,1).equals(",")) inMainCategoryStr=inMainCategoryStr.substring(1);
		if(inSubCategoryStr.substring(0,1).equals(",")) inSubCategoryStr=inSubCategoryStr.substring(1);
	}
}
%>
<BODY>

<%-- edited by wdl 2006-06-01 树型显示  --%>
<%if(showtype.equals("1")){%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=30%>
<IFRAME name=leftframe id=leftframe src="DocSummaryTreeLeft.jsp?displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width=1%>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=70%>
<IFRAME name=contentframe id=contentframe src="DocSummaryList.jsp?showtype=1&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<% 
	return;
}
%>
<%-- edited by wdl end --%>

<%-- edited by yinshun.xu 2006-07-18 按组织结构显示  --%>
<%if(showtype.equals("2")){%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=30%>
<IFRAME name=leftframe id=leftframe src="DocSearchByOrgLeft.jsp?rightStr=Car:Maintenance" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width=1%>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=70%>
<IFRAME name=contentframe id=contentframe src="DocSearchTemp.jsp?list=all&showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<% 
	return;
}
%>
<%-- edited by yinshun.xu end --%>

<%-- edited by fanggsh 2006-07-23 for TD4707 按树状字段显示 begin  --%>
<%if(showtype.equals("3")){%>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width=30%>
<IFRAME name=leftframe id=leftframe src="DocSearchByTreeDocFieldLeft.jsp" width="100%" height="100%" frameborder=no scrolling=no>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd0 name=oTd0 width=1%>
<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width=70%>
<IFRAME name=contentframe id=contentframe src="DocSearchTemp.jsp?list=all&showtype=3" width="100%" height="100%" frameborder=no scrolling=yes>
<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
<% 
	return;
}
%>
<%-- edited by fanggsh 2006-07-23 for TD4707 按树状字段显示 end --%>

<%@ include file="/docs/common.jsp" %>

<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/js/ecology8/docs/DocSummary_wev8.js"></script>

<div style="display:none;" id="menuStr">
</div>

<script type="text/javascript">
	jQuery.ajax({
		url:"DocSearchMenu.jsp",
		data:{
			url:"DocViewContent.jsp",
			doccreaterid: <%=user.getUID()%>
		},
		success:function(data){
			jQuery("#menuStr").html(data);
		}
	});
	jQuery(document).ready(function(){
		var url = "DocViewContent.jsp?doccreaterid=<%=user.getUID()%>";
		jQuery("#flowFrame").attr("src",url);
	});
</script>

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<span class="leftType"><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%><span id="totalDoc"></span></span>
			<span class="leftSearchSpan">
				&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
			</span>
		</td>
		<td rowspan="2">
			<iframe src="" id="flowFrame" name="flowFrame" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>

<script language="JavaScript">

function onShowDepartment(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+$("input[name=departmentid]").val());
	if (datas) {
        if (datas.id!=""){
			$("#departmentspan").html(datas.name);
			$("input[name=departmentid]").val(datas.id);
        }
		else{
			$("#departmentspan").html("");
			$("input[name=departmentid]").val("");
		}
	}
}
function onShowResource(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if(datas){
        if( datas.id!= "" ){
        	
			$("#ownerspan").html( "<a href='javaScript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</a>");
			$("#owner").val(datas.id);
        }else{
        	$("#ownerspan").html("");
			$("#owner").val("");
		}
	}
}

function treeView(){
	location.href="/docs/search/DocSummary.jsp?showtype=1&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewbyOrganization(){
	location.href="/docs/search/DocSummary.jsp?showtype=2&displayUsage=<%=displayUsage%>&fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>";
}

function viewByTreeDocField(){
	location.href="/docs/search/DocSummary.jsp?showtype=3";
}

</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>