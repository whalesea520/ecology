<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="testWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page" />

<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    //是否为流程模板
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
int isSaveas=Util.getIntValue(request.getParameter("isSaveas"),0);
%>
<html>
<%
    int subCompanyId2 = -1;
	String type="";
	String title="";
	String wfname="";
	String wfdes="";
	String isbill = "3";
	String iscust = "0";
	String isremak="";
	String isShowChart = "";
	String isModifyLog = "0";
	String orderbytype = "";
    String isforwardrights="";
  String needmark = "" ;
  String messageType= "" ;
  String smsAlertsType = "0";
  String mailMessageType= "" ;//added by xwj for td2965 20051101
  String archiveNoMsgAlert = ""; // 归档节点不需短信提醒
  String archiveNoMailAlert = ""; // 归档节点不需邮件提醒
  String forbidAttDownload="";//禁止附件批量下载
  String docRightByOperator="";
  String multiSubmit= "" ;
  String defaultName= "1" ;
  String maincategory = "";
  String subcategory= "";
  String seccategory= "";
  String docPath = "";
  String isannexUpload="";
  String annexmaincategory = "";
  String annexsubcategory= "";
  String annexseccategory= "";
  String annexdocPath = "";
  String isaffirmance="";
  String wfdocpath="";
  String wfdocpathspan="";
  String wfdocownerfieldid = "";
  String isSaveCheckForm = ""; //流程保存是否验证必填
  String wfdocowner="";
  String wfdocownerspan="";
   String isImportDetail="";
  int selectedCateLog = 0;
  int catelogType = 0;
  int docRightByHrmResource = 0;//added by pony for Td4611 on 2006/06/26
  String showUploadTab = "";
  String isSignDoc="";
  String showDocTab="";
  String isSignWorkflow="";
  String showWorkflowTab="";
  boolean isdocRightByHrmResource = false;
  int templateid=Util.getIntValue(request.getParameter("templateid"),0);
  String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
  String templatename="";
  String candelacc="";//是否允许创建人删除附件
  String ShowDelButtonByReject="1";
  
  String specialApproval = "0";	//是否特批件
  String Frequency = "0";	
  String Cycle = "1";
  
  String isrejectremind="0";
  String isneeddelacc="0";
  String ischangrejectnode="0";
      String isselectrejectnode="0";
  String isimportwf="0";
  String issignview="0";
  String newdocpath="";
  String newdocpathspan="";
	int helpdocid=0;
  String isvalid="1";
  String nosynfields = "";
  String nosynfieldsStr = "";
  String SAPSource = "";
  String wfdocownertype = "";
	int formid=0;
	int typeid=Util.getIntValue(request.getParameter("typeid"),0);
	type = Util.null2String(request.getParameter("src"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }


    subCompanyId2 = subCompanyId;
    boolean isnewform = false;
	String isvalidStr = "";
	if(type=="")
		type = "addwf";
	if(type.equals("addwf"))
		title="add";
	else {
		title="edit";
		WFManager.setWfid(wfid);
		WFManager.getWfInfo();
		wfname=WFManager.getWfname();
		wfdes=WFManager.getWfdes();
		typeid=WFManager.getTypeid();
		formid=WFManager.getFormid();
		isbill = WFManager.getIsBill();
		iscust = WFManager.getIsCust();
		helpdocid = WFManager.getHelpdocid();
        templateid=WFManager.getTemplateid();
    isvalid=WFManager.getIsValid();
    needmark = WFManager.getNeedMark();
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    messageType=WFManager.getMessageType();
    smsAlertsType = WFManager.getSmsAlertsType();
     //add by xwj 20051101 for 邮件提醒 td2965
    mailMessageType=WFManager.getMailMessageType();
    archiveNoMsgAlert = WFManager.getArchiveNoMsgAlert();
    archiveNoMailAlert = WFManager.getArchiveNoMailAlert();
    
    //是否禁止附件批量下载
    forbidAttDownload=WFManager.getForbidAttDownload();
    
    //是否跟随文档关联人赋权
    docRightByOperator=WFManager.getDocRightByOperator();
    //add by xhheng @ 20050302 for TD 1545
    multiSubmit=WFManager.getMultiSubmit();
    //add by xhheng @ 20050303 for TD 1689
    defaultName=WFManager.getDefaultName();
    //add by xhheng @ 20050314 for 附件上传
    docPath = WFManager.getDocPath();
    selectedCateLog = WFManager.getSelectedCateLog();
    catelogType = WFManager.getCatelogType();
    docRightByHrmResource = WFManager.getDocRightByHrmResource();
	 isImportDetail = WFManager.getIsImportDetail();
    isaffirmance=WFManager.getIsaffirmance();
    isSaveCheckForm = WFManager.getIsSaveCheckForm();
	isremak=WFManager.getIsremak();
    isforwardrights=WFManager.getIsforwardRights();    
	isShowChart = WFManager.getIsShowChart();
	orderbytype = WFManager.getOrderbytype();
	isModifyLog = WFManager.getIsModifyLog();//add by cyril on 2008-07-14 for td:8835
    subCompanyId2 = WFManager.getSubCompanyId2() ;//add by wjy
    String tempcategory=WFManager.getDocCategory();
    String tempannexcategory=WFManager.getAnnexDocCategory();
    isannexUpload=WFManager.getIsAnnexUpload();
    showUploadTab=WFManager.getShowUploadTab();
    isSignDoc=WFManager.getSignDoc();
    showDocTab=WFManager.getShowDocTab();
    isSignWorkflow=WFManager.getSignWorkflow();
    showWorkflowTab=WFManager.getShowWorkflowTab();
    candelacc = WFManager.getCanDelAcc();//是否允许创建人删除附件

    ShowDelButtonByReject = WFManager.getShowDelButtonByReject();

	specialApproval = WFManager.getSpecialApproval();
    
    Frequency = WFManager.getFrequency();
    Cycle = WFManager.getCycle();
    
    isrejectremind = WFManager.getIsrejectremind();
    ischangrejectnode = WFManager.getIschangrejectnode();
	 isselectrejectnode = WFManager.getIsSelectrejectNode();
    isimportwf = WFManager.getIsImportwf();
	wfdocpath = WFManager.getWfdocpath();
	wfdocowner = WFManager.getWfdocowner();
	wfdocownerspan = ResourceComInfo.getLastname(wfdocowner);
	wfdocownertype = WFManager.getWfdocownertype();
	wfdocownerfieldid = WFManager.getWfdocownerfieldid();
	issignview = WFManager.getIssignview();
     newdocpath=WFManager.getNewdocpath();
	 nosynfields = WFManager.getNosynfields();
	  isneeddelacc=WFManager.getIsneeddelacc();
	  SAPSource = WFManager.getSAPSource();
    try{
	      maincategory=tempcategory.substring(0,tempcategory.indexOf(','));
	      subcategory=tempcategory.substring(tempcategory.indexOf(',')+1,tempcategory.lastIndexOf(','));
	      seccategory=tempcategory.substring(tempcategory.lastIndexOf(',')+1,tempcategory.length());
	      String tempName = SubCCI.getSubCategoryname(subcategory);
	      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
	      //if(!maincategory.equals(""))
	      //docPath="/"+MainCCI.getMainCategoryname(maincategory)+"/"+tempName+"/"+SecCCI.getSecCategoryname(seccategory);
	      docPath = SecCCI.getAllParentName(seccategory,true);
    	}catch(Exception e){
    		if(tempcategory.indexOf(",")==-1){
    			docPath = SecCCI.getAllParentName(tempcategory,true);
    		}
    	}
   if(tempannexcategory!=null && !tempannexcategory.equals("")){
    	try{
	      annexmaincategory=tempannexcategory.substring(0,tempannexcategory.indexOf(','));
	      annexsubcategory=tempannexcategory.substring(tempannexcategory.indexOf(',')+1,tempannexcategory.lastIndexOf(','));
	      annexseccategory=tempannexcategory.substring(tempannexcategory.lastIndexOf(',')+1,tempannexcategory.length());
	      String tempName = SubCCI.getSubCategoryname(annexsubcategory);
	      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
	      if(!annexmaincategory.equals(""))
	      //annexdocPath="/"+MainCCI.getMainCategoryname(annexmaincategory)+"/"+tempName+"/"+SecCCI.getSecCategoryname(annexseccategory);
	    	  annexdocPath = SecCCI.getAllParentName(annexseccategory,true);
    	}catch(Exception e){
    		if(tempannexcategory.indexOf(",")==-1){
    			annexdocPath = SecCCI.getAllParentName(tempannexcategory,true);
    		}
    	}
    }
    if(wfdocpath!=null && !wfdocpath.equals("")){
    	try{
	      String _temp1 = wfdocpath.substring(0,wfdocpath.indexOf(','));
	      String _temp2 = wfdocpath.substring(wfdocpath.indexOf(',')+1,wfdocpath.lastIndexOf(','));
	      String _temp3 = wfdocpath.substring(wfdocpath.lastIndexOf(',')+1,wfdocpath.length());
	      String tempName = SubCCI.getSubCategoryname(_temp2);
	      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
	      //if(!_temp1.equals(""))
	      //wfdocpathspan="/"+MainCCI.getMainCategoryname(_temp1)+"/"+tempName+"/"+SecCCI.getSecCategoryname(_temp3);
	      wfdocpathspan = SecCCI.getAllParentName(_temp3,true);
    	}catch(Exception e){
    		if(wfdocpath.indexOf(",")==-1){
    			wfdocpathspan = SecCCI.getAllParentName(wfdocpath,true);
    		}
    	}
    }

	 if(wfdocpath!=null && !wfdocpath.equals("")){
    	try{
	      String _temp1 = wfdocpath.substring(0,wfdocpath.indexOf(','));
	      String _temp2 = wfdocpath.substring(wfdocpath.indexOf(',')+1,wfdocpath.lastIndexOf(','));
	      String _temp3 = wfdocpath.substring(wfdocpath.lastIndexOf(',')+1,wfdocpath.length());
	      String tempName = SubCCI.getSubCategoryname(_temp2);
	      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
	      //if(!_temp1.equals(""))
	      //wfdocpathspan="/"+MainCCI.getMainCategoryname(_temp1)+"/"+tempName+"/"+SecCCI.getSecCategoryname(_temp3);
	      wfdocpathspan = SecCCI.getAllParentName(_temp3,true);
    	}catch(Exception e){
    		if(wfdocpath.indexOf(",")==-1){
    			wfdocpathspan = SecCCI.getAllParentName(wfdocpath,true);
    		}
    	}
    }

    if(isbill.equals("1")){//判断是不是新创建的表单
        String tablename = "";
        RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
        if(RecordSet.next()) tablename = RecordSet.getString("tablename");
        if(tablename.equals("formtable_main_"+formid*(-1))) isnewform = true;
    }
    if(isnewform){
        RecordSet.executeSql("select count(id) from workflow_billfield where fieldhtmltype=3 and type=141 and billid="+formid);
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0)
                isdocRightByHrmResource=true;
        }
    }else{
        RecordSet.executeSql("select count(d.id) from workflow_base b, workflow_formfield c, workflow_formdict d where b.id="+wfid+" and b.isbill=0 and b.formid=c.formid and c.fieldid=d.id and d.fieldhtmltype=3 and d.type=141");
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0)
                isdocRightByHrmResource=true;
        }
    }
    	boolean isHasTestRequest = testWorkflowCheck.isHasTestRequest(wfid);
    	if(isHasTestRequest == true){
    		isvalidStr = " onchange=\"docheckisvalid(this)\" ";
    	}
	}
	
