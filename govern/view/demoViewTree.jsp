<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.govern.service.GovernService"%>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String governorId = Util.null2String(request.getParameter("id"));
	GovernService gs = new GovernService();
	Map<String, Object> gsJson = gs.getGovernorTreeView(governorId,user);
	String approvalStatus = Util.null2String(gsJson
			.get("approvalStatus"));
	Map<String, Object> dataMap = (Map<String, Object>) gsJson
			.get("dataMap");
	String jsonStr = JSON.toJSONString(dataMap,
			SerializerFeature.DisableCircularReferenceDetect);
	System.out.println(jsonStr);
	String url = "";
	rs.execute("select * from uf_govern_setting where settype=10");
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

#menu{
    width: 0; /*设置为0 隐藏自定义菜单*/
    height: 103px;
    overflow: hidden; /*隐藏溢出的元素*/
    border: solid 0px #666;
    position: absolute; /*自定义菜单相对与body元素进行定位*/  
    z-index: 10000;
    font-size: 14px;
    background: #fbfbfb;
    padding: 2px 0px;
    margin: 0px;
    width: 0px;
}
#menu > li {
    font: 12px Microsoft YaHei;
    list-style: none;
    padding: 0px 2px;
    margin: 0px;
}
#menu > li > a{
    color: #333;
    text-decoration: none;
    display: block;
    line-height: 20px;
    background-position: 6px center;
    background-repeat: no-repeat;
    outline: none;
    padding: 3px 5px;
    padding-left: 28px;
    padding-right: 6px;
    overflow: hidden;
}
#menu > li:hover{
    background:#e5e5e5
}
</style>
	</head>
	<body>
	<ul id="menu">
          <li>
            <a  id = "isreportLevel"
	            style="background-image: url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon7_wev8.png)" 
	            onclick="javascript:reportMyTask()">
      		汇报</a>
          </li>
          <li>
            <a  id = "issplitLevel"
	            style="background-image: url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon20_wev8.png)" 
	            onclick="javascript:taskSplit()">
                            分解</a>
          </li>
          <li>
            <a  id = "isdisLevel"
            	style="background-image: url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon25_wev8.png)" 
            	onclick="javascript:distribution()">
                            下发</a>         
          </li>
          <li>
            <a  id = "ischangeLevel"
                style="background-image: url(/wui/theme/ecology8/skins/default/contextmenu/CM_icon14_wev8.png)"
				onclick="javascript:doChange()">
          	变更</a>
          </li>
        </ul>
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
						<a style="width: 90px;" href="#" onclick="collapse_all()">全部收起 </a>
					</li>
					<li>
						<a style="width: 90px;" href="#" onclick="expand_all()">全部展开</a>
					</li>
					<li>
						<a style="width: 90px;" href="#" onclick="refresh()">刷新</a>
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
var skey = "";
var allowReport;
var allowSplit;
var allowDistribution;
var allowChange;

function reportMyTask(){
	if(allowReport == "1"){
		var paramData = {settype:"1",index:"0",key:skey}
		jQuery.ajax({
			url: "/govern/interfaces/governAction.jsp?action=reportMyTask",
			data: paramData,
			dataType: 'json',
			type: 'POST',
			async: false,
			success: function (res) {
				var api_errormsg = res.api_errormsg;
				var api_status = res.api_status;
				var newrequestid = res.newrequestid;
				var flowid = res.flowid;
				if (api_status == true && parseInt(newrequestid) > 0) {
	                onUrl0("taskView" + newrequestid, "汇报表单", "/workflow/request/ViewRequest.jsp?requestid=" + newrequestid + "&_workflowid=" + flowid + "&_workflowtype=&isovertime=0");
	            } else {
	                alert(api_errormsg);
	            }
			}
	    })
	}else{
		alert("对不起，您无此权限");
	}
}
function onUrl0(key, title, url){
    if (typeof (window.top.onUrl) == "function") {
        window.top.onUrl(key, title, url);
    } else {
        var obj = window.self;
        while (true) {
            if (typeof (obj.window.onUrl) == "function") {
                obj.window.onUrl(key, title, url);
                break;
            }
            if (obj == obj.window.parent) {
                break;
            }
            obj = obj.window.parent;
        }
	}
}
function taskSplit(){
	if(allowSplit == "1"){
		var paramData = {id:skey}
		jQuery.ajax({
			url: "/govern/interfaces/governAction.jsp?action=getSplitUrl",
			data: paramData,
			dataType: 'json',
			type: 'POST',
			async: false,
			success: function (res) {
				onUrl0("tasksplit" + skey, "任务分解", res.splitUrl);
			}
	    })
	}else{
		alert("对不起，您无此权限");
	}
}
function distribution(){
	if(allowDistribution == "2"){
		var paramData = {id:skey}
		jQuery.ajax({
			url: "/govern/interfaces/governAction.jsp?action=distribution",
			data: paramData,
			dataType: 'json',
			type: 'POST',
			async: false,
			success: function (res) {
				alert("所属任务已经下发");
				window.location.reload();
			}
	    })
	}else{
		alert(allowDistribution == "1" ? "对应任务已经下发":"对不起，您无此权限");
	}
}

