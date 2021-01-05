	/**
	 *	created by bpf in Oct,2013
	**/
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	
	/**
	 *	wuiform.init针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	
	
	flowPageManager.loadFunctions.leftNumMenu = function(){
		
		var	numberTypes={
				flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"新的客户"},
				flowAll:{hoverColor:"#A6A6A6",color:"black",title:"所有客户"}
				
		};
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:numberTypes,
			showZero:false,
			menuStyles:["menu_lv1",""],
			expand:{
				url:function(attr,level){
					return attr.urlSum;
				},
				done:function(children,attr,level){
					jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
					jQuery('#overFlowDiv').perfectScrollbar("update");
				}
			},
			clickFunction:function(attr,level,numberType){
				leftMenuClickFn(attr,level,numberType);
			}
		});
		var sumCount=0;
		$(".e8_level_2").each(function(){
			sumCount+=parseInt($(this).find(".e8_block:last").html());
		});
		//$(".leftType").append("("+sumCount+")");
	}
	
	function leftMenuClickFn(attr,level,numberType){
		var typeid="";
		if(level==1){
		   var mainTypeDiv=$("#overFlowDiv div[parentid="+attr.mainTypeId+"]").each(function(){
		   		typeid+=","+$(this).attr("subTypeId");
		   });
		   typeid=typeid.length>0?typeid.substring(1):"";
		}else{
		   typeid=attr.subTypeId;
		}
		
		var url = "";
		if(level == 2){
			url=menuUrl+"&mainTypeId="+attr.parentid+"&subTypeId="+attr.subTypeId;
		}else{
			url=menuUrl+"&mainTypeId="+attr.mainTypeId;
		}
		
		$(".flowFrame").attr("src",url);
		if(layout=="1")
		   showMenu();
	}
	
	