if(templateid>0){
    WFManager.reset();
    WFManager.setWfid(templateid);
	WFManager.getWfInfo();
	templatename=WFManager.getWfname();
}
    String endaffirmances = "";
    String endShowCharts = "";
    RecordSet.executeSql("select * from workflow_billfunctionlist");
    while (RecordSet.next()) {
        String _billid=RecordSet.getString("billid");
        String _indaffirmance = Util.null2String(RecordSet.getString("indaffirmance"));
        String _indShowChart = Util.null2String(RecordSet.getString("indShowChart"));
        if (!_indaffirmance.equals("1")) {
            if(endaffirmances.equals("")) endaffirmances=_billid;
            else endaffirmances += "," + _billid;
        }
        if (!_indShowChart.equals("1")) {
            if(endShowCharts.equals("")) endShowCharts=_billid;
            else endShowCharts += "," + _billid;
        }
    }
    if(!endaffirmances.equals("")) endaffirmances=","+endaffirmances+",";
    if(!endShowCharts.equals("")) endShowCharts=","+endShowCharts+",";
    boolean indaffirmance = true;
    boolean indShowChart = true;
    if(isbill.equals("1")){
        indaffirmance=endaffirmances.indexOf(","+formid+",")>-1?false:true;
        indShowChart=endShowCharts.indexOf(","+formid+",")>-1?false:true;
    }

	//Start 手机推送接口功能  by alan on 2009-12-03
    boolean isMgms = false;
    RecordSet.executeSql("SELECT workflowid FROM workflow_mgmsworkflows WHERE workflowid="+wfid);
    if(RecordSet.next()){
    	isMgms = !Util.null2String(RecordSet.getString("workflowid")).equals("");
    }
    boolean EnableMobile = Util.null2String(Prop.getPropValue("mgms" , "mgms.on")).toUpperCase().equals("Y");
    //End 手机推送接口功能

    String isOpenWorkflowImportDetail=GCONST.getWorkflowImportDetail();//是否启用流程明细表通过EXCEL导入配置
    String isOpenWorkflowSpecialApproval=GCONST.getWorkflowSpecialApproval();//是否启用启用流程特批件设置配置 
    String isOpenWorkflowReturnNode=GCONST.getWorkflowReturnNode();//是否启用流程退回时可选退回节点功能

