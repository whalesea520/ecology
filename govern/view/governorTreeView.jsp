<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.govern.service.GovernService" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature" %>

<%
String governorId = Util.null2String(request.getParameter("id"));
GovernService gs = new GovernService();
Map<String,Object> gsJson = gs.getGovernorTree(governorId);
String approvalStatus = Util.null2String(gsJson.get("approvalStatus"));
Map<String,Object> dataMap = (Map<String,Object>)gsJson.get("dataMap");

String jsonStr = JSON.toJSONString(dataMap,SerializerFeature.DisableCircularReferenceDetect);
System.out.println(jsonStr);
%>
<html>  
  <head>  
        <meta charset="utf-8">  
        <title>树状图</title>  
<style>

.node {
  cursor: pointer;
}

.node circle {
  fill: #fff;
  stroke: steelblue;
  stroke-width: 1.5px;
}

.haha{
  font: 20px sans-serif;
  file: #d80e0e;
}

.node text {
  font: 20px sans-serif;
}

.node span {
  font: 20px sans-serif;
}

.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
}

</style>
  </head> 
<body>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>

var d3json = <%=jsonStr%>;
console.log(d3json);
var margin = {top: 20, right: 120, bottom: 20, left: 120},
    width = 960 - margin.right - margin.left,
    height = 800 - margin.top - margin.bottom;

var i = 0,
    duration = 750,
    root;

var tree = d3.layout.tree()
    .size([height, width]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

var svg = d3.select("body").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
  	.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.select("body").select("svg").style("padding-left","200px");




	var nodes = tree.nodes(d3json);
	var links = tree.links(nodes);
	
	console.log(nodes);
	console.log(links);
	
	var link = svg.selectAll(".link")
	  .data(links)
	  .enter()
	  .append("path")
	  .attr("class", "link")
	  .attr("d", diagonal);
	
	var node = svg.selectAll(".node")
	  .data(nodes)
	  .enter()
	  .append("g")
	  .attr("class", "node")
	  .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })
	
	node.append("circle")
	  .attr("r", 4.5);
	
	node.append("text")
	  .attr("dx", function(d) { return d.children ? -8 : 8; })
	  .attr("dy", 3)
	  .style("text-anchor", function(d) { return d.children ? "end" : "start"; })
	  .style("fill", function(d) { 
		  var colors = d.statu == "3" ? "#2b9800" : (d.statu == "2" ? "#d80e0e":(d.statu == "1"?"#4293e8":"#080808")); 
		  console.log(colors);
		  return colors;
		  })
	  .text(function(d) { return d.name; });
	

</script>
		
    </body>  
</html>  
