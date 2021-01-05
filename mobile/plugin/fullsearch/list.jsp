<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.fullsearch.MobileSchemaBean"%>
<%@page import="weaver.fullsearch.MobileSchemaUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.mobile.plugin.ecology.service.FullSearchService"%>
<%@page import="weaver.mobile.plugin.ecology.service.FullSearchConditionBean"%>
<%@page import="java.util.Iterator"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-siteapp">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<meta name="viewport" content="width=device-width, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<!-- viewport -->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="renderer" content="webkit">
<meta name="screen-orientation" content="portrait">
<meta name="full-screen" content="yes">
<meta name="x5-orientation" content="portrait">
<meta name="x5-fullscreen" content="true">
<meta name="description" content="欢迎访问">

<link rel="stylesheet" href="/mobile/plugin/fullsearch/css/index.css">
<title>微搜</title>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

FileUpload fu = new FileUpload(request);
String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = URLDecoder.decode(titleurl,"UTF-8");

String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String viewmodule = Util.null2String(fu.getParameter("viewmodule"));
//外部传入快速搜索key
String sKey = Util.null2String(fu.getParameter("sKey"));
String sType = Util.null2String(fu.getParameter("sType"));
boolean hideHead="1".equals(Util.null2String(fu.getParameter("hideHead")));
if(!"".equals(sKey)){
	//sKey=URLDecoder.decode(sKey,"UTF-8");
}

//对标准模块权限放开 start
Map<String,MobileSchemaBean > urlMap=MobileSchemaUtil.getInstance().getSchemaUrlMap();
Map<String,MobileSchemaBean > cusMap=MobileSchemaUtil.getInstance().getSchemaCusMap();

Map<String,MobileSchemaBean> pageMap = new HashMap<String,MobileSchemaBean>();
pageMap.putAll(urlMap); //深拷贝

String authModule=viewmodule;//"1,2,4,6,13,14,15";
String authModules[]=authModule.split(",");
for(int i=0;i<authModules.length;i++){
	if(Util.getIntValue(authModules[i],-1)>=-1) continue; 
	//判断有没有自定义(建模),可以替换标准模块的跳转
	if(cusMap.containsKey(authModules[i])){
		MobileSchemaBean msb=cusMap.get(authModules[i]);
		pageMap.put(msb.getSechma(),msb);
	}
}
//对标准模块权限放开 end
String contentType="ALL";
String keyword = "";
if(!"".equals(sKey)){
	keyword=sKey;
}
if(!"".equals(sType)){
	contentType=sType;
}
String pageindex="1";//指backIndex
int pagesize=10;
FullSearchService fs=new FullSearchService();
//设置每页显示条数
fs.setPageSize(pagesize);
 
String back=Util.null2o(fu.getParameter("fromES"));

if("true".equals(back)){
	FullSearchConditionBean fsc=fs.gutSessionCondition(sessionkey);
	//如果是从其他页面返回过来,从session中获取数据
	if(fsc!=null){
		title=fsc.getTitle();
		pageindex=fsc.getPageindex();
		keyword=fsc.getKeyword();
		contentType=fsc.getContentType();
		hideHead=fsc.isHideHead();
	}
}

boolean intoFAQ=false;
RecordSet.execute("select sValue from FullSearch_EAssistantSet where sKey='ALLOWSUBMITFAQ'");
if(RecordSet.next()){
	intoFAQ="1".equals(RecordSet.getString("sValue"));
}

%>
 
  <style type="text/css">
  .am-search{
      background: #3496FC !important;
  }

  .am-search-cancel{
      color: #FFFFFF !important;
  }
  
  #hotDiv .am-flexbox-item{
  	 margin-bottom: 8px !important;
  }
  
  #resultDiv .am-list-content{
  	  font-size: 14px;
  	  color: #58657b;
  }
  
  #resultDiv .am-list-content .am-list-brief{
  	  font-size: 12px;
  	  color: #a8a8a8;
  }
  
  /*热点样式*/
  .hottd{
    border: 1px solid #848484;
    color:#848484;
    text-align :center;
	width: 65px;
	margin-bottom: 8px;
    line-height:35px;
    -moz-border-radius: 10px 10px 10px 10px;
    -webkit-border-radius: 10px 10px 10px 10px;
    border-radius: 10px 10px 10px 10px;
    font-size: 14px;
  } 
  
  .hottd a{
    display: block; 
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    -o-text-overflow: ellipsis;
  }
  
  .am-result:after{
  	border-bottom: none !important;
  }
  
  B{
  	color:red;
  }
  
  .searchDiv{
    top: 0px;
    width: 100%;
    z-index: 99;
  }
  
  .resultDiv{
  	overflow: auto;
  	-webkit-overflow-scrolling: touch;
  }
  
  .ul-li-div{
		float:left;
		margin-left: 60px;
		margin-top: 2px;
		width: 85%;
	}
	
	.ul-li-div-img{
		float:left;
		position: absolute;
	}
	
	.ul-li-div-img img{
		width:44px;
		height:44px;
		border-radius:44px;
	}
	
	.ul-li-div-img .imgDiv{
		width:44px;
		height:44px;
		border-radius:44px;
		line-height: 44px;
		text-align: center;
	    background: #6495e6;
    	color: #FFFFFF;
   	 	text-align: center;
    	font-size: 15px;
	}
	
	.ui-li-span{
		font-size: 16px;
	  	font-weight: 100 !important;
	  	display: block;
	  	text-overflow: ellipsis;
	 	overflow: hidden;
	  	white-space: nowrap;
	  	color: #a8a8a8;
	  	float: left;
	  	width: 45%;
	  	font-size: 12px;
	}
	
	.ui-li-span-heading{
		font-size: 14px;
		color: #58657b;
	}
	.ul-li-div-first{
		height: 20px;
	}
	
	.ul-li-div-second{
		height: 20px;
		margin-top: 3px;
	}
	
	.am-list-view-scrollview-content{
      	position:static !important;
	}

  </style>
