
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>

<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.safety.*" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="docManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="spopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String detailid = Util.null2String((String)request.getParameter("detailid"));
String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String title = Util.null2String((String)request.getParameter("title"));
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
String requestid = Util.null2String((String)request.getParameter("requestid"));
String fromWF = Util.null2String((String)request.getParameter("fromWF"));
int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

char flag=Util.getSeparator() ;

int userid=user.getUID();
String logintype = user.getLogintype();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String userSeclevel = user.getSeclevel();
String userSeclevelCheck = userSeclevel;
if("2".equals(logintype)){
	userdepartment="0";
	usersubcomany="0";
	userSeclevel="0";
}

docManager.resetParameter();
docManager.setId(Util.getIntValue(detailid));
docManager.getDocInfoById();

//文档信息
int maincategory=docManager.getMaincategory();
int subcategory=docManager.getSubcategory();
int seccategory=docManager.getSeccategory();
String docsubject=docManager.getDocsubject();
String doccontent=docManager.getDoccontent();
String docpublishtype=docManager.getDocpublishtype();
String docstatus=docManager.getDocstatus();
int ishistory = docManager.getIsHistory();
String usertype=docManager.getUsertype();

//子目录信息
recordSet.executeProc("Doc_SecCategory_SelectByID",seccategory+"");
recordSet.next();
String readerCanViewHistoryEdition=Util.null2String(recordSet.getString("readerCanViewHistoryEdition"));

String userInfo=logintype+"_"+userid+"_"+userSeclevelCheck+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
List PdocList = spopForDoc.getDocOpratePopedom(""+detailid,userInfo);

//0:查看  
boolean canReader = false;
//1:编辑
boolean canEdit = false;
//2:删除
boolean canDel = false;
//3:共享
boolean canShare = false ;
//4:日志
boolean canViewLog = false;
//5:可以回复
boolean canReplay = false;
//6:打印
boolean canPrint = false;
//7:发布
boolean canPublish = false;
//8:失效
boolean canInvalidate = false;
//9:归档
boolean canArchive = false;
//10:作废
boolean canCancel = false;
//11:重新打开
boolean canReopen = false;
//签出
boolean canCheckOut = false;
//签入
boolean canCheckIn = false;
//强制签入
boolean canCheckInCompellably =false ;
//新建工作流
boolean cannewworkflow = true;
//TD12005不可下载
boolean canDownloadFromShare = false;

if (((String)PdocList.get(0)).equals("true")) canReader = true ;
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(2)).equals("true")) canDel = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if (((String)PdocList.get(4)).equals("true")) canViewLog = true ;
if (((String)PdocList.get(5)).equals("true")) canDownloadFromShare = true ;//TD12005

if(canReader && ((!docstatus.equals("7")&&!docstatus.equals("8")) 
                  ||(docstatus.equals("7")&&ishistory==1&&readerCanViewHistoryEdition.equals("1"))
				  )){
    canReader = true;
}else{
    canReader = false;
}

//是否可以查看历史版本
//具有编辑权限的用户，始终可见文档的历史版本；
//可以设置具有只读权限的操作人是否可见历史版本；

if(ishistory==1) {
	//if(SecCategoryComInfo.isReaderCanViewHistoryEdition(seccategory)){
	if(readerCanViewHistoryEdition.equals("1")){
    	if(canReader && !canEdit) canReader = true;
	} else {
	    if(canReader && !canEdit) canReader = false;
	}
}	

//编辑权限操作者可查看文档状态为：“审批”、“归档”、“待发布”或历史文档
if(canEdit && ((docstatus.equals("3") || docstatus.equals("5") || docstatus.equals("6") || docstatus.equals("7")) || ishistory==1)) {
	//canEdit = false;
    canReader = true;
}

//if(!canReader) {
//	out.println("no right!");
//	return;
//}

if(docpublishtype.equals("2")){
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
}

doccontent = Util.replace(doccontent, "&amp;", "&", 0);
String docsubject_tmp = "";
docsubject_tmp = docManager.getDocsubject();
docsubject_tmp = docsubject_tmp.replaceAll("&lt;", "<");
docsubject_tmp = docsubject_tmp.replaceAll("&gt;", ">");
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
	#header {
		width:100%;
		background: -moz-linear-gradient(top, white, #ECECEC);
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#ececec');
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#ECECEC));
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		filter: alpha(opacity=70);
		-moz-opacity: 0.70;
		opacity: 0.70;
		position:relative;
	}
	#title {
		font-size:16pt;
		font-weight:bold;
		color:#000;
		padding:10px 10px 6px 10px;
		overflow:hidden;
	}
	#subhead {
		padding-left:10px;
		margin-bottom:6px;
		font-size:9pt;
		color:#000;
		overflow:hidden;
	}
	#content {
		font-family: Arial, Verdana, sans-serif;
	}
	#content table{
	border-collapse:collapse;
	}
	#content table td{
	border:1px solid #DDD;
	}
	</style>
	<script type="text/javascript">
	function doLeftButton() {
		location = '/mobile/plugin/2/view.jsp?detailid=<%=detailid%>&module=<%=module%>&scope=<%=scope%>&fromWF=<%=fromWF%>&requestid=<%=requestid%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>';
		return "0";
	}
	function doBack() {
		doLeftButton();
	}
	</script>
</head>
<body>

<div id="view_page" style="height:auto;min-height:100%;background-color:#FFFFFF;position:absolute;top:0px;">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;"><%=docsubject_tmp %></div>
		
	</div>

	<div id="content" style="background-color:#FFFFFF;">
	
		<% if(doccontent!=null&&doccontent.length()>0) { %>
	
		<div>
		<%=doccontent %>
		</div>
		
		<% } %>
		
	</div>

</div>
</body>
</html>