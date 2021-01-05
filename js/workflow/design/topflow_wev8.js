//节点属性
TProc.prototype.getPropertySource = function (){
	var id = this.ID.substr(0,this.ID.length-1);
	parent.setOperatorURL(_FLOW, id);//
	//start_td 19600
	var hasNodePro = this.hasNodePro;
	var hasCusRigKey = this.hasCusRigKey;
	var	hasLogViewSco = this.hasLogViewSco;
	var	hasNodeBefAddOpr = this.hasNodeBefAddOpr;
	var hasNodeAftAddOpr = this.hasNodeAftAddOpr;
	var hasNodeForFie = this.hasNodeForFie;
	//end_td19600
	var propertySource='';
	switch(this.ProcType){
		case 'create':
		case 'process':
			propertySource+='propertySource = {'
			propertySource+=wmsg.wfdesign.nodeName+':"'+this.Text+'",'
		//start_td19600
			propertySource+=wmsg.wfdesign.procTitleInfo+':'+'{type:"button",hasCon:"'+hasNodePro+'",text:"'+''+'", url:"/workflow/workflow/showNodeAttrOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.formSignature+':'+'{type:"button", text:"'+''+'", url:"/workflow/workflow/showFormSignatureOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.rightMenu+':'+'{type:"button",hasCon:"'+hasCusRigKey+'",text:"'+''+'",url:"/workflow/workflow/showButtonNameOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.preAddInOperate+':'+'{type:"button",hasCon:"'+hasNodeBefAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showpreaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.addInOperate+':'+'{type:"button",hasCon:"'+hasNodeAftAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','	
			propertySource+=wmsg.wfdesign.logBrownser+':'+'{type:"button",hasCon:"'+hasLogViewSco+'",text:"'+''+'",url:"/workflow/workflow/wfNodeBrownser.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.nodeFormField+':'+'{type:"button",hasCon:"'+hasNodeForFie+'",text:"'+''+'",url:"/workflow/workflow/addwfnodefield.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//end td19600
			//propertySource+=wmsg.wfdesign.createDoc+':'+'{type:"button",text:"'+''+'",url:"/test.jsp"}'+','
			propertySource+=wmsg.wfdesign.oerator+': "'+wmsg.wfdesign.select+'" }'
			//propertySource+=wmsg.wfdesign.oerator+':'+'{type:"button",text:"'+''+'",url:"/workflow/workflow/addoperatorgroup.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'&formid='+_FLOW.FormID+'&isbill='+_FLOW.IsBill+'&iscust='+_FLOW.IsCust+'"}'+'}'
			
			eval(propertySource)
			break;
		case 'realize':
			propertySource+='propertySource = {'
			propertySource+=wmsg.wfdesign.nodeName+':"'+this.Text+'",'
			if(this.nodetype==2){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.realize+'",'
			}else{
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.approve+'",'
			}
			
				//td19600
			propertySource+=wmsg.wfdesign.procTitleInfo+':'+'{type:"button",hasCon:"'+hasNodePro+'",text:"'+''+'", url:"/workflow/workflow/showNodeAttrOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.formSignature+':'+'{type:"button", text:"'+''+'", url:"/workflow/workflow/showFormSignatureOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.rightMenu+':'+'{type:"button",hasCon:"'+hasCusRigKey+'",text:"'+''+'",url:"/workflow/workflow/showButtonNameOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.preAddInOperate+':'+'{type:"button",hasCon:"'+hasNodeBefAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showpreaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.addInOperate+':'+'{type:"button",hasCon:"'+hasNodeAftAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','	
			propertySource+=wmsg.wfdesign.logBrownser+':'+'{type:"button",hasCon:"'+hasLogViewSco+'",text:"'+''+'",url:"/workflow/workflow/wfNodeBrownser.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.nodeFormField+':'+'{type:"button",hasCon:"'+hasNodeForFie+'",text:"'+''+'",url:"/workflow/workflow/addwfnodefield.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.createDoc+':'+'{type:"button",text:"'+''+'",url:"/test.jsp"}'+','
			propertySource+=wmsg.wfdesign.oerator+': "'+wmsg.wfdesign.select+'" }'
			//propertySource+=wmsg.wfdesign.oerator+':'+'{type:"button",text:"'+''+'",url:"/workflow/workflow/addoperatorgroup.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'&formid='+_FLOW.FormID+'&isbill='+_FLOW.IsBill+'&iscust='+_FLOW.IsCust+'"}'+'}'
			//end td19600
			
			eval(propertySource)
			break;
		case 'approve':
			propertySource+='propertySource = {'
			propertySource+=wmsg.wfdesign.nodeName+':"'+this.Text+'",'
			if(this.nodetype==2){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.realize+'",'
			}else{
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.approve+'",'
			}
	//start_td19600
			propertySource+=wmsg.wfdesign.procTitleInfo+':'+'{type:"button",hasCon:"'+hasNodePro+'",text:"'+''+'", url:"/workflow/workflow/showNodeAttrOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.formSignature+':'+'{type:"button", text:"'+''+'", url:"/workflow/workflow/showFormSignatureOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.rightMenu+':'+'{type:"button",hasCon:"'+hasCusRigKey+'",text:"'+''+'",url:"/workflow/workflow/showButtonNameOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.preAddInOperate+':'+'{type:"button",hasCon:"'+hasNodeBefAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showpreaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.addInOperate+':'+'{type:"button",hasCon:"'+hasNodeAftAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','	
			propertySource+=wmsg.wfdesign.logBrownser+':'+'{type:"button",hasCon:"'+hasLogViewSco+'",text:"'+''+'",url:"/workflow/workflow/wfNodeBrownser.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.nodeFormField+':'+'{type:"button",hasCon:"'+hasNodeForFie+'",text:"'+''+'",url:"/workflow/workflow/addwfnodefield.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.createDoc+':'+'{type:"button",text:"'+''+'",url:"/test.jsp"}'+','
			propertySource+=wmsg.wfdesign.oerator+': "'+wmsg.wfdesign.select+'" }'
			//propertySource+=wmsg.wfdesign.oerator+':'+'{type:"button",text:"'+''+'",url:"/workflow/workflow/addoperatorgroup.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'&formid='+_FLOW.FormID+'&isbill='+_FLOW.IsBill+'&iscust='+_FLOW.IsCust+'"}'+'}'
			//end td19600
			
			eval(propertySource)
			break;
		case 'fork':
			propertySource+='propertySource = {'
			propertySource+=wmsg.wfdesign.nodeName+':"'+this.Text+'",'
			if(this.nodetype==2){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.realize+'",'
			}else if(this.nodetype ==1){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.approve+'",'
			}else if(this.nodetype==0){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.create+'",'
			
			}
			//alert(this.nodetype)
	//start_td19600
			propertySource+=wmsg.wfdesign.procTitleInfo+':'+'{type:"button",hasCon:"'+hasNodePro+'",text:"'+''+'", url:"/workflow/workflow/showNodeAttrOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.formSignature+':'+'{type:"button", text:"'+''+'", url:"/workflow/workflow/showFormSignatureOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.rightMenu+':'+'{type:"button",hasCon:"'+hasCusRigKey+'",text:"'+''+'",url:"/workflow/workflow/showButtonNameOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.preAddInOperate+':'+'{type:"button",hasCon:"'+hasNodeBefAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showpreaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.addInOperate+':'+'{type:"button",hasCon:"'+hasNodeAftAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','	
			propertySource+=wmsg.wfdesign.logBrownser+':'+'{type:"button",hasCon:"'+hasLogViewSco+'",text:"'+''+'",url:"/workflow/workflow/wfNodeBrownser.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.nodeFormField+':'+'{type:"button",hasCon:"'+hasNodeForFie+'",text:"'+''+'",url:"/workflow/workflow/addwfnodefield.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.createDoc+':'+'{type:"button",text:"'+''+'",url:"/test.jsp"}'+','
			propertySource+=wmsg.wfdesign.oerator+': "'+wmsg.wfdesign.select+'" }'
			//end_td19600
			
			eval(propertySource)
			break;	
		case 'join':
			propertySource+='propertySource = {'
			propertySource+=wmsg.wfdesign.nodeName+':"'+this.Text+'",'
			if(this.nodetype==2){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.realize+'",'
			}else if(this.nodetype ==1){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.approve+'",'
			}else if(this.nodetype == 3){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.process+'",'
			}
			propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.approve+'",'
			if(this.passtype ==3){
				propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.passByMum+'",'
				propertySource+=wmsg.wfdesign.passnum+':"'+this.PassNum+'",'
			}else if(this.passtype ==4){
				propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.mustPass+'",'
				if(this.mustPassStep ==""){
					propertySource+=wmsg.wfdesign.mustPass+':"'+wmsg.wfdesign.select+'",'
				}else{
					var text = "";
					var ids ="";
					var aryId = this.mustPassStep.split(',');
					for(var i=0;i<aryId.length;i++){
						if(text != ""){
							text +=",";
						}
						if(ids!=""){
							ids+=","
						}
						ids += _FLOW.getStepByID(aryId[i]+"T").ID
						text += _FLOW.getStepByID(aryId[i]+"T").Text
					}
					//propertySource+=wmsg.wfdesign.mustPass+':"{type:"combobox",text:"'+ text+'", url:"'+this.mustPassStep+'"},'
					propertySource+=wmsg.wfdesign.mustPass+':'+'{type:"combobox", text:"'+text+'", url:"'+this.mustPassStep+'"}'+','
					//propertySource+=wmsg.wfdesign.mustPass+':"'+ text+'",'
				}
			}
				//start_td19600
			propertySource+=wmsg.wfdesign.procTitleInfo+':'+'{type:"button",hasCon:"'+hasNodePro+'",text:"'+''+'", url:"/workflow/workflow/showNodeAttrOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.formSignature+':'+'{type:"button", text:"'+''+'", url:"/workflow/workflow/showFormSignatureOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.rightMenu+':'+'{type:"button",hasCon:"'+hasCusRigKey+'",text:"'+''+'",url:"/workflow/workflow/showButtonNameOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.preAddInOperate+':'+'{type:"button",hasCon:"'+hasNodeBefAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showpreaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.addInOperate+':'+'{type:"button",hasCon:"'+hasNodeAftAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','	
			propertySource+=wmsg.wfdesign.logBrownser+':'+'{type:"button",hasCon:"'+hasLogViewSco+'",text:"'+''+'",url:"/workflow/workflow/wfNodeBrownser.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.nodeFormField+':'+'{type:"button",hasCon:"'+hasNodeForFie+'",text:"'+''+'",url:"/workflow/workflow/addwfnodefield.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.createDoc+':'+'{type:"button",text:"'+''+'",url:"/test.jsp"}'+','
			propertySource+=wmsg.wfdesign.oerator+': "'+wmsg.wfdesign.select+'" }'
			//endtd19600
			
			eval(propertySource)
			break;	
		case 'child':
			propertySource+='propertySource = {'
			propertySource+=wmsg.wfdesign.nodeName+':"'+this.Text+'",'
			//propertySource+=wmsg.wfdesign.procTitleInfo+':'+'{type:"button", text:"'+''+'", url:"/workflow/workflow/showNodeAttrOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
				//start_td19600
			propertySource+=wmsg.wfdesign.formSignature+':'+'{type:"button",hasCon:"false",text:"'+''+'", url:"/workflow/workflow/showFormSignatureOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.formSignature+'11111:'+this.FormSignature+','
			propertySource+=wmsg.wfdesign.rightMenu+':'+'{type:"button",hasCon:"'+hasCusRigKey+'",text:"'+''+'",url:"/workflow/workflow/showButtonNameOperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.preAddInOperate+':'+'{type:"button",hasCon:"'+hasNodeBefAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showpreaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.addInOperate+':'+'{type:"button",hasCon:"'+hasNodeAftAddOpr+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','	
			propertySource+=wmsg.wfdesign.logBrownser+':'+'{type:"button",hasCon:"'+hasLogViewSco+'",text:"'+''+'",url:"/workflow/workflow/wfNodeBrownser.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			propertySource+=wmsg.wfdesign.nodeFormField+':'+'{type:"button",hasCon:"'+hasNodeForFie+'",text:"'+''+'",url:"/workflow/workflow/addwfnodefield.jsp?design=1&wfid='+_FLOW.ID+'&nodeid='+id+'"}'+','
			//propertySource+=wmsg.wfdesign.createDoc+':'+'{type:"button",text:"'+''+'",url:"/test.jsp"}'+','
			propertySource+=wmsg.wfdesign.oerator+': "'+wmsg.wfdesign.select+'" }'
			//end_td19600
			
			eval(propertySource)
			break;
	}
	
	return propertySource;
}

//出口线属性
TStep.prototype.getPropertySource = function (){
	var id = this.ID.substr(0,this.ID.length-1);
	parent.setPurposeNodeURL(_FLOW, id);//
	//starttd19600
	var hasRoles = this.hasRole;
	var hasCondition = this.hasCondition;
	//endtd19600
	var propertySource = 'propertySource={'
	propertySource+=wmsg.wfdesign.stepName+':"'+this.Text+'",'
	propertySource+=wmsg.wfdesign.purposeNode+':"'+this.Flow.getProcByID(this.ToProc).Text+'",'

	if(this.Flow.getProcByID(this.FromProc).nodetype =="1"){
		propertySource+=wmsg.wfdesign.isReject+':'+this.isReject+','
	}
	propertySource+=wmsg.wfdesign.createNumber+':'+this.isBuildCode+','
	//td19600
	propertySource+=wmsg.wfdesign.condition+':'+'{type:"button",hasCon:"'+hasCondition+'",text:"'+''+'",url:"/workflow/workflow/showcondition.jsp?design=1&formid='+_FLOW.FormID+'&isbill='+_FLOW.IsBill+'&id=&linkid='+id+'"}'+','
	if(parent.showwayoutinfo == 'true'){
		propertySource+=wmsg.wfdesign.stepAddInOperate+':'+'{type:"button",hasCon:"'+hasRoles+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&linkid='+id+'"},'
		propertySource+=wmsg.wfdesign.stepRemindMsg+':"'+this.RemindMsg+'"'
	}else{
		propertySource+=wmsg.wfdesign.stepAddInOperate+':'+'{type:"button",hasCon:"'+hasRoles+'",text:"'+''+'",url:"/workflow/workflow/showaddinoperate.jsp?design=1&wfid='+_FLOW.ID+'&linkid='+id+'"}'
	}
	//td19600
	propertySource+='}';
	eval(propertySource)
	return propertySource;
}

TTopFlow.prototype.getPropertySource = function(){
	var propertySource = 'propertySource={'
	propertySource+=wmsg.wfdesign.flow+':"'+this.Text+'"}'
	eval(propertySource);
	return propertySource;
}
function TText(AStep){
	this.ID= AStep.ID+'Text';
	this.Step=AStep;
	//this.Text = AStep.Text;
	this.Text ='';
	this.Width='80';
	this.Heigth='5';
	this.ShapeType ='textbox';
	var arrPoint = AStep.getPath().split(',')
	this.X = '';
	this.Y = '';
	AStep.setTTextPoint(this);
}
TText.prototype.toString = function(){
	return '';
	if(document.getElementById(this.ID)!=null){
		document.getElementById(this.ID).outerHTML = '';
	}
	var arrVal = new Array();
	arrVal['id']=this.ID;
	arrVal['l'] = this.X;
	arrVal['t'] = this.Y;
	arrVal['text']= this.Text;
	arrVal['w'] = this.Width;
	arrVal['h'] = this.Heigth;
	return stuffShape(getShapeVal(this.ShapeType), arrVal);
}

TText.prototype.clone = function(AText){
	this.ID=AText.ID;
	this.Step=AText.Step;
	this.Text = AText.Text
	this.Width=AText.Width;
	this.Heigth=AText.Heigth
	this.ShapeType =AText.ShapeType;
	this.X = AText.X;
	this.Y = AText.Y;
}

function TPoint(AStep){
	this.ID = '';
	this.OndblClick ='';
	this.OnMouseDown = '';
	this.X ='';
	this.Y ='';
	this.Width='';
	this.Height='';
	this.Display='';
	this.FillColor='';
	this.StrokeColor='';
	this.StrokeWeight='1';
	this.zIndex = AStep.zIndex;
	this.Step=AStep;
	this.StepID = AStep.ID;
	this.ShapeType = 'oval'
	this.InnerObject=null;
}

TPoint.prototype.toString = function(){
	if(document.getElementById(this.ID)!=null){
		document.getElementById(this.ID).outerHTML = '';
	}
	var arrVal = new Array();
	arrVal['id']= this.ID
	arrVal['dblclick']=this.OndblClick;
	arrVal['l'] ='5';
	arrVal['t']= '5';
	if(this.X.indexOf('pt')!=-1){
		this.X = parseInt(this.X)*4/3+'';	
		this.Y = parseInt(this.Y)*4/3+'';	
	}
	arrVal['l'] =this.X;
	arrVal['t']= this.Y;
	arrVal['dl'] = parseInt(this.X)-5;
	arrVal['dt']= parseInt(this.Y)-5;
	
	if(this.Width.indexOf('pt')!=-1){
		this.Width = parseInt(this.Width)*4/3+'';		
		this.Height = parseInt(this.Height)*4/3+'';		
	}
	arrVal['w']= this.Width;
	arrVal['h'] = this.Height;
	arrVal['d'] = this.Display;
	arrVal['dw']= parseInt(this.Width)+10+'';
	arrVal['dh'] = parseInt(this.Height)+10+'';
	arrVal['z'] = this.zIndex;
	arrVal['sc'] = this.StrokeColor;
	arrVal['sw']= this.StrokeWeight;
	arrVal['fc']=this.FillColor;
	arrVal['si'] = this.StepID;
	arrVal['dsi'] = this.StepID;
	arrVal['mousedown']=this.OnMouseDown;
	
	//arrVal['mouseup'] = this.OnMouseUp;
	
	return stuffShape(getShapeVal(this.ShapeType), arrVal);
	
}
TPoint.prototype.clone = function(APoint){
	this.ID = APoint.ID;
	this.OndblClick=APoint.OndblClick;
	this.OnMouseDown=APoint.OnMouseDown;
	this.X = APoint.X;
	this.Y = APoint.Y;
	this.Width = APoint.Width;
	this.Height = APoint.Height;
	this.Display = APoint.Display
	this.FillColor = APoint.FillColor;
	this.StrokeColor = APoint.StrokeColor;
	this.StrokeWeight = APoint.StrokeWeight;
	this.zIndex = APoint.zIndex;
	this.Step = APoint.Step;
	this.StepID = APoint.StepID;
	this.ShapeType = APoint.ShapeType;
	this.InnerObject = APoint.innerObject;
}
//[选择框]类定义
function SelectBox(AFlow){
	this.Flow = AFlow;
	this.id="selectbox";
	this.ShapeType = "selectbox";
	this.Width = "50";
	this.Height = "50";
	this.X = "50";
	this.Y = "50";
	this.zIndex = 0;
	this.InnerObject = null;
	this.MoveType = "";
}


// [任务]类定义
function TProc(AFlow, id, procType) {
	this.ObjType = "Proc";
	this.Flow = AFlow;
	this.ID = id;
	this.ShapeType = "RoundRect";
	this.ProcType = procType;
	this.Text = "";
	this.Width = "50";
	this.Height = "50";
	this.X = "50";
	this.Y = "50";
	this.TextWeight = "9pt";
	this.StrokeWeight = "0";
	this.zIndex = 1;
	this.InnerObject = null;
	this.MoveType = "";
	this.Img = this.Flow.Config._ImgPath+this.ProcType+'_wev8.gif';
	// 新增
	this.actFlag = "";
	this.waittime = "";
	this.isSltTrans = "1";
	this.isSameCredit = "1";
	this.nodetype ="";
	this.isSelect =false;
	//表单签章
	this.FormSignature = false;
		//start——td19600
	this.hasNodePro = false;//节点是否有节点属性
	this.hasCusRigKey = false;//节点是否有自定义右键按钮
	this.hasNodeBefAddOpr = false;//节点是否有节点前附加操作
	this.hasNodeAftAddOpr = false;//节点是否有节点后附加操作
	this.hasLogViewSco = false;//节点是否有日志查看范围
	this.hasNodeForFie = false;//节点是否有节点表单字段
	//end td19600
	//是否是分叉节点
	this.isFork = false;
	//是否是合并节点
	this.isJoin = false;
	//分支编号
	this.branchNO = 0;
	//分支节点
	this.Fork = "";
	//合并节点
	this.Join = "";
	this.PassNum = 2;
	this.hasFromSet = false;
	this.hasToSet = false;
	this.branchCount = 0;
	
	//是否未保存节点
	this.isNew = "false";
	
	this.passtype = 3;
	this.mustPassStep = "";
	this.nodeattribute = 0;
}

TProc.prototype.showEditPoints = function(){
	var x = parseInt(this.Width*1/4);
	var y = parseInt(this.Height*1/4);
		
}

TProc.prototype.validate = function(){
	var success=true;
	var errMsg='';
	
	switch(this.ProcType){
		case 'create':
			var count=0;
			for(var i=0;i<this.Flow.Procs.length;i++){
				if(this.Flow.Procs[i].ProcType=='create')
					count++;
				if(count>1){
					errMsg+= wmsg.wfdesign.onlyOneCreate+'<br>'
					success = false;
					break;
				}
			}
			if(!this.Flow.hasNextProc(this.ID)){
				errMsg+=wmsg.wfdesign.noOutput+'<br>'
				success =false;
			}
			break;
		case 'process':
			var count=0;
			for(var i=0;i<this.Flow.Procs.length;i++){
				if(this.Flow.Procs[i].ProcType=='process')
					count++;
				if(count>1){
					//errMsg+=wmsg.wfdesign.onlyOneProcess+'<br>'
					//success = false;
					//break;
				}
			}
			if(!this.Flow.hasPriorProc(this.ID)){
				errMsg+=wmsg.wfdesign.noInput+'<br>'
				success = false;
			}
			break;
		case 'realize':
		case 'child':
			if(!this.Flow.hasPriorProc(this.ID)){
				errMsg+=wmsg.wfdesign.noInput+'<br>'
				success = false;
			}
			if(!this.Flow.hasNextProc(this.ID)){
				errMsg+=wmsg.wfdesign.noOutput+'<br>'
				success =false;
			}
			break;
		case 'approve':
			var fromCount = this.Flow.getPriorProc(this.ID);
			var toCount = this.Flow.getNextProc(this.ID);
			if(fromCount<1){
				errMsg+=wmsg.wfdesign.noInput+'<br>'
				success =false;
			}
			if(toCount<1){
				errMsg+=wmsg.wfdesign.noOutput+'<br>'
				success =false;
			}
			if(toCount<2){
				errMsg+=wmsg.wfdesign.approveTwoMoreOutput+'<br>'
				success =false;
			}
			break;
		case 'fork':
			if(!this.Flow.hasPriorProc(this.ID)&&this.nodetype!=0){
				errMsg+=wmsg.wfdesign.noInput+'<br>'
				success = false;
			}
			var toCount = this.Flow.getNextProc(this.ID);
			if(toCount<2){
				errMsg+=wmsg.wfdesign.forkTwoMoreOutput+'<br>'
				success =false;
			}
			break;
		case 'join':
			if(!this.Flow.hasNextProc(this.ID)&&this.nodetype!=3){
				errMsg+=wmsg.wfdesign.noOutput+'<br>'
				success =false;
			}
			var fromCount = this.Flow.getPriorProc(this.ID);
			if(fromCount<2){
				errMsg+=wmsg.wfdesign.joinTwoMoreInput+'<br>'
				success =false;
			}
			break;	
	}
	//alert(success)
	if(!success){
		errMsg = this.showError(errMsg);
	}
	return errMsg;
}

TProc.prototype.showError = function(errMsg){
	document.all(this.ID).imagedata.src = this.Flow.Config._ImgPath+"wrong_wev8.gif";
	return "<B>"+this.Text+"</B>:"+"<br>"+errMsg;
}

TProc.prototype.getInnerObject = function() {
	if (this.InnerObject == null)
		this.InnerObject = document.all(this.ID);
	return this.InnerObject;
}

TProc.prototype.lostFocus = function() {
	this.isSelect = false
	if(document.all(this.ID)!=null){
		document.all(this.ID).imagedata.src = this.Flow.Config._ImgPath+"background_wev8.gif";
	}
}

TProc.prototype.setSelected=function(){
	this.isSelect = true;
	document.all(this.ID).imagedata.src = this.Flow.Config._ImgPath+"hight_wev8.gif";
}

TProc.prototype.resetBranchInfo=function(){
	this.Fork = '';
	this.Join = '';
	this.branchCount = 0;
	this.branchNO = 0;
	this.isFork = false;
	this.isJoin = false;
	this.hasFromSet = false;
	this.hasToSet = false;
}

TProc.prototype.clone = function(AProc) {
	this.Flow = AProc.Flow;
	this.ID = AProc.ID;
	this.Text = AProc.Text;
	this.ShapeType = AProc.ShapeType
	this.ProcType = AProc.ProcType;
	this.Width = AProc.Width;
	this.Height = AProc.Height;
	this.X = AProc.X;
	this.Y = AProc.Y;
	this.TextWeight = AProc.TextWeight;
	this.StrokeWeight = AProc.StrokeWeight;
	this.zIndex = AProc.zIndex;
	this.InnerObject = AProc.InnerObject;
	this.Img = AProc.Img;
	this.MoveType = "";
	this.Fork = AProc.Fork;
	this.Join = AProc.Join;
	this.isFork = AProc.isFork;
	this.isJoin = AProc.isJoin;
	this.branchNO = AProc.branchNO;
	this.branchCount = AProc.branchCount;
	this.passtype = AProc.passtype;
	this.mustPassStep = AProc.mustPassStep;
	this.isNew = AProc.isNew;
	//start_td19600
	this.hasNodePro = AProc.hasNodePro;//节点是否有节点属性
	this.hasCusRigKey = AProc.hasCusRigKey;//节点是否有自定义右键按钮
	this.hasNodeBefAddOpr = AProc.hasNodeBefAddOpr;//节点是否有节点前附加操作
	this.hasNodeAftAddOpr = AProc.hasNodeAftAddOpr;//节点是否有节点后附加操作
	this.hasLogViewSco = AProc.hasLogViewSco;//节点是否有日志查看范围
	this.hasNodeForFie = AProc.hasNodeForFie;//节点是否有节点表单字段
	//end_td19600
}

TProc.prototype.setPropValue = function(AProp, AValue) {

	switch (AProp) {
		case "X" :
			this.X = AValue;
			document.all(this.ID).style.left = AValue;
			break;
		case "Y" :
			this.Y = AValue;
			document.all(this.ID).style.top = AValue;
			break;
		case "Width" :
			this.Width = AValue;
			document.all(this.ID).style.width = AValue;
			break;
		case "Height" :
			this.Height = AValue;
			document.all(this.ID).style.height = AValue;
			break;
	}
}
// [任务]字符串化函数
TProc.prototype.toString = function() {
	var cl = this.Flow.Config;
	var nStockeColor, nTextColor;
	var nSC1, nSC2;
	nSC1 = cl.ProcColor1;
	nSC2 = cl.ProcColor2
	
	var arrVal = new Array();
	arrVal["id"] = this.ID;
	arrVal["title"] = this.Text
	arrVal["st"] = this.ProcType;
	arrVal["l"] = this.X;
	arrVal["t"] = this.Y;
	arrVal["w"] = this.Width;
	arrVal["h"] = this.Height;
	arrVal["z"] = this.zIndex;
	arrVal["sw"] = this.StrokeWeight;
	arrVal["fsc"] = cl.ProcFocusedStrokeColor;
	arrVal["shadowenable"] = cl.IsProcShadow;
	arrVal["shadowcolor"] = cl.ProcShadowColor;
	arrVal["3denable"] = cl.IsProc3D;
	arrVal["3ddepth"] = cl.Proc3DDepth;
	arrVal["sc1"] = nSC1;
	arrVal["sc2"] = nSC2;
	arrVal["tc"] = nTextColor;
	arrVal["fs"] = this.TextWeight;
	arrVal["text"] = this.Text;
	arrVal["img"] = this.Img;
	// 新增
	arrVal["af"] = this.actFlag;
	arrVal["wt"] = this.waittime;
	arrVal["ist"] = this.isSltTrans;
	arrVal["isc"] = this.isSameCredit;
	
	return stuffShape(getShapeVal(this.ShapeType), arrVal);
}
TProc.prototype.isRepeat = function(AProc){
	//TODO
	var isRepeat = true;
	var fromX = parseInt(this.X)
	var fromY = parseInt(this.Y);
	var fromW = parseInt(this.Width);
	var fromH = parseInt(this.Height);
	var toX = parseInt(AProc.X)
	var toY = parseInt(AProc.Y);
	var toW = parseInt(AProc.Width);
	var toH = parseInt(AProc.Height);
	
	if(toX+toW<fromX||toX>fromX+fromW||toY+toH<fromY||toY>fromY+fromH){
		isRepeat = false
	}
	return isRepeat;
}

TProc.prototype.showRepeat = function(){
	document.all(this.ID).imagedata.src = this.Flow.Config._ImgPath+"wrong_wev8.gif";
}

// [路径]类定义
function TStep(AFlow, id) {
	this.ObjType = "Step";
	this.Flow = AFlow;
	this.ID = id;
	this.Text = "";
	this.ShapeType = "Line";
	this.FromProc = "";
	this.ToProc = "";
	this.Points = "";
	this.BasePoints = "";
	this.Cond = "";
	this.StartArrow = "none";
	this.EndArrow = "Classic";
	this.TextWeight = "9pt";
	this.StrokeWeight = "1.5";
	this.zIndex = 10000;
	this.InnerObject = null;
	this.PointObjs=[];
	this.PointObjsID={};
	this.TText=null
	// 新增
	this.fromRelX = 0;
	this.fromRelY = 0;
	this.toRelX = 0;
	this.toRelY = 0;
	this.PointID=0;
	
	//生成编号
	this.isBuildCode = false;
	
	this.canReject = false;
	this.isReject= false;
	//提示信息
	this.RemindMsg ="";
	this.directionFrom=""
	this.directionTo ="";
	
	//是否有附件规则
	this.hasRole = false;
	//是否有出口条件
	this.hasCondition = false;
	this.branchNO = 0;
	
	this.isMustPass = 0;
	this.isFocus = false;
	
	//是否未保存出口
	this.isNew = "false";
}

TStep.prototype.branchValidate = function(fromProc,toProc){
	var success = true;
	var fromProc = this.Flow.getProcByID(fromProc);
	var toProc =this.Flow.getProcByID(toProc);
	//TODO
	/*if(fromProc.Fork!=''&&toProc.Fork!=''){
		if(fromProc.isFork||){
			
		}
		if(fromProc.isJoin){
			
		}
	}
	
	if(toProc.isFork){
		
	}
	
	if(fromProc.isJoin||toProc.isJoin){
		
	}
	*/
	
	//case 1
	//fromProc.!isFork && toProc
	
	
	
	
	if((fromProc.Fork!=''||toProc.Join!='')&&!fromProc.isJoin&&fromProc.Fork!=''&&!toProc.isJoin){
		if(toProc.isFrok&&!fromProc.isJoin){
			success = false;
		}else if(fromProc.Fork!=toProc.Fork&&fromProc.Fork!=''&&toProc.Fork!=''&&fromProc.Join!=''&&toProc.Join!=''){
			success = false;
		}else if(!fromProc.isFork&&fromProc.branchNO!=toProc.branchNO&&toProc.ProcType!='join'&&toProc.Fork !=''&&toProc.Join !=''){
			success = false;
		}	
	}
	return success;
}

TStep.prototype.getMinY = function(){
	var minY = 10000;
	if(this.PointObjs.length==0){
		return false;
	}
	for(var i =0; i<this.PointObjs.length;i++){
		if(parseInt(document.all(this.PointObjs[i].ID).style.top)<minY){
			minY = parseInt(document.all(this.PointObjs[i].ID).style.top);
		}
	}
	return minY;
	
}

TStep.prototype.getMinX = function(){
	var minX = 10000;
	if(this.PointObjs.length==0){
		return false;
	}
	for(var i =0; i<this.PointObjs.length;i++){
		if(parseInt(document.all(this.PointObjs[i].ID).style.left)<minX){
			minX = parseInt(document.all(this.PointObjs[i].ID).style.left);
		}
	}
	return minX;
	
}

TStep.prototype.setTTextPoint = function(AText){
	var arrPoint = this.getPath().split(',');
	var _X =0;
	var _Y =0;
	for(var i =0;i<arrPoint.length;i++){
		if(i%2==0){
			_X+=parseInt(arrPoint[i])
		}else{
			_Y+=parseInt(arrPoint[i])
		}
	}
	_X = _X/(arrPoint.length/2)
	_Y = _Y/(arrPoint.length/2)
	if(arrPoint.length/2==2){
		_Y = _Y-10;
	}	
	AText.X = _X+'pt';
	AText.Y = _Y+'pt';
}

TStep.prototype.getMaxPointID = function() {
	this.PointID++;
	return this.ID+'point'+this.PointID;
}

TStep.prototype.removePointByID = function(ID) {
	if(type!="edit"){
		return;
	}
	for(var i=0;i<this.PointObjs.length;i++){
		if(this.PointObjs[i].ID ==ID){
			var point = document.getElementById(this.PointObjs[i].ID)
			if(point!=null){
				point.outerHTML='';
			}
			this.PointObjs.remove(this.PointObjs[i])
		}
	}
}

TStep.prototype.clone = function(AStep) {
	this.Flow =AStep.Flow;
	this.ID = AStep.ID;
	this.Text = AStep.Text;
	this.ShapeType = AStep.ShapeType;
	this.FromProc = AStep.FromProc;
	this.ToProc = AStep.ToProc;
	this.Points = AStep.Points;
	this.Cond = AStep.Cond;
	this.StartArrow = AStep.StartArrow;
	this.EndArrow = AStep.EndArrow;
	this.TextWeight = AStep.TextWeight;
	this.StrokeWeight = AStep.StrokeWeight;
	this.zIndex = AStep.zIndex;
	this.fromRelX = AStep.fromRelX;
	this.fromRelY = AStep.fromRelY;
	this.toRelX = AStep.toRelX;
	this.toRelY = AStep.toRelY;
	this.PointObjs = AStep.PointObjs.clone('Point');
	this.BasePoints = AStep.BasePoints;
	this.InnerObject = AStep.InnerObject;
	//td19600
	this.hasRole = AStep.hasRole;
	this.hasCondition = AStep.hasCondition;
	//endtd19600
	if(this.TText!=null){
		this.TText.clone(AStep.TText);
	}else{
		this.TText=AStep.TText;
	}
	this.directionFrom = AStep.directionFrom;
	this.directionTo = AStep.directionTo;
	this.branchNO = AStep.branchNO;
	this.isMustPass = AStep.isMustPass;
	this.hasRole = AStep.hasRole;
	this.hasCondition = AStep.hasCondition;
	this.isNew = AStep.isNew;
}

TStep.prototype.setPropValue = function(AProp, AValue) {
	switch (AProp) {
		case "Points" :
			this.Points = AValue;
			break;
		case "FromProc" :
			this.FromProc = AValue;
			break;
		case "ToProc" :
			this.ToProc = AValue;
			break;
	}
}

// [路径]字符串化函数
TStep.prototype.toString = function() {
	
	var StepHTML = '';
	var cl = this.Flow.Config;
	var arrVal = new Array();
	arrVal["id"] = this.ID;
	arrVal["title"] = this.Text;
	arrVal["sc"] = cl.StepColor;
	arrVal["pt"] = this.getPath();
	arrVal["z"] = this.zIndex;
	arrVal["sw"] = this.StrokeWeight;
	arrVal["fsc"] = cl.StepFocusedStrokeColor;
	arrVal["sa"] = this.StartArrow;
	arrVal["ea"] = this.EndArrow;
	arrVal["cond"] = this.Cond;
	arrVal["text"] = this.Text;
	
	StepHTML =  stuffShape(getShapeVal(this.ShapeType), arrVal);
	
	for(var i =0;i<this.PointObjs.length;i++){
		StepHTML+=this.PointObjs[i].toString()
	}
	if(this.TText!=null){
		StepHTML+=this.TText.toString();
	}
	
	return StepHTML+this.getStartAndEndPoint();
}

TStep.prototype.getInnerObject = function() {
	if (this.InnerObject == null)
		this.InnerObject = document.all(this.ID);
	return this.InnerObject;
}

TStep.prototype.setFocus = function() {
	this.isFocus = true;
	document.all(this.ID).StrokeWeight = 2
	document.all(this.ID).StrokeColor = this.Flow.Config.StepFocusedStrokeColor;
	//当出口线条得到焦点时，自动显示自身的两个端点，方便对端点的移动操作
	showPoint(this.ID);
}

TStep.prototype.setError = function() {
	
	document.all(this.ID).StrokeWeight = 2
	document.all(this.ID).StrokeColor = 'red';
}


TStep.prototype.lostFocus = function() {
	//当出口线条丢失焦点时，隐藏自身的两个端点
	hidePoint(this.ID);
	this.isFocus = false;
	this.setStepInfo();
	//this.isFocus = false;
	//document.all(this.ID).StrokeWeight = 1.5;
	//document.all(this.ID).StrokeColor = this.Flow.Config.StepColor;
}

TStep.prototype.setStepInfo = function(){
	try{
	if(this.hasRole&&this.hasCondition){
		document.all(this.ID).StrokeWeight = 2
		document.all(this.ID).StrokeColor = '#04C93C';
	}else if(this.hasRole&&!this.hasCondition){
		document.all(this.ID).StrokeWeight = 2
		document.all(this.ID).StrokeColor = '#0584E6';
	}else if(!this.hasRole&&this.hasCondition){
		document.all(this.ID).StrokeWeight = 2
		document.all(this.ID).StrokeColor = '#003399';
	}else if(!this.hasRole&&!this.hasCondition&&!this.isFocus){
		document.all(this.ID).StrokeWeight = 1.5;
		document.all(this.ID).StrokeColor = this.Flow.Config.StepColor;
	}else if(!this.hasRole&&!this.hasCondition&&this.isFocus){
		this.setFocus();
	}
	}catch(e){}
}

TStep.prototype.getStartAndEndPoint =function(){
	var strHtml = '';
	var arrPoints = changePtToPx(this.Points).split(',');
	var start = new TPoint(this);
	var end = new TPoint(this);
	start.ID = this.ID+'StartPoint';
	end.ID =  this.ID+'EndPoint';
	start.X = arrPoints[0];
	start.Y = parseInt(arrPoints[1])-2+'';
	start.StrokeColor ='red';
	start.FillColor = 'red'
	start.Width = '4px';
	start.Height = '4px';
	start.Display = 'none';
	end.X = parseInt(arrPoints[arrPoints.length-2])-4+'';
	end.Y = parseInt(arrPoints[arrPoints.length-1])-2+'';
	end.StrokeColor ='red';
	end.FillColor = 'red'
	end.Width = '4px';
	end.Height = '4px';
	end.Display = 'none';
	strHtml = start.toString()+end.toString();
	
	return strHtml;
	
}

/**
 * 流程图类定义
 * @param {} AName
 */
function TTopFlow(AName) {
	this.name = AName;
	this.ID = "";
	this.Text = "";
	this.FileName = "";
	this.FormID = "";
	this.IsBill = 0;
	this.IsCust = 0;
	this.Modified = false;
	this.Type = "";
	this.Steps = [];
	this.Procs = [];
	this.SelectBox=null;
	this.SelectedObject = null;
	this.Password = "";
	this.delNodeIDs = "";
	this.delStepIDs = "";
	this.hasCreate=false;
	this.procNumber = 0;
	this.stepNumber = 0;
	this.Config = {
		_ProcColor : "#000000", // 开始/结束
		_ProcTextColor : "#000000", // 开始/结束
		ProcColor : "#999",
		ProcTextColor : "#0000FF",
		ProcFocusedStrokeColor : "#628BD9",
		ProcSelectedStrokeColor: "#628BD9",
		IsProcShadow : "T",
		ProcShadowColor : "#B3B3B3",
		ProcColor1 : "#FFFFFF",
		ProcColor2 : "#FFFFFF",
		IsProc3D : "F",
		Proc3DDepth : "20",
		StepFocusedStrokeColor : "#628BD9",
		StepColor : "#000000",
		_ImgPath: "/images/wfdesign/"
	}
}

TTopFlow.prototype.setAllStepInfo = function(){
	for (var i = 0; i < this.Steps.length; i++){
		this.Steps[i].setStepInfo();
	
	}
		
}

/**
 * 流程图转化为XML文件
 * @return {}
 */
TTopFlow.prototype.parseTTopFlowToXML = function(){
	var xmlDoc = new ActiveXObject('MSXML2.DOMDocument');
	xmlDoc.async = false;
	xmlDoc.loadXML('<?xml version="1.0" encoding="UTF-8"?><TopFlow/>');
	
	var xmlRoot = xmlDoc.documentElement;
	var xmlNodeGrp, xmlNode, xmlNode2;
	xmlRoot.setAttribute("id", this.ID);
	xmlRoot.setAttribute("formid", this.FormID);// 新增
	xmlRoot.setAttribute("isBill",this.IsBill);
	xmlRoot.setAttribute("isCust",this.IsCust);
	xmlRoot.setAttribute("delStepIds",this.delStepIDs);
	xmlRoot.setAttribute("delNodeIds",this.delNodeIDs);
	
	// Save Proc
	var xmlNodeGrp = xmlDoc.createNode(1, "Procs", "");
	xmlRoot.appendChild(xmlNodeGrp);
	for (var i = 0; i < this.Procs.length; i++) {
		Proc = this.Procs[i];
		xmlNode = xmlDoc.createNode(1, "Proc", "");
		xmlNode2 = xmlDoc.createNode(1, "BaseProperties", "");
		xmlNode2.setAttribute("id", Proc.ID.substr(0,Proc.ID.length-1));
		xmlNode2.setAttribute("text", Proc.Text);
		
		xmlNode2.setAttribute("isNew",Proc.isNew);
		xmlNode2.setAttribute("procType", Proc.ProcType);
		xmlNode2.setAttribute("nodetype", Proc.nodetype);
		if(Proc.isFork){
			xmlNode2.setAttribute("nodeattribute", 1);
		}else if(Proc.isJoin){
			xmlNode2.setAttribute("nodeattribute", Proc.passtype+"");
			xmlNode2.setAttribute("passNum", Proc.PassNum);
		//}else if(Proc.Fork!=''&&Proc.Join!=''){
		}else if((Proc.Fork!=''&&Proc.Join!='') || Proc.nodeattribute == "2"){
			xmlNode2.setAttribute("nodeattribute", 2);
		}else {
			//xmlNode2.setAttribute("nodeattribute", 0);
			xmlNode2.setAttribute("nodeattribute", Proc.nodeattribute);
		}
		
		xmlNode.appendChild(xmlNode2);

		xmlNode2 = xmlDoc.createNode(1, "VMLProperties", "");
		xmlNode2.setAttribute("shapetype", Proc.ShapeType);
		xmlNode2.setAttribute("width", Proc.Width);
		xmlNode2.setAttribute("height", Proc.Height);
	
		xmlNode2.setAttribute("x", Proc.X);
		xmlNode2.setAttribute("y", Proc.Y);
		
		xmlNode2.setAttribute("zIndex", Proc.zIndex);
		xmlNode.appendChild(xmlNode2);

		xmlNodeGrp.appendChild(xmlNode);
	}
	
	// Save Step
	xmlNodeGrp = xmlDoc.createNode(1, "Steps", "");
	
	xmlRoot.appendChild(xmlNodeGrp);
	for (i = 0; i < this.Steps.length; i++) {
		Step = this.Steps[i];
		Step.getRelNumber();
		xmlNode = xmlDoc.createNode(1, "Step", "");
		xmlNode2 = xmlDoc.createNode(1, "BaseProperties", "");
		xmlNode2.setAttribute("id", Step.ID.substr(0,Step.ID.length-1));
		xmlNode2.setAttribute("text", Step.Text);
		xmlNode2.setAttribute("isNew",Step.isNew);
		xmlNode2.setAttribute("from", Step.FromProc.substr(0,Step.FromProc.length-1));
		xmlNode2.setAttribute("to", Step.ToProc.substr(0,Step.ToProc.length-1));
		xmlNode2.setAttribute("remindMsg",Step.RemindMsg)
		xmlNode2.setAttribute("isBuildCode",Step.isBuildCode+"");
		xmlNode2.setAttribute("isreject",Step.isReject+"");
		
		xmlNode2.setAttribute("ismustpass",Step.isMustPass+"");
		xmlNode2.setAttribute("directionfrom", Step.directionFrom);
		xmlNode2.setAttribute("directionto", Step.directionTo);
		xmlNode.appendChild(xmlNode2);

		xmlNode2 = xmlDoc.createNode(1, "VMLProperties", "");
		xmlNode2.setAttribute("points", changePtToPx(Step.Points));
		xmlNode2.setAttribute("shapetype", Step.ShapeType);
		xmlNode2.setAttribute("zIndex", Step.zIndex+'');
		xmlNode2.setAttribute("fromRelX", Step.fromRelX);
		xmlNode2.setAttribute("fromRelY", Step.fromRelY);
		xmlNode2.setAttribute("toRelX", Step.toRelX);
		xmlNode2.setAttribute("toRelY", Step.toRelY);
		xmlNode.appendChild(xmlNode2);

		xmlNodeGrp.appendChild(xmlNode);
	}
	return xmlDoc;
}

/**
 * 获取流程对应的XML内容
 * @return {}
 */
TTopFlow.prototype.getXmlContent = function(){
	var xmlDoc = this.parseTTopFlowToXML();
	return xmlDoc.xml;
}

TTopFlow.prototype.resetBranchInfo = function(){
	for(var i=0;i<this.Procs.length;i++){
		this.Procs[i].resetBranchInfo();
	}
}
/**
 * 设置流程中分支信息
 */
TTopFlow.prototype.getBranchInfo = function(){
	this.resetBranchInfo();
	var createProc = this.getCreateProc();
	if(createProc!=null){
		createProc.hasFromSet = true;
		var arrStep = this.getStepsByFromProc(createProc);
		this.setBranchInfoByFromProcStep(arrStep);
	}
	var processProcAry = this.getProcessProc();
	for(var i=0;i<processProcAry.length;i++){
	var processProc = processProcAry[i]
		if(processProc!=null){
			processProc.hasToSet = true
			var arrStep = this.getStepsByToProc(processProc);
			this.setBranchInfoByToProcStep(arrStep);
		}
	}
}

/**
 * 正向设置流程的分叉节点信息
 * @param {} arrStep
 */
TTopFlow.prototype.setBranchInfoByFromProcStep = function(arrStep){
	for(var i=0;i<arrStep.length;i++){
		var step = arrStep[i];
		
		var fromProc = this.getProcByID(step.FromProc)
		var toProc = this.getProcByID(step.ToProc)
		
		if(fromProc.ProcType =='fork'){
			fromProc.isFork = true;
			fromProc.Fork = fromProc.ID;
			fromProc.branchCount++;
			step.branchNO = fromProc.branchCount;
			if(toProc.ProcType!='process'){
				toProc.Fork = fromProc.ID;
				toProc.branchNO = step.branchNO;
			}
		}else if(fromProc.Fork !=''&& !fromProc.isJoin&&fromProc.ProcType !='join'){
			step.branchNO = fromProc.branchNO;
			if(toProc.ProcType!='process'){	
				toProc.Fork = fromProc.Fork;
				toProc.branchNO = fromProc.branchNO;
			}
		}
		fromProc.hasFromSet = true;
		if(toProc.hasFromSet == false)
			this.setBranchInfoByFromProcStep(this.getStepsByFromProc(toProc));
	}
} 

/**
 * 逆向设置流程的合并节点信息
 * @param {} arrStep
 */
TTopFlow.prototype.setBranchInfoByToProcStep = function(arrStep){
	for(var i=0;i<arrStep.length;i++){
		var step = arrStep[i];
		var fromProc = this.getProcByID(step.FromProc)
		var toProc = this.getProcByID(step.ToProc)
		
		if(toProc.ProcType =='join'){
			toProc.isJoin = true;
			toProc.Join = toProc.ID;
			toProc.branchCount++;
			if(toProc.ProcType!='create'){
				fromProc.Join = toProc.ID;
				
			}
		}else if(toProc.Join !=''&& !toProc.isFork&&toProc.ProcType !='fork'){
			if(toProc.ProcType!='create'){			
				fromProc.Join = toProc.Join;
			}
		}
		toProc.hasToSet = true;
		if(fromProc.hasToSet == false)
			this.setBranchInfoByToProcStep(this.getStepsByToProc(fromProc));
	}
}
/**
 * 获取流程创建节点
 * @return {}
 */
TTopFlow.prototype.getCreateProc = function(){
	for(var i=0;i<this.Procs.length;i++){
		if(this.Procs[i].ProcType == "create" || this.Procs[i].nodetype==0){
			return this.Procs[i]
		}
	}
}

/**
 * 获取流程归档节点
 * @return {}
 */
TTopFlow.prototype.getProcessProc = function(){
	var arrProc = new Array();
	for(var i=0;i<this.Procs.length;i++){
		if(this.Procs[i].ProcType == "process"||this.Procs[i].nodetype==3){
			arrProc[arrProc.length]= this.Procs[i]
		}
	}
	return arrProc;
}

/**
 * 根据节点获取以其为起始节点的所有出口
 * @param {} AProc
 * @return {}
 */
TTopFlow.prototype.getStepsByFromProc = function(AProc){
	var arrStep = [];
	
	for(var i=0;i<this.Steps.length;i++){
		if(this.Steps[i].FromProc == AProc.ID){
			arrStep[arrStep.length]=this.Steps[i];
		}
	}

	return arrStep;
}
/**
 * 根据节点获取以其作为目标节点的所有出口
 * @param {} AProc
 * @return {}
 */
TTopFlow.prototype.getStepsByToProc = function(AProc){
	var arrStep = [];
	
	for(var i=0;i<this.Steps.length;i++){
		if(this.Steps[i].ToProc == AProc.ID){
			arrStep[arrStep.length]=this.Steps[i];
		}
	}

	return arrStep;
}

//
TTopFlow.prototype.getInnerObject = function() {
	for (var i = 0; i < this.Procs.length; i++)
		this.Procs[i].getInnerObject();
	for (i = 0; i < this.Steps.length; i++){
		this.Steps[i].getInnerObject();
	}
}

// 清除流程图的内容
TTopFlow.prototype.clear = function() {
	this.FileName = '';
	this.hasCreate = false;
	this.Steps.length = 0;
	this.Procs.length = 0;
}

// 新建流程图
TTopFlow.prototype.createNew = function(AName) {
	this.clear();
//TODO 待定
}

TTopFlow.prototype.getProcNameByType = function (type){
	var name='';
	switch(type){
		case 'create':
			name = wmsg.wfdesign.create;
			break;
		case 'process':
			name = wmsg.wfdesign.process;
			break;
		case 'realize':
			name = wmsg.wfdesign.realize;
			break;
		case 'child':
			name = wmsg.wfdesign.child;
			break;
		case 'approve':
			name = wmsg.wfdesign.approve;
			break;
		case 'fork':
			name = wmsg.wfdesign.fork;
			break;
		case 'join':
			name = wmsg.wfdesign.join;
			break;
	}
	return name;
}

// 添加流程图的[任务]元素对象
TTopFlow.prototype.addProc = function(AProc) {
	if(AProc.ProcType =="fork"){
		AProc.isFork = true;
		AProc.Fork = AProc.ID;
	}else if(AProc.ProcType=="join"){
		AProc.isJoin = true;
		AProc.Join = AProc.ID;
	}
	this.Modified = true;
	this.Procs[this.Procs.length] = AProc;
	var id = AProc.ID;
	this.delNodeIDs = this.delNodeIDs.replace(","+id.substr(0,id.length-1),"");
	
	this.procNumber++;
	//alert("this.delNodeIDs=="+this.delNodeIDs)
}

// 添加流程图的[路径]元素对象
TTopFlow.prototype.addStep = function(AStep) {
	this.Steps[this.Steps.length] = AStep;
	var id = AStep.ID;
	this.delStepIDs = this.delStepIDs.replace(","+id.substr(0,id.length-1),"");
	this.Modified = true;
	this.stepNumber++;
	//alert("this.delStepIDs=="+this.delStepIDs)
}


TTopFlow.prototype.hasPriorProc = function(AProcID) {
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].ToProc == AProcID)
			return true;
	return false;
}

TTopFlow.prototype.getPriorProc = function(AProcID) {
	var count =0;
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].ToProc == AProcID)
			count++;
	return count;
}

TTopFlow.prototype.hasNextProc = function(AProcID) {
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].FromProc == AProcID)
			return true;
	return false;
}

TTopFlow.prototype.getNextProc = function(AProcID) {
	var count =0;
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].FromProc == AProcID)
			count++;
	return count;
}

TTopFlow.prototype.getJoinByFork = function(join){
	var arrProc = new Array();
	for(var i =0;i<this.Procs.length;i++){
		if(this.Procs[i].isJoin&&this.Procs[i].Join == join){
			arrProc[arrProc.length]= this.Procs[i]
		}
	}
	
	return arrProc;
}

TTopFlow.prototype.getForkByJoin = function(fork){
	var arrProc = new Array();
	for(var i =0;i<this.Procs.length;i++){
		if(this.Procs[i].isFork && this.Procs[i].Fork == fork){
			arrProc[arrProc.length]= this.Procs[i]
		}
	}
	
	return arrProc;
}

/**
 * 流程分叉节点验证
 * @return {Boolean}
 */
TTopFlow.prototype.branchValidate = function(){	
	
	this.showRepeatItems()
	var success =true;
	var msg = '';
	for(var i =0;i<this.Procs.length;i++){
		if(this.Procs[i].isFork){
			var joinProc = this.getJoinByFork(this.Procs[i].Join)
		
			if(joinProc.length>1){
				success = false;
				msg ="1"
			} else if(joinProc.length<1){
				msg ="2"
				success = false;
			}else if(joinProc[joinProc.length-1].Fork!=this.Procs[i].Fork){
				success = false;
				msg ="3"
			}
		}
		
		if(this.Procs[i].isJoin){
			var forkProc = this.getForkByJoin(this.Procs[i].Fork)
			if(forkProc.length>1){
				success = false;
				msg ="4"
			} else if(forkProc.length<1){
				success = false;
				msg ="5"
			}else if(forkProc[0].Fork!=this.Procs[i].Fork){
				success = false;
				msg ="6"
			}
		}
		
		
	}
	
	for(var i=0;i<this.Steps.length;i++){
		if(this.Steps[i].branchNO !=0){
			var fromProc = this.getProcByID(this.Steps[i].FromProc);
			var toProc = this.getProcByID(this.Steps[i].ToProc);
			if((fromProc.Fork!=toProc.Fork||fromProc.Join!=toProc.Join||fromProc.branchNO!=toProc.branchNO)&&(!fromProc.isJoin||!toProc.isJoin)){
				if(!fromProc.isFork&&fromProc.isJoin&&!toProc.isFork&&toProc.isJoin){
					msg ="7"
					success = false
				}
			}
		}
	}
	return success;
}

/**
 * 流程合法性验证
 * @return {Boolean}
 */
TTopFlow.prototype.validate = function(showMessage) {
	var success = true;
	var errMsg ='';
	if(showMessage == undefined){
		showMessage = true;
	}
	for (var i = 0; i < this.Procs.length; i++) {
		errMsg += this.Procs[i].validate();
	}
	if(errMsg==''){
		this.getBranchInfo();
		success = this.branchValidate();
	}
	
	if(errMsg==''&& success){
		if(showMessage){
			parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.validateSuccess,3,"T")
		}
	}else{
		success = false;
		if(showMessage){
			parent.showMessage(wmsg.wfdesign.error,errMsg,3,"T")
		}
	}
	return success
}

TTopFlow.prototype.parseXMLToTTopFlow=function(xmlDoc){
	var xmlRoot = xmlDoc.documentElement;
	this.ID = xmlRoot.getAttribute("id");
	this.IsBill = xmlRoot.getAttribute("isBill");
	this.IsCust = xmlRoot.getAttribute("isCust");
	this.FormID = xmlRoot.getAttribute("formid");
	this.Text = xmlRoot.getAttribute("text");
	this.name = this.Text;
	// Load Proc
	var Procs = xmlRoot.getElementsByTagName("Procs").item(0);
	var id, oNode, Prop;
	
	for (i = 0; i < Procs.childNodes.length; i++) {
		
		var Proc = Procs.childNodes.item(i);
		Prop = Proc.getElementsByTagName("BaseProperties").item(0);
		id = Prop.getAttribute("id")+'P';
		oNode = new TProc(this, id, Prop.getAttribute("procType"));
		if(Prop.getAttribute("procType")=='create'|| parseInt(Prop.getAttribute("nodetype"))==0){
			this.hasCreate = true;			
		}
		oNode.nodetype = Prop.getAttribute("nodetype");
		oNode.passtype = parseInt(Prop.getAttribute("passtype"));
		oNode.Text = Prop.getAttribute("text");
	//start_td19600
		if(Prop.getAttribute("hasNodePro") == "true") {
			oNode.hasNodePro = true;
		}
		if(Prop.getAttribute("hasCusRigKey") == "true") {
			oNode.hasCusRigKey = true;
		}
		if(Prop.getAttribute("hasNodeBefAddOpr") == "true") {
			oNode.hasNodeBefAddOpr = true;
		}
		if(Prop.getAttribute("hasNodeAftAddOpr") == "true") {
			oNode.hasNodeAftAddOpr = true;
		}
		
		if(Prop.getAttribute("hasLogViewSco") == "true") {
			oNode.hasLogViewSco = true;
		}
		if(Prop.getAttribute("hasNodeForFie") == "true") {
			oNode.hasNodeForFie = true;
		}
		//end_td19600
		//oNode.ProcType = Prop.getAttribute("procType");
		oNode.Img = this.Config._ImgPath+oNode.ProcType+'_wev8.gif';
		// 新增
		//oNode.actFlag = Prop.getAttribute("actFlag");
		//oNode.waittime = Prop.getAttribute("waittime");
		//oNode.isSltTrans = Prop.getAttribute("isSltTrans");
		//oNode.isSameCredit = Prop.getAttribute("isSameCredit");

		Prop = Proc.getElementsByTagName("VMLProperties").item(0);
		oNode.ShapeType = Prop.getAttribute("shapetype");
		oNode.Width = Prop.getAttribute("width");
		oNode.Height = Prop.getAttribute("height");
		oNode.X = Prop.getAttribute("x");
		oNode.Y = Prop.getAttribute("y");
		oNode.PassNum = Prop.getAttribute("passNum");
		oNode.nodeattribute = Prop.getAttribute("nodeattribute");
		
		//oNode.TextWeight = Prop.getAttribute("textWeight");
		//oNode.StrokeWeight = Prop.getAttribute("strokeWeight");
		oNode.zIndex = Prop.getAttribute("zIndex");
		if (oNode.zIndex == '')
			oNode.zIndex = this.getMinZIndex() - 1;
		this.addProc(oNode);
	}
	
	// Load Step
	var Steps = xmlRoot.getElementsByTagName("Steps").item(0);
	for (i = 0; i < Steps.childNodes.length; i++) {
	
		var Step = Steps.childNodes.item(i);
		Prop = Step.getElementsByTagName("BaseProperties").item(0);
		id = Prop.getAttribute("id")+'T';
		oNode = new TStep(this, id);
		oNode.Text = Prop.getAttribute("text");
		oNode.RemindMsg = Prop.getAttribute("remindMsg");
		oNode.isBuildCode = Prop.getAttribute("isBuildCode")=="true"
		oNode.TText = new TText(oNode);
		oNode.FromProc = Prop.getAttribute("from")+'P';
		oNode.ToProc = Prop.getAttribute("to")+'P';
		oNode.isReject = Prop.getAttribute("isreject");
		
		if(isNaN(parseInt(Prop.getAttribute("ismustpass")))){
			oNode.isMustPass = 0;
		}else{
			oNode.isMustPass = parseInt(Prop.getAttribute("ismustpass"));
		}

		//td19600
		if(Prop.getAttribute("hasRole") == "true"){
			oNode.hasRole  = true;
		}
		if(Prop.getAttribute("hasCondition") == "true"){
			oNode.hasCondition  = true;
		}
		//endtd19600
		
		if(oNode.isMustPass == 1){
			if(this.getProcByID(oNode.ToProc).mustPassStep!=''){
				this.getProcByID(oNode.ToProc).mustPassStep+=",";
			}
			this.getProcByID(oNode.ToProc).mustPassStep += Prop.getAttribute("id");
			
		}
		Prop = Step.getElementsByTagName("VMLProperties").item(0);
		oNode.Points = Prop.getAttribute("points");
		_LoadXml = true;
		oNode.getRelNumber();
		_LoadXml = false;
		if(oNode.ToProc == oNode.FromProc && oNode.Points.split(',').length<5){
			var proc = this.getProcByID(oNode.ToProc);
			oNode.getSelfPath(parseInt(proc.X),parseInt(proc.Y),parseInt(proc.Width),parseInt(proc.Height));
			oNode.BasePoints = oNode.Points;

		}else{
			
			oNode.BasePoints = oNode.Points;
			var arrPoint = oNode.Points.split(',');
			for(var j =2;j<arrPoint.length-2;j=j+2){
				var point = new TPoint(oNode);
				point.FillColor ='black'
				point.Height ='4px';
				point.ID = oNode.getMaxPointID();
				point.StrokeColor = 'white';
				point.Width ='4px';
				point.X = parseInt(arrPoint[j]-1)+'';
				point.Y = parseInt(arrPoint[j+1]-1)+'';
				
				oNode.PointObjs[oNode.PointObjs.length] = point;
			}
		}
		oNode.ShapeType = Prop.getAttribute("shapetype");
		if (oNode.zIndex == '')
			oNode.zIndex = this.getMinZIndex() - 1;
			
		this.addStep(oNode);
	}
}

// 从XML文件中载入流程图
TTopFlow.prototype.loadFromXML = function(xmlContent) {

	this.clear();
	//this.FileName = AFileName;

	var xmlDoc =  new ActiveXObject('MSXML2.DOMDocument');
	xmlDoc.async = false;
	
	var flag =xmlDoc.loadXML(xmlContent)
	
	if (!flag) {
		parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.loadFailure);
		return false;
	}
	
	this.parseXMLToTTopFlow(xmlDoc);
	this.Modified = false;
	parent.hasCreate = !this.hasCreate;
	this.getBranchInfo();
	return true;
}

TTopFlow.prototype.loadFromLocalXML = function(xmlName){
	this.clear();
	//this.FileName = AFileName;

	var xmlDoc = new ActiveXObject("Msxml2.DOMDocument.4.0");
	xmlDoc.async = false;
	xmlDoc.resolveExternals = false;
	
	//alert( xmlDoc.xml)
	//xmlDoc.async = false;
	var flag = true;
	try{
		alert(xmlName);
		flag = xmlDoc.load("c:\\aa.xml");
		alert( xmlDoc.xml);
	}catch(e){
		alert(e.message)
		return false;
	}
	if (!flag) {
		parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.loadFailure);
		return false;
	}
	
	this.parseXMLToTTopFlow(xmlDoc);
	this.Modified = false;
	parent.hasCreate = !this.hasCreate;
	this.getBranchInfo();
	return true;
}

