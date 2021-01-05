<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="weaver.company.CompanyUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:include page="/cpcompanyinfo/CompanyInfoContainer.jsp" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cpinfoTransMethod" class="weaver.cpcompanyinfo.CompanyInfoTransMethod" scope="page" />

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

<%
	String companyid = Util.null2String(request.getParameter("companyid"));
	
	//很关键的一个变量，用于判断后续页面是否开发编辑权限
	//0--只有这个公司的查看权限，没有维护权限
	//1--拥有这个公司查看和维护全县
	String showOrUpdate = Util.null2String(request.getParameter("showOrUpdate"));

	if("".equals(showOrUpdate)){
			//showOrUpdate="",很有可能是从flash里面点击[公司资料]按钮进入的，所以在此要更新一次判断权限
			 String userManager="";
			 CompanyUtil cu=new CompanyUtil();
			 if(!cu.canOperate(user,"2")){
				//得到当前用户管辖那几个公司
				    userManager=cu.canOperateCOM(user,"2");
			  }else{
					userManager="ALL";
			  }
			 showOrUpdate="0";
			 if("ALL".equals(userManager)){
				//说明有所有公司的维护权限
				showOrUpdate="1";
			 } else if((","+userManager+",").lastIndexOf(","+companyid+",")!=-1){
				//说明有该公司的维护权限
				showOrUpdate="1";
			 }
	
	}
	
	/* 公司基本表*/
	String companyname = "";
	String archivenum = "";
	
	
	
	String sqlinfo = "select * from CPCOMPANYINFO where companyid = " + companyid;
	rs.execute(sqlinfo);
	if(rs.next()){
		companyname = rs.getString("COMPANYNAME");
		archivenum = rs.getString("ARCHIVENUM");
	}
	
	
 %>

