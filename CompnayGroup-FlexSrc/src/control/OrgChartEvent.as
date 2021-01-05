package control{
	import flash.events.Event;

	public class OrgChartEvent extends Event{
		
		public static const NODE_CLICK:String="nodeClick";
		public static const NODE_SELECTED:String="nodeSelected";
		public static const NODE_MOUSE_OVER:String="nodeMouseOver";
		public static const NODE_MOUSE_OUT:String="nodeMouseOut";
		
		
		private var _node:IOrgChartNode;
		public function OrgChartEvent(type:String, theNode:IOrgChartNode=null, bubbles:Boolean=false, cancelable:Boolean=false){
			_node = theNode;
			super(type, bubbles, cancelable);
		}
		
		public function set node(theNode:IOrgChartNode):void{
			_node = theNode;
		}
		public function get node():IOrgChartNode{
			return _node;
		}
	}
}