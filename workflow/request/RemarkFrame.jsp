
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.file.FileUpload" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ page import="weaver.workflow.workflow.WFOpinionInfo" %>
<%@ page import="weaver.workflow.request.RequestOpinionBrowserInfo" %>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="RequestOpinionFieldManager" class="weaver.workflow.request.RequestOpinionFieldManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/workflow/wfbrow_wev8.js"></script>
<script language=javascript>
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">



<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<!--添加插件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
<!-- word转html插件 -->
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>

<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/wui/common/js/ckeditor/skins/kama/editor1_wev8.css" />
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
%>
<%
String needcheck = "";

String requestid=Util.null2String(request.getParameter("requestid"));
int workflowRequestLogId = 0; // Util.getIntValue(request.getParameter("workflowRequestLogId"),0);

String remark = Util.null2String(request.getParameter("remark"));
String needwfback = Util.null2String(request.getParameter("needwfback"));
int forwardflag=Util.getIntValue(request.getParameter("forwardflag"));
if(forwardflag!=2 && forwardflag!=3){
forwardflag = 1;  // 2 征求意见；3 转办 ；1 转发
}
String signdocids = Util.null2String(request.getParameter("signdocids"));
String signworkflowids = Util.null2String(request.getParameter("signworkflowids"));
String field_annexupload = Util.null2String(request.getParameter("field-annexupload"));
String remarkLocation1 = Util.null2String(request.getParameter("remarkLocation"));


FileUpload fu = null;
if(Util.null2String(request.getContentType()).toLowerCase().startsWith("multipart/form-data")){
	fu = new FileUpload(request);
	if(fu != null){
		requestid = Util.null2String(fu.getParameter("requestid"));
		workflowRequestLogId = Util.getIntValue(fu.getParameter("workflowRequestLogId"),0);
		
		remark = Util.null2String(fu.getParameter("remark"));
		signdocids = Util.null2String(fu.getParameter("signdocids"));
		signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
		field_annexupload = Util.null2String(fu.getParameter("field-annexupload"));
		remarkLocation1 = Util.null2String(fu.getParameter("remarkLocation"));
		
	}
}
session.setAttribute("__remarkLocation",remarkLocation1);

String signdocname="";
String signworkflowname="";
ArrayList templist=Util.TokenizerString(signdocids,",");
for(int i=0;i<templist.size();i++){
    signdocname+="<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
}
templist=Util.TokenizerString(signworkflowids,",");
int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
for(int i=0;i<templist.size();i++){
    tempnum++;
    signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
}
session.setAttribute("slinkwfnum", "" + tempnum);
session.setAttribute("haslinkworkflow", "1");
        

//视图转发获取不到session处理
int wfid=0,currentnodeid=0;
if(session.getAttribute(userid+"_"+requestid+"workflowid")==null){
	RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
		RecordSet.execute("select * from workflow_currentoperator where requestid = "+requestid+" and userid = " + userid +" order by nodeid desc");
			if(RecordSet.next()){
			wfid=Util.getIntValue(RecordSet.getString("workflowid"),0);
		currentnodeid=Util.getIntValue(RecordSet.getString("nodeid"),0);
	
}		
}else{
	wfid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
	currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodeid"),0);
}
String workflowid = String.valueOf(wfid);
String nodeid = String.valueOf(currentnodeid);
String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
String IsFromWFRemark = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"IsFromWFRemark"));
//added end.

String needconfirm="";
String isSignMustInput="0";
String isHideInput="0";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String isannexupload_edit="";
String annexdocCategory_remark="";
RecordSet.execute("select needAffirmance,isSignDoc,isSignWorkflow,isannexupload,annexdocCategory from workflow_base where id="+wfid);
if(RecordSet.next()){
    needconfirm=Util.null2o(RecordSet.getString("needAffirmance"));
    isSignDoc_edit=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSet.getString("isSignWorkflow"));
    isannexupload_edit=Util.null2String(RecordSet.getString("isannexupload"));
    annexdocCategory_remark=Util.null2String(RecordSet.getString("annexdocCategory"));
}

String tempbeagenter2 = "" + userid;
//获得被代理人
RecordSet.executeSql("select agentorbyagentid, agenttype from workflow_currentoperator where usertype=0 and isremark in ('0', '1', '7', '8', '9')  and requestid=" + requestid + " and userid=" + userid+ " order by isremark, id");
if (RecordSet.next()) {
  int beagenter2 = RecordSet.getInt(1);
  int tempagenttype = RecordSet.getInt(2); 
  if (tempagenttype == 2 && beagenter2 > 0)
      tempbeagenter2 = "" + beagenter2;
}

String tempbeagentername2 = ResourceComInfo.getResourcename(tempbeagenter2);
String isFormSignature="";
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;

RecordSet.executeSql("select issignmustinput,ishideinput,isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+wfid+" and nodeId="+currentnodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(RecordSet.getString("ishideinput"), 0);
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
 	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}
ArrayList forwardrights=WFForwardManager.getUserForwardRights(Util.getIntValue(requestid),wfid,currentnodeid,userid,forwardflag); 
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+" - "+Util.toScreen(requestname,user.getLanguage());
String needfav ="1";
String needhelp ="";