// 将流程图保存至服务器上的XML文件中
TTopFlow.prototype.SaveToXML = function(AUrl) {
	var canSave = checkCanSave();
	if(canSave == false){
		alert("已操作保存流程图，请稍后再试。或关闭页面重新打开。");
		return;
	}
	// 出口名称为必填项
	for(var i=0; i<this.Steps.length;i++){
		if(this.Steps[i].Text.trim()==""){
			this.Steps[i].setFocus();
			parent.showMessage(wmsg.wfdesign.error, wmsg.wfdesign.notNull)
			setCanSave(true); //ypc 2012-09-13 如果不将数据保存到服务器上的时候 提示信息 条件判断有误 再次重置一下值
			return;
		}
	}
	
	if(!this.validate(false)){
		if(confirm(wmsg.wfdesign.validateFailure+','+wmsg.wfdesign.saveConfirm)){
		
		}else{
			parent.showMessage(wmsg.wfdesign.error, wmsg.wfdesign.validateFailure)
			setCanSave(true); //ypc 2012-09-13 如果不将数据保存到服务器上的时候 提示信息 条件判断有误 再次重置一下值
			return;
		}
	}
	if(!check_form('','')) return;
	//mask.show();
	var xmlDoc =this.parseTTopFlowToXML();
	var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	xmlHttp.onreadystatechange = function(){
		
		if (xmlHttp.readyState == 4) {
			try{
				eval(xmlHttp.responseText)
				
				if(result.status=='0'){
					document.getElementById("reload").click();
					emptyLog();
					mask.hide();
					setCanSave(true);
					parent.showMessage(wmsg.wfdesign.info,wmsg.wfdesign.saveSuccess);
					_FLOW.Modified = false;
				}else{
					mask.hide();
					//setCanSave(true);
					parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.saveFailure);
				}
			}catch(e){
				//setCanSave(true);
				parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.saveFailure);
			}
	    }else{
			//setCanSave(true);
		}
	}
	xmlHttp.open("POST", "/weaver/weaver.workflow.layout.WorkflowXmlParser", true);
	//xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xmlHttp.send(xmlDoc.xml);
}

