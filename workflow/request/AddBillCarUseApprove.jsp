<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ include file="/workflow/request/WorkflowAddRequestTitle.jsp" %>
<jsp:useBean id="BrowserManager" class="weaver.general.browserData.BrowserManager" scope="page" />
<jsp:useBean id="FileElement" class="weaver.workflow.field.FileElement" scope="page"/>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>


<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<style type="text/css">
._uploadForClass .progressBarInProgress {
	height:2px;
	background:#6b94fe;
	margin:0!important;
}
._uploadForClass .progressWrapper {
	height:30px!important;
	width:100%!important;
	border-bottom:1px solid #dadada;
}
._uploadForClass .progressContainer  {
	background-color:#f5f5f5!important;
	border:solid 0px!important;
	padding-top:5px!important;
	padding-left:0px!important;
	padding-right:0px!important;
	padding-bottom:5px!important;
	margin:0px!important;
}
._uploadForClass .progressCancel {
	width:20px!important;
	height:20px!important;
	background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;
}
._uploadForClass .progressBarStatus {
	display:none!important;
}
._uploadForClass .edui-for-wfannexbutton{
	cursor:pointer!important;
}
._uploadForClass .progressName{
	width:350px!important;
	height:18px;
	padding-left:5px;
	font-size:12px;
	font-family:寰蒋闆呴粦;
	font-weight:normal!important;
	white-space:nowrap;
	overflow:hidden;
	text-overflow:ellipsis;
	color:#242424;
}
</style>
<!-- ckeditor的一些方法在uk中的实现 -->
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>

<form name="frmmain" method="post" action="RequestOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="workflowRequestLogId" value="-1">
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="requestPreAddM" class="weaver.workflow.request.RequestPreAddinoperateManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" /><%----- xwj for td3323 20051209  ------%>
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for @td2977 20051111-->
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page"/> <!--xwj for td3130 20051124-->
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding-top:3px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->

<!--yl qc:67452 start-->
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<!--yl qc:67452 end-->

<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<%----- xwj for td3323 20051209 begin ------%>
<%
String smsAlertsType = Util.null2String(request.getParameter("smsAlertsType")) ;
String chatsAlertType = Util.null2String(request.getParameter("chatsAlertType")) ;//微信提醒(QC:98106)
ArrayList uploadfieldids=new ArrayList();    
 int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
 int maxUploadImageSize = DocUtil.getMaxUploadImageSize(secid);
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }
 int wfid = Util.getIntValue(workflowid, 0);
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(wfid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 boolean isCanuse = RequestManager.hasUsedType(wfid);
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }    
String isSignMustInput="0";
String needcheck10404 = "";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	if("1".equals(isSignMustInput)){
		needcheck10404 = ",remarkText10404";
	}
}
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}    
 //String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
//int annexmaxUploadImageSize=5;
//微信提醒(QC:98106)
int chatsisedit=0;
RecordSet_nf1.execute("select isedit from workflow_nodeform where fieldid= -5 and nodeid="+nodeid);
if(RecordSet_nf1.next()){ 
    chatsisedit=Util.getIntValue(RecordSet_nf1.getString("isedit"),0); 
}//微信提醒(QC:98106)

 weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
 String usernamenew = "";
	if(user.getLogintype().equals("1"))
		usernamenew = ResourceComInfo.getResourcename(""+user.getUID());
	if(user.getLogintype().equals("2"))
		usernamenew = customerInfoComInfo.getCustomerInfoname(""+user.getUID());
	
  weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
  String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+user.getUID(),""+usernamenew,user.getLogintype());

%>
<script type="text/javascript">
function checkCarSubmit(){
	var flag = false;
	jQuery.ajax({
	    type:"post",
		url: "/cpt/car/CarSetDataOperation.jsp?action=getDataSys",
		data: {workflowid:'<%=workflowid%>'},
		async: false, 
		dataType: "json",
		success: function(returndata){
			if(returndata&&returndata.length>0){
				var iscontinue = returndata[0].iscontinue;
				var remindtype = returndata[0].remindtype; 
				if(iscontinue=='yes'){
					var field627 = returndata[0].field627; //车辆
					var field628 = returndata[0].field628; //司机
					var field629 = returndata[0].field629; //用车人
					var field634 = returndata[0].field634; //开始日期
					var field635 = returndata[0].field635; //开始时间
					var field636 = returndata[0].field636; //结束日期
					var field637 = returndata[0].field637; //结束时间
					var field638 = returndata[0].field638; //撤销
					
					field627 = jQuery("#field"+field627).val();
					field634 = jQuery("#field"+field634).val();
					field635 = jQuery("#field"+field635).val();
					field636 = jQuery("#field"+field636).val();
					field637 = jQuery("#field"+field637).val();
					jQuery.ajax({
					    type:"post",
						url: "/cpt/car/CarSetDataOperation.jsp?action=checkData",
						data: {field627:field627,field634:field634,field635:field635,field636:field636,field637:field637,workflowid:'<%=workflowid%>'},
						async: false, 
						dataType: "json",
						success: function(returnjson){
							if(returnjson&&returnjson.length>0){
								iscontinue = returnjson[0].iscontinue;
								if(iscontinue=="no"){
									if(remindtype=="0"){ //提醒不做处理
									    if(confirm("<%=SystemEnv.getHtmlLabelName(128307,user.getLanguage())%>")==true){
									        flag = true;
									    }else{
									        flag = false;
									    }
									}else{//禁止提交
										alert("<%=SystemEnv.getHtmlLabelName(128308,user.getLanguage())%>");
										flag = false;
									}
								}else{
									flag = true;
								}
							}
						}
					});
				}else{
					flag = true;
				}
			}
		}
	});
	return flag;
}

function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert("用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！");
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)     
    if (fileLenthByM><%=maxUploadImageSize%>) {
        alert("所传附件为:"+fileLenthByM+"M,此目录下不能上传超过<%=maxUploadImageSize%>M的文件,如果需要传送大文件,请与管理员联系!");  
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.size=70;
    newObj.onchange=function(){accesoryChanage(this);};
    
    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode); 
}

function checkBrowserInput(event,datas,name,_callbackParams){
	if(datas && datas.id!=""){
		jQuery("input[name='"+name+"']").val(datas.id);
	}else{
		jQuery("input[name='"+name+"']").val("");
		jQuery("#"+name+"span").html("");
	}
	datainput(name,"0");
}

</script>
<%----- xwj for td3323 20051209 end ------%>


<TABLE class="ViewForm" >
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

  <!--新建的第一行，包括说明和重要性 -->

  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <TR>
    <TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></TD>
    <TD class="fieldvalueClass">
      <!--modify by xhheng @20050318 for TD1689-->
      <%if(defaultName==1){%>
       <%--xwj for td1806 on 2005-05-09--%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage()) %>" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(txtuseruse,user.getLanguage() )%>" >
        <span id=requestnamespan>
		
 	<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
		</span>
      <%}else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage()) %>" size=60  maxlength=100  value = "" >
        <span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
      <%}%>
      <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
    </TD>
  </TR>
<tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <!--第一行结束 -->
  <!--add by xhheng @ 2005/01/24 for 消息提醒 Request06，短信设置行开始 -->
  <%
    if(messageType == 1){
  %>
  <TR>
    <TD class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
    <td class="fieldvalueClass">
	      <span id=messageTypeSpan></span>
	      <input type=radio value="0" name="messageType" <% if(smsAlertsType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%>
	      <input type=radio value="1" name="messageType" <% if(smsAlertsType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%>
	      <input type=radio value="2" name="messageType" <% if(smsAlertsType.equals("2")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%>
	    </td>
  </TR>  	   	
  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <%}%>
  <!--短信设置行结束 -->  
  <!--微信提醒(QC:98106) --> 
  <%
   if(chatsType == 1){
  if(chatsisedit==1){   
  %>
  <tr>
    <td class="fieldnameClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></td>
    <td class="fieldvalueClass">
	      <span id=chatsTypeSpan></span>
	      <input type=radio value="0" name="chatsType" <% if(chatsAlertType.equals("0")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
	      <input type=radio value="1" name="chatsType" <% if(chatsAlertType.equals("1")) {%> checked<%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>
	     </td>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>

  <%}else{%>
   <tr>
    <td class="fieldvalueClass"> <%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></td> 
	      <% if(chatsAlertType.equals("0")) {%> <td class=field>
	      <span id=chatsTypeSpan></span><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>  </td> <%}%>
	       <% if(chatsAlertType.equals("1")) {%><td class=field>
	      <span id=chatsTypeSpan></span><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>  </td><%}%>
  </tr>
  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>   <%} }%>
  <!--微信提醒(QC:98106) --> 
  <%if(formid.equals("163")){%>
  <TR>
  	<TD class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(19018,user.getLanguage())%></TD>
  	<TD class="fieldvalueClass"><a href="/car/CarUseInfo.jsp" target="_blank"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a></TD>
  </TR>
  <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
  <%}%>
<%
String docFlags=(String)session.getAttribute("requestAdd"+user.getUID());

HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息
ArrayList selfieldsadd=WfLinkageInfo.getSelectField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);
ArrayList changefieldsadd=WfLinkageInfo.getChangeField(Util.getIntValue(workflowid),Util.getIntValue(nodeid),0);

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();

ArrayList fieldrealtype=new ArrayList();
int detailno=0;
// 确定字段是否显示，是否可以编辑，是否必须输入
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列
ArrayList isedits=new ArrayList();              //字段是否可以编辑队列
ArrayList ismands=new ArrayList();              //字段是否必须输入队列

String newfromtime="";
String newendtime="";
String isbodyview="0" ;    //字段是否显示
String isbodyedit="0" ;    //字段是否可以编辑
String isbodymand="0" ;    //字段是否必须输入
String isbrowsermustwrite = "0";//browser是否必填
String fieldbodyid="";
String fieldbodyname = "" ;                         //字段数据库表中的字段名
String fieldbodyhtmltype = "" ;                     //字段的页面类型
String fieldbodytype = "" ;                         //字段的类型
String fieldbodylable = "" ;                        //字段显示名
String fielddbtype="";                              //字段数据类型

int fieldimgwidth=0;                            //图片字段宽度
int fieldimgheight=0;                           //图片字段高度
int fieldimgnum=0;                              //每行显示图片个数

String bclick="";

// yl qc:67452 start
String selectInitJsStr = "";
String initIframeStr = "";
//yl qc:67452 end

int languagebodyid = 0 ;
int detailsum=0;
String isdetail = "";//xwj for @td2977 20051111
String textheight = "4";//xwj for @td2977 20051111

//获得触发字段名
DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
    /*
    RecordSet.executeProc("workflow_FieldID_Select",formid+"");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString(1)));
        fieldorders.add(Util.null2String(RecordSet.getString(2)));
    }

    RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
    while(RecordSet.next()){
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("languageid")));
		//out.println("<b>LANGUAGE:"+Util.null2String(RecordSet.getString("languageid"))+"</b>");
    }
    */
}
else {

    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet.getString("type")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
        fieldrealtype.add(Util.null2String(RecordSet.getString("fielddbtype")));
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
        
        RecordSet_nf1.executeSql("select * from workflow_nodeform where nodeid = "+nodeid+" and fieldid = " + RecordSet.getString("id"));
        if(!RecordSet_nf1.next()){
        RecordSet_nf2.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+nodeid+","+RecordSet.getString("id")+",'1','1','0')");
        }
        
    }
}

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(Util.null2String(RecordSet.getString("isview")));
    isedits.add(Util.null2String(RecordSet.getString("isedit")));
    ismands.add(Util.null2String(RecordSet.getString("ismandatory")));
}


// 得到每个字段的信息并在页面显示
//modify by mackjoe at 2006-06-07 td4491 将节点前附加操作移出循环外操作减少数据库访问量
int fieldop1id=0;
String strFieldId=null;
String strCustomerValue=null;
String strManagerId=null;
String strUnderlings=null;
ArrayList inoperatefields = new ArrayList();
ArrayList inoperatevalues = new ArrayList();
requestPreAddM.setCreater(userid);
requestPreAddM.setOptor(userid);
requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
requestPreAddM.setNodeid(Util.getIntValue(nodeid));
Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
inoperatefields = (ArrayList)getPreAddRule_hs.get("inoperatefields");
inoperatevalues = (ArrayList)getPreAddRule_hs.get("inoperatevalues");

//得到每个字段的信息并在页面显示
Hashtable otherPara_hs = new Hashtable();
otherPara_hs.put("workflowid",Util.null2String(workflowid));
otherPara_hs.put("requestid",Util.null2String("-1"));
otherPara_hs.put("nodetype",Util.null2String("0"));
otherPara_hs.put("docCategory",Util.null2String(docCategory));
otherPara_hs.put("maxUploadImageSize",Util.null2String(maxUploadImageSize));
otherPara_hs.put("canDelAcc","0");
otherPara_hs.put("changefieldsadd",changefieldsadd);

// 得到每个字段的信息并在页面显示
String beagenter=""+userid;
//获得被代理人
int body_isagent=Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()),0);
if(body_isagent==1){
    rsaddop.executeSql("select bagentuid from workflow_agentConditionSet where workflowId="+ workflowid +" and agentuid=" + userid +
				 " and agenttype = '1' " +
				 " and ( ( (endDate = '" + TimeUtil.getCurrentDateString() + "' and (endTime='' or endTime is null))" +
				 " or (endDate = '" + TimeUtil.getCurrentDateString() + "' and endTime > '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
				 " or endDate > '" + TimeUtil.getCurrentDateString() + "' or endDate = '' or endDate is null)" +
				 " and ( ( (beginDate = '" + TimeUtil.getCurrentDateString() + "' and (beginTime='' or beginTime is null))" +
				 " or (beginDate = '" + TimeUtil.getCurrentDateString() + "' and beginTime < '" + (TimeUtil.getCurrentTimeString()).substring(11,19) + "' ) ) " +
				 " or beginDate < '" + TimeUtil.getCurrentDateString() + "' or beginDate = '' or beginDate is null)  order by agentbatch asc  ,id asc ");
    if(rsaddop.next())  beagenter=rsaddop.getString(1);
}

