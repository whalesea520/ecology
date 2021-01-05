
import mx.collections.ICollectionView;
import mx.collections.XMLListCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.controls.Alert;

////////////////////////////////////////////////
//业务方法/
////////////////////////////////////////////////
[Bindable]
private var serverURL:String="/companygroup/manage/companyoperation.jsp?method=getGroupInfo";
[Bindable]
private var chartTitle:String = "";

private function initBiz():void{
	displayOrgChartFor("0");
	//注册供Javascript调用的方法
    //调用示例详见 html-template/index.template.html
    // Interactive with JavaScript
    /*if(ExternalInterface.available){
		ExternalInterface.addCallback("displayOrgChartFor", displayOrgChartFor);
		ExternalInterface.addCallback("setTitle", setTitle);
    }*/
}
public function setTitle(title:String):void{
	chartTitle = title;
}
public function displayOrgChartFor(id:String, industryId:String="0"):void{
	var o:Object;

	//addToHistory(o);
	//Alert.show("test");
	o ={groupid:staticObj.groupid}
	displayOrgChart1(o);
}

private var isFirstTime:Boolean = true;
public function displayOrgChart1(params:Object):void{
	//Alert.show("displayOrgChart");
	//updateURL();
	//Alert.show("httpService.send(params)");
	httpService.send(params); 
	//trace("parameters{id:"+params.id+", deptType:"+params.deptType+", industryId:"+params.industryId+"]");
}

private function resultHandler1(event:ResultEvent):void{
	//trace("result="+event.result);\
	try{
	if(event.result != null && event.result is XML){
		var result:XML = event.result as XML;
		//orgTree.dataProvider = result;
		var data:ICollectionView = new XMLListCollection(new XMLList(result));
		oc.dataProvider1 = data;
		oc.visible = true;
	}
	}catch(e:Error){
		
	}
} 
private function faultHandler(event:FaultEvent):void{
	trace(event+"");
	trace(event.message.body+"");
	Alert.okLabel="确定";
	Alert.show("不能连接到服务,请稍后重试！");
}


