var lastSelectedTRObj=null;  //最后一次选区择的那个TR对像
var lastSelectedLineObj=null;
var srcRowObj;   //用于记录被拖动的源行对象
var targetRowObj;  //用于记录被拖动的目录行对象
var allowMove;       //允许移动的对象
var popedomMove;     //由于权限不让移动
var el;
var dragFlag=0;

//点击改变其本身的样式为select

function onDragTDDBClick(obj){
	var parentObj =$(obj).parent("tr")[0];	
	if(lastSelectedTRObj&&lastSelectedTRObj!=parentObj){
		lastSelectedTRObj.className="DataLight"
			for(var i=0;i<lastSelectedTRObj.cells.length;i++){
				lastSelectedTRObj.cells[i].className="DataLight";
			}
	};
	if(parentObj.className!="Selected"){
		parentObj.className="Selected";
		lastSelectedTRObj=parentObj;
		
			for(var i=0;i<parentObj.cells.length;i++){
				try{
				parentObj.cells[i].className="Selected";
				}catch(e){
					alert(i);
				}
			}
		
	}else{
		parentObj.className="DataLight";
		for(var i=0;i<parentObj.cells.length;i++){
			parentObj.cells[i].className="DataLight";
		}
		lastSelectedTRObj=null;
	}
}
function mousedown(e){    
	el =$.event.fix(e).target;	
	if(el==null||el.nodeName!="TD"||el.cellIndex!=0 || $(el).parents("tr")[0].rowIndex<2) return false;  //第2行以上第一列是TD的对像
	if ($(el).attr("trOwner")=="manager") return false ;
	if ($(el).attr("class")!="Selected") return false; 
	srcRowObj =  $(el).parents("tr")[0]; 
	allowMove=true ;
	popedomMove = true ;
}

function mouseup(e){		
	try
	{

		if (!allowMove) return false;
		allowMove = false ;
		if (!popedomMove){
			if (lastSelectedTRObj!=null) lastSelectedTRObj.className="DataLight";
			if (lastSelectedLineObj!=null) $(lastSelectedLineObj).find("td").css("background-color","#EFEFEF");	
			return false ;
		}
		
		if (el!=null && el.tagName=="TD" && ($(el).parent()[0].className=="DataLight" || $(el).parent()[0].className=="Selected"|| $(el).parent()[0].className=="Header")  && el.cellIndex==0) {	
			targetRowObj = el.parentElement
		}

		if (insertObj(srcRowObj,targetRowObj))  {		
			if (lastSelectedTRObj!=null&&lastSelectedTRObj!=targetRowObj) lastSelectedTRObj.className="DataLight";
		}
		if (lastSelectedLineObj!=null) $(lastSelectedLineObj).find("td").css("background-color","#EFEFEF");	
	}	catch (e){
			if (lastSelectedTRObj!=null) {
				lastSelectedTRObj.className="DataLight";
				lastSelectedTRObj == null ;
			}
			if (lastSelectedLineObj!=null) $(lastSelectedLineObj).find("td").css("background-color","#EFEFEF");	
		alert(e.number+": "+e.description)
		throw(e);
	}
	
}

function mousemove(e){
	
	if (!allowMove) return false;
	
	el =$.event.fix(e).target;		
	
	if (el!=null && el.nodeName=="TD" && ($(el).parent().attr("class")=="DataLight" || $(el).parent().attr("class")=="Selected"|| $(el).parent().attr("class")=="Header")  && el.cellIndex==0) {		
		if ($(el).parent().attr("rowStatus")=="disabled") {
			popedomMove = false ;				
			return false;
		}
		
		if (lastSelectedLineObj!=null) {
			$(lastSelectedLineObj).find("td").css("background","#EFEFEF");	
			
		}
		$(el).parent().next().find("td").css("background-color","#7F7F7F");	
		lastSelectedLineObj = $(el).parent().next();
	}
}

