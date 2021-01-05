
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.lang.reflect.*"%>
<%@ page import="java.util.*"%>
<%@ include file="init.jsp" %>
<%
if (!isInitDebug()) {
    return;
}

%>
<%
    Object debugData = session.getAttribute(debugDataKey);
    Class dataClass = Class.forName("com.weaver.onlinedebug.data.DebugData");
    if(debugData == null){
        debugData = dataClass.newInstance();
        session.setAttribute(debugDataKey, debugData);
    }
    
    Class util = Class.forName("com.weaver.onlinedebug.util.Util");
    List list = (List)util.getMethod("data2VaList",new Class[]{dataClass}).invoke(null,new Object[]{debugData});
    
    
%>

<HTML>
<HEAD>
<link type='text/css' rel='stylesheet'  href='css/main_wev8.css'/>
<style type="text/css">
<!--
.mydiv,body,table,form{
    margin:0px;
    padding:0px;
    background-color:#fff;
}
-->
</style>
<script type="text/javascript">
function shiftCheck(className, line, enable){
    window.location = 'debugAction.jsp?action=setenable&classname='+className+'&line='+line+'&enable='+enable;
}
var lastObj = null;
function setCurrent(obj,className, line){
    top.setCurrent(className, line);
    var els = document.getElementsByTagName('td');
    for(var i=0; i<els.length; i++){
        els[i].style.background='';
    }
    obj.style.background='#eee';
    
}
</script>
</HEAD>
<BODY class='mydiv'>
<form action='debugAction.jsp?action=editvardata' target='vardatalist'>
<table width='100%' border='1' style="border-collapse:collapse;border-width: 1px; border-style: solid;">
<colgroup>
<col width='20px'></col>
<col width='*'></col>
</colgroup>
<%
for(int i=0; i<list.size(); i++){
    String items[] = ((String)list.get(i)).split("\\|");
    String curStyle = "";
    if(items[0].equals(debugCurrentClass) && items[1].equals(debugCurrentLine)){
        curStyle = ";background:#eee";
    }
%>
<tr >
    <td><input type='checkbox' onclick='shiftCheck("<%=items[0]%>","<%=items[1]%>","<%="true".equals(items[2])?"false":"true" %>")' <%=("true".equals(items[2])?"checked":"") %> ></td>
    <td id='currentline_'+<%=items[1] %> style='<%=curStyle %>' onclick='setCurrent(this,"<%=items[0]%>","<%=items[1]%>")'>[<%=items[1]%>]<%=items[0].endsWith("__jsp")?jspClass2Path(items[0]):items[0]%></td>
</tr>
<%
}
%>
</table>
<input type='hidden' name='action' value='editvardataline' style='display:none'>
</form>



</BODY>
</HTML>

<%!
    public static String jspClass2Path(String jspClass) throws Exception {
        String jspPath = (String)Class.forName("com.weaver.onlinedebug.util.Util").getDeclaredMethod("jspClass2Path",new Class[]{String.class}).invoke(null, new Object[]{jspClass});
        return jspPath;
    }
%>