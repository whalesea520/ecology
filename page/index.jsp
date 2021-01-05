<!DOCTYPE HTML>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="seccategory" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
	*{
		font-family:"微软雅黑","宋体";
	}
	.e8_contentAbstract{
		width:100%;
		height:250px;
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
	
	.e8_progress_content{
		color:#b2b2b2;
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
	
	.e8_abs{
		margin-left:50px;
		float:left;
		position:relative;
		margin-top:30px;
	}
	
	.e8_abs_img{
		color:#fff;
		text-align:center;
		background-repeat:no-repeat;
		background-position:50% 50%;
		width:115px;
		height:115px;
		float:left;
		line-height:90px;
	}
	
	.e8_abs_title{
		color:#7e86a6;
		font-size:14px;
		text-align:center;
		margin-bottom:20px;
	}
	
	.label{
		position: absolute;
		left: 70px;
		top:85px;
		font-size: 30px;
		width: 50px;
		text-align: center;
	}

	.label24 {
		position: absolute;
		left: 65px;
		top: 95px;
		font-size: 24px;
		width: 50px;
		text-align: center;
		line-height: 24px;
	}

	.charContent{
		width: 186px; 
		
		position: relative;
		float: left;
		margin-left:70px;
		margin-top:30px;
		border: 1px solid #d7dde8;
		border-radius:3px;
		background: #ffffff;
		color:#777e87;
		
	}
	
	.charContent .chart{
		width: 100%; 
		height:100px;
		
		padding-top: 5px;
	}
	.charContent .title{
		width: 100%;
		border-bottom: 1px solid #d7dde8;
		font-size:14px;
		height: 51px;
		position: relative;
	}
	
	.charContent .title .icon{
		position: absolute;
		top: 10px;
		left: 55px;
	}
	.charContent .title .name{
		position: absolute;
		top: 20px;
		left: 95px;
	}
	.charContent .desc{
		padding-bottom: 10px;
	}
	
	
	
	
</style>
<script src="/formmode/js/amcharts/amcharts_wev8.js" type="text/javascript"></script>
<script src="/formmode/js/amcharts/pie_wev8.js" type="text/javascript"></script>
  </head>
  <% 
  	List<Map<String,String>> secList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> newSecList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> logList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> newLogList = new ArrayList<Map<String,String>>();
  	
  	
  %>
 
  <body style="margin:0 auto;">
  	<div id="contentAbstract" class="e8_contentAbstract">
  		<%
  		int all=0;
  		int used = 0;
 		rs.executeSql("SELECT count(*) as nums FROM SystemTemplate ");
 		rs.next();
 		all = rs.getInt("nums");
 		rs.executeSql("SELECT count(*) as nums FROM SystemTemplate WHERE isOpen=1 ");
 		rs.next();
 		used = rs.getInt("nums");	
	 	%>
  		<div id="portal" class="charContent" all="<%=all-used %>" used="<%=used %>" color="#2792ff">
  			<div class="title">
  				<img class="icon" src="/middlecenter/images/portal/portal_wev8.png"><span class="name"><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%></span>
  			</div>
  			
  			<div id="portalChart" class="chart"></div>
  			<div class="<%if(used<999){%>label<%}else{%>label24<%}%>" style="color:#2792ff"><%=used%></div>
  			<div class="desc" style="">
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/all_wev8.png"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%>：<span><%=all %></span>
  				</div>
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/portalused_wev8.png"><%=SystemEnv.getHtmlLabelName(33796,user.getLanguage())%>：<span style="color:#2792ff"><%=used %></span>
  				</div>
  				<div style="clear: both;"></div>
  				
  			</div>
  		</div>
  		<%
	  		
	 		rs.executeSql("SELECT count(*) as nums FROM SystemTemplate ");
	 		rs.next();
	 		all = rs.getInt("nums");
	 		rs.executeSql("SELECT count(*) as nums FROM SystemTemplate WHERE isOpen=1 ");
	 		rs.next();
	 		used = rs.getInt("nums");	
	 	%>
  		<div id="theme" class="charContent" all="<%=all-used %>" used="<%=used %>" color="#ac8fef">
  			<div class="title">
  				<img class="icon" src="/middlecenter/images/portal/theme_wev8.png">
  				<span class="name"><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></span>
  			</div>
  			<div id="themeChart" class="chart"></div>
  			<div class="<%if(used<999){%>label<%}else{%>label24<%}%>" style="color:#ac8fef"><%=used %></div>
  			<div class="desc">
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/all_wev8.png"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%>：<span><%=all %></span>
  				</div>
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/themeused_wev8.png"><%=SystemEnv.getHtmlLabelName(33796,user.getLanguage())%>：<span style="color:#ac8fef"><%=used %></span>
  				</div>
  				<div style="clear: both;"></div>
  				
  			</div>
  		</div>
  		
  		<%
	  		
	 		rs.executeSql("SELECT count(*) as nums FROM hpinfo ");
	 		rs.next();
	 		all = rs.getInt("nums");
	 		rs.executeSql("SELECT count(*) as nums FROM hpinfo WHERE isUse=1 ");
	 		rs.next();
	 		used = rs.getInt("nums");	
	 	%>
  		<div id="page" class="charContent" all="<%=all-used %>" used="<%=used %>" color="#fe6d4b">
  			<div class="title">
  				<img class="icon" src="/middlecenter/images/portal/page_wev8.png">
  				<span class="name"><%=SystemEnv.getHtmlLabelName(22967,user.getLanguage())%></span>
  			</div>
  			<div id="pageChart" class="chart"></div>
  			<div class="<%if(used<999){%>label<%}else{%>label24<%}%>" style="color:#fe6d4b"><%=used %></div>
  			<div class="desc">
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/all_wev8.png"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%>：<span><%=all %></span>
  				</div>
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/pageused_wev8.png"><%=SystemEnv.getHtmlLabelName(33796,user.getLanguage())%>：<span style="color:#fe6d4b"><%=used %></span>
  				</div>
  				<div style="clear: both;"></div>
  				
  			</div>
  		</div>
  		<%
	  	
	 		rs.executeSql("SELECT count(*) as nums FROM hpbaseelement ");
	 		rs.next();
	 		all = rs.getInt("nums");
	 		rs.executeSql("SELECT count(a1.id),a1.ebaseid  FROM hpElement a1 LEFT JOIN ElementUseInfo a2 ON a1.id = a2.eid WHERE a2.layoutid IS NOT null GROUP BY a1.ebaseid");
	 		rs.next();
	 		used = rs.getCounts();	
	 	%>
  		<div id="element" class="charContent" all="<%=all-used %>" used="<%=used %>" color="#7ed24e">
  			<div class="title">
  				<img class="icon" src="/middlecenter/images/portal/el_wev8.png">
  				<span class="name"><%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%></span>
  			
  			</div>
  			<div id="elementChart" class="chart"></div>
  			<div class="<%if(used<999){%>label<%}else{%>label24<%}%>" style="color:#7ed24e"><%=used %></div>
  			<div class="desc">
  				<div style="float:left;padding-left:30px;position: relative;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/all_wev8.png"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%>：<span><%=all %></span>
  				</div>
  				<div style="float:left;padding-left:30px;position: relative;">
  					<img style="position: absolute;left: 20px;top: 5px;" src="/middlecenter/images/portal/elused_wev8.png"><%=SystemEnv.getHtmlLabelName(33796,user.getLanguage())%>：<span style="color:#7ed24e"><%=used %></span>
  				</div>
  				<div style="clear: both;"></div>
  				
  			</div>
  		</div>
  		<div style="clear: both;"></div>
  		
  	</div>
  	<div id="logAbstract" class="e8_logAbstract">
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(33798,user.getLanguage())%>
  			</div>
  			<div style="position:relative;">
  				<div class="e8_line_sep"></div>
  				<%
  				String sql="";
  				String sql2="";
  				if(rs.getDBType().equalsIgnoreCase("sqlserver")){
  			  		sql = "SELECT SUBSTRING(opdate,0,8) as opdate,count(*) as c FROM PortalLogInfo where type !='import'  GROUP BY SUBSTRING(opdate,0,8) ORDER BY SUBSTRING(opdate,0,8) desc";
  			  		sql2 = "SELECT SUBSTRING(opdate,0,8) as opdate,count(*) as c FROM PortalLogInfo where type ='import'  GROUP BY SUBSTRING(opdate,0,8) ORDER BY SUBSTRING(opdate,0,8) desc";
  			  	}else{
  			  		sql = "select opdate,count(*) as c from ( SELECT substr(opdate,0,8) as opdate,id FROM PortalLogInfo where  type!='import' ) r where rownum<=5  GROUP BY opdate ORDER BY opdate desc ";
  			  		sql2 = "select opdate,count(*) as c from ( SELECT substr(opdate,0,8) as opdate,id FROM PortalLogInfo where  type='import' ) r where rownum<=5  GROUP BY opdate ORDER BY opdate desc ";
			  		
  			  	}
  			  	rs.executeSql(sql);
  			  	while(rs.next()){
  			  		Map<String,String> m = new HashMap<String,String>();
  			  		m.put("opdate",rs.getString("opdate"));
  			  		m.put("count",rs.getString("c"));
  			  		secList.add(m);
  			  	}
  			  	
  			 	Date date = new Date();
	  		  	int curMonth = date.getMonth()+1;
	  		  	int curYear = date.getYear()+1900;
	  		  	String curDate = TimeUtil.getCurrentDateString();
	  		  	curDate = curDate.substring(0,7);
	  		  	
  				for(int i=0;i<5;i++){
  			  		for(int j=0;j<secList.size();j++){ 
  						Map<String,String> m = secList.get(j);
  						Map<String,String> m1 = new HashMap<String,String>();
  						String opdate = m.get("opdate");
  						int count = Util.getIntValue(m.get("count"),0);
  						//System.out.println(curDate+"::"+opdate+"::"+count);
  						if(opdate.equals(curDate)){
  							m1.put("opdate",curDate);
  							m1.put("count",""+count);
  							newSecList.add(m1);
  							break;
  						}else if(j==secList.size()-1){
  							m1.put("opdate",curDate);
  							m1.put("count","0");
  							newSecList.add(m1);
  						}
  					}
  					curMonth--;
  					if(curMonth==0){
  						curMonth = 12;
  						curYear--;
  					}
  					String curM = ""+curMonth;
  					if(curMonth<10)curM = "0"+curMonth;
  					curDate = curYear+"-"+curM;
  			  	}
  				secList = newSecList;
  				
  				int total = 0;
  				for(int i=0;i<secList.size();i++){ 
  					Map<String,String> m = secList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					if(total<count)total=count;
  				}
  				for(int i=0;i<secList.size();i++){ 
  					Map<String,String> m = secList.get(i);
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
  						<div class="e8_logcontent"><%= m.get("opdate")%></div>
  						<div class="e8_progress_log_div">
  							<%if(count!=0){ %>
  								<span title="<%=count %>"  id="log2_<%= m.get("opdate")%>" class="e8_progress e8_progress_<%=i %>" style="width:0%;"></span>
  								<script type="text/javascript">
  								jQuery(document).ready(function(){
  									$("#log2_<%=m.get("opdate") %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
  								});
  							</script>
  							<%}else{ %>
  								<span class="e8_noData"><%=SystemEnv.getHtmlLabelName(33736,user.getLanguage())%></span>
  							<%} %>
  							<%--if(count!=0){ %>
		  						<span class="e8_progress_content">
									<%=progressShow %>  								
		  						</span>
	  						<%} --%>
  						</div>
  						
  						<div style="clear:both;"></div>
  					</div>
  				<%} %>
  			</div>
  		</div>
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(33799,user.getLanguage())%>
  			</div>
  			<div style="position:relative;">
  				<div class="e8_line_sep"></div>
  				
  				<%
  				
  				rs.executeSql(sql2);
  			  	while(rs.next()){
  			  		Map<String,String> m = new HashMap<String,String>();
  			  		m.put("opdate",rs.getString("opdate"));
  			  		m.put("count",rs.getString("c"));
  			  		logList.add(m);
  			  	}
  			  	
  			 	
	  		  	curMonth = date.getMonth()+1;
	  		  	curYear = date.getYear()+1900;
	  		  	curDate = TimeUtil.getCurrentDateString();
	  		  	curDate = curDate.substring(0,7);
	  		  	
  				for(int i=0;i<5;i++){
  					
  					//logList.contains(curDate)
  			  		for(int j=0;j<logList.size();j++){ 
  						Map<String,String> m = logList.get(j);
  						Map<String,String> m1 = new HashMap<String,String>();
  						String opdate = m.get("opdate");
  						int count = Util.getIntValue(m.get("count"),0);
  						//System.out.println(curDate+"::"+opdate+"::"+count);
  						if(opdate.equals(curDate)){
  							m1.put("opdate",curDate);
  							m1.put("count",""+count);
  							newLogList.add(m1);
  							break;
  						}else if(j==logList.size()-1){
  							m1.put("opdate",curDate);
  							m1.put("count","0");
  							newLogList.add(m1);
  						}
  					}
  					curMonth--;
  					if(curMonth==0){
  						curMonth = 12;
  						curYear--;
  					}
  					String curM = ""+curMonth;
  					if(curMonth<10)curM = "0"+curMonth;
  					curDate = curYear+"-"+curM;
  			  	}
  				
  				logList = newLogList;
  				
  				total = 0;
  				for(int i=0;i<logList.size();i++){ 
  					Map<String,String> m = logList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					if(total<count)total=count;
  				}
  				for(int i=0;i<logList.size();i++){ 
  					Map<String,String> m = logList.get(i);
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
  						<div class="e8_logcontent"><%= m.get("opdate")%></div>
  						<div class="e8_progress_log_div">
  							<%if(count!=0){ %>
  								<span title="<%=count %>"  id="update_<%= m.get("opdate")%>" class="e8_progress e8_progress_<%=i %>" style="width:0%;"></span>
  								<script type="text/javascript">
  								jQuery(document).ready(function(){
  									$("#update_<%=m.get("opdate") %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
  								});
  							</script>
  							<%}else{ %>
  								<span class="e8_noData"><%=SystemEnv.getHtmlLabelName(33736,user.getLanguage())%></span>
  							<%} %>
  							<%--if(count!=0){ %>
		  						<span class="e8_progress_content">
									<%=progressShow %>  								
		  						</span>
	  						<%} --%>
  						</div>
  						
  						<div style="clear:both;"></div>
  					</div>
  				<%} %>
  			</div>
  		</div>
  		<div style="clear:both;"></div>
  	</div>
  	<div style="height:30px;"></div>
  	<script type="text/javascript"><!--
  	
 	jQuery(document).ready(function(){
 		
 		$(".charContent").each(function(){
 		
 			var chartData = [{"country":"<%=SystemEnv.getHtmlLabelName(33796,user.getLanguage())%>","visits":$(this).attr("used")},{"country":"<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>","visits":$(this).attr("all")}];
 			var color = [$(this).attr("color"),"#edf0f5"]
 			var el = $(this).attr("id")+"Chart"
 			createChart(el,chartData,color);
 		})
 		
	})
			//$("#component1").append("("+(d.modelCount<0?0:d.modelCount)+")");
			//$("#component2").append("("+(d.formCount<0?0:d.formCount)+")");
			//$("#component3").append("("+(d.searchCount<0?0:d.searchCount)+")");
			//$("#component4").append("("+(d.reportCount<0?0:d.reportCount)+")");
			//$("#component5").append("("+(d.browserCount<0?0:d.browserCount)+")");
			//$("#component6").append("("+(d.treeCount<0?0:d.treeCount)+")");
// easeOutSine, easeInSine, elastic, bounce
	function createChart(el,chartData,color){
		chart = new AmCharts.AmPieChart();
		chart.outlineAlpha = 1;
	    chart.dataProvider = chartData;
	    chart.titleField = "country";
	    chart.valueField = "visits";
	    chart.sequencedAnimation = false;
	    chart.startEffect = "easeInSine";
	    chart.colors=color
	    chart.innerRadius = "90%";
	    chart.startDuration = 0;
	  
	    chart.labelText = "";
	    chart.labelRadius = 2;
	    chart.labelsEnabled = true;
	    chart.balloonText = "";
	    chart.depth3D = 0;
	    chart.angle = 0;
	    chart.fontFamily = "Microsoft YaHei";
	    chart.fontSize = 11;
	    chart.marginTop = -10;
	    chart.marginLeft = -50;
	    chart.marginRight = -50;
	    chart.marginBottom = -10;
	    chart.gradientRatio = 5;
	    chart.write(el);
	}		
	
</script>
  </body>
</html>