if(!"".equals(nosynfields)){
	if(isbill.equals("1")){
		RecordSet.executeSql("select id as fieldid, fieldlabel, viewtype as isdetail from workflow_billfield where billid="+formid+" and id in ("+nosynfields+") order by dsporder asc");
	}else{
		//update by liaodong for qc60392 in 20130913 start 
		 //RecordSet.executeSql("select a.fieldid, b.fieldlable, a.isdetail from workflow_formfield a, workflow_fieldlable b  where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage()+" order by a.fieldorder asc ");
		 RecordSet.executeSql("select a.fieldid, b.fieldlable, a.isdetail from workflow_formfield a, workflow_fieldlable b  where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage()+" and  a.fieldid in("+nosynfields+") order by a.fieldorder asc ");
	   //end
	}
	while(RecordSet.next()){
		String fieldlablename = "";
		if(isbill.equals("1")){//单据无法将字段名称作为查询条件，在这里进行处理
			fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
		}else{
			fieldlablename = Util.null2String(RecordSet.getString("fieldlable"));
		}
		int isdetail_ = Util.getIntValue(RecordSet.getString("isdetail"), 0);
		String isdetailStr = "";
		if(isdetail_ == 1){
			isdetailStr = "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
		}
		nosynfieldsStr = nosynfieldsStr + fieldlablename + isdetailStr + ",";
	}
	if(!"".equals(nosynfieldsStr)){
		nosynfieldsStr = nosynfieldsStr.substring(0, nosynfieldsStr.length()-1);
	}
}
%>

<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+":";
if(isTemplate.equals("1")){
    titlename = SystemEnv.getHtmlLabelName(17857,user.getLanguage())+":";
}
if(type.equals("addwf")){
    titlename +=SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else{
    titlename +=SystemEnv.getHtmlLabelName(93,user.getLanguage());
}
String needfav ="";
String needhelp ="";
%>
</head>

<body style='display:none;'>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
    if(isSaveas==1)
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:copytemplate(this),_self} " ; 
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    if(!type.equals("addwf")){
	    if(!ajax.equals("1"))
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",/workflow/workflow/addwf0.jsp?isTemplate=1&isSaveas=1&ajax="+ajax+"&templateid="+wfid+",_self} " ;
	    else
	    {
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",javascript:Savetemplate("+wfid+"),_self} " ;
		    RCMenuHeight += RCMenuHeightStep;
		    //是否开启流程导入导出
		    if(GCONST.isWorkflowIsOpenIOrE())
		    {
		    	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"xml,javascript:exportWorkflow("+wfid+"),_self} " ;
		    	RCMenuHeight += RCMenuHeightStep;
		    }
	    }
    }
    
    if(!ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:weaver.reset(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelName(125059, user.getLanguage())+", javascript:saveAsWorkflow("+wfid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}
%>


<form name="weaver" id="weaver" method="post" action="wf_operation.jsp">
<input type="hidden" name="endaffirmances" id="endaffirmances" value="<%=endaffirmances%>">
<input type="hidden" name="endShowCharts" id="endShowCharts" value="<%=endShowCharts%>">
<%
if(ajax.equals("1")){
%>
<input type=hidden name="ajax" value="1">
<%}%>
<%
if(type.equals("editwf")&&operatelevel>0){
%>
<%
    if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+",Editwfnode.jsp?wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(261,user.getLanguage())+",addwfnodefield.jsp?wfid="+wfid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15587,user.getLanguage())+",addwfnodeportal.jsp?wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }
%>

<%
}
%>

<%
    if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",managewf.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
    if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=85 and relatedid="+wfid+",_self} " ;   
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=85 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;
    }
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) && wfid>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2118,user.getLanguage())+SystemEnv.getHtmlLabelName(17688,user.getLanguage())+",javascript:doShowBaseData("+wfid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
String tempbasicA =  "<a name='basicA'>"+SystemEnv.getHtmlLabelName(1361,user.getLanguage())+"</a>";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout type="2col">
	<wea:group context="<%=tempbasicA%>">
		<wea:item>
		    <%if(!isTemplate.equals("1")){%>
		    	<%=SystemEnv.getHtmlLabelName(23753,user.getLanguage())%>
		    <%}else{%>
		    	<%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%>
		    <%}%>		
		</wea:item>
		<wea:item>
			<wea:required id="wfnamespan" required="true" value='<%=wfname %>'>
				<input class=Inputstyle type="text" name="wfname" size="40" onChange="checkinput('wfname','wfnamespan')" maxlength="50" value="<%=wfname%>">
			</wea:required>
		</wea:item>
		<%if(!type.equals("editwf")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(18167,user.getLanguage())%></wea:item>
		<wea:item>
	  		<brow:browser name="templateid" viewType="0" hasBrowser="true" hasAdd="false" 
	                  browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=1" isMustInput="1" isSingle="true" hasInput="true"
	                  completeUrl="/data.jsp?type=workflowBrowser&isTemplate=1"  width="150px" browserValue='<%=templateid+""%>' browserSpanValue='<%=templatename%>'/>		
		</wea:item>
		<%}%>
		<%if(isSaveas!=1){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></wea:item>
		<wea:item>
		    <select class=inputstyle  name=typeid style="width:275px;">
		    <%
		    while(WorkTypeComInfo.next()){
		     	String checktmp = "";
		     	if(typeid == Util.getIntValue(WorkTypeComInfo.getWorkTypeid()))
		     		checktmp=" selected";
			%>
				<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
			<%}%>
		    </select>  		
		</wea:item>
		<%} %>	
		<%if(detachable==1){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		<wea:item>
            <%if(operatelevel>0){%>
            <brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
                  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1" isMustInput="2" isSingle="true" hasInput="true"
                  completeUrl="/data.jsp?type=164"  width="150px" browserValue='<%=String.valueOf(subCompanyId2)%>' browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>'/>
            <%}else{%>
            <span id=subcompanyspan> <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>
                <%if(String.valueOf(subCompanyId2).equals("")){%>
                    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                <%}%>
            </span>
            <input class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subCompanyId2%>">
        	<%} %>		
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></wea:item>
		<wea:item>
			<textarea rows="3" class=Inputstyle name="wfdes" cols="44" style="resize:none;"><%=wfdes%></textarea>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15600, user.getLanguage())%></wea:item>
		<wea:item>
		    <select class=inputstyle  name=isbill style="width:120px;float: left;" onchange="onchangeisbill(this.value)">
		    <option value=3 <%if(isbill.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(557, user.getLanguage())%></option>
		    <option value=0 <%if(isbill.equals("0")||isnewform){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
		    <option value=1 <%if(isbill.equals("1")&&!isnewform){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
		    </select>
		    <%
		    String bname = "";
		    if(isbill.equals("1")) {
		    	RecordSet.executeSql("select * from workflow_bill where id="+formid);
				if(RecordSet.next()){
					int tmplable = RecordSet.getInt("namelabel");
					bname = SystemEnv.getHtmlLabelName(tmplable,user.getLanguage());
				}
		    }else{
		    	bname=FormComInfo.getFormname(""+formid);
		    }
			%>
			<span id="showFormSpan" <%if(!isbill.equals("0") && !isbill.equals("1")){%> style="display:none;" <%}%>>
			<brow:browser name="formid" viewType="0" hasBrowser="true" hasAdd="false" 
		                 browserOnClick="onShowFormSelect(isbill.value, 'formid', 'formidspan')" isMustInput="2" isSingle="true" hasInput="true"
		                 completeUrl="javascript:getformajaxurl()"  width="150px" browserValue='<%=String.valueOf(formid)%>' browserSpanValue='<%=bname%>' />	
			</span>
		    <%if(ajax.equals("1")){%>
		    <font color="red"><%=SystemEnv.getHtmlLabelName(18720,user.getLanguage())%><a href="#" onclick="toformtab()" style="color:blue;TEXT-DECORATION:none"><b><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></b></a><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></font>  
		    <%}%>		
		</wea:item>
		<%if(!isTemplate.equals("1")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(31485,user.getLanguage())%></wea:item>
		<wea:item>
		    <select id="isvalid" name="isvalid" <%=isvalidStr%>>
	        <%
	        if(!isvalid.equals("3")) {
	        %>
	        <option value="0" <% if(!isvalid.equals("1")&&!isvalid.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
	        <option value="1" <% if(isvalid.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
	        <option value="2" <% if(isvalid.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%></option>
	        <%
	        } else {
	        %>
	        <option value="3" <% if(isvalid.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18500, user.getLanguage()) %></option>
	        <%}%>
		    </select>
			<input type="hidden" id="oldisvalid" name="oldisvalid" value="<%=isvalid%>">		
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="helpdocid" viewType="0" hasBrowser="true" hasAdd="false" 
		              browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
		              completeUrl="/data.jsp?type=9"  linkUrl="/docs/docs/DocDsp.jsp" width="150px" browserValue='<%=String.valueOf(helpdocid)%>' browserSpanValue='<%=Util.toScreen(DocComInfo.getDocname(""+helpdocid),user.getLanguage())%>' />		
		</wea:item>
	</wea:group>
	<wea:group context="<a name='messageB'><%=SystemEnv.getHtmlLabelName(21946, user.getLanguage())%></a>">
		<wea:item><%=SystemEnv.getHtmlLabelName(31487,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="messageType" tzCheckbox="true" value="1" <% if(messageType.equals("1")) {%> checked <%}%> onclick="ShowORHidden(this,'smsAlertsTypeShow',this)">
		</wea:item>
		<%
			String smsAlertsTypeShow = "{'samePair':'smsAlertsTypeShow','display':''}";
			if(!messageType.equals("1")) smsAlertsTypeShow = "{'samePair':'smsAlertsTypeShow','display':'none'}";
		%>
		<wea:item attributes='<%=smsAlertsTypeShow %>'><%=SystemEnv.getHtmlLabelName(21976,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=smsAlertsTypeShow %>'>
			<select id="smsAlertsType" name="smsAlertsType">
				<option value="0" <% if(smsAlertsType.equals("0")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%></option>
				<option value="1" <% if(smsAlertsType.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%></option>
				<option value="2" <% if(smsAlertsType.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%></option>
			</select> 			
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31488,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="mailMessageType" tzCheckbox="true" value="1" <% if(mailMessageType.equals("1")) {%> checked <%}%>>
		</wea:item>
		<% 
			String archiveNoMsgAlertTr="{'samePair':'archiveNoMsgAlertTr','display':''}"; 
			String archiveNoMailAlertTr = "{'samePair':'archiveNoMailAlertTr','display':''}"; 
			if(!"1".equals(messageType)) archiveNoMsgAlertTr = "{'samePair':'archiveNoMsgAlertTr','display':'none'}";
			if(!"1".equals(mailMessageType)) archiveNoMailAlertTr = "{'samePair':'archiveNoMailAlertTr','display':'none'}";
			
		%>
		<wea:item attributes='<%=archiveNoMsgAlertTr %>'><%=SystemEnv.getHtmlLabelName(32162, user.getLanguage())%></wea:item>
		<wea:item attributes='<%=archiveNoMsgAlertTr %>'>
			<input type=checkbox name="archiveNoMsgAlert" tzCheckbox="true" value="1" <% if("1".equals(archiveNoMsgAlert)) {%> checked <%}%>>
		</wea:item>
		<wea:item attributes='<%=archiveNoMailAlertTr %>'><%=SystemEnv.getHtmlLabelName(32163, user.getLanguage())%></wea:item>
		<wea:item attributes='<%=archiveNoMailAlertTr %>'>
			<input type=checkbox name="archiveNoMailAlert" tzCheckbox="true" value="1" <% if("1".equals(archiveNoMailAlert)) {%> checked <%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31489,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isaffirmance" tzCheckbox="true" value="1" <% if(isaffirmance.equals("1")) {%> checked <%}%> <%if(!indaffirmance){%>disabled <%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31490,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isShowChart" tzCheckbox="true" value="1" <% if(isShowChart.equals("1")) {%> checked <%}%> <%if(!indShowChart){%>disabled<%}%>>
		</wea:item>
	</wea:group>
	<wea:group context="<a name='corC'><%=SystemEnv.getHtmlLabelName(32383, user.getLanguage())%></a>">
		<wea:item><%=SystemEnv.getHtmlLabelName(32160, user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isSaveCheckForm" tzCheckbox="true"  value="1" <% if("1".equals(isSaveCheckForm)) {%> checked <%}%>>
		</wea:item>
		<%if(EnableMobile){%> 
		<wea:item><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox tzCheckbox="true" name="isMgms" value="1" <% if(isMgms) {%> checked <%}%>></wea:item>
		<%}else{%>
		<input type=hidden name="isMgms" value="<%if(isMgms){%>1<%}%>">
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(31486,user.getLanguage())%></wea:item> 
		<wea:item>
			<input type=checkbox name="defaultName" tzCheckbox="true" value="1" <% if(defaultName.equals("1")) {%> checked <%}%>>
		</wea:item>
		<%if(formid != 180){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(31491,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox name="multiSubmit" tzCheckbox="true" value="1" <% if(multiSubmit.equals("1")) {%> checked <%}%>></wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(31492,user.getLanguage())%></wea:item>	
		<wea:item><input type=checkbox name="isforwardrights" tzCheckbox="true" value="1" <% if(isforwardrights.equals("1")) {%> checked <%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31493,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox name="isModifyLog" tzCheckbox="true" value="1" <% if(isModifyLog.equals("1")) {%> checked <%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31495,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox tzCheckbox="true" name="docRightByOperator" value="1" <% if(docRightByOperator.equals("1")) {%> checked <%}%>></wea:item>
		<%
			String isOpenWorkflowImportDetailShow = "{'display':''}";
			if(!isOpenWorkflowImportDetail.equals("1")) isOpenWorkflowImportDetailShow = "{'display':'none'}";
		 %>		
		<wea:item attributes='<%=isOpenWorkflowImportDetailShow %>'><%=SystemEnv.getHtmlLabelName(26254,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=isOpenWorkflowImportDetailShow %>'>
	    <% 
		  //如果不是系统单据,就出现允许明细导入的配置
		 if(!("1".equals(isbill)&&formid>0)){%>
				 <input type=checkbox tzCheckbox="true" name="isImportDetail" id="isImportDetail" value="1" onclick="isImportDetailChanged();" <%if("1".equals(isImportDetail) || "2".equals(isImportDetail)) {%> checked <%}%>> 
				 <input type=checkbox tzCheckbox="false" id='isImportDetail_fake' style='display:none' disabled='true'>
				 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <select id="importDetailType" class="inputstyle" onChange="importDetailTypeChanged();" <%if(!"1".equals(isImportDetail) && !"2".equals(isImportDetail)) {%>style="display:none"<%}%>>
				 	<option <% if("1".equals(isImportDetail)) {%>selected<%}%> value="1"><%=SystemEnv.getHtmlLabelName(33844,user.getLanguage())%></option>
				 	<option <% if("2".equals(isImportDetail)) {%>selected<%}%> value="2"><%=SystemEnv.getHtmlLabelName(33845,user.getLanguage())%></option>
				 </select>
		<%}else{%>
				 <input type=checkbox tzCheckbox="false" name="isImportDetail" id="isImportDetail" style='display:none' value="1" onchange="isImportDetailChanged();" <%if("1".equals(isImportDetail) || "2".equals(isImportDetail)) {%> checked <%}%>> 
				 <input type=checkbox tzCheckbox="true" id='isImportDetail_fake' style='display:inline' disabled='true'>
				 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <select id="importDetailType" notBeauty="true" class="inputstyle" style="display:none" onChange="importDetailTypeChanged();">
				 	<option value="1"><%=SystemEnv.getHtmlLabelName(33844,user.getLanguage())%></option>
				 	<option value="2"><%=SystemEnv.getHtmlLabelName(33845,user.getLanguage())%></option>
				 </select> 
		<%}%>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31499,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isimportwf" tzCheckbox="true" value="1" <% if(isimportwf.equals("1")) {%> checked <%}%>>
		</wea:item>
		<%if(isdocRightByHrmResource){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(19321,user.getLanguage())%></wea:item>
			<wea:item>
				<input type=checkbox name="docRightByHrmResource" tzCheckbox="true" value="1" <% if(docRightByHrmResource == 1){%> checked <%}%>>
			</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(19501, user.getLanguage())%></wea:item>		
		<wea:item><button type="button" class=Browser  onClick="wfTitleSet()"></button></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125048, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(24621,user.getLanguage())%>)</wea:item>
		<wea:item>
			<brow:browser name="newdocpath" viewType="0" hasBrowser="true" hasAdd="false" 
			                browserOnClick="onShowDocCatalog('newdocpathspan')" isMustInput="1" isSingle="true" hasInput="true"
			                completeUrl="/data.jsp?type=categoryBrowser"  width="300px" browserValue='<%=newdocpath%>' browserSpanValue='<%=newdocpathspan%>' />		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(28064,user.getLanguage())%></wea:item>
		<wea:item>
			<% String completeUrl="/data.jsp?type=fieldBrowser&wfid="+wfid; %>
			<brow:browser name="nosynfields" viewType="0" hasBrowser="true" hasAdd="false" 
	                  browserOnClick="showNoSynFields('nosynfields', 'nosynfieldsspan')" isMustInput="1" isSingle="false" hasInput="true"
	                  completeUrl='<%=completeUrl %>' isAutoComplete="false" width="150px" browserValue='<%=nosynfields%>' browserSpanValue='<%=nosynfieldsStr%>' />	
			&nbsp;&nbsp;<font color="red"><%=SystemEnv.getHtmlLabelName(28065,user.getLanguage())%></font>		
		</wea:item>
		<%if(isOpenWorkflowSpecialApproval.equals("1")){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(26007,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27566,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="specialApproval" tzCheckbox="true" value="1" onclick="ShowORHidden2(this)" <% if(specialApproval.equals("1")) {%> checked <%}%> >
		</wea:item>
		<%
			String Frequencytr = "{'samePair':'Frequencytr','display':''}";
			String Cycletr = "{'samePair':'Cycletr','display':''}";
			if(!"1".equals(specialApproval)){
				 Frequencytr = "{'samePair':'Frequencytr','display':'none'}";
				 Cycletr = "{'samePair':'Cycletr','display':'none'}";
			}			
		 %>
		<wea:item attributes='<%=Frequencytr %>'><%=SystemEnv.getHtmlLabelName(26755,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=Frequencytr %>'>
			<input type=text name="Frequency" value="<%=Frequency %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" maxLength=10 size=10>
		</wea:item>
		<wea:item attributes='<%=Cycletr %>'><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=Cycletr %>'>
			<select id=selCycle name="Cycle">
				<option value=1 <%if(Cycle.equals("1")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%></option>
				<option value=2 <%if(Cycle.equals("2")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
				<option value=3 <%if(Cycle.equals("3")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
				<option value=4 <%if(Cycle.equals("4")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
				<option value=5 <%if(Cycle.equals("5")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
			</select>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(125047, user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%>)</wea:item>
		<wea:item>
		    <select class=inputstyle  name = iscust onchange="onchangeiscust(this.value)">
		    	<option value=0 <%if(iscust.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%></option>
		    	<option value=1 <%if(iscust.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%></option>
		    </select>		
		</wea:item>
		<%if("1".equals(IsOpetype)){%>
		<wea:item>SAP<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="SAPSource" id="SAPSource">
				<option value=""></option>
				<%
				RecordSet.executeSql("select * from SAPCONN");
				while(RecordSet.next()){
					String code = RecordSet.getString("code");
				%>
					<option value="<%=code%>" <%if(SAPSource.equals(code)){%>selected<%}%>><%=code%></option>
				<%}%>	
			</select>		
		</wea:item>
		<%}%>
		<%if(formid == 156 || formid == 158){ %>
			
			<%
				String isfnacontrol = "";
				String fnanodeid = "";
				String fnadepartmentid = "";
				
				String fnanodenamestr = "";
				String fnadepartmentnamestr = "";
				
				RecordSet.executeSql("select isfnacontrol,fnanodeid,fnadepartmentid from workflow_base where id="+wfid);
				if(RecordSet.next()){
					isfnacontrol = Util.null2String(RecordSet.getString("isfnacontrol"));
					fnanodeid = Util.null2String(RecordSet.getString("fnanodeid"));
					fnadepartmentid = Util.null2String(RecordSet.getString("fnadepartmentid"));
				}
				
				if(!fnanodeid.equals("")){
					ArrayList fnanodeidlist = Util.TokenizerString(fnanodeid,",");
					for(int z=0;z<fnanodeidlist.size();z++){
						RecordSet.executeSql("select nodename from workflow_nodebase where id="+(String)fnanodeidlist.get(z));
						if(RecordSet.next()){
							fnanodenamestr += Util.null2String(RecordSet.getString("nodename")) + "&nbsp;,";
						}
					}
					if(!"".equals(fnanodenamestr)){
						fnanodenamestr = fnanodenamestr.substring(0, fnanodenamestr.length()-1);
					}
				}
				
				
				if(!fnadepartmentid.equals("")){
					ArrayList departmentlist = Util.TokenizerString(fnadepartmentid,",");
					for(int p=0;p<departmentlist.size();p++){
						fnadepartmentnamestr += DepartmentComInfo.getDepartmentname((String)departmentlist.get(p)) + "&nbsp;,";
					}
					if(!"".equals(fnadepartmentnamestr)){
						fnadepartmentnamestr = fnadepartmentnamestr.substring(0, fnadepartmentnamestr.length()-1);
					}
				}
				
				String fnanodeidtr = "{'samePair':'fnanodeidtr','display':''}";
				String fnadepartmentidtr = "{'samePair':'fnadepartmentidtr','display':''}";
				if(!"1".equals(isfnacontrol)){
					fnanodeidtr = "{'samePair':'fnanodeidtr','display':'none'}";
					fnadepartmentidtr = "{'samePair':'fnadepartmentidtr','display':'none'}";
				}
			 %>
			 <wea:item><%=SystemEnv.getHtmlLabelName(81460,user.getLanguage())%></wea:item>
			 <wea:item>
			 	<input type=checkbox name="isfnacontrol" tzCheckbox="true" onclick="ShowFnaHidden(this,'fnanodeidtr','fnadepartmentidtr');" value="1" <% if(isfnacontrol.equals("1")) {%> checked <%}%> >
			 </wea:item>
			 <wea:item attributes='<%=fnanodeidtr %>'><%=SystemEnv.getHtmlLabelName(81461,user.getLanguage())%></wea:item>
			 <wea:item attributes='<%=fnanodeidtr %>'>
			 		<button type="button" class=Browser onClick="onShowFnaNodes(fnanodeid,fnanodespan,<%=wfid%>)"></button>
					<span id=fnanodespan><%=fnanodenamestr%></span>
					<input class=inputstyle type=hidden id=fnanodeid name=fnanodeid value="<%=fnanodeid%>">
			 </wea:item>
			 <wea:item attributes='<%=fnadepartmentidtr %>'><%=SystemEnv.getHtmlLabelName(81462,user.getLanguage())%></wea:item>
			 <wea:item attributes='<%=fnadepartmentidtr %>'>
			 		<button class=Browser type="button" onClick="onShowDepartment()"></button>
		            <span id=fnadepartmentspan><%=fnadepartmentnamestr%></span>
		            <input class=inputstyle type=hidden id=fnadepartmentid name=fnadepartmentid value="<%=fnadepartmentid%>">
			 </wea:item>
		<%}%>  		
	</wea:group>
	<wea:group context="<a name='FUJIAN'><%=SystemEnv.getHtmlLabelName(23796, user.getLanguage())%></a>">
		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
		<wea:item>
		    <select class=inputstyle id=catalogtype name=catalogtype onchange="switchCataLogType(this.value)" style="float: left;width:100px;">
		    <option value=0 <%if(catelogType == 0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19213,user.getLanguage())%></option>
		    <option value=1 <%if(catelogType == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%></option>
		    </select>&nbsp;
			<%
			    String sqlSelectCatalog=null;
				int tempFieldId=0;
				if("1".equals(isbill)){
					sqlSelectCatalog = "select formField.id,fieldLable.labelName as fieldLable "
			                         + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
			                         + "where fieldLable.indexId=formField.fieldLabel "
			                         + "  and formField.billId= " + formid
			                         + "  and formField.viewType=0 "
			                         + "  and fieldLable.languageid =" + user.getLanguage()
						             + "  and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
				}else{
					sqlSelectCatalog = "select formDict.ID, fieldLable.fieldLable "
			                         + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
			                         + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
			                         + "and formField.formid = " + formid
			                         + " and fieldLable.langurageid = " + user.getLanguage()
						             + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
				}
			%>
		    	<select class=inputstyle id=selectcatalog <%if(catelogType == 0){%>style="display:none;width:300px;"<%}%> name=selectcatalog>
		    <%			
				RecordSet.executeSql(sqlSelectCatalog);
				while(RecordSet.next()){
					tempFieldId = RecordSet.getInt("ID");
			%>
		        	<option value=<%= tempFieldId %> <% if(tempFieldId == selectedCateLog) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></option>
		    <%}%>
		    </select>&nbsp;
		    <span id=mypath <%if(catelogType == 1){%>style="display:none"<%}%> >
			<brow:browser name="pathcategory" viewType="0" hasBrowser="true" hasAdd="false" 
			                browserOnClick="onShowCatalog('pathcategoryspan')" isMustInput="1" isSingle="true" hasInput="true"
			                completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData" width="300px" browserValue='<%=docPath%>' browserSpanValue='<%=docPath%>' /> 	
			</span>
		    <input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
		    <input type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
		    <input type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22944,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox name="candelacc" tzCheckbox="true" value="1" <%if(candelacc.equals("1")){%>checked<%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31494,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" <% if(isneeddelacc.equals("1")) {%> checked <%}%> name="isneeddelacc" value="1">
	      	&nbsp;&nbsp;&nbsp;
	      	<span style="color:#ff0000"><%=SystemEnv.getHtmlLabelName(28572,user.getLanguage())%></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(27025,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox name="forbidAttDownload" tzCheckbox="true" value="1" <% if(forbidAttDownload.equals("1")) {%> checked <%}%>></wea:item>
	</wea:group>
	<wea:group context="<a name='TUIHUI'><%=SystemEnv.getHtmlLabelName(84508, user.getLanguage())%></a>">
		<wea:item><%=SystemEnv.getHtmlLabelName(31497,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isrejectremind" tzCheckbox="true" value="1" <% if(isrejectremind.equals("1")) {%> checked <%}%> onclick="rejectremindChange(this,'ischangrejectnode')">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31498,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="ischangrejectnode" tzCheckbox="true" value="1" <% if(isrejectremind.equals("1")&&ischangrejectnode.equals("1")) {%> checked <%} if(!isrejectremind.equals("1")){%> disabled <%}%> >
		</wea:item>
		<%
			String isselectrejectnodeShow = "{'samePair':'isselectrejectnodeShow','display':''}";
			if(!isOpenWorkflowReturnNode.equals("1")) isselectrejectnodeShow = "{'samePair':'isselectrejectnodeShow','display':'none'}";
		 %>
		<wea:item attributes='<%=isselectrejectnodeShow %>'><%=SystemEnv.getHtmlLabelName(26435,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=isselectrejectnodeShow %>'>
			<input type=checkbox name="isselectrejectnode" tzCheckbox="true" value="1" <% if(isselectrejectnode.equals("1")) {%> checked<%}%> >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31496,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="ShowDelButtonByReject" tzCheckbox="true" value="1" <% if(ShowDelButtonByReject.equals("1")) {%> checked <%}%>>
		</wea:item>
	</wea:group>
	<wea:group context="<a name='QIANZI'><%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%></a>">
		<wea:item><%=SystemEnv.getHtmlLabelName(21603,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=orderbytype name=orderbytype onchange="changeOrderShow()" style="width: 100px;">
		    	<option value=1 <%if("1".equals(orderbytype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%></option>
		    	<option value=2 <%if("2".equals(orderbytype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%></option>
		    </select>&nbsp;&nbsp;
			<span id=orderShowSpan>
				<%if("2".equals(orderbytype)){%>
				<%=SystemEnv.getHtmlLabelName(21628,user.getLanguage())%>
				<%}else{%>
				<%=SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>
				<%}%>
			</span>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31500,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="issignview" tzCheckbox="true" value="1" <% if(issignview.equals("1")) {%> checked <%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23726,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isSignDoc" tzCheckbox="true" value="1" <% if("1".equals(isSignDoc)) {%> checked <%}%> onclick="ShowORHidden(this,'isSignDoctr','showDocTab')">
		</wea:item>
		<%
			String isSignDoctr = "{'samePair':'isSignDoctr','display':''}";
			if(!"1".equals(isSignDoc)) isSignDoctr = "{'samePair':'isSignDoctr','display':'none'}";
		 %>
		<wea:item attributes='<%=isSignDoctr %>'><%=SystemEnv.getHtmlLabelName(23728,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=isSignDoctr %>'>
		 	<input type=checkbox name="showDocTab" tzCheckbox="true" value="1" <% if(showDocTab.equals("1")) {%> checked <%}%>>
		</wea:item>	 
		<wea:item><%=SystemEnv.getHtmlLabelName(23727,user.getLanguage())%></wea:item>
		<wea:item>
		<input type=checkbox name="isSignWorkflow" tzCheckbox="true" value="1" <% if("1".equals(isSignWorkflow)) {%> checked <%}%> onclick="ShowORHidden(this,'isSignWorkflowtr','showWorkflowTab')">
		</wea:item>
		<%
		String isSignWorkflowtr = "{'samePair':'isSignWorkflowtr','display':''}";
		if(!"1".equals(isSignWorkflow)) isSignWorkflowtr = "{'samePair':'isSignWorkflowtr','display':'none'}";
		%>
		<wea:item attributes='<%=isSignWorkflowtr %>'><%=SystemEnv.getHtmlLabelName(23729,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=isSignWorkflowtr %>'>
			<input type=checkbox name="showWorkflowTab" tzCheckbox="true" value="1" <% if(showWorkflowTab.equals("1")) {%> checked <%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21417,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isannexUpload" tzCheckbox="true" value="1" <% if("1".equals(isannexUpload)) {%> checked <%}%> onclick="ShowAnnexUpload(this,'annxtCategorytr','showuploadtabtr','showUploadTab')">
		</wea:item>
		<%
			String 	annxtCategorytr = "{'samePair':'annxtCategorytr','display':''}";
			if(!"1".equals(isannexUpload)) annxtCategorytr = "{'samePair':'annxtCategorytr','display':'none'}";
		%>
		<wea:item attributes='<%=annxtCategorytr %>'><%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=annxtCategorytr %>'>
			<brow:browser name="annexseccategory" viewType="0" hasBrowser="true" hasAdd="false" 
			              browserOnClick="onShowAnnexCatalog('annexseccategoryspan')" isMustInput="1" isSingle="true" hasInput="true"
			              completeUrl="/data.jsp?type=categoryBrowser" _callback="annexseccategoryData" width="300px" browserValue='<%=annexseccategory%>' browserSpanValue='<%=annexdocPath%>' />    
			<input type=hidden id='annexmaincategory' name='annexmaincategory' value="<%=annexmaincategory%>">
			<input type=hidden id='annexsubcategory' name='annexsubcategory' value="<%=annexsubcategory%>">		
		</wea:item>
		<%
			String showuploadtabtr = "{'samePair':'showuploadtabtr','display':''}";
			if(!"1".equals(isannexUpload)) showuploadtabtr = "{'samePair':'showuploadtabtr','display':'none'}";
		%>
		<wea:item attributes='<%=showuploadtabtr %>'><%=SystemEnv.getHtmlLabelName(23725,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=showuploadtabtr %>'><input type=checkbox name="showUploadTab" tzCheckbox="true" value="1" <% if(showUploadTab.equals("1")) {%> checked <%}%>></wea:item>
	</wea:group>
</wea:layout>
<table class="viewform">
  <input type="hidden" value="<%=type%>" name="src">
  <input type="hidden" value=<%=wfid%> name="wfid">
  <input type="hidden" name="oldtypeid" value="<%=typeid%>">
  <input type="hidden" name="oldiscust" value="<%=iscust%>">
  <input type="hidden" name="oldisbill" value="<%=isbill%>">
  <input type="hidden" name="oldformid" value="<%=formid%>">
  <input type="hidden" name="isTemplate" value="<%=isTemplate%>">
</table>
<div id="addwf1div" name="addwf1div" <%if(isSaveas==1){%>style="display:none" <%}else{%>style="display:''"<%}%>></div>
</form>

<script type="text/javascript">

//以下隐藏不必要的操作栏

var messagebox=$("a[name='messageB']").parents(".intervalTR");
messagebox.hide();
messagebox.next().hide();
messagebox.next().next().hide();


messagebox=$("a[name='corC']").parents(".intervalTR");
messagebox.hide();
messagebox.next().hide();
messagebox.next().next().hide();

messagebox=$("a[name='TUIHUI']").parents(".intervalTR");
messagebox.hide();
messagebox.next().hide();
messagebox.next().next().hide();

messagebox=$("a[name='QIANZI']").parents(".intervalTR");
messagebox.hide();
messagebox.next().hide();
messagebox.next().next().hide();

var deleteattachtr=$("input[name='candelacc']").parent().parent();

deleteattachtr.hide();
deleteattachtr.next().hide();
deleteattachtr.next().next().hide();
deleteattachtr.next().next().next().hide();
deleteattachtr.next().next().next().next().hide();

$(document.body).show();




var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
</script>
<%
if(!ajax.equals("1")){
%>
<script language=javascript>
function onchangeisbill(objval){
   var oldval=$G("oldisbill").value;
   if(oldval!=3 && objval!=oldval){
       if(!confirm("<%=SystemEnv.getHtmlLabelName(18682,user.getLanguage())%>")){
            $G("isbill").value=$G("oldisbill").value;
       }       
   }
   objval=$G("isbill").value;
   if(objval!=3){
   		$("#showFormSpan").show();
   }else{
   		$("#showFormSpan").hide();
   }
   /**
   if(objval==0){
       $G("formid").style.display = '';
       $G("billid").style.display = 'none';
   }else{
      if(objval==1){
         $G("billid").style.display= '';
         $G("formid").style.display = 'none';
      }else{
         $G("formid").style.display = 'none';
         $G("billid").style.display = 'none';
      }
   }
   **/
}
function onchangeiscust(objval){
    var srctype=$G("src").value;
	if(srctype=="editwf"&&objval!=$G("oldiscust").value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18685,user.getLanguage())%>")){
            $G("iscust").value=$G("oldiscust").value;
        }
	}
}
function onchangeformid(objval){
    var oldisbillval=$G("oldisbill").value;
    var isbillval=$G("isbill").value;
	if(oldisbillval!=3 && objval!=$G("oldformid").value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
            $G("formid").value=$G("oldformid").value;
        }
	}
}
function onchangebillid(objval){
    var oldisbillval=$G("oldisbill").value;
    var isbillval=$G("isbill").value;
	if(oldisbillval!=3 && objval!=$G("oldformid").value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18684,user.getLanguage())%>")){
            $G("billid").value=$G("oldformid").value;
        }
	}
}

//modify by xhheng @20050204 for TD 1538
function submitData(obj){
	if (check_form($G("weaver"),'wfname,subcompanyid')){
		$G("weaver").submit();
        obj.disabled=true;
    }
}

function switchCataLogType(objval){
	objval=document.weaver.catalogtype.value;
    if(objval == 0){
		$("#selectcatalog").next().hide();
        $G("mypath").style.display = '';
    }else{
    	$("#selectcatalog").next().show();
        $G("mypath").style.display = 'none';
    }
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            $G(spanName).innerHTML= "<a href='#"+result[1]+"'>"+result[2]+"</a>";           
            $G("pathcategory").value=result[2];
            $G("maincategory").value=result[3];
            $G("subcategory").value=result[4];
            $G("seccategory").value=result[1];
        }
          <!--added xwj for td2048 on 2005-6-1 begin -->
        else{
            $G(spanName).innerHTML="";
            $G("pathcategory").value="";
            $G("maincategory").value="";
            $G("subcategory").value="";
            $G("seccategory").value="";
            }
        <!--added xwj for td2048 on 2005-6-1 end -->
    }
}

function onShowWfCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML=result[2];
            $G("wfdocpath").value=result[3]+","+result[4]+","+result[1];
        }
        else{
            spanName.innerHTML="";
            $G("wfdocpath").value="";
            }
    }
}
function onShowDocCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML="<a href='#'>" +result[2]+"</a>";
            $G("newdocpath").value=result[3]+","+result[4]+","+result[1];
        }
        else{
            spanName.innerHTML="";
            $G("newdocpath").value="";
            }
    }
}

function onShowWorkflow(inputname,spanname){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=1");
	//datas = json2Array(datas);
	if(datas){
	    if(datas.id!="") {
			$G(spanname).innerTML = datas.name;
			$G(inputname).value = datas.id;
	        $G("addwf0div").style.display="none";
	        $G("addwf1div").style.display="none";
	    }else{
	    	$G(spanname).innerHTML = "";
	    	$G(inputname).value="";
	    	$G("addwf0div").style.display="";
	    	$G("addwf1div").style.display="";
	   }
	}
}

function showDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	//datas = json2Array(datas);
	if(datas){
		weaver.helpdocid.value=datas.id+"";
		$("#Documentname").html("<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'>"+datas.name+"</a>");
	}
}

function onShowSubcompany(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+weaver.subcompanyid.value);
	//datas = json2Array(datas);
	issame = false;
	if (datas){
	if(datas.id!="0"&&datas.id!=""){
		if(datas.id == weaver.subcompanyid.value){
			issame = true;
		}
		$(subcompanyspan).html(datas.name);  //ypc 2012-09-24
		$GetEle("subcompanyid").value=datas.id;  //ypc 2012-09-24
	}
	else{
		$GetEle("subcompanyspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" ;//ypc 2012-09-24
		$GetEle("subcompanyid").value = "" ; //ypc 2012-09-24
	}
	}
}
</script>
<%}else {%>
<script type="text/javascript">
function showDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if(datas){
		$("input[name=helpdocid]").val(datas.id);
		$("#Documentname").html("<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'>"+datas.name+"</a>");
	}
}

function onShowDocCatalog(spanName) {
    var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (datas) {
        if (datas.tag > 0)  {
            $("#"+spanName).html("<a href='#"+datas.id+"'>"+datas.path+"</a>");
            $GetEle("newdocpath").value=datas.mainid+","+datas.subid+","+datas.id;
        }
        else{
        	$(spanName).html("");
            $GetEle("newdocpath").value="";
            }
    }
}

function showNoSynFields(inputname, spanname){
	var oldfields = $GetEle(inputname).value;
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape("/workflow/workflow/fieldMutilBrowser.jsp?workflowid=<%=wfid%>&oldfields="+oldfields));
	if(datas != null){
		if(datas[0]!=null && datas[0]!=""){
			$GetEle(inputname).value = datas[0];
			$GetEle(spanname).innerHTML = "<a href='#"+datas[0]+"'>"+datas[1]+"</a>";
		}else{
			$GetEle(inputname).value = "";
			$GetEle(spanname).innerHTML = "";
		}
	}
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    if (result) {
        if (result.tag>0)  {
           $G(spanName).innerHTML = "<a href='#"+result.id+"'>"+result.path+"</a>";
           $G("pathcategory").value = result.path;
           $G("maincategory").value=result.mainid;
           $G("subcategory").value=result.subid;
           $G("seccategory").value=result.id;
        }else{
           $G(spanName).innerHTML = "";
           $G("pathcategory").value="";
           $G("maincategory").value="";
           $G("subcategory").value="";
           $G("seccategory").value="";
        }
    }
}

function onShowCatalogData(event,datas,name,paras){
	var ids = datas.id;
	var idarr= new Array();
	idarr=ids.split(","); 
	$G("pathcategory").value = datas.name;
   	$G("maincategory").value=idarr[0];
    $G("subcategory").value=idarr[1];
    $G("seccategory").value=idarr[2];
}

function _userDelCallback(text,name){
	if(name=="pathcategory"){
		$G("pathcategory").value="";
	   	$G("maincategory").value="";
	    $G("subcategory").value="";
	    $G("seccategory").value="";	
	}else if(name=="annexseccategory"){
		$("#annexmaincategory").val("");
        $("#annexsubcategory").val("");
        $("#annexseccategory").val("");
	}
}
 
function  _userBeforeDelCallback(text,name){
	if(name=="formid"){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
	           $G("formid").value=$G("oldformid").value;	          
	           return false;
	    }
	}
	 return true;
}

function submitData(obj){
try{
	if(!checkLengtpointerCut("wfdes",'200',"<%=SystemEnv.getHtmlLabelName(15594, user.getLanguage())%>",'<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>')){
		return;
		}
}catch(e){}
    if (check_form(weaver,'wfname,subcompanyid')) {
        obj.disabled=true;
        var isbills=document.weaver.isbill.value;
        var iscust=document.weaver.iscust.value;
        var oldiscust=document.weaver.oldiscust.value;
		if(isbills == "1"){
			var billid_t = "";
			var formid_t = $G("formid").value;
			if(billid_t == ""){
				if (formid_t == ""){
					if (formid_t > 0 && billid_t == ""){
					} else {
						alert("<%=SystemEnv.getHtmlLabelName(27615,user.getLanguage())%>");
						obj.disabled=false;
						return;
					}							
				}
			}
		}else if(isbills == "0"){
			var formid_t = $G("formid").value;
			if(formid_t == ""){
				alert("<%=SystemEnv.getHtmlLabelName(27616,user.getLanguage())%>");
				obj.disabled=false;
				return;
			}
		}else{
			var _flag = $G("addwf0div").style.display;
			if("none" != _flag){
				alert("<%=SystemEnv.getHtmlLabelName(27617,user.getLanguage())%>");
				obj.disabled=false;
				return ;
			}
		}     
        weaver.submit();
		try{
        parent.parent.parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
		}catch(e){} // update by liaodong for qc52610 in 20130922
        //refreshAddwf("<%=wfid%>");
   }
}

function refreshAddwf(wfid1){
	var isbill1 = "";
	try{
		isbill1 = document.weaver.isbill.value;
	}catch(e){
		isbill1 = "";
	}
	if(isbill1 != ""){
		try{
			parent.parent.location.href = "addwf.jsp?ajax=1&src=editwf&wfid="+wfid1+"&isTemplate=<%=isTemplate%>";
		}catch(e){parent.parent.location.href = "addwf.jsp?ajax=1&src=editwf&wfid="+wfid1+"&isTemplate=<%=isTemplate%>";} // update by liaodong for qc52610 in 20130922
		
	}else{
		window.setTimeout(function(){refreshAddwf(wfid1);},100);
	}
}

function onchangeisbill(objval){
    var oldval=document.weaver.oldisbill.value;
    <%if (isnewform) {%>
    oldval = 0;//新表单
    <%}%>
    if(oldval!=3 && objval!=oldval){
       if(!confirm("<%=SystemEnv.getHtmlLabelName(18682, user.getLanguage())%>")){
            document.weaver.isbill.value=document.weaver.oldisbill.value;
       }
    }
    objval=$GetEle("isbill").value;
	if(objval==0){
		$("#showFormSpan").show();
		$("#formid").value = "";
		$("#formidspan").html("");
        $G("isaffirmance").disabled=false;
        $G("isShowChart").disabled=false;
        $G("isImportDetail").value = 1;
        $G("isImportDetail").style.display = '';
        $G("isImportDetail_fake").style.display = 'none'; 
	}else{
        if(objval==1){
        	$("#showFormSpan").show();
			$("#formid").value = "";
			$("#formidspan").html("");
            var endaffirmances=$GetEle("endaffirmances").value;
            var endShowCharts=$GetEle("endShowCharts").value;
            if(endaffirmances.indexOf(","+$G("formid").value+",")>-1){
                $GetEle("isaffirmance").checked=false;
                $GetEle("isaffirmance").disabled=true;
            }else{
                $GetEle("isaffirmance").disabled=false;
            }
            if(endShowCharts.indexOf(","+$G("formid").value+",")>-1){
                $GetEle("isShowChart").checked=false;
                $GetEle("isShowChart").disabled=true;
            }else{
                $GetEle("isShowChart").disabled=false;
            }
            $G("isImportDetail").value = 0;  
            $G("isImportDetail").style.display = 'none';
            $G("isImportDetail_fake").style.display = ''; 
        }else{
        	$("#showFormSpan").hide();
            $G("isaffirmance").disabled=false;
            $G("isShowChart").disabled=false;
			
            $G("isImportDetail").value = 1;
            $G("isImportDetail").style.display = '';
            $G("isImportDetail_fake").style.display = 'none';  
        }
    }
}

function onchangeformid(objval){
    var oldisbillval=document.weaver.oldisbill.value;
    var isbillval=document.weaver.isbill.value;
    <%if (isnewform) {%>
    oldisbillval = 0;//新表单
    <%}%>
	if(oldisbillval!=3 && isbillval==oldisbillval && objval!=document.weaver.oldformid.value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18683, user.getLanguage())%>")){
            document.weaver.formid.value=document.weaver.oldformid.value;
        }
	}
}

function onchangeiscust(objval){
    var srctype=document.weaver.src.value;
	if(srctype=="editwf"&&objval<document.weaver.oldiscust.value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18685, user.getLanguage())%>")){
            document.weaver.iscust.value=document.weaver.oldiscust.value;
        }
	}
}

function switchCataLogType(objval){
	objval=document.weaver.catalogtype.value;
    if(objval == 0){
		$("#selectcatalog").next().hide();
        document.all("mypath").style.display = '';
    }else{
    	$("#selectcatalog").next().show();
        document.all("mypath").style.display = 'none';
    }
}
</script>
<%} %>

<script type="text/javascript">
function onShowDepartment(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#fnadepartmentid").val());    
    if (data!=null){
		if (data.id != "" ){
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+names[i]+"&nbsp;&nbsp;";
				}
			}
			jQuery("#fnadepartmentspan").html(sHtml);
			jQuery("input[name=fnadepartmentid]").val(data.id.substr(1));
		}else{
			jQuery("#fnadepartmentspan").html("");
			jQuery("input[name=fnadepartmentid]").val("");
		}
	}
}

function onShowFnaNodes(inputName,spanName,workflowId){
	printNodes=inputName.value;
    tempUrl=escape("/workflow/workflow/WorkflowNodeBrowserMulti.jsp?printNodes="+printNodes+"&workflowId="+workflowId);
    var result =window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+tempUrl,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");

    if (result != null){
		if (result.id!=""){  
		    inputName.value=result.id;
		    spanName.innerHTML=result.name;
		}else{
		    inputName.value="0";
		    spanName.innerHTML="";
		}
    }
}

function ShowFnaHidden(obj,tr1name,tr2name){
    if(obj.checked){
        showEle(tr1name);
        showEle(tr2name);
    }else{
        hideEle(tr1name);
        hideEle(tr2name);
    }
}

var diag_saveaswf = null;
function Savetemplate(workflowids){
	window.location.href ="/workflow/workflow/addwf0.jsp?isTemplate=1&isSaveas=1&ajax=1&templateid="+workflowids;
}
function copytemplate(obj){
	if (check_form(weaver,'wfname,subcompanyid')) {
		  weaver.submit();
		obj.disabled=true;
		//parent.parent.wfleftFrame.location="wfmanage_left2.jsp?isTemplate=1";
   }
}
function exportWorkflow(workflowid){
	var xmlHttp = ajaxinit();
	xmlHttp.open("post","/workflow/export/wf_operationxml.jsp", true);
	var postStr = "src=export&wfid="+workflowid;
	xmlHttp.onreadystatechange = function () 
	{
		switch (xmlHttp.readyState) 
		{
		   case 4 : 
		   		if (xmlHttp.status==200)
		   		{
		   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
		   			window.open(downxml,"_self");
		   		}
			    break;
		} 
	}
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
	xmlHttp.send(postStr);
}

function doShowBaseData(wfid_){
	openFullWindow("/system/basedata/basedata_workflow.jsp?wfid="+wfid_);
}

function ShowORHidden(obj,tr1name,tabobj){
    if(obj.checked){
    	showEle(tr1name);
    }else{
    	hideEle(tr1name);
    }
    tabobj.checked=obj.checked;
}

function ShowORHidden2(obj) {
	if (obj.checked) {
		showEle("Frequencytr");
		showEle("Cycletr");
	} else {
		hideEle("Frequencytr");
		hideEle("Cycletr");
	}
}
function wfTitleSet(){
	diag_saveaswf = new window.top.Dialog();
	diag_saveaswf.currentWindow = window;
	diag_saveaswf.Width = 750;
	diag_saveaswf.Height = 450;
	diag_saveaswf.Modal = true;
	diag_saveaswf.Title = "<%=SystemEnv.getHtmlLabelName(19501, user.getLanguage())%>"; 
	diag_saveaswf.URL = "/workflow/workflow/WFTitleSet.jsp?isdialog=1&ajax=1&wfid=<%=wfid%>";
	diag_saveaswf.show();
}
function cancelsaveAsWorkflow(){ 
	diag_saveaswf.close();
}
function showtitle(evt){   
	if($.browser.msie){
		
		jQuery(".vtip").attr("title","");
		obj = evt.srcElement
		if(obj.selectedIndex!=-1){   
			
			if(obj.options[obj.selectedIndex].text.length > 2){  					
				$("#simpleTooltip").remove();					
				var  tipX;
				var  tipY;
				tipX=evt.clientX+document.body.scrollLeft+6;
				tipY=evt.clientY+document.body.scrollTop+6;		
				$("body").append("<div id='simpleTooltip' style='position: absolute; z-index: 100; display: none;'>" + obj.options[obj.selectedIndex].text + "</div>");
				var tipWidth = $("#simpleTooltip").outerWidth(true)
				$("#simpleTooltip").width(tipWidth);
				$("#simpleTooltip").css("left", tipX).css("top", tipY).fadeIn("medium");
			}
			
		}
		
		jQuery(obj).bind("mouseout",function(){
			
			$("#simpleTooltip").remove();		
		})
	}else{
		jQuery(".vtip").simpletooltip("click");
	}
}

function addSrcToDestListTit() {
	destList = window.document.flowTitleForm.destList;
	srcList = window.document.flowTitleForm.srcList;
	var len = destList.length;
	for ( var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			var found = false;
			for ( var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
					}
				}
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,
						srcList.options[i].value);
				len++;
			}
		}
	}
	jQuery(".vtip").simpletooltip("click");
       if($.browser.msie){
   		jQuery(".vtip").attr("title","");
   	}
}

function deleteFromDestListTit() {
	var destList = window.document.flowTitleForm.destList;
	var len = destList.options.length;
	for ( var i = (len - 1); i >= 0; i--) {
		if ((destList.options[i] != null)
				&& (destList.options[i].selected == true)) {
			destList.options[i] = null;
		}
	}
}

function changeOrderShow(){
	var orderbytype = $G("orderbytype").value;
	if(orderbytype == 1){
		$G("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>";
	}else{
		$G("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21628,user.getLanguage())%>";
	}
}

function rejectremindChange(obj,tdname){
	var tzCheckBox = $("input[name='"+tdname+"']").next(".tzCheckBox");
    if(obj.checked){
        $G(tdname).disabled=false;
        tzCheckBox.attr("disabled",false);
    }else{
        $G(tdname).checked=false;
        $G(tdname).disabled=true;
        var isChecked = tzCheckBox.hasClass("checked");
        if(isChecked){
        	tzCheckBox.toggleClass("checked");
        }
        tzCheckBox.attr("disabled",true);
    }
}

function ShowAnnexUpload(obj,tr1name,tr3name,tabobj){
    if(obj.checked){
        showEle(tr1name);
        showEle(tr3name);
    }else{
        hideEle(tr1name);
        hideEle(tr3name);
    }
    tabobj.checked=obj.checked;
}

function onShowAnnexCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML="<a href='#"+val(result[1])+"'>"+result[2]+"</a>";
            $("#annexmaincategory").val(result[3]);
            $("#annexsubcategory").val(result[4]);
            $("#annexseccategory").val(result[1]);
        }else{ //<!--added xwj for td2048 on 2005-6-1 begin -->
            spanName.innerHTML="";
            $("#annexmaincategory").val("");
            $("#annexsubcategory").val("");
            $("#annexseccategory").val("");
        }
        //<!--added xwj for td2048 on 2005-6-1 end -->
    }
}

function annexseccategoryData(event,datas,name,paras){
	var ids = datas.id;
	var idarr= new Array();
	idarr=ids.split(","); 
    $("#annexmaincategory").val(idarr[0]);
    $("#annexsubcategory").val(idarr[1]);
    $("#annexseccategory").val(idarr[2]);
}
function json2Array(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return null;
	}
	var ary = new Array();
	var _index = 0;
	try {
		for(var key in josinobj){
			ary[_index++] = josinobj[key];
		}
	} catch (e) {}
	return ary;
}

function getformajaxurl(){
	var isbill = $("select[name=isbill]").val();
	return url = "/data.jsp?type=wfFormBrowser&isbill="+isbill;
}

function onShowFormSelect(isbill,inputName, spanName){
	var datas,endaffirmances,endShowCharts,affpos,showpos;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill="+isbill,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	endaffirmances=$("#endaffirmances").val();
	endShowCharts=$("#endShowCharts").val();

	if (datas){
	    if(datas.id!=""){
		    $("#"+inputName).val(datas.id);
			if ($("#"+inputName).val()==datas.id){
		    	$("#"+spanName).html("<a href='#"+datas.id+"'>"+datas.name+"</a>");
			}
	        if( isbill==1){
	        	affpos=endaffirmances.indexOf(","+datas.id+",");
	        
		        if (affpos>0){
			        $GetEle("isaffirmance").checked=false
			        $GetEle("isaffirmance").disabled=true
		        }else{
		        	$GetEle("isaffirmance").disabled=false
		        }
	       		showpos=endShowCharts.indexOf(","+datas.id+",");
		        if(showpos>0){
			        $GetEle("isShowChart").checked=false
			        $GetEle("isShowChart").disabled=true
		        }
		        else{
		        	$GetEle("isShowChart").disabled=false
		        }
	        }
	        var oldisbillval=$G("oldisbill").value;
			if(oldisbillval!=3 && datas.id!=$G("oldformid").value){
				if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
		            $G("formid").value=$G("oldformid").value;
		        }
			}
	    }
	} else{
		    inputName.value=""
	        $GetEle("isaffirmance").disabled=false
	        $GetEle("isShowChart").disabled=false
		   try{
			  if (isMand==1){
			     spanName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		      }else{
			     spanName.innerHTML = ""
		     } 
		   }catch(e){}
	}
}

jQuery("input[type=checkbox]").each(function(){
	if(jQuery(this).attr("tzCheckbox")=="true"){
		jQuery(this).tzCheckbox({labels:['','']});
	}
});

function toMiaoji(name){
	var href = "";
	if(name=="<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>"){
		href="#basicA";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(21946, user.getLanguage())%>"){
		href="#messageB";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(23796, user.getLanguage())%>"){
		href="#FUJIAN";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(32383, user.getLanguage())%>"){
		href="#corC";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(84508, user.getLanguage())%>"){
		href="#TUIHUI";
	}else if(name=="<%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%>"){
		href="#QIANZI";
	}
	$("#miaoji").attr("href",href);
	miaoji.click();
}

function toformtab(){
	window.parent.location = "/workflow/form/addform.jsp?ajax=1&isformadd=1";
}


function isImportDetailChanged() {
	if (jQuery('#isImportDetail').is(':checked')) {
		jQuery('#importDetailType').selectbox('show');
	} else {
		jQuery('#importDetailType').selectbox('hide');
	}
}

function importDetailTypeChanged() {
	jQuery('#isImportDetail').val(jQuery('#importDetailType').find('option:selected').val());
}
</script>
<a href="#basicA" id="miaoji"></a>
</body>
</html>
