var ProjTaskUtil = function(strXml){
	if (strXml==null){
		this.tnXmlDoc = new TaskNodeXmlDoc();
	} else {
		this.tnXmlDoc = new TaskNodeXmlDoc(strXml);
	}
	
}

/**
* rowIndex:新的TaskNodeBean的行号
* level:所处的级别
*/
ProjTaskUtil.prototype.addNode = function(rowIndex){
	this.tnXmlDoc.addNode(rowIndex);
}


/**
*rowIndex 需要降级的行号
* 
*/
ProjTaskUtil.prototype.downLevel = function(rowIndex){
	var returnValue = this.tnXmlDoc.moveNodeDown(rowIndex);		
	switch (returnValue) {
	case 1 :
		this.modiAllTxtSize();
		break ;
	case 2 :
		/*if(readCookie("languageidweaver")==8){
			alert("The task have  already arrived at the lowwest!");
	    } 
	    else if(readCookie("languageidweaver")==9){ 
			alert("本任務已達到最低級!"); 
		}
	    else {
			alert("本任务已达到最低级!");
		}*/
		alert(SystemEnv.getHtmlNoteName(3426,readCookie("languageidweaver")));
		break ;
	case 3 :
		/*if(readCookie("languageidweaver")==8){
			alert("The last child task have  already arrived at the lowwest!");
	    }
	    else if(readCookie("languageidweaver")==9)
	    {
	    	alert("其最小子任務已達到最低級!");
	    } 
	    else {
			alert("其最小子任务已达到最低级!");
		}
		*/
		alert(SystemEnv.getHtmlNoteName(3427,readCookie("languageidweaver")));
		break ;
	case 4 :			
		break ;
	case 5 :		
		break ;
	} 		
}




/**
*rowIndex 需要升级的行号
*/
ProjTaskUtil.prototype.upLevel = function(rowIndex){

	var returnValue = this.tnXmlDoc.moveNodeUp(rowIndex);	
	switch (returnValue) {
	case 1 :
		this.modiAllTxtSize();
		break ;
	case 2 :
		/*if(readCookie("languageidweaver")==8){
			alert("The task have  already arrived at the highest!");
	    }
	    else if(readCookie("languageidweaver")==9) 
	    {
	    	alert("本任務已達到最高級!");
	    }
	    else {
			alert("本任务已达到最高级!");
		}*/
		alert(SystemEnv.getHtmlNoteName(3428,readCookie("languageidweaver")));
		break ;
	case 3 :			
		break ;	
	case 4:
		break;
	} 	
}

/*
*
*对页面降级用
*/
ProjTaskUtil.prototype.downLevelForPage = function(rowIndex) {
	try
	{
		var taskNameObj = document.getElementById("txtTaskName_"+rowIndex);  
		var taskNameDivObj = document.getElementById("taskNameDiv_"+rowIndex);   
		var newTaskNameSize = taskNameObj.size-3;
		taskNameObj.size= newTaskNameSize;
		
		taskNameDivObj.style.display="";		
		
	}
	catch (e){}
	
}


/*
*
*降所有子节点的级
*/
ProjTaskUtil.prototype.downChildrenLevel = function(rowIndex){
	var childRowIndexs = this.tnXmlDoc.getChildRowIndexs(rowIndex);
	for (var i=0;i<childRowIndexs.length;i++){
		var rowIndex = childRowIndexs[i];
		this.downLevelForPage(rowIndex);
		this.downChildrenLevel(rowIndex);
	}
}


/*
*
*对页面升级用
*/
ProjTaskUtil.prototype.upLevelForPage = function(rowIndex) {
	try
	{
		var taskNameObj = document.getElementById("txtTaskName_"+rowIndex);  
		var taskNameDivObj = document.getElementById("taskNameDiv_"+rowIndex);   
		var newTaskNameSize = taskNameObj.size+3;
		taskNameObj.size= newTaskNameSize;
		
		var nodeLevel = this.tnXmlDoc.getNodeLevel(rowIndex);		
		if (nodeLevel==0){
			taskNameDivObj.style.display="none";
		}
		
	}
	catch (e){}	
}

/*
*
*升所有子节点的级
*/
ProjTaskUtil.prototype.upChildrenLevel = function(rowIndex){
	var childRowIndexs = this.tnXmlDoc.getChildRowIndexs(rowIndex);
	for (var i=0;i<childRowIndexs.length;i++){
		var rowIndex = childRowIndexs[i];
		this.upLevelForPage(rowIndex);
		this.upChildrenLevel(rowIndex);
	}
}

