var _FLOW = new TTopFlow("");
var _TOOLTYPE = "point";
var _CREATENUMBER = 1;
var _CREATESTEP = true;
var _CURRENTX = _CURRENTY = 0;
var _FOCUSTEDOBJ = null;
var _ZOOM = 1;
var _NODETYPE = "";
var _MOVEOBJ = null;
var _MOVETYPE = "";
var _LASTMOVETYPE ="";
var _DOLOG = [];
var _DOLOGINDEX = -1;
var _strPt1 = "";
var _strPt2 = "";
var _strSltPt = "";
var _strLine1 = "";
var _strLine2 = "";
var _strSltLine = "";
var _PointOrLine;
var isSelectPoint = 0;
var isSelectLine=0;
var _clkPy = 0;
var _clkPx = 0;
var ptMoveType = "";
var oOval = null;
var _logMoveType = "";
var _MOVELINEOBJ = null;
var _PointMoveID = '';
var _isOndblclick = false;
/*ADD By Hqf*/
var _SORTBASEPROC=null;
var lastPoints= new Array();
var count=0;
var selectedItem = new Array();
var _UIOBJ = null;
var _TYPE = 0;
var _LoadXml = false;
var _canSave = true;
function checkCanSave(){
	if(_canSave == true){
		_canSave = false;
		return true;
	}else{
		return false;
	}

}
function setCanSave(flagTmp){
	_canSave = flagTmp;
}
//选中流程图元素对象，显示选中效果 
function objFocusedOn(objId)
{	
	//清除原来选中的对象
	objFocusedOff();
	_FOCUSTEDOBJ = document.getElementById(objId);
	
	if(_FOCUSTEDOBJ != null) 
	{
		var x = (event.clientX + document.body.scrollLeft) / _ZOOM;
		var y = (event.clientY + document.body.scrollTop) / _ZOOM;

		_MOVEOBJ = document.getElementById(objId);
		_clkPx = x/4*3+"pt";
		_clkPy = y/4*3+"pt";
		
		if(_FOCUSTEDOBJ.tagName=="PolyLine")
		{	
			_FLOW.getStepByID(objId).setFocus();
			
			_MOVELINEOBJ = new TStep(_FLOW);
			_MOVELINEOBJ.clone(_FLOW.getStepByID(objId));
			_MOVEOBJ = _FLOW.getStepByID(objId);
			var strPt =_MOVEOBJ.Points;
			var aryPt = strPt.split(',');
			
			var nPt=aryPt.length-1;
			_strPt2 = "";
			_strPt1 = "";
			_strLine2 = "";
			_strLine1 = "";
			for(i=0;i<=nPt;i=i+2)
			{	var m = 0
				var n = 0
				if(aryPt[i].indexOf("pt")!=-1){
					m = aryPt[i].substr(0,aryPt[i].length-2)*4/3;
					n = aryPt[i+1].substr(0,aryPt[i+1].length-2)*4/3;
				}else{
					m = aryPt[i]*1
					n = aryPt[i+1]*1
				}
				var sqrta = Math.sqrt((x-m)*(x-m)+(y-n)*(y-n));
				
				if(isSelectPoint==0&&sqrta<=10)
				{ 
					
						_PointOrLine = 0;
						isSelectPoint=1;
						
						_MOVETYPE="line_m";			  		
						_strSltPt = aryPt[i]+',' +aryPt[i+1];
						_clkPx = aryPt[i];
						_clkPy = aryPt[i+1];
						if (i==0)ptMoveType="from";
						if (i==nPt-1)ptMoveType="to";
					
				}
				else
				{
					if(isSelectPoint==1)
						_strPt2 = _strPt2+','+aryPt[i]+','+aryPt[i+1];
					else
						_strPt1 = _strPt1+','+aryPt[i]+',' +aryPt[i+1];
				}
				
				if(i<=nPt-3)
				{
					var r = 0
					var s = 0
					if(aryPt[i+2].indexOf("pt")!=-1){
						r = aryPt[i+2].substr(0,aryPt[i+2].length-2)*4/3;
						s = aryPt[i+3].substr(0,aryPt[i+3].length-2)*4/3;
					}else{
						r = aryPt[i+2]*1
						s = aryPt[i+3]*1
					}
					if((Math.abs(x*(n-s)+y*(r-m)+(m*s-n*r))/Math.sqrt((n-s)*(n-s)+(r-m)*(r-m))<=5)&&(isSelectLine==0)&&sqrta>10&&isSelectPoint==0)
					{
						
							_PointOrLine = 1;
		
							_MOVETYPE="line_m";
							
							isSelectLine = 1;
								
							_strSltLine = aryPt[i]+','+aryPt[i+1]+','+aryPt[i+2]+','+aryPt[i+3];
							_clkPx = x/4*3+"pt";
							_clkPy = y/4*3+"pt";
						
						
					}
					else
					{
						if(isSelectLine==1)
						{
							if (i <= nPt-3)
							{
								_strLine2 = _strLine2+','+aryPt[i+2]+','+aryPt[i+3];
							}
						}
						else
						{
							_strLine1 = _strLine1 + "," + aryPt[i]+',' +aryPt[i+1];
						}
					}
					
				}
				
			}
			
			if(_strPt1!= '')
			   _strPt1 = _strPt1.substr(1)+',';
			if(_strLine1!='')
			   _strLine1 = _strLine1.substr(1)+",";
		}else{
			
			 if(!_FLOW.getProcByID(objId).isSelect){
			 	
			 	clearSelect()
			 }
			 _FLOW.getProcByID(objId).setSelected();
			 if(event.ctrlKey){
			 	_SORTBASEPROC = _FLOW.getProcByID(objId);
			 }else{
			 	_SORTBASEPROC = null;
			 }
		}
	}  
	stuffProp();
}
function createOval(x,y)
{
	oOval = document.createElement("v:rect");
	oOval.style.position = "absolute";
	oOval.style.width = "4px";
	oOval.style.height="4px"
	oOval.style.left = x;
	oOval.style.top = y;
	oOval.fillcolor = "red";
	oOval.strokecolor = "red";
	//oOval.a
	
	document.body.appendChild(oOval);
}
//将HTML对象转换成PolyLine实例
function toPolyLineObj(objTemp)
{
	var objLine = _FLOW.getStepByID(objTemp.id);
	return objLine;
}
//更新数据表
function updateFlow(htmlObj){

}

//放弃选择流程图元素对象，显示未选中效果
function objFocusedOff(){
  if(_FOCUSTEDOBJ != null) 
  {
  	 if(_FOCUSTEDOBJ.tagName=="PolyLine"){
   	 	_FLOW.getStepByID(_FOCUSTEDOBJ.id).lostFocus();
  	 }else{
 	 	_FLOW.getProcByID(_FOCUSTEDOBJ.id).lostFocus();
  	 }
  }
  _FOCUSTEDOBJ = null;
  isSelectPoint = 0;
  isSelectLine = 0;
  ptMoveType = "";
  oOval = null;
  return;
}

//删除流程图元素对象
function deleteObj(ObjId){
  var obj = document.getElementById(ObjId);
  if(obj == null) return false;
  if(obj.typ != "Proc" && obj.typ != "Step") return false;
  
  if(confirm(wmsg.wfdesign.deleteConfrim)){
    objFocusedOff();
    if(obj.typ == "Proc"){
    	
      var Proc = _FLOW.getProcByID(ObjId);
      var delObj ={Procs:[],Steps:[]};
      delObj.Procs[ delObj.Procs.length]=Proc;
      for (i = _FLOW.Steps.length - 1; i >= 0; i--){
		if (_FLOW.Steps[i].FromProc == ObjId || _FLOW.Steps[i].ToProc == ObjId){
			delObj.Steps[delObj.Steps.length]=_FLOW.Steps[i]
		}
	  }
	  
      _FLOW.deleteProcByID(ObjId);
       if(Proc.ProcType=='create'){
       		parent.setNodeEnable(Proc.ProcType,true);
       }
      deleteSelect(Proc);
      
      pushLog("delproc", delObj);
    }
    else{
      var Step = _FLOW.getStepByID(ObjId);
      var oldObj = new TStep(_FLOW);
      oldObj.clone(Step)
      _FLOW.deleteStepByID(ObjId);
      pushLog("delstep", oldObj);
    }
    _FLOW.Modified = true;

    //DrawAll();
  }
}

function deleteObjs(){
	if(confirm(wmsg.wfdesign.deleteConfrim)){
		var delObj ={Procs:[],Steps:[]};
		for(var i=0;i<selectedItem.length;i++){
			
		  var ObjId = selectedItem[i].ID
		  var obj = document.getElementById(ObjId);
	
		  if(obj == null) return false;
		  if(obj.typ != "Proc" && obj.typ != "Step") return false;
		  objFocusedOff();
		  if(obj.typ == "Proc"){
		    var Proc = _FLOW.getProcByID(ObjId);
		    delObj.Procs[delObj.Procs.length]= Proc;
		    for (i = _FLOW.Steps.length - 1; i >= 0; i--){
				if (_FLOW.Steps[i].FromProc == ObjId || _FLOW.Steps[i].ToProc == ObjId){
					delObj.Steps[delObj.Steps.length]=_FLOW.Steps[i]
				}
	 		}
		    _FLOW.deleteProcByID(ObjId);
		    if(Proc.ProcType=='create'){
		    	parent.setNodeEnable(Proc.ProcType,true);
		    }
		    deleteSelect(Proc);
		    //i--;
		  } 
		}
		_FLOW.Modified = true;
		pushLog("delproc", delObj);
	}
	
    //DrawAll();
}
//更改[任务]的ID值，将原路径重新指定到新ID
function changeProcID(OldID, NewID){
  var Step;
  for(var i = 0; i< _FLOW.Steps.length; i++){
    Step = _FLOW.Steps[i];
    if(Step.FromProc == OldID) Step.FromProc = NewID;
    if(Step.ToProc == OldID) Step.ToProc = NewID;
  }
}

