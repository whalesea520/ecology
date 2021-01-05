
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
String showTop = Util.null2String(request.getParameter("showTop"));
%>
<%
	String status = Util.null2String(request.getParameter("status"));
	String sql = "SELECT  * FROM MailAutoRespond  WHERE userId = "+user.getUID();
	rs.execute(sql);
	rs.first();
%>
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<%@ include file="/cowork/uploader.jsp" %>
<jsp:include page="/email/MailUtil.jsp"></jsp:include>

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script type="text/javascript">
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;

$(document).ready(function(){
	highEditor("content");
});

function saveInfo(){
	changeImgToEmail("content");
	var remarkValue=getRemarkHtml("content");
	$("textarea[name=content]").val(remarkValue);
	$("#autorespond").submit();
}

$(function(){
	if("<%=status%>"=="true"){
		alert(SystemEnv.getHtmlLabelName(18758,user.getLanguage()));
	}
	
	if("<%=status%>"=="false"){
		alert(SystemEnv.getHtmlLabelName(22620,user.getLanguage()));
	}
});


</script>
</head>
  
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
			
<form method="post" action="MailAutoRespondOperation.jsp" id="autorespond" name="autorespond">
	<input type="hidden" name="operation"  id= "operation" value = "<%=rs.getInt("userId") > 0?"update":"add"%>"/>
	
	<wea:layout >
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item>
				    <%=SystemEnv.getHtmlLabelName(32165,user.getLanguage()) %>  
				</wea:item>
				<wea:item>
					<input type="checkbox" tzCheckbox="true" id="isAuto" name = "isAuto" value="1" <%if(rs.getInt("isAuto")==1){out.println("checked='checked'");}%>>
				</wea:item>
				
				<wea:item>
				    <%=SystemEnv.getHtmlLabelName(32167,user.getLanguage()) %>  
				</wea:item>
				<wea:item>
				    <input type="checkbox" tzCheckbox="true" id="isContactReply" name = "isContactReply" value="1" <%if(rs.getInt("isContactReply")==1){out.println("checked='checked'");}%>>
				</wea:item>
				
				<wea:item >
				    <%=SystemEnv.getHtmlLabelName(18546,user.getLanguage()) %>  
				</wea:item>
				<wea:item >
				    <div style="width:98%">
			 			<textarea id="content" _editorid="content" _editorName="content" style="width:100%;height:300px;border:1px solid #C7C7C7;"><%=rs.getString("content") %></textarea>
					</div>
				</wea:item>
				
			</wea:group>
	</wea:layout>			
	
</form>

</body>
</html>












