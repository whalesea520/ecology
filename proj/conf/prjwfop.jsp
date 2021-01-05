<%@page import="weaver.workflow.action.WorkflowActionManager"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeMap"%>
<%@page import="weaver.workflow.workflow.WorkflowBillComInfo"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.UUID"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="PrjWfConfComInfo" class="weaver.proj.util.PrjWfConfComInfo" scope="page" />
<jsp:useBean id="PrjWfUtil" class="weaver.proj.util.PrjWfUtil" scope="page" />

<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjFieldComInfo" scope="page" />
<jsp:useBean id="CptCardGroupComInfo" class="weaver.proj.util.PrjCardGroupComInfo" scope="page" />
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page" />

<jsp:useBean id="CptFieldComInfo1" class="weaver.proj.util.PrjTskFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager1" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="CptCardGroupComInfo1" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />

<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="page"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="formFieldUtil" class="weaver.workflow.form.FormFieldUtil" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<jsp:useBean id="fieldCommon" class="weaver.workflow.field.FieldCommon" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />	
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<%

User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
JSONObject jsonInfo=new JSONObject();

String method = request.getParameter("method");
String id = request.getParameter("id");
String wftype = Util.fromScreen(request.getParameter("wftype"),user.getLanguage());//1,项目创建流程;2,项目审批流程;3,模板审批流程
String wfid = Util.fromScreen(request.getParameter("wfid"),user.getLanguage());
String formid = Util.null2String(request.getParameter("formid"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String isopen = Util.null2String(request.getParameter("isopen"));

String xmjl = Util.null2String(request.getParameter("xmjl"));
String xgxm = Util.null2String(request.getParameter("xgxm"));
String xmmb = Util.null2String(request.getParameter("xmmb"));


String currentDate=TimeUtil.getCurrentDateString();
String currentTime=TimeUtil.getOnlyCurrentTimeString();

if (method.equals("add")){
	String guid1=UUID.randomUUID().toString();
	RecordSet.executeSql("insert into prj_prjwfconf(wftype,wfid,formid,prjtype,isopen,xmjl,xgxm,xmmb,creater,createdate,createtime,lastmoddate,lastmodtime,guid1) "
	+"values('"+wftype+"','"+wfid+"','"+formid+"','"+prjtype+"','"+isopen+"','"+xmjl+"','"+xgxm+"','"+xmmb+"','"+user.getUID()+"','"+currentDate+"','"+currentTime+"','"+currentDate+"','"+currentTime+"','"+guid1+"' ) ");
	RecordSet.execute("select id from prj_prjwfconf where guid1='"+guid1+"' ");
	if(RecordSet.next()){
		String newid=Util.null2String( RecordSet.getString("id"));
		jsonInfo.put("newid", newid);
		
		//auto mapping fields from generated bill
		if( RecordSet.executeSql("select 1 from workflow_bill where id="+formid+" and from_module_='prjwf' ")&&RecordSet.next()){
			String sql="select * from workflow_billfield where billid="+formid;
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String fieldname=RecordSet.getString("fieldname");
				if("manager1".equals(fieldname)){
					fieldname="manager";
				}
				String insertSql="insert into prj_prjwffieldmap(mainid,fieldtype,fieldid,fieldname) values('"+newid+"','"+RecordSet.getString("viewtype")+"','"+RecordSet.getString("id")+"','"+fieldname+"')";
				RecordSet1.executeSql(insertSql);
			}
		}
		
		//项目模板审批,只允许1个启用
		if("3".equals(wftype)&&"1".equals(isopen)){
			String sql="update prj_prjwfconf set isopen='0' where id not in("+newid+") and wftype='3' ";
			RecordSet.executeSql(sql);
			RecordSet.executeSql("UPDATE ProjTemplateMaint SET wfid="+wfid+" WHERE id=1");
		}else if("2".equals(wftype)&&"1".equals(isopen)){
			//项目审批,联动
			String sql11="update prj_prjwfconf set isopen='0' where id not in("+newid+") and prjtype='"+prjtype+"' ";
			RecordSet.executeSql(sql11);
			String sql="update Prj_ProjectType set wfid='"+wfid+"' where id='"+prjtype+"' ";
			RecordSet.executeSql(sql);

		}
		
		
	}
	
	PrjWfConfComInfo.removeCache();
	
	out.print(jsonInfo.toString());
}
else if (method.equals("edit")){
	String sql="";
	String sql1="select 1 from prj_prjwfconf where formid='"+formid+"' and id="+id+" and wftype='"+wftype+"' ";
	RecordSet.executeSql(sql1);
	if(RecordSet.next()){
		sql="update prj_prjwfconf set isopen='"+isopen+"',wfid='"+wfid+"',formid='"+formid+"',prjtype='"+prjtype+"',lastmoddate='"+currentDate+"',lastmodtime='"+currentTime+"' where id="+id+" and wftype='"+wftype+"' ";
	}else{
		sql="update prj_prjwfconf set isopen='"+isopen+"',wfid='"+wfid+"',formid='"+formid+"',prjtype='"+prjtype+"',xmjl='"+xmjl+"',xgxm='"+xgxm+"',xmmb='"+xmmb+"',lastmoddate='"+currentDate+"',lastmodtime='"+currentTime+"' where id="+id+" and wftype='"+wftype+"' ";
	}
	RecordSet.executeSql(sql);
	if("3".equals(wftype)&&"1".equals(isopen)){//项目模板审批,只允许1个启用
		sql="update prj_prjwfconf set isopen='0' where id not in("+id+") and wftype='3' ";
		RecordSet.executeSql(sql);
		RecordSet.executeSql("UPDATE ProjTemplateMaint SET wfid="+wfid+" WHERE id=1");
	}else if("2".equals(wftype)){
		//项目审批,联动
		if("1".equals(isopen)){
			String sql11="update prj_prjwfconf set isopen='0' where id not in("+id+") and prjtype='"+prjtype+"' ";
			RecordSet.executeSql(sql11);
			sql="update Prj_ProjectType set wfid='"+wfid+"' where id='"+prjtype+"' ";
			RecordSet.executeSql(sql);
		}else{
			sql="update Prj_ProjectType set wfid=null where id='"+prjtype+"' and wfid='"+wfid+"' ";
			RecordSet.executeSql(sql);
		}


	}
	PrjWfConfComInfo.removeCache();

	out.print(jsonInfo.toString());
}else if (method.equals("delete")){
	String actname="PrjGenerateAction";
	if("2".equals(wftype)){
		actname="PrjApproveAction";
	}else if("3".equals(wftype)){
		actname="PrjTemplateApproveAction";
	}
	String delwfid= PrjWfConfComInfo.getWfid(id);
	String delprjtype= PrjWfConfComInfo.getPrjtype(id);
	//清掉action
	PrjWfUtil.clearActionSet(new int[]{Util.getIntValue(delwfid ,0)}, new String[]{actname});
	
	RecordSet.executeSql("delete prj_prjwffieldmap where mainid= "+id);
	RecordSet.executeSql("delete prj_prjwfconf where id="+id);
	if("3".equals(wftype)){
		RecordSet.executeSql("UPDATE ProjTemplateMaint SET wfid=null WHERE id=1 and wfid='"+delwfid+"'");
	}else if("2".equals(wftype)){
		RecordSet.executeSql("UPDATE Prj_ProjectType SET wfid=null WHERE id='"+delprjtype+"' and wfid='"+delwfid+"'");
	}

	PrjWfConfComInfo.removeCache();
	
	out.print(jsonInfo.toString());
}else if (method.equals("batchdelete")){
	
	JSONArray referencedArr = new JSONArray() ;
	
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr= Util.TokenizerString2(ids, ",");
	for(int i=0;i<arr.length;i++){
		String id1 = ""+Util.getIntValue( arr[i]);
		
		String actname="PrjGenerateAction";
		if("2".equals(wftype)){
			actname="PrjApproveAction";
		}else if("3".equals(wftype)){
			actname="PrjTemplateApproveAction";
		}
		String delwfid= PrjWfConfComInfo.getWfid(id1);
		String delprjtype= PrjWfConfComInfo.getPrjtype(id1);
		//清掉action
		PrjWfUtil.clearActionSet(new int[]{Util.getIntValue(delwfid ,0)}, new String[]{actname});
		
	    RecordSet.executeSql("delete prj_prjwffieldmap where mainid= "+id1);
	    RecordSet.executeSql("delete prj_prjwfconf where id= "+id1);
		if("3".equals(wftype)){
			RecordSet.executeSql("UPDATE ProjTemplateMaint SET wfid=null WHERE id=1 and wfid='"+delwfid+"'");
		}else if("2".equals(wftype)){
			RecordSet.executeSql("UPDATE Prj_ProjectType SET wfid=null WHERE id='"+delprjtype+"' and wfid='"+delwfid+"'");
		}
	}
	
	PrjWfConfComInfo.removeCache();
	
	out.print(jsonInfo.toString());
    
}else if("toggleuse".equals(method)){
	String sql="update prj_prjwfconf set isopen='"+isopen+"' where id="+id;
	RecordSet.executeSql(sql);
	if("3".equals(wftype)){//项目模板审批只允许1个启用
		if("1".equals(isopen)){
			sql="update prj_prjwfconf set isopen='0' where id not in("+id+") and wftype='3' ";
			RecordSet.executeSql(sql);
			RecordSet.executeSql("UPDATE ProjTemplateMaint SET isNeedAppr='1',wfid="+wfid+" WHERE id=1");
		}else{
			sql="select t1.*,t2.formid from ProjTemplateMaint t1, workflow_base t2 where t1.wfid=t2.id and t2.formid=152 ";
			RecordSet.executeSql(sql);
			if(!RecordSet.next()){
				sql="UPDATE ProjTemplateMaint SET wfid='0',isNeedAppr='0' WHERE id=1";
				RecordSet.executeSql(sql);
			}
			
		}
		
	}else if("2".equals(wftype)){
		//项目审批,联动
		String delwfid= PrjWfConfComInfo.getWfid(id);
		String delprjtype= PrjWfConfComInfo.getPrjtype(id);
		if("1".equals(isopen)){
			String sql11="update prj_prjwfconf set isopen='0' where id not in("+id+") and prjtype='"+delprjtype+"' ";
			RecordSet.executeSql(sql11);
			sql="update Prj_ProjectType set wfid='"+delwfid+"' where id='"+delprjtype+"' ";
			RecordSet.executeSql(sql);
		}else{
			sql="update Prj_ProjectType set wfid=null where id='"+delprjtype+"' and wfid='"+delwfid+"' ";
			RecordSet.executeSql(sql);
		}
	}
	
	PrjWfConfComInfo.removeCache();
	out.print(jsonInfo.toString());
}else if("genform".equalsIgnoreCase(method)){
	
	boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
	boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
	boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;
	//新建表单采用与单据相同的模式 TD8730 MYQ修改
  	int formid1 = -1;
	int tmpFormid = formid1;
  	String from = "prjwf";
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
  		jsonInfo.put("errmsg", ""+SystemEnv.getHtmlLabelNames("83791",user.getLanguage()));
  		out.print(jsonInfo.toString());
  		return;
  	}
  	//同名验证 结束 TD10194
	
  	String formdes = Util.null2String(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formdes = Util.toHtmlForSplitPage(formdes);
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
  	int subCompanyId3 = Util.getIntValue(request.getParameter("subcompanyid3"),-1);
  	formid1 = FormManager.getNewFormId();
  	String formtable_main;
  	formtable_main = "formtable_main_"+formid1*(-1);
  	if(formid1<-1){
  		boolean success = false;
  		formname = formname.replaceAll("<","＜").replaceAll(">","＞");
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
		  		RecordSetTrans.executeSql("select dftsubcomid from SystemSet");
		  		if(RecordSetTrans.next()) subcompanyid = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
		  		if(subcompanyid==-1){
		  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
		  			if(RecordSetTrans.next()) subcompanyid = RecordSetTrans.getInt("id");
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
  			RecordSetTrans.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3) values("+formid1+",'"+namelabelid+"','"+formtable_main+"','mainid','"+formdes+"','"+subcompanyid+"','"+subCompanyId3+"')");
  			String dbType = RecordSet.getDBType();
  			if("oracle".equals(dbType)){//创建表单主表，明细表的创建在新建字段的时候如果有明细字段则创建明细表
	  			RecordSetTrans.executeSql("create table " + formtable_main + "(id integer primary key not null, requestId integer)");
	  		}else{
	  			RecordSetTrans.executeSql("create table " + formtable_main + "(id int IDENTITY(1,1) primary key CLUSTERED, requestId integer)");
	  		}
  			RecordSetTrans.commit();
  			if("oracle".equals(dbType)){//主表id自增长
	  			RecordSet.executeSql("create sequence "+formtable_main+"_Id start with 1 increment by 1 nomaxvalue nocycle");
	  			RecordSet.setChecksql(false);
	  			RecordSet.executeSql("CREATE OR REPLACE TRIGGER "+formtable_main+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main+"_Id.nextval into :new.id from dual; end;");
	  		}
			  LabelComInfo.addLabeInfoCache(""+namelabelid);//往缓存中添加表单名称的标签
			  BillComInfo.addBillCache(""+formid1);
			  WorkflowBillComInfo workflowBillComInfo=new WorkflowBillComInfo();
			  workflowBillComInfo.addWorkflowBillCache(String.valueOf(formid1));
			  
			 
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
	  			FormManager.setFormInfoByTemplate(formid1, oldformid);
	  		}
	  		//tagtag更新项目模块标志
	  		RecordSet.executeSql("update workflow_bill set from_module_='prjwf' where id="+formid1);
  		}
  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
  			RecordSet.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
  		}
  	}
  	
	//tagtag 生成主表字段和明细字段============begin=============================
	//批量添加字段
	if(formid1<-1){
		char flag=2;
	  	RecordSetTrans=new RecordSetTrans();
	  	RecordSetTrans.setAutoCommit(false);
	  	
	  	//生成主表字段
		TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(""+prjtype);
		CptCardGroupComInfo.setTofirstRow();
		try{
			while(CptCardGroupComInfo.next()){
				String groupid=CptCardGroupComInfo.getGroupid();
				TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
				if(openfieldMap==null||openfieldMap.size()==0){
					continue;
				}
				int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
				if(!openfieldMap.isEmpty()){
					Iterator it=openfieldMap.entrySet().iterator();
					while(it.hasNext()){
						Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
						String k= entry.getKey();
						JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
						int fieldlabel=v.getInt("fieldlabel");
						String fieldid=v.getString("id");
						String fieldname=v.getString("fieldname");
						if("protemplateid".equalsIgnoreCase(fieldname)
							||"status".equalsIgnoreCase(fieldname)
								){
							continue;
						}
						if("manager".equalsIgnoreCase(fieldname)){
							fieldname="manager1";
						}
						String fielddbtype=v.getString("fielddbtype");
						if(isoracle){
							if("text".equalsIgnoreCase(fielddbtype)){
								fielddbtype="varchar2(4000)";
							}else if(fielddbtype.indexOf("varchar(")!=-1){
								fielddbtype=fielddbtype.replace("varchar(", "varchar2(");
							}
						}
						String fieldhtmltype=v.getString("fieldhtmltype");
						String type=v.getString("type");
						String dsporder=v.getString("dsporder");
						String textheight=v.getString("textheight");
						String imgwidth=v.getString("imgwidth");
						String imgheight=v.getString("imgheight");
						String fieldkind=v.getString("fieldkind");
						//更新主表结构
						
						String _fielddbtype = "";//字段数据库类型 
						if(fieldhtmltype.equals("3")){
							int temptype = Util.getIntValue(type);
						  	if(temptype==118){
						  		if(isoracle) fielddbtype="varchar2(200)";
					              else fielddbtype="varchar(200)";
						  	}
							if(temptype==161||temptype==162||temptype==256||temptype==257){
								if(temptype==161||temptype==256){
									if(isoracle) _fielddbtype="varchar2(1000)";
									else if(isdb2) _fielddbtype="varchar(1000)";
									else _fielddbtype="varchar(1000)";
								}else{
									if(isoracle) _fielddbtype="varchar2(4000)";
									else if(isdb2) _fielddbtype="varchar(2000)";
									else _fielddbtype="text";
								}
							}
							if(temptype==224||temptype==225){
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
						  }
				  
						  if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+_fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+_fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+_fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+fielddbtype);
						  }else{
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+fielddbtype);
						  }
						
						
						String insertsql="INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight,places,qfws) "+
						  " VALUES ("+formid1+",'"+fieldname+"','"+fieldlabel+"','"+fielddbtype+"','"+fieldhtmltype+"','"+type+"','"+dsporder+"',"+0+",'','"+textheight+"','','','"+imgwidth+"','"+imgheight+"','','')";
						RecordSetTrans.executeSql(insertsql);
						//字段类型是下拉框
						String curfieldid = "";
						RecordSetTrans.executeSql("select max(id) as id from workflow_billfield");
					    if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
					    if(fieldhtmltype.equals("5")){
					    	if("2".equals(fieldkind)){
								rs.executeSql("select * from cus_selectitem where fieldid = "
										+ fieldid + "  order by fieldorder");
							}else{
								rs.executeSql("select * from prj_SelectItem where fieldid in( "
										+" select id from prjDefineField where prjtype=-1 and fieldname in(select fieldname from prjDefineField where id="+fieldid+" )  order by listorder,id");
							}
							
							while (rs.next()) {
								String tmpselectvalue = Util.null2String(rs
										.getString("selectvalue"));
								String tmpselectname = Util.toScreen(
										rs.getString("selectname"), user.getLanguage());
								String curorder=rs.getString("listorder");
								if("2".equals(fieldkind)){
									curorder=rs.getString("fieldorder");
								}
								String isdefault=rs.getString("isdefault");
								if("2".equals(fieldkind)){
									isdefault=rs.getString("prj_isdefault");
								}
								String cancel=rs.getString("cancel");
								
								int isAccordToSubCom_tmp = 0;
								String doccatalog = "";
								String docPath = "";
								String childItem_tmp = "";
								String para=curfieldid+flag+"1"+flag+""+tmpselectvalue+flag+tmpselectname+flag+curorder+flag+isdefault+flag+cancel; 
								RecordSetTrans.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
								
							}
					    	
					    	
					    	
					    }
						
					}
					
				}
				
			}
			RecordSetTrans.commit();
		}catch(Exception e){
			e.printStackTrace();
			jsonInfo.put("errmsg", ""+SystemEnv.getHtmlLabelNames("83793",user.getLanguage()));
			out.print(jsonInfo.toString());
			RecordSetTrans.rollback();
			return;
		}
		
		//生成明细表字段
		boolean isexist = false;
		TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap1=CptFieldComInfo1.getGroupFieldMap();
		CptCardGroupComInfo1.setTofirstRow();
		RecordSetTrans=new RecordSetTrans();
	  	RecordSetTrans.setAutoCommit(false);
	  	String formtable_main_dt1=formtable_main+"_dt1";
	  	try{
	  		String tableSql="create table " + formtable_main_dt1 + "(id int IDENTITY(1,1) primary key CLUSTERED,mainid int)";
	  		if(isoracle){
	  			tableSql="create table " + formtable_main_dt1 + "(id integer primary key not null,mainid integer)";
		  	}
	  		RecordSetTrans.executeSql(tableSql);
	 		//插入表单明细表信息workflow_billdetailtable
	 		RecordSetTrans.executeSql("INSERT INTO workflow_billdetailtable(billid,tablename,orderid) values("+formid1+",'"+formtable_main_dt1+"',"+1+")");
	  		
	  		while(CptCardGroupComInfo1.next()){
				String groupid=CptCardGroupComInfo1.getGroupid();
				TreeMap<String,JSONObject> openfieldMap= groupFieldMap1.get(groupid);
				if(openfieldMap==null||openfieldMap.size()==0){
					continue;
				}
				int grouplabel=Util.getIntValue( CptCardGroupComInfo1.getLabel(),-1);
				if(!openfieldMap.isEmpty()){
					Iterator it=openfieldMap.entrySet().iterator();
					while(it.hasNext()){
						Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
						String k= entry.getKey();
						JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
						int fieldlabel=v.getInt("fieldlabel");
						String fieldid=v.getString("id");
						String fieldname=v.getString("fieldname");
						if("parentid".equalsIgnoreCase(fieldname)
								||"prjid".equalsIgnoreCase(fieldname)
								||"actualbegindate".equalsIgnoreCase(fieldname)
								||"actualenddate".equalsIgnoreCase(fieldname)
								||"realmandays".equalsIgnoreCase(fieldname)
								||"finish".equalsIgnoreCase(fieldname)
								||"prefinish".equalsIgnoreCase(fieldname)
								||"accessory".equalsIgnoreCase(fieldname)
									){
								continue;
						}
						String fielddbtype=Util.null2String( v.getString("fielddbtype"));
						if(isoracle){
							if("text".equalsIgnoreCase(fielddbtype)){
								fielddbtype="varchar2(4000)";
							}else if(fielddbtype.indexOf("varchar(")!=-1){
								fielddbtype=fielddbtype.replace("varchar(", "varchar2(");
							}
						}
						String fieldhtmltype=v.getString("fieldhtmltype");
						String type=v.getString("type");
						String dsporder=v.getString("dsporder");
						String textheight=v.getString("textheight");
						String imgwidth=v.getString("imgwidth");
						String imgheight=v.getString("imgheight");
						//更新明细表表结构
						String _fielddbtype = "";//字段数据库类型 
						if(fieldhtmltype.equals("3")){
							int temptype = Util.getIntValue(type);
						  	if(temptype==118){
						  		if(isoracle) fielddbtype="varchar2(200)";
					              else fielddbtype="varchar(200)";
						  	}
							if(temptype==161||temptype==162||temptype==256||temptype==257){
								if(temptype==161||temptype==256){
									if(isoracle) _fielddbtype="varchar2(1000)";
									else if(isdb2) _fielddbtype="varchar(1000)";
									else _fielddbtype="varchar(1000)";
								}else{
									if(isoracle) _fielddbtype="varchar2(4000)";
									else if(isdb2) _fielddbtype="varchar(2000)";
									else _fielddbtype="text";
								}
							}
							if(temptype==224||temptype==225){
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
						  }
						  
						  if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+_fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+_fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+_fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+fielddbtype);
						  }else{
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+fielddbtype);
						  }
						
						
						String insertsql="INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight,places,qfws) "+
						  " VALUES ("+formid1+",'"+fieldname+"',"+fieldlabel+",'"+fielddbtype+"',"+fieldhtmltype+","+type+","+dsporder+","+1+",'"+formtable_main_dt1+"',"+textheight+",'','',"+imgwidth+","+imgheight+",'','')";
						RecordSetTrans.executeSql(insertsql);
						//字段类型是下拉框
						String curfieldid = "";
						RecordSetTrans.executeSql("select max(id) as id from workflow_billfield");
					    if(RecordSetTrans.next()) curfieldid = RecordSetTrans.getString("id");
					    if(fieldhtmltype.equals("5")){
							rs.executeSql("select * from prjtsk_SelectItem where fieldid ="+fieldid+"   order by listorder,id");
							while (rs.next()) {
								String tmpselectvalue = Util.null2String(rs
										.getString("selectvalue"));
								String tmpselectname = Util.toScreen(
										rs.getString("selectname"), user.getLanguage());
								String curorder=rs.getString("listorder");
								String isdefault=rs.getString("isdefault");
								String cancel=rs.getString("cancel");
								
								int isAccordToSubCom_tmp = 0;
								String doccatalog = "";
								String docPath = "";
								String childItem_tmp = "";
								String para=curfieldid+flag+"1"+flag+""+tmpselectvalue+flag+tmpselectname+flag+curorder+flag+isdefault+flag+cancel; 
								RecordSetTrans.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
								
							}
						
					}
				
	  		}
				}
	  		}
	  		
	  		
	  		
	  		if(isoracle){
				RecordSet.executeSql("select tablename from Workflow_billdetailtable where billid="+formid1);
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
									rs2.executeSql("select  1 from user_sequences where upper(sequence_name)=upper('"+tempdetailtablename+"_Id')");
									if(rs2.next()){
										rs2.executeSql("drop sequence "+tempdetailtablename+"_Id");
									}
								}catch(Exception e){}
								rs2.executeSql("create sequence "+tempdetailtablename+"_Id start with "+maxid_tmp+" increment by 1 nomaxvalue nocycle");
								rs2.setChecksql(false);
								rs2.executeSql("CREATE OR REPLACE TRIGGER "+tempdetailtablename+"_Id_Tr before insert on "+tempdetailtablename+" for each row begin select "+tempdetailtablename+"_Id.nextval into :new.id from dual; end;");
						}
				}
		}
	  		
	  		RecordSetTrans.commit();
	  	}catch(Exception e){
	  		jsonInfo.put("errmsg", ""+SystemEnv.getHtmlLabelNames("83794",user.getLanguage()));
			out.print(jsonInfo.toString());
			RecordSetTrans.rollback();
			return;
	  	}
	  	
	}
	//tagtag 生成主表字段和明细字段============end=============================
	
	jsonInfo.put("newformid", formid1);
	PrjWfConfComInfo.removeCache();
	out.print(jsonInfo.toString());
	
}else if("saveact".equalsIgnoreCase(method)){//保存action
	
	if("2".equals( wftype)||"3".equals( wftype)){//项目审批action,项目模板审批
		String mainid =""+ Util.getIntValue(request.getParameter("mainid"),0);
		String dtinfo = Util.null2String(request.getParameter("dtinfo"));
		dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
		String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
		if(keepgroupids.endsWith(",")){
			keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
		}
		if("".equals(keepgroupids)){
			keepgroupids="-1";
		}
		RecordSet.executeSql("delete from prj_prjwfactset where id not in("+keepgroupids+") and mainid="+mainid);
		net.sf.json.JSONArray dtJsonArray=net.sf.json.JSONArray.fromObject(dtinfo);
		if(dtJsonArray!=null&&dtJsonArray.size()>0){
			for(int i=0;i<dtJsonArray.size();i++){
				net.sf.json.JSONArray dtJsonArray2= net.sf.json.JSONArray.fromObject( dtJsonArray.get(i));
				if(dtJsonArray2!=null&&dtJsonArray2.size()>=6){
					int objid=Util.getIntValue(dtJsonArray2.getJSONObject(1).getString("objid").trim(),0);
					int customervalue=Util.getIntValue(dtJsonArray2.getJSONObject(2).getString("customervalue"),0);
					int isnode=Util.getIntValue(dtJsonArray2.getJSONObject(3).getString("isnode"),0);
					int groupid=Util.getIntValue(dtJsonArray2.getJSONObject(4).getString("actionChecbox"),0);
					int isTriggerReject=Util.getIntValue(dtJsonArray2.getJSONObject(5).getString("isTriggerReject"),0);
					
					String sql="";
					if(groupid>0){
						sql="update prj_prjwfactset set objid='"+objid+"',customervalue='"+customervalue+"',isnode='"+isnode+"',isTriggerReject='"+isTriggerReject+"' where id="+groupid;
					}else{
						sql="insert into prj_prjwfactset(objid,customervalue,isnode,isTriggerReject,mainid) values('"+objid+"','"+customervalue+"','"+isnode+"','"+isTriggerReject+"','"+mainid+"') ";
					}
					RecordSet.executeSql(sql);
					
				}
			}
		}
		String actname="PrjApproveAction";
		if("3".equals(wftype)){
			actname="PrjTemplateApproveAction";
		}
		RecordSet.executeSql("select * from prj_prjwfactset where mainid="+mainid);
		int counts= RecordSet.getCounts();
		if(counts>0){
			int[]nodeIdsArray=new int[counts];
			int[]workflowid=new int[counts];
			int[]isnode=new int[counts];
			int[]ispreadd=new int[counts];
			String[]customervalue=new String[counts];
			int[]isTriggerReject=new int[counts];
			int i=0;
			while(RecordSet.next()){
				nodeIdsArray[i]=Util.getIntValue( RecordSet.getString("objid"),0);
				isTriggerReject[i]=Util.getIntValue( RecordSet.getString("isTriggerReject"),0);
				workflowid[i]=Util.getIntValue(wfid ,0);
				isnode[i]=Util.getIntValue( RecordSet.getString("isnode"),0);
				ispreadd[i]=isnode[i]==2?1:0;
				isnode[i]=isnode[i]>0?1:0;
				isTriggerReject[i]=isnode[i]==0?0:isTriggerReject[i];
				customervalue[i]=actname;
				i++;
			}
			PrjWfUtil.saveActionSet(nodeIdsArray, workflowid, isnode, ispreadd, customervalue, isTriggerReject);
			
			
		}else{
			//清掉action
			PrjWfUtil.clearActionSet(new int[]{Util.getIntValue(wfid ,0)}, new String[]{actname});
		}
		
		
		
	}else if("1".equals(wftype)){//流程生成项目卡片action
		int objid=Util.getIntValue(Util.null2String(request.getParameter("objid")).trim(),0);
		int isTriggerReject=Util.getIntValue( request.getParameter("isTriggerReject"),0);
		int isnode=Util.getIntValue( request.getParameter("isnode"),0);
		int ispreadd=isnode==2?1:0;
		isnode=isnode>0?1:0;
		isTriggerReject=isnode==0?0:isTriggerReject;
		
		String actname="PrjGenerateAction";
		String sql2="select id from workflowactionset where interfaceid='"+actname+"' and workflowid="+wfid;
		RecordSet.executeSql(sql2);
		while(RecordSet.next()){
			int tmpactid=RecordSet.getInt("id");
			new WorkflowActionManager().doDeleteWsAction(tmpactid);
		}
		PrjWfUtil.saveActionSet(new int[]{objid} ,new int[]{Util.getIntValue( wfid,0)}, new int[]{isnode}, new int[]{ispreadd}, new String[]{actname}, new int[]{isTriggerReject});
		
	}
	
	PrjWfConfComInfo.removeCache();
	out.println(jsonInfo.toString());
}else if("fieldmap".equalsIgnoreCase(method)){//字段配置
	if("1".equals(wftype)){//项目创建字段配置
		RecordSetTrans.setAutoCommit(false);
		try{
			RecordSetTrans.executeSql("delete prj_prjwffieldmap where mainid="+id);
			//1,项目信息
			if(Util.getIntValue(prjtype)<=0){
				prjtype="-1";
			}
			TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(""+prjtype);
			CptCardGroupComInfo.setTofirstRow();
			while(CptCardGroupComInfo.next()){
				String groupid=CptCardGroupComInfo.getGroupid();
				TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
				if(openfieldMap==null||openfieldMap.size()==0){
					continue;
				}
				int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
				if(!openfieldMap.isEmpty()){
					Iterator it=openfieldMap.entrySet().iterator();
					while(it.hasNext()){
						Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
						String k= entry.getKey();
						JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
						int fieldlabel=v.getInt("fieldlabel");
						String fieldid=v.getString("id");
						String fieldname=v.getString("fieldname");
						if("protemplateid".equalsIgnoreCase(fieldname)
							||"status".equalsIgnoreCase(fieldname)
								){
							continue;
						}
						int billfieldid=Util.getIntValue(request.getParameter("prj_"+fieldname),0);
						RecordSetTrans.executeSql("insert into prj_prjwffieldmap(mainid,fieldtype,fieldid,fieldname) values('"+id+"','0','"+billfieldid+"','"+fieldname+"')");
						
					}
				}
			}
				
			//2,任务信息
			TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap1=CptFieldComInfo1.getGroupFieldMap();
			CptCardGroupComInfo1.setTofirstRow();
			while(CptCardGroupComInfo1.next()){
				String groupid=CptCardGroupComInfo1.getGroupid();
				TreeMap<String,JSONObject> openfieldMap= groupFieldMap1.get(groupid);
				if(openfieldMap==null||openfieldMap.size()==0){
					continue;
				}
				int grouplabel=Util.getIntValue( CptCardGroupComInfo1.getLabel(),-1);
				if(!openfieldMap.isEmpty()){
					Iterator it=openfieldMap.entrySet().iterator();
					while(it.hasNext()){
						Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
						String k= entry.getKey();
						JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
						int fieldlabel=v.getInt("fieldlabel");
						String fieldid=v.getString("id");
						String fieldname=v.getString("fieldname");
						if("parentid".equalsIgnoreCase(fieldname)
								||"prjid".equalsIgnoreCase(fieldname)
								||"actualbegindate".equalsIgnoreCase(fieldname)
								||"actualenddate".equalsIgnoreCase(fieldname)
								||"realmandays".equalsIgnoreCase(fieldname)
								||"finish".equalsIgnoreCase(fieldname)
								||"prefinish".equalsIgnoreCase(fieldname)
								||"accessory".equalsIgnoreCase(fieldname)
									){
								continue;
						}
						
						int billfieldid=Util.getIntValue(request.getParameter("tsk_"+fieldname),0);
						RecordSetTrans.executeSql("insert into prj_prjwffieldmap(mainid,fieldtype,fieldid,fieldname) values('"+id+"','1','"+billfieldid+"','"+fieldname+"')");
					}
				}
			}
			
			
			RecordSetTrans.commit();
		}catch(Exception e){
			RecordSetTrans.rollback();
		}
	
	
		
	}else if("2".equals(wftype)){
		int xmjl1=Util.getIntValue( request.getParameter("prjapprove_manager"),0);
		int xgxm1=Util.getIntValue( request.getParameter("prjapprove_relatedprjid"),0);
		RecordSet.executeSql("update prj_prjwfconf set xmjl='"+xmjl1+"',xgxm='"+xgxm1+"' where id="+id);
	}else if("3".equals(wftype)){
		int xmmb1=Util.getIntValue( request.getParameter("prjtemplate_prjtemplate"),0);
		RecordSet.executeSql("update prj_prjwfconf set xmmb='"+xmmb1+"' where id="+id);
	}
	
	PrjWfConfComInfo.removeCache();
	
	out.println(jsonInfo.toString());
}else if("checkwfexists".equalsIgnoreCase(method)){//检查重复流程配置
	RecordSet.executeSql("select 1 from prj_prjwfconf t where t.wfid="+wfid+" and t.prjtype='"+prjtype+"' and t.wftype="+wftype+" and id not in("+Util.getIntValue(id,0)+")");
	if(RecordSet.next()){
		jsonInfo.put("errmsg", ""+SystemEnv.getHtmlLabelNames("83795",user.getLanguage()));
	}
	out.println(jsonInfo.toString());
}

else {
	
	out.println(jsonInfo.toString());
}

%>
