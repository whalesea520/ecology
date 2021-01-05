<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	if(!cu.canOperate(user,"3"))//不具有入口权限
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}	
	
	boolean maintFlag = false;
	if(cu.canOperate(user,"2"))//后台维护权限
	{
		maintFlag = true;
	}
	
	String openNew = Util.null2String(request.getParameter("openNew"));
	String companyname = Util.null2String(request.getParameter("companyname"));
	
	String zrrid="";//得到自然人的id
	if(rs.execute("select id,name from CompanyBusinessService where affixindex=-1")&&rs.next()){
		zrrid=rs.getString("id");
	}
 %>
<jsp:include page="/cpcompanyinfo/CompanyInfoContainer.jsp" />
<jsp:useBean id="cpinfoTransMethod" class="weaver.cpcompanyinfo.CompanyInfoTransMethod" scope="page" />
 

<HTML><HEAD>
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

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"frame2list",
        mouldID:"<%= MouldIDConst.getID("cpcompany")%>",
        staticOnLoad:true
    });
}); 
</script>

<%
	//String url = Util.null2String(request.getParameter("url"));
	String title = "";
	
	String url="CompanyInfoList.jsp?maintFlag="+maintFlag+"&openNew="+openNew;
%>
<!-- checkbox上方水平线样式 -->
 <style type="text/css">

	.hr1{ height:1px;border:none;border-top:1px solid #DCDCDC;}

 </style>

</head>
<input type="hidden" id="businesstype01" value=""/>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
		    <ul class="tab_menu">
		       		<li class="current">
						<a onclick="javascript:queryCompanyType('','1');" class="hover" target="frame2list"><%=SystemEnv.getHtmlLabelName(31067,user.getLanguage())%></a>
					</li>
					<%
							String sql="select * from CompanyBusinessService  where affixindex !=-1 order by affixindex";
							rs.execute(sql);
							while(rs.next()){
							String c_name=rs.getString("name");
							String c_id=rs.getString("id");
					%>
								<li>
									<a onclick="javascript:queryCompanyType('<%=c_id%>','1');" target="frame2list"><%=c_name %></a>
								</li>
					<%		
							}
					 %>
					 
					 <%
					 		//确保自然人总是在最后一个tab页
							 sql="select * from CompanyBusinessService  where affixindex =-1 ";
							rs.execute(sql);
							while(rs.next()){
							String c_name=rs.getString("name");
							String c_id=rs.getString("id");
					%>
								<li>
									<a onclick="javascript:queryCompanyType('<%=c_id%>','1');" target="frame2list">
												<%=c_name %>
									 </a>
									</li>
					<%		
							}
					 %>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>	
	    
	  <!-- check框  start -->
	  <hr class="hr1" id="hr" />
	    		<div id="checkbox5">
				<div>
					<ul class="ONavSubnav PTop5 cBlue FL PB4">
						<span style="width: 100px;" class="FL FontYahei PLeft5"><input
								id="chzhzh" type="checkbox" onclick="javascript:queryCompanyType(jQuery('#businesstype01').val(),'3');"/> <span
							><%=SystemEnv.getHtmlLabelName(31758,user.getLanguage())%></span> </span>
						<span style="width: 100px;" class="FL FontYahei PLeft5"><input
								id="chgd" type="checkbox" onclick="javascript:queryCompanyType(jQuery('#businesstype01').val(),'3');" /> 
								<span><%=SystemEnv.getHtmlLabelName(31759,user.getLanguage())%></span>
						</span>
						<span style="width: 100px;" class="FL FontYahei PLeft5"><input
								id="chdsh" type="checkbox" onclick="javascript:queryCompanyType(jQuery('#businesstype01').val(),'3');"  /> 
								<span><%=SystemEnv.getHtmlLabelName(31070,user.getLanguage())%></span>
						</span>
						<span style="width: 100px;" class="FL FontYahei PLeft5"><input
								id="chzhch" type="checkbox" onclick="javascript:queryCompanyType(jQuery('#businesstype01').val(),'3');" /> 
								<span><%=SystemEnv.getHtmlLabelName(31071,user.getLanguage())%></span>
						</span>
						<span style="width: 100px;" class="FL FontYahei PLeft5"><input
								id="chxgs" type="checkbox" onclick="javascript:queryCompanyType(jQuery('#businesstype01').val(),'3');" />
								 <span><%=SystemEnv.getHtmlLabelName(31072,user.getLanguage())%></span>
						</span>
					</ul>
					
					</div>
					</div>
		  <!-- check框  end -->		
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="frame2list" name="frame2list" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	 </div> 

	 
	 <!-- 底部菜单 start -->
		  <%
				List list = cpinfoTransMethod.setStale();
			 %>
			 
				<div class="Ofoot  BoxWAuto hidetr"  id="bottom_top">
							<div >
								<table width="100%">
									<tr align="center">
										<td width="170"  id="a_click"  onclick="onButtomClick(0,3)"  style="cursor: pointer;">
											<img src="images/O_22_wev8.png"   />
											<%=SystemEnv.getHtmlLabelName(31079,user.getLanguage())%>
											<span ><%=list.get(2) %></span>
										</td>
										<td width="170" onclick="onButtomClick(0,5)" style="cursor: pointer;">
											<img src="images/O_22_wev8.png"  />
											<%=SystemEnv.getHtmlLabelName(31080,user.getLanguage())%>
											<span ><%=list.get(4) %></span>
										</td>
										<td width="170" onclick="onButtomClick(0,1)" style="cursor: pointer;">
											<img src="images/O_22_wev8.png"  />
											<%=SystemEnv.getHtmlLabelName(31081,user.getLanguage())%>
											<span ><%=list.get(0) %></span>
										</td>
										<td width="170" onclick="onButtomClick(0,2)" style="cursor: pointer;">
											<img src="images/O_22_wev8.png"  />
											<%=SystemEnv.getHtmlLabelName(31082,user.getLanguage())%>
											<span ><%=list.get(1) %></span>
										</td>
										<td width="170" onclick="onButtomClick(0,4)" style="cursor: pointer;">
											<img src="images/O_22_wev8.png"  />
											<%=SystemEnv.getHtmlLabelName(31083,user.getLanguage())%>
											<span ><%=list.get(3) %></span>
										</td>
									</tr>
								</table>
							</div>
					</div>
				</tr>
			<!-- 底部菜单 end -->

<script type="text/javascript">
	var docmh="";
	jQuery(document).ready(function(){
	
		$('#searchTX').bind('keyup', function(event){
				   if (event.keyCode=="13"){
				    	queryCompanyType(jQuery('#businesstype01').val(),"2");
				    	this.blur();
				   }
		});
		setBottom();
		jQuery(".ONav").find("li").bind("click",function(){
			jQuery(".ONav").find(".hover").removeClass("hover");
			jQuery(this).find("a").addClass("hover");
			
		});
		
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
			
			//来自于flash中点击注册公司按钮
			if("<%=openNew%>"=="T"){
				beforeNew();
			}
			//if("<=companyname%>" !=""){
				//jQuery("#searchSL").val("t1.COMPANYNAME");
				//jQuery("#searchTX").val("<=companyname%>");
				//queryCompanyType();
			//}
	});
	
	
	/*点击新增时绑定 qitp*/
	function beforeNew(){
		jQuery("#newBtn").qtip(
		{
			content: {
				url: jQuery("#newBtn").attr("rel")
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
	
	
	/*页面底部按钮*/
	function onButtomClick(type,showvalue){
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 600;
		diag_vote.Height = 360;
		diag_vote.Modal = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("367",user.getLanguage())%>";
		diag_vote.URL = "/cpcompanyinfo/ChooseCompanyBottom.jsp?type="+type+"&showvalue="+showvalue;
		diag_vote.isIframe=false;
		diag_vote.show();
	}
	
	
	/*点击下面的超链接--zzl*/
	/*绑定编辑或者查时，判断时候选中列表，如选中则绑定qtip*/
	function beforeEditorView(btnid,companyid)
	{	

				jQuery("#"+btnid).qtip(
				{
					content: {
						url: jQuery("#"+btnid).attr("rel")+"&companyid="+companyid
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
	
	/*列表删除操作*/
	function delMutiList2Info(companyid){
		
			if(confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>？")){
				var o4params = {
					method:"del",
					companyids:companyid
				};
			
				jQuery.post("/cpcompanyinfo/action/CPInfoOperate.jsp",o4params,function(data){
					reflush2List();
				});
			}
	}
	

	
	/*根据Table页的选项，改变list的条件*/
	function queryCompanyType(businesstype,type)
	{
	
		//alert(businesstype);
		//alert("xz");
		if(businesstype=="<%=zrrid%>"){
			 jQuery(".hidetr").hide();
			var docH=docmh;
			var totH=$("#top_div").height();
			//减去10px的padding和margin值
			var tempH=docH-totH-20;
			$("#OBoxW_H").height(tempH+"px");
			$("#frame2list").height((tempH-20)+"px");  
			//删除select的所有项searchSL
			if(type=="1"){
				$("#searchSL").empty();
				$("#searchSL").append("<option value='t1.COMPANYNAME'><%=SystemEnv.getHtmlLabelName(31445,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t1.COMPANYENAME'><%=SystemEnv.getHtmlLabelName(27740,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t1.COMPANYREGION'><%=SystemEnv.getHtmlLabelName(31077,user.getLanguage())%></option>");
			}  
		}else{
			if(type=="1"){
				$("#searchSL").empty();
				$("#searchSL").append("<option value='t1.COMPANYNAME'><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t1.COMPANYENAME'><%=SystemEnv.getHtmlLabelName(27740,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t1.COMPANYREGION'><%=SystemEnv.getHtmlLabelName(31077,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t2.CORPORATION'><%=SystemEnv.getHtmlLabelName(23797,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t3.GENERALMANAGER'><%=SystemEnv.getHtmlLabelName(20696,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t3.THEBOARD'><%=SystemEnv.getHtmlLabelName(30936,user.getLanguage())%></option>");   
				$("#searchSL").append("<option value='t3.BOARDVISITORS'><%=SystemEnv.getHtmlLabelName(31041,user.getLanguage())%></option>");   
			}
			 jQuery(".hidetr").show();
			 var docH=docmh;
			var botH=$("#bottom_top").height();
			var totH=$("#top_div").height();
			//减去10px的padding和margin值
			var tempH=docH-botH-totH-10;
			$("#OBoxW_H").height(tempH+"px");
			$("#frame2list").height((tempH-20)+"px");
			
		}
		
		 jQuery("#businesstype01").val(businesstype);
		 var bus = jQuery("#businesstype01").val()
			
			 if(type=="1"){
				  jQuery("#searchTX").val("");
				  jQuery("#chzhzh").attr("checked",false);
				  jQuery("#chzhch").attr("checked",false);
				  jQuery("#chgd").attr("checked",false);
				  jQuery("#chdsh").attr("checked",false);
				  jQuery("#chxgs").attr("checked",false);
				     
			}
			
		//自然人状态下隐藏checkbox以及水平线
		if(bus=="1"){
			jQuery("#checkbox5").hide();
			jQuery("#hr").hide();
		}else{
			jQuery("#checkbox5").show();
			jQuery("#hr").show();
		}	
			
			var o4chzhzh;
			var o4chzhch;
			var o4chgd;
			var o4chdsh;
			var o4chxgs;
			var o4searchTx="";
			var o4searchSL="";
			if(jQuery("#chzhzh").attr("checked")==true)o4chzhzh="on";
			else o4chzhzh = "none";
			if(jQuery("#chzhch").attr("checked")==true)o4chzhch="on";
			else o4chzhch = "none";
			if(jQuery("#chgd").attr("checked")==true)o4chgd="on";
			else o4chgd = "none";
			if(jQuery("#chdsh").attr("checked")==true)o4chdsh="on";
			else o4chdsh = "none";
			if(jQuery("#chxgs").attr("checked")==true)o4chxgs="on";
			else o4chxgs = "none";
			
			if(jQuery("#searchTX").val()!=""){
				o4searchTx = jQuery("#searchTX").val();
				o4searchSL = jQuery("#searchSL").val();
			}
			jQuery("#frame2list").attr("src","CompanyInfoList.jsp?businesstype="+jQuery("#businesstype01").val()
			+"&o4chzhzh="+o4chzhzh+"&o4chzhch="+o4chzhch+"&o4chgd="+o4chgd+"&o4chdsh="+o4chdsh+"&o4chxgs="+o4chxgs+"&maintFlag="+<%=maintFlag%>);
	}
	
	/* 刷新companylist.jsp页面已达到，新增，修改，删除后改变记录的目的*/
	function reflush2List(){
		jQuery("#frame2list")[0].contentWindow.reloadListContent();
	}
	
	function openLogView(companyid){
		//jQuery("#frame2list").attr("src","/cpcompanyinfo/CPLog.jsp");
		//window.showModalDialog("/cpcompanyinfo/CPLog.jsp","","dialogWidth=700px;dialogHeight=500px;status=no;help=no;scrollbars=no");
		window.location.href="/cpcompanyinfo/CPLog.jsp?companyid="+companyid;
	}
	
	function callABGroup(){
		jQuery("#callBtn").qtip(
		{
			content: {
				url: "/cpcompanyinfo/CompanyCallABMaint.jsp"
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
		        width:490,
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
	
	function setBottom(){
			var docH=$(document).height(); 
			docmh=docH;
			var botH=$("#bottom_top").height();
			var totH=$("#top_div").height();
			//减去10px的padding和margin值
			var tempH=docH-botH-totH-10;
			$("#OBoxW_H").height(tempH+"px");
			$("#frame2list").height((tempH-20)+"px");
	}
</script>	
	 
<script type="text/javascript">	
$(function(){
	setTabObjName("<%=title %>");
});
</script>   
</BODY>
</HTML>