// 根据[任务]的ID获取[任务]对象
TTopFlow.prototype.getProcByID = function(id) {
	for (var i = 0; i < this.Procs.length; i++)
		if (this.Procs[i].ID == id)
			return this.Procs[i];
	return null;
}

// 根据[路径]的ID获取[路径]对象
TTopFlow.prototype.getStepByID = function(id) {
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].ID == id)
			return this.Steps[i];
	return null;
}

// 获取当前选中的[路径]对象
TTopFlow.prototype.getFocusStep = function(){
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].isFocus)
			return this.Steps[i];
	return null;
}

TTopFlow.prototype.getProcAtXY = function(x, y) {
	var Proc;
	for (var i = 0; i < this.Procs.length; i++) {
		Proc = this.Procs[i];
		if (x >= parseInt(Proc.X)
				&& x <= parseInt(Proc.X) + parseInt(Proc.Width)
				&& y >= parseInt(Proc.Y)
				&& y <= parseInt(Proc.Y) + parseInt(Proc.Height)) {
			return Proc;
		}
	}
	return null;
}

TTopFlow.prototype.StepPathExists = function(FromProc, ToProc) {
	var Step;
	for (var i = 0; i < this.Steps.length; i++) {
		Step = this.Steps[i];
		if (Step.FromProc == FromProc && Step.ToProc == ToProc)
			return Step;
	}
	return null;
}

