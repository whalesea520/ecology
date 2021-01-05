	
	function leftMenuClickFn(attr,level,numberType){
				var doingTypes={
					"flowAll":{complete:0},			//全部
					"flowNew":{complete:3},			//新的
					"flowResponse":{complete:4},	//反馈的
					"flowOut":{complete:8}			//超时的
				};
				if(numberType==null){
					numberType="flowAll";
				}
				var complete=doingTypes[numberType].complete;
				
				var flowAll=attr.flowAll;
				var flowNew=attr.flowNew;
				var flowResponse=attr.flowResponse;
				var flowOut=attr.flowOut;
				
				var url;
				if(level==1){
					var typeid=attr.typeid;
					window.typeid=typeid;
					window.workflowid=null;
					window.nodeids=null;
					
					var fromAdvancedMenu=attr.fromAdvancedMenu;
					var infoId=attr.infoId;
					var workFlowIDsRequest=attr.workFlowIDsRequest;
					var workFlowNodeIDsRequest=attr.workFlowNodeIDsRequest;
					var selectedContent=attr.selectedContent;
					var menuType=attr.menuType;
					
//					if(fromAdvancedMenu=="1"){
//						url="/workflow/search/wfTabFrame.jsp?method=reqeustbywftypeNode&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=0&workFlowIDsRequest="+workFlowIDsRequest+"&workFlowNodeIDsRequest="+workFlowNodeIDsRequest+"&selectedContent="+selectedContent +"&menuType="+menuType;
//					}else{
//						url="/workflow/search/wfTabFrame.jsp?method=reqeustbywftype&wftype="+typeid+"&complete="+complete;
//					}
					if(fromAdvancedMenu=="1"){
						url="/workflow/search/wfTabFrame.jsp?method=reqeustByWfTypeAndComplete&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=0&workFlowIDsRequest="+workFlowIDsRequest+"&workFlowNodeIDsRequest="+workFlowNodeIDsRequest+"&selectedContent="+selectedContent +"&menuType="+menuType;
					}else{
						url="/workflow/search/wfTabFrame.jsp?method=reqeustByWfTypeAndComplete&wftype="+typeid+"&complete="+complete;
					}
				}else{
					var workflowid=attr.workflowid;
					var nodeids=attr.nodeids;
					window.typeid=null;
					window.workflowid=workflowid;
					window.nodeids=nodeids;
					url="/workflow/search/wfTabFrame.jsp?method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+nodeids+"&complete="+complete;
				}
				url+="&viewScope=doing&numberType="+numberType+"&flowAll="+flowAll+"&flowNew="+flowNew+"&flowResponse="+flowResponse+"&flowOut="+flowOut;
				//alert(url);
				$(".flowFrame").attr("src",url);
	}