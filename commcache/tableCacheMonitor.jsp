<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,weaver.monitor.cache.monitor.*,weaver.monitor.cache.Util.*,weaver.monitor.cache.*,java.util.concurrent.ConcurrentHashMap" %>
<html>  
<%@ include file="commoncache.jsp" %>

  
    <body>  

	<a href = "tableCacheMonitor.jsp?cachetype=1<%= urlskey%>" >查询缓存次数排序</a>  &nbsp;&nbsp;&nbsp;

	<a href = "tableCacheMonitor.jsp?cachetype=2<%= urlskey%>" >查询数据库次数排序</a>  &nbsp;&nbsp;&nbsp;

	<a href = "tableCacheMonitor.jsp?cachetype=3<%= urlskey%>" >表清空次数排序</a>  &nbsp;&nbsp;&nbsp;

	
	
	 
	表缓存名称:
	<input id="tableName" type="textfield"></input>&nbsp;&nbsp;
	<button><a onclick="updateTableCache('tableName')">清空表缓存</a> </button>&nbsp;&nbsp;&nbsp;&nbsp;
	 <button><a href = "cacheMonitor.jsp" >sql缓存监控</a>  </button>
	 <button><a href = "export.jsp?type=table" >导出</a>  </button>
	<%  
     final int PAGESIZE = 15;  
    int pageCount =0;  
    int curPage = 1;  
    String tablesort ="";
    String cachetype ="";
	final String queryCountStr ="queryCount";
	final String delCountStr ="delCount";
	
		final String queryDbCountStr ="queryDbCount";
		CacheFactory sintance = CacheFactory.getInstance();
		int size =0;
		ConcurrentHashMap<String, Object> cacheMap =  sintance.getTableMap();
   	  
		List cacheList = ListSorter.converMapToList(cacheMap,searchkey);
       	size = cacheList.size(); 
        pageCount = (size%PAGESIZE==0)?(size/PAGESIZE):(size/PAGESIZE+1); 
		
		String updatetablecache = request.getParameter("updatetablecache"); 

		if(updatetablecache != null){
			String tkey = updatetablecache.trim().toLowerCase();
			String [] tables = new String[]{tkey};
			sintance.removeCache(tables);
		}
%>  
	<h1><%= title %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;总缓存的数量(<%= size %>)</h1>
    <table border="1" spacing="2">  


  		<tr>  
  			<td>表名</td>  
            <td>缓存时间</td>  
            <td>表查询数据库次数</td>  
            <td>表缓存查询次数</td>  
            <td>表缓存清空次数</td>  
        </tr>  
<%  
    //一页放5个  
    try{  
    	
        String tmp = request.getParameter("curPage");  

		 tablesort = request.getParameter("tablesort"); 
		 cachetype = request.getParameter("cachetype"); 

		if("2".equals(cachetype)){
			ListSorter.sort(cacheList,queryDbCountStr);
		}else if("1".equals(cachetype)){
			ListSorter.sort(cacheList,queryCountStr);
		}else if("3".equals(cachetype)){
			ListSorter.sort(cacheList,delCountStr);
		}else{
			ListSorter.sort(cacheList,queryCountStr);
		}
		 
        if(tmp == null){  
            tmp="1";  
        }  
        curPage = Integer.parseInt(tmp);  
        if(curPage>=pageCount) curPage = pageCount;  
        int currIndex = (curPage-1)*PAGESIZE;  
        out.println(curPage);  
        int count = 0;  
        do{  
            if(count>=PAGESIZE || currIndex>= cacheList.size() || currIndex <0)break;  
            TableCacheBean bean =(TableCacheBean) cacheList.get(currIndex);
            String tName = new Date(bean.getTimeflag()).toLocaleString();
            String tableName = bean.getTableName();
            long qCount = bean.getQueryCount();
            long dbCount = bean.getQueryDbCount();
            long rCount = bean.getDelCount();
            count ++;  
            currIndex ++;
            %>  
        <tr>  
            <td><%=tableName%></td>  
            <td><%=tName%></td>  
            <td><%=dbCount%></td> 
            <td><%=qCount%></td>  
            <td><%=rCount%></td>  
        </tr>  
            <%  
        }while(currIndex<cacheList.size());  
    }  
    catch(Exception e){  
          e.printStackTrace();
    }  
%>  
</table>  


<a href = "tableCacheMonitor.jsp?curPage=1&cachetype=<%=cachetype%><%= urlskey%>" >首页</a>  
<a href = "tableCacheMonitor.jsp?curPage=<%=curPage-1%>&cachetype=<%=cachetype%><%= urlskey%>" >上一页</a>  
<a href = "tableCacheMonitor.jsp?curPage=<%=curPage+1%>&cachetype=<%=cachetype%><%= urlskey%>" >下一页</a>  
<a href = "tableCacheMonitor.jsp?curPage=<%=pageCount%>&cachetype=<%=cachetype%><%= urlskey%>" >尾页</a>  
第<%=curPage%>页/共<%=pageCount%>页  
  

  <script>

  function updateTableCache(key){
	  var value = document.getElementById(key).value;
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?updatetablecache="+value+"&searchkey="+value;			
			
		location.href = url;
	}


	function dosearch(key){
		var searchkey = document.getElementById(key).value;
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?searchkey="+searchkey.toLowerCase();			
			
		location.href = url;
	}
  </script>

</body>  
</html> 