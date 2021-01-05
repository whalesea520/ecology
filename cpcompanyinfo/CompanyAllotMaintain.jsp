
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
		<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"
			type="text/css" />
		<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet"
			type="text/css" />
		<link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet"
			type="text/css" />
		<link href="/newportal/style/Contacts_wev8.css" rel="stylesheet"
			type="text/css" />
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<jsp:include page="/systeminfo/WeaverLangJS.jsp">

			<jsp:param name="languageId" value="<%=user.getLanguage()%>" />

		</jsp:include>

		
		<script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
</head>


<BODY>
	<div class="OBoxW PTop5">
		<div class="OBoxTit">
			<span class="FontYahei cWhite PL20 PTop5 FL"><%=SystemEnv.getHtmlLabelName(23388,user.getLanguage()) %>：</span>
			<span class="FL PT3 PLeft5">
				<select class="OSelect" id="subcompany" onchange="synNoselect();">
					<%
					String subcompanysql = "select id,subcompanyname from hrmsubcompany order by id";
					rs.execute(subcompanysql);
					%>
					<option value=""><%=SystemEnv.getHtmlLabelName(30977,user.getLanguage()) %></option>
					<%
					while(rs.next()){
					%>
						<option value="<%=rs.getString("id") %>"><%=rs.getString("subcompanyname") %></option>
					<%} %>
				</select>
			</span>
			<span class="FontYahei cWhite PLeft5 PTop5 FL"><%=SystemEnv.getHtmlLabelName(30978,user.getLanguage()) %></span>
			
			<span class="FL PT3 PLeft5">
				<select class="OSelect" id="noselect" onchange="syncompany()">
					<option value=""><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %></option>
					<option value="0"><%=SystemEnv.getHtmlLabelName(30979,user.getLanguage()) %></option>
					<option value="1"><%=SystemEnv.getHtmlLabelName(30980,user.getLanguage()) %></option>
				</select>
			</span>
			
			<span class="FontYahei cWhite PL20 PTop5 FL"
				style="padding-top: 3px;">
				<ul class="OBtnUl FL cBlack6">
					<li>
						<em><i><a href="javascript:queryCompany();"><%=SystemEnv.getHtmlLabelName(30947,user.getLanguage()) %></a> </i> </em>
					</li>
				</ul> 
			</span>
			<ul class="OContRightMsg cBlack FR MT5">
				<li>
					<a id="callBtn" href="javascript:allotCompany();" class="hover"><div>
							<div>
								<%=SystemEnv.getHtmlLabelName(30981,user.getLanguage()) %>
							</div>
						</div>
					</a>
				</li>
			</ul>
		</div>
	</div>
	<div id="listcontent" class="MT5">
		<iframe id="frame2list" src="CompanyAllotList.jsp" width="100%" height="100%" frameborder=no scrolling=no>
		
		</iframe>
	</div>	
</BODY>

<script language="javascript">
	$(document).ready(function(){
	
	});
	
	function queryCompany(){
		jQuery("#frame2list").attr('src',"CompanyAllotList.jsp?feCompany="+jQuery('#subcompany').val()+"&isselected="+jQuery('#noselect').val());
	}
	
	function allotCompany(){
		if(jQuery('#subcompany').val()==""){
			alert("<%=SystemEnv.getHtmlLabelName(30982,user.getLanguage()) %>");
		}else{
			var _requestids=jQuery("#frame2list")[0].contentWindow.getrequestids();
			if(_requestids==""){
				alert("<%=SystemEnv.getHtmlLabelName(30983,user.getLanguage()) %>");
			}else{
				var params={
					method:"allotCompany",
					subcompany:jQuery('#subcompany').val(),
					requestids:_requestids
				};
				jQuery.post("/cpcompanyinfo/action/CPCompanySetOperate.jsp",params,function(data){
					alert("<%=SystemEnv.getHtmlLabelName(30984,user.getLanguage()) %>");
				});
				
			}
		}
	}
	
	function synNoselect(){
		if(jQuery('#subcompany').val()!="")
		{
			jQuery('#noselect').get(0).selectedIndex = 2;
		}else{
			jQuery('#noselect').get(0).selectedIndex = 1;
		}
	}
	
	function syncompany(){
		if(jQuery('#noselect').val()==0){
			jQuery('#subcompany').get(0).selectedIndex = 0;
		}
	}
</script>
<style>
.Nav{
	cursor: pointer;
}
</style>
</HTML>