function saveStepsToProc(obj)
{
	for(var i = 0; i < _FLOW.Steps.length; i++){
		var oStep = _FLOW.Steps[i];
		if(oStep.FromProc == obj.id || oStep.ToProc == obj.id){
			updateFlow(document.getElementById(oStep.ID));					
		}
	}
}

//更改Proc的位置
function changeProcPos(obj){

  if(selectedItem.length>0){
  	for(var i = 0; i < _FLOW.Steps.length; i++){
	      Step = _FLOW.Steps[i];
	      objStepHTML = document.getElementById(Step.ID);
	      if(Step.ShapeType == "Line"){
	        Step.getPath();
	        objStepHTML.from = Step.FromPoint;
	        objStepHTML.to = Step.ToPoint;
	      }
	      else if(Step.ShapeType == "PolyLine"){
			var strPt="";
			var arrPt = Step.Points.split(",");
			var objWidth ;
			var objHeight;
			var objX ;
			var objY ;
			var strMoveType = _MOVETYPE;
			var pointObj = Step.PointObjs
			if (_MOVETYPE=="")strMoveType = _logMoveType;
		
			switch(strMoveType){
				case "proc_sm":
				case "proc_m":
				case "proc_e":
				case "proc_n":
				case "proc_snw":
				case "proc_nw":
					var fromProc = document.all(Step.FromProc)	
					objX = fromProc.style.left;
					objY = fromProc.style.top;
					objX = objX.substr(0,objX.length-2)*1;
					objY = objY.substr(0,objY.length-2)*1;
					objWidth = fromProc.style.width;
					objHeight = fromProc.style.height;	
					objWidth = objWidth.substr(0,objWidth.length-2);
					objHeight = objHeight.substr(0,objHeight.length-2);
					strPt = (objX+objWidth*Step.fromRelX)*3/4+"pt,"+(objY+objHeight*Step.fromRelY)*3/4+"pt,"
					var _X = 0;
					var _Y = 0;
					if(arrPt[0].indexOf('pt') ==-1){
						 _X = ((objX+objWidth*Step.fromRelX)-parseInt(arrPt[0]))*3/4;
						 _Y = ((objY+objHeight*Step.fromRelY)-parseInt(arrPt[1]))*3/4;
					}else{
						_X = (objX+objWidth*Step.fromRelX)*3/4-parseInt(arrPt[0])
						_Y = (objY+objHeight*Step.fromRelY)*3/4-parseInt(arrPt[1])
					}

					for (var j=2; j<arrPt.length-2; j++)
					{
						if(arrPt[j].indexOf('pt')!=-1){
							if(j%2==0){
								
								strPt += parseInt(arrPt[j])+_X+"pt,"
							}else{
								strPt += parseInt(arrPt[j])+_Y+"pt,"
							}
						}else{
							if(j%2==0){
								
								strPt += parseInt(arrPt[j]*3/4)+1+_X+"pt,"
							}else{
								strPt += parseInt(arrPt[j]*3/4)+1+_Y+"pt,"
							}
						
							/*if(j%2==0){
								
								strPt += parseInt(arrPt[j])+_X+"pt,"
							}else{
								strPt += parseInt(arrPt[j])+_Y+"pt,"
							}*/
						}
					}
					
					for (var j=0; j<pointObj.length; j++)
					{
						
						if(pointObj[j].X.indexOf('pt')!=-1){
							
							pointObj[j].X= parseInt(pointObj[j].X)+_X+"pt"
							pointObj[j].Y = parseInt(pointObj[j].Y)+_Y+"pt";
						}else{
							pointObj[j].X= parseInt(pointObj[j].X*3/4)+_X+"pt"
							pointObj[j].Y = parseInt(pointObj[j].Y*3/4)+_Y+"pt";
						}
						
					}

					var toProc = document.all(Step.ToProc)
					objX = toProc.style.left;
					objY = toProc.style.top;
					objX = objX.substr(0,objX.length-2)*1;
					objY = objY.substr(0,objY.length-2)*1;
					objWidth = toProc.style.width;
					objHeight = toProc.style.height;	
					objWidth = objWidth.substr(0,objWidth.length-2);
					objHeight = objHeight.substr(0,objHeight.length-2);
					
					strPt = strPt + (objX+objWidth*Step.toRelX)*3/4+"pt,"+(objY+objHeight*Step.toRelY)*3/4+"pt"
					Step.Points = strPt;
					//Step.getRelNumber();
					//var points = strPt.split(',');
					//Step.TText.X = points[0];
					//Step.TText.Y = points[1];
					Step.setTTextPoint(Step.TText);
					break;
				default :
			}
			
			objStepHTML.outerHTML = Step.toString();
			Step.BasePoints = Step.Points;
	      }

	}
  }else{
  	
  	for(var i = 0; i < _FLOW.Steps.length; i++){
    Step = _FLOW.Steps[i];
    if(Step.FromProc == obj.id || Step.ToProc == obj.id){
      objStepHTML = document.getElementById(Step.ID);
      if(Step.ShapeType == "Line"){
        Step.getPath();
        objStepHTML.from = Step.FromPoint;
        objStepHTML.to = Step.ToPoint;
      }
      else if(Step.ShapeType == "PolyLine"){
		var strPt="";
		var arrPt = Step.Points.split(",");
		var objWidth = obj.style.width;
		var objHeight = obj.style.height;
		var objX = obj.style.left;
		var objY = obj.style.top;
		var strMoveType = _MOVETYPE;
		var pointObj = Step.PointObjs;
		objWidth = objWidth.substr(0,objWidth.length-2);
		objHeight = objHeight.substr(0,objHeight.length-2);
		objX = objX.substr(0,objX.length-2)*1;
		objY = objY.substr(0,objY.length-2)*1;
		
		if (_MOVETYPE=="")strMoveType = _logMoveType;
		switch(strMoveType){
			case "proc_sm":
			case "proc_m":
			case "proc_e":
			case "proc_n":
			case "proc_snw":
			case "proc_nw":	
				if(Step.FromProc ==Step.ToProc){
					var _X = 0;
					var _Y = 0;
					if(arrPt[0].indexOf('pt') ==-1){
						 _X = ((objX+objWidth*Step.fromRelX)-parseInt(arrPt[0]))*3/4;
						 _Y = ((objY+objHeight*Step.fromRelY)-parseInt(arrPt[1]))*3/4;
					}else{
						_X = (objX+objWidth*Step.fromRelX)*3/4-parseInt(arrPt[0])
						_Y = (objY+objHeight*Step.fromRelY)*3/4-parseInt(arrPt[1])
					}
					for (var j=0; j<arrPt.length; j++)
					{
						if(arrPt[j].indexOf('pt')!=-1){
							if(j%2==0){
								
								strPt += parseInt(arrPt[j])+_X+"pt,"
							}else{
								strPt += parseInt(arrPt[j])+_Y+"pt,"
							}
						}else{
							if(j%2==0){
								
								strPt += parseInt(arrPt[j]*3/4)+0+_X+"pt,"
							}else{
								strPt += parseInt(arrPt[j]*3/4)+0+_Y+"pt,"
							}
						
							/*if(j%2==0){
								
								strPt += parseInt(arrPt[j])+_X+"pt,"
							}else{
								strPt += parseInt(arrPt[j])+_Y+"pt,"
							}*/
						}
					}
					
					for (var j=0; j<pointObj.length; j++)
					{
						
						if(pointObj[j].X.indexOf('pt')!=-1){
							
							pointObj[j].X= parseInt(pointObj[j].X)+_X+"pt"
							pointObj[j].Y = parseInt(pointObj[j].Y)+_Y+"pt";
						}else{
							pointObj[j].X= parseInt(pointObj[j].X*3/4)+_X+"pt"
							pointObj[j].Y = parseInt(pointObj[j].Y*3/4)+_Y+"pt";
						}
						
					}
					
					strPt = strPt.substring(0,strPt.length-1);
				}else{
				
					if (Step.FromProc == obj.id)
					{	
						
						strPt = (objX+objWidth*Step.fromRelX)*3/4+"pt,"+(objY+objHeight*Step.fromRelY)*3/4+"pt"
						for (var j=2; j<arrPt.length; j++)
						{
							strPt = strPt + "," + arrPt[j]
						}
					}
					if (Step.ToProc == obj.id)
					{
						
						for (var j=0; j<arrPt.length-2; j++)
						{
							strPt = strPt + arrPt[j] + ","
							
						}
						
						strPt = strPt + (objX+objWidth*Step.toRelX)*3/4+"pt,"+(objY+objHeight*Step.toRelY)*3/4+"pt"
					}
				
				
				}
				Step.Points = strPt;
				//Step.getRelNumber();
				/*var points = strPt.split(',')
				Step.TText.X = points[0];
				Step.TText.Y = points[1];*/
				Step.setTTextPoint(Step.TText);
				break;
			default :
		}
		objStepHTML.outerHTML = Step.toString();
		
		Step.BasePoints = Step.Points;
		
      }
    }
  }
  }
  _logMoveType = "";
 
}

