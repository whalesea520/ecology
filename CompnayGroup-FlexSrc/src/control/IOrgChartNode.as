package control
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.core.IDataRenderer;
	import mx.core.IUIComponent;
	import mx.styles.IStyleClient;

	public interface IOrgChartNode extends IDataRenderer, IUIComponent, IStyleClient{
		/**
		 * 指定是横向还是竖向的矩形
		 * h 为横向
		 * v 为竖向
		 * --- Should be better in future.
		 * */
		function get oriented():String;
		function set oriented(oriented:String):void;
		
		function set parentNode(node:IOrgChartNode):void;
		function get parentNode():IOrgChartNode;
		
		function get subNodes():ArrayCollection;
		
		function addChildNode(node:IOrgChartNode):void;
		
		function removeChildNode(node:IOrgChartNode):void;
		
		function removeChildNodeAt(index:int):void;
		
		function get previousSibling():IOrgChartNode;
		
		function get nextSibling():IOrgChartNode;
		
		function get firstChild():IOrgChartNode;
		
		function get lastChild():IOrgChartNode;
		
		function get expanded():Boolean;
		
		function addLine(line:DisplayObject):void;
		
		function get hasChildren():Boolean;
		
		function get otherChildren():String;
		function set otherChildren(otherChildren:String):void;
		
		/**
		 * start from 0, it means the depth of  root node is zero. 
		 * 节点所在层级，从 0 开始，也就是说最上层节点值为 0。
		 **/
		function get depth():int;
		
		function expand():void;
		
		function collapse():void;
		
		function set hasShow(flag:Boolean):void;
		function get hasShow():Boolean;
		function getChildLine(id:String):Array;
		function getChildLabel(id:String):String;
		function getChildIsShow(id:String):String;
	}
}