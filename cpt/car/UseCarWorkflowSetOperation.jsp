
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@page import="weaver.workflow.workflow.WorkflowBillComInfo"%>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="TestWorkflowComInfo" class="weaver.workflow.workflow.TestWorkflowComInfo" scope="page" />
<jsp:useBean id="RequestUserDefaultManager" class="weaver.workflow.request.RequestUserDefaultManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="page" />
<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />	
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<jsp:useBean id="formFieldUtil" class="weaver.workflow.form.FormFieldUtil" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
String operation =Util.fromScreen(request.getParameter("operation"),7);
String dialog = Util.null2String(request.getParameter("dialog"),"0");
String workflowname = Util.null2String(request.getParameter("workflowname"));
String typeid = Util.null2String(request.getParameter("typeid"));
String wftype = Util.null2String(request.getParameter("wftype"));
int formid = Util.getIntValue(request.getParameter("formid"));
int isuse = Util.getIntValue(request.getParameter("isuse"), 0);

int selectedCateLog = Util.getIntValue(request.getParameter("selectcatalog"),0);
int catelogType = Util.getIntValue(request.getParameter("catalogtype"),0);
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
int subCompanyId = Util.getIntValue(request.getParameter("subcompanyid"),-1);
int templateid=Util.getIntValue(request.getParameter("templateid"),0);

