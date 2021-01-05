var hiddenfield = "id,type,nodeid,nodenum"; //隐藏字段
var selectednodeflag = false;

function getParams(params){
  var _params = jQuery("#searchfrm").formSerialize();
  if(!!_params){
  	params=params+"&"+_params;
  }
  return params;
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

function resetCondtionbak() {
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
}

function onBtnSearchClick(){
		jQuery("#tabTypeOption").hide();
    var url = "MutilResourceSelectAjax.jsp";
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
	  //jQuery(".multiHeight").css("height","135px");
	  //jQuery("#src_box_middle").css("height","461px");
  	E8EXCEPTHEIGHT =0;
  	expandZH();
   	jQuery("#multiArrowTo").show();
    params = getParams(params);
    params += "&btnsearch=1"
    ajaxHandler(url, params, initSource, "json", true);
    jsChangeAdvancedSearchDiv();
	}
	
  function createOrRefreshScrollBar(div,option,scrolltop){
	 	//初始化滚动条
		if(!!option){
	   	if(scrolltop)jQuery("#"+div,window.document).scrollTop(0); 
	   	jQuery("#"+div,window.document).perfectScrollbar(option);
	  }else{
	   	jQuery("#"+div,window.document).perfectScrollbar();
	  }
	  jQuery("#dest_box_middle").scrollTop(jQuery("#e8_dest_table").height());
  }
    
  function init() {
    var url = "MutilResourceSelectAjax.jsp";
    var params = "";
    params = getParams(params);
   	if(jQuery("#lsConditionField") && jQuery("#lsConditionField").val() == "1" && jQuery("#tabchange",parent.document).val()=="0"){
    }else{
		ajaxHandler(url, params, initSource, "json", true);
    }
  	url = "MutilResourceSelectAjax.jsp?src=dest";
  	ajaxHandler(url, params, initTarget, "json", true);
  }
    
	function initSource(datas) {
  	var avgwidth = "150px";
  	var container = $("#colShow");
  	jQuery("#src_box_middle").empty().html("<table class='e8_box_source' style='border-collapse: collapse;width: 100%'><tbody></tbody></table>");
    container.find(".e8_box_source").html("");
    if(datas.length==0){
    	var languageid=readCookie("languageidweaver");
     	var tr = $("<tr height='32px'><td style='text-align: center;width=346px;'>"+SystemEnv.getHtmlNoteName(3546,languageid)+"<td></tr>");
    	container.find(".e8_box_source").append(tr);
    	return;
    }
   	var checkitem;
		for (var i = 0; i < datas.length; i++) {
     	checkitem=$("<td style='width: 28px;display:none'></td>");
       checkitem.append($("<input name='srcitem' type='checkbox' style='margin-left: 7px'>"));
       tr = $("<tr height='32px'></tr>");
       tr.hover(function(){
       	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
       },function(){
      	jQuery(this).removeClass("e8_hover_tr");
       }).removeClass("e8_hover_tr");
       tr.bind("mousedown",function(e){
       		jQuery('#mousedown').val(1);
       });
       tr.bind("mouseup",function(e){
       		jQuery('#mousedown').val(0);
       });
       tr.bind("mouseover",function(e){
       	if(jQuery('#mousedown').val()==1){
       		if(!jQuery(this).find("input[type='checkbox']").attr("checked")){
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
						jsBtnChange();
					}
				}
       });
       tr.bind("dblclick",function(e){
				jQuery(this).find("input[type='checkbox']").attr("checked",true);
				jQuery("#singleArrowTo").trigger("click");
				jsBtnChange();
			 });
			 tr.bind("click",function(e){
			 	if(!e.ctrlKey){
			 		var selectitems = container.find("input[name='srcitem']:checked");
			 		if(selectitems!=null){
						for (var j = 0; j < selectitems.length; j++) {
							$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
							jQuery(selectitems[j]).attr("checked",false);
						}
					}
			 	}
			 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
				 	jQuery(this).removeClass("e8_select_tr");
					jQuery(this).find("input[type='checkbox']").attr("checked",false);
				}else{
					jQuery(this).addClass("e8_select_tr");
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
				}
				jsBtnChange();
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
       		td = $("<td style='width:30px;max-width: 30px;padding-left:5px;'><img style='vertical-align:middle;' width='20px' src='" + dataitem[item] + "'></td>");
           tr.append(td);
       	}else if(item==="pinyinlastname"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
        }else if(hiddenfield.indexOf(item)>-1){
           checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
        }else if(item==="type"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
        }else if(item==="jobtitlename"){
            td = $("<td style='width:144px;max-width: 144px;color:#929390;'>" + dataitem[item] + "</td>");
            tr.append(td);
       	}else if(item==="lastname"){
            td = $("<td style='width:80px;max-width: 80px;'>" + dataitem[item] + "</td>");
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
						var url = "MutilResourceSelectAjax.jsp";
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
  	jsBtnChange();
	}
   
   function jsShowSource(){
   	var container = $("#colShow");
 		var url = "MutilResourceSelectAjax.jsp";
    jQuery("#lastname").val(jQuery("#flowTitle").val());
    var params = "";
    params = getParams(params);
    jQuery("#src_box_middle").perfectScrollbar("destroy");
    ajaxHandler(url, params, initSource, "json", true);
   }
   
   function initTarget(datas){
   		var avgwidth = "112px";
	  	var container = $("#colShow");
	    container.find(".e8_box_target").html("");
      var checkitem;
			for (var i = 0; i < datas.length; i++) {
      	checkitem=$("<td style='width: 28px;display:none;'></td>");
        checkitem.append($("<input name='destitem' type='checkbox' style='margin-left: 7px'>"));
        tr = $("<tr height='32px'></tr>");
        tr.hover(function(){
        	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
        },function(){
        	jQuery(this).removeClass("e8_hover_tr");
        }).removeClass("e8_hover_tr");
        tr.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowFrom").trigger("click");
					jsBtnChange();
				});
				tr.bind("click",function(e){
					if(!e.ctrlKey){
				 		var selectitems = container.find("input[name='destitem']:checked");
						if(selectitems!=null){
							for (var j = 0; j < selectitems.length; j++) {
								$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
								jQuery(selectitems[j]).attr("checked",false);
							}
						}
				 	}
				 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
					 	jQuery(this).removeClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",false);
					}else{
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
					}
					jsBtnChange();
			 	});
				tr.append(checkitem);
        var dataitem = datas[i];

        if(dataitem["type"]!="resource")avgwidth="224px";
        for (var item in dataitem) {
        	if(item=="messagerurl"){
        		td = $("<td style='width:30px;max-width: 30px;padding-left:5px;'><img style='vertical-align:middle;' width='20px' src='" + dataitem[item] + "'></td>");
            tr.append(td);
        	}else if(item==="pinyinlastname"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          }else if(hiddenfield.indexOf(item)>-1){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          }else if(item==="jobtitlename"){
            td = $("<td style='width:144px;max-width: 144px;color:#929390;'>" + dataitem[item] + "</td>");
            tr.append(td);
	       	}else if(item==="lastname"){
            td = $("<td style='width:80px;max-width: 80px;'>" + dataitem[item] + "</td>");
            tr.append(td);
	        }else{
            if(dataitem["type"]=="resource"){
		      		td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "'>" + dataitem[item] + "</td>");
		      	}else
		      		td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "' colspan='2'>" + dataitem[item] + "</td>");	
            tr.append(td);
          }
        }
                
      	container.find(".e8_box_target").append(tr);
      }		
      
      createOrRefreshScrollBar("src_box_middle","update");
      //更新已选人数
      updateParam();
   }
  
 	function joinDataTarget(datas){
  	var container = $("#colShow");
	var repeatObj = {} ;
  	var avgwidth = "112px";
		var target = container.find(".e8_box_target");
		var selectedids = jQuery("#selectedids").val();
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
 		for (var i = 0; i < datas.length; i++) {
 		  var dataitem = datas[i];
 		  //隐藏
 		  if(treeObj){
 		   	var nodeid = dataitem["nodeid"];
 		  	var node = treeObj.getNodeByParam("nodeid", nodeid, null);
 		  	var type = dataitem["type"];
 		   	if(type=="resource"){
				
				if($("#tabid").val() == 4){
					var treeNodeArr = treeObj.getNodesByParam("nodeid", nodeid, null);
					for(var tx=0;tx<treeNodeArr.length;tx++) treeObj.hideNode(treeNodeArr[tx]);
				}else{
					treeObj.hideNode(node);
				}
			}
 		  }
			if((","+selectedids+",").indexOf((","+dataitem["id"]+","))!=-1)continue;
			if(repeatObj['id_'+dataitem["id"]]) continue ;
			repeatObj['id_'+dataitem["id"]] = true ;
    	checkitem=$("<td style='width: 28px;display:none'></td>");
      checkitem.append($("<input name='destitem' type='checkbox' style='margin-left: 7px'>"));
      tr = $("<tr height='32px'></tr>");
      tr.hover(function(){
      	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
      },function(){
      	jQuery(this).removeClass("e8_hover_tr");
      }).removeClass("e8_hover_tr");
      tr.bind("dblclick",function(e){
			jQuery(this).find("input[type='checkbox']").attr("checked",true);
			jQuery("#singleArrowFrom").trigger("click");
			jsBtnChange();
		});
		tr.bind("click",function(e){
			if(!e.ctrlKey){
		 		var selectitems = container.find("input[name='destitem']:checked");
				if(selectitems!=null){
					for (var j = 0; j < selectitems.length; j++) {
						$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
						jQuery(selectitems[j]).attr("checked",false);
					}
				}
			}
		 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
			 	jQuery(this).removeClass("e8_select_tr");
				jQuery(this).find("input[type='checkbox']").attr("checked",false);
			}else{
				jQuery(this).addClass("e8_select_tr");
				jQuery(this).find("input[type='checkbox']").attr("checked",true);
			}
			jsBtnChange();
		 });
		tr.append(checkitem);

    for (var item in dataitem) {
    	if(item=="messagerurl"){
    		td = $("<td style='width:30px;max-width: 30px;padding-left:5px;'><img style='vertical-align:middle;' width='20px' src='" + dataitem[item] + "'></td>");
        tr.append(td);
    	}else if(item==="pinyinlastname"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
      }else if(hiddenfield.indexOf(item)>-1){
        checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
      }else if(item==="pinyinlastname"){
        checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
      }else if(item==="jobtitlename"){
         td = $("<td style='width:144px;max-width: 144px;color:#929390;'>" + dataitem[item] + "</td>");
         tr.append(td);
    	}else if(item==="lastname"){
         td = $("<td style='width:80px;max-width: 80px;'>" + dataitem[item] + "</td>");
         tr.append(td);
     	}else{
      	if(dataitem["type"]=="resource")
      		td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "'>" + dataitem[item] + "</td>");
      	else
      		td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "' colspan='2'>" + dataitem[item] + "</td>");	
        tr.append(td);
      }
    }
   		target.append(tr);
   	}
		//更新已选人数
		updateParam();
  }
  
	function joinTarget(isAll){
		var avgwidth = "112px";
		var container = $("#colShow");
		var selectitems = container.find("input[name='srcitem']");
		var tabid = $("#tabid").val();
		if(tabid==3||tabid==4){
			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
			var nodes = null;
			if(isAll){
				var params = "";
				url = "MutilResourceSelectAjax.jsp";
	      if(tabid==3){
	      	var virtualtype = jQuery("#virtualtype").val();
	      	jQuery("#cmd").val("getComDeptResource")
	      	if(virtualtype<-1)jQuery("#cmd").val("getComDeptResourceVirtual")
	      	params += getParams(params);
	      	params +="&comdeptnodeids=com_"+virtualtype
				}else{
					jQuery("#cmd").val("getGroupResource")
					params = getParams(params);
					params +="&comdeptnodeids=-1"
				}
	   		ajaxHandler(url, params, initTarget, "json", true);
			}else{
				nodes = treeObj.getCheckedNodes(true);
			}
			if(!nodes||nodes.length==0)return;
			var comdeptnodeids = "";
			for (var j=0, l=nodes.length; j<l; j++) {
				var treeNode = nodes[j];
				var id = treeNode.id;
				var type = treeNode.type;
				var nodeid = treeNode.nodeid;
				if(type=="resource")continue;
				if(treeNode.getParentNode()==null||treeNode.getParentNode().length==0)continue;
				$("#" + treeNode.tId+"_a").attr('style','background-color : #ffffff');
				//var halfCheck = node.getCheckStatus();
				//if(halfCheck.half)continue;
	
				//处理分部部门节点
				if(jQuery("#workflow").val()==1){
					//来自工作流
					var name = treeNode.name;
					var messagerurl = treeNode.icon;
					if(type=="subcom"){
						messagerurl = "/images/treeimages/Home1_wev8.gif";
					}else if(type=="dept"||type=="group"){
						messagerurl = "/images/treeimages/subCopany_Colse1_wev8.gif";
					}
		 			var selectedids = jQuery("#selectedids").val();
				 	//如果已选择 不能再选
					var tmpid = selectedids+',';
					if(tmpid.indexOf(nodeid+',')!=-1)return;
			
		     	var checkitem;
		     	selectednodeflag=false;
   		   	var selectednodeids = jQuery("#e8_dest_table").find("input[name=nodeid]");
	   		  checkAllParents(treeNode,selectednodeids)
	   			if(selectednodeflag) return;
   			
	   			var cmd = "getComDeptResourceNum";
	   			var nodeids = nodeid;
	   		  if(type=="group"){
	   		  	nodeids = id;
	   		  	//私人组不能被选择
	   		  	if(id==-1 || id==-2 || id==-3 || (id!=-3&&treeNode.getParentNode().id==-3)){
	   		  		zTreeOnDblClick(null, null, treeNode);
	   		  		continue;
	   		  	} 
	   		  	cmd = "getGroupResourceNum";	
	   		  }
   		  	var nodenum = 0;
	   			jQuery.ajax({
						url:"MutilResourceSelectAjax.jsp",
						type:"POST",
						dataType:"json",
						async:true,
						data:{
							cmd:cmd,
							nodeids:nodeids,
							f_weaver_belongto_userid:jQuery("#f_weaver_belongto_userid").val(),
							f_weaver_belongto_usertype:jQuery("#f_weaver_belongto_usertype").val(),
							alllevel:jQuery("#alllevel").val(),
							isNoAccount:jQuery("#isNoAccount").val(),
							sqlwhere:jQuery("#sqlwhere").val()
						},
						success:function(data){
							nodenum=data.num;
							name+="("+data.num+")";
							if(nodenum==0)return;
							var json={"messagerurl":messagerurl,"id":id,"name":name,"type":type,"nodeid":nodeid,"nodenum":nodenum};
				      var jsonArr = new Array();
				      jsonArr[0]=json;
				      datas = jsonArr;
		     
							joinDataTarget(datas);
						}
					});
				}else{
					if(comdeptnodeids.length>0)comdeptnodeids+=",";
					if(type=="group")
						comdeptnodeids+=id;
					else
						comdeptnodeids+=nodeid;	
				}
			}
			if(comdeptnodeids.length>0){
				var url = "";
				var cmd = "getComDeptResource";
				if(tabid == 3){
					var virtualtype = jQuery("#virtualtype").val();
					url = "MutilResourceSelectAjax.jsp";
					if(virtualtype<-1)cmd = "getComDeptResourceVirtual"
				}else{
					url = "hrmtreeGroupXML.jsp";
				}
				jQuery.ajax({
					url:url,
					type:"POST",
					dataType:"json",
					async:true,
					data:{
						cmd:cmd,
						comdeptnodeids:comdeptnodeids,
						alllevel:jQuery("#alllevel").val(),
						selectedids:jQuery("#selectedids").val(),
						f_weaver_belongto_userid:jQuery("#f_weaver_belongto_userid").val(),
						f_weaver_belongto_usertype:jQuery("#f_weaver_belongto_usertype").val(),
						isNoAccount:jQuery("#isNoAccount").val(),
						sqlwhere:jQuery("#sqlwhere").val()
					},
					success:function(datas){
						joinDataTarget(datas);
					}
				});
			}
			for (var j=0, l=nodes.length; j<l; j++) {
				var node = nodes[j];
				var nodeid = node.nodeid;
				var nodetype = node.type;
				if(nodetype!="resource"){
				}else{
			  	var resourceid = node.id;	
			   	jQuery("#tmpTitle").empty().append(jQuery(node.name));
			   	var lastname = jQuery("#tmpTitle").find("#lastname").html();
			   	var pinyinlastname = jQuery("#tmpTitle").find("#pinyinlastname").html();
			   	var jobtitlename = jQuery("#tmpTitle").find("#jobtitlename").html();
			   	var messagerurl = node.icon;
			   	var container = $("#colShow");
				 	var target = container.find(".e8_box_target");
		     	var checkitem;
		     	
		     	var json={"messagerurl":messagerurl,"id":resourceid,"type":"resource","lastname":lastname,"pinyinlastname":pinyinlastname,"jobtitlename":jobtitlename,"nodeid":nodeid};
		      var jsonArr = new Array();
		      jsonArr[0]=json;
		      datas = jsonArr;
		      
		  	 	//var datas="[{messagerurl:'"+messagerurl+"',id:'"+resourceid+"',lastname:'"+lastname+"',pinyinlastname:'aaaa',jobtitlename:'"+jobtitlename+"',nodeid:'"+nodeid+"'}]";
		  	 	//datas = eval(datas);
				 	
				 	joinDataTarget(datas) ;
				if(tabid == 4){
					var hdNodeid = node.nodeid ;
					var treeNodeArr = treeObj.getNodesByParam("nodeid", hdNodeid, null);
					for(var tx=0;tx<treeNodeArr.length;tx++) treeObj.hideNode(treeNodeArr[tx]);
				}else{
					treeObj.hideNode(node);
				}
				
			   	//更新已选人数
					updateParam();
				}
			}
		}else{
			var target = container.find(".e8_box_target");
	    var clone;
	    var array=[];
	    /**
	     * 保存数据
	     * @param data
	     */
	    function  saveItems(data)
	    {
	        var rs=data;
	        if(rs.result==="1")
	        {
	           for(var i=0;i<array.length;i++)
	           {
	               target.append(array[i]);
	           }
	
	        }else
	        {
	        	var languageid=readCookie("languageidweaver");
	          top.Dialog.alert(SystemEnv.getHtmlNoteName(3521,languageid)+"!!!");
	        }
	
	    }
		  
		  var selectitems = [];
	    if(isAll){
	    	selectitems = container.find("input[name='srcitem']");
	    }else{
	    	selectitems = container.find("input[name='srcitem']:checked");
	    }
		        
			for (var i = 0; i < selectitems.length; i++) {
	    	clone = $(selectitems[i]).parent().parent().clone();
	     	clone.find("input").attr("class", "e8_box_desitem");
				clone.removeClass("e8_hover_tr");
				clone.removeClass("e8_select_tr");
				clone.hover(function(e){
					if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
				},function(e){
					jQuery(this).removeClass("e8_hover_tr");
				});
				clone.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowFrom").trigger("click");
					jsBtnChange();
				}).disableSelection();  
				clone.bind("click",function(e){
					if(!e.ctrlKey){
				 		var selectitems = container.find("input[name='destitem']:checked");
				 		if(selectitems!=null){
							for (var j = 0; j < selectitems.length; j++) {
								$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
								jQuery(selectitems[j]).attr("checked",false);
							}
						}
					}
				 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
					 	jQuery(this).removeClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",false);
					}else{
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
					}
					jsBtnChange();
				});   
	      clone.find("input[type=checkbox]").attr("name", "destitem");
	      clone.find("input").removeAttr("checked");
	      array.push(clone);
	      $(selectitems[i]).parent().parent().remove();
	  	}
	    var data = {};
	    data.result = "1";
	    saveItems(data);
	    //更新已选人数
	    updateParam();
		}
		
	}       
  
 	function delTarget(isAll){
 		var container = $("#colShow");
 		var srctitems=$("#colShow").find(".e8_box_source").find("input[type='checkbox'][name='srcitem']");
	  //if(srctitems.length ==0 )$("#colShow").find(".e8_box_source").html("");	
		var target = container.find(".e8_box_target");
 		var source = container.find(".e8_box_source");
    	var checkeditems = [];
    	if(isAll){
    		checkeditems=container.find(".e8_box_target").find("input[type='checkbox'][name='destitem']");
    	}else{
    		checkeditems=container.find(".e8_box_target").find("input[type='checkbox'][name='destitem']:checked");
    	}
    	if(checkeditems.length==0)return;
      var ids="";
      var array=[];
      var systemids = "";
      for(var i=0;i<checkeditems.length;i++)
      {
				clone = $(checkeditems[i]).parent().parent().clone();
	     	clone.find("input").attr("class", "e8_box_srcitem");
				clone.removeClass("e8_hover_tr");
				clone.removeClass("e8_select_tr");
				clone.hover(function(e){jQuery(this).addClass("e8_hover_tr");},function(e){jQuery(this).removeClass("e8_hover_tr");});
				clone.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowTo").trigger("click");
					jsBtnChange();
				}).disableSelection();
				clone.bind("click",function(e){
				if(!e.ctrlKey){
				 		var selectitems = container.find("input[name='srctitem']:checked");
						if(selectitems!=null){
							for (var j = 0; j < selectitems.length; j++) {
								$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
								jQuery(selectitems[j]).attr("checked",false);
							}
						}
					}
					
				 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
					 	jQuery(this).removeClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",false);
					}else{
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
					}
					jsBtnChange();
			  });
	      clone.find("input[type=checkbox]").attr("name", "srcitem");
	      clone.find("input").removeAttr("checked");
	      array.push(clone);
      
        jQuery(checkeditems[i]).parent().parent().remove();
       }
			
			function delItem(data){
				var rs = data;
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        if(rs.result==="1")
        {
            for(var i=0;i<array.length;i++)
            {
		       			var tabid = jQuery("#tabid").val();
								if(tabid!=3&&tabid!=4){
                	if($(array[i]).find("input[name=type]").val()=="resource"){
                		var extendBtn = container.find(".e8_box_source").find("button#extendBtn");
                		if(extendBtn.length>0){
                			container.find(".e8_box_source tr:last").before(array[i]);
                		}else{
                			source.append(array[i]);
                		}
                	}
                }else{
	                var type = $(array[i]).find("input[name='type']").val();
	                var nodeid = $(array[i]).find("input[name='nodeid']").val();
	                var treeNode = treeObj.getNodeByParam("nodeid", nodeid, null);
	         				if(type=="resource"){
								if(tabid == 4){
									var treeNodeArr = treeObj.getNodesByParam("nodeid", nodeid, null);
									for(var tx=0;tx<treeNodeArr.length;tx++){
											treeObj.showNode(treeNodeArr[tx]);
									}
								}else{
									treeObj.showNode(treeNode);
								}
	         					
	         				}else{
	         					$("#" + treeNode.tId + "_span").attr('style','color : #000000');
							 			if(type=="subcom")
							 				$("#" + treeNode.tId + "_ico").attr('style','background : url(/images/treeimages/Home_wev8.gif) 0 0 no-repeat');
							 			else
							 				$("#" + treeNode.tId + "_ico").attr('style','background : url(/images/treeimages/subCopany_Colse_wev8.gif) 0 0 no-repeat');
					        
					        		//节点没有下级变灰
									 		var childNodes = treeObj.transformToArray(treeNode); 
											for(var j=0;childNodes!=null&&j<childNodes.length;j++){
												var node = childNodes[j];
												if(node.type=="resource"){

													if(jQuery("#isNoAccount").val()!=1){
														jQuery("#tmpTitle").empty().html(node.name);
	   												var jobtitlename = jQuery("#tmpTitle").find("#jobtitlename").html();
														//不限是无账号人员
														if(jobtitlename=="(无帐号)"){
															continue;
														}
													}
													treeObj.showNode(node);
												}
											}
					        }
                }
            }

        }else
        {
  	        var languageid=readCookie("languageidweaver");
	          top.Dialog.alert(SystemEnv.getHtmlNoteName(3527,languageid)+"!!!");
        }
        createOrRefreshScrollBar("dest_box_middle","update");
        createOrRefreshScrollBar("src_box_middle","update");
			}
			var data = {};
      data.result = "1";
      delItem(data);
      
      //更新已选人数
    	updateParam();
    	jQuery("#currentPage").val(1);
    } 
  
  jQuery(document).ready(function(){
		registerDragEvent();
			$("label.overlabel").overlabel();
			var tabid = jQuery("#tabid").val();
			if(tabid==3||tabid==4){
				//初始化树
				createTree();
			}else{
				if(tabid==2){
					if(virtualtypedatas==null){
						init();
					}else{
						var editStr ="<img src='/images/treeimages/global_wev8.gif' style='vertical-align: middle;'>"
												+"<select class='selDemo' onchange='jsChangeManagerSel()'>";			
						for(var i=0;i<virtualtypedatas.length;i++){
								editStr+="<option value='"+virtualtypedatas[i].id+"'>"+virtualtypedatas[i].name+"</option>";
						}
						editStr+="</select>";
						jQuery("#managerSel").html(editStr);
						beautySelect(jQuery(".selDemo"));
						jsChangeManagerSel();
						var params = "";
					  params = getParams(params);
					 	url = "MutilResourceSelectAjax.jsp?src=dest";
	 	 				ajaxHandler(url, params, initTarget, "json", true);
 	 				}
				}else{
					init();
				}
			}
			 
		  jQuery("#singleArrowTo",window.document).hover(function(){
		         	//jQuery(this).attr("src","/js/dragBox/img/4-h_wev8.png")
		         },function(){
		         	//jQuery(this).attr("src","/js/dragBox/img/4_wev8.png")
		         }).bind("click",function(){
            	joinTarget();
             });
             
			jQuery("#singleArrowFrom",window.document).hover(function(){
            	//jQuery(this).attr("src","/js/dragBox/img/5-h_wev8.png")
            },function(){
            	//jQuery(this).attr("src","/js/dragBox/img/5_wev8.png")
            }).bind("click",function(){
            	delTarget();
            });
	     jQuery("#multiArrowTo",window.document).hover(function(){
			     	//jQuery(this).attr("src","/js/dragBox/img/6-h_wev8.png")
			     },function(){
			     	//jQuery(this).attr("src","/js/dragBox/img/6_wev8.png")
			     }).bind("click",function(){
			     	jQuery("#currentPage").val(0);
			     	joinTarget(true);
			     });
	     jQuery("#multiArrowFrom",window.document).hover(function(){
			     	//jQuery(this).attr("src","/js/dragBox/img/7-h_wev8.png")
			     },function(){
			     	//jQuery(this).attr("src","/js/dragBox/img/7_wev8.png")
			     }).bind("click",function(){
			     	delTarget(true);
			     });
			  jQuery("#imgalllevel").hide();   
			  if(tabid==2||tabid==3){
			  	jQuery("#imgalllevel").show();
			  	if(jQuery("#alllevel").val()==1){
        		jQuery("#imgalllevel").attr("src","/hrm/css/zTreeStyle/img/alllevelshow_wev8.png")
         	}else{
         		jQuery("#imgalllevel").attr("src","/hrm/css/zTreeStyle/img/alllevelhide_wev8.png")
         	}
			  }
			  if(tabid==0)jQuery("#imgisnoaccount").hide();
		  	if(jQuery("#isNoAccount").val()==1){
      		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png");
      		var languageid=readCookie("languageidweaver");
      		jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
       	}else{
       		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccounthide_wev8.png");
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
       	createOrRefreshScrollBar("src_box_middle");
       	createOrRefreshScrollBar("dest_box_middle");
   })
   
   function jsTargetSearch(){
   		var container = $("#colShow");
   		var val= jQuery("#flowTitle1").val();
   		var target = container.find(".e8_box_target");
   		var destitems=container.find(".e8_box_target").find("input[type='checkbox'][name='destitem']");

   		for(var i=0;i<destitems.length;i++){
				var trObj = $(destitems[i]).parent().parent();
	     	var lastname = $(trObj).children("td:eq(2)").text();
	     	var pinyinlastname = $(trObj).find("input[name='pinyinlastname']").val();
	     	if((lastname && lastname.indexOf(val)==-1)&&(pinyinlastname && pinyinlastname.indexOf(val)==-1)){
	     		trObj.hide();
	     	}else{
	     		trObj.show();
	     	}
	    }
	    target.scrollTop();
			createOrRefreshScrollBar("dest_box_middle","update");
   }
   
   function onSearchFocus(){
   		if(jQuery("#flowTitle").val()==""){
	     	//缓存之前的内容
   			//jQuery("#e8_box_middle_bak").html(jQuery("#src_box_middle").html());
   			var container = $("#colShow");
   			//jQuery("#src_box_middle").css("height","461px");
   			E8EXCEPTHEIGHT =0;
  			expandZH();
	    	container.find(".e8_box_source").html("");
	    	var languageid=readCookie("languageidweaver");
	     	var tr = $("<tr height='32px'><td style='text-align: center;width=346px;'>"+SystemEnv.getHtmlNoteName(3548,languageid)+"<td></tr>");
	    	container.find(".e8_box_source").append(tr);
	    	jQuery("#managerSel").html("");
	    	jQuery("#imgalllevel").hide();
    	}
   }
   
   function onSearchFocusLost(){
   		if(jQuery("#flowTitle").val()==""){
   			var container = $("#colShow");
    		jQuery(".magic-line",parent.document).show();
   			jQuery("#tabId"+jQuery("#oldtabid").val(),parent.document).parent().addClass("current");
				jQuery("#tabId"+jQuery("#oldtabid").val(),parent.document).parent().focus();
				//还原缓存内容
    		//jQuery("#src_box_middle").empty().html(jQuery("#e8_box_middle_bak").html());
				parent.resetbanner(jQuery("#oldtabid").val());
    		//注册事件
    		jsSrcItembind();
   		}
   }
   
   //重新注册事件
   function jsSrcItembind(){
   		var srctitems=$("#colShow").find(".e8_box_source").find("input[type='checkbox'][name='srcitem']");
   	
      for(var i=0;i<srctitems.length;i++){
				var tr = jQuery(srctitems[i]).parent().parent();
				if(jQuery(tr).hasClass("e8_select_tr"))jQuery(tr).find("input[type='checkbox']").attr("checked",true);
	       tr.hover(function(){
	       	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
	       },function(){
	      	jQuery(this).removeClass("e8_hover_tr");
	       }).removeClass("e8_hover_tr");
	       tr.bind("mousedown",function(e){
	       		jQuery('#mousedown').val(1);
	       });
	       tr.bind("mouseup",function(e){
	       		jQuery('#mousedown').val(0);
	       });
	       tr.bind("mouseover",function(e){
	       	if(jQuery('#mousedown').val()==1){
	       		if(!jQuery(this).find("input[type='checkbox']").attr("checked")){
							jQuery(this).addClass("e8_select_tr");
							jQuery(this).find("input[type='checkbox']").attr("checked",true);
							jsBtnChange();
						}
					}
	       });
	       tr.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowTo").trigger("click");
					jsBtnChange();
				 });
				 tr.bind("click",function(e){
				 	if(!e.ctrlKey){
				 		var selectitems = $("#colShow").find("input[name='srcitem']:checked");
				 		if(selectitems!=null){
							for (var j = 0; j < selectitems.length; j++) {
								$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
								jQuery(selectitems[j]).attr("checked",false);
							}
						}
				 	}
				 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
					 	jQuery(this).removeClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",false);
					}else{
						//console.log(jQuery(this).html())
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
					}
					jsBtnChange();
			  });
     }
   }
   
 	var timeout = null;
   function jsSourceSearch(){
   		clearTimeout(timeout);
 			timeout = setTimeout(function(){
	      //清空高级搜索条件
	      resetHrmCondition();
	      jQuery("#lastname").val(jQuery("#flowTitle").val());
				jQuery("#imgalllevel").hide();
				jQuery("#imgisnoaccount").show();
	  		if(jQuery("#isNoAccount").val()==1){
	    		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png");
	    		var languageid=readCookie("languageidweaver");
	    		jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
	     	}else{
	     		jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccounthide_wev8.png");
	     		var languageid=readCookie("languageidweaver");
	     		jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4063,languageid));
	     	}
	     	if(jQuery("#advancedSearchDiv").is(":visible"))jsChangeAdvancedSearchDiv();
	     	
	   		jQuery(".magic-line",parent.document).hide();
	   		jQuery(".current",parent.document).removeClass("current");
				
				jsBtnChange();
				     		 			
	   		if(jQuery("#tabid").val()!=-1)jQuery("#oldtabid").val(jQuery("#tabid").val());
	   		jQuery("#tabid").val("-1"); //组合查询
	   		jQuery("#currentPage").val(1);
	   		//jQuery(".multiHeight").css("height","135px");
   			jQuery("#multiArrowTo").show();
	   		if(jQuery("#tabid").val()==0)jQuery("#imgisnoaccount").hide();
	   		jQuery("#tabTypeOption").hide();
	   		jQuery("#imgisnoaccount").parent().css("margin-top","5px");
	   		//jQuery("#src_box_middle").empty().html("<table class='e8_box_source' style='border-collapse: collapse;width: 100%'><tbody></tbody></table>");
	   		var url = "MutilResourceSelectAjax.jsp";
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
   	var container = $("#colShow");
		var checkeditems=container.find(".e8_box_target").find("input[type='checkbox'][name='destitem']");
		var types="";
		var ids="";
    var names="";
    var resourceids = "";
   	var workflow =jQuery("#workflow").val();
		if(checkeditems.length>0){
	    for(var i=0;i<checkeditems.length;i++){
	    	if(types.length>0)types+=",";
	    	if(ids.length>0)ids+=",";
	    	if(names.length>0)names+=",";
	    	var trObj = $(checkeditems[i]).parent().parent();;
	    	var type = $(trObj).find("input[name='type']").val();
	    	var id = $(trObj).find("input[name='id']").val();
	    	var name = null;
	    	if(workflow==1){
	    		name = $(trObj).find("input[name='name']").val();
	    	}else{
	    	 	name=$(trObj).children("td:eq(2)").text();
	    	}
	    	if(type=="resource"){
	    		if(resourceids.length>0)resourceids+=",";
	    		resourceids+=id;
	    	}
	    	types+=type;
	    	ids+=id;
	    	if(typeof(name)!="undefined" && name!="")names+=name.replace(/,/g, '，');
	    }
	    if(resourceids.length>0){
	    	var url = "saveSelectAjax.jsp";
	    	var params = "ids="+resourceids;
	    	ajaxHandler(url, params, null, "json", true);
	    }
	    
	    var workflow =jQuery("#workflow").val();
	    if(workflow==1){
	    	//流程特殊处理
	    	jQuery.ajax({
					url:"MultiSelectDataFormat.jsp",
					type:"POST",
					dataType:"json",
					async:true,
					data:{
						cmd:"workflow",
						type:types,
						id:ids,
						f_weaver_belongto_userid:jQuery("#f_weaver_belongto_userid").val(),
						f_weaver_belongto_usertype:jQuery("#f_weaver_belongto_usertype").val(),
						alllevel:jQuery("#alllevel").val(),
						isNoAccount:jQuery("#isNoAccount").val(),
						sqlwhere:jQuery("#sqlwhere").val()
					},
					success:function(datas){
						//按流程数据格式返回
						try{
			   			dialog.close(datas);
						}catch(e){}
					}
				});
				return;
	    }
	   
		}
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
   
   function updateParam(option){   
    //更新selectedids
    var container = $("#colShow");
    var tabid = jQuery("#tabid").val();
    var workflow = jQuery("#workflow").val();
    var selectedids = "";
    var resourceNum = 0;
    selectitems = container.find("input[type='checkbox'][name='destitem']");
    if(selectitems){
	    for (var i = 0; i < selectitems.length; i++) {
	    	if(selectedids.length>0)selectedids+=",";
	    	var selectedid = $(selectitems[i]).parent().parent().find("input[name='id']").val();
	    	var type = $(selectitems[i]).parent().parent().find("input[name='type']").val();
	    	if(workflow==1){
	    		if(type!="resource"){
	    			selectedid=type+"_"+selectedid;
	    			var nodenum = parseInt($(selectitems[i]).parent().parent().find("input[name='nodenum']").val(),10);
	    			resourceNum += nodenum;
	    		}else{
	    			resourceNum++;
	    		}
	    	}else{
	    		resourceNum++;
	    	}
	    	selectedids+=selectedid;
	    }	    
    }
    
    /*
  	jQuery.ajax({
			url:"MutilResourceSelectAjax.jsp",
			type:"POST",
			dataType:"json",
			async:false,
			data:{
				cmd:"getSelectedidsNum",
				alllevel:jQuery("#alllevel").val(),
				selectedids:selectedids,
				isNoAccount:jQuery("#isNoAccount").val(),
				sqlwhere:jQuery("#sqlwhere").val()
			},
			success:function(data){
				resourceNum = data.num;
			}
		});*/
		//
		
    jQuery("#selectedids",parent.document).val(selectedids);
    jQuery("#selectedids").val(selectedids);
    jsBtnChange()
    //更新节点人数
		var languageid=readCookie("languageidweaver");
		jQuery("#btnok").val(jQuery("#btnok").attr("val")+"("+resourceNum+SystemEnv.getHtmlNoteName(3654,languageid)+")");
	  if(!option)updateType();
	  createOrRefreshScrollBar("src_box_middle","update");
	  createOrRefreshScrollBar("dest_box_middle","update");
    //增加拖动排序
    registerDragEvent();	
    //禁用已选节点
    treeNodeDisabled();
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
				dblClickExpand: false,
				addDiyDom: addDiyDom
			},
			callback: {
				onClick: zTreeOnClick,   //节点点击事件
				//onCheck: zTreeOnCheck,
				onDblClick:zTreeOnDblClick,
				onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			}
		};
	 
	 function updateType(){
	 	//取消节点数字计算
	 	if(1==1)return;
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		if(!treeObj)return;
		var nodes = treeObj.transformToArray(treeObj.getNodes());
		var tabid = jQuery("#tabid").val();
		//采用异步加载方式更新节点数据
		var nodeids = "";
		for (var i=0, l=nodes.length; i<l; i++) {
			if(nodes[i].type=="resource")continue;
			var node = nodes[i];
			if(i!=0)nodeids+=","
			if(nodes[i].type=="group")
				nodeids += node.id;
			else
				nodeids += node.nodeid;	
		}
		//更新节点数量
		var url="";
		if(tabid==3){
			var virtualtype = jQuery("#virtualtype").val();
			if(virtualtype!=""&&virtualtype!="1"){
				url="hrmtreeVirtualXML.jsp";
			}else{
				url="hrmtreeXML.jsp";
			}
		}else if(tabid==4){
			url="hrmtreeGroupXML.jsp";
		}
		jQuery.ajax({
			url:url,
			type:"POST",
			dataType:"json",
			async:true,
			data:{
				cmd:"getNum",
				nodeids:nodeids,
				selectedids:jQuery("#selectedids").val(),
				f_weaver_belongto_userid:jQuery("#f_weaver_belongto_userid").val(),
				f_weaver_belongto_usertype:jQuery("#f_weaver_belongto_usertype").val(),
				isNoAccount:jQuery("#isNoAccount").val(),
				sqlwhere:jQuery("#sqlwhere").val()
			},
			success:function(datas){
				for(var i=0;datas!=null&&i<datas.length;i++){
					var nodeid = datas[i].nodeid;
					var nodenum = datas[i].nodenum;
					var node = treeObj.getNodeByParam("nodeid", nodeid, null);
					node.name = node.name.replace(/ \(.*\)/gi, "") + " (" + nodenum + ")";
					if(node.type=="com"){
						$("#" + node.tId + "_span").hide();
						$("#" + node.tId + "_a").attr('style','display : inline');
						$(".selDemo").find("option:selected").text(node.name);
					}else{
						treeObj.updateNode(node);
					}
				}
			}
		});
	}
	
	 function addDiyDom(treeId, treeNode) {
		if (treeNode.type == "com") {
			if(virtualtypedatas==null)return;
			var aObj = $("#" + treeNode.tId + "_a");
			var editStr = "<select class='selDemo' id='diyBtn_" +treeNode.id+ "'>";			
			for(var i=0;i<virtualtypedatas.length;i++){
				if(virtualtype==virtualtypedatas[i].id){
					editStr+="<option value='"+virtualtypedatas[i].id+"' selected>"+virtualtypedatas[i].name+"</option>";
				}
				else
					editStr+="<option value='"+virtualtypedatas[i].id+"'>"+virtualtypedatas[i].name+"</option>";
			}
			editStr+="</select>";
			aObj.after(editStr);
			beautySelect(jQuery(".selDemo"));
			$("#" + treeNode.tId + "_span").hide();
			$("#" + treeNode.tId + "_a").attr('style','display : inline');
			var btn = $("#diyBtn_"+treeNode.id);
		  if (btn) btn.bind("change", function(){changeVirtualType(jQuery(this).val());});
		}
	}
	
	function changeVirtualType(){
		var tabid = jQuery("#tabid").val();
	  if(tabid==1){
			var url = "MutilResourceSelectAjax.jsp";
      var params = "";
      params = getParams(params);
	    ajaxHandler(url, params, initSource, "json", true);
		}else if(tabid==2){
			jsChangeManagerSel()
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
				if(virtualtype==""||virtualtype=="1"){
					//获取子节点时
			    if (treeNode && treeNode.isParent) {
			    	return "hrmtreeXML.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype +"&sqlwhere="+sqlwhere + "&selectedids="+selectedids +"&id=" + treeNode.id + "&type="+treeNode.type+"&alllevel=" +alllevel+"&isNoAccount=" +isNoAccount+"&"+ new Date().getTime() + "=" + new Date().getTime();
			    } else {
			    	//初始化时
			    	return "hrmtreeXML.jsp?f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype +"&sqlwhere="+sqlwhere + "&selectedids="+selectedids+"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+ "&" + new Date().getTime() + "=" + new Date().getTime();
			    }
				}else{
					//获取子节点时
			   if (treeNode && treeNode.isParent) {
			    	return "hrmtreeVirtualXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&virtualtype="+ virtualtype +"&sqlwhere="+sqlwhere + "&selectedids="+selectedids +"&id=" + treeNode.id + "&type="+treeNode.type+"&alllevel=" +alllevel+"&isNoAccount=" +isNoAccount+"&" + new Date().getTime() + "=" + new Date().getTime();
			    } else {
			    	//初始化时
			    	return "hrmtreeVirtualXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&sqlwhere="+sqlwhere + "&selectedids="+selectedids +"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+ "&" + new Date().getTime() + "=" + new Date().getTime();
			    }
		    }
	    }else if(tabid==4){
	    	//获取子节点时
		    if (treeNode && treeNode.isParent) {
		    	return "hrmtreeGroupXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&id="+treeNode.id +"&sqlwhere="+sqlwhere +"&selectedids="+selectedids+"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+"&" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
		    } else {
		    	//初始化时
		    	return "hrmtreeGroupXML.jsp?virtualtype="+ virtualtype +"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&sqlwhere="+sqlwhere+"&selectedids="+selectedids +"&isNoAccount=" +isNoAccount+"&alllevel=" +alllevel+"&" + new Date().getTime() + "=" + new Date().getTime();
		    }
	    }
		};
		
	function zTreeOnClick(event, treeId, treeNode) {
		if(!event.ctrlKey){
			//清除之前所选节点
			var treeObj = $.fn.zTree.getZTreeObj(treeId);
			nodes = treeObj.getCheckedNodes(true);
			for (var j=0, l=nodes.length; j<l; j++) {
				var node = nodes[j];
				$("#" + node.tId+"_a").attr('style','background-color : #ffffff'); 
				//$("#" + node.tId + "_a").attr('style','display : inline');
				treeObj.checkNode(node, false, true);
			}
		}
	   // 用于解决双击时候会调用两次单击事件的问题
    if (treeNode.clickTimeout) {
        clearTimeout(treeNode.clickTimeout);
        treeNode.clickTimeout = null;
    } else {
        treeNode.clickTimeout = setTimeout(function() {
            triggerNodeClick(treeId, treeNode);
            treeNode.clickTimeout = null;
        }, 250);
    }
	};
	
	function triggerNodeClick(treeId, treeNode){
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
	  if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		if(treeNode.checked){
			treeObj.checkNode(treeNode, false, true);
			$("#" + treeNode.tId+"_a").attr('style','background-color : #ffffff');  
		}else{
			treeObj.checkNode(treeNode, true, true);
			$("#" + treeNode.tId+"_a").attr('style','background-color : #dff1ff'); 
		}
		jsBtnChange();
	}

	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var virtualtype = jQuery("#virtualtype").val();
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
		
		
		//treeObj.expandNode(treeNode, true, false, true);
	  updateType();
	}
	
	function treeNodeDisabled(){ 
    //更新selectedids
    var workflow = jQuery("#workflow").val();
    if(workflow!=1)return;
    var container = $("#colShow");
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
   		var url = "MutilResourceSelectAjax.jsp?src=dest";
	    var params = "";
      params = getParams(params);
	   	ajaxHandler(url, params, initTarget, "json", true);
		}
		
		function zTreeOnDblClick(event, treeId, treeNode) {
			var workflow = jQuery("#workflow").val();
			var toworkflow = false;
			if(workflow==1&&treeNode.type!="resource"){
					toworkflow= true;
				  //私人组不能被选择
				  var id = treeNode.id;
				  if(treeNode.getParentNode()==null) return;
   		  	if(id==-1 || id==-2 || id==-3 || (id!=-3&&treeNode.getParentNode().id==-3)){
   		  		toworkflow= false;
   		  	}
			}

		 	if(toworkflow) {
		 		zTreeOnDblClickWF(event, treeId, treeNode);
		 		return;
		 	}
	   var avgwidth = "112px";
	   var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	   var nodeid = treeNode.nodeid;

	   if(treeNode.type!="resource"){
	  	$("#" + treeNode.tId+"_a").attr('style','background-color : #ffffff');  
	   	var halfCheck = treeNode.getCheckStatus();
			//if(halfCheck.half)return;
	   	var comdeptnodeids = nodeid;
	   	if(treeNode.type=="group")comdeptnodeids=treeNode.id;
				
				var url = "";
				var cmd = "getComDeptResource";
				var tabid = jQuery("#tabid").val();
				if(tabid == 3){
					var virtualtype = jQuery("#virtualtype").val();
					url = "MutilResourceSelectAjax.jsp";
					if(virtualtype<-1)cmd = "getComDeptResourceVirtual";
				}else{
					url = "hrmtreeGroupXML.jsp";
				}
				jQuery.ajax({
					url:url,
					type:"POST",
					dataType:"json",
					async:true,
					data:{
						cmd:cmd,
						comdeptnodeids:comdeptnodeids,
						alllevel:jQuery("#alllevel").val(),
						selectedids:jQuery("#selectedids").val(),
						f_weaver_belongto_userid:jQuery("#f_weaver_belongto_userid").val(),
						f_weaver_belongto_usertype:jQuery("#f_weaver_belongto_usertype").val(),
						isNoAccount:jQuery("#isNoAccount").val(),
						sqlwhere:jQuery("#sqlwhere").val()
					},
					success:function(datas){
						joinDataTarget(datas);
					}
				});
	   	return;
	   }
	   var resourceid = treeNode.id;
	   //选中区如果存在，不进行添加;仅隐藏
	   var curSelectIds = ","+jQuery("#selectedids").val()+"," ;
	   if(curSelectIds.indexOf(','+resourceid+',') >=0) {
		   treeObj.hideNode(treeNode) ;
		   return ;
	   }

	   jQuery("#tmpTitle").empty().html(treeNode.name);
	   var lastname = jQuery("#tmpTitle").find("#lastname").html();
	   var pinyinlastname = jQuery("#tmpTitle").find("#pinyinlastname").html();
	   var jobtitlename = jQuery("#tmpTitle").find("#jobtitlename").html();
	   var messagerurl = treeNode.icon;
	   var container = $("#colShow");
		 var target = container.find(".e8_box_target");
     
     var checkitem;
     var json={"messagerurl":messagerurl,"id":resourceid,"lastname":lastname,"type":"resource","pinyinlastname":pinyinlastname,"jobtitlename":jobtitlename,"nodeid":nodeid};
     var jsonArr = new Array();
     jsonArr[0]=json;
     datas = jsonArr;
  	 //var datas="[{messagerurl:'"+messagerurl+"',id:'"+resourceid+"',lastname:'"+lastname+"',type:'resource',pinyinlastname:'"+pinyinlastname+"',jobtitlename:'"+jobtitlename+"',nodeid:'"+nodeid+"'}]";
		 for (var i = 0; i < datas.length; i++) {
      	checkitem=$("<td style='width: 28px;display:none;'></td>");
        checkitem.append($("<input name='destitem' type='checkbox' style='margin-left: 7px'>"));
        tr = $("<tr height='32px'></tr>");
        tr.hover(function(){
        	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
        },function(){
        	jQuery(this).removeClass("e8_hover_tr");
        }).removeClass("e8_hover_tr");
        tr.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowFrom").trigger("click");
					jsBtnChange();
				});
				tr.bind("click",function(e){
					if(!e.ctrlKey){
				 		var selectitems = container.find("input[name='destitem']:checked");
				 		if(selectitems!=null){
							for (var j = 0; j < selectitems.length; j++) {
								$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
								jQuery(selectitems[j]).attr("checked",false);
							}
						}
					}
					
				 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
					 	jQuery(this).removeClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",false);
					}else{
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
					}
					jsBtnChange();
			 	});
				tr.append(checkitem);
        var dataitem = datas[i];
        for (var item in dataitem) {
        	if(item=="messagerurl"){
        		td = $("<td style='width:30px;max-width: 30px;px;padding-left:5px;'><img style='vertical-align:middle;' width='20px' src='" + dataitem[item] + "'></td>");
            tr.append(td);
        	}else if(item==="pinyinlastname"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          }else if(hiddenfield.indexOf(item)>-1){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          }else if(item==="jobtitlename"){
            td = $("<td style='width:144px;max-width: 144px;color:#929390;'>" + dataitem[item] + "</td>");
            tr.append(td);
          }else if(item==="lastname"){
            td = $("<td style='width:80px;max-width: 80px;'>" + dataitem[item] + "</td>");
            tr.append(td);
          }else{
            td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "'>" + dataitem[item] + "</td>");
            tr.append(td);
          }
        }
                
      	container.find(".e8_box_target").append(tr);
      }
	    //更新已选人数
	    updateParam();
		if(jQuery("#tabid").val() == 4){
			var hideNodeid = treeNode.nodeid ;
			var treeNodeArr = treeObj.getNodesByParam("nodeid", hideNodeid, null);
			for(var tx=0;tx<treeNodeArr.length;tx++) 	treeObj.hideNode(treeNodeArr[tx]);
		}else{
			treeObj.hideNode(treeNode);
		}
		
		};
		
		function checkAllParents(treeNode,selectednodeids){
			if (treeNode==null || treeNode.pId==0) {
				return;
			}else{
				for(var i=0; selectednodeids!=null&&i<selectednodeids.length;i++){
					if(treeNode.nodeid==jQuery(selectednodeids[i]).val()){
						selectednodeflag=true;
						break;
					}
				}
				if(selectednodeflag)return;
				checkAllParents(treeNode.getParentNode(),selectednodeids);
			}
		}
		
		function zTreeOnDblClickWF(event, treeId, treeNode){
		  var avgwidth = "224px";
			var id = treeNode.id;
			var nodeid = treeNode.nodeid;
			var name = treeNode.name;
			var type = treeNode.type;
			var messagerurl = treeNode.icon;
			var url = $("#" + treeNode.tId + "_ico").css("background-image");
			//正式系统刚好有-
			
			//if(url.indexOf("-")!=-1)return;
			if(url.indexOf("Home-_wev8.gif")!=-1||url.indexOf("subCopany_Colse-_wev8.gif")!=-1)return;
			if(type=="subcom"){
				messagerurl = "/images/treeimages/Home1_wev8.gif";
			}else if(type=="dept"||type=="group"){
				messagerurl = "/images/treeimages/subCopany_Colse1_wev8.gif";
			}
	   	var container = $("#colShow");
		 	var target = container.find(".e8_box_target");
		 	var selectedids = jQuery("#selectedids").val();
		 	//如果已选择 不能再选
		 	var tmpid = selectedids+',';
			if(tmpid.indexOf(nodeid+',')!=-1)return;
			
			var nodenum = 0;
     	var checkitem;
   		if(type=="resource"){
   			jQuery("#tmpTitle").empty().append(jQuery(name));
			  var lastname = jQuery("#tmpTitle").find("#lastname").html();
   			name = lastname;
   		}
   		
   		if(type!="resource"){
   			var cmd = "getComDeptResourceNum";
   			var nodeids = nodeid;
   			//如果上级已被选择，不需要再选
   			selectednodeflag=false;
   			var selectednodeids = jQuery("#e8_dest_table").find("input[name=nodeid]");
   		  checkAllParents(treeNode,selectednodeids);
   			if(selectednodeflag) return;
   			
   		  if(type=="group"){
   		  	nodeids = id;
   		  	//私人组不能被选择
   		  	if(id==-1 || id==-2 || id==-3 || (id!=-3&&treeNode.getParentNode().id==-3)){
   		  		return;
   		  	} 
   		  	cmd = "getGroupResourceNum";	
   		  }
   			jQuery.ajax({
					url:"MutilResourceSelectAjax.jsp",
					type:"POST",
					dataType:"json",
					async:false,
					data:{
						cmd:cmd,
						nodeids:nodeids,
						alllevel:jQuery("#alllevel").val(),
						f_weaver_belongto_userid:jQuery("#f_weaver_belongto_userid").val(),
						f_weaver_belongto_usertype:jQuery("#f_weaver_belongto_usertype").val(),
						isNoAccount:jQuery("#isNoAccount").val(),
						sqlwhere:jQuery("#sqlwhere").val()
					},
					success:function(data){
						nodenum = data.num;
						name+="("+nodenum+")";
   		if(nodenum==0)return;
     var json={"messagerurl":messagerurl,"id":id,"name":name,"type":type,"nodeid":nodeid,"nodenum":nodenum};
     var jsonArr = new Array();
     jsonArr[0]=json;
     datas = jsonArr;
     
 	 		//var datas="[{messagerurl:'"+messagerurl+"',id:'"+id+"',name:'"+name+"',type:'"+type+"',nodeid:'"+nodeid+"',nodenum:'"+nodenum+"'}]";
 	 		//datas = eval(datas);
	 		for (var i = 0; i < datas.length; i++) {
     		checkitem=$("<td style='width: 28px;display:none;'></td>");
      	checkitem.append($("<input name='destitem' type='checkbox' style='margin-left: 7px'>"));
        tr = $("<tr height='32px'></tr>");
        tr.hover(function(){
        	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
        },function(){
        	jQuery(this).removeClass("e8_hover_tr");
        }).removeClass("e8_hover_tr");
        tr.bind("dblclick",function(e){
					jQuery(this).find("input[type='checkbox']").attr("checked",true);
					jQuery("#singleArrowFrom").trigger("click");
					jsBtnChange();
				});
				tr.bind("click",function(e){
					if(!e.ctrlKey){
				 		var selectitems = container.find("input[name='destitem']:checked");
						if(selectitems!=null){
							for (var j = 0; j < selectitems.length; j++) {
								$(selectitems[j]).parent().parent().removeClass("e8_select_tr");
								jQuery(selectitems[j]).attr("checked",false);
							}
						}
					}
				 	if(jQuery(this).find("input[type='checkbox']").attr("checked")){
					 	jQuery(this).removeClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",false);
					}else{
						jQuery(this).addClass("e8_select_tr");
						jQuery(this).find("input[type='checkbox']").attr("checked",true);
					}
					jsBtnChange();
			 	});
				tr.append(checkitem);
        var dataitem = datas[i];
        for (var item in dataitem) {
        	if(item=="messagerurl"){
        		td = $("<td style='width:30px;max-width: 30px;padding-left:5px;'><img style='vertical-align:middle;' width='20px' src='" + dataitem[item] + "'></td>");
            tr.append(td);
        	}else if(item==="pinyinlastname"){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          }else if(hiddenfield.indexOf(item)>-1){
            checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          }else{
          	if(item==="name"){
          		checkitem.append($("<input type='hidden' name='"+item+"' value='"+dataitem[item]+"'>"));
          	}
            td = $("<td style='width:"+avgwidth+";max-width: " + avgwidth + "' colspan='2'>" + dataitem[item] + "</td>");
            tr.append(td);
          }
        }       
     		container.find(".e8_box_target").append(tr);
     		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
			  //节点没有下级变灰
		 		var childNodes = childNodes = treeObj.transformToArray(treeNode); 

		 		
				for(var i=0;childNodes!=null&&i<childNodes.length;i++){
					var node = childNodes[i];
					if(node.type=="resource")treeObj.hideNode(node);
				}
  			//更新人数
				updateParam();
     	}


					}
				});
   		}
		}
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
		    jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccounthide_wev8.png");
		    var languageid=readCookie("languageidweaver");
		    jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4063,languageid));
		  }else{
		 	 	jQuery("#isNoAccount",parent.document).val("1");
		 	 	jQuery("#isNoAccount").val("1");
		 	 	jQuery("#imgisnoaccount").attr("src","/hrm/css/zTreeStyle/img/noaccountshow_wev8.png");
		 	 	var languageid=readCookie("languageidweaver");
		 	 	jQuery("#imgisnoaccount").attr("title",SystemEnv.getHtmlNoteName(4064,languageid));
		  }
		  if(jQuery("#tabid").val()=="-1"){
		  	var url = "MutilResourceSelectAjax.jsp";
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
		  //parent.resetbanner(jQuery("#tabid").val());
		  changeVirtualType();
		}

		function jsBtnChange(){
			var container = $("#colShow");	
			var tabid = $("#tabid").val();				 
			var srcitemschecked = null;
			var srcitems = null;
			//最近、组织结构、常用组 
			/*
   		if(tabid==0||tabid==3||tabid==4){
   			jQuery("#singleArrowTo").attr('style','margin-top : 165px'); 
   			jQuery("#multiArrowFrom").attr('style','margin-top : 160px'); 
   		}else{
   			jQuery("#singleArrowTo").attr('style','margin-top : 135px'); 
   			jQuery("#multiArrowTo").attr('style','margin-top : 135px'); 
   		}*/
			if(tabid==3||tabid==4){
				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
				srcitemschecked = treeObj.getCheckedNodes(true);
				srcitems = treeObj.getNodes();
				//jQuery(".multiHeight").css("height","180px");
				jQuery("#multiArrowTo").hide();
			}else{
				srcitemschecked = container.find("input[type='checkbox'][name='srcitem']:checked");
				srcitems = container.find("input[type='checkbox'][name='srcitem']");
			}			
			var destitemschecked = container.find("input[type='checkbox'][name='destitem']:checked");
			var destitems = container.find("input[type='checkbox'][name='destitem']");
			
			//alert("srcitems=="+srcitems.length+"destitem=="+destitems.length);
			//console.log("srcitems=="+srcitems.length+"destitem=="+destitem.length);
			if(srcitemschecked.length>0){
				jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4-h_wev8.png");
			}else{
		  	jQuery("#singleArrowTo").attr("src","/js/dragBox/img/4_wev8.png");
		  }
		  if(srcitems.length>0){
				jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6-h_wev8.png");
			}else{
		  	jQuery("#multiArrowTo").attr("src","/js/dragBox/img/6_wev8.png");
		  }
		  
		  if(destitemschecked.length>0){
				jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5-h_wev8.png");
			}else{
		  	jQuery("#singleArrowFrom").attr("src","/js/dragBox/img/5_wev8.png");
		  }
		  
			if(destitems.length>0){
				jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7-h_wev8.png");
			}else{
		  	jQuery("#multiArrowFrom").attr("src","/js/dragBox/img/7_wev8.png");
		  }
		  
		}

