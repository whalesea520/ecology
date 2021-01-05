
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:appSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(26761,user.getLanguage()); //微博应用设置
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String sqlstr="select * from blog_app where appType is not null order by sort";
RecordSet.execute(sqlstr);

%>
<html>
  <head>
  	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(26761,user.getLanguage()) %>"/>
</jsp:include>

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

<form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
<input type="hidden" value="editApp" name="operation"/> 
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>  
  <COL width="30%">
  <COL width="70%">
  <TBODY>
  <TR class=HeaderForXtalbe>
	  <th><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></th>
  </tr>
	<%
	   while(RecordSet.next()){
		  String appid=RecordSet.getString("id");
	      String appName=RecordSet.getString("name");
	      String appType=RecordSet.getString("appType");
	      String isActive=RecordSet.getString("isActive");
	      appName=!appType.equals("custom")?SystemEnv.getHtmlLabelName(Integer.parseInt(appName),user.getLanguage()):appName;
	  %>
	  <tr class="DataLight">	  
		  <TD><%=appName%></TD>
		  <TD>  
		    <input type="hidden" value="<%=appid%>" name="appid">
			<input type="checkbox" tzCheckbox="true" name="isActive_<%=appid%>" <%=isActive.equals("1")?"checked=checked":""%>  value="1" />
		  </TD>
	  </tr>	  
	<%}%>
</TBODY>
</TABLE>	

</form>  
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
  
  function doEdit(){
    window.location.href="BlogAppSetting.jsp?operation=editApp";
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
