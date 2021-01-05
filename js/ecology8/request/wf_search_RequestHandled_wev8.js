	
	function leftMenuClickFn(attr,level,numberType){
				var doingTypes={
					"flowAll":{complete:2},			//全部
					"flowNew":{complete:50},		//新的
					"flowResponse":{complete:5},	//反馈的
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
						url="/workflow/search/wfTabFrame.jsp?method=reqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=2&selectedContent="+selectedContent +"&menuType="+menuType +"&date2during="+date2during +"&viewType=2";
					}else{
						url="/workflow/search/wfTabNewFrame.jsp?method=reqeustbywftype&wftype="+typeid+"&complete=2&date2during="+date2during +"&viewType=2";
					}
				}else{
					if(numberType==null){
						numberType="flowAll";
					}
					var complete=doingTypes[numberType].complete;
					window.typeid=null;
					window.workflowid=workflowid;
					window.nodeids=nodeids;
					url="/workflow/search/wfTabNewFrame.jsp?method=reqeustbywfid&workflowid="+workflowid+"&complete="+complete+"&date2during="+date2during+"&viewType=2";
				}
				url+="&viewScope=done&numberType="+numberType;
				$(".flowFrame").attr("src",url);
	}