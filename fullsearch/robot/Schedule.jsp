
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.WorkPlan.MutilUserUtil"%>
<%@page import="weaver.WorkPlan.WorkPlanShareUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%!
public String tc(String di) {
    int c=Util.getIntValue(di,0);
    int i=0;
    String d = "666666888888aaaaaabbbbbbdddddda32929cc3333d96666e69999f0c2c2b1365fdd4477e67399eea2bbf5c7d67a367a994499b373b3cca2cce1c7e15229a36633cc8c66d9b399e6d1c2f029527a336699668cb399b3ccc2d1e12952a33366cc668cd999b3e6c2d1f01b887a22aa9959bfb391d5ccbde6e128754e32926265ad8999c9b1c2dfd00d78131096184cb05288cb8cb8e0ba52880066aa008cbf40b3d580d1e6b388880eaaaa11bfbf4dd5d588e6e6b8ab8b00d6ae00e0c240ebd780f3e7b3be6d00ee8800f2a640f7c480fadcb3b1440edd5511e6804deeaa88f5ccb8865a5aa87070be9494d4b8b8e5d4d47057708c6d8ca992a9c6b6c6ddd3dd4e5d6c6274878997a5b1bac3d0d6db5a69867083a894a2beb8c1d4d4dae54a716c5c8d8785aaa5aec6c3cedddb6e6e41898951a7a77dc4c4a8dcdccb8d6f47b08b59c4a883d8c5ace7dcce";
    return "#" + d.substring(c * 30 + i * 6, c * 30 + (i + 1) * 6);
     
}

%>
<%
//获取用户信息,根据用户信息,获取有权限的公众平台
 int userid=user.getUID(); 
 String userType = user.getLogintype(); 
 String selectUser=""+userid;
 String key=Util.null2String(request.getParameter("key"));
 if(!"".equals(key)){
	 key=URLDecoder.decode(key,"UTF-8");
	 if(key.startsWith("\"")) key=key.substring(1);
	 if(key.endsWith("\"")) key=key.substring(0,key.length()-1);
	 boolean matching=false;
	 //循环查询条件,返回满足名字长度最长的人
	 String sql="select id,lastname,";
	 if(rs.getDBType().equals("oracle")){
		 sql+="length(lastname) as l";
	 }else{
		 sql+="len(lastname) as l";
	 }
	 sql+=" from HrmResource where lastname='"+key+"'";
	 //搜索内容从后截断
	 String tempkey=key;
	 while(tempkey.length()>0){
	 	tempkey=tempkey.substring(0,tempkey.length()-1);
	 	if(!"".equals(tempkey)){
	 		sql+=" or  lastname='"+tempkey+"' ";
	 	}
	 }
	 
	 //搜索内容从前截断
	 tempkey=key;
	 while(tempkey.length()>0){
	 	tempkey=tempkey.substring(1,tempkey.length());
	 	if(!"".equals(tempkey)){
	 		sql+=" or  lastname='"+tempkey+"' ";
	 	}
	 }
	 sql+=" order by l desc";

	 rs.execute(sql);
	 if(rs.next()){
		 selectUser=rs.getString("id");
	 }
 }
 
 String beginDate=TimeUtil.getCurrentDateString();//"2015-05-30";//
 String endDate=beginDate;
 boolean belongshow=MutilUserUtil.isShowBelongto(user);
String belongids="";
if(belongshow){
	belongids=User.getBelongtoidsByUserId(user.getUID());
}
String sql=WorkPlanShareUtil.getShareSql(user);
String overColor = "";
String archiveColor = "";
String archiveAvailable = "0";
String overAvailable = "0";
String oversql = "select * from overworkplan order by workplanname desc";
recordSet.executeSql(oversql);
while (recordSet.next()) {
	String id = recordSet.getString("id");
	String workplanname = recordSet.getString("workplanname");
	String workplancolor = recordSet.getString("workplancolor");
	String wavailable = recordSet.getString("wavailable");
	if ("1".equals(id)) {
		overColor = workplancolor;
		if ("1".equals(wavailable))
			overAvailable = "1";
	} else {
		archiveColor = workplancolor;
		if ("1".equals(wavailable))
			archiveAvailable = "2";
	}
}
if ("".equals(overColor)) {
	overColor = "#c3c3c2";
}
if ("".equals(archiveColor)) {
	archiveColor = "#937a47";
}
 
StringBuffer sqlStringBuffer = new StringBuffer();

sqlStringBuffer
		.append("SELECT C.*,overworkplan.workplancolor FROM (SELECT * FROM ");
