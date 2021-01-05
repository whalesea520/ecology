
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=0;
userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String isReceive="1";     //是否接收关注申请
String maxAttention="50"; //最大关注人数
String isThumbnail="1";   //是否显示缩略图

String sqlstr="select * from blog_setting where userid="+userid;
RecordSet.execute(sqlstr);
if(RecordSet.next()){
	isReceive=RecordSet.getString("isReceive");
	isThumbnail=RecordSet.getString("isThumbnail");
	maxAttention=RecordSet.getString("maxAttention");
}else{
	sqlstr="insert into blog_setting(userid,isReceive,isThumbnail,maxAttention) values("+userid+",1,1,50)";
	RecordSet.execute(sqlstr);
}

%>

<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16261,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
  </head>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<form action="BlogSettingOperation.jsp" method="post"  id="mainform">
    <input type="hidden" value="edit" name="operation"/> 
    <input type="hidden" name="maxAttention" value="<%=maxAttention%>" style="width: 35px" size="4">
    <input type="checkbox" style="display: none" name="isThumbnail" <%=isThumbnail.equals("1")?"checked=checked":""%>  value="1" />
    
    <wea:layout>
    	<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
    		<wea:item><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())+SystemEnv.getHtmlLabelName(25436,user.getLanguage())+SystemEnv.getHtmlLabelName(129,user.getLanguage())%></wea:item>
    		<wea:item><input type="checkbox" tzCheckbox="true" name="isReceive" <%=isReceive.equals("1")?"checked=checked":""%> value="1" /></wea:item>
    	</wea:group>
    </wea:layout>
    
</form>  
</body>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
  
jQuery(document).ready(function(){
	 jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
});
 </script>
</html>
