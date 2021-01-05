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
.hfoot2 {display:block; height:auto; background:#F7F7FA; color:#000000; text-align:center; padding:1px;font-size:14px;}
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
width:100px;
height:67px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
color:#ffffff;
text-decoration:none;
background:url("/images/ecology8/workflow/wfback01_wev8.png");
}
.spaniwfback02{
float:left;
text-align:center;
line-height:15px;
width:100px;
height:67px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
color:#ffffff;
text-decoration:none;
background:url("/images/ecology8/workflow/wfback02_wev8.png");
}
.spaniwfback03{
margin:0 auto;
line-height:15px;
width:100px;
height:67px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
color:#ffffff;
text-decoration:none;
background:url("/images/ecology8/workflow/wfback03_wev8.png");
}
.spaniwfback04{
float:left;
text-align:center;
line-height:15px;
width:100px;
height:67px;
font-family:"微软雅黑",YaHei,"黑体";
font-size:14;
color:#ffffff;
text-decoration:none;
background:url("/images/ecology8/workflow/wfback04_wev8.png");
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
		width:75%;
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
  	List<Map<String,String>> secList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> logList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> logListshow = new ArrayList<Map<String,String>>();
  	int formnum = 0;//表单数
  	int useform = 0;//在用数
  	
  	int workflownum = 0;//流程数
  	int useworkflow = 0;//在用流程数
  	
  	int reportnum = 0;//报表数

  	int interfacenum = 0;//接口总数
  	int useinterface = 0;//在用接口数
  	String sql = "";
  	String sql2 = "";
  	
  	List datelistfirst = new ArrayList();
  	List datelistlast = new ArrayList();
  	List showdatelist = new ArrayList();
	try{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); 
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMM");
		SimpleDateFormat df=new SimpleDateFormat("yyyy-MM");
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
	        
	        Map<String,String> map = new HashMap<String,String>();
	  		map.put("opdate", sdf.format(date));
	  		map.put("count", "0");
	  		logList.add(map);
	  		
	        Map<String,String> mapshow = new HashMap<String,String>();
	        mapshow.put("opdate", df.format(date));
	        mapshow.put("count", "0");
	  		logListshow.add(mapshow);
		}
	}catch(Exception e){
		
	}

  	if(rs.getDBType().equalsIgnoreCase("sqlserver")){
  		sql = "SELECT wr.count , wb.workflowname, wb.id FROM workflow_base wb ,( "+
  				" SELECT TOP 5 count(workflowid) AS count, workflowid FROM workflow_requestbase  GROUP BY workflowid "+
  				" ORDER BY count DESC) wr WHERE wr.workflowid = wb.id ORDER BY wr.count desc ";
  		sql2 = "select top 5 opdate,count(id) as c from "+
				" (select id,SUBSTRING(operatedate,0,8) as opdate from SysMaintenanceLog where operateitem in(1,2,3)) r"+
				" group by opdate order by opdate desc";
  	}else{
  		sql = "SELECT * FROM (SELECT wr.count , wb.workflowname, wb.id FROM workflow_base wb ,( "+
  				" SELECT count(workflowid) AS count, workflowid FROM workflow_requestbase GROUP BY workflowid "+
  				" ORDER BY count DESC) wr WHERE wr.workflowid = wb.id  ORDER BY wr.count desc) WHERE ROWNUM <=5";
  		sql2 = "select topdate,count(id) as c from "+
				" (select id,substr(operatedate,0,8) as opdate from SysMaintenanceLog where operateitem in(1,2,3)) r"+
				" where rownum<=5 group by opdate order by opdate desc";
  	}
  	rs.executeSql(sql);
  	while(rs.next()){
  		Map<String,String> m = new HashMap<String,String>();
  		m.put("workflowname",rs.getString("workflowname"));
  		m.put("count",rs.getString("count"));
  		m.put("id",rs.getString("id"));
  		secList.add(m);
  	}
  	
  	//rs.executeSql(sql2);
  	//while(rs.next()){
  	//	Map<String,String> m = new HashMap<String,String>();
  	//	m.put("opdate",rs.getString("opdate"));
  	//	m.put("count",rs.getString("c"));
  	//	logList.add(m);
  	//}
  	
  	sql = "SELECT count(1)  FROM workflow_formbase";
  	rs.executeSql(sql);
  	if(rs.next()){
  		formnum = rs.getInt(1);
  	}
  	sql = "SELECT count(1) FROM workflow_bill";
  	rs.executeSql(sql);
  	if(rs.next()){
  		formnum += rs.getInt(1);
  	}
  	sql = "SELECT count(DISTINCT formid) FROM workflow_base ";
  	rs.executeSql(sql);
  	if(rs.next()){
  		useform = rs.getInt(1);
  	}

  	sql = "select count(1) FROM workflow_base";
  	rs.executeSql(sql);
  	if(rs.next()){
  		workflownum = rs.getInt(1);
  	}

  	sql = "select count(1) FROM workflow_base WHERE isvalid=1";
  	rs.executeSql(sql);
  	if(rs.next()){
  		useworkflow = rs.getInt(1);
  	}

  	sql = "select count(1) FROM Workflow_Report";
  	rs.executeSql(sql);
  	if(rs.next()){
  		reportnum = rs.getInt(1);
  	}
  	
    try{
    List l=StaticObj.getServiceIds(Action.class); 
    interfacenum = l.size();
    }catch(Exception e){
        
    }

  	sql = "SELECT count(DISTINCT customervalue) FROM workflow_addinoperate WHERE customervalue LIKE 'action.%'";
  	rs.executeSql(sql);
  	if(rs.next()){
  		useinterface = rs.getInt(1);
  	}

  	

  	//在用
  	//SELECT count(DISTINCT formid) FROM workflow_base 
  	//select count(1) FROM workflow_base WHERE isvalid=1
  	//
  	//SELECT count(DISTINCT customervalue) FROM workflow_addinoperate WHERE customervalue LIKE 'action.%'
  	%>
