<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,weaver.filter.*" %>
<html>  
  
    <body>  
    <br/>
	 2222||<%=OverTimeService.visitLog.size()%>
    <table border="1" spacing="2">  
  		<tr>  
            <td>访问时间</td>  
            <td>用户loginid</td>  
            <td>请求uri</td>  
            <td>服务器ip</td>      
        </tr>  
		
<%  
    //一页放5个  
    try{  
    	
       for (Map.Entry<String, OverTimeBean> entry : OverTimeService.visitLog.entrySet()) {
				OverTimeBean obj = entry.getValue();
            %>  
        <tr>  
            <td><%=obj.getTime()%></td>  
            <td><%=obj.getUserid()%></td>  
             <td><%=obj.getUri()%></td> 
            <td><%=obj.getServerip()%></td>  
          
        </tr>  
<%  
       }
    }  
    catch(Exception e){  
          e.printStackTrace();
    }  
%>  
</table>  

</body>  

</html> 