package control
{
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.collections.ArrayCollection;

	public class PointDescriptor extends UIComponent
	{
		//定点样式
		private var _thinkness:Number = 3;
		private var _color:uint = 0x000000;
		private var _alpha:Number = 1;
		private var _pixelHinting:Boolean = false;
		private var _scaleMode:String = "normal";
		private var _x:int=0;
		private var _y:int=0;
		private var _index:int=0;
		private var _line:PolylineDescriptor;
		public function PointDescriptor(x:int,y:int,line:PolylineDescriptor,canEdit:Boolean)
		{
			_x=x;
			_y=y;
			_line=line;
			draw();
			this.doubleClickEnabled=true;
			//Alert.show("test");
			//addE
			if(canEdit){
				addEventListener(MouseEvent.MOUSE_OVER,doOver);
				addEventListener(MouseEvent.MOUSE_UP,doUp);
				addEventListener(MouseEvent.MOUSE_DOWN,doClick);
				addEventListener(MouseEvent.DOUBLE_CLICK,doDClick);
			}
			//addEventListener(MouseEvent.MOUSE_DOWN,doClick);
		}
		
		private function doUp(e:MouseEvent):void{
			_line.activePoint=null;
		}
		
		private function doOver(e:MouseEvent):void{
			_color=0x0000ff;
			draw();
		}
		private function stopEvent(e:MouseEvent):void{
			e.stopImmediatePropagation();
		}
		
		private function doClick(e:MouseEvent):void{
			//Alert.show("tset");
			_line.activePoint=this;
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		
		private function doDClick(e:MouseEvent):void{
			//Alert.show("test");
			return;
			var _index:int=1;
			
			var _pionts:ArrayCollection=_line.points;
			if(_pionts.length>3){
				_index=index;
			}
			var point:Point=null;
			if(_index==2&&false){
				point =_line.getMiddlePoint(_pionts.getItemAt(_index-2)as Point,_pionts.getItemAt(_index+2) as Point);
			}else{
				point =_line.getMiddlePoint(_pionts.getItemAt(_index-1)as Point,_pionts.getItemAt(_index+1) as Point);
			}
			//_pionts
			_pionts.setItemAt(point,_index);
			if(_index==2){
				_line.updateLable(point);
			}
			//_line.removePointAt(_index);
			this.updatePoint(point.x,point.y);
			//graphics.clear();
			e.stopPropagation();
		}
		public function updatePoint(newX:int,newY:int):void{
			_x=newX;
			_y=newY;
			draw();
		
		}
		
		/**
		 * 划点
		 * */
		public function draw():void{
			graphics.clear();
			with(graphics){
				//graphics.lineStyle(2,0x990033,1);
				graphics.beginFill(_color); //填充颜色
				//Alert.show(""+_x+"%%"+_y)
				graphics.drawCircle(_x,_y,4);
				graphics.endFill(); //停止填充
			}
			//Alert.show(this.parent.name);
			//Alert.show(hasArrowHead+"");
		}
		
		public function remove():void{
			graphics.clear();
		}
		
		public function set index(index:int):void{
			this._index=index;
		}
		
		public function get index():int{
			return this._index;
		}
	}
}