sqlStringBuffer.append("(");
sqlStringBuffer
		.append("SELECT name,begindate,begintime ,enddate,endtime,workPlan.id,status,type_n, workPlanType.workPlanTypeColor");
sqlStringBuffer
		.append(" FROM WorkPlan workPlan, WorkPlanType workPlanType");
//显示所有日程，包含已结束日程
sqlStringBuffer.append(" WHERE (workPlan.status = 0 ");
if("1".equals(overAvailable)){
	sqlStringBuffer.append(" or workPlan.status =1 ");
}
if("2".equals(archiveAvailable)){
	sqlStringBuffer.append(" or workPlan.status =2 ");
}
sqlStringBuffer.append(" ) ");
sqlStringBuffer.append(" AND workPlan.deleted <> 1");
sqlStringBuffer
		.append(" AND workPlan.type_n = workPlanType.workPlanTypeId");
sqlStringBuffer.append(" AND workPlan.createrType = '" + userType
		+ "'");

sqlStringBuffer.append(" AND (");
		 
if(!"".equals(belongids)){
	sqlStringBuffer.append("(");
		if (recordSet.getDBType().equals("oracle")) {
			sqlStringBuffer
					.append(" ','||workPlan.resourceID||',' LIKE '%,"
							+ selectUser + ",%'");
		} else {
			sqlStringBuffer
					.append(" ','+workPlan.resourceID+',' LIKE '%,"
							+ selectUser + ",%'");
		}

		StringTokenizer idsst = new StringTokenizer(belongids, ",");
		while (idsst.hasMoreTokens()) {
			String id = idsst.nextToken();
			if (recordSet.getDBType().equals("oracle")) {
				sqlStringBuffer
						.append(" OR ','||workPlan.resourceID||',' LIKE '%,"
								+ id + ",%'");
			} else {
				sqlStringBuffer
						.append(" OR ','+workPlan.resourceID+',' LIKE '%,"
								+ id + ",%'");
			}
		}
		sqlStringBuffer.append(")");
	
}else{
	if (recordSet.getDBType().equals("oracle")) {
	sqlStringBuffer
		.append("  ','||workPlan.resourceID||',' LIKE '%,"
				+ selectUser + ",%'");
	}else{
		sqlStringBuffer
		.append("  ','+workPlan.resourceID+',' LIKE '%,"
				+ selectUser + ",%'");
	}
}
 
		sqlStringBuffer.append(" )");
	 
	sqlStringBuffer.append(" AND (  workPlan.beginDate <= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("' and ");
	sqlStringBuffer.append(" workPlan.endDate >= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("' )");
	sqlStringBuffer.append(" ) A");
	sqlStringBuffer.append(" JOIN");
	sqlStringBuffer.append(" (");
	sqlStringBuffer.append(sql);
	sqlStringBuffer.append(" ) B");
	sqlStringBuffer.append(" ON A.id = B.workId) C");
	 
	sqlStringBuffer.append(" LEFT JOIN overworkplan ON overworkplan.id=c.status ");
	sqlStringBuffer.append(" WHERE shareLevel >= 1");

	sqlStringBuffer.append(" ORDER BY beginDate asc, beginTime ASC");
	
	recordSet.executeSql(sqlStringBuffer.toString());
	
	String begindate1="";
	String begintime="";
	String enddate1="";
	String endTime="";
	Date timeDate=null;
	String id="";
	String name="";
	String color="";
	String title="";
	String showEndDate="";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style type="text/css">
        

		.hand{
			cursor:pointer;
		}
		 
		.planDataEvent{
			width: 100%;
			overflow-y: hidden;
			position: relative;
			height: 100px;
		}
		.planDataEventDiv{
			float:left;
			height: 100px;
			z-index:100;
			overflow: hidden;
			margin-left:20px;
		}
		.planDataEventchd{
			z-index:100;
		}
		.dataEvent{			
			border-width: 0px;
			border-style: solid;
			border-color: #F3F2F2;
			float: left;
			width: 161px;
			margin-right:8px;
			margin-bottom:20px;
			z-index:50;
		}

		.dataEvent2{			
			line-height: 33px;
			float: left;
			height: 33px;
			width: 100%;
			background:#F5F5F5;
			color: #fff;
		}
		.dataEvent2_0{
			float: left;
			margin-top:5px;
			margin-left:25px;
		}
		.dataEvent2_1{			
			margin-left:10px;
			float: left;
			font-size:14px;
		}
		.dataEvent3{	
			float: left;		
			height: 63px;
			display:block;
			overflow:hidden; 
			text-overflow: ellipsis;
			-o-text-overflow:ellipsis; 
			width: 159px;
			border-left:#DFDFDF 1px solid;
			border-right:#DFDFDF 1px solid; 
			border-bottom:#DFDFDF 1px solid; 
		}
		.dataEvent3_0{
			margin:10px;
			line-height:24px;
		}
		.nameTitle{
			margin-left:20px;
			height:30px;
			line-height: 30px;
			font-size:14px;
		}
		.noSchedule{
		  font-size: 14px;
		  float:left;
		  margin-left:15px;
		  color:#9d9d9d;
		}
		
		.sTitle a{
			color: #42a4fe;
		}
 		.arrow{
 			float:left;
 			height:100px;
 			width:12px;
 			cursor:pointer;
 			margin-top:40px;
 			z-index:105;
 			position: absolute;
 		}
 		.left{
 			width:20px;
 		}
 		.right{
 			right:20px;
 		}
</style>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32642,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<div id="wpDiv" >
			<table id="Calendar" width="100%" border=0>
		        <tr>
					<td>
						<div class='nameTitle'>
							<div style="float: left;"><a style='hand' href="/hrm/resource/HrmResource.jsp?id=<%=userid %>" target="_blank"><%=ResourceComInfo.getLastname(selectUser) %></a>
							&nbsp;<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>
							</div>
							<div class='sTitle' style="float: left;margin-left: 50px;"><a style='hand' href='javascript:void(0)' onclick='doMore()'><%=SystemEnv.getHtmlLabelName(81408,user.getLanguage())%></a></div>
						</div>
					</td>
				</tr>
				<tr>
		            <td>
		            	 
	           				
	           					
	           					<%
	           					if(recordSet.getCounts()>0){
	           						int divH=140;
	           						if(recordSet.getCounts()<5){
	           							divH=33*recordSet.getCounts();
	           						}
	           					%>
	           				<div id="planDataEvent" class="planDataEvent" >
	           					<div id="leftArrow" class="arrow left">
	           						<img onclick="left()" src="/fullsearch/img/leftArrow_wev8.png" onmouseover="this.src='/fullsearch/img/leftArrow_hot_wev8.png'" onmouseout="this.src='/fullsearch/img/leftArrow_wev8.png'" border="0">
	           					</div>
	           					<div id="planDataEventDiv" class="planDataEventDiv">
		           					<div id="planDataEventchd" class="planDataEventchd" style="position: relative;left: 0px;">
		           					<%	
		           						int i=1;
		           						while (recordSet.next()) {
		           								begindate1=recordSet.getString("begindate");
		           								if("".equals(begindate1)) continue;
		           								id=recordSet.getString("id");
		           								begintime=recordSet.getString("begintime").trim();
		           								enddate1=recordSet.getString("enddate").trim();
		           								begintime="".equals(begintime)?"00:00":begintime;
		           								name=recordSet.getString("name");
		           								timeDate=TimeUtil.getString2Date(begintime,"HH:mm");
		           								
		           								if(recordSet.getInt("status")==0){
		           									color=recordSet.getString("workPlanTypeColor");//颜色
		           								}else{
		           									color=recordSet.getString("workplancolor");//颜色
		           								}
		           								 
		           								if (!"".equals(enddate1)) {
			           								showEndDate=enddate1; 
		           									endTime = recordSet.getString("endtime");
		           									if ("".equals(endTime.trim())) {
		           										endTime = "23:59";
		           									}
		           								}else{
		           									showEndDate="";
		           									enddate1=begindate1;
		           									endTime = "23:59";
		           								}
		           								title=begindate1+" "+begintime+("".equals(showEndDate)?"":" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+(enddate1+" "+endTime));
		           					%>
		           					 <div class="hand dataEvent" dateTarget="<%=i++ %>" onclick="clickData(<%=id %>)" title="<%=title+"\n"+ name%>">
									     <div class="dataEvent2" style="background:<%=tc(color) %>;">
										     <div class="dataEvent2_0"><img src="/fullsearch/img/time_wev8.png"></div>
										     <div class="dataEvent2_1"><%=begintime %>&nbsp;&nbsp;<%=timeDate.getHours()<12?"AM":"PM" %></div>
									     </div>
									     <div class="dataEvent3"><div class="dataEvent3_0"><%=name %></div></div>
								     </div>
		           					<%	}%>
		           					</div>
	           					</div>
	           					<div id="rightArrow" class='arrow right' ><img onclick="right()" src="/fullsearch/img/rightArrow_wev8.png" onmouseover="this.src='/fullsearch/img/rightArrow_hot_wev8.png'" onmouseout="this.src='/fullsearch/img/rightArrow_wev8.png'" border="0"></div>
	           					<%}else{%>
	           					<div id="planDataEvent" class="planDataEvent" style="height:60px;background: #f7f7f7">
	           						<div id="planDataEventchd1" style='margin-bottom:20px;line-height: 60px;height:60px'>
			           					<div id="showDiv" style="position:absolute;">
				           					<div style='float:left;margin-top:5px;'><img style="vertical-align:text-bottom" width="22px" height="22px" src='/fullsearch/img/noSchedule_wev8.png' border="0"></div>
											<div class='noSchedule'><%=SystemEnv.getHtmlLabelName(83506, user.getLanguage())%></span>
										</div>
									</div>
								</div>
	           					<%}%>
	           				
		            	</div>
		            </td>
		        </tr>
		    </table>
		    </div>
	</td>	 
 </td>
</tr>
</table>

<script language="javascript">
var current=1;
var totalNum=1;
var canShow=1;
var maxCanShow=1;
 	//点击数据
 	function clickData(id){
 		var url='/workplan/data/WorkPlanDetail.jsp?from=1&workid='+id;
 		//openFullWindowHaveBar(url);
 		if(window.top.Dialog){
			calendarDialog = new window.top.Dialog();
		} else {
			calendarDialog = new Dialog();
		};
	  	calendarDialog.URL =url;
	  	calendarDialog.Width = 600;
		calendarDialog.Height = 600;
	  	calendarDialog.checkDataChange = false;
	    calendarDialog.Title="<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	    calendarDialog.show();
 	}
  
  
  function doMore(){
  		var w=1100;
  		var h=600;
  		if(window.name&&window.name!=''){
  			w=$(window.parent).width()-20;
  			h=$(window.parent).height()-20;
  		}
  		var url="/workplan/data/WorkPlanView.jsp?fromES=1&isShare=1&selectUser=<%=selectUser%>";
 		
 		if(window.top.Dialog){
			calendarDialog = new window.top.Dialog();
		} else {
			calendarDialog = new Dialog();
		};
	  	calendarDialog.URL =url;
	  	calendarDialog.Width = w;
		calendarDialog.Height = h;
	  	calendarDialog.checkDataChange = false;
	    calendarDialog.Title="<%=ResourceComInfo.getLastname(selectUser) +" "+SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	    calendarDialog.show();
	    
  }
 
 function right(){
 	
 	 var left=$("#planDataEventchd").position().left;
 	 if(left>=0&&left<50){
 	 	left=0;
 	 }else{
 	 	left-=20;
 	 }
 	  
 	  if(current==1){
 	 	$('#leftArrow').show();
 	 	//$('#planDataEventDiv').css("margin-left","20px");
 	 }
 	 current++;
 	 
	 $("#planDataEventchd").animate({left:(left-169)+"px"});
	 if(current+canShow>totalNum){
	 	$('#rightArrow').hide();
	 }
 
 }
 
 function left(){
 	 current--;
 	 var left=$("#planDataEventchd").position().left;
 	 left-=20;
 	 if(current==1){
 	 	$('#leftArrow').hide();
 	 	//$('#planDataEventDiv').css("margin-left","5px");
 	 }
 	 
	 $("#planDataEventchd").animate({left:(left+169)+"px"});
	 
 	 $('#rightArrow').show();
 } 
 
 function refashDate(){
 	if(calendarDialog &&calendarDialog.closed && hasRfdh ){
 		hasRfdh = false;
   		reGetDate();
 	}
 }
 
  
  function closeByHand(){
  	calendarDialog.close();	
  }
  
  function refreshCal(){
	calendarDialog.close();	
	
}


$(document).ready(function() {
	 $('#leftArrow').hide();
	 
	 if(window.name&&window.name!=''){
   		parent.document.getElementsByName(window.name)[0].height=jQuery("#Calendar").height();
   	 }
   	 if(jQuery("#planDataEventchd1")&&jQuery("#planDataEventchd1").length>0){//没有日程
   	 	var w=(jQuery("#planDataEventchd1").width()-120)/2;
   	 	jQuery('#showDiv').css("left",w+"px");
   	 }else{//有日程
   	 	$('#planDataEventDiv').width(jQuery("#planDataEvent").width()-jQuery("#leftArrow").width()-jQuery("#rightArrow").width()-25);
   	 	
   	 	totalNum=$('.dataEvent').length;
   	 	 
   	 	canShow=Math.floor($('#planDataEventDiv').width()/169);
   	 	maxCanShow=Math.ceil($('#planDataEventDiv').width()/169);
   	 	 
   	 	if(totalNum<=canShow){
   	 		$('#rightArrow').hide();
   	 	}
   	 	 
   	 	$('#planDataEventchd').width(10000);
   	 	
   	 	
   	 	
   	 }
});



</script>

</HTML>