//修改[路径]
function editStep(objId){
 
  if(type!=="edit"){
  	return;
  }
  var oldobj = new TStep(_FLOW), newobj = new TStep(_FLOW);
  var step = _FLOW.getStepByID(objId);
  
  oldobj.clone(step);

  var x = (event.clientX + document.body.scrollLeft) / _ZOOM;
  var y = (event.clientY + document.body.scrollTop) / _ZOOM;
  var strPt = step.Points;
  var aryPt = strPt.split(',');
  
  var nPt = aryPt.length-1;
  isSelectPoint = 0;
      _strPt2 = "";
      _strPt1 = "";
	  for(i=0;i<=nPt;i=i+2){
	  	var m =0
	  	var n =0
	  	if(aryPt[i].indexOf("pt")!=-1){
			m = aryPt[i].substr(0,aryPt[i].length-2)*1.333;
	    	n = aryPt[i+1].substr(0,aryPt[i+1].length-2)*1.333;
	  	}else{
	  		m = aryPt[i]*1
	    	n = aryPt[i+1]*1
	  	}
	  	var sqrta = Math.sqrt((x-m)*(x-m)+(y-n)*(y-n));
			if(isSelectPoint==0&&sqrta<=10){
			 
			  _strSltPt = aryPt[i]+',' +aryPt[i+1];
			}
			else if(isSelectPoint==1){
				    _strPt2 = _strPt2+','+aryPt[i]+','+aryPt[i+1];
			}
			     else{
				    _strPt1 = _strPt1+','+aryPt[i]+',' +aryPt[i+1];
			}
      }    
      if(_strPt1!= ''){
	     _strPt1 = _strPt1.substr(1);
      }

  step.Points = _strPt1+_strPt2;
  step.getRelNumber();
  step.setTTextPoint(step.TText);
  updateFlow(document.getElementById(step.ID));
  document.getElementById(step.ID).points.value = step.Points;
  pushLog("editstep", {"_old":oldobj,"_new":step});
  //DrawVML();
  stuffProp();
  _FLOW.Modified = true;
}


function stuffProp(){
	if(_FOCUSTEDOBJ != null) {
	  	var obj = _FOCUSTEDOBJ.typ == "Proc"?_FLOW.getProcByID(_FOCUSTEDOBJ.id):_FLOW.getStepByID(_FOCUSTEDOBJ.id);
	  	if(type=='edit'){
	  		var p = window.parent.property;
	    	p.setSource(obj.getPropertySource());  
	  	}
	}
}

//CACHE
function emptyLog(){
  _DOLOG = [];
  _DOLOGINDEX = -1;
}

function pushLog(act, obj){
  var newLog = _DOLOG.slice(0, _DOLOGINDEX + 1);
  _DOLOG = newLog;
  _DOLOGINDEX = _DOLOG.push({"act" : act, "val": obj}) - 1;
}

function getLog(){
  return _DOLOG[_DOLOGINDEX];
}

function undoLog(){
  if(_DOLOGINDEX == -1){
    parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.noUndo);
    return;
  }
  
  if(doLog("undo")) _DOLOGINDEX --;
}

function redoLog(){
  if(_DOLOGINDEX == _DOLOG.length - 1){
    parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.noRedo);
    return;
  }
  _DOLOGINDEX ++;
  doLog("redo");
}

function doLog(act){
  var log = getLog();
/*TODO 是否要进行提醒
if(!confirm("确定要*"+(act == "undo"?"撤消":"恢复")+"*最后一次操作[" + log.act + "]吗？")){
    if(act == "redo") _DOLOGINDEX --;
    return false;
  }*/
  switch(log.act){
    case "addproc":
      if(act == "undo"){
      	for(var i=0;i<log.val.Procs.length;i++){
      		_FLOW.deleteProcByID(log.val.Procs[i].ID);
      	}
      		
      }else{
      	for(var i=0;i<log.val.Procs.length;i++){
      		
     		_FLOW.addProc(log.val.Procs[i]);
      	}
 
      	for(var i=0;i<log.val.Steps.length;i++){
      		_FLOW.addStep(log.val.Steps[i]);
      	}
      	DrawAll();
      }
      
      break;
    case "addstep":
     
      act == "undo"?_FLOW.deleteStepByID(log.val.ID):_FLOW.addStep(log.val);
      
      break;
    case "delproc":
    
      if(act == "undo"){
      	var arrProc = log.val.Procs;
      	for(var i=0;i<arrProc.length;i++){
      		_FLOW.addProc(arrProc[i])	
      	}
      	var arrStep = log.val.Steps;
      	for(var i=0;i<arrStep.length;i++){
      		_FLOW.addStep(arrStep[i])	
      	}
      }else{
      	var arrProc = log.val.Procs;
      	for(var i=0;i<arrProc.length;i++){
      		_FLOW.deleteProcByID(arrProc[i].ID)	
      	}	
      }
      DrawAll();
      break;
    case "delstep":
      
      act == "undo"?_FLOW.addStep(log.val):_FLOW.deleteStepByID(log.val.ID);
      DrawAll();
      break;
    case "editproc":
      if(act == "undo"){
        var Proc = _FLOW.getProcByID(log.val._new.ID);
        Proc.clone(log.val._old);
        if(log.val._new.ID != log.val._old.ID) changeProcID(log.val._new.ID, log.val._old.ID);
      }
      else{
        var Proc = _FLOW.getProcByID(log.val._old.ID);
        Proc.clone(log.val._new);
        if(log.val._new.ID != log.val._old.ID) changeProcID(log.val._old.ID, log.val._new.ID);
      }
      //DrawAll();
      objFocusedOn(act == "undo"?log.val._old.ID:log.val._new.ID);
      break;
    case "editstep":
    
      if(act == "undo"){
        var Step = _FLOW.getStepByID(log.val._new.ID);
        for(var i =0;i<Step.PointObjs.length;i++){
        	if(document.getElementById(Step.PointObjs[i].ID)!=null){
        		document.getElementById(Step.PointObjs[i].ID).outerHTML = '';
        	}
        }
        
        Step.clone(log.val._old);
      }
      else{
        var Step = _FLOW.getStepByID(log.val._old.ID);
        for(var i =0;i<Step.PointObjs.length;i++){
        	if(document.getElementById(Step.PointObjs[i].ID)!=null){
        		document.getElementById(Step.PointObjs[i].ID).outerHTML = '';
        	}
        }
        Step.clone(log.val._new);
        
      }
      //DrawVML();
      
      document.getElementById(Step.ID).outerHTML = Step.toString();
      break;
    case "moveproc":
      for(var i=0; i< log.val._old.length;i++){
	      var obj = _FLOW.getProcByID(log.val.objID[i]);
	      if(act == "undo"){
	        obj.setPropValue("X", log.val._old[i].X);
	        obj.setPropValue("Y", log.val._old[i].Y);
	        obj.setPropValue("Width", log.val._old[i].Width);
	        obj.setPropValue("Height", log.val._old[i].Height);
	      }
	      else{
	        obj.setPropValue("X", log.val._new[i].X);
	        obj.setPropValue("Y", log.val._new[i].Y);
	        obj.setPropValue("Width", log.val._new[i].Width);
	        obj.setPropValue("Height", log.val._new[i].Height);
	      }
		  _logMoveType = log.val.moveType;
		  
	      changeProcPos(document.getElementById(obj.ID));
	      
      }
      break;
    case "editprop":
      var CurrentProp = (act == "undo"?log.val._old:log.val._new);
      log.val.obj[log.val.prop] = CurrentProp;
      switch(log.val.prop){
        case "ID":
          if(log.val.obj.ObjType == "Proc") act == "undo"?changeProcID(log.val._new, log.val._old):changeProcID(log.val._old, log.val._new);
          DrawVML();
          objFocusedOn(log.val.obj.ID);
          break;
        case "Text":
          DrawAll();
          objFocusedOn(log.val.obj.ID);
          break;
        case "ShapeType":
          DrawVML();
          objFocusedOn(log.val.obj.ID);
          break;
        case "TextWeight":
          document.all(log.val.obj.ID + "Text").style.fontSize = CurrentProp;
          break;
        case "zIndex":
          log.val.obj.InnerObject.style.zIndex = CurrentProp;
          break;
        case "StrokeWeight":
          log.val.obj.InnerObject.strokeweight = CurrentProp;
          break;
        case "X":
          log.val.obj.InnerObject.style.left = CurrentProp;
          changeProcPos(log.val.obj.InnerObject);
          break;
        case "Y":
          log.val.obj.InnerObject.style.top = CurrentProp;
          changeProcPos(log.val.obj.InnerObject);
          break;
        case "Width":
          log.val.obj.InnerObject.style.width = CurrentProp;
          changeProcPos(log.val.obj.InnerObject);
          break;
        case "Height":
          log.val.obj.InnerObject.style.height = CurrentProp;
          changeProcPos(log.val.obj.InnerObject);
          break;
        case "Cond":
          document.all(log.val.obj.ID + "Text").innerHTML = CurrentProp;
          break;
        case "StartArrow":
          document.all(log.val.obj.ID + "Arrow").startarrow = CurrentProp;
          break;
        case "EndArrow":
          document.all(log.val.obj.ID + "Arrow").endarrow = CurrentProp;
          break;
        case "FromProc":
        case "ToProc":
          if(log.val.obj.ShapeType == "Line"){
            log.val.obj.getPath();
            log.val.obj.InnerObject.from = log.val.obj.FromPoint;
            log.val.obj.InnerObject.to = log.val.obj.ToPoint;
          }
          else if(log.val.ShapeType == "PolyLine"){
            log.val.obj.InnerObject.points.value = log.val.obj.reGetPath();
          }
          break;
      }      
      break;
  }
  
  
  stuffProp();
  _FLOW.setAllStepInfo();
  return true;
}