String wfisbill="";
String wfformid="";

RecordSet.executeSql("select isbill,formid from workflow_base where id="+wfid);
if(RecordSet.next()){
	wfisbill = ""+Util.getIntValue(RecordSet.getString("isbill"), 0);
	wfformid = Util.null2String(RecordSet.getString("formid"));
}

int hasright=0;
char flag=Util.getSeparator() ;
int rowindex=0;
//权限判断
RecordSet.execute("select requestid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark in ('2','4','0','1','9','7', '8') ");
if(RecordSet.next())	hasright=1;
if(hasright==0){
	response.sendRedirect("/notice/noright.jsp");
   	return;
}
%>
<style>

  span.cke_skin_kama {
     -moz-border-radius: 0px;
     -webkit-border-radius: 0px;
      border-radius: 0px;
	 border: 1px solid #D3D3D3;
	 border-bottom: none;
	 border-top:none;
  }
  TABLE.ViewForm TD {
	padding: 0 0 0 0;
	BACKGROUND-COLOR: #F7F7F7;
  }
  
  #signinput {
	padding-left: 5px !important;
	padding-right: 5px !important;
}
.cke_toolbox {
 border-top:1px solid #cccccc;
}
#imagesing {
	margin-bottom: 0px!important;
}
</style>

<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>     

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
window.__isremarkPage = true;
</script>
</head>
<script>

function selectwfoperator() {
	if (!($("#selectNodeoptBlock").css("display") == 'block')) {
		$("#selectNodeoptBlock").show();
	} else {
		$("#selectNodeoptBlock").hide();
	}
}

$(function () {
	getAtItems();
});
	
var atitems = [];
//获取@的所有条目

function getAtItems() {
	var ajax = ajaxinit();
	ajax.open("POST", "WorkflowRequestPictureForJson.jsp", true);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	var parpstr = "requestid=" + <%=requestid %>+"&workflowid=" + <%=wfid %>+"&nodeid=" + <%=currentnodeid %>+"&isbill=" + <%=wfisbill %>+"&formid=" + <%=wfformid %>;
	ajax.send(parpstr);
	//获取执行状态

	ajax.onreadystatechange = function() {
		//如果执行状态成功，那么就把返回信息写到指定的层里

		if (ajax.readyState == 4 && ajax.status == 200) {
			try {
				var rs = jQuery.trim(ajax.responseText);
				atitems = eval('(' + rs + ')');
				//取得异步请求值后绑定事件
				$("#selectNodeoptBlock ol li a").click(function () {
					var rel = $(this).attr("rel");
					transtorbynode(rel, $("#onlyopt").is(":checked"));
					$("#selectNodeoptBlock").hide();
				});
				initItemData(atitems);
				
				window.__atdataready = true;
			    window.__atdata = atitems;
			} catch(e) {}
		}
	}
}



function wrapshowhtml(ahtml, id) {
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"addimg()\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	deleteimg();
	return str;
}

function deleteimg(){
	jQuery("#field5spanimg img").remove();
}

function addimg(){
    if(jQuery("#field5span").children().length==1){
		jQuery("#field5spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	}
}

Array.prototype.contains = function (element) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == element) {
            return true;
        }
    }
    return false;
}

function multipy2single(strtoken){
	var arr = strtoken.split(",");
	var array = [];
	for(var i = 0 ; i < arr.length; i++){
		var temp = arr[i];
		arr[i] = "";
		if(array.join(",").indexOf(temp) == -1){
		  array.push(temp);
		}
	}
	return array;
}

