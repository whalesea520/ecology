
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String srcdeal = Util.null2String(request.getParameter("srcdeal"));
	String srcfile = Util.null2String(request.getParameter("srcfile"));
%>
<HTML><HEAD>
	<script type="text/javascript">
		var dialog;
		var parentWin;
		jQuery(document).ready(function(){
			dialog = window.top.getDialog(window);
		});
		
		function setLinkDesc()
		{
			var linkjson = {srcdeal:$("#srcdeal").val(),srcfile:$("#srcfile").val()};
			dialog.close(linkjson);
		}
		
	</script>
</HEAD>
 	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<BODY>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("30615,81973", user.getLanguage())%>'/>
	</jsp:include>     	
	<div class="zDialog_div_content" id="zDialog_div_content" style="overflow:hidden;">   	
	<wea:layout type="twoCol">
			    <wea:group context="<%=SystemEnv.getHtmlLabelName(81973, user.getLanguage())%>">
			    	<wea:item><%=SystemEnv.getHtmlLabelName(129000, user.getLanguage())%></wea:item>
			    	<wea:item><select id="srcdeal" name="srcdeal">
			    		<option value="1" <%="1".equals(srcdeal) ? "selected" : "" %>>http://</option>
			    		<option value="2" <%="2".equals(srcdeal) ? "selected" : "" %>>https://</option>
			    		<option value="3" <%="3".equals(srcdeal) ? "selected" : "" %>>ftp://</option>
			    		<option value="4" <%="4".equals(srcdeal) ? "selected" : "" %>>news://</option>
			    	</select></wea:item>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(128048, user.getLanguage())%></wea:item>
			    	<wea:item><input type="text" id="srcfile" name="srcfile" value="<%=srcfile %>"></input></wea:item>
			    </wea:group>
			</wea:layout>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>			    		
      </div>
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="setLinkDesc()">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
   <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
