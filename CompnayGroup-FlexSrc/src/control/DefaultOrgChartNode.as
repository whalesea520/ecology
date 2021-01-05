package control{
	
	import com.adobe.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.IUITextField;
	import mx.core.UITextField;
	
	//import tipBubble.BubbleTipManager;
	
//	import view.DetailsPanel;

	public class DefaultOrgChartNode extends Button implements IOrgChartNode{
		
		public var _data:Object;
		private var dataChanged:Boolean = true;
		
		private var _expanded:Boolean = true;
		private var _parent:IOrgChartNode;
		
		private var _subNodes:ArrayCollection=new ArrayCollection();
		
		private var _lines:ArrayCollection = new ArrayCollection();
		private var _linesChanged:Boolean = false;
	//	private var tipManager:BubbleTipManager;
		
		public var _textField:IUITextField;
		public var _otherChildren:String="";
		private var _parentLinePoints:String="";
		private var _labels:String="";
		private var _isShows:String = "";
		private var _hasShow:Boolean=false;
	//	private var detailsPanel:DetailsPanel;
		//private var fader:Fade;
		public function DefaultOrgChartNode(canView:Boolean){
			super();
			
			//fader.
			//buttonMode = true;
			//cornerRadius=0;
			
			//styleName="companyNode";
			if(canView){
				addEventListener(MouseEvent.CLICK, onClick);
			}
			
			//addEventListener(MouseEvent.MOUSE_OVER, onOver);
			//addEventListener(MouseEvent.MOUSE_OVER, onOver);
			/* addEventListener(FlexEvent.SHOW, onShow);
			addEventListener(FlexEvent.HIDE, onHide); */
			//addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onClick(e:MouseEvent):void{
			Application.application.showCompany(name)
		}
		
		private function onOver(e:MouseEvent):void{
			//this.toolTip = this;
			return;
		}
		/* private function onShow(event:Event):void{
			fader.alphaFrom = .5;
			fader.alphaTo = 1;
			if(fader.isPlaying){
				fader.stop();
			}
			fader.play();
		}
		
		private function onHide(event:Event):void{
			fader.alphaFrom = 1;
			fader.alphaTo = .5;
			if(fader.isPlaying){
				fader.stop();
			}
			fader.play();
		} */
		
		public function set parentNode(node:IOrgChartNode):void{
			if( node!= null){
				_parent = node;
				_parent.addChildNode(this);
			}
		}
		
		public function get parentNode():IOrgChartNode{
			return _parent;
		}
		
		public function get subNodes():ArrayCollection{
			return _subNodes;
		}
		
		public function addChildNode(node:IOrgChartNode):void{
			if(node != null){
				node.visible = expanded;
				subNodes.addItem(node);
			}
		}
		
		public function removeChildNode(node:IOrgChartNode):void{
		}
		
		public function removeChildNodeAt(index:int):void{
			
		}
		
		public function get hasChildren():Boolean{
			return subNodes.length == 0 ? false : true;
		}
		
		public function get depth():int{
			if(parentNode == null){
				return 0;
			}else{
				return parentNode.depth + 1;
			}
		}
		
		public function addLine(line:DisplayObject):void{
			if(line == null)return;
			line.visible = expanded;
			_lines.addItem(line);
			_linesChanged = true;
		}
		
		public function get firstChild():IOrgChartNode{
			if(subNodes.length == 0){
				return null;
			}else{
				return subNodes.getItemAt(0) as IOrgChartNode;
			}
		}
		
		public function get lastChild():IOrgChartNode{
			if(subNodes.length == 0){
				return null;
			}else{
				return subNodes.getItemAt(subNodes.length - 1) as IOrgChartNode;
			}
		}
		public function get previousSibling():IOrgChartNode{
			if(parentNode == null 
				|| parentNode.subNodes.length == 1 
				|| parentNode.subNodes.getItemIndex(this) == 0){
				return null;
			}else{ 
				return parentNode.subNodes.getItemAt(parentNode.subNodes.getItemIndex(this)-1) as IOrgChartNode;
			}
		}
		
		public function get nextSibling():IOrgChartNode{
			if(parentNode == null){
				return null;
			} 
			var subNodes:ArrayCollection = parentNode.subNodes;
			if(subNodes.length == 1){
				return null;
			}else if(subNodes.getItemIndex(this) == (subNodes.length - 1)){
				return null;
			}else{
				return subNodes.getItemAt(subNodes.getItemIndex(this) + 1) as IOrgChartNode;
			}
		}
		
		public function get expanded():Boolean{
			return _expanded;
		}
		public function expand():void{
			if(_expanded) return;
			for(var cursor:IViewCursor=subNodes.createCursor(); !cursor.afterLast; cursor.moveNext()){
				cursor.current.expand();
				cursor.current.visible = true;
			}
			for(cursor=_lines.createCursor(); !cursor.afterLast; cursor.moveNext()){
				cursor.current.visible = true;
			}
			_expanded = true;
		}
		
		public function collapse():void{
			if(!_expanded) return;
			for(var j:int=0; j<_lines.length; j++){
				_lines.getItemAt(j).visible = false;
			}
			for(var i:int=0; i<subNodes.length; i++){
				subNodes.getItemAt(i).collapse();
				subNodes.getItemAt(i).visible = false;
			}
			
			_expanded = false;
		}
		
		private var _oriented:String = "v";
		
		public function get oriented():String{
			return _oriented;
		}
		
		public function set oriented(theOriented:String):void{
			_oriented = theOriented;
		}
		
		public function get otherChildren():String{
			return _otherChildren;
		}
		public function set otherChildren(otherChildren:String):void{
			_otherChildren = otherChildren
		}
		
		override public function get data():Object{
			return _data;
		}
		//[Embed(source='/images/female.png')]
		//private var femaleIcon:Class;
		override public function set data(value:Object):void{
			_data =  value;
			_otherChildren = _data.@childid;
			_labels = _data.@Investment;
			_isShows = _data.@isshow;
			name=_data.@id;
			_parentLinePoints = _data.@point;
			dataChanged = true;
			invalidateProperties();
		}
		
		
		override protected function createChildren():void{
			super.createChildren();
			if(_textField == null){
				_textField = new UITextField();
				_textField.multiline = true;
				_textField.wordWrap = true;
				
				addChild(DisplayObject(_textField));
			}
		}
		
		override protected function measure():void{
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(_linesChanged){
				for(var cursor:IViewCursor = _lines.createCursor(); !cursor.afterLast; cursor.moveNext()){
					cursor.current.draw();
				}
				_linesChanged = false;
			}
			//Alert.show(oriented);
			if(oriented == "v"){
				_textField.y = 5;
				_textField.height = unscaledHeight - 5;
				_textField.width = unscaledWidth;
			}else{
				_textField.width = unscaledWidth;
				_textField.height = _textField.textHeight + 4;
				
				_textField.y = (unscaledHeight - _textField.height) / 2;	
			}
			
			
			//make text on top tier
			super.setChildIndex(DisplayObject(_textField), super.numChildren-1);
		}
		
		override protected function commitProperties():void{
			
			super.commitProperties();
			if(dataChanged && _data != null){
				//Alert.show(_data.@children);
				//otherChildre
				name=_data.@id;
				//Alert.show( _data.@childid);
				_otherChildren = _data.@childid;
				_labels = _data.@Investment;
				_isShows = _data.@isshow;
				//_parentLinePoints = _data.@point;
				//Alert.show(_data.@children);
				
				_textField.text = _data.@archivenum+"-"+_data.@cnName;
				this.toolTip = _textField.text;
				//_textField.toolTip = _textField.text;
				 if(_data.@type == "person" || _data.@type == "department"){
					//tipManager = new BubbleTipManager();
				//	if(detailsPanel == null){
					//	detailsPanel = new DetailsPanel();
					//	detailsPanel.data = _data;
				//	}
					//tipManager.createBubbleTip(this, "", detailsPanel);

					
				} 
				if(_data.@type == "more"){
					setStyle("color", "red");
					//setStyle("icon", femaleIcon);
					//setStyle("fontWeight", "bold");
				}
				
				if(_data.@selected=='true'){
					styleName = "companyNodeSelected";
				}else{
					styleName = "companyNode";
				}
			}
		}
		
		public function set hasShow(flag:Boolean):void{
			this._hasShow = flag;
		}
		
		public function get hasShow():Boolean{
			return _hasShow;
		}
		
		public function getChildLine(id:String):Array{
			//if()
			//Alert.show(_parentLinePoints);
			var childrenPoints:Array = new Array();
			var childrens:Array = _parentLinePoints.split("|");
			for(var i:int = 0;i<childrens.length;i++){
				var pointStr:String = childrens[i];
				if(pointStr.indexOf(id+"/")!=-1){
					pointStr = pointStr.substr(pointStr.indexOf("/")+1,pointStr.length);
				//	Alert.show(pointStr+"%%%"+id);
					if(pointStr!=""){
						var points:Array = pointStr.split(",")
						for(var i:int = 0;i<points.length;i++){
							var point :Point = new Point(points[i],points[i+1])
							childrenPoints.push(point);
							i++;
						}
					}
				}
			}
			
			return childrenPoints;
		}
		
		public function getChildLabel(id:String):String{
			//if()
			var label:String="";
			//Alert.show(_parentLinePoints);
			var childrenPoints:Array = new Array();
			var childrens:Array = _labels.split("|");
			for(var i:int = 0;i<childrens.length;i++){
				var pointStr:String = childrens[i];
				if(pointStr.indexOf(id+"/")!=-1){
					//
					pointStr = StringUtil.trim(pointStr);
					pointStr = pointStr.substr(pointStr.indexOf("/")+1,pointStr.length);
					//Alert.show(pointStr+"%%%"+id.length+"%%%"+pointStr.length);
					label = pointStr;
				}
			}
			
			return label;
		}
		
		public function getChildIsShow(id:String):String{
			var isshow:String="";
			//Alert.show(_parentLinePoints);
			var childrenPoints:Array = new Array();
			var childrens:Array = _isShows.split("|");
			for(var i:int = 0;i<childrens.length;i++){
				var pointStr:String = childrens[i];
				if(pointStr.indexOf(id+"/")!=-1){
					pointStr = pointStr.substr(pointStr.indexOf("/")+1,pointStr.length);
					//Alert.show(pointStr+"%%%"+id);
					isshow = pointStr;
				}
			}
			
			return isshow;
		}
	}
}