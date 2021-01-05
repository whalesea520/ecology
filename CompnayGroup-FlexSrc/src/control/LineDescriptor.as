package control{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.*;
	import mx.core.UIComponent;

	public class LineDescriptor extends UIComponent {
		
		private var _start:Point = new Point(0, 0);
		private var _startX:Number;
		private var _startY:Number;
		
		private var _end:Point = new Point(0, 0);
		private var _endX:Number;
		private var _endY:Number;
		
		private var _hasArrowHead:Boolean=false;
		
		/////////////////////////////////////////
		//线的样式
		//////////////////////////////////////////
		private var _thinkness:Number = 1.5;
		private var _color:uint = 0x000000;
		private var _alpha:Number = 1;
		private var _pixelHinting:Boolean = false;
		private var _scaleMode:String = "normal";
		
		
		public function LineDescriptor(startPoint:Point=null,
										endPoint:Point=null,
										hasArrow:Boolean=false){
			start = startPoint;
			end = endPoint;
			hasArrowHead = hasArrow;
			//addEventListener(MouseEvent.CLICK, onClick);
			//addEventListener(MouseEvent.MOUSE_OVER, lineMouseOver);
			//addEventListener(MouseEvent.MOUSE_OUT, lineMouseOut);
			//addEventListener(MouseEvent.MOUSE_UP, lineMouseOut);
			//addEventListener(MouseEvent.MOUSE_DOWN, lineMouseOut);
			//addEventListener(MouseEvent.MOUSE_MOVE, lineMouseMove);
			
		}
		private function lineMouseOver(e:MouseEvent):void{
			//Alert.show("1");
			//lineStyle(_thinkness, _color, _alpha, _pixelHinting, _scaleMode);
			//this.styleName="test";
			//_thinkness=1;
			_color = 0xff0000;
			draw();
		}
		
		private function lineMouseOut(e:MouseEvent):void{
			//Alert.show("1");
			//lineStyle(_thinkness, _color, _alpha, _pixelHinting, _scaleMode);
			//this.styleName="test";
			//_thinkness=1;
			_color = 0x000000;
			draw();
		}
		
		private function lineMouseDown(e:MouseEvent):void{

		}
		
		private function lineMouseUp(e:MouseEvent):void{
			
		}
		
		private function lineMouseMove(e:MouseEvent):void{
			
		}
		
		/**
		 * 划线
		 * */
		public function draw():void{
			graphics.clear();
			with(graphics){
				lineStyle(_thinkness, _color, _alpha, _pixelHinting, _scaleMode);
				moveTo(start.x, start.y);
				//lineTo(start.x+10, start.y+10);
				//curveTo(start.x,start.y,start.x,start.y)
				
				lineTo(end.x, end.y);	
			}
			//Alert.show(hasArrowHead+"");
			if(hasArrowHead){
				drawArrowHead();
			}
		}
		
		/**
		 * 画箭头
		 * draw arrow for line 
		 **/
		private function drawArrowHead():void{
			//return;
			var startX:Number = start.x;
			var startY:Number = start.y;
			var endX:Number = end.x;
			var endY:Number = end.y;
			
			var arrowLength : Number = 6;
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
				moveTo(end.x, end.y);
				lineTo(leftArrowX, leftArrowY);
				moveTo(end.x, end.y);
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
		public function get start():Point{
			return _start;
		}
		public function set start(value:Point):void{
			if(value){
				_start = value;
			}
		}
		
		/**
		 * 起点的X坐标
		 **/
		public function get startX():Number{
			return _start.x;
		}
		public function set startX(value:Number):void{
			_start.x = value;
		}
		
		/**
		 * 起点的Y坐标
		 **/
		public function get startY():Number{
			return _start.y;
		}
		public function set startY(value:Number):void{
			_start.y = value;
		}
		
		/**
		 * 线的终点
		 **/
		public function get end():Point{
			return _end;
		}
		public function set end(value:Point):void{
			if(value){
				_end = value;
			}
		}
		
		/**
		 * 终点的X坐标
		 **/
		public function get endX():Number{
			return end.x;
		}
		public function set endX(value:Number):void{
			_end.x = value;
		}
		
		/**
		 * 终点的Y坐标
		 **/
		public function get endY():Number{
			return end.y;
		}
		public function set endY(value:Number):void{
			_end.y = value;
		}
		
	}
}