function doChange(){
	if(allowChange == "1"){
		var paramData = {settype:"9",index:"2",key:skey}
		jQuery.ajax({
			url: "/govern/interfaces/governAction.jsp?action=governorPostpone",
			data: paramData,
			dataType: 'json',
			type: 'POST',
			async: false,
			success: function (res) {
				var api_errormsg = res.api_errormsg;
				var api_status = res.api_status;
				var newrequestid = res.newrequestid;
				var flowid = res.flowid;
				if (api_status == true && parseInt(newrequestid) > 0) {
	                onUrl0("changeFlow" + newrequestid, "变更流程", "/workflow/request/ViewRequest.jsp?requestid=" + newrequestid + "&_workflowid=" + flowid);
           		} else {
	                alert(api_errormsg);
	            }
			}
	    })
	}else{
		alert("对不起，您无此权限");
	}
}
function refresh(){
	window.location.reload();
}
function clickTable (id) {
	_jm.toggle_node(id)
}
function openTask (id,text) {
	onUrl0("TaskView" + id, text, "<%=url%>billid=" + id)
	_jm.collapse_node(id);
}
function load_jsmind() {

	var jsonData = <%=jsonStr%>;
		var mind = {
            meta:{
            },
            format:'node_tree',
            support_html : true, 
            data:jsonData,
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
    
    $(function () {
	    load_jsmind();
	    jQuery("body").unbind("mousedown").bind("contextmenu", function (e) {
	    	e.preventDefault();
	    	var obj;
	    	if(jQuery(e.target).attr("class") == "DBcard"){
	    		obj = jQuery(e.target);
	    	}else{
	    		obj = $(e.target).parents('.DBcard');
	    	}
	    	if(obj.attr("class") == "DBcard"){
	    		skey = obj.attr("skey");
	    		allowReport = obj.attr("reportLevel");
				allowSplit = obj.attr("splitLevel");
				allowDistribution = obj.attr("disLevel");
				allowChange = obj.attr("changeLevel");
				var menu = jQuery("#menu");
	        	menu.css("width", '105px');
	        	menu.css("border", 'solid 2px #666');
	        	menu.css("left", e.clientX + 'px');
	        	menu.css("top", e.clientY + 'px');
	        	var i = 0;
	        	menu.css('display' ,'block'); 
	        	if(allowReport=="0"){
		        	jQuery("#isreportLevel").css('display' ,'none');    	
	        	}else if(allowReport=="1"){
	        		jQuery("#isreportLevel").css('display' ,'block');
	        		i++;   
	        	}
	        	if(allowSplit=="0"){
		        	jQuery("#issplitLevel").css('display' ,'none');
	        	}else if(allowSplit=="1"){
	        		jQuery("#issplitLevel").css('display' ,'block');
	        		i++;
	        	}
	        	if(allowDistribution=="2"){
	        		jQuery("#isdisLevel").css('display' ,'block');
	        		i++; 
        		}else{
		        	jQuery("#isdisLevel").css('display' ,'none');
	        	}
	        	if(allowChange=="0"){
		        	jQuery("#ischangeLevel").css('display' ,'none');
	        	}else if(allowChange=="1"){
	        		jQuery("#ischangeLevel").css('display' ,'block');
	        		i++; 
	        	}	        	
	        	menu.css("height",25*i +"px");
	        	if(i == 0){
	        		menu.css('display' ,'none');    	
	        	}
	    	}else{
	    		jQuery("#menu").css("width", "0px");
	      		jQuery("#menu").css("border", 'solid 0px #666');
	    	}
	    	
	    });
	    document.onclick = function () {
	      jQuery("#menu").css("width", "0px");
	      jQuery("#menu").css("border", 'solid 0px #666');
	    };
    })
    
    
    function openHrmResourceView(id){	
    	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id);
	}
    
    function openFullWindowForXtable(url){
	  var redirectUrl = url ;
	  var width = screen.availWidth-10 ;
	  var height = screen.availHeight-60 ;
	  //if (height == 768 ) height -= 75 ;
	  //if (height == 600 ) height -= 60 ;
	  var szFeatures = "top=0," ;
	  szFeatures +="left=0," ;
	  szFeatures +="width="+width+"," ;
	  szFeatures +="height="+height+"," ;
	  szFeatures +="directories=no," ;
	  szFeatures +="status=yes," ;
	  szFeatures +="menubar=no," ;
	  szFeatures +="scrollbars=yes," ;
	  szFeatures +="resizable=yes" ; //channelmode
	  window.open(redirectUrl,"",szFeatures) ;
	}
</script>
	</body>
</html>
