
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript">
	function saveInfo(){
		 jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 });	
	}
	
	function showDetail(obj){
		if(!jQuery(obj).is(":checked"))
		 	showGroup("emldetail");
		else
		 	hideGroup("emldetail");
	}
	
</script>
</head>

<%
	int clearTime = 1;
	int dimissionEmpTime = 2;
	int isClear = 0;
	String attributes = "{samePair:'emldetail',itemAreaDisplay:'none',groupOperDisplay:'none'}";
	rs.execute("select * from MailConfigureInfo");
	while(rs.next()){
		clearTime = rs.getInt("clearTime");
		dimissionEmpTime = rs.getInt("dimissionEmpTime");
		isClear = rs.getInt("isClear");
	}
	if(isClear == 1)
		attributes = "{samePair:'emldetail',groupOperDisplay:'none'}";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<input type="hidden" name="method" value="clearTime">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context="自动清理">
		<wea:item>启用自动清理</wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isClear" id="isClear" value="1" class="inputstyle" 
				<%if(isClear == 1)out.println("checked=checked");%> onchange="showDetail(this)"/>
		</wea:item>

	</wea:group>
	

	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="<%=attributes %>">
		<wea:item>邮件保留时间</wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;">
				<SELECT  class=InputStyle name="clearTime" id="clearTime"  style="width: 120px;" >
				  	  <option value="1" <%if(clearTime == 1)out.print("selected='selected'"); %>>一周</option>
					  <option value="2" <%if(clearTime == 2)out.print("selected='selected'"); %>>一个月</option>
					  <option value="3" <%if(clearTime == 3)out.print("selected='selected'"); %>>三个月</option>
					  <option value="4" <%if(clearTime == 4)out.print("selected='selected'"); %>>半年</option>
					  <option value="5" <%if(clearTime == 5)out.print("selected='selected'"); %>>一年</option>
				</SELECT>
			</span>
		</wea:item>
		<wea:item>离职人员邮件保留时间</wea:item>
		<wea:item>
			<span style="float:left;margin-right:10px;">
				<SELECT  class=InputStyle name="dimissionEmpTime" id="dimissionEmpTime"  style="width: 120px;" >
				  	  <option value="1" <%if(dimissionEmpTime == 1)out.print("selected='selected'"); %>>一周</option>
					  <option value="2" <%if(dimissionEmpTime == 2)out.print("selected='selected'"); %>>一个月</option>
					  <option value="3" <%if(dimissionEmpTime == 3)out.print("selected='selected'"); %>>三个月</option>
					  <option value="4" <%if(dimissionEmpTime == 4)out.print("selected='selected'"); %>>半年</option>
					  <option value="5" <%if(dimissionEmpTime == 5)out.print("selected='selected'"); %>>一年</option>
				</SELECT>
			</span>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>