// 根据[任务]的ID删除[任务]对象
TTopFlow.prototype.deleteProcByID = function(id) {
	this.Modified = true;
	for (var i = 0; i < this.Procs.length; i++)
		if (this.Procs[i].ID == id){
			this.Procs.splice(i, 1);
			this.delNodeIDs+=','+id.substr(0,id.length-1);
			
			//alert("this.delNodeIDs=="+this.delNodeIDs)
			if(document.getElementById(id)!=null){
				document.getElementById(id).outerHTML = '';
			}
		}
		
	// 删除与些Proc关联的Step
	for (i = this.Steps.length - 1; i >= 0; i--)
		if (this.Steps[i].FromProc == id || this.Steps[i].ToProc == id){
			this.deleteStepByID(this.Steps[i].ID);
		}
}

// 根据[路径]的ID删除[路径]对象
TTopFlow.prototype.deleteStepByID = function(id) {
	this.Modified = true;
	for (var i = 0; i < this.Steps.length; i++)
		if (this.Steps[i].ID == id){
	
			this.delStepIDs+=','+id.substr(0,id.length-1);
			//alert("this.delStepIDs=="+this.delStepIDs)
			for(var j=0;j<this.Steps[i].PointObjs.length;j++){
				this.Steps[i].removePointByID(this.Steps[i].PointObjs[j].ID)
				j--;
			}
			this.Steps.splice(i, 1);
			if(document.getElementById(id)!=null){
				document.getElementById(id).outerHTML = '';
			}
		}
}

