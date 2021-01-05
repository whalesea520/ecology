var hiddenfield = "id,type,nodeid,nodenum"; //隐藏字段
var container;

function getParams(params){
  var _params = jQuery("#searchfrm").formSerialize();
  if(!!_params){
  	params=params+"&"+_params;
  }
  return params;
}

function onBtnSearchClick(){
		//缓存之前的内容
		container.hide();
		container = $("#e8_box_source_quick");
		container.show();
    var url = "ResourceSelectAjax.jsp";
    var params = "";
    //高级搜索 默认显示无账号人员
    jQuery("#currentPage").val(1);
		jQuery("#isNoAccount").val("1");
		jQuery("#isNoAccount",parent.document).val("1");
		jQuery("#imgisnoaccount").show();
		jQuery("#imgisnoaccount").parent().css("margin-top","5px");
		jQuery("#imgalllevel").hide();  
  	jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png");
  	var languageid=readCookie("languageidweaver");
  	jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
    params = getParams(params);
    params += "&btnsearch=1"
    ajaxHandler(url, params, initSource, "json", true);
    jsChangeAdvancedSearchDiv();
}
	
  function createOrRefreshScrollBar(div,option,scrolltop){
	 	//初始化滚动条
		if(!!option){
			if(scrolltop)container.find("#"+div).scrollTop(0); 
	   	container.find("#"+div).perfectScrollbar(option);
	  }else{
	   	container.find("#"+div).perfectScrollbar();
	  }
  }
    
  function init() {
    var url = "ResourceSelectAjax.jsp";
    var params = "";
    params = getParams(params);
    if(jQuery("#lsConditionField") && jQuery("#lsConditionField").val() == "1" && jQuery("#tabchange",parent.document).val()=="0"){
    }else{
		ajaxHandler(url, params, initSource, "json", true);
	}
  }
    
	function initSource(datas) {
  	var avgwidth = "150px";
    if(datas.length==0){
    	var languageid=readCookie("languageidweaver");
     	var tr = $("<tr height='32px'><td style='text-align: center;width=346px;'>"+SystemEnv.getHtmlNoteName(3546,languageid)+"<td></tr>");
    	container.find(".e8_box_source").empty().append(tr);
    	return;
    }
    container.find(".e8_box_source").empty();
   	var checkitem;
		for (var i = 0; i < datas.length; i++) {
     	 checkitem=$("<td style='width: 28px;display:none'></td>");
       tr = $("<tr height='32px'></tr>");
       tr.hover(function(){
       	jQuery(this).addClass("e8_hover_tr");
       },function(){
      	jQuery(this).removeClass("e8_hover_tr");
       }).removeClass("e8_hover_tr");

       tr.bind("click",function(e){
					var id = jQuery(this).find("input[name=id]").val();
					var name = jQuery(this).children("td:eq(2)").text();
					if(name && name.indexOf(',')) name = name.replace(/,/g,'，') ;
					//设置返回值并关闭
    			returnValue(dialog,window.parent.parent,id,name,1);
    			/*
					var returnjson = {'id':id,'name':name};	 
					if(dialog){
					try{
		          dialog.callback(returnjson);
		     }catch(e){}
		
					try{
					     dialog.close(returnjson);
					 }catch(e){}
					}else{
			    	window.parent.parent.returnValue = returnjson;
			    	window.parent.parent.close();
				 	}*/				 	
			 });
			 tr.append(checkitem);
       var dataitem = datas[i];
       var totalPage = 0;
       for (var item in dataitem) {
       	if(item=="totalPage"){
       		totalPage=dataitem[item];
       		continue;
       	}
       	if(item=="messagerurl"){
       		td = $("<td style='width:77px;max-width: 77px;padding-left:5px;'><img style='vertical-align:middle;' width='20px' src='" + dataitem[item] + "'></td>");
          tr.append(td);
       	}else if(item==="pinyinlastname"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
        }else if(hiddenfield.indexOf(item)>-1){
           checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
        }else if(item==="type"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
        }else if(item==="jobtitlename"){
            td = $("<td style='width:315px;max-width: 315px;color:#929390;'>" + dataitem[item] + "</td>");
            tr.append(td);
       	}else if(item==="lastname"){
            td = $("<td id='lastname' style='width:176px;max-width: 176px;'>" + dataitem[item] + "</td>");
            tr.append(td);
        }else{
           td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "'>" + dataitem[item] + "</td>");
           tr.append(td);
         }
       } 
       tr.disableSelection();       
     	 container.find(".e8_box_source").append(tr);
     }
     var extendBtn = container.find(".e8_box_source").find("button#extendBtn");
			var currentPage = parseInt(jQuery("#currentPage").val(),10);
	     var hasMore = true;
	     if(totalPage<=currentPage*30)hasMore=false;
			if(hasMore){
				if(extendBtn.length>0){
					extendBtn.html(SystemEnv.getHtmlNoteName(3520,readCookie("languageidweaver")).replace(/#\{count\}/g,30));
				}else{
					var tr = $("<tr class='moreBtn'></tr>");
					var td = $("<td style='text-align:center;width:100%;border:none;'colspan=4></td>");
					var extendBtn = $("<button type='button' id='extendBtn' class='extendBtn'></button>");
					extendBtn.html(SystemEnv.getHtmlNoteName(3520,readCookie("languageidweaver")).replace(/#\{count\}/g,30));
					extendBtn.bind("click",function(){
						var url = "ResourceSelectAjax.jsp";
		   			var params = "";
				    params = getParams(params);
				    var currentPage = parseInt(jQuery("#currentPage").val(),10);
				    currentPage++;
				    jQuery("#currentPage").val(currentPage);
				    var pageSize=currentPage*30;
				    params +="&pageSize="+pageSize;
				   	ajaxHandler(url, params, initSource, "json", true);
					});
					td.append(extendBtn);
					tr.append(td);
					container.find(".e8_box_source").append(tr);
				}
			}else{
				extendBtn.closest("tr.moreBtn").remove();
			}
  	createOrRefreshScrollBar("src_box_middle","update");
	}
   
   function jsShowSource(){
   	jQuery("#divMore").hide();
 		var url = "ResourceSelectAjax.jsp";
    jQuery("#lastname").val(jQuery("#flowTitle").val());
    var params = "";
    params = getParams(params);
    ajaxHandler(url, params, initSource, "json", true);
   }
  
  jQuery(document).ready(function(){
			$("label.overlabel").overlabel();
			container = jQuery("#e8_box_source_base");
			var tabid = jQuery("#tabid").val();
			if(tabid==3||tabid==4){
				//初始化树
				createTree();
			}else{
				init();
			}
			  jQuery("#imgalllevel").hide();   
			  if(tabid==2){
			  	jQuery("#imgalllevel").show();
			  	if(jQuery("#alllevel").val()==1){
        		jQuery("#imgalllevel").attr("src","/hrm/css/zTreeStyle/img/alllevelshow_wev8.png")
         	}else{
         		jQuery("#imgalllevel").attr("src","/hrm/css/zTreeStyle/img/alllevelhide_wev8.png")
         	}
			  }
			  if(tabid==0)jQuery("#imgisnoaccount").hide();
		  	if(jQuery("#isNoAccount").val()==1){
      		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png")
      		var languageid=readCookie("languageidweaver");
  				jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
       	}else{
       		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccounthide_wev8.png")
       		var languageid=readCookie("languageidweaver");
  				jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4063,languageid));
       	}
		 
        jQuery("#imgalllevel",window.document).bind("click",function(){   	
					jsChangeAllLevel();
       	});
      	jQuery("#imgisnoaccount",window.document).bind("click",function(){   
					jsChangeIsNoAccount();
       	});
       	
       	jQuery(".searchImg").bind("click",function(){ 
       		jsSourceSearch();
       	});
       	 
       	jQuery(".searchImg1").bind("click",function(){ 
       		jsTargetSearch();
       	});
       //初始化滚动条
       createOrRefreshScrollBar("src_box_middle");
       jQuery("#e8_box_source_quick").find("#src_box_middle").perfectScrollbar();
   })
   
   
   function onSearchFocus(){
   		if(jQuery("#flowTitle").val()==""){
	     	//缓存之前的内容
   			container.hide();
   			container = $("#e8_box_source_quick");
   			container.show();
	    	jQuery("#imgalllevel").hide();
	    	jQuery("#imgisnoaccount").parent().css("margin-top","5px");
    	}
   }
function resetHrmCondition(){
	selector="#advancedSearchDiv";
	//清空文本框
	jQuery(selector).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	/*try{
		jQuery(selector).find("select").selectbox("reset");
	}catch(e){
		jQuery(selector).find("select").each(function(){
			var $target = jQuery(this);
			var _defaultValue = $target.attr("_defaultValue");
			if(!_defaultValue){
				var option = $target.find("option:first");
				_defaultValue = option.attr("value");
			}
			$target.val(_defaultValue).trigger("change");
		});
	}*/
	//清空日期
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find(".Calendar").siblings("span").html("");
	jQuery(selector).find(".Calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find("input[type='checkbox']").each(function(){
		try{
			changeCheckboxStatus(this,false);
		}catch(e){
			this.checked = false;
		}
	});
}
   function onSearchFocusLost(){
   		if(jQuery("#flowTitle").val()==""){
   			//还原缓存内容
    		jQuery(".magic-line",parent.document).show();
   			jQuery("#tabId"+jQuery("#oldtabid").val(),parent.document).parent().addClass("current");
				jQuery("#tabId"+jQuery("#oldtabid").val(),parent.document).parent().focus();
				jQuery("#tabid").val(jQuery("#oldtabid").val());
				container.find(".e8_box_source").empty();
				container.hide();
				container = $("#e8_box_source_base");
				container.show();
				if(jQuery("#tabvirtualtype")&&(jQuery("#tabid").val()==1||jQuery("#tabid").val()==2||jQuery("#tabid").val()==3)){
					jQuery("#imgisnoaccount").parent().css("margin-top","35px");
				}else{
					jQuery("#imgisnoaccount").parent().css("margin-top","5px");
				}
   		}
   }
   var timeout = null;
   function jsSourceSearch(){
   		clearTimeout(timeout);
 			timeout = setTimeout(function(){
	      //清空高级搜索条件
	      resetHrmCondition();
	      jQuery("#divMore").hide();
	      jQuery("#lastname").val(jQuery("#flowTitle").val());
				jQuery("#imgalllevel").hide();
				jQuery("#imgisnoaccount").show();
	  		if(jQuery("#isNoAccount").val()==1){
	    		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png")
	    		var languageid=readCookie("languageidweaver");
  				jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
	     	}else{
	     		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccounthide_wev8.png")
	     		var languageid=readCookie("languageidweaver");
       		jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4063,languageid));
	     	}
	     	if(jQuery("#advancedSearchDiv").is(":visible"))jsChangeAdvancedSearchDiv();
	     	
	   		jQuery(".magic-line",parent.document).hide();
	   		jQuery(".current",parent.document).removeClass("current");
	   		if(jQuery("#tabid").val()!=-1)jQuery("#oldtabid").val(jQuery("#tabid").val());
	   		jQuery("#tabid").val("-1"); //组合查询
	   		if(jQuery("#tabid").val()==0)jQuery("#imgisnoaccount").hide();
	   		var url = "ResourceSelectAjax.jsp";
				var params = "";
				//jQuery("#status").val("8");
	      params = getParams(params);
		    ajaxHandler(url, params, initSource, "json", true);
		    if($("#flowTitle").val()=="")$("label[for='flowTitle']").show();
	    },400);
   }
   
   function jsChangeAdvancedSearchDiv(){
 		if(jQuery("#tabid").val()!=-1)jQuery("#oldtabid").val(jQuery("#tabid").val());
 		jQuery("#tabid").val("-1"); //组合查询
   	if(jQuery("#advancedSearchDiv").is(":hidden")){
   	 	jQuery(".magic-line",parent.document).hide();
 			jQuery(".current",parent.document).removeClass("current");
   		jQuery("#advancedSearchDiv").show();
   		jQuery("#hshadowAdvancedSearchOuterDiv").show();
   	}else{
   	  jQuery("#tabId"+jQuery("#oldtabid").val(),parent.document).parent().addClass("current");
			jQuery("#tabId"+jQuery("#oldtabid").val(),parent.document).parent().focus();
   		jQuery("#advancedSearchDiv").hide();
   		jQuery("#hshadowAdvancedSearchOuterDiv").hide();
   	}
   }
   
   function jsCheckIsNoAccount(){
   	changeCheckboxStatus(jQuery("#isNoAccount")[0],true);
   }
   
   function jsOK(){
		
		//设置返回值并关闭
    returnValue(dialog,window.parent.parent,ids,names,1);
   }
   
   function jsClear(){
		//设置返回值并关闭
    	returnValue(dialog,window.parent.parent,"","",1);
   }
   
   function jsCancel(){
    	//设置返回值并关闭
		returnValue(dialog,window.parent.parent,"","",0);
   }

		var cxtree_id = "";
		var virtualtype = "";	
		//zTree配置信息
		var setting = {
			async: {
				enable: true,       //启用异步加载
				dataType: "text",   //ajax数据类型
				url: getAsyncUrl    //ajax的url
			},
			check: {
				enable: true,       //启用checkbox或者radio
				chkStyle: "checkbox",  //check类型为radio
				radioType: "all",   //radio选择范围
				chkboxType: { "Y" : "", "N" : "" } 
			},
			view: {
				expandSpeed: "",   //效果
				fontCss: getFont,
				showTitle: false,
				nameIsHTML: true,
				showLine: false,
				dblClickExpand: false
			},
			callback: {
				onClick: zTreeOnClick,   //节点点击事件
				onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			}
		};

	function changeVirtualType(){
		var tabid = jQuery("#tabid").val();
	  if(tabid==1){
			var url = "ResourceSelectAjax.jsp";
      var params = "";
      params = getParams(params);
	    ajaxHandler(url, params, initSource, "json", true);
		}else if(tabid==2){
			jsChangeManagerSel();
		}else	if(tabid==3||tabid==4){
			jQuery.fn.zTree.init($("#treeDemo"), setting);
		}
		
	}
	
	  function getFont(treeId, node) {
			return node.font ? node.font : {};
		}
		/**
		 * 获取url（alax方式获得子节点时使用）
		 */
		function getAsyncUrl(treeId, treeNode) {
			var sqlwhere = jQuery("#sqlwhere").val();
		  var selectedids = jQuery("#selectedids").val();
		 	var alllevel = jQuery("#alllevel").val();
			var tabid = jQuery("#tabid").val();
			var isNoAccount = jQuery("#isNoAccount").val();
			var virtualtype = jQuery("#virtualtype").val();
			var	f_weaver_belongto_userid = jQuery("#f_weaver_belongto_userid").val();
			var f_weaver_belongto_usertype = jQuery("#f_weaver_belongto_usertype").val();
			if(tabid==3){
				//获取子节点时
				if(virtualtype!=""&&virtualtype!="1"){
					//获取子节点时
			   if (treeNode && treeNode.isParent) {
			    	return "/hrm/resource/hrmtreeVirtualXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&sqlwhere="+sqlwhere + "&selectedids="+selectedids +"&id=" + treeNode.id + "&type="+treeNode.type+"&alllevel=" +alllevel+"&isNoAccount=" +isNoAccount+"&" + new Date().getTime() + "=" + new Date().getTime();
			    } else {
			    	//初始化时
			    	return "/hrm/resource/hrmtreeVirtualXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&sqlwhere="+sqlwhere + "&selectedids="+selectedids +"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+ "&" + new Date().getTime() + "=" + new Date().getTime();
			    }
				}else{
					//获取子节点时
			    if (treeNode && treeNode.isParent) {
			    	return "/hrm/resource/hrmtreeXML.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&virtualtype="+ virtualtype +"&sqlwhere="+sqlwhere + "&selectedids="+selectedids +"&id=" + treeNode.id + "&type="+treeNode.type+"&alllevel=" +alllevel+"&isNoAccount=" +isNoAccount+"&"+ new Date().getTime() + "=" + new Date().getTime();
			    } else {
			    	//初始化时
			    	return "/hrm/resource/hrmtreeXML.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&virtualtype="+ virtualtype +"&sqlwhere="+sqlwhere + "&selectedids="+selectedids+"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+ "&" + new Date().getTime() + "=" + new Date().getTime();
			    }
		    }
	    }else if(tabid==4){
	    	//获取子节点时
		    if (treeNode && treeNode.isParent) {
		    	return "/hrm/resource/hrmtreeGroupXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&id="+treeNode.id +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&virtualtype="+ virtualtype +"&sqlwhere="+sqlwhere +"&selectedids="+selectedids+"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
		    } else {
		    	//初始化时
		    	return "/hrm/resource/hrmtreeGroupXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&sqlwhere="+sqlwhere+"&selectedids="+selectedids +"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+"&" + new Date().getTime() + "=" + new Date().getTime();
		    }
	    }
		};

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var virtualtype = jQuery(".selDemo").val();
	 	
		if(!treeNode){
			if(virtualtype){
				treeNode=treeObj.getNodeByParam("nodeid","com_"+virtualtype, null);
			}else{
				treeNode=treeObj.getNodeByParam("id", 1, null);
			}
			createOrRefreshScrollBar("src_box_middle","update",true);
		}
		treeNodeDisabled();
		if(!treeNode)return;
		if(treeNode.getCheckStatus()){
	  var halfCheck = treeNode.getCheckStatus();
			if(halfCheck.half){
				treeObj.checkNode(treeNode, true, true);
			}
		}
		//节点没有下级变灰
 		var childNodes;
 		if(treeNode.type=="com"){

 			childNodes = treeObj.transformToArray(treeObj.getNodes());
 		}else{
 			childNodes = treeObj.transformToArray(treeNode); 
 		}
 		
		for(var i=0;childNodes!=null&&i<childNodes.length;i++){
			var node = childNodes[i];
			if(!node.isParent && node.type!="resource"){
      	if(node){
		 			$("#" + node.tId + "_span").attr('style','color : #888888');
		 			if(node.type=="subcom")
		 				$("#" + node.tId + "_ico").attr('style','background : url(/images/treeimages/Home-_wev8.gif) 0 0 no-repeat');
		 			else
		 				$("#" + node.tId + "_ico").attr('style','background : url(/images/treeimages/subCopany_Colse-_wev8.gif) 0 0 no-repeat');
	 			}
			}
		}
	}
	
	function treeNodeDisabled(){ 
    //更新selectedids
    var workflow = jQuery("#workflow").val();
    if(workflow!=1)return;
    var tabid = jQuery("#tabid").val();
    selectitems = container.find("input[type='checkbox'][name='destitem']");
    if(selectitems){
	    for (var i = 0; i < selectitems.length; i++) {
	    	var type = $(selectitems[i]).parent().parent().find("input[name='type']").val();
	      //节点已选变灰
	      if((tabid==3||tabid==4)&&type!="resource"){
	      	var nodeid = $(selectitems[i]).parent().parent().find("input[name='nodeid']").val();
	      	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	      	var treeNode = treeObj.getNodeByParam("nodeid", nodeid, null);
	      	if(treeNode){
			 			$("#" + treeNode.tId + "_span").attr('style','color : #888888');
			 			if(type=="subcom")
			 				$("#" + treeNode.tId + "_ico").attr('style','background : url(/images/treeimages/Home-_wev8.gif) 0 0 no-repeat');
			 			else
			 				$("#" + treeNode.tId + "_ico").attr('style','background : url(/images/treeimages/subCopany_Colse-_wev8.gif) 0 0 no-repeat');
		 			}
		 		}
	    }	    
    }
	}
		
	function createTree(){
	 $.fn.zTree.init($("#treeDemo"), setting); 	
	}
		
	function zTreeOnClick(event, treeId, treeNode) {
		var avgwidth = "112px";
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var nodeid = treeNode.nodeid;
		if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		if (treeNode.type != "resource") return;
		var id = treeNode.id;
		jQuery("#tmpTitle").empty().html(treeNode.name);
		var name = jQuery("#tmpTitle").find("#lastname").html();
		//设置返回值并关闭
    returnValue(dialog,window.parent.parent,id,name,1);
    /*
		var returnjson = {
			'id' : id,
			'name' : name
		};
		if (dialog) {
			try {
				dialog.callback(returnjson);
			} catch (e) {
			}
	
			try {
				dialog.close(returnjson);
			} catch (e) {
			}
		} else {
			window.parent.parent.returnValue = returnjson;
			window.parent.parent.close();
		}
		*/
	};
		
	function jsSubcompanyCallback(e,datas, name){
		if (datas && datas.id!=""){
			_writeBackData('departmentid','1',{'id':'','name':''});
		}
	}
		function jsDepartmentCallback(e,datas, name){
			if(datas && datas.id!="") {
				_writeBackData('subcompanyid','1',{'id':'','name':''});
				_writeBackData('jobtitle','1',{'id':'','name':''});
			}   
		}
		function jsChangeIsNoAccount(){
			jQuery("#currentPage").val(1);
			if(jQuery("#isNoAccount").val()==1){
		    jQuery("#isNoAccount",parent.document).val("0");
		    jQuery("#isNoAccount").val("0");
		    jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccounthide_wev8.png")
		    var languageid=readCookie("languageidweaver");
       	jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4063,languageid));
		  }else{
		 	 	jQuery("#isNoAccount",parent.document).val("1");
		 	 	jQuery("#isNoAccount").val("1");
		 	 	jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png")
		 	 	var languageid=readCookie("languageidweaver");
  			jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
		  }
		  if(jQuery("#tabid").val()=="-1"){
		  	var url = "ResourceSelectAjax.jsp";
	      var params = "";
	      params = getParams(params);
		    ajaxHandler(url, params, initSource, "json", true);
		  }else{
		  	//刷新页面
		  	//parent.resetbanner(jQuery("#tabid").val());
		  	changeVirtualType();
		  }
		}
		
		function jsChangeAllLevel(){
			if(jQuery("#alllevel").val()==1){
		    jQuery("#alllevel",parent.document).val("0");
		    jQuery("#alllevel").val("0");
		    jQuery("#imgalllevel").attr("src","/hrm/css/zTreeStyle/img/alllevelhide_wev8.png")
		  }else{
		 	 	jQuery("#alllevel",parent.document).val("1");
		 	 	jQuery("#alllevel").val("1");
		 	 	jQuery("#imgalllevel").attr("src","/hrm/css/zTreeStyle/img/alllevelshow_wev8.png")
		  }
		  //刷新页面
		  changeVirtualType();
		}

