
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.docs.reply.BelongUtils" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.safety.*" %>
<%@ page import="weaver.mobile.webservices.common.HtmlUtil"%>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="docManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="docImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
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

String requestid = Util.null2String((String)request.getParameter("requestid"));
String fromWF = Util.null2String((String)request.getParameter("fromWF"));
int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);
//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
//标记是从任务管理模块进入start
String fromTask=Util.null2String((String)request.getParameter("fromTask"));
//标记是从任务管理模块进入end


String fromcowork = Util.null2String((String)request.getParameter("fromcowork"));
String coworkid = Util.null2String((String)request.getParameter("coworkid"));

String readnew = request.getParameter("_readnew_");

String ipaddress = Util.null2String((String)request.getParameter("ipaddress"));

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

user = BelongUtils.getBelongUser(user,detailid,request,response);
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

int doceditionid = docManager.getDocEditionId();
int ishistory = docManager.getIsHistory();

//TD.5434 提醒有新版本文档
if(doceditionid>-1&&ishistory==1){
    rs.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " order by id desc ");
    rs.next();
	int newDocId = Util.getIntValue(rs.getString("id"));
	if(newDocId!=Util.getIntValue(detailid)&&newDocId>0){
	%>
		<script language=javascript>
		if(confirm("<%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
			location = '/mobile/plugin/2/view.jsp?detailid='+<%=newDocId%>+'&module=<%=module%>&scope=<%=scope%>&fromWF=true&requestid=<%=requestid%>&fromRequestid=<%=fromRequestid%>';
		}
		</script> 
	<%
	}
}

//文档信息
int maincategory=docManager.getMaincategory();
int subcategory=docManager.getSubcategory();
int seccategory=docManager.getSeccategory();
String docsubject=docManager.getDocsubject();
String doccontent=docManager.getDoccontent();
String docpublishtype=docManager.getDocpublishtype();
String docstatus=docManager.getDocstatus();
ishistory = docManager.getIsHistory();
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

if(!canReader) {
	out.println("no right!");
	return;
}

if(docpublishtype.equals("2")){
	int tmppos = doccontent.indexOf("!@#$%^&*");
	if(tmppos!=-1) doccontent = doccontent.substring(tmppos+8,doccontent.length());
}

doccontent = Util.replace(doccontent, "&amp;", "&", 0);
doccontent = doccontent.replaceAll("\u3000", "#SBCnbsp;");//处理全角空格丢失问题

Whitelist user_content_filter = Whitelist.relaxed();

user_content_filter.addTags("embed","object","param","span","div");
user_content_filter.addAttributes(":all", "style", "class", "id", "name");
user_content_filter.addAttributes("object", "width", "height","classid","codebase");	
user_content_filter.addAttributes("param", "name", "value");
user_content_filter.addAttributes("embed", "src","quality","width","height","allowFullScreen","allowScriptAccess","flashvars","name","type","pluginspage");

String placeholderUri = "http://WeaverReservedURL";
//doccontent = Jsoup.clean(doccontent, placeholderUri, user_content_filter).replace(placeholderUri, "");
doccontent = doccontent.replace("#SBCnbsp;", "\u3000");//处理全角空格丢失问题