// 获取流程图最顶层的Z轴值
TTopFlow.prototype.getMaxZIndex = function() {
	var m = 0;
	for (var i = 0; i < this.Procs.length; i++)
		m = Math.max(m, this.Procs[i].zIndex);
	for (i = 0; i < this.Steps.length; i++)
		m = Math.max(m, this.Steps[i].zIndex);
	return m;
}

// 获取流程图最底层的Z轴值
TTopFlow.prototype.getMinZIndex = function() {
	var m = 0;
	for (var i = 0; i < this.Procs.length; i++)
		m = Math.min(m, this.Procs[i].zIndex);
	for (i = 0; i < this.Steps.length; i++)
		m = Math.min(m, this.Steps[i].zIndex);
	return m;
}

// 将一个流程图元素对象移至最上层
TTopFlow.prototype.brintToFront = function(obj) {
	this.Modified = true;
	obj.zIndex = this.getMaxZIndex() + 1;
}

// 将一个流程图元素对象移至最底层
TTopFlow.prototype.sendToBack = function(obj) {
	this.Modified = true;
	obj.zIndex = this.getMinZIndex() - 1;
}

// 获取流程图下一个[任务]的缺省ID
TTopFlow.prototype.getMaxProcID = function(obj) {
	//mask.show();
	var arrProc = createProcs(obj)
	var maxProcID ="";
	
	var para = "method=wfnodeadd&wfid="+this.ID+"&formid="+this.FormID+"&delids="+this.delNodeIDs+"&nodesnum="+arrProc.length+"&isbill="+this.IsBill;
	for(var i=0;i<arrProc.length;i++){
		var nodetype = -1;
		var nodeattribute = '';
		switch(arrProc[i].ProcType){
			case 'create':
				nodetype = 0;
				nodeattribute = 0;
				break;
			case 'approve':
				nodetype = 1;
				nodeattribute = 0;
				break;
			case 'realize':
				nodetype =2;
				nodeattribute = 0;
				break;
			case 'process':
				nodetype = 3
				nodeattribute = 0;
				break;
			case 'fork':
				nodetype = 2;
				nodeattribute = 1;
				break;
			case 'join':
				nodetype = 2;
				nodeattribute = 4;
				break;
			default:
				nodetype = 2;
				nodeattribute = 0;
				break;
				
		}
		var procName = arrProc[i].Text
		para+="&node_"+i+"_attribute="+nodeattribute+"&node_"+i+"_type="+nodetype+"&node_"+i+"_name="+procName+"&node_"+i+"_drawxpos="+arrProc[i].X+"&node_"+i+"_drawypos="+arrProc[i].Y;
	}

	/*var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4) {

			if(xmlHttp.responseText!=''){
			eval(xmlHttp.responseText)
				if(result.status=='0'){
					
					maxProcID = result.id;
					createProcsByID(maxProcID,arrProc);
					mask.hide();
				}else{
					mask.hide();
					parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.procAddFailure);
					maxProcID =  false;
				}
			}
	    }
	}
	xmlHttp.open("POST", "/weaver/weaver.workflow.layout.WorkflowDesignOperatoinServlet", true);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xmlHttp.send(para);
    */
	//alert(1)
	//maxProcID = "2010";
	for(var i=0;i<arrProc.length;i++){
		maxProcID+=Math.round(Math.random()*100000000)+","
	}
	maxProcID = maxProcID.substring(0,maxProcID.length-1);
	createProcsByID(maxProcID,arrProc);
	return maxProcID;
}

