
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>


<%
String url = Util.null2String(request.getParameter("url"));
//来自报表
String fromReport=Util.null2String(request.getParameter("fromReport"));
String fromReportformid=Util.null2String(request.getParameter("fromReportformid"));
//来自节点前
String fromNode=Util.null2String(request.getParameter("fromNode"));
String fromNodeFormid=Util.null2String(request.getParameter("fromNodeFormid"));
String fromNodeWfid=Util.null2String(Util.getIntValue(request.getParameter("fromNodeWfid")+"", 0)+"");

String fromReportisbill=Util.null2String(request.getParameter("fromReportisbill"));
String fromcapital = Util.null2String(request.getParameter("fromcapital"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
String cptstateid = Util.null2String(request.getParameter("cptstateid"));
String cptsptcount = Util.null2String(request.getParameter("cptsptcount"));
String isdata = Util.null2String(request.getParameter("isdata"));
String ProjID = Util.null2String(request.getParameter("ProjID"));
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String crmManager = Util.null2String(request.getParameter("crmManager"));
//add by zhouquan 菜单自定义后台管理的浏览框参数
String defaultLevel = Util.null2String(request.getParameter("defaultLevel"));
String menuId = Util.null2String(request.getParameter("menuId"));

//isedit如果为1则显示具有编辑权限以上的分部    
String isedit = Util.null2String(request.getParameter("isedit"));

//TD9734修改
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String notCompany = Util.null2String(request.getParameter("notCompany"));
String allselect = Util.null2String(request.getParameter("allselect"));
String rightStr = Util.null2String(request.getParameter("rightStr"));
//TD4957修改
String cptuse = Util.null2String(request.getParameter("cptuse"));

String subscribePara = Util.null2String(request.getParameter("subscribePara"));

String meetingtype = Util.null2String(request.getParameter("meetingtype"));
String meetingname = Util.null2String(request.getParameter("meetingname"));
String roomid = Util.null2String(request.getParameter("roomid"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String starttime = Util.null2String(request.getParameter("starttime"));
String endtime = Util.null2String(request.getParameter("endtime"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String deptlevel=Util.null2String(request.getParameter("deptlevel"));
String splitflag=Util.null2String(request.getParameter("splitflag"));

String workflowId=Util.null2String(request.getParameter("workflowId"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String nodelinkid=Util.null2String(request.getParameter("nodelinkid"));
String ispreoperator=Util.null2String(request.getParameter("ispreoperator"));
String actionid=Util.null2String(request.getParameter("actionid"));

String datasourceid = Util.null2String(request.getParameter("datasourceid"));
String needcheckds = Util.null2String(request.getParameter("needcheckds"));
String dmlformid = Util.null2String(request.getParameter("dmlformid"));
String dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
String dmltablename = Util.null2String(request.getParameter("dmltablename"));

String ajax=Util.null2String(request.getParameter("ajax"));
String wfid=Util.null2String(request.getParameter("wfid"));
String entryID=Util.null2String(request.getParameter("entryID"));

if("".equals(splitflag)) splitflag = ",";

boolean ishead = true;
if(url.indexOf("?")>0){
	ishead = false;
}
if(!fromcapital.equals("")){
	if(ishead){
		url+="?fromcapital="+fromcapital;
	}else{
		url+="&fromcapital="+fromcapital;
	}
	ishead = false;
}
if(!meetingid.equals("")){
	if(ishead){
		url+="?meetingid="+meetingid;
	}else{
		url+="&meetingid="+meetingid;
	}
	ishead = false;
}
if(!cptstateid.equals("")){
	if(ishead){
		url+="?stateid="+cptstateid;
	}else{
		url+="&stateid="+cptstateid;
	}
	ishead = false;
}
if(!cptsptcount.equals("")){
	if(ishead){
		url+="?sptcount="+cptsptcount;
	}else{
		url+="&sptcount="+cptsptcount;
	}
	ishead = false;
}
if(!isdata.equals("")){
	if(ishead){
		url+="?isdata="+isdata;
	}else{
		url+="&isdata="+isdata;
	}
	ishead = false;
}
if(!ProjID.equals("")){
	if(ishead){
		url+="?ProjID="+ProjID;
	}else{
		url+="&ProjID="+ProjID;
	}
	ishead = false;
}
if(!taskrecordid.equals("")){
	if(ishead){
		url+="?taskrecordid="+taskrecordid;
	}else{
		url+="&taskrecordid="+taskrecordid;
	}
	ishead = false;
}
if(!crmManager.equals("")){
	if(ishead){
    	url+="?crmManager="+crmManager;
	}else{
		url+="&crmManager="+crmManager;
	}
	ishead = false;
}
//add by zhouquan 菜单自定义后台管理的浏览框参数
if(!defaultLevel.equals("")){
	if(ishead){
		url+="?defaultLevel="+defaultLevel;
	}else{
		url+="&defaultLevel="+defaultLevel;
	}
	ishead = false;
}
if(!menuId.equals("")){
	if(ishead){
		url+="?menuId="+menuId;
	}else{
		url+="&menuId="+menuId;
	}
	ishead = false;
}
if(!isedit.equals("")){
	if(ishead){
		url+="?isedit="+isedit;
	}else{
		url+="&isedit="+isedit;
	}
	ishead = false;
}
if(!cptuse.equals("")){
	if(ishead){
		url+="?cptuse="+cptuse;
	}else{
		url+="&cptuse="+cptuse;
	}
	ishead = false;
}
if(!subscribePara.equals("")){
	if(ishead){
		url+="?subscribePara="+subscribePara;
	}else{
		url+="&subscribePara="+subscribePara;
	}
	ishead = false;
}
if(!subcompanyid.equals("")){
	if(ishead){
		url+="?subcompanyid="+subcompanyid;
	}else{
		url+="&subcompanyid="+subcompanyid;
	}
	ishead = false;
}
if(!notCompany.equals("")){
	if(ishead){
		url+="?notCompany="+notCompany;
	}else{
		url+="&notCompany="+notCompany;
	}
	ishead = false;
}
if(!allselect.equals("")){
	if(ishead){
		url+="?allselect="+allselect;
	}else{
		url+="&allselect="+allselect;
	}
	ishead = false;
}
if(!rightStr.equals("")){
	if(ishead){
		url+="?rightStr="+rightStr;
	}else{
		url+="&rightStr="+rightStr;
	}
	ishead = false;
}

if(!meetingtype.equals("")){
	if(ishead){
		url+="?meetingtype="+meetingtype;
	}else{
		url+="&meetingtype="+meetingtype;
	}
	ishead = false;
}
if(!meetingname.equals("")){
	if(ishead){
		url+="?meetingname="+meetingname;
	}else{
		url+="&meetingname="+meetingname;
	}
}
if(!roomid.equals("")){
	if(ishead){
		url+="?roomid="+roomid;
	}else{
		url+="&roomid="+roomid;
	}
	ishead = false;
}
if(!startdate.equals("")){
	if(ishead){
		url+="?startdate="+startdate;
	}else{
		url+="&startdate="+startdate;
	}
	ishead = false;
}
if(!enddate.equals("")){
	if(ishead){
		url+="?enddate="+enddate;
	}else{
		url+="&enddate="+enddate;
	}
	ishead = false;
}
if(!starttime.equals("")){
	if(ishead){
		url+="?starttime="+starttime;
	}else{
		url+="&starttime="+starttime;
	}
	ishead = false;
}
if(!endtime.equals("")){
	if(ishead){
		url+="?endtime="+endtime;
	}else{
		url+="&endtime="+endtime;
	}
	ishead = false;
}
if(!selectedids.equals("")){
	if(ishead){
		url+="?selectedids="+selectedids;
	}else{
		url+="&selectedids="+selectedids;
	}
	ishead = false;
}

if(!ajax.equals("")){
	if(ishead){
		url+="?ajax="+ajax;
	}else{
		url+="&ajax="+ajax;
	}
}
if(!wfid.equals("")){
	if(ishead){
		url+="?wfid="+wfid;
	}else{
		url+="&wfid="+wfid;
	}
}
if(!entryID.equals("")){
	if(ishead){
		url+="?entryID="+entryID;
	}else{
		url+="&entryID="+entryID;
	}
}

if(!splitflag.equals("")){
	if(ishead){
		url+="?splitflag="+splitflag;
	}else{
		url+="&splitflag="+splitflag;
	}
	ishead = false;
}

if(!deptlevel.equals("")){
	if(ishead){
		url+="?deptlevel="+deptlevel;
	}else{
		url+="&deptlevel="+deptlevel;
	}
	ishead = false;
}
if(!workflowId.equals("")){
	if(ishead){
		url+="?workflowId="+workflowId;
	}else{
		url+="&workflowId="+workflowId;
	}
	ishead = false;
}
if(!nodeid.equals("")){
	if(ishead){
		url+="?nodeid="+nodeid;
	}else{
		url+="&nodeid="+nodeid;
	}
	ishead = false;
}
if(!nodelinkid.equals("")){
	if(ishead){
		url+="?nodelinkid="+nodelinkid;
	}else{
		url+="&nodelinkid="+nodelinkid;
	}
	ishead = false;
}
if(!ispreoperator.equals("")){
	if(ishead){
		url+="?ispreoperator="+ispreoperator;
	}else{
		url+="&ispreoperator="+ispreoperator;
	}
	ishead = false;
}
if(!actionid.equals("")){
	if(ishead){
		url+="?actionid="+actionid;
	}else{
		url+="&actionid="+actionid;
	}
	ishead = false;
}
if(!datasourceid.equals("")){
	if(ishead){
		url+="?datasourceid="+datasourceid;
	}else{
		url+="&datasourceid="+datasourceid;
	}
	ishead = false;
}
if(!needcheckds.equals("")){
	if(ishead){
		url+="?needcheckds="+needcheckds;
	}else{
		url+="&needcheckds="+needcheckds;
	}
	ishead = false;
}
if(!dmlformid.equals("")){
	if(ishead){
		url+="?dmlformid="+dmlformid;
	}else{
		url+="&dmlformid="+dmlformid;
	}
	ishead = false;
}
if(!dmltablename.equals("")){
	if(ishead){
		url+="?dmltablename="+dmltablename;
	}else{
		url+="&dmltablename="+dmltablename;
	}
	ishead = false;
}
if(!dmlisdetail.equals("")){
	if(ishead){
		url+="?dmlisdetail="+dmlisdetail;
	}else{
		url+="&dmlisdetail="+dmlisdetail;
	}
	ishead = false;
}
//System.out.println("url:"+url);

//针对自定义浏览按钮，做特殊处理
int CommonBrowserIndex = url.indexOf("/interface/CommonBrowser.jsp?type=browser.");//单选
int MultiCommonBrowserIndex = url.indexOf("/interface/MultiCommonBrowser.jsp?type=browser.");//多选
String browserType = "";
String frombrowserid = "";//触发字段id
long currenttime = System.currentTimeMillis();
if(CommonBrowserIndex>=0||MultiCommonBrowserIndex>=0){
	//解析url，获得type
	String tempUrl = url.substring(url.indexOf("?")+1);
	String tempUrlParas[] = tempUrl.split("&");
	for(int i=0;i<tempUrlParas.length;i++){
		String tempParas[] = tempUrlParas[i].split("=");
		if(tempParas.length>1){
			String paraName = Util.null2String(tempParas[0]);
			if(paraName.equals("type")){
				browserType = Util.null2String(tempParas[1]);
				String bts[] = browserType.split("\\|");
				browserType = bts[0];
				if(bts.length>1){
					frombrowserid = bts[1];
				}
			}
		}
	}
	
	Browser browser=(Browser)StaticObj.getServiceByFullname(browserType, Browser.class);
	String Search = browser.getSearch();//
	String SearchByName = browser.getSearchByName();//
}


//针对自定义浏览按钮，做特殊处理
int sapSingleBrowserIndex = url.indexOf("/interface/sapSingleBrowser.jsp?type");//单选
int sapMutilBrowserIndex = url.indexOf("/interface/sapMutilBrowser.jsp?type");//多选

//针对集成浏览按钮，做特殊处理
int IntSingleBrowserIndex = url.indexOf("/integration/sapSingleBrowser.jsp?type");//单选
int IntMutilBrowserIndex = url.indexOf("/integration/sapMutilBrowser.jsp?type");//多选

String sapbrowserid = "";//浏览框id
boolean ismainfiled = true;//是主字段
String detailrow = "";//如果是明字段，代表行号
String fromfieldid = "";//字段id
if(sapSingleBrowserIndex>=0||sapMutilBrowserIndex>=0||IntSingleBrowserIndex>=0||IntMutilBrowserIndex>=0){
	//解析url，获得type
	String tempUrl = url.substring(url.indexOf("?")+1);
	String tempUrlParas[] = tempUrl.split("&");
	for(int i=0;i<tempUrlParas.length;i++){
		String tempParas[] = tempUrlParas[i].split("=");
		if(tempParas.length>1){
			String paraName = Util.null2String(tempParas[0]);
			if(paraName.equals("type")){
				browserType = Util.null2String(tempParas[1]);
				String strs[] = browserType.split("\\|");
				if(strs.length==2){
					sapbrowserid = Util.null2String(strs[0]);
					frombrowserid = Util.null2String(strs[1]);
					strs = frombrowserid.split("_");
					if(strs.length==2){
						fromfieldid = strs[0];
						detailrow = strs[1];
						ismainfiled = false;
					}else{
						fromfieldid = strs[0];
					}
				}
			}
		}
	}
}
%>

<html>

<head>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_wev8.js"></script>
</head>

<script language="javascript">
var parentWn = null;

window.onbeforeunload = function(){
	try{
		parentWn.top._popWindow = null;
	}catch(e){}
}
jQuery(document).ready(function(){
	parentWn = window.dialogArguments || window.opener; 
	try{
		var modelWindow = parentWn.top._popWindow;
		if(modelWindow){
			modelWindow.close();
		}
		parentWn.top._popWindow = window;
	}catch(e){
		try{
			parentWn.top._popWindow = null;
		}catch(e){}
	}
});
var url = "<%=url%>";
var fromReport="<%=fromReport%>";
var fromReportformid="<%=fromReportformid%>";
var fromReportisbill="<%=fromReportisbill%>";
var fromNode="<%=fromNode%>";
var fromNodeFormid="<%=fromNodeFormid%>";
var fromNodeWfid="<%=fromNodeWfid%>";
<%if(sapSingleBrowserIndex>=0||sapMutilBrowserIndex>=0){%>
	jQuery(document).ready(function(){
		try{
			var fromNodeorReport=0;//用于判断改浏览按钮的点击来源为报表或节点前或批次条件
			var formid = "";
			var isbill ="";
			var workflowid = "";
			if(fromReport=="1"){//来自报表界面--/workflow/report/ReportResult.jsp
				 formid = fromReportformid;
				 isbill =fromReportisbill;
			 	 workflowid =fromNodeWfid;
			 	 fromNodeorReport="1";
			}else if(fromNode=="1"){//来自节点前默认值和批次条件
				 formid = fromNodeFormid;
				 isbill =fromReportisbill;
			 	 workflowid = fromNodeWfid;
			 	 fromNodeorReport="1";
			}
			else{
				 formid = getDialogArgumentValueByName("formid");
				 isbill = getDialogArgumentValueByName("isbill");
				 workflowid = getDialogArgumentValueByName("workflowid"); 
			}
			var isfirefox=checkFirefoxOrIE();
			var browserType = "<%=browserType%>";
			var currenttime = "<%=currenttime%>";
			var sapbrowserid = "<%=sapbrowserid%>";
			var frombrowserid = "<%=frombrowserid%>";
			url += "&workflowid="+workflowid+"&currenttime="+currenttime+"&sapbrowserid="+sapbrowserid+"&frombrowserid="+frombrowserid+"&fromNodeorReport="+fromNodeorReport; 
			jQuery.ajax({
				url : "/workflow/request/GetSapBrowserParas.jsp",
				type : "post",
				processData : false,
				data : "formid="+formid+"&isbill="+isbill+"&workflowid="+workflowid+"&browserType="+browserType+"&currenttime="+currenttime+"&isfirefox="+isfirefox,
				dataType : "xml",
				success: function do4Success(msg){
					try{
						if(fromReport=="1"||fromNode=="1"){//节点前的动作也不应该走else的逻辑
								
						}else{
							var needChangeField = msg.getElementsByTagName("value")[0].childNodes[0].nodeValue;
							var fieldids = needChangeField.split(",");
							for(var i=0;i<fieldids.length;i++){
								var fieldid = fieldids[i].replace(/(^\s*)|(\s*$)/g,"");
								if(fieldid!=""){
									var fieldobj = window.dialogArguments.document.getElementById(fieldid);
									if(fieldobj!=null){
										var fieldvalue = fieldobj.value;
										url += "&"+fieldid+"="+fieldvalue;
									}
								}
							}
						}
					}catch(e){
						
					}
					setFrameSrc();				
				},
				error:function(){
					setFrameSrc();
				}
			});
		}catch(e){
			setFrameSrc();
		}
	});
<%}else if(IntSingleBrowserIndex>=0||IntMutilBrowserIndex>=0){%>
		jQuery(document).ready(function(){
		try{
			var fromNodeorReport=0;//用于判断改浏览按钮的点击来源为报表或节点前或批次条件
			if(fromReport=="1"){//来自报表界面--/workflow/report/ReportResult.jsp
			 	 fromNodeorReport="1";
			}else if(fromNode=="1"){//来自节点前默认值和批次条件
			 	 fromNodeorReport="1";
			}
			//var formid = window.dialogArguments.document.getElementById("formid").value;
			//var isbill = window.dialogArguments.document.getElementById("isbill").value;
			//var workflowid = window.dialogArguments.document.getElementById("workflowid").value;
			var browserType = "<%=browserType%>";
			var currenttime = "<%=currenttime%>";
			var sapbrowserid = "<%=sapbrowserid%>";
			var frombrowserid = "<%=frombrowserid%>";
			//流程表单的节点id
			var nodeid=0;
			try{
				nodeid= getDialogArgumentValueByName("nodeid");
			}catch(e){
			}
			url += "&currenttime="+currenttime+"&sapbrowserid="+sapbrowserid+"&frombrowserid="+frombrowserid+"&fromNodeorReport="+fromNodeorReport;
			url +="&nodeid="+nodeid;
			setFrameSrc();
		}catch(e){
			setFrameSrc();
		}
	});
<%}else if(CommonBrowserIndex>=0||MultiCommonBrowserIndex>=0){%>
	jQuery(document).ready(function(){
		try{
			var formid = getDialogArgumentValueByName("formid");
			var isbill = getDialogArgumentValueByName("isbill");
			var workflowid = getDialogArgumentValueByName("workflowid");
			
			var browserType = "<%=browserType%>";
			var frombrowserid = "<%=frombrowserid%>";
			var currenttime = "<%=currenttime%>";
			url += "&workflowid="+workflowid+"&currenttime="+currenttime;
			jQuery.ajax({
				url : "/workflow/request/GetCustomizeBrowserParas.jsp",
				type : "post",
				processData : false,
				data : "formid="+formid+"&isbill="+isbill+"&workflowid="+workflowid+"&browserType="+browserType+"&frombrowserid="+frombrowserid+"&currenttime="+currenttime,
				dataType : "xml",
				success: function do4Success(msg){
					try{
						var needChangeField = msg.getElementsByTagName("value")[0].childNodes[0].nodeValue;
						var fieldids = needChangeField.split(",");
						for(var i=0;i<fieldids.length;i++){
							var fieldid = fieldids[i].replace(/(^\s*)|(\s*$)/g,"");
							if(fieldid!=""){
								url += "&"+fieldid+"="+getDialogArgumentValueByName(fieldid);
							}
						}
						//alert(url);
					}catch(e){
						
					}
					setFrameSrc();				
				},
				error:function(){
					setFrameSrc();
				}
			});
		}catch(e){
			setFrameSrc();
		}
	});
<%}else{%>
	window.onload=function(){
		setFrameSrc();
	}
<%}%>

function setFrameSrc(){
	document.getElementById("main").src = url;
}

function getDialogArgumentValueByName(name) {
	var _document = window.dialogArguments.document;
	var ele = _document.getElementById(name);
	
	if (ele == undefined || ele == null) {
		var eles = _document.getElementsByName(name);
		if (eles != undefined && eles != null && eles.length > 0) {
			ele = eles[0];
		}
	}
	
	if (ele) {
		return ele.value;
	}
	return "";
}

function checkFirefoxOrIE(){
		var userAgent=window.navigator.userAgent.toLowerCase();
		if(userAgent.indexOf("firefox")>=1){
			//document.write("你用的是火狐浏览器！版本是：Firefox/"+versionName+"<br>");
			return "1";
		}else{
			return "0";
		}
}

</script>

<!--
<frameset rows="2,98%" framespacing="0" border="0" frameborder="0" >
  <frame name="contents" target="main"  marginwidth="0" marginheight="0" scrolling="auto" noresize >
  <frame name="main" id="main" marginwidth="0" marginheight="0" scrolling="auto" src="">
  <noframes>
  <body>
  <p>此网页使用了框架，但您的浏览器不支持框架。</p>

  </body>
  </noframes>
</frameset>
-->
<body scroll="no">
<iframe name="main" id="main" marginwidth="0" marginheight="0" scrolling="auto" src=""  framespacing="0" border="0" frameborder="0" style="height:750px;width:100%;padding: 0px;margin: 0px;padding-top:10px;"/>
</body>

</html>

