<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.SubWorkflowTriggerService" %>
<%@page import="weaver.workflow.request.RequestShare"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>


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

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="WFLinkInfo_nf" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<jsp:useBean id="WorkflowBillComInfo" class="weaver.workflow.workflow.WorkflowBillComInfo" scope="page"/>

<%
String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);
int userlanguage=Util.getIntValue(request.getParameter("languageid"),7);
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;
                     
String newfromdate="a";
String newenddate="b";
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急
String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是
int creater=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否
int billid=0 ;              //如果是单据,对应的单据表的id
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
int workflowid=0;           //工作流id
String workflowtype = "" ;  //工作流种类
int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
int nodeid=0;               //节点id
String nodetype="";         //节点类型  0:创建 1:审批 2:实现 3:归档
String workflowname = "" ;          //工作流名称
String isreopen="";                 //是否可以重打开
String isreject="";                 //是否可以退回
int isremark = -1 ;              //当前操作状态  modify by xhheng @ 20041217 for TD 1291
int handleforwardid = -1;     //转办状态
int takisremark = -1;     //意见征询状态
String status = "" ;     //当前的操作类型
String needcheck="requestname,";

String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面
topage = URLEncoder.encode(topage);
String isaffirmance=Util.null2String(request.getParameter("isaffirmance"));//是否需要提交确认
String reEdit=Util.null2String(request.getParameter("reEdit"));//是否为编辑
// 工作流新建文档的处理
String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
String isrejectremind="";
String ischangrejectnode="";
String isselectrejectnode="";
// 董平 2004-12-2 FOR TD1421  新建流程时如果点击表单上的文档新建按钮，在新建完文档之后，能返回流程，但是文档却没有挂带进来。
String newdocid = Util.null2String(request.getParameter("newdocid"));        // 新建的文档

// 操作的用户信息
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";
String currentnodetype = "";
int currentnodeid = 0;

int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String sql = "" ;
char flag = Util.getSeparator() ;
String fromPDA= Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){
	status  = Util.null2String(RecordSet.getString("status")) ;
    requestname= Util.null2String(RecordSet.getString("requestname")) ;
	requestlevel = Util.null2String(RecordSet.getString("requestlevel"));
    requestmark = Util.null2String(RecordSet.getString("requestmark")) ;
    creater = Util.getIntValue(RecordSet.getString("creater"),0);
	creatertype = Util.getIntValue(RecordSet.getString("creatertype"),0);
    deleted = Util.getIntValue(RecordSet.getString("deleted"),0);
	workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
	currentnodeid = Util.getIntValue(RecordSet.getString("currentnodeid"),0);
    if(nodeid<1) nodeid = currentnodeid;
	currentnodetype = Util.null2String(RecordSet.getString("currentnodetype"));
    if(nodetype.equals("")) nodetype = currentnodetype;
    
}else{%>
	<script>
	alert('<%=SystemEnv.getHtmlLabelName(84497,user.getLanguage())%>'+'[<%=requestid%>]'+'<%=SystemEnv.getHtmlLabelName(23084,user.getLanguage())%>');
	//location.href = '/workflow/request/EditFormIframe.jsp?requestid=<%=requestid%>';
	window.opener=null;
	window.open('', '_self', ''); 
	window.close();
	</script>
<%}

RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");
if(RecordSet.next()){
	formid = Util.getIntValue(RecordSet.getString("formid"),0);
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
	workflowname = Util.null2String(RecordSet.getString("workflowname"));
	workflowtype = Util.null2String(RecordSet.getString("workflowtype"));
}

