
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:templateSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(28171,user.getLanguage()); //微博应用设置
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String sqlstr="select * from blog_template where isSystem = 1 order by id desc";
RecordSet.execute(sqlstr);

%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
  </head>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addTemp(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String orderBy = "id";
String backFields = "id , tempName ,tempDesc, isUsed ,isSystem,case when isSystem=1 then '"+SystemEnv.getHtmlLabelName(83158,user.getLanguage())+"' else '"+SystemEnv.getHtmlLabelName(83159,user.getLanguage())+"' END isSystem_str";
String sqlFrom = "from blog_template";
String sqlwhere = " isSystem = 1";
String operateString= "<operates width=\"15%\">";
       operateString+="     <operate href=\"javascript:editTemp()\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
       operateString+="     <operate href=\"javascript:showTemp()\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" index=\"1\"/>";
       operateString+="     <operate href=\"javascript:templateShare()\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" index=\"2\"/>";
   	   operateString+="     <operate href=\"javascript:delTemp()\" target=\"_self\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
       operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Blog_Template+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Blog_Template,user.getUID(),PageIdConst.BLOG)+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"desc\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"25%\" transmethod=\"weaver.blog.BlogTransMethod.getBlogTemplateName\" "+
       			"text=\""+ SystemEnv.getHtmlLabelName(18151,user.getLanguage()) +"\" column=\"tempName\" orderkey=\"tempName\" otherpara=\"column:id\"/>";
       tableString+="<col width=\"30%\" text=\""+ SystemEnv.getHtmlLabelName(18627,user.getLanguage()) +"\" column=\"tempDesc\" orderkey=\"tempDesc\"/>";
  	   tableString+="<col width=\"18%\"  text=\""+ SystemEnv.getHtmlLabelName(20622,user.getLanguage()) +"\" column=\"isUsed\" orderkey=\"isUsed\" "+
  			 " otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.blog.BlogTransMethod.getCheckInfo\" />";
       tableString+="<col width=\"18%\"  text=\""+ SystemEnv.getHtmlLabelName(20622,user.getLanguage()) +"\" column=\"isSystem_str\" orderkey=\"isSystem_str\"/>";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(28171,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="addTemp()" type="button"  value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form action="BlogSettingOperation.jsp" method="post"  id="mainform">
<input type="hidden" value="editApp" name="operation"/>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Blog_Template%>"> 
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</form>  
</body>
 <script type="text/javascript">
   var diag = null;
   function getDialog(title,width,height){
	    diag = new window.top.Dialog();
	    diag.currentWindow = window; 
	    diag.Modal = true;
	    diag.Drag=true;
		diag.Width =width;
		diag.Height =height;
		diag.Title = title;
		return diag;
	} 
	
	function callback(){
		if(diag){
			diag.close();
		}
		_table. reLoad();
	}
	
  
  function addTemp(){
  	diag = getDialog("<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>", 800 ,600);
  	diag.URL = "/blog/addBlogTemplate.jsp?operation=editApp&isSystem=1";
  	diag.show();
  	document.body.click();
  }
  
  function editTemp(id){
  	diag = getDialog("<%=SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>", 800 ,600);
  	diag.URL = "/blog/addBlogTemplate.jsp?operation=editApp&tempid="+id+"&isSystem=1";
  	diag.show();
  	document.body.click();
  }
  
  function showTemp(id){
  	diag = getDialog("<%=SystemEnv.getHtmlLabelName(33025,user.getLanguage())%>", 800 ,600);
  	diag.URL = "/blog/viewBlogTemplate.jsp?tempid="+id;
  	diag.show();
  	document.body.click();
  }
  
  function delTemp(tempid){
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
    	 jQuery.post("/blog/BlogSettingOperation.jsp?operation=deleteTemp&tempid="+tempid,function(){
         	_table. reLoad();
         });
    });  
  }
  
  function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>!");
		return;
	}
	id = id.substring(0,id.length-1);
	delTemp(id);

}

  function preViw(tempid){
	
	diag = getDialog("<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())%>", 600 ,420);
  	diag.URL = "/blog/blogTemplateView.jsp?tempid="+tempid;
  	diag.show();
	document.body.click();
  }
  
  function templateShare(id){
  	diag = getDialog("<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>", 600 ,420);
  	diag.URL = "/blog/blogTemplateShare.jsp?tempid="+id;
  	diag.show();
  	document.body.click();
  }
  

  
 </script>
</html>
