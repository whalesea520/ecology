
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<style>
  table{border-collapse:collapse}
</style>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage()) %>"/>
</jsp:include>

<%
   String tempid=request.getParameter("tempid");
   String sql="select * from blog_template where id="+tempid;
   RecordSet recordSet=new RecordSet();
   recordSet.execute(sql);
   String tempContent="";
   if(recordSet.next())
      tempContent=recordSet.getString("tempContent");
   out.print(tempContent);
%>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  