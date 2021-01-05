<!DOCTYPE HTML>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.system.License" %>
<%@ page import="weaver.general.Util " %>
<%@ page import="com.weaver.upgrade.FunctionUpgradeUtil " %>

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
	
	.app{
		width: 158px;
		height: 166px;
		border: 1px solid #b1b1b1;
		float: left;
		margin-top:10px;
		margin-right:5px;
		margin-left:5px;
	}
	
	.page{
		cursor:pointer;
		background: url(/middlecenter/images/app/page_wev8.png) center center no-repeat;
		
	}
	.current{
		background-image: url(/middlecenter/images/app/pageOver_wev8.png)!important;
	}
	
	.icon{
		text-align: center;
		height: 86px;
		cursor: pointer;
	}
	.content{
		text-align: center;
		height: 80px;
		cursor: pointer;
	}
	.content .name{
		color:#484848;
	}
	
	
	.content .desc{
		height:30px;
		line-height:30px;
		width: 105px;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		color:#a8a8a8;
		
	}
	.over{
		text-align: center;
		background: #f4f4f4;
		position: absolute;
		bottom: 0px;
		width: 158px; 
		height:0px;
		display: none;
		cursor: pointer;
	}
	.over .name{
		color:#212121!important;
	}
	.over .desc{
		width: 158px!important;
		
		color:#525252!important;
	}
	.center { MARGIN-RIGHT: auto; MARGIN-LEFT: auto; }
	
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
  	
  	int cid = Util.getIntValue(new License().getCId());
  	
  	int menuidkey = FunctionUpgradeUtil.getMenuidkey();
  	
  	int menustatuskey = FunctionUpgradeUtil.getMenustatuskey();
  	
  	if(rs.getDBType().equals("oracle")){ 
  		sql = "select DISTINCT * FROM (SELECT nvl(b.isopen,a.id+("+(cid+menustatuskey)+")+1) AS isopened, a.id,a.labelId,a.useCustomName,a.customName,a.customName_e,a.customName_t,a.appicon,a.appdesc from MainMenuInfo a LEFT JOIN menucontrollist b ON a.id+"+(cid+menuidkey)+" = b.menuid AND b.type='top' where parentid = 10004 and id>0 and id!=10078) a WHERE a.isopened=a.id+("+(cid+menustatuskey)+")+1";
  	
  	}else{
  		sql = "select DISTINCT * FROM (SELECT isnull(b.isopen,a.id+("+(cid+menustatuskey)+")+1) AS isopened, a.id,a.labelId,a.useCustomName,a.customName,a.customName_e,a.customName_t,a.appicon,a.appdesc from MainMenuInfo a LEFT JOIN menucontrollist b ON a.id+"+(cid+menuidkey)+" = b.menuid AND b.type='top' where parentid = 10004 and id>0 and id!=10078) a WHERE a.isopened=a.id+("+(cid+menustatuskey)+")+1";
  	}
  	rs.executeSql(sql);
  %>
  <body style="margin:0 auto;">
  	<div class="w-all h-all" style="padding:top:15px;padding-left:10px;padding-right:10px">
  		<div id="applist" style="padding-top:20px;width:1020px">
  			<div style="float:left;width:100px;font-size:14px;color:#3e3e3e"><%=SystemEnv.getHtmlLabelName(33743,user.getLanguage())%>：<span id="appnums" style="color:#0067ff"><%=rs.getCounts() %></span></div>
  			<div id="commomsetting" style="cursor:pointer;float:right;padding-right:15px;font-size:14px;color:#3e3e3e;padding-left:20px;background: url(/wui/theme/ecology8/page/images/plugin_wev8.png) no-repeat center left;"> <%=SystemEnv.getHtmlLabelName(32142,user.getLanguage())%></div>	
  				<div style="clear: both"/>
  			<div style="height:5px;"></div>
  			<div style="height:1px;background: #cccccc;">&nbsp;</div>
  			<div>
  				<%
  			   	 MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
				
  					while(rs.next()){
  						int labelId = rs.getInt("labelId");
  				        
  				
  				        
  				        boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
  				        String customName = rs.getString("customName");
  				        String customName_e = rs.getString("customName_e");
  				        String customName_t = rs.getString("customName_t");
  				        
  				        boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true  : false;
  				        String infoCustomName = rs.getString("infoCustomName");
  				        String infoCustomName_e = rs.getString("infoCustomName_e");
  				        String infoCustomName_t = rs.getString("infoCustomName_t");
  				        String appicon = Util.null2String(rs.getString("appicon"));
  				        int appdesc =  Util.getIntValue(rs.getString("appdesc"));
  				        if(appicon.equals("")){
  				        	appicon="/middlecenter/images/app/app_wev8.png";
  				        }
  				        String text = mu.getMenuText(labelId, useCustomName, customName, customName_e, customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());           
						String id =rs.getString("id");
						
						
						//快速部署，屏蔽一些不常用的功能
				   		//邮件
				   		int infoid = Util.getIntValue(id);
				   		if (!PortalUtil.isShowEMail() && infoid == 1381) {
				   		    continue;
				   		}
				   		//通信
				   		if (!PortalUtil.isShowMessage() && infoid == 1329) {
				   		    continue;
				   		}
				   		//调查
				   		if (!PortalUtil.isShowSurvey() && infoid == 10086) {
				   		    continue;
				   		}
  						%>
  						<div class="app" id="<%=id%>" style="position:relative;">
  							
  							<div class="icon">
  							<div style="height:20px;">&nbsp;</div>
  							<img src="<%=appicon %>">
  							</div>
  							
  							<div class="content center">
  								<div style="height:20px;">&nbsp;</div>
  								<div class="name"><%=text %></div>
  								<div style="height:10px;">&nbsp;</div>
  								<div class="desc center" title="<%=SystemEnv.getHtmlLabelName(appdesc,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(appdesc,user.getLanguage()) %></div>
  							</div>
  							<div class="over">
  								<div style="height:20px;">&nbsp;</div>
  								<div class="name"><%=text %></div>
  								<div style="height:10px;">&nbsp;</div>
  								<div class="desc center" title="<%=SystemEnv.getHtmlLabelName(appdesc,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(appdesc,user.getLanguage()) %></div>
  							
  							</div>
  						</div>
  						<% 
  					}
  				%>
  					<div style="clear:both;"/>
  			</div>
  			<div id="toolbar" style="text-align: right">
  				
  			</div>
  		</div>
  	</div>
  	
  	<div id="logAbstract" class="e8_logAbstract">
  		
  		<div class="e8_dirHot">
  			<div class="e8_dirHotHead">
  			<%=SystemEnv.getHtmlLabelName(33750,user.getLanguage())%>
  			</div>
  			<div>
  				<%
  				 secList = getAppUseInfo();
  				
  				int total = 0;
  				//rs.executeSql("SELECT menuid,clickCnt FROM HrmUserMenuStatictics ORDER BY clickCnt desc");
  				
  			if(secList.size()>0){
  			
  				for(int i=0;i<secList.size();i++){ 
  					Map<String,String> m = secList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					String progress = "0%";
  					if(i==0){
  						total = count;
  						if(total==0)total=1;
  						progress="100%";
  					}else{
  						if((count*1.0/total*100)<1){
							progress = "1%";
						}else if((count*1.0/total*100)>100){
							progress = "100%";
						}else{
							progress = (count*1.0/total*100)+"%";
						}
  					
  					}
  				%>
  					<div style="margin-top:20px;">
  						<div class="e8_ranking" style="background-image:url(/images/ecology8/doc/rank_<%=i %>_wev8.png);"><%=i+1 %></div>
  						<div class="e8_content"><%= getAppName(Util.getIntValue(m.get("appid")),user)%></div>
  						
  						<div class="e8_progress_div">
  						<span title="<%=count %>" id="app_<%= m.get("appid")%>" class="e8_progress e8_progress_<%=i %>" style="width:0%"></span>
  							<script type="text/javascript">
  								jQuery(document).ready(function(){
  									$("#app_<%=m.get("appid") %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
  								});
  							</script>
  							</div>
  						<div style="clear:both;"></div>
  					</div>
  				<%}
  				}else{%>
  					<div class="nodata center" style="width:250px;padding-top:30px;">
  						<div class="" style="position:relative">
  						<img src="/middlecenter/images/app/nodata_wev8.png">
  							<div class="" style="position:absolute;color:#c2c2c2;top:10px;left:60px;font-size:14px;">
  								<%=SystemEnv.getHtmlLabelName(127909,user.getLanguage())%>
  							</div>
  						</div>
  						
  					</dv>
  				<%} %>
  			</div>
  		</div>
  		</div>
  		<div class="e8_dirHot" style="margin-left:50px;">
  			<div class="e8_dirHotHead">
  				<%=SystemEnv.getHtmlLabelName(33751,user.getLanguage())%>
  			</div>
  			<div>
  				<%
  				 secList = gethtItemTypeNum(TimeUtil.getCurrentDateString(),TimeUtil.getCurrentDateString(),"");
  	  			
  				 total = 0;
  				//rs.executeSql("SELECT menuid,clickCnt FROM HrmUserMenuStatictics ORDER BY clickCnt desc");
  				
  			if(secList.size()>0){
  				int max = 0;
  				if(secList.size()>5){
  					max = 5;
  				}else{
  					max = secList.size();
  				}
  				for(int i=0;i<max;i++){ 
  					Map<String,String> m = secList.get(i);
  					int count = Util.getIntValue(m.get("count"),0);
  					String progress = "0%";
  					if(i==0){
  						total = count;
  						if(total==0)total=1;
  						progress="100%";
  					}else{
  						if((count*1.0/total*100)<1){
							progress = "1%";
						}else if((count*1.0/total*100)>100){
							progress = "100%";
						}else{
							progress = (count*1.0/total*100)+"%";
						}
  					
  					}
  				%>
  					<div style="margin-top:20px;">
  						<div class="e8_ranking" style="background-image:url(/images/ecology8/doc/rank_<%=i %>_wev8.png);"><%=i+1 %></div>
  						<div class="e8_content"><%= getSystemItemName(Util.getIntValue(m.get("type")),user.getLanguage())%></div>
  						
  						<div class="e8_progress_div">
  						<span title="<%=count %>" id="log_<%= m.get("type")%>" class="e8_progress e8_progress_<%=i %>" style="width:0%"></span>
  							<script type="text/javascript">
  								jQuery(document).ready(function(){
  									$("#log_<%=m.get("type") %>").animate({"width": "<%=progress %>"}, (<%=(count*1.0/total*100) %>)*15);
  								});
  							</script>
  							</div>
  						<div style="clear:both;"></div>
  					</div>
  				<%}
  				}else{%>
  					<div class="nodata center" style="width:250px;padding-top:30px;">
  						<div class="" style="position:relative">
  						<img src="/middlecenter/images/app/nodata_wev8.png">
  							<div class="" style="position:absolute;color:#c2c2c2;top:10px;left:60px;font-size:14px;">
  								<%=SystemEnv.getHtmlLabelName(127909,user.getLanguage())%>
  							</div>
  						</div>
  						
  					</dv>
  				<%} %>
  			</div>
  		</div>
  		<div style="clear:both;"></div>
  	</div>
  	<div style="height:30px;"></div>
  	<script type="text/javascript">
  	
  		$(document).ready(function(){
  			var appnums = $("#appnums").text()*1;
  			var width = 1020;
  			var rowItems = parseInt(width/170);
  			var maxShowindex = rowItems*2-1;
  			var rowCounts 
  			if(appnums%rowItems>0){
  				rowCounts = parseInt(appnums/rowItems)+1;
  			}else{
  				rowCounts = parseInt(appnums/rowItems);
  			}
  			var pageCount;
  			if(rowCounts%2>0){
  				pageCount = parseInt(rowCounts/2)+1
  			}else{
  				pageCount = parseInt(rowCounts/2)
  			}
  			//alert(rowCounts);
  			if(pageCount==1){
  				$("#toolbar").hide();
  			}else{
  				
  				$(".app:gt("+maxShowindex+")").hide();
  				for(i=1;i<=pageCount;i++){
  					var cls = "";
  					if(i==1){
  						cls = "current"
  					}
  					$("#toolbar").append("<span class='page "+cls+"' page='"+i+"'>&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;");
  				}
  				
  				$("#toolbar").find(".page").bind("click",function(){
  					$(".current").removeClass("current");
  					$(this).addClass("current");
  					var page = $(this).attr("page");
  					$(".app").hide();
  					if(page==1){
  						var index = page*rowItems*2
  						//alert(index)
  						$(".app:lt("+index+")").show()
  					}else if(page==pageCount){
  						var index = (page-1)*rowItems*2-1
  						//alert(index)
  						$(".app:gt("+index+")").show()
  					}else{
  						var index = (page-1)*rowItems*2-1
  						$(".app:gt("+index+")").show()
  						var index = (page)*rowItems*2-1
  						$(".app:gt("+index+")").hide()
  					}
  					
  				})
  			}
  			
  			$(".app").hover(function(){
  				//$(this).find(".content").hide();
  				$(this).find(".over").show();
  				$(this).find(".over").animate({height:"80px"})
  			},function(){
  				$(this).find(".over").hide();
  				$(this).find(".over").animate({height:"0px"})
  			})
  			
  			$(".app").bind("click",function(){
  				var menuid = $(this).attr("id");
  				$(".menuitem[menuid="+menuid+"]",parent.document).trigger("click");
  			})
  			
  			
  			$("#commomsetting").click(function(){
  				$(".selected",parent.document).removeClass("selected")
  				parent.getDeployedApp(10078,true)
  			})
  		})
  	</script>
  </body>
</html>

<%!


private List<Map<String,String>> getAppUseInfo() throws Exception{
	List<Map<String,String>> htItemTypeNum = new ArrayList<Map<String,String>>();	

	weaver.conn.RecordSet RecordSet = new weaver.conn.RecordSet();
	String sql="";
	if(RecordSet.getDBType().equalsIgnoreCase("sqlserver")){
		sql = "SELECT top 5  appid,sum(usecount) AS nums  FROM appuseinfo GROUP BY appid  ORDER BY nums desc";
	
	}else{
		sql = " SELECT  appid,sum(usecount) AS nums  FROM appuseinfo  where rownum<=5 GROUP BY appid  ORDER BY nums desc";
		
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		
	
		Map<String,String> m = new HashMap<String,String>();
  		m.put("appid",RecordSet.getString("appid"));
  		m.put("count",RecordSet.getString("nums"));
  		htItemTypeNum.add(m);
		//htItemTypeNum.put(RecordSet.getInt("typeid"),RecordSet.getInt("num"));
	}
	
	return htItemTypeNum;
}
private List<Map<String,String>> gethtItemTypeNum(String startdate, String startdateto, String qname) throws Exception{
	weaver.conn.RecordSet RecordSet = new weaver.conn.RecordSet();
	List<Map<String,String>> htItemTypeNum = new ArrayList<Map<String,String>>();	
	String sqlWhere = "";
	if(!"".equals(startdate)){
		sqlWhere += " and SysMaintenanceLog.operatedate >= '"+startdate+"'"; 
	}
	
	if(!"".equals(startdateto)){
		sqlWhere += " and SysMaintenanceLog.operatedate <= '"+startdateto+"'"; 
	}
	
	if(!qname.equals("")){
		sqlWhere += " and relatedName like '%"+qname+"%'";
	}	
	
	RecordSet.executeSql(" SELECT SystemLogItem.typeid, COUNT(*) num FROM SysMaintenanceLog , SystemLogItem" 
											+" WHERE SysMaintenanceLog.operateitem = SystemLogItem.itemid"
											+" AND  SystemLogItem.itemid != 60 AND SystemLogItem.typeid !=7 "
											+sqlWhere
											+" GROUP BY SystemLogItem.typeid");

	while(RecordSet.next()){
		if("1".equals(RecordSet.getString("typeid"))){
			continue;
		}
	
		Map<String,String> m = new HashMap<String,String>();
  		m.put("type",RecordSet.getString("typeid"));
  		m.put("count",RecordSet.getString("num"));
  		htItemTypeNum.add(m);
		//htItemTypeNum.put(RecordSet.getInt("typeid"),RecordSet.getInt("num"));
	}
	
	return htItemTypeNum;
}
private String getSystemItemName(int id,int lang){
	String name ="";
	
	 switch(id){
		 case -1: // 其他
			 name = SystemEnv.getHtmlLabelName(375,lang);
				break;
		 case 2: // 人力资源
			 name = SystemEnv.getHtmlLabelName(179,lang);
				break;
		 case 4: // 财务
			 name = SystemEnv.getHtmlLabelName(33274,lang);
				break;
		 case 5: // 资产
			 name = SystemEnv.getHtmlLabelName(33263,lang);
				break;
		 case 8: // 协作
			 name = SystemEnv.getHtmlLabelName(33264,lang);
				break;
		 case 10: //项目
			 name = SystemEnv.getHtmlLabelName(33262,lang);
				break;
		 case 11: //客户 	
			 name = SystemEnv.getHtmlLabelName(33261,lang);
				break;
	 }
	 
	 return name;
}

private String getAppName(int appid,User user){
	
	String name = "";
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	rs.executeSql("select * from MainMenuInfo where id ="+appid);
	if(rs.next()){
			int labelId = rs.getInt("labelId");
	        
			MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
	        
	        boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
	        String customName = rs.getString("customName");
	        String customName_e = rs.getString("customName_e");
	        String customName_t = rs.getString("customName_t");
	        
	        boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true  : false;
	        String infoCustomName = rs.getString("infoCustomName");
	        String infoCustomName_e = rs.getString("infoCustomName_e");
	        String infoCustomName_t = rs.getString("infoCustomName_t");
	        String appicon = Util.null2String(rs.getString("appicon"));
	        int appdesc =  Util.getIntValue(rs.getString("appdesc"));
	        if(appicon.equals("")){
	        	appicon="/middlecenter/images/app/app_wev8.png";
	        }
	        name = mu.getMenuText(labelId, useCustomName, customName, customName_e, customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());           
	}		
	return name;
}
%>
