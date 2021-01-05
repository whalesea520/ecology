	function CheckBrowser(){
		var app=navigator.appName;
		var verStr=navigator.appVersion;
		if (app.indexOf('Netscape') != -1 && navigator["userAgent"].indexOf("Firefox")!=-1) {
			return "firefox";
		}else if (app.indexOf('Microsoft') != -1) {
			return "IE";
		}
	}

	var menus={
		weaverShop:[//WUC,顶部一级菜单
			{
				name:"泛微云商店",//顶部二级菜单
				display:false,
				url:"blank.html",
				subMenus:[{
					name:"所有应用",//左侧一级菜单
					/*subMenus:[
						{name:"所有应用",url:"http://www.baidu.com"},//左侧二级菜单
						{name:"开发工具",url:"http://www.qq.com"},//左侧二级菜单
						{name:"常用问题",url:"http://www.baidu.com"},//左侧二级菜单
						{name:"在线文档",url:"http://www.baidu.com"},//左侧二级菜单
						{name:"社区交流",url:"http://www.baidu.com"}//左侧二级菜单
					]*/
					url: "blank.html"
				},{
					name:"开发工具",
					url: "blank.html"
				},{
					name:"常用问题",
					url: "blank.html"
				},{
					name:"在线文档",
					url: "blank.html"
				},{
					name:"社区交流",
					url: "blank.html"
				}]
			}
		],
		moduleLib:[//流程
			{
				name:"泛微模板库",
				url:"blank.html",
				display:false,
				subMenus:[{
					name:"所有模板",//左侧一级菜单
					url: "blank.html"
				},{
					name:"门户模板",
					url: "blank.html"
				},{
					name:"流程模板",
					url: "blank.html"
				},{
					name:"文档模板",
					url: "blank.html"
				}]
			}
		],
		deployedApp:[//门户
			{
				name:"已部署应用",
				display:false,
				url:"leftMenu/left.jsp?module=2",
				target: "leftMenu"
			}
		],
		configCenter:[//内容
			{
				name:"权限监控中心",
				display:false,
				url:"blank.html",
				subMenus:[{
					name:"权限管理中心",//左侧一级菜单
					subMenus:[
						{
							name:"功能权限",
							url:"blank.html"
						},{
							name:"数据权限",
							url:"blank.html"
						}
					]
				},{
					name:"分权管理",
					subMenus:[
						{
							name:"功能权限1",
							url:"blank.html"
						},{
							name:"数据权限1",
							url:"blank.html"
						}
					]
				}]
			}
		],
		
		WUC:[//WUC,顶部一级菜单
			{
				name:"引擎监控",//顶部二级菜单
				//url:"abc.jsp",
				subMenus:[{
					name:"注册接口",//左侧一级菜单
					url:"qqqqwweertytyy.html",
					attr:{id:"aaaa"},
					subMenus:[
						{name:"接口部署",url:"/admincenter/interfaces/interfaceList.jsp",attr:{xxxx:"yyyy"}},//左侧二级菜单
						{name:"接口开发",url:"/admincenter/interfaces/interfaceDevelop.jsp"}//左侧二级菜单
					]
				},{
					name:"谷歌",
					url:"http://www.163.com"
				}]
			},{
				name:"开发集成",
				url:""
			},{
				name:"监控分析",
				url:""
			}
		],
		flowEngine:[//流程
			{
				name:"引擎概述",
				url:"flowImg.jsp"
			},{
				name:"开发集成",
				url:"",
				subMenus:[{
					name:"注册接口",//左侧一级菜单
					subMenus:[
						{name:"接口部署",url:"/admincenter/interfaces/interfaceList.jsp"},//左侧二级菜单
						{name:"接口开发",url:"/admincenter/interfaces/interfaceDevelop.jsp"}//左侧二级菜单
					]
				},{
					name:"规则开发",
					subMenus:[
						{name:"报销流转规则",url:"http://www.baidu.com"},//左侧二级菜单
						{name:"采购合约规则",url:"http://www.qq.com"}//左侧二级菜单
					]
				},{
					name:"webService",
					url:"http://www.163.com"
				},{
					name:"开发指南",
					subMenus:[
						{name:"数据源设置",url:"/integration/integrationTab.jsp?urlType=3"},//左侧二级菜单
						{name:"WebService注册",url:"/integration/integrationTab.jsp?urlType=1"},//左侧二级菜单
						{name:"集成登录",url:"/integration/integrationTab.jsp?urlType=6"},//左侧二级菜单
						{name:"LDAP集成",url:"/integration/integrationTab.jsp?urlType=2"},//左侧二级菜单,
						{name:"HR同步",url:"/integration/integrationTab.jsp?urlType=4"},//左侧二级菜单
						{name:"计划任务",url:"/integration/integrationTab.jsp?urlType=7"},//左侧二级菜单
						{name:"财务凭证",url:"/integration/integrationTab.jsp?urlType=8"},//左侧二级菜单
						{name:"流程触发集成",url:"/integration/icontent.jsp?showtype=12"},//左侧二级菜单
						{name:"流程流转集成",url:"/integration/icontent.jsp?showtype=10"},//左侧二级菜单
						{name:"数据展现集成",url:"/integration/integrationTab.jsp?urlType=10"}
					]
				}]
				
			},{
				name:"监控分析",
				subMenus:[
					{name:"异常日志分析",url:""},
					{name:"访问统计分析",url:""}
				]
			}
		],
		portalEngine:[//门户
			{
				name:"引擎概述",
				subMenus:[
					{name:"元素管理",url:"",
						subMenus:[
						{name:"元素库",url:"/admincenter/portalEngine/ElementTabs.jsp?_fromURL=portlet"},
						{name:"元素开发",url:"/admincenter/portalEngine/ElementTabs.jsp?_fromURL=dev"}
					]},
					{name:"布局和样式",url:"",
					subMenus:[
						{name:"技术门户样式模板",url:""},
						{name:"销售门户样式模板",url:""},
						{name:"客户门户样式模板",url:""}
					]},{name:"开发指南",url:"blank.html"}
				]
			},{
				name:"开发集成",
				url:""
			},{
				name:"监控分析",
				subMenus:[
					{name:"异常日志分析",url:""},
					{name:"访问统计分析",url:""}
				]
			}
		],
		contentEngine:[//内容
			{
				name:"引擎概述",
				url:""
			},{
				name:"开发集成",
				url:"",
				subMenus:[
					{name:"协同区开发",url:"",
					subMenus:[
						{name:"文档协同区",url:""},
					]},
					{name:"文档模板开发",url:""}
				]
			},{
				name:"监控分析",
				subMenus:[
					{name:"日志分析",url:""},
					{name:"索引监控",url:""}
				]
			}
		],
		formEngine:[//表单
			{
				name:"应用",
				url:"javascript:var index = window.location.href.indexOf('/formmode/setup/main.jsp');" +
				"if(index==-1){" +
					"if(window.location.href.indexOf('/admincenter/admincenter.jsp')!=-1){" +
						"changeMainFrameAppUrl();" +
					"}else{" +
						"window.location.href='/formmode/setup/main.jsp';" +
					"}" +
				"}else{changeAppUrl();}" 
			},
			{
				name:"模块",
				url:"javascript:changeFormModuleUrl('/formmode/setup/modelSettings.jsp');",
				target: ""
			},
			{
				name:"表单",
				url:"javascript:changeFormModuleUrl('/formmode/setup/formSettings.jsp');",
				target: ""
			},
			{
				name:"查询",
				url:"javascript:changeFormModuleUrl('/formmode/setup/customSearchSettings.jsp');",
				target: ""
			},
			{
				name:"报表",
				url:"javascript:changeFormModuleUrl('/formmode/setup/reportinfoSettings.jsp');",
				target: ""
			},
			{
				name:"浏览框",
				url:"javascript:changeFormModuleUrl('/formmode/setup/browserSettings.jsp');",
				target: ""
			},
			{
				name:"树",
				url:"javascript:changeFormModuleUrl('/formmode/setup/customTreeSettings.jsp');",
				target: ""
			},
			{
				name:"自定义页面",
				url:"javascript:changeFormModuleUrl('/formmode/setup/customPageSettings.jsp');",
				target: ""
			},
			{
				name:"Web Service",
				url:"javascript:changeFormModuleUrl('/formmode/setup/interfaceSettings.jsp');",
				target: ""
			}
		],
		mobileEngine:[//移动建模
			{
				name:"UI建模",
				url:"/mobilemode/MobileSettings.jsp"
			},{
				name:"模板管理",
				url:"/mobilemode/templateDesign.jsp?templateType=homepage",
				subMenus:[
								{name:"自定义页面模板",url:"/mobilemode/templateDesign.jsp?templateType=homepage"},//左侧二级菜单
										{name:"UI模板",url:"/mobilemode/templateDesign.jsp?templateType=formuilist"}]//左侧二级菜单
			}
		],
		
		/*reportEngine:[//报表
			{
				name:"引擎监控",
				url:""
			},{
				name:"开发集成",
				url:""
			},{
				name:"监控分析",
				url:""
			}
		],*/
		combinePlat:[//集成
		{
			name:"功能集成",
			url:"/integration/funcintegration.jsp",
			subMenus:[
			{
				name:"功能集成",//左侧一级菜单
				url:"/integration/funcintegration.jsp",
				subMenus:[
					{name:"数据源设置",url:"/integration/integrationTab.jsp?urlType=3"},//左侧二级菜单
					{name:"WebService注册",url:"/integration/integrationTab.jsp?urlType=1"},//左侧二级菜单
					{name:"集成登录",url:"/integration/integrationTab.jsp?urlType=6"},//左侧二级菜单
					{name:"LDAP集成",url:"/integration/integrationTab.jsp?urlType=2"},//左侧二级菜单,
					{name:"HR同步",url:"/integration/integrationTab.jsp?urlType=4"},//左侧二级菜单
					{name:"计划任务",url:"/integration/integrationTab.jsp?urlType=7"},//左侧二级菜单
					{name:"财务凭证",url:"/integration/integrationTab.jsp?urlType=8"},//左侧二级菜单
					{name:"流程触发集成",url:"/integration/icontent.jsp?showtype=12"},//左侧二级菜单
					{name:"流程流转集成",url:"/integration/icontent.jsp?showtype=10"},//左侧二级菜单
					{name:"数据展现集成",url:"/integration/integrationTab.jsp?urlType=10"}
				]
			},{
				name:"产品集成",//左侧一级菜单
				url:"/integration/productintegration.jsp",
				subMenus:[
					{name:"SAP集成",url:"/integration/icontent.jsp?type=1&showtype=1"},//左侧二级菜单
					{name:"NC集成",url:"/integration/icontent.jsp?showtype=2&type=1"},//左侧二级菜单
					{name:"EAS集成",url:"/integration/icontent.jsp?showtype=3&type=1"},//左侧二级菜单
					{name:"U8集成",url:"/integration/icontent.jsp?showtype=4&type=1"},//左侧二级菜单
					{name:"K3集成",url:"/integration/icontent.jsp?showtype=5&type=1"}//左侧二级菜单
				]
			}]
		},
		{
			name:"产品集成",
			url:"/integration/productintegration.jsp",
			subMenus:[
			{
				name:"功能集成",//左侧一级菜单
				url:"/integration/funcintegration.jsp",
				subMenus:[
					{name:"数据源设置",url:"/integration/integrationTab.jsp?urlType=3"},//左侧二级菜单
					{name:"WebService注册",url:"/integration/integrationTab.jsp?urlType=1"},//左侧二级菜单
					{name:"集成登录",url:"/integration/integrationTab.jsp?urlType=6"},//左侧二级菜单
					{name:"LDAP集成",url:"/integration/integrationTab.jsp?urlType=2"},//左侧二级菜单,
					{name:"HR同步",url:"/integration/integrationTab.jsp?urlType=4"},//左侧二级菜单
					{name:"计划任务",url:"/integration/integrationTab.jsp?urlType=7"},//左侧二级菜单
					{name:"财务凭证",url:"/integration/integrationTab.jsp?urlType=8"},//左侧二级菜单
					{name:"流程触发集成",url:"/integration/icontent.jsp?showtype=12"},//左侧二级菜单
					{name:"流程流转集成",url:"/integration/icontent.jsp?showtype=10"},//左侧二级菜单
					{name:"数据展现集成",url:"/integration/integrationTab.jsp?urlType=10"}
				]
			},{
				name:"产品集成",//左侧一级菜单
				url:"/integration/productintegration.jsp",
				subMenus:[
					{name:"SAP集成",url:"/integration/icontent.jsp?type=1&showtype=1"},//左侧二级菜单
					{name:"NC集成",url:"/integration/icontent.jsp?showtype=2&type=1"},//左侧二级菜单
					{name:"EAS集成",url:"/integration/icontent.jsp?showtype=3&type=1"},//左侧二级菜单
					{name:"U8集成",url:"/integration/icontent.jsp?showtype=4&type=1"},//左侧二级菜单
					{name:"K3集成",url:"/integration/icontent.jsp?showtype=5&type=1"}//左侧二级菜单
				]
			}]
		}],
		devPlat:[//开发
		],
		maintainPlat:[//运维
			{
				name:"系统状态",
				url:"/admincenter/em80_index.jsp"
			},{
				name:"升级向导",
				url:"/admincenter/em80_index.jsp?type=1",
				target:"_blank"
				/*subMenus:[
					{name:"升级包选择",url:""},
					{name:"升级包验证",url:""},
					{name:"停止Resin服务",url:""},
					{name:"数据库备份",url:""},
					{name:"升级包升级",url:""},
					{name:"启动Resin服务",url:""},
					{name:"升级完成",url:""}
				]*///左侧一级菜单
			},{
				name:"配置向导",
				url:"/admincenter/em80_index.jsp?type=2",
				target:"_blank"
			},{
				name:"升级日志",
				url:"/admincenter/em80_index.jsp?type=3",
				target:"_blank"
			},{
				name:"密码设置",
				url:"/admincenter/em80_index.jsp?type=4",
				target:"_blank"
			}/*,{
				name:"升级包还原",
				url:EMSERVER+"/component/manageplat/restore",
				target:"_blank"
			}*/
		]
		
	};

	/**
	处理顶部二级菜单
	**/
	function changeMenu(menuId){
		var submenusDiv=$("#submenusDiv");
		var submenuTr=$("#submenuTr");
		submenusDiv.empty();
		if(menuId==null || menuId==undefined){
			return;
		}else{
			
		}
		
		var subMenus=menus[menuId];
		if(subMenus.length==0){
			$("#drillmenu").parent().hide();
			submenuTr.hide();
		}else{
			submenuTr.show();
		}
		var i=0;
		$.each(subMenus,function(){
			i++;
			var submenuUrlName=this.name;
			var btn="<span class='subMenu hand color-6d'>"+submenuUrlName+"</span>";
			if(i!=subMenus.length){
				btn+="<span class='color-6d'>|</span>";
			}
			if(this.display==false){
				btn="<span class='subMenu hand' style='display:none;'>"+submenuUrlName+"</span>";
			}
			var submenuTarget = this.target;
			if(submenuTarget==null)submenuTarget = 'mainFrame';
			var submenuUrl=this.url;
			if(submenuUrl!=null && submenuUrl!=undefined && submenuUrl!=""){
				btn="<a href=\""+submenuUrl+"\" target='"+submenuTarget+"'>"+btn+"</a>";
			}
			var sub=$(btn);
			
			var leftMenus1=this.subMenus;
			/*
				顶部二级菜单点击事件
			*/
			sub.click(function(){
				$("#drillmenu").empty();
				if(leftMenus1==undefined ){
					$("#drillmenu").parent().parent().hide("slow");
					return ;
				}
				$("#drillmenu").parent().show();//显示左侧菜单
				$("#drillmenu").parent().parent().show("slow");//显示左侧菜单
				$("#drillmenu").append("<div id='innerH'></div>");
				$.each(leftMenus1,function(i,obj){
					var leftMenus1Name=this.name;
					var leftMenus1Url=this.url;
//					if(leftMenus1Url!=null && leftMenus1Url!=undefined && leftMenus1Url!=""){
//						$("#innerH").append("<a href='"+leftMenus1Url+"' target='mainFrame'><div class='leftmainmenu hand '><span class='bzCls'>-</span>"+leftMenus1Name+"</div></a>");
//					}else{
//						$("#innerH").append("<div class='leftmainmenu hand divCss'><span  class='bzCls'>+</span>"+leftMenus1Name+"</div>");
//					}

					var leftMenusi1=$("<div class='leftmainmenu hand divCss'></div>");
					var toggleBtn=$("<span class='toggleBtn bzCls'>+</span>");
					var leftmenus2=this.subMenus;
					if(leftmenus2==null || leftmenus2==undefined || leftmenus2.length==0){
						toggleBtn.html("-");
					}
					
					leftMenusi1.append(toggleBtn);
					addAttr(leftMenusi1,this.attr);
					if(leftMenus1Url!=null && leftMenus1Url!=undefined && leftMenus1Url!=""){
						var leftMenus1a=$("<a href='"+leftMenus1Url+"' target='mainFrame'></a>");
						leftMenus1a.append(leftMenus1Name);
						leftMenusi1.append(leftMenus1a);
					}else{
						leftMenusi1.append(leftMenus1Name);
					}
					$("#innerH").append(leftMenusi1);
					
					
					if(leftmenus2!=null && leftmenus2!=undefined ){
						var htmls=$("<div id='subDiv"+i+"' style=' display: none;' class='w-all leftSubDiv' realheight='0' ></div>");
						$.each(leftmenus2,function(){
							var a=$("<a target='mainFrame' href='"+this.url+"'></a>");
							a.append("<div class='hand leftsubmenu'><span class='toggleBtn bzCls'>-</span>"+this.name+"</div>");
							addAttr(a,this.attr);
							htmls.append(a);
						});
						
						
//						var htmls=["<div id='subDiv"+i+"' style=' display: none;' class='w-all leftSubDiv' realheight='0' >"];
//						$.each(leftmenus2,function(){
//							htmls.push("<a target='mainFrame' href='"+this.url+"'>");
//							htmls.push("<div class='hand leftsubmenu'><span class='toggleBtn'><img src='/images/ecology8/images/close_wev8.gif'/></span>"+this.name+"</div>");
//							htmls.push("</a>");
//						});
//						htmls.push("</div>");
						
						
					 	$("#innerH").append(htmls);
					}
				});
				

				var nodeName=this.nodeName;
				if(nodeName!="A"){
					$("#innerH").find("div:eq(0)").click();
				}
				updateScrollHeight("#drillmenu","#innerH","#leftMenu");
			});
			submenusDiv.append(sub);
			if($.trim(submenuUrlName) == ""){	//名称为空的二级菜单隐藏
				sub.hide();
			}
		});
		$(".subMenu:eq(0)").click();
		updateScrollHeight("#drillmenu","#innerH","#leftMenu");
	}
	
	
	$(function(){
		/**
			顶部二级菜单选中处理(样式)
		**/
		$(".subMenu").bind("click",function(){
			$(".subMenu").removeClass("subMenuSelected");
			$(this).addClass("subMenuSelected");
			var url=$(this).attr("url");
			if(url==""){
				return;
			}
		});
		
		/**
			左侧一级菜单选中处理(样式)
		**/
		$(".leftmainmenu").bind("click",function(){
			$(".leftmainmenuselected").removeClass("leftmainmenuselected");
			$(this).addClass("leftmainmenuselected");
		});
		
		$(".toggleBtn").bind("click",function(){
			$(this).toggleClass("opened");
			if($(this).hasClass("opened")){
				$(this).html("-");
			}else{
				$(this).html("+");
			}
			$(this.parentNode.nextSibling).toggle("slow");
			updateScrollHeight("#drillmenu","#innerH","#leftMenu");
			$(this).addClass("leftmainmenuselected");
		});
		
		/**
			左侧二级菜单选中处理(样式)
		**/
		$(".leftsubmenu").bind("click",function(){
			$(".leftsubmenuselected").removeClass("leftsubmenuselected");
			$(this).addClass("leftsubmenuselected");
		});
		
	});
	jQuery(document).ready(function(){
		/*
			退出按钮悬停样式
		*/
		jQuery(".shortcutItem").hover(
			function(){$(this).addClass("touming-10");},
			function(){$(this).removeClass("touming-10");}
		);
		
		/*
		*记录最后选中的菜单
		*/
		var lastShowDiv="";
		/*For TopTabItem*/
		jQuery(".toptabitem").click(function() {
			 $this=$(this);
			 var targetDiv=$this.attr("target");
			 if(targetDiv==lastShowDiv) return;
			 
			//一级菜单选中后浮动层的处理
			jQuery("#divFloatItem").find(".imgCenter").html("<span style='font-size:17px;'><b>"+$this.html()+"</b></span>");
			jQuery("#divFloatItem").show().each(function(){
				jQuery.dequeue(this, "fx");}).animate({    
				width:$this.width(),
				height:$this.height(),
				top: CheckBrowser()=="firefox"?$this.offset().top-10:(jQuery.browser.msie?$this.position().top:$this.position().top-10),
				left: CheckBrowser()=="firefox"?$this.offset().left:$this.position().left
				},350, 'easeOutExpo');
			
			//jQuery("#divFloatItem").css("line-height","180px");
			
			
			//处理左侧菜单
			$("#"+lastShowDiv).hide();
			$("#"+targetDiv).show();
			lastShowDiv=targetDiv;
			var menuId=$this.attr("target");
			changeMenu(menuId);
		});
		
		/*
		进入页面后第一个顶部菜单默认选中
		*/
		$(".firstselected").trigger("click");
		$(".hoverimg").hover(
			function(){
				$this=$(this);
				$(this).attr("src",$this.attr("overimg"));
			},
			function(){
				$this=$(this);
				$(this).attr("src",$this.attr("srcimg"));				
			}
		);
		
		/*For Left Menu Item*/
	/*	jQuery(".toShowMenu").hover(
			function(){$(this).addClass("divOver");},
			function(){$(this).removeClass("divOver");}
		);

		jQuery(".toShowMenu").bind("click",function(){
			jQuery("#"+jQuery(this).attr("target")+"Preview").hide();
			jQuery("#"+jQuery(this).attr("target")+"Content").show();
			jQuery("#drillmenu"+jQuery(this).attr("target")).find("div:eq("+jQuery(this).attr("index")+")").trigger("click");
		});

		function init(targetDiv){
			jQuery("#selectedLeftMenu").text("");
			jQuery("#menuFloatSpan").text("");
			
			jQuery("#"+targetDiv+"Preview").show();
			jQuery("#"+targetDiv+"Content").hide();
		}

		$(".progressBar").progressBar(30,{width:400,height:14,barImage: '/images/ecology8/images/progressbg_ccc_wev8.gif'});
	 	jQuery(".toMenuTargetImg").hover(
				function(){
					$(this).attr("src","/images/ecology8/images/product/"+$(this).attr("target")+"/"+$(this).attr("id")+"Over_wev8.png");
				},
				function(){
					$(this).attr("src","/images/ecology8/images/product/"+$(this).attr("target")+"/"+$(this).attr("id")+"_wev8.png");
				}
		);
		 
		jQuery(".toMenuTargetImg").bind("click",function(){
			jQuery("#"+jQuery(this).attr("target")+"Preview").hide();
			jQuery("#"+jQuery(this).attr("target")+"Content").show();
			jQuery("#drillmenu"+jQuery(this).attr("target")).find("div:eq("+jQuery(this).attr("index")+")").trigger("click");
		});*/
		
		jQuery(".selectItem").hover(
			function(){
				$(this).addClass("selectDownSelected")
			},
			function(){
				$(this).removeClass("selectDownSelected")
			}
		);
		
		/**
		右上角菜单点击跳转
		**/
		jQuery(".selectItem").bind("click",function(){
			window.location.href=jQuery(this).attr("url");
		});
		
		
		/**
		隐藏右上角菜单
		**/
		$("body").bind("click",function(){
			$("#selectContentDiv").hide();
			$("#selectIcon").attr("src","/images/ecology8/images/select/ecology_wev8.png");
		});
		 
		/**
		右上角菜单鼠标悬停样式
		**/
		jQuery("#selectIcon").hover(
			function(){
				$(this).attr("src","/images/ecology8/images/select/ecologyOver_wev8.png");
			},
			function(){
				//$(this).attr("src","/images/ecology8/images/select/ecology_wev8.png");
			}
		);
		 
		/**
		弹出右上角菜单
		**/
		jQuery("#selectIcon").bind("click",function(event){
			var offset = jQuery(this).offset();
			event.stopPropagation(); 
			$("#selectContentDiv").hide();
			$("#selectContentDiv").css("left",offset.left);
			$("#selectContentDiv").css("top",offset.top+19);
			$("#selectContentDiv").show();
		});
	});

	var cacheMenu = null;

	function getDeployedApp(){
		/*jQuery("#drillmenu").hide();
		jQuery("#leftMenu").show("slow");
		jQuery("#leftMenu").attr("src","leftMenu/left.jsp?module=2");*/
		if(cacheMenu){
			jQuery("#drillmenu").html(cacheMenu);
			createMenu("#drillmenu","20px");
		}else{
				jQuery.ajax({
				url:"/wui/theme/ecology8/page/ajaxGetMenu.jsp?typeid=114&parentid=",
				type: 'GET',
				dataType: 'html',
				timeout: 10000,
				error: function(xml){
					alert('Error loading XML document'+xml);
				},
				success: function(xml){
					//createMenu(xml);
					//对返回的数据进行处理
					cacheMenu = xml;
					jQuery("#drillmenu").html(xml);
					createMenu("#drillmenu","20px");
					
					//setTimeout("jQuery('.folderNew:first').trigger('click');",100);
					
				}
			});
		}
		
	}

	function updateScrollHeight(outerContainer,innerContainer,updateContainer){
		window.setTimeout(function(){
			$(outerContainer).height($(innerContainer).height());
			$(updateContainer).perfectScrollbar("update");
		},500);
	}




	function addAttr(obj,attrs){
		if(attrs!=null && attrs!=undefined){
			for(var attr in attrs){
				obj.attr(attr,attrs[attr]);
			}
		}
	}

	function openMenu(expressions){
		var j=[];
		for(var expression in expressions){
			j.push("["+expression+"='"+expressions[expression]+"']");
		}
		var objectElement=$(j.join(""));
		if(objectElement.hasClass("leftmainmenu")){
			return;
		}else{
			var hide=objectElement.is(":hidden");
			if(!hide){
				return;
			}
			$(objectElement.parent().get(0).previousSibling).find(".toggleBtn:eq(0)").click();
		}
		
	}
	
	function changeFormModuleUrl(url){
		var mainFrame = document.getElementById("mainFrame");
		var mainFrameDoc = mainFrame.contentWindow.document;
		var currModelId = mainFrameDoc.getElementById("currModelId").value;
		var rightFrame = mainFrameDoc.getElementById("rightFrame");
		url += ((url.indexOf("?") == -1) ? "?" : "&") + "modelId=" + currModelId;
		rightFrame.src = url;
	}
	
	var topDlg;
	function createTopDialog(){
		if(!topDlg){
			topDlg = new Dialog();
		}
		return topDlg;
	}
	
	function closeTopDialog(result){
		if(topDlg){
			if(typeof(topDlg.onCloseCallbackFn) == "function"){
				topDlg.onCloseCallbackFn(result);
			}
			topDlg.close();
			topDlg = null;
		}
	}
	
	function callTopDlgHookFn(result){
		if(topDlg && typeof(topDlg.hookFn) == "function"){
			topDlg.hookFn(result);
		}
	}

	var codeDlg;
	function openCodeEdit(param, hookFn){
		var url = "/formmode/setup/codeEdit.jsp?1=1";
		if(param){
			for(var key in param){
				url += "&" + key + "=" + param[key];
			}
		}
		codeDlg = new Dialog();//获取Dialog对象
		codeDlg.Model = true;
		codeDlg.Width = 900;//定义长度
		codeDlg.Height = 548;
		codeDlg.URL = url;
		codeDlg.Title = "代码编辑";
		codeDlg.show();
		codeDlg.hookFn = hookFn;
	}
	
	function callCodeDlgHookFn(result){
		if(codeDlg && typeof(codeDlg.hookFn) == "function"){
			codeDlg.hookFn(result);
		}
	}
	
	function closeCodeEdit(){
		if(codeDlg){
			if(typeof(codeDlg.onCloseCallbackFn) == "function"){
				codeDlg.onCloseCallbackFn(result);
			}
			codeDlg.close();
			codeDlg = null;
		}
	}