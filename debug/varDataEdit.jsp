
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script type="text/javascript" src="javascripts/jquery-1.4.2.min_wev8.js"></script>
<%@ include file="init.jsp" %>
<%
if (!isInitDebug()) {
    return;
}

%>
<%
    if(debugCurrentClass==null || debugCurrentLine==null){
        return;
    }
    
    Object debugData = session.getAttribute(debugDataKey);
    Class dataClass = Class.forName("com.weaver.onlinedebug.data.DebugData");

    Class util = Class.forName("com.weaver.onlinedebug.util.Util");
    String info = (String)util.getMethod("getVarLineData",new Class[]{dataClass, String.class, int.class}).invoke(null,new Object[]{debugData,debugCurrentClass,Integer.valueOf((String)debugCurrentLine)});
    info = info.replace(';','\n');
%>

<HTML>
<HEAD>
<link type='text/css' rel='stylesheet'  href='css/main_wev8.css'/>
<style type="text/css">
<!--

.mydiv{
    margin:0px;
    padding:0px;
}
-->
</style>
<script type="text/javascript">

function setCurrent(){
    var nl  = document.getElementById('newline');
    top.setCurrent("<%=debugCurrentClass%>", nl.value);
    
}
</script>
</HEAD>
<BODY class='mydiv'>
<form action='debugAction.jsp' target='vardatalist' id="editForm" >
<table width='100%' height='100%' border='1' style="border-collapse:collapse;border-width: 1px; border-style: solid;">
<tr><td height='30px'>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>行号：<input type='text' id='newline' name='newline' value='<%=debugCurrentLine %>'></td>
		<td class="pointList"></td>
		<td height="27px;" class="pointOper">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><div style="cursor:pointer" onclick="setCurrent();$('#editForm').submit();">应用</div></td>
				</tr>
			</table>
		</td>
		<td class="btnCR"></td>
	</tr>
</table>
</td></tr>
<tr><td>
<textarea name='info' style='width:100%;height:100%'><%=info %></textarea>
</td></tr>
</table>
<input type='hidden' name='oldline' value='<%=debugCurrentLine %>' style='display:none'>
<input type='hidden' name='classname' value='<%=debugCurrentClass %>' style='display:none'>
<input type='hidden' name='action' value='editvardata' style='display:none'>
</form>



</BODY>
</HTML>