<html>
	<head>
	
	<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('#searchAffix').bind('keyup', function(event){
				   if (event.keyCode=="13"){
				    	searchaffix();
				    	this.blur();
				   }
				});
				
				setBottom();
			//jQuery("#id").width(jQuery(window).width());jQuery(window).resize(function(){jQuery("#id").width(jQuery(window).width());})
			//var allwidth=jQuery(window).width();
			//var MW=$("#MainCont").width(allwidth); 
		
		//	var LW=$("#BContLeft").width("50%"); 
			//var RW=$("#BContRight").width((allwidth/2)-10); 
			
			//alert($("#MainCont").width()+"--"+$("#BContLeft").width()+"--"+$("#BContRight").width());
			
			jQuery(".ONav").find("li").bind("click",function(){
				jQuery(".ONav").find(".hover").removeClass("hover");
				jQuery(this).find("a").addClass("hover");
				
			});
			/*通讯录*/
			jQuery('#cantacts').qtip(
			{
				content: {
					url: '/newportal/contactslist.jsp' 
		   		},
			   	position: {
			      	target: jQuery(document.body), // Position it via the document body...
			      	corner: 'center' // ...at the center of the viewport
			   	},
			   	show: {
			      	when: 'click', // Show it on click
			      	solo: true // And hide all other tooltips
			   	},
			   	hide: false,
			   	style: {
			      	width: { max: 990 },
			      	width:979,
			      	height:402,
			      	padding: '0px 0px',
			      	border: {
			         	width: 0,
			         	radius: 0,
			         	color: '#666666'
			      	},
			      	name: 'light'
			   	},
			   	api: {
			      	beforeShow: function()
			      	{
			         	// Fade in the modal "blanket" using the defined show speed
						jQuery('#qtip-blanket').fadeIn(this.options.show.effect.length);
			    	},
					beforeHide: function()
					{
			         	// Fade out the modal "blanket" using the defined hide speed
			         	jQuery('#qtip-blanket').fadeOut(this.options.hide.effect.length);
			      	}
			      	
			   	}
			});
		
			// Create the modal backdrop on document load so all modal tooltips can use it
			jQuery('<div id="qtip-blanket">')
				.css({
					position: 'absolute',
			      	top: jQuery(document).scrollTop(), // Use document scrollTop so it's on-screen even if the window is scrolled
			      	left: 0,
			      	height: jQuery(document).height()-4, // Span the full document height...
			      	width: '100%', // ...and full width
			      	opacity: 0.3, // Make it slightly transparent
			      	backgroundColor: 'black',
			      	zIndex: 5000  // Make sure the zIndex is below 6000 to keep it below tooltips!
			   })
			   .appendTo(document.body) // Append to the document body
			   .hide(); // Hide it initially
		   
		   
			
			
			
			var obj = jQuery("#pagegxList").find("li");
			var divsize = obj.size(); //数据条数
			
			var perpage = 5;	//每页条数
			var sumpage = Math.ceil(divsize/perpage);	//总页数	
			var i = 1;  //默认第一页
			obj.hide();
			obj.slice(0,perpage).show();
			//上一页
			$("#prevpage").click(function(){		
				--i;
				if(i<=0)
				{
					i = 1;
					return false;
				}
				obj.hide();
				obj.slice(i*perpage-perpage,i*perpage).show();	
			});
			//下一页
			$("#nextpage").click(function(){	
				if(i>=sumpage)
				{
					i = sumpage;
					return false;
				}
				obj.hide();
				obj.slice(i*perpage,i*perpage+perpage).show();
				++i;
			});
			
		});
		
		/*打开章程面板*/
		/**
		function open2zc(){
			jQuery("a[typepage='zc']").qtip(
			{
				content: {
					url: jQuery("a[typepage='zc']").attr("businessref")
				},
				position: {
					target: jQuery(document.body), // Position it via the document body...
					corner: 'center' // ...at the center of the viewport
				},
				show: {
					when: 'click', // Show it on click
					solo: true, // And hide all other tooltips
					ready:true
				},
				hide: false,
				style: {
					width: { max: 990 },
	        		width:492,
		    		height:402,
		    		padding: '0px 0px',
		    		border: {
						width: 0,
		      			radius: 0,
		        		color: '#666666'
					},
					name: 'light'
				},
				api: {
					beforeShow: function()
					{
	            		// Fade in the modal "blanket" using the defined show speed
	            		SWFUpload.movieCount=0;
	            		jQuery('#qtip-blanket').fadeIn(this.options.show.effect.length);
		    		},
		    		onShow:function(){
		    			//alert(1);
		    		},
					beforeHide: function()
					{
			   			// Fade out the modal "blanket" using the defined hide speed
			   			jQuery('#qtip-blanket').fadeOut(this.options.hide.effect.length);
					}
				}
			});
		}
		**/
		/*打开董事会面板*/
		/**
		function open2dsh(){
			jQuery("a[typepage='dsh']").qtip(
			{
				content: {
					url: jQuery("a[typepage='dsh']").attr("businessref")
				},
				position: {
					target: jQuery(document.body), // Position it via the document body...
					corner: 'center' // ...at the center of the viewport
				},
				show: {
					when: 'click', // Show it on click
					solo: true, // And hide all other tooltips
					ready:true
				},
				hide: false,
				style: {
					width: { max: 990 },
	        		width:692,
		    		height:402,
		    		padding: '0px 0px',
		    		border: {
						width: 0,
		      			radius: 0,
		        		color: '#666666'
					},
					name: 'light'
				},
				api: {
					beforeShow: function()
					{
	            		// Fade in the modal "blanket" using the defined show speed
	            		SWFUpload.movieCount=0;
	            		jQuery('#qtip-blanket').fadeIn(this.options.show.effect.length);
		    		},
		    		onShow:function(){
		    			//alert(1);
		    		},
					beforeHide: function()
					{
			   			// Fade out the modal "blanket" using the defined hide speed
			   			jQuery('#qtip-blanket').fadeOut(this.options.hide.effect.length);
					}
				}
			});
		}
		**/
		
		/*打开股东面板*/
		/**
		function open2gd(){
			jQuery("a[typepage='gd']").qtip(
			{
				content: {
					url: jQuery("a[typepage='gd']").attr("businessref")
				},
				position: {
					target: jQuery(document.body), // Position it via the document body...
					corner: 'center' // ...at the center of the viewport
				},
				show: {
					when: 'click', // Show it on click
					solo: true, // And hide all other tooltips
					ready:true
				},
				hide: false,
				style: {
					width: { max: 990 },
	        		width:762,
		    		height:400,
		    		padding: '0px 0px',
		    		border: {
						width: 0,
		      			radius: 0,
		        		color: '#666666'
					},
					name: 'light'
				},
				api: {
					beforeShow: function()
					{
	            		// Fade in the modal "blanket" using the defined show speed
	            		SWFUpload.movieCount=0;
	            		jQuery('#qtip-blanket').fadeIn(this.options.show.effect.length);
		    		},
		    		onShow:function(){
		    			//alert(1);
		    		},
					beforeHide: function()
					{
			   			// Fade out the modal "blanket" using the defined hide speed
			   			jQuery('#qtip-blanket').fadeOut(this.options.hide.effect.length);
					}
				}
			});
		}**/
	
	//后半部分操作
	
	//关键字搜索
	function searchaffix(){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 550;
		diag_vote.Height =400;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("22629",user.getLanguage())%>";
		diag_vote.URL = "/cpcompanyinfo/CompanyAffixFileDown.jsp?companyid=<%=companyid%>&searchaffix="+jQuery("#searchAffix").val();
		diag_vote.isIframe=false;
		diag_vote.show();
	}
	
	/*绑定编辑或者查时，判断时候选中列表，如选中则绑定qtip*/
	function beforeEditorView(whichBtn,whichMethod)
	{	
		/*获取iframe中companylist.jsp中选中的checkbox的记录数据库ID*/
		var requestids = jQuery("#frame2list")[0].contentWindow.getrequestids();	
		if(requestids==null||requestids=="")
		{
			alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage())%>！")
		}
		else
		{
			if(requestids.split(',').length>2){
				alert("<%=SystemEnv.getHtmlLabelName(31014,user.getLanguage())%>！");
			}
			else{
				var affixUrl;
				if(whichMethod=="add"){
					affixUrl=jQuery("#affix2SAdd").attr("refUrl")+"&moudel="+jQuery("#affix2SAdd").attr("urlMoudel")+"&btn="+whichBtn;
				}else if(whichMethod=="edit"){
					affixUrl=jQuery("#affix2SEdit").attr("refUrl")+"&moudel="+jQuery("#affix2SEdit").attr("urlMoudel")+"&btn="+whichBtn+"&searchid="+requestids.split(',')[0];
				}
				jQuery("#"+whichBtn).qtip(
				{
					content: {
						url: affixUrl
					},
					position: {
						target: jQuery(document.body), // Position it via the document body...
						corner: 'center' // ...at the center of the viewport
					},
					show: {
						when: 'click', // Show it on click
						solo: true, // And hide all other tooltips
						ready:true
					},
					hide: false,
					style: {
						width: { max: 990 },
		        		width:540,
			    		height:402,
			    		padding: '0px 0px',
			    		border: {
							width: 0,
			      			radius: 0,
			        		color: '#666666'
						},
						name: 'light'
					},
					api: {
						beforeShow: function()
						{
		            		// Fade in the modal "blanket" using the defined show speed
		            		//SWFUpload.movieCount=0;
		            		jQuery('#qtip-blanket').fadeIn(this.options.show.effect.length);
			    		},
			    		onShow:function(){
			    			//alert(1);
			    		},
						beforeHide: function()
						{
				   			// Fade out the modal "blanket" using the defined hide speed
				   			jQuery('#qtip-blanket').fadeOut(this.options.hide.effect.length);
						}
					}
				});
			}
		}
	}
	function onAdd(){
		var url="/cpcompanyinfo/CompanyAffixSearch.jsp?method=add&companyid=<%=companyid %>&moudel=search&btn=affix2SAdd";
		var title="<%=SystemEnv.getHtmlLabelName(128210,user.getLanguage())%>";
		openDialog(url,title,500,600,false,true);
		
	}
	//编辑
	function f1(whichBtn,whichMethod,o4thisid){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 500;
		diag_vote.Height =600;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("93",user.getLanguage())%>";
		diag_vote.URL = "/cpcompanyinfo/CompanyAffixSearch.jsp?method=edit&companyid=<%=companyid %>&moudel=search&btn="+whichBtn+"&searchid="+o4thisid;
		diag_vote.isIframe=false;
		diag_vote.show();
	}
	
	/*点击下面的超链接--zzl*/
	function beforeNew_conter(type,showvalue){
		jQuery("#a_click").qtip(
		{
			content: {
				url: "/cpcompanyinfo/ChooseCompanyBottom.jsp?type="+type+"&showvalue="+showvalue+"&companyid=<%=companyid%>"
			},
			position: {
				target: jQuery(document.body), // Position it via the document body...
				corner: 'center' // ...at the center of the viewport
			},
			show: {
				when: 'click', // Show it on click
				solo: true, // And hide all other tooltips
				ready:true
			},
			hide: false,
			style: {
				width: { max: 990 },
		        width:492,
			    height:402,
			    padding: '0px 0px',
			    border: {
					width: 0,
			      	radius: 0,
			        color: '#666666'
				},
				name: 'light'
			},
			api: {
				beforeShow: function()
				{
		            // Fade in the modal "blanket" using the defined show speed
		            jQuery('#qtip-blanket').fadeIn(this.options.show.effect.length);
			    },
				beforeHide: function()
				{
				   // Fade out the modal "blanket" using the defined hide speed
				   jQuery('#qtip-blanket').fadeOut(this.options.hide.effect.length);
				}
			}
		});
	}
	
	function changeMethod(whichMoudel){
		jQuery("a[urlMoudel]").attr("urlMoudel",whichMoudel);
		jQuery("#frame2list").attr("src","CompanyAffixMainList.jsp?companyid=<%=companyid %>&moudel="+whichMoudel);
	}
	
	function moreMethod(){
		jQuery("#frame2list").attr("src","CompanyAffixMainList1.jsp?companyid=<%=companyid %>&moudel="+jQuery("#moreBtn").attr("urlMoudel"));
	}
	
	/*列表删除操作*/
	function delAffixSearch(){
		var requestids = jQuery("#frame2list")[0].contentWindow.getrequestids();
		if(requestids==null||requestids=="")
		{
			alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>!")
		}
		else
		{
			if(confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>?")){
				var o4params = {
					method:"del",
					affsearchids:requestids
				};
				
				jQuery.post("/cpcompanyinfo/action/CPManageOperate.jsp",o4params,function(data){
					reflush2List();
				});
			}else
			{
				return;			
			}
		}
	}
	/* 刷新companyaffixMainlist.jsp页面已达到，新增，修改，删除后改变记录的目的*/
	function reflush2List(){
			//alert("zx");
			jQuery("#frame2list")[0].src=jQuery("#frame2list")[0].src;
		//jQuery("#frame2list")[0].contentWindow.reloadListContent();
	}
	
	function setBottom(){
			var docH=$(document).height(); 
			var botH=$("#bottom_top").height();
			var totH=$("#top_div").height();
			//减去10px的padding和margin值
			var tempH=docH-botH-totH-10-5;
			$("#OBoxW_H").height((tempH-64)+"px");
			$("#BContLeft").height((tempH-64)+"px");
			$("#BContRight").height((tempH-64)+"px");
			$("#frame2list").height((tempH-20)+"px");
			$("#set_H").height(($("#BContRight").height()-300)+"px");
			$("#frame2list").height(($("#BContRight").height()-250)+"px");
			
			<%
				if("0".equals(showOrUpdate)){
			%>
					
					if(""==$("#Constitution").html()){
							$("#Constitution").parent().attr("href","javascript:alert('<%=SystemEnv.getHtmlLabelName(30941,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(128212,user.getLanguage())%>!')");
					 }
					 if(""==$("#ShareHolder").html()){
							$("#ShareHolder").parent().attr("href","javascript:alert('<%=SystemEnv.getHtmlLabelName(28421,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(128212,user.getLanguage())%>!')");
					 }
					 if(""==$("#BoardDirectors").html()){
							$("#BoardDirectors").parent().attr("href","javascript:alert('<%=SystemEnv.getHtmlLabelName(30936,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(128212,user.getLanguage())%>!')");
					 }
			<%	
				}
			%>
			
			
			
	}
	//刷新数据
	 function refsh(){
				var o4params = {
					method:"refsh",
					companyid:"<%=companyid%>"
				};
				jQuery.post("/cpcompanyinfo/action/CPManageOperate.jsp",o4params,function(data){
							jQuery("#License").html(data[0]);
							jQuery("#Constitution").html(data[1]);
							jQuery("#ShareHolder").html(data[2]);
							jQuery("#BoardDirectors").html(data[3]);
							 jQuery("#pagegxList").html("").html(data[4]);
							 jQuery("#_fr").html("").html(data[5]);
							 jQuery("#_ds").html("").html(data[6]);
							 jQuery("#_gd").html("").html(data[7]);
							var obj = jQuery("#pagegxList").find("li");
							var divsize = obj.size(); //数据条数
							var perpage = 5;	//每页条数
							var sumpage = Math.ceil(divsize/perpage);	//总页数	
							var i = 1;  //默认第一页
							obj.hide();
							obj.slice(0,perpage).show();
							//上一页
							$("#prevpage").click(function(){		
								--i;
								if(i<=0)
								{
									i = 1;
									return false;
								}
								obj.hide();
								obj.slice(i*perpage-perpage,i*perpage).show();	
							});
							//下一页
							$("#nextpage").click(function(){	
								if(i>=sumpage)
								{
									i = sumpage;
									return false;
								}
								obj.hide();
								obj.slice(i*perpage,i*perpage+perpage).show();
								++i;
							});
			
				},"json");
	} 
