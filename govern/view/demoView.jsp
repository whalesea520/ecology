<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.govern.service.GovernService"%>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
String governorId = Util.null2String(request.getParameter("id"));
	GovernService gs = new GovernService();
	Map<String, Object> gsJson = gs.getGovernorTreeView0(governorId);
	String approvalStatus = Util.null2String(gsJson
			.get("approvalStatus"));
	//Map<String, Object> dataMap = (Map<String, Object>) gsJson
	//		.get("dataMap");
	List dataMap = (List)gsJson.get("dataMap");
	String jsonStr = JSON.toJSONString(dataMap,
			SerializerFeature.DisableCircularReferenceDetect);
	System.out.println(jsonStr);
	String url = "";
	rs.execute("select * from uf_govern_setting where id=10");
	if(rs.next()){
		url = Util.null2String(rs.getString("taskLink"));
	}
%>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>jsMind</title>
		<link type="text/css" rel="stylesheet" href="../css/jsmind.css" />
		<style type="text/css">
#jsmind_container {
	width: 800px;
	height: 500px;
	border: solid 1px #ccc;
	/*background:#f4f4f4;*/
	background: #f4f4f4;
}

#mind_top {
	background: #FFF;
	height: 30px;
}

#mind_total {
	float: left;
}

#mind_operate {
	float: right;
}

#mind_total ul {
	text-align: center;
	line-height: 15px;
	margin: 0px auto;
	padding: 0;
	margin-left: 10px;
	font-size: 12px;
	color: #7d7f81;
	height: 30px;
	margin-top: 6px;
}

#mind_operate ul {
	margin: 0px auto;
	padding: 0;
	margin-right: 25px;
	height: 30px;
}

#mind_operate ul li {
	list-style: none;
	float: right;
	margin-top: 6px;
	margin-left: -1px;
}

#mind_operate ul li a {
	width: 60px;
	height: 18px;
	line-height: 15px;
	color: #30b5ff;
	background: #FFF;
	margin: 1px 0px;
	font-size: 12px;
	text-align: center;
	text-decoration: none;
	border: 1px solid #30b5ff;
	display: block;
}

#jsmind_container { /*height: 93%;*/
	width: 99.5%;
	border: solid 1px #ccc;
	background: #f4f4f4;
}

a {
	text-decoration: none;
}

a:hover {
	text-decoration: none;
}

jmnode {
	box-shadow: 0px 0px 10px #aaa;
}

jmnode.selected {
	box-shadow: 0px 0px 10px #017afd;
}

jmnode:hover {
	box-shadow: 0px 0px 10px #777;
}

td {
	font-size: 11px;
	color: #7d7f81;
}
jmnodes.theme-primary jmnode{
	background-color: #FFF;
    color: #000;
}
jmnode{
     padding:1px
}
.root{
	padding:10px
}
</style>
	</head>
	<body>
		<div id="mind_top">
			<div id="mind_operate">
				<ul>
					<li>
						<a href="#" onclick="zoomOut()"> - 缩小</a>
					</li>
					<li>
						<a href="#" onclick="zoomIn()"> + 放大</a>
					</li>
					<li>
						<a style="width: 90px;" href="#" onclick="collapse_all()">
							全部收起 </a>
					</li>
					<li>
						<a style="width: 90px;" href="#" onclick="expand_all()"> 全部展开
						</a>
					</li>
				</ul>
			</div>
		</div>
		<div id="jsmind_container" style="height: 95%"></div>
		<script type="text/javascript" src="../js/jsmind.js">
</script>
		<script type="text/javascript" src="../js/jsmind.draggable.js">
</script>
		<script type="text/javascript" src="../js/jsmind.shell.js">
</script>
		<script type="text/javascript">
var _jm = null;
function clickTable (id) {
	_jm.toggle_node(id)
}
function openTask (id,text) {
	window.top.onUrl("TaskView" + id, text, "<%=url%>billid=" + id)
	_jm.collapse_node(id);
}

function load_jsmind() {

	var jsonData = <%=jsonStr%>;
		var mind = {
            meta:{
            },
            format:'node_array',
            support_html : true, 
            data:jsonData,
            editable:false,
        };
        var options = {
            container:'jsmind_container',
            editable:true,
            theme:'weaver',
            layout:{
		       hspace:150,          // 节点之间的水平间距
		       vspace:10,          // 节点之间的垂直间距
		       pspace:13           // 节点收缩/展开控制器的尺寸
		    }
        }
        _jm = jsMind.show(options,mind);
        // jm.set_readonly(true);
        // var mind_data = jm.get_data();
        // alert(mind_data);
    }
    
    function load_file(fi){
        var files = fi.files;
        if(files.length > 0){
            var file_data = files[0];
            jsMind.util.file.read(file_data, function(freemind_data, jsmind_name){
                var mind = jsmind_data;
                if(!!mind){
                    _jm.show(mind);
                }else{
                    console.error('can not open this file as mindmap');
                }
            });
        }
    }

    function save_nodetree(){
        var mind_data = _jm.get_data('node_tree');
        console.log(mind_data);
    }

    function replay(){
        var shell = _jm.shell;
        if(!!shell){
            shell.replay();
        }
    }
    
    function replay(){
        var shell = _jm.shell;
        if(!!shell){
            shell.replay();
        }
    }

	
	function saveContacterMind(){
		editable();
		arr.length = 0;
		findAllChildrenByNode(_jm.get_root());
		$.post("/CRM/contacter/contacterMindOperate.jsp",
					{"datas":JSON.stringify(arr),
					 "old_parent":old_parent,
					 "new_parent":new_parent,
					 "customerId":"<%=governorId%>",
					 "contacterId":selectd_node
					}, function(data,status){
								//window.top.Dialog.alert("1111");
								old_parent = "";
								new_parent = "";
	 					 });
	 
	}
	
	function findAllChildrenByNode(node){
		var id;
		var parentid;
		var obj;
		var direction;
		var children = node.children;
		var length = children.length;
		if(length>0){
			for(var i = 0 ;i < length;i++){
				id = children[i].id;
				parentid = children[i].parent.id;
				direction = children[i].direction;
				obj = {"id":id,"parentid":parentid,"direction":direction};
				arr.push(obj);
				this.findAllChildrenByNode(children[i]);
			}
		}
	}
	
	
	function resetContacter(){
		window.top.Dialog.confirm("2222",function(){
			$.post("/CRM/contacter/contacterMindOperate.jsp",
					{"customerId":<%=governorId%>,
					"action":"reset"
					}, function(data,status){
							window.location.reload(true);
	 					 });
		});
		
	}
	
	
	function editable(){
        _jm.enable_edit();
    }
    
    function expand_all(){
        _jm.expand_all();
    }
    
    function collapse_all(){
        _jm.collapse_all();
    }
    //浏览器版本
  	var browserName = $.client.browserVersion.browser;             //浏览器名称
  	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
  	var osVersion=$.client.version;                                //操作系统版本
  	var browserOS=$.client.os;
	 
     function zoomIn() {
     if((browserName == "IE"&&browserVersion<10)){
		 window.top.Dialog.alert("不支持IE9及以下版本,请升级IE版本");
	  }
        _jm.view.zoomIn();
       
    };

    function zoomOut() {
    if((browserName == "IE"&&browserVersion<10)){
		 window.top.Dialog.alert("不支持IE9及以下版本,请升级IE版本");
	  }
       _jm.view.zoomOut();
    };

    load_jsmind();
</script>
	</body>
</html>
