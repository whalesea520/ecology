package util
{
	import mx.controls.Alert;
	import mx.rpc.xml.SimpleXMLEncoder;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode
	import mx.collections.ArrayCollection;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.ArrayUtil;
	public final class XmlUtil
	{
		/**
		 *将xmllist转换为Array
		 * 注意Array里装有VO对象（类似于javabean） 
		 * @param xmllist
		 * @param classpath
		 * @return 
		 * 
		 */
		
		public static function parseXmlToBean(xmllist:XMLList,obj:Object):Boolean{
			
			//var temp4grid:Array=new Array();
			
			try{
				//var classReference:Class=Class(getDefinitionByName(classpath));
			}catch(err:Error)
			{
				//Alert.show("1:类名不匹配||modelconfig中实例化||"+err.message);
			}
			var keys:Array=new Array();
			
			var le:int=xmllist.length();
			//Alert.show(le.toString());
			var isMore:Boolean=false;
			if(le>1)isMore=true;
			
			for(var i:int=0;i<le;i++){
				var temp:XML=XML(xmllist[i]);
				//var one:Object=new classReference();
			
				if(i==0){//处理第一个
					
					for each(var str:XML in temp.elements() ){
						try{
							var key:String=str.name();
							
							if(isMore){keys.push(key);}
							var xmlvalue:*=temp[key];
							
							if(xmlvalue=="true"){xmlvalue=true;}
							else if(xmlvalue=="false"){xmlvalue=false;}
							//	
							
							//Alert.show(one[key].toString());
							obj[key]=xmlvalue;
							//Alert.show(one[key].toString());
						}
						catch(err:Error){Alert.show("2:字段名不匹配||"+err.message);return false;}
						
					}
				}else{//处理第一个之后
					for(var j:int=0;j<keys.length;j++){
						var currentKey:String=keys[j];
						obj[currentKey]=temp[currentKey];
					}
				}
				
				//temp4grid.push(one);
			}
			return true;
			//return temp4grid;
			//Alert.show(temp4grid);	
		}
		
		
		public static function objectToXML(obj:ArrayCollection,rooName:String):XML 
		{
			/*var qName:QName = new QName(rooName);
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			Alert.show("1");
			Alert.show(xmlDocument.toString());
			*/
			
			var xml:XML = new XML("<root/>");
			for(var i:int = 0;i<obj.length;i++){
				var node:XML = new XML("<node/>");
				node.id = obj[i].name;
				node.points = obj[i].points;
				//node.sjtitle = arr[i].sjtitle;
				//node.kemu= arr[i].kemu;
				//node.shijID= arr[i].shijID;
				//node.num= arr[i].num;
				
				xml.appendChild(node);
			}
			//Alert.show(root.toString());
			//return root;

			
			return xml;
		}
		
		public static function parseXmlToArray(obj:XMLDocument):ArrayCollection 
		{
			/*var qName:QName = new QName(rooName);
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			Alert.show("1");
			Alert.show(xmlDocument.toString());
			*/
			
			var decoder:SimpleXMLDecoder = new SimpleXMLDecoder();
			
			var data:Object = decoder.decodeXML( obj );
			
			var array:Array = ArrayUtil.toArray( data.rows.row );
			
			//Alert.show(array[0].name+array[0].id+array[0].desc);
			
			return new ArrayCollection( array );

			//Alert.show(root.toString());
			//return root;
			
		}
		
		
		
	}
}