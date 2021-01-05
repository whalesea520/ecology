<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,weaver.monitor.cache.monitor.*,weaver.monitor.cache.Util.*,weaver.monitor.cache.*" %>
<html>  
<%
String title = "";
String cacheStr = "";
String logStr = "";
String logUpdateStr = "";
String cacheParam = "";
String logParam ="";
String logUpdateParam ="";

String cache = request.getParameter("isCache"); 
String log = request.getParameter("islog"); 
String cacheparam = request.getParameter("cachelevel"); 
String urlskey = "";
String searchkey = request.getParameter("searchkey"); 
if(searchkey == null){
	searchkey = "";
}else {
	urlskey = "&searchkey="+searchkey.toLowerCase();
}

String isreload = request.getParameter("isreload"); 

if(isreload != null && "1".equals(isreload)){
	CacheFactory.getInstance().reset();
}







if("1".equals(cache)){
	ConfigMap.update("iscache","1");
}else if("0".equals(cache)){
	ConfigMap.update("iscache","0");
	CacheFactory.getInstance().clear();
}

if("1".equals(cacheparam)){
	ConfigMap.update("cachelevel","1");
}else if("2".equals(cacheparam)){
	ConfigMap.update("cachelevel","2");
}else if("3".equals(cacheparam)){
	ConfigMap.update("cachelevel","3");
	CacheFactory.getInstance().clearCacheMap();
}
String cachelevel = ConfigMap.get("cachelevel");
	String isCache = ConfigMap.get("iscache");
	if("1".equals(isCache)){
		title = "�����ѿ���";
		cacheStr = "�رջ���";
		cacheParam = "0";
	}else if("0".equals(isCache)){
		title = "�����ѽ���";
		cacheStr = "��������";
		cacheParam = "1";
	}
	
 
	 if("1".equals(log)){
		 ConfigMap.update("islog","1");
	 }else if("0".equals(log)){
		 ConfigMap.update("islog","0");
	 }else if("2".equals(log)){
		 ConfigMap.update("islog","2");
	 }

	String islog = ConfigMap.get("islog");
	if("1".equals(islog)){
		title +="(��־�ѿ���)";
		logStr = "�ر���־";
		logUpdateStr = "�ر���־";
		logUpdateParam ="0";
		logParam = "0";
	}else if("0".equals(islog)){
		title +="(��־�ѹر�)";
		logStr = "������־";
		logUpdateStr = "�����޸���־";
		logUpdateParam ="2";
		logParam = "1";
	}else if("2".equals(islog)){
		title +="(�޸���־�ѿ���)";
		logUpdateStr = "�ر���־";
		logStr = "������־";
		logUpdateParam ="0";
		logParam = "1";
	}
	
%>  

  
    <body>  
    
  <input type="radio" <%= cachelevel.equals("1") ? "Checked":"" %> name="cachelevel" value="1" onclick="updateCacheLevel(1)"/>
	 ά����д���� &nbsp;&nbsp;
	
	 	
	  <input type="radio" <%= cachelevel.equals("2") ? "Checked":"" %> name="cachelevel" value="2" onclick="updateCacheLevel(2)"/>
	���ö����� &nbsp;&nbsp;

		 <input type="radio" <%= cachelevel.equals("3") ? "Checked":"" %> name="cachelevel" value="3" onclick="updateCacheLevel(3)"/>

	 ֻά������ͬ��&nbsp;&nbsp;

	<input id="searchkey" type="textfield" value="<%=searchkey %>"></input>&nbsp;&nbsp;
	<button><a onclick="dosearch('searchkey')">����</a> </button>
	
	  
	 <span style="margin-right:30px;padding-right:30px;">
	
	 </span>
	  <button><a onclick ="updateCache(<%= cacheParam%>)" ><%=cacheStr%></a> </button>
	  <button><a onclick ="reloadConfig()" >���¼�������</a> </button>&nbsp;&nbsp;&nbsp;
	 <button><a onclick ="updatelog(<%= logParam%>)" ><%=logStr%></a>  </button>
	 <button><a onclick ="updatelog(<%= logUpdateParam%>)" ><%=logUpdateStr%></a>  </button>
	 
	  <br /><br />

</body>  

<script>
	function updateCacheLevel(level){
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?cachelevel="+level;	
		location.href = url;
	}

/**
	function updateProp(key,value){
		var mapkey = document.getElementById(key).value;
		mapkey = trim(mapkey);
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));

		var mapvalue = document.getElementById(value).value;
		mapvalue = trim(mapvalue);
		url = url + "?mapkey="+mapkey + "&mapvalue=" +mapvalue;			
			
		location.href = url;
	}


	function queryProp(key){
		var mapkey = document.getElementById(key).value;
		mapkey = trim(mapkey);
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));	
			
		url = url + "?mapkey="+mapkey;			
			
		location.href = url;
	}
	**/

	
	function reloadConfig(){
	
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?isreload=1";			
			
		location.href = url;
	}


	function updateCache(key){
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?isCache="+key;			
			
		location.href = url;
	}

	function updatelog(key){
		
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?islog="+key;			
			
		location.href = url;
	}


	function trim(str) {
  return str.replace(/(^\s+)|(\s+$)/g, "");
}

</script>
</html> 