function transtorbynode(nodeid, isopt) {
	
	var allresArray = new Array();
	
	try {
		var allresstr = $("#field5").val();
		allresArray = allresstr.split(",");
	} catch (e) {}
	var transtounhanditemsids = "";
	var transtounhanditemsnames = "";
	var transtounhanditemsspanvalues = "";
	for (var i = 0; i < atitems.length; i++) {
		//非所有点时，只添加选择节点
		if (nodeid != '0' && nodeid != atitems[i].nodeid) {
			continue;
		}
		if (!!isopt && isopt == true) {
			//只包含已操作者

			if (atitems[i].handed != '1') {
				continue;
			}
		}
		if (isopt == false) {
			//只包含未操作者

			if (atitems[i].handed != '0') {
				continue;
			}
		}
			
			if (allresArray.contains(atitems[i].uid)) {
				continue;
			}
			
			if (i === (atitems.length - 1)) {
				transtounhanditemsids = transtounhanditemsids + atitems[i].uid;
				transtounhanditemsnames = transtounhanditemsnames + atitems[i].data;
			} else {
				transtounhanditemsids = transtounhanditemsids + atitems[i].uid + ",";
				transtounhanditemsnames = transtounhanditemsnames + atitems[i].data+",";
			}
	}
	if (transtounhanditemsids.lastIndexOf(",") == transtounhanditemsids.length - 1) {
		transtounhanditemsids = transtounhanditemsids.substring(0, transtounhanditemsids.length - 1);
	}
	var a_transtounhanditemsids = multipy2single(transtounhanditemsids);
	var a_transtounhanditemsnames = multipy2single(transtounhanditemsnames);

	for(var i =0;i<a_transtounhanditemsids.length;i++){
		var item_temp = a_transtounhanditemsids[i];
		var itemname_temp = a_transtounhanditemsnames[i];
		transtounhanditemsspanvalues = transtounhanditemsspanvalues + wrapshowhtml("<a style='COLOR:#000;' href='#" + item_temp + "' title='" + itemname_temp + "'>" + itemname_temp + "</a>", item_temp);
	}
	
	var data = {
		id: a_transtounhanditemsids.join(","),
		name: transtounhanditemsspanvalues
	};

	_writeBackData('field5', 1, data, {
		isSingle: false,
		hasInput: true,
		replace: false
	});
	hoverShowNameSpan(".e8_showNameClass");
	$(".e8_delClass").unbind("click").bind("click", function(e){
		del(e, this, 1, true);
	});
	// 客户自定义验证方法， 返回false则不向下执行
	// 方法名：__browVal4CustomCheck
	// 参数： wfid, reqid, type, ids, names
	try {
		var __cutomfnrtn  = __browVal4CustomCheck("field5",  <%=wfid %>, <%=requestid %>, 17, jQuery("#field5").val(), jQuery("#field5span").html());
		if (__cutomfnrtn == false) {
			return ;
		}
	} catch (_e852) {}
}
 //未操作者

function transToUnHandItems() {
	var transtounhanditemsids = "";
	var transtounhanditemsspanvalues = "";

	for (var i = 0; i < atitems.length; i++) {
		if (atitems[i].handed === '0') {
			if (i === (atitems.length - 1)) {
				transtounhanditemsids = transtounhanditemsids + atitems[i].uid;
				transtounhanditemsspanvalues = transtounhanditemsspanvalues + "<a href='#" + atitems[i].uid + "'>" + atitems[i].data + "</a>";
			} else {
				transtounhanditemsids = transtounhanditemsids + atitems[i].uid + ",";
				transtounhanditemsspanvalues = transtounhanditemsspanvalues + "<a href='#" + atitems[i].uid + "'>" + atitems[i].data + "</a>";
			}
		}
	}
	if (transtounhanditemsids.lastIndexOf(",") >= 0) {
		transtounhanditemsids = transtounhanditemsids.substring(0, transtounhanditemsids.length - 1);
	}

	var data = {
		id: transtounhanditemsids,
		name: transtounhanditemsspanvalues
	};
	_writeBackData('field5', 1, data, {
		isSingle: false,
		hasInput: true,
		replace: true
	});

}

//转发所有人
function transToAllItems() {
	var transtoallitemsids = "";
	var transtoallitemsspanvalues = "";
	for (var i = 0; i < atitems.length; i++) {
			if (i === (atitems.length - 1)) {
				transtoallitemsids = transtoallitemsids + atitems[i].uid;
				transtoallitemsspanvalues = transtoallitemsspanvalues + "<a href='#" + atitems[i].uid + "'>" + atitems[i].data + "</a>";
			} else {
				transtoallitemsids = transtoallitemsids + atitems[i].uid + ",";
				transtoallitemsspanvalues = transtoallitemsspanvalues + "<a href='#" + atitems[i].uid + "'>" + atitems[i].data + "</a>";
			}
	}
	if (transtoallitemsids.lastIndexOf(",") >= 0) {
		transtoallitemsids = transtoallitemsids.substring(0, transtoallitemsids.length - 1);
	}
	var data = {
		id: transtoallitemsids,
		name: transtoallitemsspanvalues
	};
	_writeBackData('field5', 1, data, {
		isSingle: false,
		hasInput: true,
		replace: true
	});
}