// 获取流程图下一个[路径]的缺省ID
TTopFlow.prototype.getMaxStepID = function(arrStep,auto) {

	var maxStepID = "";
	/*var para = "method=wfnodeportal&wfid="+this.ID+"&formid="+this.FormID+"&delids="+this.delStepIDs+"&stepssum="+arrStep.length;
	for(var i=0;i<arrStep.length;i++){
		
		var stepName = arrStep[i].Text
		arrStep[i].getRelNumber();
		para+="&por"+i+"_nodeid="+arrStep[i].FromProc.substr(0,arrStep[i].FromProc.length-1)+"&por"+i+"_directionfrom="+arrStep[i].directionFrom;
		para+="&por"+i+"_directionto="+arrStep[i].directionTo+"&por"+i+"_link="+stepName+"&por"+i+"_des="+arrStep[i].ToProc.substr(0,arrStep[i].ToProc.length-1);
	
	}

	if(!auto){
		mask.show();
	}
	var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4) {
			if(xmlHttp.responseText!=''){
			eval(xmlHttp.responseText)
			if(result.status=='0'){
				maxStepID = result.id;
				createStepsByID(maxStepID,arrStep,auto);
				if(!auto){
					mask.hide();
				}
				//parent.showMessage(wmsg.wfdesign.info,staute.errormsg)
			}else{
				parent.showMessage(wmsg.wfdesign.error,wmsg.wfdesign.stepAddFailure);
				maxStepID =  false;
			}
			}
	    }
	}
	xmlHttp.open("POST", "/weaver/weaver.workflow.layout.WorkflowDesignOperatoinServlet", !auto);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xmlHttp.send(para);
	*/
	for(var i=0;i<arrStep.length;i++){
		maxStepID+=Math.round(Math.random()*100000000)+",";
	}
	maxStepID = maxStepID.substring(0,maxStepID.length-1);
	createStepsByID(maxStepID,arrStep,auto);
	return maxStepID;
}

// 流程图[选择框]的字符串化函数
TTopFlow.prototype.SelectBoxString = function(){
	return this.SelectBox;
} 
// 流程图内全部[任务]的字符串化函数
TTopFlow.prototype.ProcString = function() {
	var S = "", i;
	for (i = 0; i < this.Procs.length; i++)
		S += this.Procs[i];
	return S;
}

// 流程图内全部[路径]的字符串化函数
TTopFlow.prototype.StepString = function() {
	var S = "", i;
	for (i = 0; i < this.Steps.length; i++)
		S += this.Steps[i];
	return S;
}

// 流程图字符串化函数
TTopFlow.prototype.toString = function() {
	return this.ProcString() + this.StepString();
}

TTopFlow.prototype.getFlowMinY = function(){
	if(selectedItem.length==0){
		return false;
	}	
	var minY = parseInt(selectedItem[0].getInnerObject().style.top);
	for(var i=0;i<selectedItem.length;i++){
		
		if(minY>parseInt(selectedItem[i].getInnerObject().style.top)){
			minY = parseInt(selectedItem[i].getInnerObject().style.top);
		}
		
	}
	for(var i=0;i<this.Steps.length;i++){
		if(this.Steps[i].getMinY()){
			if(this.Steps[i].getMinY()<minY){
				minY = this.Steps[i].getMinY();
			}
		}
	}
	return minY
} 

