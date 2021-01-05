
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
</script>
	<script type="text/javascript">
		function onAdd(){
			window.location.href="/security/sensitive/SensitiveTab.jsp?_fromURL=1";
		}

		function onEdit(id){
			if(!id){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
				return;
			}
			window.location.href = "/security/sensitive/SensitiveTab.jsp?_fromURL=2&id="+id;
		}

		function onDelete(id){
			if(!id){
				alert("<%=SystemEnv.getHtmlLabelName(83439,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>")){
		jQuery.ajax({
			url:"/security/sensitive/SensitiveWordOperation.jsp?operation=delete&id="+id,
			type:"post",
			success:function(data){
				alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
				_table.reLoad();
			}
		});
		}
		}

	</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
 %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(131741,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.toHtml2(Util.null2String(request.getParameter("word")));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:onAdd(),_top}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
</form>
<%
	String sqlWhere = "";
	if(!qname.equals("")){
		sqlWhere = " word like '%"+qname+"%'";
	}	
	 String tabletype="checkbox";
	String  operateString= "";
	operateString = "<operates width=\"20%\" isalwaysshow=\"true\">";
	 	       operateString+="     <operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:onDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="</operates>";	
	String tableString=""+
	   "<table  instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"sensitive_words\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   operateString+
	   "<head>"+							 
			 "<col pkey=\"id\" width=\"5%\" text=\"ID\" column=\"id\"  orderkey=\"id\"/>"+
			 "<col pkey=\"words\" width=\"75%\" text=\""+SystemEnv.getHtmlLabelName(131596,user.getLanguage())+"\" column=\"word\"/>";
	   tableString += "</head>"+
	   "</table>";
%> 
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  />
</BODY>
</HTML>