</script>
<body  style='overflow-x: hidden;'>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_top} " ;//xwj for td2104 on 20050802
RCMenuHeight += RCMenuHeightStep;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="RemarkOperate.jsp" enctype="multipart/form-data">
<%
	String para=requestid+flag+"1";
	RecordSet.executeProc("workflow_RequestRemark_Select",para);
	boolean islight=true;
	String resourceids=Util.null2String(request.getParameter("resourceids"));
	String resourcenames ="";
	
	if(!"".equals(resourceids))
	{
	
	   resourcenames=Util.toScreen(ResourceComInfo.getResourcename(resourceids),user.getLanguage());
	
	}
	String linkUrl ="/hrm/resource/HrmResource.jsp";
	String spanInnerHtml ="";
	
	
	boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+user.getUID()); 
		String workflowPhrases[] = new String[RecordSet.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
		int x = 0 ;
		if (isSuccess) {
			while (RecordSet.next()){
				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
				workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
				x ++ ;
			}
		}
		
		String myremark = remark;
		String annexdocids = field_annexupload;
		int annexmainId=0;
	         int annexsubId=0;
	         int annexsecId=0;
	         if("1".equals(isannexupload_edit) && annexdocCategory_remark!=null && !annexdocCategory_remark.equals("")){
	            annexmainId=Util.getIntValue(annexdocCategory_remark.substring(0,annexdocCategory_remark.indexOf(',')));
	            annexsubId=Util.getIntValue(annexdocCategory_remark.substring(annexdocCategory_remark.indexOf(',')+1,annexdocCategory_remark.lastIndexOf(',')));
	            annexsecId=Util.getIntValue(annexdocCategory_remark.substring(annexdocCategory_remark.lastIndexOf(',')+1));
	          }
	         int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
	         if(annexmaxUploadImageSize<=0){
	            annexmaxUploadImageSize = 5;
	         }
%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%if(2==forwardflag){%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("82578,33361",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></wea:item>
		<wea:item>
			<div>
			<brow:browser onPropertyChange="wfbrowvaluechange(this, 5);" 
				browserBtnSpanCls="browserBtnSpanCls" browserBtnClass="browserBtnClass"
				addBtnSpanCls="addBtnSpanCls" addBtnClass="addBtnClass"
				viewType="1" name="field5" browserValue='<%=resourceids%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" hasInput="true" width="500px" isSingle="false"  hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue='<%=resourcenames%>' hasAdd="true" addOnClick="showrescommongroup(this, 5)"> 
			</brow:browser>
			
			<div title="<%=SystemEnv.getHtmlLabelName(84509,user.getLanguage())%>" class="" id="u106" tabindex="0" style="cursor: pointer;">
				<div class="panel_state" id="u106_state0" style="width: 16px; height: 16px;">
					<button type="button" title="<%=SystemEnv.getHtmlLabelName(84509,user.getLanguage())%>" class="ax_pic ax" id="remarkShowBtn" onclick="showOrHideBtnOnClick();"></button>
				</div>
			</div>
			
			<span style="display:inline-block;width:10px;"></span>
			
			
			<%//调整位置请调整以下参数， 不要调整内部位置%>
			<div style="left: 320px;margin-top:-14.5px;;position: relative;">
			<jsp:include page="RemarkFrameItems.jsp"></jsp:include>
			</div>
			</div>
		</wea:item>
		
	</wea:group>
	
<%}else if(3==forwardflag){%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(84510,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("23745,15525",user.getLanguage())%></wea:item>
		<wea:item>
			<div>
			<brow:browser  onPropertyChange="wfbrowvaluechange(this, 5);"
				viewType="1" name="field5" browserValue='<%=resourceids%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=" hasInput="true" width="500px" isSingle="true"  hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue='<%=resourcenames%>' > 
				</brow:browser>
			
			<span style="display:inline-block;width:10px;"></span>
			
			
			<div style="left: 320px;margin-top:-14.5px;;position: relative;">
			<jsp:include page="RemarkFrameItems3.jsp"></jsp:include>
			</div>
			</div>
		</wea:item>
		
	
	</wea:group>
	
	
<%}else{%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("6011,87",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())+SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></wea:item>
		<wea:item>
			<div>
			<brow:browser onPropertyChange="wfbrowvaluechange(this, 5);remarkvaluechange(this);" 
				browserBtnSpanCls="browserBtnSpanCls" browserBtnClass="browserBtnClass"
				addBtnSpanCls="addBtnSpanCls" addBtnClass="addBtnClass"
				viewType="1" name="field5" browserValue='<%=resourceids%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" hasInput="true" width="500px" isSingle="false"  hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp"  browserSpanValue='<%=resourcenames%>' hasAdd="true" addOnClick="showrescommongroup(this, 5)"> 
			</brow:browser>
			
			<div title="<%=SystemEnv.getHtmlLabelName(84509,user.getLanguage())%>" class="" id="u106" tabindex="0" style="cursor: pointer;">
				<div class="panel_state" id="u106_state0" style="width: 16px; height: 16px;">
					<button type="button" title="<%=SystemEnv.getHtmlLabelName(84509,user.getLanguage())%>" class="ax_pic ax" id="remarkShowBtn" onclick="showOrHideBtnOnClick();"></button>
				</div>
			</div>
			
			<span style="display:inline-block;width:10px;"></span>
			
			<div style="left: 320px;margin-top:-14.5px;;position: relative;">
			<jsp:include page="RemarkFrameItems.jsp"></jsp:include>
			</div>
			</div>
		</wea:item>
		
	<%
	if(forwardrights.size()>0){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(81768,user.getLanguage())%></wea:item>
		<wea:item>
		<%
		boolean canCheck = false;
       	for(int i=0;i<forwardrights.size();i++){
            HashMap forwardmap = (HashMap)forwardrights.get(i);
            String showname="";
            String itemname="";
            String itemvalue="";
            if(forwardmap!=null){
                showname=(String)forwardmap.get("showname"+user.getLanguage());
                itemname=(String)forwardmap.get("itemname");
                itemvalue=(String)forwardmap.get("itemvalue");
			    if(( "IsBeForwardModify".equals(itemname) || "IsBeForwardSubmit".equals(itemname) ) && "1".equals(itemvalue))
               	    canCheck = true;
            }
    	%>
    		<div style="float:left;margin-right:10px;">
	  	    	<input type=checkbox name="<%=itemname%>" value="1" <%if("1".equals(itemvalue)){%>checked<%}%>><%=showname%>
	  		</div>
		<%
       	}
		%>
		</wea:item>
	<%
	}
	%>
	</wea:group>
<%}%>

<%
	if(isHideInput.equals("0")){
		String contextHtml = SystemEnv.getHtmlLabelName(17614,user.getLanguage());
		if(isSignMustInput.equals("1"))
			contextHtml += "<span style='color:red;margin-left:10px;font-weight:normal;'>"+SystemEnv.getHtmlLabelName(81909,user.getLanguage())+"</span>";
		if (!tempbeagenter2.equals(userid + "")) 
			contextHtml+="<span style='color:#d5d5d5;margin-left:10px;font-weight:normal;'>"+SystemEnv.getHtmlLabelName(84397,user.getLanguage())+tempbeagentername2+SystemEnv.getHtmlLabelName(84398,user.getLanguage())+"</span>";
		%>
		<wea:group context='<%=contextHtml%>'>
			<wea:item attributes="{'colspan':'full','isTableList':'true'}">
				<%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
			</wea:item>
		</wea:group>
	<%	
	}
	%>
</wea:layout>

<input type=hidden name="forwardflag" value=<%=forwardflag%>>
<input type=hidden name="operate">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowRequestLogId" value=<%=workflowRequestLogId%>>
<input type=hidden name="IsFromWFRemark" value=<%=IsFromWFRemark%>>
<input type=hidden name="needwfback"  value=<%=needwfback%>>


<script>
  
   
   
   function addOriginalValues()
   {
	 var resourceids="<%=resourceids%>";
     var resourcenames="<a href='#<%=resourceids%>'><%=resourcenames%></a>";
     var data={id:resourceids,name:resourcenames};
     _writeBackData('field5',1,data,{isSingle:false,hasInput:true,replace:true}); 
   
   
   }
</script>
       
	<%
	
	List labelNames = RequestOpinionFieldManager.getOpinionFieldNames(workflowid, nodeid);
	if(labelNames != null){
		for(int i=0; i<labelNames.size(); i++){
			WFOpinionInfo info = (WFOpinionInfo) labelNames.get(i);
			String type = info.getType_cn();
			int fieldid = info.getId();
			String fieldidstr = String.valueOf(fieldid);
    		RequestOpinionBrowserInfo browserInfo = RequestOpinionFieldManager.getBrowserInfo(type);
  %>
  <TR>
    <TD width="20%"> <%=info.getLabel_cn()%></TD>
    <td width="80%" class=field>
		<button type=button  class=Browser onclick="onShowBrowser2('<%=browserInfo.getFieldid()+fieldidstr%>','<%=browserInfo.getUrl()%>','<%=browserInfo.getLinkurl()%>','<%=browserInfo.getFieldtype()%>','<%=browserInfo.getIsMust()%>')" title="<%=info.getLabel_cn()%>" 
		onChange="checkinput('opinionbrowser','field<%=browserInfo.getFieldid()+fieldidstr%>span')"> </button>
		<input type=hidden id="opinionbrowser" name="field<%=browserInfo.getFieldid()+fieldidstr%>">
        <span id="field<%=browserInfo.getFieldid()+fieldidstr%>span">
        <%if(info.getIsMust() == 1){ 
        	needcheck+=",field"+browserInfo.getFieldid()+fieldidstr;
        %>
        <img src="/images/BacoError_wev8.gif" align=absmiddle>
		<%}%>
        </span>
	</td>
  </TR>  	   	
  <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
		<%}%>
	<%} %>




  <input type="hidden" name="totaldetail" value=0> 

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='padding:3px;width:100%' valign='top'>
</div>


<!--TD4262 增加提示信息  结束-->

<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</form>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>

<script type="text/javascript">

<%
String allnodesql = "select distinct t1.id,t1.nodename,t2.nodeorder from workflow_nodebase t1 inner join workflow_flownode t2 on t1.id=t2.nodeid inner join workflow_currentoperator t3 on t3.nodeid=t2.nodeid and t3.workflowid=t2.workflowid where t3.requestid="+requestid+" order by t2.nodeorder";
RecordSet.executeSql(allnodesql);
%>

jQuery(function() {

	var allNodes = [];
	var freeNodes = [];
	<%while (RecordSet.next()) {
		String tempnodeid = Util.null2String(RecordSet.getString("id"));
		String tempnodename = Util.null2String(RecordSet.getString("nodename"));
		String tempnodeorder = Util.null2String(RecordSet.getString("nodeorder"));
		if (tempnodeorder.isEmpty()) {
	%>
		freeNodes.push({'id':'<%=tempnodeid%>', 'name':'<%=tempnodename%>'});
	<%} else {%>
		allNodes.push({'id':'<%=tempnodeid%>', 'name':'<%=tempnodename%>'});
	<%}}%>
	initNodeData(allNodes);
	initNodeData(freeNodes);
});

//转发给所有人
jQuery(".transtoall").click(function(){
      var current=jQuery(this);
      var value=jQuery("#transtoallhidden").val();
      if(value==='0'){
          jQuery(".transtoall").attr("src","/images/ecology8/request/rcheck_wev8.png");
          jQuery(".transtohand").attr("src","/images/ecology8/request/runcheck_wev8.png");
		  jQuery("#transtohandhidden").val("0");
          jQuery("#transtoallhidden").val("1");
		  transToAllItems();
      }else if(value==='1'){ 
		  jQuery("#transtoallhidden").val("0");
		  jQuery(".transtoall").attr("src","/images/ecology8/request/runcheck_wev8.png");
          addOriginalValues();
	  }

});

//转发给未操作人

jQuery(".transtohand").click(function(){
      var current=jQuery(this);
      var value=jQuery("#transtohandhidden").val();
      if(value==='0'){
          jQuery(".transtohand").attr("src","/images/ecology8/request/rcheck_wev8.png");
          jQuery(".transtoall").attr("src","/images/ecology8/request/runcheck_wev8.png");
		  jQuery("#transtoallhidden").val("0");
          jQuery("#transtohandhidden").val("1");
		  transToUnHandItems();
      }else if(value==='1'){ 
		  jQuery("#transtohandhidden").val("0");
		  jQuery(".transtohand").attr("src","/images/ecology8/request/runcheck_wev8.png");
          addOriginalValues();
	  }

});



function onShowSignBrowserFormSignature(url, linkurl, inputname, spanname, type1) {
	var tmpids = $GetEle(inputname).value;
	if (type1 === 37) {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
				+ "?documentids=" + tmpids);
	} else {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
				+ "?resourceids=" + tmpids);
	}
	if (id1) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$GetEle(inputname).value = resourceids;
			
			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			
			
			for (var _i=0; _i<resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];
				
				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_blank'>" + curname + "</a>&nbsp";
			}
			$GetEle(spanname).innerHTML = sHtml;

		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}