String preAdditionalValue = "";
boolean isSetFlag = false;//xwj for td3308 20051124
for(int i=0;i<fieldids.size();i++){         // 循环开始
 
  int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i
  
	fieldbodyid=(String)fieldids.get(tmpindex);  //字段id
    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示
        if( viewtype.equals("1") ) continue ;
    }

 /*---xwj for td3130 20051124 begin ---*/
  preAdditionalValue = "";
  isSetFlag = false;//added by xwj for td3359 20051222
    //将节点前附加操作移出循环外操作减少数据库访问量
  //rsaddop.executeSql("select customervalue from workflow_addinoperate where workflowid=" + workflowid + " and ispreadd='1' and isnode = 1 and objid = "+nodeid+" and fieldid = " + fieldbodyid);
  int inoperateindex=inoperatefields.indexOf(fieldbodyid);
  if(inoperateindex>-1){
  isSetFlag = true;
  preAdditionalValue = (String)inoperatevalues.get(inoperateindex);
  }
  /*---xwj for td3130 20051124 end ---*/

    int isfieldidindex = isfieldids.indexOf(fieldbodyid) ;
    if( isfieldidindex != -1 ) {
        isbodyview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isbodyedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    isbodymand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
	    isbrowsermustwrite = isbodymand.equals("1") ? "2" : "1";
    }
    if(isbill.equals("0")) {
        languagebodyid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新
        fieldbodyhtmltype=FieldComInfo.getFieldhtmltype(fieldbodyid);
        fieldbodytype=FieldComInfo.getFieldType(fieldbodyid);
        fieldbodylable=(String)fieldlabels.get(tmpindex);
        fieldbodyname=FieldComInfo.getFieldname(fieldbodyid);
        fieldimgwidth=FieldComInfo.getImgWidth(fieldbodyid);
		fieldimgheight=FieldComInfo.getImgHeight(fieldbodyid);
		fieldimgnum=FieldComInfo.getImgNumPreRow(fieldbodyid);
    }
    else {
        languagebodyid = user.getLanguage() ;
        fieldbodyname=(String)fieldnames.get(tmpindex);
        fieldbodyhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldbodytype=(String)fieldtypes.get(tmpindex);
        fieldbodylable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languagebodyid );
        fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);
		fielddbtype = Util.null2String((String)fieldrealtype.get(tmpindex));
    }




    if(fieldbodyname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(""+beagenter);
%>
	<input type=hidden name="field<%=fieldbodyid%>" value="<%=tmpmanagerid%>">
<%
        if(isbodyview.equals("1")){
%> <tr>
      <td <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%> class="fieldnameClass"> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class="fieldvalueClass"><%=ResourceComInfo.getLastname(tmpmanagerid)%></td>
   </tr><tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
<%
        }
	    continue;
	}

	if(fieldbodyname.equalsIgnoreCase("startDate")) newfromdate="field"+fieldbodyid; //开始日期,主要为开始日期不大于结束日期进行比较
	if(fieldbodyname.equalsIgnoreCase("endDate")) newenddate="field"+fieldbodyid;   //结束日期,主要为开始日期不大于结束日期进行比较
    if(fieldbodyname.equalsIgnoreCase("startTime")) newfromtime="field"+fieldbodyid; //开始时间
	if(fieldbodyname.equalsIgnoreCase("endTime")) newendtime="field"+fieldbodyid;	//结束时间
    
    if(isbodymand.equals("1"))  needcheck+=",field"+fieldbodyid;   //如果必须输入,加入必须输入的检查中

    //if( ! isbodyview.equals("1") ) continue ;           //不显示即进行下一步循环
    if( ! isbodyview.equals("1") ) { //不显示即进行下一步循环,除了人力资源字段，应该隐藏人力资源字段，因为人力资源字段有可能作为流程下一节点的操作者
        if(fieldbodyhtmltype.equals("3") && (fieldbodytype.equals("1") ||fieldbodytype.equals("17")||fieldbodytype.equals("165")||fieldbodytype.equals("166")) && !preAdditionalValue.equals("")){           
           out.println("<input type=hidden name=field"+fieldbodyid+" value="+preAdditionalValue+">");
        }        
        continue ;                  
    }

    // 下面开始逐行显示字段
