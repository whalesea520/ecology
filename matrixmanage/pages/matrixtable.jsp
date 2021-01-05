
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util,weaver.matrix.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="MatrixManager" class="weaver.matrix.MatrixManager" scope="page" />
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

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33933,user.getLanguage());
//矩阵id
String matrixid=request.getParameter("matrixid");
String canedit=request.getParameter("canedit");
String issystem=request.getParameter("issystem");
String fieldinfojson=MatrixUtil.getMatrixJsonById(matrixid) ;
String browserjson=MatrixUtil.getBrowserJsonObj();
String isoutusermatrix = "0";
RecordSet.executeSql("SELECT name FROM MatrixInfo where id="+matrixid);
if(RecordSet.next()){
	if(RecordSet.getString("name").equals("外部用户")){
		isoutusermatrix="1";
	}
}


//矩阵维护权限
boolean canmaint = HrmUserVarify.checkUserRight("Matrix:Maint",user);

//判断是否矩阵维护者
String matrixids = MatrixManager.getUserPermissionMatrixids(user);
String matrixidStr[] = matrixids.split(",");
boolean isManager = false;  //是否矩阵维护者
	for(int i =0;i<matrixidStr.length;i++){
		if(matrixid.equals(matrixidStr[i])){
			isManager=true;
		}
	}
if(canmaint || isManager){
	canedit = "true";
}else{
	canedit = "false";
}


%>



<body style="overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 
 <%
 if("true".equals(canedit)){ 
	if("".equals(issystem)){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(21690,user.getLanguage())+",javascript:matrixtable.insertARow(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;   
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(16182,user.getLanguage())+",javascript:matrixtable.removeItems(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:matrixtable.saveTableData(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:openDialog(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportData()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
 }

%>
 
 <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 
 <table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important; ">
		    <%if("true".equals(canedit)){ %>
				<%if("".equals(issystem)){ %>
	   			<input type="button" value="<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="matrixtable.insertARow()">	
	   			<input type="button" value="<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="matrixtable.removeItems()">
	   			<%} %>		
	   			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="matrixtable.saveTableData()">
	   			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="os()">
	   			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="exportData()">
		      	<a id="exportData1" href='' style="color:blue;display: none;"></a>  					
			<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>  

       <div>
	       
	       <!--分页数据容器-->
			<div class='pagewrapper' style="margin-bottom: -10px;" title='<%=SystemEnv.getHtmlLabelName(83945,user.getLanguage())%>' >
			    <input  type='hidden'  name='matrixid' value='<%=matrixid%>'>
				<div style="border-bottom: 1px solid #eee;overflow:auto;" >
				   <div class='pagethead'>	
					<table  class='pagetable' >
							<thead>
								 
							</thead>
							<tbody>
									
							</tbody>
					  </table>
				   </div>
				  
				   <div class='pagetbody' style="margin-top:0;padding-bottom:12px;">	
					  <table  class='pagetable'>
							<thead>
								 
							</thead>
							<tbody>
									
							</tbody>
					  </table>
				   </div>

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
			<div class="div_descr" >
                <span>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(83989,user.getLanguage())%>  <%=SystemEnv.getHtmlLabelName("".equals(issystem)?84459:84614,user.getLanguage())%></span>
			</div>
            
			<!--分页信息容器-->
			<div id="div_pager">

			</div>
            <input type="text" id="autofocus" style="border:1px solid #fff;margin-left: -500px" />
        </div>

		
 
        <script src="../js/jquery_wev8.js"></script>
        <script src="../js/jquery-ui_wev8.js"></script>
		<script src="../js/matrix_pageshow_wev8.js"></script>
        <script src="../js/matrixtable_wev8.js"></script>
        <script>
        	//权限信息
        	var canedit='<%=canedit%>';
        	var issystem='<%=issystem%>';
        	var isoutusermatrix='<%=isoutusermatrix%>';
            //列信息(生成列头)  
            var fieldinfojson=<%=fieldinfojson%>;
            var browserjson=<%=browserjson%>;
            //生成矩阵表单
            matrixtable.initMatrixTable(fieldinfojson);
            
            function openDialog(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "";
				url = "/matrixmanage/pages/MatrixImport.jsp?matrixid=<%=matrixid%>&issystem=<%=issystem%>";
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(84015, user.getLanguage())%>";
				dialog.Width = 800;
				dialog.Height = 470;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
				
				return dialog;
			} 
			function os(){
			   var v = openDialog();
			}
			function exportData(){
				var	matrixUrl = "/matrixmanage/pages/MatrixExportToFile.jsp?method=exportDataNoSQ&matrixid=<%=matrixid%>";
				 $.ajax({
				     type: "post",
				     url: matrixUrl, 
				     async:false,
				     success: function(msg) {
				     	$("#exportData1").attr("href","/matrixmanage/pages/tmpfile/"+msg+".xls");
				     },
				     error: function() {
				     	alert("<%=SystemEnv.getHtmlLabelName(129278, user.getLanguage())%>");
				     }
				 });
				window.location.href = $("#exportData1").attr("href");				
			}
			
        </script>
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type="text/javascript" src="/js/ecology8/wTooltip/wTooltip_wev8.js"></script>
        <script type="text/javascript" src="/js/poshytip-1.2/jquery.poshytip_wev8.js"></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<script type='text/javascript' src="/js/nicescroll/jquery.nicescroll.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
        <script language=javascript src="../js/jquery.selectbox-0.2_wev8.js"></script>
        <script src="../js/uuid_wev8.js"></script>
       

    </body>
</html>
