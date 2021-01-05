
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="8kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.Writer" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ page import="weaver.rdeploy.workflow.WorkflowInitialization" %>
<%@ page import="weaver.workflow.workflow.GroupDetailMatrix,weaver.workflow.workflow.GroupDetailMatrixDetail" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@page import="weaver.fna.general.FnaWfInitE8"%>
<%@page import="weaver.workflow.workflow.WFMainManager"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo2"%><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="matrixUtil" class="weaver.matrix.MatrixUtil" scope="page" />
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<%WFNodePortalMainManager.resetParameter();%>
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<jsp:useBean id="WorkflowAllComInfo" class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="TestWorkflowComInfo" class="weaver.workflow.workflow.TestWorkflowComInfo" scope="page" />
<%WFNodeOperatorManager.resetParameter();%>
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<%RequestCheckUser.resetParameter();%>
<jsp:useBean id="RequestUserDefaultManager" class="weaver.workflow.request.RequestUserDefaultManager" scope="page"/>
<jsp:useBean id="wFNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page"/>
<jsp:useBean id="excelsetInitManager" class="weaver.workflow.exceldesign.ExcelsetInitManager" scope="page"/>
<jsp:useBean id="htmlLayoutOperate" class="weaver.workflow.exceldesign.HtmlLayoutOperate" scope="page"/>
<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page" />
<%
  WfRightManager wfrm = new WfRightManager();
  boolean haspermission = wfrm.hasPermission3(Util.getIntValue(request.getParameter("wfid"), 0), 0, user, WfRightManager.OPERATION_CREATEDIR);
  if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}  
  int design = Util.getIntValue(request.getParameter("design"),0);
  String ajax=Util.null2String(request.getParameter("ajax"));
  String isTemplate=Util.null2String(request.getParameter("isTemplate"));
  int templateid=Util.getIntValue(request.getParameter("templateid"),0);
  int selectedCateLog = Util.getIntValue(request.getParameter("selectcatalog"),0);
  int catelogType = Util.getIntValue(request.getParameter("catalogtype"),0);
  String src = Util.null2String(request.getParameter("src"));
    int subCompanyId = Util.getIntValue(request.getParameter("subcompanyid"),-1); //add by wjy


    /* start 同步到其他路径创建节点***************************************/
    String wfids = Util.null2String(request.getParameter("workflowids"));
    String deleteBeforeAdd =  Util.null2String(request.getParameter("deleteBeforeAdd"));
    String selectwfids[] = wfids.split(",");

    for(int index=0;index<selectwfids.length;index++){
        int wfid = Util.getIntValue(selectwfids[index],0);
        int nodeid=0;
        int formid=0;
        String isbill="";
        String iscust="0";
          
        String sql = "";
        sql = "select a.formid,a.isbill,a.iscust,b.nodeid from workflow_base a,workflow_flownode b where a.id = b.workflowid and b.nodetype = 0 and a.id = " + wfid;
        RecordSet.executeSql(sql);
        if(RecordSet.next()){
            nodeid=Util.getIntValue(RecordSet.getString("nodeid"),0);
            formid=Util.getIntValue(RecordSet.getString("formid"),0);
            isbill=Util.null2String(RecordSet.getString("isbill"));
            iscust=Util.null2String(RecordSet.getString("iscust"));
        }
        
        //先做删除现有操作者


        if( deleteBeforeAdd.trim().equals("true") && wfid > 0){
            String nodetype="0";
            String tmp = "";//groupid
            RecordSet.executeSql("delete from workflow_groupdetail where groupid in (select id from workflow_nodegroup where nodeid = "+nodeid+")");
            RecordSet.executeSql("delete from Workflow_HrmOperator where groupid in (select id from workflow_nodegroup where nodeid = "+nodeid+")");
            RecordSet.executeSql("delete from workflow_nodegroup where nodeid = "+nodeid);
            RecordSet.executeSql("update workflow_nodebase set totalgroups=0 where id = "+nodeid);
            String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
            RequestCheckUser.setWorkflowid(wfid);
            RequestCheckUser.setNodeid(nodeid);
            RequestCheckUser.updateCreateList(Util.getIntValue(tmp));
            RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);

            //删除节点操作组日志



            SysMaintenanceLog.resetParameter();
            SysMaintenanceLog.setRelatedId(nodeid);
            SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15545,user.getLanguage()));
            SysMaintenanceLog.setOperateType("3");
            SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_delete");
            SysMaintenanceLog.setOperateItem("87");
            SysMaintenanceLog.setOperateUserid(user.getUID());
            SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
            SysMaintenanceLog.setSysLogInfo();
        }
        int id = 0;
        sql = "select max(id) as id from workflow_nodegroup";
        RecordSet.executeSql(sql);
    
        if(RecordSet.next()){
          id = Util.getIntValue(Util.null2String(RecordSet.getString("id")),0);
        }
        id += 1;
      
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
        WFNodeOperatorManager.resetParameter();
        WFNodeOperatorManager.setId(id);
        WFNodeOperatorManager.setNodeid(nodeid);
        String groupname = Util.null2String(request.getParameter("groupname"));
        int canview = 1;
        WFNodeOperatorManager.setName(groupname);
        WFNodeOperatorManager.setCanview(canview);
        WFNodeOperatorManager.setAction("add");
        WFNodeOperatorManager.AddGroupInfo();
          String para="";  
        for(int i=0;i<rowsum;i++) {
          String type = Util.null2String(request.getParameter("group_"+i+"_type"));
          String virtualid = Util.null2String(request.getParameter("group_"+i+"_virtual"));
          String ruleRelationship = Util.null2String(request.getParameter("group_"+i+"_ruleRelationship"));
          String groupid = Util.null2String(request.getParameter("group_"+i+"_id"));
          int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
          int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
          String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
          String orders=Util.null2String(request.getParameter("group_"+i+"_order"));
          String signorder=Util.null2String(request.getParameter("group_"+i+"_signorder"));
          String IsCoadjutant=Util.null2String(request.getParameter("group_"+i+"_IsCoadjutant"));
          String signtype=Util.null2String(request.getParameter("group_"+i+"_signtype"));
          String issyscoadjutant=Util.null2String(request.getParameter("group_"+i+"_issyscoadjutant"));
          String coadjutants=Util.null2String(request.getParameter("group_"+i+"_coadjutants"));
          String issubmitdesc=Util.null2String(request.getParameter("group_"+i+"_issubmitdesc"));
          String ispending=Util.null2String(request.getParameter("group_"+i+"_ispending"));
          String isforward=Util.null2String(request.getParameter("group_"+i+"_isforward"));
          String ismodify=Util.null2String(request.getParameter("group_"+i+"_ismodify"));
          String Coadjutantconditions=Util.null2String(request.getParameter("group_"+i+"_Coadjutantconditions"));
          String bhxj=Util.null2String(request.getParameter("group_"+i+"_bhxj"));
          String jobfield=Util.null2String(request.getParameter("group_"+i+"_jobfield"));
          String jobobj=Util.null2String(request.getParameter("group_"+i+"_jobobj"));
          signorder = "-1".equals(signorder) ? "" : signorder;
          //对应为空，没选情况判断出来下
          if(signorder.equals("[object]")){
            signorder="";
          }
          
		  	String hrmgroupidn="";
		 	if(type.equals("3")){//一般类型：人力资源类型
		 		hrmgroupidn=groupid;
				groupid="0";
		 	}
          String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
          if (orders.equals("")) orders="0";
          if(!type.equals("")){
            String matrixValue = groupid;
  			//关联责任人

  			if ("99".equals(type)) {
  				groupid = "0";
  			}
            char flag=2;
            para=""+id+flag+type+flag+groupid+flag+level+flag+level2+flag+conditions+flag+conditioncn+flag+orders+flag+signorder+flag+IsCoadjutant+
                          flag+signtype+flag+issyscoadjutant+flag+issubmitdesc+flag+ispending+flag+isforward+flag+ismodify+flag+coadjutants+flag+Coadjutantconditions+flag+virtualid+flag+ruleRelationship;
            
            RecordSet.executeProc("workflow_groupdetail_Insert",para);
		   //处理部门、分部自定义字段
		   int maxID=-1;
		   if(RecordSet.next()){
		      maxID =Util.getIntValue(""+RecordSet.getInt(1));
		      RecordSet.execute("update workflow_groupdetail set bhxj ='"+bhxj+ "',jobobj ='"+jobobj+ "',jobfield ='"+jobfield+ "'  where id = " + maxID);
	       }
             if(type.equals("3")){//一般类型：人力资源类型
	        	  RecordSet.executeSql("delete from Workflow_HrmOperator where groupdetailid='"+maxID+"'");
		          //将人力资源类型值写入中间表中start==
		          List hrmoperatorlist=Util.TokenizerString(hrmgroupidn,",");
		          for(int j=0;j<hrmoperatorlist.size();j++){
			          RecordSet.executeSql("insert into Workflow_HrmOperator(type,objid,signorder,orders,groupid,groupdetailid)values('"+type+"','"+hrmoperatorlist.get(j)+"','"+signorder+"','"+j+"','"+id+"','"+maxID+"')");
		          }	  
	          //将人力资源类型值写入中间表中end== 
	          }
          }
        }
        int iscreate = Util.getIntValue(request.getParameter("iscreate"),0);
        if(iscreate==1 && wfid > 0){
          String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
          RequestCheckUser.setWorkflowid(wfid);
          RequestCheckUser.setNodeid(nodeid);
          RequestCheckUser.updateCreateList(id);
          RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);
        }
      
        //新增操作人组日志
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(nodeid);
        SysMaintenanceLog.setRelatedName(groupname);
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_insert");
        SysMaintenanceLog.setOperateItem("87");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
      }
      /* end 同步到其他路径创建节点***************************************/
  //System.out.println("--src--"+src);