%>
    <tr>
      <td <%if(fieldbodyhtmltype.equals("2")){%> valign=top <%}%> class="fieldnameClass"> <%=Util.toScreen(fieldbodylable,languagebodyid)%> </td>
      <td class="fieldvalueClass">
      <%
        if(fieldbodyhtmltype.equals("1")){                          // 单行文本框
            if(fieldbodytype.equals("1")){                          // 单行文本框中的文本
                if(isbodyview.equals("1")){
                if(isbodyedit.equals("1")){
                    if(isbodymand.equals("1")) {
      %>
        <input datatype="text" type=text viewtype="<%=isbodymand%>" class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" size=50 onChange="checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span')"<%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
      <%

				    }else{%>
        <input datatype="text" type=text viewtype="<%=isbodymand%>" class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" value="" size=50 <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}else{%> onblur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
      <%            }
		    }else{ %>
        <!--input  type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=50 readonly-->
            <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
            <input  type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>"  size=50 value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
      <%          }
            }
            }
		    else if(fieldbodytype.equals("2")){                     // 单行文本框中的整型
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
      %>
        <input  datatype="int" type=text id="field<%=fieldbodyid%>" viewtype="<%=isbodymand%>" class=Inputstyle name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" size=20
		onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checkcount1(this);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span')" <%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%

				    }else{%>
        <input  datatype="int" type=text viewtype="<%=isbodymand%>" class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" size=20 onKeyPress="ItemCount_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checkcount1(this);datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}else{%> onBlur="checkcount1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> value="<%=preAdditionalValue%>"> <!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
			    }else{  %>
         <!--input datatype="int" type=text class=Inputstyle name="field<%=fieldbodyid%>" size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="int" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
            }
            }
		    else if(fieldbodytype.equals("3")){                     // 单行文本框中的浮点型
                if(isbodyview.equals("1")){
			    if(isbodyedit.equals("1")){
				    if(isbodymand.equals("1")) {
       %>
        <input datatype="float" type=text viewtype="<%=isbodymand%>" class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" size=20
		onKeyPress="ItemNum_KeyPress()" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checknumber1(this);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span');datainput('field<%=fieldbodyid%>')" <%}else{%> onBlur="checknumber1(this);checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span')"<%}%> value="<%=preAdditionalValue%>">
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%
    				}else{%>
        <input datatype="float" type=text viewtype="<%=isbodymand%>" class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" size=20 onKeyPress="ItemNum_KeyPress()"  <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onBlur="checknumber1(this);datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}else{%> onBlur="checknumber1(this);checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));"<%}%> value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%           }
               }else{  %>
         <!--input datatype="float" type=text class=Inputstyle name="field<%=fieldbodyid%>"  size=20 readonly-->
         <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
         <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
        <%        }
		    }
	    }
	     /*-----------xwj for td3131 20051115 begin ----------*/
	    else if(fieldbodytype.equals("4")){%>
            <TABLE cols=2 id="field<%=fieldbodyid%>_tab">
            <tr><td>
                <%if(isbodyview.equals("1")){
                    if(isbodyedit.equals("1")){%>
                        <input datatype="float" type=text class=Inputstyle id="field_lable<%=fieldbodyid%>" name="field_lable<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" size=60 
                            onfocus="FormatToNumber('<%=fieldbodyid%>')" 
                            onKeyPress="ItemNum_KeyPress('field_lable<%=fieldbodyid%>')"                             
                            <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>
                                onBlur="numberToFormat('<%=fieldbodyid%>') 
                                datainput('field_lable<%=fieldbodyid%>') 
                                <%if(isbodymand.equals("1")){%>
                                    checkinput('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span')
                                <%}%>"
                            <%}else{%>
                                onBlur="numberToFormat('<%=fieldbodyid%>') 
                                <%if(isbodymand.equals("1")){%>
                                    checkinput('field_lable<%=fieldbodyid%>','field_lable<%=fieldbodyid%>span')
                                <%}%>"
                            <%}%>
                        >
                        <span id="field_lable<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=hidden class=Inputstyle id="field_lable<%=fieldbodyid%>" name="field_lable<%=fieldbodyid%>" value="">
                        <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" value="">
                    <%}else{%>
                        <span id="field<%=fieldbodyid%>span"></span>
                        <input datatype="float" type=text class=Inputstyle name="field_lable<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" disabled="true">
                        <input datatype="float" type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" value="">
                    <%}
                }
                if(!"".equals(preAdditionalValue)){%>
                    <script language="javascript">
                        window.document.all("field_lable"+<%=fieldbodyid%>).value  = numberChangeToChinese(<%=preAdditionalValue%>);
                        window.document.all("field"+<%=fieldbodyid%>).value  = <%=preAdditionalValue%>;
                    </script>
                <%}%>
            </td></tr>
            <tr><td>
                <input type=text class=Inputstyle size=60 id="field<%=fieldbodyid%>" name="field_chinglish<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" readOnly="true">
            </td></tr>
            </table>
	    <%}
	    if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
	    /*-----------xwj for td3131 20051115 end ----------*/
	    }// 单行文本框条件结束
	    else if(fieldbodyhtmltype.equals("2")){                     // 多行文本框
	     /*-----xwj for @td2977 20051111 begin-----*/
	     if(isbill.equals("0")){
			 rscount.executeSql("select * from workflow_formdict where id = " + fieldbodyid);
			 if(rscount.next()){
			 textheight = rscount.getString("textheight");
			 }
			 }
			    /*-----xwj for @td2977 20051111 begin-----*/
            if(isbodyview.equals("1")){
		    if(isbodyedit.equals("1")){
			    if(isbodymand.equals("1")) {
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');" <%}%> onChange="checkinput('field<%=fieldbodyid%>','field<%=fieldbodyid%>span')"
		rows="<%=textheight%>" cols="40" style="width:80%" class=Inputstyle ><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111-->
        <span id="field<%=fieldbodyid%>span"><%if("".equals(preAdditionalValue)){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span><!--modified by xwj for td3130 20051124-->
       <%
			    }else{
       %>
        <textarea class=Inputstyle viewtype="<%=isbodymand%>" id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onBlur="datainput('field<%=fieldbodyid%>');checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}else{%> onblur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));" <%}%> rows="<%=textheight%>" cols="40" style="width:80%"><%=preAdditionalValue%></textarea><!--xwj for @td2977 20051111--><!--modified by xwj for td3130 20051124-->
        <span id="field<%=fieldbodyid%>span"></span>
       <%       }
            }else{  %>
                <span id="field<%=fieldbodyid%>span"><%=preAdditionalValue%></span>
                <input type=hidden class=Inputstyle id="field<%=fieldbodyid%>" name="field<%=fieldbodyid%>" value="<%=preAdditionalValue%>"><!--modified by xwj for td3130 20051124-->
         <!--textarea  class=Inputstyle name="field<%=fieldbodyid%>" rows="4" cols="40" style="width:80%"  readonly></textarea-->
        <%        }
	    }
	    if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }// 多行文本框条件结束
	    else if(fieldbodyhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
		    String url=BrowserComInfo.getBrowserurl(fieldbodytype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldbodytype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值
            
            if((fieldbodytype.equals("8") || fieldbodytype.equals("135")) && !prjid.equals("")){       //浏览按钮为项目,从前面的参数中获得项目默认值
                showid = "" + Util.getIntValue(prjid,0);
            }else if((fieldbodytype.equals("9") || fieldbodytype.equals("37")) && !docid.equals("")){ //浏览按钮为文档,从前面的参数中获得文档默认值
                showid = "" + Util.getIntValue(docid,0);
            }else if((fieldbodytype.equals("1") ||fieldbodytype.equals("17")) && !hrmid.equals("")){ //浏览按钮为人,从前面的参数中获得人默认值
                showid = "" + Util.getIntValue(hrmid,0);
            }else if((fieldbodytype.equals("7") || fieldbodytype.equals("18")) && !crmid.equals("")){ //浏览按钮为CRM,从前面的参数中获得CRM默认值
                showid = "" + Util.getIntValue(crmid,0);
            }else if(fieldbodytype.equals("4") && !hrmid.equals("")){ //浏览按钮为部门,从前面的参数中获得人默认值(由人力资源的部门得到部门默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getDepartmentID(hrmid),0);
            }else if(fieldbodytype.equals("24") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getJobTitle(hrmid),0);
            }else if(fieldbodytype.equals("32") && !hrmid.equals("")){ //浏览按钮为职务,从前面的参数中获得人默认值(由人力资源的职务得到职务默认值)
                showid = "" + Util.getIntValue(request.getParameter("TrainPlanId"),0);
            }else if((fieldbodytype.equals("164") || fieldbodytype.equals("169") || fieldbodytype.equals("170")) && !hrmid.equals("")){ //浏览按钮为分部,从前面的参数中获得人默认值(由人力资源的分部得到分部默认值)
                showid = "" + Util.getIntValue(ResourceComInfo.getSubCompanyID(hrmid),0);
            }
            
            if(fieldbodytype.equals("2")){ //added by xwj for td3130 20051124                      
                 if(!isSetFlag){
                    showname = currentdate;
                    showid = currentdate;
                }else{
                    showname=preAdditionalValue;
                    showid=preAdditionalValue;
                }
            }
            
            if(fieldbodytype.equals("19")){                      
                if(!isSetFlag){
                	String _currenttime = currenttime.substring(0,5);
                   showname = _currenttime;
                   showid = _currenttime;
               }else{
                   showname=preAdditionalValue;
                   showid=preAdditionalValue;
               }
           }
            
            if(showid.equals("0")) showid = "" ;
            
            
            if(isSetFlag){
            showid = preAdditionalValue;//added by xwj for td3308 20051213
           }
            
			if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
				url+="?type="+fielddbtype;
			}
           if(fieldbodytype.equals("2") || fieldbodytype.equals("19")  )	showname=showid; // 日期时间
            else if(! showid.equals("")){       // 获得默认值对应的默认显示值,比如从部门id获得部门名称
                ArrayList tempshowidlist=Util.TokenizerString(showid,",");
                if(fieldbodytype.equals("8") || fieldbodytype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("1") ||fieldbodytype.equals("17")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("7") || fieldbodytype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("4") || fieldbodytype.equals("57")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("164")){
                    //分部
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=SubCompanyComInfo1.getSubCompanyname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("9") || fieldbodytype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        if (fieldbodytype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//维护正文
                         String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='#' onlick='createDoc("+fieldbodyid+","+tempDoc+")'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }
                        else
                        {
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldbodytype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("16") || fieldbodytype.equals("152") || fieldbodytype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldbodytype.equals("161")||fieldbodytype.equals("162")){
                    
					Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
                            String desc=Util.null2String(bb.getDescription());
                            String name=Util.null2String(bb.getName());							
                            String href=Util.null2String(bb.getHref());
                            if(href.equals("")){
                            	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                            }else{
                            	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                            }
						}catch (Exception e){
						}
                    }                    
                }else if(fieldbodytype.equals("141")){
                    //人力资源条件
					showname+=ResourceConditionManager.getFormShowName(preAdditionalValue,languagebodyid);                    
                }else{
	                String tablename=BrowserComInfo.getBrowsertablename(fieldbodytype);
	                String columname=BrowserComInfo.getBrowsercolumname(fieldbodytype);
	                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldbodytype);
	                String sql="";
	                if(showid.indexOf(",")==-1){
	                    sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+showid;
	                }else{
	                    sql="select "+columname+" from "+tablename+" where "+keycolumname+" in("+showid+")";
	                }
	                //System.out.println("showid:"+showid);
					//System.out.println("sql:"+sql);
	                RecordSet.executeSql(sql);
	                while(RecordSet.next()) {
	                	 if (!linkurl.equals(""))
	                     {
	                     	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
	                     	{
	                     		showname += "<a href='javaScript:openhrm(" + showid + ");' onclick='pointerXY(event);'>" + RecordSet.getString(1) + "</a>&nbsp";
	                     	}
	                     	else
	                         	showname += "<a href='" + linkurl + showid + "'>" + RecordSet.getString(1) + "</a>&nbsp";
	                     }
	                    else
	                        showname +=RecordSet.getString(1) ;
	                }
	            }
            }

           //deleted by xwj for td3130 20051124

		    if(isbodyedit.equals("1")){

		    	//----对一下浏览框做特殊处理-----
            	//人力资源和多人力资源 
				//分权人力资源、分权多人力资源
				//文档、多文档
				//项目、多项目
				//客户、多客户
				//资产、会议
				//成本中心、报销费用类型
				String paramStr = "";
				if(fieldbodytype.equals("1")||fieldbodytype.equals("17")
						||fieldbodytype.equals("165")||fieldbodytype.equals("166")
						||fieldbodytype.equals("9")||fieldbodytype.equals("37")
						||fieldbodytype.equals("8")||fieldbodytype.equals("135")
						||fieldbodytype.equals("7")||fieldbodytype.equals("18")
						||fieldbodytype.equals("23")||fieldbodytype.equals("28")
						||fieldbodytype.equals("251")||fieldbodytype.equals("22")
					){
						paramStr = "bdf_wfid="+workflowid+"&bdf_fieldid="+fieldbodyid+"&bdf_viewtype=0";
						if(fieldbodytype.equals("251")||fieldbodytype.equals("22")){
							paramStr += "&workflowid="+workflowid+"&fieldid="+fieldbodyid;
						}
				}else if(fieldbodytype.equals("152")||fieldbodytype.equals("171")||fieldbodytype.equals("16")){
						paramStr = "currworkflowid="+workflowid+"&fieldid="+fieldbodyid;
				}
				if(!paramStr.equals("")){
					if(url.indexOf("url=")!=-1){
						String urltemp = url.substring(url.indexOf("url=")+4);
						if(urltemp.indexOf("?")!=-1){
							url+= "&"+paramStr;
						}else{
							url+= "?"+paramStr;
						}
					}
				}
		    	
	              if(fieldbodytype.equals("160")){
	                  rsaddop.execute("select a.level_n, a.level2_n from workflow_groupdetail a ,workflow_nodegroup b where a.groupid=b.id and a.type=50 and a.objid="+fieldbodyid+" and b.nodeid in (select nodeid from workflow_flownode where workflowid="+workflowid+" ) ");
	  				String roleid="";
	  				int rolelevel_tmp = 0;
	  				if (rsaddop.next())
	  				{
	  				roleid=rsaddop.getString(1);
	  				rolelevel_tmp=Util.getIntValue(rsaddop.getString(2), 0);
	  				roleid += "a"+rolelevel_tmp;
	  				}
				bclick="onShowResourceRole('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'),'"+roleid+"')";
	  %>
			<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' id='<%="field"+fieldbodyid%>' temptitle="<%=fieldbodylable %>" browserValue='<%=showid%>' browserUrl='<%=url+roleid %>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowsermustwrite %>' completeUrl="/data.jsp" width="130px" needHidden="false" browserSpanValue='<%=showname%>' _callback="checkBrowserInput"> </brow:browser>
			<!--
	          <button class=Browser  onclick="onShowResourceRole('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'),'<%=roleid%>')" title="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>"></button>-->
	  <%
	  			  } else



                if( !fieldbodytype.equals("37") ) {    //  多文档特殊处理
					if(fieldbodytype.equals("2") || fieldbodytype.equals("19")){
					%>
						<button type="button" name="<%="field"+fieldbodyid%>_button" id="<%="field"+fieldbodyid%>_button" temptitle="<%=fieldbodylable %>" class=calendar <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');"<%}else{%> onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>	
					<%
					}else if(fieldbodytype.equals("178")){
					%>
						<button class=Browser name="<%="field"+fieldbodyid%>_button" id="<%="field"+fieldbodyid%>_button" temptitle="<%=fieldbodylable %>" <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');"<%}else{%> onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>
					<%
					}else{
						if(trrigerfield.indexOf("field"+fieldbodyid)>=0){
							bclick="onShowBrowser('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'));datainput('field"+fieldbodyid+"');";
						}else{
							bclick="onShowBrowser('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"',field"+fieldbodyid+".getAttribute('viewtype'))";
						}
						String completeUrl = "/data.jsp?type="+fieldbodytype+"&fielddbtype="+fielddbtype;
						//out.println("url:"+url);
					%>
						<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' id='<%="field"+fieldbodyid%>' temptitle="<%=fieldbodylable %>" browserValue='<%=showid%>' browserUrl='<%=url %>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowsermustwrite %>' completeUrl='<%=completeUrl %>' width="130px" needHidden="false" browserSpanValue='<%=showname%>'  _callback="checkBrowserInput"> </brow:browser>
					<%
					}
					

	   %>
	   <!--
        <button class=Browser <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%>onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'));datainput('field<%=fieldbodyid%>');"<%}else{%> onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>',field<%=fieldbodyid%>.getAttribute('viewtype'))"<%}%> title="<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%>"></button>-->
       <%       } else {                         // 如果是多文档字段,加入新建文档按钮
			bclick="onShowBrowser('"+fieldbodyid+"','"+url+"','"+linkurl+"','"+fieldbodytype+"','"+
				isbodymand+"')";
       %>
		<brow:browser viewType="0" name='<%="field"+fieldbodyid%>' id='<%="field"+fieldbodyid%>' browserValue='<%=showid%>' browserUrl='<%=url %>' hasInput="true" isSingle='<%=BrowserManager.browIsSingle(fieldbodytype)%>' hasBrowser = "true" isMustInput='<%=isbrowsermustwrite %>' completeUrl="/data.jsp" temptitle="<%=fieldbodylable %>" width="130px" needHidden="false" browserSpanValue='<%=showname%>'  _callback="checkBrowserInput"> </brow:browser>
        <!--<button class=AddDoc onclick="onShowBrowser('<%=fieldbodyid%>','<%=url%>','<%=linkurl%>','<%=fieldbodytype%>','<%=isbodymand%>')" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>-->
		&nbsp;&nbsp<button class=AddDoc onclick="onNewDoc(<%=fieldbodyid%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
       <%       }
            }
       %>
      
        <input type=hidden viewtype="<%=isbodymand%>" name="field<%=fieldbodyid%>" id="field<%=fieldbodyid%>" value="<%=showid%>" >
        <%if(isbrowsermustwrite.equals("2")){ %>
        <script type="text/javascript">
        	//$("input[name='field<%=fieldbodyid %>']").propertychange(function(){ alert(1);checkBrowserInput('field<%=fieldbodyid %>'); });
        </script>
        <%} %>
		<%
		   if(fieldbodytype.equals("2") || fieldbodytype.equals("19")  || fieldbodytype.equals("178")){
		%>
        <span id="field<%=fieldbodyid%>span"><%=Util.toScreen(showname,user.getLanguage())%>
       <%   if(isbodymand.equals("1") && showname.equals("")) {
       %>
           <img src="/images/BacoError_wev8.gif" align=absmiddle>
       <%
            }
       %>
        </span>
       <%}else if(isbodyedit.equals("0")){
    	   %>
    	   <span id="field<%=fieldbodyid%>span"><%=showname %></span>
    	   <%
       }
       if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
	    }                                                       // 浏览按钮条件结束
	    else if(fieldbodyhtmltype.equals("4")) {                  // check框
	   %>
        <input type=checkbox <%if("".equals(preAdditionalValue)){%>value=1<%}else{%>value=<%=preAdditionalValue%><%}%>  name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" <%if(isbodyedit.equals("0")){%> DISABLED <%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>><!--modified by xwj for td3130 20051124-->
       <%
        }                                                       // check框条件结束
        else if(fieldbodyhtmltype.equals("5")){                     // 选择框   select

             //yl 67452   start
            String uploadMax = "";
            if(fieldbodyid.equals(selectedfieldid)&&uploadType==1)
            {
                uploadMax = "changeMaxUpload('field"+fieldbodyid+"');reAccesoryChanage();";
            }
            //处理select字段联动
            String onchangeAddStr = "";
            int childfieldid_tmp = 0;
            if("0".equals(isbill)){
                rs.execute("select childfieldid from workflow_formdict where id="+fieldbodyid);
            }else{
                rs.execute("select childfieldid from workflow_billfield where id="+fieldbodyid);
            }
            if(rs.next()){
                childfieldid_tmp = Util.getIntValue(rs.getString("childfieldid"), 0);
            }
            int firstPfieldid_tmp = 0;
            boolean hasPfield = false;
            if("0".equals(isbill)){
                rs.execute("select id from workflow_formdict where childfieldid="+fieldbodyid);
            }else{
                rs.execute("select id from workflow_billfield where childfieldid="+fieldbodyid);
            }
            while(rs.next()){
                firstPfieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
                if(fieldids.contains(""+firstPfieldid_tmp)){
                    hasPfield = true;
                    break;
                }
            }
            if(childfieldid_tmp != 0){//如果先出现子字段，则要把子字段下拉选项清空
                onchangeAddStr = " onchange = '" +  "$changeOption(this, "+fieldbodyid+", "+childfieldid_tmp+");'";
            }

            //yl 67452   end
	   %>
        <script>
        	function funcField<%=fieldbodyid%>(){
        	    changeshowattr('<%=fieldbodyid%>_0',document.getElementById('field<%=fieldbodyid%>').value,-1,'<%=workflowid%>','<%=nodeid%>');
        	}
        	window.attachEvent("onload", funcField<%=fieldbodyid%>);
        </script>
        <select notBeauty=true class=inputstyle viewtype="<%=isbodymand%>"   <%=onchangeAddStr%>  id="field<%=fieldbodyid%>"  name="field<%=fieldbodyid%>" temptitle="<%=fieldbodylable %>" <%if(isbodyedit.equals("0")){%> DISABLED <%}%> <%if(isbodyedit.equals("1")){%>onBlur="checkinput2('field<%=fieldbodyid%>','field<%=fieldbodyid%>span',this.getAttribute('viewtype'));"<%}%> <%if(trrigerfield.indexOf("field"+fieldbodyid)>=0&&selfieldsadd.indexOf(fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');changeshowattr('<%=fieldbodyid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>);" <%}else if(selfieldsadd.indexOf(fieldbodyid)>=0){%> onchange="changeshowattr('<%=fieldbodyid%>_0',this.value,-1,<%=workflowid%>,<%=nodeid%>)"<%}else if(trrigerfield.indexOf("field"+fieldbodyid)>=0){%> onChange="datainput('field<%=fieldbodyid%>');" <%}%>><!--added by xwj for td3313 20051206 -->
	    <option value=""></option><!--added by xwj for td3297 20051130 -->
	   <%
            // 查询选择框的所有可以选择的值

           char flag= Util.getSeparator() ;
            rs.executeProc("workflow_selectitembyid_new",""+fieldbodyid+flag+isbill);
			      boolean checkempty = true;//xwj for td3313 20051206
			      String finalvalue = "";//xwj for td3313 20051206


           //yl 67452   start
           if(hasPfield == false){
             while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
                String isdefault = Util.toScreen(rs.getString("isdefault"),user.getLanguage());//xwj for td2977 20051107
				         /* -------- xwj for td3313 20051206 begin -*/
				        if("".equals(preAdditionalValue)){
				         if("y".equals(isdefault)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				        }
				        else{
				         if(tmpselectvalue.equals(preAdditionalValue)){
				          checkempty = false;
				          finalvalue = tmpselectvalue;
				         }
				        }
				         /* -------- xwj for td3313 20051206 end -*/
	   %>
	    <option value="<%=tmpselectvalue%>"  <%if("".equals(preAdditionalValue)){if("y".equals(isdefault)){%>selected<%}}else{if(tmpselectvalue.equals(preAdditionalValue)){%>selected<%}}//xwj for td2977 20051107%> ><%=tmpselectname%></option><!--modified by xwj for td3130 20051124-->
	   <%            }
            }else{
           while(rs.next()){
               String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
               String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
               if(tmpselectvalue.equals(preAdditionalValue)){
                   checkempty = false;
                   finalvalue = tmpselectvalue;
               }
       %>
            <option value="<%=tmpselectvalue%>" <%if(preAdditionalValue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
            <%
                    }
                    selectInitJsStr += "doInitChildSelect("+fieldbodyid+","+firstPfieldid_tmp+",\""+finalvalue+"\");\n";
                    initIframeStr += "<iframe id=\"iframe_"+firstPfieldid_tmp+"_"+fieldbodyid+"_00\" frameborder=0 scrolling=no src=\"\"  style=\"display:none\"></iframe>";
           }

                //yl 67452   end

       %>
	    </select>
	    <!--xwj for td3313 20051206 begin-->
	    <span id="field<%=fieldbodyid%>span">
	    <%
	     if(isbodymand.equals("1") && checkempty){
	    %>
       <IMG src='/images/BacoError_wev8.gif' align=absMiddle>
      <%
            }
       %>
	     </span>
	    <%if(isbodyedit.equals("0")){%>
        <input type=hidden class=Inputstyle name="field<%=fieldbodyid%>" value="<%=finalvalue%>" >
      <%}%>
	    <!--xwj for td3313 20051206 end-->
       <%
       if(changefieldsadd.indexOf(fieldbodyid)>=0){
%>
    <input type=hidden name="oldfieldview<%=fieldbodyid%>" value="<%=Util.getIntValue(isbodyview,0)+Util.getIntValue(isbodyedit,0)+Util.getIntValue(isbodymand,0)%>" />
<%
    }
        }                                                       // 选择框   select结束
       //add by xhheng @20050310 for 附件上传
       else if(fieldbodyhtmltype.equals("6")){
    	    otherPara_hs.put("fieldimgwidth"+fieldbodyid, Util.null2String(fieldimgwidth));
            otherPara_hs.put("fieldimgheight"+fieldbodyid, Util.null2String(fieldimgheight));
	       	otherPara_hs.put("fieldimgnum"+fieldbodyid, Util.null2String(fieldimgnum));
	       	otherPara_hs.put("uploadfieldids", uploadfieldids);
	       	uploadfieldids.add(fieldbodyid);
       	
	       	Hashtable ret_hs = FileElement.getHtmlElementString(Util.getIntValue(fieldbodyid), fieldbodyname, Util.getIntValue(fieldbodytype), fieldbodylable, 0, 0, 0, preAdditionalValue, 0, Util.getIntValue(isbodyview), Util.getIntValue(isbodyedit), Util.getIntValue(isbodymand), user, otherPara_hs);
	       	out.println(Util.null2String(ret_hs.get("inputStr")));
	       	out.println("<script>");
	       	out.println(Util.null2String(ret_hs.get("jsStr")));
	       	out.println("</script>");

       }else if(fieldbodyhtmltype.equals("7")){
    	   out.println(Util.null2String((String)specialfield.get(fieldbodyid+"_1")));
       }                                          // 选择框条件结束 所有条件判定结束
       %>
      </td>
    </tr>
	 <tr style="height:1px;"><td class=Line1 colSpan=2></td></tr>
<%
    }       // 循环结束
%>

</table>

<!-- 单独写签字意见Start ecology8.0 -->
    <%
  //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
    //add by cyril on 2008-09-30 for td:9014
		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet_nf1.next()){
				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
				m ++ ;
			}
		}
		//end by cyril on 2008-09-30 for td:9014
		
		//String isSignMustInput="0";
		String isFormSignature=null;
		String isHideInput="0";
		int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
		int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
		RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
		if(RecordSet_nf1.next()){
		isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
		formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
		isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
		isHideInput = ""+Util.getIntValue(RecordSet_nf1.getString("ishideinput"), 0);
		}
		int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
		if(isUseWebRevision_t != 1){
		isFormSignature = "";
		}
	String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String isannexupload_edit = isannexupload_add;
	String annexdocids = "";
	String requestid = "-1";
	
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_add)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
         if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
          }
         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
     }
    %>
	<%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