/*
*
*对所有节点的移动
*/

ProjTaskUtil.prototype.moveNode = function(srcObj,targetObj,locatObj,locatAt,isFirstRow){		
	//修改逻辑结构	
	var returnValue = this.tnXmlDoc.moveNode(srcObj,targetObj,locatObj,locatAt,isFirstRow);	
	switch (returnValue) {		
	case 1 :
		//把源行插入到目标行的下一行后 形成新形行
		targetNextLine = targetObj.nextSibling; 
		srcNextLine = srcObj.nextSibling; 
		
		targetNextLine.insertAdjacentElement("afterEnd",srcObj);  
		newLine = targetNextLine.nextSibling; 

		//把源行下一行的下一行插入到  新形行的下一行
		newLine.insertAdjacentElement("afterEnd",srcNextLine); 

		this.moveChilds(srcObj);
		this.modiAllTxtSize();
		return true;
		break ;
	case 2 :
		/*if(readCookie("languageidweaver")==8){
			alert("The child task have  already arrived at the lowwest, can't move!");
	    }
	    else if(readCookie("languageidweaver")==9) 
	    {
	    	alert("其子任務將達到最低級,不能移動!");
	    }
	    else {
			alert("其子任务将达到最低级,不能移动!");
		}*/
		alert(SystemEnv.getHtmlNoteName(3429,readCookie("languageidweaver")));
		return false;
		break ;		
	case 3 :	
		return false;
		break ;			
	case 4 :
		/*if(readCookie("languageidweaver")==8){
			alert("you can't  move the task into his child!");
	    }
	    else if(readCookie("languageidweaver")==9) 
	    {
	    	alert("不能把上級任務移到下級任務!");
	    }
	    else {
			alert("不能把上级任务移到下级任务!");
		}*/
		alert(SystemEnv.getHtmlNoteName(3430,readCookie("languageidweaver")));
		return false;
		break ;	
	} 	
}


/*
*obj 为行的对象
*移动子结点
*/
ProjTaskUtil.prototype.moveChilds= function(obj){	
	var childRowIndexs = this.tnXmlDoc.getChildRowIndexs(obj.customIndex);

	for (var i=0;i<childRowIndexs.length;i++){
		var newSrcRowIndex = childRowIndexs[i];
	
		//本身
		newRowObj = document.getElementById("tr_"+newSrcRowIndex);
		//本身的下一个节点
		newNextRowObj = document.getElementById("tr_"+newSrcRowIndex).nextSibling;
	
	
			obj.nextSibling.insertAdjacentElement("afterEnd",newRowObj);
			obj.nextSibling.nextSibling.insertAdjacentElement("afterEnd",newNextRowObj);
		 
		this.moveChilds(newRowObj);
	}

}

/*
*
*
*/
ProjTaskUtil.prototype.moveChildrens = function(srcRowIndex,targetRowIndex) {
	var childRowIndexs = this.tnXmlDoc.getChildRowIndexs(srcRowIndex);
	for (var i=0;i<childRowIndexs.length;i++){
		var newSrcRowIndex = childRowIndexs[i];
		this.moveChildForPage(newSrcRowIndex,targetRowIndex);
		this.moveChildrens(newSrcRowIndex,newSrcRowIndex);
	}
}

ProjTaskUtil.prototype.moveChildForPage = function(srcRowIndex,targetRowIndex) {
	

	var srcRow = document.getElementById("tr_"+srcRowIndex); 
	var targetRow =  document.getElementById("tr_"+targetRowIndex); 

	var srcNodeDepth = this.tnXmlDoc.getNodeLevel(srcRowIndex);
	var srcNodeSize = 25 - srcNodeDepth*3;
	//物理移动
	var srcTaskNameObj = document.getElementById("txtTaskName_"+srcRowIndex);  
    var srcTaskNameDivObj = document.getElementById("taskNameDiv_"+srcRowIndex);

	srcTaskNameObj.size = srcNodeSize;
	//alert(srcNodeSize);
	if (srcNodeSize==25) srcTaskNameDivObj.style.display="none";	

	targetRow.insertAdjacentElement("afterEnd",srcRow);
}

/*
*
*
*/
ProjTaskUtil.prototype.getDeleteList = function(chkObjs) {
	var returnList = new ArrayList();
	for (var i=0;i<chkObjs.length;i++)	{
		var objValue = chkObjs[i].value;
		if (chkObjs[i].checked){
			if (!returnList.contains(objValue)) returnList.add(objValue);				
			returnList = this.getChildIds(objValue,returnList);

			//删除逻辑关系中的值
            this.tnXmlDoc.delNode(objValue);
		}		
	}
	return returnList;
}


