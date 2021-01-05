
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.cowork.*" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CoTypeRight" class="weaver.cowork.CoTypeRight" scope="page"/>
<jsp:useBean id="CoworkService" class="weaver.cowork.CoworkService" scope="page" />
<%@ include file="/cowork/uploader.jsp" %>
<jsp:include page="CoworkUtil.jsp"></jsp:include>

<%	
//CoTypeComInfo.removeCoTypeInfoCache();
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);          

int typeid=Util.getIntValue(request.getParameter("typeid"),0);

int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String enddate=TimeUtil.dateAdd(currentdate,1);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String parterids=userid+","+(hrmid.equals(""+userid)?"":(hrmid));
String parterNames=ResourceComInfo.getLastname(""+userid)+","+(hrmid.equals(""+userid)?"":ResourceComInfo.getResourcename(hrmid)); 

String docid = Util.null2String(request.getParameter("docid"));
String from =request.getParameter("from");//用来表示从哪个页面进入的，从协作区进入from="cowork"，从其他地方进入from="other"
String message= Util.null2String(request.getParameter("message")); //协作创建失败，返回到协作新建页面

Map appStatusMap=CoworkService.getAppStatus();

String titlename=SystemEnv.getHtmlLabelNames("82,17855",user.getLanguage());
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())%></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>

<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<script type="text/javascript" src="js/cowork_wev8.js"></script>

<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker_wev8.js?rnd="+Math.random()+"'></script>
<link rel="stylesheet" href="/cowork/css/cowork_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

