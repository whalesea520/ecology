package model
{
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import util.XmlUtil;

	public class CompanyInfo
	{
		public function CompanyInfo()
		{
			
		}
		

		public var cnname:String;
		public var enname:String;
		public var registercapital:String;
		public var corporatdelegate:String;
		public var theboard:String;
		public var boardvisitors:String;
		public var generalmanager:String;
		public var usefulbegindate:String;
		public var usefulenddate:String;
		public var companyid:String;
		public function queryById(id:String) :Boolean{
		
			var http:HTTPService = new HTTPService();
			
			http.addEventListener(ResultEvent.RESULT,parseObj);
			http.addEventListener(FaultEvent.FAULT,myFaultErrorEvent);
			
			http.url="/companygroup/manage/companyoperation.jsp?method=queryCompanyInfoById"
			http.method = "post";
			http.resultFormat = "e4x";
			
			var val:URLVariables = new URLVariables;
			val.id = id;
			val.random = Math.random();
			
			http.send(val);
			
			return true;
		}
		
		public function parseObj(xmlContent:ResultEvent):void{
			try{
				var content:XML = xmlContent.result as XML;
				//Alert.show(content.toString());
				var flag:Boolean = XmlUtil.parseXmlToBean(content.companyinfo,this);
				Application.application.showCompanyPopUp();
			}catch(e:Error){
				
			}
		}
		
		public function myFaultErrorEvent(myFaultEvent:FaultEvent):void{    //异常处理函数   
			//Alert.show("333");
			trace(myFaultEvent.message);   
		}   
		
	}
}