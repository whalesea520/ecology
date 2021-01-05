//FIXTREEHEIGHT=450;
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.parent.getParentWindow(parent);
	dialog = parent.parent.parent.getDialog(parent);
}catch(e){}
function quickQry(qname){
}
jQuery(document).ready(function(){
	rightMenu.style.visibility='hidden';
	resizeDialog(document);
	onlyFnaWf_onclick();
});

var setting = {
	data: {
		simpleData: {
			enable: true
		}
	},
	callback: {
		onClick: fnaWfTree_onClick
	},
	check: {
		enable: true,
		chkStyle: "checkbox",
		chkboxType: {"Y":"","N":""}
	}
};
function fnaWfTree_onClick(event, treeId, treeNode, clickFlag) {
	parent.onSave1(treeNode.id, treeNode.fullShowName);
}
function fnaWfTree_onAsyncSuccess(event, treeId, treeNode, clickFlag) {
	var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
	var nodes = treeObj.getNodes();
	expandNodeAll(nodes, treeObj);
}
function expandNodeAll(nodes, treeObj){
	var nodesLen = nodes.length;
	for(var i=0;i<nodesLen;i++){
		try{
			var _node = nodes[i];
			var _checkStatus = _node.getCheckStatus();
			if(_checkStatus.checked || _checkStatus.half){
				treeObj.expandNode(_node, true, false, false);
				if(_node.children){
					expandNodeAll(_node.children, treeObj);
				}
			}
		}catch(ex1){}
	}
}
function filter(treeId, parentNode, childNodes) {
	if (!childNodes) return null;
	for (var i=0, l=childNodes.length; i<l; i++) {
		childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
	}
	return childNodes;
}
function onlyFnaWf_onclick(){
	jQuery.fn.zTree.init(jQuery("#fnaWfTree"), setting, _fnaWfTree_zNodes);
	fnaWfTree_onAsyncSuccess();
}

function onSave1(){
	var pkVal = "";
	var nameVal = "";
	var treeObj = jQuery.fn.zTree.getZTreeObj("fnaWfTree");
	var nodes = treeObj.getCheckedNodes(true);
	var nodesLen = nodes.length;
	for(var i=0;i<nodesLen;i++){
		var _node = nodes[i];
		if(i>0){
			pkVal+=",";
			nameVal+=",";
		}
		pkVal+=_node.id ;
		nameVal+=_node.name;
	}
	
	var returnjson = {"id":pkVal,"name":nameVal};
	if(dialog){
		try{dialog.callback(returnjson);}catch(e){}
		try{dialog.close(returnjson);}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
	  	window.parent.parent.close();
	}
}
function onClear() {
	var returnjson = {id:"",name:""};
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
	}
}
function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  		window.parent.parent.close();
	}
}
function onCancel(){
	try{
		var dialog = parent.getDialog(window);	
		dialog.close();
	}catch(ex1){}
	doClose();
}
function doClose(){
	try{
		var parentWin = parent.parent.getParentWindow(window);
		parentWin.closeDialog();
	}catch(ex1){}
}