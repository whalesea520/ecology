
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
if (!HrmUserVarify.checkUserRight("blog:specifiedShare", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(28205,user.getLanguage()); 
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String sqlstr="SELECT * FROM (SELECT min(id) AS minid,specifiedid FROM blog_specifiedShare  GROUP BY specifiedid)  t ORDER BY t.minid";
RecordSet.execute(sqlstr);
BlogDao blogDao=new BlogDao();
%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
  </head>
  <body>
  
  <table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
					
					<input type=button class="e8_btn_top" onclick="addSpecifiedShare()" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
					<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
			<td></td>
		</tr>
	</table>
  
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSpecifiedShare(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%
String orderBy = "t2.id";
String backFields = " specifiedid,subcompanyid1,departmentid";
String sqlFrom = "from (SELECT min(id) AS minid,specifiedid FROM blog_specifiedShare  GROUP BY specifiedid)  t,hrmresource t2";
String sqlwhere = " t.specifiedid=t2.id";
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.blog.BlogTransMethod.getBlogSpecifiedSharePopedom\"></popedom> ";
       operateString+="     <operate href=\"javascript:addSpecifiedShare()\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:delSpecified()\" target=\"_self\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
       operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Blog_SpecifedShare+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Blog_SpecifedShare,user.getUID(),PageIdConst.BLOG)+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"specifiedid\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\" text=\""+ SystemEnv.getHtmlLabelName(28209,user.getLanguage()) +"\" column=\"specifiedid\" "+
       			" transmethod=\"weaver.blog.BlogTransMethod.getSpecifiedName\"/>";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" "+
   			 " column=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />";			
 	   tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" "+
   			 " column=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%> 
 
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform">
    <input type="hidden" value="editApp" name="operation"/> 
    <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Blog_SpecifedShare%>">	
    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
	</form>  
  </body>
 <script type="text/javascript">
 
 $(document).ready(function(){
 	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
 });
 
  function doSave(){
     jQuery("#mainform").submit();
  }
  
  var diaglog = null;
  function addSpecifiedShare(specifiedid){
  	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) +SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>";
	if(specifiedid){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) +SystemEnv.getHtmlLabelName(2112,user.getLanguage()) %>";
	}
	dialog.Width = 850;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	var url = "/blog/specified/addSpecifiedShare.jsp";
	if(specifiedid){
		url += "?operation=editApp&specifiedid="+specifiedid;
	}
	dialog.URL = url;
	dialog.show();
	document.body.click();
  }
  
  function closeWin(){
  	if(dialog){
  		dialog.close();
  	}
  	_table. reLoad();
  }
  function delSpecified(specifiedid){
  	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
  		jQuery.post("/blog/BlogSettingOperation.jsp",
  			{"operation":"deleteSpecified","specifiedid":specifiedid},function(){
            _table. reLoad();
         });
  	});
  }
  
  function preViw(tempid){
    var diag = new Dialog();
    diag.Modal = false;
    diag.Drag=true;
	diag.Width = 550;
	diag.Height = 450;
	diag.ShowButtonRow=false;
	diag.Title = "<%=SystemEnv.getHtmlLabelName(31568,user.getLanguage()) %>";

	diag.URL = "blogTemplateView.jsp?tempid="+tempid;
    diag.show();
  }
  
  
  function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage()) %>!");
		return;
	}
	id = id.substring(0,id.length-1);
	delSpecified(id);

}
  
 </script>
</html>