function getResource(tdname,inputename) {
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
		    resourceids = rid.substr(1);
		    resourcename = rname.substr(1);
			$G(tdname).innerHTML = resourcename;
			$G(inputename).value = resourceids;
		} else {
			$G(tdname).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			$G(inputename).value = "";
		}
	}
}

function onShowBrowser(id, url, linkurl, type1, ismand) {
    if (type1 == 2 || type1 == 19) {
        id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
        $GetEle("field" + id + "span").innerHTML = id1;
        $GetEle("field" + id).value = id1
    } else {
        if (type1 != 17 && type1 != 18 && type1 != 27 && type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65 && type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169 && type1 != 170) {
            id1 = window.showModalDialog(url)
        } else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?selectedids=" + tmpids)
        } else {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?resourceids=" + tmpids)
        }
        if (id1) {
            if (type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37 || type1 == 56 || type1 == 57 || type1 == 65) {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
                    resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
                    
                    $GetEle("field" + id).value = resourceids;
                    sHtml = "";
                    var idArray = resourceids.split(",");
                    var nameArray = resourcename.split(",");
                    
                    for (var i=0; i<idArray.length; i++) {
                    	curid = idArray[i];
	                    curname = nameArray[i];
	                   
	                    if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
	                        sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp"
	                    } else {
	                        sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname + "</a>&nbsp"
	                    }
                    }
                   
                    $GetEle("field" + id + "span").innerHTML = sHtml;
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = "";
                }
            } else {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    if (linkurl == "") {
                        $GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1)
                    } else {
                        if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
                            $GetEle("field" + id + "span").innerHTML = "<a href=javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp"
                        } else {
                            $GetEle("field" + id + "span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + ">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>"
                        }
                    }
                    $GetEle("field" + id).value = wuiUtil.getJsonValueByIndex(id1, 0);
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = ""
                }
            }
        }
    }
}

