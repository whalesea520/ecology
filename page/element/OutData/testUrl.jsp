<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%  
  StringBuffer content = new StringBuffer("");   
  content.append("<?xml version=\"1.0\"   encoding=\"UTF-8\" ?>");  
  content.append("<roots>");
   content.append("<ro>"); 
  content.append("<id>");  
  content.append("545454");  
  content.append("</id>");
  content.append("<name>");  
  content.append("545454");  
  content.append("</name>");
  content.append("<name2>");  
  content.append("545454");  
  content.append("</name2>");
  content.append("</ro>");  
  content.append("<ro>"); 
  content.append("<id>");  
  content.append("88888");  
  content.append("</id>");
  content.append("<name>");  
  content.append("");  
  content.append("</name>"); 
  content.append("<name2>");  
  content.append("545454");  
  content.append("</name2>");
  content.append("</ro>");  
  content.append("</roots>");  
  response.setCharacterEncoding(weaver.general.GCONST.XML_UTF8);  
  out.print(content);  
%> 