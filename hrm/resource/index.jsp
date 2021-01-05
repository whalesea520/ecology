<!DOCTYPE html>

<%@ page language="java" import="java.util.*,java.text.*"  pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workflowtype" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="/css/ecology8/abutton_wev8.css" type="text/css" />
    <style>
        *{ margin:0; padding:0;}
        .help { padding: 20px; line-height: 18px; list-style: none; font-size: 12px;}
        .help td{color:#848585;}
         a{color:#1d98f8;cursor: pointer;} 
        .help .b{ height: 36px; font-weight: bold; line-height:36px;color:#373737;}
        .explain { padding: 10px; list-style: none;background-color: #FFFFFF; font-size: 12px;border-color: #adadad;border-style: solid;border-width: 1px;color:#848585;}

/* The header and footer */
.headfoot {display:block; height:auto; background:#F7F7FA; color:#000000; text-align:center; padding:5px;font-size:16px;}
.hfoot {display:block; height:auto; background:#F7F7FA; color:#000000; text-align:center; padding:5px;font-size:12px;}
.bfoot {display:block; height:auto; background:#F7F7FA; color:#000000; text-align:center; padding:5px;font-size:12px;}
.headfoot1 {display:block; height:auto; background:#ffffff; color:#000000; text-align:center;font-size:16px;}
.hfoot1 {display:block; height:auto; background:#ffffff; color:#6c6c6c; text-align:center;font-size:14px;}

.headfoot2 {display:block; height:auto; background:#F7F7FA; color:#000000; text-align:center; padding:1px;font-size:16px;}
.hfoot2 {display:block; height:auto; background:#F7F7FA; color:#FFFFFF; text-align:center; padding:1px;font-size:14px;}
.bfoot2 {display:block; height:auto; background:#F7F7FA; color:#000000; text-align:center; padding:1px;font-size:12px;}
/* This bit does all the work */
#container {position:relative; display:block; background:#F7F7FA;width: 100%;float:left;}
#container1 {position:relative; display:block; background:#ffffff;width: 100%;float:left;}
#inner {display:block; margin-left:-100px; margin-right:-100px; padding:1px;}
#left {
float:left;
border:0px #ff0 solid;
height:auto;
background:#F7F7FA;
}
#left1 {
float:left;
border:0px #ff0 solid;
height:auto;
background:#ffffff;
}
#left2 {
float:left;
margin-left:1px;
border:0px #ff0 solid;
height:auto;
width:99%;
background:#ffffff;
}
.clear {clear:both;}
#topdiv {
	
}
#left3 {
float:left;
border:0px #ff0 solid;
height:auto;
width:200px；
}
#right3 {
float:right;
border:0px #ff0 solid;
margin-right:38px;
height:auto;
width:150px;
text-align:center;
}
#left4 {
float:right;
border:0px #ff0 solid;
height:auto;
margin-right: 15px;
}



.btstyle01{
display:block;
width:90px;
height:30px;
text-align:center;
line-height:30px;
cursor:pointer;
background:#43b2ff;
color:#FFFFFF;
}

.btstyle02{
display:block;
width:90px;
height:30px;
text-align:center;
line-height:30px;
cursor:pointer;
background:#18a0ff;
color:#FFFFFF;
}

.spaniwfback01{
float:left;
text-align:center;
line-height:15px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
text-decoration:none;
background:url("/images/ecology8/hrm/department_wev8.png") top center no-repeat;
}

.spaniwfback001{
float:left;
text-align:center;
line-height:15px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
text-decoration:none;
background:url("/images/ecology8/hrm/back1_wev8.png");
}

.spaniwfback02{
float:left;
text-align:center;
line-height:15px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
text-decoration:none;
/*background:url("/images/ecology8/hrm/admin_wev8.png")top center no-repeat;*/
background-image:url('/images/ecology8/hrm/admin_wev8.png');
background-repeat:no-repeat;
background-position-x:center;
background-position-y:top;
}

.spaniwfback002{
float:left;
text-align:center;
line-height:15px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
text-decoration:none;
background:url("/images/ecology8/hrm/back2_wev8.png");
}

#aaa{
float:left;
width:75px;
height:11px;
margin-top:48px;
background:url("/images/ecology8/workflow/wfline_wev8.png");
}
*{
		font-family:"微软雅黑","宋体";
	}
	.e8_contentAbstract{
		width:100%;
		height:368px;
		background-color:#f7f7fa;
		border-bottom:1px solid #efeef4;
	}
	.e8_dirHot{
		width:45%;
		float:left;
		margin-left:15px;
	}
	
	.e8_dirHotHead{
		border-bottom:2px solid rgb(204,204,204);
		width:100%;
		height:30px;
		line-height:30px;
		margin-bottom:6px;
		color:#3f3f3f;
		font-size:14px;
	}
	
	.e8_logAbstract{
		margin-top:30px;
		margin-left:25px;
	}
	
	.e8_progress{
		display:inline-block;
		height:12px;
	}
	
	.e8_progress_0{
		background-color:#1ba2e1;
	}
	.e8_progress_1{
		background-color:#48b5e7;
	}
	.e8_progress_2{
		background-color:#75c8e7;
	}
	.e8_progress_3{
		background-color:#a3daf2;
	}
	.e8_progress_4{
		background-color:#d1ecf8;
	}
	
	.e8_ranking{
		color:#fff;
		text-align:center;
		background-repeat:no-repeat;
		background-position:50% 50%;
		width:16px;
		height:16px;
		float:left;
	}
	
	.e8_content{
		color:#3f3f3f;
		float:left;
		margin-left:10px;
		width:120px;
		overflow:hidden;
		white-space:nowrap;
		text-overflow:ellipsis;
	}
	
	.e8_logcontent{
		color:#b2b2b2;
		float:left;
		margin-left:10px;
		width：60px;
		overflow:hidden;
		white-space:nowrap;
		text-overflow:ellipsis;
	}
	
	.e8_progress_div{
		float:left;
		margin-left:30px;
		width:55%;
	}
	
	.e8_progress_log_div{
		float:left;
		margin-left:30px;
		width:70%;
	}
	
	.e8_progress_log_div1{
		float:left;
		margin-r:30px;
		width:70%;
	}
	
	.e8_line_sep{
		width:1px;
		background-color:#d8d8d8;
		position:absolute;
		left:8px;
		top:12px;
		height:142px;
	}
	
	.e8_noData{
		font-size:12px;
		color:#3f3f3f;
	}
</style>
</head>
<%
List<Map<String,String>> departList = new ArrayList<Map<String,String>>();
List<Map<String,String>> adminList = new ArrayList<Map<String,String>>();

List datelistfirst = new ArrayList();
List datelistlast = new ArrayList();
List showdatelist = new ArrayList();

try{
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Calendar calendar = Calendar.getInstance();
	
	for(int n = 0;n<5;n++){
		//yyyy-MM-dd 第一天
		int index = 0;
		if(n!=0) index=-1;
		calendar.add(Calendar.MONTH, index);
		calendar.set(Calendar.DAY_OF_MONTH,1);
		datelistfirst.add(format.format(calendar.getTime()));
		//yyyyMM
		Date date = calendar.getTime();
		showdatelist.add(sdf.format(date));
		//yyyy-MM-dd 最后一天
    calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));  
    datelistlast.add(format.format(calendar.getTime()));
        
    Map<String,String> departmap = new HashMap<String,String>();
    departmap.put("opdate", sdf.format(date));
    departmap.put("count", "0");
		departList.add(departmap);
		
    Map<String,String> adminmap = new HashMap<String,String>();
    adminmap.put("opdate", sdf.format(date));
    adminmap.put("count", "0");
		adminList.add(adminmap);
	}
}catch(Exception e){
	
}
//开始取数
int subcompany=0, department=0, resource=0;//分部 部门 人员
int right=0, role=0, admin=0;//权限 角色 管理员

String sql = "";
sql = "select count(*) from hrmsubcompany where (canceled is null or canceled = '0' or canceled = '')";
rs.executeSql(sql);
if(rs.next())subcompany = rs.getInt(1);
sql = "select count(*) FROM HrmDepartment where (canceled is null or canceled = '0' or canceled = '')";
rs.executeSql(sql);
if(rs.next())department = rs.getInt(1);
sql = "select count(*) FROM HrmResource where (status =0 or status = 1 or status = 2 or status = 3)";
rs.executeSql(sql);
if(rs.next())resource = rs.getInt(1);

sql = "select COUNT(*) from SystemRights";
rs.executeSql(sql);
if(rs.next())right = rs.getInt(1);
sql = "select COUNT(*) from hrmroles";
rs.executeSql(sql);
if(rs.next())role = rs.getInt(1);
sql = "SELECT COUNT(*) FROM HrmResourceManager";
rs.executeSql(sql);
if(rs.next())admin = rs.getInt(1);

//取使用情况
for(int i = 0;i<showdatelist.size();i++){
	String datetempfirst = datelistfirst.get(i).toString();
	String datetemplast = datelistlast.get(i).toString();
	String showdatetemp = showdatelist.get(i).toString();

	//10 总部 11 分部 12 部门 29 人力资源
	sql = "SELECT count(distinct relatedid) as c FROM SysMaintenanceLog WHERE operateitem IN(10,11,12,29) "
			+ "AND  operatedate >= '"+ datetempfirst+ "' AND operatedate <= '"+ datetemplast+ "'";
	rs.executeSql(sql);
	if(rs.next()){
		Map<String,String> m = null;
		for(Map<String,String> tmp : departList){
			if(tmp.get("opdate").equals(showdatetemp)){
				m=tmp;
				break;
			}
		}
		m.put("opdate",showdatetemp);
		m.put("count",rs.getString("c"));
	}

	//102 功能权限 103 机构权限 28 权限组  16 角色 32  角色成员
	sql = "SELECT count(distinct relatedid) as c FROM SysMaintenanceLog WHERE operateitem IN(102,103, 28, 16, 32) "
		  + "AND  operatedate >= '"+ datetempfirst+ "' AND operatedate <= '"+ datetemplast+ "'";
	rs.executeSql(sql);
	while(rs.next()){
		Map<String,String> m = null;
		for(Map<String,String> tmp : adminList){
			if(tmp.get("opdate").equals(showdatetemp)){
				m=tmp;
				break;
			}
		}
		m.put("opdate",showdatetemp);
		m.put("count",rs.getString("c"));
	}
}

%>
<body>
<div style="min-width:1000px;overflow:hidden;">
<div id="container" style="border-bottom:1px solid #efeef4;">
<div style="margin:0 42px 0 42px;">
<div style="width:100%;height:30px!important;float:left;background:#F7F7FA;"></div>
<div id="left" style="width:100%;">
	<div class="headfoot2"><img src="/images/ecology8/hrm/root_wev8.png" /></div>
	<div class="hfoot2" style="text-align:center;margin-top: -10px">
		<div style="width:100%;text-align:center;height:67px;">
			<div class="spaniwfback01" style="background-image:url('/images/ecology8/hrm/department_wev8.png')top center no-repeat;">
				<div style="text-align:center;line-height:42px;font-size:24px;width:65px;height:65px;">
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:14px;color:#000000;">
					<%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%>
				</div>
				<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
				<div style="width:222px; height:12px; border-top:1px solid #D8D8D8; border-left:1px solid #D8D8D8; border-right:1px solid #D8D8D8;margin:0 auto;">
					<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
				</div>
				<div class="hfoot2" style="text-align:center;">
				<div style="width:328px;height:67px;">
					<div class="spaniwfback001" >
						<div style="height:42px;width: 100px;text-align:center;line-height:42px;font-size:24px;">
							<%=subcompany %>
						</div>
						<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
							<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						</div>
					</div>
					<div style="width:14px!important;height:1px;float:left;"></div>
					<div class="spaniwfback001" >
						<div style="height:42px;width: 100px;text-align:center;line-height:42px;font-size:24px;">
							<%=department %>
						</div>
						<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
							<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						</div>
					</div>
					<div style="width:14px!important;height:1px;float:left;"></div>
					<div class="spaniwfback001" >
						<div style="height:42px;width: 100px;text-align:center;line-height:42px;font-size:24px;">
							<%=resource %>
						</div>
						<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
							<%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%>
						</div>
					</div>
				</div>
			</div>
			</div>
			<div style="width:14px!important;height:1px;float:left;"></div>
			<div class="spaniwfback02" style="">
				<div style="text-align:center;line-height:42px;font-size:24px;width:65px;height:65px;">
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:14px;color:#000000;">
					<%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%>
				</div>
				<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
				<div style="width:222px; height:12px; border-top:1px solid #D8D8D8; border-left:1px solid #D8D8D8; border-right:1px solid #D8D8D8;margin:0 auto;">
					<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
				</div>
				<div class="hfoot2" style="text-align:center;">
				<div style="width:328px;height:67px;">
					<div class="spaniwfback002" >
						<div style="height:42px;width: 100px;text-align:center;line-height:42px;font-size:24px;">
							<%=right %>
						</div>
						<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
							<%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%>
						</div>
					</div>
					<div style="width:14px!important;height:1px;float:left;"></div>
					<div class="spaniwfback002" >
						<div style="height:42px;width: 100px;text-align:center;line-height:42px;font-size:24px;">
							<%=role %>
						</div>
						<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
							<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
						</div>
					</div>
					<div style="width:14px!important;height:1px;float:left;"></div>
					<div class="spaniwfback002" >
						<div style="height:42px;width: 100px;text-align:center;line-height:42px;font-size:24px;">
							<%=admin %>
						</div>
						<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
							<%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>
						</div>
					</div>
				</div>
			</div>
			</div>
		</div>
	</div>
</div>
<div style="width:100%;height:48px!important;float:left;background:#F7F7FA;"></div>
</div>
</div>
<div style="background:rgb(204,204,204);width:89.5%;height:2px!important;margin-left:39px;"></div>
<div style="width:100%;height:15px!important;float:left;"></div>
<div id="logAbstract" class="e8_logAbstract">
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(125010,user.getLanguage())%>
  			</div>
  			<div>
  				<%
  				int total = 0;
  				total = 0;
  				for(int i=0;i<departList.size();i++){ 
  					Map<String,String> m = departList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					if(total<count)total=count;
  				}
  				for(int i=0;i<departList.size();i++){ 
  					Map<String,String> m = departList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  				%>
  					<div style="margin-top:20px;">
  						<div class="e8_ranking" style="background-image:url(/images/ecology8/doc/ranklog_<%=i==0?0:1 %>_wev8.png);"></div>
  						<div class="e8_logcontent"><%= m.get("opdate")%></div>
  						<div class="e8_progress_log_div">
  							<span title="<%=count %>" id="departlog_<%= m.get("opdate")%>" class="e8_progress e8_progress_<%=i %>" style="width:200px;"></span>
  						</div>
  						<div style="clear:both;"></div>
  					</div>
  				<%} %>
  			</div>
  		</div>
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(125011,user.getLanguage())%>
  			</div>
  			<div style="position:relative;">
  				<div class="e8_line_sep"></div>
	  				<%
	  				total = 0;
	  				for(int i=0;i<adminList.size();i++){ 
	  					Map<String,String> m = adminList.get(i);
	  					int count = Util.getIntValue(m.get("count"),0);
	  					if(total<count)total=count;
	  				}
	  				for(int i=0;i<adminList.size();i++){ 
	  					Map<String,String> m = adminList.get(i);
	  					int count = Util.getIntValue(m.get("count"),0);
	  				%>
  					<div style="margin-top:20px;">
  						<div class="e8_ranking" style="background-image:url(/images/ecology8/doc/ranklog_<%=i==0?0:1 %>_wev8.png);"></div>
  						<div class="e8_logcontent"><%= m.get("opdate")%></div>
  						<div class="e8_progress_log_div">
  							<span title="<%=count %>" id="adminlog_<%= m.get("opdate")%>" class="e8_progress e8_progress_<%=i %>" style="width:200px;"></span>
  						</div>
  						
  						<div style="clear:both;"></div>
  					</div>
  				<%} %>
  			</div>
  		</div>
  		<div style="clear:both;"></div>
</div>
<div style="width:100%;height:30px!important;"></div>
<script type="text/javascript">
$(window).resize(function(){                
	jQuery(".spaniwfback01").css("margin-left", ((jQuery(".headfoot2").width()/2)-330)-5);             
 });   
jQuery(document).ready(function () {
	jQuery(".spaniwfback01").css("margin-left", ((jQuery(".headfoot2").width()/2)-330)-5);
	<%
		total = 0;
		for(int i=0;i<departList.size();i++){ 
			Map<String,String> m = departList.get(i);
			int count = Util.getIntValue(m.get("count"),0);
			if(total<count)total=count;
		}
		
		for(int i=0;i<departList.size();i++){ 
			Map<String,String> m = departList.get(i);
			int count = Util.getIntValue(m.get("count"),0);
			String opdate = m.get("opdate");
			String progress = (count*1.0/total*100)+"%";	
	
		%>
			if (<%=count%> == 0) {
				$("#departlog_<%=opdate %>").html("<%=SystemEnv.getHtmlLabelName(83781,user.getLanguage())%>").css("color","#b2b2b2").removeClass("e8_progress_<%=i%>");
			} else {
				$("#departlog_<%=opdate %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
			}
	<%  } %>
	
		<%
		total = 0;
		for(int i=0;i<adminList.size();i++){ 
			Map<String,String> m = adminList.get(i);
			int count = Util.getIntValue(m.get("count"),0);
			if(total<count)total=count;
		}
		for(int i=0;i<adminList.size();i++){ 
			Map<String,String> m = adminList.get(i);
			int count = Util.getIntValue(m.get("count"),0);
			String opdate = m.get("opdate");
			String progress = (count*1.0/total*100)+"%";	
		%>
			if (<%=count%> == 0) {
				$("#adminlog_<%=opdate %>").html("<%=SystemEnv.getHtmlLabelName(83781,user.getLanguage())%>").css("color","#b2b2b2").removeClass("e8_progress_<%=i%>");
			} else {
				$("#adminlog_<%=opdate %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
			}
	<%  } %>
}); 
</script>
</div>
</body>
</html>