if ("1".equals(isbill)) {
	String billtablename = WorkflowBillComInfo.getTablename(formid+"");          // 获得单据的主表
	rs.execute("select id from " + billtablename + " where requestid = " + requestid);
	rs.next();
	billid = rs.getInt(1);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
	               
String needfav ="1";
String needhelp ="";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
 
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>    
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<title><%=requestname%></title>

<script language="javascript">


function windowOnload(){
	displayAllmenu();
}


/**
  解决表单序列化中文编码
  (jquery默认序列化采用的是encodeuricompent方法,转码成utf8,所以我们先反转,然后escape编码)
**/
function serialize(objs)

{

    var parmString = jQuery(objs).serialize();

    var parmArray = parmString.split("&");

    var parmStringNew="";

    jQuery.each(parmArray,function(index,data){

        var li_pos = data.indexOf("=");

        if(li_pos >0){

            var name = data.substring(0,li_pos);

            var value = escape(decodeURIComponent(data.substr(li_pos+1)));

            var parm = name+"="+value;

            parmStringNew = parmStringNew=="" ? parm : parmStringNew + '&' + parm;

        }

    });

    return parmStringNew;

}



/** end by cyril on 008-07-01 for TD:8835*/

function doLocationHref(resourceid){
    //获取相关文档-相关流程-相关附件参数
    //var signdocids=$G("signdocids").value;
    //var signworkflowids=$G("signworkflowids").value;
    //附件上传参数
    //var param = "&annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + $G("field-annexupload").value + "&field_annexupload_del_id=" + $G("field_annexupload_del_id").value;
    //获取参数end
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	var remarklag = "";

   // var oEditor = CKEDITOR.instances['remark'];

	//alert(oEditor.getData());

	if($G("workflowRequestLogId")!=null){
		workflowRequestLogId=$G("workflowRequestLogId").value;
	}
	try{
		CkeditorExt.updateContent('remark');

		var params=serialize("#formitem");


		//附件上传
                        StartUploadAll();
                        checkfileuploadcomplet();
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		 //frmmain.target = "_blank";
		 //frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
         //document.frmmain.submit();
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid + "&requestname=<%=requestname %>");
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&requestname=<%=requestname %>");

	}catch(e){
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl = "/workflow/request/Remark.jsp?requestid="+id+"&signworkflowids="+signworkflowids+param+"&workflowRequestLogId="+workflowRequestLogId;
		openFullWindowHaveBar(forwardurl);
	}
}

function doLocationHref(resourceid,forwardflag){
    //获取相关文档-相关流程-相关附件参数
    //var signdocids=$G("signdocids").value;
    //var signworkflowids=$G("signworkflowids").value;
    //附件上传参数
    //var param = "&annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + $G("field-annexupload").value + "&field_annexupload_del_id=" + $G("field_annexupload_del_id").value;
    //获取参数end
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	//var remarklag = flag;

   // var oEditor = CKEDITOR.instances['remark'];

	//alert(oEditor.getData());

	if($G("workflowRequestLogId")!=null){
		workflowRequestLogId=$G("workflowRequestLogId").value;
	}
	try{
		CkeditorExt.updateContent('remark');

		var params=serialize("#formitem");


		//附件上传
                        StartUploadAll();
                        checkfileuploadcomplet();
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		 //frmmain.target = "_blank";
		 //frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
         //document.frmmain.submit();
		if(forwardflag==2){
		if(resourceid)
		openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&requestname=<%=requestname %>");
		else
        openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&requestname=<%=requestname %>");
		}else if (forwardflag==3)
		{
			if(resourceid)
		openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&requestname=<%=requestname %>");
		else
        openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&requestname=<%=requestname %>");
		}else{
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&requestname=<%=requestname %>");
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&requestname=<%=requestname %>");
		}
	}catch(e){
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl = "/workflow/request/Remark.jsp?requestid="+id+ "&forwardflag="+ forwardflag +"&signworkflowids="+signworkflowids+param+"&workflowRequestLogId="+workflowRequestLogId;
		openFullWindowHaveBar(forwardurl);
	}
}