<!-- 单独写签字意见End ecology8.0 -->



 <script>

//签字意见打开关闭
  jQuery(".signstatus").click(function(){
	     
		   var classname=jQuery(this).find("img").attr("class");
		   var signtr;
		   var height=220;
		   if(classname==='signshrink')
		   {
		     
             signtr=jQuery(this).parent().find(".ViewForm  tbody").find("tr").eq(1);

			 jQuery(signtr).show();
             
			 jQuery(".flowsign .cke_editor").show();
                
             if(jQuery(".signaturebyhand").length>0)
			 {
			   jQuery(".signaturebyhand").show();
			 }

			 if(jQuery(".relateitems").length>0)
			   {
			    jQuery(".relateitems").show();
			  }

			  jQuery(this).find("img").attr("class","signspread");
			  jQuery(this).find("img").attr("src","/images/wf/spread_wev8.png");
       
	         if(jQuery(".flowsignhelper").length>0)
			   {
	            jQuery(".flowsignhelper").css("height",jQuery(".flowsignhelper").attr("flowheight"));
			   }


		   }else
		   {
		    

             signtr=jQuery(this).parent().find(".ViewForm  tbody").find("tr").eq(1);
             jQuery(signtr).hide();
			 jQuery(".flowsign .cke_editor").hide();
             
			 if(jQuery(".signaturebyhand").length>0)
			 {
			   jQuery(".signaturebyhand").hide();
			 }

              if(jQuery(".relateitems").length>0)
			   {
			    jQuery(".relateitems").hide();
			  }
            
			 if(jQuery(".flowsignhelper").length>0)
			   {
			    jQuery(".flowsignhelper").css("height",jQuery(".flowsignhelper").attr("titleheight"));
			  }
 

	         jQuery(this).find("img").attr("src","/images/wf/shrink_wev8.png");
             jQuery(this).find("img").attr("class","signshrink");

			 jQuery(document.body).css("height",jQuery(document.body).get(0).scrollHeight+"px");
              
            // alert();

			  
		   }

		});

        function onShowSignBrowser(url, linkurl, inputname, spanname, type1) {

				//var tmpids = $GetEle(inputname).value;
				var tmpids="";
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

                    	
						var resourceidArray = resourceids.split(",");
						
						var resourcenameArray = resourcename.split(",");
						
						var inputResourceidArray = resourceids.split(",");
						

						var oEditor = CKEDITOR.instances['remark'];


                        var editorel=jQuery("<div>"+oEditor.getData()+"</div>");

                        var tempval="";
						 var items=[];

                        //确认并生成该签字意见所关联的文档或流程 
                        if (type1 === 37)
						{
					        items=editorel.find(".relatedoc"); 
                       
					    }else
						{
                            items=editorel.find(".relatewf"); 

						}

						 for(var i=0,length=items.length;i<length;i++)
						  {
						     tempval=jQuery(items[i]).attr("relateid");
						     if((","+resourceids).indexOf(","+tempval)<0)
							  {
							    inputResourceidArray.push(tempval);
							  }
						  }


                       	$GetEle(inputname).value = inputResourceidArray.join(",");


						oEditor.insertElement(new CKEDITOR.dom.element.createFromHtml("<span></span>", oEditor.document));  

						for (var _i=0; _i<resourceidArray.length; _i++) {
							var curid = resourceidArray[_i];
							var curname = resourcenameArray[_i];
							
							if (type1 === 37) 
							sHtml = sHtml+"&nbsp<a  class='relatedoc' relateid="+curid+" unselectable='off'  style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000' href=" + linkurl + curid
									+ " target='_blank'><img src='/images/ecology8/top_icons/1-1_wev8.png'/>" + curname + "</a>&nbsp";
                             else
                             sHtml = sHtml+"&nbsp<a  class='relatewf' relateid="+curid+" unselectable='off'  style='cursor:pointer;text-decoration:none !important;margin-right:8px;color:#000000' href=" + linkurl + curid
									+ " target='_blank'><img src='/images/ecology8/top_icons/3-1_wev8.png'/>" + curname + "</a>&nbsp";
						  // oEditor.insertElement(new CKEDITOR.dom.element.createFromHtml(sHtml, oEditor.document)); 
						}

						//editor.insertElement(new CKEDITOR.dom.element.createFromHtml(sHtml, editor.document));
							
							FCKEditorExt.insertHtml(sHtml,"remark");
						//FCKEditorExt.setHtml(sHtml,"remark");
						//$GetEle(spanname).innerHTML = sHtml;

					} else {
						//$GetEle(spanname).innerHTML = "";
						//$GetEle(inputname).value = "";
					}
				}
			}


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



   </script>


