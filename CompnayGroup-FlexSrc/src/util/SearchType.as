package util
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class SearchType
	{
		
		[Bindable]		
		public var searchTypeList:ArrayCollection;
		
		[Bindable]	
		public var businesstypeList:ArrayCollection;	
		
		[Bindable]	
		public var companyvestinList:ArrayCollection;
		
		private var list:Array = new Array;
		
		
		
		private static var one:SearchType;
		public static function getOne():SearchType
		{
			if (one == null)one = new SearchType();
			return one;
		}
		
		
	
		/**
		 * 绑定业务类型下拉框数据
		 */ 
		private function bindCompanyService(event:ResultEvent):void{
			var rawData:String = String(event.result); 
//			Alert.show(rawData);
			var arr:Array = (JSON.decode(rawData) as Array); 
			businesstypeList = new ArrayCollection(arr); 
//			Alert.show(businesstypeList.length+"");
//			businesstypeList=content;
			//staticObj.groupid = groupList.selectedItem.data;
			//groupList.dropdown.toolTip = groupList.toolTip;
		}
		
		
		
		/**
		 * 绑定关键字下拉框数据
		 */ 
		private function bindCompanyAttributablekey(event:ResultEvent):void{
			var rawData:String = String(event.result); 
			var arr:Array = (JSON.decode(rawData) as Array); 
			searchTypeList = new ArrayCollection(arr); 
			//			Alert.show(businesstypeList.length+"");
			//			businesstypeList=content;
			//staticObj.groupid = groupList.selectedItem.data;
			//groupList.dropdown.toolTip = groupList.toolTip;
		}
		
		/**
		 * 绑定公司归属下拉框数据
		 */ 
		private function bindCompanyAttributable(event:ResultEvent):void{
			var rawData:String = String(event.result); 
			var arr:Array = (JSON.decode(rawData) as Array); 
			companyvestinList = new ArrayCollection(arr); 
			//			Alert.show(businesstypeList.length+"");
			//			businesstypeList=content;
			//staticObj.groupid = groupList.selectedItem.data;
			//groupList.dropdown.toolTip = groupList.toolTip;
		}
		
		
		
		public function SearchType()
		{
			// 初始化基本搜索类型
			//list.push({label:'公司名称',data:"COMPANYNAME"});
			//list.push({label:'公司英文名称',data:"COMPANYENAME"});
			//list.push({label:'所在区域',data:"COMPANYREGION"});
			//list.push({label:'法人',data:"CORPORATION"});
			//list.push({label:'董事会',data:"THEBOARD"});
			//list.push({label:'监事会',data:"BOARDVISITORS"});
			//list.push({label:'总经理',data:"GENERALMANAGER"});
			
			
			var http03:HTTPService = new HTTPService();
			http03.addEventListener(ResultEvent.RESULT,bindCompanyAttributablekey);
			http03.url="/companygroup/manage/companyoperation.jsp?method=getCompanyAttributablekey"
			http03.method = "post";
			http03.resultFormat = "e4x";
			http03.send();
			
			
			list = new Array();
			
			
			var http:HTTPService = new HTTPService();
			http.addEventListener(ResultEvent.RESULT,bindCompanyService);
			//http.addEventListener(ResultEvent.RESULT,bindGroupInfo);
			//http.addEventListener(FaultEvent.FAULT,myFaultErrorEvent);
			
			http.url="/companygroup/manage/companyoperation.jsp?method=getCompanyService"
			http.method = "post";
			http.resultFormat = "e4x";
			http.send();
			
			var http02:HTTPService = new HTTPService();
			http02.addEventListener(ResultEvent.RESULT,bindCompanyAttributable);
			http02.url="/companygroup/manage/companyoperation.jsp?method=getCompanyAttributable"
			http02.method = "post";
			http02.resultFormat = "e4x";
			http02.send();
			
			
			
			
			
		}
		
		public function addSearchType(label:String,data:String):void{
			list.push({label:label,data:data});
			searchTypeList = new ArrayCollection(list);
		}
		
		public function get getCompanyvestinList():ArrayCollection{
			return companyvestinList;
		}
		
		public function get getBusinesstypeList():ArrayCollection{
			return businesstypeList;
		}
	}
}