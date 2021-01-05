
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
    String id = (String)request.getParameter("id");
    int currentpage =Util.getIntValue((String)request.getParameter("currentpage"),1);
    String from = Util.null2String(request.getParameter("from"));
    
	String tableString = "";
	int perpage=10;                                 
	String backfields = " id,modifydate,modifytime,modifier,coworkid,type,clientip";
	String fromSql  = "cowork_log" ;
	String sqlWhere = "coworkid="+id;
	String orderby = " modifydate desc,modifytime desc ";
	
	tableString = " <table pagesize=\""+perpage+"\" tabletype=\"none\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" />"+
	              " <head>"+
	              "	<col width='45%' text=\""+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\" column=\"modifydate\" otherpara='column:modifytime' transmethod=\"weaver.general.CoworkTransMethod.getCoworkLogDatetime\"/>"+
	              "	<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" orderkey=\"modifier\" column=\"modifier\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
				  " <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" orderkey=\"type\" column=\"type\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkLogType\"/>"+
         		  "	<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(110,user.getLanguage())+"\" orderkey=\"clientip\" column=\"clientip\" />";	 
	 tableString+="	</head></table>";
	
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
   $(document).ready(function(){
      
   });
   
</script>  

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31704,user.getLanguage())%>"/>
</jsp:include>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

