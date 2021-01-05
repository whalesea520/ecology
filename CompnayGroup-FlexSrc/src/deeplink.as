
import mx.events.BrowserChangeEvent;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;
import mx.utils.URLUtil;
//////////////////////////////////////////////////////////////
//Deep link
//////////////////////////////////////////////////////////////

private var parsing:Boolean = false;
private var browserManager:IBrowserManager;
private function initDeepLink():void{
	browserManager = BrowserManager.getInstance(); 
	browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, parseURL); 
	browserManager.init("", "index");
}
private function parseURL(event:BrowserChangeEvent):void{
	parsing = true;
	var o:Object = URLUtil.stringToObject(browserManager.fragment);
	
	if(o.id == undefined){
		o.id = "0";
	}
	
	if(o.industryId == undefined){
		o.industryId = "0";				
	}
	
	if(o.deptType == undefined){
		o.deptType = 1;
	}
	
	displayOrgChart(o);
	
	parsing = false;
}

private function updateURL():void{ 
	if (!parsing) 
		callLater(actuallyUpdateURL); 
   } 
   private function actuallyUpdateURL():void{
   	var o:Object = history.getItemAt(currentIndex); 
    
    var s:String = URLUtil.objectToString(o);
    browserManager.setFragment(s);
   }
         