
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />

<%@ include file="/hrm/header.jsp" %>
<HTML><HEAD>
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
<script type="text/javascript">
function showDelPub(_this){
	jQuery(_this).find("span[name=delSpan]").css({"visibility":"visible"});
}
function hideDelPub(_this){
	jQuery(_this).find("span[name=delSpan]").css({"visibility":"hidden"});
}
function delGroup(groupmemberid){

	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		jQuery.ajax({
			type: "post",
			url: "/hrm/group/HrmGroupData.jsp",
			data: {method:"delGroup", groupmemberid:groupmemberid},
			dataType: "JSON",
			success: function(result){
				window.location.reload();
			}
		});
	});
}
function addGroupMember(addedUserid){
	var groupidVal = jQuery("#groupid").val();
	if(!groupidVal || groupidVal == ""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25468,user.getLanguage())%>");
	}else{
		jQuery.ajax({
			type: "post",
			url: "/hrm/group/HrmGroupData.jsp",
			data: {method:"addGroupMember",userid:addedUserid, groupid:groupidVal},
			dataType: "JSON",
			success: function(result){
				window.location.reload();
			}
		});
	}
}
function groupMemberSetting(){
}
</script>
<style type="text/css">
<!--
.grouptop {
	height: 4%;
	padding-top: 20px;
	margin: 10px;
	float: left;
	/**	border-bottom: 3px solid #55BBDD; **/
}

.groupline {
	height: 2%;
	margin-left: 10px;
	width: 100%;
	float: left;
	font-size: 12px;
}

.groupcontent {
	height: 80%;
	margin: 10px;
	float: left;
}

.imgdiv {
	width: 10px;
	height: 10px;
	margin-right: 5px;
}

.button {
	display: inline-block;
	position: relative;
	text-align: center;
	text-decoration: none;
	font: bold 12px/ 25px Arial, sans-serif;
}

.blue {
	background: #30b5ff;
	height: 22px !important;
	width: 48px !important;
	font-size: 12px;
	color: #ffffff !important;
	font-family: "宋体" !important;
	font-weight:lighter;
}

.gray {
	background: #c4ccdc;
	height: 22px !important;
	width: 84px !important;
	font-size: 12px;
	color: #ffffff !important;
	font-family: "宋体" !important;
	font-weight:lighter;
}

.pubGroupDiv {
	float: left;
	width: 220px;
}

.priGroupDiv {
	float: left;
	width: 238px;
}

.pubth {
	background-color: #68a0f5;
	height: 30px;
	font-size: 12px;
	color: #ffffff;
	font-family: "宋体" !important;
	font-weight:lighter;
}

.prith {
	background-color: #75d6e7;
	height: 30px;
	font-size: 12px;
	color: #ffffff;
	font-family: "宋体" !important;
	font-weight:lighter;
}
span .e8_showNameClass {
	font-size: 12px !important;
	font-family: "微软雅黑" !important;
}
-->
</style>
<%

boolean cansave = HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
	
String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();

String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓名*/

String pubGroupSql = " select b.name,a.* from HrmGroup b  left join HrmGroupMembers a on a.groupid = b.id where a.userid="+id+"  and b.type=1 " ;

String priGroupSql = "  select b.name,a.* from HrmGroup b  left join HrmGroupMembers a on a.groupid = b.id where a.userid="+id+"  and b.type=0 " ;

boolean isSelf = false;
if(id.equals(""+user.getUID())){
	isSelf = true;
}
String sqlwhere = "";
String pubGroupUser = GroupAction.getPubGroupUser(user);
String priGroupUser = GroupAction.getPriGroupUser(user);
String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/group/MultiGroupBrowser.jsp?";
String dataBrowser = "/data.jsp?type=hrmgroup";
String canSeeGroupids = pubGroupUser+","+priGroupUser;
if(canSeeGroupids.length() > 0){
	sqlwhere += " ("+Util.getSubINClause(canSeeGroupids, "id", "in")+") ";
}else{
	sqlwhere += " 1 = 2 ";
}
if(!cansave){
	sqlwhere += " and type = 0";
}
browserUrl += "sqlwhere="+xssUtil.put(sqlwhere);
dataBrowser += "&sqlwhere="+xssUtil.put(sqlwhere);
browserUrl += "&selectedids=";

if(pubGroupUser.length() > 0){
pubGroupSql += " and ("+Util.getSubINClause(pubGroupUser, "b.id", "in")+") ";
}else{
pubGroupSql += " and 1=2 ";
}

pubGroupSql +=" order by b.type,b.sn ";
rs.executeSql(pubGroupSql);

if(priGroupUser.length() > 0){
priGroupSql +=" and ("+Util.getSubINClause(priGroupUser, "b.id", "in")+") ";
}else{
priGroupSql += " and 1=2 ";
}
priGroupSql +=" order by b.type,b.sn ";
RecordSet.executeSql(priGroupSql);
 %>
</head>
<BODY style="width:800px;" >
<div class="grouptop" >
<span>
		<brow:browser viewType="0" name="groupid" browserValue="" 
          browserUrl="<%=browserUrl %>"
          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
          completeUrl="<%=dataBrowser %>" 
          browserSpanValue="" width="458px" >
      </brow:browser>
