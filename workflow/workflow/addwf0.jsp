<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.workflow.workflow.WFNodeTransMethod" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
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
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SapAuthorityUtil" class="com.weaver.integration.util.SapAuthorityUtil" scope="page" />


<!--add by wshen-->
<jsp:useBean id ="baseBean" class = "weaver.general.BaseBean" scope="page"/>

<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	int isIncludeToptitle = 0;
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	String iscreat = Util.null2String(request.getParameter("iscreat"));
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	String from = Util.null2String(request.getParameter("from"));
	String isprjwfclose = Util.null2String(request.getParameter("isprjwfclose"));
	int templateid=Util.getIntValue(request.getParameter("templateid"),0);
if("1".equalsIgnoreCase(isprjwfclose)){
	session.setAttribute("newprjwfid", ""+wfid);
%>	
	<script type="text/javascript">
	var dialog = null;
	try{
		dialog = parent.parent.dialog;
		if(dialog){
			var returnjson={id:"<%=wfid %>",name:"<%=WorkflowComInfo.getWorkflowname(""+wfid) %>"};
			try{
	            dialog.callback(returnjson);
	       }catch(e){}
		  	try{
		       dialog.close(returnjson);
		   }catch(e){}
		}else{
			window.parent.returnValue = {id:"<%=wfid %>",name:"<%=WorkflowComInfo.getWorkflowname(""+wfid) %>"};
			window.parent.close();
		}
	}catch(e){}
	
	</script>	

<%
return;
}
	
    //如果是自由流程，则直接跳转到自由流程设置界面
	String  freewfid="0";
	//获取自由流程id(系统中只有一个流程绑定该具体单据)
	String  freeWfSql="select  id  from workflow_base a  where  a.formid=285";
	RecordSet.executeSql(freeWfSql);
	if(RecordSet.next()){
	  freewfid=RecordSet.getString("id");
	}

    if(freewfid.equals(wfid+"")  &&  !freewfid.equals("0")){
	   //跳转到自由节点设置界面
	}
	
	WfRightManager wfrm = new WfRightManager();
	wfid = (wfid==0)?templateid:wfid;
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	boolean userRight = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
	if (!userRight && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
    String ajax=Util.null2String(request.getParameter("ajax"));
    //是否为流程模板


String isTemplate=Util.null2String(request.getParameter("isTemplate"));
int isSaveas=Util.getIntValue(request.getParameter("isSaveas"),0);
%>

<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.systeminfo.menuconfig.MenuUtil"%><html>
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
    String isshared="0";
    String isforwardrights="";
  String needmark = "" ;
  String messageType= "" ;
  String smsAlertsType = "0";
  
  //微信提醒START(QC:98106)     
  String chatsType= "" ;//微信提醒
  String chatsAlertType = "0";//微信提醒类型  0：不提醒  1：提醒
  String notRemindifArchived = "0";//归档节点不短信提醒

  //微信提醒END(QC:98106)
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
  int hrmResourceShow = 0; //人力资源条件中是否显示安全级别
  String showUploadTab = "";
  String isSignDoc="";
  String showDocTab="";
  String isSignWorkflow="";
  String showWorkflowTab="";
  boolean isdocRightByHrmResource = false;
  
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
  String importReadOnlyField = "";
  String issignview="0";
  String newdocpath="";
  String newdocpathspan="";
  int helpdocid=0;
  String isvalid="1";
  String fieldNotImport = "";
  String fieldNotImportStr = "";
  String nosynfields = "";
  String nosynfieldsStr = "";
  String SAPSource = "";
  String wfdocownertype = "";
  String isAutoApprove = "0";//允许自动批准
  String isAutoCommit = "0";//允许处理节点自动提交
  String isAutoRemark = "1";//自动填写用户最后一次手动操作的意见
  int dsporder = 0;
  String isFree = "0";
  int submittype = 0;
	int formid=0;
	int typeid=Util.getIntValue(request.getParameter("typeid"),0);
	type = Util.null2String(request.getParameter("src"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	boolean isHasRight = false;
    int subCompanyId=-1;
    int operatelevel=0;
    String[] subCompanyArray = null;
	
    
    if(detachable==1){  
        //如果开启分权，管理员
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId2")),-1);
        subCompanyId2 = subCompanyId;
        String hasRightSub = SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
        if(!"".equals(hasRightSub)){
            subCompanyArray = hasRightSub.split(",");    
        }
        if(subCompanyId == -1){
            //系统管理员
            if(user.getUID() == 1 ){
	   	         RecordSet.executeProc("SystemSet_Select","");
	   	         if(RecordSet.next()){
	   	             subCompanyId2 = Util.getIntValue(RecordSet.getString("wfdftsubcomid"),0);
	   	         }
           }else{
               if(subCompanyArray != null){
                   subCompanyId2 = Util.getIntValue(subCompanyArray[0]);  
               }
           }
        }
        if(user.getUID() == 1){
            operatelevel = 2;
        }else{
            String subCompanyIds = manageDetachComInfo.getDetachableSubcompanyIds(user);
            if (subCompanyId == 0 || subCompanyId == -1 ) {
                if (subCompanyIds != null && !"".equals(subCompanyIds)) {
                    String [] subCompanyIdArray = subCompanyIds.split(",");
                    for (int i=0; i<subCompanyIdArray.length; i++) {
                        subCompanyId = Util.getIntValue(subCompanyIdArray[i]);
                        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
                        if (operatelevel > 0) {
                            break;
                        }
                    }
                }
            } else {
                operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
            }            
        }

    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            operatelevel=2;
        }else{
            operatelevel=1;
        }
            
    }
    boolean isnewform = false;
	String isvalidStr = "";
	
	if(type=="")
		type = "addwf";
	if(type.equals("addwf")){
		title="add";
	}else {
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
     
  	//微信提醒START(QC:98106)
  	chatsType=WFManager.getChatsType() ;     //微信提醒
    chatsAlertType =WFManager.getChatsAlertType();      //微信提醒类型  0：不提醒  1：提醒

    notRemindifArchived = WFManager.getNotRemindifArchived();      //归档节点不短信提醒

  	//微信提醒END(QC:98106)  
    archiveNoMsgAlert = WFManager.getArchiveNoMsgAlert();
    archiveNoMailAlert = WFManager.getArchiveNoMailAlert();
    
    //是否禁止附件批量下载
    forbidAttDownload=WFManager.getForbidAttDownload();
    
    //是否跟随文档关联人赋权
    docRightByOperator=WFManager.getDocRightByOperator();
    multiSubmit=WFManager.getMultiSubmit();
    defaultName=WFManager.getDefaultName();
    docPath = WFManager.getDocPath();
    selectedCateLog = WFManager.getSelectedCateLog();
    catelogType = WFManager.getCatelogType();
    docRightByHrmResource = WFManager.getDocRightByHrmResource();
    hrmResourceShow = WFManager.getHrmResourceShow();
	 isImportDetail = WFManager.getIsImportDetail();
    isaffirmance=WFManager.getIsaffirmance();
    isSaveCheckForm = WFManager.getIsSaveCheckForm();
	isremak=WFManager.getIsremak();
	isshared=WFManager.getIsshared();//允许流程共享
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
    importReadOnlyField = WFManager.getImportReadOnlyField();
	wfdocpath = WFManager.getWfdocpath();
	wfdocowner = WFManager.getWfdocowner();
	wfdocownerspan = ResourceComInfo.getLastname(wfdocowner);
	wfdocownertype = WFManager.getWfdocownertype();
	wfdocownerfieldid = WFManager.getWfdocownerfieldid();
	issignview = WFManager.getIssignview();
     newdocpath=WFManager.getNewdocpath();
	 fieldNotImport = WFManager.getFieldNotImport();
	 nosynfields = WFManager.getNosynfields();
	  isneeddelacc=WFManager.getIsneeddelacc();
    dsporder = WFManager.getDsporder();
    isFree = WFManager.getIsFree();
    submittype = "1".equals(multiSubmit)?WFManager.getSubmittype():0;
	  SAPSource = WFManager.getSAPSource();
  		isAutoApprove = Util.null2s(WFManager.getIsAutoApprove(),"0");
		isAutoCommit =WFManager.getIsAutoCommit();
  		isAutoRemark = Util.null2s(WFManager.getIsAutoRemark(),"1");
    if(tempcategory!=null && !tempcategory.equals("")){
    	try{
  	      maincategory=tempcategory.substring(0,tempcategory.indexOf(','));
  	      subcategory=tempcategory.substring(tempcategory.indexOf(',')+1,tempcategory.lastIndexOf(','));
  	      seccategory=tempcategory.substring(tempcategory.lastIndexOf(',')+1,tempcategory.length());
  	      String tempName = SubCCI.getSubCategoryname(subcategory);
  	      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
  	      docPath = SecCCI.getAllParentName(seccategory,true);
      	}catch(Exception e){
      		if(tempcategory.indexOf(",")==-1){
      			docPath = SecCCI.getAllParentName(tempcategory,true);
      		}
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
  	      wfdocpathspan = SecCCI.getAllParentName(_temp3,true);
      	}catch(Exception e){
      		if(wfdocpath.indexOf(",")==-1){
      			wfdocpathspan = SecCCI.getAllParentName(wfdocpath,true);
      		}
      	}
    }

	 if(newdocpath!=null && !newdocpath.equals("")){
		 try{
		      String _temp1 = newdocpath.substring(0,newdocpath.indexOf(','));
		      String _temp2 = newdocpath.substring(newdocpath.indexOf(',')+1,newdocpath.lastIndexOf(','));
		      String _temp3 = newdocpath.substring(newdocpath.lastIndexOf(',')+1,newdocpath.length());
		      String tempName = SubCCI.getSubCategoryname(_temp2);
		      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
		      newdocpathspan = SecCCI.getAllParentName(_temp3,true);
			 }catch(Exception e){
				 if(newdocpath.indexOf(",")==-1){
					 newdocpathspan = SecCCI.getAllParentName(newdocpath,true);
				 }
			 }
    }

    if(isbill.equals("1")){//判断是不是新创建的表单


        String tablename = "";
        RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
        if(RecordSet.next()) tablename = RecordSet.getString("tablename");
        if(tablename.equals("formtable_main_"+formid*(-1)) || tablename.startsWith("uf_")) isnewform = true;
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
    	
        if(operatelevel < 1 && haspermission){
            operatelevel = 1;
        }
    	if(subCompanyId2 != -1 && subCompanyId2 != 0 && detachable == 1){
    	    if(!haspermission){
    	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId2);    
    	    }
    	    
   	    	if(subCompanyArray != null){
   	    	    for(int i = 0;i<subCompanyArray.length;i++){
   	    	        if(Integer.parseInt(subCompanyArray[i]) == subCompanyId2){
   	    	         	isHasRight = true;
   	    	         	break;
   	    	        }
   	    	    }
   	    	}
    	}
	}
	if(templateid>0){
	    WFManager.reset();
	    WFManager.setWfid(templateid);
		WFManager.getWfInfo();
		templatename=WFManager.getWfname();
		if("1".equals(isTemplate)){
		    if (isSaveas==1) {
                subCompanyId2 = WFManager.getSubCompanyId2();
            }
		    if(subCompanyId2 != -1 && subCompanyId2 != 0 && detachable == 1){
		    	if(subCompanyArray != null){
		    	    for(int i = 0;i<subCompanyArray.length;i++){
		    	        if(Integer.parseInt(subCompanyArray[i]) == subCompanyId2){
		    	         	isHasRight = true;
		    	         	break;
		    	        }
		    	    }
		    	}
			}	    
		}
	
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

if(!"".equals(fieldNotImport)) {
	if(isbill.equals("1")) {
		RecordSet.executeSql("select id as fieldid, fieldlabel, viewtype as isdetail from workflow_billfield where billid=" + formid + " and id in (" + fieldNotImport + ") order by dsporder asc");
	}else {
		RecordSet.executeSql("select a.fieldid, b.fieldlable, a.isdetail from workflow_formfield a, workflow_fieldlable b  where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage()+" and  a.fieldid in("+fieldNotImport+") order by a.fieldorder asc ");
	}
	while(RecordSet.next()) {
		String fieldlablename = "";
		if(isbill.equals("1")) { // 单据无法将字段名称作为查询条件，在这里进行处理
			fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		}else {
			fieldlablename = Util.null2String(RecordSet.getString("fieldlable"));
		}
		int isdetail_ = Util.getIntValue(RecordSet.getString("isdetail"), 0);
		String isdetailStr = "";
		if(isdetail_ == 1) {
			isdetailStr = "(" + SystemEnv.getHtmlLabelName(17463, user.getLanguage()) + ")";
		}
		fieldNotImportStr = fieldNotImportStr + fieldlablename + isdetailStr + ",";
	}
	if(!"".equals(fieldNotImportStr)){
		fieldNotImportStr = fieldNotImportStr.substring(0, fieldNotImportStr.length()-1);
	}
}
	
if(!"".equals(nosynfields)){
	if(isbill.equals("1")){
		RecordSet.executeSql("select id as fieldid, fieldlabel, viewtype as isdetail from workflow_billfield where billid="+formid+" and id in ("+nosynfields+") order by dsporder asc");
	}else{
		 RecordSet.executeSql("select a.fieldid, b.fieldlable, a.isdetail from workflow_formfield a, workflow_fieldlable b  where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage()+" and  a.fieldid in("+nosynfields+") order by a.fieldorder asc ");
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

//判断是否有标题字段
String _sql = "";
boolean hasSelectedTitleField = false;
if (isbill.equals("0"))
  	{
	_sql="select workflow_formfield.fieldid, workflow_fieldlable.fieldlable from workflow_formfield,workflow_fieldlable where workflow_formfield.fieldid=workflow_fieldlable.fieldid and workflow_fieldlable.formid=workflow_formfield.formid  and workflow_fieldlable.formid="+formid+" and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and langurageid="+user.getLanguage();
   	_sql += " order by workflow_formfield.isdetail desc, workflow_formfield.groupid, workflow_formfield.fieldorder";
  	}
 	else
 	{
 	_sql="select id,fieldlabel from workflow_billfield where viewtype=0 and billid="+formid;
 	_sql += " order by viewtype,detailtable,dsporder";
}
String fieldid="";
RecordSet.execute("select * from workflow_TitleSet where flowid="+wfid +" order by gradation");
while(RecordSet.next()){
	fieldid += RecordSet.getString("fieldid")+",";  
}
ArrayList fieldids = Util.TokenizerString(fieldid,",");
RecordSet.execute(_sql);
if(fieldids!=null && fieldids.size()>0){
	for(int i=0;i<fieldids.size();i++){
		while(RecordSet.next()){
			if(fieldids.get(i).toString().equals(RecordSet.getString(1))){
				hasSelectedTitleField = true;
				break;
			}
		}
	}
}

%>

<head>
<script type="text/javascript">
<%if(isrefresh.equals("1")){ %>
parent.parent.location.href="addwf.jsp?src=editwf&versionid_toXtree=1&wfid=<%=wfid%>&isTemplate=<%=isTemplate%>";
try{
      parent.parent.parent.wfleftFrame.location="/workflow/workflow/wfmanage_left2.jsp?isTemplate=<%=isTemplate%>";
}catch(e){} // update by liaodong for qc52610 in 20130922
<%}%>
<%if(!wfname.equals("")){%>
try {
	jQuery("#objName", parent.parent.document).html("<%=wfname%>");
} catch (e) {}
<%}%>
</script>
  <link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <link href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel="stylesheet">
  <script language="javascript" src="/js/weaver_wev8.js"></script>
  <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
  <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
  <script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
  <script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
  <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
  <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
  <script language="javascript" src="/proj/js/common_wev8.js"></script>
<style type="text/css">

input{
	width: 300px!important;
}
</style>
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

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0 || haspermission){
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
		    
			RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"xml,javascript:exportWorkflow("+wfid+"),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
				
	    }
    }
    
    if(!ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:weaver.reset(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
    }
    if(!iscreat.equals("1") && !"1".equals(isTemplate) && wfid != 0) {
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(125059,user.getLanguage())+", javascript:saveAsWorkflow("+wfid+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
    }
}
	if(!iscreat.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+", javascript:onLog("+wfid+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
%>

<form name="weaver" id="weaver" method="post" action="wf_operation.jsp">
<input type="hidden" name="endaffirmances" id="endaffirmances" value="<%=endaffirmances%>">
<input type="hidden" name="endShowCharts" id="endShowCharts" value="<%=endShowCharts%>">
<%
if("prjwf".equalsIgnoreCase(from)){
%>	
<input type="hidden" name="from" id="from" value="<%=from %>" />
<input type="hidden" name="prjwfinfo" id="prjwfinfo" value="<%=request.getQueryString() %>" />
<%
}

if(detachable == 0){
%>
<input type="hidden" name="subcompanyid" id="subcompanyid" value="<%=subCompanyId2%>">
<%} %>


<%if(ajax.equals("1")){%>
	<input type=hidden name="ajax" value="1">
<%}%>
<%
if(type.equals("editwf")&&operatelevel>0){
    if(!ajax.equals("1")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+",Editwfnode.jsp?wfid="+wfid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15587,user.getLanguage())+",addwfnodeportal.jsp?wfid="+wfid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;
    }
}
if(!ajax.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",managewf.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
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
String prjwfformid=request.getParameter("prjwfformid");
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



    <jsp:include page="addwf0_inner2.jsp">
        <jsp:param value="<%=isTemplate %>" name="isTemplate"/>
        <jsp:param value="<%=wfname%>" name="wfname"/>
        <jsp:param value="<%=type%>" name="type"/>
        <jsp:param value="<%=templatename %>" name="templatename"/>
        <jsp:param value="<%=templateid %>" name="templateid"/>
        <jsp:param value="<%=detachable %>" name="detachable"/>
        <jsp:param value="<%=operatelevel %>" name="operatelevel"/>
        <jsp:param value="<%=subCompanyId2 %>" name="subCompanyId2"/>
        <jsp:param value="<%=wfid %>" name="wfid"/>
        <jsp:param value="<%=helpdocid %>" name="helpdocid"/>
        <jsp:param value="<%=typeid %>" name="typeid"/>
        <jsp:param value="<%=wfdes%>" name="wfdes"/>
        <jsp:param value="<%=formid%>" name="formid"/>
        <jsp:param value="<%=isbill %>" name="isbill"/>
        <jsp:param value="<%=isSaveas %>" name="isSaveas"/>
        <jsp:param value="<%=from %>" name="from"/>
        <jsp:param value="<%=isvalid %>" name="isvalid"/>
        <jsp:param value="<%=isvalidStr %>" name="isvalidStr"/>
        <jsp:param value="<%=isHasRight %>" name="isHasRight"/>
        <jsp:param value="<%=haspermission %>" name="haspermission"/>
        <jsp:param value="<%=isnewform %>" name="isnewform"/>
        <jsp:param value="<%=dsporder %>" name="dsporder"/>
        <jsp:param value="<%=prjwfformid%>" name="prjwfformid"/>

    </jsp:include>
<wea:layout type="2col">

	
	<%
		if (!(isSaveas==1 && "1".equals(isTemplate))) {
		%>
	
	
  <%
  //当新建流程或者流程为自由流程时，显示此设置信息
  if( wfid == 0 || isFree.equals("1")){
  %>
  <%String context2 = "<a name='freeWorkflow'>" + SystemEnv.getHtmlLabelName(32825,user.getLanguage()) + "</a>"; %>
  <wea:group context='<%=context2%>'>
    <wea:item>
      <%=SystemEnv.getHtmlLabelName(125045,user.getLanguage())%>

    </wea:item>
    <wea:item>
        <input type="checkbox" name="isFree" tzCheckbox="true" value="1" <% if(wfid != 0){%> disabled <%}%> <% if(isFree.equals("1")) {%> checked <%}%> onclick="">
        <span style="padding-left:20px;"><%=SystemEnv.getHtmlLabelName(125046,user.getLanguage())%></span>
    </wea:item>
  </wea:group>
  <%
  }
  %>
	<%String context3 = "<a name='messageB'>" + SystemEnv.getHtmlLabelName(21946,user.getLanguage()) + "</a>"; %>
	<wea:group context='<%=context3%>'>
		<%
			String smsAlertsTypeShow = "{'samePair':'smsAlertsTypeShow','display':''}";
			String archiveNoMsgAlertTr="{'samePair':'archiveNoMsgAlertTr','display':''}"; 
			String archiveNoMailAlertTr = "{'samePair':'archiveNoMailAlertTr','display':''}"; 
			if(!"1".equals(messageType)){
				smsAlertsTypeShow = "{'samePair':'smsAlertsTypeShow','display':'none'}";
				archiveNoMsgAlertTr = "{'samePair':'archiveNoMsgAlertTr','display':'none'}";
			}
			if(!"1".equals(mailMessageType)){
				archiveNoMailAlertTr = "{'samePair':'archiveNoMailAlertTr','display':'none'}";
			}
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="messageType" tzCheckbox="true" value="1" <% if(messageType.equals("1")) {%> checked <%}%> onclick="ShowORHidden(this,'smsAlertsTypeShow,archiveNoMsgAlertTr','')">
		</wea:item>
		<wea:item attributes='<%=smsAlertsTypeShow %>'><%=SystemEnv.getHtmlLabelName(21976,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=smsAlertsTypeShow %>'>
			<select id="smsAlertsType" name="smsAlertsType">
				<option value="0" <% if(smsAlertsType.equals("0")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%></option>
				<option value="1" <% if(smsAlertsType.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%></option>
				<option value="2" <% if(smsAlertsType.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%></option>
			</select> 			
		</wea:item>
		<wea:item attributes='<%=archiveNoMsgAlertTr %>'><%=SystemEnv.getHtmlLabelName(32162, user.getLanguage())%></wea:item>
		<wea:item attributes='<%=archiveNoMsgAlertTr %>'>
			<input type=checkbox name="archiveNoMsgAlert" tzCheckbox="true" value="1" <% if("1".equals(archiveNoMsgAlert)) {%> checked <%}%>>
		</wea:item>
		<!-- 开启微信提醒START QC:98106 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT tzCheckbox="true" type=checkbox name="chatsType" value="1"  <% if(chatsType.equals("1")) {%> checked <%}%> onclick="wchatStateChange(this)" >	 
		</wea:item>
		<wea:item attributes="{'samePair':'chatsType'}">
			<%=SystemEnv.getHtmlLabelName(21976,user.getLanguage())%> 
		</wea:item>
		<wea:item attributes="{'samePair':'chatsType'}">
			<select id="chatsAlertType" name="chatsAlertType">
	          <option value="0" <% if(chatsAlertType.equals("0")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%></option>
	          <option value="1" <% if(chatsAlertType.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></option>
	     	</select>
		</wea:item>
		<wea:item attributes="{'samePair':'notRemind'}"><%=SystemEnv.getHtmlLabelName(32810,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'notRemind'}">
		 		<INPUT tzCheckbox="true" type=checkbox name="notRemindifArchived" value="1" <% if(notRemindifArchived.equals("1")) {%> checked <%}%>>
		</wea:item>
		<!-- 开启微信提醒END QC:98106 -->
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31488,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="mailMessageType" tzCheckbox="true" value="1" <% if(mailMessageType.equals("1")) {%> checked <%}%> onclick="ShowORHidden(this,'archiveNoMailAlertTr','')">
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
	<%String context4 = "<a name='corC'>"+SystemEnv.getHtmlLabelName(32383,user.getLanguage()) + "</a>"; %>
	<wea:group context='<%=context4%>'>
	 
		<%if(EnableMobile){%> 
		<wea:item><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox tzCheckbox="true" name="isMgms" value="1" <% if(isMgms) {%> checked <%}%>></wea:item>
		<%}else{%>
		<input type=hidden name="isMgms" value="<%if(isMgms){%>1<%}%>">
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(31486,user.getLanguage())%></wea:item> 
		<wea:item>
			<input type=checkbox    name="defaultName" id="defaultName" tzCheckbox="true"   onclick="ShowFnaHidden2()"   value="1" <% if(defaultName.equals("1")) {%> checked <%}%>>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span id="defaultitle" <% if(!defaultName.equals("1")) {%>style="display: none" <%} %>><a href="#" onclick="totitletab()" style="color:blue;TEXT-DECORATION:none"><%=SystemEnv.getHtmlLabelName(31844,user.getLanguage())%></a></span> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></wea:item>		
		<wea:item><img id='btnMessageSetting' class="setting" src="/images/homepage/style/setting_wev8.png" onClick="wfTitleSet()"/><%if(hasSelectedTitleField == true){%><img src="/images/ecology8/checkright_wev8.png" width="16" height="17" border="0"><%}%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125047,user.getLanguage())%></wea:item>
		<wea:item>
		<input type=checkbox name="iscust" tzCheckbox="true" value="1" onchange="onchangeiscust(this.value)" <%if(iscust.equals("1")){%> checked <%}%> >
		  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31491,user.getLanguage())%></wea:item>
		<wea:item>
			<table style="margin-left:-2px;">
				<tr>
					<td>
						<input type=checkbox name="multiSubmit" id="multiSubmit" tzCheckbox="true" value="1" <% if(multiSubmit.equals("1")) {%> checked <%}%> onclick="clickMultisubmit()">
					</td>
					<td>
						<div id="multiSubmitSpan"  <%if(!"1".equals(multiSubmit)){ %>style="display:none;"<%}%>>
							<table>
								<tr>
									<td>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
										<%=SystemEnv.getHtmlLabelName(382860,user.getLanguage())%>：
										<select name="submittype" id="submittype" onchange="typeChange(this)" style="width: 60px;">
											<option value="0" <%if(submittype == 0){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option><!-- 全部 -->
											<option value="1" <%if(submittype == 1){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></option><!-- 选择 -->
											<option value="2" <%if(submittype == 2){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(126833,user.getLanguage())%></option><!-- 排除选择 -->
										</select>
									</td>
									<td>
										<%
											String completeUrl2 = "/data.jsp?type=workflowNodeBrowser&wfid="+wfid;
											if(wfid == 0)
												completeUrl2 = "/data.jsp?type=workflowNodeBrowser&wfid=-1";
											String submitnode = "";
											String submitnodeName = "";
											String submitnode2 = "";
											String submitnodeName2 = "";
											if(wfid != 0 && submittype != 0){
												RecordSet.execute("select b.id,b.nodename from workflow_flownode a,workflow_nodebase b where a.nodeid = b.id and a.workflowid = "+wfid+" and (b.isfreenode is null or b.isfreenode = '' or b.isfreenode = '0') and a.batchsubmit = 1 order by a.nodeorder,b.id ");
												while(RecordSet.next()){
													if(submittype == 1){
														submitnode += "," + RecordSet.getString(1);
														submitnodeName += "," + RecordSet.getString(2);
													}else if(submittype == 2){
														submitnode2 += "," + RecordSet.getString(1);
														submitnodeName2 += "," + RecordSet.getString(2);
													}
												}
												
												if(!"".equals(submitnode)){
													submitnode = submitnode.substring(1);
													submitnodeName = submitnodeName.substring(1);
												}
												if(!"".equals(submitnode2)){
													submitnode2 = submitnode2.substring(1);
													submitnodeName2 = submitnodeName2.substring(1);
												}
											}
										%>
										<span id="submitNode_Span" <%if(submittype == 0 || submittype == 2) {%>style="display: none"<%} %>>
											<brow:browser name="submitnode" viewType="0" hasBrowser="true" hasAdd="false" completeUrl="<%=completeUrl2 %>"
							         			 isMustInput="2" isSingle="false" hasInput="true" getBrowserUrlFn="getShowNodesUrl1"
							         			 width="300px" browserValue="<%=submitnode %>" browserSpanValue="<%=submitnodeName %>" nameSplitFlag=","/>
						         		</span>
						         		<span id="submitNode_Span2" <%if(submittype == 0 || submittype == 1) {%>style="display: none"<%} %>>
											<brow:browser name="submitnode2" viewType="0" hasBrowser="true" hasAdd="false" completeUrl="<%=completeUrl2 %>"
							         			 isMustInput="2" isSingle="false" hasInput="true" getBrowserUrlFn="getShowNodesUrl2"
							         			 width="300px" browserValue="<%=submitnode2 %>" browserSpanValue="<%=submitnodeName2 %>" nameSplitFlag=","/>
						         		</span>
			         			 	</td>
			         			 </tr>
			         		</table>
		         		</div>
         			 </td>
				</tr>
			</table>
		</wea:item>
		<!-- 允许流程共享 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(82607,user.getLanguage())%></wea:item>	
		<wea:item><input type=checkbox name="isshared" tzCheckbox="true" value="1" <% if(isshared.equals("1")) {%> checked <%}%>></wea:item>
		<!-- end -->
		<wea:item><%=SystemEnv.getHtmlLabelName(81778,user.getLanguage())%></wea:item>	
		<wea:item><input type=checkbox name="isforwardrights" tzCheckbox="true" value="1" <% if(isforwardrights.equals("1")) {%> checked <%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31493,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox name="isModifyLog" tzCheckbox="true" value="1" <% if(isModifyLog.equals("1")) {%> checked <%}%>></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31495,user.getLanguage())%></wea:item>
		<wea:item><input type=checkbox tzCheckbox="true" name="docRightByOperator" value="1" <% if(docRightByOperator.equals("1")) {%> checked <%}%>></wea:item>
		<%
			String isOpenWorkflowImportDetailShow = "{'display':''}";
			if(!isOpenWorkflowImportDetail.equals("1")) isOpenWorkflowImportDetailShow = "{'display':'none'}";
		 %>		
		 <wea:item><%=SystemEnv.getHtmlLabelName(125048,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="newdocpath" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="path"
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
			                completeUrl="/data.jsp?type=categoryBrowser"  width="300px" browserValue='<%=newdocpath%>' browserSpanValue='<%=newdocpathspan%>' />		
		</wea:item>
		<wea:item attributes='<%=isOpenWorkflowImportDetailShow %>'><%=SystemEnv.getHtmlLabelName(26254,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=isOpenWorkflowImportDetailShow %>'>
	    <% 
		  //如果不是系统单据,就出现允许明细导入的配置
		  if(!("1".equals(isbill)&&formid>0)){%>
				 <input type=checkbox tzCheckbox="true" name="isImportDetail" id="isImportDetail" value="1" onclick="isImportDetailChanged();" <%if("1".equals(isImportDetail) || "2".equals(isImportDetail)) {%> checked <%}%>> 
				 <!-- <input type=checkbox tzCheckbox="false" id='isImportDetail_fake' style='display:none' disabled='true'> -->
				 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <select id="importDetailType" class="inputstyle" onChange="importDetailTypeChanged();" <%if(!"1".equals(isImportDetail) && !"2".equals(isImportDetail)) {%>style="display:none"<%}%>>
				 	<option <% if("1".equals(isImportDetail)) {%>selected<%}%> value="1"><%=SystemEnv.getHtmlLabelName(33844,user.getLanguage())%></option>
				 	<option <% if("2".equals(isImportDetail)) {%>selected<%}%> value="2"><%=SystemEnv.getHtmlLabelName(33845,user.getLanguage())%></option>
				 </select>
		<%}else{%>
				 <input type=checkbox tzCheckbox="true" name="isImportDetail" id="isImportDetail" value="1" onclick="isImportDetailChanged();" disabled> 
				 <!-- <input type=checkbox tzCheckbox="true" id='isImportDetail_fake' style='display:inline' disabled='true'> -->
				 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <select id="importDetailType" class="inputstyle" style="display:none" onChange="importDetailTypeChanged();">
				 	<option value="1"><%=SystemEnv.getHtmlLabelName(33844,user.getLanguage())%></option>
				 	<option value="2"><%=SystemEnv.getHtmlLabelName(33845,user.getLanguage())%></option>
				 </select> 
		<%}%>	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31499,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isimportwf" tzCheckbox="true" value="1" <% if(isimportwf.equals("1")) {%> checked <%}%> onclick="ShowORHidden(this, 'fieldNotImportShow', '');isimportwfClicked(this);">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span id="importReadOnlyFieldSpan" style="<% if(!isimportwf.equals("1")) { %> display: none; <% } %>">
				<input type="checkbox" name="importReadOnlyField" id="importReadOnlyField" value="1" <% if("1".equals(importReadOnlyField)) { %> checked="checked" <% } %> />
				<%=SystemEnv.getHtmlLabelName(131942, user.getLanguage()) %>
			</span>
		</wea:item>
		<%
			String fieldNotImportShow = "{'samePair':'fieldNotImportShow', 'display':''}";
			if(!"1".equals(isimportwf)) {
				fieldNotImportShow = "{'samePair':'fieldNotImportShow', 'display':'none'}";
			}
		%>
		<wea:item attributes='<%=fieldNotImportShow %>'><%=SystemEnv.getHtmlLabelName(32990,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=fieldNotImportShow %>'>
			<% 
				String fieldNotImportURL = "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/browserFieldMutil.jsp?workflowid="+wfid+"%26oldfields=#id#";
			%>
			<brow:browser name="fieldNotImport" viewType="0" isMustInput="1" isSingle="false" hasInput="true" 
			browserUrl='<%=fieldNotImportURL %>'
			completeUrl='<%="/data.jsp?type=fieldBrowser&wfid=" + wfid %>' isAutoComplete="true" width="300px" browserValue='<%=fieldNotImport %>' browserSpanValue='<%=fieldNotImportStr %>' />
		</wea:item>
		<%if(isdocRightByHrmResource){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(19321,user.getLanguage())%></wea:item>
			<wea:item>
				<input type=checkbox name="docRightByHrmResource" tzCheckbox="true" value="1" <% if(docRightByHrmResource == 1){%> checked <%}%>>
			</wea:item>
            <wea:item><%=SystemEnv.getHtmlLabelName(131375,user.getLanguage())%></wea:item>
            <wea:item>
                 <select id="hrmResourceShow" name="hrmResourceShow" class="inputstyle" >
                    <option value="0" <% if(hrmResourceShow <= 0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(131376,user.getLanguage())%></option>
                    <option value="1" <% if(hrmResourceShow == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(131377,user.getLanguage())%></option>
                    <option value="2" <% if(hrmResourceShow == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(131379,user.getLanguage())%></option>
                 </select> 
            </wea:item>
		<%}%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(28064,user.getLanguage())%></wea:item>
		<wea:item>
			<% 
				String completeUrl="/data.jsp?type=fieldBrowser&wfid="+wfid; 
				String nosynfieldsUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/fieldMutilBrowser.jsp?workflowid="+wfid+"&oldfields="+nosynfields;
			%>
			<brow:browser name="nosynfields" viewType="0" hasBrowser="true" hasAdd="false" 
			browserUrl='<%=nosynfieldsUrl %>' isMustInput="1" isSingle="false" hasInput="true"
	        completeUrl='<%=completeUrl %>' isAutoComplete="false" width="300px" browserValue='<%=nosynfields%>' 
	        browserSpanValue='<%=nosynfieldsStr%>' />	
			&nbsp;&nbsp;	
			<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(28065,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	
		</wea:item>
		<%if(isOpenWorkflowSpecialApproval.equals("1")){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(26007,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27566,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="specialApproval" tzCheckbox="true" value="1" onclick="ShowORHidden(this,'Frequencytr,Cycletr','')" <% if(specialApproval.equals("1")) {%> checked <%}%> >
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

		<%
            //if("1".equals(IsOpetype)){
            int isOpenSap = SapAuthorityUtil.isOpenSapFun();
            if(isOpenSap>0){
        %>
        <wea:item>SAP<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
        <wea:item>
            <select name="SAPSource" id="SAPSource">
                <option value=""></option>
                <%
                    //0表示使用新版本的数据源，1表示使用老版本的数据源 wshen
                    String isUseOldVersion = Util.null2String(baseBean.getPropValue("Integrated","isUseOldVersion"));
                    if("0".equals(isUseOldVersion)){
                        RecordSet.executeSql("select * from sap_datasource");
                    }else {
                        RecordSet.executeSql("select * from SAPCONN");
                    }
                    while(RecordSet.next()){
                        String code ="";
                        String sourceID ="";
                        if("0".equals(isUseOldVersion)){
                            code = RecordSet.getString("poolname");
                            sourceID=RecordSet.getString("id");
                        }else {
                            code = RecordSet.getString("code");
                            sourceID = code;
                        }
                %>
                <option value="<%=sourceID%>" <%if(SAPSource.equals(sourceID)){%>selected<%}%>><%=code%></option>
                <%}%>
            </select>
            <input type="hidden" id="isUseOldVersion" value="<%=isUseOldVersion%>"/>
        </wea:item>
        <%
        }%>
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
			 		<%
			 			String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp%3FprintNodes%3D"+fnanodeid+"%26workflowId%3D"+wfid;
			 		%>
				 	<brow:browser name="fnanodeid" viewType="0" hasBrowser="true" hasAdd="false" 
							browserUrl='<%=browserUrl %>' 
							isMustInput="1" isSingle="false" hasInput="false"
							width="300px" 
							browserValue='<%=fnanodeid %>' browserSpanValue='<%=fnanodenamestr%>'/>
			 </wea:item>
			 <wea:item attributes='<%=fnadepartmentidtr %>'><%=SystemEnv.getHtmlLabelName(81462,user.getLanguage())%></wea:item>
			 <wea:item attributes='<%=fnadepartmentidtr %>'>
					<%
			 			String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+fnadepartmentid;
						String completeUrl = "/data.jsp?type=4";
			 		%>
				 	<brow:browser name="fnadepartmentid" viewType="0" hasBrowser="true" hasAdd="false" 
							browserUrl='<%=browserUrl %>' 
							isMustInput="1" isSingle="false" hasInput="true"
							width="300px" 
							completeUrl="<%=completeUrl %>"
							browserValue='<%=fnadepartmentid %>' browserSpanValue='<%=fnadepartmentnamestr%>'/>
			 </wea:item>
			
		<%}%>  		
		<wea:item><%=SystemEnv.getHtmlLabelName(31496,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="ShowDelButtonByReject" tzCheckbox="true" value="1" <% if(ShowDelButtonByReject.equals("1")) {%> checked <%}%>>
		</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(130577,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=isAutoApprove name=isAutoApprove onchange="ShowOrHiddenLable(this,'isAutoCommitspan')" style="float: left;">
			    <option value=0 <%if(isAutoApprove.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(31675,user.getLanguage())%></option>
			    <option value=1 <%if(isAutoApprove.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(130574,user.getLanguage())%></option>
			    <option value=2 <%if(isAutoApprove.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(130575,user.getLanguage())%></option>
		    </select>
			<!-- 
			<input type=checkbox name="isAutoApprove" tzCheckbox="true" value="1" <% if(isAutoApprove.equals("1")) {%> checked <%}%> onclick="ShowOrHiddenLable(this,'isAutoCommitspan');">
			-->
			&nbsp;
			<span id="isAutoCommitspan" <% if(isAutoApprove.equals("0")){%>style="display:none;float: left;"<%}else{ %>style="float: left;" <%} %>>
				<div style="float: left;padding-left:10px;line-height : 26px;">
					<%=SystemEnv.getHtmlLabelName(130578,user.getLanguage())%>
				</div>
				<div style="float: left;padding-left:10px;">
					<select class=inputstyle id=isAutoCommit name=isAutoCommit >
					    <option value=0 <%if(isAutoCommit.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
					    <option value=1 <%if(isAutoCommit.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(130576,user.getLanguage())%></option>
				    </select>
			    </div>
				&nbsp;&nbsp;
			</span>
			<!--自动填写用户最后一次手动操作的意见 默认值给1  默认勾选  不勾选值为 0 -->
			<div id="isAutoRemarkdiv" <% if(isAutoApprove.equals("0")){%>style="display:none;float: left;padding-left:10px;line-height : 24px;"<%}else{ %>style="float: left;padding-left:10px;line-height : 24px;"<%} %>>
				<input type="checkbox" id="isAutoRemark" name="isAutoRemark" notBeauty=true value="1" <% if(isAutoRemark.equals("1")) {%> checked <%}%>>
				<%=SystemEnv.getHtmlLabelName(130579,user.getLanguage()) %>
			</div>
		</wea:item>
	</wea:group> 

	
	<%
		}
	%>
</wea:layout>
<% if (!(isSaveas==1 && "1".equals(isTemplate))) { %>
  
    <jsp:include page="addwf0_inner3.jsp">
        <jsp:param value="<%=wfid %>" name="wfid"/>
        <jsp:param value="<%=catelogType%>" name="catelogType"/>
        <jsp:param value="<%=selectedCateLog%>" name="selectedCateLog"/>
        <jsp:param value="<%=isbill %>" name="isbill"/>
        <jsp:param value="<%=maincategory %>" name="maincategory"/>
        <jsp:param value="<%=subcategory %>" name="subcategory"/>
        <jsp:param value="<%=seccategory %>" name="seccategory"/>
        <jsp:param value="<%=candelacc %>" name="candelacc"/>
        <jsp:param value="<%=isneeddelacc %>" name="isneeddelacc"/>
        <jsp:param value="<%=forbidAttDownload %>" name="forbidAttDownload"/>
        <jsp:param value="<%=formid %>" name="formid"/>
        <jsp:param value="<%=docPath %>" name="docPath"/>
    </jsp:include>

	<jsp:include page="addwf0_inner.jsp">
		<jsp:param value="<%=orderbytype %>" name="orderbytype"/>
		<jsp:param value="<%=isSignDoc %>" name="isSignDoc"/>
		<jsp:param value="<%=isSignWorkflow %>" name="isSignWorkflow"/>
		<jsp:param value="<%=annexsubcategory %>" name="annexsubcategory"/>
		<jsp:param value="<%=isannexUpload %>" name="isannexUpload"/>
		<jsp:param value="<%=issignview %>" name="issignview"/>
		<jsp:param value="<%=annexmaincategory %>" name="annexmaincategory"/>
		<jsp:param value="<%=annexseccategory %>" name="annexseccategory"/>
		<jsp:param value="<%=annexdocPath %>" name="annexdocPath"/>
	</jsp:include>
<%} %>
<br/>
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
<jsp:include page="addwf0_script.jsp">
	<jsp:param name="ajax" value="<%=ajax %>"/>
	<jsp:param name="wfid" value="<%=wfid %>"/>
	<jsp:param name="isTemplate" value="<%=isTemplate %>"/>
	<jsp:param name="isnewform" value="<%=isnewform %>"/>
	<jsp:param name="isrejectremind" value="<%=isrejectremind %>"/>
	<jsp:param name="chatsType" value="<%=chatsType %>"/>
</jsp:include>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
<a href="#basicA" id="miaoji"></a>
</body>
</html>