ProjTaskUtil.prototype.getDeleteListForProjEdit = function(chkObjs,isDelXmlNode) {
	var returnList = new ArrayList();
	for (var i=0;i<chkObjs.length;i++)	{
		var objValue = chkObjs[i].value;
		if (chkObjs[i].checked){
			if (!returnList.contains(objValue)) returnList.add(objValue);				
			returnList = this.getChildIds(objValue,returnList);

			//删除逻辑关系中的值
			if (isDelXmlNode=="true")	this.tnXmlDoc.delNode(objValue);
		}		
	}
	return returnList;
}


/*
*
*
*/
ProjTaskUtil.prototype.getChildIds = function(objValue,returnList){
	     	var ObjChilds = this.tnXmlDoc.getChildRowIndexs(objValue);	

			for (var j=0;j<ObjChilds.length;j++){					
				if (!returnList.contains(ObjChilds[j]))  returnList.add(ObjChilds[j]);					 				
				this.getChildIds(ObjChilds[j],returnList);
			}


	return returnList;
	
}

/*
*修改所有任务框的size的长度以及显示与隐藏子任务图片
*
*/
ProjTaskUtil.prototype.modiAllTxtSize = function() {
	var xmlDoc = this.tnXmlDoc.getThisDoc();
	var root = xmlDoc.documentElement;
	var level = -1 ;     //当前所处的级数
	this.modiChildsSize(root,level);
			
}


/*
*修改子任务中所有任务框的size的长度以及显示与隐藏子任务图片
*
*/
ProjTaskUtil.prototype.modiChildsSize = function(objs,level) {
	try	{
		var childs = objs.childNodes;
		level++;
		for (var i=0;i<childs.length;i++){
			var child = childs[i];
			var childId = child.getAttribute("id");			
			var isHaveChilds = child.hasChildNodes(); 

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
			this.modiChildsSize(child,level);
		}
		
	}
	catch (e){
		//alert(e.description)
	}
	
}


ProjTaskUtil.prototype.showTRchilds = function(rowIndex,mode) {
	try{
		var objChildIndexs = this.tnXmlDoc.getChildRowIndexs(rowIndex);
		for (var i=0;i<objChildIndexs.length;i++) {
			var newIndex = objChildIndexs[i];
			var beforIndex = document.getElementById("index_"+newIndex).value;
			var trObj = document.getElementById("tr_"+newIndex);	
			var seleObj= document.getElementById("seleBeforeTask_"+beforIndex);
			var seleObjManager= document.getElementById("txtManager_"+newIndex);

			if (mode=="hidden"){		
				seleObjManager.style.display='none';
				seleObj.style.display='none';
				trObj.style.display='none';		
				trObj.nextSibling.style.display='none';
				
			} else {
				seleObjManager.style.display='';
				seleObj.style.display='';	
				trObj.style.display='';
				trObj.nextSibling.style.display='';				
				document.getElementById("img_"+newIndex).src='/images/project_rank_wev8.gif';
			}	
			this.showTRchilds(newIndex,mode);
		}
		
	} catch(e){alert(e.description)}
}


ProjTaskUtil.prototype.addRowNeedMove = function(srcIndex,targetObj) {
	if (targetObj==null) return false; 		
	if (targetObj.className!="Selected") return false; 
	var srcObj = document.getElementById("tr_"+srcIndex);
	var targetPrePreObj = targetObj;
	//alert("targetObj: "+targetObj.id+" id: "+targetPrePreObj.id+" trOwner: "+targetPrePreObj.trOwner);
	var targetTrIsManagerTr = targetPrePreObj.trOwner=="manager";	
	//alert(targetTrIsManagerTr)

	var result = this.tnXmlDoc.addRowNeedMove(srcIndex,targetObj.customIndex,targetTrIsManagerTr)=="true";	
	if (result){		
		var nextSrcObj = srcObj.nextSibling;		

		targetObj.nextSibling.insertAdjacentElement("afterEnd",srcObj);
		targetObj.nextSibling.nextSibling.insertAdjacentElement("afterEnd",nextSrcObj);		
	}	
	this.modiAllTxtSize()
}

/*
*
*
*/


ProjTaskUtil.prototype.getXmlDocStr = function() {
	return this.tnXmlDoc.toString(); 
}