<body>

<div style="min-width:1000px;overflow:hidden;">

<div id="container" style="border-bottom:1px solid #efeef4;">
<div style="margin:0 0 0 42px;">
<div style="width:100%;height:30px!important;float:left;background:#F7F7FA;"></div>
<div id="left" style="width:214px;">
	<div class="headfoot2"><img src="/images/ecology8/workflow/wf01_wev8.png" /></div>
	<div class="hfoot2" style="text-align:center;">
		<div><%=SystemEnv.getHtmlLabelName(31923,user.getLanguage()) %></div>
		<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
		<div style="width:100px; height:12px; border-top:1px solid #D8D8D8; border-left:1px solid #D8D8D8; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
	</div>
	<div class="hfoot2" style="text-align:center;">
		<div style="width:214px;height:67px;">
			<div class="spaniwfback01" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=formnum %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(82155,user.getLanguage())%>
				</div>
			</div>
			<div style="width:14px!important;height:1px;float:left;"></div>
			<div class="spaniwfback01" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=useform %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(125101,user.getLanguage())%>
				</div>
			</div>
		</div>
	</div>
</div>
<div style="width:62px!important;height:1px;float:left;"></div>
		<div id="left" style="width:214px;">
	<div class="headfoot2"><img src="/images/ecology8/workflow/wf02_wev8.png" /></div>
	<div class="hfoot2" style="text-align:center;">
		<div><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></div>
		<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
		<div style="width:100px; height:12px; border-top:1px solid #D8D8D8; border-left:1px solid #D8D8D8; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
	</div>
	<div class="hfoot2" style="text-align:center;">
		<div style="width:214px;height:67px;">
			<div class="spaniwfback02" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=workflownum %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(125102,user.getLanguage())%>
				</div>
			</div>
			<div style="width:14px!important;height:1px;float:left;"></div>
			<div class="spaniwfback02" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=useworkflow %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(125103,user.getLanguage())%>
				</div>
			</div>
		</div>
	</div>
</div>
<div style="width:62px!important;height:1px;float:left;"></div>
		<div id="left" style="width:100px;">
	<div class="headfoot2"><img src="/images/ecology8/workflow/wf03_wev8.png" /></div>
	<div class="hfoot2" style="text-align:center;">
		<div><%=SystemEnv.getHtmlLabelName(26312,user.getLanguage())%></div>
		<div style="width:1px; height:25px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
	</div>
	<div class="hfoot2" style="text-align:center;">
		<div style="width:100px;height:67px;">
			<div class="spaniwfback03" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=reportnum %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(125104,user.getLanguage())%>
				</div>
			</div>
		</div>
	</div>