</head>
<body style="background-color: #FFFFFF;overflow: hidden;">

<input type="hidden" id="pageindex" name="pageindex" value="<%=pageindex %>">
<input type="hidden" id="back" name="back" value="<%=back %>"> 
<input type="hidden" id="contentType" name="contentType" value="<%=contentType%>">
<input type="hidden" id="keyword" name="keyword" value="<%=keyword%>">
<input type="hidden" id="hideHead" name="hideHead" value="<%=hideHead%>">
<input type="hidden" id="title" name="title" value="<%=title%>">
<input type="hidden" id="userid" name="userid" value="<%=user.getUID()%>">

<!-- 以下用于js页面的多语言显示 -->
<input type="hidden" id="promptStr"  value="<%=SystemEnv.getHtmlLabelName(32933,user.getLanguage())%>">
<input type="hidden" id="searchStr"  value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>">
<input type="hidden" id="loadStr"  value="<%=SystemEnv.getHtmlLabelName(31230,user.getLanguage())%>...">
<input type="hidden" id="loadMoreStr"  value="<%=SystemEnv.getHtmlLabelName(128560,user.getLanguage())%>">
<input type="hidden" id="allStr"  value="<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>">
<input type="hidden" id="hotStr1"  value="<%=SystemEnv.getHtmlLabelName(81783,user.getLanguage())%>">
<input type="hidden" id="hotStr2"  value="<%=SystemEnv.getHtmlLabelName(83445,user.getLanguage())%>">
<input type="hidden" id="hotStr3"  value="<%=SystemEnv.getHtmlLabelName(81790,user.getLanguage())%>">
<input type="hidden" id="tipStr"  value="<%=SystemEnv.getHtmlLabelName(558,user.getLanguage())%>">

	
<div id="root"></div>
<%if(intoFAQ){ %>
	<div style="position: absolute;right: 20px;bottom: 15px;width: 40px;height: 40px;background-image: url(/mobile/plugin/fullsearch/img/customerService3_wev8.png);background-position: center;background-repeat: no-repeat;background-size: 100%;display: inline-block;" onclick="intoFAQ()"></div> 
<%} %>
<script type="text/javascript" src="/cloudstore/resource/mobile/react/react-with-addons.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/cloudstore/resource/mobile/react/react-dom.min.js" charset="utf-8"></script>

<script type="text/javascript" src="/mobile/plugin/fullsearch/js/promise.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/js/fetch.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/js/common.js" charset="utf-8"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/js/index.js" charset="utf-8"></script>
<script type="text/javascript" src="/mobilemode/js/fastclick/fastclick.min_wev8.js" charset="utf-8"></script>
<script>
  FastClick.attach(document.body);
  
  function goPage(detailid,schema,url) {
  		detailid=detailid.replaceAll("\\\\","");
		<%
			Iterator<String> it=pageMap.keySet().iterator();
			while(it.hasNext()){
				String key=it.next();
				String url=pageMap.get(key).getUrl();
				url=url.replaceAll("\\{ID\\}","\"+detailid+\"");
		%>
			if(schema=="<%=key%>"){
				location="<%=url%>";
				return;
			}
		<% }
		
		%>
	}
<%if(intoFAQ){ %>
	var commit=false;
	//提交查询结果不是想要的
	function intoFAQ() {
		if(commit){
			return;
		}
		commit=true;
		var key=getElementsByClassName("input","am-search-value")[0].value;
		if(key==""){
			alert("您还未查询,不能提交");
			commit=false;
			return;
		}
	    var a=confirm("不是我想要的答案\n确认提交?");
	     if(a){
	     	fetch("/mobile/plugin/fullsearch/ajaxVoice.jsp?type=insertFAQ&commitTag=2&ask="+key, {
	            method: 'POST',
	            mode: 'same-origin',
	            headers: {'Content-Type': 'application/json; charset=utf-8'},
	            credentials: 'include'
	        }).then(function(res) {
	        	commit=false;
	            console.log("问题已提交");
	        }).catch(function(e) {
	        	commit=false;
	          	console.log("error",e);
	        });
	     }else{
	     	commit=false;
	     }		 
	}
	
	function getElementsByClassName(strTagName, strClassName){ 
		var arrElements = (strTagName == "*" && document.all)? document.all : document.getElementsByTagName(strTagName); 
		var arrReturnElements = new Array(); 
		strClassName = strClassName.replace(/\-/g, "\\-"); 
		var oRegExp = new RegExp("(^|\\s)" + strClassName + "(\\s|$)"); 
		var oElement; 
		for(var i=0; i < arrElements.length; i++){ 
			oElement = arrElements[i]; 
			if(oRegExp.test(oElement.className)){ 
				arrReturnElements.push(oElement); 
			} 
		} 
		return (arrReturnElements) 
	} 

<%}%>
String.prototype.replaceAll = function(s1,s2){  
	return this.replace(new RegExp(s1,"gm"),s2);  
} 	
</script>

</body>
</html>