if(operation.equals("create") || operation.equals("createToDetails")){
	boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
  boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
  boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;
	//新建的时候如果类型是卡片生成表单，要将卡片生成表单
	if ("0".equals(wftype)) {
		//新建表单采用与单据相同的模式 TD8730 MYQ修改
	  	String from = Util.null2String(request.getParameter("from"));
	  	String formdes = Util.null2String(request.getParameter("formdes"));
	  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	  	formdes = Util.toHtmlForSplitPage(formdes);
	  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
	  	int subCompanyId3 = Util.getIntValue(request.getParameter("subcompanyid3"),-1);
	  	formid = FormManager.getNewFormId();
	  	String formtable_main = "formtable_main_"+formid*(-1);
	    if(formid<-1){
	  		String formname = formtable_main;
	  		RecordSetTrans.setAutoCommit(false);
	  		try{
			  	int namelabelid = -1;
			  	if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
			  	else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
			  	if(RecordSetTrans.next()) namelabelid = RecordSetTrans.getInt("indexid");//如果表单名称在标签库中存在，取得标签id
			  	else{
			  		namelabelid = FormManager.getNewIndexId(RecordSetTrans);//生成新的标签id
				  	if(namelabelid!=-1){//更新标签库
				  		RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+namelabelid);
				  		RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+namelabelid);
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+namelabelid+",'"+formname+"')");
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',7)");
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',8)");
				  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',9)");
				  	}
				  }
			  	
			  	if(subcompanyid==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
			  		subcompanyid = Util.getIntValue(manageDetachComInfo.getWfdftsubcomid(), -1);
			  		
			  		if(subcompanyid==-1){
			  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
			  			if(RecordSetTrans.next()) subcompanyid = RecordSetTrans.getInt("id");
			  		}
			  	}
				if(subCompanyId3==-1||subCompanyId3==0){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
			  		subCompanyId3 = Util.getIntValue(manageDetachComInfo.getWfdftsubcomid(), -1);
			  		if(subCompanyId3==-1||subCompanyId3==0){
			  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
			  			if(RecordSetTrans.next()) subCompanyId3 = RecordSetTrans.getInt("id");
			  		}
			  	}
	  			RecordSetTrans.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3) values("+formid+","+namelabelid+",'"+formtable_main+"','mainid','"+formdes+"',"+subcompanyid+","+subCompanyId3+")");
	  			String dbType = RecordSet.getDBType();
	  			if("oracle".equals(dbType)){//创建表单主表，明细表的创建在新建字段的时候如果有明细字段则创建明细表
		  			RecordSetTrans.executeSql("create table " + formtable_main + "(id integer primary key not null, requestId integer)");
		  		}else{
		  			RecordSetTrans.executeSql("create table " + formtable_main + "(id int IDENTITY(1,1) primary key CLUSTERED, requestId integer)");
		  		}
	  			if("oracle".equals(dbType)){//主表id自增长
		  			RecordSet.executeSql("create sequence "+formtable_main+"_Id start with 1 increment by 1 nomaxvalue nocycle");
		  			RecordSet.setChecksql(false);
		  			RecordSet.executeSql("CREATE OR REPLACE TRIGGER "+formtable_main+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main+"_Id.nextval into :new.id from dual; end;");
		  		}
				  LabelComInfo.addLabeInfoCache(""+namelabelid);//往缓存中添加表单名称的标签
				  BillComInfo.addBillCache(""+formid);
				  WorkflowBillComInfo workflowBillComInfo=new WorkflowBillComInfo();
				  workflowBillComInfo.addWorkflowBillCache(String.valueOf(formid));
	  		}catch(Exception exception){
				  RecordSetTrans.rollback();
			}
	  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
	  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
	  		}
	  		
	  		//新建好表单，给表单添加字段（将用车表转到新增加的表中）
	  	  	try{
	  		String maintablename = FormManager.getTablename(formid); //主表名
	  	  	
	  	  	Map<String,String> field_pubchoice_map = new LinkedHashMap<String,String>();
	  		Map<String,String> field_pubchilchoice_map = new LinkedHashMap<String,String>();
	  	  	
	  		RecordSet.executeSql("select id, dsporder, fieldlabel, fieldname, fielddbtype, fieldhtmltype, type, viewtype,detailtable,places,qfws, textheight,textheight_2,imgheight,imgwidth,selectitem,selectItemType,pubchoiceId,pubchilchoiceId from workflow_billfield where (viewtype is null or viewtype=0) and billid=163 and fromUser=1");
	  	  	while (RecordSet.next()) {
	  	  		String carid = Util.null2String(RecordSet.getString("id"));
	  	  			String selectItemType = Util.null2String(RecordSet.getString("selectItemType"));
	  				int pubchoiceId = Util.getIntValue(Util.null2String(RecordSet.getString("pubchoiceId")),0);
	  				int pubchilchoiceId = Util.getIntValue(Util.null2String(RecordSet.getString("pubchilchoiceId")),0);
	  				if(selectItemType.equals("0")){
	  					pubchoiceId = 0;
	  					pubchilchoiceId = 0;
	  				}
	  				if(selectItemType.equals("1")){
	  					pubchilchoiceId = 0;
	  				}
	  				if(selectItemType.equals("2")){
	  					pubchoiceId = 0;
	  				}
	  	  			
	  	  			String fieldname = Util.null2String(RecordSet.getString("fieldname"));
	  	  			if(fieldname.equals("")) continue;//先添加后删除的
	  	  			int imgwidth = Util.getIntValue(Util.null2String(RecordSet.getString("imgwidth")),0);
	  	            int imgheight = Util.getIntValue(Util.null2String(RecordSet.getString("imgheight")),0);
	  	  			String fieldlabel = Util.null2String(RecordSet.getString("fieldlabel"));
	  			  	
  				  String fieldhtmltype = Util.null2String(RecordSet.getString("fieldhtmltype"));
  				  if(!fieldhtmltype.equals("5")){
  				  	selectItemType = "0";
  				  	pubchilchoiceId=0;
  				  	pubchoiceId=0;
  				  }
	  				String fielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
	  				String type = Util.null2String(RecordSet.getString("type"));
	  				String viewtype = Util.null2String(RecordSet.getString("viewtype"));
	  				String detailtable = Util.null2String(RecordSet.getString("detailtable"));
	  				int textheight = Util.getIntValue(Util.null2String(RecordSet.getString("textheight")),4);
	  				String textheight_2 = Util.null2String(RecordSet.getString("textheight_2"));
	  				String linkfield = Util.null2String(RecordSet.getString("linkfield"));
	  				String locateType = Util.null2String(RecordSet.getString("locateType"));
	  				String dsporder = Util.null2String(RecordSet.getString("dsporder"));
	  				int childfieldid = Util.getIntValue(Util.null2String(RecordSet.getString("childfieldid")),0);
	  				String places = Util.null2String(RecordSet.getString("places"));
	  				String qfws = Util.null2String(RecordSet.getString("qfws"));
	  				String selectitem = Util.null2String(RecordSet.getString("selectitem"));
	  				
	  				String _sql = "INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight,places,qfws,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,locatetype) "+
	   					  " VALUES ("+formid+",'"+fieldname+"',"+fieldlabel+",'"+fielddbtype+"',"+fieldhtmltype+","+type+","+dsporder+","+viewtype+",'"+detailtable+"',"+textheight+",'"+textheight_2+"',"+childfieldid+","+imgwidth+","+imgheight+",'"+places+"','"+qfws+"','"+selectitem+"','"+linkfield+"','"+selectItemType+"',"+pubchoiceId+","+pubchilchoiceId+",'"+locateType+"')";
 					  
	  				//插入字段信息
 					  RecordSetTrans.executeSql(_sql);
	  				  //更新主表结构
	  				  RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+fielddbtype);
	  				  
	  				  
	  				  //如果是选择框，更新表workflow_SelectItem
	  				  String curfieldid = "";
  				      //RecordSetTrans.executeSql("select max(id) as id from workflow_billfield");
	  				  String sql_="select id from workflow_billfield where billid ="+formid+" and fieldname='"+fieldname+"'";
	                  if(detailtable==""){
	                        if(isoracle){
	                            sql_+=" and detailtable is null ";
	                        }else{
	                            sql_+=" and detailtable ='' ";
	                        }
	                  }else{
	                        sql_+=" and  detailtable ='"+detailtable+"'";
	                  }
	                  RecordSetTrans.executeSql(sql_);
  				      if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
  				      if ("627".equals(carid) ||"628".equals(carid) || "629".equals(carid) || "634".equals(carid) || "635".equals(carid) || "636".equals(carid) || "637".equals(carid) || "639".equals(carid)) {
  				    	 RecordSetTrans.executeSql("insert into mode_carrelatemode(mainid,carfieldid,modefieldid) values(-1,"+carid+","+curfieldid+")");
  				      }
	  				  
	  				  if(fieldhtmltype.equals("5")){
	  				    if (selectItemType.equals("1")){
	  				    	field_pubchoice_map.put(curfieldid,""+pubchoiceId);
	  				    }else if (selectItemType.equals("2")){
	  				    	field_pubchilchoice_map.put(curfieldid,""+pubchilchoiceId);
	  				    }
	  				  }
	  				  if(fieldhtmltype.equals("7")){              
	  					RecordSetTrans.executeSql("select * from workflow_specialfield where fieldid="+curfieldid);
	  				      if(RecordSetTrans.next()) {
		  		               String displayname = RecordSetTrans.getString("displayname");//显示名
		  		               String linkaddress = RecordSetTrans.getString("linkaddress");//链接地址
		  		               String descriptivetext = RecordSetTrans.getString("descriptivetext");//描述性文字
		  		             String isform = RecordSetTrans.getString("isform");//isform
		  		           String isbill = RecordSetTrans.getString("isbill");//isbill
		  		               descriptivetext = Util.spacetoHtml(descriptivetext);	
		  		               
		  			           String sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,descriptivetext,isform,isbill) values("+curfieldid+",'"+displayname+"','"+linkaddress+"','"+descriptivetext+"',"+isform+","+isbill+")";    
		  				       RecordSetTrans.executeSql(sql);
	  				  	}
	  				  }
	  				  
	  					String insertFieldId = curfieldid;
	  				  	RecordSetTrans.execute("select count(nodeid) as wfnfc from workflow_nodeform where fieldid="+insertFieldId);
	  				  	int wf_nf_count = 0;
	  				  	if(RecordSetTrans.next()){
	  				  		wf_nf_count = Util.getIntValue(RecordSetTrans.getString(1), 0);
	  				  	}
	  				  	if(wf_nf_count<1){
	  						ArrayList arrNodeId = new ArrayList();
	  						RecordSetTrans.executeSql("select nodeid from workflow_flownode where workflowid in (select id from workflow_base where formid="+formid+" and isbill=1)");
	  						while(RecordSetTrans.next()){
	  							arrNodeId.add(RecordSetTrans.getString("nodeid"));
	  						}
	  						for(int h=0; h < arrNodeId.size(); h++){
	  							RecordSetTrans.executeSql("insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory) values("+(String)arrNodeId.get(h)+","+insertFieldId+",'0','0','0')");
	  						}
	  				  	}
	  	  	}
	  	  	//主字段 结束
	  			RecordSetTrans.commit();
	  			
	  			
	  			for(Map.Entry<String, String> entry: field_pubchoice_map.entrySet()){
	  			    int fieldid = Util.getIntValue(entry.getKey(),0);
	  			    int pubchoiceId = Util.getIntValue(entry.getValue(),0);
	  				SelectItemManager.setSelectOpBypubid(formid+"",pubchoiceId,fieldid+"",1,user.getLanguage());
	  			}
	  			for(Map.Entry<String, String> entry: field_pubchilchoice_map.entrySet()){
	  			    int fieldid = Util.getIntValue(entry.getKey(),0);
	  			    int pubchilchoiceId = Util.getIntValue(entry.getValue(),0);
	  				SelectItemManager.setSuperSelectOp(formid+"",1,pubchilchoiceId,fieldid,user.getLanguage());
	  			}
	  			
	  	  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
	  	  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
	  	  		}
	  	  }catch(Exception e){
	  		  e.printStackTrace();
	  			RecordSetTrans.rollback();
	  		}finally{
	  			formFieldUtil.syncDB(formid);
	  		}
	  	}
	}
	
	int wfid = 0;
	WFManager.reset();
  	WFManager.setAction("addwf");
  	WFManager.setWfname(Util.null2String(request.getParameter("workflowname")));
  	WFManager.setWfdes(Util.null2String(request.getParameter("wfdes")));        
  	WFManager.setTypeid(Util.getIntValue(Util.null2String(request.getParameter("typeid"))));
  	String isbill = Util.null2String(1);
  	String iscust = Util.null2String(request.getParameter("iscust"));
  	int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
    String isvalid= "1";
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
    String defaultName= Util.null2String(request.getParameter("defaultName"),"1");

	if(defaultName.equals("1")){//标题默认增加规则
		DateUtil.InitializationWFTitle(""+wfid);
	}
	//add by xhheng @ 20050317 for 附件上传
    String pathcategory= Util.null2String(request.getParameter("pathcategory"));
    String maincategory= Util.null2String(request.getParameter("maincategory"));
    String subcategory= Util.null2String(request.getParameter("subcategory"));
    String seccategory= Util.null2String(request.getParameter("seccategory"));
    int docRightByHrmResource = Util.getIntValue(request.getParameter("docRightByHrmResource"),0);
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
  int dsporder = Util.getIntValue(request.getParameter("dsporder"),0);
  	String isFree = request.getParameter("isFree") == null ? "0" : "1";
    if("".equals(isneeddelacc))  isneeddelacc="0";
 	formid = formid;  		
	String tablename = "";
	RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
	if(RecordSet.next()) tablename = RecordSet.getString("tablename");
	if(tablename.equals("formtable_main_"+formid*(-1)) || tablename.startsWith("uf_")){//新创建的表单做为单据保存
		isbill = "1";
	}
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
    wfid=WFManager.setWfInfo();

    WorkflowComInfo.removeWorkflowCache();
    TestWorkflowComInfo.removeWorkflowCache();
	RequestUserDefaultManager.addDefaultOfSysAdmin(String.valueOf(wfid));

	//将新添加的流程加入版本信息表
	WorkflowVersion wv=new WorkflowVersion();
	wv.saveWorkflowVersionInfo(wfid+"");

    SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(wfid);
    SysMaintenanceLog.setRelatedName(workflowname);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("WrokFlow_insert");
    SysMaintenanceLog.setOperateItem("85");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setIstemplate(Util.getIntValue(isTemplate));
    SysMaintenanceLog.setSysLogInfo();
    
	
    boolean flag = RecordSet.executeSql("insert into carbasic(workflowid,typeid,wtype,formid,isuse) values('"+wfid+"','"+typeid+"','"+wftype+"','"+formid+"','"+isuse+"')");
    if(flag){
	    String sql_ = "select max(id) id from carbasic";
		RecordSet.executeSql(sql_);
		if (RecordSet.next()) {
			String id = RecordSet.getString("id");
			RecordSet.executeSql("update mode_carrelatemode set mainid="+id+" where mainid=-1");
		}
    }
    
    if (operation.equals("create")) {
    	response.sendRedirect("/cpt/car/UseCarWorkflowSetCreate.jsp?isclosed=1");
    } else if (operation.equals("createToDetails")) {
    	response.sendRedirect("/cpt/car/UseCarWorkflowSetCreate.jsp?isclosedToDetails=1&workflowid="+wfid);
    }
	return;
}