</div>
<div style="width:62px!important;height:1px;float:left;"></div>
		<div id="left" style="width:214px;">
	<div class="headfoot2"><img src="/images/ecology8/workflow/wf04_wev8.png" /></div>
	<div class="hfoot2" style="text-align:center;">
		<div><%=SystemEnv.getHtmlLabelName(82725,user.getLanguage())%></div>
		<div style="width:1px; height:12px; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
		<div style="width:100px; height:12px; border-top:1px solid #D8D8D8; border-left:1px solid #D8D8D8; border-right:1px solid #D8D8D8;margin:0 auto;"></div>
	</div>
	<div class="hfoot2" style="text-align:center;">
		<div style="width:214px;height:67px;">
			<div class="spaniwfback04" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=interfacenum %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(125105,user.getLanguage())%>
				</div>
			</div>
			<div style="width:14px!important;height:1px;float:left;"></div>
			<div class="spaniwfback04" >
				<div style="height:42px;text-align:center;line-height:42px;font-size:24px;">
					<%=useinterface %>
				</div>
				<div style="height:21px;text-align:center;line-height:26px;font-size:12px;">
					<%=SystemEnv.getHtmlLabelName(125106,user.getLanguage())%>
				</div>
			</div>
		</div>
	</div>
</div>
<div style="width:100%;height:48px!important;float:left;background:#F7F7FA;"></div>
</div>
</div>


<div style="width:1px;height:40px!important;float:left;"></div>
<div id="container1" style="height:30px;">
<div style="height:30px;">
	<div id="left3" >
			<div style="width:400px;height:30px;text-align:left;padding-left:39px;line-height:35px; font-size:14px;"><%=SystemEnv.getHtmlLabelName(125107,user.getLanguage())%></div>
	</div>
	<div id="right3">
		<a onmouseover="showBt(this)" onmouseout="hiddenBt(this)"  href="/workflow/workflow/help1.jsp" style="width:90px;height:30px;vertical-align:middle;"><span class="btstyle01"><%=SystemEnv.getHtmlLabelName(32597,user.getLanguage())%></span></a>
	</div>
	<div class="clear"></div>
</div>
</div>
<div style="width:50%;height:3px!important;float:left;"></div>
<div style="clear:both;"></div>
<div style="background:rgb(204,204,204);width:89.5%;height:2px!important;margin-left:39px;"></div>

<div style="width:100%;height:17px!important;float:left;"></div>
<div id="container1">
<div style="padding-left:30px;">
<div id="left1">
	<div class="headfoot1"><img src="/images/ecology8/workflow/wfanalysis01_wev8.png" /></div>
	<div class="hfoot1" style="padding-left:15px;"><%=SystemEnv.getHtmlLabelName(125108,user.getLanguage())%></div>
</div>
<div id="left1">
	<div class="headfoot1"><div id="aaa" ></div></div>
</div>
<div id="left1">
	<div class="headfoot1"><img src="/images/ecology8/workflow/wfcreate02_wev8.png" /></div>
	<div class="hfoot1"><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></div>
</div>
<div id="left1">
	<div class="headfoot1"><div id="aaa" ></div></div>
</div>
<div id="left1">
	<div class="headfoot1"><img src="/images/ecology8/workflow/wfform03_wev8.png" /></div>
	<div class="hfoot1"><%=SystemEnv.getHtmlLabelName(125109,user.getLanguage())%></div>
</div>
<div id="left1">
	<div class="headfoot1"><div id="aaa" ></div></div>
</div>
<div id="left1">
	<div class="headfoot1"><img src="/images/ecology8/workflow/wfdraw04_wev8.png" /></div>
	<div class="hfoot1"><%=SystemEnv.getHtmlLabelName(125110,user.getLanguage())%></div>
</div>
<div id="left1">
	<div class="headfoot1"><div id="aaa" ></div></div>
</div>
<div id="left1">
	<div class="headfoot1"><img src="/images/ecology8/workflow/wftest05_wev8.png" /></div>
	<div class="hfoot1"><%=SystemEnv.getHtmlLabelName(125111,user.getLanguage())%></div>
