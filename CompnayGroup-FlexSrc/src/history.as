
import mx.collections.ArrayCollection;

[Bindable]
private var history:ArrayCollection;
[Embed(source="images/forward.png")]
[Bindable]
public var FrontImg:Class;


[Embed(source="images/back.png")]
[Bindable]
public var BackImg:Class;

[Embed(source="images/noback.jpg")]
[Bindable]
public var NOBackImg:Class;

[Embed(source="images/nofront.jpg")]
[Bindable]
public var NOFrontImg:Class;
/**
 *行业Id 
 **/
private var currentIndustryId:String = "0";
[Bindable]
private var currentIndex:int=0;
////////////////////////////////////////////
//前进和后退的功能，参考浏览器的前进和后退
// forward and back feature
////////////////////////////////////////////
private function initHistory():void{
	history = new ArrayCollection();
}
private function forward():void{
	currentIndex = currentIndex+1;
	var o:Object = history.getItemAt(currentIndex);
	if(o != null){
		displayOrgChart(o);					
	}
}
private function back():void{
	currentIndex = currentIndex-1;
	var obj:Object = history.getItemAt(currentIndex);
	if(obj != null){
		displayOrgChart(obj);
	}
}
private function home():void{
//var obj:Object = history.getItemAt(0);
//if( obj != null ){
//displayOrgChart(obj);
//}
//currentIndex = 0;
	currentIndustryId = "0";
	var obj:Object = {id:0, deptType:0, industryId:0, tmode:"temp"};
	displayOrgChart(obj);
	//chartName.text = "";
	history = new ArrayCollection();
}
private function addToHistory(obj:Object):void{						
	if(currentIndex < history.length){
		currentIndex = currentIndex+1;
		history.addItemAt(obj, currentIndex);
		for(var i:int = currentIndex+1; i< history.length; i++){
			history.removeItemAt(i);
		}
	}else{						
		history.addItem(obj);
		currentIndex = history.length - 1;
	}
}