////得到标记信息
	//System.out.println("src="+src);
  if(src.equalsIgnoreCase("addwf")){      
      int wfid=0;
    if(templateid>0){
		
        WFManager.reset();
        WFManager.setWfname(Util.null2String(request.getParameter("wfname")));
  	    WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));
		WFManager.setSubCompanyId2(subCompanyId);
		WFManager.setTypeid(Util.getIntValue(Util.null2String(request.getParameter("typeid"))));
        wfid=WFManager.setWFTemplate(templateid,isTemplate,user.getUID(),request.getRemoteAddr());
        WorkflowAllComInfo.removeWorkflowCache();
		WorkflowComInfo.removeWorkflowCache();
        TestWorkflowComInfo.removeWorkflowCache();
        
      	//将新添加的流程加入版本信息表
    	WorkflowVersion wv=new WorkflowVersion();
    	wv.saveWorkflowVersionInfo(wfid+"");
        
		RequestUserDefaultManager.addDefaultOfSysAdmin(String.valueOf(wfid));
		String hisWorkflowCreater="";
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);

    }else{
	WFManager.reset();
  	WFManager.setAction("addwf");
  	WFManager.setWfname(Util.null2String(request.getParameter("wfname")));
  	WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));        
  	WFManager.setTypeid(Util.getIntValue(Util.null2String(request.getParameter("typeid"))));
  	String isbill = Util.null2String(request.getParameter("isbill"));
  	int fnaWfType1 = -1;//自定义表单-费用类流程类型
  	int fnaWfType2 = -1;//自定义表单-费用类流程是否有事前流程
  	if("4".equals(isbill)){
  		isbill = "0";
  	  	fnaWfType1 = Util.getIntValue(request.getParameter("fnaWfType1"),-1);
  	  	fnaWfType2 = Util.getIntValue(request.getParameter("fnaWfType2"),-1);
  	}
  	String iscust = Util.null2String(request.getParameter("iscust"));
  	int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
    String isvalid= Util.null2String(request.getParameter("isvalid"));
    String needmark= Util.null2String(request.getParameter("needmark"));
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    String messageType= Util.null2String(request.getParameter("messageType"));
    //add by xwj  20051101 for 邮件提醒 td2965
    String mailMessageType= Util.null2String(request.getParameter("mailMessageType"));
    String archiveNoMsgAlert = Util.null2String(request.getParameter("archiveNoMsgAlert")); // 归档节点不需短信提醒
    String archiveNoMailAlert = Util.null2String(request.getParameter("archiveNoMailAlert")); // 归档节点不需邮件提醒
    String forbidAttDownload= Util.null2String(request.getParameter("forbidAttDownload"));
    String docRightByOperator= Util.null2String(request.getParameter("docRightByOperator"));
  	//微信提醒START(QC:98106)
    //add by fyg @ 20140319 for 微信提醒 
    String chatsType=Util.null2String(request.getParameter("chatsType"));
    String chatsAlertType=Util.null2String(request.getParameter("chatsAlertType"));
    String notRemindifArchived=Util.null2String(request.getParameter("notRemindifArchived")); 
  	//微信提醒END(QC:98106)
    //add by xhheng @ 20050302 for TD 1545
    String multiSubmit= Util.null2String(request.getParameter("multiSubmit"));
    //add by xhheng @ 20050303 for TD 1689
    String defaultName= Util.null2String(request.getParameter("defaultName"));

	if(defaultName.equals("1")){//标题默认增加规则
		DateUtil.InitializationWFTitle(""+wfid);
	}
	
	
    //add by xhheng @ 20050317 for 附件上传
    String pathcategory= Util.null2String(request.getParameter("pathcategory"));
    String maincategory= Util.null2String(request.getParameter("maincategory"));
    String subcategory= Util.null2String(request.getParameter("subcategory"));
    String seccategory= Util.null2String(request.getParameter("seccategory"));
    int docRightByHrmResource = Util.getIntValue(request.getParameter("docRightByHrmResource"),0);
    int hrmResourceShow = Util.getIntValue(request.getParameter("hrmResourceShow"),0);
    String isaffirmance= Util.null2String(request.getParameter("isaffirmance"));
   // String isSaveCheckForm = Util.null2String(request.getParameter("isSaveCheckForm")); // 流程保存是否验证必填
	String isremak= Util.null2String(request.getParameter("isremark"));
	String isShowChart= Util.null2String(request.getParameter("isShowChart"));
	String orderbytype= Util.null2String(request.getParameter("orderbytype"));
	String isModifyLog = Util.null2String(request.getParameter("isModifyLog"));
    String isannexUpload= Util.null2String(request.getParameter("isannexUpload"));
    String annexmaincategory= Util.null2String(request.getParameter("annexmaincategory"));
    String annexsubcategory= Util.null2String(request.getParameter("annexsubcategory"));
    String annexseccategory= Util.null2String(request.getParameter("annexseccategory"));
    String isShowOnReportInput= Util.null2String(request.getParameter("isShowOnReportInput"));
    String ShowDelButtonByReject=Util.null2String(request.getParameter("ShowDelButtonByReject"));
    
    String specialApproval=Util.null2String(request.getParameter("specialApproval"));//是否特批件



    String Frequency=Util.null2String(request.getParameter("Frequency"));
    if(Frequency.equals("")) Frequency = "0";
    String Cycle=Util.null2String(request.getParameter("Cycle"));
    
    String isimportwf=Util.null2String(request.getParameter("isimportwf"));
    String importReadOnlyField = Util.null2String(request.getParameter("importReadOnlyField")); // 允许导入数据到只读字段
    String fieldNotImport = Util.null2String(request.getParameter("fieldNotImport")); // 无需导入字段
	String wfdocpath = Util.null2String(request.getParameter("wfdocpath"));
	String newdocpath = Util.null2String(request.getParameter("newdocpath"));
	String wfdocowner = Util.null2String(request.getParameter("wfdocowner"));
	String wfdocownertype = ""+Util.getIntValue(request.getParameter("wfdocownertype"), 0);
	String wfdocownerfieldid = ""+Util.getIntValue(request.getParameter("wfdocownerfieldid"), 0);
	String isImportDetail= Util.null2String(request.getParameter("isImportDetail")); 
    String showUploadTab = Util.null2String(request.getParameter("showUploadTab"));
    String isSignDoc = Util.null2String(request.getParameter("isSignDoc"));
    String showDocTab = Util.null2String(request.getParameter("showDocTab"));
    String isSignWorkflow = Util.null2String(request.getParameter("isSignWorkflow"));
    String showWorkflowTab = Util.null2String(request.getParameter("showWorkflowTab"));
    int isshared = Util.getIntValue(request.getParameter("isshared"),0);
    int isforwardrights = Util.getIntValue(request.getParameter("isforwardrights"),0);
    String isrejectremind=Util.null2String(request.getParameter("isrejectremind"));
    String ischangrejectnode=Util.null2String(request.getParameter("ischangrejectnode"));
	   String isselectrejectnode=Util.null2String(request.getParameter("isselectrejectnode")); 
    String issignview = Util.null2String(request.getParameter("issignview"));
	String nosynfields = Util.null2String(request.getParameter("nosynfields"));
	String isneeddelacc=Util.null2String(request.getParameter("isneeddelacc"));
	String SAPSource = Util.null2String(request.getParameter("SAPSource"));
	String smsAlertsType = Util.null2String(request.getParameter("smsAlertsType"));	
	String isForwardReceiveDef = Util.null2String(request.getParameter("isForwardReceiveDef"));
	String isAutoApprove = Util.null2String(request.getParameter("isAutoApprove"));
	String isAutoCommit = Util.null2String(request.getParameter("isAutoCommit"));
	String isAutoRemark = Util.null2s(request.getParameter("isAutoRemark"),"0");
  int dsporder = Util.getIntValue(request.getParameter("dsporder"),0);
  	int submittype = Util.getIntValue(request.getParameter("submittype"),0);
  	String isFree = request.getParameter("isFree") == null ? "0" : "1";
    if("".equals(isneeddelacc))  isneeddelacc="0";
	int formid = 0;
 	formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));  		

 	boolean isFnaWfInitE8 = ("0".equals(isbill) && fnaWfType1 > 0 && (fnaWfType2 >= 0 && fnaWfType2 <= 2) && formid <= 0);
 	HashMap<String, Object> isFnaWfInitE8Hm = new HashMap<String, Object>();
  	if(isFnaWfInitE8){
  		try{
  			formid = FnaWfInitE8.initE8FnaWfForm(fnaWfType1, fnaWfType2, user.getUID(), user.getLanguage(), subCompanyId, isFnaWfInitE8Hm);
  		}catch(Exception ex1){
  			new BaseBean().writeLog(ex1);
  			out.print(ex1.getMessage());
  			return;
  		}
 	}
 	
	String tablename = "";
	RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
	if(RecordSet.next()) tablename = RecordSet.getString("tablename");
	if(tablename.equals("formtable_main_"+formid*(-1)) || tablename.startsWith("uf_")){//新创建的表单做为单据保存
		isbill = "1";
	}
	/**
  	if(isbill.equals("0")){
  			formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));  		
			String tablename = "";
			RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
			if(RecordSet.next()) tablename = RecordSet.getString("tablename");
			if(tablename.equals("formtable_main_"+formid*(-1)) || tablename.startsWith("uf_")){//新创建的表单做为单据保存
				isbill = "1";
			}
  	}else {
  		formid = Util.getIntValue(Util.null2String(request.getParameter("billid")));
  		if (isbill.equals("1") && formid == -1)
  					formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
    }
    **/
  	
  	//是否允许创建人删除附件



  	String candelacc= Util.null2String(request.getParameter("candelacc"));
  	
  	WFManager.setFormid(formid);
  	WFManager.setIsBill(isbill);
  	WFManager.setIsCust(iscust);
  	WFManager.setHelpdocid(helpdocid);
    WFManager.setIsValid(isvalid);
    WFManager.setNeedMark(needmark);
    WFManager.setMessageType(messageType);
    WFManager.setMailMessageType(mailMessageType);//added by xwj for td2965 20051101
    //微信提醒START(QC:98106)
    WFManager.setChatsType(chatsType);  //add by fyg @ 20140319 for 微信提醒 
    WFManager.setChatsAlertType(chatsAlertType);  //add by fyg @ 20140319 for 微信提醒 
    WFManager.setNotRemindifArchived(notRemindifArchived);  //add by fyg @ 20140319 for 微信提醒
    //微信提醒END(QC:98106)
    WFManager.setArchiveNoMsgAlert(archiveNoMsgAlert);
    WFManager.setArchiveNoMailAlert(archiveNoMailAlert);
    WFManager.setForbidAttDownload(forbidAttDownload);
    WFManager.setDocRightByOperator(docRightByOperator);
    WFManager.setMultiSubmit(multiSubmit);
    WFManager.setDefaultName(defaultName);
    WFManager.setDocCategory(maincategory+","+subcategory+","+seccategory);
    WFManager.setDocPath(pathcategory);
    WFManager.setSubCompanyId2(subCompanyId);
    WFManager.setIsTemplate(isTemplate);
    WFManager.setTemplateid(templateid);
    WFManager.setCatelogType(catelogType);
    WFManager.setSelectedCateLog(selectedCateLog);
    WFManager.setDocRightByHrmResource(docRightByHrmResource);
    WFManager.setHrmResourceShow(hrmResourceShow);
    WFManager.setIsaffirmance(isaffirmance);
   // WFManager.setIsSaveCheckForm(isSaveCheckForm);
	  WFManager.setIsremak(isremak);
	  WFManager.setIsShowChart(isShowChart);
	  WFManager.setOrderbytype(orderbytype);
    WFManager.setIsAnnexUpload(isannexUpload);
    WFManager.setAnnexDocCategory(annexmaincategory+","+annexsubcategory+","+annexseccategory);
    WFManager.setIsShowOnReportInput(isShowOnReportInput);
    WFManager.setIsModifyLog(isModifyLog);
    WFManager.setShowDelButtonByReject(ShowDelButtonByReject);
    
    WFManager.setSpecialApproval(specialApproval);
    WFManager.setFrequency(Frequency);
    WFManager.setCycle(Cycle);
    
    WFManager.setIsImportwf(isimportwf);
    WFManager.setImportReadOnlyField(importReadOnlyField);
    WFManager.setFieldNotImport(fieldNotImport);
	  WFManager.setWfdocpath(wfdocpath);
	  WFManager.setWfdocowner(wfdocowner);
	  WFManager.setWfdocownertype(wfdocownertype);
	  WFManager.setWfdocownerfieldid(wfdocownerfieldid);
    WFManager.setShowUploadTab(showUploadTab);
    WFManager.setSignDoc(isSignDoc);
    WFManager.setShowDocTab(showDocTab);
    WFManager.setSignWorkflow(isSignWorkflow);
    WFManager.setShowWorkflowTab(showWorkflowTab);
    WFManager.setCanDelAcc(candelacc);
    WFManager.setIsshared(""+isshared);
    WFManager.setIsforwardRights(""+isforwardrights);
    WFManager.setIsrejectremind(isrejectremind);
    WFManager.setIschangrejectnode(ischangrejectnode);
    WFManager.setNewdocpath(newdocpath);
    WFManager.setIssignview(issignview);
	  WFManager.setNosynfields(nosynfields);
	  WFManager.setSAPSource(SAPSource);
    WFManager.setIsSelectrejectNode(isselectrejectnode);
	  WFManager.setIsImportDetail(isImportDetail);
	  WFManager.setIsneeddelacc(isneeddelacc);
	  WFManager.setSmsAlertsType(smsAlertsType);
	  WFManager.setIsForwardReceiveDef(isForwardReceiveDef);
    WFManager.setDsporder(dsporder);
    WFManager.setIsFree(isFree);
    WFManager.setIsAutoApprove(isAutoApprove);
    WFManager.setIsAutoCommit(isAutoCommit);
    WFManager.setIsAutoRemark(isAutoRemark);
    WFManager.setSubmittype(submittype);
    try{
        wfid=WFManager.setWfInfo();
    }catch (Exception e){
        new weaver.general.BaseBean().writeLog(e);
        out.println("<h2 style='text-align: center;'>"+SystemEnv.getHtmlLabelName(383324,user.getLanguage())+"</h2>");
        return;
    }
    WorkflowAllComInfo.removeWorkflowCache();
    WorkflowComInfo.removeWorkflowCache();
    TestWorkflowComInfo.removeWorkflowCache();
	  RequestUserDefaultManager.addDefaultOfSysAdmin(String.valueOf(wfid));

	//将新添加的流程加入版本信息表
	WorkflowVersion wv=new WorkflowVersion();
	wv.saveWorkflowVersionInfo(wfid+"");
	
    //Start 手机接口功能 by alan
    RecordSet.executeSql("DELETE FROM workflow_mgmsworkflows WHERE workflowid="+wfid);
    if(Util.null2String(request.getParameter("isMgms")).equals("1")){
    	RecordSet.executeSql("INSERT INTO workflow_mgmsworkflows(workflowid) VALUES ("+wfid+")");
    }	
    //End 手机接口功能
    
    //add by xhheng @ 2004/12/08 for TDID 1317 start
    //新增工作流日志



    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(wfid);
    SysMaintenanceLog.setRelatedName(Util.null2String(request.getParameter("wfname")));
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("WrokFlow_insert");
    SysMaintenanceLog.setOperateItem("85");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));
    SysMaintenanceLog.setSysLogInfo();
    //add by xhheng @ 2004/12/08 for TDID 1317 end
    //when the workflow is free, create two default node:create node and end node.
   	if( isFree.equals("1") ){
        //create create node
        WFNodeMainManager.resetParameter();
        WFNodeMainManager.setWfid(wfid);
        WFNodeMainManager.setFormid(formid);
        WFNodeMainManager.setNodename(SystemEnv.getHtmlLabelName(125,user.getLanguage()));
        WFNodeMainManager.setNodetype("0");
        WFNodeMainManager.setNodeorder(1);
        WFNodeMainManager.setNodeattribute("0");
        WFNodeMainManager.setNodepassnum(0);
        WFNodeMainManager.setIsbill(Integer.valueOf(isbill));
        WFNodeMainManager.setIsFreeWorkflow("1");
        WFNodeMainManager.setDrawxpos(70);
        WFNodeMainManager.setDrawypos(70);
        //自由流程创建节点默认可以自由退回



        WFNodeMainManager.setFreefs("2");

        WFNodeMainManager.saveWfNode();
        int createNodeId = WFNodeMainManager.getNodeid2();
        
        //create node log
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(wfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(125,user.getLanguage()));
        SysMaintenanceLog.setOperateItem("86");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("WrokFlowNode_insert");
        SysMaintenanceLog.setSysLogInfo();

        //create end node
        WFNodeMainManager.resetParameter();
        WFNodeMainManager.setWfid(wfid);
        WFNodeMainManager.setFormid(formid);
        WFNodeMainManager.setNodename(SystemEnv.getHtmlLabelName(251,user.getLanguage()));
        WFNodeMainManager.setNodetype("3");
        WFNodeMainManager.setNodeorder(2);
        WFNodeMainManager.setNodeattribute("0");
        WFNodeMainManager.setNodepassnum(0);
        WFNodeMainManager.setIsbill(Integer.valueOf(isbill));
        WFNodeMainManager.setIsFreeWorkflow("1");
        WFNodeMainManager.setDrawxpos(190);
        WFNodeMainManager.setDrawypos(70);

        WFNodeMainManager.saveWfNode();
        int endNodeId = WFNodeMainManager.getNodeid2();

        //end node log
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(wfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(251,user.getLanguage()));
        SysMaintenanceLog.setOperateItem("86");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("WrokFlowNode_insert");
        SysMaintenanceLog.setSysLogInfo();

        //create portal
        WFNodePortalMainManager.resetParameter();
        WFNodePortalMainManager.setWfid(wfid);
        WFNodePortalMainManager.setNodeid(createNodeId);
        WFNodePortalMainManager.setIsreject("0");
        WFNodePortalMainManager.setLinkorder(0);
        WFNodePortalMainManager.setLinkname(SystemEnv.getHtmlLabelName(251,user.getLanguage()));
        WFNodePortalMainManager.setDestnodeid(endNodeId);
        WFNodePortalMainManager.setPasstime(-1);
        WFNodePortalMainManager.setIsBulidCode("1");
        WFNodePortalMainManager.setIsMustPass("0");
        WFNodePortalMainManager.setTipsinfo(SystemEnv.getHtmlLabelName(251,user.getLanguage()));   
        WFNodePortalMainManager.setStartDirection(90);
        WFNodePortalMainManager.setEndDirection(0); 
        WFNodePortalMainManager.saveWfNodePortal();


        //portal log
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(wfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(251,user.getLanguage()));
        SysMaintenanceLog.setOperateItem("88");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_insert");
        SysMaintenanceLog.setSysLogInfo();
      }

  	  if(isFnaWfInitE8){
  		try{
  			FnaWfInitE8.initE8FnaWfNode(fnaWfType1, fnaWfType2, user.getUID(), user.getLanguage(), wfid, formid, subCompanyId, isFnaWfInitE8Hm);
  		}catch(Exception ex1){
  	  		try{
  	  			//失败则删除当前流程
	  		    SysMaintenanceLog.resetParameter();
	  		    SysMaintenanceLog.setRelatedId(wfid);
	  		    //modify by xhheng @20050104 for TD 1317
	  		    WFManager.setWfid(wfid);
	  		    WFManager.getWfInfo();
	  		    SysMaintenanceLog.setRelatedName(WFManager.getWfname());
	  		    SysMaintenanceLog.setOperateType("3");
	  		    SysMaintenanceLog.setOperateDesc("WrokFlow_delete");
	  		    SysMaintenanceLog.setOperateItem("85");
	  		    SysMaintenanceLog.setOperateUserid(user.getUID());
	  		    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	  		    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));    
	  		    SysMaintenanceLog.setSysLogInfo();

				new WFMainManager().DeleteWf(new String[]{wfid+""});
				
	  	  		WorkflowAllComInfo.removeWorkflowCache();
	  	  		WorkflowComInfo.removeWorkflowCache();
	  	  		TestWorkflowComInfo.removeWorkflowCache();
	  	  		new WorkflowComInfo2().removeWorkflowCache();
  	  		}catch(Exception ex2){
  	  		}
  			new BaseBean().writeLog(ex1);
  			out.print(ex1.getMessage());
  			return;
  		}
 	  }
    }