function doProcMouseDown(obj, x, y){
  //判断是否是画线
  if(_TOOLTYPE == "line" || _TOOLTYPE == "polyline"){
    _CURRENTX = x;
    _CURRENTY = y;
    _MOVEOBJ = document.all("_lineui");
    //_MOVEOBJ.from = _CURRENTX + "," + _CURRENTY;
	_MOVEOBJ.from = _CURRENTX + "," + (_CURRENTY - 0);//原代码
    _MOVEOBJ.to = _MOVEOBJ.from;
    _MOVEOBJ.style.display = "block";
    _MOVETYPE = _TOOLTYPE;
  }
  else{
    var rightSide = (parseInt(obj.style.left) + parseInt(obj.style.width) -x <= 2);
    var bottomSide = (parseInt(obj.style.top) + parseInt(obj.style.height) - y <= 2);
    if(rightSide && bottomSide)
      	//_MOVETYPE = "proc_nw";
    	_MOVETYPE = "";
    else if(rightSide)
     	//_MOVETYPE = "proc_e";
    	_MOVETYPE = "";
    else if(bottomSide)
      //_MOVETYPE = "proc_n";
    	_MOVETYPE = "";
    else{
      _MOVETYPE = "proc_m";
      _CURRENTX = x - obj.offsetLeft;
      _CURRENTY = y - obj.offsetTop;
    }
    _MOVEOBJ = obj;
  }
  window.event.cancelBubble = true;
}

// 这里的x,y是换算过的值(/ZOOM)
function fireProcMouseDown(x, y){
  var curProc = null;
  for(var i = 0; i< _FLOW.Procs.length; i ++){
    Proc = _FLOW.Procs[i];
    if (x >= parseInt(Proc.X) && x <= (parseInt(Proc.X) + parseInt(Proc.Width))
        && y >= parseInt(Proc.Y) && y <= (parseInt(Proc.Y) + parseInt(Proc.Height))) {
	  if (curProc == null || Proc.zIndex >= curProc.zIndex) // 重叠的情况下取上面那个
	    curProc = Proc;
    }
  }

  if (curProc != null) {
    obj = document.getElementById(curProc.ID);
    objFocusedOn(obj.id);
    doProcMouseDown(obj, x, y);
    return true;
  }
  return false;
}

// 这里的x,y是换算过的值(/ZOOM)
function doProcMouseMove(obj, x, y){
  if(_TOOLTYPE == "line" || _TOOLTYPE == "polyline")
   
  document.all.Canvas.style.cursor = "crosshair";
  else{
    
   /* var rightSide = (parseInt(obj.style.left) + parseInt(obj.style.width) -x <= 2);
    var bottomSide = (parseInt(obj.style.top) + parseInt(obj.style.height) - y <= 2);
	
    if(rightSide && bottomSide)
      //document.all.Canvas.style.cursor = "NW-resize";
    	document.all.Canvas.style.cursor = "hand";
    else if(rightSide)
      //document.all.Canvas.style.cursor = "E-resize";
    	document.all.Canvas.style.cursor = "hand";
    else if(bottomSide)
      //document.all.Canvas.style.cursor = "N-resize";
    	document.all.Canvas.style.cursor = "hand";
    else
      document.all.Canvas.style.cursor = "hand";
      */
  	document.all.Canvas.style.cursor = "hand";
  }
}

// 这里的x,y是换算过的值(/ZOOM)
function fireProcMouseMove(x, y){
  if (document.all.Canvas == null) return;
  for(var i = 0; i< _FLOW.Procs.length; i ++){
    Proc = _FLOW.Procs[i];
	  obj = document.getElementById(Proc.ID);
    if (x >= parseInt(Proc.X) && x <= (parseInt(Proc.X) + parseInt(Proc.Width))
      && y >= parseInt(Proc.Y) && y <= (parseInt(Proc.Y) + parseInt(Proc.Height))) {
      doProcMouseMove(obj, x, y);	
	  return true;
    }
  }
  if (i >= _FLOW.Procs.length){
    document.all.Canvas.style.cursor = (_TOOLTYPE == "point"?"default":"default");
  }
  return false;
}

function doDocMouseDown(){
  
  var x = (event.clientX + document.body.scrollLeft) / _ZOOM;
  var y = (event.clientY + document.body.scrollTop) / _ZOOM;
  
  var oEvt = event.srcElement;
  
  //if (oEvt.id == "tableContainer" || oEvt.id == "") return; 	// 过滤数据视图/对象视图上的事件
  if (oEvt.typ=="Step")
  {
	  document.all.Canvas.style.cursor = "default";
	  return;
  }
  if (fireProcMouseDown(x, y)) return;		// 过滤图元上的事件

  switch(_TOOLTYPE){
    case "rect":
    case "roundrect":
    case "diamond":
    case "oval":
	case "fillrect":
     
      var obj = document.all("_" + _TOOLTYPE + "ui");
      
      _CURRENTX = x;
      _CURRENTY = y;
      obj.style.left = _CURRENTX;
      obj.style.top = _CURRENTY;
      obj.style.width  = 0;
      obj.style.height = 0;
      obj.style.display = "block"
      _MOVETYPE = _TOOLTYPE;
      break;
    case "selectbox":
      if(oEvt.tagName.toLowerCase() == "polyline") return;
      if(oEvt.tagName.toLowerCase() == "rect") return;
      clearSelect();
      
      var obj = document.all("_" + _TOOLTYPE + "ui");
      
      _CURRENTX = x;
      _CURRENTY = y;
      obj.style.left = _CURRENTX;
      obj.style.top = _CURRENTY;
      obj.style.width  = 0;
      obj.style.height = 0;
      obj.style.display = "block"
      _MOVETYPE = _TOOLTYPE;
      break;
    	 
  }
  
}

