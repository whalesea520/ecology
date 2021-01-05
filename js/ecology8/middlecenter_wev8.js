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
								{name:"权限设置",url:"/hrm/HrmTab.jsp?_fromURL=SystemRightGroup"},
								{name:"权限转移",url:"/hrm/HrmTab.jsp?_fromURL=HrmRightTransfer"},
								{name:"角色设置",url:"/hrm/roles/HrmRoles_frm.jsp"}	//modified by wcd 2014-06-30 [/hrm/HrmTab.jsp?_fromURL=HrmRoles]
					]
				},
				{
					name:"功能管理赋权",
					subMenus:[
								{name:"功能管理赋权设置",url:"/system/EffectManageEmpowerTab.jsp?_fromURL=EffectManageEmpower"}
					]
				},{
					name:"分权管理中心",
					subMenus:[
								{name:"分权管理设置",url:"/system/DetachMSetTab.jsp?_fromURL=DetachMSetEdit"},
								{name:"分权管理员设置",url:"/systeminfo/sysadmin/sysadminEditBatchTab.jsp?_fromURL=sysadminEditBatch"},
								{name:"组织机构应用分权",url:"/system/sysdetach/AppDetachTab.jsp?_fromURL=AppDetachList"},
								{name:"模块管理分权",url:"/system/ModuleManageDetachTab.jsp?_fromURL=ModuleManageDetach"}
					]
				}			
				]
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
					{name:"集成登录",url:"/interface/outter/OutterSys.jsp"},//左侧二级菜单
					{name:"LDAP集成",url:"/integration/ldapsetting.jsp"},//左侧二级菜单,
					{name:"数据源设置",url:"/servicesetting/datasourcesetting.jsp"},//左侧二级菜单
					{name:"HR同步",url:"/integration/hrsetting.jsp"},//左侧二级菜单
					{name:"公文交换",url:"/integration/icontent.jsp?showtype=6&type=1"},//左侧二级菜单
					{name:"计划任务",url:"/servicesetting/schedulesetting.jsp"},//左侧二级菜单
					{name:"流程触发集成",url:"/workflow/automaticwf/automaticsetting.jsp"},//左侧二级菜单
					{name:"财务凭证",url:"/integration/financelist.jsp"},//左侧二级菜单
					{name:"流程流转集成",url:"/integration/actioncontent.jsp"},//左侧二级菜单
					{name:"数据展现集成",url:"/integration/WsShowEditSetList.jsp"}
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
						{name:"元素库",url:"/admincenter/portalEngine/PortalElements.jsp"},
						{name:"元素开发",url:"/admincenter/portalEngine/ElementCustom.jsp"}
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
				name:"引擎监控",
				url:""
			},{
				name:"开发集成",
				url:""
			},{
				name:"监控分析",
				url:""
			}
		],
		reportEngine:[//报表
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
		],
		combinePlat:[//集成
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
		],
		devPlat:[//开发
		],
		maintainPlat:[//运维
			{
				name:"服务状态",
				url:""
			},{
				name:"升级向导",
				subMenus:[
					{name:"升级包选择",url:""},
					{name:"升级包验证",url:""},
					{name:"停止Resin服务",url:""},
					{name:"数据库备份",url:""},
					{name:"升级包升级",url:""},
					{name:"启动Resin服务",url:""},
					{name:"升级完成",url:""}
				]//左侧一级菜单
			},{
				name:"配置向导",
				url:""
			},{
				name:"升级日志",
				url:""
			},{
				name:"密码设置",
				url:""
			},{
				name:"升级包还原",
				url:""
			}
		]
		
	};

	/**
	处理顶部二级菜单
	**/
	function changeMenu(menuId){
		var submenusDiv=jQuery("#submenusDiv");
		var submenuTr=jQuery("#submenuTr");
		submenusDiv.empty();
		if(menuId==null || menuId==undefined){
			return;
		}else{
			
		}
		
		var subMenus=menus[menuId];
		if(subMenus.length==0){
			jQuery("#drillmenu").parent().hide();
			submenuTr.hide();
		}else{
			submenuTr.show();
		}
		jQuery.each(subMenus,function(){
			
			var submenuUrlName=this.name;
			var btn="<span class='subMenu hand'>"+submenuUrlName+"</span>";
			if(this.display==false){
				btn="<span class='subMenu hand' style='display:none;'>"+submenuUrlName+"</span>";
			}
			var submenuTarget = this.target;
			if(submenuTarget==null)submenuTarget = 'mainFrame';
			var submenuUrl=this.url;
			if(submenuUrl!=null && submenuUrl!=undefined && submenuUrl!=""){
				btn="<a href='"+submenuUrl+"' target='"+submenuTarget+"'>"+btn+"</a>";
			}
			var sub=jQuery(btn);
			
			var leftMenus1=this.subMenus;
			
			/*
				顶部二级菜单点击事件
			*/
			sub.click(function(){
				jQuery("#drillmenu").empty();
				if(leftMenus1==undefined ){
					jQuery("#drillmenu").parent().parent().hide("slow");
					return ;
				}
				jQuery("#drillmenu").parent().show();//显示左侧菜单
				jQuery("#drillmenu").parent().parent().show("slow");//显示左侧菜单
				jQuery("#drillmenu").append("<div id='innerH'></div>");
				jQuery.each(leftMenus1,function(i,obj){
					var leftMenus1Name=this.name;
					var leftMenus1Url=this.url;
//					if(leftMenus1Url!=null && leftMenus1Url!=undefined && leftMenus1Url!=""){
//						jQuery("#innerH").append("<a href='"+leftMenus1Url+"' target='mainFrame'><div class='leftmainmenu hand '><span class='bzCls'>-</span>"+leftMenus1Name+"</div></a>");
//					}else{
//						jQuery("#innerH").append("<div class='leftmainmenu hand divCss'><span  class='bzCls'>+</span>"+leftMenus1Name+"</div>");
//					}

					var leftMenusi1=jQuery("<div class='leftmainmenu hand divCss'></div>");
					var toggleBtn=jQuery("<span class='toggleBtn bzCls'>+</span>");
					var leftmenus2=this.subMenus;
					
					addAttr(leftMenusi1,this.attr);
					var leftMenus1a = "";
					if(leftMenus1Url!=null && leftMenus1Url!=undefined && leftMenus1Url!=""){
						var leftMenus1span = jQuery("<span class='nameDiv'></span>");
						leftMenus1a=jQuery("<a href='"+leftMenus1Url+"' target='mainFrame'></a>");
						leftMenus1span.append(leftMenus1Name);
						leftMenus1a.append(toggleBtn);
						leftMenus1a.append(leftMenus1span);
						leftMenusi1.append(leftMenus1a);
					}else{
						leftMenusi1.append(toggleBtn);
						leftMenusi1.append("<span class='nameDiv'>"+leftMenus1Name+"</span><span class='expand'><img src='/images/ecology8/menuicon/closed_wev8.png'/></span>");
					}
					
					jQuery("#innerH").append(leftMenusi1);
					
					if(!!leftMenusi1.find("span.expand")){
						setMarginLeft2(leftMenusi1);
					}
					
					if(leftmenus2==null || leftmenus2==undefined || leftmenus2.length==0){
						toggleBtn.html("-");
						leftMenusi1.removeClass("leftmainmenu").addClass("leftsubmenu");
						if(!!leftMenus1a)
							setNameDivWidth(leftMenus1a);
					}
					
					if(leftmenus2!=null && leftmenus2!=undefined ){
						var htmls=jQuery("<div id='subDiv"+i+"' style=' display: none;' class='w-all leftSubDiv' realheight='0' ></div>");
						jQuery.each(leftmenus2,function(){
							var a=jQuery("<a target='mainFrame' href='"+this.url+"'></a>");
							var b=jQuery("<div class='hand leftsubmenu'><span class='toggleBtn bzCls'>-</span><span class='nameDiv'>"+this.name+"</span></div>");
							a.append(b);
							addAttr(a,this.attr);
							htmls.append(a);
						});
						
						
//						var htmls=["<div id='subDiv"+i+"' style=' display: none;' class='w-all leftSubDiv' realheight='0' >"];
//						jQuery.each(leftmenus2,function(){
//							htmls.push("<a target='mainFrame' href='"+this.url+"'>");
//							htmls.push("<div class='hand leftsubmenu'><span class='toggleBtn'><img src='/images/ecology8/images/close_wev8.gif'/></span>"+this.name+"</div>");
//							htmls.push("</a>");
//						});
//						htmls.push("</div>");
						
						
					 	jQuery("#innerH").append(htmls);
					 	
					 	jQuery("#innerH").find("div.leftSubDiv").each(function(){
					 		jQuery(this).children("a").each(function(){
								setNameDivWidth2(this);					 			
					 		});
					 	});
					}
				});
				

				var nodeName=this.nodeName;
				if(nodeName!="A"){
					jQuery("#innerH").find("div:eq(0)").click();
				}
				updateScrollHeight("#drillmenu","#innerH","#leftMenu");
			});
			submenusDiv.append(sub);
			submenusDiv.hide();
			
		});
		jQuery(".subMenu:eq(0)").click();
		updateScrollHeight("#drillmenu","#innerH","#leftMenu");
	}
	
	
	jQuery(function(){
		/**
			顶部二级菜单选中处理(样式)
		**/
		jQuery(".subMenu").bind("click",function(){
			jQuery(".subMenu").removeClass("subMenuSelected");
			jQuery(this).addClass("subMenuSelected");
			var url=jQuery(this).attr("url");
			if(url==""){
				return;
			}
		});
		
		/**
			左侧一级菜单选中处理(样式)
		**/
		jQuery(".leftmainmenu").bind("click",function(){
			jQuery(".leftmainmenuselected").removeClass("leftmainmenuselected");
			if(jQuery(this).next(".leftSubDiv").length==0 || jQuery(this).children("a").length>0)
				jQuery(this).addClass("leftmainmenuselected");
		});
		
		jQuery(".toggleBtn").bind("click",function(){
			jQuery(this).toggleClass("opened");
			if(jQuery(this).hasClass("opened")){
				jQuery(this).html("-");
				var x = jQuery(this).parent("div").find("span.expand img");
				var angle = 0;
				var timer = setInterval(function(){
					angle+=5;
					if(jQuery.browser.msie){
						jQuery(x).attr("src","/images/ecology8/menuicon/open_wev8.png");
						jQuery(x).blur();
						clearInterval(timer);
					}else{
						jQuery(x).rotate(angle);
						if (angle==90) clearInterval(timer);
					}
				},5);
			}else{
				jQuery(this).html("+");
				var x = jQuery(this).parent("div").find("span.expand img");
				var angle = 0;
				var timer = setInterval(function(){
					angle+=20;
					if(jQuery.browser.msie){
						jQuery(x).attr("src","/images/ecology8/menuicon/closed_wev8.png");
						jQuery(x).blur();
						clearInterval(timer);
					}else{
						jQuery(x).rotate(angle);
						if (angle==360) clearInterval(timer);
					}
				},5);
			}
			jQuery(this.parentNode.nextSibling).toggle();
			updateScrollHeight("#drillmenu","#innerH","#leftMenu");
			jQuery(this).addClass("leftmainmenuselected");
		});
		
		/**
			左侧二级菜单选中处理(样式)
		**/
		jQuery(".leftsubmenu").bind("click",function(){
			jQuery(".leftmainmenuselected").removeClass("leftmainmenuselected");
			jQuery(".leftsubmenuselected").removeClass("leftsubmenuselected");
			jQuery(this).addClass("leftsubmenuselected");
		});
		
	});
	jQuery(document).ready(function(){
		/*
			退出按钮悬停样式
		*/
		jQuery(".shortcutItem").hover(
			function(){jQuery(this).addClass("touming-10");},
			function(){jQuery(this).removeClass("touming-10");}
		);
		
		/*
		*记录最后选中的菜单
		*/
		var lastShowDiv="";
		/*For TopTabItem*/
		jQuery(".toptabitem").click(function() {
			 $this=jQuery(this);
			 var targetDiv=$this.attr("target");
			 if(targetDiv==lastShowDiv) return;
			 
			//一级菜单选中后浮动层的处理
			/*jQuery("#divFloatItem").find(".imgCenter").html("<span style='font-size:17px;'><b>"+$this.html()+"</b></span>");
			jQuery("#divFloatItem").show().each(function(){
				jQuery.dequeue(this, "fx");}).animate({    
				width:$this.width(),
				height:$this.height(),
				top: CheckBrowser()=="firefox"?$this.offset().top:$this.position().top,
				left: CheckBrowser()=="firefox"?$this.offset().left:$this.position().left
				},350, 'easeOutExpo');
			
			jQuery("#divFloatItem").css("line-height","180px");*/
			setNewSelectItem(this);			
			
			//处理左侧菜单
			jQuery("#"+lastShowDiv).hide();
			jQuery("#"+targetDiv).show();
			jQuery(".e8_leftToggle").removeClass("e8_leftToggleShow");
			lastShowDiv=targetDiv;
			var menuId=$this.attr("target");
			changeMenu(menuId);
		});
		
		function setNewSelectItem(obj){
			jQuery(".toptabitem").each(function(){
				var img = jQuery(this).find("img:first");
				var attr = jQuery(img).attr("src");
				if(!!attr)
					jQuery(img).attr("src",attr.replace("-s",""));
			});
			jQuery(".toptabitem").removeClass("selectTopItem");
			jQuery(obj).addClass("selectTopItem");
			var img = jQuery(obj).find("img:first");
			var attr = jQuery(img).attr("src");
			if(!!attr)
				jQuery(img).attr("src",attr.replace("_wev8.png","-s_wev8.png"));
		}
		
		/*
		进入页面后第一个顶部菜单默认选中
		*/
		jQuery(".firstselected").trigger("click");
		jQuery(".hoverimg").hover(
			function(){
				$this=jQuery(this);
				jQuery(this).attr("src",$this.attr("overimg"));
			},
			function(){
				$this=jQuery(this);
				jQuery(this).attr("src",$this.attr("srcimg"));				
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
				jQuery(this).addClass("selectDownSelected")
			},
			function(){
				jQuery(this).removeClass("selectDownSelected")
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
		jQuery("body").bind("click",function(){
			jQuery("#selectContentDiv").hide();
			jQuery("#selectIcon").attr("src","/images/ecology8/images/select/ecology_wev8.png");
		});
		 
		/**
		右上角菜单鼠标悬停样式
		**/
		jQuery("#selectIcon").hover(
			function(){
				jQuery(this).attr("src","/images/ecology8/images/select/ecologyOver_wev8.png");
			},
			function(){
				//jQuery(this).attr("src","/images/ecology8/images/select/ecology_wev8.png");
			}
		);
		 
		/**
		弹出右上角菜单
		**/
		jQuery("#selectIcon").bind("click",function(event){
			var offset = jQuery(this).offset();
			event.stopPropagation(); 
			jQuery("#selectContentDiv").hide();
			jQuery("#selectContentDiv").css("left",offset.left);
			jQuery("#selectContentDiv").css("top",offset.top+19);
			jQuery("#selectContentDiv").show();
		});
	});
	
	var cacheMenu = null;
	var __ajaxSendTime__ = 0;
	function getDeployedApp(parentid,selectFirst){
		/*jQuery("#drillmenu").hide();
		jQuery("#leftMenu").show("slow");
		jQuery("#leftMenu").attr("src","leftMenu/left.jsp?module=2");*/
				if(!parentid){
					return;
				}
				var time = 0;
				jQuery.ajax({
				url:"/wui/theme/ecology8/page/ajaxGetMenu.jsp?typeid=114&parentid="+parentid,
				type: 'GET',
				dataType: 'html',
				error: function(xml){
					alert('Error loading XML document'+xml);
				},
				beforeSend:function(xhr){
					time = new Date().getTime();
					__ajaxSendTime__ = time;
					jQuery("#drillmenu").html("<span style=\"align:center;padding-top:50px;padding-left:50px;\"><img src=\"/wui/theme/ecology8/page/images/leftmenu/loader_wev8.gif\"></span>");
				},
				success: function(xml){
					//aelrt(xml)
					//createMenu(xml);
					//对返回的数据进行处理
					if(__ajaxSendTime__ == time){
						cacheMenu = xml;
						jQuery("#drillmenu").html(xml);
						createMenu("#drillmenu","10px");
						if(selectFirst){
							selectFirstMenu(jQuery("#drillmenu"));
						}
						window.setTimeout(function(){
							jQuery("#drillmenu").height(jQuery("#drillmenu").children("ul").height());
							jQuery('#leftMenu').perfectScrollbar("update");
						},10);
					}
				}
			});
		
		function selectFirstMenu(obj){
			var li = jQuery(obj).find("ul:first").find("li:first");
			//alert(li.length)
			if(li.hasClass("liCss")){
				li.find("a:first").trigger("click");
				selectFirstMenu(li)
			}else{
				//alert("click")
				li.find(".nameDiv:first").trigger("click");
			}
	}
		
		
		
	}

	function updateScrollHeight(outerContainer,innerContainer,updateContainer){
		window.setTimeout(function(){
			jQuery(outerContainer).height(jQuery(innerContainer).height());
			jQuery(updateContainer).perfectScrollbar("update");
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
		var objectElement=jQuery(j.join(""));
		if(objectElement.hasClass("leftmainmenu")){
			return;
		}else{
			var hide=objectElement.is(":hidden");
			if(!hide){
				return;
			}
			jQuery(objectElement.parent().get(0).previousSibling).find(".toggleBtn:eq(0)").click();
		}
		
	}
	
	var topDlgArr = new Array();
	function createTopDialog(){
		var topDlg = new Dialog();
		topDlg.CancelEvent = function(){
			topDlg.close();
			topDlgArr.splice(topDlgArr.length - 1, 1);
			//closeTopDialog();
		};
		topDlgArr.push(topDlg);
		return topDlg;
	}
	
	function closeTopDialog(result){
		if(topDlgArr.length > 0){
			var topDlg = topDlgArr[topDlgArr.length - 1];
			if(typeof(topDlg.onCloseCallbackFn) == "function"){
				topDlg.onCloseCallbackFn(result);
			}
			topDlg.close();
			topDlgArr.splice(topDlgArr.length - 1, 1);
		}
	}
	
	function callTopDlgHookFn(result){
		if(topDlgArr.length > 0){
			var topDlg = topDlgArr[topDlgArr.length - 1];
			if(topDlg && typeof(topDlg.hookFn) == "function"){
				topDlg.hookFn(result);
			}
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
		codeDlg.Title = SystemEnv.getHtmlNoteName(3506,readCookie("languageidweaver"));
		codeDlg.CancelEvent = cancelCodeEditor;
		codeDlg.show();
		codeDlg.hookFn = hookFn;
	}
	
	function cancelCodeEditor() {
		Dialog.confirm(SystemEnv.getHtmlNoteName(3507,readCookie("languageidweaver")), function(){
			codeDlg.close();
		});
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
	
	function loadFormEngine(url,isLoad){
		var formEnginFrame=jQuery("#formEngine");
		if(formEnginFrame.length>0){
			var formEngineDoc=jQuery(document.getElementById("formEngine").contentWindow.document);
			var rightFrameUrlObj=formEngineDoc.find("#rightFrameUrl");
			var currModelIdObj=formEngineDoc.find("#currModelId");
			var t = new Date().getTime();
			url = url+"?t="+t;
			rightFrameUrlObj.val(url);
			jQuery("#mainFrame").attr("src",url+"&modelId="+currModelIdObj.val());
			if(isLoad){
				formEnginFrame.css("opacity", "1");
			}
		}else{
			var leftMenuHeight=jQuery("#leftMenu").height();
			//建模引擎
			var leftMenuFrame=jQuery("<iframe id='formEngine' frameborder='0' style='width: 100%;height:100%;opacity: 0;' onload='loadFormEngine(\""+url+"\",true)'/>").attr("src","/formmode/setup/main.jsp");
			jQuery("#drillmenu").empty().height(leftMenuHeight).append(leftMenuFrame);
		}
	}
	
	function loadMobileEngine(url,isLoad){
		var mobileEngineFrame=jQuery("#mobileEngine");
		if(mobileEngineFrame.length>0){
			var mobileEngineDoc=jQuery(document.getElementById("mobileEngine").contentWindow.document);
			var rightFrameUrlObj=mobileEngineDoc.find("#rightFrameUrl");
			var currMobileAppIdObj=mobileEngineDoc.find("#currMobileAppId");
			rightFrameUrlObj.val(url);
			jQuery("#mainFrame").attr("src",url+"?id="+currMobileAppIdObj.val());
			if(isLoad){
				mobileEngineFrame.css("opacity", "1");
			}
		}else{
			var leftMenuHeight=jQuery("#leftMenu").height();
			//建模引擎
			var leftMenuFrame=jQuery("<iframe id='mobileEngine' frameborder='0' style='width: 100%;height:100%;opacity: 0;' onload='loadMobileEngine(\""+url+"\",true)'/>").attr("src","/mobilemode/MobileSettings.jsp");
			$("#drillmenu").empty().height(leftMenuHeight).append(leftMenuFrame);
		}
	}
	
	function changeDrillmenuHeight(enginFrameID){
		var formEnginFrame=jQuery("#formEngine");
		var mobileEngineFrame=jQuery("#mobileEngine");
		if(formEnginFrame.length>0||mobileEngineFrame.length>0){
			var leftMenuHeight=jQuery("#leftMenu").height();
			jQuery("#drillmenu").height(leftMenuHeight);
		}
	}