</span>
<div style="float: left;margin-left: 10px;margin-right: 10px;" >
<a href="javascript:addGroupMember(<%=id %>);" class="button blue" >
	<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>
</a>
</div>
<div style="float: left;" >
<a href="/systeminfo/menuconfig/CustomSetting.jsp?_fromURL=2" target="blank" class="button gray">
	<%=SystemEnv.getHtmlLabelNames("81554,68",user.getLanguage())%>
</a>
</div>
      
</div>
<div class="groupline" >
	<%
	if(isSelf){
	%>
	<%=(SystemEnv.getHtmlLabelName(130758,user.getLanguage())+SystemEnv.getHtmlLabelName(130732,user.getLanguage()))%>
	<%
	}else{
	 %>
	<%=(lastname+SystemEnv.getHtmlLabelName(130732,user.getLanguage()))%>
	<%}
	 %>
</div>
		         
<div class="groupcontent" >       
	<div class="pubGroupDiv" style="border: 0.1px solid #e9f1fc;border-radius: 3px;" >
	<table width="100%">
		<thead>
			<tr>
				<th class="pubth" align="center">
				<%=SystemEnv.getHtmlLabelName(17619,user.getLanguage())%>
				</th>
			</tr>
		</thead>
		<tbody>
<%
int pubCount = rs.getCounts();
if(pubCount > 0 ){
	while(rs.next()){
	String pubname = rs.getString("name") ;
	String groupmemberid = rs.getString("id") ;

%>
			<tr style="background-color:#e9f1fc;height: 30px;display:block;margin-bottom:2px;"  onmouseover="showDelPub(this)" onmouseout="hideDelPub(this)" >
				<td align="center" valign="middle" style="display:block;" >
					<div style="width: 100%;height: 100%;padding-top: 2px;">
						<span style="font-size:12px;" ><%=pubname %></span>
						<%
						if(cansave){
						 %>
						<span name = "delSpan" style="float: right;visibility: hidden;padding-right:10px;padding-top:2px;">
						<a href="javascript:delGroup(<%=groupmemberid %>)" ><img style="width:10px;height:10px;" src="/images/pubDel.png" ></a>
						</span>
						<%} %>
					</div>
				</td>
			</tr>
	
<%
}}else{
%>
	<tr><td></td>
	</tr>
	<tr style="background-color:#ebfafd;height:120px;">
	<td align="center">
			<img alt="" src="/images/pubnull.png" />
	</td>
	</tr>
<%}
 %>
		</tbody>
	</table>
	</div>
	
	<div class="priGroupDiv" style="border: 0.1px solid #e9f1fc;border-radius: 3px;" > 
	<table width="100%">
		<thead>
			<tr >
				<th class="prith" align="center" >
				<%=SystemEnv.getHtmlLabelName(17618,user.getLanguage())%>
				</th>
			</tr>
		</thead>
		<tbody>
<%
int priCount = RecordSet.getCounts();

if(RecordSet.next()){

	String priname = RecordSet.getString("name") ;
	String groupmemberid = RecordSet.getString("id") ;
	%>	
	<tr style="background-color:#ebfafd;height: 30px;display:block;margin-bottom:2px;" onmouseover="showDelPub(this)" onmouseout="hideDelPub(this)" >
				<td align="center" valign="middle" style="display:block;" >
					<div style="width: 100%;height: 100%;padding-top: 2px;">
					<span style="font-size:12px;"><%=priname %></span>
					<span name = "delSpan" style="float: right;visibility: hidden;padding-right:10px;padding-top:2px;">
					<a href="javascript:delGroup(<%=groupmemberid %>)" ><img style="width:10px;height:10px;" src="/hrm/images/pubDel.png" ></a>
					</span>
					</div>
				</td>
			</tr>
	
	<%
	
	
	while(RecordSet.next()){
	 priname = RecordSet.getString("name") ;
	 groupmemberid = RecordSet.getString("id") ;
%>
			<tr style="background-color:#ebfafd;height: 30px;display:block;margin-bottom:2px;" onmouseover="showDelPub(this)" onmouseout="hideDelPub(this)" >
				<td align="center" valign="middle" style="display:block;" >
					<div style="width: 100%;height: 100%;padding-top: 2px;">
					<span style="font-size:12px;"><%=priname %></span>
					<span name = "delSpan" style="float: right;visibility: hidden;padding-right:10px;padding-top:2px;">
					<a href="javascript:delGroup(<%=groupmemberid %>)" ><img style="width:10px;height:10px;" src="/images/pubDel.png" ></a>
					</span>
					</div>
				</td>
			</tr>
	
<%
}}else{
%>
	<tr><td></td>
	</tr>
	<tr style="background-color:#ebfafd;height:120px;">
	<td align="center">
			<img alt="" src="/images/pubnull.png" />
	</td>
	</tr>
<%}
 %>
		</tbody>
	</table>
	</div>
</div>
<%
//}
 %>
</body>
</html>

