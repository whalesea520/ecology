<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
  *{float:none;}
  #container{float: none;}
  .tab-request{position: relative;float: none;padding-bottom: 20px;padding-top: 20px;}
  .tab-request-first{position: relative;float: none;padding-bottom: 20px;}
  .tab-line{padding-left:10px;padding-right: 10px;}
  .tab-line hr {height:1px;}
  .page-break {page-break-after: always;}
  .pholder {
	display:none;
  }
  html, body, a, span, p,table,td {
	color:#000!important;
  }
</style>

<%--打印的时候，一些元素不打印 --%>
<style type="text/css" media="print">
  .tab-line{display: none;}
  .tab-request{padding-bottom: 0px;padding-top: 0px;}
  .tab-request-first{padding-bottom: 0px;}
</style>
</head>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%!
	private int getModeid(String workflowid,String nodeid){
		String sql = " select id from workflow_nodehtmllayout "
				   + " where isactive=1 and workflowid = " + workflowid + " and nodeid = " + nodeid + " and type = '1'";
		RecordSet rs = new RecordSet();
		int modeid = -1;
		rs.executeSql(sql);
		if(rs.next()){
			modeid = rs.getInt("id");
		}
		return modeid;
	}
%>

<%
BaseBean bb_printmode = new BaseBean();
int urm_printmode = 1;
try{
	urm_printmode = Util.getIntValue(bb_printmode.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(20756,user.getLanguage())+",javascript:doPrintSet(),_top}" ;
//RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:doPrint(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY id="flowbody" style="overflow:auto">
<div id="container">
<%
String multirequestid = Util.null2String(request.getParameter("multirequestid"));
if("".equals("multirequestid")){
%>
	<script language=javascript>
	alert("<%=SystemEnv.getHtmlLabelName(26427,user.getLanguage())%>");
	window.close();
	</script>
<%
	return;
}
%>
<%
	List<String> reqList = new ArrayList<String>();
	multirequestid = multirequestid + "0";
	String sql = "select requestid,workflowid from workflow_requestbase where requestid in (" + multirequestid + ")";
	recordSet.executeSql(sql);
	int userid = user.getUID();
	int logintype = Util.getIntValue(user.getLogintype(),1);
	
	//本来在MultiPrintGroups.jsp中已判断过modeid的，此处再做判断会有一些性能上的影响，
	//但是为了防止此时刚好有人修改了打印模板的设置，因此做了该判断
	while(recordSet.next()){
		String workflowid = recordSet.getString("workflowid");
		int reqid = recordSet.getInt("requestid");
		int nodeid = WFLinkInfo.getCurrentNodeid(reqid,userid,logintype);    //当前人员最后操作的节点
		int modeid = getModeid(workflowid,nodeid+"");
		if(modeid > 0){
			reqList.add(reqid + "");
		}
	}
	
	if(reqList.size() < 1){
%>
	<script language=javascript>
	alert("<%=SystemEnv.getHtmlLabelName(84014,user.getLanguage())%>");
	window.close();
	</script>
	<%
	}
	%>
	<%
	for(int i = 0; i < reqList.size(); i++){
		String reqid = reqList.get(i);
		String className = "tab-request";
		if(i == 0){
			className = "tab-request-first";
		}
	%>
	<div class="<%=className%>" id="req_<%=reqid%>" <%if(i != (reqList.size() -1)){ %> style="page-break-after: always;" <%} %>>
	<iframe id="requestiframe<%=reqid%>" name="requestiframe<%=reqid%>" width="100%" scrolling="no" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0" style="overflow-x:visible;overflow-y:visible;" src="/workflow/request/PrintRequest.jsp?requestid=<%=reqid%>&isprint=1&fromFlowDoc=1&ismultiprintmode=1"></iframe>
	</div>
	<%
	if(i != (reqList.size() -1)){
	%>
	<div class="tab-line" style="display: none;"><hr/></div>
	<%	
	}
	%>
	<%}%>
</div>
</body>

<script language="javascript">
var reqCount = <%=reqList.size()%>;  //请求的数量
var orgCount = <%=reqList.size()%>;   //请求数量的备份
var firstReqid = <%=reqList.get(0)%>;  //第一个请求的id

jQuery(document).ready(function(){
	showPrompt("<%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%>");
});


function doPrint(){
	hideRightClickMenu();  //隐藏右键菜单
	window.print();
}

//加载结束，隐藏加载的提示信息
function loadOver(){
	jQuery("#message_table_Div").css("display","none");
	jQuery("div.tab-line").css("display","");
}

//加载的提示信息
function showPrompt(content){
     var showTableDiv  = document.getElementById('container');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     pTop = Math.max(pTop,300);
 	 var pLeft= document.body.offsetWidth/2-50;
 	jQuery(message_table_Div).css("position", "absolute").css("top", pTop).css("left", pLeft);
     message_table_Div.style.zIndex=1002;
}

//调整签字意见中图片大小的方法
function image_resize(_this,ifrmID) {
	var innerWidth = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
	var imgWidth = $(_this).width();
	var imgHeight = $(_this).height();
	var iframeWidth = 0;
	if(jQuery("iframe[name^=FCKsigniframe]").size() >0)
		iframeWidth = (jQuery("iframe[name^=FCKsigniframe]").width())*0.6;
	else{
		//iframeWidth = ($(_this).closest("td[name='signContentTd']").width()*0.8)*0.6;
		iframeWidth = window.innerWidth * 0.25;
	}
	if (imgWidth >= iframeWidth) {
		var variable = imgWidth/iframeWidth;
		var variableWidth = imgWidth/variable;
		var variableHeight = imgHeight/variable;
		if(variableHeight >= 250){
			var coefficient = variableHeight/250;
			var coefficientWidth = variableWidth/coefficient;
			var coefficientHeight = variableHeight/coefficient;
			jQuery(_this).width(coefficientWidth);
			jQuery(_this).height(coefficientHeight);
			jQuery(_this).closest(".small_pic").width(coefficientWidth);
			jQuery(_this).closest(".small_pic").height(coefficientHeight);
		}else{
			jQuery(_this).width(variableWidth);
			jQuery(_this).height(variableHeight);
			jQuery(_this).closest(".small_pic").width(variableWidth);
			jQuery(_this).closest(".small_pic").height(variableHeight);
			//jQuery(_this).width(iframeWidth);
			//jQuery(_this).removeAttr("height");
			//jQuery(_this).css("height", "");
			//jQuery(_this).closest(".small_pic").width(iframeWidth);
		}
	}else{
		if(imgHeight >= 250){
			var coefficient = imgHeight/250;
			var coefficientWidth = imgWidth/coefficient;
			var coefficientHeight = imgHeight/coefficient;
			jQuery(_this).width(coefficientWidth);
			jQuery(_this).height(coefficientHeight);
			jQuery(_this).closest(".small_pic").width(coefficientWidth);
			jQuery(_this).closest(".small_pic").height(coefficientHeight);
		}else{
			jQuery(_this).width(imgWidth);
			jQuery(_this).height(imgHeight);
			jQuery(_this).closest(".small_pic").width(imgWidth);
			jQuery(_this).closest(".small_pic").height(imgHeight);
		}
	}
	if(!!document.getElementById(ifrmID))
		ifrResize(document.getElementById(ifrmID).contentWindow.document,ifrmID,1);
	//jQuery(_this).parent().style.cursor = 'url(images/right.ico),auto;'
}

</script>
</html>