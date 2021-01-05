
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util,weaver.matrix.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<html><head>
    <title>matrix design</title>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
    <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css">
	<link rel="stylesheet" href="../css/matrixpage_wev8.css">
</head>
<%
//矩阵id
String matrixid=request.getParameter("matrixid");
String fieldinfojson=MatrixUtil.getMatrixJsonById(matrixid);
String browserjson=MatrixUtil.getBrowserJsonObj();
%>
<body>
       <div>
	       <div style="padding: 2px;">
		     <input class='addrow' type="button" value="<%=SystemEnv.getHtmlLabelName(83946,user.getLanguage())%>" style="
					padding: 2px;
					width: 100px;
					border: 0;
					background: #5ccfeb;
					color: #ffffff;cursor:pointer;">

			<input class='savecurrent' type="button" value="<%=SystemEnv.getHtmlLabelName(30986 ,user.getLanguage())%>" style="
			padding: 2px;
			width: 100px;
			border: 0;
			background: #5ccfeb;
			color: #ffffff;cursor:pointer;">

			<input class='deleteitems' type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" style="
			padding: 2px;
			width: 100px;
			border: 0;
			background: #5ccfeb;
			color: #ffffff;cursor:pointer;">

		   </div>
	       <!--分页数据容器-->
			<div class='pagewrapper'>
			    <input  type='hidden'  name='matrixid' value='<%=matrixid%>'>
				<div>
					<table  class='pagetable'>
						<thead>
							 
						</thead>
						<tbody>
								
						</tbody>
					</table> 
                </div>
				<div class='searchitems'>
					  <div>
						 <span class='searchbrowser'>
						 
						 </span>
					  </div>
					  <div class='qseachbtn'>
						   <input type="button" class="zd_btn_cancle btn_submit" style="padding: 0px 18px 0px 18px;" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" >
					  </div>
	      	     </div>
			</div>
            
			<!--分页信息容器-->
			<div id="div_pager">

			</div>

        </div>

		
 
        <script src="../js/jquery_wev8.js"></script>
		<script src="../js/matrix_pageshow_wev8.js"></script>
        <script src="../js/matrixtable_wev8.js"></script>
        <script>
            //列信息(生成列头)  
            var fieldinfojson=<%=fieldinfojson%>;
            var browserjson=<%=browserjson%>;
            //生成矩阵表单
            matrixtable.initMatrixTable(fieldinfojson);
        </script>
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
        <script language=javascript src="../js/jquery.selectbox-0.2_wev8.js"></script>
        <script src="../js/uuid_wev8.js"></script>
       

    </body>
</html>