else if(operation.equals("add")){
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String id = Util.null2String(request.getParameter("id"));
	if ("".equals(id)) {
		RecordSet.executeSql("insert into carbasic(workflowid,typeid,wtype,formid,isuse) values('"+workflowid+"','"+typeid+"','"+wftype+"','"+formid+"','"+isuse+"')");
	} else {
		RecordSet.executeSql("update carbasic set isuse="+isuse+" where id="+id);
	}
	response.sendRedirect("/cpt/car/UseCarWorkflowSetAdd.jsp?isclosed=1");
	return;
}

else if(operation.equals("createToDetails2")){
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	boolean flag = RecordSet.executeSql("insert into carbasic(workflowid,typeid,wtype,formid,isuse) values('"+workflowid+"','"+typeid+"','"+wftype+"','"+formid+"','"+isuse+"')");
	String id = "";
	if(flag){
		String sql = "select max(id) id from carbasic";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			id = RecordSet.getString("id");
		}
	}
	response.sendRedirect("/cpt/car/UseCarWorkflowSetAdd.jsp?isclosedToDetails=1&id="+id);
	return;
}

else if (operation.equals("use")) {
	String id = request.getParameter("id");
	RecordSet.executeSql("update carbasic set isuse=1 where id="+id);
	response.sendRedirect("/cpt/car/UseCarWorkflowSetIframe.jsp");
	return;
}

