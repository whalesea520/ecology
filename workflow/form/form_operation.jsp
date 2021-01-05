<%@page import="com.weaver.formmodel.util.StringHelper"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WorkflowBillComInfo"%>

<%@ page import="java.util.*,java.util.regex.*" %>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="formFieldUtil" class="weaver.workflow.form.FormFieldUtil" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="fieldCommon" class="weaver.workflow.field.FieldCommon" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />	
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="WorkflowSubwfFieldManager" class="weaver.workflow.field.WorkflowSubwfFieldManager" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />

<%FormFieldlabelMainManager.resetParameter();
User user = HrmUserVarify.getUser (request , response) ;
%>

<%
  boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
  boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
  boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;
  String appid = Util.null2String(request.getParameter("appid"));
  String ajax=Util.null2String(request.getParameter("ajax"));
  String src = Util.null2String(request.getParameter("src"));
  String fromWFCode = Util.null2String(request.getParameter("fromWFCode"));
  String dialog = Util.null2String(request.getParameter("dialog"),"1");//qyw
  String saveOrSet = Util.null2String(request.getParameter("saveOrSet"));//qyw
  int groupId=Util.getIntValue(Util.null2String(request.getParameter("groupId")),0);
  int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
  int tmpFormid = -1;
////得到标记信息
  if(src.equalsIgnoreCase("addform")){
    //int isformadd = Util.getIntValue(request.getParameter("isformadd"));
    //System.out.println("isformadd:"+isformadd);
    //FormManager.reset();
  	//FormManager.setAction("addform");
  	//FormManager.setFormname(Util.null2String(request.getParameter("formname")));
  	//FormManager.setFormdes(Util.null2String(request.getParameter("formdes")));
  	//FormManager.setSubCompanyId2(Util.getIntValue(request.getParameter("subcompanyid"),-1) );
  	//FormManager.setFormInfo();
  	//FormComInfo.removeFormCache();
    //RecordSet.executeSql("select max(id) as id from workflow_formbase");
    //int formid=0;
    //if(RecordSet.next()){
  	//	formid = Util.getIntValue(Util.null2String(RecordSet.getString("id")),0);
  	//}
  	
  	//新建表单采用与单据相同的模式 TD8730 MYQ修改
  	int formid = -1;
	tmpFormid = formid;
  	//System.out.println("formid=="+formid);
  	String from = Util.null2String(request.getParameter("from"));
  	String formname = Util.null2String(request.getParameter("formname"));
  	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formname = Util.toHtmlForSplitPage(formname);
  	//同名验证 开始 TD10194
  	boolean issamename = false;
  	RecordSet.executeSql("select namelabel from workflow_bill");
  	
    while(RecordSet.next()){//新表单名和单据名
  	    int namelabel = Util.getIntValue(Util.null2String(RecordSet.getString("namelabel")),0);
  	    if(namelabel!=0)
  	    {
  	        if(formname.equals(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
  	RecordSet.executeSql("select formname from workflow_formbase");
    while(RecordSet.next()){//旧表单名
  	    String tempformname = Util.null2String(RecordSet.getString("formname"));
  	    if(!tempformname.equals(""))
  	    {
  	        if(formname.equals(tempformname))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
  	if(issamename){
  	    if(from.equals("addDefineForm")){
  	        response.sendRedirect("/workflow/form/addform.jsp?from=addDefineForm&message=issamename&isFromMode="+isFromMode+"&ajax="+ajax+"&dialog="+dialog+"&appid="+appid);//gzt update TD27194
  	        return;
  	    }else{
  	        response.sendRedirect("/workflow/form/editform.jsp?message=issamename&isFromMode="+isFromMode+"&ajax="+ajax+"&dialog="+dialog);//gzt update TD27194
  	        return;
  	    }
  	}
  	//同名验证 结束 TD10194
	
  	String formdes = Util.null2String(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formdes = Util.toHtmlForSplitPage(formdes);
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
  	int subCompanyId3 = Util.getIntValue(request.getParameter("subcompanyid3"),-1);
  	formid = FormManager.getNewFormId();
  	String formtable_main;
  	if(isFromMode == 1){	//请求来自表单建模
  		formtable_main = "uf_" + Util.null2String(request.getParameter("tablename"));
		if(from.equals("addDefineForm")){ //验证数据库表名是否存放(后台验证，防止相同页面同时提交)
	  		boolean tableISExists = FormManager.isHaveSameTableInDB(formtable_main);
	  		if(tableISExists){
	  			response.sendRedirect("/workflow/form/addDefineForm.jsp?message=issametablename&isFromMode="+isFromMode+"&ajax="+ajax+"&dialog="+dialog);
	  			return;
	  		}
		}
  	}else{
  		formtable_main = "formtable_main_"+formid*(-1);
  	}
  	if(formid<-1){
  		boolean success = false;
  		//String formtable_main = "formtable_main_"+formid*(-1);//主表名
  		formname = formname.replaceAll("<","＜").replaceAll(">","＞");
  		//String formtable_detail = "formtable_detail_"+formid;//明细表名
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
		  	//不管是流程还是建模新建的表单保证subCompanyId3和subcompanyid一致为页面上设置的机构
		  	if(subcompanyid!=-1){
		  		subCompanyId3 = subcompanyid;
		  	}else if(subCompanyId3!=-1&&subCompanyId3!=0){
		  		subcompanyid = subCompanyId3;
		  	}else{
		  	if(subcompanyid==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
		  		//RecordSetTrans.executeSql("select dftsubcomid from SystemSet");
		  		//if(RecordSetTrans.next()) subcompanyid = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
		  		
		  		subcompanyid = Util.getIntValue(manageDetachComInfo.getWfdftsubcomid(), -1);
		  		
		  		if(subcompanyid==-1){
		  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
		  			if(RecordSetTrans.next()) subcompanyid = RecordSetTrans.getInt("id");
		  		}
		  	}
		  	
		  	
			if(subCompanyId3==-1||subCompanyId3==0){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
		  		//RecordSetTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
		  		//if(RecordSetTrans.next()){
		  		//	subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("fmdftsubcomid"),-1);
		  		//	if(subCompanyId3==-1||subCompanyId3==0){
		  		//		subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
		  		//	}
		  		//}
		  		subCompanyId3 = Util.getIntValue(manageDetachComInfo.getWfdftsubcomid(), -1);
		  		if(subCompanyId3==-1||subCompanyId3==0){
		  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
		  			if(RecordSetTrans.next()) subCompanyId3 = RecordSetTrans.getInt("id");
		  		}
		  	}
			if(isFromMode == 1){
				RecordSetTrans.executeSql("select fmdetachable,fmdftsubcomid,dftsubcomid from SystemSet");
		  		if(RecordSetTrans.next()){
		  			int fmdetachable = Util.getIntValue(RecordSetTrans.getString("fmdetachable"),0);
		  			if(fmdetachable == 1){
				  		subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("fmdftsubcomid"),-1);
				  		if(subCompanyId3==-1||subCompanyId3==0){
				  			subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
			  			}
		  			}else{
		  				subCompanyId3 = -1;
		  			}
				}
			}
		  	}
  			RecordSetTrans.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3) values("+formid+","+namelabelid+",'"+formtable_main+"','mainid','"+formdes+"',"+subcompanyid+","+subCompanyId3+")");
  			String dbType = RecordSet.getDBType();
  			if("oracle".equals(dbType)){//创建表单主表，明细表的创建在新建字段的时候如果有明细字段则创建明细表
	  			RecordSetTrans.executeSql("create table " + formtable_main + "(id integer primary key not null, requestId integer)");
	  			//RecordSetTrans.executeSql("create sequence "+formtable_main+"_Id start with 1 increment by 1 nomaxvalue nocycle");
	  			//RecordSetTrans.executeSql("CREATE OR REPLACE TRIGGER "+formtable_main+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main+"_Id.nextval into :new.id from dual; end;");
	  		}else{
	  			RecordSetTrans.executeSql("create table " + formtable_main + "(id int IDENTITY(1,1) primary key CLUSTERED, requestId integer)");
	  		}
	  		if(!StringHelper.isEmpty(appid)){
	  			RecordSetTrans.executeSql("insert into AppFormInfo(appid,formid)values("+appid+","+formid+")");
	  		}
  			RecordSetTrans.commit();
  			if("oracle".equals(dbType)){//主表id自增长
	  			RecordSet.executeSql("create sequence "+formtable_main+"_Id start with 1 increment by 1 nomaxvalue nocycle nocache");
	  			RecordSet.setChecksql(false);
	  			RecordSet.executeSql("CREATE OR REPLACE TRIGGER "+formtable_main+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main+"_Id.nextval into :new.id from dual; end;");
	  		}
			  LabelComInfo.addLabeInfoCache(""+namelabelid);//往缓存中添加表单名称的标签
			  BillComInfo.addBillCache(""+formid);
			  WorkflowBillComInfo workflowBillComInfo=new WorkflowBillComInfo();
			  workflowBillComInfo.addWorkflowBillCache(String.valueOf(formid));
			  
			  //System.out.println("test:"+from+";dialog:"+dialog+";saveOrSet:"+saveOrSet);
			  if(from.equals("addDefineForm")){
				if("1".equals(dialog) && "0".equals(saveOrSet)){
  				 response.sendRedirect("/workflow/form/addform.jsp?isadd=false&formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax+"&isclose=1");
  			    }else if("1".equals(dialog) && "1".equals(saveOrSet)){
  				 response.sendRedirect("/workflow/form/addform.jsp?isadd=true&formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax+"&isclose=1");
  			    }
			  }else{ 
  				response.sendRedirect("/workflow/form/editform.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax);
  			  }
			 
			  success = true;
  		}catch(Exception exception){
			success = false;
			  RecordSetTrans.rollback();
		  }
  		//TD10835 根据已有表单新建表单，需要把原表单的信息复制过来 chujun
  		if(success == true){//如果上面失败了，就不要下面的操作了
	  		int oldformid = Util.getIntValue(request.getParameter("oldformid"), 0);
	  		if(oldformid != 0){
	  			int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	  			FormManager.setFormInfoByTemplate(formid, oldformid);
	  		}
  		}
  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
  		}
  	}
  	//新建表单采用与单据相同的模式 TD8730 MYQ修改
    //response.sendRedirect("/workflow/form/editform.jsp?src=editform&formid="+formid+"&ajax="+ajax+"&isformadd="+isformadd);

  }
  else if(src.equalsIgnoreCase("editform")){
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	tmpFormid = formid;
	String formname = request.getParameter("formname").replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	boolean issamename = false;
  	RecordSet.executeSql("select namelabel from workflow_bill where id !="+formid);
    while(RecordSet.next()){//新表单名和单据名
  	    int namelabel = Util.getIntValue(Util.null2String(RecordSet.getString("namelabel")),0);
  	    if(namelabel!=0)
  	    {
  	        if(formname.equals(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
  	RecordSet.executeSql("select formname from workflow_formbase where id !="+formid);
    while(RecordSet.next()){//旧表单名
  	    String tempformname = Util.null2String(RecordSet.getString("formname"));
  	    if(!tempformname.equals(""))
  	    {
  	        if(formname.equals(tempformname))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
    String isoldform = Util.null2String(request.getParameter("isoldform"));
  	if(issamename){
  		response.sendRedirect("/workflow/form/addform.jsp?src=editform&formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax+"&message=issamename&isoldform="+isoldform);
	    return;
  	}
	FormManager.reset();
  	FormManager.setAction("editform");
  	FormManager.setFormid(formid);
  	FormManager.setFormname(Util.null2String(formname));
  	String formdes = request.getParameter("formdes").replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	FormManager.setFormdes( Util.null2String(formdes));
    FormManager.setSubCompanyId2(Util.getIntValue(request.getParameter("subcompanyid"),-1) );
    FormManager.setSubCompanyId3(Util.getIntValue(request.getParameter("subcompanyid3"),-1) );
  	FormManager.setFormInfo();
  	FormComInfo.removeFormCache();
    response.sendRedirect("/workflow/form/addform.jsp?src=editform&formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax+"&isoldform="+isoldform);

  }
  else if(src.equalsIgnoreCase("formfield")){
  	//老表单的字段管理添加集成多选浏览按钮zzl
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	int sapclos=Util.getIntValue(Util.null2String(request.getParameter("sapclos")),0);//记录添加过的明细表的个数
	tmpFormid = formid;
	FormFieldMainManager.resetParameter();
    FormFieldMainManager.setGroupId(groupId);
	FormFieldMainManager.setFormid(formid);
	
	  String[] mulId;  
	  String ids=Util.null2String(request.getParameter("formfields"));//added by xwj for td3325 20051205
	  String ids2=Util.null2String(request.getParameter("formfields2"));//added by xwj for td3325 20051205
	  String mulIds=""; 
	   //新增多明细 by ben 2006-04-27
	  int rownum=Util.getIntValue(request.getParameter("rownum"),0);
	 
	for(int i = 0; i < rownum; i++)
	{
	    mulId = request.getParameterValues("destListMul" + i);
	      
	    if (mulId != null)
	    {
	    	for (int j = 0; j < mulId.length; j++)
	    	{ 
	    		mulIds += mulId[j];
	    		mulIds += ",";
	    	}
	    }
	}
	
	if(FormFieldMainManager.checkByRef(Util.null2String(request.getParameter("formfields")),mulIds+Util.null2String(request.getParameter("formfields2")))){
	        response.sendRedirect("/workflow/form/addformfield.jsp?formid="+formid+"&errorcode=1&isFromMode="+isFromMode+"&ajax="+ajax);
	        return;
	    }

	if(WorkflowSubwfFieldManager.hasSubWfSettingForForm(","+Util.null2String(request.getParameter("formfields"))+","+mulIds+Util.null2String(request.getParameter("formfields2")),formid,0)){
		response.sendRedirect("/workflow/form/addformfield.jsp?formid="+formid+"&errorcode=2&isFromMode="+isFromMode+"&ajax="+ajax);
	    return;
	}

    //fieldCommon.initNewFieldIsView(""+formid,Util.TokenizerString2(ids,","),Util.TokenizerString2(ids2,","));//added by xwj for td3325 20051205
    
	FormFieldMainManager.deleteFormfield();
	//delete by  by xwj for td3325 20051205
	FormFieldMainManager.saveFormfield(Util.TokenizerString2(ids,","));
    //begin 王金永 add
    
    FormFieldMainManager.deleteDetailFormfield();
   //delete by  xwj for td3325 20051205
    FormFieldMainManager.setGroupId(0);
	FormFieldMainManager.saveDetailFormfield(Util.TokenizerString2(ids2,","));
	//System.out.println("主表下的明细表的"+ids2);
	String mul01=Util.null2String(request.getParameter("newsapmultiBrowservalue_0" ));
	if(!"".equals(mul01)){
		RecordSet.execute("select * from sap_multiBrowser where mxformname='0' and mxformid='"+formid+"'");
		if(!RecordSet.next()){
			RecordSet.execute(" insert  into  sap_multiBrowser (mxformname,mxformid,browsermark,isbill) values('0','"+formid+"','"+mul01+"','0')");
		}
	}
    //end
    
     //先删除，再添加
    RecordSet.execute("delete   sap_multiBrowser where mxformid='"+formid+"' and mxformname!='0' and isbill=0");
    
    List listsap=new ArrayList();
    //新增多明细 by ben 2006-04-27
    //int rownum=Util.getIntValue(request.getParameter("rownum"),0);
    for(int i = 0; i < rownum; i++)
    { 
    	mulId = request.getParameterValues("destListMul" + i);
    
    	if (mulId != null)
    	{
    		String[] temp;
    		temp=request.getParameterValues("null");
    		//fieldCommon.initNewFieldIsView("" + formid, temp, mulId);
    		FormFieldMainManager.setGroupId(i + 1);
    		listsap.add((i + 1));//记录有效的明细表的id
			FormFieldMainManager.saveDetailFormfield(mulId);			
		}else{
			listsap.add("");//记录无效的明细表的id
		}
    }
    int tempsap=0;
    if(listsap.size()>0){
	    for(int i=1;i<sapclos;i++){
	  			String mul=Util.null2String(request.getParameter("newsapmultiBrowservalue_" + i));
	  			if(!"".equals(mul)&&tempsap<listsap.size()){
	  					if(!"".equals(listsap.get(tempsap))){
							RecordSet.execute(" insert  into  sap_multiBrowser (mxformname,mxformid,browsermark,isbill) values('"+listsap.get(tempsap)+"','"+formid+"','"+mul+"','0')");
							
						}
				}
				tempsap++;
	    }
    }
    
    fieldCommon.initNewFieldIsView("" + formid, Util.TokenizerString2(ids, ","), Util.TokenizerString2(ids2 + mulIds, ","));
    
    //清除被删除字段的节点字段信息
    FormFieldMainManager.deleteNodefield();
	response.sendRedirect("/workflow/form/addformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax);
	
 	
  }
  else if(src.equalsIgnoreCase("formfieldlabel")){
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	tmpFormid = formid;
  	ArrayList fields = new ArrayList();
  	ArrayList idarray = new ArrayList();

	FormFieldlabelMainManager.resetParameter();
	FormFieldlabelMainManager.setFormid(formid);
	//FormFieldlabelMainManager.deleteFormfield();
	String ids=Util.null2String(request.getParameter("formfieldlabels"));
	if(!ids.equals("")){  //add by king for formfieldlabels is null
		int defaultlang=Util.getIntValue(Util.null2String(request.getParameter("isdefault")));
		idarray = Util.TokenizerString(ids,",");

		if(defaultlang==-1) defaultlang = user.getLanguage();//TD14315

		FormFieldMainManager.setFormid(formid);
		FormFieldMainManager.selectAllFormField();
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
				String label = request.getParameter("label_"+languageid+"_"+fieldid);
				if(label == null){
					break;
                }
				label = Util.StringReplace(label, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
				label = Util.StringReplace(label, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
				FormFieldlabelMainManager.setFieldlabel(label);
				FormFieldlabelMainManager.setIsdefault(isdef);
				FormFieldlabelMainManager.saveFormfieldlabel();
			}
		}
	}

	response.sendRedirect("/workflow/form/addformfieldlabel.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax);
  }
  else if (src.equalsIgnoreCase("formfielddetail"))
  {
    int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	tmpFormid = formid;
	String ids2=Util.null2String(request.getParameter("formfields2"));
	groupId=Util.getIntValue(Util.null2String(request.getParameter("groupId")),1);
	FormFieldMainManager.resetParameter();
    FormFieldMainManager.setGroupId(groupId);
	FormFieldMainManager.setFormid(formid);
	 FormFieldMainManager.deleteDetailFormfield();
   //delete by  xwj for td3325 20051205
	FormFieldMainManager.saveDetailFormfield(Util.TokenizerString2(ids2,","));
	response.sendRedirect("/workflow/form/addformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax="+ajax);
    return;
}else if(src.equals("eidtform")){
	String formname = Util.null2String(request.getParameter("formname"));
	String formid = Util.null2String(request.getParameter("formid"));
  	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formname = Util.toHtmlForSplitPage(formname);
  		boolean issamename = false;
  	RecordSet.executeSql("select namelabel from workflow_bill where id !="+formid);
    while(RecordSet.next()){//新表单名和单据名
  	    int namelabel = Util.getIntValue(Util.null2String(RecordSet.getString("namelabel")),0);
  	    if(namelabel!=0)
  	    {
  	        if(formname.equals(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
  	RecordSet.executeSql("select formname from workflow_formbase where id !="+formid);
    while(RecordSet.next()){//旧表单名
  	    String tempformname = Util.null2String(RecordSet.getString("formname"));
  	    if(!tempformname.equals(""))
  	    {
  	        if(formname.equals(tempformname))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
  	if(issamename){
  		response.sendRedirect("/workflow/form/editform.jsp?ajax=1&formid="+formid+"&isFromMode="+isFromMode+"&message=issamename");
	    return;
  	}
  	int namelabelid = -1;
  	if(issqlserver) RecordSet.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		else RecordSet.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		if(RecordSet.next()) namelabelid = RecordSet.getInt("indexid");//如果表单名称在标签库中存在，取得标签id
		else{
			namelabelid = FormManager.getNewIndexId(RecordSetTrans);//生成新的标签id
			if(namelabelid!=-1){//更新标签库
				RecordSet.executeSql("delete from HtmlLabelIndex where id="+namelabelid);
				RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+namelabelid);
				RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+namelabelid+",'"+formname+"')");
				RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',7)");
				RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',8)");
				RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',9)");
			}
		}
		LabelComInfo.addLabeInfoCache(""+namelabelid);//往缓存中添加表单名称的标签
		BillComInfo.addBillCache(formid,namelabelid);
			  
  	String formdes = Util.null2String(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formdes = Util.toHtmlForSplitPage(formdes);
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
  	int subCompanyId3 = Util.getIntValue(request.getParameter("subcompanyid3"),-1);
  	if(subcompanyid==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
			RecordSet.executeSql("select dftsubcomid from SystemSet");
			if(RecordSetTrans.next()) subcompanyid = Util.getIntValue(RecordSet.getString("dftsubcomid"),-1);
			if(subcompanyid==-1){
		  	RecordSet.executeSql("select min(id) as id from HrmSubCompany");
		  	if(RecordSet.next()) subcompanyid = RecordSet.getInt("id");
			}
		}
  	
  	if(subCompanyId3==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
  		RecordSetTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
  		if(RecordSetTrans.next()){
  			subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("fmdftsubcomid"),-1);
  			if(subCompanyId3==-1){
  				subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
  			}
  		}
  		if(subCompanyId3==-1){
  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
  			if(RecordSetTrans.next()) subCompanyId3 = RecordSetTrans.getInt("id");
  		}
  	}
  	RecordSet.executeSql("update workflow_bill set subcompanyid="+subcompanyid+",subcompanyid3="+subCompanyId3+", namelabel="+namelabelid+",formdes='"+formdes+"' where id="+formid);
  	response.sendRedirect("/workflow/form/editform.jsp?ajax=1&isFromMode="+isFromMode+"&formid="+formid);
}else if(src.equals("addfieldbatch")){
	//批量添加字段
  	char flag=2;
  	RecordSetTrans.setAutoCommit(false);
  	boolean modifyFieldtypeSuccess = true;	//状态变量(判断修改字段时修改字段类型是否成功)
  	
  	int formid = Util.getIntValue((request.getParameter("formid")),0);//表单id
  	
  	try{
	tmpFormid = formid;
	String maintablename = FormManager.getTablename(formid); //主表名
  	//String maintablename = "formtable_main_"+formid*(-1);//主表名
  	int recordNum = Util.getIntValue(Util.null2String(request.getParameter("recordNum")),0);//字段行数
  	String delids = Util.null2String(request.getParameter("delids"));//删除行id集
  	String changeRowIndexs = Util.null2String(request.getParameter("changeRowIndexs"));//有改变的行id集
  	String labelidsCache = ",";//更新缓存用
  	String jumpRowindex = Util.null2String(request.getParameter("jumpRowindex"));
  	int jumpfieldid = 0;
  	
  	Map<String,String> field_pubchoice_map = new LinkedHashMap<String,String>();
	Map<String,String> field_pubchilchoice_map = new LinkedHashMap<String,String>();
  	
  	//主字段 开始
  	ArrayList delidsArray = Util.TokenizerString(delids,",");
  	//删除指定的字段
  	for(int i=0;i<delidsArray.size();i++){
  		String fieldnameForDel = "";
  		String delFieldId = (String)delidsArray.get(i);
		//如果主字段被列规则引用，则退出。
		RecordSetTrans.executeSql("select * from workflow_formdetailinfo where maincalstr like '%!_"+delFieldId+"_%' escape '!' or maincalstr like '%!_"+delFieldId+"' escape '!'");
		if(RecordSetTrans.next()){
		    RecordSetTrans.rollback();
		    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodelete");
		    return;
		}

          if(WorkflowSubwfFieldManager.hasSubWfSetting(RecordSetTrans,Util.getIntValue(delFieldId,0),1)){
		    RecordSetTrans.rollback();
		    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodeleteForSubWf");
		    return;
		}

  		RecordSetTrans.executeSql("select fieldname from workflow_billfield where id="+delFieldId);
  		if(RecordSetTrans.next()) fieldnameForDel = RecordSetTrans.getString("fieldname");//取得字段名
  		RecordSetTrans.executeSql("delete from workflow_billfield where id="+delFieldId);//删除字段
  		RecordSetTrans.execute("update workflow_billfield set childfieldid=0 where childfieldid="+delFieldId);//如果被删除字段是子字段，则需要修改
  		RecordSetTrans.executeSql("alter table "+maintablename+" drop column "+fieldnameForDel);//修改表结构
  		RecordSetTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+delFieldId);//删除表workflow_SelectItem中该字段对应数据
  		RecordSetTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid="+delFieldId);//删除表workflow_specialfield中该字段对应数据
  		
		//删除与该字段相关的出口条件
		Pattern mpattern = null;
		Matcher mmatcher = null;
		String partStr = "\\b"+fieldnameForDel+"\\b";
		mpattern = Pattern.compile(partStr);
		ArrayList nodelinkidList = new ArrayList();
		ArrayList conditionList = new ArrayList();
			
		String strSql = "select * from workflow_nodelink where condition like '%"+fieldnameForDel+"%' and workflowid in (select id from workflow_base where formid="+formid+")";
		weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
		weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
		String docContent = "";
		statement.setStatementSql(strSql, false);
		statement.executeQuery();
		if(statement.next()){
			if(statement.getDBType().equals("oracle"))
			{
				oracle.sql.CLOB theclob = statement.getClob("condition"); 
				String readline = "";
				StringBuffer clobStrBuff = new StringBuffer("");
				java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
				while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				clobin.close() ;
				docContent = clobStrBuff.toString();
			}else{
					docContent=statement.getString("condition");
			}
		
			int nlid = Util.getIntValue(statement.getString("id"));
			nodelinkidList.add(""+nlid);
			conditionList.add(""+docContent);
		}
			
		//调整字段后新的读取方式结束
		for(int cx=0; cx<nodelinkidList.size(); cx++){
		    String nlid = Util.null2String((String)nodelinkidList.get(cx));
		    String condition = Util.null2String((String)conditionList.get(cx));
		    mmatcher = mpattern.matcher(condition);
		    boolean find = mmatcher.find();
		    if(find==true){
		        //RecordSetTrans.execute("update workflow_nodelink set condition='' , conditioncn='' where id="+nlid);
		        String sql = "update workflow_nodelink set condition='' , conditioncn='' where id="+nlid;
		        if(statement.getDBType().equals("oracle"))
		            sql = "update workflow_nodelink set condition=empty_clob() , conditioncn=empty_clob() where id="+nlid;
		              statement.setStatementSql(sql);
		              statement.executeUpdate();
		    }
		}
		//删除与该字段相关的出口条件
		
		//删除节点附加操作
		RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=1 and objid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + delFieldId + " or fieldop1id = " + delFieldId + " or fieldop2id = " + delFieldId + ")" );
		//删除出口附加操作
		RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=0 and objid in (select t1.id from  workflow_nodelink t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + delFieldId + " or fieldop1id = " + delFieldId + " or fieldop2id = " + delFieldId + ")");
		//删除由自定义字段产生的操作人，主要是由浏览框带来的
		RecordSetTrans.executeSql("delete from  workflow_groupdetail where type in(5,6,31,32,7,38,42,43,8,33,9,10,47,34,11,12,13,35,14,15,44,45,46,16) and groupid in(select id from workflow_nodegroup where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ")) and objid=" + delFieldId);
		//删除节点上哪些字段可视、可编辑、必输的信息
		RecordSetTrans.executeSql("delete from  workflow_nodeform where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and fieldid= " + delFieldId);
		//删除特殊字段的信息
		RecordSetTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid =" + delFieldId);
		if(null!=statement){
			statement.close();
		}
  	}
  	
  	ArrayList changeRowIndexsArray = Util.TokenizerString(changeRowIndexs,",");
  	for(int i=0;i<changeRowIndexsArray.size();i++){//修改有改变的行(包括新增行和编辑行)
  		String index = (String)changeRowIndexsArray.get(i);
  		String new_OR_modify = Util.null2String(request.getParameter("modifyflag_"+index));
  		//不为空表示是编辑字段，为空表示新添加字段。
  		if(!new_OR_modify.equals("")){
			//对编辑字段先删除，再添加
			//字段编辑时不允许修改字段数据库名，不需要重新生成id，避免流程中数据丢失。TD10290
			//RecordSetTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+new_OR_modify);//删除表workflow_SelectItem中该字段对应数据
	  		RecordSetTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid="+new_OR_modify);//删除表workflow_specialfield中该字段对应数据	
  		}
  			String fieldname = "";//数据库字段名称
  			int fieldlabel = 0;//字段显示名标签id
  			String fielddbtype = "";//字段数据库类型
			String _fielddbtype = "";//字段数据库类型
  			String fieldhtmltype = "";//字段页面类型
  			String type = "";//字段详细类型
  			String dsporder = "";//显示顺序
  			int selectitem = 0;//公共选择项字段
  			int linkfield = 0;//关联选择项字段
  			String viewtype = "0";//viewtype="0"表示主表字段,viewtype="1"表示明细表字段
  			String detailtable = "";//明细表名
  			int textheight = 0;//多行文本框的高度
  			String textheight_2 = ""; //分权 级别 
  			String locateType = "";  //定位类型：2：自动、1：手动
  			int  qfws=0;
  			int  places=0;
  			
  			
  			String selectItemType = Util.null2String(request.getParameter("selectItemType"+index));
			int pubchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchoiceId"+index)),0);
			int pubchilchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchilchoiceId"+index)),0);
			
			if(selectItemType.equals("0")){
				pubchoiceId = 0;
				pubchilchoiceId = 0;
			}
			if(selectItemType.equals("1")){
				pubchilchoiceId = 0;
			}
			if(selectItemType.equals("2")){
				//pubchoiceId = 0;
			}
  			
  			fieldname = Util.null2String(request.getParameter("itemDspName_"+index));
  			if(fieldname.equals("")) continue;//先添加后删除的
  			int imgwidth = Util.getIntValue(request.getParameter("imgwidth_"+index),0);
            int imgheight = Util.getIntValue(request.getParameter("imgheight_"+index),0);
  			String fieldlabelname = Util.null2String(request.getParameter("itemFieldName_"+index));
  			fieldlabelname = Util.StringReplace(fieldlabelname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
  			fieldlabelname = Util.StringReplace(fieldlabelname, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
  			if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  	else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  	if(RecordSetTrans.next()) fieldlabel = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id
		  	else{
		  		fieldlabel = FormManager.getNewIndexId(RecordSetTrans);//生成新的标签id
			  	if(fieldlabel!=-1){//更新标签库
			  		labelidsCache+=fieldlabel+",";
			  		RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+fieldlabel);
			  		RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+fieldlabel);
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+fieldlabel+",'"+fieldlabelname+"')");
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',7)");
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',8)");
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',9)");
			  	}
			  }
			  
			  fieldhtmltype = Util.null2String(request.getParameter("itemFieldType_"+index));
			  if(!fieldhtmltype.equals("5")){
			  	selectItemType = "0";
			  	pubchilchoiceId=0;
			  	pubchoiceId=0;
			  }
			  
			  if(fieldhtmltype.equals("1")){
				  int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits_"+index),2);
			  	type = Util.null2String(request.getParameter("documentType_"+index));	
				  if(type.equals("1")){
				  	String strlength = Util.null2String(request.getParameter("itemFieldScale1_"+index));
				  	if(Util.getIntValue(strlength,1)<=1) strlength = "1";
			    	if(isoracle) fielddbtype="varchar2("+strlength+")";
			    	else fielddbtype="varchar("+strlength+")";
			    	
			   	}
				 	if(type.equals("2")){
			   		if(isoracle) fielddbtype="integer";
			   		else fielddbtype="int";
			   	}
				 	if(type.equals("3")){
				   		if(isoracle) fielddbtype="number(15,"+decimaldigits+")";
				   		else fielddbtype="decimal(15,"+decimaldigits+")";
			   		
			 	 	}
				 	
				
			   	if(type.equals("4")){
			   		if(isoracle) fielddbtype="number(15,2)";
			   		else fielddbtype="decimal(15,2)";
					}
			   	if(type.equals("5")){
			   		if(isoracle) fielddbtype="varchar2(30)";
			   		else fielddbtype="varchar(30)";
			   			 qfws=decimaldigits;
					}
			    	if(!new_OR_modify.equals("")){
			    	    String oldfielddbtype = "";
			    	    RecordSetTrans.executeSql("select fielddbtype from workflow_billfield where id="+new_OR_modify);
			    	    if(RecordSetTrans.next()) oldfielddbtype = RecordSetTrans.getString("fielddbtype");
			    	    
			    	    if(!fielddbtype.equals(oldfielddbtype)){
			    	        try{
				    	        if(isoracle) RecordSetTrans.executeSql("ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+fielddbtype);
				    	        else RecordSetTrans.executeSql("ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+fielddbtype);
			    	    	}catch(Exception ep){
			    	    		modifyFieldtypeSuccess = false;			    	    		
			    	    		throw ep;
			    	    	}
			    	    }
			    	}
			  }
			  if(fieldhtmltype.equals("2")){
			  	String htmledit = Util.null2String(request.getParameter("htmledit_"+index));
			  	if(htmledit.equals("")) type="1";
			  	else type=htmledit;
				  	if(isoracle) {
						if(!"1".equals(type)) {
							fielddbtype="clob";
						} else {
							fielddbtype="varchar2(4000)";
						}
					} else if(isdb2) {
					    fielddbtype="varchar(2000)";
					} else {
						fielddbtype="text";
					}
					textheight = Util.getIntValue(Util.null2String(request.getParameter("textheight_"+index)),4);
			  }
			  if(fieldhtmltype.equals("3")){
			  	int temptype = Util.getIntValue(Util.null2String(request.getParameter("broswerType_"+index)),0);
			  	type = ""+temptype;
			  	if(temptype>0)
			  		fielddbtype=BrowserComInfo.getBrowserdbtype(type+"");
				  	if(temptype==118){
				  		if(isoracle) fielddbtype="varchar2(200)";
			              else fielddbtype="varchar(200)";
				  	}
					if(temptype==161||temptype==162){
						fielddbtype=Util.null2String(request.getParameter("definebroswerType_"+index));
						if(temptype==161){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
					}
					if(temptype==256||temptype==257){
						fielddbtype=Util.null2String(request.getParameter("defineTreeBroswerType_"+index));
						if(temptype==256){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="varchar(4000)";
						}
					}
					if(temptype==224||temptype==225){
						fielddbtype=Util.null2String(request.getParameter("sapbrowser_"+index));
						if(temptype==224){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
					}
					
					if(temptype==226||temptype==227){
						fielddbtype=Util.null2String(request.getParameter("showvalue_"+index));
						if(temptype==226){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
					}
					if(temptype==17){
				  		if(isoracle) {
				  			fielddbtype="clob";
				  			_fielddbtype="clob";
				  		}else if(isdb2){
				  			_fielddbtype="varchar(2000)";
				  		}
						else {
							fielddbtype="text";
							_fielddbtype="text";
						}
				  	}
					
					
				  if(temptype==165||temptype==166||temptype==167||temptype==168) 
				  	//textheight=Util.getIntValue(Util.null2String(request.getParameter("decentralizationbroswerType_"+index)),0);
				  	textheight_2 = Util.null2String(request.getParameter("decentralizationbroswerType_"+index)); 
			  }
			  if(fieldhtmltype.equals("4")){
			  	type = "1";
			  	fielddbtype="char(1)";
			  }
			  if(fieldhtmltype.equals("5"))	{
			  	type = "1";
			  	if(isoracle) fielddbtype="integer";
			  	else fielddbtype="int";
			  }
			  if(fieldhtmltype.equals("6"))	{
			  	type = "" + Util.getIntValue(Util.null2String(request.getParameter("uploadtype_"+index)), 1);
			    if(isoracle) fielddbtype="varchar2(4000)";
				  else if(isdb2) fielddbtype="varchar(2000)";
			    else fielddbtype="text";
                textheight = Util.getIntValue(Util.null2String(request.getParameter("strlength_"+index)), 0);  
			  }
			  if(fieldhtmltype.equals("7"))	{
			  	type = Util.null2String(request.getParameter("specialfield_"+index));
			    if(isoracle) fielddbtype="varchar2(4000)";
				  else if(isdb2) fielddbtype="varchar(2000)";
			    else fielddbtype="text";
			  }
			  if(fieldhtmltype.equals("8"))	{
				  selectitem = Util.getIntValue(Util.null2String(request.getParameter("selectType_"+index)),0);
				  linkfield = Util.getIntValue(Util.null2String(request.getParameter("childCommonItem_"+index)),0);
				  type = "1";
				  if(isoracle) fielddbtype="integer";
				  else fielddbtype="int";
			  }
			  if(fieldhtmltype.equals("9")){
			      locateType = Util.null2String(request.getParameter("locateType_"+index)); //定位方式：手动或自动
				  type = Util.null2String(request.getParameter("locationType_"+index));	//类型：位置				  
				  if(isoracle) fielddbtype = "clob";
				  else fielddbtype = "text"; 

			  }
			  dsporder = Util.null2String(request.getParameter("itemDspOrder_"+index));
			  //if(dsporder.equals("")) dsporder="0";
			  dsporder = ""+Util.getFloatValue(dsporder,0);
			  int childfieldid_tmp = Util.getIntValue(request.getParameter("childfieldid_"+index), 0);
			  if(!new_OR_modify.equals("")){//不为空表示是编辑字段，为空表示新添加字段。
			  	String oldfieldname = "";
			  	String oldfielddbtype = "";
			  	String oldtype = "";
			  	RecordSetTrans.executeSql("select fieldname,fielddbtype,type from workflow_billfield where id="+new_OR_modify);
			  	if(RecordSetTrans.next()){
			  	    oldfieldname = RecordSetTrans.getString("fieldname");
			  	    oldfielddbtype = RecordSetTrans.getString("fielddbtype");
			  	  	oldtype = RecordSetTrans.getString("type");
			  	}
			  	RecordSetTrans.executeSql("update workflow_billfield set billid="+formid+",fieldname='"+fieldname+"',fieldlabel="+fieldlabel+",fielddbtype='"+fielddbtype+"',fieldhtmltype="+fieldhtmltype+",type="+type+",dsporder="+dsporder+",viewtype="+viewtype+",detailtable='"+detailtable+"',textheight="+textheight+",textheight_2='"+textheight_2+"',imgwidth="+imgwidth+",imgheight="+imgheight+" ,places="+places+" ,qfws="+qfws+",selectitem='"+selectitem+"',linkfield='"+linkfield+"',selectItemType='"+selectItemType+"',pubchoiceId="+pubchoiceId+",pubchilchoiceId="+pubchilchoiceId+",locatetype='"+ locateType +"' where id="+new_OR_modify);
			  	if(!fieldname.equals(oldfieldname)||(!fielddbtype.equals(oldfielddbtype) && !"1".equals(fieldhtmltype) && !"".equals(type))){//修改了数据库字段名称或类型
			  	    RecordSetTrans.executeSql("select "+oldfieldname+" from "+maintablename);
			  	    if(!RecordSetTrans.next()){
			  	    	RecordSetTrans.executeSql("alter table "+maintablename+" drop column "+oldfieldname);
			  	    	if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
			  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
				  	    }else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
			  	        	RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
				  	    }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
				  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
				  	    }else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
				  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
				  	    }
				  	    else{
				  	        RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+fielddbtype);
				  	    }
			  	    }else{	//物理表中有数据时
			  	    	if(!fieldname.equals(oldfieldname)){	//修改的是数据库字段名称
			  	    		if(issqlserver){
			  	    			//("调试打印2:" + "EXEC sp_rename '"+maintablename+".["+oldfieldname+"]','"+fieldname+"','COLUMN'");
			  	    			RecordSetTrans.executeSql("EXEC sp_rename '"+maintablename+".["+oldfieldname+"]','"+fieldname+"','COLUMN'");
			  	    		}else if(isoracle){
			  	    			RecordSetTrans.executeSql("alter table "+maintablename+" rename column "+oldfieldname+" to "+fieldname);
			  	    		}
			  	    	}
			  	    	if((!fielddbtype.equals(oldfielddbtype) && !"1".equals(fieldhtmltype) && !"".equals(type))){ //修改的是数据库字段类型
			  	    		String modifyFieldTypeSQL = "";
			  	    		if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
			  	    			if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+_fielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+_fielddbtype;
				    	        }
							}else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
			  	    			if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+_fielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+_fielddbtype;
				    	        }
							}else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
								if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+_fielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+_fielddbtype;
				    	        }
						  	}else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
						  		if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+_fielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+_fielddbtype;
				    	        }
						  	}else{
						  		if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+fielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+fielddbtype;
				    	        }
						  	}
			  	    		try{
			  	    			RecordSetTrans.executeSql(modifyFieldTypeSQL);	
			  	    		}catch(Exception ep){
			  	    			modifyFieldtypeSuccess = false;
			  	    			throw ep;
			  	    		}
					  	}
			  	    }
			  	}else if(fieldhtmltype.equals("3")&&type.equals("257")&&oldtype.equals("256")){//从树形单选改到多选
			  		String modifyFieldTypeSQL = "";
  	    			if(isoracle){
  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" MODIFY "+fieldname+" "+_fielddbtype;
  	    			}else if(issqlserver){
  	    				modifyFieldTypeSQL = "ALTER TABLE "+maintablename+" ALTER COLUMN "+fieldname+" "+_fielddbtype;
	    	        }
  	    			
  	    			try{
	  	    			RecordSetTrans.executeSql(modifyFieldTypeSQL);	
	  	    		}catch(Exception ep){
	  	    			modifyFieldtypeSuccess = false;
	  	    			throw ep;
	  	    		}
	  	    		
				}
				}else{
				  //插入字段信息
				  RecordSetTrans.executeSql("INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight,places,qfws,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,locatetype) "+
				  " VALUES ("+formid+",'"+fieldname+"',"+fieldlabel+",'"+fielddbtype+"',"+fieldhtmltype+","+type+","+dsporder+","+viewtype+",'"+detailtable+"',"+textheight+",'"+textheight_2+"',"+childfieldid_tmp+","+imgwidth+","+imgheight+","+places+","+qfws+",'"+selectitem+"','"+linkfield+"','"+selectItemType+"',"+pubchoiceId+","+pubchilchoiceId+",'"+locateType+"')");
			  }
			  if(new_OR_modify.equals("")){//新添加字段
			  //更新主表结构
			  if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
			  	  RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
			  }else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
			  	  RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
			  }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
			  	  RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
			  }else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
			  	  RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+_fielddbtype);
			  }
			  else{
			  	  RecordSetTrans.executeSql("alter table "+maintablename+" add "+fieldname+" "+fielddbtype);
			  }
			  }
			  
			  
			  //如果是选择框，更新表workflow_SelectItem
			  String curfieldid = "";
			  if(new_OR_modify.equals("")){
			      RecordSetTrans.executeSql("select max(id) as id from workflow_billfield");
			      if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
			  }else{
			      curfieldid = new_OR_modify;
			  }
			  
			  if(jumpRowindex.equals(index)){
			      jumpfieldid = Util.getIntValue(curfieldid);
			  }
			  
			  if(fieldhtmltype.equals("5")){
			    
			    if(selectItemType.equals("0") && false){//不执行
			    	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("choiceRows_"+index)));
	                int curvalue=0;
				  	for(int temprow=1;temprow<=rowsum;temprow++){
				  		String curname = Util.null2String(request.getParameter("field_"+index+"_"+temprow+"_name"));
				  		if(curname.equals("")) continue;
				  		String curorder = Util.null2String(request.getParameter("field_count_"+index+"_"+temprow+"_name"));
				  		String isdefault = "n";
				  		String checkValue = Util.null2String(request.getParameter("field_checked_"+index+"_"+temprow+"_name"));
				  		String cancel = Util.null2String(request.getParameter("cancel_"+index+"_"+temprow+"_name")); 
				  		if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
							cancel = "1";
						}else{
							cancel = "0";
						}
						if(checkValue.equals("1")) isdefault="y";
				  			int isAccordToSubCom_tmp = Util.getIntValue(request.getParameter("isAccordToSubCom"+index+"_"+temprow), 0);
							String doccatalog = Util.null2String(request.getParameter("maincategory_"+index+"_"+temprow));
							String docPath = Util.null2String(request.getParameter("pathcategory_"+index+"_"+temprow));
							String childItem_tmp = Util.null2String(request.getParameter("childItem_"+index+"_"+temprow));
							if(childfieldid_tmp==0)childItem_tmp="";
							String para=curfieldid+flag+"1"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault+flag+cancel; 
							RecordSetTrans.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
							RecordSetTrans.executeSql("update workflow_SelectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"',childitemid='"+childItem_tmp+"',isAccordToSubCom='"+isAccordToSubCom_tmp+"' where fieldid="+curfieldid+" and selectvalue="+curvalue);
	                        curvalue++;
				  	}
			    }else if (selectItemType.equals("1")){
			    	field_pubchoice_map.put(curfieldid,""+pubchoiceId);
			    }else if (selectItemType.equals("2")){
			    	field_pubchilchoice_map.put(curfieldid,""+pubchilchoiceId);
			    }
			    
			  	
			  }
			  if(fieldhtmltype.equals("7")){              
	               String displayname = Util.null2String(request.getParameter("displayname_"+index));//显示名
	               String linkaddress = Util.null2String(request.getParameter("linkaddress_"+index));//链接地址
	               String descriptivetext = Util.null2String(request.getParameter("descriptivetext_"+index));//描述性文字
	               descriptivetext = Util.spacetoHtml(descriptivetext);	
	               descriptivetext = Util.htmlFilter4UTF8(descriptivetext);
		  	       String specialfield = Util.null2String(request.getParameter("specialfield_"+index));//类型
		  	       //String sql = "select max(id) from workflow_billfield";
			       //RecordSetTrans.executeSql(sql);
			       //RecordSetTrans.next();
			       //String curfieldid=RecordSetTrans.getString(1);
			       //if(!new_OR_modify.equals("")) curfieldid = new_OR_modify;
		           String sql = "";
		           if(specialfield.equals("1")){
		              sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+curfieldid+",'"+displayname+"','"+linkaddress+"',0,1)";    
		           }else{
		              sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+curfieldid+",'"+descriptivetext+"',0,1)";    
		           }
			       RecordSetTrans.executeSql(sql);
			  }
			  
			  if(new_OR_modify.equals("")){//新建字段插入到节点
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
			  	}//if(wf_nf_count<1){
			  }
			  
  	}
  	//主字段 结束
  	
  	//明细字段 开始
  	int detailtables = Util.getIntValue((request.getParameter("detailtables")),0);//明细数量
  	String detailtableIndexs = Util.null2String(request.getParameter("detailtableIndexs"));//明细表序号集
  	ArrayList detailtableIndexsArray = Util.TokenizerString(detailtableIndexs,",");
  	
  	for(int tempi=0;tempi<detailtables;tempi++){
  		int i = Util.getIntValue((String)detailtableIndexsArray.get(tempi),0);
  		boolean isexist = false;
			String detailtable = Util.null2String(request.getParameter("detailtablename_db_"+i));	//明细表名称
			String newsapmultiBrowservalue= Util.null2String(request.getParameter("newsapmultiBrowservalue_"+i));
			RecordSetTrans.executeSql("select * from Workflow_billdetailtable where billid="+formid+" and tablename='"+detailtable+"'");
			if(RecordSetTrans.next()) isexist=true;//明细表已存在
			
			String dbtype = RecordSet.getDBType();
			String sql = "";
			if (dbtype.equalsIgnoreCase("oracle")) {
			    sql = "select 1 from user_tables where TABLE_NAME = upper('" + detailtable + "')";
			} else if (dbtype.toLowerCase().indexOf("sqlserver")>-1||dbtype.equalsIgnoreCase("sybase")) {
			    sql = "select 1 from sysobjects where name = '" + detailtable + "' ";
			} else if (dbtype.equalsIgnoreCase("informix")) {
			    sql = "select 1 from systables where lower(tabname) = lower('" + detailtable + "') ";
			} else if (dbtype.equalsIgnoreCase("mysql")) {
			    sql = "select 1 from information_schema.Tables where LOWER(Table_Name)=LOWER('" + detailtable + "') ";
			} else if (dbtype.equalsIgnoreCase("db2")) {
			    sql = "select 1 from SYSIBM.SYSTABLES where lower(name)= lower('" + detailtable + "') ";
			}else{
			    sql="select 1 from "+detailtable;
			}
			RecordSetTrans.executeSql(sql);
			if(RecordSetTrans.next()) isexist=true;//明细表已存在
			
			if(!isexist){//明细表不存在，则新建明细表
	  		if(isoracle){
		  		RecordSetTrans.executeSql("create table " + detailtable + "(id integer primary key not null,mainid integer)");
		  	}else{
		  		RecordSetTrans.executeSql("create table " + detailtable + "(id int IDENTITY(1,1) primary key CLUSTERED,mainid int)");
		 		}
		 		//插入表单明细表信息workflow_billdetailtable
		 		RecordSetTrans.executeSql("INSERT INTO workflow_billdetailtable(billid,tablename,orderid) values("+formid+",'"+detailtable+"',"+i+")");
	 		}
		//明细表的名字--detailtable
		//明细表的formid  
			  
		
	  	String detaildelids = Util.null2String(request.getParameter("detaildelids_"+i));//删除行id集
	  	String detailChangeRowIndexs = Util.null2String(request.getParameter("detailChangeRowIndexs_"+i));//有改变的行id集
	  	
	  	ArrayList detaildelidsArray = Util.TokenizerString(detaildelids,",");
	  	for(int j=0;j<detaildelidsArray.size();j++){//删除指定的字段
	  		String fieldnameForDel = "";
	  		String delFieldId = (String)detaildelidsArray.get(j);

				//如果字段被行列规则引用，则退出。
				RecordSetTrans.executeSql("select * from workflow_formdetailinfo where rowcalstr like '%!_"+delFieldId+"_%' escape '!' or rowcalstr like '%!_"+delFieldId+"' escape '!' or colcalstr like '%!_"+delFieldId+"_%' escape '!' or colcalstr like '%!_"+delFieldId+"' escape '!' or maincalstr like '%!_"+delFieldId+"_%' escape '!' or maincalstr like '%!_"+delFieldId+"' escape '!'");
				if(RecordSetTrans.next()){
				    RecordSetTrans.rollback();
				    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodelete");
				    return;
				}

               if(WorkflowSubwfFieldManager.hasSubWfSetting(RecordSetTrans,Util.getIntValue(delFieldId,0),1)){
			        RecordSetTrans.rollback();
			        response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodeleteForSubWf");
			        return;
			    }

	  		RecordSetTrans.executeSql("select fieldname from workflow_billfield where id="+delFieldId);
	  		if(RecordSetTrans.next()) fieldnameForDel = RecordSetTrans.getString("fieldname");//取得字段名
	  		RecordSetTrans.executeSql("delete from workflow_billfield where id="+delFieldId);//删除字段
	  		RecordSetTrans.executeSql("alter table "+detailtable+" drop column "+fieldnameForDel);//修改表结构
	  		RecordSetTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+delFieldId);//删除表workflow_SelectItem中该字段对应数据
	  		RecordSetTrans.execute("update workflow_billfield set childfieldid=0 where childfieldid="+delFieldId);//如果被删除字段是子字段，则需要修改
				//删除节点附加操作
				RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=1 and objid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + delFieldId + " or fieldop1id = " + delFieldId + " or fieldop2id = " + delFieldId + ")" );
				//删除出口附加操作
				RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=0 and objid in (select t1.id from  workflow_nodelink t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + delFieldId + " or fieldop1id = " + delFieldId + " or fieldop2id = " + delFieldId + ")");
				//删除由自定义字段产生的操作人，主要是由浏览框带来的
				RecordSetTrans.executeSql("delete from  workflow_groupdetail where type in(5,6,31,32,7,38,42,43,8,33,9,10,47,34,11,12,13,35,14,15,44,45,46,16) and groupid in(select id from workflow_nodegroup where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ")) and objid=" + delFieldId);
				//删除节点上哪些字段可视、可编辑、必输的信息
				RecordSetTrans.executeSql("delete from  workflow_nodeform where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and fieldid= " + delFieldId);
				//删除特殊字段的信息
				RecordSetTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid =" + delFieldId);

					  		
	  	}
	  	
	  	ArrayList detailChangeRowIndexsArray = Util.TokenizerString(detailChangeRowIndexs,",");
	  	for(int j=0;j<detailChangeRowIndexsArray.size();j++){//修改有改变的行(包括新增行和编辑行)
	  		String temprowindex = (String)detailChangeRowIndexsArray.get(j);

	  		String new_OR_modify = Util.null2String(request.getParameter("modifyflag_"+i+"_"+temprowindex));
	  		if(!new_OR_modify.equals("")){//不为空表示是编辑字段，为空表示新添加字段。
	  			//对编辑字段先删除，再添加
	  			
	  			//字段编辑时不允许修改字段数据库名，不需要重新生成id，避免流程中数据丢失。TD10290
	  			//String fieldnameForDrop = "";
	  			//RecordSetTrans.executeSql("select fieldname from workflow_billfield where id="+new_OR_modify);
	  			//if(RecordSetTrans.next()) fieldnameForDrop = RecordSetTrans.getString("fieldname");//取得字段名
	  			//RecordSetTrans.executeSql("delete from workflow_billfield where id="+new_OR_modify);//删除字段
	  			//RecordSetTrans.executeSql("alter table "+detailtable+" drop column "+fieldnameForDrop);//修改表结构

	  			//字段编辑时不允许修改字段数据库名，不需要重新生成id，避免流程中数据丢失。TD10290
	  			
				 // RecordSetTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+new_OR_modify);//删除表workflow_SelectItem中该字段对应数据
	  		}
	  		
	  		String detailfieldname = "";//数据库字段名称
  			int detailfieldlabel = 0;//字段显示名标签id
  			String detailfielddbtype = "";//字段数据库类型
  			String _detailfielddbtype = "";//字段数据库类型
  			String detailfieldhtmltype = "";//字段页面类型
  			String detailtype = "";//字段详细类型
  			String detaildsporder = "";//显示顺序
  			String viewtype = "1";//viewtype="0"表示主表字段,viewtype="1"表示明细表字段
  			//String detailtable = "";//明细表名
  			int detailtextheight = 0;//多行文本框的高度
  			String detailtextheight_2 = "";//分权级别
  			int detailplaces = 0;//多行文本框的高度
  			int qfws = 0;
  			int detailselectitem = 0;
  			int detaillinkfield = 0;
  			detailfieldname = Util.null2String(request.getParameter("itemDspName_detail"+i+"_"+temprowindex));
  			detailfieldname = Util.StringReplace(detailfieldname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
  			detailfieldname = Util.StringReplace(detailfieldname, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
  			if(detailfieldname.equals("")) continue;//先添加后删除的
  			
  			int detailimgwidth = Util.getIntValue(request.getParameter("imgwidth_"+i+"_"+temprowindex),0);
            int detailimgheight = Util.getIntValue(request.getParameter("imgheight_"+i+"_"+temprowindex),0);
            
            String detailselectItemType = Util.null2String(request.getParameter("selectItemType"+i+"_"+temprowindex));
			int detailpubchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchoiceId"+i+"_"+temprowindex)),0);
			int detailpubchilchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchilchoiceId"+i+"_"+temprowindex)),0);
			if(detailselectItemType.equals("0")){
				detailpubchoiceId = 0;
				detailpubchilchoiceId = 0;
			}
			if(detailselectItemType.equals("1")){
				detailpubchilchoiceId = 0;
			}
			if(detailselectItemType.equals("2")){
				detailpubchoiceId = 0;
			}
			
  			String detailfieldlabelname = Util.null2String(request.getParameter("itemFieldName_detail"+i+"_"+temprowindex));
  			detailfieldlabelname = Util.StringReplace(detailfieldlabelname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
  			detailfieldlabelname = Util.StringReplace(detailfieldlabelname, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
  			if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+detailfieldlabelname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  	else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+detailfieldlabelname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  	if(RecordSetTrans.next()) detailfieldlabel = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id
		  	else{
		  		detailfieldlabel = FormManager.getNewIndexId(RecordSetTrans);//生成新的标签id
			  	if(detailfieldlabel!=-1){//更新标签库
			  		labelidsCache+=detailfieldlabel+",";
			  		RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+detailfieldlabel);
			  		RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+detailfieldlabel);
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+detailfieldlabel+",'"+detailfieldlabelname+"')");
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+detailfieldlabel+",'"+detailfieldlabelname+"',7)");
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+detailfieldlabel+",'"+detailfieldlabelname+"',8)");
			  		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+detailfieldlabel+",'"+detailfieldlabelname+"',9)");
			  	}
			  }
  			
			  detailfieldhtmltype = Util.null2String(request.getParameter("itemFieldType_"+i+"_"+temprowindex));
			  if(!detailfieldhtmltype.equals("5")){
			  	detailselectItemType = "0";
			  	detailpubchoiceId=0;
			  	detailpubchilchoiceId=0;
			  }
			  if(detailfieldhtmltype.equals("1")){
			  	detailtype = Util.null2String(request.getParameter("documentType_"+i+"_"+temprowindex));
			  	int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits_"+i+"_"+temprowindex),2);
				  if(detailtype.equals("1")){
				  	String strlength = Util.null2String(request.getParameter("itemFieldScale1_"+i+"_"+temprowindex));
				  	if(Util.getIntValue(strlength,1)<=1) strlength = "1";
			    	if(isoracle) detailfielddbtype="varchar2("+strlength+")";
			    	else detailfielddbtype="varchar("+strlength+")";
			    	
			   	}
				 	if(detailtype.equals("2")){
			   		if(isoracle) detailfielddbtype="integer";
			   		else detailfielddbtype="int";
			   	}
				 	if(detailtype.equals("3")){
				   		if(isoracle) detailfielddbtype="number(15,"+decimaldigits+")";
				   		else detailfielddbtype="decimal(15,"+decimaldigits+")";
				   		qfws=decimaldigits;
			 	 	}
			   	if(detailtype.equals("4")){
			   		if(isoracle) detailfielddbtype="number(15,2)";
			   		else detailfielddbtype="decimal(15,2)";
					}
			   	if(detailtype.equals("5")){
			   		if(isoracle) detailfielddbtype="varchar2(30)";
			   		else detailfielddbtype="varchar(30)";
			   		 qfws=decimaldigits;
					}
			    	if(!new_OR_modify.equals("")){
			    	    String olddetailfielddbtype = "";
			    	    RecordSetTrans.executeSql("select fielddbtype from workflow_billfield where id="+new_OR_modify);
			    	    if(RecordSetTrans.next()) olddetailfielddbtype = RecordSetTrans.getString("fielddbtype");
			    	    
			    	    if(!detailfielddbtype.equals(olddetailfielddbtype)){
			    	        try{
				    	        if(isoracle) RecordSetTrans.executeSql("ALTER TABLE "+detailtable+" MODIFY "+detailfieldname+" "+detailfielddbtype);
				    	        else RecordSetTrans.executeSql("ALTER TABLE "+detailtable+" ALTER COLUMN "+detailfieldname+" "+detailfielddbtype);
			    	    	}catch(Exception ep){
			  	    			modifyFieldtypeSuccess = false;
			  	    			throw ep;
			  	    		}
			    	    }
			    	}
			  }
			  if(detailfieldhtmltype.equals("2")){
			  	detailtype = "1";
			  	String htmledit = Util.null2String(request.getParameter("htmledit_"+i+"_"+temprowindex));
					if(isoracle) detailfielddbtype="varchar2(4000)";
					else if(isdb2) detailfielddbtype="varchar(2000)";
					else detailfielddbtype="text";
					if(!htmledit.equals("")) detailtype=htmledit;
					detailtextheight = Util.getIntValue(Util.null2String(request.getParameter("textheight_"+i+"_"+temprowindex)),0);
			  }
			  if(detailfieldhtmltype.equals("3")){
			  	int temptype = Util.getIntValue(Util.null2String(request.getParameter("broswerType_"+i+"_"+temprowindex)),0);
			  	detailtype = ""+temptype;
			  	
			  	if(temptype>0)
			  		detailfielddbtype=BrowserComInfo.getBrowserdbtype(detailtype+"");
				  	if(temptype==118){
				  		if(isoracle) detailfielddbtype="varchar2(200)";
			              else detailfielddbtype="varchar(200)";
				  	}
					if(temptype==161||temptype==162){
						detailfielddbtype=Util.null2String(request.getParameter("definebroswerType_"+i+"_"+temprowindex));
						if(temptype==161){
							if(isoracle) _detailfielddbtype="varchar2(1000)";
							else if(isdb2) _detailfielddbtype="varchar(1000)";
							else _detailfielddbtype="varchar(1000)";
						}else{
							if(isoracle) _detailfielddbtype="varchar2(4000)";
							else if(isdb2) _detailfielddbtype="varchar(2000)";
							else _detailfielddbtype="text";
						}
					}	
					
					if(temptype==256||temptype==257){
						detailfielddbtype=Util.null2String(request.getParameter("defineTreeBroswerType_"+i+"_"+temprowindex));
						if(temptype==256){
							if(isoracle) _detailfielddbtype="varchar2(1000)";
							else if(isdb2) _detailfielddbtype="varchar(1000)";
							else _detailfielddbtype="varchar(1000)";
						}else{
							if(isoracle) _detailfielddbtype="varchar2(4000)";
							else if(isdb2) _detailfielddbtype="varchar(2000)";
							else _detailfielddbtype="varchar(4000)";
						}
					}	
					
					if(temptype==224||temptype==225){
						detailfielddbtype=Util.null2String(request.getParameter("sapbrowser_"+i+"_"+temprowindex));
						if(temptype==224){
							if(isoracle) _detailfielddbtype="varchar2(1000)";
							else if(isdb2) _detailfielddbtype="varchar(1000)";
							else _detailfielddbtype="varchar(1000)";
						}else{
							if(isoracle) _detailfielddbtype="varchar2(4000)";
							else if(isdb2) _detailfielddbtype="varchar(2000)";
							else _detailfielddbtype="text";
						}
					}
					
					if(temptype==226||temptype==227){
						detailfielddbtype=Util.null2String(request.getParameter("showvalue_"+i+"_"+temprowindex));
						if(temptype==226){
							if(isoracle) _detailfielddbtype="varchar2(1000)";
							else if(isdb2) _detailfielddbtype="varchar(1000)";
							else _detailfielddbtype="varchar(1000)";
						}else{
							if(isoracle) _detailfielddbtype="varchar2(4000)";
							else if(isdb2) _detailfielddbtype="varchar(2000)";
							else _detailfielddbtype="text";
						}
					}
					if(temptype==17){
				  		if(isoracle) {
				  			detailfielddbtype="clob";
				  			_detailfielddbtype="clob";
				  		}else if(isdb2){
				  			_detailfielddbtype="varchar(2000)";
				  		}
						else {
							detailfielddbtype="text";
							_detailfielddbtype="text";
						}
				  	}
				  if(temptype==165||temptype==166||temptype==167||temptype==168) 
				  	//detailtextheight=Util.getIntValue(Util.null2String(request.getParameter("decentralizationbroswerType_"+i+"_"+temprowindex)),0);
				  	detailtextheight_2=Util.null2String(request.getParameter("decentralizationbroswerType_"+i+"_"+temprowindex)); 
			  }
			  if(detailfieldhtmltype.equals("4")){
			  	detailtype = "1";
			  	detailfielddbtype="char(1)";
			  }
			  if(detailfieldhtmltype.equals("5"))	{
			  	detailtype = "1";
			  	if(isoracle) detailfielddbtype="integer";
			  	else detailfielddbtype="int";
			  }
			  if(detailfieldhtmltype.equals("6"))	{
			  	detailtype = "" + Util.getIntValue(Util.null2String(request.getParameter("uploadtype_"+i+"_"+temprowindex)), 1);
			    if(isoracle) detailfielddbtype="varchar2(4000)";
				  else if(isdb2) detailfielddbtype="varchar(2000)";
			    else detailfielddbtype="text";
			    detailtextheight = Util.getIntValue(Util.null2String(request.getParameter("strlength_"+i+"_"+temprowindex)), 0);  
			  }
			  if(detailfieldhtmltype.equals("8")){
				  detailselectitem = Util.getIntValue(Util.null2String(request.getParameter("selectType_"+i+"_"+temprowindex)),0);
				  detaillinkfield = Util.getIntValue(Util.null2String(request.getParameter("childCommonItem_"+i+"_"+temprowindex)),0);
				  detailtype = "1";
				  if(isoracle) detailfielddbtype="integer";
				  	else detailfielddbtype="int";
			  }
  			
			  detaildsporder = Util.null2String(request.getParameter("itemDspOrder_detail"+i+"_"+temprowindex));
			  detaildsporder = ""+Util.getFloatValue(detaildsporder,0);
			  int childfieldid_tmp = Util.getIntValue(request.getParameter("childfieldid_detail"+i+"_"+temprowindex), 0);
			  if(!new_OR_modify.equals("")){//不为空表示是编辑字段，为空表示新添加字段。
			  	String olddetailfieldname = "";
			  	String olddetailfielddbtype = "";
			  	RecordSetTrans.executeSql("select fieldname,fielddbtype from workflow_billfield where id="+new_OR_modify);
			  	if(RecordSetTrans.next()){
			  	    olddetailfieldname = RecordSetTrans.getString("fieldname");
			  	    olddetailfielddbtype = RecordSetTrans.getString("fielddbtype");
			  	}
			  	RecordSetTrans.executeSql("update workflow_billfield set billid="+formid+",fieldname='"+detailfieldname+"',fieldlabel="+detailfieldlabel+",fielddbtype='"+detailfielddbtype+"',fieldhtmltype="+detailfieldhtmltype+",type="+detailtype+",dsporder="+detaildsporder+",viewtype="+viewtype+",detailtable='"+detailtable+"',textheight="+detailtextheight+",textheight_2='"+detailtextheight_2+"',imgwidth="+detailimgwidth+",imgheight="+detailimgheight+",places="+detailplaces+" ,qfws="+qfws+",selectitem='"+detailselectitem+"',linkfield='"+detaillinkfield+"',selectItemType='"+detailselectItemType+"',pubchoiceId="+detailpubchoiceId+",pubchilchoiceId="+detailpubchilchoiceId+" where id="+new_OR_modify);
			  	if(!detailfieldname.equals(olddetailfieldname) || (!detailfielddbtype.equals(olddetailfielddbtype) && !"1".equals(detailfieldhtmltype) && !"".equals(detailtype))){//修改了数据库字段名称或类型
			  	    RecordSetTrans.executeSql("select "+olddetailfieldname+" from "+detailtable);
			  	    if(!RecordSetTrans.next()){
				  	    RecordSetTrans.executeSql("alter table "+detailtable+" drop column "+olddetailfieldname);
				  	    if(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))){
				  	        RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
				  	    }else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("256")||detailtype.equals("257"))){
				  	        RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
				  	    }else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("224")||detailtype.equals("225"))){
				  	        RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
				  	    }else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("226")||detailtype.equals("227"))){
				  	        RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
				  	    }
				  	    else{
				  	        RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+detailfielddbtype);
				  	    }
				  	 }else{ //物理表中有数据时
			  	    	if(!detailfieldname.equals(olddetailfieldname)){	//修改的是数据库字段名称
			  	    		if(issqlserver){
			  	    			RecordSetTrans.executeSql("EXEC sp_rename '"+detailtable+".["+olddetailfieldname+"]','"+detailfieldname+"','COLUMN'");
			  	    		}else if(isoracle){
			  	    			RecordSetTrans.executeSql("alter table "+detailtable+" rename column "+olddetailfieldname+" to "+detailfieldname);
			  	    		}
			  	    	}
			  	    	
			  	    	if((!detailfielddbtype.equals(olddetailfielddbtype) && !"1".equals(detailfieldhtmltype) && !"".equals(detailtype))){ //修改的是数据库字段类型
			  	    		String modifyFieldTypeSQL = "";
			  	    		if(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))){
			  	    			if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" MODIFY "+detailfieldname+" "+_detailfielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" ALTER COLUMN "+detailfieldname+" "+_detailfielddbtype;
				    	        }
			  	    		}else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("256")||detailtype.equals("257"))){
			  	    			if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" MODIFY "+detailfieldname+" "+_detailfielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" ALTER COLUMN "+detailfieldname+" "+_detailfielddbtype;
				    	        }
			  	    		}else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("224")||detailtype.equals("225"))){
			  	    			if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" MODIFY "+detailfieldname+" "+_detailfielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" ALTER COLUMN "+detailfieldname+" "+_detailfielddbtype;
				    	        }
			  	    		}else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("226")||detailtype.equals("227"))){
			  	    			if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" MODIFY "+detailfieldname+" "+_detailfielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" ALTER COLUMN "+detailfieldname+" "+_detailfielddbtype;
				    	        }
						  	}else{
						  		if(isoracle){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" MODIFY "+detailfieldname+" "+detailfielddbtype;
			  	    			}else if(issqlserver){
			  	    				modifyFieldTypeSQL = "ALTER TABLE "+detailtable+" ALTER COLUMN "+detailfieldname+" "+detailfielddbtype;
				    	        }
						  	}
			  	    		try{
			  	    			RecordSetTrans.executeSql(modifyFieldTypeSQL);	
			  	    		}catch(Exception ep){
			  	    			modifyFieldtypeSuccess = false;
			  	    			throw ep;
			  	    		}
					  	}
			  	    }
			  	}
				}else{
			  	//插入字段信息
			  	RecordSetTrans.executeSql("INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight,places,qfws,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId) "+
			  	" VALUES ("+formid+",'"+detailfieldname+"',"+detailfieldlabel+",'"+detailfielddbtype+"',"+detailfieldhtmltype+","+detailtype+","+detaildsporder+","+viewtype+",'"+detailtable+"',"+detailtextheight+",'"+detailtextheight_2+"',"+childfieldid_tmp+","+detailimgwidth+","+detailimgheight+","+detailplaces+","+qfws+",'"+detailselectitem+"','"+detaillinkfield+"','"+detailselectItemType+"',"+detailpubchoiceId+","+detailpubchilchoiceId+")");
			  }
			  if(new_OR_modify.equals("")){//新添加字段
			  //更新明细表结构
			  if(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))){
			  	  RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
			  }else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("256")||detailtype.equals("257"))){
			  	  RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
			  }else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("224")||detailtype.equals("225"))){
			  	  RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
			  }else if(detailfieldhtmltype.equals("3")&&(detailtype.equals("226")||detailtype.equals("227"))){
			  	  RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+_detailfielddbtype);
			  }
			  else{
			  	  RecordSetTrans.executeSql("alter table "+detailtable+" add "+detailfieldname+" "+detailfielddbtype);
			  } 
			  }
			  
			  //如果是选择框，更新表workflow_SelectItem
			  String curfieldid = "";
			  if(new_OR_modify.equals("")){
			      RecordSetTrans.executeSql("select max(id) as id from workflow_billfield");
			      if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
			  }else{
			      curfieldid = new_OR_modify;
			  }
			  
			  if(jumpRowindex.equals(i+"_"+temprowindex)){
			      jumpfieldid = Util.getIntValue(curfieldid);
			  }
			  
			  if(detailfieldhtmltype.equals("5")){
			  	
			  	if(detailselectItemType.equals("0") && false){ //不执行
			    	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("choiceRows_"+i+"_"+temprowindex)));
	                int curvalue=0;
				  	for(int temprow=1;temprow<=rowsum;temprow++){
				  		String curname = Util.null2String(request.getParameter("field_"+i+"_"+temprowindex+"_"+temprow+"_name"));
				  		if(curname.equals("")) continue;
				  		String curorder = Util.null2String(request.getParameter("field_count_"+i+"_"+temprowindex+"_"+temprow+"_name"));
				  		String isdefault = "n";
				  		String checkValue = Util.null2String(request.getParameter("field_checked_"+i+"_"+temprowindex+"_"+temprow+"_name"));
				  		String cancel = Util.null2String(request.getParameter("cancel_"+i+"_"+temprowindex+"_"+temprow+"_name"));
				  		if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
							cancel = "1";
						}else{
							cancel = "0";
						}
						if(checkValue.equals("1")) isdefault="y";
				  		int isAccordToSubCom_tmp = Util.getIntValue(request.getParameter("isAccordToSubCom"+i+"_"+temprowindex+"_"+temprow), 0);
							String doccatalog = Util.null2String(request.getParameter("maincategory_"+i+"_"+temprowindex+"_"+temprow));
							String docPath = Util.null2String(request.getParameter("pathcategory_"+i+"_"+temprowindex+"_"+temprow));
							String childItem_tmp = Util.null2String(request.getParameter("childItem_"+i+"_"+temprowindex+"_"+temprow));
							String para=curfieldid+flag+"1"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault+flag+cancel;
							if(childfieldid_tmp==0)childItem_tmp="";
							RecordSetTrans.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
							RecordSetTrans.executeSql("update workflow_SelectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"',childitemid='"+childItem_tmp+"',isAccordToSubCom='"+isAccordToSubCom_tmp+"' where fieldid="+curfieldid+" and selectvalue="+curvalue);
	                        curvalue++;
				  	}
			    }else if (detailselectItemType.equals("1")){
			    	field_pubchoice_map.put(curfieldid,""+detailpubchoiceId);
			    }else if (detailselectItemType.equals("2")){
			    	field_pubchilchoice_map.put(curfieldid,""+detailpubchilchoiceId);
			    }
			  	
			  }
			  
			  if(new_OR_modify.equals("")){//新建字段插入到节点
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
	  	}
	  	
