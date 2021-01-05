var prjTaskObj;
function initPrjTaskObj(){
	 prjTaskObj=$.z4x($("textarea[name=task_xml]").val());
	 if(!prjTaskObj.rootTask.task){
		 prjTaskObj.rootTask.task=[];
	 }
	 modiAllTxtSize();
}


Array.prototype.remove=function(index){
	return this.splice(index,1);
	
};
function addNode(iRowIndex){
	
	if(prjTaskObj.rootTask.task){
		prjTaskObj.rootTask.task.push({$id:""+iRowIndex});
	}else{
		prjTaskObj.rootTask.task=[];
		prjTaskObj.rootTask.task.push({$id:""+iRowIndex});
	}
}
function getElmentById(curNode,id){
	if(curNode.task&&curNode.task.length>0){
		for(var i=0;i<curNode.task.length;i++){
			if(curNode.task[i].$id==id){
				return curNode.task[i];

			}else{
		      return  getElmentById(curNode.task[i],id);
            }
		}
	}
}

function removeNode(curNode,id){
	if(curNode.task&&curNode.task.length>0){
		for(var i=0;i<curNode.task.length;i++){
			if(curNode.task[i].$id==id){
				var d=curNode.task[i];
				curNode.task.splice(i,1);
				return d;
			}
			else{
				removeNode(curNode.task[i],id);
			}
		}
	}else{
		return;
	}
}

function moveNodeDown(curNode,id){
	if(curNode.task&&curNode.task.length>0){
		for(var i=0;i<curNode.task.length;i++){
			if(curNode.task[i].$id==id){
				if(i>0){
					var d=curNode.task[i];
					curNode.task.splice(i,1);
					if(curNode.task[i-1].task){
						curNode.task[i-1].task.push(d);
					}else{
						curNode.task[i-1].task=new Array();
						curNode.task[i-1].task.push(d);
					}
				}
				return 1;
			}
			else{
				moveNodeDown(curNode.task[i],id);
			}
		}
	}else{
		return;
	}
}
function moveNodeUp(curNode,id){
	
	if(curNode.task&&curNode.task.length>0){
		var length=curNode.task.length;
		for(var i=0;i<length;i++){
			if(curNode.task[i].$id==id){
				if(!curNode.$id){
					return 0;
				}
				var parentNode=getParent(prjTaskObj.rootTask, curNode.$id);
				//parentNode=getParent(prjTaskObj.rootTask,parentNode.$id);
				var d=curNode.task[i];
				curNode.task.splice(i,1);
				parentNode.task.push(d);
				return 1;
			}
			else{
				moveNodeUp(curNode.task[i],id);
			}
		}
	}
}
function getParent(curNode,id,result){
	if(curNode){
		if(curNode.task&&curNode.task.length>0){
			for(var i=0;i<curNode.task.length;i++){
				if(curNode.task[i].$id==id){
					return curNode;
				}else{
					return getParent(curNode.task[i],id);
				}
			}
		}else{
			return 0;
		}
	}else{
		return 0;
	}
}



var modiAllTxtSize = function() {
	var root = prjTaskObj.rootTask;
	var level = -1 ;     //当前所处的级数
	this.modiChildsSize(root,level);			
};
var modiChildsSize = function(objs,level) {
	try	{
		var childs = objs.task;
		
		level++;
		for (var i=0;i<childs.length;i++){
			var child = childs[i];
			var childId = child.$id;			
			var isHaveChilds = (child.task?child.task.length:0)>0; 

			if (isHaveChilds){
				document.getElementById("img_"+childId).style.visibility="visible" ;
			} else {
				document.getElementById("img_"+childId).style.visibility="hidden" ;
			}
			var oldSize = document.getElementById("txtTaskName_"+childId).size;
		
			var newSize = 24 - level*3					
			
			if (oldSize!=newSize) {
				document.getElementById("txtTaskName_"+childId).size = newSize; 	
			}
			if(isHaveChilds){
				this.modiChildsSize(child,level);
			}
		}
	}
	catch (e){
		alert(e.description);
		throw(e);
	}
};

