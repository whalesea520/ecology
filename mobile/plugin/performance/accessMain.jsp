<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);

	int showtype = Util.getIntValue(request.getParameter("showtype"),0);
	String currentUserId = user.getUID()+"";
	String currentdate = TimeUtil.getCurrentDateString();
    int count = Util.getIntValue(request.getParameter("count"),0);
    int unread = Util.getIntValue(request.getParameter("unread"),0);
    if(count==0){
    	String countSql = "select count(distinct t.id) total,count(distinct case when ga.id is null then t.id end) noread  from GP_AccessScore t join HrmResource h on t.userid = h.id left join GP_AccessScoreLog ga on ga.scoreid = t.id "
            +" and ga.operator = "+currentUserId+ "where t.isvalid=1 and t.status<>3  and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
    	 	+" and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")
    		+" and (t.operator="+currentUserId+" or exists(select 1 from GP_AccessScoreAudit aa where aa.scoreid=t.id and aa.userid="+currentUserId+")) ";
    	rs.executeSql(countSql);
        if(rs.next()){
        	count = rs.getInt("total");
        	unread = rs.getInt("noread");
        } 
    }
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
		ul.tab li:first-child{border-radius:3px 0 0 3px;border-right:0;}
		ul.tab li:last-child{border-radius:0 3px 3px 0;}
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="body">
    <div id="main-panel" class="main-panel"><!-- 顶部 -->
		<div id="header">
		    <input type="hidden" value="1" id="pageNum" name="pageNum" autocomplete="off"/>
			<input type="hidden" id="showtype" name="showtype" value="<%=showtype %>"/>
			<ul class="tab">
				<li class="tab1" data-value="1">考核成绩</li>
				<li class="tab1 selected" data-value="2">考核评分
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
			<li class="tab <%if(showtype==0){ %>tab_click<%} %>" data-value="0">全部</li>
			<li class="tab <%if(showtype==1){ %>tab_click<%} %>" data-value="1">待评分</li>
			<li class="tab <%if(showtype==2){ %>tab_click<%} %>" data-value="2">待审批</li>
		</ul>
	</div>
	<div class="listSearch">
		<img src="/mobile/plugin/performance/images/searchright_wev8.gif" class="btn">
		<form action="javascript:getSearch();">
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
					<div class="Formfield-Label">周期 :</div>
					<div class="Design_FInputText_Fielddom">
						<div class="Design_FSelect_Fielddom">
						<select id="type1" class="MADFS_Left_Select">
							<option value="">请选择</option>
							<option value="1">月度</option>
							<option value="2">季度</option>
							<option value="3">半年</option>
							<option value="4">年度</option>
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
	<div id="userChooseDiv">
		<iframe id="userChooseFrame" src="/mobile/plugin/plus/browser/hrmBrowser.jsp" frameborder="0" scrolling="auto">
		</iframe>
	</div>
	<div id="departBrowserDiv">
		<iframe id="departBrowserFrame_eb" src="/mobile/plugin/plus/browser/departBrowser.jsp" frameborder="0" scrolling="auto">
		</iframe>
	</div>
	<script type="text/javascript">
		$(document).ready(function(){
		       if($(body).width()>=768){
			      $('*').css('font-size','16px');
			   }
		       $("#tabblank").height($("#main-panel").height()+3);//占位fixed出来的空间
		       getAccessList();
		       $("ul.tab .tab1").click(function(){
		           var datavalue = $(this).attr('data-value');
		           if(datavalue==2){
		             window.location = "/mobile/plugin/performance/accessMain.jsp";
		           }else{
		             window.location = "/mobile/plugin/performance/perforMain.jsp";
		           }
		       });
		      $(".tabpanel li.tab").click(function(){
				    var datavalue = $(this).attr('data-value');
		            $(this).addClass("tab_click");
			        $(this).siblings().removeClass("tab_click");
			        $('#pageNum').val(1);
			        $('#showtype').val(datavalue);
			        $('#items').empty();
			        getAccessList();
		      });
		       
		       $("#showMoreTask").live("click",function(){
		           $("#showMoreTask").hide();
		           getAccessList();
		       });
		       $(".listSearch .btn").on("click", function(){
					getSearch();
			   });
			   $("#hrmname").keyup(function(event){
					var keyCode = event.keyCode;
					if(keyCode == 13){
					   getSearch();
					}
				});
		 });
		 function getSearch(){
		    $('#pageNum').val(1);
		    $('#items').empty();
		    getAccessList();
		 }
		 function doSearch(){
		  doHistoryBack();
		  $('#pageNum').val(1);
		  $('#items').empty();
		  getAccessList();
		}
		 function getAccessList(){
		   $('.mec_refresh_loading').show();
		   var pageNum = $('#pageNum').val();
		   var showtype = $('#showtype').val();
		   var type1 = $('#type1').val();
		   var hrmids = $('#hrmids').val();
		   var hrmname = $('#hrmname').val();
		   var subids = $('#subids').val();
		   var deptids = $('#deptids').val();
		   $.ajax({
				url:"/mobile/plugin/performance/getAccessList.jsp",
				data:{"pageNum":pageNum,"showtype":showtype,"type1":type1,'hrmids':hrmids,'hrmname':hrmname,'subids':subids,'deptids':deptids},
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
				            htresult +="<li onclick=\"searchAccess('/mobile/plugin/performance/AccessView.jsp?scoreid=" + n.id+"&back=1');\"><table><tbody><tr>";
							htresult += "<td class=\"imgPart\">";
							htresult += "<div class=\"imgin\">";
							htresult += "<img src=\""+n.userimg+"\"/>";
							htresult += "</div></td>";
							htresult += "<td class=\"fieldPart\">";
							htresult +="<div class=\"titleRowWrap\"><span>"+n.scorename+"<br/>评分："+(n.result==''?"-":n.result)+"</span><font class=\"newsfont\">"+(n.nums==0?"new":"")+"</font></div>";  
							htresult +="<div class=\"colWrap\"><span>"+n.subname+">"+n.departmentname+"</span></div>";  
							htresult +="<div class=\"colWrap\"><span>";
							if(n.statusctx!=""){
								htresult += "状态："+n.statusctx;
							}
							htresult +=" 截止日期："+n.enddate+"</span></div></td><td>";
							var opts = "";
							if(n.opt==0){
							   opts = "<span>已过期</span>";
							}else{
							  if(n.status==0 || n.status==2){
							     opts = "<span>评分</span>";
							  }else if(n.status==1){
							     opts = "<span id=\"doApprove\" onclick=\"doApprove("+n.id+")\">批准</span>"+"<br/><span id=\"doReturn\" onclick=\"doReturn("+n.id+")\" style=\"background-color:#808080;\">退回</span>";
							  }
							}
							htresult +="<div class=\"zt1\">"+opts+"</div>";
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
		}
		function doApprove(scoreids,event) {
		        var showtype = $('#showtype').val();
		        if(confirm("确定批准此考核结果?")){
					jQuery.ajax({
						type: "post",
						dataType:"json",
						url: "/mobile/plugin/performance/AccessOperation.jsp",
					    data:{"operation":"quick_approve","scoreids":scoreids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					        window.location.href = "/mobile/plugin/performance/accessMain.jsp?showtype="+showtype;
					    }
				    });
				}
				stopDefaultProp(event);
			}
			function doReturn(scoreids,event) {
			    var showtype = $('#showtype').val();
				if(confirm("确定退回此考核结果??")){
					jQuery.ajax({
						type: "post",
						dataType:"json",
						url: "/mobile/plugin/performance/AccessOperation.jsp",
					    data:{"operation":"quick_return","scoreids":scoreids}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){
					        window.location.href = "/mobile/plugin/performance/accessMain.jsp?showtype="+showtype;
					    }
				    });
				}
				stopDefaultProp(event);
			}
	</script>
</body>
</html>