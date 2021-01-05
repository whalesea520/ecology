<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.fullsearch.model.FSViewSetInfo" %>
<%@ page import="weaver.fullsearch.model.FSSearchSetInfo" %>
<%@ include file="init.jsp" %>
<jsp:useBean id="searchSetDao" class="weaver.fullsearch.dao.SearchSetDao" scope="page" />
<jsp:useBean id="viewSet" class="weaver.fullsearch.bean.ViewSetBean"/>
<jsp:setProperty name="viewSet" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="viewSet" property="user" value="<%=user%>"/>
<% 
	 String type = request.getParameter("changetype");
     
     Map map = viewSet.getMapOfViewSet(user.getUID());
     FSViewSetInfo allVinfo = null;
     if(map.containsKey("ALL")){
     	allVinfo = (FSViewSetInfo)map.get("ALL");
     }

     //每页显示条数
     int num = (allVinfo != null?allVinfo.getNumPerPage():-1);
	 //搜索高级配置
	 FSSearchSetInfo searchSetInfo=searchSetDao.getSearchSetInfo(user.getUID());
     
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=SystemEnv.getHtmlLabelName(83361,user.getLanguage()) %></title>

<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/commonCss_wev8.css" type="text/css" />


<style type="text/css">

.bar_div{
	height:35px;
	background-color: #f6f6f6;
	line-height: 35px;
	width:100%;
	-moz-border-radius: 8px; 
    -webkit-border-radius: 8px; 
    border-radius:8px 8px 0px 0px; 
    font-family:微软雅黑;
	font-size: 12px; 
}

.line_div{
	width:100%;
	height: 50px;
  	line-height: 50px;
  	font-family:微软雅黑;
	font-size: 12px; 
}

.lable_div{
 	  width: 160px;
  	  text-align: right;
  	  margin-right: 10px;
  	  font-family:微软雅黑;
	  font-size: 12px; 
	  white-space:nowrap; 
	  text-overflow:ellipsis;
	  overflow: hidden;
} 

.field_div{
	font-family:微软雅黑;
	font-size: 12px; 
}

.left_div{
	float:left;
}

.foot_div{
	margin-left:200px;
	margin-top:15px;
	font-family:微软雅黑;
	font-size: 12px; 
}

.btn_div{
  width: 90px;
  height: 30px;
  border: 1px solid #e5e5e5;
  line-height: 30px;
  color: #018ff8;
  cursor: pointer;
  text-align: center;
}

.btn_div:HOVER{
  border: 1px solid #e5e5e5;
  line-height: 30px;
  color: #018ff8;
  background-color: #018ff8;
  color:#fff;
}

.yj{
	margin-top:8px;
    width:460px; 
    height:200px;
    border: 1px solid #e5e5e5;
    -moz-border-radius: 8px; 
    -webkit-border-radius: 8px; 
    border-radius:8px;   
    background-color: #fff;        
}

/*向上箭头*/
div.arrow-up { 
	width: 0; 
	height: 0; 
	border-left: 8px solid transparent; /* 左边框的宽 */ 
	border-right: 8px solid transparent; /* 右边框的宽 */ 
	border-bottom: 8px solid #e5e5e5; /* 下边框的长度|高,以及背景色 */ 
	font-size: 0; 
	line-height: 0;
	position: absolute;
	top: 0px;
	left: 430px;
}

/*向上箭头*/
div.arrow-up1 { 
	width: 0; 
	height: 0; 
	border-left: 8px solid transparent; /* 左边框的宽 */ 
	border-right: 8px solid transparent; /* 右边框的宽 */ 
	border-bottom: 8px solid #f6f6f6; /* 下边框的长度|高,以及背景色 */ 
	font-size: 0; 
	line-height: 0;
	position: absolute;
	top: 1px;
	left: 430px;
}
.sbSelector{
	line-height: 22px;
}	
</style>
<script type="text/javascript">
 jQuery(document).ready(function(){
 });
var isshow=false; 
function showSetting(){
	if(isshow){
		hideSetting();
	}else{
		isshow=true;
		$('#searchSetDiv').show();
	}
	
}

function hideSetting(){
	isshow=false;
	$('#searchSetDiv').hide();
}

function save(){
	//可以判断值是否发生变化,再提交
	jQuery.ajax({
	   type: "GET",
	   url: "/fullsearch/AjaxOperation.jsp?",
	   data: "method=saveSet&numperpage="+$('#numperpage').val()+"&searchField="+$('#searchField').val()+"&sortField="+$('#sortField').val(),
	   success: function(msg){
	      hideSetting();
	      dosubmit();
	   }
	});
	 
}	
</script>
</head>
<body>
<form action="" method="POST" name="frm" id="frm">
<div id="setBodyDiv" class="yj">
	<div class="arrow-up"></div>
	<div class="arrow-up1"></div>
	
	<div class="bar_div">
		<div style="margin-left:13px;"><%=SystemEnv.getHtmlLabelNames("197,68",user.getLanguage()) %></div>
	</div>
	
	<div  class="line_div" >
		<div class="left_div lable_div" title="<%=SystemEnv.getHtmlLabelName(17491,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage()) %>:</div>
		<div>
			<select id="numperpage" name="numperpage" style="width:33px">
				<option value="10" <%if(num <= 10){%>selected<%} %>>10</option>
				<option value="15" <%if(num == 15){%>selected<%} %>>15</option>
				<option value="20" <%if(num == 20){%>selected<%} %>>20</option>
			</select>&nbsp;<%=(user.getLanguage()==7||user.getLanguage()==9)?"条":"" %>
		</div>
	</div>
	
	<div  class="line_div" >
		<div class="left_div lable_div"><%=SystemEnv.getHtmlLabelName(19332,user.getLanguage()) %>:</div>
		<div class="left_div field_div" style="width:260px">
			<select id="searchField" name="searchField"  style="width:81px">
				<option value="0"  <%if(searchSetInfo.getSearchField() == 0){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(125623,user.getLanguage()) %> </option>
				<option value="1" <%if(searchSetInfo.getSearchField() == 1){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(125624,user.getLanguage()) %></option>
			</select>&nbsp;&nbsp; 
			
			<select id="sortField" name="sortField"  style="width:116px">
				<option value="0"  <%if(searchSetInfo.getSortField() == 0){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(125625,user.getLanguage()) %></option>
				<option value="1" <%if(searchSetInfo.getSortField()== 1){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(125626,user.getLanguage()) %></option>
			</select>
		</div>
	</div>
	
	<div class="foot_div" ><div class="btn_div" onclick="save()"><%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %></div></div>
</div>
</form>
</body>
</html>