</div>
<div class="clear"></div>
</div>
</div>
<div style="width:100%;height:75px!important;float:left;"></div>
<div id="logAbstract" class="e8_logAbstract">
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(125112,user.getLanguage())%>
  			</div>
  			<div>
  				<%
  				int total = 0;
  				for(int i=0;i<secList.size();i++){ 
  					Map<String,String> m = secList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					String progress = "0%";
  					if(i==0){
  						total = count;
  						if(total==0)total=1;
  						progress="100%";
  					}else{
  						progress = (count*1.0/total*100)+"%";	
  					}
  				%>
  					<div style="margin-top:20px;">
  						<div class="e8_ranking" style="background-image:url(/images/ecology8/doc/rank_<%=i %>_wev8.png);"><%=i+1 %></div>
  						<div class="e8_content"><%= m.get("workflowname")%></div>
  						<div class="e8_progress_div">
  							<span title="<%=count %>" id="top_wfid_<%=m.get("id") %>" class="e8_progress e8_progress_<%=i %>" style="width:0px;"></span>
  						</div>
  						<div style="clear:both;"></div>
  					</div>
  				<%} %>
  			</div>
  		</div>
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(125113,user.getLanguage())%>
  			</div>
  			<div style="position:relative;">
  				<div class="e8_line_sep"></div>
  				<%
  				total = 0;
  				for(int i=0;i<logList.size();i++){ 
  					Map<String,String> m = logList.get(i);
  					Map<String,String> mshow = logListshow.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					if(total<count)total=count;
  				}
  				for(int i=0;i<logList.size();i++){ 
  					Map<String,String> m = logList.get(i);
  					Map<String,String> mshow = logListshow.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					String progress = "0%";
  					String progressShow = "0%";
  					if(total==count){
  						if(total==0)total=1;
  						progressShow="100%";
  						progress = "85%";
  					}else{
  						progressShow = 	Math.round(count*1.0/total*100)+"%";
  						progress = (count*1.0/total*100*0.85)+"%";
  					}
  				%>
  					<div style="margin-top:20px;">
  						<div class="e8_ranking" style="background-image:url(/images/ecology8/doc/ranklog_<%=i==0?0:1 %>_wev8.png);"></div>
  						<div class="e8_logcontent"><%= mshow.get("opdate")%></div>
  						<div class="e8_progress_log_div">
  							<span title="<%=count %>" id="log_<%= m.get("opdate")%>" class="e8_progress e8_progress_<%=i %>" style="width:0%;"></span>
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

$(function () {
	<%
		total = 0;
		for(int i=0;i<secList.size();i++){ 
			Map<String,String> m = secList.get(i);
			int count = Util.getIntValue(m.get("count"),0);
			String id = m.get("id");
			String progress = "0%";
			if(i==0){
				total = count;
				if(total==0)total=1;
				progress="100%";
			}else{
				progress = (count*1.0/total*100)+"%";	
			}
		%>
			if (<%=count%> == 0) {
				$("#top_wfid_<%=id %>").html("<%=SystemEnv.getHtmlLabelName(129499, user.getLanguage())%>").css("width","200px").removeClass("e8_progress_"+i);
			} else {
				$("#top_wfid_<%=id %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
			}
	<%  } %>

	$.ajax({
		type: "GET",
		cache: false,
		url: encodeURI("/workflow/workflow/index_ajaxlogdata.jsp"),
	    
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(){
		},
	    error:function (XMLHttpRequest, textStatus, errorThrown) {
	    } , 
	    success : function (data, textStatus) {
	    	if (data == undefined || data == null) {
	    		$.alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>", promptWrod);
	    		return;
	    	} else {
	    		var dataarray = eval(data);
	    		
	    		var total = 0;
	    		for (var i=0; i<dataarray.length; i++) { 
  					var count = parseInt(dataarray[i].count);
  					if(total<count)total=count;
  				}
	    		
	    		for (var i=0; i<dataarray.length; i++) {
	    			try {
	    				var progress = "0%";
	  					var progressShow = "0%";
	  					
	  					var count = parseInt(dataarray[i].count);
	  					if(total==count){
	  						if(total == 0) {
	  							total=1;
	  						}
	  						progressShow="100%";
	  						progress = "85%";
	  					}else{
	  						progressShow = 	Math.round(count*1.0/total*100)+"%";
	  						progress = (count*1.0/total*100*0.85)+"%";
	  					}
	  					if (count == 0) {
	    					$("#log_" + dataarray[i].opdate).html("<%=SystemEnv.getHtmlLabelName(33736, user.getLanguage())%>").css("width","200px").removeClass("e8_progress_"+i);
	  					} else {
	    					$("#log_" + dataarray[i].opdate).attr("title",count).animate({"width": progress}, (count*1.0/total*100*0.85)*15);
	  					}
	    			} catch(e){}
	    		}
	    	}
	    } 
	}); 
	
})

function openhelp(){
	var href = "/workflow/workflow/help1.jsp";
	window.location = href;
}

function showBt(obj){
	$(obj).find(".btstyle01").addClass("btstyle02");
}

function hiddenBt(obj){
	$(obj).find(".btstyle01").removeClass("btstyle02");
}

</script>

</div>
</body>
</html>