function doDocMouseMove(){

var x = (event.clientX + document.body.scrollLeft) / _ZOOM;
var y = (event.clientY + document.body.scrollTop) / _ZOOM;

var m,n,aryPt,_movePt,sqrta,_moveLine
if (_PointMoveID != ''&& oOval==null) {

	_clkPx = _clkPx + '';
	if (_clkPx.indexOf('pt') != -1) {
		m = _clkPx.substr(0, _clkPx.length - 2) * 4 / 3;
		n = _clkPy.substr(0, _clkPy.length - 2) * 4 / 3;
	} else {
		m = _clkPx * 1
		n = _clkPy * 1
	}
	sqrta = Math.sqrt((x - m) * (x - m) + (y - n) * (y - n)); 
	if (sqrta < 10) {
		_isOndblclick = true;
		return;
	}
}
_isOndblclick = false;
  switch(_MOVETYPE){
    case "line":	
    case "polyline":
		//_MOVEOBJ.to = x + "," + y;
	    _MOVEOBJ.to = x + "," + (y - 0);//原代码
      break;
	case "line_m":
		var zx=x*_ZOOM
		var zy=y*_ZOOM
		
		if (oOval==null)createOval(zx,zy);
		if (_PointOrLine==0)
		{	
			var Step = _FLOW.getStepByID(_MOVEOBJ.ID)
			if(_PointMoveID==''){
				for(var i=0;i<Step.PointObjs.length;i++){
					var _x = parseInt(Step.PointObjs[i].X)
					var _y = parseInt(Step.PointObjs[i].Y)
					if(Math.abs(_x-zx)<20&&Math.abs(_y-zy)<20){
						_MOVETYPE ='';
						document.body.removeChild(oOval);
						return false;
					}
				}
			}
			
			Step.removePointByID(_PointMoveID)
			 var ProcTo = _FLOW.getProcAtXY(x, y);
			 if(ProcTo!=null){
			 
			 	//TODO
			 	ProcTo.setSelected()
			 }
			 oOval.fillcolor = "red";
			 oOval.strokecolor = "red";
		}
		m = _clkPx.substr(0,_clkPx.length-2)*4/3;
		n = _clkPy.substr(0,_clkPy.length-2)*4/3;
		sqrta = Math.sqrt((x-m)*(x-m)+(y-n)*(y-n));
	    var _arySltLine = _strSltLine.split(',');
	    _UIOBJ = document.all("_polylineui");
	    _UIOBJ.points.value = '';
	    _UIOBJ.style.display = '';
		if(sqrta>5||_PointMoveID!='')
	    {
	    	oOval.setAttribute('Modified',true)
			oOval.style.left = (x*3/4)-3+'pt';
			oOval.style.top = (y*3/4)-3+"pt";
			if(_PointOrLine==0){
			  _movePt = (x*3/4)+'pt,'+(y*3/4)+"pt";
			  _MOVEOBJ.Points = _strPt1+""+_movePt+""+_strPt2;
			}
			else{
			  _moveLine = _arySltLine[0]+','+_arySltLine[1]+','+x*3/4+'pt,'+y*3/4+'pt,'+_arySltLine[2]+','+_arySltLine[3];
			  _MOVEOBJ.Points = _strLine1+_moveLine+_strLine2;
			}
			 _MOVEOBJ.getRelNumber();
			//document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
			//document.getElementById(_MOVEOBJ.ID).points.value = _MOVEOBJ.Points;
			 _UIOBJ.points.value = _MOVEOBJ.Points;
			_MOVEOBJ.setTTextPoint(_MOVEOBJ.TText);
			_FLOW.Modified = true;
			
		}
	  break;
    case "proc_m":
		m = _clkPx.substr(0,_clkPx.length-2)*4/3;
		n = _clkPy.substr(0,_clkPy.length-2)*4/3;
		sqrta = Math.sqrt((x-m)*(x-m)+(y-n)*(y-n));
		if(sqrta>2)
	    {
	    	x = x-_MOVEOBJ.offsetLeft;
	    	y = y -_MOVEOBJ.offsetTop;
	    	
			var newX = x- _CURRENTX;
			var newY = y- _CURRENTY;

			var _X = parseInt(_MOVEOBJ.style.left)
			var _Y = parseInt(_MOVEOBJ.style.top)	
			if(selectedItem.length>0){
				
				var minX = _FLOW.getFlowMinX();
				var minY = _FLOW.getFlowMinY();
				var _Left,_Top;
				if(minX){
						if(newX+minX<0){
							newX = 0-minX;
						}
						if(newY+minY<25){
							newY = 25-minY;
						}
					}else{
						if(newX+_X<0){
							newX = 0-_X;
						}
						if(newY+_Y<25){
							newY =25-_Y;
						}
				}
				
				for(var i=0;i<selectedItem.length;i++){

					_Left = parseInt(document.all(selectedItem[i].ID).style.left)
					_Top = parseInt(document.all(selectedItem[i].ID).style.top)
									
					if(newX!=0){
						document.all(selectedItem[i].ID).style.left=_Left+newX+2
					}
					if(newY!=0){
						document.all(selectedItem[i].ID).style.top =_Top+newY+2
					}
				}
					
			}else{
				var minX = _FLOW.getFlowMinX();
				var minY = _FLOW.getFlowMinY();
				if(minX){
					if(newX+minX<0){
							newX = 0-minX;
					}
					if(newX+minY<0){
						newY =25-minY;
					}
				}else{
					if(newX+_X<0){
						newX = 0-_X;
					}
					if(newY+_Y<25){
						newY =25-_Y;
					}
				}
				_MOVEOBJ.style.left = _X +newX + 2; //修正两个像素
				_MOVEOBJ.style.top = _Y+newY + 2;
			
			}
			changeProcPos(_MOVEOBJ);
		}
		break;
    case "proc_n":
      var newH = y - parseInt(_MOVEOBJ.style.top);
      if(newH < 30) newH = 30;
      _MOVEOBJ.style.height = newH;
      changeProcPos(_MOVEOBJ);
      break;
    case "proc_e":
      var newW = x - parseInt(_MOVEOBJ.style.left);
      if(newW < 30) newW = 30;
      _MOVEOBJ.style.width = newW;
      changeProcPos(_MOVEOBJ);
      break;
    case "proc_nw":
      var newW = x - parseInt(_MOVEOBJ.style.left);
      var newH = y - parseInt(_MOVEOBJ.style.top);
      if(newW < 30) newW = 30;
      if(newH < 30) newH = 30;
      _MOVEOBJ.style.width = newW;
      _MOVEOBJ.style.height = newH;
      changeProcPos(_MOVEOBJ);
      break;
    case "rect":
    case "roundrect":
    case "diamond":
    case "oval":
	case "fillrect":
	case "selectbox":
	  
      var newX = x;
      var newY = y;
      var obj = document.all("_" + _MOVETYPE + "ui");
      //var begin = document.getElementById('begin');
      if(newX < _CURRENTX) obj.style.left = newX;
      obj.style.width = Math.abs(newX - _CURRENTX);
      if(newY < _CURRENTY) obj.style.top = newY;
      obj.style.height = Math.abs(newY - _CURRENTY);
      break;
    default: // 不是在移动状态下，将鼠标移动消息交给图元
      
      fireProcMouseMove(x, y); 
	  
  }
   _FLOW.setAllStepInfo();
}
//获取当前点到当前对象的8个点中最近的点
function getNearPt(oProc,x,y)
{

	var objProc = document.getElementById(oProc.ID)
	var fromW = parseInt(objProc.style.width);
	var fromH = parseInt(objProc.style.height);
	var fromX = parseInt(objProc.style.left);
	var fromY = parseInt(objProc.style.top);
	
	var arrX = new Array();
	var arrY = new Array();
	var arrPos = new Array(0,0.25,0.5,0.75,1);
	var nX, nY, m,n , nearPt,poX,poY;
	arrX[0] = fromX;
	arrX[1] = fromX + fromW / 4;
	arrX[2] = fromX + fromW / 2;
	arrX[3] = fromX + fromW * 3 / 4;
	arrX[4] = fromX + fromW;

	arrY[0] = fromY;
	arrY[1] = fromY + fromH / 4;
	arrY[2] = fromY + fromH / 2;
	arrY[3] = fromY + fromH * 3 / 4;
	arrY[4] = fromY + fromH;
	m=0;
	n=0;
	for (var i=0; i<4; i++)
	{
		Math.abs(x-arrX[i]) < Math.abs(x-arrX[i+1]) ? m=m : m=i+1;
		Math.abs(y-arrY[i]) < Math.abs(y-arrY[i+1]) ? n=n : n=i+1;
	}
	if (m>0 && m<4 && n>0 && n<4)
	{
		if (m==3)
			m=4;
		else 
			m=0;
		if (n==3)
			n=4;
		else 
			n=0;
	}

	nX = arrX[m];
	nY = arrY[n];
	poX = arrPos[m];
	poY = arrPos[n];
	nearPt = nX*3/4+"pt,"+nY*3/4+"pt|~|"+poX+","+poY
	//alert(nearPt);
	return nearPt;
	
}