function onShowBrowser2(id, url, linkurl, type1, ismand) {
    if (type1 == 2 || type1 == 19) {
        id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
        $GetEle("field" + id + "span").innerHTML = id1;
        $GetEle("field" + id).value = id1
    } else {
        if (type1 != 135 && type1 != 17 && type1 != 18 && type1 != 27 && type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65 && type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169 && type1 != 170) {
            id1 = window.showModalDialog(url)
        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?selectedids=" + tmpids)
        } else {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?resourceids=" + tmpids)
        }
        if (id1) {
            if (type1 == 135 || type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37 || type1 == 56 || type1 == 57 || type1 == 65) {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
                    resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
                    
                    $GetEle("field" + id).value = resourceids;
                    sHtml = "";
                    var idArray = resourceids.split(",");
                    var nameArray = resourcename.split(",");
                    
                    for (var i=0; i<idArray.length; i++) {
                    	curid = idArray[i];
	                    curname = nameArray[i];
	                   
	                    if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
	                        sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp"
	                    } else {
	                        sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname + "</a>&nbsp"
	                    }
                    }
                   
                    $GetEle("field" + id + "span").innerHTML = sHtml;
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = "";
                }
            } else {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    if (linkurl == "") {
                        $GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1)
                    } else {
                        if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
                            $GetEle("field" + id + "span").innerHTML = "<a href=javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp"
                        } else {
                            $GetEle("field" + id + "span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + ">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>"
                        }
                    }
                    $GetEle("field" + id).value = wuiUtil.getJsonValueByIndex(id1, 0);
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = ""
                }
            }
        }
    }
}