function insertObj(srcObj,targetObj){  	
	
	if (srcObj==targetObj) return false ;	

	//修改逻辑DOC对象及移动相关的行对象
	var locatObj;
    var locatAt;
	var isFirstRow=false;

	if (targetObj.className=="Header"){  //当目标行是表头的时候,则afterObj为其下一行的下一行,并且方式为前
		locatObj=$(targetObj).next().next()[0];
		locatAt="before"
		isFirstRow=true;
	} else 	if(isLastLine(targetObj)=="false"){   //当为最后一行时 插入的地方为,目标行后面		
		locatObj=targetObj;
		locatAt="after"
	} else {  //当为普及通行时 插入的地方为,目标行的下一行的下一行的前面				
		locatObj=$(targetObj).next().next()[0];
		locatAt="before";
	}
	
	//移动其它
	var result = modeNode(srcObj,targetObj,locatObj,locatAt,isFirstRow);	

	return result;
}

//是否是最后一行
function isLastLine(obj){
	try	{
		var Next2Sibling = $(obj).next().next();	
		if (Next2Sibling.length==0) return "false";
		return "true" ;		
	}catch (e){		
		return "false";		
	}	
}

function findNextBrother(nodeId){
	flag=0;
	
	return flag;
}

var srcRowIndex=-1;
var targetRowIndex=-1;
var srcRowNextObj;
function taskDragSort(){
	
	jQuery("input[name='seleBeforeTask']").each(function(k){
		var beforeTask=$(this);
		var beforeTaskIndex=0;
		var oldIndex=$(this).attr("oldIndex");
		if(beforeTask.val()!="0"){
			oldIndex=$("input[name='txtRowIndex']:eq("+(beforeTask.val()-1)+")").val();
		}else{
			oldIndex="0";
		}	
		$(this).attr("oldIndex",oldIndex);
		
	});	
	
	$("#tblTask").dragsort({
		itemSelector: "tr",
		dragSelector: ".td_drag", 
		dragBetween: true, 
		dragStart: function(){
			srcRowObj=$(this)[0];
			srcRowIndex=srcRowObj.rowIndex;
			srcRowNextObj=$(this).next();
		},
		dragEndBefore:function(){
			if($(this).hasClass("itemtr")||$(this).hasClass("Selected")||$(this).hasClass("Header")){
				targetRowObj=$(this)[0];
				targetRowIndex=targetRowObj.rowIndex;
				return true;
			}else{
				targetRowObj=null;
				return false;
			}	
					
		},
		dragEnd: function(){
			if(targetRowObj!=null){
				$(srcRowNextObj).before($(this));
			}
			//由上向下不允许拖动
			//if(targetRowObj&&targetRowIndex<srcRowIndex){
			if(targetRowObj){
				insertObj(srcRowObj,targetRowObj);
				resetBeforeTask();
				targetRowObj=null;
			}	
			//}	
		},
		placeHolderTemplate: "<tr><td style='width:15px'></td><td style='width:20px'></td><td style=''></td></tr>",
		scrollSpeed: 5
	});
}

function resetBeforeTask(){
	
	jQuery("input[name='seleBeforeTask']").each(function(k){
		var beforeTask=$(this);
		var beforeTaskIndex=0;
		var oldIndex=$(this).attr("oldIndex");
		jQuery("input[name='txtRowIndex']").each(function(i){
			if(oldIndex==jQuery(this).val()){
				//beforeTask.val(i+1);
				beforeTaskIndex=i+1;
				return false;
			}
		});
		beforeTask.val(beforeTaskIndex);
		if(beforeTaskIndex==0){
			beforeTask.next().html("");
		}
	});	
}	

//选择前置任务
function onSelectBeforeTask(spanname,inputename){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectTaskBrowser.jsp",document.getElementsByName("txtTaskName"));
	if (datas){
		if(datas.id!=""){
			$(spanname).html(datas.name);
			$(inputename).val(datas.id);
			var oldIndex=$("input[name='txtRowIndex']:eq("+(datas.id-1)+")").val(); 
			$(inputename).attr("oldIndex",oldIndex);
		}else{
			$(spanname).html("");
			$(inputename).val("");
		}
	}
	beforeTask_check(inputename);
}
