/**
 * Neal Mi
 * email: imzw.net@gmail.com
 *
 * Any problem, please contact me via email. Please use following format as Subject.
 * format: OrgChart  -  your problem - your name
 * eg: OrgChart - node in a bad position -  neal
 *
 * 有任何问题，请通过电子邮件联系我。使用以下的格式做为邮件的主题。
 * 格式： OrgChart - 问题的一句话描述 - 你的名字
 * 示例： OrgChart - 节点错位 - Peter Wang
 **/
package control {
	/* import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	*/
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import flexlib.containers.DragScrollingCanvas;
	
	import mx.controls.Alert;
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.Zoom;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.events.CloseEvent;
	
	import util.XmlUtil;
	import common.StaticObj;
 
	
	[Event(name="nodeClick", type="control.OrgChartEvent")]
	[Event(name="nodeSelected", type="control.OrgChartEvent")]
	[Event(name="nodeMouseOver", type="control.OrgChartEvent")]
	[Event(name="nodeMouseOut", type="control.OrgChartEvent")]
	
	public class OrgChart extends UIComponent {
			
		private var _data:ICollectionView;
		private var dataProviderChanged:Boolean=false;
		private var _treeDataDesciptor:ITreeDataDescriptor=new DefaultDataDescriptor;
		
		private var _children:ArrayCollection=new ArrayCollection();
		
		private var _selectable:Boolean=true;
		private var _selected:IOrgChartNode=null;
		private var _depth:int=0;
		private var _currentDepth:int=0;
		private var _maxX:Number=0;
		private var _maxY:Number=0;
		
		/*
		They're should be better.
		*/
		private var _hItemWidth:Number=180; //横向的节点
		private var _hItemHeight:Number=50;
		
		private var _vItemWidth:Number=25; //纵向的节点
		private var _vItemHeight:Number=80;
		
		private var _verticalSpacing:Number=40; //间隔
		private var _horizonalSpacing:Number=40; //
		
		private var _container:DragScrollingCanvas;
		
		
		private var _nodes:ArrayCollection=new ArrayCollection();
		private var _polyLines:ArrayCollection = new ArrayCollection();
		private var _maxHeight:Number=0;
		private var _maxWidth:Number=0;
		
		private var _canEdit:Boolean=false;
		private var _canView:Boolean =false;
		public function OrgChart() {
			
			super();
		}
		
		///////////////////////////////////////////////////////////
		// Private funtions
		///////////////////////////////////////////////////////////
		/**
		 * 计算树的深度，即为XML文件有多少层级
		 **/
		private function calculateDepth(data:ICollectionView):void {
			for (var cursor:IViewCursor=data.createCursor(); !cursor.afterLast; cursor.moveNext()) {
				if (_treeDataDesciptor.isBranch(cursor.current, data) && _treeDataDesciptor.getChildren(cursor.current, data).length != 0) {
					
					_currentDepth++;
					
					if (_currentDepth > _depth) {
						_depth=_currentDepth;
					}
					
					var __tmp:ICollectionView=_treeDataDesciptor.getChildren(cursor.current, data);
					calculateDepth(__tmp);
					
					_currentDepth--;
				}
			}
			//Alert.show("zzl--xml总共有多少层"+_currentDepth);
		}
		
		/**
		 * 创建子节点
		 * */
		private function _createSubNodes(data:ICollectionView, parentNode:IOrgChartNode):void {
			for (var cursor:IViewCursor=data.createCursor(); !cursor.afterLast; cursor.moveNext()) {
				
				//Alert.show("zzl-创建子节点"+parentNode);
				var node:IOrgChartNode=_createNode(cursor.current, parentNode);
				
				if (_treeDataDesciptor.isBranch(cursor.current, data) && _treeDataDesciptor.getChildren(cursor.current, data).length != 0) {
					
					//I know this is not good, but...
					if (cursor.current.@type != "more") {
						var __tmp:ICollectionView=_treeDataDesciptor.getChildren(cursor.current, data);
						_createSubNodes(__tmp, node);
					}
				}
			}
			
		}
		private function updatePosition(node:IOrgChartNode):void{
			var my:Number = getMaxY(node);
			
		}
		
		private function getMaxY(node:IOrgChartNode):Number{
			var ny:Number = node.y;
			var subs:ArrayCollection = node.subNodes;
			for(var i:int=0; i<subs.length; i++){
				var sn:IOrgChartNode = subs.getItemAt(i) as IOrgChartNode;
				ny = Math.max(ny, getMaxY(sn));
			}
			
			return ny;
		}
		/**
		 * 创建节点
		 * */
		private function _createNode2(data:Object, parentNode:IOrgChartNode):IOrgChartNode {
			//Alert.show("zzl-创建节点");
			var node:IOrgChartNode=new DefaultOrgChartNode(_canView);
			
			//node.addEventListener(MouseEvent.CLICK, nodeClick);
			/*node.addEventListener(MouseEvent.MOUSE_OVER, nodeMouseOver);
			node.addEventListener(MouseEvent.ROLL_OVER, nodeRollOver);
			node.addEventListener(MouseEvent.ROLL_OUT, nodeRollOut);
			node.addEventListener(MouseEvent.MOUSE_OUT, nodeMouseOut);*/
			
			node.parentNode=parentNode;
			node.data=data;
			
			
			node.width=hItemWidth;
			node.height=hItemHeight;
			node.oriented="v";
			
			
			//起始时，根节点在最左边
			if (parentNode == null) {
				node.x=horizontalSpacing;
				node.y=verticalSpacing;
			} else {
				normalLayout2(node);
				
				//移动父节点
				updateParentNodePosition2(node.parentNode);
			}
			
			_nodes.addItem(node);
			
			return node;
		}
		
		private function normalLayout2(node:IOrgChartNode):IOrgChartNode {
			var parentNode:IOrgChartNode=node.parentNode;
			if (node.previousSibling == null) {
				//与父节点在同一中轴线上
				node.y=parentNode.y + (parentNode.height - node.height) / 2;
				//我们只保存最大值
				_maxY=Math.max(node.y + node.height, parentNode.y + parentNode.height);
			} else {
				node.y=_maxY + verticalSpacing;
				_maxY=Math.max(node.y + node.height, _maxY);
			}
			node.x=parentNode.x + parentNode.width + horizontalSpacing;
			
			return node;
		}
		
		/**
		 * 递归移动所有父节点的位置。
		 * Recursive update the positon of parent node.
		 * */
		private function updateParentNodePosition2(node:IOrgChartNode):void {
			if (node != null) {
				var subs:ArrayCollection=node.subNodes;
				var lastChild:IOrgChartNode=node.firstChild;
				var firstChild:IOrgChartNode=node.lastChild;
				
				node.y=firstChild.y + (lastChild.y - firstChild.y + lastChild.height - node.height) / 2;
				//递归更新直到根节点
				updateParentNodePosition2(node.parentNode);
			}
		}
		
		/**
		 * 创建节点之间的线
		 * */
		private function createLines2(node:IOrgChartNode):void {
			//Alert.show("zzl创建节点之间的线");
			createLineForNormalLayout2(node);
		}
		/**
		 * 创建节点之间的线（正常布局）
		 * */
		private function createLineForNormalLayout2(node:IOrgChartNode):void {
			//画当前节点下面的短竖线
			//Alert.show("test");
			if (node.hasChildren) {
				//Alert.show("1");
				var headVLine:LineDescriptor=new LineDescriptor();
				headVLine.startY=node.y + node.height / 2;
				headVLine.startX=node.x + node.width;
				
				headVLine.endY=headVLine.startY;
				if (node.subNodes.length == 1) {
					headVLine.endX=node.x + node.width + horizontalSpacing;
				} else {
					headVLine.endX=node.x + node.width + horizontalSpacing / 2;
				}
				
				headVLine.hasArrowHead=true;
				
				node.addLine(headVLine);
				addToContainer(headVLine);
			}
			
			var subs:ArrayCollection=node.subNodes;
			
			//画子节点上面的横线，跨度从第一个子节点的中心到最后一个子节点的中心
			if (subs.length > 1) {
				
				var firstChild:IOrgChartNode=subs.getItemAt(0) as IOrgChartNode;
				var lastChild:IOrgChartNode=subs.getItemAt(subs.length - 1) as IOrgChartNode;
				//Alert.show("2");
				var hLine:LineDescriptor=new LineDescriptor();
				hLine.startY=firstChild.y + firstChild.height / 2;
				hLine.startX=node.x + node.width + horizontalSpacing / 2;
				
				hLine.endY=hLine.startY + lastChild.y + lastChild.height / 2 - (firstChild.y + firstChild.height / 2);
				hLine.endX=hLine.startX;
				
				addToContainer(hLine);
				node.addLine(hLine);
				
				//画每个子节点头上的短竖线
				for (var j:int=0; j < subs.length; j++) {
					var child:IOrgChartNode=subs.getItemAt(j) as IOrgChartNode;
					//Alert.show("3");
					var vline:LineDescriptor=new LineDescriptor();
					
					vline.startY=child.y + child.height / 2;
					vline.startX=child.x - horizontalSpacing / 2;
					
					vline.endY=vline.startY;
					vline.endX=vline.startX + horizontalSpacing / 2;
					
					node.addLine(vline);
					addToContainer(vline);
				}
			}
		}
		
		/**
		 * 创建节点
		 * */
		private function _createNode(data:Object, parentNode:IOrgChartNode):IOrgChartNode {
			
			var node:IOrgChartNode=new DefaultOrgChartNode(_canView);
			
			//node.addEventListener(MouseEvent.CLICK, nodeClick);
			
			node.parentNode=parentNode;
			node.data=data;
			
			
			node.width=hItemWidth;
			node.height=hItemHeight;
			node.oriented="h";
			
			
			//起始时，根节点在最左边
			if (parentNode == null) {
				//parentNode == null说明是跟节点
				node.x=horizontalSpacing;
				node.y=verticalSpacing;
			} else {
				
				if (node.parentNode.data.@layout == "leftHanging") {
					leftHangingLayout(node);
				} else if (node.parentNode.data.@layout == "rightHanging") {
					rightHangingLayout(node);
				} else if (node.parentNode.data.@layout == "bothHanging") {
					bothHangingLayout(node);
				} else {
					normalLayout(node);
				}
				
				//移动父节点
				updateParentNodePosition(node.parentNode);
			}
			
			_nodes.addItem(node);
			
			return node;
		}
		
		/**
		 * 左侧悬挂布局（leftHanging）
		 * */
		private function leftHangingLayout(node:IOrgChartNode):IOrgChartNode {
			var parentNode:IOrgChartNode=node.parentNode;
			if (node.previousSibling == null) {
				node.x=parentNode.x;
				node.y=parentNode.y + parentNode.height + verticalSpacing / 2;
			} else {
				node.x=node.previousSibling.x;
				_maxX=Math.max(node.x + node.width, _maxX);
				node.y=node.previousSibling.y + node.previousSibling.height + verticalSpacing / 2;
			}
			return node;
		}
		
		/**
		 *  右侧悬挂布局（rightHanging）
		 * */
		private function rightHangingLayout(node:IOrgChartNode):IOrgChartNode {
			var parentNode:IOrgChartNode=node.parentNode;
			if (node.previousSibling == null) {
				node.x=parentNode.x + parentNode.width / 2 + horizontalSpacing / 2;
				node.y=parentNode.y + parentNode.height + verticalSpacing / 2;
			} else {
				node.x=node.previousSibling.x;
				_maxX=Math.max(node.x + node.width, _maxX);
				node.y=node.previousSibling.y + node.previousSibling.height + verticalSpacing / 2;
			}
			return node;
		}
		
		/**
		 * 两侧侧悬挂布局（bothHanging）
		 * */
		private function bothHangingLayout(node:IOrgChartNode):IOrgChartNode {
			var parentNode:IOrgChartNode=node.parentNode;
			if (node.previousSibling == null) {
				node.x=parentNode.x;
				node.y=parentNode.y + parentNode.height + verticalSpacing / 2;
			} else {
				if (parentNode.subNodes.length % 2 == 0) {
					node.x=node.previousSibling.x + node.previousSibling.width + horizontalSpacing;
					node.y=node.previousSibling.y;
					
					_maxX=Math.max(node.x + node.width, _maxX);
				} else {
					node.x=node.previousSibling.previousSibling.x;
					node.y=node.previousSibling.previousSibling.y + node.previousSibling.previousSibling.height + verticalSpacing / 2;
				}
			}
			return node;
		}
		
		private function normalLayout(node:IOrgChartNode):IOrgChartNode {
			var parentNode:IOrgChartNode=node.parentNode;
			if (node.previousSibling == null) {
				//与父节点在同一中轴线上
				node.x=parentNode.x + (parentNode.width - node.width) / 2;
				//我们只保存最大值
				_maxX=Math.max(node.x + node.width, parentNode.x + parentNode.width);
			} else {
				node.x=_maxX + horizontalSpacing;
				_maxX=Math.max(node.x + node.width, _maxX);
			}
			node.y=parentNode.y + parentNode.height + verticalSpacing;
			
			return node;
		}
		
		/**
		 * 递归移动所有父节点的位置。
		 * Recursive update the positon of parent node.
		 * */
		private function updateParentNodePosition(node:IOrgChartNode):void {
			if (node != null) {
				if (node.data.@layout == "leftHanging" || node.data.@layout == "bothHanging") {
					if (node.previousSibling != null) {
						node.x=node.previousSibling.x + node.previousSibling.width / 2 + horizontalSpacing / 2;
					}
					node.x=node.firstChild.x + node.firstChild.width / 2 + horizontalSpacing / 2;
					_maxX=Math.max(node.x + node.width, _maxX);
				} else if (node.data.@layout == "rightHanging") {
					updateParentNodePosition(node.parentNode);
				} else {
					var subs:ArrayCollection=node.subNodes;
					var lastChild:IOrgChartNode=node.firstChild;
					var firstChild:IOrgChartNode=node.lastChild;
					
					node.x=firstChild.x + (lastChild.x - firstChild.x + lastChild.width - node.width) / 2;
				}
				//递归更新直到根节点
				updateParentNodePosition(node.parentNode);
			}
		}
		
		public function addToContainer(child:DisplayObject):void {
			_children.addItem(child);
			addChild(child);
		}
		
		/**
		 * 创建节点之间的线
		 * */
		private function createLines(node:IOrgChartNode):void {
			createLineForNormalLayout(node);
			return;
			if (node.data.@layout == "leftHanging") {
				createLineFormLeftHangingLayout(node);
			} else if (node.data.@layout == "rightHanging") {
				createLineForRightHangingLayout(node);
			} else if (node.data.@layout == "bothHanging") {
				createLineForBothHangingLayout(node);
			} else {
				createLineForNormalLayout(node);
			}
			
		}
		
		/**
		 * 创建节点之间的线（Both Hanging）
		 * */
		private function createLineForBothHangingLayout(node:IOrgChartNode):void {
			
			if (node.hasChildren) {
				//Alert.show("4");
				var parentLine:LineDescriptor=new LineDescriptor();
				parentLine.startX=node.x + node.width / 2;
				parentLine.startY=node.y + node.height;
				
				parentLine.endX=node.x + node.width / 2;
				parentLine.endY=node.lastChild.y + node.lastChild.height / 2;
				
				node.addLine(parentLine);
				addToContainer(parentLine);
			}
			var subNodes:ArrayCollection=node.subNodes;
			for (var i:int=0; i < subNodes.length; i++) {
				var childNode:IOrgChartNode=subNodes.getItemAt(i) as IOrgChartNode;
				//Alert.show("5");
				var bothHangingChildLine:LineDescriptor=new LineDescriptor();
				if (i % 2 == 0) {
					bothHangingChildLine.startX=node.x + node.width / 2;
					bothHangingChildLine.startY=childNode.y + childNode.height / 2;
					
					bothHangingChildLine.endX=childNode.x + childNode.width;
					bothHangingChildLine.endY=bothHangingChildLine.startY;
				} else {
					bothHangingChildLine.startX=node.x + node.width / 2;
					bothHangingChildLine.startY=childNode.y + childNode.height / 2;
					
					bothHangingChildLine.endX=childNode.x;
					bothHangingChildLine.endY=bothHangingChildLine.startY;
				}
				node.addLine(bothHangingChildLine);
				addToContainer(bothHangingChildLine);
			}
		}
		
		/**
		 * 创建节点之间的线（Right Hanging）
		 * */
		private function createLineForRightHangingLayout(node:IOrgChartNode):void {
			
			
			//Alert.show("6");
			if (node.hasChildren) {
				var parentLine:LineDescriptor=new LineDescriptor();
				parentLine.startX=node.x + node.width / 2;
				parentLine.startY=node.y + node.height;
				
				parentLine.endX=node.x + node.width / 2;
				parentLine.endY=node.lastChild.y + node.lastChild.height / 2;
				
				node.addLine(parentLine);
				addToContainer(parentLine);
			}
			var subNodes:ArrayCollection=node.subNodes;
			for (var i:int=0; i < subNodes.length; i++) {
				var childNode:IOrgChartNode=subNodes.getItemAt(i) as IOrgChartNode;
				
				var rightHangingChildLine:LineDescriptor=new LineDescriptor();
				
				rightHangingChildLine.startX=node.x + node.width / 2;
				rightHangingChildLine.startY=childNode.y + childNode.height / 2;
				
				rightHangingChildLine.endX=childNode.x;
				rightHangingChildLine.endY=rightHangingChildLine.startY;
				
				node.addLine(rightHangingChildLine);
				addToContainer(rightHangingChildLine);
			}
			
			
		}
		
		/**
		 * 创建节点之间的线（Left Hanging）
		 * */
		private function createLineFormLeftHangingLayout(node:IOrgChartNode):void {
			//Alert.show("7");
			if (node.hasChildren) {
				var leftHangingParentLine:LineDescriptor=new LineDescriptor();
				leftHangingParentLine.startX=node.x + node.width / 2;
				leftHangingParentLine.startY=node.y + node.height;
				
				leftHangingParentLine.endX=node.x + node.width / 2;
				leftHangingParentLine.endY=node.lastChild.y + node.lastChild.height / 2;
				
				node.addLine(leftHangingParentLine);
				addToContainer(leftHangingParentLine);
			}
			var subNodes:ArrayCollection=node.subNodes;
			for (var i:int=0; i < subNodes.length; i++) {
				var childNode:IOrgChartNode=subNodes.getItemAt(i) as IOrgChartNode;
				
				var leftHangingVline:LineDescriptor=new LineDescriptor();
				
				leftHangingVline.startX=childNode.x + childNode.width;
				leftHangingVline.startY=childNode.y + childNode.height / 2;
				
				leftHangingVline.endX=node.x + node.width / 2;
				leftHangingVline.endY=leftHangingVline.startY;
				
				node.addLine(leftHangingVline);
				addToContainer(leftHangingVline);
			}
		}
		
		/**
		 * 创建节点之间的线（正常布局）
		 * */
		private function createLineForNormalLayout(node:IOrgChartNode):void {
			//画当前节点下面的短竖线
//			Alert.show(node.hasShow+"%"+node.name);
			if(!node.hasShow){
			node.hasShow = true; 
		}else{
				return;
		}
			if (node.hasChildren) {
				var pointList :Array = new Array();
				
				var startPoint:Point = new Point(node.x + node.width / 2,node.y + node.height);
				
				var endPoint:Point;
			
				
				
				//headVLine.endX=headVLine.startX;
				var hasArrowHead:Boolean=false;
				if (node.subNodes.length == 1) {
					
					endPoint = new Point(node.x + node.width / 2,node.y + node.height + verticalSpacing);
					//headVLine.endY=node.y + node.height + verticalSpacing;
					hasArrowHead = true;
					
				} else {
					endPoint = new Point(node.x + node.width / 2,node.y + node.height + verticalSpacing/2);
					hasArrowHead = false;
					//headVLine.endY=node.y + node.height + verticalSpacing / 2;
				}
				var child:IOrgChartNode=node.subNodes.getItemAt(0) as IOrgChartNode;
				pointList.push(startPoint);
				pointList.push(endPoint);
				var isShow = node.getChildIsShow(child.name);
				if(isShow=='1'||true){
					var label = node.getChildLabel(child.name);
					
					var headPoints:ArrayCollection = new ArrayCollection(pointList)
					var headVLine:PolylineDescriptor=new PolylineDescriptor(this,headPoints,hasArrowHead,false,hasArrowHead,label);	
					//Alert.show("test")
					headVLine.name="";
					node.addLine(headVLine);
					addToContainer(headVLine);
				}
				//_polyLines.addItem(headVLine);
			}
			
			//Alert.show(node.name)
			//Alert.show(node.otherChildren)
			if(node.otherChildren!=""){
				//Alert.show(node.otherChildren);
				var others :Array = node.otherChildren.split(",")
				
				for(var k:int=0;k<others.length;k++){
					//var vline:PolylineDescriptor
					var pointList :Array = new Array();
					
					var startPoint:Point = new Point(node.x + node.width / 2,node.y + node.height);
					
					var endPoint:Point;
					var otherNode :IOrgChartNode = Application.application.oc.getChildByName(others[k]) as IOrgChartNode
					
					endPoint = new Point(otherNode.x+otherNode.width,otherNode.y+otherNode.height/2);
					var otherPoints:Array = node.getChildLine(others[k]);
					//Alert.show(""+startPoint.x+"%%%"+startPoint.y);
					pointList.push(startPoint);
					for(var x:int=0;x<otherPoints.length;x++){
						pointList.push(otherPoints[x]);
						var p:Point = otherPoints[x] as Point;
						if(p.y>_maxHeight){
							_maxHeight = p.y;
						}
						
						if(p.x>_maxWidth){
							_maxWidth = p.x;
						}
					}
					//pointList.concat(otherPoints);
					pointList.push(endPoint);
					//Alert.show(pointList.length+"");
					var headPoints:ArrayCollection = new ArrayCollection(pointList)
					isShow = node.getChildIsShow(otherNode.name);
					if(isShow=='1'){
						var label = node.getChildLabel(otherNode.name);
						var pline:PolylineDescriptor=new PolylineDescriptor(this,headPoints,true,_canEdit,true,label);
						pline.name=node.name+"_"+otherNode.name;
						node.addLine(pline);
						addToContainer(pline);
						if (!_polyLines.contains(pline)){
							_polyLines.addItem(pline);
						}
					}
					
				}
			}
			
			node.otherChildren="";
			
			var subs:ArrayCollection=node.subNodes;
			
			//画子节点上面的横线，跨度从第一个子节点的中心到最后一个子节点的中心
			if (subs.length > 1) {
				//Alert.show("8");
				var firstChild:IOrgChartNode;
				var lastChild:IOrgChartNode;
				for(var i:int=0;i<subs.length;i++){
					var nodeTmp:IOrgChartNode =  subs.getItemAt(i) as IOrgChartNode;
					if(node.getChildIsShow(nodeTmp.name)=='1'){
						firstChild = nodeTmp;
						break;
					}
					
					
				}
				
				for(var i:int=subs.length-1;i>-1;i--){
					var nodeTmp:IOrgChartNode =  subs.getItemAt(i) as IOrgChartNode;
				
					if(node.getChildIsShow(nodeTmp.name)=='1'){
						lastChild = nodeTmp;
						
						break;
					}
					
					
				}
				
				
				var hLine:LineDescriptor=new LineDescriptor();
				
				hLine.hasArrowHead=false;
				
				hLine.startX=firstChild.x + firstChild.width / 2;
				hLine.startY=node.y + node.height + verticalSpacing / 2;
				if(firstChild.name==lastChild.name){
					hLine.endX=hLine.startX + node.x + node.width / 2 - (firstChild.x + firstChild.width / 2);
					hLine.endY=hLine.startY;
				}else{
					hLine.endX=hLine.startX + lastChild.x + lastChild.width / 2 - (firstChild.x + firstChild.width / 2);
					hLine.endY=hLine.startY;
				}
				
				
				
				addToContainer(hLine);
				node.addLine(hLine);
				
				//画每个子节点头上的短竖线
				for (var j:int=0; j < subs.length; j++) {
					var child:IOrgChartNode=subs.getItemAt(j) as IOrgChartNode;
					
					var pointList :Array = new Array();
					
					var startPoint:Point = new Point(child.x + child.width / 2,child.y - verticalSpacing / 2);
					
					var endPoint:Point = new Point(child.x + child.width / 2,child.y);
					pointList.push(startPoint);
					pointList.push(endPoint); 
					var headPoints:ArrayCollection = new ArrayCollection(pointList)
					var isShow:String = node.getChildIsShow(child.name);
					if(isShow=='1'){
						var label:String = node.getChildLabel(child.name);
						var vline:PolylineDescriptor=new PolylineDescriptor(this,headPoints,true,false,true,label);
						node.addLine(vline);
						addToContainer(vline);
					}
				}
			}
		}
		
		/**
		 * 删除所有节点和线
		 * */
		private function _removeAllChildren():void {
			for (var cursor:IViewCursor=_children.createCursor(); !cursor.afterLast; cursor.moveNext()) {
				removeChild(cursor.current as DisplayObject);
			}
			_children=new ArrayCollection();
			//removeAllChildren();
		}
		
		
		////////////////////////////////////////////////////
		// Override funtions
		///////////////////////////////////////////////////
		override protected function createChildren():void {
			super.createChildren();
		}
		
		override protected function measure():void {
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			//这里添加所有节点到OrgChart上，并画线
			// Render the all node, create lines.
			//Alert.show("test"+dataProviderChanged)
			if (dataProviderChanged) {
				for (var cursor:IViewCursor=_nodes.createCursor(); !cursor.afterLast; cursor.moveNext()) {
					var node:IOrgChartNode=cursor.current as IOrgChartNode;
					
					
					
					addToContainer(node as UIComponent);
					
					
					//根据内容自动设置OrgChart的宽和高
					/*height=_maxY + verticalSpacing;
					
					width=(depth + 1) * (vItemWidth + horizontalSpacing);
					*/
					width=_maxX + horizontalSpacing;
					if(width<_container.width){
						width = _container.width;
					}
					
					height=(depth + 1) * (hItemHeight + verticalSpacing)+20;
					if(_maxHeight>height){
						height = _maxHeight+10;
					}
					if(_maxWidth>width){
						width = _maxWidth+10;
					}
					//trace("[OrgChart updateDisplayList] width,height = " + width + "," + height);
				}
				
				//dataProviderChanged=false;
			}
			
			if (dataProviderChanged) {
				for (var cursor:IViewCursor=_nodes.createCursor(); !cursor.afterLast; cursor.moveNext()) {
					var node:IOrgChartNode=cursor.current as IOrgChartNode;
					
					
					
					
					createLines(node);
					
					//根据内容自动设置OrgChart的宽和高
					/*height=_maxY + verticalSpacing;
					
					width=(depth + 1) * (vItemWidth + horizontalSpacing);
					*/
					width=_maxX + horizontalSpacing;
					if(width<_container.width){
						width = _container.width;
					}
					
					height=(depth + 1) * (hItemHeight + verticalSpacing)+20;
					if(_maxHeight>height){
						height = _maxHeight+10;
					}
					if(_maxWidth>width){
						width = _maxWidth+10;
					}
					//trace("[OrgChart updateDisplayList] width,height = " + width + "," + height);
				}
				
				dataProviderChanged=false;
			}
			
			dataProviderChanged=false;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if (dataProviderChanged) {
				
				//remove all children ，
				_removeAllChildren();
				
				_nodes=new ArrayCollection();
				
				//reset the depth, should recalculate
				//重新计算树深度值
				_depth=0;
				calculateDepth(_data);
				_maxY=0;
				
				_createSubNodes(_data, null);
				invalidateDisplayList();
			}
		}
		
		
		
		////////////////////////////////////////////////////////////
		// Getters and Setters
		////////////////////////////////////////////////////////////
		public function get depth():int {
			return _depth;
		}
		
		public function set dataProvider1(data:ICollectionView):void {
			_data=data;
			//Alert.show("dataProviderChanged");
			dataProviderChanged=true;
			invalidateProperties();
		}
		
		[Bindable]
		public function get selected():Object {
			return _selected ? _selected.data : null;
		}
		
		public function set selected(value:Object):void {
			if (!value)
				return;
			for (var cursor:IViewCursor=_nodes.createCursor(); !cursor.afterLast; cursor.moveNext()) {
				var n:IOrgChartNode=cursor.current as IOrgChartNode;
				if (n.data == value) {
					selectedNode=n;
				}
			}
		}
		
		[Bindable]
		public function get selectedNode():IOrgChartNode {
			return _selected;
		}
		
		public function set selectedNode(value:IOrgChartNode):void {
			if (value) {
				_selected=value;
				if (willTrigger(OrgChartEvent.NODE_SELECTED) && selectable) {
					var e:OrgChartEvent=new OrgChartEvent(OrgChartEvent.NODE_SELECTED, selectedNode);
					dispatchEvent(e);
				}
			}
		}
		
		[Bindable]
		public function get selectable():Object {
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void {
			_selectable=value;
		}
		
		public function get hItemWidth():Number {
			return _hItemWidth;
		}
		
		public function set hItemWidth(w:Number):void {
			_hItemWidth=w;
		}
		
		public function get hItemHeight():Number {
			return _hItemHeight;
		}
		
		public function set hItemHeight(h:Number):void {
			hItemHeight=h;
		}
		
		
		public function get vItemWidth():Number {
			return _vItemWidth;
		}
		
		public function set vItemWidth(w:Number):void {
			_vItemWidth=w;
		}
		
		public function get vItemHeight():Number {
			return _vItemHeight;
		}
		
		public function set vItemHeight(h:Number):void {
			_vItemHeight=h;
		}
		
		public function get horizontalSpacing():Number {
			return _horizonalSpacing;
		}
		
		public function set horizontalSpacing(value:Number):void {
			_horizonalSpacing=value;
		}
		
		public function get verticalSpacing():Number {
			return _verticalSpacing;
		}
		
		public function set verticalSpacing(value:Number):void {
			_verticalSpacing=value;
		}
		
		public function set container(container:DragScrollingCanvas):void{
			this._container = container;
		}
		
		public function set canEdit(canEdit:Boolean):void{
			this._canEdit = canEdit;
		}
		
		public function set canView(canView:Boolean):void{
			this._canView = canView;
		}
		
		/////////////////////////////////////////////////////
		// Event handlers.
		/////////////////////////////////////////////////////
		private var zoom:Zoom=new Zoom();
		
		private function nodeRollOver(e:MouseEvent):void {
			//doZoom(e);
		}
		
		private function nodeRollOut(e:MouseEvent):void {
			//doZoom(e);
		}
		
		private function doZoom(e:MouseEvent):void {
			var node:DefaultOrgChartNode=e.currentTarget as DefaultOrgChartNode;
			
			if (zoom.isPlaying) {
				zoom.reverse();
			} else {
				zoom.zoomWidthFrom=1;
				zoom.zoomWidthTo=1.5;
				zoom.zoomHeightFrom=1;
				zoom.zoomHeightTo=1.5;
				zoom.duration=200;
				zoom.play([node], e.type == MouseEvent.ROLL_OUT ? true : false);
			}
		}
		
		private function nodeMouseOver(e:MouseEvent):void {
			if (willTrigger(OrgChartEvent.NODE_MOUSE_OVER)) {
				dispatchEvent(new OrgChartEvent(OrgChartEvent.NODE_MOUSE_OVER, e.currentTarget as IOrgChartNode));
			}
			
			
		}
		
		private function nodeMouseOut(e:MouseEvent):void {
			if (willTrigger(OrgChartEvent.NODE_MOUSE_OUT)) {
				dispatchEvent(new OrgChartEvent(OrgChartEvent.NODE_MOUSE_OUT, e.currentTarget as IOrgChartNode));
			}
		}
		
		/*private function nodeClick(e:MouseEvent):void {
			if (selectable) {
				selectedNode=e.currentTarget as IOrgChartNode;
			}
			if (willTrigger(OrgChartEvent.NODE_CLICK)) {
				dispatchEvent(new OrgChartEvent(OrgChartEvent.NODE_CLICK, e.currentTarget as IOrgChartNode));
			}
		}*/
		
		
		public function savePolyLine():void{
			
			Alert.yesLabel = ""+resourceManager.getString('resources', 'LM015');
			Alert.noLabel = ""+resourceManager.getString('resources', 'LM070');
			Alert.show(resourceManager.getString('resources', 'LM071')+"？", resourceManager.getString('resources', 'LM038')+"", 3, this, alertClickHandler);
		}
		
		
		/**
		 *  保存折线顶点信息
		 */
		public function savePolyLineInfo():void{
			var staticObj :StaticObj=Application.application.staticObj;	
			var xmlArray:ArrayCollection = new ArrayCollection(new Array());
			
			for(var i:int=0;i<_polyLines.length;i++){
				var line:PolylineDescriptor = _polyLines.getItemAt(i) as PolylineDescriptor;
				if(line.name==""){
					continue;
				}
				var lineinfo:Object = {name:line.name,points:line.pointToString()};
				xmlArray.addItem(lineinfo);
			}
			//Alert.show(xmlArray.length+"");
			var xml:XML = XmlUtil.objectToXML(xmlArray,"root");
			//Alert.show(xml.toString());
			
			var http:HTTPService = new HTTPService();
			http.addEventListener(ResultEvent.RESULT,success);
			http.addEventListener(FaultEvent.FAULT,fault);
			http.url="/companygroup/manage/companyoperation.jsp?method=saveLineInfo"
			http.method = "post";
			//http.resultFormat = "e4x";
			
			var val:URLVariables= new URLVariables();
			val.xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+xml.toString();
			val.random = Math.random();
			val.groupid = staticObj.groupid;
			http.send(val);
			
			
		}
		
		
		public function clear():void{
			
			var xmlArray:ArrayCollection = new ArrayCollection(new Array());
			//Alert.show(_polyLines.length+"");
			for(var i:int=0;i<_polyLines.length;i++){
				var line:PolylineDescriptor = _polyLines.getItemAt(i) as PolylineDescriptor;
				line.clear();
			}
			
			
		}
		public function success(xmlContent:ResultEvent):void{
			
			
			//Alert.show("保存成功！");
			//Alert.yesLabel = "确定";
			//Alert.noLabel = "取消";
			//Alert.show("是否创建版本？", "创建版本", 3, this, alertClickHandler);
			
			
		}
		
		
		public function fault(myFaultEvent:FaultEvent):void{    //异常处理函数  
			Alert.okLabel=""+resourceManager.getString('resources', 'LM015');
			Alert.show(resourceManager.getString('resources', 'LM076')+"！");
			trace(myFaultEvent.message);   
		} 
		
		private function alertClickHandler(event:CloseEvent):void {
			if (event.detail==Alert.YES){
				savePolyLineInfo();
				Application.application.showGroupVersionPopUp();
			}
			
		}
		
		
		
	}
}