int doccreaterid=docManager.getDoccreaterid();


	if(userid != doccreaterid || !usertype.equals(logintype)) {
	    rs.executeProc("docReadTag_AddByUser",""+detailid+flag+userid+flag+logintype); 
	    docDetailLog.resetParameter();
	    docDetailLog.setDocId(Util.getIntValue(detailid));
	    docDetailLog.setDocSubject(docsubject);
	    docDetailLog.setOperateType("0");
	    docDetailLog.setOperateUserid(user.getUID());
	    docDetailLog.setUsertype(user.getLogintype());
	    docDetailLog.setClientAddress(ipaddress);
	    docDetailLog.setDocCreater(doccreaterid);
	    docDetailLog.setDocLogInfo();
	}


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
	<title><%=docsubject_tmp %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
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
	#content,#original {
		color:#3F3F3F;
		padding: 15px 8px 15px 8px;
		min-height: 200px;
		overflow:auto;
		font-family: Arial, Verdana, sans-serif;
	}
	#bottom {
		width:100%;
		top:0px;
	    bottom:0px;
		position:relative;
		padding:20px 0;
	}
	.browser_original_content {
		position:absolute; 
		bottom:5px; 
		right:10px;
		color:blue;
	}
	.attachment {
		background: -moz-linear-gradient(top, white, #ECECEC);
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#ececec');
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#ECECEC));
		background: -moz-linear-gradient(top, white, #ECECEC);
		-moz-border-radius: 8px;  
		-webkit-border-radius: 8px; 
		filter: alpha(opacity=70);
		-moz-opacity: 0.70;
		opacity: 0.70;
		border: 1px solid #999; 
		padding: 10px;
		margin: 5px 10px;
		position:relative;
	}
	.attachment .icon {
		width:24px;
	}
	.attachment .name {
		font-weight: bold;
		font-size:10pt;
	}
	.attachment .size {
		font-size:9pt;
		color:#777;
		text-align: right;
		width:33px;
	}
	
	.attachment .name span {
        display:inline-block;
        width:100%;
        word-break: break-all;
	}
	
	.attachment .flag {
		width:20px;
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
		var fromWF = "<%=fromWF%>";
		var fromES="<%=fromES%>";
		var fromcowork="<%=fromcowork%>";
		var fromTask = "<%=fromTask%>";
		if(fromWF == "true" || fromES=="true"||fromcowork=="true"||fromTask=="true") {
			doBack();
			return 1;
		}
	}
	function doBack() {
		var fromWF = "<%=fromWF%>";
		if(fromWF == "true"){
			location = '/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&module=<%=module%>&scope=<%=scope%>&fromRequestid=<%=fromRequestid%>';
			return 1;
		} else {
			var fromES="<%=fromES%>";
			var fromcowork="<%=fromcowork%>";
			var fromTask = "<%=fromTask%>";
			if(fromES=="true"){
				 location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
			}else if(fromcowork=="true"){
			     location = '/mobile/plugin/cowork/view.jsp?detailid=<%=coworkid%>&module=<%=module%>&scope=<%=scope%>';	
			}else if(fromTask=="true"){
				location = "/mobile/plugin/task/taskDetail.jsp?module=<%=module%>&scope=<%=scope%>";
			}else{
			//不能写成这种形式：history.go(-1)， 否则在文档模块中返回按钮功能不能正常导航。
			location = "/list.do?module=<%=module%>&scope=<%=scope%>";
			}
		}
	}
	//去new标记
	function reloadData () {
		var ajaxUrl = "/mobile/plugin/2/view.jsp?_readnew_=1&<%=request.getQueryString()%>";
		jQuery.ajax({
			type: "GET",
			url: ajaxUrl
		});
	}
	
	function img_resize(_this) {
		var innerWidth = window.innerWidth;
		var imgWidth = $(_this).width();
		if (imgWidth >= innerWidth) {
			$(_this).width("100%");
		}
	}
	</script>
</head>
<body>

<div id="view_page" style="height:auto;min-height:100%;background-color:#FFFFFF">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<a href="javascript:doBack();">
			<div style="position:absolute;left:5px;top:6px;width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
			<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
			</div>
		</a>
		<div id="view_title" style="position:absolute;left:65px;top:6px;right:65px;"><%=docsubject_tmp %></div>
		
	</div>
	<div style="background-color:#FFFFFF;padding:0px;height:100%">
	<div id="header">
		<div id="title"></div>
		<div id="subhead">
			<%=SystemEnv.getHtmlLabelName(84094,user.getLanguage())%>&nbsp;:&nbsp;<%=resourceComInfo.getLastname(docManager.getDoclastmoduserid()+"") %>&nbsp;,&nbsp;<%=docManager.getDoclastmoddate() %>&nbsp;<%=docManager.getDoclastmodtime() %><br/>
			<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>&nbsp;:&nbsp;<%=resourceComInfo.getLastname(docManager.getDoccreaterid()+"") %>&nbsp;,&nbsp;<%=docManager.getDoccreatedate() %>&nbsp;<%=docManager.getDoccreatetime() %><br/>
			<%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%>&nbsp;:&nbsp;<%=resourceComInfo.getLastname(docManager.getOwnerid()+"") %>
		</div>
		<a href="/mobile/plugin/2/content.jsp?module=<%=module%>&scope=<%=scope%>&detailid=<%=detailid%>&fromWF=<%=fromWF%>&requestid=<%=requestid%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>">
		<div class="browser_original_content"><%=SystemEnv.getHtmlLabelName(26075,user.getLanguage())%></div>
		</a>
		<div style="clear:both;"></div>
	</div>

	<div id="content">
		<% if(doccontent!=null&&doccontent.length()>0) { %>
		<%=HtmlUtil.translateMarkup(doccontent) %>
		<% } %>
	</div>

	<div id="bottom">
	
		<%
		int docImageId = 0;
		int docId = Util.getIntValue(detailid);
		
		rs.executeSql("select * from DocImageFile where docid="+docId+" and (isextfile <> '1' or isextfile is null) and docfiletype <> '1' order by versionId desc");
		if(rs.next()) {
	        String curimgid = rs.getString("imagefileid");
	        long docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(curimgid));
	        String docImagefilename = Util.null2String(rs.getString("imagefilename"));
	        
	        String docImagefileSizeStr = "";
	        if(docImagefileSize / (1024 * 1024) > 0) {
	        	docImagefileSizeStr = (docImagefileSize / 1024 / 1024) + "M";
	        } else if(docImagefileSize / 1024 > 0) {
	        	docImagefileSizeStr = (docImagefileSize / 1024) + "K";
	        } else {
	        	docImagefileSizeStr = docImagefileSize + "B";
	        }
	        
	        int idx = docImagefilename.length() - 200;
	        String urlfilename = (idx > 0) ? docImagefilename.substring(idx, docImagefilename.length()) : docImagefilename;
	        urlfilename = java.net.URLEncoder.encode(urlfilename,"UTF-8");
		%>
		<a href="/download.do?fileid=<%=curimgid%>&module=<%=module%>&scope=<%=scope%>&filename=<%=urlfilename%>">
			<div class="attachment">
				<table style="width:100%;table-layout:fixed;">
					<tr>
						<td class="icon"><img src="/images/down_wev8.png" width="24" height="24"></td>
						<td class="name"><span><%=docImagefilename%></span></td>
						<td class="size"><%=docImagefileSizeStr%></td>
						<td class="flag"><img src="/images/flag_wev8.gif" width="20" height="20"></td>
					</tr>
				</table>
			</div>
		</a>
		<% }
		
	    docImageManager.resetParameter();
	    docImageManager.setDocid(docId);
	    docImageManager.selectDocImageInfo();
	    while (docImageManager.next()) {
	        int temdiid = docImageManager.getId();
	        if (temdiid == docImageId) {
	            continue;
	        }
	        docImageId = temdiid;
	        String curimgid = docImageManager.getImagefileid();
	       
	        String curimgname = docImageManager.getImagefilename();
	        String docFileType = docImageManager.getDocfiletype();
	        long docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(curimgid));
	        String docImagefilename = Util.null2String(docImageManager.getImagefilename());
	       
	        int versionId = docImageManager.getVersionId();
	        
	        String docImagefileSizeStr = "";
	        if(docImagefileSize / (1024 * 1024) > 0) {
	        	docImagefileSizeStr = (docImagefileSize / 1024 / 1024) + "M";
	        } else if(docImagefileSize / 1024 > 0) {
	        	docImagefileSizeStr = (docImagefileSize / 1024) + "K";
	        } else {
	        	docImagefileSizeStr = docImagefileSize + "B";
	        }
	        
	        int idx = docImagefilename.length() - 200;
	        String urlfilename = (idx > 0) ? docImagefilename.substring(idx, docImagefilename.length()) : docImagefilename;
	        urlfilename = java.net.URLEncoder.encode(urlfilename,"UTF-8");
		%>
		<a href="/download.do?fileid=<%=curimgid%>&module=<%=module%>&scope=<%=scope%>&filename=<%=urlfilename%>">
			<div class="attachment">
				<table style="width:100%;table-layout:fixed;">
					<tr>
						<td class="icon"><img src="/images/down_wev8.png" width="24" height="24"></td>
						<td class="name"><span><%=docImagefilename%></span></td>
						<td class="size"><%=docImagefileSizeStr%></td>
						<td class="flag"><img src="/images/flag_wev8.gif" width="20" height="20"></td>
					</tr>
				</table>
			</div>
		</a>
		<% } %>
	
	</div>
	</div>
</div>

</body>
</html>