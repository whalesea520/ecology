
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.cowork.CoworkLabelVO"%>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<%
int userid=user.getUID();
String layout=Util.null2String(request.getParameter("layout"));
String jointype=Util.null2String(request.getParameter("jointype"));
String type=Util.null2String(request.getParameter("type"));
String typeid=Util.null2String(request.getParameter("typeid"));
String mainid=Util.null2String(request.getParameter("mainid"));
String name=Util.null2String(request.getParameter("name"));
String coworkid = Util.null2String(request.getParameter("coworkid"));
String showtree = Util.null2String(request.getParameter("showtree"),"0");
//读取协作布局cookie
Cookie cookies[]=request.getCookies();
String coworkLayout="1";
for(int i=0;i<cookies.length;i++){
	if(cookies[i].getName().equals("coworkLayout")){
		coworkLayout=cookies[i].getValue();
	    break;
	}	
}
layout=layout.equals("")?coworkLayout:layout;
%>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/cowork/js/coworkUtil_wev8.js"></script>
<link type="text/css" href="/cowork/css/coworkNew_wev8.css" rel=stylesheet>
</head>
<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<%if(showtree.equals("1")){ %>
							<li class="e8_tree">
								<a><%=SystemEnv.getHtmlLabelName(83222,user.getLanguage())%></a>
							</li>
						<%} %>
						<li class="current">
							<a href="javascript:void(0)" onclick="refreshCoworkList('all','allTab')" target="tabcontentframe" layout="<%=layout%>" id = 'allTab' type='all' labelid=''><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>
						</li>
						<%
						List labelList=CoworkItemMarkOperation.getLabelList(userid+"","all");          //标签列表
						for(int i=0;i<labelList.size();i++){ 
							
			                 CoworkLabelVO labelVO=(CoworkLabelVO)labelList.get(i);
			                 String isUsed=labelVO.getIsUsed();
			                 if(isUsed.equals("0")) continue;
			                 String id=labelVO.getId();
			                 String labelType=labelVO.getLabelType();
			                 String labelName=labelVO.getName();
			                 if(labelName.equals("17694"))  continue;//过滤掉协作区标签
			                 
			                 if(labelType.equals("label")){
			              	   labelName=labelVO.getName();
			                 }else if(labelType.equals("typePlate")){
			                	   labelName = CoTypeComInfo.getCoTypename(labelVO.getName());
			                 }else{
			              	   labelName=SystemEnv.getHtmlLabelName(Util.getIntValue(labelVO.getName()),user.getLanguage());
			                 }
			                 
			            %>
			            <li>
							<a href="javascript:void(0)" onclick="refreshCoworkList('<%=labelType%>','<%=id%>')" target="tabcontentframe" type='<%=labelType%>' labelid='<%=id%>' title='<%=labelName%>'><%=labelName%></a>
						</li>
			            <%} %>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe onload="update()" src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" style="overflow:hidden;"></iframe>
		</div>	
	</div>
</body>
<script>
  var layout="<%=layout%>";
  var jointype="<%=jointype%>";
  var typeid="<%=typeid%>";
  var mainid = "<%=mainid%>";
  window.notExecute = true;
  var menuUrl="/cowork/CoworkMain.jsp?jointype="+jointype+"&layout="+layout+"&name=<%=URLEncoder.encode(name,"utf-8")%>";
  
  $(document).ready(function(){
	    $('.e8_box').Tabs({
			getLine : 1,
			iframe : "tabcontentframe",
			mouldID:"<%= MouldIDConst.getID("collaboration")%>",
       		staticOnLoad:true,
       		objName:"<%=jointype.equals("5")?SystemEnv.getHtmlLabelName(32574,user.getLanguage()):SystemEnv.getHtmlLabelName(32571,user.getLanguage())%>"
		});
		
		jQuery("#tabcontentframe").attr("src","/cowork/CoworkMain.jsp?layout=<%=layout%>&mainid=<%=mainid%>&typeid=<%=typeid%>&type=all&jointype=<%=jointype%>&labelid=&name=<%=URLEncoder.encode(name,"utf-8")%>&coworkid=<%=coworkid %>");
		
		attachUrl();
		
		jQuery("#e8_tablogo").bind("click",function(){
    		parent.refreshTree2();
    	});
    	
    	//保存设置的布局
    	addCookie("coworkLayout","<%=layout%>",365*24*60*60*1000);
  });
   
function refreshCoworkList(type,labelid){
	$("#tabcontentframe").contents().find("#listFrame").attr("src","/cowork/CoworkList.jsp?from=cowork&type="+type+"&labelid="+labelid+"&layout="+layout+"&jointype="+jointype+"&mainid="+mainid+"&typeid="+typeid);
}

function attachUrl(){
	$("a[target='tabcontentframe']").each(function(){
		var type=$(this).attr("type");
		var labelid=$(this).attr("labelid");
		//$(this).attr("href","javascript:void(0)").attr("onclick","refreshCoworkList('"+type+"','"+labelid+"')");
	});
}

var diag=null;
function addCowork(){
    var title="<%=SystemEnv.getHtmlLabelName(27411,user.getLanguage()) %>";
	diag=getCoworkDialog(title,720,520);
	diag.URL = "/cowork/AddCoWork.jsp?from=cowork";
	diag.show();
	document.body.click();
} 

//新建协作类别
function addCoworkType(){
    var title="<%=SystemEnv.getHtmlLabelName(83198,user.getLanguage()) %>";
    diag=getCoworkDialog(title,720,520);
    diag.URL = "/cowork/type/CoworkMainType.jsp?";
    diag.show();
    document.body.click();
}

//新建协作板块
function addmaintype(){
    var title="<%=SystemEnv.getHtmlLabelName(129747,user.getLanguage()) %>";
    diag=getCoworkDialog(title,720,520);
    diag.URL = "/cowork/type/CoworkType.jsp?";
    diag.show();
    document.body.click();
}


function addCoworkCallback(id){
	diag.close();
	$("#tabcontentframe").contents().find("#ifmCoworkItemContent").attr("src","/cowork/ViewCoWork.jsp?from=cowork&id="+id)
	$("#tabcontentframe")[0].contentWindow.reLoadCoworkList();
}

function labelManageCallback(){
	diag.close();
	window.location.reload();
}

function labelManage(){
	
    var title="<%=SystemEnv.getHtmlLabelName(30884,user.getLanguage()) %>";
	diag=getCoworkDialog(title,680,600);
	diag.URL = "/cowork/labelSetting.jsp";
	diag.show();
	
	//$(diag.okButton).hide();
	
	document.body.click();
}

//添加cookie
function addCookie(objName,objValue,objHours){//添加cookie
	var str = objName + "=" + escape(objValue);
	if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
		var date = new Date();
		date.setTime(date.getTime() + objHours);
		str += "; expires=" + date.toGMTString();
	}
	document.cookie = str;
}

</script>
</html>

