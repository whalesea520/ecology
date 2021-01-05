	
	function leftMenuClickFn(attr,level,numberType){
				var doingTypes={
					"flowAll":{complete:1},			//全部
					"flowNew":{complete:6},		//新的
					"flowResponse":{complete:7},	//反馈的
				};
				var url;
				var typeid=attr.typeid;
				var fromAdvancedMenu=attr.fromAdvancedMenu;
				var infoId=attr.infoId;
				var selectedContent=attr.selectedContent;
				var menuType=attr.menuType;
				var date2during=attr.date2during;
				var workflowid=attr.workflowid;
				
				if(level==1){
					window.typeid=typeid;
					window.workflowid=null;
					window.nodeids=null;
					if(fromAdvancedMenu=="1"){
						url="/system/systemmonitor/workflow/wfMonitorFrame.jsp?method=reqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&selectedContent="+selectedContent +"&menuType="+menuType +"&date2during="+date2during +"&viewType=3";
					}else{
						url="/system/systemmonitor/workflow/wfMonitorFrame.jsp?method=reqeustbywftype&wftype="+typeid+"&date2during="+date2during +"&viewType=3";
					}
				}else{
					if(numberType==null){
						numberType="flowAll";
					}
					var complete=doingTypes[numberType].complete;
					window.typeid=null;
					window.workflowid=workflowid;
					window.nodeids=nodeids;
					url="/system/systemmonitor/workflow/wfMonitorFrame.jsp?method=reqeustbywfid&workflowid="+workflowid+"&date2during="+date2during+"&viewType=3";
				}
				url+="&viewScope=complete&numberType="+numberType;
				$(".flowFrame").attr("src",url);
	}
	
	
	flowPageManager.loadFunctions.leftNumMenu = function(){
			
			var needflowOut=true;
			var needflowResponse=true;
			
			var	numberTypes={
					flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"新的流程"}
			};
			if(needflowOut==true || needflowOut=="true"){
				numberTypes.flowOut={hoverColor:"#CB9CF4",color:"#CB9CF4",title:"超时的流程"};
			}
			if(needflowResponse==true || needflowResponse=="true"){
				numberTypes.flowResponse={hoverColor:"#FFC600",color:"#FFC600",title:"有反馈的流程"};
			}
			numberTypes.flowAll={hoverColor:"#A6A6A6",color:"black",title:"全部流程"};
			if(demoLeftMenus != null)
			{
				$(".ulDiv").leftNumMenu(demoLeftMenus,{
					numberTypes:numberTypes,
					showZero:false,
					menuStyles:["menu_lv1",""],
					clickFunction:function(attr,level,numberType){
						leftMenuClickFn(attr,level,numberType);
					},
					deleteIfAllZero : true
				});
			}
			var sumCount=0;
			$(".e8_level_2").each(function(){
				sumCount+=parseInt($(this).find(".e8_block:last").html());
			});
			//$(".leftType").append("("+sumCount+")");
			
		}