TTopFlow.prototype.getFlowMinX = function(){
	if(selectedItem.length==0){
		return false;
	}	
	var minX = parseInt(selectedItem[0].getInnerObject().style.left);
	for(var i=0;i<selectedItem.length;i++){
		
		if(minX>parseInt(selectedItem[i].getInnerObject().style.left)){
			minX = parseInt(selectedItem[i].getInnerObject().style.left);
		}
		
	}
	for(var i=0;i<this.Steps.length;i++){
		if(this.Steps[i].getMinY()){
			if(this.Steps[i].getMinY()<minX){
				minX = this.Steps[i].getMinX();
			}
		}
	}
	return minX
} 

// 获取[路径]的划线结点路径
TStep.prototype.getPath = function() {
	if (this.Points != null && this.Points != "")
		return this.Points;
	var fromProc = document.getElementById(this.FromProc), toProc = document.getElementById(this.ToProc);
	
	if (fromProc == null || toProc == null){
		fromProc = this.Flow.getProcByID(this.FromProc);
		toProc = this.Flow.getProcByID(this.ToProc);
		if(toProc==null||toProc==null){
			return '';
		}
		var fromW = parseInt(fromProc.Width);
		var fromH = parseInt(fromProc.Height);
		var toW = parseInt(toProc.Width);
		var toH = parseInt(toProc.Height);
		var fromX = parseInt(fromProc.X);
		var fromY = parseInt(fromProc.Y);
		var toX = parseInt(toProc.X);
		var toY = parseInt(toProc.Y);
		if (this.FromProc == this.ToProc)
			return this.getSelfPath(fromX, fromY, fromW, fromH);
	
		if (ifRepeatProc(fromX, fromY, fromW, fromH, toX, toY, toW, toH)) {
			return "";
		} else if (this.ShapeType == "PolyLine") {
			return this.getLinePath(fromX, fromY, fromW, fromH, toX, toY, toW, toH);
		} else
			return this.Points;
		
	}else{
		
		var fromW = parseInt(fromProc.style.width);
		var fromH = parseInt(fromProc.style.height);
		var toW = parseInt(toProc.style.width);
		var toH = parseInt(toProc.style.height);
		var fromX = parseInt(fromProc.style.left);
		var fromY = parseInt(fromProc.style.top);
		var toX = parseInt(toProc.style.left);
		var toY = parseInt(toProc.style.top);
		if (this.FromProc == this.ToProc)
			return this.getSelfPath(fromX, fromY, fromW, fromH);
	
		if (ifRepeatProc(fromX, fromY, fromW, fromH, toX, toY, toW, toH)) {
			return "";
		} else if (this.ShapeType == "PolyLine") {
			return this.getLinePath(fromX, fromY, fromW, fromH, toX, toY, toW, toH);
		} else
			return this.Points;
	}
}

// 重新获取[路径]的划线结点路径
TStep.prototype.reGetPath = function() {

	var fromProc = this.Flow.getProcByID(this.FromProc)
	var toProc = this.Flow.getProcByID(this.ToProc)

	if (fromProc == null || toProc == null)
		return '';
	var fromW = parseInt(fromProc.Width);
	var fromH = parseInt(fromProc.Height);
	var toW = parseInt(toProc.Width);
	var toH = parseInt(toProc.Height);
	var fromX = parseInt(fromProc.X);
	var fromY = parseInt(fromProc.Y);
	var toX = parseInt(toProc.X);
	var toY = parseInt(toProc.Y);
	if (this.FromProc == this.ToProc)
		return this.getSelfPath(fromX, fromY, fromW, fromH);

	if (ifRepeatProc(fromX, fromY, fromW, fromH, toX, toY, toW, toH)) {
		return "";
	} else if (this.ShapeType == "PolyLine") {
		return this.getLinePath(fromX, fromY, fromW, fromH, toX, toY, toW, toH);
	} else
		return this.Points;
}

// 获取当[路径]指向自身时的划线结点路径
TStep.prototype.getSelfPath = function(ProcX, ProcY, ProcW, ProcH) {
	var constLength = 20;
	point0X = ProcX + ProcW/4;
	point0Y = ProcY 
	point1X = point0X;
	point1Y = point0Y - constLength;

	point2X = ProcX + ProcW*3/4;
	point2Y = point1Y;

	point3X = point2X;
	point3Y = point0Y;

	this.Points = point0X + ',' + point0Y + ',' + point1X + ',' + point1Y + ','
			+ point2X + ',' + point2Y + ',' + point3X + ',' + point3Y ;
	var arrPoints = this.Points.split(',');
	arrPoints.splice()
	for(var i=2;i<arrPoints.length-2;i=i+2){
		var point = new TPoint(this);
		point.Display = '';
		point.X = parseInt(arrPoints[i])-2+"";
		point.Y = parseInt(arrPoints[i+1])-2+"";
		point.FillColor = 'black';
		point.Height = '4px';
		point.Width = '4px';
		point.ID = _FLOW.stepNumber+this.getMaxPointID();
		point.StrokeColor = 'white';
		this.PointObjs[this.PointObjs.length]=point;
	}
	_FLOW.stepNumber++;
	this.getRelNumber();
	return point0X + ',' + point0Y + ' ' + point1X + ',' + point1Y + ' '
			+ point2X + ',' + point2Y + ' ' + point3X + ',' + point3Y;
}

TStep.prototype.getRelNumber = function(){

	var arrPoint =changePtToPx(this.Points).split(',')
	
	if(arrPoint.length==0){
		return false;
	}
	
	var fromPointX = parseInt(arrPoint[0]);
	var fromPointY = parseInt(arrPoint[1]);
	var toPointX = parseInt(arrPoint[arrPoint.length-2]);
	var toPointY = parseInt(arrPoint[arrPoint.length-1]);
	
	var fromProc = this.Flow.getProcByID(this.FromProc)
	var toProc = this.Flow.getProcByID(this.ToProc)

	if (fromProc == null || toProc == null)
		return '';
	var fromProcW = parseInt(fromProc.Width);
	var fromProcH = parseInt(fromProc.Height);
	var toProcW = parseInt(toProc.Width);
	var toProcH = parseInt(toProc.Height);
	var fromProcX = parseInt(fromProc.X);
	var fromProcY = parseInt(fromProc.Y);
	var toProcX = parseInt(toProc.X);
	var toProcY = parseInt(toProc.Y);
	
	if(fromPointX>fromProcX&&fromPointX<fromProcX+(fromProcW*0.5)&&(fromProcX+fromProcW*0.5-fromPointX>4)&&(fromPointX-fromProcX>4)){
		
		fromRelX = 0.25
		
	}else if(fromPointX>fromProcX+(fromProcW*0.5)&&fromPointX<fromProcX+fromProcW&&(fromPointX-(fromProcX+fromProcW*0.5))>4&&(fromProcX+fromProcW-fromPointX>4)){
		fromRelX = 0.75
		
	}else if(fromPointX > fromProcX+fromProcW*0.75&&(fromPointX-(fromProcX+fromProcW*0.75)>4)){
		
		fromRelX = 1
		
	}else if(fromPointX < fromProcX+fromProcW*0.25&&(fromProcX+fromProcW*0.2-fromPointX>4)){
		fromRelX = 0;
		
	}else{
		fromRelX = 0.5
	}
	
	if(toPointX>toProcX&&toPointX<toProcX+toProcW*0.5&&((toProcX+toProcW*0.5)-toPointX>4)&&(toPointX-toProcX>4)){
		toRelX = 0.25
	}else if(toPointX>toProcX+(toProcW*0.5)&&toPointX<toProcX+toProcW&&(toPointX-(toProcX+toProcW*0.5)>4)&&(toProcX+toProcW-toPointX>4)){
		
		toRelX = 0.75
	}else if(toPointX > toProcX+toProcW*0.75&&(toPointX-(toProcX+toProcW*0.75)>4)){
		toRelX = 1
	}else if(toPointX < toProcX+toProcW*0.25&&(toProcX+toProcW*0.25-toPointX)>4){
		toRelX = 0;
	}else {
		toRelX = 0.5
	}
	
	if(toPointY>toProcY&&toPointY<toProcY+(toProcH*0.5)&&((toProcY+(toProcH*0.5))-toPointY>4)&&(toPointY-toProcY>4)){
		toRelY = 0.25
		if(toRelX>0.25){
			toRelX = 1
		}else{
			toRelX = 0
		}
	}else if(toPointY>toProcY+(toProcH*0.5)&&toPointY<toProcY+toProcH&&(toPointY-(toProcY+(toProcH*0.5))>4&&(toProcY+toProcH-toPointY>4))){
		toRelY = 0.75
		if(toRelX>0.25){
			toRelX = 1
		}else{
			toRelX = 0
		}
	}else if(toPointY > toProcY+toProcH*0.75&&(toPointY-(toProcY+toProcH*0.75)>4)){
		toRelY = 1
	}else if(toPointY < toProcY+toProcH*0.25&&(toProcY+toProcH*0.25-toPointY>4)){
		toRelY = 0;
	}else {
		toRelY = 0.5
		if(toRelX>0.25){
			toRelX = 1
		}else{
			toRelX = 0
		}
	}
	
	if(fromPointY>fromProcY&&fromPointY<fromProcY+(fromProcH*0.5)&&(fromProcY+fromProcH*0.5-fromPointY>4)&&(fromPointY-fromProcY>4)){
		fromRelY = 0.25
		if(fromRelX>0.25){
			fromRelX = 1
		}else{
			fromRelX = 0
		}
	}else if(fromPointY>fromProcY+(fromProcH*0.5)&&fromPointY<fromProcY+fromProcH&&(fromPointY-(fromProcY+fromProcH*0.5)>4)&&(fromProcY+fromProcH-fromPointY>4)){
		fromRelY = 0.75
		if(fromRelX>0.25){
			fromRelX = 1
		}else{
			fromRelX = 0
		}
	}else if(fromPointY > fromProcY+fromProcH*0.75&&(fromPointY-(fromProcY+fromProcH*0.75)>4)){
		fromRelY = 1
	}else if(fromPointY < fromProcY+fromProcH*0.25&&(fromProcY+fromProcH*0.25-fromPointY)>4){
		fromRelY = 0;
	}else {
		fromRelY = 0.5
		if(fromRelX>0.25){
			fromRelX = 1
		}else{
			fromRelX = 0
		}
	}
	
	this.fromRelX = fromRelX;
	this.fromRelY = fromRelY;
	this.toRelX = toRelX;
	this.toRelY = toRelY;
	
	this.setDirection(fromProcX,fromProcY,fromProcW,fromProcH,toProcX,toProcY,toProcW,toProcH,arrPoint);
}

