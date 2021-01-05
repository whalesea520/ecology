var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
  elem: false,
  write: function(text){
    if (!this.elem) 
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    //this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};

var st = null;
var top = null, 
    left = null, 
    bottom = null, 
    right = null,
    normal = null;
function init(json){
    //init data
    //end
    //init Spacetree
    //Create a new ST instance
    st = new $jit.ST({
        //id of viz container element
        injectInto: 'infovis',
        //set duration for the animation
        duration: 600,
        //set animation transition type
        transition: $jit.Trans.Quart.easeInOut,
        //set distance between node and its children
        levelDistance: 50,
        //enable panning
        Navigation: {
          enable:true,
          panning:true
        },
        //set node and edge styles
        //set overridable=true for styling individual
        //nodes or edges
        Node: {
            height: 60,
            width: 140,
            type: 'rectangle',
            color: '#aaa',
            overridable: true
        },
        
        Edge: {
            type: 'bezier',
            lineWidth: 2,
            color:'#eed',
            overridable: true
        },
        
        onBeforeCompute: function(node){
            //Log.write("请稍候！");
        },
        
        onAfterCompute: function(){
            //Log.write("加载完成！");
            //禁止选中
        	$("div,td").attr('unselectable','on') 
            .css({'-moz-user-select':'-moz-none', 
            '-moz-user-select':'none', 
            '-o-user-select':'none', 
            '-khtml-user-select':'none', /* you could also put this in a class */ 
            '-webkit-user-select':'none',/* and add the CSS class here instead */ 
            '-ms-user-select':'none', 
            'user-select':'none' 
            }).bind('selectstart', function(){ return false; }); 
        },
        
        //This method is called on DOM label creation.
        //Use this method to add event handlers and styles to
        //your node.
        onCreateLabel: function(label, node){
            label.id = node.id;            
            label.innerHTML = node.name;
            label.onclick = function(){
            	//if(normal.checked) {
            	  st.onClick(node.id); //保留最顶级节点
            	//} else {
                //st.setRoot(node.id, 'animate'); //从当前节点开始延伸
            	//}
            };
            //set label styles
            var style = label.style;
            style.width = 130 + 'px';
            style.height = 30 + 'px';            
            style.cursor = 'pointer';
            style.color = '#333';
            style.fontSize = '0.8em';
            style.textAlign= 'center';
            style.paddingTop = '0px';
        },
        
        //This method is called right before plotting
        //a node. It's useful for changing an individual node
        //style properties before plotting it.
        //The data properties prefixed with a dollar
        //sign will override the global node style properties.
        onBeforePlotNode: function(node){
        	var nodeid = node.id;
            //add some color to the nodes in the path between the
            //root node and the selected node.
            if (node.selected) {
                node.data.$color = show;//展开颜色
                /**
                $("#box"+nodeid).find("td.info1").css("color",showinfo1);
                $("#box"+nodeid).find("td.info2").css("color",showinfo2);
                $("#box"+nodeid).find("td.info3").css({"color":showinfo3,"background":showinfo33});
                */
            }
            else {
                delete node.data.$color;
                //if the node belongs to the last plotted level
                if(!node.anySubnode("exist")) {
                    //count children number
                    var count = 0;
                    node.eachSubnode(function(n) { count++; });
                    //assign a node color based on
                    //how many children it has
                    //node.data.$color = ['#F6F6F6', '#F7F7F7', '#F8F8F8', '#F9F9F9', '#F3F3F3', '#F2F2F2'][count]; 
                    //node.data.$color = ['#fff', '#fff', '#fff', '#fff', '#fff', '#fff'][count]; 
                    //node.data.$color = ['#aaa', '#baa', '#caa', '#daa', '#eaa', '#faa'][count];
                    if(count==0) node.data.$color = nosub;//不含下级颜色
                    else node.data.$color = hassub;//含下级颜色
                }
            }
        },
        
        //This method is called right before plotting
        //an edge. It's useful for changing an individual edge
        //style properties before plotting it.
        //Edge data proprties prefixed with a dollar sign will
        //override the Edge global style properties.
        onBeforePlotLine: function(adj){
            if (adj.nodeFrom.selected && adj.nodeTo.selected) {
                adj.data.$color = "#FFC993";
                adj.data.$lineWidth = 3;
            }
            else {
                delete adj.data.$color;
                delete adj.data.$lineWidth;
            }
        }
    });
    //load json data
    st.loadJSON(json);
    //compute node positions and layout
    st.compute();
    //optional: make a translation of the tree
    st.geom.translate(new $jit.Complex(-200, 0), "current");
    //emulate a click on the root node.
    st.onClick(st.root);
    //end
    //Add event handlers to switch spacetree orientation.
    top = $jit.id('r-top'), 
        left = $jit.id('r-left'), 
        bottom = $jit.id('r-bottom'), 
        right = $jit.id('r-right'),
        normal = $jit.id('s-normal');
        
    
    function changeHandler() {
        if(this.checked) {
            top.disabled = bottom.disabled = right.disabled = left.disabled = true;
            st.switchPosition(this.value, "animate", {
                onComplete: function(){
                    top.disabled = bottom.disabled = right.disabled = left.disabled = false;
                }
            });
        }
    };
    top.onchange = left.onchange = bottom.onchange = right.onchange = changeHandler;
}
 function changeOperation(obj) {
        if(obj.attr("checked")) {
            top.disabled = bottom.disabled = right.disabled = left.disabled = true;
            st.switchPosition(obj.val(), "animate", {
                onComplete: function(){
                    top.disabled = bottom.disabled = right.disabled = left.disabled = false;
                }
            });
        }
}