else if (operation.equals("close")) {
	String id = request.getParameter("id");
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	RecordSet.executeSql("select * from carbasic where id="+id);
	if (RecordSet.next()) {
		RecordSet.executeSql("update carbasic set isuse=0 where id="+id);
	} else {
		RecordSet.executeSql("insert into carbasic(workflowid,typeid,wtype,formid,isuse) values('"+workflowid+"','','','163','0')");
	}
	response.sendRedirect("/cpt/car/UseCarWorkflowSetIframe.jsp");
	return;
}

else if(operation.equals("delete")){
	String id = request.getParameter("id");
	RecordSet.executeSql("delete carbasic where id="+id);
	response.sendRedirect("/cpt/car/UseCarWorkflowSetIframe.jsp");
	return;
}

else if(operation.equals("getForminfo")){
	String workflowid = Util.null2String(request.getParameter("workflowid"),"0");
	String data = "";
	RecordSet.executeSql("select * from carbasic where workflowid="+workflowid);
	if (RecordSet.next()) {
		data = "1";
		return;
	}
	RecordSet.executeSql("select formid,info.labelname as formname,workflowtype from workflow_base b,workflow_bill f,htmllabelinfo info where b.formid=f.id and f.namelabel=info.indexid and info.languageid=7 and b.id="+workflowid+" and b.isbill=1");
	JSONArray jsonArray = new JSONArray();
	
	if (RecordSet.next()) {
		String formid_ = RecordSet.getString("formid");
		String formname_ = RecordSet.getString("formname");
		String workflowtype = RecordSet.getString("workflowtype");
		data="{\"formid\":\""+formid_+"\",\"formname\":\""+formname_+"\",\"workflowtype\":\""+workflowtype+"\"}";
		out.println(data);
		return;
	}
}

else if (operation.equals("saveFieldRelate")) {
	String mainid = request.getParameter("mainid");
	String[] carfieldids = request.getParameterValues("carfieldid");
	String[] modefieldids = request.getParameterValues("modefieldid");
	RecordSet.executeSql("delete mode_carrelatemode where mainid="+mainid);
	for (int i = 0 ; i < carfieldids.length ; i++) {
		String carfieldid = carfieldids[i];
		String modefieldid = modefieldids[i];
		RecordSet.executeSql("insert into mode_carrelatemode(mainid,carfieldid,modefieldid) values("+mainid+",'"+carfieldid+"','"+modefieldid+"')");
	}
	response.sendRedirect("/cpt/car/CarInfoRelateMode.jsp?isclosed=1&id="+mainid);
	return;
}
%>