function doLocationHrefnoback(resourceid,forwardflag){
    //获取相关文档-相关流程-相关附件参数
    //var signdocids=$G("signdocids").value;
    //var signworkflowids=$G("signworkflowids").value;
    //附件上传参数
    //var param = "&annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + $G("field-annexupload").value + "&field_annexupload_del_id=" + $G("field_annexupload_del_id").value;
    //获取参数end
	var id = <%=requestid%>;
	var workflowRequestLogId=0;
	//var remarklag = flag;

   // var oEditor = CKEDITOR.instances['remark'];

	//alert(oEditor.getData());

	if($G("workflowRequestLogId")!=null){
		workflowRequestLogId=$G("workflowRequestLogId").value;
	}
	try{
		CkeditorExt.updateContent('remark');

		var params=serialize("#formitem");


		//附件上传
                        StartUploadAll();
                        checkfileuploadcomplet();
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		 //frmmain.target = "_blank";
		 //frmmain.action = "/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId;
         //document.frmmain.submit();
		if(forwardflag==2){
		if(resourceid)
		openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag+"&needwfback=0&requestname=<%=requestname %>");
		else
        openDialog2("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		}else if (forwardflag==3)
		{
			if(resourceid)
		openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		else
        openDialog3("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		}else{
		if(resourceid)
		openDialog("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params+"&resourceids="+resourceid +"&forwardflag="+forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		else
        openDialog("<%=requestname%>","/workflow/request/Remark.jsp?requestid="+id+"&workflowRequestLogId="+workflowRequestLogId+"&"+params + "&forwardflag=" + forwardflag + "&needwfback=0&requestname=<%=requestname %>");
		}
	}catch(e){
		var remark="";
		try{
			remark = CkeditorExt.getHtml("remark");
		}catch(e){}
		var forwardurl = "/workflow/request/Remark.jsp?requestid="+id+ "&forwardflag="+ forwardflag +"&needwfback=0&signworkflowids="+signworkflowids+param+"&workflowRequestLogId="+workflowRequestLogId;
		openFullWindowHaveBar(forwardurl);
	}
}





var isfirst = 0 ;

function downloads(files)
{ jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
$G("fileDownload").src="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1&requestid=<%=requestid%>&fromrequest=1";
}
function downloadsBatch(fieldvalue,requestid)
{ 
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
$G("fileDownload").src="/weaver/weaver.file.FileDownload?fieldvalue="+fieldvalue+"&download=1&downloadBatch=1&fromrequest=1&requestid="+requestid;
}
function opendoc(showid,versionid,docImagefileid)
{jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
}
function opendoc1(showid)
{
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&isrequest=1&requestid=<%=requestid%>&isOpenFirstAss=1");
}
<%-----------xwj for td3131 20051115 begin -----%>
//主表中金额转换字段调用
function numberToFormat(index){
    if($G("field_lable"+index).value != ""){
        var floatNum = floatFormat($G("field_lable"+index).value);
        var val = numberChangeToChinese(floatNum)
        if(val == ""){
            alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
            $G("field"+index).value = "";
            $G("field_lable"+index).value = "";
            $G("field_chinglish"+index).value = "";
        } else {
            $G("field"+index).value = floatNum;
            $G("field_lable"+index).value = milfloatFormat(floatNum);
            $G("field_chinglish"+index).value = val;
        }
    }else{
        $G("field"+index).value = "";
        $G("field_chinglish"+index).value = "";
    }
}
function FormatToNumber(index){
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
    if($G("field_lable"+index).value != ""){
        $G("field_lable"+index).value = $G("field"+index).value;
    }else{
        $G("field"+index).value = "";
        $G("field_chinglish"+index).value = "";
    }
	setLocation(elm,n);
}
<%-----------xwj for td3131 20051115 end -----%>

//明细表中金额转换字段调用
function numberToChinese(index){
    if($G("field_lable"+index).value != ""){
        var floatNum = floatFormat($G("field_lable"+index).value);
        var val = numberChangeToChinese(floatNum);
        if(val == ""){
            alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
            $G("field_lable"+index).value = "";
            $G("field"+index).value = "";
        }else{
            $G("field_lable"+index).value = val;
            $G("field"+index).value = floatNum;
        }
    } else {
        $G("field"+index).value = "";
    }
}
function ChineseToNumber(index){
if($G("field_lable"+index).value != ""){
$G("field_lable"+index).value = chineseChangeToNumber($G("field_lable"+index).value);
$G("field"+index).value = $G("field_lable"+index).value;
}
else{
$G("field"+index).value = "";
}
}
</SCRIPT>

<BODY id="flowbody" ><%--Modified by xwj for td3247 20051201--%>
<%@ include file="RequestTopTitle.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82821,user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave()">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<iframe id="fileDownload" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="triSubwfIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<TABLE width="100%">
	<tr>
	<td valign="top">

<form name="frmmain" id="frmmain" method="post" action="EditFormOperation.jsp" <%if (!fromPDA.equals("1")) {%> enctype="multipart/form-data" <%}%>>
<input type="hidden" id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=userid %>">
<input type="hidden" id="f_weaver_belongto_usertype" name="f_weaver_belongto_usertype" value="<%=usertype %>">

<jsp:include page="EditFormBodyAction.jsp" flush="true">
	<jsp:param name="userid" value="<%=userid%>" />
    <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
    <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="requestlevel" value="<%=requestlevel%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="deleted" value="<%=deleted%>" />
    <jsp:param name="billid" value="<%=billid%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="isreopen" value="<%=isreopen%>" />
    <jsp:param name="isreject" value="<%=isreject%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
	<jsp:param name="topage" value="<%=topage%>" />
	<jsp:param name="newenddate" value="<%=newenddate%>" />
	<jsp:param name="newfromdate" value="<%=newfromdate%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
	<jsp:param name="newdocid" value="<%=newdocid%>" />
</jsp:include>

<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载
boolean  hasdetailb=false;
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}
if(hasdetailb){
	if(isbill.equals("0")){
%>
    <jsp:include page="EditFormDetailBodyAction.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="creater" value="<%=creater%>" />
    <jsp:param name="creatertype" value="<%=creatertype%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="isaffirmance" value="<%=isaffirmance%>" />
    <jsp:param name="reEdit" value="<%=reEdit%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    </jsp:include>
<% } else{%>
	<jsp:include page="EditFormDetailBodyActionBill.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="workflowid" value="<%=workflowid%>" />
    <jsp:param name="workflowtype" value="<%=workflowtype%>" />
    <jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="nodetype" value="<%=nodetype%>" />
    <jsp:param name="newdocid" value="<%=newdocid%>" />
    <jsp:param name="isremark" value="<%=isremark%>" />
	<jsp:param name="currentdate" value="<%=currentdate%>" />
	<jsp:param name="currenttime" value="<%=currenttime%>" />
	<jsp:param name="docfileid" value="<%=docfileid%>" />
    <jsp:param name="needcheck" value="<%=needcheck%>" />
    <jsp:param name="isaffirmance" value="<%=isaffirmance%>" />
    <jsp:param name="reEdit" value="<%=reEdit%>" />
	<jsp:param name="isbill" value="<%=isbill%>" />
    </jsp:include>
<%}}%>
	
	<%
		int submit=Util.getIntValue(Util.null2String(request.getParameter("submit")), 0);
		int forward=Util.getIntValue(Util.null2String(request.getParameter("forward")), 0);
	%>
    <%--@ include file="WorkflowManageSign.jsp" --%>
    
	<input type="hidden" name="needwfback"  id="needwfback" value="1"/>

	<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
	<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
	<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
    
</form>
<%
//add by ben for relationgrequests 2006-05-09
int haslinkworkflow=Util.getIntValue(String.valueOf(session.getAttribute("haslinkworkflow")),0);
if(haslinkworkflow==1){
    session.setAttribute("desrequestid",""+requestid);
}else{
    if(haslinkworkflow==0){
        session.removeAttribute("desrequestid");
        int linkwfnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")),0);
        for(int i=0;i<=linkwfnum;i++){
            session.removeAttribute("resrequestid"+i);
        }
        session.removeAttribute("slinkwfnum");
    }
}

//添加临时授权信息
if(haslinkworkflow == 1){
    RequestShare.addRequestViewRightInfo(request);
}
%>




</td>
		</tr>
		</TABLE>

		<!-- 点击打印按钮 存在打印模板时使用以此隐藏打印时的主窗口 -->
		<iframe style="display: none;visibility: hidden;" id="loadprintmodeFrame" src="">
		</iframe>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">

function changecancleon(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}


function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

function changebuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#8d8d8d");
	}
}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function changebuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#aaaaaa");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;");
}

function showProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;display:block;float:right;");
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;display:none;float:right;");
}

if (window.addEventListener){
    window.addEventListener("load", windowOnload, false);
}else if (window.attachEvent){
    window.attachEvent("onload", windowOnload);
}else{
    window.onload=windowOnload;
}

//qc 66179 by yl
var ffff  =    <%=formid%>;
var ffffIsbill  =    <%=isbill%>;
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
        return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
                return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                        return false;
                    else
                        return true;
                }
                else
                    return true;
            }
        }
        else
            return true;
    }
}
function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
    if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
    {
        YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
        MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
        DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
        YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
        MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
        DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
        if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            window.alert("<%=SystemEnv.getHtmlLabelName(15273,userlanguage)%>");
            return false;
        }
    }
    else{
        if( ffff == 181 && ffffIsbill==1){
            <%
            RecordSet rsss = new RecordSet();
            String fromdateid ="";
            String sql11="Select id from workflow_billfield where billid= 181 and fieldname='fromDate' ";
            rsss.executeSql(sql11);
            if(rsss.next()){
               fromdateid=rsss.getString("id");
            }
            String todateid="";
            String sql22="Select id from workflow_billfield where billid= 181 and fieldname='toDate' ";
            rsss.executeSql(sql22);
            if(rsss.next()){
               todateid=rsss.getString("id");
            }            
            String fromtimeid ="";
            String sql33="Select id from workflow_billfield where billid= 181 and fieldname='fromTime' ";
            rsss.executeSql(sql33);
            if(rsss.next()){
               fromtimeid=rsss.getString("id");
            }  
            String totimeid ="";
            String sql44="Select id from workflow_billfield where billid= 181 and fieldname='toTime' ";
            rsss.executeSql(sql44);
            if(rsss.next()){
               totimeid=rsss.getString("id");
            } 
            
                    String dbType =   rsss.getDBType();
                    String fromdate =  "field"+fromdateid;
                    String todate     = "field"+todateid;
                    String fromtime   = "field"+fromtimeid;
                    String totime     = "field"+totimeid;             
                 

            %>
            YearFrom=document.frmmain.<%=fromdate%>.value.substring(0,4);
            MonthFrom=document.frmmain.<%=fromdate%>.value.substring(5,7);
            DayFrom=document.frmmain.<%=fromdate%>.value.substring(8,10);
            YearTo=document.frmmain.<%=todate%>.value.substring(0,4);
            MonthTo=document.frmmain.<%=todate%>.value.substring(5,7);
            DayTo=document.frmmain.<%=todate%>.value.substring(8,10);
            HourFrom=document.frmmain.<%=fromtime%>.value.substring(0,2);
            MinFrom = document.frmmain.<%=fromtime%>.value.substring(3,5);
            HourTo=document.frmmain.<%=totime%>.value.substring(0,2);
            MinTo = document.frmmain.<%=totime%>.value.substring(3,5);
            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
                window.alert("<%=SystemEnv.getHtmlLabelName(17362,userlanguage)%>!!!!");
                return false;
            }else{
                if(document.frmmain.<%=fromdate%>.value==document.frmmain.<%=todate%>.value){
                    if (!DateCompare(YearFrom, HourFrom, MinFrom,YearTo, HourTo,MinTo )){
                        window.alert("<%=SystemEnv.getHtmlLabelName(15273,userlanguage)%>!!!!!");
                        return false;
                    }else{
                        if(HourFrom==HourTo && MinFrom == MinTo){
                            window.alert("<%=SystemEnv.getHtmlLabelName(24981,userlanguage)%>"  +"<%=SystemEnv.getHtmlLabelName(26315,userlanguage)%>"+"<%=SystemEnv.getHtmlLabelName(17690,userlanguage)%>!!!!");
                            return false;
                        }
                    }
                }
            }
        }
    }
    return true;
}