<link rel=stylesheet type="text/css" href="/cowork/css/coworkNew_wev8.css"/>
<style>
table.ke-toolbar-table td{padding:0px;}
</style>
</head>
<body onbeforeunload="checkChange()">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(27411,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>"/> 
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:420px;">
<form name="frmmain" method="post" action="CoworkOperation.jsp?from=<%=from%>" enctype="multipart/form-data">
<input type=hidden name="method" value="add">
<input type=hidden name="from" value="<%=from%>">
<input type=hidden name="status" id="status" value="1"/>
<input type=hidden name="isApproval" id="isApproval" value="0"/>
<%String defaultCoType = "";//初始协作区类型 %>  
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item >
			<wea:required id="namespan" required="true">
				<input class=inputstyle type=text name="name" id="name" 
					onkeydown="if(window.event.keyCode==13) return false;" onChange="checkinput('name','namespan')" 
					style="width:45%" onblur="checkLength('name',50,'<%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')">
			</wea:required> 
		</wea:item> 

		<wea:item><%=SystemEnv.getHtmlLabelName(33867,user.getLanguage())%></wea:item>
		<wea:item>
			
			<select name="typeid" id="typeid" size=1 onchange="onShowneedinput();onShowCoTypeAccessory(this.value);getTypeSet(this.value)" style="width:150px;">
			<%
				
				int index = 0;
				
			 	while(CoTypeComInfo.next()){
			     
				     String tmptypeid=CoTypeComInfo.getCoTypeid();
				     String typename=CoTypeComInfo.getCoTypename();             
				
				     int sharelevel = CoTypeRight.getRightLevelForCowork(""+userid,tmptypeid);
				     if(sharelevel==0) continue;
				    	index++;	
				    	if(index==1) defaultCoType = tmptypeid;//初始协作区类型默认为选项中的第一个
				    	if(tmptypeid.equals(""+typeid)) defaultCoType = tmptypeid;//如果设置了默认协作区类型，更新初始协作区类型
			     
					%>
					<option value="<%=tmptypeid%>" <%if(tmptypeid.equals(""+typeid)){%> selected <%}%> ><%=typename%></option>
					<%
				}
			%>
			</select>
			<span id="subtypespan">
				<%if(defaultCoType.equals("")){%>
					<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
				<%}%>
			</span>
			<input type=hidden name="creater" value=<%=userid%>>
		</wea:item>
		<%--
		<wea:item attributes="{'samePair':'showroAnonymous'}"><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showroAnonymous'}">
			<input type="checkbox" tzCheckbox="true" name="isAnonymous" id="isAnonymous" value="1">
		</wea:item>
		 
		<wea:item><%=SystemEnv.getHtmlLabelName(33868,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isApply" id="isApply" value="1">
		</wea:item>
		--%>
		<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
		<wea:item>      	
			
			<brow:browser viewType="0" name="txtPrincipal" browserValue='<%=""+userid%>' 
							browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
							hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
							completeUrl="/data.jsp" width="50%" 
							browserSpanValue='<%=ResourceComInfo.getResourcename(""+userid)%>'>
			</brow:browser>
			
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></wea:item>
		<wea:item>
			<textarea id="remark" _editorid="remark" _editorName="remark" style="width:100%;height:120px;border:1px solid #C7C7C7;"></textarea>
		</wea:item>
		<%if(appStatusMap.containsKey("attachment")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></wea:item>
		<%
			CoworkDAO dao = new CoworkDAO();
			Map dirMap=dao.getAccessoryDir(defaultCoType);
			String secId = (String)dirMap.get("secId");
			String maxsize = (String)dirMap.get("maxsize");
		
			if(!secId.equals("")){
		%>
		<wea:item attributes="{'id':'divAccessory'}">
			<div id="uploadDiv" mainId="" subId="" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
		</wea:item>
		<%}else{%>
			<wea:item attributes="{'id':'divAccessory'}"><font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font></wea:item>
		<%}%>
		<%} %>
	</wea:group>
</wea:layout>

<div style="display:none;">
	<input type="hidden" name="begindate" id="begindate" value=<%=currentdate%>>
	<input type="hidden" name="endtime" id="endtime">   
	<input type="hidden" name="enddate" id="enddate" value='<%=enddate%>'> 
	<input type="hidden" name="beingtime" id="beingtime">
	
	<input type="hidden" name="sharetype" value="5">
	<input type="hidden" name="seclevel" value="0">
	<input type="hidden" name="seclevelMax" value="100">
	<input type="hidden" name="shareid" value="0">
	<input name="relatedshareid" type="hidden" class="relatedshareid_0">
	<input type="hidden" name="shareOperation" value="add">
	<input type="hidden" name="isChangeCoworker" value="1" id="isChangeCoworker">
	<input type="hidden" name="deleteShareids" id="deleteShareids" value="" "="">
</div>
</form>
</div>

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

</body>
</html>
<script>
function checkChange() {
	if(jQuery("#name").val()!=""||jQuery("#remark").val()!=""||(jQuery("#relateddoc").val()!=''&&jQuery("#relateddoc").val()!='0')||jQuery("#relatedcus").val()!=''||jQuery("#relatedwf").val()!=''||jQuery("#relatedprj").val()!=''||jQuery("#projectIDs").val()!=''||document.all("relatedacc").value!='')
      event.returnValue="<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
</script>
<script language=javascript src="/js/checkData_wev8.js"></script>

<script language=javascript>

var isApproval="";
var isAnonymous="";

jQuery(document).ready(function(){

   //加载条件
	$.post("/cowork/CoworkShareManager.jsp?from=add",null,function(data){
		$("#coworkshare_tr").html(data);
		if("<%=hrmid%>"!=""){
		   _writeBackData("relatedshareid_0",1,{id:"<%=parterids%>",name:"<%=parterNames%>"},{hasInput:true,replace:true,isSingle:false,isedit:false});
	   }
	});
   
   highEditor("remark");	
   
   //绑定附件上传
   setTimeout(function(){
	   if(jQuery("#uploadDiv").length>0)
	     bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc"); 
   },1000);
     
  if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
   //左侧下拉框处理
   jQuery(document.body).bind("mouseup",function(){
	   parent.jQuery("html").trigger("mouseup.jsp");	
    });
    jQuery(document.body).bind("click",function(){
		jQuery(parent.document.body).trigger("click");		
    });
   }
   
   //新建协作失败提醒
   if("<%=message%>"=="error") 
      alert("<%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())+SystemEnv.getHtmlLabelName(498,user.getLanguage())%>");
   
   isApproval="<%=CoTypeComInfo.getIsApprovals(defaultCoType)%>"; 
   if(isApproval=="1")
	   jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelNames("615,359",user.getLanguage())%>");
   else
	   jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>");
   
   isAnonymous="<%=CoTypeComInfo.getIsAnonymouss(defaultCoType)%>";
   if(isAnonymous!="1"){
	   hideEle("showroAnonymous","true");
   }	   
}
);
function doSave(obj){
	if(check_formM(document.frmmain,'name,typeid,txtPrincipal')){
		if(jQuery("img[src='/images/BacoError_wev8.gif']").length !=0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
			return;
		}
		jQuery(".shareSecLevel").show();
		
		obj.disabled = true;
		document.body.onbeforeunload = null;//by cyril on 2008-06-24 for TD:8828
		
		var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];
	    try{
	       if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
	         doSaveAfterAccUpload();  //保存协作
	       else 
	     	 oUploader.startUpload();
		}catch(e){
		     doSaveAfterAccUpload(); //保存协作
		 }
	}
}

function doSaveAfterAccUpload(){
	if(isApproval==1)
		jQuery("#status").val("-1");//需要审批
	else
		jQuery("#status").val("1");//正常状态
	jQuery("#isApproval").val(isApproval);	
	var remarkValue=getRemarkHtml("remark");
	$("textarea[name=remark]").val(remarkValue);
    document.frmmain.submit();		
}

//检查协作时间
function checkDateTime(){
   var begindateStr=document.getElementById("begindate").value.split("-");
   var enddateStr=document.getElementById("enddate").value.split("-");
   
   var begindate,enddate;
   
   var beingtimeStr=document.getElementById("beingtime").value.split(":");
   var endtimeStr=document.getElementById("endtime").value.split(":");
   if(beingtimeStr.length==2)
       begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2],beingtimeStr[0],beingtimeStr[1]);
   else
       begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2]);
   
   if(endtimeStr.length==2)
       enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2],endtimeStr[0],endtimeStr[1]);
   else
       enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2]); 
       
   if(begindate>enddate){
       alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
       return false;
   }else
       return true;    
}
  function check_formM(thiswins,items)
{
	thiswin = thiswins
	items = ","+items + ",";
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="coworkers"){
		if(tmpvalue == 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}

function onShowCoTypeAccessory(CoType){
   jQuery.post("CoworkAccessory.jsp?CoType="+CoType,{},function(data){
       jQuery("#divAccessory").html(data);
       //绑定附件上传
       if(jQuery("#uploadDiv").length>0)
          bindUploaderDiv(jQuery("#uploadDiv"),"relatedacc");
   });
}

function getTypeSet(typeid){
	jQuery.post("CoworkOperation.jsp?method=getTypeSet&typeid="+typeid,{},function(data){
		data=eval("("+data+")");
		isApproval=data.isApproval;
		isAnonymous=data.isAnonymous;
		
		if(isApproval==1)
			jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelNames("615,359",user.getLanguage())%>");
		else
			jQuery("#rightMenuIframe").contents().find("#menuItemDivId0 button").html("<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>");
		
		if(isAnonymous=="1"){
			showEle("showroAnonymous","true");
		}else{
			hideEle("showroAnonymous","true");
		}
	});
}
</script>

<script>
function onShowneedinput(){
  if(jQuery("#typeid").val()=="")
     jQuery("#subtypespan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
  else
     jQuery("#subtypespan").html("");   
}

function moreInfo(obj){
	var _status = $(obj).attr("_status");
	var _hh = $("#moretable").height();
	if(_status==1){
		$("#moreinfo").animate({height:_hh},300,null,function(){});
		$(obj).attr("_status",0).attr("title","<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage())%>").css("background","url('/cowork/images/btn_up2_wev8.png')");
	}else{
		$("#moreinfo").animate({height:0},300,null,function(){});
		$(obj).attr("_status",1).attr("title","<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage())%>").css("background","url('/cowork/images/btn_down2_wev8.png')");
	}
}

</script>
