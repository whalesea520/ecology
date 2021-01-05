	
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
						url="/workflow/search/wfTabFrame.jsp?method=reqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=1&selectedContent="+selectedContent +"&menuType="+menuType +"&date2during="+date2during +"&viewType=3";
					}else{
						url="/workflow/search/wfTabFrame.jsp?method=reqeustbywftype&wftype="+typeid+"&complete=1&date2during="+date2during +"&viewType=3";
					}
				}else{
					if(numberType==null){
						numberType="flowAll";
					}
					var complete=doingTypes[numberType].complete;
					window.typeid=null;
					window.workflowid=workflowid;
					window.nodeids=nodeids;
					url="/workflow/search/wfTabNewFrame.jsp?method=reqeustbywfid&workflowid="+workflowid+"&complete="+complete+"&date2during="+date2during+"&viewType=3";
				}
				url+="&viewScope=complete&numberType="+numberType;
				$(".flowFrame").attr("src",url);
	}