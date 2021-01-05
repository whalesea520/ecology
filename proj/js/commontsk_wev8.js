var lossFlag=false;//解决双击任务标题后会掉值的问题
function onSelectBeforeTaskE8(spanname,inputename) {
    try{
    	var inputid=$(inputename).attr("id");
		showModalDialogForBrowser(null,
				"/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectTaskBrowser.jsp", '#', inputid, true, 2, '', 
				{name:inputid,hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onSelectBeforeTaskE8_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onSelectBeforeTaskE8_callback(p1,datas,fieldname,p4,p5){
	if (datas&&fieldname) {
	    var spanname="seleBeforeTaskSpan_"+fieldname.split("_")[1];
		if(datas.id!=""){
			$("#"+spanname).html(datas.name);
			$("#"+fieldname).val(datas.id.trim());
			var oldIndex=$("input[name='txtRowIndex']:eq("+(datas.id-1)+")").val(); 
			$("#"+fieldname).attr("oldIndex",oldIndex);
		}else{
			$("#"+spanname).html("");
			$("#"+fieldname).val("");
		}
		beforeTask_check($("#"+fieldname)[0]);
	    
    }
}
function onSelectManagerE8(spanname,inputename) {
    try{
    	var inputid=$(inputename).attr("id");
    	var tmpids = $("input[name=hrmids02]",parent.document).val();
		showModalDialogForBrowser(null,
				"/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectManagerBrowser.jsp?Members="+tmpids, '#', inputid, true, 2, '', 
				{name:inputid,hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onSelectManagerE8_callback}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onSelectManagerE8_callback(p1,datas,fieldname,p4,p5){
	if (datas&&fieldname) {
	    var spanname="txtManagerSpan_"+fieldname.split("_")[1];
		if(datas.id!=""){
			$("#"+spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"' target='_blank'>"+datas.name+"</A>");
			$("#"+fieldname).val(datas.id);
		}else{
			$("#"+spanname).html("");
			$("#"+fieldname).val("");
		}
	    
    }
}

//多选任务负责人
function onSelectApprove(spanname,inputename){
	try{
	var tmpids = $(inputename).val();
	var inputid=$(inputename).attr("id");
	showModalDialogForBrowser(null,
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids, '#', inputid, true, 2, '', 
			{name:inputid,hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onSelectApprove_callback}
		);
	}catch(ex1){
		alert(ex1);
	}
	
}

function onSelectApprove_callback(p1,datas,fieldname,p4,p5){
	if (datas&&fieldname) {
	    var spanname="txtManagerSpan_"+fieldname.split("_")[1];
		if(datas.id!=""){
			$("#"+spanname).html(datas.name.replace(/,/g,"&nbsp;"));
			$("#"+fieldname).val(datas.id);
		}else{
			$("#"+spanname).html("");
			$("#"+fieldname).val("");
		}
	    
    }
}
function addRow(){
	lossFlag=false;
	var rootNode = $("#tblTask").fancytree("getRootNode");
    var childNode = rootNode.addChildren({
      title: SystemEnv.getHtmlNoteName(4000,readCookie("languageidweaver")),
      folder: false,
      isNew: true
    });
    childNode.editStart();
    lossFlag=true;
}
function delRows(){
	var msg=SystemEnv.getHtmlNoteName(3999,readCookie("languageidweaver"));
	if(window.top.Dialog.confirm(msg,function(){
	  	var tree=$("#tblTask").fancytree("getTree");
	  	var nodeArr= tree.getSelectedNodes();
	  	for(var i=0;i<nodeArr.length;i++){
	  		try{
	  			nodeArr[i].remove();
	  		}catch(e){}
	  	}
	}));
}
//提交时重算任务等级和父亲索引
function reloadTaskTree(){
	var levelflag = "noemallevel";
	$("#tblTask").fancytree("getTree").visit(function(node){
		if(node.getLevel()>10){
			levelflag ="overlevel";
		}
		$(node.tr).find("input[type=hidden][name=txtLevel]").val(node.getLevel());
		$(node.tr).find("input[type=hidden][name=txtParentRowIndex]").val(node.getParent().key.substring(1)||"0");
  	});
	$("#tblTask").find("input[type=text][name=txtWorkLong]").each(function(){
		$(this).attr("value",$(this).val());
	});
	$("#tblTask").find("input[type=text][name=txtBudget]").each(function(){
		$(this).attr("value",$(this).val());
	});
	return levelflag;
}
function hideRightMenu(e){
	var event=$.event.fix(e);
	var element=event.target;
	var tagname=element.tagName.toLowerCase();
	var classname=element.className.toLowerCase();
	if(("span"===tagname&&"fancytree-title"===classname) || ("input"===tagname&&"fancytree-edit-input"===classname) ){
		$("#rightMenuIframe").hide();
	}else{
		$("#rightMenuIframe").show();
	}
}
function loadTaskData(tableId,url,lazyurl,isedit,istemplate){
	
	var	CLIPBOARD = null;
	var src=[];
	if(url&&url.length>0){
		src={url:url};
	}
	
	$("#"+tableId).fancytree({
		checkbox: true,
		titlesTabbable: true,     
		icons:false,
		debugLevel:0,
		source: src,
		lazyLoad: function(event, data) {
	      var node = data.node;
	      data.result = {
	        url: lazyurl,
	        data: {key: node.key}
	      }
	    },
	    focusTree:function(){
	    	lossFlag=true;
	    },
		extensions: ["edit", "dnd", "table", "gridnav"],

		dnd: {
			preventVoidMoves: true,
			preventRecursiveMoves: true,
			autoExpandMS: 400,
			dragStart: function(node, data) {
				return true;
			},
			dragEnter: function(node, data) {
				return true;
			},
			dragDrop: function(node, data) {
				data.otherNode.moveTo(node, data.hitMode);
			}
		},
		edit: {
			triggerCancel: ["esc", "tab", "click"],
		    triggerStart: ["f2", "dblclick", "shift+click", "mac+enter"]
		},
		table: {
			indentation: 20,
			nodeColumnIdx: 2,
			checkboxColumnIdx: 0
		},
		gridnav: {
			autofocusInput: false,
			handleCursorKeys: true
		},


		
		renderColumns: function(event, data) {
			var node = data.node,
			$tdList = $(node.tr).find(">td");
			node.setExpanded(true);//自动展开节点
			      
			if( node.isFolder() ) {
				$tdList.eq(2)
					.prop("colspan", 6)
					.nextAll().remove();
			}

			$tdList.eq(1).text(node.getIndexHier()).addClass("alignRight");
			var iRowIndex=node.key.substring(1);
			
			var tasknameval=node.title||"";
			var begindate=node.data.begindate||"";
			var begintime=node.data.begintime||"00:00";
			var enddate=node.data.enddate||"";
			var endtime=node.data.endtime||"23:59";
			var workday=node.data.workday||"";
			var budget=node.data.budget||"";
			var beftaskid=node.data.beftaskid||"";
			var hrmid=node.data.hrmid||"";
			var hrmname=node.data.hrmname||"";
			//var pid=node.data.pid||"";
			var pid=node.getParent().key.substring(1)||"0";//父亲的索引
			var lv=node.getLevel()||"1";//任务层级
			var realid="";
			var realidHtml="";
			var beftaskname="";
			if(isedit&&"true"==isedit){//只有编辑任务页面才有
				realid=node.data.realid||"0";//数据库里的真实id
				realidHtml="<input type='hidden' name='realid' value='"+realid+"' />";

			}
            beftaskname=node.data.beftaskname||"";

			
			//模板的任务id
			var templatetaskid=node.data.realid||"";
			var templatetaskidHtml="<input type='hidden' name='templetTaskId' value='"+templatetaskid+"' />";
			
			var parentindexHtml="<input type='hidden' name='txtParentRowIndex' id='txtParentRowIndex_"+iRowIndex+"' value='"+pid+"' />";
			var levelHtml="<input type='hidden' name='txtLevel' id='txtLevel_"+iRowIndex+"' value='"+lv+"' />";
			
			var rowindexHtml="<input type='hidden' name='txtRowIndex' id='txtRowindex_"+iRowIndex+"' value='"+iRowIndex+"' />";
			var tasknameHtml="<input type='hidden' class='InputStyle'  name='txtTaskName' size='24'  style='width:150px!important;'    id='txtTaskName_"+iRowIndex+"' onchange=''   customIndex='"+iRowIndex+"' value='"+tasknameval+"' />";
			var worklongHtml="<input type='text' class='InputStyle' style='width:50px!important;' name='txtWorkLong'  size='4' id='txtWorkLong_"+iRowIndex+"'  onKeyPress='ItemNum_KeyPress(this)' onchange='onWorkLongChange(this,txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+")' value='"+workday+"'>"; 

              
            //开始日期
			var begindateHtml="<button type=\"button\" class=Calendar onclick='onShowBeginDate(txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
            "<SPAN id=spanBeginDate_"+iRowIndex+" >"+begindate+"</SPAN>"+
            "<input type='hidden' name='txtBeginDate' id='txtBeginDate_"+iRowIndex+"' value='"+begindate+"'>";
            
            //开始时间
            var begintimeHtml="";
            if(istemplate&&"true"==istemplate){
           		begintimeHtml = "<button style='visibility:hidden'  type=\"button\" class=Clock onclick='onShowBeginTime(txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>";
           		 begintimeHtml +="<SPAN  style='visibility:hidden' id=spanBeginTime_"+iRowIndex+" >"+begintime+"</SPAN>";
            }else{
            	begintimeHtml += "<button  type=\"button\" class=Clock onclick='onShowBeginTime(txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>";
            	begintimeHtml +="<SPAN id=spanBeginTime_"+iRowIndex+" >"+begintime+"</SPAN>";
            	
            }
            begintimeHtml+="<input type='hidden' name='txtBeginTime' id='txtBeginTime_"+iRowIndex+"' value='"+begintime+"'>"; 
            
            //结束日期 
            var enddateHtml="<button type=\"button\" class=Calendar onclick='onShowEndDate(txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>"+
            "<SPAN id=spanEndDate_"+iRowIndex+" >"+enddate+"</SPAN>"+
            "<input type='hidden' name='txtEndDate' id='txtEndDate_"+iRowIndex+"' value='"+enddate+"'>";
            
            //结束时间
            var endtimeHtml="";
            if(istemplate&&"true"==istemplate){
           		 endtimeHtml= "<button style='visibility:hidden' type=\"button\" class=Clock onclick='onShowEndTime(txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>";
          		  endtimeHtml+="<SPAN  style='visibility:hidden' id=spanEndTime_"+iRowIndex+" >"+endtime+"</SPAN>";
            }else{
            	endtimeHtml+= "<button type=\"button\" class=Clock onclick='onShowEndTime(txtEndDate_"+iRowIndex+",spanEndDate_"+iRowIndex+",txtBeginDate_"+iRowIndex+",spanBeginDate_"+iRowIndex+",txtEndTime_"+iRowIndex+",spanEndTime_"+iRowIndex+",txtBeginTime_"+iRowIndex+",spanBeginTime_"+iRowIndex+",txtWorkLong_"+iRowIndex+")'></BUTTON>";
            endtimeHtml+="<SPAN id=spanEndTime_"+iRowIndex+" >"+endtime+"</SPAN>";
            }
            endtimeHtml+="<input type='hidden' name='txtEndTime' id='txtEndTime_"+iRowIndex+"' value='"+endtime+"'>";
            
                       
            var pretaskHtml="<button type=\"button\" class=e8_browflow onclick='onSelectBeforeTaskE8(seleBeforeTaskSpan_"+iRowIndex+",seleBeforeTask_"+iRowIndex+")'></button><input type=hidden name='seleBeforeTask' id='seleBeforeTask_"+iRowIndex+"' value='"+beftaskid+"'  onchange='beforeTask_check(this)' ><span id='seleBeforeTaskSpan_"+iRowIndex+"'>"+beftaskname+"</span><input type=hidden name='index_"+iRowIndex+"' id='index_"+iRowIndex+"' value='"+iRowIndex+"'>";
            var budgetHtml="<input type='text' class='InputStyle' style='width:80px!important;' name='txtBudget' size='8' id='txtBudget_"+iRowIndex+"' onKeyPress='ItemNum_KeyPress(this)' value='"+budget+"'>";                
            var managerHtml="<button type=\"button\" class=e8_browflow onclick='onSelectApprove(txtManagerSpan_"+iRowIndex+",txtManager_"+iRowIndex+")'></button><input type=hidden name='txtManager' id='txtManager_"+iRowIndex+"' value='"+hrmid+"' ><span id='txtManagerSpan_"+iRowIndex+"'>"+hrmname+"</span>";
            
            if(lossFlag){
            	$tdList.eq(3).find("input[name=txtTaskName]").val(tasknameval);
			}else{
				$tdList.eq(3).html(realidHtml+parentindexHtml+levelHtml+templatetaskidHtml+rowindexHtml+tasknameHtml+worklongHtml);
				$tdList.eq(4).html(begindateHtml+" "+begintimeHtml);
				$tdList.eq(5).html(enddateHtml+" "+endtimeHtml);
				$tdList.eq(6).html(pretaskHtml);
				$tdList.eq(7).html(budgetHtml);
				$tdList.eq(8).html(managerHtml);
			}
			
			//$tdList.eq(7).html($select);
		}
	}).on("nodeCommand", function(event, data){
		// context menu:
		var refNode, moveMode,
			tree = $(this).fancytree("getTree"),
			node = tree.getActiveNode();

		switch( data.cmd ) {
		case "moveUp":
			node.moveTo(node.getPrevSibling(), "before");
			node.setActive();
			break;
		case "moveDown":
			node.moveTo(node.getNextSibling(), "after");
			node.setActive();
			break;
		case "indent":
			refNode = node.getPrevSibling();
			node.moveTo(refNode, "child");
			refNode.setExpanded();
			node.setActive();
			break;
		case "outdent":
			node.moveTo(node.getParent(), "after");
			node.setActive();
			break;
		case "rename":
			node.editStart();
			break;
		case "remove":
			node.remove();
			break;
		case "addChild":
			lossFlag=false;
			refNode = node.addChildren({
				title: SystemEnv.getHtmlNoteName(4001,readCookie("languageidweaver")),
				isNew: true
			});
			node.setExpanded();
			refNode.editStart();
			lossFlag=true;
			break;
		case "addSibling":
			lossFlag=false;
			refNode = node.getParent().addChildren({
				title: SystemEnv.getHtmlNoteName(4000,readCookie("languageidweaver")),
				isNew: true
			}, node.getNextSibling());
			refNode.editStart();
			lossFlag=true;
			break;
		/**	
		case "cut":
			CLIPBOARD = {mode: data.cmd, data: node};
			break;
		case "copy":
			CLIPBOARD = {
				mode: data.cmd,
				data: node.toDict(function(n){
					delete n.key;
				})
			};
			break;
		case "clear":
			CLIPBOARD = null;
			break;
		case "paste":
			lossFlag=false;
			if( CLIPBOARD.mode === "cut" ) {
				// refNode = node.getPrevSibling();
				CLIPBOARD.data.moveTo(node, "child");
				CLIPBOARD.data.setActive();
			} else if( CLIPBOARD.mode === "copy" ) {
				node.addChildren(CLIPBOARD.data).setActive();
			}
			lossFlag=true;
			break;
		**/	
		default:
			alert("Unhandled command: " + data.cmd);
			return;
		}

	}).on("keydown", function(e){
		var c = String.fromCharCode(e.which),
			cmd = null;

		if( c === "N" && e.ctrlKey && e.shiftKey) {
			cmd = "addChild";
		} else if( c === "C" && e.ctrlKey ) {
			cmd = "copy";
		} else if( c === "V" && e.ctrlKey ) {
			cmd = "paste";
		} else if( c === "X" && e.ctrlKey ) {
			cmd = "cut";
		} else if( c === "N" && e.ctrlKey ) {
			cmd = "addSibling";
		} else if( e.which === $.ui.keyCode.DELETE ) {
			cmd = "remove";
		} else if( e.which === $.ui.keyCode.F2 ) {
			cmd = "rename";
		} else if( e.which === $.ui.keyCode.UP && e.ctrlKey ) {
			cmd = "moveUp";
		} else if( e.which === $.ui.keyCode.DOWN && e.ctrlKey ) {
			cmd = "moveDown";
		} else if( e.which === $.ui.keyCode.RIGHT && e.ctrlKey ) {
			cmd = "indent";
		} else if( e.which === $.ui.keyCode.LEFT && e.ctrlKey ) {
			cmd = "outdent";
		}
		if( cmd ){
			$(this).trigger("nodeCommand", {cmd: cmd});
			return false;
		}
	});

	$("#"+tableId).contextmenu({
		delegate: "span.fancytree-title",
		menu: [
			{title: SystemEnv.getHtmlNoteName(4002,readCookie("languageidweaver")), cmd: "rename", uiIcon: "ui-icon-pencil" },
			{title: SystemEnv.getHtmlNoteName(3519,readCookie("languageidweaver")), cmd: "remove", uiIcon: "ui-icon-trash" },
			{title: "----"},
			{title: SystemEnv.getHtmlNoteName(4003,readCookie("languageidweaver")), cmd: "addSibling", uiIcon: "ui-icon-plus" },
			{title: SystemEnv.getHtmlNoteName(4004,readCookie("languageidweaver")), cmd: "addChild", uiIcon: "ui-icon-plus" }
//			,
//			{title: "----"},
//			{title: SystemEnv.getHtmlNoteName(4005,readCookie("languageidweaver")), cmd: "cut", uiIcon: "ui-icon-scissors"},
//			{title: SystemEnv.getHtmlNoteName(3874,readCookie("languageidweaver")), cmd: "copy", uiIcon: "ui-icon-copy"},
//			{title: SystemEnv.getHtmlNoteName(3876,readCookie("languageidweaver")), cmd: "paste", uiIcon: "ui-icon-clipboard", disabled: true }
			],
		beforeOpen: function(event, ui) {
			var node = $.ui.fancytree.getNode(ui.target);
			$("#"+tableId).contextmenu("enableEntry", "paste", !!CLIPBOARD);
			node.setActive();
		},
		select: function(event, ui) {
			var that = this;
			// delay the event, so the menu can close and the click event does
			// not interfere with the edit control
			setTimeout(function(){
				$(that).trigger("nodeCommand", {cmd: ui.cmd});
			}, 100);
		}
	});
}

$(function(){
	$("#chkAllObj").bind('click',function(){
		if(!$(this).is(":checked")){
			$("#tblTask").fancytree("getTree").visit(function(node){
	        	node.setSelected(true);
	      	});
		}else{
			$("#tblTask").fancytree("getTree").visit(function(node){
	        	node.setSelected(false);
	      	});
		}
	});
	
	//提示
	try{
		$("img.remindImg").attr("title",$("#remindtbl").text());
	}catch(e){}
});