</script>

<script language=javascript>



var rowindex="<%=rowindex%>";
function addRow()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_resource' value="+rowindex+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
            	var sHtml = "<button type=button  class=browser onclick=getResource('resourcespan"+rowindex+"','resourceid"+rowindex+"')></button>&nbsp;"+
            		"<span id='resourcespan"+rowindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>"+
            		"<input type=hidden name='resourceid"+rowindex+"'>"; 
            	oDiv.innerHTML = sHtml;
            	oCell.appendChild(oDiv); 
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_resource')
			rowsum1 ++;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_resource'){
			if(document.forms[0].elements[i].checked==true)
				oTable1.deleteRow(rowsum1);	
			rowsum1--;
		}
	}
}

function doSave(obj){<%--xwj for td2104 on 2005-08-01--%>
	var forwardflag=<%=forwardflag%>
    var parastr = "" ;
	var len = document.forms[0].elements.length;
	var i=0;
	for(i=len-1; i >= 0;i--){
		if (document.forms[0].elements[i].name=='check_resource'){
			parastr+=",resourceid"+document.forms[0].elements[i].value;
		}
	}
    if(parastr.length>0){
		parastr=parastr.substring(1);
    }
    if(check_form(frmmain,parastr)){
		frmmain.totaldetail.value=rowindex;
		frmmain.operate.value="save";
		getRemarkText_log();
		var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
		if(ischeckok=="true"){
			if(!check_form(document.frmmain,'remarkText10404')){
				ischeckok="false";
			}
		}
<%
		}
	}
%>
		if(ischeckok=="true"){
			if(check_form(frmmain,'field5'+'<%=needcheck%>')){
				if ("<%=needconfirm%>"=="1"){
					if(forwardflag==1){
					if (!confirm("<%=SystemEnv.getHtmlLabelName(19992,user.getLanguage())%>")){
						return false;
					}
					}else if(forwardflag==2)
					{
						if (!confirm("<%=SystemEnv.getHtmlLabelName(129378, user.getLanguage())%>")){
						return false;
					}
					}else if(forwardflag==3)
					{
						if (!confirm("<%=SystemEnv.getHtmlLabelName(129379, user.getLanguage())%>")){
						return false;
					}
					}

				}				
<%
//保存签章数据
if("1".equals(isFormSignature)){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){
								    //TD4262 增加提示信息  开始

									if(forwardflag==1){
								    var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
									}
									if(forwardflag==2){
								    var content="<%=SystemEnv.getHtmlLabelName(82651,user.getLanguage())%>";
									}
									if(forwardflag==3){
								    var content="<%=SystemEnv.getHtmlLabelName(82652,user.getLanguage())%>";
									}
								    showPrompt(content);
								    //TD4262 增加提示信息  结束
								    obj.disabled=true;
									//附件上传
				                    StartUploadAll();
				                    checkuploadcomplet();
								}else{
									if(isDocEmpty==1){
										alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
										isDocEmpty=0;
									}else{
										alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
									}
									return ;
								}
					        }
					    }catch(e){
					        <%if(isHideInput.equals("1")){%>
					        		if(forwardflag==1){
								    var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
									}
									if(forwardflag==2){
								    var content="<%=SystemEnv.getHtmlLabelName(82651,user.getLanguage())%>";
									}
									if(forwardflag==3){
								    var content="<%=SystemEnv.getHtmlLabelName(82652,user.getLanguage())%>";
									}
								    showPrompt(content);
								    //TD4262 增加提示信息  结束
								    obj.disabled=true;
									//附件上传
				                    StartUploadAll();
				                    checkuploadcomplet();
					        <%}%> 
					    }
				
<%}else{%>
        //TD4262 增加提示信息  开始

        if(forwardflag==1){
								    var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
									}
									if(forwardflag==2){
								    var content="<%=SystemEnv.getHtmlLabelName(82651,user.getLanguage())%>";
									}
									if(forwardflag==3){
								    var content="<%=SystemEnv.getHtmlLabelName(82652,user.getLanguage())%>";
									}
        showPrompt(content);
        //TD4262 增加提示信息  结束
        obj.disabled=true;
        //附件上传
        StartUploadAll();
        checkuploadcomplet();
		
<%}%>
			}
		}

		//parent && parent.close();
	}
  


  
}
function getRemarkText_log(){
	try{
		CkeditorExt.updateContent();
		var remarkText = CkeditorExt.getText("remark");
		document.getElementById("remarkText10404").value = remarkText;
	}catch(e){}
}
function doBack(obj)
{
	obj.disabled=true;
	history.go(-1);
}

function CheckAll() {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='check_resource') 
            document.frmmain.elements[i].checked=true;
    } 
}
</script>

<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc'))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		deleteRow();
		}
}

//TD4262 增加提示信息  开始