function jsChangeManagerSel(){
	var virtualtype = jQuery("#virtualtype").val();
	//jQuery("#cmd").val("getManagerResource");
  var url = "ResourceSelectAjax.jsp";
  var params = "";
  params = getParams(params);
  ajaxHandler(url, params, initSource, "json", true);
}

function jsChangelastname(){
	jQuery("#flowTitle").val(jQuery("#lastname").val());
	if(jQuery("#flowTitle").val()!="")
		$("label[for='flowTitle']").hide();
	else
		$("label[for='flowTitle']").show();
}



//设置浏览按钮返回值 兼容老式的弹出窗口及chrome37+
function returnValue(dialog,opWin,ids,names,type){
	if(ids.length>0){
  	var url = "saveSelectAjax.jsp";
  	var params = "ids="+ids;
  	ajaxHandler(url, params, null, "json", true);
  }
	try {
		if (dialog) {
			//E8弹出窗口模式
			
			if(type==1){
				//设置值
				try {
					dialog.callback({
						id : ids,
						name : names
					});
				} catch (e) {
				}
				//关闭
				try {
					dialog.close({
						id : ids,
						name : names
					});
				} catch (e) {
				}
			}else{
				//关闭
				try {
					dialog.close();
				} catch (e) {
				}
			}
			
		} else {
			//老式弹出窗口操作
			doSetValue(opWin,ids,names,type);
		}
	} catch (e) {
		//老式弹出窗口操作
		doSetValue(opWin,ids,names,type);
	}
}
function doSetValue(opWin,ids,names,type){
	/**
	var opWin = window.parent;
	if (config.parentWin)
		opWin = config.parentWin;
	*/
	try {
		//chrome37+ 处理
		var dialogflag = (typeof (systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
		dialogflag = (dialogflag || systemshowModalDialog);
		
		//设置值
		if(type==1){
			if (dialogflag) {
				try {
					opWin.opener.dialogReturnValue = {
						id : ids,
						name : names
					};
				} catch (_96e) {
				}
			}
			opWin.returnValue = {
				id : ids,
				name : names
			};
		}
		//关闭
		if (dialogflag) {
			try {
				opWin.opener.closeHandle();
			} catch (_96e) {
			}
		}
		opWin.close();
	} catch (e) {
		//设置值
		if (type == 1) {
			opWin.returnValue = {
				id : ids,
				name : names
			};
		}
		//关闭
		opWin.close();
	}
}