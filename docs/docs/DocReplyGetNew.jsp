
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
	int docid = Util.getIntValue(request.getParameter("docid"),0);
	
	String isReply = Util.null2String(request.getParameter("isReply"));

%>

<%
				//设置好搜索条件				
				
				String tableString=""+
					   "<table datasource=\"weaver.docs.docs.DocDataSource.getDocReply\" sourceparams=\"docid:"+docid+"+isReply:"+isReply+"\" pagesize=\"10\" tabletype=\"none\" needPage=\"false\">"+
					   "<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"shareId\" sqlsortway=\"desc\"  />"+
					   "<head>";
					   		tableString+="<col width=\"40%\" labelid=\"1341\"  text=\""+SystemEnv.getHtmlLabelName(1341,user.getLanguage())+"\" column=\"docsubject\" />";
					   		tableString += "<col width=\"20%\" labelid=\"79\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"owner\"/>";
							tableString += "<col width=\"30%\" labelid=\"19521\"  text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\" column=\"doclastmoditime\"/>"+
					   "</head>"+
					   "</table>";      
  %>
<wea:layout>
	<%String attrs = "{'groupDisplay':'none'}"; %>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>' attributes="<%=attrs %>">
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>
</wea:layout>
<script>
function openhrm(id){
  parent.openhrm(id);
try{
  var mainsupport = parent.document.getElementById("mainsupports");
}catch(e){if(window.console)console.log(e);}
}
function pointerXY(event){
  parent.pointerXY(event);
}
</script>