function doImportDetail(){
    if(!checkDataChange()){
        if(confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")){
            //window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>",window);
            var dialog = new window.top.Dialog();
        	dialog.currentWindow = window;
        	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>";
        	var title = "<%=SystemEnv.getHtmlLabelName(26255,user.getLanguage())%>";
        	dialog.Width = 550;
        	dialog.Height = 550;
        	dialog.Title=title;
        	dialog.Drag = true;
        	dialog.maxiumnable = true;
        	dialog.URL = url;
        	dialog.show();
        }
    }else{
        //window.showModalDialog("/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>",window);
        var dialog = new window.top.Dialog();
    	dialog.currentWindow = window;
    	var url = "/workflow/workflow/BrowserMain.jsp?url=/workflow/request/RequestDetailImport.jsp?requestid=<%=requestid%>";
    	var title = "<%=SystemEnv.getHtmlLabelName(26255,user.getLanguage())%>";
    	dialog.Width = 700;
    	dialog.Height = 650;
    	dialog.Title=title;
    	dialog.Drag = true;
    	dialog.maxiumnable = true;
    	dialog.URL = url;
    	dialog.show();
    }
}


function changeTab()
{
   /*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_0").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_0").className="cycleTDCurrent";
  	*/
  	}
function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}


function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
function onNewRequest(wfid,requestid,agent){
	var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent+"&reqid="+requestid;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
function onNewSms(wfid, nodeid, reqid){
	var redirectUrl =  "/sms/SendRequestSms.jsp?workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid;
	var width = screen.availWidth/2;
	var height = screen.availHeight/2;
	var top = height/2;
	var left = width/2;
	var szFeatures = "top="+top+"," ;
	szFeatures +="left="+left+"," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
//微信提醒(QC:98106)
function onNewChats(wfid, nodeid,reqid){ 
	var redirectUrl =  "/systeminfo/BrowserMain.jsp?url=/wechat/sendWechat.jsp?workflowid="+wfid+"&nodeid="+nodeid+"&reqid="+reqid+"&actionid=dialog";
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32818,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 350;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = redirectUrl;
	dialog.show();
} 


function doRemark_nBack(obj){
	$G("needwfback").value = "1";
	getRemarkText_log();
	doRemark_n(obj);
}
function doRemark_nNoBack(obj){
	$G("needwfback").value = "0";
	getRemarkText_log();
	doRemark_n(obj);
}
function doAffirmanceBack(obj){
	$G("needwfback").value = "1";
	getRemarkText_log();
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	$G("needwfback").value = "0";
	getRemarkText_log();
	doAffirmance(obj);
}
function doSave_nNew(obj){
	getRemarkText_log();
	doSave_n(obj);
}
function doReject_New(){
	getRemarkText_log();
	doReject();
}
function doSubmit_Pre(obj){
	getRemarkText_log();
	doSubmit(obj);
}


function doSave(){
	StartUploadAll();
    checkuploadcomplet();
}




function getRemarkText_log(){
	try{
		var reamrkNoStyle = CkeditorExt.getText("remark");
		if(reamrkNoStyle == ""){
			$G("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = CkeditorExt.getTextNew("remark");
			$G("remarkText10404").value = remarkText;
		}
		for(var i=0; i<CkeditorExt.editorName.length; i++){
			var tmpname = CkeditorExt.editorName[i];
			try{
				if(tmpname == "remark"){
					continue;
				}
				$(tmpname).value = CkeditorExt.getText(tmpname);
			}catch(e){}
		}
	}catch(e){
	}


}

function returnTriSubwf(returnString){
	if(returnString==1){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22064,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>");
	}else {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22064,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");
	}
	location.reload();
}


function onChangeSharetypeNew(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051,user.getLanguage())%>"+names+"<%=SystemEnv.getHtmlLabelName(84051,user.getLanguage())%>", function(){
		/*fieldid=delid.substr(0,delid.indexOf("_"));
	    linknum=delid.substr(delid.lastIndexOf("_")+1);
		fieldidnum=fieldid+"_idnum_1";
		fieldidspan=fieldid+"span";
	    delfieldid=fieldid+"_id_"+linknum;
	    */
	    jQuery(obj).parent().parent().parent().parent().css("display","none");
		
	    /*var deleteid = jQuery("#"+fieldid).val();
		deleteid = deleteid.replace(showid,"");
		deleteid = deleteid.replace(",,",",");
		if(deleteid.indexOf(",") == 0){
			deleteid = deleteid.substr(1);
		}
		if (deleteid.lastIndexOf(",") == deleteid.length - 1) {
			deleteid = deleteid.substring(0, deleteid.length - 1);
		}
		jQuery("#"+fieldid).val(deleteid);
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
			if (ismand=="1"){
				var needcheck = jQuery("#needcheck").val();
				jQuery("#"+fieldid).val(needcheck+","+fieldid);
				jQuery("#needcheck").attr("viewtype","1");
			}	
		}*/
		
		////
		var fieldid=delid.substr(0,delid.indexOf("_"));
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
	    if($GetEle(delspan).style.visibility=='visible'){
	      $GetEle(delspan).style.visibility='hidden';
	      $GetEle(delid).value='0';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
	        var tempvalue=$GetEle(fieldid).value;
	          if(tempvalue==""){
	              tempvalue=$GetEle(delfieldid).value;
	          }else{
	              tempvalue+=","+$GetEle(delfieldid).value;
	          }
		     $GetEle(fieldid).value=tempvalue;
	    }else{
	      $GetEle(delspan).style.visibility='visible';
	      $GetEle(delid).value='1';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
	        var tempvalue=$GetEle(fieldid).value;
	        var tempdelvalue=","+$GetEle(delfieldid).value+",";
	          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
	          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
	          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
	          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
	          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
		     $GetEle(fieldid).value=tempvalue;
	    }
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    //alert("swfuploadid = "+swfuploadid);
			    var fieldidnew = "field"+swfuploadid;
			    var fieldidspannew = "field_"+swfuploadid+"span";
			    //alert("fieldidspannew = "+fieldidspannew);
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspannew).innerHTML="";
		        if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="（必填）";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspannew).innerHTML="";
		        }
		  	}else{
		  	 var swfuploadid=fieldid.replace("field","");
		  	 //alert("swfuploadid = "+swfuploadid);
		     var fieldidspannew = "field_"+swfuploadid+"span";
			 $GetEle(fieldidspannew).innerHTML="";
		  	}
		}else{//add by td78113
			var swfuploadid=fieldid.replace("field","");
		    var fieldidnew = "field"+swfuploadid;
		    var fieldidspannew = "field_"+swfuploadid+"span";
			if(jQuery("#"+fieldidnew).attr("viewtype")=="1"){
				if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="（必填）";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
		    
		  	displaySWFUploadError(fieldid);
		}
		
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
  }

</SCRIPT>
<!-- added by cyril on 20080605 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
<!-- end by cyril on 20080605 for td8828-->
<script language="JavaScript">
	if("<%=seeflowdoc%>"=="1"){
		if($G("rightMenu")!=null){
			$G("rightMenu").style.display="none";
		}
	}
</script>

<jsp:include page="/workflow/request/UserDefinedRequestBrowser.jsp" flush="true">
	<jsp:param name="workflowid" value="<%=workflowid%>" />
</jsp:include>