<!-- yl qc:67452 start-->
<%=initIframeStr%>
<!-- yl qc:67452 end-->

  <jsp:include page="WorkflowAddRequestDetailBody.jsp" flush="true">
		<jsp:param name="workflowid" value="<%=workflowid%>" />
		<jsp:param name="nodeid" value="<%=nodeid%>" />
		<jsp:param name="formid" value="<%=formid%>" />
        <jsp:param name="detailsum" value="<%=detailsum%>"/>
        <jsp:param name="isbill" value="<%=isbill%>"/>
        <jsp:param name="currentdate" value="<%=currentdate%>" />
		<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="needcheck" value="<%=needcheck%>" />
		<jsp:param name="prjid" value="<%=prjid%>" />
		<jsp:param name="docid" value="<%=docid%>" />
		<jsp:param name="hrmid" value="<%=hrmid%>" />
		<jsp:param name="crmid" value="<%=crmid%>" />
  </jsp:include>

<input type=hidden name="workflowid" id="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="workflowtype" id="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" id="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" id="nodetype" value="0">                     <!--当前节点类型-->
<input type=hidden name="src" id="src">                                    <!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" id="iscreate" value="1">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" id="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="topage" id="topage" value="<%=topage%>">            <!--创建结束后返回的页面-->
<input type=hidden name ="isbill" id="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name ="method" id="method">                                <!--新建文档时候 method 为docnew-->
<input type=hidden name ="needcheck" id="needcheck" value="<%=needcheck+needcheck10404%>">
<input type=hidden name ="inputcheck" id="inputcheck" value="">

