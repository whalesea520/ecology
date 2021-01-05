package control
{
	import mx.core.UIComponent;
	
	public class Circle extends UIComponent
	{
		
		public function Circle()
		{
			super();
		}
		
		private var _radius:Number = 20;
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
			_radius = value;
			invalidateDisplayList();
		}
		
		private var _borderColor:uint = 0x000000;
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			invalidateDisplayList();
		}
		
		private var _backgroundColor:uint = 0xFF0000;
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, 
																	   unscaledHeight:Number):void
		{
			super.updateDisplayList(5, 5);
			graphics.clear();
			if (isNaN(_radius))
				return;
			if (_radius <= 0)
				return;
			graphics.lineStyle(1, _borderColor, 1);
			graphics.beginFill(_backgroundColor, 1);
			graphics.drawCircle(Math.round(unscaledWidth / 2), 
				Math.round(unscaledHeight / 2), _radius);
			graphics.endFill();
		}
		
	}

}