</script>

<style type="text/css">
		.MLeft20{
				margin-left: 20px;
		}
</style>
<!--[if lte IE 6]>
<script type="text/javascript" src="js/DD_belatedPNG_0.0.7a_wev8.js"></script>

<script>

DD_belatedPNG.fix('.png,.png:hover');

</script>
<![endif]-->
<% 
	String name = companyname+"    "+archivenum;
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
<jsp:param name="mouldID" value="cpcompany"/>
<jsp:param name="navName" value="<%=name %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<body>
		
		<%
			List list = cpinfoTransMethod.setStale(companyid);
		 %>
		<!--主要内容 左侧 start-->
		<div class="BBoxW PTop5"    id="OBoxW_H">
			<div class="BContLeft"   id="BContLeft">
				<ul class="FL">
					<li>
						<a
							href="javascript:window.location.href='/cpcompanyinfo/CompanyBusinessLicenseSurvey.jsp?companyid=<%=companyid%>&companyname=<%= companyname%>&archivenum=<%= archivenum%>&showOrUpdate=<%=showOrUpdate %>';"><span
							class="cBlue FontYahei FS16"><%=SystemEnv.getHtmlLabelName(30958,user.getLanguage())%></span>
						<p class="cBlack4 PTop10"  id="License">
								<!-- 公司证照 -->
								<%=SystemEnv.getHtmlLabelName(30942,user.getLanguage())%><%=list.get(2) %><%=SystemEnv.getHtmlLabelName(30943,user.getLanguage())%>
							</p>
						</a>
					</li>
					<li>
						<a href="javascript:open2zc('<%=companyid %>','<%=showOrUpdate %>')" typepage="zc"
							businessref="/cpcompanyinfo/CompanyConstitutionMaint.jsp?companyid=<%=companyid%>&companyname=<%=companyname%>&showOrUpdate=<%=showOrUpdate %>" rwidth="590" refheight="550"  ><span
							class="cBlue FontYahei FS16"><%=SystemEnv.getHtmlLabelName(30941,user.getLanguage())%></span>
							<!-- 章程 -->
						<p class="cBlack4 PTop10"  id="Constitution">
							<%if(!list.get(5).toString().split("/")[0].equals("0")){ %>
								<%=list.get(5).toString().split("/")[0] %><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></br><%=list.get(5).toString().split("/")[1] %><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>
								<%} %>
							</p>
						</a>
					</li>
					<li>
						<a href="javascript:open2gd('<%=companyid %>','<%=showOrUpdate %>')" typepage="gd"
							businessref="/cpcompanyinfo/CompanyShareHolderMaint.jsp?companyid=<%=companyid%>&showOrUpdate=<%=showOrUpdate %>" rwidth="590" refheight="330"  ><span
							class="cBlue FontYahei FS16"><%=SystemEnv.getHtmlLabelName(28421,user.getLanguage())%></span>
						<p class="cBlack4 PTop10"  id="ShareHolder">
								<%if(!list.get(6).toString().split("/")[0].equals("0")){ %>
								<%=list.get(6).toString().split("/")[0] %><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></br><%=list.get(6).toString().split("/")[1] %><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>
								<%} %>
							</p>
						</a>
					</li>
					
					<li>
						<a href="javascript:open2dsh('<%=companyid%>','<%=showOrUpdate %>')" typepage="dsh"
							businessref="/cpcompanyinfo/CompanyBoardDirectorsMaint.jsp?companyid=<%=companyid%>&companyname=<%=companyname%>&showOrUpdate=<%=showOrUpdate %>"  rwidth="590" refheight="400"><span
							class="cBlue FontYahei FS16"><%=SystemEnv.getHtmlLabelName(30936,user.getLanguage())%></span>
						<p class="cBlack4 PTop10" id="BoardDirectors">
								<%if(!list.get(7).toString().split("/")[0].equals("0")){ %>
								<%=list.get(7).toString().split("/")[0] %><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></br><%=list.get(7).toString().split("/")[1] %><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>
								<%} %>
							</p>
						</a>
					</li>
				</ul>
			</div>
		<!--主要内容 左侧 end-->
			
	   <!--主要内容 右侧 start-->
			<div class="BContRight"  id="BContRight">
				<div class="BContRightTitW FL">
					<div class="border19">
						<div class="BoxHeight27">
							<span class="FR MR10">
								<img id="prevpage" style="cursor:hand" src="images/O_23_wev8.jpg" />&nbsp;&nbsp;
								<img id="nextpage" style="cursor:hand" src="images/O_24_wev8.jpg"/>
							</span>
							<img src="images/O_22_wev8.png" class="png MLeft10 FL MT8" />
							<span class="cBlue PLeft5 FL"><%=SystemEnv.getHtmlLabelName(31089,user.getLanguage())%></span><%--更新通知--%>
							<div class="clear"></div>
						</div>
					</div>
				</div>
				<div class="clear"></div>
				<div class="border19">
					<ul class="BContRightList" style="height:140px;overflow: auto;" id="pagegxList">
						<%String upsql = "select * from CPCOMPANYUPGRADE where companyid="+companyid+" order by CREATEDATETIME desc"; 
							rs.execute(upsql);
							while (rs.next()){
						%>
						<li><span class="FR"><%=rs.getString("CREATEDATETIME") %></span><%=rs.getString("discription") %></li>
						<%} %>
					</ul>
				</div>
				
				
				
				<div class="BContRightTitW FL MT3">
					<div class="border19  BoxHeight27 ">
						<div class=" Relative BoxW430">
							<span class="FL" style="margin-left:8px">&nbsp;</span>
							<img src="images/O_22_wev8.png" class="png  FL MT8" />
							<span class="cBlue PLeft5 FL"><%=SystemEnv.getHtmlLabelName(31757,user.getLanguage())%></span><%--附件搜索--%>
							
						</div>
						<div class="clear"></div>
					</div>
				</div>
				<div class="BContRightTitW FL MT3">
					<div class="border19   BoxHeight27 ">
						<div class=" Relative BoxW430">
								<span class="FL" style="margin-left:8px">&nbsp;</span>
								<%=SystemEnv.getHtmlLabelName(31034,user.getLanguage())%><%--关键字搜索--%>
								<input type="text" name="searchAffix" id="searchAffix"
								class="BInput2 BoxW410 FR MR10 MT3" style="height: 21px; line-height:21px;" />
							<img src="/images/ecology8/request/search-input_wev8.png" id="searchImg" class="Absolute" onclick="javascript:searchaffix();"
								style="right: 15px; top: 8px; cursor:hand;" businessref="/cpcompanyinfo/CompanyAffixFileDown.jsp?companyid=<%=companyid%>"/>
						</div>
						<div class="clear"></div>
					</div>
				</div>
				
				<div class="BContRightTitW FL MT3">
								<li style="display:none">
								
									<a id="affix2SAdd" href="javascript:openAffixSearch('affix2SAdd','add');" class="hover" refUrl="/cpcompanyinfo/CompanyAffixSearch.jsp?method=add&companyid=<%=companyid %>" urlMoudel="search"><div>
											<div>
												<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%><!--新增-->
											</div>
										</div>
									</a>
								</li>
								<li style="display:none">
									<a id="affix2SEdit" href="javascript:beforeEditorView('affix2SEdit','edit');" class="hover" refUrl="/cpcompanyinfo/CompanyAffixSearch.jsp?method=edit&companyid=<%=companyid %>" urlMoudel="search"><div>
											<div>
												<%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><!--修改-->
											</div>
										</div>
									</a>
								</li>
								<li style="display:none">
									<a href="javascript:delAffixSearch();" class="hover"><div>
											<div>
												<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%><!--删除-->
											</div>
										</div>
									</a>
								</li>
								
				</div>
