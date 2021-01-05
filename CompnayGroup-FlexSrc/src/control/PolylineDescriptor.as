package control{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flexlib.containers.DragScrollingCanvas;
	
	import mx.controls.Alert;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;

	public class PolylineDescriptor extends UIComponent {
		
		private var _hasArrowHead:Boolean=false;
		
		/////////////////////////////////////////
		//线的样式
		//////////////////////////////////////////
		private var _thinkness:Number = 2;
		private var _color:uint = 0x000000;
		private var _alpha:Number = 1;
		private var _pixelHinting:Boolean = false;
		private var _scaleMode:String = "normal";
		private var _points:ArrayCollection;
		private var _pointObjs:ArrayCollection;
		private var _drag:Boolean=false;
		private var _activePoint:PointDescriptor;
		private var _orgChartContainer:OrgChart;
		private var _init:Boolean=false;
		private var _canEdit:Boolean;
		private var _label:LabelDescriptor;
		private var _hasLabel:Boolean;
		private var _scale:Number = 1;
	
		public function PolylineDescriptor(orgChartContainer:OrgChart,thePoints:ArrayCollection=null,
										hasArrow:Boolean=false,canEdit:Boolean=false,hasLabel:Boolean=true,labelText:String=""){
			this.doubleClickEnabled=true;
			_orgChartContainer = orgChartContainer;
			points = thePoints;
			_hasLabel = hasLabel
			if(hasLabel){
				_label = new LabelDescriptor(labelText);
				if(points.length==3){
					var p = points[1] as Point;
					_label.x=p.x+3
					_label.y=p.y-10;
				}else if(points.length==2){
					var p:Point=getMiddlePoint(_points.getItemAt(0) as Point,_points.getItemAt(1) as Point);
					_label.x=p.x+3
					_label.y=p.y-10;
				}else{
					var p = points[2] as Point;
					_label.x=p.x+3
					_label.y=p.y-10;
				}
				_orgChartContainer.addToContainer(_label);
			}
			//Alert.show(_label.label);
			
			_pointObjs = new ArrayCollection(new Array());
			
			hasArrowHead = hasArrow;
			_init = true;
			
			_canEdit = canEdit;
			
			if(canEdit){
				addEventListener(MouseEvent.MOUSE_OVER, lineMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT, lineMouseOut);
				//addEventListener(MouseEvent.MOUSE_UP, lineMouseUp);
				addEventListener(MouseEvent.MOUSE_DOWN, lineMouseDown);
				addEventListener(MouseEvent.DOUBLE_CLICK,lineDClick);
				//addEventListener(MouseEvent.MOUSE_MOVE, lineMouseMove);
				//_orgChartContainer.parent
				_orgChartContainer.parent.addEventListener(MouseEvent.MOUSE_MOVE,lineMouseMove);
				_orgChartContainer.parent.addEventListener(MouseEvent.MOUSE_UP,lineMouseUp);
			}
			
			//addEventListener(MouseEvent.MOUSE_MOVE, lineMouseMove);
		}
		
		
		private function lineDClick(e:MouseEvent):void{
			var start:Point=_points.getItemAt(0) as Point;
			var end:Point = _points.getItemAt(_points.length-1) as Point;
			var array:Array = new Array();
			array.push(start);
			array.push(end);
			_points = new ArrayCollection(array);
			for(var i:int=0;i<_pointObjs.length;i++){
				var _pointObj:PointDescriptor = _pointObjs.getItemAt(i) as PointDescriptor;
				_pointObj.remove();
			}
			draw();
			var mPoint:Point=getMiddlePoint(_points.getItemAt(0) as Point,_points.getItemAt(1) as Point);
			_label.x=mPoint.x+10;
			_label.y=mPoint.y+10;
			
		}
		
		private function lineMouseOver(e:MouseEvent):void{
			//Alert.show("1");
			//lineStyle(_thinkness, _color, _alpha, _pixelHinting, _scaleMode);
			//this.styleName="test";
			//_thinkness=1;
			//this.buttonMode=true;
			//this.useHandCursor=true;
			//this.mouseChildren=false;
			
			if(!_drag){
				_color = 0xff0000;
				draw();
			}
			//e.stopImmediatePropagation();
		}
		
		private function lineMouseOut(e:MouseEvent):void{
			//Alert.show("1");
			//lineStyle(_thinkness, _color, _alpha, _pixelHinting, _scaleMode);
			//this.styleName="test";
			//_thinkness=1;
			//_color = 0x000000;
			//_drag = false;
			//draw();
			//e.stopImmediatePropagation();
			if(!_drag){
				_color = 0x000000;
				draw();
			}
		}
		
		private function addOtherPoint():void{
			for(var i:int=1; i<points.length-1; i++){
				var p:Point = Point(points.getItemAt(i));
				var point:PointDescriptor = new PointDescriptor(p.x,p.y,this,_canEdit);
				if(points.length>3){
					point.index=i;
				}else{
					point.index=2;
						
				}
				_orgChartContainer.addChild(point);
				_pointObjs.addItem(point);
			}
		}
		
		private function lineMouseDown(e:MouseEvent):void{
			//Alert.show("true");
			_drag = true;
			
			_color = 0xff0000;
			draw();
			 
			if(_activePoint==null){
			    if(_points.length==2){
					var mPoint:Point=getMiddlePoint(_points.getItemAt(0) as Point,_points.getItemAt(1) as Point);
					var point:PointDescriptor = new PointDescriptor(mPoint.x,mPoint.y,this,_canEdit);
					//_activePoint=point;
					point.index=2;
					_points.addItemAt(new Point(e.localX,e.localY),1)
					//addChild(point);
					_orgChartContainer.addChild(point);
					_activePoint=point;
					_pointObjs.addItem(point);
					
				}else if(_points.length==3){
					//var point:PointDescriptor=getChildAt(0) as PointDescriptor;
					//point.index=2;
					var mPoint:Point=getMiddlePoint(_points.getItemAt(0) as Point,_points.getItemAt(1) as Point);
					var point:PointDescriptor = new PointDescriptor(mPoint.x,mPoint.y,this,_canEdit);
					//_activePoint=point;
					point.index=1;
					
					_points.addItemAt(new Point(mPoint.x,mPoint.y),1)
					_orgChartContainer.addChild(point);
					_pointObjs.addItemAt(point,0);
					//addChild(point);	
					
					var mPoint:Point=getMiddlePoint(_points.getItemAt(2) as Point,_points.getItemAt(3) as Point);
					var point:PointDescriptor = new PointDescriptor(mPoint.x,mPoint.y,this,_canEdit);
					//_activePoint=point;
					point.index=3;
					_points.addItemAt(new Point(mPoint.x,mPoint.y),3)
					_orgChartContainer.addChild(point);
					_pointObjs.addItemAt(point,2);
				}
			}
			e.stopImmediatePropagation();
			
		}
		
		
		
		private function lineMouseUp(e:MouseEvent):void{
			_drag = false;
			_activePoint=null;
			var obj:DragScrollingCanvas = _orgChartContainer.parent as DragScrollingCanvas;
			if((e.stageY+obj.verticalScrollPosition)>_orgChartContainer.height){
				_orgChartContainer.height = (e.stageY+obj.verticalScrollPosition)/_orgChartContainer.scaleY+10;
			}
			//e.stopImmediatePropagation();
			
		}
		
		private function lineMouseMove(e:MouseEvent):void{
			if(_orgChartContainer.scaleX<1){
				_scale =_orgChartContainer.scaleX;
			}else{
				_scale =_orgChartContainer.scaleX;
			}
			if(_activePoint!=null){
				var index:int=1;
				if(_points.length>3){
					index=_activePoint.index;
				}
				var obj:DragScrollingCanvas = _orgChartContainer.parent as DragScrollingCanvas;
				//obj.horizontalScrollPosition
				_color = 0x0000ff;
				
				_activePoint.updatePoint((e.stageX+obj.horizontalScrollPosition)/_scale,(e.stageY+obj.verticalScrollPosition)/_orgChartContainer.scaleY);
				_points.setItemAt(new Point((e.stageX+obj.horizontalScrollPosition)/_scale,(e.stageY+obj.verticalScrollPosition)/_orgChartContainer.scaleY),index);
				draw();
				if(_activePoint.index==2&&_hasLabel){
					_label.x=(e.stageX+obj.horizontalScrollPosition)/_scale;
					_label.y=(e.stageY+obj.verticalScrollPosition)/_orgChartContainer.scaleY;
				}
				//Alert.show("true"+_orgChartContainer.scaleX);
			}
			
		}
		
		public function getMiddlePoint(start:Point,end:Point):Point{
			
			//Alert.show(start.x+"%%"+start.y+"^^^^"+end.x+"%%%"+end.y);
			return new Point(start.x+(end.x-start.x)/2,start.y+(end.y-start.y)/2);
		}
		
		/**
		 * 划线
		 * */
		public function draw():void{
			graphics.clear();
			with(graphics){
				lineStyle(_thinkness, _color, _alpha, _pixelHinting, _scaleMode);
				
				for(var i:int=0; i<points.length; i++){
					var p:Point = Point(points.getItemAt(i));
					if(i==0){
						moveTo(p.x, p.y);
						//var point:PointDescriptor = new PointDescriptor(p.x,p.y);
						//addChild(point);
						//var ce:Circle=new Circle();
						//ce.updateDisplayList(5,5);
					}
					
					lineTo(p.x, p.y);
					
				}
			}
			
			if(hasArrowHead){
				drawArrowHead();
			}
			if(_init){
				addOtherPoint();
			}
			_init = false;
			
		}
		
		/**
		 * 画箭头
		 * draw arrow for line 
		 **/
		private function drawArrowHead():void{
			
			var startX:Number = Point(points.getItemAt(0)).x;
			var startY:Number =  Point(points.getItemAt(0)).y;
			if(points.length > 1){
				startX = Point(points.getItemAt(points.length-2)).x;
				startY = Point(points.getItemAt(points.length-2)).y;
			}
			var endX:Number =  Point(points.getItemAt(points.length-1)).x;
			var endY:Number =  Point(points.getItemAt(points.length-1)).y;
			var arrowLength : Number = 5;
			var arrowAngle : Number = Math.PI / 6;
			var lineAngle : Number;
			if(endX - startX != 0)				
				lineAngle = Math.atan((endY - startY) / (endX - startX));
			else{
				if(endY - startY < 0)
					lineAngle = Math.PI / 2;
				else
					lineAngle = 3 * Math.PI / 2;
			}				
			if(endY - startY >= 0 && endX - startX <= 0){
				lineAngle = lineAngle + Math.PI;
			}else if(endY - startY <= 0 && endX - startX <= 0){
				lineAngle = lineAngle + Math.PI;
			}
			//定义三角形
			var angleC : Number = arrowAngle;
			var rimA : Number = arrowLength;
			var rimB : Number = Math.pow(Math.pow(endY - startY,2) + Math.pow(endX - startX,2),1/2);
			var rimC : Number = Math.pow(Math.pow(rimA,2) + Math.pow(rimB,2) - 2 * rimA * rimB * Math.cos(angleC),1/2);
			var angleA : Number = Math.acos((rimB - rimA * Math.cos(angleC)) / rimC);
			
			var leftArrowAngle : Number = lineAngle + angleA;
			var rightArrowAngle : Number = lineAngle - angleA;			
			var leftArrowX : Number = startX + rimC * Math.cos(leftArrowAngle);
			var leftArrowY : Number = startY + rimC * Math.sin(leftArrowAngle);			
			var rightArrowX : Number = startX + rimC * Math.cos(rightArrowAngle);
			var rightArrowY : Number = startY + rimC * Math.sin(rightArrowAngle);
			
			
			with(graphics){
				moveTo(endX, endY);
				lineTo(leftArrowX, leftArrowY);
				moveTo(endX, endY);
				lineTo(rightArrowX, rightArrowY);
			}
		}
		
		/**
		 * 是否有箭头
		 **/
		public function get hasArrowHead():Boolean{
			return _hasArrowHead;
		}
		public function set hasArrowHead(value:Boolean):void{
			_hasArrowHead = value;
		}
		
		/**
		 * 线的起点
		 **/
		public function get points():ArrayCollection{
			return _points;
		}
		public function set points(value:ArrayCollection):void{
			if(!value){
				_points = new ArrayCollection();
				_points.addItem(new Point(0, 0));
			}else{
				_points = value;
			}
		}
		
		public function updateLine(points:ArrayCollection):void{
			if(points){
				_points = points;
				_color = 0x0000ff;
				draw();
				
				//Alert.show("1");
			}
		}
		
		public function updateLable(p:Point):void{
			_label.x=p.x+3
			_label.y=p.y-10;
		}
		
		public function removePointAt(index:int):void{
			_points.removeItemAt(index);
			draw();
		}
		
		public function set activePoint(active:PointDescriptor):void{
			this._activePoint = active;
		
		}
		
		/**
		 * 折线顶点转换为字符串，中间用','隔开 
		 */
		public function pointToString():String{
			var str:String="";
			if(_points.length>2){
				for(var i:int=1;i<_points.length-1;i++){
					var p:Point = _points.getItemAt(i) as Point;
					str += p.x+","+p.y+",";
					
				}
			}
			if(str.length>1){
				str = str.substr(0,str.length-1);
			}
			return str;
			
		}
		
		public function clear():void{
			for(var i:int=0;i<_pointObjs.length;i++){
				var _pointObj:PointDescriptor = _pointObjs.getItemAt(i) as PointDescriptor;
				_pointObj.remove();
			}
		}
		//public function get
	}
}