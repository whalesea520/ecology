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
	if(year.equals("")){
		year = currentdate.substring(0,4);
	}
	int isfyear = 0;       
	int ishyear = 0;     
	int isquarter = 0;       
	int ismonth = 0;
	String sql ="select count(case when isfyear=1 then id end) fyear,count(case when ishyear=1 then id end) hyear,count(case when isquarter=1 then id end) qyear,"
	+"count(case when ismonth=1 then id end) myear  from GP_BaseSetting where resourcetype=2 ";
	rs.executeSql(sql);
	if(rs.next()){
		if(rs.getInt(1)>0){
			isfyear = 1;
		}
		if(rs.getInt(2)>0){
			ishyear = 1; 
		}
		if(rs.getInt(3)>0){
			isquarter = 1;
		}
		if(rs.getInt(4)>0){
			ismonth = 1;
		}
	}
	if(isfyear!=1 && ishyear!=1 && isquarter!=1 && ismonth!=1) {
		out.print("<table width='100%'><tr><td align='center'>您暂未开启任何考核周期！</td></tr></table>");
		return;//未启用任何考核
	}
	if(isfyear!=1 && type1.equals("4")) type1 = "";
	if(ishyear!=1 && type1.equals("3")) type1 = "";
	if(isquarter!=1 && type1.equals("2")) type1 = "";
	if(ismonth!=1 && type1.equals("1")) type1 = "";
	if(type1.equals("")){
		if(isfyear==1){ type1 = "4";}
		if(ishyear==1){ type1 = "3";}
		if(isquarter==1){ type1 = "2";}
		if(ismonth==1){ type1 = "1";}
	}
	if(type2.equals("")){
		if(type1.equals("4") || type1.equals("3")) type2 = "0";
		if(type1.equals("2")) type2 = TimeUtil.getCurrentSeason();
		if(type1.equals("1")) type2 = currentdate.substring(5,7);
		
		rs.executeSql("select count(id) from GP_AccessScore where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and startdate<='"+currentdate+"'");
		//System.out.println("select count(id) from GP_AccessScore where isvalid=1 and year="+year+" and type1="+type1+" and type2="+type2+" and startdate<='"+currentdate+"'");
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
					type2 = "4";
				}else{
					type2 = (Integer.parseInt(type2)-1)+"";
				}
			}else{
				year = (Integer.parseInt(year)-1)+"";
			}
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
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="body">
    <div id="main-panel" class="main-panel"><!-- 顶部 -->
		<div id="header">
		    <input type="hidden" value="1" id="pageNum" autocomplete="off"/>
			<input type="hidden" id="type1" value="<%=type1%>"/>
			<ul class="tab">
				<li class="tab1 selected" data-value="1">考核成绩</li>
				<li class="tab1" data-value="2">考核评分
				<%if(count!=0){
				   if(unread!=0){%>
					   <font class="font_c2">(</font><font class="font_cl"><%=unread%></font><font class="font_c2"><%="/"+count+")" %></font>
				   <%}else{%>
					   <font class="font_c2">(<%=count+")" %></font>
				   <%}%>
				<%} %>
			</ul>
		</div>
	</div>
	<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
	<div class="tabpanel">
		<ul>
			<%if(isfyear==1){ %><li class="tab <%if(type1.equals("4")){ %>tab_click<%} %>" data-value="4">年度</li><%} %>
		    <%if(ishyear==1){ %><li class="tab <%if(type1.equals("3")){ %>tab_click<%} %>" data-value="3">半年</li><%} %>
			<%if(isquarter==1){%><li class="tab <%if(type1.equals("2")){ %>tab_click<%} %>" data-value="2">季度</li><%} %>
			<%if(ismonth==1){ %><li class="tab <%if(type1.equals("1")){ %>tab_click<%} %>" data-value="1">月度</li><%} %>
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
					<div class="Formfield-Label">季度 :</div>
					<div class="Design_FInputText_Fielddom">
						<div class="Design_FSelect_Fielddom">
						  <select id="type2" class="MADFS_Left_Select">
							<%for(int i=1;i<5;i++){ %>
								<option value="<%=i %>" <%if(Integer.parseInt(type2)==i){ %>selected<%} %>><%=i %>季度</option>
							<%} %>
						  </select>
					  </div>
					</div>
				</div>
				<%}%>
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">状态 :</div>
					<div class="Design_FInputText_Fielddom">
					   <div class="Design_FSelect_Fielddom">
					      <select id="status" class="MADFS_Left_Select">
							<option value="">请选择</option>
							<option value="0">考核中</option>
							<option value="1">审批中</option>
							<option value="3">已完成</option>
							<option value="4">未开始</option>
							<option value="5">已过期</option>
							<option value="-1">无方案或无数据</option>
						</select>
					   </div>
					</div>
				</div>
				<div class="Formfield-Wrap">
					<div class="Formfield-Label">成绩 :</div>
					<div class="Design_FInputText_Fielddom">
						<input class="intext" maxLength=10 placeholder="请输入" size=6 id="minresult" name="minresult" onKeyPress="ItemNum_KeyPress('minresult')" onBlur="checknumber('minresult')"/>
			    		--<input class="intext" maxLength=10 placeholder="请输入" size=6 id="maxvalue" name="maxvalue" onKeyPress="ItemNum_KeyPress('maxvalue')" onBlur="checknumber('maxvalue')"/>
					<input type="checkbox" id="isreset" name="isreset" value="0"/><font style="font-size:14px;color: #666;">有更新</font>
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
		       getResultList();
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
		            var year = $('#year').val();
		            window.location = "perforMain.jsp?year="+year+"&type1="+datavalue;
		      });
		      
		       var len = $("ul.tab .tab1").length;
		       if(len==2){
		         $("ul.tab .tab1:first").css({'border-radius':'3px 0 0 3px','border-right':0});
		         $("ul.tab .tab1:last").css('border-radius','0 3px 3px 0');
		       }else if(len==1){
		         $("ul.tab .tab1").css('border-radius','3px 3px 3px 3px');
		       }
		       $("#isreset").live("click",function(){
					if($(this).attr("checked")){
						$(this).val(1);
					}else{
						$(this).val(0);
					}
				});
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
		   var iresult = $('#minresult').val();
		   var aresult = $('#maxvalue').val();
		   var ireset = $('#isreset').val();
		   var hrmids = $('#hrmids').val();
		   var subids = $('#subids').val();
		   var deptids = $('#deptids').val();
		   var hrmname = $('#hrmname').val();
		   var status = $('#status').val();
		   $.ajax({
				url:"/mobile/plugin/performance/getResultList.jsp",
				data:{"pageNum":pageNum,"year":years,"type1":oType,"type2":TTpe,"minresult":iresult,"maxresult":aresult,"isreset":ireset,'hrmids':hrmids,'hrmname':hrmname,'statusval':status,'subids':subids,'deptids':deptids},
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
					       htresult +="<div class=\"titleRowWrap\"><span>"+n.lastname+n.titlename+"  评分："+(n.result==''?"-":n.result)+(n.isrescore==1?"<font class=\"rescorefont\"></font>":"")+"</span></div>";  
						   htresult +="<div class=\"colWrap\"><span>"+n.subname+">"+n.departmentname+"</span></div>";  
						   htresult +="<div class=\"colWrap\"><span>";
						   if(n.info!=""){
							  htresult += n.info;
						   }
						   htresult +="</span></div></td><td>";
						   htresult +="<div class=\"zt0\" style=\"background-color:#"+n.fcolor+";\">"+n.status+"</div>";
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
		  $("#minresult,#maxvalue").width(($("#maxvalue").parent().width()-$("#isreset").width()-100)/2);
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