function deleteRow(){
	 var message="";
	 /*if(readCookie("languageidweaver")==8){
		message="His children task will be delete,are you sure?"; 
	}
	else if(readCookie("languageidweaver")==9){ 
		message="其子任務也將被刪除,是否繼續?"; 
	}
	else {
		message="其子任务也将被删除,是否继续?";  
	}*/
	message = SystemEnv.getHtmlNoteName(85,readCookie("languageidweaver"));
  if(!confirm(message)) return  ;
  try {
      var taskItems = document.getElementsByName("chkTaskItem");
      
      var delList = getDeleteList(taskItems);
   
      for (var i= 0;i<delList.size();i++){
          var delItem = delList.get(i);           
          
			var delRowObj = document.getElementById("tr_"+delItem);
			if (delRowObj==lastSelectedTRObj) {
				lastSelectedTRObj=null ;					
			}
          var delRowIndex = delRowObj.rowIndex;
          var delNextRowIndex= document.getElementById("tr_"+delItem).nextSibling.rowIndex;
          var currIndex = document.getElementById("tr_"+delItem).rowIndex/2;

          tblTask.deleteRow(delNextRowIndex);
          tblTask.deleteRow(delRowIndex);
          
          //清空已删除的前置任务  by alan
          var seleBeforeTaskObjs = document.getElementsByName("seleBeforeTask");
          var tdobjs = document.getElementsByName('seleBeforeTask_TD');
          for (var j=0;j<seleBeforeTaskObjs.length;j++){
              if(seleBeforeTaskObjs[j].value==currIndex) {
              	seleBeforeTaskObjs[j].value = '';
               	tdobjs[j].getElementsByTagName('span')[0].innerHTML = '';
              }
              else if(seleBeforeTaskObjs[j].value>currIndex) {
              	seleBeforeTaskObjs[j].value = seleBeforeTaskObjs[j].value*1-1;
              }
          }               
      }
       document.getElementById("chkAllObj").checked = false ;
  } catch(ex){}
}

//删除及获取删除的行
var getDeleteList = function(chkObjs) {
	var returnList = new ArrayList();
	for (var i=0;i<chkObjs.length;i++)	{
		var objValue = chkObjs[i].value;
		if (chkObjs[i].checked){
			if (!returnList.contains(objValue)){ 
				returnList.add(objValue);
			}			
			returnList = getChildIds(objValue,returnList,prjTaskObj.rootTask);

			//删除逻辑关系中的值
            //this.tnXmlDoc.delNode(objValue);
            removeNode(prjTaskObj.rootTask,objValue);
		}		
	}
	return returnList;
};
var getChildIds = function(objValue,returnList,curNode){
	var curObj=getElmentById(curNode, objValue);
 	var ObjChilds =curObj?curObj.task:null ;	
 	if(ObjChilds&&ObjChilds.length>0){
		for (var j=0;j<ObjChilds.length;j++){					
			if (!returnList.contains(ObjChilds[j].$id)){
					returnList.add(ObjChilds[j].$id);	
			}				 				
			this.getChildIds(ObjChilds[j].$id,returnList,ObjChilds[j]);
		}
 	}
return returnList;

}
var showTRchilds = function(rowIndex,mode) {
	try{
		var objChildIndexs=new ArrayList();
		var objChildIndexs = getChildIds(rowIndex,objChildIndexs,prjTaskObj.rootTask)
		for (var i=0;i<objChildIndexs.size();i++) {
			var newIndex = objChildIndexs.get(i);
			var beforIndex = $("input[name=index_"+newIndex+"]").val();
			var trObj = $("#tr_"+newIndex);	
			var seleObj=$("#seleBeforeTask_"+beforIndex);
			var seleObjManager= $("#txtManager_"+newIndex);

			if (mode=="hidden"){		
				seleObjManager.hide();
				seleObj.hide();
				trObj.hide();		
				trObj.next().hide();
				
			} else {
				seleObjManager.show();
				seleObj.show();
				trObj.show();		
				trObj.next().show();		
				$("img_"+newIndex).attr("src",'/images/project_rank_wev8.gif');
			}	
			this.showTRchilds(newIndex,mode);
		}
		
	} catch(e){alert(e.description)}
}