//    WorkflowComInfo.removeWorkflowCache();
  //tagtag4prjwf
    String from=Util.null2String(request.getParameter("from"));
    if("prjwf".equalsIgnoreCase(from)){
    	response.sendRedirect("addwf0.jsp?isprjwfclose=1&from=prjwf&src=editwf&isloadleft=1&wfid="+wfid+"&isTemplate="+isTemplate+"&isrefresh=1");
    	return;
    }
    if(!ajax.equals("1"))
    	response.sendRedirect("managewf.jsp");
    else{
    	response.sendRedirect("addwf0.jsp?src=editwf&isloadleft=1&wfid="+wfid+"&isTemplate="+isTemplate+"&isrefresh=1");
    }
    return;

  }
  else if(src.equalsIgnoreCase("editwf")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	
    String oldisbill = Util.null2String(request.getParameter("oldisbill"));
  	String oldiscust = Util.null2String(request.getParameter("oldiscust"));
  	String isbill = Util.null2String(request.getParameter("isbill"));
  	String iscust = Util.null2String(request.getParameter("iscust"));
  	int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
    String isvalid= Util.null2String(request.getParameter("isvalid"));
    String needmark= Util.null2String(request.getParameter("needmark"));
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    String messageType= Util.null2String(request.getParameter("messageType"));
     //add by xwj  20051101 for 邮件提醒 td2965
    String mailMessageType= Util.null2String(request.getParameter("mailMessageType"));
    String archiveNoMsgAlert = Util.null2String(request.getParameter("archiveNoMsgAlert")); // 归档节点不需短信提醒
    String archiveNoMailAlert = Util.null2String(request.getParameter("archiveNoMailAlert")); // 归档节点不需邮件提醒
    String forbidAttDownload= Util.null2String(request.getParameter("forbidAttDownload"));
    String docRightByOperator= Util.null2String(request.getParameter("docRightByOperator"));
    //微信提醒START(QC:98106)
    //add by fyg @ 20140319 for 微信提醒 
    String chatsType=Util.null2String(request.getParameter("chatsType")); 
    String chatsAlertType=Util.null2String(request.getParameter("chatsAlertType"));
    String notRemindifArchived=Util.null2String(request.getParameter("notRemindifArchived"));
  	//微信提醒END(QC:98106)
    //add by xhheng @ 20050302 for TD 1545
    String multiSubmit= Util.null2String(request.getParameter("multiSubmit"));
    //add by xhheng @ 20050303 for TD 1689
    String defaultName= Util.null2String(request.getParameter("defaultName"));
	 

	if(defaultName.equals("1")){//标题默认增加规则
		DateUtil.InitializationWFTitle(""+wfid);
	}
    //add by xhheng @ 20050317 for 附件上传
    String pathcategory= Util.null2String(request.getParameter("pathcategory"));
    String maincategory= Util.null2String(request.getParameter("maincategory"));
    String subcategory= Util.null2String(request.getParameter("subcategory"));
    String seccategory= Util.null2String(request.getParameter("seccategory"));
    int docRightByHrmResource = Util.getIntValue(request.getParameter("docRightByHrmResource"),0);
    int hrmResourceShow = Util.getIntValue(request.getParameter("hrmResourceShow"),0);
    String isaffirmance= Util.null2String(request.getParameter("isaffirmance"));
   // String isSaveCheckForm = Util.null2String(request.getParameter("isSaveCheckForm")); // 流程保存是否验证必填
	String isremak= Util.null2String(request.getParameter("isremark"));
	String isShowChart= Util.null2String(request.getParameter("isShowChart"));
	String orderbytype= Util.null2String(request.getParameter("orderbytype"));
	String isModifyLog= Util.null2String(request.getParameter("isModifyLog"));
    String isannexUpload= Util.null2String(request.getParameter("isannexUpload"));
    String annexmaincategory= Util.null2String(request.getParameter("annexmaincategory"));
    String annexsubcategory= Util.null2String(request.getParameter("annexsubcategory"));
    String annexseccategory= Util.null2String(request.getParameter("annexseccategory"));
    String isShowOnReportInput= Util.null2String(request.getParameter("isShowOnReportInput"));
    String ShowDelButtonByReject=Util.null2String(request.getParameter("ShowDelButtonByReject"));
    
    String specialApproval=Util.null2String(request.getParameter("specialApproval"));
    String Frequency=Util.null2String(request.getParameter("Frequency"));
    if(Frequency.equals("")) Frequency = "0";
    String Cycle=Util.null2String(request.getParameter("Cycle"));
    
    String isimportwf=Util.null2String(request.getParameter("isimportwf"));
    String importReadOnlyField = Util.null2String(request.getParameter("importReadOnlyField")); // 允许导入数据到只读字段
    String fieldNotImport = Util.null2String(request.getParameter("fieldNotImport"));
	String wfdocpath = Util.null2String(request.getParameter("wfdocpath"));
	String wfdocowner = Util.null2String(request.getParameter("wfdocowner"));
	String wfdocownertype = ""+Util.getIntValue(request.getParameter("wfdocownertype"), 0);
	String wfdocownerfieldid = ""+Util.getIntValue(request.getParameter("wfdocownerfieldid"), 0);
    String showUploadTab = Util.null2String(request.getParameter("showUploadTab"));
    String isImportDetail= Util.null2String(request.getParameter("isImportDetail")); 
	String isSignDoc = Util.null2String(request.getParameter("isSignDoc"));
    String showDocTab = Util.null2String(request.getParameter("showDocTab"));
    String isSignWorkflow = Util.null2String(request.getParameter("isSignWorkflow"));
    String showWorkflowTab = Util.null2String(request.getParameter("showWorkflowTab"));
    int isshared = Util.getIntValue(request.getParameter("isshared"),0);
    int isforwardrights = Util.getIntValue(request.getParameter("isforwardrights"),0);
    String isrejectremind=Util.null2String(request.getParameter("isrejectremind"));
	   String isselectrejectnode=Util.null2String(request.getParameter("isselectrejectnode"));
   String ischangrejectnode=Util.null2String(request.getParameter("ischangrejectnode")); 
    String issignview = Util.null2String(request.getParameter("issignview"));
	String nosynfields = Util.null2String(request.getParameter("nosynfields"));
	String SAPSource = Util.null2String(request.getParameter("SAPSource"));
	
	String isfnacontrol = Util.null2String(request.getParameter("isfnacontrol"));
	String fnanodeid = Util.null2String(request.getParameter("fnanodeid"));
	String fnadepartmentid = Util.null2String(request.getParameter("fnadepartmentid"));
	String smsAlertsType = Util.null2String(request.getParameter("smsAlertsType"));
	String isForwardReceiveDef = Util.null2String(request.getParameter("isForwardReceiveDef"));
	String isAutoApprove = Util.null2String(request.getParameter("isAutoApprove"));
	String isAutoCommit = Util.null2String(request.getParameter("isAutoCommit"));
	String isAutoRemark = Util.null2s(request.getParameter("isAutoRemark"),"0");
  int dsporder = Util.getIntValue(request.getParameter("dsporder"),0);
  	int submittype = Util.getIntValue(request.getParameter("submittype"),0);
	//System.out.println("isfnacontrol="+isfnacontrol);
	//System.out.println("fnanodeid="+fnanodeid);
	//System.out.println("fnadepartmentid="+fnadepartmentid);
	
	
    int formid = 0;
    int oldformid=Util.getIntValue(Util.null2String(request.getParameter("oldformid")));
	String newdocpath = Util.null2String(request.getParameter("newdocpath"));
	String isneeddelacc=Util.null2String(request.getParameter("isneeddelacc"));
	 if("".equals(isneeddelacc))  isneeddelacc="0";
	RecordSet.executeSql("select * from workflow_base where id = " + wfid);
	if(RecordSet.next()){
		wfdocpath = RecordSet.getString("wfdocpath");
		wfdocowner = RecordSet.getString("wfdocowner");
		wfdocownertype = RecordSet.getString("wfdocownertype");
		wfdocownerfieldid = RecordSet.getString("wfdocownerfieldid");
	}

  	if(isbill.equals("0")){
  		formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
  		String tablename = "";
			RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
			if(RecordSet.next()) tablename = RecordSet.getString("tablename");
			if(tablename.equals("formtable_main_"+formid*(-1)) || tablename.startsWith("uf_")){//新创建的表单做为单据保存
				isbill = "1";
			}
  	}
  	else
  		formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
    //是否允许创建人删除附件



    String candelacc= Util.null2String(request.getParameter("candelacc"));
    
    if(Util.getIntValue(iscust)<Util.getIntValue(oldiscust)){ 
        //清除type＝20～25的操作组
        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.clearWFCRM();
    }
    if("3".equals(oldisbill) && formid>0){
        //增加新表单字段信息



        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.setFormid(formid);
  	    WFManager.setIsBill(isbill);
        WFManager.addWFFieldInfo();
    }
    if(!"3".equals(oldisbill) && !isbill.equals(oldisbill)){
        //清除附加操作中关联的字段信息、字段显示信息及模板信息、出口条件信息，增加新表单字段信息



        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.setIsBill(isbill);
        WFManager.setFormid(formid);
        WFManager.clearWFFormInfo();
    }
    if(!"3".equals(oldisbill) && isbill.equals(oldisbill) && oldformid!=formid){
        //清除附加操作中关联的字段信息、字段显示信息及模板信息、出口条件信息，增加新表单字段信息



        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.setIsBill(isbill);
        WFManager.setFormid(formid);
        WFManager.clearWFFormInfo();
    }
    //有时候subcompanyid 莫名其妙会变为-1，这里验证下
    if(subCompanyId == -1){
        WFManager.reset();
        WFManager.setWfid(wfid);
        WFManager.getWfInfo();
        subCompanyId = WFManager.getSubCompanyId2();
    }
    
    WFManager.reset();
  	WFManager.setAction("editwf");
  	WFManager.setWfid(wfid);
  	WFManager.setWfname(Util.null2String(request.getParameter("wfname")));
  	WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));
  	WFManager.setTypeid(Util.getIntValue(Util.null2String(request.getParameter("typeid"))));
    WFManager.setOldTypeid(Util.getIntValue(Util.null2String(request.getParameter("oldtypeid"))));
    WFManager.setSubCompanyId2(subCompanyId);

  	WFManager.setFormid(formid);
  	WFManager.setIsBill(isbill);
  	WFManager.setIsCust(iscust);
  	WFManager.setHelpdocid(helpdocid);
    WFManager.setIsValid(isvalid);
    WFManager.setNeedMark(needmark);
    WFManager.setMessageType(messageType);
    WFManager.setMailMessageType(mailMessageType);//added by xwj for td2965 20051101
    //微信提醒START(QC:98106)
    WFManager.setChatsType(chatsType);  //add by fyg @ 20140319 for 微信提醒 
    WFManager.setChatsAlertType(chatsAlertType);  //add by fyg @ 20140319 for 微信提醒 
    WFManager.setNotRemindifArchived(notRemindifArchived);  //add by fyg @ 20140319 for 微信提醒 
    //微信提醒END(QC:98106)
    WFManager.setArchiveNoMsgAlert(archiveNoMsgAlert);
    WFManager.setArchiveNoMailAlert(archiveNoMailAlert);
    WFManager.setForbidAttDownload(forbidAttDownload);
    WFManager.setDocRightByOperator(docRightByOperator);
    WFManager.setMultiSubmit(multiSubmit);
    WFManager.setDefaultName(defaultName);
    WFManager.setDocCategory(maincategory+","+subcategory+","+seccategory);
    WFManager.setDocPath(pathcategory);
    WFManager.setTemplateid(templateid);
    WFManager.setCatelogType(catelogType);
    WFManager.setSelectedCateLog(selectedCateLog);
    WFManager.setDocRightByHrmResource(docRightByHrmResource);
    WFManager.setHrmResourceShow(hrmResourceShow);
    WFManager.setIsaffirmance(isaffirmance);
   // WFManager.setIsSaveCheckForm(isSaveCheckForm);
	WFManager.setIsremak(isremak);
	WFManager.setIsShowChart(isShowChart);
	WFManager.setOrderbytype(orderbytype);
	WFManager.setIsModifyLog(isModifyLog);
    WFManager.setIsAnnexUpload(isannexUpload);
    WFManager.setAnnexDocCategory(annexmaincategory+","+annexsubcategory+","+annexseccategory);
    WFManager.setIsShowOnReportInput(isShowOnReportInput);
    WFManager.setShowDelButtonByReject(ShowDelButtonByReject);
    WFManager.setNosynfields(nosynfields);
    WFManager.setSAPSource(SAPSource);
    WFManager.setSpecialApproval(specialApproval);
    WFManager.setFrequency(Frequency);
    WFManager.setCycle(Cycle);
    
    WFManager.setIsImportwf(isimportwf);
    WFManager.setImportReadOnlyField(importReadOnlyField);
    WFManager.setFieldNotImport(fieldNotImport);
	WFManager.setWfdocpath(wfdocpath);
	WFManager.setWfdocowner(wfdocowner);
	WFManager.setWfdocownertype(wfdocownertype);
	WFManager.setWfdocownerfieldid(wfdocownerfieldid);
    WFManager.setShowUploadTab(showUploadTab);
    WFManager.setSignDoc(isSignDoc);
    WFManager.setShowDocTab(showDocTab);
    WFManager.setSignWorkflow(isSignWorkflow);
    WFManager.setShowWorkflowTab(showWorkflowTab);
    WFManager.setCanDelAcc(candelacc);
    WFManager.setIsshared(""+isshared);
    WFManager.setIsforwardRights(""+isforwardrights);
    WFManager.setIsrejectremind(isrejectremind);
    WFManager.setIschangrejectnode(ischangrejectnode);  
	WFManager.setNewdocpath(newdocpath);
	WFManager.setIssignview(issignview);
	  WFManager.setIsSelectrejectNode(isselectrejectnode);
	  	WFManager.setIsImportDetail(isImportDetail);
	  	WFManager.setIsneeddelacc(isneeddelacc);
	  	WFManager.setSmsAlertsType(smsAlertsType);
		WFManager.setIsForwardReceiveDef(isForwardReceiveDef);
    WFManager.setDsporder(dsporder);
    WFManager.setIsAutoApprove(isAutoApprove);
    WFManager.setIsAutoCommit(isAutoCommit);
    WFManager.setIsAutoRemark(isAutoRemark);
    WFManager.setSubmittype(submittype);
      try{
    WFManager.setWfInfo();
      }catch (Exception e){
          new weaver.general.BaseBean().writeLog(e);
          out.println("<h2 style='text-align: center;'>"+SystemEnv.getHtmlLabelName(383324,user.getLanguage())+"</h2>");
          return;
      }
    
    //保存submitnode
    String submitnodes = "";
    if("1".equals(multiSubmit)){
    	if(submittype == 1){
    		submitnodes = Util.null2String(request.getParameter("submitnode"));
    	}else if(submittype == 2){
    		submitnodes = Util.null2String(request.getParameter("submitnode2"));
    	}
    }
    
    rs.execute("update workflow_flownode set batchsubmit = 0 where workflowid = " + wfid + " and batchsubmit = 1");
    if(!"".equals(submitnodes)){
		if(submitnodes.startsWith(","))
			submitnodes = submitnodes.substring(1);
		if(submitnodes.endsWith(","))
			submitnodes = submitnodes.substring(0,submitnodes.length() - 1);
		
		rs.execute("update workflow_flownode set batchsubmit = 1 where workflowid = " + wfid + " and nodeid in ("+submitnodes+")");
	}

    //Start 手机接口功能 by alan
    RecordSet.executeSql("DELETE FROM workflow_mgmsworkflows WHERE workflowid="+wfid);
    if(Util.null2String(request.getParameter("isMgms")).equals("1")){
    	RecordSet.executeSql("INSERT INTO workflow_mgmsworkflows(workflowid) VALUES ("+wfid+")");
    }	
    //End 手机接口功能
    
    //add by xhheng @ 2004/12/08 for TDID 1317 start
    //修改工作流日志



    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(wfid);
    SysMaintenanceLog.setRelatedName(Util.null2String(request.getParameter("wfname")));
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("WrokFlow_update");
    SysMaintenanceLog.setOperateItem("85");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));
    SysMaintenanceLog.setSysLogInfo();
    //add by xhheng @ 2004/12/08 for TDID 1317 end
    
    
    
    //更新相关费控字段的值



    if(isfnacontrol.equals("")){
    	RecordSet.executeSql("update workflow_base set isfnacontrol='' where id="+wfid);
    	RecordSet.executeSql("update workflow_base set fnanodeid='' where id="+wfid);
    	RecordSet.executeSql("update workflow_base set fnadepartmentid='' where id="+wfid);
    }else{
	    RecordSet.executeSql("update workflow_base set isfnacontrol='"+isfnacontrol+"' where id="+wfid);
	    if(!fnanodeid.equals("")){
	    	RecordSet.executeSql("update workflow_base set fnanodeid='"+fnanodeid+"' where id="+wfid);
	    }
	    if(!fnadepartmentid.equals("")){
	    	RecordSet.executeSql("update workflow_base set fnadepartmentid='"+fnadepartmentid+"' where id="+wfid);
	    }
    }
    
    
    
    WorkflowAllComInfo.removeWorkflowCache();
    WorkflowComInfo.removeWorkflowCache();
    TestWorkflowComInfo.removeWorkflowCache();
    if(!ajax.equals("1")){
    response.sendRedirect("managewfTab.jsp");
    }else{
    response.sendRedirect("addwf0.jsp?ajax=1&src=editwf&wfid="+wfid+"&isTemplate="+isTemplate);
    }
    return;

  }
  else if(src.equalsIgnoreCase("bywhat")){

  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	int bywhat=Util.getIntValue(Util.null2String(request.getParameter("bywhat")),0);
  	String[] userids = request.getParameterValues("userids");
  	String tmp = "";
  	if(userids!=null){
  	for(int i=0;i<userids.length;i++){
  		String ismanager = Util.null2String(request.getParameter("ismanager_"+userids[i]));
  		if(ismanager.equals("1"))
  			tmp += ",M"+userids[i];
  		else
  			tmp += ","+userids[i];
  	}
  	}
  	if(bywhat ==0){
  		if(!tmp.equals("")){
  			tmp = tmp.substring(1);
  		}
  		String sql = "update workflow_nodebase set userbyform='0',userids='"+tmp+"' where id="+nodeid;
  		RecordSet.executeSql(sql);
  	}
  	else if(bywhat == 1){
  		String sql = "update workflow_nodebase set userbyform='1' where id = "+nodeid;
  		RecordSet.executeSql(sql);
  	}
  	  response.sendRedirect("Editwfnode.jsp?wfid="+wfid);
  	  return;


  }
  else if(src.equalsIgnoreCase("delgroups")){

  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
    //add by xhheng @ 2004/12/10 for TDID 1448
    String nodetype=Util.null2String(request.getParameter("nodetype"));
  	String iscust=Util.null2String(request.getParameter("iscust"));
  	String[] deleteids = request.getParameterValues("delete_wf_id");

  	String tmp = "";

	 nodetype="";
	char flag=2;
	RecordSet.executeProc("workflow_NodeType_Select",""+wfid+flag+nodeid);

	if(RecordSet.next())
		nodetype = RecordSet.getString("nodetype");

  	if(deleteids!=null){
	  	for(int i=0;i<deleteids.length;i++){
	  		tmp = deleteids[i];
	  		//先要删除相关负责人矩阵



	  		GroupDetailMatrix.deleteAllByGroup(RecordSet, tmp);
	  		GroupDetailMatrixDetail.deleteAllByGroup(RecordSet, tmp);

	  		RecordSet.executeProc("workflow_nodegroup_Delete",tmp);
	  		RecordSet.executeProc("workflow_groupdetail_DbyGroup",tmp);
	  		String sql1 = " update workflow_nodebase set totalgroups=totalgroups-1 where id = "+nodeid;
	  		RecordSet.executeSql(sql1);
	  		RecordSet.executeSql(" delete Workflow_HrmOperator  where groupid='"+tmp+"'  ");
        //add by xhheng @ 2004/12/10 for TDID 1448
        //创建节点时，才做创建人表更新
	        if(nodetype!=null && nodetype.equals("0")){
			  
		         // RequestCheckUser.setWorkflowid(wfid);
		         // RequestCheckUser.updateCreateList(Util.getIntValue(tmp));
		       
				String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
				RequestCheckUser.setWorkflowid(wfid);
				RequestCheckUser.setNodeid(nodeid);
			    RequestCheckUser.updateCreateList(Util.getIntValue(tmp));
				RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);
	        }
	  	}
  	}

    //add by xhheng @ 2004/12/08 for TDID 1317 start
    //删除节点操作组日志



    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(nodeid);
    SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15545,user.getLanguage()));
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_delete");
    SysMaintenanceLog.setOperateItem("87");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    //add by xhheng @ 2004/12/08 for TDID 1317 end
	if(design==1)//add by cyril on 2008-12-10
		response.sendRedirect("addnodeoperator.jsp?design="+design+"&wfid="+wfid+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust);
	else
  	  	response.sendRedirect("/workflow/workflow/editoperatorgroup.jsp?isclose=1");
  	  return;
 // response.sendRedirect("addnodeoperator.jsp?wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&iscust="+iscust+"&formid="+formid);

  }
  else if(src.equalsIgnoreCase("wfnodeadd")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isSaveNewVersionAndEdit=Util.null2String(request.getParameter("isSaveNewVersionAndEdit"));
  	String delids = Util.null2String(request.getParameter("delids"));
  	//保存为新模板
  	int newwfid = -1 ;
    WorkflowVersion wv=new WorkflowVersion(""+wfid);
  	if("1".equals(isSaveNewVersionAndEdit)){
	    newwfid = wv.saveAsVersion(user,"",request.getRemoteAddr());  	  
  	    //wv.setActiveVersion();
  	    if(delids.startsWith(",")){
    	      delids = delids.substring(1);
   	    }
  	    delids = wv.getWFNodesByParentNodeIDs(newwfid+"",delids);
  	}
  	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
    
  	int createnum = 0;

  	String sqltmp = "";

//  	if(!delids.equals("")){
//  		delids = delids.substring(1);
//	  	String del_ids[] =Util.TokenizerString2(delids,",");
//		for(int i=0;i<del_ids.length;i++){
//			int tmpid = Util.getIntValue(del_ids[i]);
//			sqltmp = " select count(nodeid) from workflow_flownode where nodeid="+tmpid+" and nodetype='0'";
//			RecordSet.executeSql(sqltmp);
//  			if(RecordSet.next())
//  				createnum -= RecordSet.getInt(1);
//  		}
//	}
	for(int i=0;i<rowsum;i++) {
		String tmptype = Util.null2String(request.getParameter("node_"+i+"_type"));
		if(tmptype.equals("0")){
			createnum += 1;
		}
	}
	if(createnum != 1){
        if(!ajax.equals("1"))
        response.sendRedirect("addwfnode.jsp?message=1&wfid="+wfid);
        else
        response.sendRedirect("addwfnode.jsp?ajax=1&message=1&wfid="+wfid);
        return;
	}

  	if(!delids.equals("")){
	  	String del_ids[] =Util.TokenizerString2(delids,",");
	  	WFNodeMainManager.resetParameter();
        WFNodeMainManager.deleteWfNode(del_ids,user.getUID());
      //add by xhheng @ 2004/12/08 for TDID 1317 start
      //删除节点日志
      for(int i=0;i<del_ids.length;i++){
        SysMaintenanceLog.resetParameter();
        //记录工作流id
        SysMaintenanceLog.setRelatedId(newwfid == -1 ?wfid:newwfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15070,user.getLanguage()));
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("WrokFlowNode_delete");
        SysMaintenanceLog.setOperateItem("86");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
      }
      //add by xhheng @ 2004/12/08 for TDID 1317 end
	}

    //add by mackjoe at 2005-12-19 表单中是否设置了模板
    int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),0);
    String ismode="0";
    RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"'");
    if(RecordSet.next()){
        ismode="1";
    }
    //end by mackjoe
	for(int i=0;i<rowsum;i++) {
		WFNodeMainManager.resetParameter();
		WFNodeMainManager.setWfid(newwfid == -1 ?wfid:newwfid);
		WFNodeMainManager.setFormid(formid);
		String nodename = Util.null2String(request.getParameter("node_"+i+"_name"));
		int nodeid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_id")),0);
		if(newwfid != -1){
			nodeid = Util.getIntValue(wv.getWFNodesByParentNodeIDs(newwfid+"",nodeid+""),-1);
		}
		int nodeorder = Util.getIntValue(Util.null2String(request.getParameter("node_order_" + i)), -1);
		String nodetype = Util.null2String(request.getParameter("node_"+i+"_type"));
        String nodeattribute = Util.null2String(request.getParameter("node_"+i+"_attribute"));
        int nodepassnum = Util.getIntValue(request.getParameter("node_"+i+"_passnum"),0);

/*
		if(ismode.equals("1")){
				RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid=0");
        while(RecordSet.next()){
        	int isbill_workflow_modeview = RecordSet.getInt("isbill");
        	int fieldid = RecordSet.getInt("fieldid");
        	String isview = RecordSet.getString("isview");
        	String isedit = RecordSet.getString("isedit");
        	String ismandatory = RecordSet.getString("ismandatory");
        	rs.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid="+fieldid);
        	if(!rs.next()){
        		rs.executeSql("insert into workflow_modeview values("+formid+","+nodeid+","+isbill_workflow_modeview+","+fieldid+",'"+isview+"','"+isedit+"','"+ismandatory+"')");
        	}
        }
     }
*/     
		WFNodeMainManager.setNodename(nodename);
		WFNodeMainManager.setNodetype(nodetype);
		WFNodeMainManager.setNodeorder(nodeorder);
        WFNodeMainManager.setNodeattribute(nodeattribute);
        WFNodeMainManager.setNodepassnum(nodepassnum);
        WFNodeMainManager.setIsbill(isbill);
        //modify by xhheng @ 2004/12/08 for TDID 1317 start
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(newwfid==-1 ? wfid:newwfid);
		SysMaintenanceLog.setRelatedName(nodename);
		SysMaintenanceLog.setOperateItem("86");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		if(!nodename.equals("") && !nodetype.equals("") && nodeid > 0){
			//修改节点日志
			SysMaintenanceLog.setOperateType("2");
			SysMaintenanceLog.setOperateDesc("WrokFlowNode_update");
            SysMaintenanceLog.setSysLogInfo();
			WFNodeMainManager.setNodeid(nodeid);
			WFNodeMainManager.updateWfNode();
		}

		if(!nodename.equals("") && !nodetype.equals("") && nodeid < 1){
			//新增节点日志
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("WrokFlowNode_insert");
            SysMaintenanceLog.setSysLogInfo();
			WFNodeMainManager.saveWfNode();
			nodeid=WFNodeMainManager.getNodeid2();
        }

		if(ismode.equals("1")){
			RecordSet.executeSql("select  distinct * from workflow_modeview where formid="+formid+" and nodeid=0 and not exists(select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldId=workflow_modeview.fieldId)");

            while(RecordSet.next()){
        	    int isbill_workflow_modeview = RecordSet.getInt("isbill");
        	    int fieldid = RecordSet.getInt("fieldid");
        	    String isview = RecordSet.getString("isview");
        	    String isedit = RecordSet.getString("isedit");
        	    String ismandatory = RecordSet.getString("ismandatory");

        		rs.executeSql("insert into workflow_modeview(formId,nodeId,isBill,fieldId,isview,isedit,ismandatory)  values("+formid+","+nodeid+","+isbill_workflow_modeview+","+fieldid+",'"+isview+"','"+isedit+"','"+ismandatory+"')");
           }
		}
		//modify by xhheng @ 2004/12/08 for TDID 1317 end
	}
    //add by mackjoe at 2005-12-19 表单中设置有模板，自动引用模板  移到WFNodeMainManager中处理
	/////////
	if(!delids.equals("") || rowsum > 0){
		WorkflowInitialization wfinza = new WorkflowInitialization();
		wfinza.recordInformation(wfid);
	}
	/////////


    //RecordSet.executeSql("update workflow_flownode set ismode='"+ismode+"' where workflowid="+wfid);
    //end by mackjoe
    if(!ajax.equals("1")) {
    	if(design==1) {//added by cyril on 2008-12-10
    		int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    		response.sendRedirect("addnodeoperator.jsp?design=1&wfid="+wfid+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+WFManager.getIsCust());
    	}
    	else	
			response.sendRedirect("Editwfnode.jsp?wfid="+wfid);
    }
    else {
    	response.sendRedirect("Editwfnode.jsp?ajax=1&wfid="+wfid);
    }
    return;

  }
    else if(src.equalsIgnoreCase("addoperatorgroup")){
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	
  	int nodetype = -1;
    RecordSet.executeSql("SELECT nodetype FROM workflow_flownode WHERE nodeid="+nodeid);
    if(RecordSet.next()){
         nodetype = Util.getIntValue(RecordSet.getString("nodetype"));
    }
    
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	String iscust=Util.null2String(request.getParameter("iscust"));

	int id = 0;
  	String sql = "select max(id) as id from workflow_nodegroup";
  	RecordSet.executeSql(sql);

  	if(RecordSet.next()){
  		id = Util.getIntValue(Util.null2String(RecordSet.getString("id")),0);
  	}
  	id += 1;

	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
	WFNodeOperatorManager.resetParameter();
	WFNodeOperatorManager.setId(id);
	WFNodeOperatorManager.setNodeid(nodeid);
	String groupname = Util.null2String(request.getParameter("groupname"));
	int canview = Util.getIntValue(request.getParameter("canview"),0);
	WFNodeOperatorManager.setName(groupname);
	WFNodeOperatorManager.setCanview(canview);
	WFNodeOperatorManager.setAction("add");
	WFNodeOperatorManager.AddGroupInfo();
    String para="";  
	for(int i=0;i<rowsum;i++) {

		String type = Util.null2String(request.getParameter("group_"+i+"_type"));
		String virtualid = Util.null2String(request.getParameter("group_"+i+"_virtual"));
		String ruleRelationship = Util.null2String(request.getParameter("group_"+i+"_ruleRelationship"));
		String groupid = Util.null2String(request.getParameter("group_"+i+"_id"));
		int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
		int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
		String deptField = Util.null2String(request.getParameter("group_"+i+"_deptField"));
		String subcompanyField = Util.null2String(request.getParameter("group_"+i+"_subcompanyField"));
        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
        String orders=Util.null2String(request.getParameter("group_"+i+"_order"));
		String signorder=Util.null2String(request.getParameter("group_"+i+"_signorder"));
		//对应为空，没选情况判断出来下
		if(signorder.equals("[object]")){
			signorder="";
		}
		String hrmgroupidn="";
		 if(type.equals("3")){//一般类型：人力资源类型
			 hrmgroupidn=groupid;
			 if (nodetype != 0) {
			     groupid="0";
			 }
		  }
        String jobobj=Util.null2String(request.getParameter("group_"+i+"_jobobj"));
        String jobfield=Util.null2String(request.getParameter("group_"+i+"_jobfield"));
        String IsCoadjutant=Util.null2String(request.getParameter("group_"+i+"_IsCoadjutant"));
        String signtype=Util.null2String(request.getParameter("group_"+i+"_signtype"));
		String issyscoadjutant=Util.null2String(request.getParameter("group_"+i+"_issyscoadjutant"));
        String coadjutants=Util.null2String(request.getParameter("group_"+i+"_coadjutants"));
        String issubmitdesc=Util.null2String(request.getParameter("group_"+i+"_issubmitdesc"));
		String ispending=Util.null2String(request.getParameter("group_"+i+"_ispending"));
        String isforward=Util.null2String(request.getParameter("group_"+i+"_isforward"));
        String ismodify=Util.null2String(request.getParameter("group_"+i+"_ismodify"));
		String Coadjutantconditions=Util.null2String(request.getParameter("group_"+i+"_Coadjutantconditions"));
		int bhxj = Util.getIntValue(request.getParameter("group_"+i+"_bhxj"),0);
		//td13272
		signorder = "-1".equals(signorder) ? "" : signorder;
        String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
		if (orders.equals("")) orders="0";
		if(!type.equals("")){
			String matrixValue = groupid;
			//关联责任人



			if ("99".equals(type)) {
				groupid = "0";
			}
			char flag=2;
			para=""+id+flag+type+flag+groupid+flag+level+flag+level2+flag+conditions+flag+conditioncn+flag+orders+flag+signorder+flag+IsCoadjutant+
                    flag+signtype+flag+issyscoadjutant+flag+issubmitdesc+flag+ispending+flag+isforward+flag+ismodify+flag+coadjutants+flag+Coadjutantconditions+flag+virtualid+flag+ruleRelationship;

			RecordSet.executeProc("workflow_groupdetail_Insert",para);
			
		   //处理部门、分部自定义字段
		   int maxID=-1;
		   if(RecordSet.next()){
		      maxID = RecordSet.getInt(1);
	       }

	       if(maxID>0){
	    	   String updateDeptFieldSQL="update workflow_groupdetail set jobobj ='"+jobobj+ "',jobfield ='"+jobfield+ "',deptField ='"+deptField+"',subcompanyField='"+subcompanyField+"',bhxj = "+bhxj+" where id="+maxID;
	          //String updateDeptFieldSQL="update workflow_groupdetail set deptField ='"+deptField+"',subcompanyField='"+subcompanyField+"' where id="+maxID;
	          RecordSet.executeSql(updateDeptFieldSQL);

	          if(type.equals("3")){//一般类型：人力资源类型
	        	  
	        	  RecordSet.executeSql("delete from Workflow_HrmOperator where groupdetailid='"+maxID+"'");
		          //将人力资源类型值写入中间表中start==
		         List hrmoperatorlist=Util.TokenizerString(hrmgroupidn,",");
		          for(int index=0;index<hrmoperatorlist.size();index++){
			          RecordSet.executeSql("insert into Workflow_HrmOperator(type,objid,signorder,orders,groupid,groupdetailid)values('"+type+"','"+hrmoperatorlist.get(index)+"','"+signorder+"','"+index+"','"+id+"','"+maxID+"')");
		          }	  
	          //将人力资源类型值写入中间表中end== 
	          }
	          
	          if ("99".equals(type)) {
	        	  int groupdetailid = maxID;
		          String[] valueAry = matrixValue.split(",");
		          String matrix = valueAry[0];
		          String value_field = valueAry[1];
		          GroupDetailMatrix gdMatrix = new GroupDetailMatrix();
		          gdMatrix.setGroupdetailid(String.valueOf(groupdetailid));
		          gdMatrix.setMatrix(matrix);
		          gdMatrix.setValue_field(value_field);
		          gdMatrix.save(RecordSet);
		          for (int z = 2; z < valueAry.length; z++) {
		        	  String rowValue = valueAry[z];
		        	  String[] rowValueAry = rowValue.split(":");
		        	  String condition_field = rowValueAry[0];
		        	  String workflow_field = rowValueAry[1];
		        	  GroupDetailMatrixDetail gdMatrixDetail = new GroupDetailMatrixDetail();
		        	  gdMatrixDetail.setGroupdetailid(String.valueOf(groupdetailid));
		        	  gdMatrixDetail.setCondition_field(condition_field);
		        	  gdMatrixDetail.setWorkflow_field(workflow_field);
		        	  gdMatrixDetail.save(RecordSet);
		          }
	          }
	       }

	       //规则逻辑  ===== START =========
	    	String rulemaplistid = Util.null2String(request.getParameter("group_"+i+"_rulemaplistids"));
	    	if(!rulemaplistid.equals(""))
	    	{
	    		String[] _mlid = Util.TokenizerString2(rulemaplistid,",");
	    		for(int j=0;j<_mlid.length;j++)
	    		{
	    			RecordSet.executeSql(" select * from rule_maplist where id="+_mlid[j]);
	    			String nm = "";
	    			String ruleid = "";
	    			String mapid = "";
	    			if(RecordSet.first())
	    			{
	    				nm = Util.null2String(RecordSet.getString("nm"));
	    				ruleid = Util.null2String(RecordSet.getString("ruleid"));
	    				mapid = Util.null2String(RecordSet.getString("id"));
	    			}
	   				RecordSet.executeSql("update rule_maplist set linkid='"+maxID+"',rowidenty='0' where id='"+mapid+"'");
	   				RecordSet.executeSql("update rule_mapitem set linkid='"+maxID+"',rowidenty='0' where linkid='"+nodeid+"' and rulesrc=2 and rowidenty="+(i+1));
	    			if(nm.equals("0"))
	    			{
	    				RecordSet.executeSql(" update rule_base set linkid="+maxID+",rulename='"+WorkflowComInfo.getWorkflowname(wfid+"")+"-"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+"-"+maxID+"' where id="+ruleid);
	    			}
	    		}
	    	}
		}
	}
	
	RecordSet.executeSql("delete from rule_maplist where  rowidenty<>0 and linkid='"+nodeid+"' and rulesrc=2");
	
	int iscreate = Util.getIntValue(request.getParameter("iscreate"),0);
	if(iscreate==1 && wfid > 0){
        String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
		RequestCheckUser.setWorkflowid(wfid);
		RequestCheckUser.setNodeid(nodeid);
	    RequestCheckUser.updateCreateList(id);
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);

	}

	//add by xhheng @ 2004/12/08 for TDID 1317 start
	//新增操作人组日志
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(nodeid);
	SysMaintenanceLog.setRelatedName(groupname);
	SysMaintenanceLog.setOperateType("1");
	SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_insert");
	SysMaintenanceLog.setOperateItem("87");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	
	/////////
	if(rowsum > 0){
		WorkflowInitialization wfinza = new WorkflowInitialization();
		wfinza.recordInformation(wfid);
	}
	/////////
	
	//add by xhheng @ 2004/12/08 for TDID 1317 end
    if(!ajax.equals("1"))
    response.sendRedirect("addnodeoperator.jsp?design="+design+"&wfid="+wfid+"&isbill="+isbill+"&iscust="+iscust+"&formid="+formid+"&nodeid="+nodeid);
    else{
    response.sendRedirect("/workflow/workflow/addoperatorgroup.jsp?isclose=1");
    }
    return;

  }
  else if(src.equalsIgnoreCase("editoperatorgroup")){
	 // System.out.println("--editoperatorgroup--");
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	
  	int nodetype = -1;
    RecordSet.executeSql("SELECT nodetype FROM workflow_flownode WHERE nodeid="+nodeid);
    if(RecordSet.next()){
         nodetype = Util.getIntValue(RecordSet.getString("nodetype"));
    }
  	
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	String iscust=Util.null2String(request.getParameter("iscust"));
	String oldids=Util.null2String(request.getParameter("oldids"));

  	char flag1 = 2;
  	//RecordSet.executeProc("workflow_groupdetail_DbyGroup",""+id);

	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
	WFNodeOperatorManager.resetParameter();
	WFNodeOperatorManager.setId(id);
	WFNodeOperatorManager.setNodeid(nodeid);
	String groupname = Util.null2String(request.getParameter("groupname"));
	int canview = Util.getIntValue(request.getParameter("canview"),0);
	WFNodeOperatorManager.setName(groupname);
	WFNodeOperatorManager.setCanview(canview);
    String para="";  
	for(int i=0;i<rowsum;i++) {

		String type = Util.null2String(request.getParameter("group_"+i+"_type"));
		String virtualid = Util.null2String(request.getParameter("group_"+i+"_virtual"));
		String ruleRelationship = Util.null2String(request.getParameter("group_"+i+"_ruleRelationship"));
		String groupid = Util.null2String(request.getParameter("group_"+i+"_id"));
		
		int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
		int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
		String deptField = Util.null2String(request.getParameter("group_"+i+"_deptField"));
		String subcompanyField = Util.null2String(request.getParameter("group_"+i+"_subcompanyField"));
        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
		String signorder=Util.null2String(request.getParameter("group_"+i+"_signorder"));
		//对应为空，没选情况判断出来下
		if(signorder.equals("[object]")){
			signorder="";
		}
		
		
		//td13272
		signorder = "-1".equals(signorder) ? "" : signorder;
		
		
		
		String hrmgroupidn="";
        String orders=Util.null2String(request.getParameter("group_"+i+"_order"));
        String conditioncn=Util.htmlFilter4UTF8(Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage()));
		String oldid=Util.null2String(request.getParameter("group_"+i+"_oldid"));
        String IsCoadjutant=Util.null2String(request.getParameter("group_"+i+"_IsCoadjutant"));
        String signtype=Util.null2String(request.getParameter("group_"+i+"_signtype"));
		String issyscoadjutant=Util.null2String(request.getParameter("group_"+i+"_issyscoadjutant"));
        String coadjutants=Util.null2String(request.getParameter("group_"+i+"_coadjutants"));
        String issubmitdesc=Util.null2String(request.getParameter("group_"+i+"_issubmitdesc"));
		String ispending=Util.null2String(request.getParameter("group_"+i+"_ispending"));
        String isforward=Util.null2String(request.getParameter("group_"+i+"_isforward"));
        String ismodify=Util.null2String(request.getParameter("group_"+i+"_ismodify"));
		String Coadjutantconditions=Util.null2String(request.getParameter("group_"+i+"_Coadjutantconditions"));
		String jobobj=Util.null2String(request.getParameter("group_"+i+"_jobobj"));
        String jobfield=Util.null2String(request.getParameter("group_"+i+"_jobfield"));
		int bhxj = Util.getIntValue(request.getParameter("group_"+i+"_bhxj"),0);
		if (orders.equals("")) orders="0";
	 
		if(!type.equals("")){
			String matrixValue = groupid;
			//关联责任人
			if ("99".equals(type)) {
				groupid = "0";
			}
			char flag=2;
			 if(type.equals("3")){//一般类型：人力资源类型
				 hrmgroupidn=groupid;
				 if (nodetype != 0) {
				     groupid="0";
				 }
			  }
			
			 if(virtualid.equals("undefined")){//标准增加这个字段，在保存一般类型 人力资源、所有人等情况，保存会提示存储过程异常 
				 virtualid="";
			 } 
			 
		    if (oldid.equals("")){
				 
				 
                para=""+id+flag+type+flag+groupid+flag+level+flag+level2+flag+conditions+flag+conditioncn+flag+orders+flag+signorder+flag+IsCoadjutant+
                    flag+signtype+flag+issyscoadjutant+flag+issubmitdesc+flag+ispending+flag+isforward+flag+ismodify+flag+coadjutants+flag+Coadjutantconditions+flag+virtualid+flag+ruleRelationship;
                RecordSet.executeProc("workflow_groupdetail_Insert",para);
			   //处理部门自定义字段

			   int maxID=-1;
			   if(RecordSet.next()){
			      maxID = RecordSet.getInt(1);
		       }
			   
			//   System.out.println("--editoperatorgroup-maxID:"+maxID);
			 
		       if(maxID>0){
		    	  String updateDeptFieldSQL="update workflow_groupdetail set jobobj = '"+jobobj+"',jobfield ='"+jobfield+"',deptField ='"+deptField+"',subcompanyField='"+subcompanyField+"',bhxj = "+bhxj+" where id="+maxID;
//		          String updateDeptFieldSQL="update workflow_groupdetail set deptField ='"+deptField+"',subcompanyField='"+subcompanyField+"' where id="+maxID;
		          RecordSet.executeSql(updateDeptFieldSQL);
		          if(type.equals("3")){//一般类型：人力资源类型
			          //将人力资源类型值写入中间表中start==
			          RecordSet.executeSql(" delete from Workflow_HrmOperator where groupdetailid='"+maxID+"' ");  
		        	  List hrmoperatorlist=Util.TokenizerString(hrmgroupidn,",");
			          for(int index=0;index<hrmoperatorlist.size();index++){
				          RecordSet.executeSql("insert into Workflow_HrmOperator(type,objid,signorder,orders,groupid,groupdetailid)values('"+type+"','"+hrmoperatorlist.get(index)+"','"+signorder+"','"+index+"','"+id+"','"+maxID+"')");
			          }	
			          //将人力资源类型值写入中间表中end== 
		          }  
		          if ("99".equals(type)) {
		        	  int groupdetailid = maxID;
			          String[] valueAry = matrixValue.split(",");
			          String matrix = valueAry[0];
			          String value_field = valueAry[1];
			          GroupDetailMatrix gdMatrix = new GroupDetailMatrix();
			          gdMatrix.setGroupdetailid(String.valueOf(groupdetailid));
			          gdMatrix.setMatrix(matrix);
			          gdMatrix.setValue_field(value_field);
			          gdMatrix.save(RecordSet);
			          for (int z = 2; z < valueAry.length; z++) {
			        	  String rowValue = valueAry[z];
			        	  String[] rowValueAry = rowValue.split(":");
			        	  String condition_field = rowValueAry[0];
			        	  String workflow_field = rowValueAry[1];
			        	  GroupDetailMatrixDetail gdMatrixDetail = new GroupDetailMatrixDetail();
			        	  gdMatrixDetail.setGroupdetailid(String.valueOf(groupdetailid));
			        	  gdMatrixDetail.setCondition_field(condition_field);
			        	  gdMatrixDetail.setWorkflow_field(workflow_field);
			        	  gdMatrixDetail.save(RecordSet);
			          }
		          }
		        //规则逻辑  ===== START =========
			    	String rulemaplistid = Util.null2String(request.getParameter("group_"+i+"_rulemaplistids"));
			    	if(!rulemaplistid.equals(""))
			    	{
			    		String[] _mlid = Util.TokenizerString2(rulemaplistid,",");
			    		for(int j=0;j<_mlid.length;j++)
			    		{
			    			RecordSet.executeSql(" select * from rule_maplist where id="+_mlid[j]);
			    			String nm = "";
			    			String ruleid = "";
			    			String mapid = "";
			    			if(RecordSet.first())
			    			{
			    				nm = Util.null2String(RecordSet.getString("nm"));
			    				ruleid = Util.null2String(RecordSet.getString("ruleid"));
			    				mapid = Util.null2String(RecordSet.getString("id"));
			    			}
			   				RecordSet.executeSql("update rule_maplist set linkid='"+maxID+"',rowidenty='0' where id='"+mapid+"'");
			   				RecordSet.executeSql("update rule_mapitem set linkid='"+maxID+"',rowidenty='0' where linkid='"+nodeid+"' and rulesrc=2 and rowidenty="+(i + 1));
			    			if(nm.equals("0"))
			    			{
			    				RecordSet.executeSql(" update rule_base set linkid="+maxID+",rulename='"+WorkflowComInfo.getWorkflowname(wfid+"")+"-"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+"-"+maxID+"' where id="+ruleid);
			    			}
			    		}
			    		
			    	}
		       }                
            }
			else
			{
				
				 
				RecordSet.execute("update workflow_groupdetail set  type="+type+", objid="+groupid+", level_n="+level+", level2_n="+level2+", conditions='"+conditions+"', conditioncn='"+conditioncn+"', orders='"+orders+"', signorder='"+signorder+
	                    "',IsCoadjutant='"+IsCoadjutant+"',signtype='"+signtype+"'," +
	                    "issyscoadjutant='"+issyscoadjutant+"',issubmitdesc='"+issubmitdesc+"',ispending='"+ispending+"',isforward='"+isforward+"',ismodify='"+ismodify+"'," +
	                   // "coadjutants='"+coadjutants+"',coadjutantcn='"+Coadjutantconditions+"',deptField='"+deptField+"',subcompanyField='"+subcompanyField+"',virtualid='"+virtualid+"',ruleRelationship='"+ruleRelationship+"' where id="+oldid);
                		"coadjutants='"+coadjutants+"',coadjutantcn='"+Coadjutantconditions+"',deptField='"+deptField+"',subcompanyField='"+subcompanyField+"',virtualid='"+virtualid+"',ruleRelationship='"+ruleRelationship+"',bhxj = "+bhxj+",jobfield = '"+jobfield+"',jobobj = '"+jobobj+"' where id="+oldid);
				oldids=Util.StringReplace(oldids,","+oldid+",",",-1,");
				
				
				
				//更新
				
				 if(type.equals("3")){//一般类型：人力资源类型
				  //将人力资源类型值写入中间表中start==
					      RecordSet.executeSql(" delete from Workflow_HrmOperator where groupdetailid='"+oldid+"' ");  
			        	  List hrmoperatorlist=Util.TokenizerString(hrmgroupidn,",");
				          for(int index=0;index<hrmoperatorlist.size();index++){
					          RecordSet.executeSql("insert into Workflow_HrmOperator(type,objid,signorder,orders,groupid,groupdetailid)values('"+type+"','"+hrmoperatorlist.get(index)+"','"+signorder+"','"+index+"','"+id+"','"+oldid+"')");
					          
				          }	
		          //将人力资源类型值写入中间表中end== 
				 }

				if ("99".equals(type)) {
					
		        	  String groupdetailid = oldid;
			          String[] valueAry = matrixValue.split(",");
			          String matrix = valueAry[0];
			          String value_field = valueAry[1];
			          GroupDetailMatrix gdMatrix = new GroupDetailMatrix();
			          gdMatrix.setGroupdetailid(String.valueOf(groupdetailid));
			          gdMatrix.setMatrix(matrix);
			          gdMatrix.setValue_field(value_field);
			          gdMatrix.update(RecordSet);
						GroupDetailMatrixDetail.delete(RecordSet, groupdetailid);
			          for (int z = 2; z < valueAry.length; z++) {
			        	  String rowValue = valueAry[z];
			        	  String[] rowValueAry = rowValue.split(":");
			        	  String condition_field = rowValueAry[0];
			        	  String workflow_field = rowValueAry[1];
					
			        	  //删除旧的
			        	  
						  //GroupDetailMatrixDetail.delete(RecordSet, groupdetailid,condition_field,workflow_field);
			        	  //添加新的
			        	  GroupDetailMatrixDetail gdMatrixDetail = new GroupDetailMatrixDetail();
			        	  gdMatrixDetail.setGroupdetailid(String.valueOf(groupdetailid));
			        	  gdMatrixDetail.setCondition_field(condition_field);
			        	  gdMatrixDetail.setWorkflow_field(workflow_field);
			        	  gdMatrixDetail.save(RecordSet);
			          }
		          }
			}
		}

	}
	
	//鍒犻櫎鎿嶄綔鑰呬骇鐢熺殑鍨冨溇鏁版嵁
	RecordSet.executeSql("delete workflow_groupdetail where groupid in (select id from workflow_nodegroup where nodeid=0)");
	
    RecordSet.execute("delete from workflow_groupdetail where groupid in (select id from workflow_nodegroup where nodeid=0)");
	
	RecordSet.executeSql("delete workflow_nodegroup where nodeid=0");
	
	RecordSet.executeSql("delete from rule_maplist where  rowidenty<>0 and linkid='"+nodeid+"' and rulesrc=2");
	    //删除
	if (!oldids.equals(",")&&!oldids.equals(""))
	{
	oldids="-1"+oldids+"-1";
    RecordSet.execute("delete from workflow_groupdetail where id in ("+oldids+") ");
    	//删除相关责任人矩阵
   RecordSet.executeSql(" delete from Workflow_HrmOperator where groupdetailid in ("+oldids+") ");


   	 	GroupDetailMatrix.deleteAll(RecordSet, oldids);
   	 	GroupDetailMatrixDetail.deleteAll(RecordSet, oldids);
   	 	//删除引用规则
   	 	RecordSet.execute("delete from rule_maplist where linkid in (" + oldids + ") and rulesrc=2 ");
   		RecordSet.execute("delete from rule_mapitem where linkid in (" + oldids + ") and rulesrc=2 ");
   	 	
	}
		WFNodeOperatorManager.setAction("edit");
		WFNodeOperatorManager.AddGroupInfo();

		
	int iscreate = Util.getIntValue(request.getParameter("iscreate"),0);
	if(iscreate==1 && wfid > 0){
        String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
		RequestCheckUser.setWorkflowid(wfid);
		RequestCheckUser.setNodeid(nodeid);
	    RequestCheckUser.updateCreateList(id);
		RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);
	}

	//add by xhheng @ 2004/12/08 for TDID 1317 start
	//编辑操作人组日志
	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(nodeid);
	SysMaintenanceLog.setRelatedName(groupname);
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_update");
	SysMaintenanceLog.setOperateItem("87");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	//add by xhheng @ 2004/12/08 for TDID 1317 end
    if(!ajax.equals("1")) {
    	response.sendRedirect("addnodeoperator.jsp?design="+design+"&wfid="+wfid+"&isbill="+isbill+"&iscust="+iscust+"&formid="+formid+"&nodeid="+nodeid);
    }
    else
    	response.sendRedirect("/workflow/workflow/editoperatorgroup.jsp?isclose=1");
    return;

  }else if(src.equalsIgnoreCase("nodefieldhtml")){
		wFNodeFieldManager.setRequest(request);
  		wFNodeFieldManager.setUser(user);
  		int modeid = wFNodeFieldManager.setNodeFieldInfo4Html();
  		int wfid = Util.getIntValue(request.getParameter("wfid"), 0);//
  		int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);//
  		int formid = Util.getIntValue(request.getParameter("formid"), 0);//
  		int isbill = Util.getIntValue(request.getParameter("isbill"), 0);//
  		int needprep = Util.getIntValue(request.getParameter("needprep"), 0);//
		int design_tmp = Util.getIntValue(request.getParameter("design"), 0);//
		int isExcel = Util.getIntValue(request.getParameter("isExcel"),0);
		if(isExcel != 0 ){	//当如果是新版流程表单设计器时，这里不需要重定向了



			//根据保存的信息， 需要拼2个json ：自定义属性json 和控件所需的json
			int excelStyle = Util.getIntValue(request.getParameter("excelStyle"),0);
			String issys = Util.null2String(request.getParameter("excelIssys"));
			int exceloutype = Util.getIntValue(request.getParameter("exceloutype"));
			//1表示批量设置字段属性只保存，2表示批量设置字段属性并初始化，3表示模板列表页面初始化字段属性



			int saveAttrFlag=Util.getIntValue(request.getParameter("saveAttrFlag"),0);
			if(saveAttrFlag==1){
				out.print("<script>jQuery(document).ready(function(){parent.closeCurDialog()});</script>");
			}else{
				excelsetInitManager.setRequest(request);
				excelsetInitManager.setUser(user);
				excelsetInitManager.setIsSys(issys);
				excelsetInitManager.setExcelStyle(excelStyle);
				modeid = excelsetInitManager.createSheetJson(exceloutype,1,excelStyle);
				if(saveAttrFlag==2){
					out.print("<script>jQuery(document).ready(function(){parent.closeCurDialog()});</script>");
				}else if(saveAttrFlag==3){
					out.print("<script>jQuery(document).ready(function(){parent.initExcel("+excelStyle+","+modeid+")});</script>");
				}
			}
			return;
		}
  		if(needprep == 0){
	  		response.sendRedirect("/workflow/workflow/addwfnodefield.jsp?ajax=1&wfid="+wfid+"&nodeid="+nodeid);
			return;
  		}else if(needprep == 1){
  			response.sendRedirect("/workflow/workflow/edithtmlnodefield.jsp?needprep=1&wfid="+wfid+"&nodeid="+nodeid+"&ajax="+ajax+"&modeid="+modeid);
			return;
  		}else if(needprep == 2){//预览以后再批量设置后，关闭设置页面，并且刷新原来页面
  			if(design_tmp == 1){
  				response.sendRedirect("/workflow/workflow/addwfnodefield.jsp?ajax="+ajax+"&wfid="+wfid+"&nodeid="+nodeid+"&design="+design);
  				return;
  			}else{
	  			out.println("<script>try{window.opener.location.href=\"/workflow/html/LayoutEditFrame.jsp?formid="+formid+"&wfid="+wfid+"&nodeid="+nodeid+"&isbill="+isbill+"&layouttype=0&ajax=0&modeid="+modeid+"\";}catch(e){}");
	  			out.println("window.close();");
	  			out.println("</script>");
  			}
  		}
  		return;
  }else if(src.equalsIgnoreCase("saveGeneralField")){
	  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	  	String isbill = Util.null2String(request.getParameter("isbill"));
	    String isnew = Util.null2String(request.getParameter("isnew"));
	    String _modename = Util.null2String(request.getParameter("modename"));
      	//新建模板
     	if(_modename.equals("")){
     		RecordSet.executeSql("select nodename from workflow_nodebase where id="+nodeid);
     		RecordSet.first();
     		_modename = RecordSet.getString("nodename") + SystemEnv.getHtmlLabelName(16450,user.getLanguage());
     	}
        if(!isnew.equals("")){
	      	RecordSet.executeSql(" select id from wfnodegeneralmode where formid="+formid+" and isbill="+isbill+" and nodeid="+nodeid+" and wfid="+wfid);
	      	RecordSet.first();
	      	int moid = Util.getIntValue(RecordSet.getString("id"),0);
	      	if( moid> 0)
	      		RecordSet.executeSql(" update wfnodegeneralmode set modename='"+_modename+"' where id="+moid);
	      	else
	      		RecordSet.executeSql(" insert into wfnodegeneralmode(modename,formid,isbill,wfid,nodeid) values ('"+
	      			_modename+"',"+formid+","+isbill+","+wfid+","+nodeid+")");
       }
       int nodetype = -1;
       RecordSet.executeSql("SELECT nodetype FROM workflow_flownode WHERE nodeid="+nodeid);
       if(RecordSet.next()){
       		nodetype = Util.getIntValue(RecordSet.getString("nodetype"));
       }
       /*保存系统字段 begin*/
       if(nodetype !=0){		//创建节点不可编辑则不改变系统字段属性，否则会导致保存后Html字段属性被改变QC148566
	        String curedit_ = Util.null2String(request.getParameter("title_edit"));
		 	String curview_ = Util.null2String(request.getParameter("title_view"));
		 	String curman_ = Util.null2String(request.getParameter("title_man"));
		 	WFNodeFieldMainManager.resetParameter();
		 	WFNodeFieldMainManager.setNodeid(nodeid);
			WFNodeFieldMainManager.setFieldid(-1);
			WFNodeFieldMainManager.setIsview("1");
		 	WFNodeFieldMainManager.setIsedit("0");
		 	WFNodeFieldMainManager.setIsmandatory("0");
		 	if(curedit_.equals("on")){
		 		WFNodeFieldMainManager.setIsedit("1");
		 		WFNodeFieldMainManager.setIsmandatory("1");
		 	}
			WFNodeFieldMainManager.saveWfNodeField2();
	
	        String curview1 = Util.null2String(request.getParameter("level_view"));
		 	String curedit1 = Util.null2String(request.getParameter("level_edit"));
		 	String curman1 = Util.null2String(request.getParameter("level_man"));
		 	WFNodeFieldMainManager.resetParameter();
		 	WFNodeFieldMainManager.setNodeid(nodeid);
			WFNodeFieldMainManager.setFieldid(-2);
			WFNodeFieldMainManager.setIsview("1");
		 	WFNodeFieldMainManager.setIsedit("0");
		 	WFNodeFieldMainManager.setIsmandatory("0");
		 	if(curedit1.equals("on")){
		 		WFNodeFieldMainManager.setIsedit("1");
		 		WFNodeFieldMainManager.setIsmandatory("1");
		 	}
			WFNodeFieldMainManager.saveWfNodeField2();
	  			
	        String curview2 = Util.null2String(request.getParameter("ismessage_view"));
		 	String curedit2 = Util.null2String(request.getParameter("ismessage_edit"));
		 	String curman2 = Util.null2String(request.getParameter("ismessage_man"));
		 	WFNodeFieldMainManager.resetParameter();
		 	WFNodeFieldMainManager.setNodeid(nodeid);
			WFNodeFieldMainManager.setFieldid(-3);
			WFNodeFieldMainManager.setIsview("1");
		 	WFNodeFieldMainManager.setIsedit("0");
		 	WFNodeFieldMainManager.setIsmandatory("0");
		 	if(curedit2.equals("on"))
		 		WFNodeFieldMainManager.setIsedit("1");
			WFNodeFieldMainManager.saveWfNodeField2();
       }
		
		String curview3 = Util.null2String(request.getParameter("ischats_view"));
	 	String curedit3 = Util.null2String(request.getParameter("ischats_edit"));
	 	String curman3 = Util.null2String(request.getParameter("ischats_man"));
	 	WFNodeFieldMainManager.resetParameter();
	 	WFNodeFieldMainManager.setNodeid(nodeid);
		WFNodeFieldMainManager.setFieldid(-5);
		WFNodeFieldMainManager.setIsview("1");
	 	WFNodeFieldMainManager.setIsedit("0");
	 	WFNodeFieldMainManager.setIsmandatory("0"); 
	 	if(curedit3.equals("on"))
	 		WFNodeFieldMainManager.setIsedit("1");
		WFNodeFieldMainManager.saveWfNodeField2();
		/*保存系统字段 end*/
   /*--xwj for td1834 on 005-05-18 begin--*/
   if(isbill.equals("0")){
	  	FormFieldMainManager.setFormid(formid);
		FormFieldMainManager.selectAllFormField();
        int groupid=-1;
		while(FormFieldMainManager.next()){
			int curid=FormFieldMainManager.getFieldid();
            int curgroupid=FormFieldMainManager.getGroupid();
            if(curgroupid==-1) curgroupid=999;
            String isdetail = FormFieldMainManager.getIsdetail();
			WFNodeFieldMainManager.resetParameter();
			WFNodeFieldMainManager.setNodeid(nodeid);
			WFNodeFieldMainManager.setFieldid(curid);
		 	String curedit = Util.null2String(request.getParameter("node"+curid+"_edit_g"+curgroupid));
		 	String curview = Util.null2String(request.getParameter("node"+curid+"_view_g"+curgroupid));
		 	String curman = Util.null2String(request.getParameter("node"+curid+"_man_g"+curgroupid));

		 	WFNodeFieldMainManager.setIsview("0");
		 	WFNodeFieldMainManager.setIsedit("0");
		 	WFNodeFieldMainManager.setIsmandatory("0");
		 	if(curview.equals("on"))
		 		WFNodeFieldMainManager.setIsview("1");
		 	if(curedit.equals("on"))
		 		WFNodeFieldMainManager.setIsedit("1");
		 	if(curman.equals("on"))
		 		WFNodeFieldMainManager.setIsmandatory("1");
			WFNodeFieldMainManager.saveWfNodeField2();

            if(isdetail.equals("1") && curgroupid>groupid) {
                groupid=curgroupid;
                String dtladd = Util.null2String(request.getParameter("dtl_add_"+curgroupid));
                String dtledit = Util.null2String(request.getParameter("dtl_edit_"+curgroupid));
                String dtldelete = Util.null2String(request.getParameter("dtl_del_"+curgroupid));
                String dtlhide = Util.null2String(request.getParameter("hide_del_"+curgroupid));
                String dtldefault = Util.null2String(request.getParameter("dtl_def_"+curgroupid));
                String dtlneed = Util.null2String(request.getParameter("dtl_ned_"+curgroupid));

				  String dtlmul = Util.null2String(request.getParameter("dtl_mul_"+curgroupid));//zzl
				  
				  int dt1defaultrows = Util.getIntValue(request.getParameter("dtl_defrow"+curgroupid),0);
				  dt1defaultrows = dt1defaultrows<=0?1:dt1defaultrows;
				  
                WFNodeDtlFieldManager.setNodeid(nodeid);
                WFNodeDtlFieldManager.setGroupid(curgroupid);
                WFNodeDtlFieldManager.setIsadd("0");
                WFNodeDtlFieldManager.setIsedit("0");
                WFNodeDtlFieldManager.setIsdelete("0");
                WFNodeDtlFieldManager.setIshide("0");
                WFNodeDtlFieldManager.setIsdefault("0");
                WFNodeDtlFieldManager.setIsopensapmul("0");//zzl
                WFNodeDtlFieldManager.setIsneed("0");
                WFNodeDtlFieldManager.setDefaultrows(dt1defaultrows);
                if(dtladd.equals("on"))
                    WFNodeDtlFieldManager.setIsadd("1");
                if(dtledit.equals("on"))
                    WFNodeDtlFieldManager.setIsedit("1");
                if(dtldelete.equals("on"))
                    WFNodeDtlFieldManager.setIsdelete("1");
                if(dtlhide.equals("on"))
                    WFNodeDtlFieldManager.setIshide("1");
                if(dtldefault.equals("on"))
                    WFNodeDtlFieldManager.setIsdefault("1");
                 if(dtlmul.equals("on"))
                    WFNodeDtlFieldManager.setIsopensapmul("1");//zzl
                if(dtlneed.equals("on"))
                    WFNodeDtlFieldManager.setIsneed("1");
                WFNodeDtlFieldManager.saveWfNodeDtlField();
            }
		}
	}else if(isbill.equals("1")){
		boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
		RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
		if(RecordSet.next()){
			String temptablename = Util.null2String(RecordSet.getString("tablename"));
			if(temptablename.equals("formtable_main_"+formid*(-1)) || temptablename.startsWith("uf_")) isNewForm = true;
		}
		String sql = "select * from workflow_billfield where billid = "+formid+"  order by viewtype,detailtable,dsporder";
		if(isNewForm == true){
			if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
				sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,TO_NUMBER((select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
			}else{
				sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,convert(int, (select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
			}
		}else{
			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
		}
		RecordSet.executeSql(sql);
       int curgroupid=0;
       String predetailtable=null;
        while(RecordSet.next()){
			int curid=RecordSet.getInt("id");
            int viewtype=RecordSet.getInt("viewtype");
            String detailtable = Util.null2String(RecordSet.getString("detailtable"));
            WFNodeFieldMainManager.resetParameter();
			WFNodeFieldMainManager.setNodeid(nodeid);
			WFNodeFieldMainManager.setFieldid(curid);
            if(viewtype==1 && !detailtable.equals(predetailtable)){
                predetailtable=detailtable;
                curgroupid++;
            }
            String curedit = Util.null2String(request.getParameter("node"+curid+"_edit_g"+curgroupid));
		 	String curview = Util.null2String(request.getParameter("node"+curid+"_view_g"+curgroupid));
		 	String curman = Util.null2String(request.getParameter("node"+curid+"_man_g"+curgroupid));

		 	WFNodeFieldMainManager.setIsview("0");
		 	WFNodeFieldMainManager.setIsedit("0");
		 	WFNodeFieldMainManager.setIsmandatory("0");
		 	if(curview.equals("on"))
		 		WFNodeFieldMainManager.setIsview("1");
		 	if(curedit.equals("on"))
		 		WFNodeFieldMainManager.setIsedit("1");
		 	if(curman.equals("on"))
		 		WFNodeFieldMainManager.setIsmandatory("1");

			WFNodeFieldMainManager.saveWfNodeField2();
		}        
        for(int i=0;i<curgroupid;i++){
            String dtladd = Util.null2String(request.getParameter("dtl_add_"+(i+1)));
                String dtledit = Util.null2String(request.getParameter("dtl_edit_"+(i+1)));
                String dtldelete = Util.null2String(request.getParameter("dtl_del_"+(i+1)));
                String dtlhide = Util.null2String(request.getParameter("hide_del_"+(i+1)));
                String dtldefault = Util.null2String(request.getParameter("dtl_def_"+(i+1)));
                String dtlneed = Util.null2String(request.getParameter("dtl_ned_"+(i+1)));
				  String dtlmul = Util.null2String(request.getParameter("dtl_mul_"+(i+1)));//zzl
				  int dt1defaultrows = Util.getIntValue(request.getParameter("dtl_defrow"+(i+1)),0);
				  dt1defaultrows = dt1defaultrows<=0?1:dt1defaultrows;
                WFNodeDtlFieldManager.setNodeid(nodeid);
                WFNodeDtlFieldManager.setGroupid(i);
                WFNodeDtlFieldManager.setIsadd("0");
                WFNodeDtlFieldManager.setIsedit("0");
                WFNodeDtlFieldManager.setIsdelete("0");
                WFNodeDtlFieldManager.setIshide("0");
                WFNodeDtlFieldManager.setIsdefault("0");
                WFNodeDtlFieldManager.setIsneed("0");
                WFNodeDtlFieldManager.setIsopensapmul("0");//zzl
                WFNodeDtlFieldManager.setDefaultrows(dt1defaultrows);
                if(dtladd.equals("on"))
                    WFNodeDtlFieldManager.setIsadd("1");
                if(dtledit.equals("on"))
                    WFNodeDtlFieldManager.setIsedit("1");
                if(dtldelete.equals("on"))
                    WFNodeDtlFieldManager.setIsdelete("1");
                if(dtlhide.equals("on"))
                    WFNodeDtlFieldManager.setIshide("1");
                if(dtldefault.equals("on"))
                    WFNodeDtlFieldManager.setIsdefault("1");
                 if(dtlmul.equals("on"))
                    WFNodeDtlFieldManager.setIsopensapmul("1");//zzl
                if(dtlneed.equals("on"))
                    WFNodeDtlFieldManager.setIsneed("1");
                WFNodeDtlFieldManager.saveWfNodeDtlField();
			}
		}
  		RecordSet.executeSql("update workflow_flownode set ismode='0' where workflowid="+wfid+" and nodeid="+nodeid);
  		response.sendRedirect("/workflow/workflow/addwfnodegeneral.jsp?isclose=1&wfid="+wfid+"&isbill="+isbill+"&nodeid="+nodeid+"&formid="+formid);
  }else if(src.equalsIgnoreCase("wfnodefield")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	String isbill = Util.null2String(request.getParameter("isbill"));
    String modetype=Util.null2String(request.getParameter("modetype"));
    String _modename = Util.null2String(request.getParameter("modename"));
    String _sql="";
    if(modetype.equals("0")){
    	String ischoose = Util.null2String(request.getParameter("ischoose"));
    	int _nodeid = -1;
    	if("y".equals(ischoose)){	//y：选择了模板
    		int choosemodeid = Util.getIntValue(request.getParameter("choosemodeid"),0);
    		RecordSet.executeSql(" select nodeid from wfnodegeneralmode where id="+choosemodeid);
    		if(RecordSet.next()){
    			_nodeid = RecordSet.getInt("nodeid");
    		}
    	}else{
    		_nodeid = nodeid;
    	}
    	String gensyncNodes=Util.null2String(request.getParameter("gensyncNodes"));
    	gensyncNodes += ","+nodeid;
    	ArrayList syncnodeids = Util.TokenizerString(gensyncNodes, ",");
		for(int i=0;i<syncnodeids.size();i++){
			int syncnodeid= Util.getIntValue(syncnodeids.get(i).toString());
			if(syncnodeid == _nodeid)
				continue;
			//普通模式模板表修改
			RecordSet.executeSql(" select nodename from workflow_nodebase where id="+syncnodeid);
	       	RecordSet.first();
	       	_modename = RecordSet.getString("nodename") + SystemEnv.getHtmlLabelName(16450,user.getLanguage());
			RecordSet.executeSql(" select id from wfnodegeneralmode where formid="+formid+" and isbill="+isbill+" and nodeid="+syncnodeid+" and wfid="+wfid);
        	RecordSet.first();
        	int moid = Util.getIntValue(RecordSet.getString("id"),0);
        	if(moid>0){
        		RecordSet.executeSql(" update wfnodegeneralmode set modename='"+_modename+"' where id="+moid);
        	}else{
        		RecordSet.executeSql(" insert into wfnodegeneralmode(modename,formid,isbill,wfid,nodeid) values ('"+
        			_modename+"',"+formid+","+isbill+","+wfid+","+syncnodeid+")");
        	}
			//字段表先删后插
			RecordSet.executeSql(" delete from workflow_nodeform where nodeid="+syncnodeid);
			_sql=" insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) "+
				 " select "+syncnodeid+",fieldid,isview,isedit,ismandatory,orderid from workflow_nodeform where nodeid="+_nodeid;
			RecordSet.executeSql(_sql);
			//明细字段删除插入
			RecordSet.executeSql(" delete from workflow_NodeFormGroup where nodeid="+syncnodeid);
			RecordSet.executeSql(" select count(*) as count from workflow_NodeFormGroup where nodeid="+_nodeid);
			RecordSet.first();
			if(RecordSet.getInt("count")>0){
				_sql=" insert into workflow_NodeFormGroup(nodeid,groupid,isadd,isedit,isdelete,ishidenull,isdefault,isneed,isopensapmul,defaultrows) "+
					 " select "+syncnodeid+",groupid,isadd,isedit,isdelete,ishidenull,isdefault,isneed,isopensapmul,defaultrows from workflow_NodeFormGroup where nodeid="+_nodeid;
				RecordSet.executeSql(_sql);
			}
			//改变节点模板模式
			RecordSet.executeSql("update workflow_flownode set ismode='"+modetype+"' where workflowid="+wfid+" and nodeid="+syncnodeid);
		}
		//保存打印模板  liuzy 20140830
		int gen_belmodetype=Util.getIntValue(Util.null2String(request.getParameter("gen_belmodetype")),0);
		String genprintsyncNodes=Util.null2String(request.getParameter("genprintsyncNodes"));
	    String printsyncNodes = genprintsyncNodes;
        printsyncNodes += ","+nodeid ;
    	ArrayList printsyncNodeList = Util.TokenizerString(printsyncNodes, ",");
		if(gen_belmodetype==1){
		    ConnStatement statement=new ConnStatement();
        	try {
       			boolean isoracle = (statement.getDBType()).equals("oracle");
        		String sqlstr="";
        		String modestr="";
                int modeids=Util.getIntValue(Util.null2String(request.getParameter("printmodeid")),0);
                String modename=Util.null2String(request.getParameter("printmodename"));
                int i=1;
                String updatestr="printdes";
                String modetable="workflow_nodemode";
                if(Util.getIntValue(Util.null2String(request.getParameter("printisform")),0)==1){
                    modetable="workflow_formmode";
                }
                ArrayList list = printsyncNodeList ; 
                for(int k = 0 ; k<list.size();k++){
                	nodeid = Util.getIntValue(list.get(k).toString());
               	    RecordSet.executeSql("select n.nodename, f.nodetype from workflow_nodebase n left join workflow_flownode f on f.nodeid=n.id where n.id="+nodeid);
               	    if(RecordSet.next()){
               		   modename = RecordSet.getString("nodename") + SystemEnv.getHtmlLabelName(16450,user.getLanguage());
               	    }
	                RecordSet.executeSql("select id from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
	                //已经有模板



	                if(RecordSet.next()){
	                    int modeid=RecordSet.getInt("id");          
	                    if(modeids>0){		//更新模板
	                        if(modetable.equals("workflow_nodemode")){
	                            sqlstr="select modedesc from "+modetable+" where id="+modeids;
	                            statement.setStatementSql(sqlstr);
	                            statement.executeQuery();
	                            if (statement.next()) {
	                                if(isoracle){
	                                    CLOB theclob = statement.getClob(1);
	                                    String readline = "" ;
	                                    StringBuffer clobStrBuff = new StringBuffer("") ;
	                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
	                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
	                                    clobin.close() ;
	                                    modestr=clobStrBuff.toString();
	                                }else{
	                                	modestr = statement.getString("modedesc");
	                                }
	                            }
	                            if(isoracle){
	                                sqlstr="update workflow_nodemode set modename=? where id="+modeid;
	                                statement.setStatementSql(sqlstr);
	                                statement.setString(1 , modename);
	                                statement.executeUpdate();
	
	                                sqlstr = "select modedesc from workflow_nodemode where id = "+modeid;
	                                statement.setStatementSql(sqlstr, false);
	                                statement.executeQuery();
	                                if(statement.next()){
	                                    CLOB theclob = statement.getClob(1);
	                                    char[] contentchar = modestr.toCharArray();
	                                    Writer contentwrite = theclob.getCharacterOutputStream();
	                                    contentwrite.write(contentchar);
	                                    contentwrite.flush();
	                                    contentwrite.close();
	                                }
	                            }else{
	                                sqlstr="update workflow_nodemode set modedesc=?,modename=? where id="+modeid;
	                                statement.setStatementSql(sqlstr);
	                                statement.setString(1 , modestr);
	                                statement.setString(2 , modename);
	                                statement.executeUpdate();
	                            }
	                        }else{
	                            RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
	                        }
	                    }else{
	                        //删除模板
	                        RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
	                        RecordSet.executeSql("select id from workflow_nodemode where formid="+formid+" and nodeid="+nodeid+" and isprint!='"+i+"'");
	                        if(RecordSet.getCounts() <= 0) {
	                        	RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
	                        }
	                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='1' where workflowid="+wfid+" and nodeid="+nodeid);
	                    }
	                }else{
	                    //没有模板,插入模板
	                    if(modeids>0){
	                        if(modetable.equals("workflow_nodemode")){
	                            sqlstr="select modedesc from "+modetable+" where id="+modeids;
	                            statement.setStatementSql(sqlstr);
	                            statement.executeQuery();
	                            if (statement.next()) {
	                                if(isoracle){
	                                    CLOB theclob = statement.getClob(1);
	                                    String readline = "" ;
	                                    StringBuffer clobStrBuff = new StringBuffer("") ;
	                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
	                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
	                                    clobin.close() ;
	                                    modestr=clobStrBuff.toString();
	                                }else{
	                                    modestr = statement.getString("modedesc");
	                                }
	                            }
	                            if(isoracle){
	                                sqlstr="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,empty_clob(),?,?)";
	                                statement.setStatementSql(sqlstr);
	                                statement.setInt(1 ,formid);
	                                statement.setInt(2 ,nodeid);
	                                statement.setString(3 ,""+i);
	                                statement.setInt(4 ,wfid);
	                                statement.setString(5 ,modename);
	                                statement.executeUpdate();
	
	                                sqlstr = "select modedesc from workflow_nodemode where formid = "+formid+" and nodeid="+nodeid+" and isprint='"+i+"' and workflowid="+wfid+" order by id desc";
	                                statement.setStatementSql(sqlstr, false);
	                                statement.executeQuery();
	                                if(statement.next()){
	                                    CLOB theclob = statement.getClob(1);
	                                    char[] contentchar = modestr.toCharArray();
	                                    Writer contentwrite = theclob.getCharacterOutputStream();
	                                    contentwrite.write(contentchar);
	                                    contentwrite.flush();
	                                    contentwrite.close();
	                                }
	                            }else{
	                                sqlstr="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,?,?,?)";
	                                statement.setStatementSql(sqlstr);
	                                statement.setInt(1 ,formid);
	                                statement.setInt(2 ,nodeid);
	                                statement.setString(3 ,""+i);
	                                statement.setString(4 , modestr);
	                                statement.setInt(5 ,wfid);
	                                statement.setString(6 ,modename);
	                                statement.executeUpdate();
	                            }
	                        }
	                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='0' where workflowid="+wfid+" and nodeid="+nodeid);                   
	                    }else{
	                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='1' where workflowid="+wfid+" and nodeid="+nodeid);
	                    }
	                }
            	}
            }catch(Exception e){
	            e.printStackTrace();
	        }finally{
	            statement.close();
	        }
		}else if(gen_belmodetype==2){
			//需删除存在的节点上的 模板模式打印模板
			RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='1' ");
	    	htmlLayoutOperate.setRequest(request);
	    	htmlLayoutOperate.setUser(user);
	    	htmlLayoutOperate.saveLayout_print();
		}
  		//add by mackjoe at 2005-12-19 保存显示类型
    }else if(modetype.equals("1")){
        int showmodeid=Util.getIntValue(Util.null2String(request.getParameter("showmodeid")),0);
        int printmodeid=Util.getIntValue(Util.null2String(request.getParameter("printmodeid")),0);
        int showisform=Util.getIntValue(Util.null2String(request.getParameter("showisform")),0);
        int printisform=Util.getIntValue(Util.null2String(request.getParameter("printisform")),0);
        String showmodename=Util.null2String(request.getParameter("showmodename"));
        String printmodename=Util.null2String(request.getParameter("printmodename"));
        int showtype=Util.getIntValue(Util.null2String(request.getParameter("showtype")),0);   
        int vtapprove=0;
        int vtrealize=0;
        int vtforward=0;
		int vtpostil=0;
		int vtHandleForward = 0;
		int vtTakingOpinions = 0;
		int vttpostil=0;   
        int vtrecipient=0;
		int vtrpostil=0; 
        int vtreject=0;
        int vtsuperintend=0;
        int vtover=0;
        int vtintervenor=0;
        int vdcomments=0;
        int vddeptname=0;
        int vdoperator=0;
        int vddate=0;
        int vdtime=0;
        int stnull=Util.getIntValue(Util.null2String(request.getParameter("showtype_null")),0);
        int vsignupload=0;
		int vmobilesource=0;
        int vsigndoc=0;
        int vsignworkflow=0;
        int toexcel=0;
        toexcel=Util.getIntValue(Util.null2String(request.getParameter("toexcel")),0);
        String viewtypeall=Util.null2String(request.getParameter("viewtype_all"));
        String viewdescall=Util.null2String(request.getParameter("viewdesc_all"));
        if(viewtypeall.indexOf("viewtype_all")!=-1||viewtypeall.equals("1")){
        	viewtypeall = "1";
        }else{
        	if(viewtypeall.indexOf("viewtype_approve")!=-1)
        		vtapprove=1;
        	if(viewtypeall.indexOf("viewtype_realize")!=-1)
        		vtrealize=1;
        	if(viewtypeall.indexOf("viewtype_forward")!=-1)
        		vtforward=1;
        	if(viewtypeall.indexOf("viewtype_postil")!=-1)
        		vtpostil=1;
			if(viewtypeall.indexOf("view_handleForward")!=-1)
        		vtHandleForward=1;
			if(viewtypeall.indexOf("view_takingOpinions")!=-1)
        		vtTakingOpinions=1;
			if(viewtypeall.indexOf("viewtype_tpostil")!=-1)
        		vttpostil=1;
			if(viewtypeall.indexOf("viewtype_recipient")!=-1)
        		vtrecipient=1;
        	if(viewtypeall.indexOf("viewtype_rpostil")!=-1)
        		vtrpostil=1;
			if(viewtypeall.indexOf("viewtype_reject")!=-1)
        		vtreject=1;
        	if(viewtypeall.indexOf("viewtype_superintend")!=-1)
        		vtsuperintend=1;
        	if(viewtypeall.indexOf("viewtype_over")!=-1)
        		vtover=1;
        	if(viewtypeall.indexOf("viewtype_intervenor")!=-1)
        		vtintervenor=1;
        	viewtypeall = "0";
        }
        if(viewdescall.indexOf("viewdesc_all")!=-1||viewdescall.equals("1")){
        	viewdescall = "1";
			vdcomments=1;
			vddeptname=1;
			vdoperator=1;
			vddate=1;
			vdtime=1;
			vsignupload=1;
			vsigndoc=1;
			vsignworkflow=1;
			vmobilesource=1;
        }else{
        	if(viewdescall.indexOf("viewdesc_comments")!=-1)
        		vdcomments=1;
        	if(viewdescall.indexOf("viewdesc_deptname")!=-1)
        		vddeptname=1;
        	if(viewdescall.indexOf("viewdesc_operator")!=-1)
        		vdoperator=1;
        	if(viewdescall.indexOf("viewdesc_date")!=-1)
        		vddate=1;
        	if(viewdescall.indexOf("viewdesc_time")!=-1)
        		vdtime=1;
        	if(viewdescall.indexOf("viewdesc_signupload")!=-1)
        		vsignupload=1;
        	if(viewdescall.indexOf("viewdesc_signdoc")!=-1)
        		vsigndoc=1;
        	if(viewdescall.indexOf("viewdesc_signworkflow")!=-1)
        		vsignworkflow=1;
			if(viewdescall.indexOf("viewdesc_mobilesource")!=-1)
        		vmobilesource=1;
        	viewdescall = "0";
        }
        
        
        /*************************/
        String syncNodes = Util.null2String(request.getParameter("modesyncNodes")) ;
        String printsyncNodes = Util.null2String(request.getParameter("modeprintsyncNodes")) ;
        syncNodes += ","+nodeid ;
        printsyncNodes += ","+nodeid ;
        
        ConnStatement statement=new ConnStatement();
        try {
        boolean isoracle = (statement.getDBType()).equals("oracle");
        String sqlstr="";
        String modestr="";
        int modeids=showmodeid;
        String modename=showmodename;
        String modetable="workflow_nodemode";
        String updatestr="";
        //RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
        ArrayList syncnodeids = Util.TokenizerString(syncNodes, ",");
        ArrayList syncprintnodeids = Util.TokenizerString(printsyncNodes, ",");
        for(int i=0;i<2;i++){
                if(i==0){
                    modeids=showmodeid;
                    modename=showmodename;
                    updatestr="showdes";
                    modetable="workflow_nodemode";
                    if(showisform==1){
                        modetable="workflow_formmode";
                    }
                }else{
                    modeids=printmodeid;
                    modename=printmodename;
                    updatestr="printdes";
                    modetable="workflow_nodemode";
                    if(printisform==1){
                        modetable="workflow_formmode";
                    }
                }
                 ArrayList list = null ;
                if(i==0) list = syncnodeids ;
                else list = syncprintnodeids ;
                int _tempnodeid = nodeid ; 
                for(int k = 0 ; k<list.size();k++){
                	nodeid = Util.getIntValue(list.get(k).toString());
					//add by liaodong for qc80560 in 2013-12-11 start
                	   RecordSet.executeSql("select n.nodename, f.nodetype from workflow_nodebase n left join workflow_flownode f on f.nodeid=n.id where n.id="+nodeid);
                	   if(RecordSet.next()){
                		   modename = RecordSet.getString("nodename");
                		   if(i == 0)
                			   modename += SystemEnv.getHtmlLabelName(16450,user.getLanguage());
                		   else if(i == 1)
                			   modename += SystemEnv.getHtmlLabelNames("257,64",user.getLanguage());
                	   }
                	//end
                RecordSet.executeSql("select id from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
                //已经有模板



                if(RecordSet.next()){
                    int modeid=RecordSet.getInt("id");
                    //更新模板
                    if(modeids>0){
                        if(modetable.equals("workflow_nodemode")){
                            if(i==0){
                                sqlstr="select formid,nodeid from "+modetable+" where id="+modeids;
                                RecordSet.executeSql(sqlstr);
                                if(RecordSet.next()){
                                    int tempformid=RecordSet.getInt("formid");
                                    int tempnodeid=RecordSet.getInt("nodeid");
                                    if(formid!=tempformid || tempnodeid!=nodeid){
                                        RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                                        RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+tempformid+" and nodeid="+tempnodeid+" and isbill="+isbill);
                                        while(RecordSet.next()){
                                            rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                        }
                                    }
                                }
                            }
                            sqlstr="select modedesc from "+modetable+" where id="+modeids;
                            statement.setStatementSql(sqlstr);
                            statement.executeQuery();
                            if (statement.next()) {
                                if(isoracle){
                                    CLOB theclob = statement.getClob(1);
                                    String readline = "" ;
                                    StringBuffer clobStrBuff = new StringBuffer("") ;
                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
                                    clobin.close() ;
                                    modestr=clobStrBuff.toString();
                                }else{
                                modestr = statement.getString("modedesc");
                                }
                            }
                            if(isoracle){
                                sqlstr="update workflow_nodemode set modename=? where id="+modeid;
                                statement.setStatementSql(sqlstr);
                                statement.setString(1 , modename);
                                statement.executeUpdate();

                                sqlstr = "select modedesc from workflow_nodemode where id = "+modeid;
                                statement.setStatementSql(sqlstr, false);
                                statement.executeQuery();
                                if(statement.next()){
                                    CLOB theclob = statement.getClob(1);
                                    char[] contentchar = modestr.toCharArray();
                                    Writer contentwrite = theclob.getCharacterOutputStream();
                                    contentwrite.write(contentchar);
                                    contentwrite.flush();
                                    contentwrite.close();
                                    //statement.close();
                                }
                            }else{
                                sqlstr="update workflow_nodemode set modedesc=?,modename=? where id="+modeid;
                                statement.setStatementSql(sqlstr);
                                statement.setString(1 , modestr);
                                statement.setString(2 , modename);
                                statement.executeUpdate();
                            }
                        }else{
                            if(i==0){
                                RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                                RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+formid+" and nodeid=0 and isbill="+isbill);
                                while(RecordSet.next()){
                                   rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                }
                            }
                            RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
                        }
                    }else{
                        //删除模板
                        //RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                        RecordSet.executeSql("delete from workflow_nodemode where workflowid="+wfid+" and nodeid="+nodeid+" and isprint='"+i+"'");
						//(TD23195)是否还有其他模板使用
                        RecordSet.executeSql("select id from workflow_nodemode where formid="+formid+" and nodeid="+nodeid+" and isprint!='"+i+"'");
                        if(RecordSet.getCounts() <= 0) {
                        	RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                        }
                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='1' where workflowid="+wfid+" and nodeid="+nodeid);
                    }
                }else{
                    //没有模板
                    //插入模板
                    if(i==0) RecordSet.executeSql("delete from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill);
                    if(modeids>0){
                        if(modetable.equals("workflow_nodemode")){
                            if(i==0){
                                sqlstr="select formid,nodeid from "+modetable+" where id="+modeids;
                                RecordSet.executeSql(sqlstr);
                                if(RecordSet.next()){
                                    int tempformid=RecordSet.getInt("formid");
                                    int tempnodeid=RecordSet.getInt("nodeid");
                                    RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+tempformid+" and nodeid="+tempnodeid+" and isbill="+isbill);
                                    while(RecordSet.next()){
                                        rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                    }
                                }
                            }
                            sqlstr="select modedesc from "+modetable+" where id="+modeids;
                            statement.setStatementSql(sqlstr);
                            statement.executeQuery();
                            if (statement.next()) {
                                if(isoracle){
                                    CLOB theclob = statement.getClob(1);
                                    String readline = "" ;
                                    StringBuffer clobStrBuff = new StringBuffer("") ;
                                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline) ;
                                    clobin.close() ;
                                    modestr=clobStrBuff.toString();
                                }else{
                                    modestr = statement.getString("modedesc");
                                }
                            }
                            if(isoracle){
                                sqlstr="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,empty_clob(),?,?)";
                                statement.setStatementSql(sqlstr);
                                statement.setInt(1 ,formid);
                                statement.setInt(2 ,nodeid);
                                statement.setString(3 ,""+i);
                                statement.setInt(4 ,wfid);
                                statement.setString(5 ,modename);
                                statement.executeUpdate();

                                sqlstr = "select modedesc from workflow_nodemode where formid = "+formid+" and nodeid="+nodeid+" and isprint='"+i+"' and workflowid="+wfid+" order by id desc";
                                statement.setStatementSql(sqlstr, false);
                                statement.executeQuery();
                                if(statement.next()){
                                    CLOB theclob = statement.getClob(1);
                                    char[] contentchar = modestr.toCharArray();
                                    Writer contentwrite = theclob.getCharacterOutputStream();
                                    contentwrite.write(contentchar);
                                    contentwrite.flush();
                                    contentwrite.close();
                                    //statement.close();
                                }
                            }else{
                                sqlstr="insert into workflow_nodemode(formid,nodeid,isprint,modedesc,workflowid,modename) values(?,?,?,?,?,?)";
                                statement.setStatementSql(sqlstr);
                                statement.setInt(1 ,formid);
                                statement.setInt(2 ,nodeid);
                                statement.setString(3 ,""+i);
                                statement.setString(4 , modestr);
                                statement.setInt(5 ,wfid);
                                statement.setString(6 ,modename);
                                statement.executeUpdate();
                            }
                        }else{
                            if(i==0){
                                RecordSet.executeSql("select fieldid,isview,isedit,ismandatory from workflow_modeview where formid="+formid+" and nodeid=0 and isbill="+isbill);
                                while(RecordSet.next()){
                                   rs.executeSql("insert into workflow_modeview(formid,nodeid,isbill,fieldid,isview,isedit,ismandatory) values("+formid+","+nodeid+","+isbill+","+RecordSet.getInt("fieldid")+",'"+RecordSet.getString("isview")+"','"+RecordSet.getString("isedit")+"','"+RecordSet.getString("ismandatory")+"')");
                                }
                            }
                        }
                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='0' where workflowid="+wfid+" and nodeid="+nodeid);
                        
                    }else{
                        RecordSet.executeSql("update workflow_flownode set "+updatestr+"='1' where workflowid="+wfid+" and nodeid="+nodeid);
                    }
                }
                if(i==0){
                    RecordSet.executeSql("update workflow_flownode set ismode='"+modetype+"' where workflowid="+wfid+" and nodeid="+nodeid);
                }
            }
           } 
        
	        String noderemarksync = Util.null2String(request.getParameter("noderemarksync"));
	    	String nodeid_new = "";
	    	if("".equals(noderemarksync))
	    		nodeid_new = nodeid + "";
	    	else
	    		nodeid_new = nodeid + "," + noderemarksync;
    	
	        String mysql="update workflow_flownode set viewtypeall='"+viewtypeall+"',viewdescall='"+viewdescall+"',showtype='"+showtype+"',vtapprove='"+vtapprove+"',vtforward='"+vtforward+"',vtTakingOpinions='"+vtTakingOpinions+"',vtHandleForward='"+vtHandleForward+"',vttpostil='"+vttpostil+"',vtrpostil='"+vtrpostil+
	        "',vtover='"+vtover+"',vtintervenor='"+vtintervenor+"',vtpostil='"+vtpostil+"',vtrealize='"+vtrealize+"',vtrecipient='"+vtrecipient+"',vtreject='"+vtreject+"',vtsuperintend='"+vtsuperintend+
	        "',vdcomments='"+vdcomments+"',vddate='"+vddate+"',vddeptname='"+vddeptname+"',vdoperator='"+vdoperator+"',vdtime='"+vdtime+"',stnull='"+stnull+"',toexcel='"+toexcel+
	        "',vsignupload='"+vsignupload+"',vmobilesource='"+vmobilesource+"',vsigndoc='"+vsigndoc+"',vsignworkflow='"+vsignworkflow+"' where workflowid="+wfid+" and nodeid in ("+nodeid_new+")";
	        RecordSet.executeSql(mysql);
                    
            if(isbill.equals("0")){
		  	  	FormFieldMainManager.setFormid(formid);
		  		FormFieldMainManager.selectAllFormField();
		        int groupid=-1;
		  		while(FormFieldMainManager.next()){
		  			int curid=FormFieldMainManager.getFieldid();
		            int curgroupid=FormFieldMainManager.getGroupid();
		            if(curgroupid==-1) curgroupid=999;
		            String isdetail = FormFieldMainManager.getIsdetail();
		  			WFNodeFieldMainManager.resetParameter();
		  			WFNodeFieldMainManager.setNodeid(nodeid);
		  			WFNodeFieldMainManager.setFieldid(curid);
		            if(isdetail.equals("1") && curgroupid>groupid) {
		                  groupid=curgroupid;
		                  int dt1defaultrows = Util.getIntValue(request.getParameter("dtl_defrow_"+curgroupid),0);
		                  dt1defaultrows = dt1defaultrows<=0?1:dt1defaultrows;
			              WFNodeDtlFieldManager.resetParameter();
		                  WFNodeDtlFieldManager.setNodeid(nodeid);
		                  WFNodeDtlFieldManager.setGroupid(curgroupid);
		                  WFNodeDtlFieldManager.setDefaultrows(dt1defaultrows);
		                  WFNodeDtlFieldManager.saveWfNodeDtlField_defaultRow();
		             }
		  		}
		  	}else if(isbill.equals("1")){
		  		boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
		  		RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
		  		if(RecordSet.next()){
		  			String temptablename = Util.null2String(RecordSet.getString("tablename"));
		  			if(temptablename.equals("formtable_main_"+formid*(-1)) || temptablename.startsWith("uf_")) isNewForm = true;
		  		}
		  		String sql = "select * from workflow_billfield where billid = "+formid+"  order by viewtype,detailtable,dsporder";
		  		if(isNewForm == true){
		  			if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
		  				sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,TO_NUMBER((select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
		  			}else{
		  				sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,convert(int, (select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
		  			}
		  		}else{
		  			sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
		  		}
	  		
		  		RecordSet.executeSql(sql);
		        int curgroupid=0;
		        String predetailtable=null;
		        while(RecordSet.next()){
	  				int curid=RecordSet.getInt("id");
	              	int viewtype=RecordSet.getInt("viewtype");
	              	String detailtable = Util.null2String(RecordSet.getString("detailtable"));
	              	WFNodeFieldMainManager.resetParameter();
	  				WFNodeFieldMainManager.setNodeid(nodeid);
	  				WFNodeFieldMainManager.setFieldid(curid);
	              	if(viewtype==1 && !detailtable.equals(predetailtable)){
	                  	predetailtable=detailtable;
	                  	curgroupid++;
	              	}
	  			}   
	  		  
	          for(int i=0;i<curgroupid;i++){
                  int dt1defaultrows = Util.getIntValue(request.getParameter("dtl_defrow_"+i),0);
                  dt1defaultrows = dt1defaultrows<=0?1:dt1defaultrows;                  
                  WFNodeDtlFieldManager.resetParameter();
                  WFNodeDtlFieldManager.setNodeid(nodeid);
                  WFNodeDtlFieldManager.setGroupid(i);	                  
                  WFNodeDtlFieldManager.setDefaultrows(dt1defaultrows);
                  WFNodeDtlFieldManager.saveWfNodeDtlField_defaultRow();
	          }
	      }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            statement.close();
        }
    }else if(modetype.equals("2")){ //Html编辑模式
    	//保存Html模板信息，当前节点及需要同步的节点模板
    	htmlLayoutOperate.setRequest(request);
    	htmlLayoutOperate.setUser(user);
    	htmlLayoutOperate.saveLayout_all();
        
    	//保存转PDF打印、打印流转意见选项
    	String printsyncNodes = Util.null2String(request.getParameter("printsyncNodes"));
        printsyncNodes = "".equals(printsyncNodes) ? (""+nodeid) : (printsyncNodes+","+nodeid);
        String pdfprint = "on".equals(Util.null2String(request.getParameter("pdfprint"))) ? "1" : "0";
      	//解决默认状态为选择，而默认状态 数据库字段printflowcomment 为null 读出以后为0，故0 为选择
        int printflowcomment=Util.getIntValue(Util.null2String(request.getParameter("printflowcomment")),1);
    	String syncsql = "update workflow_flownode set pdfprint='"+pdfprint+"',printflowcomment='"+printflowcomment+"' where workflowid="+wfid;
    	syncsql += " and nodeid in ("+printsyncNodes+")";
    	RecordSet.executeSql(syncsql);
    	
    	//增加html模式 显示内容保存 Start
        int showtype=Util.getIntValue(Util.null2String(request.getParameter("showtype2")),0);
        int vtapprove=0;
        int vtrealize=0;
        int vtforward=0;
		int vtpostil=0;
		int vtHandleForward = 0;
		int vtTakingOpinions = 0;
		int vttpostil=0;   
        int vtrecipient=0;
		int vtrpostil=0; 
        int vtreject=0;
        int vtsuperintend=0;
        int vtover=0;
        int vtintervenor=0;
        //处理意见,如果为空先默认置为1,设置表单中没有这个字段，但是签字意见加入表单中取意见需要用
        int vdcomments=0;
        int vddeptname=0;
        int vdoperator=0;
        int vddate=0;
        int vdtime=0;
        int stnull=Util.getIntValue(Util.null2String(request.getParameter("showtype_null2")),0);

        int vsignupload=0;
        int vsigndoc=0;
        int vsignworkflow=0;
		int vmobilesource=0;
        int toexcel=0;
        String viewtypeall=Util.null2String(request.getParameter("viewtype_all2"));
        String viewdescall=Util.null2String(request.getParameter("viewdesc_all2"));
        if(viewtypeall.indexOf("viewtype_all")!=-1||viewtypeall.equals("1")){
        	viewtypeall = "1";
        }else{
        	if(viewtypeall.indexOf("viewtype_approve")!=-1)
        		vtapprove=1;
        	if(viewtypeall.indexOf("viewtype_realize")!=-1)
        		vtrealize=1;
        	if(viewtypeall.indexOf("viewtype_forward")!=-1)
        		vtforward=1;
        	if(viewtypeall.indexOf("viewtype_postil")!=-1)
        		vtpostil=1;
			if(viewtypeall.indexOf("view_handleForward")!=-1)
        		vtHandleForward=1;
			if(viewtypeall.indexOf("view_takingOpinions")!=-1)
        		vtTakingOpinions=1;
			if(viewtypeall.indexOf("viewtype_tpostil")!=-1)
        		vttpostil=1;
			if(viewtypeall.indexOf("viewtype_recipient")!=-1)
        		vtrecipient=1;
        	if(viewtypeall.indexOf("viewtype_rpostil")!=-1)
        		vtrpostil=1;
        	if(viewtypeall.indexOf("viewtype_reject")!=-1)
        		vtreject=1;
        	if(viewtypeall.indexOf("viewtype_superintend")!=-1)
        		vtsuperintend=1;
        	if(viewtypeall.indexOf("viewtype_over")!=-1)
        		vtover=1;
        	if(viewtypeall.indexOf("viewtype_intervenor")!=-1)
        		vtintervenor=1;
        	viewtypeall = "0";
        }
        if(viewdescall.indexOf("viewdesc_all")!=-1||viewdescall.equals("1")){
        	viewdescall = "1";
			vdcomments=1;
			vddeptname=1;
			vdoperator=1;
			vddate=1;
			vdtime=1;
			vsignupload=1;
			vsigndoc=1;
			vsignworkflow=1;
			vmobilesource=1;
        }else{
        	if(viewdescall.indexOf("viewdesc_comments")!=-1)
        		vdcomments=1;
        	if(viewdescall.indexOf("viewdesc_deptname")!=-1)
        		vddeptname=1;
        	if(viewdescall.indexOf("viewdesc_operator")!=-1)
        		vdoperator=1;
        	if(viewdescall.indexOf("viewdesc_date")!=-1)
        		vddate=1;
        	if(viewdescall.indexOf("viewdesc_time")!=-1)
        		vdtime=1;
        	if(viewdescall.indexOf("viewdesc_signupload")!=-1)
        		vsignupload=1;
        	if(viewdescall.indexOf("viewdesc_signdoc")!=-1)
        		vsigndoc=1;
        	if(viewdescall.indexOf("viewdesc_signworkflow")!=-1)
        		vsignworkflow=1;
			if(viewdescall.indexOf("viewdesc_mobilesource")!=-1)
        		vmobilesource=1;

        	viewdescall = "0";
        }
        String noderemarksync = Util.null2String(request.getParameter("noderemarksync2"));
    	String nodeid_new = "";
    	if("".equals(noderemarksync))
    		nodeid_new = nodeid + "";
    	else
    		nodeid_new = nodeid + "," + noderemarksync;
    	
        String mysql="update workflow_flownode set viewtypeall='"+viewtypeall+"',viewdescall='"+viewdescall+"',showtype='"+showtype+"',vtapprove='"+vtapprove+"',vtforward='"+vtforward+"',vtTakingOpinions='"+vtTakingOpinions+"',vtHandleForward='"+vtHandleForward+"',vttpostil='"+vttpostil+"',vtrpostil='"+vtrpostil+"',vtover='"+vtover+"',vtintervenor='"+vtintervenor+"',vtpostil='"+vtpostil+"',vtrealize='"+vtrealize+"',vtrecipient='"+vtrecipient+"',vtreject='"+vtreject+"',vtsuperintend='"+vtsuperintend+
            "',vdcomments='"+vdcomments+"',vddate='"+vddate+"',vddeptname='"+vddeptname+"',vdoperator='"+vdoperator+"',vdtime='"+vdtime+"',stnull='"+stnull+"',vsignupload='"+vsignupload+"',vmobilesource='"+vmobilesource+"',vsigndoc='"+vsigndoc+"',vsignworkflow='"+vsignworkflow+"' where workflowid="+wfid+" and nodeid in ("+nodeid_new+")";
        boolean b= RecordSet.executeSql(mysql);
    	//增加html模式 显示内容保存 End
    }
    RecordSet.executeSql("update workflow_flownode set ismode='"+modetype+"' where workflowid="+wfid+" and nodeid="+nodeid);
	response.sendRedirect("addwfnodefield.jsp?ajax="+ajax+"&design="+design+"&wfid="+wfid+"&nodeid="+nodeid);
    return;
  }
   else if(src.equalsIgnoreCase("wfnodeportal")){
  	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);

  	String delids = Util.null2String(request.getParameter("delids"));

  	if(!delids.equals("")){
  		delids = delids.substring(1);
	  	String del_ids[] =Util.TokenizerString2(delids,",");
	  	for(int i=0;i<del_ids.length;i++){
	  		WFNodePortalMainManager.resetParameter();
        WFNodePortalMainManager.setId(Util.getIntValue(del_ids[i],0));
        WFNodePortalMainManager.deleteWfNodePortal();
        //add by xhheng @ 2004/12/08 for TDID 1317 start
        //删除出口日志
        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(wfid);
        SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15611,user.getLanguage()));
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_delete");
        SysMaintenanceLog.setOperateItem("88");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
        //add by xhheng @ 2004/12/08 for TDID 1317 end
 	 	  }
	  }

  	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodessum")));
        		
  	String postValue = Util.null2String(request.getParameter("portValueStr"));
  	String[] members = Util.TokenizerString2(postValue,"\u001b");
	for(int i=0;i<members.length;i++) {
		String linkvalue = members[i];
  		WFNodePortalMainManager.resetParameter();
  		WFNodePortalMainManager.setWfid(wfid);

  		int id = Util.getIntValue(Util.null2String(request.getParameter("por"+linkvalue+"_id")),0);

      WFNodePortalMainManager.setNodeid(Util.getIntValue(Util.null2String(request.getParameter("por"+linkvalue+"_nodeid")),0));
      WFNodePortalMainManager.setIsreject(Util.null2String(request.getParameter("por"+linkvalue+"_rej")));
      WFNodePortalMainManager.setLinkorder(Util.getIntValue(Util.null2String(request.getParameter("por_order_" + linkvalue)), -1));

      WFNodePortalMainManager.setLinkname(Util.null2String(request.getParameter("por"+linkvalue+"_link")));
      //WFNodePortalMainManager.setCondition(Util.null2String(request.getParameter("por"+i+"_con")));
      //add by xhheng @20050205 for TD 1537
      //WFNodePortalMainManager.setConditioncn(Util.null2String(request.getParameter("por"+i+"_con_cn")));
      WFNodePortalMainManager.setDestnodeid(Util.getIntValue(request.getParameter("por"+linkvalue+"_des")));
      WFNodePortalMainManager.setPasstime(Util.getFloatValue((String)request.getSession(true).getAttribute("por"+linkvalue+"_passtime"),-1));
      WFNodePortalMainManager.setIsBulidCode(Util.null2String(request.getParameter("por"+linkvalue+"_isBulidCode")));
      WFNodePortalMainManager.setIsMustPass(Util.null2String(request.getParameter("por"+linkvalue+"_ismustpass")));
      WFNodePortalMainManager.setTipsinfo(Util.null2String(request.getParameter("por"+linkvalue+"_tipsinfo")));    
      //modify by xhheng @ 2004/12/08 for TDID 1317 start
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(wfid);
      SysMaintenanceLog.setRelatedName(Util.null2String(request.getParameter("por"+linkvalue+"_link")));
      SysMaintenanceLog.setOperateItem("88");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      if(Util.getIntValue(request.getParameter("por"+linkvalue+"_des"))!=-1 && id ==0){
        WFNodePortalMainManager.saveWfNodePortal();
        //新增出口日志
        SysMaintenanceLog.setOperateType("1");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_insert");
        SysMaintenanceLog.setSysLogInfo();
      }
      if(Util.getIntValue(request.getParameter("por"+linkvalue+"_des"))!=-1 && id !=0){
        WFNodePortalMainManager.setId(id);
        WFNodePortalMainManager.updateWfNodePortal();
        //修改出口日志
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("WrokFlowNodePortal_update");
        SysMaintenanceLog.setSysLogInfo();
      }
      //modify by xhheng @ 2004/12/08 for TDID 1317 end
	}
	/////////
	if(!delids.equals("") || rowsum > 0){
		WorkflowInitialization wfinza = new WorkflowInitialization();
		wfinza.recordInformation(wfid);
	}
	/////////
	
      if(!ajax.equals("1"))
    response.sendRedirect("addwf.jsp?src=editwf&wfid="+wfid);
      else
   response.sendRedirect("addwfnodeportal.jsp?ajax=1&wfid="+wfid);   
    return;

  }
 /* else if(src.equalsIgnoreCase("formfieldlabel")){
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	ArrayList fields = new ArrayList();
  	ArrayList idarray = new ArrayList();

	FormFieldlabelMainManager.resetParameter();
	FormFieldlabelMainManager.setFormid(formid);
	FormFieldlabelMainManager.deleteFormfield();
	String ids=Util.null2String(request.getParameter("formfieldlabels"));
	int defaultlang=Util.getIntValue(Util.null2String(request.getParameter("isdefault")));
	idarray = Util.TokenizerString(ids,",");

	FormFieldMainManager.setFormid(formid);
	FormFieldMainManager.selectFormField();
	while(FormFieldMainManager.next()){
		int curid=FormFieldMainManager.getFieldid();
		fields.add(""+curid);
	}
	for(int i=0;i<idarray.size();i++) {
		int languageid = Util.getIntValue((String)idarray.get(i),0);
		String isdef = "0";
		if( languageid < 1)
			break;
		if(languageid == defaultlang)
			isdef = "1";
		for(int j=0; j< fields.size();j++) {
			String tfieldid=(String)fields.get(j);
			int fieldid = Util.getIntValue(tfieldid,0);
			FormFieldlabelMainManager.resetParameter();
			FormFieldlabelMainManager.setFormid(formid);
			FormFieldlabelMainManager.setFieldid(fieldid);
			FormFieldlabelMainManager.setLanguageid(languageid);
			String label = Util.null2String(request.getParameter("label_"+languageid+"_"+fieldid));
			if(label.equals(""))
				break;
			FormFieldlabelMainManager.setFieldlabel(label);
			FormFieldlabelMainManager.setIsdefault(isdef);
			FormFieldlabelMainManager.saveFormfieldlabel();
		}
	}

	response.sendRedirect("manageform.jsp");
	return;
  }
*/
%>