function doDocMouseUp(){

	if(_isOndblclick){
		_PointMoveID = '';
		_MOVETYPE = "";
		_MOVELINEOBJ = null;
		_MOVEOBJ = null;

		return;
	}
	
  var x = (event.clientX + document.body.scrollLeft) / _ZOOM;
  var y = (event.clientY + document.body.scrollTop) / _ZOOM;
  switch(_MOVETYPE){
	 case "line_m":
		
		 if(oOval){
		 var Step = _FLOW.getStepByID(_MOVEOBJ.ID)
		
		 if((Step.Points.split(',').length<16 && _PointOrLine!=0 && oOval.Modified == true)||(_PointMoveID!=''&&_PointMoveID.indexOf('Start')==-1&&_PointMoveID.indexOf('End')==-1)){
		 	
			 oOval.StrokeColor='white'
			 oOval.FillColor = 'black'
			 var _Point = new TPoint(Step);
			 _Point.ID = Step.getMaxPointID()
			 _Point.X = parseInt(oOval.style.left)+2+'pt';
			 _Point.Y = parseInt(oOval.style.top)+2+'pt';
			 _Point.Width = oOval.style.width;
			 _Point.Height = oOval.style.height;
			 _Point.FillColor = oOval.FillColor;
			 _Point.StrokeColor = oOval.StrokeColor;
			 _Point.StrokeWeight = oOval.StrokeWeight;
			 
			 Step.PointObjs[Step.PointObjs.length] = _Point;
			 lastPoints[lastPoints.length]=_MOVEOBJ.Points;
			 _MOVEOBJ.BasePoints = _MOVEOBJ.Points;
			 document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
			 var newobj = new TStep(_FLOW);
			 newobj.clone(_MOVEOBJ);
			 _FLOW.Modified = true;
			 pushLog("editstep", {"_old":_MOVELINEOBJ,"_new":newobj});
			 //DrawVML();	
			
		 }else if(Step.PointObjs.length==5 && _PointOrLine!=0){
		 	
		 	if(false){
			 	_MOVEOBJ.Points=lastPoints[lastPoints.length-1];
		 	}else{
		 		_MOVEOBJ.Points = _MOVEOBJ.BasePoints;		 		
		 	}
		 	_MOVEOBJ.getRelNumber();
		 	_MOVEOBJ.setTTextPoint(_MOVEOBJ.TText);
			document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
		 	parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.maxPoints)
		 }
		 
		 document.body.removeChild(oOval);
		 oOval=null
		 
		 }
		var ProcTo
		ProcTo = _FLOW.getProcAtXY(x, y);

		if (ProcTo==null)
		{
			if (ptMoveType=="from" || ptMoveType=="to")
			{
				_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
				_MOVEOBJ.getRelNumber();
				document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
			}
		}
		else
	    {	
			if (ptMoveType=="from" || ptMoveType=="to")
			{
				ProcTo.lostFocus();
				var Proc1,Proc2;
				Proc1 = _FLOW.getProcAtXY(_CURRENTX, _CURRENTY);
				Proc2 = _FLOW.getProcAtXY(x, y);
				
				var nearPt = getNearPt(ProcTo,x,y);
				var strPt = nearPt.split("|~|")[0];
				var arrPt = strPt.split(",");
				var strPos = nearPt.split("|~|")[1];
				var nX = arrPt[0].substr(0,arrPt[0].length-2);
				var nY = arrPt[1].substr(0,arrPt[1].length-2);
				var relX = strPos.split(",")[0];
				var relY = strPos.split(",")[1];
				if (ptMoveType=="from")
				{
					Proc1 = ProcTo;
					Proc2 = _FLOW.getProcByID(_MOVEOBJ.ToProc);
				}
				if (ptMoveType=="to")
				{
					Proc1 = _FLOW.getProcByID(_MOVEOBJ.FromProc);
					Proc2 = ProcTo;
				}
				var existProc = _FLOW.StepPathExists(Proc1.ID, Proc2.ID)
				if((Proc1.ID == Proc2.ID)||(existProc!=null && existProc.ID != _MOVEOBJ.ID)
					||(Proc1.ProcType == "process" || Proc2.ProcType == "create")
					||(_MOVEOBJ.FromProc=="begin" && ptMoveType=="from" && ProcTo.ID != _MOVEOBJ.FromProc)
					||(_MOVEOBJ.FromProc=="begin" && ptMoveType=="to" && ProcTo.ID != _MOVEOBJ.ToProc)
					||(_MOVEOBJ.FromProc!="begin" && ProcTo.ID=="begin")){
					// 多条出口
					/*if(existProc!=null && existProc.ID != _MOVEOBJ.ID){
						parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.stepExist);
						_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
						_MOVEOBJ.getRelNumber();
						document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
						if(_UIOBJ!=null){
								_UIOBJ.style.display = "none";
								_UIOBJ = null;
						}
						break;
					}*/
					if(Proc1.ProcType == "process"){
						parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.stepRule);
						_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
						_MOVEOBJ.getRelNumber();
						document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
						if(_UIOBJ!=null){
								_UIOBJ.style.display = "none";
								_UIOBJ = null;
						}
						break;
					}
					if(Proc1.ID == Proc2.ID){
						//确认是否要添加指向自身的出口
						if(confirm(wmsg.wfdesign.addSelfConfrim)){
						 
							parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.notSelf);
							_MOVEOBJ.Points = _strPt1+strPt+_strPt2;
							_MOVEOBJ.getRelNumber();
							_MOVEOBJ.setPropValue("ToProc",_MOVEOBJ.FromProc)
							document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
							if(_UIOBJ!=null){
									_UIOBJ.style.display = "none";
									_UIOBJ = null;
							}
						}
						break;
					}
					
					if (ptMoveType=="from")
					{
						if(!_MOVEOBJ.branchValidate(ProcTo.ID,_MOVEOBJ.ToProc)){
							parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.noInSameBranch)
							_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
							_MOVEOBJ.getRelNumber();
							document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
							if(_UIOBJ!=null){
								_UIOBJ.style.display = "none";
								_UIOBJ = null;
							}
							break;
						}
						_MOVEOBJ.setPropValue("FromProc",ProcTo.ID);
						_MOVEOBJ.fromRelX = relX;
						_MOVEOBJ.fromRelY = relY;
					}
					if (ptMoveType=="to")
					{
						if(!_MOVEOBJ.branchValidate(_MOVEOBJ.FromProc,ProcTo.ID)){
							parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.noInSameBranch)
							_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
							_MOVEOBJ.getRelNumber();
							document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
							if(_UIOBJ!=null){
								_UIOBJ.style.display = "none";
								_UIOBJ = null;
							}
							break;
						}
						_MOVEOBJ.setPropValue("ToProc",ProcTo.ID);
						_MOVEOBJ.toRelX = relX;
						_MOVEOBJ.toRelY = relY;
					}
				
					_FLOW.Modified = true;
					_MOVEOBJ.Points = _strPt1+strPt+_strPt2;
					_MOVEOBJ.getRelNumber();
					document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
				}
				else
				{
					
					if (ptMoveType=="from")
					{
						if(!_MOVEOBJ.branchValidate(ProcTo.ID,_MOVEOBJ.ToProc)){
							parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.noInSameBranch)
							_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
							_MOVEOBJ.getRelNumber();
							document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
							if(_UIOBJ!=null){
								_UIOBJ.style.display = "none";
								_UIOBJ = null;
							}
							break;
						}
						_MOVEOBJ.setPropValue("FromProc",ProcTo.ID);
						_MOVEOBJ.fromRelX = relX;
						_MOVEOBJ.fromRelY = relY;
					}
					if (ptMoveType=="to")
					{
						if(!_MOVEOBJ.branchValidate(_MOVEOBJ.FromProc,ProcTo.ID)){
							parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.noInSameBranch)
							_MOVEOBJ.Points = _strPt1+_strSltPt+_strPt2;
							_MOVEOBJ.getRelNumber();
							document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
							if(_UIOBJ!=null){
								_UIOBJ.style.display = "none";
								_UIOBJ = null;
							}
							break;
						}
						_MOVEOBJ.setPropValue("ToProc",ProcTo.ID);
						_MOVEOBJ.toRelX = relX;
						_MOVEOBJ.toRelY = relY;
					}
				
					_MOVEOBJ.Points = _strPt1+strPt+_strPt2;
					_MOVEOBJ.getRelNumber();
					document.getElementById(_MOVEOBJ.ID).outerHTML=_MOVEOBJ.toString();
					stuffProp();
					_FLOW.Modified = true;
					var newobj = new TStep(_FLOW);
					newobj.clone(_MOVEOBJ);
					
					pushLog("editstep", {"_old":_MOVELINEOBJ,"_new":newobj});
				}
			}
			
		}
		if(_UIOBJ!=null){
			_UIOBJ.style.display = "none";
			_UIOBJ = null;
		}
		updateFlow(document.getElementById(_MOVEOBJ.ID));
		break;
    case "proc_m":
    case "proc_n":
    case "proc_e":
    case "proc_nw":
      var Proc = _FLOW.getProcByID(_MOVEOBJ.id);
	  var moveObj = {"objID":[],"moveType":_MOVETYPE,"_old": [], "_new":[]}
	  var oldVal = {"X":Proc.X,"Y":Proc.Y,"Width":Proc.Width,"Height":Proc.Height};
	  
      if(selectedItem.length>0 && _MOVETYPE == "proc_m"){
      	
      	if(true||Math.abs(parseInt(oldVal.X) - parseInt(Proc.X)) > 2 || Math.abs(parseInt(oldVal.Y) - parseInt(Proc.Y)) > 2
		         || Math.abs(parseInt(oldVal.Width) - parseInt(Proc.Width)) > 2 || Math.abs(parseInt(oldVal.Height) - parseInt(Proc.Height)) > 2){
		    
			for(var i=0;i<selectedItem.length;i++){
				
				Proc = _FLOW.getProcByID(selectedItem[i].ID)
				oldVal = {"X":Proc.X,"Y":Proc.Y,"Width":Proc.Width,"Height":Proc.Height};
				Proc.setPropValue("X",parseInt(document.all(selectedItem[i].ID).style.left));
	        	Proc.setPropValue("Y",parseInt(document.all(selectedItem[i].ID).style.top));
				updateFlow(document.all(selectedItem[i].ID));
		  		saveStepsToProc(document.all(selectedItem[i].ID));
				
			    //如果只是细小的调节，不记录历史操作
				moveObj.objID[ moveObj.objID.length] = Proc.ID;
		        moveObj._old[moveObj._old.length]=oldVal;
		        moveObj._new[moveObj._new.length]={"X":Proc.X,"Y":Proc.Y,"Width":Proc.Width,"Height":Proc.Height};
	         }
	      	 moveObj.moveType = _MOVETYPE;
		 	   _FLOW.Modified = true;	
		 	 pushLog("moveproc", moveObj);	        
		 	 stuffProp();
		         }
		}else{
		  
	      if(_MOVETYPE == "proc_m"){
	        Proc.setPropValue("X",_MOVEOBJ.style.left);
	        Proc.setPropValue("Y",_MOVEOBJ.style.top);
	      }
	      else{
	        Proc.setPropValue("Width",_MOVEOBJ.style.width);
	        Proc.setPropValue("Height",_MOVEOBJ.style.height);
	      }
	      //如果只是细小的调节，不记录历史操作
	      if(Math.abs(parseInt(oldVal.X) - parseInt(Proc.X)) > 2 || Math.abs(parseInt(oldVal.Y) - parseInt(Proc.Y)) > 2
	         || Math.abs(parseInt(oldVal.Width) - parseInt(Proc.Width)) > 2 || Math.abs(parseInt(oldVal.Height) - parseInt(Proc.Height)) > 2){
	      	moveObj.objID[ moveObj.objID.length] = Proc.ID;
	        moveObj._old[moveObj._old.length]=oldVal;
	        moveObj._new[moveObj._new.length]={"X":Proc.X,"Y":Proc.Y,"Width":Proc.Width,"Height":Proc.Height};
	        //DrawAll();
	        
	        moveObj.moveType = _MOVETYPE;
	        _FLOW.Modified = true;
	        pushLog("moveproc", moveObj);
	  
	      }
	      stuffProp();
	      
		  updateFlow(_MOVEOBJ);
		  saveStepsToProc(_MOVEOBJ);
		}
		moveObj.moveType = _MOVETYPE;
		
      break;
    case "rect":
    case "roundrect":
    case "diamond":
    case "oval":
	case "fillrect":
    case "line":
    case "polyline":
     
      var obj = document.all("_" + (_MOVETYPE == "polyline"?"line":_MOVETYPE) + "ui");
      
      obj.style.display = "none";
      if(_MOVETYPE == "line" || _MOVETYPE == "polyline"){
		var _points = obj.from+","+obj.to;
		
      	_points = changePtToPx(_points);
		var Proc1,Proc2, Step;
        Proc1 = _FLOW.getProcAtXY(_CURRENTX, _CURRENTY);
        Proc2 = _FLOW.getProcAtXY(x, y);
		if(Proc1 == null || Proc2 == null){
          break;;
        }
        var aryTmpPoint = _points.split(",");
       
        if(true){
        	
        }else{
        	
        }
        //多条出口
        /*if(_FLOW.StepPathExists(Proc1.ID, Proc2.ID)!=null){
          parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.stepExist);
          break;
        }*/
        if(Proc1.ID == Proc2.ID){
        	 //确认是否要添加指向自身的出口
	    	 if(confirm(wmsg.wfdesign.addSelfConfrim)){
	      		parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.notSelf);
	    	 }else{
	    	 	break;
	    	 }
          //
        }
      
        if(Proc1.ProcType == "process"){
          parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.stepRule);
          break;
        }
              
        Step = new TStep(_FLOW);
        Step.FromProc = Proc1.ID;
        Step.ToProc = Proc2.ID;
        
        Step.Points = _points;
        Step.getRelNumber();
        var strPt ="";
        var objX = parseInt(Proc1.X);
        var objY = parseInt(Proc1.Y);
        var objWidth = parseInt(Proc1.Width);
        var objHeight = parseInt(Proc1.Height);
        strPt = (objX+objWidth*Step.fromRelX)*3/4+"pt,"+(objY+objHeight*Step.fromRelY)*3/4+"pt,"
        objX = parseInt(Proc2.X);
        objY = parseInt(Proc2.Y);
        objWidth = parseInt(Proc2.Width);
        objHeight = parseInt(Proc2.Height);
        strPt = strPt + (objX+objWidth*Step.toRelX)*3/4+"pt,"+(objY+objHeight*Step.toRelY)*3/4+"pt"
         Step.Points = strPt;
        if(!Step.branchValidate(Proc1.ID,Proc2.ID)){
			parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.noInSameBranch)
			Step==null;
			break;
		}
		
        Step.Text = wmsg.wfdesign.step+(_FLOW.stepNumber+1)
        Step.ShapeType = "PolyLine";
        Step.isNew = "true";
		var arrStep = [Step];
		
        _FLOW.getMaxStepID(arrStep);
        
      }
      else{
      	
		_FLOW.getMaxProcID(obj);
      	
      }
     
      break;
  	case "selectbox":
  	  var obj = document.all("_" + (_MOVETYPE == "polyline"?"line":_MOVETYPE) + "ui");
  	  obj.style.display = "none";
		var selectBox = new SelectBox(_FLOW);    
		selectBox.ShapeType = "selectbox";
		
		selectBox.X = parseInt(obj.style.left);
		selectBox.Y = parseInt(obj.style.top);
		selectBox.Width = parseInt(obj.style.width);
		selectBox.Height = parseInt(obj.style.height);
		
		_FLOW.SelectBox=selectBox;
		doSelect(false);
		objFocusedOff();
      break;
    default:
      objFocusedOff();
      break;
  }
  showSelect();
  if(!event.ctrlKey){
  	_TOOLTYPE = "selectbox"
  }
  if (_TOOLTYPE == "selectbox") {
		if (_MOVETYPE == 'polyline') {
			parent.setButtonPressed('polyline', false);
		} else if (_MOVETYPE == 'roundrect') {
			parent.setButtonPressed(_NODETYPE, false);
		}
  }
  _PointMoveID ="";
  _LASTMOVETYPE = _MOVETYPE;
  _MOVETYPE = "";
  _MOVELINEOBJ = null;
  _MOVEOBJ = null;
 
  return;
}
function doDocSelectStart(){
  var oEvt = event.srcElement.tagName;
  if(oEvt != "INPUT") return false;
}