function registerDragEvent(){
	 var fixHelper = function(e, ui) {
	    ui.children().each(function() {  
	      jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
	      jQuery(this).height("30px");						//在CSS中定义为30px,目前不能动态获取
	    });  
	    return ui;  
    }; 
     jQuery(".e8_box_target tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
         helper: fixHelper,                  //调用fixHelper  
         axis:"y",  
         start:function(e, ui){
         	 ui.helper.addClass("moveMousePoint");
           ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
           if(ui.item.hasClass("notMove")){
           	e.stopPropagation();
           }
           $(".hoverDiv").css("display","none");
           return ui;  
         },  
         stop:function(e, ui){
             jQuery(ui.item).hover(function(){
            	if(!jQuery(this).hasClass("e8_select_tr"))jQuery(this).addClass("e8_hover_tr");
            },function(){
            	jQuery(this).removeClass("e8_hover_tr");
            	
            });
            jQuery(ui.item).removeClass("moveMousePoint");
            return ui;  
         }  
     });  
}

function jsChangeManagerSel(){
	var virtualtype = jQuery("#virtualtype").val();
	if(virtualtype=="")jQuery("#virtualtype").val("1");
	//jQuery("#cmd").val("getManagerResource");
  var url = "MutilResourceSelectAjax.jsp";
  var params = "";
  params = getParams(params);
  ajaxHandler(url, params, initSource, "json", true);
  jQuery("#cmd").val("");
  params = "";
 	params = getParams(params);
	url = "MutilResourceSelectAjax.jsp?src=dest";
	ajaxHandler(url, params, initTarget, "json", true);
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