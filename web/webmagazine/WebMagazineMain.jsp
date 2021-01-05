
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	.ztree li div button{
		height:30px;
	}
</style>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(92,user.getLanguage());
String needfav ="1";
String needhelp ="";
String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
if(subcompanyId.equals("")){
	subcompanyId = Util.null2String(session.getAttribute("docdftsubcomid"));
	if(isUseDocManageDetach){
	String hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WebMagazine:Main",-1);
	
	if(!hasRightSub.equals("")){
	
	 subcompanyId=hasRightSub;
    }
	session.setAttribute("hasRightSub",hasRightSub);
	session.setAttribute("hasRightSub2",hasRightSub);
	}
}
session.setAttribute("webMagazineType_subcompanyid",subcompanyId);
int detachable = Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
%>
<BODY>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/js/ecology8/docs/DocWebMagazine_wev8.js"></script>

<script type="text/javascript">
	var demoLeftMenus = [<%
		String sql = "select * from WebMagazineType";
		if(detachable==1){
			sql += " where subcompanyid in ( "+subcompanyId+")";
		}
		sql += " order by id";
		RecordSet.executeSql(sql);
		int j = 0;
		String typeID = "";
		while(RecordSet.next()){
			j++;
			typeID = RecordSet.getString("id");
			rs.executeSql("select count(*) from WebMagazine where typeID = "+typeID);
			int ccount = rs.next()?rs.getInt(1):0;
	%>
			{name:"<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>",
			 numbers:{
			 	magaNum:"<%=ccount%>"
			 },
			 hasChildren:true,
			 attr:{
			 	url:"DocWebTab.jsp?_fromURL=2&typeID=<%=RecordSet.getString("id")%>"
			 },
			 submenus:[
			 	<% 
			 		rs.executeSql("select * from WebMagazine where typeID = "+typeID+" order by releaseYear desc,name desc");
			 		int i=0;
			 		while(rs.next()){
			 			i++;
			 	%>
			 			{
			 				name:"<%=rs.getString("releaseYear")+SystemEnv.getHtmlLabelName(445,user.getLanguage())+Util.toScreen(rs.getString("name"),user.getLanguage())%>",
			 				hasChildren:false,
			 				numbers:{
			 					magaNum:"0"
			 				},
			 				attr:{
			 					url:"DocWebTab.jsp?_fromURL=3&id=<%=rs.getString("id")%>"
			 				}
			 			}<%=i==ccount?"":","%>
			 	<%	}
			 	%>
			 ]	
			}<%=RecordSet.getCounts()==j?"":","%>
	<%		
		}
	%>
	];
	
	function gotoInitPage(){
		window.location.href = "/web/webmagazine/WebMagazineMain.jsp";
	}
</script>


<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border:none;">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span onclick="gotoInitPage();"><%=SystemEnv.getHtmlLabelNames("332,31516",user.getLanguage()) %></span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
			
		</td>
		<td rowspan="2">
			<iframe src="DocWebTab.jsp" id="flowFrame" name="flowFrame" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:226px;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>


</script>
</body>
</html>