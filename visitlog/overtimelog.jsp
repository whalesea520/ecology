<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.*,weaver.filter.*" %>
<html>  
   2222||<%=OverTimeService.overtimelog.size()%>
    <body>  
    <br/>
    <table border="1" spacing="2">  
  		<tr>  
            <td>����ʱ��</td>  
            <td>�û�loginid</td>  
            <td>����uri</td>  
			<td>����ʱ��</td> 
            <td>������ip</td>      
        </tr>  
		
<%  
    //һҳ��5��  
    try{  
    	
       for (Map.Entry<String, OverTimeBean> entry : OverTimeService.overtimelog.entrySet()) {
				OverTimeBean obj = entry.getValue();
            %>  
        <tr>  
            <td><%=obj.getTime()%></td>  
            <td><%=obj.getUserid()%></td>  
             <td><%=obj.getUri()%></td> 
			  <td><%=obj.getRequestTime()%></td> 
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