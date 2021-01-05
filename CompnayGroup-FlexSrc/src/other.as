
import control.OrgChartEvent;

import mx.controls.Alert;
import mx.core.ScrollPolicy;

private function processParameters():void{
	//pass some parameters from HTML
	var value:String = Application.application.parameters.serverURL;
	trace("serverURL="+value);
	if(value != null){
		serverURL = value;
	}
	var demoMode:String = Application.application.parameters.demoMode;
	//Alert.show(demoMode);
	trace("demoMode="+demoMode);
	if(demoMode == "true"){
		serverURL = "test_init.xml"
	}
}
///////////////////////////////////////////////////////////////////
// 处理More（通过弹出Flex Window的方式）
// Special for type "more", pop an flex window show all chilren.
//////////////////////////////////////////////////////////////////
//private var popWindow:AllUnitsPanel;
/*private function showPopup(event:OrgChartEvent):void{
	if(popWindow == null){
		popWindow = PopUpManager.createPopUp(this, AllUnitsPanel, false) as AllUnitsPanel;
		popWindow.addEventListener(CloseEvent.CLOSE, hidePopup);
		popWindow.addEventListener("itemClick", onItemClick);
	}
	popWindow.data = event.node.data;
	PopUpManager.centerPopUp(popWindow);
	popWindow.visible = true;
}*/
/*
private function onItemClick(event:ItemClickEvent):void{
	popWindow.visible = false;
	
	displayOrgChartFor(event.item.@id, currentIndustryId);
}
private function hidePopup(event:CloseEvent):void{
	popWindow.visible = false;				
}
*/
//////////////////////////////////////////////////////////////////
// 处理图节点的单击
// Called when a node has been clicked.
/////////////////////////////////////////////////////////////////
private function onNodeClick(event:OrgChartEvent):void{
	var data:Object = event.node.data;
	if(data.@type == "more"){
		//showPopup(event);
	}else if(data.@type == "department" || data.@type == "person"){	
		
		//openBrowserWindowFor(data);
	}else{
		//displayOrgChartFor(data.@id, currentIndustryId);
		resetZoom();
	}
}
/////////////////////////////////////////////////////////////////////////////
//调用Javascript，弹出新的浏览器窗口
//JavaScript 函数详见 html-template/index.template.html
// Interactive with JavaScript
////////////////////////////////////////////////////////////////////////////
private function openBrowserWindowFor(data:Object):void{
	if(ExternalInterface.available){
		var type:String = data.@type;
		var id:int = data.@id;
		var result:Boolean = ExternalInterface.call("showDetailsPageFor", type, id);
		if(!result){
			//Alert.show("详细信息窗口被拦截，请修改您的浏览器设置。");
			Alert.show("Popup blocked.");
		}
	} 
}

/////////////////////////////////////////////
//设置自定义 cursor, 如果需要，打开注释。
// custome the cursor
//////////////////////////////////////////////
[Embed(source="/images/male.png")]
private var handCursor:Class;
private function onChartMouseDown(event:MouseEvent):void{
	//CursorManager.setCursor(handCursor, CursorManagerPriority.HIGH, 3, 2);
	//CursorManager.showCursor();
}
private function onChartMouseUp(event:MouseEvent):void{
	//CursorManager.removeAllCursors();
}



/**
 * 保持Orgchart居中，同时当容器width 小于 OrgChart width时保证不会出现 Orgchart左边无法显示的问题。
 * Keep the OrgChart align center
 **/
private function setHorizontalCenterOrNot():void{
	//trace("setHorizontalCenterOrNot width = "+width);
	//trace("setHorizontalCenterOrNot oc.width = "+oc.width);
	//trace("setHorizontalCenterOrNot oc.width = ");
	//orgChartContainer.oc
	//Alert.show(orgChartContainer.width+"$"+oc.width)
	//orgChartContainer.verticalScrollPolicy = orgChartContainer.horizontalScrollPolicy = ScrollPolicy.AUTO
	if(orgChartContainer.width > oc.width){
		oc.setStyle("horizontalCenter", 0);
		
	}else{
		//Alert.show(oc.width+"");
		oc.setStyle("left", 0);					
		oc.setStyle("horizontalCenter", "");
	}
}