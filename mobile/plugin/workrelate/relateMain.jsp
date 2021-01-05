<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);
	String currentUserId = user.getUID()+"";
	String currentdate = TimeUtil.getCurrentDateString();

	String year = Util.null2String(request.getParameter("year"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	int count = Util.getIntValue(request.getParameter("count"),0);
    int unread = Util.getIntValue(request.getParameter("unread"),0);
    if(count==0){
    	String countSql = "select count(distinct t.id) total,count(distinct case when rp.id is null then t.id  end) noread from PR_PlanReport t join HrmResource h on t.userid = h.id left join PR_PlanReportLog rp on t.id = rp.planid and rp.operator="+currentUserId;

    	if("oracle".equals(rs.getDBType())){
    		countSql +=" where t.isvalid=1 and t.status=1 and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
    			+" and h.status in (0,1,2,3) and h.loginid is not null"
    		+" and (exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid="+currentUserId+"))";
    	}else{
    		countSql +=" where t.isvalid=1 and t.status=1 and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
    	 	+" and h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>''"
    		+" and (exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid="+currentUserId+"))";
    	}
    	rs.executeSql(countSql);
        if(rs.next()){
        	count = rs.getInt("total");
        	unread = rs.getInt("noread");
        } 
    }
	if(year.equals("")){
		if(year.equals("")) year = currentdate.substring(0,4);
	}
	int isweek = 0;       
	int ismonth = 0;    
	rs.executeSql("select count(id) from PR_BaseSetting where resourcetype=2 and ismonth=1");
	if(rs.next() && rs.getInt(1)>0) ismonth = 1;  
	rs.executeSql("select count(id) from PR_BaseSetting where resourcetype=2 and isweek=1");
	if(rs.next() && rs.getInt(1)>0) isweek = 1;  
	if(isweek!=1 && ismonth!=1) {
		out.print("<table width='100%'><tr><td align='center'>您暂未开启任何计划报告周期！</td></tr></table>");
		return;//未启用任何周期
	}
	if(isweek!=1 && type1.equals("2")) type1 = "";
	if(ismonth!=1 && type1.equals("1")) type1 = "";
	if(type1.equals("")){
		if(isweek==1){ type1 = "2";}
		if(ismonth==1){ type1 = "1";}
	}
	if(type2.equals("")){
		if(type1.equals("2")) type2 = TimeUtil.getWeekOfYear(new Date())+"";
		if(type1.equals("1")) type2 = currentdate.substring(5,7);
		
		rs.executeSql("select count(id) from PR_PlanReport where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and startdate<='"+currentdate+"'");
		if(rs.next() && rs.getInt(1)==0){
			if(type1.equals("1")){
				if(Integer.parseInt(type2)==1){
					year = (Integer.parseInt(year)-1)+"";
					type2 = "12";
				}else{
					type2 = (Integer.parseInt(type2)-1)+"";
				}
			}else if(type1.equals("2")){
				if(Integer.parseInt(type2)==1){
					year = (Integer.parseInt(year)-1)+"";
					type2 = TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+"";
				}else{
					type2 = (Integer.parseInt(type2)-1)+"";
				}
			}
		}
	}
	int intyear = Integer.parseInt(year);
	int inttype1 = Integer.parseInt(type1);
	int inttype2 = Integer.parseInt(type2);
	
	String backfields = " h.id,h.lastname,h.workcode,h.dsporder,t.id as planid,t.planname,t.year,t.type1,t.type2,t.status as s_status,t.isresubmit,t.startdate,t.enddate,h.departmentid,h.subcompanyid1,h.jobtitle ";
	String fromSql = " HrmResource h join PR_BaseSetting b on h.subcompanyid1=b.resourceid and b.resourcetype=2 left join PR_PlanReport t on h.id=t.userid and t.isvalid=1 and t.year="+year+" and t.type1="+type1+" and t.type2="+type2
				+" left join PR_PlanProgram p on h.id=p.userid and p.programtype="+type1;
	String orderby = " h.dsporder,h.id ";			
	
	String sqlWhere = " where h.status in (0,1,2,3) and h.loginid is not null and h.loginid<>''"
		+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%' or ','+convert(varchar(200),p.auditids)+',' like '%,"+currentUserId+",%' or p.shareids like '%,"+currentUserId+",%' or t.shareids like '%,"+currentUserId+",%'"
		+" or exists(select 1 from PR_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.reportaudit like '%,"+currentUserId+",%' or bs.reportview like '%,"+currentUserId+",%'))"
		+" or exists(select 1 from PR_PlanReportlog l where l.planid=t.id and l.operatetype in (4,5) and l.operator="+currentUserId+")"
		+")";
	if("oracle".equals(rs.getDBType())){
		sqlWhere = " where h.status in (0,1,2,3) and h.loginid is not null"
			+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%' or CONCAT(CONCAT(',',p.auditids),',') like '%,"+currentUserId+",%' or p.shareids like '%,"+currentUserId+",%' or t.shareids like '%,"+currentUserId+",%'"
			+" or exists(select 1 from PR_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.reportaudit like '%,"+currentUserId+",%' or bs.reportview like '%,"+currentUserId+",%'))"
			+" or exists(select 1 from PR_PlanReportlog l where l.planid=t.id and l.operatetype in (4,5) and l.operator="+currentUserId+")"
			+")";
	}
	if(inttype1==1){
		sqlWhere += " and b.ismonth=1";
	}else if(inttype1==2){
		sqlWhere += " and b.isweek=1";
	}
	String weekdate1 = TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
	String weekdate2 = TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(Integer.parseInt(year),Integer.parseInt(type2)));
	int currentweek = TimeUtil.getWeekOfYear(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"/>
	<meta http-equiv="Pragma" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script type='text/javascript' src='/mobile/plugin/workrelate/js/workrelate.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/performance/css/newperf.css" />
	
	<style type="text/css">
    .weekselect{width: 302px;height:auto;border: 1px #ECECEC solid;position: absolute;display: none;background: #fff;z-index: 99999;overflow:hidden;}
	.weekoption{width: 50px;line-height:22px;text-align:center;float:left;color:#999999;font-size:12px;cursor:pointer;}
	.weekoption_current{background: #F8EFEF;}
	.weekoption_hover,.weekoption_select{background: #0080C0;color: #fff;}
	.week_txt{float: left;line-height:40px;width: 56px;text-align: center;margin: 0px;padding: 0px;font-weight: normal;font-size: 12px;cursor: pointer;}
	.week_btn1{float: left;width: 16px;height: 28px;margin: 0px;margin-top:6px;padding: 0px;background: url('images/prev.png') center no-repeat;}
	.week_prev{cursor: pointer;}
	.week_prev_hover{background: url('images/prev_hover.png') center no-repeat;}
	.week_btn2{float: left;width: 16px;height: 28px;margin: 0px;margin-top:6px;padding: 0px;background: url('images/next.png') center no-repeat;}
	.week_next{cursor: pointer;}
	.week_next_hover{background: url('images/next_hover.png') center no-repeat;}
	.week_show{width:160px;float:left;line-height: 40px;color: #969696;font-weight: normal;font-size: 12px;}
	.week_show1{line-height: 20px;color: #969696;font-weight: normal;font-size: 12px;}
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="body">
    <div id="main-panel" class="main-panel"><!-- 顶部 -->
		<div id="header">
		    <input type="hidden" value="1" id="pageNum" autocomplete="off"/>
			<input type="hidden" id="type1" value="<%=type1%>"/>
			<ul class="tab">
				<li class="tab1 selected" data-value="1">报告查询</li>
				<li class="tab1" data-value="2">报告审批
				<%if(count!=0){
				   if(unread!=0){%>
					   <font class="font_c2">(</font><font class="font_cl"><%=unread%></font><font class="font_c2"><%="/"+count+")" %></font>
				   <%}else{%>
					   <font class="font_c2">(<%=count+")" %></font>
				   <%}%>
				<%} %>
				</li>
			</ul>
		</div>
	</div>
	<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
	<div class="tabpanel">
		<ul>
			<%if(isweek==1){%><li class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" data-value="2">周报</li><%} %>
			<%if(ismonth==1){ %><li class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" data-value="1">月报</li><%} %>
		</ul>
	</div>
	<div class="listSearch">
		<img src="/mobile/plugin/performance/images/searchright_wev8.gif" class="btn">
		<form action="javascript:refreshList();">
			<input class="searchKey" type="search" id="hrmname" placeholder="请输入姓名...">
		</form>
		<a onclick="toShowSearch()" class="as_btn"><div class="line one"></div><div class="line two"></div><div class="line three"></div></a>
	</div>
	<!------------搜索条件部分------------->
	<div id="searchDiv">
				<span class="header-left" onclick="doHistoryBack()"></span>
				<div class="searchTitle">查询条件</div>
				<div class="tabContainer">
				
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">年份 :</div>
					<div class="Design_FInputText_Fielddom">
						 <div class="Design_FSelect_Fielddom">
						 <select id="year" class="MADFS_Left_Select">
							       <% 
										int currentyear = Integer.parseInt(currentdate.substring(0,4));
										for(int i=2013;i<(currentyear+3);i++){ %>
										  <option value="<%=i %>" <%if(Integer.parseInt(year)==i){ %>selected<%} %>><%=i %></option>
								  <%} %>
						</select>
						</div>
					</div>
				</div>
				<%if(type1.equals("1")){ %>
				  <div class="Formfield-Wrap">
					<div class="Formfield-Label">月份 :</div>
					<div class="Design_FInputText_Fielddom">
					<div class="Design_FSelect_Fielddom">
						 <select id="type2" class="MADFS_Left_Select">
							<%for(int i=1;i<13;i++){ %>
								<option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>月</option>
							<%} %>
						</select>
						</div>
					</div>
				</div>
				<%}else if(type1.equals("2")){ %>
				  <div class="Formfield-Wrap">
				    <input type="hidden" id="type2" value="<%=type2%>"/>
					<div class="Formfield-Label">周 :</div>
					<div class="Design_FInputText_Fielddom">
						<div class="week_btn1 <%if(inttype2!=1){ %>week_prev<%} %>"></div>
						<div id="weekpanel" class="week_txt">第&nbsp;<%=type2 %>&nbsp;周</div>
						<div class="week_btn2 <%if(inttype2!=TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))){ %>week_next<%} %>" ></div>
						<div class="week_show" id="week_show"><%=weekdate1+" 至 "+weekdate2 %></div>
					</div>
				</div>
				<%}%>
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">状态 :</div>
					<div class="Design_FInputText_Fielddom">
						<div class="Design_FSelect_Fielddom">
						<select id="status" class="MADFS_Left_Select">
							<option value="">请选择</option>
							<option value="0">草稿</option>
							<option value="1">审批中</option>
							<option value="3">已完成</option>
							<option value="-1">其他</option>
						</select>
						</div>
					</div>
				</div>
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">人员 :</div>
					<div class="Design_FInputText_Fielddom">
						<textarea class="intext" placeholder="请选择..." id="hrmidsSpan" readonly onclick="selectUser('hrmids','hrmidsSpan',1)"></textarea>
						<div id="img1" class="btn_browser" style="margin-left:3px !important;" onclick="selectUser('hrmids','hrmidsSpan',1)"></div>
						<input type="hidden" id="hrmids" name="hrmids"/>
					</div>
				</div>
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">分部 :</div>
					<div class="Design_FInputText_Fielddom">
						<textarea class="intext" placeholder="请选择..." id="subsSpan" readonly onclick="onBrowserDepart_dt('subids','subsSpan',1,2)"></textarea>
						<div id="img2" class="btn_browser" style="margin-left:3px !important;" onclick="onBrowserDepart_dt('subids','subsSpan',1,2)"></div>
						<input type="hidden" id="subids" name="subids"/>
					</div>
				</div>
				
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">部门 :</div>
					<div class="Design_FInputText_Fielddom">
						<textarea class="intext" placeholder="请选择..." id="deptsSpan" readonly onclick="onBrowserDepart_dt('deptids','deptsSpan',1,1)"></textarea>
						<div id="img3" class="btn_browser" style="margin-left:3px !important;" onclick="onBrowserDepart_dt('deptids','deptsSpan',1,1)"></div>
						<input type="hidden" id="deptids" name="deptids"/>
					</div>
				</div>

				<div id="fButtons" class="fButtons">
					<div title="搜索" onclick="doSearch();" class="fButton fSubmitButton">搜索</div>
				</div>
		</div>
	</div>
	<div id="items"></div>
	<div class="mec_refresh_loading">
		<div class="spinner">
			<div class="bounce1"></div>
			<div class="bounce2"></div>
			<div class="bounce3"></div>
		</div>
	</div>
	<div id="weekselect" class="weekselect">
		<%for(int i=1;i<TimeUtil.getMaxWeekNumOfYear(Integer.parseInt(year))+1;i++){%>
			<div weekvalue="<%=i%>" class="weekoption<%if(currentweek==i){ %> weekoption_current<%} %><%if(inttype2==i){ %> weekoption_select<%} %>">第<%=i %>周</div>
		<%	} %> 
	</div>	
	<div id="userChooseDiv">
		<iframe id="userChooseFrame" src="/mobile/plugin/plus/browser/hrmBrowser.jsp" frameborder="0" scrolling="auto">
		</iframe>
	</div>
	<div id="departBrowserDiv">
		<iframe id="departBrowserFrame_eb" src="/mobile/plugin/plus/browser/departBrowser.jsp" frameborder="0" scrolling="auto">
		</iframe>
	</div>
	<script type="text/javascript">
	    var $currentweek = <%=currentweek%>;
		$(document).ready(function(){
		       if($(body).width()>=768){
			      $('*').css('font-size','16px');
			   }
		       $("#tabblank").height($("#main-panel").height()+3);//占位fixed出来的空间
		       $("ul.tab .tab1").on("click",function(){
		           var datavalue = $(this).attr('data-value');
		           if(datavalue==2){
		             window.location = "/mobile/plugin/workrelate/auditMain.jsp";
		           }else{
		             window.location = "/mobile/plugin/workrelate/relateMain.jsp";
		           }
		       });
		        $(".tabpanel li.tab").on("click",function(){
				   var datavalue = $(this).attr('data-value');
		           var year = $('#year').val();
		           window.location = "relateMain.jsp?year="+year+"&type1="+datavalue;
		           
		      });
		       
		       var len = $("ul.tab .tab1").length;
		       if(len==2){
		         $("ul.tab .tab1:first").css({'border-radius':'3px 0 0 3px','border-right':0});
		         $("ul.tab .tab1:last").css('border-radius','0 3px 3px 0');
		       }else if(len==1){
		         $("ul.tab .tab1").css('border-radius','3px 3px 3px 3px');
		       }
		       getResultList();
		       $("#showMoreTask").live("click",function(){
		           $("#showMoreTask").hide();
		           getResultList();
		       });
		       
		       $(".listSearch .btn").on("click", function(){
					refreshList();
			   });
			   $("#hrmname").keyup(function(event){
					var keyCode = event.keyCode;
					if(keyCode == 13){
					   refreshList();
					}
				});
		      
		       $('#weekpanel').live('click',function(){
		          var wth = "312px";
		          if(screen.width<400){
		            wth = "200px"
		          }
		          $("#weekselect").css({top:$(this).offset().top+35,left:$(this).offset().left,width:wth});
		          $('#weekselect').toggle();
		       });
		       $('.weekselect .weekoption').live('click',function(){
		          var weekvalue = $(this).attr('weekvalue');
		          $(this).addClass("weekoption_select");
		          $(this).siblings().removeClass("weekoption_select");
		          var int_year = $('#year').val();
		          $.ajax({
					type: "post",
					url: "/mobile/plugin/workrelate/PlanOperation.jsp",
					data:{"operation":"week","year":int_year,"type2":weekvalue}, 
					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					complete: function(data){
					   if(data!=""){
						var txt = $.trim(data.responseText);
						$("#week_show").html(txt);
						$('#weekpanel').html("第"+weekvalue+"周");
		                $('#type2').val(weekvalue);
					   }
					}
			     });
		       });
		       $('.week_btn1').live('click',function(){
		         var $type = $('#type2').val();
		         var int_year = $('#year').val();
		         if($type==1)return;
		         var $t = parseInt($type)-parseInt(1);
		         $.ajax({
					type: "post",
					url: "/mobile/plugin/workrelate/PlanOperation.jsp",
					data:{"operation":"week","year":int_year,"type2":$t}, 
					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					complete: function(data){
					   if(data!=""){
						var txt = $.trim(data.responseText);
						$("#week_show").html(txt);
						$('#weekpanel').html("第"+$t+"周");
						$('#type2').val($t);
						$('.weekoption').each(function(){
						  var $this = $(this).attr('weekvalue');
						  if($this==$t){
						    $(this).addClass("weekoption_select");
		                    $(this).siblings().removeClass("weekoption_select");
		                    return false;
						  }
						});
					   }
					}
			     });
		       });
		       $('.week_btn2').live('click',function(){
		          var $type = $('#type2').val();
		          var int_year = $('#year').val();
		          var $t = parseInt($type)+parseInt(1);
		          $.ajax({
					type: "post",
					url: "/mobile/plugin/workrelate/PlanOperation.jsp",
					data:{"operation":"week","year":int_year,"type2":$t,"type":1}, 
					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					complete: function(data){
					   if(data!=""){
						var txt = $.trim(data.responseText);
						if(txt!="back"){
						   $("#week_show").html(txt);
						   $('#weekpanel').html("第"+$t+"周");
						   $('#type2').val($t);
						   $('.weekoption').each(function(){
							  var $this = $(this).attr('weekvalue');
							  if($this==$t){
							    $(this).addClass("weekoption_select");
			                    $(this).siblings().removeClass("weekoption_select");
			                    return false;
							  }
						});
						}
					   }
					}
			     });
		       });
		       $('#year').change(function(){
		          var $type1 = $('#type1').val();
		          if($type1==2){
		             var $type = $('#type2').val();
		             var int_year = $('#year').val();
		             $.ajax({
						type: "post",
						url: "/mobile/plugin/workrelate/PlanOperation.jsp",
						data:{"operation":"week","year":int_year,"type2":$type,"type":2}, 
						contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						complete: function(data){
						   if(data!=""){
							var txt = $.trim(data.responseText);
							var $txt = txt.split(',');
							$("#week_show").html($txt[0]);
							$('#weekselect').empty();
							var $ht = "";
							for(var n=1;n<=$txt[1];n++){
							  var $ctk = "";
							  var $wks ="";
							  if($currentweek==n) $ctk =" weekoption_current";
							  if($type==n) $wks = " weekoption_select";
							  $ht += "<div weekvalue=\""+n+"\" class=\"weekoption"+$ctk+$wks+" \">第"+n+"周</div>";
							}
							$('#weekselect').append($ht);
							if($type>$txt[1]){
							  $('#type2').val($txt[1]);
							  $('#weekpanel').html("第"+$txt[1]+"周");
							}
						   }
						}
				     });
		          }
		       });
		       $(document).bind("click",function(e){
				  var target=$.event.fix(e).target;
				  if($(target).attr("id")!="weekpanel"){
					 $("#weekselect").hide();
				  }
		       });
		       
		 });
		 function refreshList(){
		   $('#pageNum').val(1);
		   $('#items').empty();
		   getResultList();
		 }
		 function getResultList(){
		   $('.mec_refresh_loading').show();
		   var pageNum = $('#pageNum').val();
		   var years = $('#year').val();
		   var oType =$('#type1').val();
		   var TTpe = $('#type2').val();
		   var status = $('#status').val();
		   var hrmids = $('#hrmids').val();
		   var hrmname = $('#hrmname').val();
		   var subids = $('#subids').val();
		   var deptids = $('#deptids').val();
		   $.ajax({
				url:"/mobile/plugin/workrelate/getResultList.jsp",
				data:{"pageNum":pageNum,"year":years,"type1":oType,"type2":TTpe,"status":status,"hrmids":hrmids,'hrmname':hrmname,'subids':subids,'deptids':deptids},
				type:"post",
				dataType:"json",
				success:function(data){
				  if(data.msg==0){
				     if(data.list!=null){
				        var htresult ="";
				        var totalpage = data.totalpage;
				        if(pageNum==1){
							htresult = "<ul id=\"itemContent\" class=\"listContainer\">";
						}
				        var $d = data.list;
				        $.each($d,function(i,n){
				            htresult +="<li onclick=\"searchAccess('"+n.linkUrl+"');\"><table><tbody><tr>";
							htresult += "<td class=\"imgPart\">";
							htresult += "<div class=\"imgin\">";
							htresult += "<img src=\""+n.userimg+"\"/>";
							htresult += "</div></td>";
							htresult += "<td class=\"fieldPart\">";
							htresult +="<div class=\"titleRowWrap\"><span>"+n.lastname+n.titlename+"</span></div>";  
							htresult +="<div class=\"colWrap\"><span>"+n.subname+">"+n.deptname+"</span></div>";  
							htresult +="<div class=\"colWrap\"><span>";
							if(n.info!=""){
								htresult += n.info;
							}
							htresult +="</span></div></td><td>";
							htresult +="<div class=\"zt0\" style=\"background-color:#"+n.fcolor+";\">"+n.ss_sta+"</div>";
							htresult +="</td></tr></tbody></table></li>";
				        });
				        if(pageNum==1){
							htresult += "</ul>";
							if(totalpage>pageNum){
								htresult += "<div class=\"showMoreTask\" id=\"showMoreTask\">更多</div>";
							}
							$('#items').append(htresult);
						}else{
						    $('#itemContent').append(htresult);
						}
						if(totalpage==pageNum){
						    $('#showMoreTask').remove();
						}else{
						    $('#pageNum').val(parseInt(pageNum)+1);
						    $("#showMoreTask").show();
						}
				     }
				  }else{
				     $('#items').empty();
				     var htresult = "<div class='taskTips'>"+data.msg+"</div>";
				     $('#items').append(htresult);
				  }
				},
				error:function(data){
				    $('#items').empty();
				    var htresult = "<div class='taskTips'>"+data.msg+"</div>";
					$('#items').append(htresult);
				},
				complete:function(data){
					$('.mec_refresh_loading').hide();
				}
			});
		 
		 }
		 function searchAccess(linkurl){//查看跳转
			$('#items').empty();
			$('.mec_refresh_loading').show();
			location.href=linkurl;
		}
		function toShowSearch(){
		  $("#searchDiv").animate({ "left":"0" },400,null,function(){
			setTimeout(function(){
				jQuery(document).scrollTop(0);
			},500);
		  });
	      $("#hrmidsSpan,#subsSpan,#deptsSpan").width($("#hrmidsSpan").parent().width()-$('#img1').width()-10);
		  if(($('#weekpanel').width() + $('.week_btn1').width()+$('.week_btn2').width()+$('#week_show').width())>$('#weekpanel').parent().width() ){
		        $('#week_show').removeClass('week_show').addClass('week_show1');
		    }
		}
		function doSearch(){
		  doHistoryBack();
		  $('#pageNum').val(1);
		  $('#items').empty();
		  getResultList();
		}
	</script>
</body>
</html>