function doDocKeyDown(){
	
  switch(event.keyCode){
    case 46: //Del
      if(event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "SELECT")
        mnuDelObj();
      break;
    case 90: //z
      if(event.ctrlKey && !event.shiftKey &&!event.altKey)
        undoLog();
      break;
    case 65: //a
      if(event.ctrlKey && !event.shiftKey &&!event.altKey){
         doSelect(true);
      }
      break;
 	case 89: //y
       if(event.ctrlKey && !event.shiftKey &&!event.altKey){
       	 redoLog();
       }
      break;
    /*case 112: //F1
      mnuAbout();
      break;
	case 187: //+
      if(event.ctrlKey) mnuSetZoom('in');
      break;
	case 189: //-
      if(event.ctrlKey) mnuSetZoom('out');
      break;*/
	case 83: //s
      if(event.ctrlKey) mnuSaveFlow();
      break;
	/*case 79: //o
      if(event.ctrlKey) mnuOpenFlow();
      break;
	case 78: //n
      if(event.ctrlKey) mnuNewFlow();
      break;
	case 67: //C
      if(event.ctrlKey) mnuCopyProc();
      break;*/
	case 13: //enter
      document.all.Canvas.focus();
      break;
  }
}

function doDocKeyUp(){
	switch(event.keyCode){
		case 17: // Ctrl
			_TOOLTYPE = "selectbox";
			if (_LASTMOVETYPE == 'polyline') {
				parent.setButtonPressed('polyline', false);
			} else if (_LASTMOVETYPE == 'roundrect') {
				parent.setButtonPressed(_NODETYPE, false);
			}
			break;
	}
}

/*多个选中 flag：true(Ctrl+A) false鼠标选择*/
function doSelect(flag){
  if(flag){
  	clearSelect();
	for(var i=0;i<_FLOW.Procs.length;i++){
		_FLOW.Procs[i].setSelected();
  		selectedItem[selectedItem.length]=_FLOW.Procs[i];
  	}
  }else{
  	for(var i=0;i<_FLOW.Procs.length;i++){
	  	if(parseInt(_FLOW.Procs[i].X)+parseInt(_FLOW.Procs[i].Width)>parseInt(_FLOW.SelectBox.X)
	  	&&parseInt(_FLOW.Procs[i].X)<parseInt(_FLOW.SelectBox.X)+parseInt(_FLOW.SelectBox.Width)
	  	&&parseInt(_FLOW.Procs[i].Y)+parseInt(_FLOW.Procs[i].Height)>parseInt(_FLOW.SelectBox.Y)
	  	&&parseInt(_FLOW.Procs[i].Y)<parseInt(_FLOW.SelectBox.Y)+parseInt(_FLOW.SelectBox.Height)){
	  		_FLOW.Procs[i].setSelected();
	  		selectedItem[selectedItem.length]=_FLOW.Procs[i];
	  	}
	  }
  }
}
 
function clearSelect(){
	
  for(var i=0;i<selectedItem.length;i++){
	selectedItem[i].lostFocus();
  }
  selectedItem.length=0;
}

function showSelect(){
  for(var i=0;i<selectedItem.length;i++){
	selectedItem[i].setSelected();
  }
}

function deleteSelect(obj){
	selectedItem.remove(obj);
}

function showFouces(id){
	if(type=='view'){
		return;
	}
	if((_MOVETYPE=='line_m'&&_PointOrLine==0&&_PointMoveID=='')||_MOVETYPE=='polyline'){
		_FLOW.getProcByID(id).setSelected()
		for(var i=0;i<_FLOW.Procs.length;i++){
			if(_FLOW.Procs[i].ID!=id){
				_FLOW.Procs[i].lostFocus();
			}
		}
	}
	
	if(selectedItem.length>1){
		return;
	}
	var proc = _FLOW.getProcByID(id);
	
	if(_TOOLTYPE!="selectbox"&&_TOOLTYPE!="point"&&_TOOLTYPE!="polyline"){
		return;
	}
	
	if(((Math.abs(event.clientX-parseInt(proc.X))<3||Math.abs(event.clientX-parseInt(proc.X)-parseInt(proc.Width))<3)&&(event.clientY>=parseInt(proc.Y)&&event.clientY<=parseInt(proc.Y)+parseInt(proc.Height)))
		||((Math.abs(event.clientY-parseInt(proc.Y))<3||Math.abs(event.clientY-parseInt(proc.Y)-parseInt(proc.Height))<3)&&(event.clientX>=parseInt(proc.X)&&event.clientX<=parseInt(proc.X)+parseInt(proc.Width)))
	){
		document.all.Canvas.style.cursor = "point"
		_TOOLTYPE = "polyline";
	}else{
		if(!parent.Ext.getCmp("showTextpolyline").pressed){
			document.all.Canvas.style.cursor = "hand"
			_TOOLTYPE = "selectbox";
		}
	
	}
}