//提示窗口
function showPrompt(content)
{

	var showTableDiv  = $GetEle('_xTable');
    var message_table_Div = document.createElement("div")
    message_table_Div.id="message_table_Div";
    message_table_Div.className="xTable_message";
    showTableDiv.appendChild(message_table_Div);
    var message_table_Div  = $GetEle("message_table_Div");
    message_table_Div.style.display="inline";
    message_table_Div.innerHTML=content;
    var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
    var pLeft= document.body.offsetWidth/2-50;
    message_table_Div.style.position="absolute"
    jQuery(message_table_Div).css("top", pTop);
    jQuery(message_table_Div).css("left", pLeft);

    message_table_Div.style.zIndex=1002;
    var oIframe = document.createElement('iframe');
    oIframe.id = 'HelpFrame';
    showTableDiv.appendChild(oIframe);
    oIframe.frameborder = 0;
    oIframe.style.position = 'absolute';
   
    jQuery(oIframe).css("top", pTop);
    jQuery(oIframe).css("left", pLeft);
    
    oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
    oIframe.style.width = parseInt(message_table_Div.offsetWidth);
    oIframe.style.height = parseInt(message_table_Div.offsetHeight);
    oIframe.style.display = 'block';
}

//TD4262 增加提示信息  结束

function onAddPhrase(phrase){            
	if(phrase!=null && phrase!=""){
		try{
			UE.getEditor("remark").setContent(phrase, true);
		}catch(e){}
		document.getElementById("remarkSpan").innerHTML = "";
	}
}
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=document.getElementById("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
		if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"||e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    document.getElementById(objName).outerHTML=outerHTML;
    document.getElementById(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  } 

 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";

    if($GetEle(delspan).style.visibility=='visible'){
      $GetEle(delspan).style.visibility='hidden';
      $GetEle(delid).value='0';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
    }else{
      $GetEle(delspan).style.visibility='visible';
      $GetEle(delid).value='1';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
    }
	if (ismand=="1")
	  {
	if ($GetEle(fieldidnum).value=="0")
	  {
	    $GetEle("needcheck").value=$GetEle("needcheck").value+","+fieldid;
		$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";

	  }
	  else
	  {   if ($GetEle("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     $GetEle("needcheck").value=$GetEle("needcheck").value.substr(0,$GetEle("needcheck").value.indexOf(","+fieldid));
		 $GetEle(fieldidspan).innerHTML="";
		  }
	  }
	  }
  }
</script>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">

			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="clostWin();">
	    </td></tr>
	</table>
</div>	


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td class="rightSearchSpan" style="text-align:right;" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(725,user.getLanguage()) %>" class="e8_btn_top" onclick="javascript:doSave(this)">			
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu">
			</span>
		</td>
	</tr>
</table>

<script>
function clostWin(){
	var pdialog = parent.parent.getDialog(window.parent);
	pdialog.close();
}

function changeclickbrow(event,datas,name,callbackParams){
	var field5 = "";
	jQuery("#field5").val();
	if(field5.equals("")){
		jQuery("#field5spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	}
}

function Map() {    
    var struct = function(key, value) {    
        this.key = key;    
        this.value = value;    
    }    
     
    var put = function(key, value){    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                this.arr[i].value = value;    
                return;    
            }    
        }    
        this.arr[this.arr.length] = new struct(key, value);    
    }    
         
    var get = function(key) {    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                return this.arr[i].value;    
            }    
        }    
        return null;    
    }    
         
    var remove = function(key) {    
        var v;    
        for (var i = 0; i < this.arr.length; i++) {    
            v = this.arr.pop();    
            if ( v.key === key ) {    
                continue;    
            }    
            this.arr.unshift(v);    
        }    
    }    
         
    var size = function() {    
        return this.arr.length;    
    }    
         
    var isEmpty = function() {    
        return this.arr.length <= 0;    
    }    
       
    this.arr = new Array();    
    this.get = get;    
    this.put = put;    
    this.remove = remove;    
    this.size = size;    
    this.isEmpty = isEmpty;    
}
jQuery("#field5__").bind("keydown",function(){
	jQuery("[id^=Consult]").hide();
});
jQuery("#field5__").bind("blur",function(){
	jQuery("[id^=Consult]").show();
});

jQuery(document).ready(function() {
	jQuery('#field5').attr('viewtype', 1);
	jQuery(".addBtnClass").attr("title", "<%=SystemEnv.getHtmlLabelName(84511,user.getLanguage())%>");
});

function remarkvaluechange(target) {
	// 客户自定义验证方法， 返回false则不向下执行
	try {
		var __cutomfnrtn  = __browVal4CustomCheck("field5",  <%=wfid %>, <%=requestid %>, 17, jQuery("#field5").val(), jQuery("#field5span").html());
		if (__cutomfnrtn == false) {
			return ;
		}
	} catch (_e852) {}
}
</script>
<jsp:include page="/workflow/request/WorkflowRemarkCustomPage.jsp" flush="true">
    <jsp:param name="workflowid" value="<%=workflowid%>" />
</jsp:include>
</body>
</html>