TStep.prototype.setDirection = function(fromProcX,fromProcY,fromProcW,fromProcH,toProcX,toProcY,toProcW,toProcH,arrPoint){
	
	if(this.fromRelX ==0){
		if(true||fromProcX>toProcX){
			switch(this.fromRelY){
				case 0:
					this.directionFrom = 10;
					break;
				case 0.25:
					this.directionFrom =9;
					break;
				case 0.5:
					this.directionFrom = 8;
					break;
				case 0.75:
					this.directionFrom = 7;
					break;
				case 1:
					this.directionFrom = 6
					break;
			}
			arrPoint[0] = fromProcX+fromProcW;
			arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
		}else{
			switch(this.fromRelY){
				case 0:
					this.directionFrom = 14;
					break;
				case 0.25:
					this.directionFrom =15;
					break;
				case 0.5:
					this.directionFrom = 0;
					break;
				case 0.75:
					this.directionFrom = 1;
					break;
				case 1:
					this.directionFrom = 2;
					break;
			}
			arrPoint[0] = fromProcX;
			arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
		}
	}else if(this.fromRelX ==0.25){
		switch(this.fromRelY){
			case 0:
				this.directionFrom = 11;
				break;
			case 1:
				this.directionFrom = 5;
				break;
		}
		arrPoint[0] = fromProcX+fromProcW*this.fromRelX;
		arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
	}else if(this.fromRelX ==0.5){
		switch(this.fromRelY){
			case 0:
				this.directionFrom = 12;
				break;
			case 1:
				this.directionFrom = 4;
				break;
		}
		arrPoint[0] = fromProcX+fromProcW*this.fromRelX;
		arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
	}else if(this.fromRelX ==0.75){
		switch(this.fromRelY){
			case 0:
				this.directionFrom = 13;
				break;
			case 1:
				this.directionFrom = 3;
				break;
		}
		arrPoint[0] = fromProcX+fromProcW*this.fromRelX;
		arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
	}else if(this.fromRelX ==1){
		if(true||fromProcX>toProcX){
			switch(this.fromRelY){
				case 0:
					this.directionFrom = 14;
					break;
				case 0.25:
					this.directionFrom =15;
					break;
				case 0.5:
					this.directionFrom = 0;
					break;
				case 0.75:
					this.directionFrom = 1;
					break;
				case 1:
					this.directionFrom = 2;
					break;
			}
			arrPoint[0] = fromProcX;
			arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
		}else{
			switch(this.fromRelY){
					case 0:
						this.directionFrom = 10;
						break;
					case 0.25:
						this.directionFrom =9;
						break;
					case 0.5:
						this.directionFrom = 8;
						break;
					case 0.75:
						this.directionFrom = 7;
						break;
					case 1:
						this.directionFrom = 6
						break;
			}
			arrPoint[0] = fromProcX+fromProcW*this.fromRelX;
			arrPoint[1] = fromProcY+fromProcH*this.fromRelY;
		}
	}
	
	if(this.toRelX ==0){
		if(true||fromProcX>toProcX){
			switch(this.toRelY){
				case 0:
					this.directionTo = 10;
					break;
				case 0.25:
					this.directionTo =9;
					break;
				case 0.5:
					this.directionTo = 8;
					break;
				case 0.75:
					this.directionTo = 7;
					break;
				case 1:
					this.directionTo = 6
					break;
			}
			arrPoint[arrPoint.length-2] = toProcX+toProcW;
			arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;
		}else{
			switch(this.toRelY){
				case 0:
					this.directionTo = 14;
					break;
				case 0.25:
					this.directionTo =15;
					break;
				case 0.5:
					this.directionTo = 0;
					break;
				case 0.75:
					this.directionTo = 1;
					break;
				case 1:
					this.directionTo = 2;
					break;
			}
			arrPoint[arrPoint.length-2] = toProcX;
			arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;
		}
	}else if(this.toRelX ==0.25){
		switch(this.toRelY){
			case 0:
				this.directionTo = 11;
				break;
			case 1:
				this.directionTo = 5;
				break;
		}
		arrPoint[arrPoint.length-2] = toProcX+toProcW*this.toRelX;
		arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;
	}else if(this.toRelX ==0.5){
		switch(this.toRelY){
			case 0:
				this.directionTo = 12;
				break;
			case 1:
				this.directionTo = 4;
				break;
		}
		arrPoint[arrPoint.length-2] = toProcX+toProcW*this.toRelX;
		arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;
	}else if(this.toRelX ==0.75){
		switch(this.toRelY){
			case 0:
				this.directionTo = 13;
				break;
			case 1:
				this.directionTo = 3;
				break;
		}
		arrPoint[arrPoint.length-2] = toProcX+toProcW*this.toRelX;
		arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;

	}else if(this.toRelX ==1){
		if(true||fromProcX>toProcX){
			switch(this.toRelY){
				case 0:
					this.directionTo = 14;
					break;
				case 0.25:
					this.directionTo =15;
					break;
				case 0.5:
					this.directionTo = 0;
					break;
				case 0.75:
					this.directionTo = 1;
					break;
				case 1:
					this.directionTo = 2;
					break;
			}
			arrPoint[arrPoint.length-2] = toProcX
			arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;

		}else{
			switch(this.toRelY){
				case 0:
					this.directionTo = 10;
					break;
				case 0.25:
					this.directionTo =9;
					break;
				case 0.5:
					this.directionTo = 8;
					break;
				case 0.75:
					this.directionTo = 7;
					break;
				case 1:
					this.directionTo = 6
					break;
			}
			arrPoint[arrPoint.length-2] = toProcX+toProcW*this.toRelX;
			arrPoint[arrPoint.length-1] = toProcY+toProcH*this.toRelY;

		}
	}
	var _Points = "";
	for(var i = 0;i<arrPoint.length;i++){
		_Points+=arrPoint[i]+",";
	}
	//this.Points = _Points.substring(0,_Points.length-1);
	
	if((this.directionFrom == 0 && this.directionTo == 8)&&fromProcX>toProcX){
		if(!_LoadXml){
			return;
		}
		var _points = changePtToPx(this.Points);
		var aryPoint = _points.split(",");
		if(aryPoint.length == 4){
			_Points = (fromProcX+fromProcW/2)+","+fromProcY+","+(fromProcX+fromProcW/2)+","+(fromProcY-15)+","+(toProcX+toProcW/2)+","
					 +(toProcY-15)+","+(toProcX+toProcW/2)+","+toProcY+"";
			this.Points = _Points;
			//this.directionFrom = 12;
			//this.directionTo = 12;
		}
	}
}
// 获取当[路径]线型为直线时的划线结点路径
TStep.prototype.getLinePath = function(fromProcX, fromProcY, fromProcW,
		fromProcH, toProcX, toProcY, toProcW, toProcH) {
	
	var fromX, fromY, toX, toY, fromRelX, fromRelY, toRelX, toRelY;
	if (fromProcY + fromProcH < toProcY) {
		 // FromProc完全在ToProc上方
		if (fromProcX + fromProcW < toProcX) { // FromProc完全在ToProc左方
			fromX = fromProcX + fromProcW; // 取FromProc右下角
			fromY = fromProcY + fromProcH;
			toX = toProcX; // 取ToProc左上角
			toY = toProcY;
			
			fromRelX = 1;
			fromRelY = 1;
			toRelX = 0;
			toRelY = 0;
		} else if (fromProcX > toProcX + toProcW) { // FromProc完全在ToProc右方
			fromX = fromProcX; // 取FromProc左下角
			fromY = fromProcY + fromProcH;
			toX = toProcX + toProcW;
			toY = toProcY;
			fromRelX = 0;
			fromRelY = 1;
			toRelX = 1;
			toRelY = 0;
		} else { // 取FromProc下中结点
			fromX = fromProcX + parseInt(fromProcW / 2);
			fromY = fromProcY + fromProcH;
			toX = toProcX + parseInt(toProcW / 2);
			toY = toProcY;
			fromRelX = 0.5;
			fromRelY = 1;
			toRelX = 0.5;
			toRelY = 0;
		}
	} else if (fromProcY > toProcY + toProcH) {
		// FromProc完全在ToProc下方
		if (fromProcX + fromProcW < toProcX) { // FromProc完全在ToProc左方
			fromX = fromProcX + fromProcW; // 取FromProc右上角
			fromY = fromProcY;
			toX = toProcX; // 取ToProc左下角
			toY = toProcY + toProcH;
			fromRelX = 1;
			fromRelY = 0;
			toRelX = 0;
			toRelY = 1;
		} else if (fromProcX > toProcX + toProcW) { // FromProc完全在ToProc右方
			fromX = fromProcX; // 取FromProc左上角
			fromY = fromProcY;
			toX = toProcX + toProcW; // 取ToProc右下角
			toY = toProcY + toProcH;
			fromRelX = 0;
			fromRelY = 0;
			toRelX = 1;
			toRelY = 1;
		} else { // 取FromProc下中结点
			fromX = fromProcX + parseInt(fromProcW / 2);
			fromY = fromProcY;
			toX = toProcX + parseInt(toProcW / 2);
			toY = toProcY + toProcH;
			fromRelX = 0.5;
			fromRelY = 0;
			toRelX = 0.5;
			toRelY = 1;
		}
	} else if (fromProcX + fromProcW < toProcX) { // FromProc在toProc左方
		fromX = fromProcX + fromProcW;
		fromY = fromProcY + parseInt(fromProcH / 2);
		toX = toProcX;
		toY = toProcY + parseInt(toProcH / 2);
		fromRelX = 1;
		fromRelY = 0.5;
		toRelX = 0;
		toRelY = 0.5;
	} else { // 在右方
		fromX = fromProcX;
		fromY = fromProcY + parseInt(fromProcH / 2);
		toX = toProcX + toProcW;
		toY = toProcY + parseInt(toProcH / 2);
		fromRelX = 0;
		fromRelY = 0.5;
		toRelX = 1;
		toRelY = 0.5;
	}
	this.Points = fromX / 4 * 3 + 'pt,' + fromY / 4 * 3 + 'pt,' + toX / 4 * 3
			+ 'pt,' + toY / 4 * 3 + 'pt';
	if(!this.getRelNumber()){
	
		this.fromRelX = fromRelX;
		this.fromRelY = fromRelY;
		this.toRelX = toRelX;
		this.toRelY = toRelY;
	}
	
	return this.Points;

}

// 获取当[路径]线型为折线线时的划线结点路径
TStep.prototype.getPolyLinePath = function(fromProcX, fromProcY, fromProcW,
		fromProcH, toProcX, toProcY, toProcW, toProcH) {
	// fromProc Center X,Y
	var fromCenterX = fromProcX + parseInt(fromProcW / 2);
	var fromCenterY = fromProcY + parseInt(fromProcH / 2);
	// toProc Center X,Y
	var toCenterX = toProcX + parseInt(toProcW / 2);
	var toCenterY = toProcY + parseInt(toProcH / 2);
	//
	point2X = fromCenterX;
	point2Y = toCenterY;
	if (toCenterX > fromCenterX) { // ToProc在FromProc的右边
		absY = toCenterY >= fromCenterY ? toCenterY - fromCenterY : fromCenterY
				- toCenterY; // 计算两个对象中心点的距离
		if (parseInt(fromProcH / 2) >= absY) { // ToProc的顶部在FromProc的底部之上
			point1X = fromProcX + fromProcW;
			point1Y = toCenterY;
			point2X = point1X;
			point2Y = point1Y;
		} else {
			point1X = fromCenterX;
			point1Y = fromCenterY < toCenterY
					? fromProcY + fromProcH
					: fromProcY;
		}
		absX = toCenterX - fromCenterX;
		if (parseInt(fromProcW / 2) >= absX) {
			point3X = fromCenterX;
			point3Y = fromCenterY < toCenterY ? toProcY : toProcY + toProcH;
			point2X = point3X;
			point2Y = point3Y;
		} else {
			point3X = toProcX;
			point3Y = toCenterY;
		}
	}
	if (toCenterX < fromCenterX) {
		absY = toCenterY >= fromCenterY ? toCenterY - fromCenterY : fromCenterY
				- toCenterY;
		if (parseInt(fromProcH / 2) >= absY) {
			point1X = fromProcX;
			point1Y = toCenterY;
			point2X = point1X;
			point2Y = point1Y;
		} else {
			point1X = fromCenterX;
			point1Y = fromCenterY < toCenterY
					? fromProcY + fromProcH
					: fromProcY;
		}
		absX = fromCenterX - toCenterX;
		if (parseInt(fromProcW / 2) >= absX) {
			point3X = fromCenterX;
			point3Y = fromCenterY < toCenterY ? toProcY : toProcY + toProcH;
			point2X = point3X;
			point2Y = point3Y;
		} else {
			point3X = toProcX + toProcW;
			point3Y = toCenterY;
		}
	}
	if (toCenterX == fromCenterX) {
		point1X = fromCenterX;
		point1Y = fromCenterY > toCenterY ? fromProcY : fromProcY + fromProcH;
		point3X = fromCenterX;
		point3Y = fromCenterY > toCenterY ? toProcY + toProcH : toProcY;
		point2X = point3X;
		point2Y = point3Y;
	}
	if (toCenterY == fromCenterY) {
		point1X = fromCenterX > toCenterX ? fromProcX : fromProcX + fromProcW;
		point1Y = fromCenterY;
		point3Y = fromCenterY;
		point3X = fromCenterX > toCenterX ? toProcX + toProcW : toProcX;
		point2X = point3X;
		point2Y = point3Y;
	}
	return point1X + ',' + point1Y + ' ' + point2X + ',' + point2Y + ' '
			+ point3X + ',' + point3Y;
}

/**
 * 显示流程中重叠的节点
 */
TTopFlow.prototype.showRepeatItems = function(){
	for(var i=0;i<this.Procs.length;i++){
		for(var j=0;j<this.Procs.length;j++){
			var proc = this.Procs[i];
			var _proc = this.Procs[j];
			if(_proc.ID!=proc.ID){
				if(proc.isRepeat(_proc)){
					proc.showRepeat();
					_proc.showRepeat();
				}
			}
		}
	}	
}

// 判断两个[任务]的位置是否有重叠
function ifRepeatProc(fromX, fromY, fromW, fromH, toX, toY, toW, toH) {
	return (fromX + fromW >= toX) && (fromY + fromH >= toY)
			&& (toX + toW >= fromX) && (toY + toH >= fromY);
}
