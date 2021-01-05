var workflowInterface=(function (){
	var mainSpan;
	var parentSpan;
	
	var requestid;

	var freedata=[]; //自由定义流转节点

	var fulldata; //全部流转节点
	var currnodeid;//当前处理的节点id
	var nextnodeid;//当前流转的下一节点id
	var wfid;

	var startSpan;//drag起始点
	var stopSpan;//drag终止点
	var startrows=-1;//startSpan在奇数？偶数？行
	var stoprows=-1;//stopSpan在奇数？偶数？行

	var spanId=0;//生成节点的divId

	var spans=[];//整体页面数据

	var init_nodeName;
	
	var initx=50;
	var inity=40;

	var span_x=initx;
	var span_y=inity;
	
	var space_x=235;//每个节点的距离
	var space_y=176;//每行间隔
	
	var cols=4;//每排个数
	var cnum=0;//计数

	var signTypeOption;
	var roadTypeOption;

	var appNum=1;
	//var showover = 0;
	//添加的新节点的默认信息
	var appInitData={floworder:"",nodename:"",nodetype:"1",Signtype:"1",operators:"",operatornames:"",grouptype:"0",objid:"0"};

	return {
		
		setRequestid:function (rid){
			requestid=rid;
		},
		setInitNodeName:function (nodename){
			init_nodeName=nodename;
		},
		setNodeTypeOption:function (option){
			nodeTypeOption=option;
		},
		setSignTypeOption:function (option){
			signTypeOption=option;
		},
		setRoadTypeOption:function (option){
			roadTypeOption=option;
		},
		create:function (div,full_data,curr_nodeid,next_nodeid,curr_wfid){
			mainSpan=div;
			fulldata=full_data;
			currnodeid=curr_nodeid;
			nextnodeid=next_nodeid;
			wfid=curr_wfid;
			init();
		},
		
		setOperators:function (operators,operatornames){
			if(operators.length>0){
				if(freedata.length>0){
					//改填第一个节点的操作人信息
					var id=updateOperators();
					
					jQuery("#wfEditForm").find("input[name='operatornames_"+id+"']").val(operatornames);
					jQuery("#wfEditForm").find("input[name='operators_"+id+"']").val(operators);

				}else{
					//没有自由节点，则添加一个
					addApproval();
					
					var id=spanId-1;

					jQuery("#wfEditForm").find("input[name='operatornames_"+id+"']").val(operatornames);
					jQuery("#wfEditForm").find("input[name='operators_"+id+"']").val(operators);

				}
			}			
		},
		//saveDataToParent:function (){

		//	var id=updateOperators();
		//},
		//changeNodeName:function (value){
		//	alterNodeName(value);
		//	if(value.length>0){
		//		jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","none");
		//	}else{
		//		jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","block");
		//	}
		//},
		//changeNodeType:function(value){
		//	alterNodeType(value);
		//},
		//saveChangedStatus:function() {
		//	jQuery(parentSpan).append("<input type='hidden' name='freeWorkflowChanged' value='true' />");
		//}
	}

	function init(){
		/**初始化**/
		var start_i;
		var stop_i;
		var rows=0;
		var num=0;
		var fnum=0;
		for(var i=0;i<fulldata.length;i++){
			if(fulldata[i].nodeid==currnodeid){
				start_i=i;

			}else if(fulldata[i].nodeid==nextnodeid){
				stop_i=i;
			}			
		}
		
		while(num<=fulldata.length){
			if(fulldata[0].nodetype!=0){
				//第一个节点不是创建节点，数据获取有问题
				break;
			}
			var span;
			
			fulldata[num].id=spanId;
			if(fulldata[num].nodetype==0){
				//创建节点
				span=proposerSpan(fulldata[num].nodename,fulldata[num].operatornames);	
				span.addClass("proposer");
			}else if(fulldata[num].nodetype==1){
				//审批节点
				span=approvalSpan(fulldata[num].nodename,fulldata[num].operatornames);
				span.addClass("approval");
			}else if(fulldata[num].nodetype==2){
				//处理节点
				span=manageSpan(fulldata[num].nodename,fulldata[num].operatornames);
				span.addClass("manage");
			}else if(fulldata[num].nodetype==3){
				//归档节点
				span=pigeonholeSpan(fulldata[num].nodename,fulldata[num].operatornames);
				span.addClass("pigeonhole");
			}
			mainSpan.append(span);
			span.attr("id",spanId);
			span.css("top",span_y).css("left",span_x);
			
			spans[cnum]={id:spanId,
						 minx:span_x,
						 miny:span_y,
						 maxx:span_x+span.width(),
						 maxy:span_y+span.height()};
			
			spanId++;

			if(num==start_i&&startrows==-1){
				startSpan=spans[cnum];
				startrows=rows;
			}else if(num==stop_i&&stoprows==-1){
				stopSpan=spans[cnum];
				stoprows=rows;
			}
			//最后一组数据时，不需要继续执行了
			if(num==(fulldata.length-1)){
				break;
			}

			cnum++;
			if(cnum%cols==0){ //将要换行
				//加纵向箭头
				var arrow=Arrows();
				if(fulldata[num+1].nodetype == "1"){
					arrow.addClass("verticalArrows1");
				}else{
					arrow.addClass("verticalArrows");
				}
				arrow.css("top",span_y+span.height()).css("left",span_x);
				mainSpan.append(arrow);
				
				rows=(cnum/cols)%2;
				if(rows==0){
					span_x=initx;
					span_y=span_y+space_y;
				}else{
					span_x=span_x;
					span_y=span_y+space_y;
				}			

			}else{
				if(rows==0){
					
					//加横向箭头
					var arrow=Arrows();
					if(fulldata[num+1].nodetype == "1"){
						arrow.addClass("horizontalArrowsLeft1");
					}else{
						arrow.addClass("horizontalArrowsLeft");
					}
					arrow.css("top",span_y).css("left",span_x+span.width());
					mainSpan.append(arrow);

					span_x=span_x+space_x;
					span_y=span_y;					
				}else{
					//加横向箭头
					var arrow=Arrows();
					if(fulldata[num+1].nodetype == "1"){
						arrow.addClass("horizontalArrowsRight1");
					}else{
						arrow.addClass("horizontalArrowsRight");
					}
					mainSpan.append(arrow);
					arrow.css("top",span_y).css("left",span_x-arrow.width());				
				
					span_x=span_x-space_x;
					span_y=span_y;					
				}
			}
			
			num++;
			
		}

		jQuery("#mainSpan").mousedown(function (e){ 
			if(!!!jQuery(e.target).closest(".proposer1")[0] && !!!jQuery(e.target).closest(".approval1")[0] && !!!jQuery(e.target).closest(".manage1")[0] && !!!jQuery(e.target).closest(".pigeonhole1")[0]){
				if(jQuery(".nodeChecked").length>0){
					var tempactually = jQuery(".actually").length;
					if(tempactually>0){
						jQuery(".actually").removeClass("actually");
					}
					var tempclass = jQuery(".nodeChecked");
					tempclass.removeClass("nodeChecked");
					var delclass = tempclass.attr("class");
					tempclass.attr("class",delclass.substring(0,delclass.length-1));
					if(tempactually>0){
						jQuery(div).addClass("actually");
					}
				}
				//jQuery("#selectType").selectbox("detach");
				//document.all("selectType").disabled = true;
				//jQuery("#selectType").selectbox("attach");
				//var selectType = jQuery("#selectType option:selected").val();
				//if(selectType == 1){
				//	jQuery("#createrid_browserbtn").attr("disabled","true");
				//	jQuery(".e8_delClass").hide();
				//}
			}
			
			if(!!!jQuery(e.target).closest(".nodenamesavehide")[0]){
				$(".nodeshow").animate({ 
					width: 0
					}, 100,null,function() {
				}); 
				
				if(jQuery(".nodeshow").length>0){
					jQuery(".nodeshow").removeClass("nodeshow");
				}
			}
			
			if(!!!jQuery(e.target).closest(".operatorsavehide")[0] && !!!jQuery(e.target).closest(".operatorsavehideleft")[0]){
				$(".operatorshow").animate({ 
					width: 0
				}, 100,null,function() {
				});
				
				if(jQuery(".operatorshow").length>0){
					jQuery(".operatorshow").find(".operatorsave").height("40px");
					jQuery(".operatorshow").find(".operatorsaveleft").height("40px");
					jQuery(".operatorshow").height("45px");
					jQuery(".operatorshow").removeClass("operatorshow");
				}
				if(jQuery(".operatortocircle").length>0){
					var tempclass = jQuery(".operatortocircle");
					tempclass.removeClass("operatortocircle");
					var delclass = tempclass.attr("class");
					tempclass.attr("class",delclass.substring(0,delclass.length-3));
					var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
					tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
				}
				//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
			}
		});
		
		jQuery("#middlediv").bind("mouseover",function(e){
			jQuery("#forleft").show();
			jQuery("#forright").show();
		});
		
		jQuery("#middlediv").bind("mouseout",function(e){
			jQuery("#forleft").hide();
			jQuery("#forright").hide();
		});
		
		jQuery("#forleft").bind("mouseover",function(e){
			jQuery(this).attr("class","alefthot");
		});
		
		jQuery("#forleft").bind("mouseout",function(e){
			jQuery(this).attr("class","aleft");
		});
		
		jQuery("#forright").bind("mouseover",function(e){
			jQuery(this).attr("class","rightwardhot");
		});
		
		jQuery("#forright").bind("mouseout",function(e){
			jQuery(this).attr("class","rightward");
		});
		//resizeMain();
        //主动触发创建节点点击事件
		/*jQuery(".proposer2").trigger("mousedown");
		jQuery(".proposer1").trigger("mousedown");
		jQuery(".proposer").trigger("mousedown");*/

	}
	function isFreedata(nodeid){
		for(var i=0;i<freedata.length;i++){
			if(freedata[i].nodeid==nodeid){
				return true;
			}
		}
		return false;
	}
	/**创建节点**/
	function proposerSpan(title,operatornames){
		//class=\"content\" contenteditable=\"true\"
		//var div=jQuery("<div class=\"left\"><div class=\"headfoot\">"+title+"</div><div class=\"hfoot\">"+title+"</div></div>");
		//var div=jQuery("<div><div><table><tr align=\"center\"><td align=\"center\"><input type=\"text\" value=\""+title+"\" style=\"width:75px;border-style:none;text-align:center;vertical-align:middle;\" /></td></tr><tr align=\"center\"><td align=\"center\"><input type=\"text\" value=\""+title+"\" style=\"width:75px;border-style:none;text-align:center;vertical-align:middle;\" /></td></tr></table></div></div>");
		//if(wfid != 35){
			var div=jQuery("<div title=\"操作者："+operatornames+"\"><div name=\"firstdiv\" style=\"height:100px;line-height:100px;\">"+title+"</div><div name=\"insert\" class=\"insert\" title=\""+SystemEnv.getHtmlNoteName(3518)+"\"></div><div name=\"agency\" class=\"agency\" title=\""+SystemEnv.getHtmlNoteName(4002)+"\"></div><div name=\"operator\" class=\"operator\" title=\"操作人\"></div><div class=\"nodenamesavehide\"><div class=\"nodenamesave\"><div class=\"inputdiv\"><input type=\"text\" name=\"inputnodeid\" class=\"inputnodeclass\" ></div><div name=\"nodenamebrow\" class=\"nodenamebrow\"></div></div></div><div class=\"operatorsavehideleft\"><div class=\"operatorsaveleft\"><div style=\"float:left;width:8px;height:30px;\"></div><div name=\"operatorcircle0\" class=\"operatorcircle0\"><div class=\"hook\"></div><div name=\"wordclass0\" class=\"wordclass0\">指定人</div></div><div name=\"operatorcircle1\" class=\"operatorcircle1\"><div class=\"hook\"></div><div name=\"wordclass1\" class=\"wordclass1\">所有人</div></div><div name=\"operatorcircle2\" class=\"operatorcircle2\"><div class=\"hook\"></div><div name=\"wordclass2\" class=\"wordclass2\">创建人本人</div></div><div name=\"operatorcircle3\" class=\"operatorcircle3\"><div class=\"hook\"></div><div name=\"wordclass3\" class=\"wordclass3\">创建人经理</div></div><div name=\"operatorbrow\" class=\"operatorbrow\"></div><div name=\"createspanfor\" style=\"width:350px;height:36px;line-height:34px;font-size:14px;margin-left:8px;padding-top:5px;\"></div></div><div class=\"operatorbtn\"></div></div></div>");
		//}else{
		//	var div=jQuery("<div><div name=\"firstdiv\" style=\"height:100px;line-height:100px;\">"+title+"</div><div name=\"agency\" class=\"agency\" title=\""+SystemEnv.getHtmlNoteName(4002)+"\"></div><div class=\"nodenamesavehide\"><div class=\"nodenamesave\"><div class=\"inputdiv\"><input type=\"text\" name=\"inputnodeid\" class=\"inputnodeclass\" ></div><div name=\"nodenamebrow\" class=\"nodenamebrow\"></div></div></div></div>");
		//}
		jQuery(div).find("div[name=insert]").css({"top":"0px","left":"65px"});
		jQuery(div).find("div[name=agency]").css({"top":"0px","left":"90px"});
		jQuery(div).find("div[name=operator]").css({"top":"0px","left":"115px"});
		//jQuery(div).find(".nodenamesave").css({"top":"-20px","left":"-45px"});
		jQuery(div).find(".nodenamesavehide").css({"top":"-20px","right":"0px"});
		jQuery(div).find(".operatorsavehideleft").css({"top":"-20px","left":"0px"});
		
		div.mousedown(function (){
			var id=jQuery(this).attr("id");
			doMouseDown(this);
		});
		
		div.hover(function (){
			var id=jQuery(this).attr("id");
			var position = jQuery(this).position();
			//var divleft = 55;
			//var divtop = 0;
			
			var firstleft = 60;//按钮的初始位置
			var firsttop = 50;
			jQuery(this).find("div[name=insert]").show();
			jQuery(this).find("div[name=agency]").show();
			jQuery(this).find("div[name=operator]").show();
			//jQuery(this).find(".insert").css({"top":firsttop+"px","left":firstleft+"px"});
			//jQuery(this).find(".insert").css({"top":divtop+"px","left":divleft+"px"});
			
			/*jQuery(this).find(".insert").animate({
			      top     : divtop + 'px',
			      left    : divleft + 'px',
			      opacity : "show",
			      width   : 25,
			      height  : 25
			    }, 100, null, function() {
			});*/
			
			if(jQuery(".actually").length>0){
				jQuery(".actually").removeClass("actually");
			}	
			jQuery(div).addClass("actually");
			
			jQuery(this).find("div[name=insert]").unbind('click').bind('click',function(e){
				var tempid = jQuery(div).attr("id");
				addApproval0(tempid);
			});
			
			jQuery(this).find("div[name=agency]").unbind('click').bind('click',function(e){
				//var tempid = jQuery(div).attr("id");
				//if(showover == 0){
					alterationNodeName(div);
				//}
			});
			//操作人编辑事件
			jQuery(this).find("div[name=operator]").unbind('click').bind('click',function(e){
				jQuery(div).find("div[name=createspanfor]").e8Browser({
					   name:"createrid"+id,
					   viewType:"0",
					   browserValue:"",
					   isMustInput:"1",
					   browserSpanValue:"",
					   hasInput:true,
					   linkUrl:"#",
					   isSingle:true,
					   completeUrl:"/data.jsp",
					   browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					   width:"150px",
					   hasAdd:false,
					   isSingle:true
				});
				alterationOperatorleft(div,"0");
			});
		});
		
		//添加按钮事件
		jQuery(div).find("div[name=insert]").bind("mouseover",function(e){
			jQuery(this).attr("class","inserthot");
		});
		jQuery(div).find("div[name=insert]").bind("mouseout",function(e){
			jQuery(this).attr("class","insert");
		});
		jQuery(div).find("div[name=agency]").bind("mouseover",function(e){
			jQuery(this).attr("class","agencyhot");
		});
		jQuery(div).find("div[name=agency]").bind("mouseout",function(e){
			jQuery(this).attr("class","agency");
		});
		jQuery(div).find("div[name=operator]").bind("mouseover",function(e){
			jQuery(this).attr("class","operatorhot");
		});
		jQuery(div).find("div[name=operator]").bind("mouseout",function(e){
			jQuery(this).attr("class","operator");
		});
		
		
		div.hover(null, function (){
			var id=jQuery(this).attr("id");
			if(jQuery(".actually").length>0){
				jQuery(".actually").removeClass("actually");
			}	
			var position = jQuery(this).position();
			var divleft = 60;
			var divtop = 50;
			jQuery(this).find("div[name=insert]").hide();
			jQuery(this).find("div[name=agency]").hide();
			jQuery(this).find("div[name=operator]").hide();
			/*
			jQuery(this).find(".insert").animate({
			      top     : divtop + 'px',
			      left    : divleft + 'px',
			      opacity : "hide",
				  width   : '1px',
				  height  : '1px'
			    }, 0, null, function() {
			});
			*/
		});

		/*div.children().dblclick(function() { 
			var judge = jQuery(this).attr("name");
			if(judge === "firstdiv"){
				toReplace(this);
			}
		});*/
		return div;
	}
	
	//var shnode;
	function alterationNodeName(obj){
		jQuery(obj).find(".nodenamesave").show();
		jQuery(obj).find(".nodenamesavehide").show();
		//showover++;
		//shnode = setInterval(widthDecrease,20,obj);
		var id=jQuery(obj).attr("id");
		var tempnodename = jQuery("#wfEditForm").find("input[name=nodename_"+id+"]").val();//名称
		//alert(tempnodename);
		jQuery(obj).find("input[name=inputnodeid]").val(tempnodename);
		jQuery(obj).find("input[name=inputnodeid]").focus();
		
		if(jQuery(".nodeshow").length>0){
			jQuery(".nodeshow").removeClass("nodeshow");
		}
		jQuery(obj).find(".nodenamesavehide").addClass("nodeshow");
		
		jQuery(obj).find("div[name=nodenamebrow]").bind("mouseover",function(e){
			jQuery(this).attr("class","nodenamebrowhot");
		});
		
		jQuery(obj).find("div[name=nodenamebrow]").bind("mouseout",function(e){
			jQuery(this).attr("class","nodenamebrow");
		});
		
		jQuery(obj).find("div[name=nodenamebrow]").unbind('click').bind('click',function(e){
			var savenodeid = jQuery("#wfEditForm").find("input[name=wfnodeid_"+id+"]").val();
			var ismodify__ = jQuery("#wfEditForm").find("input[name=ismodify_"+id+"]").val();
			var savenodename = jQuery(obj).find("input[name=inputnodeid]").val();
			if(savenodename != ""){
				if(ismodify__ != "1"){
					$.ajax({
						type: "post",
					    url: "/rdeploy/wf/request/wfStatusOperation.jsp?_" + new Date().getTime() + "=1&",
					    data: {
					    	"wfid":wfid,
					    	"savenodeid":savenodeid,
					    	"savenodename":savenodename,
					    	"actionkey":"nodechange"
					    	},
					    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					    complete: function(){
						},
					    error:function (XMLHttpRequest, textStatus, errorThrown) {
					    } , 
					    success:function (data, textStatus) {
					    	var _data = jQuery.parseJSON(data);
					    	var _success = _data.success;
					    	/////////////
					    	if(_success == "success"){
						    	jQuery("#wfEditForm").find("input[name=nodename_"+id+"]").val(savenodename);
						    	jQuery(obj).find("div[name=firstdiv]").html(savenodename);
						    	$(".nodeshow").animate({ 
						    		width: 0
						    	}, 100,null,function() {
						    	}); 
						    	if(jQuery(".nodeshow").length>0){
						    		jQuery(".nodeshow").removeClass("nodeshow");
						    	}
						    	var ismodify = 0;
						    	var rownumadd = 0;
						    	try {
						    		rownumadd = parseInt(jQuery("#rownum").val());
						    		ismodify = parseInt(jQuery("input[name=ismodify_"+id+"]").val());
						    	} catch (e) {}
						    	if(ismodify === 0){
						    		jQuery("input[name=ismodify_"+id+"]").val("2");
						    	}
						    	jQuery("#rownum").val(rownumadd+1);
					    	}else{
					    		top.Dialog.alert(SystemEnv.getHtmlNoteName(4008));
					    		return false;
					    	}
					    	/////////////
					    } 
			    	});
				}else{
					jQuery("#wfEditForm").find("input[name=nodename_"+id+"]").val(savenodename);
			    	jQuery(obj).find("div[name=firstdiv]").html(savenodename);
			    	$(".nodeshow").animate({ 
			    		width: 0
			    	}, 100,null,function() {
			    	}); 
			    	if(jQuery(".nodeshow").length>0){
			    		jQuery(".nodeshow").removeClass("nodeshow");
			    	}
			    	//var ismodify = 0;
			    	var rownumadd = 0;
			    	try {
			    		rownumadd = parseInt(jQuery("#rownum").val());
			    		//ismodify = parseInt(jQuery("input[name=ismodify_"+id+"]").val());
			    	} catch (e) {}
			    	//if(ismodify === 0){
			    	//	jQuery("input[name=ismodify_"+id+"]").val("2");
			    	//}
			    	jQuery("#rownum").val(rownumadd+1);
				}
			}else{
				top.Dialog.alert(SystemEnv.getHtmlNoteName(4009));
				return false;
			}
		});
		
		jQuery(obj).find(".nodenamesavehide").animate({ 
		    //width:[185, 'easeOutBounce']
			width:[185, 'easeInQuad']
		},200); 
		
	}
	
	function alterationOperator(obj,optype){
		jQuery(obj).find(".operatorsave").show();
		jQuery(obj).find(".operatorsavehide").show();
		//shnode = setInterval(widthDecrease,20,obj);
		var id=jQuery(obj).attr("id");
		//jQuery(obj).find("input[name=inputnodeid]").val(tempnodename);
		//jQuery(obj).find("input[name=inputnodeid]").focus();
		
		if(jQuery(".operatorshow").length>0){
			jQuery(".operatorshow").removeClass("operatorshow");
		}
		jQuery(obj).find(".operatorsavehide").addClass("operatorshow");
		
		jQuery(obj).find("div[name=operatorbrow]").bind("mouseover",function(e){
			jQuery(this).attr("class","operatorbrowhot");
		});
		jQuery(obj).find("div[name=operatorbrow]").bind("mouseout",function(e){
			jQuery(this).attr("class","operatorbrow");
		});
		
		var currentoptype = 0;
		try {
			currentoptype = parseInt(jQuery("#wfEditForm").find("input[name=grouptype_"+id+"]").val());
		} catch (e) {}
		if(currentoptype == 3){
			jQuery(obj).find("div[name=operatorcircle0]").attr("class","operatorcircle0hot")
			jQuery(obj).find("div[name=operatorcircle0]").find("div[name=wordclass0]").attr("class","wordclass0hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle0]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle0]").closest(".operatorsave").height("90px");
			jQuery(".operatorshow").height("95px");
			__initbrowser(id);
		}else if(currentoptype == 4){
			jQuery(obj).find("div[name=operatorcircle1]").attr("class","operatorcircle1hot");
			jQuery(obj).find("div[name=operatorcircle1]").find("div[name=wordclass1]").attr("class","wordclass1hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle1]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle1]").closest(".operatorsave").height("40px");
			jQuery(".operatorshow").height("45px");
		}else if(currentoptype == 17){
			jQuery(obj).find("div[name=operatorcircle2]").attr("class","operatorcircle2hot");
			jQuery(obj).find("div[name=operatorcircle2]").find("div[name=wordclass2]").attr("class","wordclass2hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle2]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle2]").closest(".operatorsave").height("40px");
			jQuery(".operatorshow").height("45px");
		}else if(currentoptype == 18){
			jQuery(obj).find("div[name=operatorcircle3]").attr("class","operatorcircle3hot");
			jQuery(obj).find("div[name=operatorcircle3]").find("div[name=wordclass3]").attr("class","wordclass3hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle3]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle3]").closest(".operatorsave").height("40px");
			jQuery(".operatorshow").height("45px");
		}
		
		//选中操作者--start
		jQuery(obj).find("div[name=operatorcircle0]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle0hot");
			jQuery(this).find("div[name=wordclass0]").attr("class","wordclass0hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsave").height("90px");
			jQuery(".operatorshow").height("95px");
			//var operatorposition = jQuery(".nodeChecked").position();
			//var operatorleft = operatorposition.left;
			//var operatortop = operatorposition.top;
			//if(optype == "0"){
			//	jQuery(".rowinputblockleft4").css({"top":operatortop+73+"px","left":operatorleft-230+"px"});
			//}else{
			//	jQuery(".rowinputblockleft4").css({"top":operatortop+65+"px","left":operatorleft-225+"px"});
			//}
		});
		jQuery(obj).find("div[name=operatorcircle1]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle1hot");
			jQuery(this).find("div[name=wordclass1]").attr("class","wordclass1hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsave").height("40px");
			jQuery(".operatorshow").height("45px");
			//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
		});
		jQuery(obj).find("div[name=operatorcircle2]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle2hot");
			jQuery(this).find("div[name=wordclass2]").attr("class","wordclass2hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsave").height("40px");
			jQuery(".operatorshow").height("45px");
			//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
		});
		jQuery(obj).find("div[name=operatorcircle3]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle3hot");
			jQuery(this).find("div[name=wordclass3]").attr("class","wordclass3hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsave").height("40px");
			jQuery(".operatorshow").height("45px");
			//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
			
		});
		//选中操作者--end
		//保存操作者
		jQuery(obj).find("div[name=operatorbrow]").unbind('click').bind('click',function(e){
			var ismodify__ = jQuery("#wfEditForm").find("input[name=ismodify_"+id+"]").val();
			if(jQuery(".operatortocircle").length>0){
				var savenodeid = jQuery("#wfEditForm").find("input[name=wfnodeid_"+id+"]").val();
				var selectType = jQuery(".operatortocircle").attr("name");
				var grouptypeid,nowobjname;
				if(selectType == "operatorcircle0"){
					grouptypeid = "3";
					nowobjname = "操作人："+jQuery("#createrid"+id+"span").find("a").html();
				}else if(selectType == "operatorcircle1"){
					grouptypeid = "4";
					nowobjname = "操作人：所有人";
				}else if(selectType == "operatorcircle3"){
					grouptypeid = "18";
					nowobjname = "操作人：创建人经理";
				}else if(selectType == "operatorcircle2"){
					grouptypeid = "17";
					nowobjname = "操作人：创建人本人";
				}
				if(ismodify__ != "1"){
					var objid = jQuery("#createrid"+id).val();
					if((grouptypeid == "3" && objid != "" && objid != null) || grouptypeid != "3"){
						$.ajax({
							type: "post",
							url: "/rdeploy/wf/request/wfAssignerOperation.jsp?_" + new Date().getTime() + "=1&",
							data: {
								"wfid":wfid,
								"savenodeid":savenodeid,
								"grouptype":grouptypeid,
								"objid":objid
							},
							contentType : "application/x-www-form-urlencoded; charset=UTF-8",
							complete: function(){
							},
							error:function (XMLHttpRequest, textStatus, errorThrown) {
							} , 
							success:function (data, textStatus) {
								var _data = jQuery.parseJSON(data);
								var _success = _data.success;
								/////////////
								if(_success == "success"){
									changeGroupType();
									jQuery(obj).attr("title",nowobjname);
									
									$(".operatorshow").animate({ 
										width: 0
									}, 100,null,function() {
									}); 
									//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
									if(jQuery(".operatortocircle").length>0){
										var tempclass = jQuery(".operatortocircle");
										tempclass.removeClass("operatortocircle");
										var delclass = tempclass.attr("class");
										tempclass.attr("class",delclass.substring(0,delclass.length-3));
										var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
										tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
									}
								}else{
									top.Dialog.alert("节点操作者保存错误！");
									return false;
								}
								/////////////
							} 
						});
					}else{
						top.Dialog.alert("请选择指定操作者！");
						return false;
					}
				}else{
					//jQuery("#wfEditForm").find("input[name=nodename_"+id+"]").val(savenodename);
			    	//jQuery(obj).find("div[name=firstdiv]").html(savenodename);
					changeGroupType();
			    	$(".operatorshow").animate({ 
			    		width: 0
			    	}, 100,null,function() {
			    	}); 
			    	jQuery(obj).attr("title",nowobjname);
			    	//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
			    	if(jQuery(".operatortocircle").length>0){
			    		var tempclass = jQuery(".operatortocircle");
						tempclass.removeClass("operatortocircle");
						var delclass = tempclass.attr("class");
						tempclass.attr("class",delclass.substring(0,delclass.length-3));
						var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
						tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			    	}
			    	/*var rownumadd = 0;
			    	try {
			    		rownumadd = parseInt(jQuery("#rownum").val());
			    	} catch (e) {}
			    	jQuery("#rownum").val(rownumadd+1);*/
				}
			}else{
				top.Dialog.alert("请选择操作者类型！");
				return false;
			}
		});
		
		jQuery(obj).find(".operatorshow").animate({ 
		    //width:[185, 'easeOutBounce']
			width:[386, 'easeInQuad']
		},200); 
	}
	
	function alterationOperatorleft(obj,optype){
		jQuery(obj).find(".operatorsaveleft").show();
		jQuery(obj).find(".operatorsavehideleft").show();
		//shnode = setInterval(widthDecrease,20,obj);
		var id=jQuery(obj).attr("id");
		//jQuery(obj).find("input[name=inputnodeid]").val(tempnodename);
		//jQuery(obj).find("input[name=inputnodeid]").focus();
		
		if(jQuery(".operatorshow").length>0){
			jQuery(".operatorshow").removeClass("operatorshow");
		}
		jQuery(obj).find(".operatorsavehideleft").addClass("operatorshow");
		
		var currentoptype = 0;
		try {
			currentoptype = parseInt(jQuery("#wfEditForm").find("input[name=grouptype_"+id+"]").val());
		} catch (e) {}
		if(currentoptype == 3){
			jQuery(obj).find("div[name=operatorcircle0]").attr("class","operatorcircle0hot")
			jQuery(obj).find("div[name=operatorcircle0]").find("div[name=wordclass0]").attr("class","wordclass0hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle0]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle0]").closest(".operatorsaveleft").height("90px");
			jQuery(".operatorshow").height("95px");
			__initbrowser(id);
		}else if(currentoptype == 4){
			jQuery(obj).find("div[name=operatorcircle1]").attr("class","operatorcircle1hot");
			jQuery(obj).find("div[name=operatorcircle1]").find("div[name=wordclass1]").attr("class","wordclass1hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle1]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle1]").closest(".operatorsaveleft").height("40px");
			jQuery(".operatorshow").height("45px");
		}else if(currentoptype == 17){
			jQuery(obj).find("div[name=operatorcircle2]").attr("class","operatorcircle2hot");
			jQuery(obj).find("div[name=operatorcircle2]").find("div[name=wordclass2]").attr("class","wordclass2hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle2]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle2]").closest(".operatorsaveleft").height("40px");
			jQuery(".operatorshow").height("45px");
		}else if(currentoptype == 18){
			jQuery(obj).find("div[name=operatorcircle3]").attr("class","operatorcircle3hot");
			jQuery(obj).find("div[name=operatorcircle3]").find("div[name=wordclass3]").attr("class","wordclass3hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(obj).find("div[name=operatorcircle3]").addClass("operatortocircle");
			jQuery(obj).find("div[name=operatorcircle3]").closest(".operatorsaveleft").height("40px");
			jQuery(".operatorshow").height("45px");
		}
		
		jQuery(obj).find("div[name=operatorbrow]").bind("mouseover",function(e){
			jQuery(this).attr("class","operatorbrowhot");
		});
		jQuery(obj).find("div[name=operatorbrow]").bind("mouseout",function(e){
			jQuery(this).attr("class","operatorbrow");
		});
		//选中操作者--start
		jQuery(obj).find("div[name=operatorcircle0]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle0hot");
			jQuery(this).find("div[name=wordclass0]").attr("class","wordclass0hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsaveleft").height("90px");
			jQuery(".operatorshow").height("95px");
			//var operatorposition = jQuery(".nodeChecked").position();
			//var operatorleft = operatorposition.left;
			//var operatortop = operatorposition.top;
			//if(optype == "0"){
			//	jQuery(".rowinputblockleft4").css({"top":operatortop+73+"px","left":operatorleft+10+"px"});
			//}else{
			//	jQuery(".rowinputblockleft4").css({"top":operatortop+65+"px","left":operatorleft+10+"px"});
			//}
		});
		jQuery(obj).find("div[name=operatorcircle1]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle1hot");
			jQuery(this).find("div[name=wordclass1]").attr("class","wordclass1hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsaveleft").height("40px");
			jQuery(".operatorshow").height("45px");
			//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
		});
		jQuery(obj).find("div[name=operatorcircle2]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle2hot");
			jQuery(this).find("div[name=wordclass2]").attr("class","wordclass2hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsaveleft").height("40px");
			jQuery(".operatorshow").height("45px");
			//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
		});
		jQuery(obj).find("div[name=operatorcircle3]").unbind('click').bind("click",function(e){
			jQuery(this).attr("class","operatorcircle3hot");
			jQuery(this).find("div[name=wordclass3]").attr("class","wordclass3hot");
			if(jQuery(".operatortocircle").length>0){
				var tempclass = jQuery(".operatortocircle");
				tempclass.removeClass("operatortocircle");
				var delclass = tempclass.attr("class");
				tempclass.attr("class",delclass.substring(0,delclass.length-3));
				var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
				tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			}
			jQuery(this).addClass("operatortocircle");
			jQuery(this).closest(".operatorsaveleft").height("40px");
			jQuery(".operatorshow").height("45px");
			//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
			
		});
		//选中操作者--end
		//保存操作者
		jQuery(obj).find("div[name=operatorbrow]").unbind('click').bind('click',function(e){
			var ismodify__ = jQuery("#wfEditForm").find("input[name=ismodify_"+id+"]").val();
			if(jQuery(".operatortocircle").length>0){
				var savenodeid = jQuery("#wfEditForm").find("input[name=wfnodeid_"+id+"]").val();
				var selectType = jQuery(".operatortocircle").attr("name");
				var grouptypeid,nowobjname;
				if(selectType == "operatorcircle0"){
					grouptypeid = "3";
					nowobjname = "操作人："+jQuery("#createrid"+id+"span").find("a").html();
				}else if(selectType == "operatorcircle1"){
					grouptypeid = "4";
					nowobjname = "操作人：所有人";
				}else if(selectType == "operatorcircle3"){
					grouptypeid = "18";
					nowobjname = "操作人：创建人经理";
				}else if(selectType == "operatorcircle2"){
					grouptypeid = "17";
					nowobjname = "操作人：创建人本人";
				}
				if(ismodify__ != "1"){
					var objid = jQuery("#createrid"+id).val();
					if((grouptypeid == "3" && objid != "" && objid != null) || grouptypeid != "3"){
						$.ajax({
							type: "post",
							url: "/rdeploy/wf/request/wfAssignerOperation.jsp?_" + new Date().getTime() + "=1&",
							data: {
								"wfid":wfid,
								"savenodeid":savenodeid,
								"grouptype":grouptypeid,
								"objid":objid
							},
							contentType : "application/x-www-form-urlencoded; charset=UTF-8",
							complete: function(){
							},
							error:function (XMLHttpRequest, textStatus, errorThrown) {
							} , 
							success:function (data, textStatus) {
								var _data = jQuery.parseJSON(data);
								var _success = _data.success;
								/////////////
								if(_success == "success"){
									changeGroupType();
									jQuery(obj).attr("title",nowobjname);
									
									$(".operatorshow").animate({ 
										width: 0
									}, 100,null,function() {
									}); 
									//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
									if(jQuery(".operatortocircle").length>0){
										var tempclass = jQuery(".operatortocircle");
										tempclass.removeClass("operatortocircle");
										var delclass = tempclass.attr("class");
										tempclass.attr("class",delclass.substring(0,delclass.length-3));
										var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
										tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
									}
								}else{
									top.Dialog.alert("节点操作者保存错误！");
									return false;
								}
								/////////////
							} 
						});
					}else{
						top.Dialog.alert("请选择指定操作者！");
						return false;
					}
				}else{
					//jQuery("#wfEditForm").find("input[name=nodename_"+id+"]").val(savenodename);
			    	//jQuery(obj).find("div[name=firstdiv]").html(savenodename);
					changeGroupType();
			    	$(".operatorshow").animate({ 
			    		width: 0
			    	}, 100,null,function() {
			    	}); 
			    	jQuery(obj).attr("title",nowobjname);
			    	//jQuery(".rowinputblockleft4").css({"top":"-200px","left":"20px"});
			    	if(jQuery(".operatortocircle").length>0){
			    		var tempclass = jQuery(".operatortocircle");
						tempclass.removeClass("operatortocircle");
						var delclass = tempclass.attr("class");
						tempclass.attr("class",delclass.substring(0,delclass.length-3));
						var delwordclass = tempclass.find("div[name^=wordclass]").attr("class");
						tempclass.find("div[name^=wordclass]").attr("class",delwordclass.substring(0,delwordclass.length-3));
			    	}
			    	/*var rownumadd = 0;
			    	try {
			    		rownumadd = parseInt(jQuery("#rownum").val());
			    	} catch (e) {}
			    	jQuery("#rownum").val(rownumadd+1);*/
				}
			}else{
				top.Dialog.alert("请选择操作者类型！");
				return false;
			}
		});
		
		jQuery(obj).find(".operatorshow").animate({ 
		    //width:[185, 'easeOutBounce']
			width:[386, 'easeInQuad']
		},200); 
	}
	
	/*function widthDecrease(obj){
		var width=jQuery(obj).find(".nodenamesavehide").width()+5;
		if(width < 190){
			jQuery(obj).find(".nodenamesavehide").width(width);
		}else{
			//jQuery(obj).find(".nodenamesavehide").hide();
			clearInterval(shnode);
			showover--;
			return false;
		}
	}*/
	
	function toReplace(divElement) { 
		// 创建一个input元素 
		var divhtml = jQuery(divElement).html();
		// 把obj里面的元素以及文本内容赋值给新建的inputElement 
		var inputElement="<input type='text' class='operateinput' value='"+divhtml+"'/>";
		// 将创建的input放入div
		jQuery(divElement).html(inputElement);
		jQuery(".operateinput").focus();
		// 当input失去焦点时触发下面函数，使得input变成div 
		jQuery(".operateinput").blur(function() { 
			//把input的值交给原来的div 
			var inputval = jQuery(".operateinput").val();
			//用原来的div重新替换inputElement 
			jQuery(divElement).html(inputval);
			var index = jQuery(divElement).parent().attr("id");
			jQuery("input[name=nodename_"+index+"]").val(inputval);
			var ismodify_ = jQuery("input[name=ismodify_"+index+"]").val();
			if(ismodify_ == 0){
				jQuery("input[name=ismodify_"+index+"]").val("2");
			}
		});
	}

	/**审批人**/
	function approvalSpan(title,operatornames){
		//var div=jQuery("<div><div>"+title+"</div></div>");
		var div=jQuery("<div title=\"操作者："+operatornames+"\" ><div name=\"firstdiv\" style=\"height:100px;line-height:100px;\">"+title+"</div><div name=\"remove\" class=\"remove\" title=\""+SystemEnv.getHtmlNoteName(3519)+"\"></div><div name=\"insert\" class=\"insert\" title=\""+SystemEnv.getHtmlNoteName(3518)+"\"></div><div name=\"agency\" class=\"agency\" title=\""+SystemEnv.getHtmlNoteName(4002)+"\"></div><div name=\"operator\" class=\"operator\" title=\"操作人\"></div><div class=\"nodenamesavehide\"><div class=\"nodenamesave\"><div class=\"inputdiv\"><input type=\"text\" name=\"inputnodeid\" class=\"inputnodeclass\" ></div><div name=\"nodenamebrow\" class=\"nodenamebrow\"></div></div></div><div class=\"operatorsavehide\"><div class=\"operatorsave\"><div style=\"float:left;width:8px;height:30px;\"></div><div name=\"operatorcircle0\" class=\"operatorcircle0\"><div class=\"hook\"></div><div name=\"wordclass0\" class=\"wordclass0\">指定人</div></div><div name=\"operatorcircle1\" class=\"operatorcircle1\"><div class=\"hook\"></div><div name=\"wordclass1\" class=\"wordclass1\">所有人</div></div><div name=\"operatorcircle2\" class=\"operatorcircle2\"><div class=\"hook\"></div><div name=\"wordclass2\" class=\"wordclass2\">创建人本人</div></div><div name=\"operatorcircle3\" class=\"operatorcircle3\"><div class=\"hook\"></div><div name=\"wordclass3\" class=\"wordclass3\">创建人经理</div></div><div name=\"operatorbrow\" class=\"operatorbrow\"></div><div name=\"createspanfor\" style=\"width:350px;height:36px;line-height:34px;font-size:14px;margin-left:8px;padding-top:5px;\"></div></div><div class=\"operatorbtn\"></div></div></div>");
		jQuery(div).find("div[name=insert]").css({"top":"-10px","left":"50px"});
		jQuery(div).find("div[name=remove]").css({"top":"-10px","left":"75px"});
		jQuery(div).find("div[name=agency]").css({"top":"-10px","left":"100px"});
		jQuery(div).find("div[name=operator]").css({"top":"-10px","left":"125px"});
		jQuery(div).find(".nodenamesavehide").css({"top":"-30px","right":"-5px"});
		div.mousedown(function (){
			var id=jQuery(this).attr("id");
			doMouseDown(this);
		});
		div.hover(function (){
			var id=jQuery(this).attr("id");
			if(jQuery(".actually").length>0){
				jQuery(".actually").removeClass("actually");
			}	
			jQuery(div).addClass("actually");
			//var position = jQuery(this).position();

			//var divleft = 0;
			//var divtop = -10;
			
			//var firstleft = 70;//两按钮的初始位置
			//var firsttop = 50;
			
			//jQuery(this).find(".insert").css({"top":firsttop+"px","left":firstleft+"px","width":"1px","height":"1px"});
			//jQuery(this).find(".remove").css({"top":firsttop+"px","left":firstleft+"px","width":"1px","height":"1px"});
			
			jQuery(this).find("div[name=insert]").show();
			jQuery(this).find("div[name=remove]").show();
			jQuery(this).find("div[name=agency]").show();
			jQuery(this).find("div[name=operator]").show();
			
			/*jQuery(this).find(".remove").animate({
			      top     : divtop + 'px',
			      left    : divleft + 15 + 'px',
			      opacity : "show",
			      width   : 25,
			      height  : 25
			    }, 100, null, function() {
			});
			jQuery(this).find(".insert").animate({
				top     : divtop + 'px',
				left    : divleft + 105 + 'px',
				opacity : "show",
				width   : 25,
				height  : 25
			}, 100, null, function() {
			});*/
			//添加按钮事件
			jQuery(this).find("div[name=insert]").unbind('click').bind('click',function(e){
				var tempid = jQuery(div).attr("id");
				addApproval(tempid);
			});
			//删除按钮事件
			jQuery(this).find("div[name=remove]").unbind('click').bind('click',function(e){
				var tempid = jQuery(div).attr("id");
				removeApprovalnew(tempid);
			});
			jQuery(this).find("div[name=agency]").unbind('click').bind('click',function(e){
				//var tempid = jQuery(div).attr("id");
				//if(showover == 0){
					alterationNodeName(div);
				//}
			});
			//操作人编辑事件
			jQuery(this).find("div[name=operator]").unbind('click').bind('click',function(e){
				//if(!!!jQuery(div).find("#createrid"+id)){
					jQuery(div).find("div[name=createspanfor]").e8Browser({
						   name:"createrid"+id,
						   viewType:"0",
						   browserValue:"",
						   isMustInput:"1",
						   browserSpanValue:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp",
						   browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
						   width:"150px",
						   hasAdd:false,
						   isSingle:true
					});
				//}
				var floworder__ = 0;
				try {
					floworder__ = parseInt(jQuery("#wfEditForm").find("input[name=floworder_"+id+"]").val());
		    	} catch (e) {}
		    	if(floworder__ > 7 &&(floworder__%8 == 0 || floworder__%8 == 1)){
		    		if(jQuery(div).find(".operatorsavehide").length>0){
						var reclass0 = jQuery(div).find(".operatorsave").attr("class");
						var reclass1 = jQuery(div).find(".operatorsavehide").attr("class");
						
						jQuery(div).find(".operatorsave").attr("class","operatorsaveleft");
						jQuery(div).find(".operatorsavehide").attr("class","operatorsavehideleft");
					}
		    		jQuery(div).find(".operatorsavehideleft").css({"top":"-30px","left":"-5px"});
					//jQuery(div).find(".operatorsavehideleft").css({"top":"-20px","left":"0px"});
					alterationOperatorleft(div,"1");
				}else{
					if(jQuery(div).find(".operatorsavehideleft").length>0){
						var reclass0 = jQuery(div).find(".operatorsaveleft").attr("class");
						var reclass1 = jQuery(div).find(".operatorsavehideleft").attr("class");
						jQuery(div).find(".operatorsaveleft").attr("class",reclass0.substring(0,reclass0.length-4));
						jQuery(div).find(".operatorsavehideleft").attr("class",reclass1.substring(0,reclass1.length-4));
					}
					jQuery(div).find(".operatorsavehide").css({"top":"-30px","right":"-5px"});
					//jQuery(div).find(".operatorsavehide").css({"top":"-20px","right":"0px"});
					alterationOperator(div,"1");
				}
			});
		});
		
		jQuery(div).find("div[name=insert]").bind("mouseover",function(e){
			jQuery(this).attr("class","inserthot");
		});
		jQuery(div).find("div[name=insert]").bind("mouseout",function(e){
			jQuery(this).attr("class","insert");
		});
		jQuery(div).find("div[name=remove]").bind("mouseover",function(e){
			jQuery(this).attr("class","removehot");
		});
		jQuery(div).find("div[name=remove]").bind("mouseout",function(e){
			jQuery(this).attr("class","remove");
		});
		jQuery(div).find("div[name=agency]").bind("mouseover",function(e){
			jQuery(this).attr("class","agencyhot");
		});
		jQuery(div).find("div[name=agency]").bind("mouseout",function(e){
			jQuery(this).attr("class","agency");
		});
		jQuery(div).find("div[name=operator]").bind("mouseover",function(e){
			jQuery(this).attr("class","operatorhot");
		});
		jQuery(div).find("div[name=operator]").bind("mouseout",function(e){
			jQuery(this).attr("class","operator");
		});
		
		
		div.hover(null, function (){
			var id=jQuery(this).attr("id");
			if(jQuery(".actually").length>0){
				jQuery(".actually").removeClass("actually");
			}	
			var position = jQuery(this).position();
			var divleft = 70;
			var divtop = 50;
			
			jQuery(this).find("div[name=insert]").hide();
			jQuery(this).find("div[name=remove]").hide();
			jQuery(this).find("div[name=agency]").hide();
			jQuery(this).find("div[name=operator]").hide();
			/*jQuery(this).find(".insert").animate({
			      top     : divtop + 'px',
			      left    : divleft + 'px',
			      opacity : "hide",
				  width   : 1,
				  height  : 1
			    }, 0, null, function() {
			});
			jQuery(this).find(".remove").animate({
				top     : divtop + 'px',
				left    : divleft + 'px',
				opacity : "hide",
				width   : 1,
				height  : 1
			}, 0, null, function() {
			});*/
		});
		
		/*div.children().dblclick(function() {
			var judge = jQuery(this).attr("name");
			if(judge === "firstdiv"){
				toReplace(this);
			}
		});*/
		/*div.hover(null, function () {
			var id=jQuery(this).attr("id");
			jQuery(".menu").css("display","none");
		})*/
		return div;	
	}
	/**处理人**/
	function manageSpan(title,operatornames){
		//var div=jQuery("<div><div>"+title+"</div></div>");
		
		var div=jQuery("<div title=\"操作者："+operatornames+"\"><div name=\"firstdiv\" style=\"height:100px;line-height:100px;\">"+title+"</div><div name=\"remove\" class=\"remove\" title=\""+SystemEnv.getHtmlNoteName(3519)+"\"></div><div name=\"insert\" class=\"insert\" title=\""+SystemEnv.getHtmlNoteName(3518)+"\"></div><div name=\"agency\" class=\"agency\" title=\""+SystemEnv.getHtmlNoteName(4002)+"\"></div><div name=\"operator\" class=\"operator\" title=\"操作人\"></div><div class=\"nodenamesavehide\"><div class=\"nodenamesave\"><div class=\"inputdiv\"><input type=\"text\" name=\"inputnodeid\" class=\"inputnodeclass\" ></div><div name=\"nodenamebrow\" class=\"nodenamebrow\"></div></div></div><div class=\"operatorsavehide\"><div class=\"operatorsave\"><div style=\"float:left;width:8px;height:30px;\"></div><div name=\"operatorcircle0\" class=\"operatorcircle0\"><div class=\"hook\"></div><div name=\"wordclass0\" class=\"wordclass0\">指定人</div></div><div name=\"operatorcircle1\" class=\"operatorcircle1\"><div class=\"hook\"></div><div name=\"wordclass1\" class=\"wordclass1\">所有人</div></div><div name=\"operatorcircle2\" class=\"operatorcircle2\"><div class=\"hook\"></div><div name=\"wordclass2\" class=\"wordclass2\">创建人本人</div></div><div name=\"operatorcircle3\" class=\"operatorcircle3\"><div class=\"hook\"></div><div name=\"wordclass3\" class=\"wordclass3\">创建人经理</div></div><div name=\"operatorbrow\" class=\"operatorbrow\"></div><div name=\"createspanfor\" style=\"width:350px;height:36px;line-height:34px;font-size:14px;margin-left:8px;padding-top:5px;\"></div></div><div class=\"operatorbtn\"></div></div></div>");
		jQuery(div).find("div[name=insert]").css({"top":"-10px","left":"50px"});
		jQuery(div).find("div[name=remove]").css({"top":"-10px","left":"75px"});
		jQuery(div).find("div[name=agency]").css({"top":"-10px","left":"100px"});
		jQuery(div).find("div[name=operator]").css({"top":"-10px","left":"125px"});
		jQuery(div).find(".nodenamesavehide").css({"top":"-30px","right":"-5px"});
		
		//if(wfid != 36){
			div.mousedown(function (){
				var id=jQuery(this).attr("id");
				doMouseDown(this);
			});
			div.hover(function (){
				var id=jQuery(this).attr("id");
				if(jQuery(".actually").length>0){
					jQuery(".actually").removeClass("actually");
				}	
				jQuery(div).addClass("actually");
				//var position = jQuery(this).position();
				//var divleft = 0;
				//var divtop = -10;
				
				//var firstleft = 70;//两按钮的初始位置
				//var firsttop = 50;
				
				jQuery(this).find("div[name=insert]").show();
				jQuery(this).find("div[name=remove]").show();
				jQuery(this).find("div[name=agency]").show();
				jQuery(this).find("div[name=operator]").show();
				//jQuery(this).find(".insert").css({"top":firsttop+"px","left":firstleft+"px","width":"1px","height":"1px"});
				//jQuery(this).find(".remove").css({"top":firsttop+"px","left":firstleft+"px","width":"1px","height":"1px"});
				/*
				jQuery(this).find(".remove").animate({
				      top     : divtop + 'px',
				      left    : divleft + 15 + 'px',
				      opacity : "show",
				      width   : 25,
				      height  : 25
				    }, 100, null, function() {
				});
				jQuery(this).find(".insert").animate({
					top     : divtop + 'px',
					left    : divleft + 105 + 'px',
					opacity : "show",
					width   : 25,
					height  : 25
				}, 100, null, function() {
				});*/
				
				//添加按钮事件
				jQuery(this).find("div[name=insert]").unbind('click').bind('click',function(e){
					var tempid = jQuery(div).attr("id");
					addApproval1(tempid);
				});
				//删除按钮事件
				jQuery(this).find("div[name=remove]").unbind('click').bind('click',function(e){
					removeApproval();
				});
				jQuery(this).find("div[name=agency]").unbind('click').bind('click',function(e){
					//var tempid = jQuery(div).attr("id");
					//if(showover == 0){
						alterationNodeName(div);
					//}
				});
				//操作人编辑事件
				jQuery(this).find("div[name=operator]").unbind('click').bind('click',function(e){
					jQuery(div).find("div[name=createspanfor]").e8Browser({
						   name:"createrid"+id,
						   viewType:"0",
						   browserValue:"",
						   isMustInput:"1",
						   browserSpanValue:"",
						   hasInput:true,
						   linkUrl:"#",
						   isSingle:true,
						   completeUrl:"/data.jsp",
						   browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
						   width:"150px",
						   hasAdd:false,
						   isSingle:true
					});
					var floworder__ = 0;
					try {
						floworder__ = parseInt(jQuery("#wfEditForm").find("input[name=floworder_"+id+"]").val());
			    	} catch (e) {}
			    	if(floworder__ > 7 &&(floworder__%8 == 0 || floworder__%8 == 1)){
			    		if(jQuery(div).find(".operatorsavehide").length>0){
							var reclass0 = jQuery(div).find(".operatorsave").attr("class");
							var reclass1 = jQuery(div).find(".operatorsavehide").attr("class");
							
							jQuery(div).find(".operatorsave").attr("class","operatorsaveleft");
							jQuery(div).find(".operatorsavehide").attr("class","operatorsavehideleft");
						}
			    		jQuery(div).find(".operatorsavehideleft").css({"top":"-30px","right":"-5px"});
			    		//jQuery(div).find(".operatorsavehideleft").css({"top":"-20px","left":"0px"});
						alterationOperatorleft(div,"1");
					}else{
						if(jQuery(div).find(".operatorsavehideleft").length>0){
							var reclass0 = jQuery(div).find(".operatorsaveleft").attr("class");
							var reclass1 = jQuery(div).find(".operatorsavehideleft").attr("class");
							jQuery(div).find(".operatorsaveleft").attr("class",reclass0.substring(0,reclass0.length-4));
							jQuery(div).find(".operatorsavehideleft").attr("class",reclass1.substring(0,reclass1.length-4));
						}
						jQuery(div).find(".operatorsavehide").css({"top":"-30px","right":"-5px"});
						//jQuery(div).find(".operatorsavehide").css({"top":"-20px","right":"0px"});
						alterationOperator(div,"1");
					}
				});
			});
			
			jQuery(div).find("div[name=insert]").bind("mouseover",function(e){
				jQuery(this).attr("class","inserthot");
			});
			jQuery(div).find("div[name=insert]").bind("mouseout",function(e){
				jQuery(this).attr("class","insert");
			});
			jQuery(div).find("div[name=remove]").bind("mouseover",function(e){
				jQuery(this).attr("class","removehot");
			});
			jQuery(div).find("div[name=remove]").bind("mouseout",function(e){
				jQuery(this).attr("class","remove");
			});
			jQuery(div).find("div[name=agency]").bind("mouseover",function(e){
				jQuery(this).attr("class","agencyhot");
			});
			jQuery(div).find("div[name=agency]").bind("mouseout",function(e){
				jQuery(this).attr("class","agency");
			});
			jQuery(div).find("div[name=operator]").bind("mouseover",function(e){
				jQuery(this).attr("class","operatorhot");
			});
			jQuery(div).find("div[name=operator]").bind("mouseout",function(e){
				jQuery(this).attr("class","operator");
			});
			
			
			div.hover(null, function (){
				var id=jQuery(this).attr("id");
				if(jQuery(".actually").length>0){
					jQuery(".actually").removeClass("actually");
				}	
				var position = jQuery(this).position();
				var divleft = 70;
				var divtop = 50;
				jQuery(this).find("div[name=insert]").hide();
				jQuery(this).find("div[name=remove]").hide();
				jQuery(this).find("div[name=agency]").hide();
				jQuery(this).find("div[name=operator]").hide();
				/*jQuery(this).find(".insert").animate({
				      top     : divtop + 'px',
				      left    : divleft + 'px',
				      opacity : "hide",
					  width   : '1px',
					  height  : '1px'
				    }, 0, null, function() {
				});
				jQuery(this).find(".remove").animate({
					top     : divtop + 'px',
					left    : divleft + 'px',
					opacity : "hide",
					width   : '1px',
					height  : '1px'
				}, 0, null, function() {
				});*/
			});
		//}else{
		//	div.mousedown(function (){
		//		var id=jQuery(this).attr("id");
		//		doMouseDownForNotice(this);
		//	});
		//}
		
		/*div.children().dblclick(function() { 
			var judge = jQuery(this).attr("name");
			if(judge === "firstdiv"){
				toReplace(this);
			}
		});*/
		
		/*div.hover(null, function () {
			var id=jQuery(this).attr("id");
			jQuery(".menu").css("display","none");
		})*/
		return div;	
	}
	/**审批人（可拖）**/
	function canDragSpan(title){
		if(title.length==0){
			title=init_nodeName;
		}
		var div=jQuery("<div class='approval_drag'><div>"+title+"</div></div>");
		jQuery(div).find("div[name=agency]").css({"top":"0px","left":"115px"});
		div.mousedown(function (){
			jQuery(".remove").css("display","inline-block");
			jQuery(".agency").css("display","inline-block");
			doMouseDown(this);
		/**	changeNodeSpan();**/
			jQuery("#detail_disable").css("display","none");
			//fillDetail(-1);	
		});
		div.draggable({
						containment:"#mainSpan",
						helper: "clone",
						stop:stopDragg
					});
		return div;
	}
	
	/**归档**/
	function pigeonholeSpan(title,operatornames){
		//var div=jQuery("<div><div>"+title+"</div></div>");
		var div=jQuery("<div title=\"操作者："+operatornames+"\"><div name=\"firstdiv\" style=\"height:100px;line-height:100px;\">"+title+"</div><div name=\"agency\" class=\"agency\" title=\""+SystemEnv.getHtmlNoteName(4002)+"\"></div><div name=\"operator\" class=\"operator\" title=\"操作人\"></div><div class=\"nodenamesavehide\"><div class=\"nodenamesave\"><div class=\"inputdiv\"><input type=\"text\" name=\"inputnodeid\" class=\"inputnodeclass\" ></div><div name=\"nodenamebrow\" class=\"nodenamebrow\"></div></div></div><div class=\"operatorsavehide\"><div class=\"operatorsave\"><div style=\"float:left;width:8px;height:30px;\"></div><div name=\"operatorcircle0\" class=\"operatorcircle0\"><div class=\"hook\"></div><div name=\"wordclass0\" class=\"wordclass0\">指定人</div></div><div name=\"operatorcircle1\" class=\"operatorcircle1\"><div class=\"hook\"></div><div name=\"wordclass1\" class=\"wordclass1\">所有人</div></div><div name=\"operatorcircle2\" class=\"operatorcircle2\"><div class=\"hook\"></div><div name=\"wordclass2\" class=\"wordclass2\">创建人本人</div></div><div name=\"operatorcircle3\" class=\"operatorcircle3\"><div class=\"hook\"></div><div name=\"wordclass3\" class=\"wordclass3\">创建人经理</div></div><div name=\"operatorbrow\" class=\"operatorbrow\"></div><div name=\"createspanfor\" style=\"width:350px;height:36px;line-height:34px;font-size:14px;margin-left:8px;padding-top:5px;\"></div></div><div class=\"operatorbtn\"></div></div></div>");
		jQuery(div).find("div[name=agency]").css({"top":"0px","left":"90px"});
		jQuery(div).find("div[name=operator]").css({"top":"0px","left":"115px"});
		jQuery(div).find(".nodenamesavehide").css({"top":"-20px","right":"0px"});
		div.mousedown(function (){
			var id=jQuery(this).attr("id");
			doMouseDown(this);
		});
		
		div.hover(function (){
			var id=jQuery(this).attr("id");
			jQuery(this).find("div[name=agency]").show();
			jQuery(this).find("div[name=operator]").show();
			
			if(jQuery(".actually").length>0){
				jQuery(".actually").removeClass("actually");
			}
			jQuery(div).addClass("actually");

			jQuery(this).find("div[name=agency]").unbind('click').bind('click',function(e){
				//var tempid = jQuery(div).attr("id");
				//if(showover == 0){
					alterationNodeName(div);
				//}
			});
			//操作人编辑事件
			jQuery(this).find("div[name=operator]").unbind('click').bind('click',function(e){
				jQuery(div).find("div[name=createspanfor]").e8Browser({
					   name:"createrid"+id,
					   viewType:"0",
					   browserValue:"",
					   isMustInput:"1",
					   browserSpanValue:"",
					   hasInput:true,
					   linkUrl:"#",
					   isSingle:true,
					   completeUrl:"/data.jsp",
					   browserUrl:"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					   width:"150px",
					   hasAdd:false,
					   isSingle:true
				});
				var floworder__ = 0;
				try {
					floworder__ = parseInt(jQuery("#wfEditForm").find("input[name=floworder_"+id+"]").val());
		    	} catch (e) {}
				if(floworder__ > 7 &&(floworder__%8 == 0 || floworder__%8 == 1)){
					if(jQuery(div).find(".operatorsavehide").length>0){
						var reclass0 = jQuery(div).find(".operatorsave").attr("class");
						var reclass1 = jQuery(div).find(".operatorsavehide").attr("class");
						
						jQuery(div).find(".operatorsave").attr("class","operatorsaveleft");
						jQuery(div).find(".operatorsavehide").attr("class","operatorsavehideleft");
					}
					jQuery(div).find(".operatorsavehideleft").css({"top":"-20px","left":"0px"});
					alterationOperatorleft(div,"0");
				}else{
					if(jQuery(div).find(".operatorsavehideleft").length>0){
						var reclass0 = jQuery(div).find(".operatorsaveleft").attr("class");
						var reclass1 = jQuery(div).find(".operatorsavehideleft").attr("class");
						jQuery(div).find(".operatorsaveleft").attr("class",reclass0.substring(0,reclass0.length-4));
						jQuery(div).find(".operatorsavehideleft").attr("class",reclass1.substring(0,reclass1.length-4));
					}
					jQuery(div).find(".operatorsavehide").css({"top":"-20px","right":"0px"});
					alterationOperator(div,"0");
				}
			});
		});
		
		div.hover(null, function (){
			var id=jQuery(this).attr("id");
			if(jQuery(".actually").length>0){
				jQuery(".actually").removeClass("actually");
			}	
			jQuery(this).find("div[name=agency]").hide();
			jQuery(this).find("div[name=operator]").hide();
		});
		
		jQuery(div).find("div[name=agency]").bind("mouseover",function(e){
			jQuery(this).attr("class","agencyhot");
		});
		jQuery(div).find("div[name=agency]").bind("mouseout",function(e){
			jQuery(this).attr("class","agency");
		});
		jQuery(div).find("div[name=operator]").bind("mouseover",function(e){
			jQuery(this).attr("class","operatorhot");
		});
		jQuery(div).find("div[name=operator]").bind("mouseout",function(e){
			jQuery(this).attr("class","operator");
		});
		
		/*
		div.children().dblclick(function() { 
			var judge = jQuery(this).attr("name");
			if(judge === "firstdiv"){
				toReplace(this);
			}
		});*/
		return div;
	}
	
	//0:所有人type=4,1:指定人type=3,2:创建人经理type=18,3:创建人本人type=17
	function changeGroupType(){
		var selectType = jQuery(".operatortocircle").attr("name");
		var id=jQuery(".nodeChecked").attr("id");
		var checkobjid = "objid_"+id;
		var checkfield = jQuery("#wfEditForm").find("#checkfield").val();
		var ismodify = 0;
		var rownumadd = 0;
		try {
				rownumadd = parseInt(jQuery("#rownum").val());
				ismodify = parseInt(jQuery("input[name=ismodify_"+id+"]").val());
			} catch (e) {}
		if(selectType == "operatorcircle0"){
			//jQuery("#createridse1span").css("display","");
			if(checkfield.indexOf(checkobjid) < 0){
				jQuery("#wfEditForm").find("#checkfield").val(jQuery("#wfEditForm").find("#checkfield").val()+","+checkobjid);
			}
			jQuery("input[name=grouptype_"+id+"]").val("3");
			var nowobjid = jQuery("#createrid"+id).val();
			var nowobjname = jQuery("#createrid"+id+"span").find("a").html();
			
			jQuery("input[name=objid_"+id+"]").val(nowobjid);
			jQuery("input[name=objname_"+id+"]").val(nowobjname);
		}else{
			//jQuery("#createridse1span").css("display","none");
			checkfield += ",";
			if(checkfield.indexOf(checkobjid) > -1){
				checkfield = checkfield.replace(new RegExp(checkobjid+",","g"),"");
				jQuery("#wfEditForm").find("#checkfield").val(checkfield);
			}
			if(selectType == "operatorcircle1"){
				jQuery("input[name=grouptype_"+id+"]").val("4");
			}else if(selectType == "operatorcircle3"){
				jQuery("input[name=grouptype_"+id+"]").val("18");
			}else if(selectType == "operatorcircle2"){
				jQuery("input[name=grouptype_"+id+"]").val("17");
			}
		}
		if(ismodify === 0){
			jQuery("input[name=ismodify_"+id+"]").val("2");
		}
		jQuery("#rownum").val(rownumadd+1);
	}
	
	/**横向箭头**/
	function Arrows(){
		var div=jQuery("<div class='arrow'></div>");
		return div;
	}

	function doMouseDown(div){
		var tempactually = jQuery(".actually").length;
		if(tempactually>0){
			jQuery(".actually").removeClass("actually");
		}
		if(jQuery(".nodeChecked").length>0){
			var tempclass = jQuery(".nodeChecked");
			tempclass.removeClass("nodeChecked");
			var delclass = tempclass.attr("class");
			tempclass.attr("class",delclass.substring(0,delclass.length-1));
			//jQuery(".nodeChecked").removeClass("nodeChecked");
		}
		jQuery(div).attr("class",jQuery(div).attr("class")+"1");
		jQuery(div).addClass("nodeChecked");
		if(tempactually>0){
			jQuery(div).addClass("actually");
		}
		//showMenu();
		
		
		/*jQuery("#selectType").selectbox("detach");
		//if(wfid != 35){
			document.all("selectType").disabled = false;
		//}
	    var __indexid = jQuery(div).attr("id");
	    var __grouptype = jQuery("input[name=grouptype_"+__indexid+"]").val();
	    var __nodetype = jQuery("input[name=nodetype_"+__indexid+"]").val();
	    if(__grouptype == "4"){
	    	jQuery("#selectType").val("0");
	    	jQuery("#createridse1span").css("display","none");
	    }else if(__grouptype == "3"){
	    	jQuery("#selectType").val("1");
	    	jQuery("#createridse1span").css("display","");
	    	__initbrowser(__indexid);
	    	//if(wfid != 35){
	    		jQuery("#createrid_browserbtn").removeAttr("disabled");
	    	//}else{
	    	//	var selectType = jQuery("#selectType option:selected").val();
			//	if(selectType == 1){
			//		jQuery("#createrid_browserbtn").attr("disabled","true");
			//		jQuery(".e8_delClass").hide();
			//	}
	    	//}
	    }else if(__grouptype == "18"){
	    	jQuery("#selectType").val("2");
	    	jQuery("#createridse1span").css("display","none");
	    }else if(__grouptype == "17"){
	    	jQuery("#selectType").val("3");
	    	jQuery("#createridse1span").css("display","none");
	    }
	    //创建节点只有所有人、指定人
	    if(__nodetype == "0"){
	    	jQuery("#selectType option[value='2']").remove();
	    	jQuery("#selectType option[value='3']").remove();
	    }else{
	    	var optionvalue = jQuery("#selectType option[value='2']").val();
	    	if(optionvalue != "2"){
		    	//创建人经理 "+SystemEnv.getHtmlNoteName(3418,languageid)+"
		    	jQuery("#selectType").append("<option value='2'>"+SystemEnv.getHtmlNoteName(4006)+"</option>");
		    	//创建人本人"+SystemEnv.getHtmlNoteName(3418,languageid)+"
		    	jQuery("#selectType").append("<option value='3'>"+SystemEnv.getHtmlNoteName(4007)+"</option>");
	    	}
	    }
	    
	    jQuery("#selectType").selectbox("attach");
	    */
	}
	
	//
	function doMouseDownForNotice(div){
		var tempactually = jQuery(".actually").length;
		if(tempactually>0){
			jQuery(".actually").removeClass("actually");
		}
		if(jQuery(".nodeChecked").length>0){
			var tempclass = jQuery(".nodeChecked");
			tempclass.removeClass("nodeChecked");
			var delclass = tempclass.attr("class");
			tempclass.attr("class",delclass.substring(0,delclass.length-1));
			//jQuery(".nodeChecked").removeClass("nodeChecked");
		}
		jQuery(div).attr("class",jQuery(div).attr("class")+"1");
		jQuery(div).addClass("nodeChecked");
		if(tempactually>0){
			jQuery(div).addClass("actually");
		}
		//showMenu();
		jQuery("#selectType").selectbox("detach");
	    document.all("selectType").disabled = false;
	    var __indexid = jQuery(div).attr("id");
	    var __grouptype = jQuery("input[name=grouptype_"+__indexid+"]").val();
	    if(__grouptype == "4"){
	    	jQuery("#selectType").val("0");
	    	jQuery("#createridse1span").css("display","none");
	    }else if(__grouptype == "3"){
	    	jQuery("#selectType").val("1");
	    	jQuery("#createridse1span").css("display","");
	    	__initbrowser(__indexid);
	    	jQuery("#createrid_browserbtn").removeAttr("disabled");
	    }else if(__grouptype == "18"){
	    	jQuery("#selectType").val("2");
	    	jQuery("#createridse1span").css("display","none");
	    }else if(__grouptype == "17"){
	    	jQuery("#selectType").val("3");
	    	jQuery("#createridse1span").css("display","none");
	    }
	    document.all("selectType").disabled = true;
	    jQuery("#selectType").selectbox("attach");
	}
	
	//填充浏览按钮
	
	function __initbrowser(obj){
		var rid = jQuery("input[name=objid_"+obj+"]").val();
		var rname = jQuery("input[name=objname_"+obj+"]").val();

		var sHtml = "";

		var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
		var idArray = rid.split(",");
		var nameArray = rname.split(",");
		for ( var _i = 0; _i < idArray.length; _i++) {
			var curid = idArray[_i];
			var curname = nameArray[_i];
			sHtml += wrapshowhtml("0", 
					"<a title='" + curname + "' href='" + url + 
					curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
		}
		jQuery($GetEle("createrid"+obj+"span")).html(sHtml);
		$GetEle("createrid"+obj).value = rid;
		
	    hoverShowNameSpan(".e8_showNameClass");
		try {
			var onppchgfnstr = jQuery("#"+ "createrid"+obj).attr('onpropertychange');
			eval(onppchgfnstr);
			if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
				onpropertychange();
			}
		} catch (e) {
		}
		try {
			var onppchgfnstr = jQuery("#"+ "createrid" +obj+ "__").attr('onpropertychange').toString();
			eval(onppchgfnstr);
			if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
				onpropertychange();
			}
		} catch (e) {
		}
	}
	
	function wrapshowhtml(viewtype, ahtml, id) {
		var ismust = 1;
		if (viewtype == '1') {
			ismust = 2;
		}
		var str = "<span class=\"e8_showNameClass\">";
		str += ahtml;
		str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
		return str;
	}
	
	function showMenu(){
		//菜单显示
		jQuery(".menu").css("display","block");
		
		var offset=jQuery(".nodeChecked").offset();

		jQuery(".menu").css("top",(offset.top-jQuery(".menu").height()-10+mainSpan.scrollTop())).css("left",((offset.left+jQuery(".nodeChecked").width()/2)-jQuery(".menu").width()/2));
		
	}
	function addRowForm(appData){
		jQuery("#wfEditForm").append("<input type='hidden' name='floworder_"+appData.id+"' value='"+appData.floworder+"'/>");//顺序
		jQuery("#wfEditForm").append("<input type='hidden' name='nodename_"+appData.id+"' value='"+appData.nodename+"'/>");//名称
		jQuery("#wfEditForm").append("<input type='hidden' name='wfnodeid_"+appData.id+"' value=''/>");//id
		jQuery("#wfEditForm").append("<input type='hidden' name='nodetype_"+appData.id+"' value='"+appData.nodetype+"'/>");//节点类型
		jQuery("#wfEditForm").append("<input type='hidden' name='nextnodetype_"+appData.id+"' value='"+appData.nextnodetype+"'/>");//上一个节点类型
		jQuery("#wfEditForm").append("<input type='hidden' name='Signtype_"+appData.id+"' value='"+appData.Signtype+"'/>");//会签类型
		jQuery("#wfEditForm").append("<input type='hidden' name='operators_"+appData.id+"' value='"+appData.operators+"'/>");//操作者id
		jQuery("#wfEditForm").append("<input type='hidden' name='operatornames_"+appData.id+"' value='"+appData.operatornames+"'/>");//操作者name
		jQuery("#wfEditForm").append("<input type='hidden' name='grouptype_"+appData.id+"' value='"+appData.grouptype+"'/>");//操作组类型
		jQuery("#wfEditForm").append("<input type='hidden' name='objid_"+appData.id+"' value='"+appData.objid+"'/>");//操作组对象id
		jQuery("#wfEditForm").append("<input type='hidden' name='objname_"+appData.id+"' value='"+appData.objname+"'/>");//操作组对象id
		jQuery("#wfEditForm").append("<input type='hidden' name='ismodify_"+appData.id+"' value='1'/>");//是否要保存 0不管、1新增、2修改、3删除

		/**其他设置信息，填写的均是测试值**/

		jQuery("#wfEditForm").find("#rownum").val(jQuery(".approval_drag").length+1);
		jQuery("#wfEditForm").find("#indexnum").val(appData.id+1);
		jQuery("#wfEditForm").find("#allnum").val(parseInt(jQuery("#wfEditForm").find("#allnum").val())+1);
		jQuery("#wfEditForm").find("#checkfield").val(jQuery("#wfEditForm").find("#checkfield").val()+",nodename_"+appData.id+",grouptype_"+appData.id);
	}
	function stopDragg(event,ui){
		var div=ui.helper;
		var minx=ui.offset.left;
		var miny=ui.offset.top;
		var maxx=minx+div.width();
		var maxy=miny+div.height();
		if(startrows==0){
			if((maxx<startSpan.maxx&&((miny>startSpan.miny&&miny<startSpan.maxy)||(maxy>startSpan.miny&&maxy<startSpan.maxy)))||(maxy<startSpan.miny)){
				//拖到起始节点外面去了
				return;
			}
		}else{
			if((minx>startSpan.minx&&((miny>startSpan.miny&&miny<startSpan.maxy)||(maxy>startSpan.miny&&maxy<startSpan.maxy)))||(maxy<startSpan.miny)){
				//拖到起始节点外面去了
				return;
			}
		}
		if(stoprows==0){
			if((minx>stopSpan.minx&&((miny>stopSpan.miny&&miny<stopSpan.maxy)||(maxy>stopSpan.miny&&maxy<stopSpan.maxy)))||(miny>stopSpan.maxy)){
				//拖到归档外面去了
				return;
			}
		}else{
			if((maxx<stopSpan.maxx&&((miny>stopSpan.miny&&miny<stopSpan.maxy)||(maxy>stopSpan.miny&&maxy<stopSpan.maxy)))||(miny>stopSpan.maxy)){
				//拖到归档外面去了
				return;
			}
		}

		var id=jQuery(".nodeChecked").attr("id");
		var frontNum=null;
		var dragNum=null;

		var rows=0;

		for(var i=0;i<spans.length;i++){
			if(spans[i].id==id){
				dragNum=i;
				if(frontNum!=null){
					break;
				}
			}
			//拖动到覆盖到某一节点的后半截
			if(minx>spans[i].minx&&minx<spans[i].maxx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
				if(rows==0){//奇数行
					frontNum=i;
				}else{//偶数行
					frontNum=i-1;
				}
				if(dragNum!=null){
					break;
				}
			}
			//拖动到覆盖到某一节点的前半截
			else if(maxx>spans[i].minx&&maxx<spans[i].maxx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
				if(rows==0){//奇数行
					frontNum=i-1;
				}else{//偶数行
					frontNum=i;
				}
				if(dragNum!=null){
					break;
				}
			}
			//拖到节点之间的空白的地方
			else{
				if(rows==0){//奇数行
					if((i+1)%cols==1){ //奇数行最左边的节点(本行开始节点)
						//拖到最左边
						if(maxx<spans[i].minx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i-1;
							if(dragNum!=null){
								break;
							}
						}
					}else if((i+1)%cols==0){//奇数行最右边的节点(本行结束节点)
						if(minx>spans[i].maxx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i;
							if(dragNum!=null){
								break;
							}
						}//拖到本节点和前一节点之间
						else if(minx>spans[i-1].maxx&&maxx<spans[i].minx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i-1;
							if(dragNum!=null){
								break;
							}
						}
					}//奇数行中间的节点
					else{
						//拖到本节点和前一节点之间
						if(minx>spans[i-1].maxx&&maxx<spans[i].minx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i-1;
							if(dragNum!=null){
								break;
							}
						}
					}
				}else{//偶数行
					if((i+1)%cols==1){//偶数行最右边的节点(本行开始节点)
						//拖到最右边
						if(minx>spans[i].maxx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i-1;
							if(dragNum!=null){
								break;
							}
						}
					}else if((i+1)%cols==0){//偶数行最左边的节点(本行结束节点)
						//拖到最左边
						if(maxx<spans[i].minx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i;
							if(dragNum!=null){
								break;
							}
						}//拖到本节点和前一节点之间
						else if(minx>spans[i].maxx&&maxx<spans[i-1].minx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i-1;
							if(dragNum!=null){
								break;
							}
						}
					}//偶数行中间的节点
					else{
						//拖到本节点和前一节点之间
						if(minx>spans[i].maxx&&maxx<spans[i-1].minx&&((miny>spans[i].miny&&miny<spans[i].maxy)||(maxy>spans[i].miny&&maxy<spans[i].maxy))){
							frontNum=i-1;
							if(dragNum!=null){
								break;
							}
						}
					}
				}
			}
			
			if((i+1)%cols==0){
				rows=((i+1)/cols)%2;
			}

		}
		if(frontNum==null||(frontNum==dragNum||((frontNum+1)==dragNum))){
			return;
		}

		var spanArray=[];
		if(frontNum<dragNum){
			for(var i=0;i<spans.length;i++){
				if(i==(frontNum+1)){
					spanArray[i]=spans[dragNum];
				}else if(i>frontNum&&i<dragNum){
					spanArray[i]=spans[i-1];
				}else if(i==dragNum){
					spanArray[i]=spans[i-1];				
				}else{
					spanArray[i]=spans[i];
				}
			}
		}else{
			for(var i=0;i<spans.length;i++){
				if(i>(dragNum-1)&&i<frontNum){
					spanArray[i]=spans[i+1];
				}else if(i==frontNum){
					spanArray[i]=spans[dragNum];
				}else{
					spanArray[i]=spans[i];
				}
			}
		}
		showMian(spanArray);

		spans=spanArray;

		showMenu();
	}
	function showMian(spanArray){
		var num=0;
		span_x=initx;
		span_y=inity;
		
		//自定义的自由节点顺序重排
		var freeNum=1;
		
		var rows=0;
		
		mainSpan.find(".arrow").remove();

		var sign=0;
		
		for(var i=0;i<spanArray.length;i++){
			spanArray[i].minx=span_x;
			spanArray[i].miny=span_y;
			spanArray[i].maxx=span_x+jQuery("#"+spanArray[i].id).width();
			spanArray[i].maxy=span_y+jQuery("#"+spanArray[i].id).height();
			
			jQuery("#"+spanArray[i].id).css("top",span_y).css("left",span_x);
			
			if(jQuery("#wfEditForm").find("input[name='floworder_"+spanArray[i].id+"']").length>0){
				jQuery("#wfEditForm").find("input[name='floworder_"+spanArray[i].id+"']").val(freeNum);
				freeNum++;
			}
			
			if(i==(spanArray.length-1)){
				break;
			}

			var nodetypeid = jQuery("#wfEditForm").find("input[name='nodetype_"+spanArray[i].id+"']").val();
			var nextnodetype = jQuery("#wfEditForm").find("input[name='nextnodetype_"+spanArray[i].id+"']").val();

			num++;
			if(num%cols==0){
				
				//加纵向箭头
				var arrow=Arrows();
				if(nextnodetype == "1"){
					arrow.addClass("verticalArrows1");
				}else{
					arrow.addClass("verticalArrows");
				}
				
				arrow.css("top",span_y+jQuery("#"+spanArray[i].id).height()).css("left",span_x);
				mainSpan.append(arrow);

				rows=(num/cols)%2;
				if(rows==0){
					span_x=initx;
					span_y=span_y+space_y;
				}else{
					span_x=span_x;
					span_y=span_y+space_y;	
				}
			}else{
				if(rows==0){
					
					//加横向箭头
					var arrow=Arrows();
					if(nextnodetype == "1"){
						arrow.addClass("horizontalArrowsLeft1");
					}else{
						arrow.addClass("horizontalArrowsLeft");
					}
					
					arrow.css("top",span_y).css("left",span_x+jQuery("#"+spanArray[i].id).width());
					mainSpan.append(arrow);

					span_x=span_x+space_x;
					span_y=span_y;
				}else{
					
					//加横向箭头
					var arrow=Arrows();
					if(nextnodetype == "1"){
						arrow.addClass("horizontalArrowsRight1");
					}else{
						arrow.addClass("horizontalArrowsRight");
					}
					
					mainSpan.append(arrow);
					arrow.css("top",span_y).css("left",span_x-arrow.width());

					span_x=span_x-space_x;
					span_y=span_y;
				}				
			}

		}
	}
	function addApproval0(tempid){
		appNum++;
		//var div=canDragSpan(init_nodeName + (spanId - 1));
		var div=approvalSpan(init_nodeName + (spanId - 1),"请选择操作人");
		div.addClass("approval");
		
		//生成节点id
		div.attr("id",spanId);
		
		jQuery(".actually").after(div);
		
		var tempnextnodetype = jQuery("#wfEditForm").find("input[name='nextnodetype_"+tempid+"']").val();
		var tempgrouptype = jQuery("#wfEditForm").find("input[name='grouptype_"+tempid+"']").val();
		var tempobjid = jQuery("#wfEditForm").find("input[name='objid_"+tempid+"']").val();
		var tempobjname = jQuery("#wfEditForm").find("input[name='objname_"+tempid+"']").val();

		appInitData.id=spanId;
		appInitData.floworder=spanId;
		appInitData.grouptype=tempgrouptype;
		appInitData.objid=tempobjid;
		appInitData.objname=tempobjname;
		appInitData.nodetype=1;
		appInitData.nodename=init_nodeName + (spanId - 1);
		appInitData.nextnodetype=tempnextnodetype;
		
		jQuery("#wfEditForm").find("input[name='nextnodetype_"+tempid+"']").val("1");
		
		addRowForm(appInitData);
		
		//数组重排序
		var spanArray=[];
		var id=jQuery(".actually").attr("id");
		var num=-1;
		for(var i=0;i<spans.length;i++){
			if(spans[i].id==id){
				num=i+1;
			}
			if(num===-1||i<num){	
				spanArray[i]=spans[i];
			}else if(num==i){
				spanArray[i]={id:spanId,minx:0,miny:0,maxx:0,maxy:0};
				spanArray[i+1]=spans[i];
			}else{
				spanArray[i+1]=spans[i];
			}
		}
		//div.hide();
		//组件重新定位
		showMian(spanArray);
		spans=spanArray;
		//div.show("slow");
		spanId++;
		resizeMain();
	}
	function addApproval(tempid){
		appNum++;
		//var div=canDragSpan(init_nodeName + (spanId - 1));
		var div=approvalSpan(init_nodeName + (spanId - 1),"请选择操作人");
		div.addClass("approval");

		//生成节点id
		div.attr("id",spanId);

		jQuery(".actually").after(div);
		
		var tempnextnodetype = jQuery("#wfEditForm").find("input[name='nextnodetype_"+tempid+"']").val();
		var tempgrouptype = jQuery("#wfEditForm").find("input[name='grouptype_"+tempid+"']").val();
		var tempobjid = jQuery("#wfEditForm").find("input[name='objid_"+tempid+"']").val();
		var tempobjname = jQuery("#wfEditForm").find("input[name='objname_"+tempid+"']").val();

		appInitData.id=spanId;
		appInitData.floworder=spanId;
		appInitData.grouptype=tempgrouptype;
		appInitData.objid=tempobjid;
		appInitData.objname=tempobjname;
		appInitData.nodetype=1;
		appInitData.nodename=init_nodeName + (spanId - 1);
		appInitData.nextnodetype=tempnextnodetype;
		
		jQuery("#wfEditForm").find("input[name='nextnodetype_"+tempid+"']").val("1");

		addRowForm(appInitData);

		//数组重排序
		var spanArray=[];
		var id=jQuery(".actually").attr("id");
		var num=-1;
		for(var i=0;i<spans.length;i++){
			if(spans[i].id==id){
					num=i+1;
			}
			if(num===-1||i<num){	
				spanArray[i]=spans[i];
			}else if(num==i){
				spanArray[i]={id:spanId,minx:0,miny:0,maxx:0,maxy:0};
				spanArray[i+1]=spans[i];
			}else{
				spanArray[i+1]=spans[i];
			}
		}
		//div.hide();
		//组件重新定位
		showMian(spanArray);
		spans=spanArray;
		//div.show("slow");
		spanId++;
		resizeMain();
	}
	
	function addApproval1(tempid){
		appNum++;
		//var div=canDragSpan(init_nodeName + (spanId - 1));
		var div=manageSpan(init_nodeName + (spanId - 1),"请选择操作人");
		div.addClass("manage");

		//生成节点id
		div.attr("id",spanId);
		jQuery(".actually").after(div);
		
		var tempgrouptype = jQuery("#wfEditForm").find("input[name='grouptype_"+tempid+"']").val();
		var tempobjid = jQuery("#wfEditForm").find("input[name='objid_"+tempid+"']").val();
		var tempobjname = jQuery("#wfEditForm").find("input[name='objname_"+tempid+"']").val();

		appInitData.id=spanId;
		appInitData.floworder=spanId;
		appInitData.grouptype=tempgrouptype;
		appInitData.objid=tempobjid;
		appInitData.objname=tempobjname;
		appInitData.nodetype=2;
		appInitData.nodename=init_nodeName + (spanId - 1);
		appInitData.nextnodetype=2;

		addRowForm(appInitData);

		//数组重排序
		var spanArray=[];
		var id=jQuery(".actually").attr("id");
		var num=-1;
		for(var i=0;i<spans.length;i++){
			if(spans[i].id==id){
					num=i+1;
			}
			if(num===-1||i<num){	
				spanArray[i]=spans[i];
			}else if(num==i){
				spanArray[i]={id:spanId,minx:0,miny:0,maxx:0,maxy:0};
				spanArray[i+1]=spans[i];
			}else{
				spanArray[i+1]=spans[i];
			}
		}
		
		//组件重新定位
		//div.hide();
		showMian(spanArray);
		spans=spanArray;
		//div.show("slow");
		spanId++;
		resizeMain();
	}
	
	function resizeMain(){
		var __indexnum = jQuery("#allnum").val();
		var __divisor = parseInt(__indexnum/4);
		var __remainder = parseInt(__indexnum%4);
		if(__divisor > 0 && __remainder == 0){
			__divisor -= 1;
		}
		var __mainSpanhigh = 160 + __divisor*176;
		jQuery("#mainSpan").height(__mainSpanhigh);
	}
	
	function removeApprovalnew(tempid){
		var id=jQuery(".actually").attr("id");
		
		var attrname = "";
		var tempnextnodetype = jQuery("#wfEditForm").find("input[name='nextnodetype_"+id+"']").val();
		var testfloworder = parseInt(jQuery("#wfEditForm").find("input[name='floworder_"+id+"']").val());
		jQuery("input[name^=floworder_]").each(function (i, e) {
			var dataval = $(e).val();
			var dataval1 = testfloworder-1;
			if(dataval == dataval1){
				attrname = $(e).attr("name");
			}
		});
		jQuery("#wfEditForm").find("input[name='nextnodetype_"+attrname.split("_")[1]+"']").val(tempnextnodetype);
		
		removeRowForm(id);
		
		var spanArray=[];
		var num=-1;
		for(var i=0;i<spans.length;i++){
			if(spans[i].id==id){
				num=i;
			}
			if(num===-1){
				spanArray[i]=spans[i];
			}else if(i>num){
				spanArray[i-1]=spans[i];
			}
		}
		
		showMian(spanArray);
		
		spans=spanArray;
		
		jQuery(".actually").remove();
		
		//jQuery(".menu").css("display","none");
		
		//jQuery("#detail_disable").css("display","block");
		resizeMain();
	}
	function removeApproval(){
		var id=jQuery(".actually").attr("id");

		removeRowForm(id);
		
		var spanArray=[];
		var num=-1;
		for(var i=0;i<spans.length;i++){
			if(spans[i].id==id){
				num=i;
			}
			if(num===-1){
				spanArray[i]=spans[i];
			}else if(i>num){
				spanArray[i-1]=spans[i];
			}
		}

		showMian(spanArray);

		spans=spanArray;

		jQuery(".actually").remove();

		//jQuery(".menu").css("display","none");

		//jQuery("#detail_disable").css("display","block");
		resizeMain();
	}
	function removeRowForm(i){
		jQuery("#wfEditForm").find("input[name='floworder_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='nodename_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='nodetype_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='nextnodetype_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='Signtype_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='operators_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='operatornames_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='grouptype_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='objid_"+i+"']").remove();
		var ismodify = jQuery("#wfEditForm").find("input[name='ismodify_"+i+"']").val();
		if(ismodify != 1){
			var delwfnodeid = jQuery("#wfEditForm").find("input[name='wfnodeid_"+i+"']").val();
			jQuery("#deletenode").val(jQuery("#deletenode").val()+","+delwfnodeid);
		}
		jQuery("#wfEditForm").find("input[name='ismodify_"+i+"']").remove();
		jQuery("#wfEditForm").find("input[name='wfnodeid_"+i+"']").remove();
		
		jQuery("#wfEditForm").find("#rownum").val(jQuery(".approval_drag").length-1);

		var checkfield=jQuery("#wfEditForm").find("#checkfield").val();
		var checkfields=checkfield.split(",");
		checkfield="";
		for(var r=0;r<checkfields.length;r++){
			if((checkfields[r]!=("nodename_"+i))||(checkfields[r]!=("grouptype_"+i))){
				checkfield=checkfield+checkfields[r]+",";
			}
		}
		//jQuery("#wfEditForm").find("#indexnum").val(jQuery("#wfEditForm").find("#indexnum").val()-1);
		jQuery("#wfEditForm").find("#allnum").val(jQuery("#wfEditForm").find("#allnum").val()-1);
		jQuery("#wfEditForm").find("#checkfield").val(checkfield);
	}
})();