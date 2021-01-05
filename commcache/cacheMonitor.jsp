<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,weaver.monitor.cache.monitor.*,weaver.monitor.cache.Util.*,weaver.monitor.cache.*" %>
<html>  
<%@ include file="commoncache.jsp" %>
  
    <body>  
    <br/>
	<a href = "cacheMonitor.jsp?cachetype=1<%= urlskey%>" >查询缓存次数排序</a>  &nbsp;&nbsp;&nbsp;

	<a href = "cacheMonitor.jsp?cachetype=2<%= urlskey%>" >查询数据库次数排序</a>  &nbsp;&nbsp;&nbsp;

	<a href = "cacheMonitor.jsp?cachetype=3<%= urlskey%>" >查询数据库时间排序</a>  &nbsp;&nbsp;&nbsp;

	&nbsp;&nbsp;&nbsp;
	<button><a href = "tableCacheMonitor.jsp" >表缓存监控</a>  </button>

	<button><a href = "export.jsp?type=sql" >导出</a>  </button>
	<%
    final int PAGESIZE = 15;  
    int pageCount;  
    int curPage = 1;  
    String tablesort ="";
    String cachetype ="";
	final String queryCountStr ="queryCount";
		final String queryDbCountStr ="queryDbCount";
		final String queryLostTimeStr ="queryLostTime";
		CacheFactory sintance = CacheFactory.getInstance();
		int size =0;
		LRULinkedHashMap<String, Object> cacheMap =  sintance.getCacheMap();
   	  
		List cacheList = ListSorter.converMapToList(cacheMap,searchkey);
       	size = cacheList.size(); 
        pageCount = (size%PAGESIZE==0)?(size/PAGESIZE):(size/PAGESIZE+1); 
		
		long tt =  TableCacheBean.sumQueryCount.longValue();

%>  
	<h1><%= title %>&nbsp;&nbsp;&nbsp;&nbsp;缓存数量(<%= size %>)&nbsp;&nbsp;&nbsp;&nbsp;<%= tt %></h1>
    <table border="1" spacing="2">  


  		<tr>  
            <td>缓存时间</td>  
            <td>sql查询数据库次数</td>  
            <td>sql查询数据库花费时间</td>  
            <td>sql</td>  
            <td>sql缓存查询次数</td>  
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
			ListSorter.sort(cacheList,queryLostTimeStr);
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
            SQLCacheBean bean =(SQLCacheBean) cacheList.get(currIndex);
            String tName = new Date(bean.getLastCacheTime()).toLocaleString();
            String sql = bean.getSql();
            long qCount = bean.getQueryCount();
            long rCount = bean.getQueryDbCount();
            long lostTime = bean.getQueryLostTime();
            count ++;  
            currIndex ++;
            %>  
        <tr>  
            <td><%=tName%></td>  
            <td><%=rCount%></td>  
             <td><%=lostTime%></td> 
            <td><%=sql%></td>  
            <td><%=qCount%></td>  
        </tr>  
            <%  
        }while(currIndex<cacheList.size());  
    }  
    catch(Exception e){  
          e.printStackTrace();
    }  
%>  
</table>  


<a href = "cacheMonitor.jsp?curPage=1&cachetype=<%=cachetype%><%= urlskey%>" >首页</a>  
<a href = "cacheMonitor.jsp?curPage=<%=curPage-1%>&cachetype=<%=cachetype%><%= urlskey%>" >上一页</a>  
<a href = "cacheMonitor.jsp?curPage=<%=curPage+1%>&cachetype=<%=cachetype%><%= urlskey%>" >下一页</a>  
<a href = "cacheMonitor.jsp?curPage=<%=pageCount%>&cachetype=<%=cachetype%><%= urlskey%>" >尾页</a>  
第<%=curPage%>页/共<%=pageCount%>页  
  
</body>  
<script>
function dosearch(key){
		var searchkey = document.getElementById(key).value;
		var url = window.location.href;
		url = url.substring(0,url.indexOf('?'));
		url = url + "?searchkey="+searchkey;			
			
		location.href = url;
	}

</script>
</html> 