/* 	    	if(!"".equals(newsapmultiBrowservalue)){
	  	
	  		RecordSetTrans.executeSql("select count(*) s from sap_multiBrowser where browsermark='"+newsapmultiBrowservalue+"' and  mxformid='"+formid+"' ");
	  		if(RecordSetTrans.next()&&RecordSetTrans.getInt("s")<=0){
	  			   //如果配置了sap集成多选浏览按钮---插入sap_multiBrowser的数据
	    	 		RecordSetTrans.executeSql("insert into sap_multiBrowser (mxformname,mxformid,browsermark,isbill) values('"+detailtable+"',"+formid+",'"+newsapmultiBrowservalue+"','1')");
	  		}else{
	  				//由于多选浏览按钮添加以后、删除不了，所以修改操作没有了意义
	  		} 
	  	}else{ */
	  			//删除了表，同样需要删除sap_multiBrowser表中的数据
			  	RecordSetTrans.executeSql("delete  sap_multiBrowser where mxformname='"+detailtable+"' and  mxformid='"+formid+"' ");
	  			//为了与老表单兼容，凡是明细表中没字段的都默认把集成多选浏览按钮删除
		  		//没有字段则删除表
		 	 	RecordSetTrans.executeSql("select * from workflow_billfield where billid="+formid+" and detailtable='"+detailtable+"'");
			  	if(!RecordSetTrans.next()){
			  		RecordSetTrans.executeSql("drop table "+detailtable);
			  		RecordSetTrans.executeSql("delete from Workflow_billdetailtable where billid="+formid+" and tablename='"+detailtable+"'");
			  		
			  	} else{
			  			if(!"".equals(newsapmultiBrowservalue)){
				  			//说明明细表中有字段
				  			RecordSetTrans.executeSql("select count(*) s from sap_multiBrowser where browsermark='"+newsapmultiBrowservalue+"' and  mxformid='"+formid+"' ");
					  		if(RecordSetTrans.next()&&RecordSetTrans.getInt("s")<=0){
					  			   //如果配置了sap集成多选浏览按钮---插入sap_multiBrowser的数据
					    	 		RecordSetTrans.executeSql("insert into sap_multiBrowser (mxformname,mxformid,browsermark,isbill) values('"+detailtable+"',"+formid+",'"+newsapmultiBrowservalue+"','1')");
					  		}else{
					  				//由于多选浏览按钮添加以后、删除不了，所以修改操作没有了意义
					  		} 
				  	}
			  	}
			  	
	  /* 	}  */
	  	 
  		
  		/* 	//没有字段则删除表
		 	 	RecordSetTrans.executeSql("select * from workflow_billfield where billid="+formid+" and detailtable='"+detailtable+"'");
			  	if(!RecordSetTrans.next()){
			  		RecordSetTrans.executeSql("drop table "+detailtable);
			  		RecordSetTrans.executeSql("delete from Workflow_billdetailtable where billid="+formid+" and tablename='"+detailtable+"'");
			  	} 
			  	//删除了表，同样需要删除sap_multiBrowser表中的数据
			  	RecordSetTrans.executeSql("delete  sap_multiBrowser where browsermark='"+detailtable+"' and  mxformid='"+formid+"' "); */
	  
	  	
  	}
  	//明细字段 结束
  	
		RecordSetTrans.commit();
  	
		//公共选择框子项 上级选择框不能重复，如果重复将失效的上级选择框清空，并提示。
		ArrayList<String> needUpdfieldidList = new ArrayList<String>();
  		String needUpdateIds = "";
  		StringBuffer sqltmp = new StringBuffer();
  		sqltmp.append("SELECT MAX(id) fieldid FROM workflow_billfield WHERE billid = ").append(formid).append(" AND selectItemType='2' AND pubchilchoiceId>0");
  		sqltmp.append(" GROUP BY pubchilchoiceId");
  		sqltmp.append(" HAVING COUNT(pubchilchoiceId) >1");
  		rs2.executeSql(sqltmp.toString());
  		while(rs2.next()){
  			needUpdfieldidList.add(rs2.getString("fieldid"));
  		}
		
		for(Map.Entry<String, String> entry: field_pubchoice_map.entrySet()){
		    int fieldid = Util.getIntValue(entry.getKey(),0);
		    int pubchoiceId = Util.getIntValue(entry.getValue(),0);
			SelectItemManager.setSelectOpBypubid(formid+"",pubchoiceId,fieldid+"",1,user.getLanguage());
		}
		for(Map.Entry<String, String> entry: field_pubchilchoice_map.entrySet()){
		    int fieldid = Util.getIntValue(entry.getKey(),0);
		    int pubchilchoiceId = Util.getIntValue(entry.getValue(),0);
		    
		    if(needUpdfieldidList.contains(fieldid+"")){
		    	needUpdateIds += ","+fieldid;
		    	continue;
		    }
			SelectItemManager.setSuperSelectOp(formid+"",1,pubchilchoiceId,fieldid,user.getLanguage());
		}
		
		
		if(isoracle){
				RecordSet.executeSql("select tablename from Workflow_billdetailtable where billid="+formid);
				while(RecordSet.next()){
						String tempdetailtablename = RecordSet.getString("tablename");
						rs1.executeSql("select * from user_triggers where upper(trigger_name)=upper('"+tempdetailtablename+"_Id_Tr')");
						if(!rs1.next()){//明细表id自增长
								int maxid_tmp = 0;
								rs2.execute("select max(id) from "+tempdetailtablename+"");
								if(rs2.next()){
									maxid_tmp = Util.getIntValue(rs2.getString(1), 0);
								}
								maxid_tmp++;
								try{
									//rs2.executeSql("drop sequence "+tempdetailtablename+"_Id");
									rs2.executeSql("select  1 from user_sequences where upper(sequence_name)=upper('"+tempdetailtablename+"_Id')");
									if(rs2.next()){
										rs2.executeSql("drop sequence "+tempdetailtablename+"_Id");
									}
								}catch(Exception e){}
								rs2.executeSql("create sequence "+tempdetailtablename+"_Id start with "+maxid_tmp+" increment by 1 nomaxvalue nocycle nocache");
								rs2.setChecksql(false);
								rs2.executeSql("CREATE OR REPLACE TRIGGER "+tempdetailtablename+"_Id_Tr before insert on "+tempdetailtablename+" for each row begin select "+tempdetailtablename+"_Id.nextval into :new.id from dual; end;");
						}
				}
		}
		
		//批量处理pubchoiceid
		rs2.execute("select pubchilchoiceid,id from workflow_billfield where billid = "+formid+" and pubchoiceid = 0 and pubchilchoiceid > 0 and pubchoiceid = 0 and pubchilchoiceid > 0 ");
		while(rs2.next()){
			int pubchilchoiceid_temp = Util.getIntValue(rs2.getString(1),0);
			int id_temp = Util.getIntValue(rs2.getString(2),0);
	    	rs1.execute("update workflow_billfield set pubchoiceid =(select pubchoiceId from workflow_billfield where id = " + pubchilchoiceid_temp + ") where id = " + id_temp);
	    }
		
		ArrayList labelidsArray = Util.TokenizerString(labelidsCache,",");
		for(int i=0;i<labelidsArray.size();i++){//添加标签id到缓存
			LabelComInfo.addLabeInfoCache((String)labelidsArray.get(i));
		}
  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
  		}
  		
  		if(!needUpdateIds.equals("")){
  			needUpdateIds = needUpdateIds.substring(1);
  			rs2.executeSql("update workflow_billfield set pubchilchoiceId=0 where id in ("+needUpdateIds+")");
  			
  			response.sendRedirect("/workflow/form/editfieldbatch.jsp?formid="+formid+"&dialog=1&isFromMode="+isFromMode+"&message=pubchilchoiceId");
  			return ;
  		}
  		
  		if(jumpfieldid>0){
  			response.sendRedirect("/workflow/form/editfieldbatch.jsp?formid="+formid+"&dialog=1&isFromMode="+isFromMode+"&jumpfieldid="+jumpfieldid);
  			return ;
  		}
  		
  		
  		String fromwhere = Util.null2String(request.getParameter("fromwhere"));
  		if("1".equals(dialog)){ 
			response.sendRedirect("/workflow/form/addfieldbatch.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&isclose=1&isValue=1&fromwhere="+fromwhere);
		}else{
		 response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0");
  		}
  }catch(Exception e){
		e.printStackTrace();
		RecordSetTrans.rollback();
		String url = "/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0";
		if(!modifyFieldtypeSuccess){
			url += "&message=modifyFieldtypeError";
		}
		
		response.sendRedirect(url);
	}finally{
		formFieldUtil.syncDB(tmpFormid);
	}
}else if(src.equals("deleteField")){
	RecordSetTrans.setAutoCommit(false);
	try{
		String formid = Util.null2String(request.getParameter("formid"));
		int fieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
		String viewtype = Util.null2String(request.getParameter("viewtype"));
		String tablename = "";
		if(viewtype.equals("0")) tablename = Util.null2String(request.getParameter("maintable"));
		if(viewtype.equals("1")) tablename = Util.null2String(request.getParameter("detailtable"));
		
		//如果字段被行列规则引用，则退出。
		RecordSetTrans.executeSql("select * from workflow_formdetailinfo where rowcalstr like '%!_"+fieldid+"_%' escape '!' or rowcalstr like '%!_"+fieldid+"' escape '!' or colcalstr like '%!_"+fieldid+"_%' escape '!' or colcalstr like '%!_"+fieldid+"' escape '!' or maincalstr like '%!_"+fieldid+"_%' escape '!' or maincalstr like '%!_"+fieldid+"' escape '!'");
		if(RecordSetTrans.next()){
		    RecordSetTrans.rollback();
		    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodelete");
		    return;
		}

		if(WorkflowSubwfFieldManager.hasSubWfSetting(RecordSetTrans,fieldid,1)){
			RecordSetTrans.rollback();
			response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodeleteForSubWf");
			return;
		}

		String fieldnameForDel="";
		RecordSetTrans.executeSql("select fieldname from workflow_billfield where id="+fieldid);
		if(RecordSetTrans.next()) fieldnameForDel = RecordSetTrans.getString("fieldname");//取得字段名
		RecordSetTrans.executeSql("delete from workflow_billfield where id="+fieldid);//删除字段
		RecordSetTrans.executeSql("alter table "+tablename+" drop column "+fieldnameForDel);//修改表结构
		RecordSetTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+fieldid);//删除表workflow_SelectItem中该字段对应数据
		RecordSetTrans.execute("update workflow_billfield set childfieldid=0 where childfieldid="+fieldid);//如果被删除字段是子字段，则需要修改
		
		//删除与该字段相关的出口条件
		if(viewtype.equals("0")){
		Pattern mpattern = null;
		Matcher mmatcher = null;
		String partStr = "\\b"+fieldnameForDel+"\\b";
		mpattern = Pattern.compile(partStr);
		ArrayList nodelinkidList = new ArrayList();
		ArrayList conditionList = new ArrayList();
		
		//RecordSetTrans.execute("select * from workflow_nodelink where condition like '%"+fieldnameForDel+"%' and workflowid in (select id from workflow_base where formid="+formid+")");
		//while(RecordSetTrans.next()){
		//		int nlid = Util.getIntValue(RecordSetTrans.getString("id"));
		//		String condition = Util.null2String(RecordSetTrans.getString("condition"));
		//		nodelinkidList.add(""+nlid);
		//		conditionList.add(""+condition);
		//}
		
		//调整字段后新的读取方式开始
		 String strSql = "select * from workflow_nodelink where condition like '%"+fieldnameForDel+"%' and workflowid in (select id from workflow_base where formid="+formid+")";
		 weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
   	 	 weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
		 String docContent = "";
	   	 statement.setStatementSql(strSql, false);
	   	 statement.executeQuery();
 		 if(statement.next()){
		  	 if(statement.getDBType().equals("oracle"))
		  	 {
		  			oracle.sql.CLOB theclob = statement.getClob("condition"); 
			  		String readline = "";
			        StringBuffer clobStrBuff = new StringBuffer("");
			        java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
			        while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
			        clobin.close() ;
			        docContent = clobStrBuff.toString();
		  	  }else{
				  		docContent=statement.getString("condition");
		  }
	  	 
	  	 int nlid = Util.getIntValue(statement.getString("id"));
	  	 nodelinkidList.add(""+nlid);
		 conditionList.add(""+docContent);
 		}
	  	 //调整字段后新的读取方式结束
		
		for(int cx=0; cx<nodelinkidList.size(); cx++){
				String nlid = Util.null2String((String)nodelinkidList.get(cx));
				String condition = Util.null2String((String)conditionList.get(cx));
				mmatcher = mpattern.matcher(condition);
				boolean find = mmatcher.find();
				if(find==true){
						//RecordSetTrans.execute("update workflow_nodelink set condition='' , conditioncn='' where id="+nlid);
						String sql = "update workflow_nodelink set condition='' , conditioncn='' where id="+nlid;
				        if(statement.getDBType().equals("oracle"))
				            sql = "update workflow_nodelink set condition=empty_clob() , conditioncn=empty_clob() where id="+nlid;
		                statement.setStatementSql(sql);
		                statement.executeUpdate();
				}
		}
		if(null!=statement){
			statement.close();
		}
		}
		//删除与该字段相关的出口条件

		//删除节点附加操作
		RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=1 and objid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + fieldid + " or fieldop1id = " + fieldid + " or fieldop2id = " + fieldid + ")" );
		//删除出口附加操作
		RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=0 and objid in (select t1.id from  workflow_nodelink t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + fieldid + " or fieldop1id = " + fieldid + " or fieldop2id = " + fieldid + ")");
		//删除由自定义字段产生的操作人，主要是由浏览框带来的
		RecordSetTrans.executeSql("delete from  workflow_groupdetail where type in(5,6,31,32,7,38,42,43,8,33,9,10,47,34,11,12,13,35,14,15,44,45,46,16) and groupid in(select id from workflow_nodegroup where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ")) and objid=" + fieldid);
		//删除节点上哪些字段可视、可编辑、必输的信息
		RecordSetTrans.executeSql("delete from  workflow_nodeform where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and fieldid= " + fieldid);
		//删除特殊字段的信息
		RecordSetTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid =" + fieldid);

		
		//如果删除的是明细表最后一个字段，则将该表同时删除
		if(viewtype.equals("1")){
		  RecordSetTrans.executeSql("select * from workflow_billfield where billid="+formid+" and detailtable='"+tablename+"'");
		  if(!RecordSetTrans.next()){
		  	RecordSetTrans.executeSql("drop table "+tablename);
		  	RecordSetTrans.executeSql("delete from Workflow_billdetailtable where billid="+formid+" and tablename='"+tablename+"'");
		  }
	  }
		
		RecordSetTrans.commit();
		response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0");
		
	}catch(Exception e){
		RecordSetTrans.rollback();
	}
}else if(src.equals("editField")){
	char flag=2;
	String hasChanged = Util.null2String(request.getParameter("hasChanged"));
	String canChange = Util.null2String(request.getParameter("canChange"));
	String openrownum = Util.null2String(request.getParameter("openrownum"));
    int imgwidth = Util.getIntValue(request.getParameter("imgwidth"),0);
    int imgheight = Util.getIntValue(request.getParameter("imgheight"),0);
	String formid = Util.null2String(request.getParameter("formid"));
	int fieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
	String selectItemType = Util.null2String(request.getParameter("selectItemType"));
	int pubchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchoiceId")),0);
	int pubchilchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchilchoiceId")),0);
	if(selectItemType.equals("0")){
		pubchoiceId = 0;
		pubchilchoiceId = 0;
	}
	if(selectItemType.equals("1")){
		pubchilchoiceId = 0;
	}
	if(selectItemType.equals("2")){
		//pubchoiceId = 0;
	}
	
	String needUpdateIds = "";
	String fieldHtmlType = Util.null2String(request.getParameter("FieldHtmlType"));
	if("5".equals(fieldHtmlType)){
		hasChanged = "true";
		if(selectItemType.equals("2")){
			rs2.executeSql("SELECT id FROM workflow_billfield b WHERE b.billid = "+formid+" AND fieldhtmltype='5' AND id !="+fieldid+" AND pubchilchoiceId = "+pubchilchoiceId);
			if(rs2.next()){
				needUpdateIds = ""+fieldid;
			}
		}
	}
	
	if(hasChanged.equals("true")){
		RecordSetTrans.setAutoCommit(false);
		try{
			
			String viewtype = "0";
			String tablename = Util.null2String(request.getParameter("updateTableName"));
			String detailtable = "";
			RecordSetTrans.executeSql("select * from Workflow_billdetailtable where billid="+formid+" and tablename='"+tablename+"'");
			if(RecordSetTrans.next()){
				viewtype = "1";
			    detailtable = tablename;
			}
			
			String fieldname = Util.null2String(request.getParameter("fieldname"));
			String fieldlabelname = Util.null2String(request.getParameter("fieldlabelname"));
			fieldlabelname = Util.StringReplace(fieldlabelname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldlabelname = Util.StringReplace(fieldlabelname, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			int lableid = 0;
			if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
			else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  if(RecordSetTrans.next()) lableid = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id
		 	else{
				lableid = FormManager.getNewIndexId(RecordSetTrans);//生成新的标签id
			 	if(lableid!=-1){//更新标签库
			  	RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
			 		RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldlabelname+"')");
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldlabelname+"',7)");
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldlabelname+"',8)");
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldlabelname+"',9)");
			 	}
			}
			
			String documentType = Util.null2String(request.getParameter("DocumentType"));
			String textheight = Util.null2String(request.getParameter("textheight"));
			String textheight_2 = "";
			String fielddbtype = Util.null2String(request.getParameter("fielddbtype"));
			String _fielddbtype = "";//字段数据库类型
			String dsporder = Util.null2String(request.getParameter("itemDspOrder"));
			dsporder = ""+Util.getFloatValue(dsporder,0);
			int qfws=0;
			int places=0;
			int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
			//if(dsporder.equals("")) dsporder = "0";
			if(!fieldHtmlType.equals("5")){
			  	selectItemType = "0";
			  	pubchoiceId=0;
			  	pubchilchoiceId=0;
			 }
			
			if(fieldHtmlType.equals("1")&&documentType.equals("1")){//单行文本框——文本，重新生成数据库类型
				String oldfielddbtype = "";
				RecordSetTrans.executeSql("select fielddbtype from workflow_billfield where id="+fieldid);
				if(RecordSetTrans.next()) oldfielddbtype = RecordSetTrans.getString("fielddbtype");
				
				String strlength = Util.null2String(request.getParameter("itemFieldScale1"));
				if(Util.getIntValue(strlength,1)<=1) strlength = "1";
				if(isoracle) fielddbtype="varchar2("+strlength+")";
				else fielddbtype="varchar("+strlength+")";
				
				if(!fielddbtype.equals(oldfielddbtype)){
				    if(isoracle) RecordSetTrans.executeSql("ALTER TABLE "+tablename+" MODIFY "+fieldname+" "+fielddbtype);
				    else RecordSetTrans.executeSql("ALTER TABLE "+tablename+" ALTER COLUMN "+fieldname+" "+fielddbtype);
				}
			} 
			if(canChange.equals("true")){
			    String type = Util.null2String(request.getParameter("DocumentType"));
			    int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits"),2);
			    if(fieldHtmlType.equals("1")){
			        if(type.equals("1")){
			            String strlength = Util.null2String(request.getParameter("itemFieldScale1"));
			            if(Util.getIntValue(strlength,1)<=1) strlength = "1";
			            if(isoracle) fielddbtype="varchar2("+strlength+")";
			            else fielddbtype="varchar("+strlength+")";
			        }
			        if(type.equals("2")){
			            if(isoracle) fielddbtype="integer";
			            else fielddbtype="int";
			        }
			        if(type.equals("3")){
			            if(isoracle) fielddbtype="number(15,"+decimaldigits+")";
			            else fielddbtype="decimal(15,"+decimaldigits+")";
			            qfws=decimaldigits;
			        }
			        if(type.equals("4")){
			            if(isoracle) fielddbtype="number(15,2)";
			            else fielddbtype="decimal(15,2)";
			        }
			        if(type.equals("5")){
			        	if(isoracle) fielddbtype="varchar2(30)";
			            else fielddbtype="varchar(30)";
			            	qfws=decimaldigits;
			        }
			    }
			    if(fieldHtmlType.equals("2")){
			        String htmledit = Util.null2String(request.getParameter("htmledit"));
			        if(htmledit.equals("")) documentType="1";
			        else documentType=htmledit;
			        //if(isoracle) fielddbtype="varchar2(4000)";
			        //else if(isdb2) fielddbtype="varchar(2000)";
			        //else fielddbtype="text";
			        if(isoracle) {
			        	if(!"1".equals(documentType)) {
			        		fielddbtype="clob";
			        	} else {
			        		fielddbtype="varchar2(4000)";
			        	}
			        } else if(isdb2) {
			         	fielddbtype="varchar(2000)";
			        } else {
			        	fielddbtype="text";
			        }
			        textheight = ""+Util.getIntValue(Util.null2String(request.getParameter("textheight")),4);
			    }
			    if(fieldHtmlType.equals("3")){
			        int temptype = Util.getIntValue(Util.null2String(request.getParameter("browsertype")),0);
			        documentType = ""+temptype;
			        if(temptype>0)
			            fielddbtype=BrowserComInfo.getBrowserdbtype(temptype+"");
			        if(temptype==118){
				  		if(isoracle) fielddbtype="varchar2(200)";
			              else fielddbtype="varchar(200)";
				  	}
			        if(temptype==161||temptype==162){
			            fielddbtype=Util.null2String(request.getParameter("definebroswerType"));
			            if(temptype==161){
			                if(isoracle) _fielddbtype="varchar2(1000)";
			                else if(isdb2) _fielddbtype="varchar(1000)";
			                else _fielddbtype="varchar(1000)";
			            }else{
			                if(isoracle) _fielddbtype="varchar2(4000)";
			                else if(isdb2) _fielddbtype="varchar(2000)";
			                else _fielddbtype="text";
			            }
			        }
			        
			        if(temptype==256||temptype==257){//树形browser
						fielddbtype=Util.null2String(request.getParameter("defineTreeBroswerType"));
						if(temptype==256){
			                if(isoracle) _fielddbtype="varchar2(1000)";
			                else if(isdb2) _fielddbtype="varchar(1000)";
			                else _fielddbtype="varchar(1000)";
			            }else{
			                if(isoracle) _fielddbtype="varchar2(4000)";
			                else if(isdb2) _fielddbtype="varchar(2000)";
			                else _fielddbtype="varchar(4000)";
			            }
				  	}
			        
			        if(temptype==224||temptype==225){
			            fielddbtype=Util.null2String(request.getParameter("sapbrowser"));
			            if(temptype==224){
			                if(isoracle) _fielddbtype="varchar2(1000)";
			                else if(isdb2) _fielddbtype="varchar(1000)";
			                else _fielddbtype="varchar(1000)";
			            }else{
			                if(isoracle) _fielddbtype="varchar2(4000)";
			                else if(isdb2) _fielddbtype="varchar(2000)";
			                else _fielddbtype="text";
			            }
			        }
			        
			        	//zzl-start
				  	if(temptype==226||temptype==227){
						fielddbtype=Util.null2String(request.getParameter("showvalue"));
				  		if(temptype==226){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
				  	}

				  	if(temptype==17){
				  		if(isoracle) {
				  			fielddbtype="clob";
				  			_fielddbtype="clob";
				  		}else if(isdb2){
				  			_fielddbtype="varchar(2000)";
				  		}
						else {
							fielddbtype="text";
							_fielddbtype="text";
						}
				  	}
				  	//zzl-end
				  				        
			    }
			    if(fieldHtmlType.equals("4")){
			        documentType = "1";
			        fielddbtype="char(1)";
			    }
			    if(fieldHtmlType.equals("5"))	{
			        documentType = "1";
			        if(isoracle) fielddbtype="integer";
			        else fielddbtype="int";
			    }
			    if(fieldHtmlType.equals("6"))	{
			        if(isoracle) fielddbtype="varchar2(4000)";
			        else if(isdb2) fielddbtype="varchar(2000)";
			        else fielddbtype="text";
			    }
			    if(fieldHtmlType.equals("7"))	{
			        documentType = Util.null2String(request.getParameter("specialfield"));//类型
			        if(isoracle) fielddbtype="varchar2(4000)";
			        else if(isdb2) fielddbtype="varchar(2000)";
			        else fielddbtype="text";
			    }
			}
            if (fieldHtmlType.equals("6")) {
                documentType = "" + Util.getIntValue(Util.null2String(request.getParameter("uploadtype")), 1);
                textheight = "" + Util.getIntValue(Util.null2String(request.getParameter("strlength")), 0);
            }
			
			if (fieldHtmlType.equals("3")) {
			    int temptype = Util.getIntValue(Util.null2String(request.getParameter("browsertype")),0);
                if(temptype==165||temptype==166||temptype==167||temptype==168) {
			        //textheight=""+Util.getIntValue(Util.null2String(request.getParameter("decentralizationbroswerType")),0); 
			        textheight_2=Util.null2String(request.getParameter("decentralizationbroswerType")); 
				}
			}

            
            //如果 canChange为true，并且 字段是下拉框 公共选择框、公共选择框子项 则不能删掉新增，只能修改 否则fieldid变了影响引用
            boolean isUpdate = (canChange.equals("true") && fieldid>0 && fieldHtmlType.equals("5") && (selectItemType.equals("1") || selectItemType.equals("2")))?true:false;           

            
			if(canChange.equals("true")&&isFromMode!=1 && !isUpdate){
			    //先删除字段相关信息再插入  
			    String fieldnameForDel="";
			    RecordSetTrans.executeSql("select fieldname from workflow_billfield where id="+fieldid);
			    if(RecordSetTrans.next()) fieldnameForDel = RecordSetTrans.getString("fieldname");//取得字段名
			    String oldtablename = Util.null2String(request.getParameter("oldtablename"));
			    RecordSetTrans.executeSql("delete from workflow_billfield where id="+fieldid);//删除字段
				/*
				 * 查询如果当前这个表单没有被流程引用，那么我更新formtable的统一都用drop然后add
				*/
				boolean canChangeFieldDbType = true;
				String sqlForCanChangeFieldDbType = " select 1 from " + tablename + " where " + fieldname + " is not null ";
				rs2.writeLog("==========szg==========sqlForCanChangeFieldDbType:" + " select 1 from " + tablename + " where " + fieldname + " is not null ");
                rs2.executeSql(sqlForCanChangeFieldDbType);
				if(rs2.next()){
                    canChangeFieldDbType = false;
				}
                rs2.writeLog("==========szg==========canChangeFieldDbType:" + canChangeFieldDbType);
			    if(!fieldname.equals(fieldnameForDel)||!oldtablename.equals(tablename) || canChangeFieldDbType){//TD10207 chujun
			        RecordSetTrans.executeSql("alter table "+oldtablename+" drop column "+fieldnameForDel);//修改表结构
			        int temptype = Util.getIntValue(Util.null2String(request.getParameter("browsertype")),0);
			        if(!"".equals(_fielddbtype)){
						rs2.writeLog("==========szg==========alterSql:" + "alter table "+tablename+" add "+fieldname+" "+_fielddbtype);
			        	RecordSetTrans.executeSql("alter table "+tablename+" add "+fieldname+" "+_fielddbtype);//更新表结构
			        }else{
						rs2.writeLog("==========szg==========alterSql:" + "alter table "+tablename+" add "+fieldname+" "+_fielddbtype);
			        	RecordSetTrans.executeSql("alter table "+tablename+" add "+fieldname+" "+fielddbtype);//更新表结构
			        }
			    }
			    			
			    //RecordSetTrans.executeSql("delete from workflow_SelectItem where fieldid="+fieldid);//删除表workflow_SelectItem中该字段对应数据

			    //更新字段信息
			    RecordSetTrans.executeSql("INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,imgwidth,imgheight,places,qfws,selectItemType,pubchoiceId,pubchilchoiceId) "+
			    " VALUES ("+formid+",'"+fieldname+"',"+lableid+",'"+fielddbtype+"',"+fieldHtmlType+","+documentType+","+dsporder+","+viewtype+",'"+detailtable+"',"+textheight+",'"+textheight_2+"',"+imgwidth+","+imgheight+","+places+","+qfws+",'"+selectItemType+"',"+pubchoiceId+","+pubchilchoiceId+")");
			}else if(canChange.equals("true")&&isFromMode==1){
			    String fieldnameForDel="";
			    RecordSetTrans.executeSql("select fieldname from workflow_billfield where id="+fieldid);
			    if(RecordSetTrans.next()) fieldnameForDel = RecordSetTrans.getString("fieldname");//取得字段名
			    String oldtablename = Util.null2String(request.getParameter("oldtablename"));
			    if(!fieldname.equals(fieldnameForDel)||!oldtablename.equals(tablename)){//TD10207 chujun
			        RecordSetTrans.executeSql("alter table "+oldtablename+" drop column "+fieldnameForDel);//修改表结构
			        int temptype = Util.getIntValue(Util.null2String(request.getParameter("browsertype")),0);
			        if(!"".equals(_fielddbtype)){
			        	RecordSetTrans.executeSql("alter table "+tablename+" add "+fieldname+" "+_fielddbtype);//更新表结构
			        }else{
			        	RecordSetTrans.executeSql("alter table "+tablename+" add "+fieldname+" "+fielddbtype);//更新表结构
			        }
			    }
				RecordSetTrans.executeSql("update workflow_billfield set billid="+formid+",fieldname='"+fieldname+"',fieldlabel="+lableid+",fielddbtype='"+fielddbtype+"',fieldhtmltype="+fieldHtmlType+",type="+documentType+",dsporder="+dsporder+",viewtype="+viewtype+",detailtable='"+detailtable+"',textheight="+textheight+",textheight_2='"+textheight_2+"',childfieldid="+childfieldid+",imgwidth="+imgwidth+",imgheight="+imgheight+" ,places="+places+" ,qfws="+qfws+",selectItemType='"+selectItemType+"',pubchoiceId="+pubchoiceId+",pubchilchoiceId="+pubchilchoiceId+" where id="+fieldid);
			}else{
                RecordSetTrans.executeSql("update workflow_billfield set billid="+formid+",fieldname='"+fieldname+"',fieldlabel="+lableid+",fielddbtype='"+fielddbtype+"',fieldhtmltype="+fieldHtmlType+",type="+documentType+",dsporder="+dsporder+",viewtype="+viewtype+",detailtable='"+detailtable+"',textheight="+textheight+",textheight_2='"+textheight_2+"',childfieldid="+childfieldid+",imgwidth="+imgwidth+",imgheight="+imgheight+" ,places="+places+" ,qfws="+qfws+",selectItemType='"+selectItemType+"',pubchoiceId="+pubchoiceId+",pubchilchoiceId="+pubchilchoiceId+" where id="+fieldid);
			}
			
			String curfieldid = "";
			if(canChange.equals("true")&&isFromMode!=1 && !isUpdate){
			    RecordSetTrans.executeSql("select max(id) as id from workflow_billfield where billid="+formid);
			    if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
			    RecordSetTrans.executeSql("update  Workflow_Selectitem set fieldid="+curfieldid+" where fieldid="+fieldid+" and isbill=1");
			    RecordSetTrans.executeSql("update  Workflow_SelectitemObj set fieldid="+curfieldid+" where fieldid="+fieldid+" and isbill=1");
			}else{
			    curfieldid = ""+fieldid;
			}  
			fieldid = Util.getIntValue(curfieldid,0);		
			//如果是选择框，更新表workflow_SelectItem
			if(fieldHtmlType.equals("5") && selectItemType.equals("0")){
			  RecordSetTrans.executeSql("update workflow_billfield set childfieldid="+childfieldid +" where id="+curfieldid);
			  int rowsum = Util.getIntValue(Util.null2String(request.getParameter("choiceRows_rows")));
			  String ids = "";
	          for(int temprow=1;temprow<=rowsum;temprow++){
	          	String id_temp = Util.null2String(request.getParameter("id_"+temprow));
	          	if(!"".equals(id_temp))
	          		ids += "," + id_temp;
	          }
	          
	          String delsql = "delete from workflow_SelectItem where isbill=1 and fieldid="+fieldid;
	      	  if(!"".equals(ids)){
	      		  ids = ids.substring(1);
	      		  delsql += " and id not in ("+ids+")";
	      	  }
	      	  RecordSetTrans.executeSql(delsql);
			  
	      	  int curvalue = -1;
	    	  RecordSet.execute("select max(selectvalue) from workflow_SelectItem where isbill = 1 and fieldid="+fieldid);
	    	  if(RecordSet.next())
	    		 curvalue = Util.getIntValue(Util.null2String(RecordSet.getString(1)),-1);
              
			  for(int temprow=1;temprow<=rowsum;temprow++){
				String id_temp = Util.null2String(request.getParameter("id_"+temprow));
				String curname = Util.null2String(request.getParameter("field_name_"+temprow));
			  	if(curname.equals("")) continue;
			  	String curorder = Util.null2String(request.getParameter("field_count_name_"+temprow));
			  	String isdefault = "n";
			  	String checkValue = Util.null2String(request.getParameter("field_checked_name_"+temprow));
			  	String cancel = Util.null2String(request.getParameter("cancel_"+temprow+"_name")); 
			  	if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
						cancel = "1";
					}else{
						cancel = "0";
					}
			  	if(checkValue.equals("1")) isdefault="y";
			  	int isAccordToSubCom_tmp = Util.getIntValue(request.getParameter("isAccordToSubCom"+temprow), 0);
					String doccatalog = Util.null2String(request.getParameter("maincategory_"+temprow));
					String docPath = Util.null2String(request.getParameter("pathcategory_"+temprow));
					String childItem = Util.null2String(request.getParameter("childItem"+temprow));
					if(childfieldid==0)childItem="";
					if("".equals(id_temp)){
						curvalue++;
						String para=curfieldid+flag+"1"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault+flag+cancel;
						RecordSetTrans.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
						RecordSetTrans.executeSql("update workflow_SelectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"',childitemid='"+childItem+"',isAccordToSubCom='"+isAccordToSubCom_tmp+"' where fieldid="+curfieldid+" and selectvalue="+curvalue);
					}else{
						String updatesql = "update workflow_selectitem set selectname = '"+curname+"'," +
						"listorder="+curorder+"," +
						"isdefault='"+isdefault+"',"+
						"cancel='"+cancel+"',"+
						"docpath='"+docPath+"',"+
						"docCategory='"+doccatalog+"',"+
						"childitemid='"+childItem+"',"+
						"isAccordToSubCom='"+isAccordToSubCom_tmp+"'"+
						" where  fieldid = " + fieldid + "  and id = " + id_temp;
						RecordSetTrans.execute(updatesql);
					}
				}
			}

	        if(fieldHtmlType.equals("7")){
               String displayname = Util.null2String(request.getParameter("displayname"));//显示名
               String linkaddress = Util.null2String(request.getParameter("linkaddress"));//链接地址
			  
               String descriptivetext = Util.null2String(request.getParameter("descriptivetext"));//描述性文字
               descriptivetext = Util.spacetoHtml(descriptivetext);	
               descriptivetext = Util.htmlFilter4UTF8(descriptivetext);
	  	       String specialfield = Util.null2String(request.getParameter("specialfield"));//类型
               String sql = "delete from workflow_specialfield where isbill = 1 and fieldid = " + fieldid;
	           RecordSetTrans.executeSql(sql);
	           if(specialfield.equals("1")){
	              sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+fieldid+",'"+displayname+"','"+linkaddress+"',0,1)";    
	           }else{
	              sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+fieldid+",'"+descriptivetext+"',0,1)";    
	           }
		       RecordSetTrans.executeSql(sql);	
	        }

			RecordSetTrans.commit();
			
			if(fieldHtmlType.equals("5")){
				if(selectItemType.equals("1")){
					SelectItemManager.setSelectOpBypubid(formid,pubchoiceId,fieldid+"",1,user.getLanguage());
				}else if(selectItemType.equals("2")){
					if(needUpdateIds.equals("")){
						SelectItemManager.setSuperSelectOp(formid,1,pubchilchoiceId,fieldid,user.getLanguage(),pubchoiceId);
					}
				}
			}
			
			
			LabelComInfo.addLabeInfoCache(""+lableid);
	  		
			if(!needUpdateIds.equals("")){
				RecordSet.executeSql("update workflow_billfield set pubchilchoiceId=0 where id in ("+needUpdateIds+")");
				response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&fieldid="+fieldid+"&message=pubchilchoiceId");
				return;
			}
			
			if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
	  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
	  		}
			if(!openrownum.equals("")){
			      response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&src=editfield&isused=true&fieldid="+fieldid+"&dialog=1&isclose=1");
			}else{
			response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0");
			}
		}catch(Exception e){
			RecordSetTrans.rollback();
		}finally{
		formFieldUtil.syncDB(tmpFormid);
	}
	}else{
		if(!openrownum.equals("")){
			      response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&src=editfield&isused=true&dialog=1&isclose=1");
			}else{
		    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0");
			}
	}
}else if(src.equals("addFieldSingle")){
	char flag=2;
	String isAccordToSubComFieldid ="";
	String openrownum="";
	boolean isToEditSubComFieldid=false;
	RecordSetTrans.setAutoCommit(false);
	boolean needUpdate = false;
	try{
			String formid = Util.null2String(request.getParameter("formid"));
			String updateTableName = Util.null2String(request.getParameter("updateTableName"));//需要更新的表
			String documentType = Util.null2String(request.getParameter("DocumentType"));
			 openrownum= Util.null2String(request.getParameter("openrownum"));
			String fieldname = Util.null2String(request.getParameter("fieldname"));
			String fieldlabelname = Util.null2String(request.getParameter("fieldlabelname"));
			int selectitem = 0;//公共选择项字段
  			int linkfield = 0;//关联选择项字
  			selectitem = Util.getIntValue(Util.null2String(request.getParameter("selectType")),0);
			linkfield = Util.getIntValue(Util.null2String(request.getParameter("childCommonItem")),0);
			String fieldHtmlType = Util.null2String(request.getParameter("FieldHtmlType"));
			String selectItemType = Util.null2String(request.getParameter("selectItemType"));
			int pubchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchoiceId")),0);
			int pubchilchoiceId = Util.getIntValue(Util.null2String(request.getParameter("pubchilchoiceId")),0);
			String locateType = Util.null2String(request.getParameter("locateType"));
			if(selectItemType.equals("0")){
				pubchoiceId = 0;
				pubchilchoiceId = 0;
			}
			if(selectItemType.equals("1")){
				pubchilchoiceId = 0;
			}
			if(selectItemType.equals("2")){
				//pubchoiceId = 0;
			}
			
			if(fieldHtmlType.equals("5") && selectItemType.equals("2")){
				rs2.executeSql("SELECT id FROM workflow_billfield b WHERE b.billid = "+formid+" AND fieldhtmltype='5' AND pubchilchoiceId = "+pubchilchoiceId);
				if(rs2.next()){
					needUpdate = true;
					pubchilchoiceId = 0;
				}
			}
			
			fieldlabelname = Util.StringReplace(fieldlabelname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldlabelname = Util.StringReplace(fieldlabelname, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			int lableid = 0;
			if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
			else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  if(RecordSetTrans.next()) lableid = RecordSetTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id
		 	else{
				lableid = FormManager.getNewIndexId(RecordSetTrans);//生成新的标签id
			 	if(lableid!=-1){//更新标签库
			  	RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
			 		RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldlabelname+"')");
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldlabelname+"',7)");
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldlabelname+"',8)");
			 		RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldlabelname+"',9)");
			 	}
			}
			
			String type = "";
			String fielddbtype = "";
			String _fielddbtype = "";
			String dsporder = Util.null2String(request.getParameter("itemDspOrder"));
			dsporder = ""+Util.getFloatValue(dsporder,0);
			int childfieldid = Util.getIntValue(request.getParameter("childfieldid"),0);
			//if(dsporder.equals("")) dsporder="0";
			String viewtype = "0";
			String detailtable = "";
			int tableIndex=-1;
			int places =0;
			int qfws =0;
			RecordSetTrans.executeSql("select * from Workflow_billdetailtable where billid="+formid+" and tablename='"+updateTableName+"'");
			if(RecordSetTrans.next()){
				viewtype = "1";
				detailtable = updateTableName;
				tableIndex=Util.getIntValue(RecordSetTrans.getString("orderid"),1)-1;
			}
			int textheight = 0;
			String textheight_2 = "";
            int imgwidth = Util.getIntValue(request.getParameter("imgwidth"),0);
            int imgheight = Util.getIntValue(request.getParameter("imgheight"),0);
            
            if(!fieldHtmlType.equals("5")){
			  	selectItemType = "0";
			  	pubchoiceId=0;
			  	pubchilchoiceId=0;
			 }else{
				 if(pubchilchoiceId > 0){
					 rs2.execute("select pubchoiceid from workflow_billfield where id = " + pubchilchoiceId);
					 rs2.next();
					 pubchoiceId = rs2.getInt(1);
				 }
			 }

			if(fieldHtmlType.equals("1")){
				int decimaldigits = Util.getIntValue(request.getParameter("decimaldigits"),2);
			  	type = Util.null2String(request.getParameter("DocumentType"));	
				  if(type.equals("1")){
				  	String strlength = Util.null2String(request.getParameter("itemFieldScale1"));
				  	if(Util.getIntValue(strlength,1)<=1) strlength = "1";
			    	if(isoracle) fielddbtype="varchar2("+strlength+")";
			    	else fielddbtype="varchar("+strlength+")";
			   	}
				 	if(type.equals("2")){
			   		if(isoracle) fielddbtype="integer";
			   		else fielddbtype="int";
			   	}
				 	if(type.equals("3")){
			   		if(isoracle) fielddbtype="number(15,"+decimaldigits+")";
			   		else fielddbtype="decimal(15,"+decimaldigits+")";
			   		qfws=decimaldigits;
			 	 	}
			   	if(type.equals("4")){
			   		if(isoracle) fielddbtype="number(15,2)";
			   		else fielddbtype="decimal(15,2)";
					}
					if(type.equals("5")){
						if(isoracle) fielddbtype="varchar2(30)";
			              else fielddbtype="varchar(30)";
			              	 qfws=decimaldigits;
          			}
			  }
			  if(fieldHtmlType.equals("9")){
			      type = Util.null2String(request.getParameter("locationType"));	  
				   
				  if(isoracle) fielddbtype = "clob";
				  else fielddbtype = "text";
			  }
			  if(fieldHtmlType.equals("2")){
			  	String htmledit = Util.null2String(request.getParameter("htmledit"));
			  	type = htmledit.isEmpty() ? "1" : htmledit;
					//if(isoracle) fielddbtype="varchar2(4000)";
				    //else if(isdb2) fielddbtype="varchar(2000)";
				    //else fielddbtype="text";
				    if(isoracle) {
				   		fielddbtype = "1".equals(type) ? "varchar2(4000)" : "clob";
				    } else if(isdb2) {
				         	fielddbtype="varchar(2000)";
				    } else {
				        fielddbtype="text";
				    }
					textheight = Util.getIntValue(Util.null2String(request.getParameter("textheight")),4);
			  }
			  if(fieldHtmlType.equals("3")){
			  	int temptype = Util.getIntValue(Util.null2String(request.getParameter("browsertype")),0);
			  	type = ""+temptype;
			  	if(temptype>0)
			  		fielddbtype=BrowserComInfo.getBrowserdbtype(type+"");
			  	if(temptype==118){
			  		if(isoracle) fielddbtype="varchar2(200)";
		              else fielddbtype="varchar(200)";
			  	}
					if(temptype==161||temptype==162){
						fielddbtype=Util.null2String(request.getParameter("definebroswerType"));
				  		if(temptype==161){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
				  	}
					
					if(temptype==256||temptype==257){//树形browser
						fielddbtype=Util.null2String(request.getParameter("defineTreeBroswerType"));
						if(temptype==256){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="varchar(4000)";
						}
				  	}
					
					if(temptype==224||temptype==225){
						fielddbtype=Util.null2String(request.getParameter("sapbrowser"));
				  		if(temptype==224){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
				  	}
				  	//zzl-start
				  	if(temptype==226||temptype==227){
						fielddbtype=Util.null2String(request.getParameter("showvalue"));
				  		if(temptype==226){
							if(isoracle) _fielddbtype="varchar2(1000)";
							else if(isdb2) _fielddbtype="varchar(1000)";
							else _fielddbtype="varchar(1000)";
						}else{
							if(isoracle) _fielddbtype="varchar2(4000)";
							else if(isdb2) _fielddbtype="varchar(2000)";
							else _fielddbtype="text";
						}
				  	}
				  	if(temptype==17){
				  		if(isoracle) {
				  			fielddbtype="clob";
				  			_fielddbtype="clob";
				  		}else if(isdb2){
				  			_fielddbtype="varchar(2000)";
				  		}
						else {
							fielddbtype="text";
							_fielddbtype="text";
						}
				  	}
				  	//zzl-end
				  	
				  if(temptype==165||temptype==166||temptype==167||temptype==168) 
				  	//textheight=Util.getIntValue(Util.null2String(request.getParameter("decentralizationbroswerType")),0); 
				  	textheight_2=Util.null2String(request.getParameter("decentralizationbroswerType")); 
			  }
			  if(fieldHtmlType.equals("4")){
			  	type = "1";
			  	fielddbtype="char(1)";
			  }
			  if(fieldHtmlType.equals("5"))	{
			  	type = "1";
			  	if(isoracle) fielddbtype="integer";
			  	else fielddbtype="int";
			  }
			  if(fieldHtmlType.equals("8"))	{
			  	type = "1";
			  	if(isoracle) fielddbtype="integer";
			  	else fielddbtype="int";
			  }
			  if(fieldHtmlType.equals("6"))	{
			  	type = ""+Util.getIntValue(Util.null2String(request.getParameter("uploadtype")),1);
			    if(isoracle) fielddbtype="varchar2(4000)";
				  else if(isdb2) fielddbtype="varchar(2000)";
			    else fielddbtype="text";
                  textheight=Util.getIntValue(Util.null2String(request.getParameter("strlength")),0);
			  }
			  if(fieldHtmlType.equals("7"))	{
			  	type = Util.null2String(request.getParameter("specialfield"));//类型
			    if(isoracle) fielddbtype="varchar2(4000)";
				  else if(isdb2) fielddbtype="varchar(2000)";
			    else fielddbtype="text";
			  }
			if(isoracle == false&&fielddbtype.indexOf("varchar2")!=-1){
				fielddbtype = fielddbtype.replaceAll("varchar2","varchar");
	  		}
			//更新明细表结构
			if(fieldHtmlType.equals("3")&&(type.equals("161")||type.equals("162"))){
				RecordSetTrans.executeSql("alter table "+updateTableName+" add "+fieldname+" "+_fielddbtype);
			}else if(fieldHtmlType.equals("3")&&(type.equals("224")||type.equals("225"))){
				RecordSetTrans.executeSql("alter table "+updateTableName+" add "+fieldname+" "+_fielddbtype);
			}else if(fieldHtmlType.equals("3")&&(type.equals("226")||type.equals("227"))){
				RecordSetTrans.executeSql("alter table "+updateTableName+" add "+fieldname+" "+_fielddbtype);
			}else if(fieldHtmlType.equals("3")&&(type.equals("256")||type.equals("257"))){
				RecordSetTrans.executeSql("alter table "+updateTableName+" add "+fieldname+" "+_fielddbtype);
			}else if(fieldHtmlType.equals("3")&&type.equals("17")){
				RecordSetTrans.executeSql("alter table "+updateTableName+" add "+fieldname+" "+_fielddbtype);
			}
			else{
				RecordSetTrans.executeSql("alter table "+updateTableName+" add "+fieldname+" "+fielddbtype);
			}
			//插入字段信息
			RecordSetTrans.executeSql("INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight,places,qfws,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,locatetype) "+
			" VALUES ("+formid+",'"+fieldname+"',"+lableid+",'"+fielddbtype+"',"+fieldHtmlType+","+type+","+dsporder+","+viewtype+",'"+detailtable+"',"+textheight+",'"+textheight_2+"',"+childfieldid+","+imgwidth+","+imgheight+","+places+","+qfws+","+selectitem+","+linkfield+",'"+selectItemType+"',"+pubchoiceId+","+pubchilchoiceId+",'"+locateType+"')");
			String curfieldid = "";
			RecordSetTrans.executeSql("select max(id) as id from workflow_billfield");
			if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
			//如果是选择框，更新表workflow_SelectItem
			if(fieldHtmlType.equals("5") && selectItemType.equals("0")){
			  int rowsum = Util.getIntValue(Util.null2String(request.getParameter("choiceRows_rows")));
              int curvalue=0;
			  for(int temprow=1;temprow<=rowsum;temprow++){
			  	String curname = Util.null2String(request.getParameter("field_name_"+temprow));
			  	if(curname.equals("")) continue;
			  	String curorder = Util.null2String(request.getParameter("field_count_name_"+temprow));
			  	String isdefault = "n";
			  	String checkValue = Util.null2String(request.getParameter("field_checked_name_"+temprow));
				String childItem = Util.null2String(request.getParameter("childItem"+temprow));
				if(childfieldid==0)childItem="";
			  	if(checkValue.equals("1")) isdefault="y";
			  	int isAccordToSubCom_tmp = Util.getIntValue(request.getParameter("isAccordToSubCom"+temprow), 0);
					String doccatalog = Util.null2String(request.getParameter("maincategory_"+temprow));
					String docPath = Util.null2String(request.getParameter("pathcategory_"+temprow));
				String cancel = Util.null2String(request.getParameter("field_cancel_"+temprow));
                 if(isAccordToSubCom_tmp==1){
				isToEditSubComFieldid=true;
			     }
				 isAccordToSubComFieldid=curfieldid;
					String para=curfieldid+flag+"1"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault;
					RecordSetTrans.executeProc("workflow_SelectItem_Insert",para);//更新表workflow_SelectItem
					RecordSetTrans.executeSql("update workflow_SelectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"', childitemid='"+childItem+"',isAccordToSubCom='"+isAccordToSubCom_tmp+"',cancel='"+cancel+"' where fieldid="+curfieldid+" and selectvalue="+curvalue);
                    curvalue++;
				}
			}
		
	        if(fieldHtmlType.equals("7")){
               String displayname = Util.null2String(request.getParameter("displayname"));//显示名
               String linkaddress = Util.null2String(request.getParameter("linkaddress"));//链接地址
               String descriptivetext = Util.null2String(request.getParameter("descriptivetext"));//描述性文字
               descriptivetext = Util.spacetoHtml(descriptivetext);	
               descriptivetext = Util.htmlFilter4UTF8(descriptivetext);
	  	       String specialfield = Util.null2String(request.getParameter("specialfield"));//类型
	  	       String sql = "";
	           if(specialfield.equals("1")){
	              sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+curfieldid+",'"+displayname+"','"+linkaddress+"',0,1)";    
	           }else{
	              sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+curfieldid+",'"+descriptivetext+"',0,1)";    
	           }
		       RecordSetTrans.executeSql(sql);	
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
			RecordSetTrans.commit();
			
			if(fieldHtmlType.equals("5")){
				if(selectItemType.equals("1")){
					SelectItemManager.setSelectOpBypubid(formid,pubchoiceId,insertFieldId,1,user.getLanguage());
				}else if(selectItemType.equals("2")){
					if(!needUpdate){
						SelectItemManager.setSuperSelectOp(formid,1,pubchilchoiceId,Util.getIntValue(insertFieldId,0),user.getLanguage(),pubchoiceId);						
					}
				}
			}
			
	  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
	  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
	  		}
			LabelComInfo.addLabeInfoCache(""+lableid);
			
			if(needUpdate){
				response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&fieldid="+curfieldid+"&message=pubchilchoiceId");
				return;
			}
			
			if("1".equals(dialog)){
				if("wfcode".equals(fromWFCode)){
					if(isToEditSubComFieldid){
			      response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&src=editfield&isused=true&fieldid="+isAccordToSubComFieldid+"&dialog=1&isclose=0&openrownum="+openrownum);
				}else{
					response.sendRedirect("/workflow/field/addfield0.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&isclose=1&isValue=2&fieldHtmlType="+fieldHtmlType+"&fieldname="+fieldname+"&lableid="+lableid);
				  }
				}else if("exceldesign".equals(fromWFCode)){
					if(isToEditSubComFieldid){
			      response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&src=editfield&isused=true&fieldid="+isAccordToSubComFieldid+"&dialog=1&isclose=0&openrownum="+openrownum);
				}else{
					response.sendRedirect("/workflow/field/addfield0.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&isclose=1&isValue=3&curfieldid="+curfieldid+"&fieldlabelname="+URLEncoder.encode(fieldlabelname, "utf-8")+"&tableIndex="+tableIndex);
				 }
				}else{
					if(isToEditSubComFieldid){
			      response.sendRedirect("/workflow/field/editfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&src=editfield&isused=true&fieldid="+isAccordToSubComFieldid+"&dialog=1&isclose=0&openrownum="+openrownum);
				}else{
					response.sendRedirect("/workflow/field/addfield0.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&isclose=1&isValue=1");
				  }
				}
			}else{
			   response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0");
			}
		}catch(Exception e){
			RecordSetTrans.rollback();
		}finally{
		formFieldUtil.syncDB(tmpFormid);
	}
}else if(src.equals("listDelete")){
	
	try{
		RecordSetTrans.setAutoCommit(false);
		
		String deleteids = Util.null2String(request.getParameter("deleteids"));
		int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
		tmpFormid = formid;
		ArrayList deleteidsArray = Util.TokenizerString(deleteids,",");
		for(int i=0;i<deleteidsArray.size();i++){
			String fieldid = (String)deleteidsArray.get(i);
			String tablename = "";
			String viewtype = "";
			
			String fieldnameForDel="";
			RecordSetTrans.executeSql("select * from workflow_billfield where id="+fieldid);
			if(RecordSetTrans.next()){
				fieldnameForDel = RecordSetTrans.getString("fieldname");//取得删除字段的字段名
				viewtype = RecordSetTrans.getString("viewtype");//取得删除字段的字段类型
				if(viewtype.equals("1")){
					tablename = RecordSetTrans.getString("detailtable");//取得明细字段所在表名
				}else if(viewtype.equals("0")){
					RecordSetTrans.executeSql("select tablename from workflow_bill where id="+formid);
					if(RecordSetTrans.next()){
						tablename = RecordSetTrans.getString("tablename");//取得主字段所在表名
					}
				}
			}

			//如果字段被行列规则引用，则退出。
			RecordSetTrans.executeSql("select * from workflow_formdetailinfo where rowcalstr like '%!_"+fieldid+"_%' escape '!' or rowcalstr like '%!_"+fieldid+"' escape '!' or colcalstr like '%!_"+fieldid+"_%' escape '!' or colcalstr like '%!_"+fieldid+"' escape '!' or maincalstr like '%!_"+fieldid+"_%' escape '!' or maincalstr like '%!_"+fieldid+"' escape '!'");
			if(RecordSetTrans.next()){
			    RecordSetTrans.rollback();
			    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodelete");
			    return;
			}			

            if(WorkflowSubwfFieldManager.hasSubWfSetting(RecordSetTrans,Util.getIntValue(fieldid,0),1)){
			    RecordSetTrans.rollback();
			    response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0&message=nodeleteForSubWf");
			    return;
			}

            RecordSetTrans.executeSql("delete from workflow_billfield where id="+fieldid);//删除字段
			RecordSetTrans.executeSql("alter table "+tablename+" drop column "+fieldnameForDel);//修改表结构
			RecordSetTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+fieldid);//删除表workflow_SelectItem中该字段对应数据

	    //删除与该字段相关的出口条件
	    if(viewtype.equals("0")){
			Pattern mpattern = null;
			Matcher mmatcher = null;
			String partStr = "\\b"+fieldnameForDel+"\\b";
			mpattern = Pattern.compile(partStr);
			ArrayList nodelinkidList = new ArrayList();
			ArrayList conditionList = new ArrayList();
			/*
			RecordSetTrans.execute("select * from workflow_nodelink where condition like '%"+fieldnameForDel+"%' and workflowid in (select id from workflow_base where formid="+formid+")");
			while(RecordSetTrans.next()){
			    int nlid = Util.getIntValue(RecordSetTrans.getString("id"));
			    String condition = Util.null2String(RecordSetTrans.getString("condition"));
			    nodelinkidList.add(""+nlid);
			    conditionList.add(""+condition);
			}
			*/
			
			//调整字段后新的读取方式开始
			 String strSql = "select * from workflow_nodelink where condition like '%"+fieldnameForDel+"%' and workflowid in (select id from workflow_base where formid="+formid+")";
			 weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
	    	 weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
			 String docContent = "";
	    	 statement.setStatementSql(strSql, false);
	    	 statement.executeQuery();
	  		if(statement.next()){
			  	 if(statement.getDBType().equals("oracle"))
			  	 {
			  			oracle.sql.CLOB theclob = statement.getClob("condition"); 
				  		String readline = "";
				        StringBuffer clobStrBuff = new StringBuffer("");
				        java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
				        while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
				        clobin.close() ;
				        docContent = clobStrBuff.toString();
			  	  }else{
					  		docContent=statement.getString("condition");
			  }
		  	 
		  	 int nlid = Util.getIntValue(statement.getString("id"));
		  	 nodelinkidList.add(""+nlid);
		     conditionList.add(""+docContent);
	  		}
		  	 //调整字段后新的读取方式结束
			
			for(int cx=0; cx<nodelinkidList.size(); cx++){
			    String nlid = Util.null2String((String)nodelinkidList.get(cx));
			    String condition = Util.null2String((String)conditionList.get(cx));
			    mmatcher = mpattern.matcher(condition);
			    boolean find = mmatcher.find();
			    if(find==true){
			        RecordSetTrans.execute("update workflow_nodelink set condition='' , conditioncn='' where id="+nlid);
			        String sql = "update workflow_nodelink set condition='' , conditioncn='' where id="+nlid;
			        if(statement.getDBType().equals("oracle"))
			            sql = "update workflow_nodelink set condition=empty_clob() , conditioncn=empty_clob() where id="+nlid;
	                statement.setStatementSql(sql);
	                statement.executeUpdate();
			    }
			}
			if(null!=statement){
			statement.close();
			}
			}
			//删除与该字段相关的出口条件
		
			//删除节点附加操作
			RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=1 and objid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + fieldid + " or fieldop1id = " + fieldid + " or fieldop2id = " + fieldid + ")" );
			//删除出口附加操作
			RecordSetTrans.executeSql("delete from  workflow_addinoperate where isnode=0 and objid in (select t1.id from  workflow_nodelink t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and (fieldid =" + fieldid + " or fieldop1id = " + fieldid + " or fieldop2id = " + fieldid + ")");
			//删除由自定义字段产生的操作人，主要是由浏览框带来的
			RecordSetTrans.executeSql("delete from  workflow_groupdetail where type in(5,6,31,32,7,38,42,43,8,33,9,10,47,34,11,12,13,35,14,15,44,45,46,16) and groupid in(select id from workflow_nodegroup where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ")) and objid=" + fieldid);
			//删除节点上哪些字段可视、可编辑、必输的信息
			RecordSetTrans.executeSql("delete from  workflow_nodeform where nodeid in (select t1.nodeid from  workflow_flownode t1, workflow_base t2 where t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + formid + ") and fieldid= " + fieldid);
			//删除特殊字段的信息
			RecordSetTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid =" + fieldid);
			RecordSetTrans.execute("update workflow_billfield set childfieldid=0 where childfieldid="+fieldid);//如果被删除字段是子字段，则需要修改

						
			//如果删除的是明细表最后一个字段，则将该表同时删除
			if(viewtype.equals("1")){
			  RecordSetTrans.executeSql("select * from workflow_billfield where billid="+formid+" and detailtable='"+tablename+"'");
			  if(!RecordSetTrans.next()){
			  	RecordSetTrans.executeSql("drop table "+tablename);
			  	RecordSetTrans.executeSql("delete from Workflow_billdetailtable where billid="+formid+" and tablename='"+tablename+"'");
			  }
		  }	
		}
		RecordSetTrans.commit();
		response.sendRedirect("/workflow/form/editformfield.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=0");
		
	}catch(Exception e){
		RecordSetTrans.rollback();
	}
	
}else if(src.equals("editfieldlabel")){
	String formid = Util.null2String(request.getParameter("formid"));
	String changefieldids = Util.null2String(request.getParameter("changefieldids"));
	String isfromformid = Util.null2String(request.getParameter("isfromformid"));
	RecordSetTrans.setAutoCommit(false);
	try{
		ArrayList changefieldidsArray = Util.TokenizerString(changefieldids,",");
		for(int i=0;i<changefieldidsArray.size();i++){
			String fieldid = (String)changefieldidsArray.get(i);
			String fieldnameCN = Util.null2String(request.getParameter("field_"+fieldid+"_CN"));
			String fieldnameEn = Util.null2String(request.getParameter("field_"+fieldid+"_En"));
			String fieldnameTW = Util.null2String(request.getParameter("field_"+fieldid+"_TW"));
			fieldnameCN = Util.StringReplace(fieldnameCN, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldnameCN = Util.StringReplace(fieldnameCN, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			fieldnameEn = Util.StringReplace(fieldnameEn, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldnameEn = Util.StringReplace(fieldnameEn, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			fieldnameTW = Util.StringReplace(fieldnameTW, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
			fieldnameTW = Util.StringReplace(fieldnameTW, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
			int lableid = 0;
			if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldnameCN+"' collate Chinese_PRC_CS_AI and languageid=7");
			else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldnameCN+"' and languageid=7");
		  if(RecordSet.next()) lableid = RecordSet.getInt("indexid");//如果字段名称在标签库中存在，取得标签id,以中文为准。
			else{//不存在则生成新的标签id
				lableid = FormManager.getNewIndexId(RecordSetTrans);
			}
			if(lableid!=-1){//更新标签库
				RecordSet.executeSql("delete from HtmlLabelIndex where id="+lableid);
				RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
				RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldnameCN+"')");
				RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameCN+"',7)");//中文
				RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameEn+"',8)");//英文
				RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameTW+"',9)");//繁体
			}
			
			RecordSet.executeSql("update workflow_billfield set fieldlabel="+lableid+" where id="+fieldid);
			
			LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
			
		}
		RecordSetTrans.commit();
	}catch(Exception exception){
		RecordSetTrans.rollback();
	}
	if(!isfromformid.equals("")){
		response.sendRedirect("/workflow/form/editformfield.jsp?formid="+isfromformid+"&isFromMode="+isFromMode+"&ajax=0");
	}else{
		response.sendRedirect("/workflow/form/addformfieldlabel0.jsp?formid="+formid+"&isFromMode="+isFromMode+"&ajax=1");
	}
} else if(src.equalsIgnoreCase("checktablename")){
	response.reset();
	String checkStatus = "-1";	//-1:正常  0:检测表名时出现未知错误   1:表名已存在  2.表名不合法
	String tablename = Util.null2String(request.getParameter("tablename"));
	
	try{
		boolean tableISExists = FormManager.isHaveSameTableInDB(tablename);
		
	    if (tableISExists) {
	    	checkStatus = "1";
	    }else{	//检查表名是否合法(模拟创建表)
	    	try{
	    		boolean createTableSuccess = RecordSet.executeSql("create table " + tablename + "(id varchar(10))");
	    		if(!createTableSuccess){
	    			checkStatus = "2";
	    		}
	    	}finally{
	    		try{
	    			RecordSet.executeSql("drop table " + tablename);
	    		}catch(Exception e){}
	    	}
	    }
	    //Thread.sleep(2000);
	}catch(Exception ep){
		ep.printStackTrace();
		checkStatus = "0";
	}
	out.print(checkStatus);
	return;
}else if(src.equalsIgnoreCase("getDetailTablename")){
	response.reset();
	String maintablename = Util.null2String(request.getParameter("maintablename"));
	String detailtablename = "";
	if(maintablename.startsWith("uf_")){
		maintablename = maintablename.substring(3);
	}
	
	int detailEndIndex = Util.getIntValue(request.getParameter("detailEndIndex"), 1);
	String pageNoSaveTablenames = Util.null2String(request.getParameter("pageNoSaveTablenames")).toLowerCase();
	
	for(; detailEndIndex <Integer.MAX_VALUE; detailEndIndex++){
		detailtablename = maintablename + "_dt" + detailEndIndex;
		if(pageNoSaveTablenames.indexOf(detailtablename.toLowerCase() + ",") == -1){
			String testTablename = maintablename.startsWith("uf_") ? ("uf_" + detailtablename) : detailtablename;
			boolean tableISExists = FormManager.isHaveSameTableInDB(testTablename);
			if(!tableISExists){
				break;
			}
		}
	}
	out.print(detailtablename);
}
%>