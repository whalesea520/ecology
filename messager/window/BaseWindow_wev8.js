/*
*此类是窗口基本类，主要用于构建一个窗口。
*Hunk Zeng 2009-12-23
*例子如下
var para={
		id:'window1',  //窗口ID  *必填 用于标识及后来找到窗口
		templateId:'windowTemplate', //窗口模板  *必填 用于标识及后来找到窗口
		height:'200px', 
		width:'300px',
		top:'0',
		left:'0',
		logoImg:'images/icon-offline_wev8.gif',
		name:'Zdp Window 1',
		canDrag:true
}
new BaseWindow(para2).appendTo(document.body);
*/
function  BaseWindow(para){
	/*For Attr*/
	this.para=para;
	this.objWindow=null;
	this.cusData={};
	this.isShow=false;
}

/************Public Method************/		
BaseWindow.prototype.appendTo=function(paretnBody){		
	this.hide();
	if(this.objWindow==null) {
		this._create()
		
		this._fixSize();		
	}
	$(paretnBody).append(this.objWindow);
	this._initAccessory();
	this._initDrag();
	this._initFocus();	
}

BaseWindow.prototype.append=function(html){
	this.objWindow.find(".body").append(html);
}


BaseWindow.prototype.html=function(html){
	this.objWindow.find(".body").html(html);
}

//仅能看到其所有的子元素
BaseWindow.prototype.toString=function(){
	if(this.objWindow==null) {
		this._create()
	}
	return this.objWindow.html();
}

BaseWindow.prototype._subShow=function(){
}
BaseWindow.prototype.show=function(){
	if(!this.isShow){
		this.objWindow.css("z-index",ControlWindow.intMessagerZindex)
		this.objWindow.fadeIn("fast");
		this._subShow();
		this.isShow=true;
	}
}
BaseWindow.prototype.hide=function(){	
	if(this.isShow){
		this.objWindow.fadeOut("fast");
		this.isShow=false;	
	}
}	

BaseWindow.prototype.setCusData=function(name,value){
	this.cusData.name=value;	
}

BaseWindow.prototype.getCusData=function(name){
	return this.cusData.name;
}


BaseWindow.prototype.getId=function(){
	if(this.objWindow!=null) {
		return this.objWindow.attr("id");
	} else {
		return "";
	}
}			
BaseWindow.prototype.create=function(){
	if(this.objWindow==null) {
		this._create()
	}
}

BaseWindow.prototype.remove=function(){
	if(this.objWindow!=null) {
		this.objWindow.remove();

	}
}	

BaseWindow.prototype.hideForId=function(id){		
	$("#"+id).fadeOut("fast");
}
/****************Protect Method************/
//得到Clone的窗口


BaseWindow.prototype._getTemplateClone=function(){
	if(this.para.templateId==null) {
		alert("BaseWindow._getTemplateClone:window templateId " + rMsg.baseWindowCanNotBeEmpty)
		return false;
	}	
	this.objWindow=$("#"+this.para.templateId).clone();
	
}			
//verify objWindow是否存在
BaseWindow.prototype._verifyObjWindow=function(){	
	if(this.objWindow==null){
		_getTemplateClone();
	}			
}
BaseWindow.prototype._setId=function(){		
	this._verifyObjWindow();
	this.objWindow.attr("id",this.para.id);
}		

BaseWindow.prototype._setTop=function(){	
	this._verifyObjWindow();

	this.objWindow.css("top",this.para.top);
}

BaseWindow.prototype._setLeft=function(){	
	this._verifyObjWindow();
	
	this.objWindow.css("left",this.para.left);
}
BaseWindow.prototype.changeLogo=function(logoStr){		
		//alert(logoStr) 
		this.objWindow.find(".logo").find("img").attr("src",logoStr);	 
}
BaseWindow.prototype._setLogo=function(){	
	this._verifyObjWindow();
	//this.objWindow.find(".logo").css("background-image","url('"+this.para.logoImg+"')");	
	
	if(this.para.logoImg=="") {
		this.objWindow.find(".name").css("left","4px");
	} else {
		this.objWindow.find(".logo").append("<img src='"+this.para.logoImg+"'>");				
	}
}
BaseWindow.prototype._setName=function(){	
	this._verifyObjWindow();
	this.objWindow.find(".name").html(this.para.name);
}
BaseWindow.prototype._setOperate=function(){		
	this._verifyObjWindow();
	this.objWindow.find(".operate").hover(			
		function () {
			$(this).css("background-image","url('/messager/css/gray/x_wev8.gif')");
		},
		function () {
			$(this).css("background-image","url('/messager/css/gray/x_wev8.gif')");
		}
	);	
	var $this=this;
	this.objWindow.find(".operate").bind("click",{id:this.para.id},function(event){
		$this.hide();
	})
}
BaseWindow.prototype._setButtons=function(){		
	this._verifyObjWindow();
}



BaseWindow.prototype._fixWindow=function(){		
	 
	this._verifyObjWindow();
	
	var width=parseInt(this.para.width);
	var height=parseInt(this.para.height);		
	
	//fix all size
	this.objWindow.css("height",height);
	this.objWindow.css("width",width);

	//fix body size			
	this.objWindow.find(".body").css("height",height-8);
	this.objWindow.find(".body").css("width",width-8);	
}	

BaseWindow.prototype._fixSize=function(){	
	this._fixWindow();
}
BaseWindow.prototype._setEl=function(){			
	if(typeof this.para.el!="undefined"){	
		var newEl=$("#"+this.para.el).clone()
		newEl.show(); 
		this.objWindow.find(".body").append(newEl);
	}
}

BaseWindow.prototype._createBase=function(){
	this._getTemplateClone();
	this._setId();

	this._setTop();
	this._setLeft();
	this._setLogo();
	this._setName();
	this._setOperate();
	this._setButtons();	
	
	this._setEl();	 
}
BaseWindow.prototype._initDrag=function(){
	if(this.para.canDrag=="true"){		
		$("#"+this.para.id).jqDrag(".title").jqResize('.resize',{
			minWidth:100,
			minHeight:50
		});	
	}	
}
BaseWindow.prototype._initFocus=function(){
	this.objWindow.bind("click",function(){		
		  $(this).css("z-index",ControlWindow.intMessagerZindex);
		  ControlWindow.intMessagerZindex++;
	}); 
}
BaseWindow.prototype._create=function(){
	this._createBase();
}

BaseWindow.prototype._initAccessory=function(){
}

		