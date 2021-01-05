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
		margin-left:100px;
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
	
</style>
  </head>
  <% 
  	List<Map<String,String>> secList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> logList = new ArrayList<Map<String,String>>();
  	List<Map<String,String>> newLogList = new ArrayList<Map<String,String>>();
  	int maindir = 0;
  	int subdir = 0;
  	int secdir = 0;
  	int mould = 0;
  	int magazine = 0;
  	int news = 0;
  	String sql = "";
  	String sql2 = "";
  	if(rs.getDBType().equalsIgnoreCase("sqlserver")){
  		sql = "select top 5 seccategory,count(*) as c from DocDetail group by seccategory order by c desc";
  		sql2 = "select top 5 opdate,count(id) as c from "+
				" (select id,SUBSTRING(operatedate,0,8) as opdate from SysMaintenanceLog where operateitem in(1,2,3)) r"+
				" group by opdate order by opdate desc";
  	}else{
  		sql = "select seccategory,count(*) as c from DocDetail where rownum<=5 group by seccategory order by c desc";
  		sql2 = "select opdate,count(id) as c from "+
				" (select id,substr(operatedate,0,8) as opdate from SysMaintenanceLog where operateitem in(1,2,3)) r"+
				" where rownum<=5 group by opdate order by opdate desc";
  	}
  	rs.executeSql(sql);
  	while(rs.next()){
  		Map<String,String> m = new HashMap<String,String>();
  		m.put("seccategory",seccategory.getSecCategoryname(rs.getString("seccategory")));
  		m.put("count",rs.getString("c"));
  		m.put("secid",rs.getString("seccategory"));
  		secList.add(m);
  	}
  	
  	rs.executeSql(sql2);
  	Date date = new Date();
  	int curMonth = date.getMonth()+1;
  	int curYear = date.getYear()+1900;
  	String curDate = TimeUtil.getCurrentDateString();
  	curDate = curDate.substring(0,7);
  	while(rs.next()){
  		Map<String,String> m = new HashMap<String,String>();
  		String opdate = Util.null2String(rs.getString("opdate"));
  		m.put("opdate",rs.getString("opdate"));
  		m.put("count",rs.getString("c"));
  		newLogList.add(m);
  	}
  	for(int i=0;i<5;i++){
  		for(int j=0;j<newLogList.size();j++){ 
			Map<String,String> m = newLogList.get(j);
			Map<String,String> m1 = new HashMap<String,String>();
			String opdate = m.get("opdate");
			int count = Util.getIntValue(m.get("count"),0);
			if(opdate.equals(curDate)){
				m1.put("opdate",curDate);
				m1.put("count",""+count);
				logList.add(m1);
				break;
			}else if(j==newLogList.size()-1){
				m1.put("opdate",curDate);
				m1.put("count","0");
				logList.add(m1);
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
  	
  	/*sql = "select count(id) from docmaincategory";
  	rs.executeSql(sql);
  	if(rs.next()){
  		maindir = rs.getInt(1);
  	}
  	
  	sql = "select count(id) from docsubcategory";
  	rs.executeSql(sql);
  	if(rs.next()){
  		subdir = rs.getInt(1);
  	}*/
  	
  	sql = "select count(id) from docseccategory";
  	rs.executeSql(sql);
  	if(rs.next()){
  		secdir = rs.getInt(1);
  	}
  	
  	sql = "select count(id) from WebMagazinetype";
  	rs.executeSql(sql);
  	if(rs.next()){
  		magazine = rs.getInt(1);
  	}
  	
  	sql = "select count(id) from DocFrontPage";
  	rs.executeSql(sql);
  	if(rs.next()){
  		news = rs.getInt(1);
  	}
  	
  	sql = "select count(id) from DocMould";
  	rs.executeSql(sql);
  	if(rs.next()){
  		mould = rs.getInt(1);
  	}
  %>
  <body style="margin:0 auto;">
  	<div id="contentAbstract" class="e8_contentAbstract">
  		<div class="e8_abs">
  			<div class="e8_abs_title"><%=SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></div>
  			<div style="text-align:center;">
  				<img src="/images/ecology8/doc/dir_wev8.png" style="vertical-align:middle;" />
  			</div>
  			<div style="height:35px;width:100%;position:relative;">
  				<!-- <div style="width:235px;background-color:#d8d8d8;height:1px;position: absolute;top: 18px;left: 55px;"></div> -->
  				<div style="width: 1px;background-color:#d8d8d8;height:43px;position: absolute;top: -1px;left: 60px;"></div>
  				<!-- <div style="width: 1px;background-color:#d8d8d8;height: 25px;position: absolute;top: 18px;left: 55px;"></div>
  				<div style="width: 1px;background-color:#d8d8d8;height: 25px;position: absolute;top: 18px;right: 55px;"></div> -->
  			</div>
  			<div>
  				<%--<div class="e8_abs_img" style="background-image:url(/images/ecology8/doc/mdir_wev8.png);">
  					<div style="font-size:30px;height:30px;"><%=maindir %></div>
  					<div style="font-size:14px;height:30px;"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></div>
  				</div>
  				<div class="e8_abs_img"  style="background-image:url(/images/ecology8/doc/sdir_wev8.png);">
  					<div style="font-size:30px;height:30px;"><%=subdir %></div>
  					<div style="font-size:14px;height:30px;"><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></div>
  				</div> --%>
  				<div class="e8_abs_img"  style="background-image:url(/images/ecology8/doc/mdir_wev8.png);">
  					<div style="font-size:30px;height:30px;"><%=secdir %></div>
  					<div style="font-size:14px;height:30px;"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%></div>
  				</div>
  				<div style="clear:both;"></div>
  			</div>
  		</div>
  		<div class="e8_abs">
  			<div class="e8_abs_title"><%=SystemEnv.getHtmlLabelName(33144,user.getLanguage())%></div>
  			<div style="text-align:center;">
  				<img src="/images/ecology8/doc/mould_wev8.png" style="vertical-align:middle;" />
  			</div>
  			<div style="height:35px;width:100%;position:relative;">
  				<div style="width: 1px;background-color:#d8d8d8;height:43px;position: absolute;top: -1px;left: 58px;"></div>
  			</div>
  			<div>
  				<div class="e8_abs_img" style="background-image:url(/images/ecology8/doc/tmould_wev8.png);">
  					<div style="font-size:30px;height:30px;"><%=mould %></div>
  					<div style="font-size:14px;height:30px;"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%></div>
  				</div>
  				<div style="clear:both;"></div>
  			</div>
  		</div>
  		<div class="e8_abs">
  			<div class="e8_abs_title"><%=SystemEnv.getHtmlLabelName(31516,user.getLanguage())%></div>
  			<div style="text-align:center;">
  				<img src="/images/ecology8/doc/magazine_wev8.png" style="vertical-align:middle;" />
  			</div>
  			<div style="height:35px;width:100%;position:relative;">
  				<div style="width: 1px;background-color:#d8d8d8;height:43px;position: absolute;top: -1px;left: 58px;"></div>
  			</div>
  			<div>
  				<div class="e8_abs_img" style="background-image:url(/images/ecology8/doc/tmagazine_wev8.png);">
  					<div style="font-size:30px;height:30px;"><%=magazine %></div>
  					<div style="font-size:14px;height:30px;"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%></div>
  				</div>
  				<div style="clear:both;"></div>
  			</div>
  		</div>
  		<div class="e8_abs">
  			<div class="e8_abs_title"><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></div>
  			<div style="text-align:center;">
  				<img src="/images/ecology8/doc/news_wev8.png" style="vertical-align:middle;" />
  			</div>
  			<div style="height:35px;width:100%;position:relative;">
  				<div style="width: 1px;background-color:#d8d8d8;height:43px;position: absolute;top: -1px;left: 58px;"></div>
  			</div>
  			<div>
  				<div class="e8_abs_img" style="background-image:url(/images/ecology8/doc/tnews_wev8.png);">
  					<div style="font-size:30px;height:30px;"><%=news %></div>
  					<div style="font-size:14px;height:30px;"><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%></div>
  				</div>
  				<div style="clear:both;"></div>
  			</div>
  		</div>
  		<div style="clear:both;"></div>
  	</div>
  	<div id="logAbstract" class="e8_logAbstract">
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(33734,user.getLanguage())%>
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
  						<div class="e8_content"><%= m.get("seccategory")%></div>
  						<div class="e8_progress_div">
  							<span title="<%=count %>" id="log_<%= m.get("secid")%>" class="e8_progress e8_progress_<%=i %>" style="width:0%"></span>
  							<script type="text/javascript">
  								jQuery(document).ready(function(){
  									$("#log_<%=m.get("secid") %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
  								});
  							</script>
  						</div>
  						<div style="clear:both;"></div>
  					</div>
  				<%} %>
  			</div>
  		</div>
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(33735,user.getLanguage())%>
  			</div>
  			<div style="position:relative;">
  				<div class="e8_line_sep"></div>
  				<%
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
  		<div style="clear:both;"></div>
  	</div>
  	<div style="height:30px;"></div>
  </body>
</html>