<wea:layout >
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("30959",user.getLanguage())%>' >
		<wea:item type="groupHead">
			<%
			if("1".equals(showOrUpdate)){
			 %>
			<input class="addbtn" accesskey="A" onclick="onAdd()" title="<%=SystemEnv.getHtmlLabelNames("611",user.getLanguage())%>" type="button">
			<input class="delbtn" accesskey="E" onclick="delAffixSearch()" title="<%=SystemEnv.getHtmlLabelNames("91",user.getLanguage())%>" type="button">
			<%} %>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
				<div class=" FL BContRightTitW"  >
					<div class="border19 OContHiddenScroll"  id="set_H"    >
						<iframe id="frame2list" src="CompanyAffixMainList.jsp?companyid=<%=companyid %>&moudel=search" width="100%" height="99%" frameborder=no  scrolling="no">
				
						</iframe>
						<div class="clear"></div>
					</div>
				</div>
			</wea:item>
	</wea:group>
</wea:layout>
			</div>
		</div>
		<!--主要内容 右侧 end-->
		
		
		<!-- 底部 start -->
		<div class="Ofoot FL BoxWAuto"  id="bottom_top">
				<div >
					<table width="100%">
						<tr align="center">
							<td width="170"  id="a_click"  onclick="onButtomClick(1,3)" style="cursor: pointer;">
								<img src="images/O_22_wev8.png" />
								<%=SystemEnv.getHtmlLabelName(31079,user.getLanguage())%>
								<span><%=list.get(2) %></span>
							</td>
							<td width="170" onclick="onButtomClick(1,5)" style="cursor: pointer;">
								<img src="images/O_22_wev8.png" />
								<!-- 即将年检证照 -->
								<%=SystemEnv.getHtmlLabelName(31080,user.getLanguage())%>
								<span ><%=list.get(4) %></span>
							</td>
							<td width="170" onclick="onButtomClick(1,1)" style="cursor: pointer;">
								<img src="images/O_22_wev8.png" />
								<!-- 本月变更法人 -->
								<%=SystemEnv.getHtmlLabelName(31081,user.getLanguage())%>
								<span id="_fr"><%=list.get(0) %></span>
							</td>
							<td width="170" onclick="onButtomClick(1,2)" style="cursor: pointer;">
								<img src="images/O_22_wev8.png" />
								<%=SystemEnv.getHtmlLabelName(31082,user.getLanguage())%>
								<span id="_ds"><%=list.get(1) %></span>
							</td>
							<td width="170" onclick="onButtomClick(1,4)" style="cursor: pointer;">
								<img src="images/O_22_wev8.png" />
								<%=SystemEnv.getHtmlLabelName(31083,user.getLanguage())%>
								<span  id="_gd"><%=list.get(3) %></span>
							</td>
							<td width="170">
								&nbsp;
							</td>
						</tr>
					</table>
				</div>
			</div>
			<!-- 底部 end -->
<script type="text/javascript">
function open2zc(companyid,showorupdate){
	var url=jQuery("a[typepage='zc']").attr("businessref")+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("30941",user.getLanguage())%>";
	openDialog(url,title,800,550,false,true);
}
function open2dsh(companyid,showorupdate){
	var url=jQuery("a[typepage='dsh']").attr("businessref")+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("30936",user.getLanguage())%>";
	openDialog(url,title,850,550,false,true);
}
function open2gd(companyid,showorupdate){
	var url=jQuery("a[typepage='gd']").attr("businessref")+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("28421",user.getLanguage())%>";
	openDialog(url,title,800,550,false,true);
}

	/*页面底部按钮*/
	function onButtomClick(type,showvalue){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 600;
		diag_vote.Height = 360;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("367",user.getLanguage())%>";
		diag_vote.URL = "/cpcompanyinfo/ChooseCompanyBottom.jsp?type="+type+"&showvalue="+showvalue+"&companyid=<%=companyid%>";
		diag_vote.isIframe=false;
		diag_vote.show();
	}
</script>			
	</body>
</html>
