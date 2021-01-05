
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ page import="net.sf.json.JSONObject"%>
<%
String browserId = request.getParameter("browserId");
String showfield = Util.null2String(request.getParameter("showField"));
String params = Util.null2String(request.getParameter("params"));
%>
<HTML><HEAD>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<script src="/mobilemode/jqmobile4/js/jquery_wev8.js"></script>
	<style>
		*{
			font-family: 'Microsoft YaHei', Arial;
			font-size: 12px;
		}
		html,body{
			padding: 0px;
			margin: 0px;
		}
		#browserSearchContainer{
			position: relative;
			background-color: #f9f9f9;
			padding: 8px 10px 10px 10px;
			border-bottom: 1px solid #eee;
		}
		#browserkeyword{
			border: 1px solid #ddd;
			height: 28px;
			width: 180px;
			border-right: none;
			padding-left: 8px;
			text-shadow: none;
			
			-moz-border-radius: 0;
    		-webkit-border-radius: 0; 
			border-radius: 0;
			
			-webkit-box-shadow:none;
			-moz-box-shadow:none;
			box-shadow:none;
			box-sizing: border-box;
			
		}
		#search{
			position: absolute;
			top: 8px;
			left: 190px;
			display: block;
			height: 26px;
			border: 1px solid #ddd;
			padding: 0px 10px;
			line-height: 26px;
			text-decoration: none;
			background-color: #f0f0f0;
			color: #333;
		}
		#okBtn{
			display: block;
			height: 26px;
			border: 1px solid #ddd;
			padding: 0px 10px;
			line-height: 26px;
			text-decoration: none;
			background-color: #f0f0f0;
			color: #333;
			float: right;
		}
		#browsserlist{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		#browsserlist li{
			border-bottom: 1px solid #eee;
			padding: 5px 10px 5px 10px;
		}
		#browserDataContainer{
			height: 302px; 
			overflow: auto;
			background-color:#fff;
		}
		
		#loading{
			position: absolute;
		    left:0px;
		    top:0px;
		    height: 100%;
		    width: 100%;
		    z-index: 20001;
		    display: none;
		}
		#loading .loadMask{
			height: 100%;
		    width: 100%;
			background-color: #fff;
		    opacity: 0.3;
		}
		#loading .loadText{
			position: absolute;
		    top:120px;
		    left:120px;
		    width: 48px;
		    height: 16px;
		    background: url("/mobilemode/images/mobile_loading_wev8.gif") no-repeat;
			background-position: center center;
		}
		#loadMore{
			display: block;
			width: 100%;
			height: 30px;
			background-color: red;
			line-height: 30px;
			text-decoration: none;
			background-color: rgb(246, 246, 246);
			color: #333;
			text-align: center;
			margin: 8px 0px 5px 0px;
			border-top: 1px solid #ddd;
			border-bottom: 1px solid #ddd;
			cursor: pointer;
		}
	</style>
	
	<script type="text/javascript">
		var currPgNo = 1;
		var pageSize = 10;
		var pageCount = 0;
		var _selected_arr = [];
		var params1 = <%=params.toString()%>;
		
		function doSearch(browserid, showfield, fn){
			$("#loading").show();
			var keyword = encodeURI(document.getElementById("browserkeyword").value);
			var url="/mobilemode/searchbrowser.jsp?browserId="+browserid+"&keyword="+keyword+"&showField=field"+showfield+"&pageno="+currPgNo+"&params="+encodeURIComponent(JSON.stringify(params1));
			$.post(url, { "keyword":keyword,"pageSize":pageSize},function(data){
				$("#loading").hide();
	 			fn.call(this, data);
	 		});
		}
		
		function browserSearch(browserid,showfield) {
			currPgNo = 1;
			doSearch(browserid, showfield, function(data){
				document.getElementById("browsserlist").innerHTML=data.trim();
	 			var totalRecordCount = parseInt(document.getElementById("totalRecordCount").value);
	 			pageCount = (totalRecordCount % pageSize) == 0 ? parseInt(totalRecordCount / pageSize) : (parseInt(totalRecordCount / pageSize) + 1);
	 			if(currPgNo >= pageCount){
	 				$("#loadMore").hide();
	 			}else{
	 				$("#loadMore").show();
	 			}
			});
		}
		
		function browserSearchMore(browserid,showfield){
			currPgNo++;
			doSearch(browserid, showfield, function(data){
				$("#browsserlist").append(data.trim());
	 			
	 			if(currPgNo >= pageCount){
	 				$("#loadMore").hide();
	 			}
			});
		}
		
		function browserSelect(showfield){
			var result;
			var single=$("#single").val();
			if(single=="true"){
				var sel=$("#browsserlist input[name='radio']:checked");
				var value=sel.val();
				
				result = {"name" : $("#label-"+value).text(), "value" : value};
			}else{
				var selvalue="";
				var sellabel="";
			    for(var i = 0; i < _selected_arr.length; i++){
					var selectedData = _selected_arr[i];
					selvalue += selectedData["id"] + ",";
					sellabel += selectedData["name"] + ",";
				}
				if(selvalue!=""){
					selvalue=selvalue.substring(0, selvalue.length-1);
					sellabel=sellabel.substring(0, sellabel.length-1);
				}
				result = {"name" : sellabel, "value" : selvalue};
			}
			if(parent && typeof(parent.onBrowserOK) == "function"){
				parent.onBrowserOK(showfield, result);
			}
		}
		
		function onbrowserSelect(checkbox){
			var value=$(checkbox).val();
			var label=$("#label-"+value).text();
			var data_json = {"id" : value, "name" : label};
			if(checkbox.checked == true){
				//alert("value:"+value=" label:"+label);
				addInSelectedArr(data_json);
			}else{
				removeFromSelectedArr(data_json);
			}
		}
		
		function indexOfSelectedArr(id){
			var index = -1;
			for(var i = 0; i < _selected_arr.length; i++){
				var selectedData = _selected_arr[i];
				if(selectedData["id"] == id){
					index = i;
					break;
				}
			}
			return index;
		}

		function addInSelectedArr(data){
			if(indexOfSelectedArr(data.id) == -1){
				_selected_arr.push(data);
			}
		}
		
		function removeFromSelectedArr(data){
			removeFromSelectedArrById(data.id);
		}
		
		function removeFromSelectedArrById(id){
			var index = indexOfSelectedArr(id);
			if(index != -1){
				_selected_arr.splice(index, 1);
			}	
		}

		$(document).ready(function(){
			browserSearch('<%=browserId %>','<%=showfield %>');
		});
	</script>
</HEAD>
<body>
<div>
	<span id="browserSearchContainer" style="display:block">
		<input type="text" name="browserkeyword" id="browserkeyword" value="" placeholder="请输入..."/>
		<a id="search" href="javascript:browserSearch('<%=browserId %>','<%=showfield %>');" data-role="button"  data-mini="true" data-inline="true">查询</a>
		<a id="okBtn" href="javascript:browserSelect('<%=showfield %>');" data-role="button"  data-mini="true" data-inline="true" data-icon="check" data-theme="b" data-rel="back">确定</a>
	</span>
	<div style="position: relative;">
		<div id="loading">
			<div class="loadMask"></div>
			<div class="loadText"></div>
		</div>
		
		<div id="browserDataContainer">
			<ul data-role="listview" data-inset="true" id="browsserlist">
			</ul>
			
			<a id="loadMore" href="javascript:browserSearchMore('<%=browserId %>','<%=showfield %>');">加载更多</a>
			<script type="text/javascript">
				$("#loadMore").hide();
			</script>
		</div>
	</div>
</div>
</body>
</html>