<script language=javascript>

function onNewDoc(fieldbodyid) {
   
    frmmain.action = "RequestOperation.jsp" ;
    frmmain.method.value = "docnew_"+fieldbodyid ;
    if(check_form(document.frmmain,'requestname')){
      
        document.frmmain.src.value='save';
        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    }
}

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
    	try {
	        if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && document.frmmain.<%=newenddate%>.value != "")
	        {
	            YearFrom=document.frmmain.<%=newfromdate%>.value.substring(0,4);
	            MonthFrom=document.frmmain.<%=newfromdate%>.value.substring(5,7);
	            DayFrom=document.frmmain.<%=newfromdate%>.value.substring(8,10);
	            YearTo=document.frmmain.<%=newenddate%>.value.substring(0,4);
	            MonthTo=document.frmmain.<%=newenddate%>.value.substring(5,7);
	            DayTo=document.frmmain.<%=newenddate%>.value.substring(8,10);
	            if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
	                window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	                return false;
	            }else{
	                if(document.frmmain.<%=newenddate%>.value==document.frmmain.<%=newfromdate%>.value && document.frmmain.<%=newendtime%>.value<document.frmmain.<%=newfromtime%>.value){
	                    window.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	                    return false;
	                }
				}
	        }
	        return true;
    	} catch (e) {
        	return true;
        }
    }

    function doSave(){              <!-- 点击保存按钮 -->
        var ischeckok="";
        getRemarkText_log2();
        try{
        if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
            if(check_form(document.frmmain,'<%=needcheck+needcheck10404%>'))
                ischeckok="true";
        }
        if(ischeckok=="true"){
            if(checktimeok()) {
                    document.frmmain.src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){
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
<%}else{%>

                    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
                }
            }
    }
//给签字意见 hidden 框赋值
function getRemarkText_log2(){
    try{

        var reamrkNoStyle = FCKEditorExt.getText("remark");
        if(reamrkNoStyle == ""){
            document.getElementById("remarkText10404").value = reamrkNoStyle;
        }else{
            var remarkText = FCKEditorExt.getTextNew("remark");
            document.getElementById("remarkText10404").value = remarkText;
        }
        for(var i=0; i<FCKEditorExt.editorName.length; i++){
            var tmpname = FCKEditorExt.editorName[i];
            try{
                if(tmpname == "remark"){
                    continue;
                }
                $(tmpname).value = FCKEditorExt.getText(tmpname);
            }catch(e){}
        }
    }catch(e){

    }
}
    function doSubmit(obj){            <!-- 点击提交 -->
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try document.all("needcheck")来检查,避免对原有无明细单据的修改
        var ischeckok="";
        getRemarkText_log2();
        try{
        if(check_form(document.frmmain,document.all("needcheck").value+document.all("inputcheck").value))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form(document.frmmain,'<%=needcheck+needcheck10404%>'))
            ischeckok="true";
        }
        if(!checkCarSubmit()){
            ischeckok=="false";
            return;
        }
        if(ischeckok=="true"){
            if(checktimeok()) {
                document.frmmain.src.value='submit';
                // xwj for td2104 on 20050802
                //document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
//保存签章数据
<%if("1".equals(isFormSignature)){%>
	                    if(SaveSignature()){
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
<%}else{%>
                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            }
        }
    }
	function onAddPhrase(phrase){            <!-- 添加常用短语 -->
    if(phrase!=null && phrase!=""){
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
			}
		}catch(e){}
    }
    }