function createProcs(obj){
		var arrProc = [];
      	
      	var _cx = parseInt(obj.style.left);
      	
      	var _cy = parseInt(obj.style.top);
      	if(_cx<10){
      		_cx = 10;
      	}
      	if(_cy<30){
      		_cy = 30;	
      	}
      	var _maxX = 0;
      	var _row = 0;
      	var _column = 0;
      	for(var i=0;i<_CREATENUMBER;i++){
      		var Proc = new TProc(_FLOW,"",_NODETYPE);
      		Proc.nodetype = _TYPE;
	        Proc.ShapeType = (_MOVETYPE == "rect"?"Rect":(_MOVETYPE == "roundrect"?"RoundRect":(_MOVETYPE=="fillrect"?"FillRect":(_MOVETYPE=="selectbox"?"Selectbox":(_MOVETYPE == "oval"?"Oval":"Diamond")))));
			Proc.Text = _FLOW.getProcNameByType(_NODETYPE)+(_FLOW.procNumber+1+i)
			Proc.Img = _FLOW.Config._ImgPath+_NODETYPE+".gif";
			Proc.ProcType = _NODETYPE;
			
			if(_row%2==0){
				Proc.X = _cx+50*_column+120*_column
			}else{
				Proc.X = _maxX-50*_column-120*_column
			}

			Proc.Y = _cy+_row*80+_row*50;
	         _column ++;
	        if((_row%2==0&&Proc.X+120+50+120>1000)||(_row%2!=0&&Proc.X-50-120<25)){
	        
	        	_row++;
	        	_column=0;
	        	_maxX = Proc.X
	        	_cx = Proc.X
	        }
	        
	 	    Proc.Width = 120;
	        Proc.Height = 80;
	       	Proc.isNew = "true";
	        arrProc[i] = Proc;
      	}
      	
      	return arrProc;
}
function createProcsByID(procId,arrProc){
		//alert(procId);
		var arrStep =[];
      	//var procId = _FLOW.getMaxProcID(arrProc);
	    if(procId!=false){
	    	var procIds = procId.split(',');
	    	for(var i=0; i<procIds.length;i++){
	    		arrProc[i].ID = procIds[procIds.length-(i+1)]+"P";
	    		//alert(arrProc[i].ID);
	    		if(arrProc[i].ProcType=='create'){
		    		parent.setNodeEnable(arrProc[i].ProcType,false);
		    		
		    	}
		    	_FLOW.addProc(arrProc[i]);
	    	}

	        if(_CREATESTEP&&_CREATENUMBER>1){
	        	
	        	for(var i=0;i<_CREATENUMBER-1;i++){
	        		var Step = new TStep(_FLOW);
	        		
			        Step.FromProc = arrProc[i].ID;
			        Step.ToProc = arrProc[i+1].ID;
			        Step.Text = wmsg.wfdesign.step+(_FLOW.stepNumber+1+i)
			        Step.ShapeType = "PolyLine";
			        Step.isNew = "true";
			        arrStep[i]=Step;
	        	}
	        	var stepId = _FLOW.getMaxStepID(arrStep,true);
	        	
	        	if(stepId!=false){
	        		//createStepsByID(stepId,)
	        	}else{
	        		for(var i=0; i<arrProc.length;i++){
			    		_FLOW.deleteProcByID(arrProc[i].ID);
			    	}
			    	_FLOW.getMaxProcID(new Array());
	        	}
	        }
	        var objAdd = {Procs:[],Steps:[]};
			objAdd.Procs = arrProc;
			objAdd.Steps = arrStep;
			_FLOW.Modified = true;
			
	        pushLog("addproc", objAdd);
	        DrawAll();	
	        _FLOW.getBranchInfo();
	       
	  	}else{
	  		_TOOLTYPE = "selectbox"
	  		parent.setButtonPressed(_NODETYPE, false);
	  	}
	  
}
function createStepsByID(id,arrStep,auto){
	if(id!=false){
			if(!auto){
		        arrStep[0].ID = id.split(',')[0]+"T";	        
		        var newText = new TText(arrStep[0]);
				newText.ID = arrStep[0].ID+'Text';
				arrStep[0].TText = newText;
				_FLOW.Modified = true;
		        pushLog("addstep", arrStep[0]);
		        _FLOW.addStep(arrStep[0]);
		        _FLOW.getBranchInfo();
		        DrawAll();
			}else{
				var stepIds = id.split(',');
        		for(var i=0;i<stepIds.length;i++){
        			arrStep[stepIds.length-1-i].ID = stepIds[i]+"T";
	        		var newText = new TText(arrStep[stepIds.length-1-i]);
					newText.ID = arrStep[stepIds.length-1-i].ID+'Text';
					arrStep[stepIds.length-1-i].TText = newText;
					_FLOW.addStep(arrStep[stepIds.length-1-i]);
        		}
			}
        }else{
        	Step = null;
        	_TOOLTYPE = "selectbox"
      		parent.setButtonPressed("polyline", false);
        }
}

/**
 * 显示出口起点和结点
 * @param {} id
 */
function showPoint(id){
	
	if(type!='edit'){
		return;
	}
	var start = document.getElementById(id+'StartPoint');
	var end = document.getElementById(id+'EndPoint');
	try{
	if(start!=null){
		start.style.display ='';
		start.style.zIndex = start.style.zIndex+100;
		if(event.clientX<parseInt(start.style.left)+parseInt(start.style.width)&&event.clientX>parseInt(start.style.left)&&
			event.clientY<parseInt(start.style.top)+parseInt(start.style.height)&&event.clientY>parseInt(start.style.top)){
			start.style.display ='';
		}else{
			//start.style.display ='none';
		}
	}
	if(end!=null){
		end.style.display ='';
		end.style.zIndex = start.style.zIndex+100;
		if(event.clientX<parseInt(end.style.left)+parseInt(end.style.width)&&event.clientX>parseInt(end.style.left)&&
			event.clientY<parseInt(end.style.top)+parseInt(end.style.height)&&event.clientY>parseInt(end.style.top)){
			end.style.display ='';
		}else{
			//end.style.display ='none';
		}
	}
	}catch(e){
		//alert(event);
	}
}

/**
 * 隐藏出口起点和结点
 * @param {} id
 */
function hidePoint(id){
	var start = document.getElementById(id+'StartPoint');
	var end = document.getElementById(id+'EndPoint')
	
	start.style.display ='none';
	start.style.zIndex = start.style.zIndex-100;
	end.style.display ='none';
	end.style.zIndex = start.style.zIndex-100;
}

/**
 * 自动调整流程图
 */
function autoAdjust(){
	
	for(var i=0; i<_FLOW.Steps.length;i++){
		// 对于没有顶点的出口不做处理
		if(_FLOW.Steps[i].PointObjs.length==0){
			continue;
		}
		adjustLine(_FLOW.Steps[i]);
	}
}

/**
 * 自动调整出口
 * @param {} step
 */
function adjustLine(step){
	var _point = "";
	var aryPt = changePtToPx(step.Points).split(',');
	var _X =0;
	var _Y = 0;
	
	var start = document.getElementById(step.ID+'StartPoint');
	var end = document.getElementById(step.ID+'EndPoint')
	
	//修正出口
	for(var i=0;i<aryPt.length-2;i=i+2){
		_X = Math.abs(parseInt(aryPt[i])-parseInt(aryPt[i+2]));
		_Y = Math.abs(parseInt(aryPt[i+1])-parseInt(aryPt[i+3]));
		if(_Y/_X<1/4){
			if(i<2){
				aryPt[i+3] = aryPt[i+1];
			}else {
				aryPt[i+1] = aryPt[i+3] ;
			}
		}
		if(_X/_Y<1/4){
			if(i>aryPt.length-5){
				aryPt[i] = aryPt[i+2];
			}else {
				aryPt[i+2] = aryPt[i];	
			}
		}
	}
	
	for(var i=0;i<aryPt.length;i++){
		_point+=aryPt[i]+",";
	}
	
	_point = _point.substr(0,_point.length-1);
	step.Points =  _point;
	
	//修正出口顶点
	for(var i=0; i<step.PointObjs.length;i++){
		document.getElementById(step.PointObjs[i].ID).outerHTML = "";
	}
	step.PointObjs.length = 0;
	step.PointID = 0;
	for(var j =2;j<aryPt.length-2;j=j+2){
		var point = new TPoint(step);
		point.FillColor ='black'
		point.Height ='4px';
		point.ID = step.getMaxPointID();
		point.StrokeColor = 'white';
		point.Width ='4px';
		point.X = parseInt(aryPt[j]-1)+'';
		point.Y = parseInt(aryPt[j+1]-1)+'';
		
		step.PointObjs[step.PointObjs.length] = point;
	}
	//更新画面显示
	document.getElementById(step.ID).outerHTML = step.toString();
	
}

// 指定页面事件 
if(type=='edit'){

	document.onselectstart = doDocSelectStart;
	document.onmousedown = doDocMouseDown;
	document.onmousemove = doDocMouseMove;
	document.onmouseup = doDocMouseUp;
	document.onkeydown = doDocKeyDown;
	document.onkeyup = doDocKeyUp;
	document.onerror = new Function("return false;"); 
}