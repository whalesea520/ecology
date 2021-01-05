var freeWorkflow=(function (){
	var mainSpan;
	var parentSpan;
	
	var requestid;

	var freedata=[]; //自由定义流转节点

	var fulldata; //全部流转节点
	var currnodeid;//当前处理的节点id
	var nextnodeid;//当前流转的下一节点id

	var startSpan;//drag起始点
	var stopSpan;//drag终止点
	var startrows=-1;//startSpan在奇数？偶数？行
	var stoprows=-1;//stopSpan在奇数？偶数？行

	var spanId=0;//生成节点的divId

	var spans=[];//整体页面数据

	var init_nodeName;
	
	var initx=20;
	var inity=40;

	var span_x=initx;
	var span_y=inity;
	
	var space_x=200;//每个节点的距离
	var space_y=170;//每行间隔
	
	var cols=4;//每排个数
	var cnum=0;//计数

	var roadDuty;//当前操作者的路径编辑权限
	var frmsDuty;

	var nodeTypeOption;
	var signTypeOption;
	var roadTypeOption;

	var appNum=1;
	//添加的新节点的默认信息
	var appInitData={floworder:"",nodename:"",nodetype:"1",Signtype:"1",operators:"",operatornames:"",road:"1",frms:"0",trust:"0",nodeDo:"1"};

	return {
		setFreedata:function (div){
			parentSpan=div;
			//填充freedata
			fillFreedata();
		},
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
		setRoadDuty:function (duty){
			roadDuty=duty;
		},
		setFrmsDuty:function (duty){
			frmsDuty=duty;
		},
		create:function (div,full_data,curr_nodeid,next_nodeid){
			mainSpan=div;
			fulldata=full_data;
			currnodeid=curr_nodeid;
			nextnodeid=next_nodeid;
			init();
		},
		saveDetail:function (){
			saveDetail();
		},
		setOperators:function (operators,operatornames){
			if(operators.length>0){
				if(freedata.length>0){
					//改填第一个节点的操作人信息
					var id=updateOperators();
					
					jQuery("#freeForm").find("input[name='operatornames_"+id+"']").val(operatornames);
					jQuery("#freeForm").find("input[name='operators_"+id+"']").val(operators);

				}else{
					//没有自由节点，则添加一个
					addApproval();
					
					var id=spanId-1;

					jQuery("#freeForm").find("input[name='operatornames_"+id+"']").val(operatornames);
					jQuery("#freeForm").find("input[name='operators_"+id+"']").val(operators);

				}
			}			
		},
		saveDataToParent:function (){

			var id=updateOperators();
			DataSync(id);
			if(requestid!=-1){//编辑页面
				handlePigeonhole(id);
			}else{//新建页面
				fillParentInput(id);
			}
		/**	//stopSpan节点是否是归档节点
			if(stopSpan.id==spans[spans.length-1].id&&requestid!=-1){
				//归档节点
				handlePigeonhole(id);
			}else{
				//不是归档节点
				fillParentInput(id);
			}
	**/	},
		changeNodeName:function (value){
			alterNodeName(value);
		//	console.dir(jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError"));
			if(value.length>0){
				jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","none");
			}else{
				jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","block");
			}
		},
		changeNodeType:function(value){
			alterNodeType(value);
		},
		saveChangedStatus:function() {
			jQuery(parentSpan).append("<input type='hidden' name='freeWorkflowChanged' value='true' />");
		}
	}
	function init(){
		/**流程中只会有一个创建节点和一个归档节点**/
		var start_i;
		var stop_i;
		
		if(requestid==-1){//新建创建时
			roadDuty=2;
		}

		//当路径编辑权限最高时，终止点为归档节点
		if(roadDuty==2){
			nextnodeid=fulldata[fulldata.length-1].nodeid;
		}
		
		if(currnodeid==-1||nextnodeid==-1){
			alert("数据库数据读取有误！");
			return;
		}

		for(var i=0;i<fulldata.length;i++){
			if(fulldata[i].nodetype==0){
				//创建节点
				fulldata[i].road=2;//最高路径编辑权限
				fulldata[i].frms=1;//表单编辑权限
			}
			if(fulldata[i].nodeid==currnodeid){
				start_i=i;

			}else if(fulldata[i].nodeid==nextnodeid){
				stop_i=i;
			}			
		}
					
		var rows=0;
		var num=0;
		var fnum=0;
		while(num<fulldata.length){
			if(fulldata[0].nodetype!=0||start_i>stop_i){
				//第一个节点不是创建节点，数据获取有问题
				//开始序号大于结束序号，数据整理有问题
				break;
			}
			var span;
			if(num<start_i){
				
				fulldata[num].id=spanId;

				if(fulldata[num].nodetype==0){
					//创建节点
					span=proposerSpan(fulldata[num].nodename);	
					
					span.addClass("proposer");

				}else if(fulldata[num].nodetype==1){
					//审批节点
					span=approvalSpan(fulldata[num].nodename);
					
					span.addClass("approval");

				}else if(fulldata[num].nodetype==2){
					//处理节点
					span=approvalSpan(fulldata[num].nodename);

					span.addClass("manage");

				}
			}else if(num==start_i){ //当前操作节点
				
				fulldata[num].id=spanId;

				if(fulldata[num].nodetype==0){
					//创建节点
					span=proposerSpan(fulldata[num].nodename);	
					if(requestid==-1){
						span.addClass("proposer2");
					}else{
						span.addClass("proposer1");
					}
				}else if(fulldata[num].nodetype==1){
					//审批节点
					span=approvalSpan(fulldata[num].nodename);
					
					span.addClass("approval1");

				}else if(fulldata[num].nodetype==2){
					//处理节点
					span=approvalSpan(fulldata[num].nodename);

					span.addClass("manage1");

				}else if(fulldata[num].nodetype==3){
					//归档节点
					span=pigeonholeSpan(fulldata[num].nodename);

					span.addClass("pigeonhole1");

				}
			}else{
				if(num<stop_i){
					if(freedata.length==0){ //自由节点不存在时，跳过这段
						num=stop_i;
						continue;
					}

					freedata[fnum].id=spanId;
					//自由节点
					span=canDragSpan(freedata[fnum].nodename);
					
					if(freedata[fnum].nodetype==1){
						//审批节点
						span.addClass("approval2");
					}else if(freedata[fnum].nodetype==2){
						//处理节点
						span.addClass("manage2");
					}

					addRowForm(freedata[fnum]);

					appNum++;
					
					if(fnum==(freedata.length-1)){
						num=stop_i-1;
					}else{
						//避免数据丢失，让循环停留
						num=num-0.5;
					}
					fnum++;
				}else if(num==stop_i){
					if(fnum==freedata.length){

						fulldata[num].id=spanId;

						if(fulldata[num].nodetype==3){
							//归档节点
							span=pigeonholeSpan(fulldata[num].nodename);
							
							span.addClass("pigeonhole2");
							
						}else if(fulldata[num].nodetype==1){
							//审批节点
							span=approvalSpan(fulldata[num].nodename);

							span.addClass("approval2");

						}else if(fulldata[num].nodetype==2){
							//处理节点
							span=approvalSpan(fulldata[num].nodename);

							span.addClass("manage2");

						}
					}else {
						if(freedata.length==0){ //自由节点不存在时，跳过这段
							num=stop_i;
							continue;
						}
						freedata[fnum].id=spanId;
						//自由节点
						span=canDragSpan(freedata[fnum].nodename);
						
						if(freedata[fnum].nodetype==1){
							//审批节点
							span.addClass("approval2");
						}else if(freedata[fnum].nodetype==2){
							//处理节点
							span.addClass("manage2");
						}

						addRowForm(freedata[fnum]);

						appNum++;

						fnum++;
						
						num=stop_i-1;
					}
				}else if(num>stop_i){
					fulldata[num].id=spanId;

					if(fulldata[num].nodetype==3){
						//归档节点
						span=pigeonholeSpan(fulldata[num].nodename);

						span.addClass("pigeonhole2");

					}else if(fulldata[num].nodetype==1){
						//审批节点
						span=approvalSpan(fulldata[num].nodename);

						span.addClass("approval2");

					}else if(fulldata[num].nodetype==2){
						//处理节点
						span=approvalSpan(fulldata[num].nodename);

						span.addClass("manage2");

					}
				}
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
				if(num<start_i){
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
					if(num<start_i){
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
					if(num<start_i){
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

		jQuery("#"+startSpan.id).unbind("mousedown");
		jQuery("#"+startSpan.id).mousedown(function (){
			jQuery(".remove").css("display","none");
			jQuery(".agency").css("display","none");
			doMouseDown(this);
			jQuery("#detail_disable").css("display","block");
			fillDetail(startSpan.id);
		});

		jQuery(".insert").click(addApproval); //添加按钮事件
		jQuery(".remove").click(removeApproval);//删除按钮事件

        
        //主动触发创建节点点击事件
		jQuery(".proposer2").trigger("mousedown");
		jQuery(".proposer1").trigger("mousedown");
		jQuery(".proposer").trigger("mousedown");


		if(roadDuty==0){//没有权限
			jQuery(".insert").css("display","none");
		}

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
	function proposerSpan(title){
		var div=jQuery("<div><div>"+title+"</div></div>");
		div.mousedown(function (){
			var id=jQuery(this).attr("id");
			commonMouseDown(id);
			jQuery("#detail_disable").css("display","block");
			jQuery(".menu").css("display","none");
		})
		return div;
	}
	/**审批人**/
	function approvalSpan(title){
		var div=jQuery("<div><div>"+title+"</div></div>");
		div.mousedown(function (){
			var id=jQuery(this).attr("id");
			commonMouseDown(id);
			jQuery("#detail_disable").css("display","block");
			jQuery(".menu").css("display","none");
		})
		return div;	
	}
	/**审批人（可拖）**/
	function canDragSpan(title){
		if(title.length==0){
			title=init_nodeName;
		}
		var div=jQuery("<div class='approval_drag'><div>"+title+"</div></div>");
		div.mousedown(function (){
			jQuery(".remove").css("display","inline-block");
			jQuery(".agency").css("display","inline-block");
			doMouseDown(this);
		/**	changeNodeSpan();**/
			jQuery("#detail_disable").css("display","none");
			fillDetail(-1);	
		});
	/**	div.mouseout(function (){
			var offset=jQuery(".nodeChecked").offset();
			var width=jQuery(".nodeChecked").width();
			var height=jQuery(".nodeChecked").height();
			jQuery(".nodeChecked").css("top",(offset.top+40)).css("left",(offset.left+20));
			jQuery(".nodeChecked").css("width",(width-40)+'px').css("height",(height-80)+'px').css("line-height",(height-80)+'px');
			
			saveDetail();

		//	jQuery(".menu").css("display","none");

		});**/
		div.draggable({
						containment:"#mainSpan",
						helper: "clone",
						stop:stopDragg
					});
		return div;
	}
/**	function changeNodeSpan(){
		var offset=jQuery(".nodeChecked").offset();
		var width=jQuery(".nodeChecked").width();
		var height=jQuery(".nodeChecked").height();
		jQuery(".nodeChecked").css("top",(offset.top-40)).css("left",(offset.left-20));
		jQuery(".nodeChecked").css("width",(width+40)+'px').css("height",(height+80)+'px').css("line-height",(height+80)+'px');
	}
**/	/**归档**/
	function pigeonholeSpan(title){
		var div=jQuery("<div><div>"+title+"</div></div>");
		div.mousedown(function (){
			var id=jQuery(this).attr("id");
			commonMouseDown(id);
			jQuery("#detail_disable").css("display","block");
			jQuery(".menu").css("display","none");
		})
		return div;
	}
	/**横向箭头**/
	function Arrows(){
		var div=jQuery("<div class='arrow'></div>");

		return div;
	}
	function commonMouseDown(id){
		if(jQuery(".nodeChecked").length>0){
			if(jQuery("#detail_disable").css("display")=="none"){
				saveDetail();
			}
			jQuery(".nodeChecked").removeClass("nodeChecked");
		}
	
		fillDetail(id);
		
	}
	function doMouseDown(div){
		if(jQuery(".nodeChecked").length>0){
			if(jQuery("#detail_disable").css("display")=="none"){
				saveDetail();
			}
			jQuery(".nodeChecked").removeClass("nodeChecked");
		}	
		jQuery(div).addClass("nodeChecked");		
		showMenu();
	}
	//填充右侧设置信息
	function fillDetail(k){


        jQuery(".sbOptions").parent().hide();

		var names;
		var ids;
		var nodeDo;
		if(k!=-1){	
			
	//		jQuery("#spanBase").find("select[name='nodetype']").find("option").css("display","block");
	//		jQuery("#spanBase").find("select[name='nodetype']").parent().find("li").css("display","block");

			var item;
			//获取节点信息
			for(var i=0;i<fulldata.length;i++){
				if(fulldata[i].id==k){
					item=fulldata[i];
					break;
				}
			}
			
			prettifySelect("node",item.nodetype);
			
			jQuery("#spanBase").find("input[name='nodename']").val(item.nodename);
			
			jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","none");

			prettifySelect("sign",item.Signtype);

			names=item.operatornames;
			ids=item.operators;

			prettifySelect("road",item.road);

			jQuery("#spanOther").find("input[name='frms']").val(item.frms);
			jQuery("#spanOther").find("input[name='trust']").val(item.trust);

			nodeDo=item.nodeDo;
			
		}else{
	
			jQuery("#spanBase").find("select[name='nodetype']").parent().find(".sbSelector").text();

			var id=jQuery(".nodeChecked").attr("id");
			
			var nodename=jQuery("#freeForm").find("input[name='nodename_"+id+"']").val();

			jQuery("#spanBase").find("input[name='nodename']").val(nodename);

			if(nodename.length>0){
				jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","none");
			}else{
				jQuery("#spanBase").find("input[name='nodename']").parent().find(".bacoError").css("display","block");
			}
			
			prettifySelect("dragnode",jQuery("#freeForm").find("input[name='nodetype_"+id+"']").val());
			
			prettifySelect("sign",jQuery("#freeForm").find("input[name='Signtype_"+id+"']").val());

			//其他设置
			prettifySelect("dragroad",jQuery("#freeForm").find("input[name='road_"+id+"']").val());

			jQuery("#spanOther").find("input[name='frms']").val(jQuery("#freeForm").find("input[name='frms_"+id+"']").val());
			jQuery("#spanOther").find("input[name='trust']").val(jQuery("#freeForm").find("input[name='trust_"+id+"']").val());
			
			names=jQuery("#freeForm").find("input[name='operatornames_"+id+"']").val();
			ids=jQuery("#freeForm").find("input[name='operators_"+id+"']").val();			

			nodeDo=jQuery("#freeForm").find("input[name='nodeDo_"+id+"']").val();
		}
	
		jQuery("#spanBase").find("input[name='operatornames']").val(names);
		jQuery("#spanBase").find("input[name='operators']").val(ids);

		//jQuery("#operatorsspan").empty();		
		if(ids.indexOf(",")===0){
			ids = ids.substr(1);
		}
		var resids=ids.split(",");
		var resname="";
		if(names.length>0){
			if (names.indexOf(',') == 0) {
				names = names.substring(1);
			}
			var resnames=names.split(",");			
			for(var i=0;i<resnames.length;i++){
				if(resnames[i]!=""){
					/*var span="<span class='e8_showNameClass'>"
								+"<a href='#"+resids[i]+"' target='_blank' title='"+resnames[i]+"' style='max-width:105px;'>"
								+resnames[i]
								+"</a>"
								+"<span id='"+resids[i]+"' class='e8_delClass' onclick=\"del(event,this,1);mark('operators')\" >"
								+"&nbsp;x&nbsp;"
								+"</span>"
							+"</span>";
					jQuery("#operatorsspan").append(span);*/
					resname=resname+"<a href='#"+resids[i]+"'>"+resnames[i]+"</a>";
				}
			}			
		}

		if (k == -1)  {
			_writeBackData('operators',2,{id:ids,name:resname},{isSingle:false,hasInput:true,replace:true});
		} else {
			_writeBackData('operators',0,{id:ids,name:resname},{isSingle:false,hasInput:true,replace:true});
			jQuery('#operatorsspanimg').html('');
		}

		jQuery("#spanOther").find(".tzCheckBox").remove();
		
		if(frmsDuty==0){//路径编辑按钮disable
			jQuery("#spanOther").find("input[name='frms']").attr("disabled","disabled");
		}

        jQuery("#spanOther").find("input[name='frms']").tzRadio({labels:['','']});
		jQuery("#spanOther").find("input[name='trust']").tzRadio({labels:['','']});
  
		

		if(nodeDo.length>0){
			var nodeDos=nodeDo.split(",");
			jQuery("#spanOther").find("input[name='nodeDo']").attr("checked",false);
			jQuery("#spanOther").find("input[name='nodeDo']").next("span.jNiceCheckbox").removeClass("jNiceChecked");
			for(var i=0;i<nodeDos.length;i++){
				jQuery("#spanOther").find("input[name='nodeDo'][value='"+nodeDos[i]+"']").attr("checked",true);
				jQuery("#spanOther").find("input[name='nodeDo'][value='"+nodeDos[i]+"']").next("span.jNiceCheckbox").addClass("jNiceChecked");
			}			
		}
	}
	function saveDetail(){
		var id=jQuery(".nodeChecked").attr("id");
		
		var nodename=jQuery("#spanBase").find("input[name='nodename']").val();

		jQuery("#freeForm").find("input[name='nodename_"+id+"']").val(nodename);

		alterNodeName(nodename);
		
		var nondetype=jQuery("#spanBase").find("select[name='nodetype']").val();

		jQuery("#freeForm").find("input[name='nodetype_"+id+"']").val(nondetype);

		alterNodeType(nondetype);

		jQuery("#freeForm").find("input[name='Signtype_"+id+"']").val(jQuery("#spanBase").find("select[name='Signtype']").val());
		
		var names="";

		jQuery("#operatorsspan").parent().find("a").each(function (){
			names=names+","+jQuery(this).text();
		})

		//jQuery("#freeForm").find("input[name='operatornames_"+id+"']").val(jQuery("#spanBase").find("input[name='operatornames']").val());
		jQuery("#freeForm").find("input[name='operatornames_"+id+"']").val(names);
		jQuery("#freeForm").find("input[name='operators_"+id+"']").val(jQuery("#spanBase").find("input[name='operators']").val());
		
		jQuery("#freeForm").find("input[name='road_"+id+"']").val(jQuery("#spanOther").find("select[name='road']").val());
		jQuery("#freeForm").find("input[name='frms_"+id+"']").val(jQuery("#spanOther").find("input[name='frms']").val());
		jQuery("#freeForm").find("input[name='trust_"+id+"']").val(jQuery("#spanOther").find("input[name='trust']").val());
	//	jQuery("#freeForm").find("input[name='sync_"+id+"']").val(jQuery("#spanOther").find("input[name='sync']").val());
		
		var nodeDo="";
		jQuery("#spanOther").find("input[name='nodeDo']").each(function (){
			if(jQuery(this).attr("checked")){
				nodeDo=nodeDo+jQuery(this).val()+",";
			}
		});
		if(nodeDo.lastIndexOf(",")>-1){
			nodeDo = nodeDo.substring(0,nodeDo.lastIndexOf(","));
		}

		jQuery("#freeForm").find("input[name='nodeDo_"+id+"']").val(nodeDo);
	}
	function showMenu(){
		//菜单显示
		jQuery(".menu").css("display","block");
		
		var offset=jQuery(".nodeChecked").offset();

		jQuery(".menu").css("top",(offset.top-jQuery(".menu").height()-10+mainSpan.scrollTop())).css("left",((offset.left+jQuery(".nodeChecked").width()/2)-jQuery(".menu").width()/2));
		
	}
	function addRowForm(appData){
		jQuery("#freeForm").append("<input type='hidden' name='floworder_"+appData.id+"' value='"+appData.floworder+"'/>");//顺序
		jQuery("#freeForm").append("<input type='hidden' name='nodeid_"+appData.id+"' value='"+appData.nodeid+"'/>");//名称
		jQuery("#freeForm").append("<input type='hidden' name='nodename_"+appData.id+"' value='"+appData.nodename+"'/>");//名称
		jQuery("#freeForm").append("<input type='hidden' name='nodetype_"+appData.id+"' value='"+appData.nodetype+"'/>");//名称
		jQuery("#freeForm").append("<input type='hidden' name='Signtype_"+appData.id+"' value='"+appData.Signtype+"'/>");//会签类型
		jQuery("#freeForm").append("<input type='hidden' name='operators_"+appData.id+"' value='"+appData.operators+"'/>");//操作者id
		jQuery("#freeForm").append("<input type='hidden' name='operatornames_"+appData.id+"' value='"+appData.operatornames+"'/>");//操作者name
		
		/**其他设置信息，填写的均是测试值**/
		jQuery("#freeForm").append("<input type='hidden' name='road_"+appData.id+"' value='"+appData.road+"' />");//路径编辑
		jQuery("#freeForm").append("<input type='hidden' name='frms_"+appData.id+"' value='"+appData.frms+"'/>");//表单编辑
		jQuery("#freeForm").append("<input type='hidden' name='trust_"+appData.id+"' value='"+appData.trust+"'/>");//节点签章
	//	jQuery("#freeForm").append("<input type='hidden' name='sync_"+appData.id+"' value='"+appData.sync+"'/>");//同步所有节点
		jQuery("#freeForm").append("<input type='hidden' name='nodeDo_"+appData.id+"' value='"+appData.nodeDo+"'/>");//节点操作

		jQuery("#freeForm").find("#rownum").val(jQuery(".approval_drag").length+1);
		jQuery("#freeForm").find("#indexnum").val(appData.id+1);
		jQuery("#freeForm").find("#checkfield").val(jQuery("#freeForm").find("#checkfield").val()+",nodename_"+appData.id+",operators_"+appData.id);
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
			
			if(jQuery("#freeForm").find("input[name='floworder_"+spanArray[i].id+"']").length>0){
				jQuery("#freeForm").find("input[name='floworder_"+spanArray[i].id+"']").val(freeNum);
				freeNum++;
			}

			if(spanArray[i].id==startSpan.id){
				sign=1;
				startSpan=spanArray[i];
				startrows=rows;
			}
			if(spanArray[i].id==stopSpan.id){
				stopSpan=spanArray[i];
				stoprows=rows;
			}
			
			if(i==(spanArray.length-1)){
				break;
			}

			num++;
			if(num%cols==0){
				
				//加纵向箭头
				var arrow=Arrows();
				if(sign==0){
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
					if(sign==0){
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
					if(sign==0){
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
	function addApproval(){
		appNum++;
		var div=canDragSpan(init_nodeName + (spanId - 1));

		div.addClass("approval2");


		//生成节点id
		div.attr("id",spanId);

		jQuery(".nodeChecked").after(div);

		appInitData.id=spanId;
		appInitData.floworder=spanId;
		appInitData.nodename=init_nodeName + (spanId - 1);
        appInitData.nodeid = -1;
		addRowForm(appInitData);

		//数组重排序
		var spanArray=[];
		var id=jQuery(".nodeChecked").attr("id");
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
		showMian(spanArray);

		spans=spanArray;

		spanId++;

	}
	function removeApproval(){
		var id=jQuery(".nodeChecked").attr("id");

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

		jQuery(".nodeChecked").remove();

		jQuery(".menu").css("display","none");

		jQuery("#detail_disable").css("display","block");

	}
	function removeRowForm(i){
		jQuery("#freeForm").find("input[name='floworder_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='nodeid_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='nodename_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='nodetype_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='Signtype_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='operators_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='operatornames_"+i+"']").remove();

		jQuery("#freeForm").find("input[name='road_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='frms_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='trust_"+i+"']").remove();
	//	jQuery("#freeForm").find("input[name='sync_"+i+"']").remove();
		jQuery("#freeForm").find("input[name='nodeDo_"+i+"']").remove();

		jQuery("#freeForm").find("#rownum").val(jQuery(".approval_drag").length-1);

		var checkfield=jQuery("#freeForm").find("#checkfield").val();
		var checkfields=checkfield.split(",");
		checkfield="";
		for(var r=0;r<checkfields.length;r++){
			if((checkfields[r]!=("nodename_"+i))||(checkfields[r]!=("operators_"+i))){
				checkfield=checkfield+checkfields[r]+",";
			}
		}
		jQuery("#freeForm").find("#checkfield").val(checkfield);
	}
	function updateOperators(){
		//获取第一个自由节点
		var i=jQuery("#freeForm").find("#indexnum").val();
		if(i.length==0||i==0){
			return -1;
		}
		var id=-1;
		var minfloworder=i;
		var curfloworder;
		for(var k=0;k<i;k++){
			if(jQuery("#freeForm").find("input[name='floworder_"+k+"']").length>0){
				curfloworder=jQuery("#freeForm").find("input[name='floworder_"+k+"']").val();
				if(curfloworder<minfloworder){
					minfloworder=curfloworder;
					id=k;
				}
			}
		}
		return id;
	}
	function fillFreedata(){
		if(parentSpan.find("input[name='indexnum']").length>0){
			var num=0;
			var iArray=[];
			var fArray=[];
			var index=parentSpan.find("input[name='indexnum']").val();
			for(var i=0;i<index;i++){
				if(parentSpan.find("input[name='floworder_"+i+"']").length>0){
					iArray[num]=i;
					fArray[num]=parentSpan.find("input[name='floworder_"+i+"']").val();
					num++;
				}
			}
			for (var k = 0; k < num; k++) {
				for (var n = k+1; n < num; n++) {
					var floworder = parseInt(fArray[k]);
					var index = iArray[k];
					if (floworder > fArray[n]) {
						fArray[k] = fArray[n];
						fArray[n] = floworder;
						
						iArray[k] = iArray[n];
						iArray[n] = index;
					}
				}
			}
			num=0;
			for(var m=0;m<iArray.length;m++){
				freedata[num]={
								nodetype:parentSpan.find("input[name='nodetype_"+iArray[m]+"']").val(),
								floworder:parentSpan.find("input[name='floworder_"+iArray[m]+"']").val(),
								nodename:parentSpan.find("input[name='nodename_"+iArray[m]+"']").val(),
								nodeid:parseInt(parentSpan.find("input[name='nodeid_"+iArray[m]+"']").val()),
								Signtype:parentSpan.find("input[name='Signtype_"+iArray[m]+"']").val(),
								operators:parentSpan.find("input[name='operators_"+iArray[m]+"']").val(),
								operatornames:parentSpan.find("input[name='operatornames_"+iArray[m]+"']").val(),
								road:parentSpan.find("input[name='road_"+iArray[m]+"']").val(),
								frms:parentSpan.find("input[name='frms_"+iArray[m]+"']").val(),
								trust:parentSpan.find("input[name='trust_"+iArray[m]+"']").val(),
			//					sync:parentSpan.find("input[name='sync_"+iArray[m]+"']").val(),
								nodeDo:parentSpan.find("input[name='nodeDo_"+iArray[m]+"']").val()
							}
				num++;					
			}
		}else{
			freedata=[];
		}
	}
	function DataSync(id){
		if(id==-1){
			parentSpan.empty();
			parentSpan.html("<input type='hidden' name='freeNode' value='0'/>");
		}else{
			parentSpan.empty();
			parentSpan.html(jQuery("#freeForm").html());
		}
	}
	function fillParentInput(id){
		jQuery("#operator_0span", window.top.freewindow.document).empty();
		if(id==-1){
			jQuery("#operator_0",window.top.freewindow.document).val("");
			return;
		}
		var ids=jQuery("#freeForm").find("input[name='operators_"+id+"']").val();
		var names=jQuery("#freeForm").find("input[name='operatornames_"+id+"']").val();
		
		jQuery("#operator_0",window.top.freewindow.document).val(ids);
		
		if(ids.indexOf(",")==0){
			ids=ids.substr(1);
		}
		if(names.indexOf(",")==0){
			names=names.substr(1);
		}

		if(names.length>0){	
			var resnames=names.split(",");
			var resids=ids.split(",");
			var linkarrays=[];
			for(var i=0;i<resids.length;i++){
				if(resids[i].length>0){
				    linkarrays.push("<a href='#"+resids[i]+"'>"+resnames[i]+"</a>");
				}				
			}
           var data={id:ids,name:linkarrays.join("")};
           window.top.freewindow._writeBackData('operator_0',1,data,{isSingle:false,hasInput:true,replace:true});
		}
	}
	function handlePigeonhole(id){

		var switchitem=jQuery(".switch", window.top.freewindow.document);
        var connectlist=jQuery(".connectlist", window.top.freewindow.document);
		
		if(id==-1){
			jQuery("#freeNodeSpan", window.top.freewindow.document).css("display","none");
			jQuery("#overNodeSpan", window.top.freewindow.document).css("display","table-row");
            if(connectlist.is(":visible"))
			{
			   switchitem.trigger("click");
			}
            switchitem.hide();
		}else{
			if(jQuery("#overNodeSpan", window.top.freewindow.document).css("display")!="none"){
				jQuery("#freeNodeSpan", window.top.freewindow.document).css("display","table-row");
				jQuery("#overNodeSpan", window.top.freewindow.document).css("display","none");			
				jQuery("#freeNodeSpan", window.top.freewindow.document).find("#inneroperator_0div").css("width","91%");
			} 
			//展示常用联系人开关(edit by lsj 2014/4/8)
            switchitem.find("img").attr("src","/images/ecology8/wf_freeshow_wev8.png");
			switchitem.show();
      

			fillParentInput(id);
		}
	}
	function alterNodeName(value){
		jQuery(".nodeChecked").find("div").text(value);
	}
	function alterNodeType(value){
		jQuery(".nodeChecked").removeClass("approval2 ");
		jQuery(".nodeChecked").removeClass("manage2");
		if(value==1){
			jQuery(".nodeChecked").addClass("approval2 ");
		}else if(value==2){
			jQuery(".nodeChecked").addClass("manage2");
		}
	}
	function makeNodeTypeSelect(value){
		var s=0;
		var p=nodeTypeOption.length;
		if(value==-1){
			//添加的是可拖节点，要过滤掉创建和归档节点
			s=1;
			p=p-1;
		
		}
		var select="<select class=inputstyle style='width:120px' name='nodetype' onchange='changeType(this.value)'>";
			for(var i=s;i<p;i++){
				select=select+"<option value='"+nodeTypeOption[i].id+"'";
				if(value==nodeTypeOption[i].id){
					select=select+" selected='selected'";
				}
				select=select+">"+nodeTypeOption[i].value+"</option>";
			}

			select=select+"</select>";
		return  jQuery(select);
	}
	function makeSignTypeSelect(value){
		var select="<select class=inputstyle style='width:120px' name='Signtype'>";
		for(var i=0;i<signTypeOption.length;i++){
			select=select+"<option value='"+signTypeOption[i].id+"'";
			if(value==signTypeOption[i].id){
				select=select+" selected='selected'";
			}
			select=select+">"+signTypeOption[i].value+"</option>";
		}
		select=select+"</select>";
		return  jQuery(select);
	}
	function makeRoadTypeSelect(value){
		var select="<select class=inputstyle style='width:120px' name='road'>";
		for(var i=0;i<roadTypeOption.length;i++){
			if(value==-1&&i>roadDuty){
				break;
			}
			select=select+"<option value='"+roadTypeOption[i].id+"'";
			if(value==roadTypeOption[i].id){
				select=select+" selected='selected'";
			}
			select=select+">"+roadTypeOption[i].value+"</option>";
		}
		select=select+"</select>";
		return  jQuery(select);
	} 
	function prettifySelect(key,value){
		var TypeSpan;
		var select;
		if(key=="node"){
			TypeSpan=jQuery("#spanBase").find("select[name='nodetype']").parent();
			select=makeNodeTypeSelect(value);
		}else if(key=="sign"){
			TypeSpan=jQuery("#spanBase").find("select[name='Signtype']").parent();
			select=makeSignTypeSelect(value);
		}else if(key=="dragnode"){
			TypeSpan=jQuery("#spanBase").find("select[name='nodetype']").parent();
			select=makeNodeTypeSelect(-1);
		}else if(key=="road"){
			TypeSpan=jQuery("#spanOther").find("select[name='road']").parent();
			select=makeRoadTypeSelect(value);
		}else if(key=="dragroad"){
			TypeSpan=jQuery("#spanOther").find("select[name='road']").parent();
			select=makeRoadTypeSelect(-1);
		}

		TypeSpan.empty();
		
		TypeSpan.append(select);

		TypeSpan.find("select").val(value);

		TypeSpan.find("select").selectbox();

	}
})();