<%-----------xwj for td3131 20051115 begin -----%>
function numberToFormat(index){
    if(document.all("field_lable"+index).value != ""){
        document.all("field"+index).value = floatFormat(document.all("field_lable"+index).value);
        document.all("field_lable"+index).value = milfloatFormat(document.all("field"+index).value);
        document.all("field_chinglish"+index).value = numberChangeToChinese(document.all("field"+index).value);
    }else{
        document.all("field"+index).value = "";
        document.all("field_chinglish"+index).value = "";
    }
}
function FormatToNumber(index){
    if(document.all("field_lable"+index).value != ""){
        document.all("field_lable"+index).value = document.all("field"+index).value;
    }else{
        document.all("field"+index).value = "";
        document.all("field_chinglish"+index).value = "";
    }
}
<%-----------xwj for td3131 20051115 end -----%>
function numberToChinese(index){
if(document.all("field_lable"+index).value != ""){
document.all("field"+index).value = document.all("field_lable"+index).value;
document.all("field_lable"+index).value = numberChangeToChinese(document.all("field_lable"+index).value);
}
else{
document.all("field"+index).value = "";
}
}
function ChineseToNumber(index){
if(document.all("field_lable"+index).value != ""){
document.all("field_lable"+index).value = chineseChangeToNumber(document.all("field_lable"+index).value);
document.all("field"+index).value = document.all("field_lable"+index).value;
}
else{
document.all("field"+index).value = "";
}
}

  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
      var tempS = "<%=trrigerfield%>";
      var tempA = tempS.split(",");
      for(var i=0;i<tempA.length;i++){
          datainput(tempA[i]);
      }
  }
  var tempvalue = "";
  function datainput(parfield,type){                <!--数据导入-->
  	  if(",<%=trrigerfield%>,".indexOf(","+parfield+",")==-1){
	  	return;
	  }
	  if(jQuery("#"+parfield).val()==tempvalue && type!="0"){
	  	return;
	  }else{
	  	tempvalue = jQuery("#"+parfield).val();
	  }
      //var xmlhttp=XmlHttp.create();
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
      <%
          ArrayList Linfieldname=ddi.GetInFieldName();
          ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
          for(int i=0;i<Linfieldname.size();i++){
              String temp=(String)Linfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
          for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
          StrData+="&<%=temp%>="+document.all("<%=temp.substring(temp.indexOf("|")+1)%>").value;
      <%
          }
      %>
      //alert(StrData);
      document.all("datainputform").src="DataInputFrom.jsp?"+StrData;
      //xmlhttp.open("POST", "DataInputFrom.jsp", false); 
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
  function addannexRow(accname)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1); 
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (此目录下最大只能上传<%=maxUploadImageSize%>M/个的附件) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
function showfieldpop(){
<%if(fieldids.size()<1){%>
alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
<%}%>
}


//提示窗口
function showPrompt(content)
{

     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("<div>")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.posTop=pTop;
     message_table_Div.style.posLeft=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
//TD4262 增加提示信息  结束



</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script LANGUAGE="javascript">


//yl qc:67452 start
function $changeOption(obj, fieldid, childfieldid){

    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
}
function doInitChildSelect(fieldid,pFieldid,finalvalue){
    try{
        var pField = $GetEle("field"+pFieldid);
        if(pField != null){
            var pFieldValue = pField.value;
            if(pFieldValue==null || pFieldValue==""){
                return;
            }
            if(pFieldValue!=null && pFieldValue!=""){
                var field = $GetEle("field"+fieldid);
                var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
                $GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
            }
        }
    }catch(e){}
}
<%=selectInitJsStr%>
//yl qc:67452 end

function getWFLinknum(wffiledname){
    if(document.all(wffiledname) != null){
        return document.all(wffiledname).value;
    }else{
        return 0;
    }
}
function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if (id1) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}

//hjun 2015-08-04 字段属性联动
jQuery(document).ready(function(){
<%
String sqlLink = "select * from workflow_viewattrlinkage where workflowid="+workflowid+" and nodeid="+nodeid;
RecordSet.executeSql(sqlLink);
while(RecordSet.next()){
	String selectfieldid = Util.null2String(RecordSet.getString("selectfieldid"));
	//String[] selectfieldidattr = selectedfieldid.split("_");
	selectfieldid = selectfieldid.substring(0, selectfieldid.indexOf("_"));
	String selectfieldvalue = Util.null2String(RecordSet.getString("selectfieldvalue"));
	String changefieldids = Util.null2String(RecordSet.getString("changefieldids"));
	String[] changefieldidarr = changefieldids.split(",");
	String viewattr = Util.null2String(RecordSet.getString("viewattr"));
	%>
	jQuery("#field<%=selectfieldid%>").change(function(){
		var thisval = jQuery(this).val();
		setTimeout(function(){
			if(thisval=="<%=selectfieldvalue%>"){
			<%
			for(int i=0;i<changefieldidarr.length;i++){
				if(!"".equals(changefieldidarr[i])){
					//String[] changefieldidattr = changefieldidarr[i].split("_");
					String changefieldid = changefieldidarr[i].substring(0,changefieldidarr[i].indexOf("_"));
					%>
					//var val = $("#field<%=changefieldid%>").val();
					//$("#field<%=changefieldid%>").val("");
					<%
					if(viewattr.equals("2")){//必填
					%>
						document.getElementById("field<%=changefieldid%>").setAttribute("viewtype","1");
						//$("#field<%=changefieldid%>").attr("viewtype","1");
					<%
					}else{
					%>
						document.getElementById("field<%=changefieldid%>").setAttribute("viewtype","0");
						//$("#field<%=changefieldid%>").attr("viewtype","0");
					<%
					}
				}
			}
			%>
			}
		},1000);
	});
<%
}
%>
});
////字段联动 end

function checkinput5(elementname,spanid,viewtype){
	if (wuiUtil.isNullOrEmpty(viewtype)) {
		viewtype = $G(elementname).getAttribute("viewtype");
	}
	if(viewtype==1){
		var tmpvalue = "";
		try{
			tmpvalue = $GetEle(elementname).value;
		}catch(e){
			tmpvalue = $GetEle(elementname).value;
		}
		while(tmpvalue.indexOf(" ") >= 0){
			tmpvalue = tmpvalue.replace(" ", "");
		}
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue!=""){
			$GetEle(spanid+"img").innerHTML = "";
		}else{
			$GetEle(spanid+"img").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			//$GetEle(elementname).value = "";
		}
	}
}

function checkFileRequired(fieldid){
	if(jQuery("#needcheck").val().indexOf("field"+fieldid)>-1){
		var isReturn = false;
		jQuery("#fsUploadProgress"+fieldid+" .progressBarStatus").each(function(i,obj){
			if(jQuery(obj).text()!='Cancelled'){
				isReturn = true;
				return false
			}
		})
		if(isReturn){
			jQuery("#field_"+fieldid+"span").hide();
		}else{
			if(jQuery("#field"+fieldid).val()==''
					||jQuery("#field"+fieldid).val()=='NULL'
					||jQuery("#field"+fieldid).val()=='null'){
				jQuery("#field_"+fieldid+"span").show();
			}else{
				jQuery("#field_"+fieldid+"span").hide();
			}
		}
	}
}

</script>
</form>