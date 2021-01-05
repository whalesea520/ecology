<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.workflow.form.FormManager"%>
<%@page import="weaver.hrm.moduledetach.ManageDetachComInfo"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.workflow.workflow.BillComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowBillComInfo"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.workflow.selectItem.SelectItemManager"%>
<%@page import="weaver.workflow.form.FormFieldUtil"%>
<%@page import="weaver.hrm.attendance.dao.WorkflowBillfieldDao"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="weaver.hrm.attendance.domain.WorkflowBillfield"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.workflow.workflow.WorkflowAllComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo2"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

boolean isoracle = (rs.getDBType()).equals("oracle") ;
boolean isdb2 = (rs.getDBType()).equals("db2") ;
boolean issqlserver = (rs.getDBType()).equals("sqlserver") ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2);

String operation = Util.null2String(request.getParameter("operation"));

if("fnaWfCreat_doSave".equals(operation)){//初始化表单
  	RecordSetTrans rst = new RecordSetTrans();
  	FormManager formManager = new FormManager();
  	ManageDetachComInfo manageDetachComInfo = new ManageDetachComInfo();
  	LabelComInfo labelComInfo = new LabelComInfo();
  	BillComInfo billComInfo = new BillComInfo();
  	
	String creatType = Util.null2String(request.getParameter("creatType")).trim();
	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), -1);
	String formName = Util.null2String(request.getParameter("formName")).trim();
	int isFnaFeeDtl = Util.getIntValue(request.getParameter("isFnaFeeDtl"), 0);
	int enableRepayment = Util.getIntValue(request.getParameter("enableRepayment"), 0);
	
  	int subCompanyId3 = Util.getIntValue(request.getParameter("subcompanyid3"),-1);
    String appid = Util.null2String(request.getParameter("appid"));
  	String formdes = Util.null2String(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞");
  	formdes = Util.toHtmlForSplitPage(formdes);
	
	int formid = 0;
	int fnaFeeWfInfoId = 0;

	String formtable_main = "";
	String formtable_main_fm = "";
	if(true){
		//新建表单
	  	String formname = formName;
	  	formname = formname.replaceAll("<","＜").replaceAll(">","＞");
	  	formname = Util.toHtmlForSplitPage(formname);

	  	//同名验证 开始 TD10194
	  	boolean issamename = false;
	  	rs.executeSql("select namelabel from workflow_bill");
	    while(rs.next()){//新表单名和单据名
	  	    int namelabel = Util.getIntValue(Util.null2String(rs.getString("namelabel")),0);
	  	    if(namelabel!=0){
	  	        if(formname.equals(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage()))){
	  	            issamename = true;
	  	            break;
	  	        }
	  	    }
	  	}
	    if(!issamename){
		    rs.executeSql("select 1 from workflow_formbase where formname = '"+StringEscapeUtils.escapeSql(formname)+"'");
		    if(rs.next()){//旧表单名
				issamename = true;
		  	}
	    }
	    if(issamename){
	  		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(22750,user.getLanguage()))+"}");//表单名称已存在
	  		out.flush();
	  		return;
	    }
	  	//同名验证 结束 TD10194
	  	
  		boolean success = false;
  		try{
  		  	formid = formManager.getNewFormId();
  	  		formtable_main = "formtable_main_"+Math.abs(formid);
  	  		formtable_main_fm = "fm_"+Math.abs(formid);
  	  		
  	  		rst.setChecksql(false);
  	  		rst.setAutoCommit(false);
  	  		
		  	int namelabelid = -1;
		  	if(issqlserver){
		  		rst.executeSql("select indexid from HtmlLabelInfo "+
		  				" where labelname='"+StringEscapeUtils.escapeSql(formname)+"' collate Chinese_PRC_CS_AI "+
		  				" and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  	}else{
		  		rst.executeSql("select indexid from HtmlLabelInfo "+
		  				" where labelname='"+StringEscapeUtils.escapeSql(formname)+"' "+
		  				" and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		  	}
		  	if(rst.next()){
		  		namelabelid = rst.getInt("indexid");//如果表单名称在标签库中存在，取得标签id
		  	}else{
		  		namelabelid = formManager.getNewIndexId(rst);//生成新的标签id
			  	if(namelabelid!=-1){//更新标签库
			  		rst.executeSql("delete from HtmlLabelIndex where id="+namelabelid);
			  		rst.executeSql("delete from HtmlLabelInfo where indexid="+namelabelid);
			  		rst.executeSql("INSERT INTO HtmlLabelIndex values("+namelabelid+",'"+StringEscapeUtils.escapeSql(formname)+"')");
			  		rst.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+StringEscapeUtils.escapeSql(formname)+"',7)");
			  		rst.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+StringEscapeUtils.escapeSql(formname)+"',8)");
			  		rst.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+StringEscapeUtils.escapeSql(formname)+"',9)");
			  	}
			  }
		  	
		  	if(subcompanyid==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
		  		subcompanyid = Util.getIntValue(manageDetachComInfo.getWfdftsubcomid(), -1);
		  		if(subcompanyid==-1){
		  			rst.executeSql("select min(id) as id from HrmSubCompany");
		  			if(rst.next()){
		  				subcompanyid = rst.getInt("id");
		  			}
		  		}
		  	}
			if(subCompanyId3==-1||subCompanyId3==0){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
		  		subCompanyId3 = Util.getIntValue(manageDetachComInfo.getWfdftsubcomid(), -1);
		  		if(subCompanyId3==-1||subCompanyId3==0){
		  			rst.executeSql("select min(id) as id from HrmSubCompany");
		  			if(rst.next()){
		  				subCompanyId3 = rst.getInt("id");
		  			}
		  		}
		  	}
  			rst.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3) "+
  					" values("+formid+","+namelabelid+",'"+StringEscapeUtils.escapeSql(formtable_main)+"','mainid','"+StringEscapeUtils.escapeSql(formdes)+"',"+subcompanyid+","+subCompanyId3+")");
  			if(isoracle){//创建表单主表，明细表的创建在新建字段的时候如果有明细字段则创建明细表
	  			rst.executeSql("create table " + formtable_main + "(id integer primary key not null, requestId integer)");
	  		}else{
	  			rst.executeSql("create table " + formtable_main + "(id int IDENTITY(1,1) primary key CLUSTERED, requestId integer)");
	  		}
	  		if(!StringHelper.isEmpty(appid)){
	  			rst.executeSql("insert into AppFormInfo(appid,formid)values("+Util.getIntValue(appid, 0)+","+formid+")");
	  		}

  	  		//表单添加字段
  			List<String> tableCreateSql_array = new ArrayList<String>();
  			List<String> detailtable_array = new ArrayList<String>();
  			List<String> tableCreateIndexSql_array = new ArrayList<String>();
  			List<String> tableFieldInitSql_array = new ArrayList<String>();
  			
  			if("borrow".equals(creatType)){//借款流程
  				detailtable_array.add(formtable_main+"_dt1");
  				detailtable_array.add(formtable_main+"_dt2");
  				if(isoracle){
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar2(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add yjhkrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add jkje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add jksy clob");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id integer primary key not null, mainid integer, "+
  							"mx1jklx integer, mx1jkje decimal(15, 2), mx1tzmx varchar2(900), mx1jksm varchar2(900), mx1xghk varchar2(500))");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt2"+" (id integer primary key not null, mainid integer, "+
  							"mx2skfs integer, mx2skje decimal(15, 2), mx2khyh varchar2(300), mx2hm varchar2(200), mx2skzh varchar2(100))");

  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt1_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");
  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt2_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");

  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt1_ID_TR " +
  							" before insert on "+formtable_main+"_dt1 for each row " + 
  							" begin " + 
  							"   select "+formtable_main_fm+"_dt1_ID.nextval into :new.id from dual; " + 
  							" end;");
  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt2_ID_TR " +
  							" before insert on "+formtable_main+"_dt2 for each row " + 
  							" begin " + 
  							"   select "+formtable_main_fm+"_dt2_ID.nextval into :new.id from dual; " + 
  							" end;");
  					
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1jklx)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_1 on "+formtable_main+"_dt2 (mx2skfs)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_2 on "+formtable_main+"_dt2 (mx2khyh)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_3 on "+formtable_main+"_dt2 (mx2hm)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_4 on "+formtable_main+"_dt2 (mx2skzh)");
  					
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar2(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'integer','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'integer','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'integer','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'integer','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'yjhkrq',127065,'char(10)','3',2,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'jkje',1043,'decimal(15,2)','1',3,0,'','1',0,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'jksy',127066,'clob','2',1,0,'','1',4,9.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  						
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1jklx',22138,'integer','5',1,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1jkje',1043,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
  					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tzmx',83190,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1jksm',83354,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1xghk',84626,'varchar2(500)','1',1,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2skfs',83192,'integer','5',1,1,'"+formtable_main+"_dt2','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2skje',17176,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2khyh',17084,'varchar2(300)','1',1,1,'"+formtable_main+"_dt2','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2hm',19804,'varchar2(200)','1',1,1,'"+formtable_main+"_dt2','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2skzh',83191,'varchar2(100)','1',1,1,'"+formtable_main+"_dt2','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  					
  				}else{
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add yjhkrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add jkje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add jksy text");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
  							"mx1jklx int, mx1jkje decimal(15, 2), mx1tzmx varchar(900), mx1jksm varchar(900), mx1xghk varchar(500))");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt2"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
  							"mx2skfs int, mx2skje decimal(15, 2), mx2khyh varchar(300), mx2hm varchar(200), mx2skzh varchar(100))");

  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1jklx)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_1 on "+formtable_main+"_dt2 (mx2skfs)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_2 on "+formtable_main+"_dt2 (mx2khyh)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_3 on "+formtable_main+"_dt2 (mx2hm)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_4 on "+formtable_main+"_dt2 (mx2skzh)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'int','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'int','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'int','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'int','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'yjhkrq',127065,'char(10)','3',2,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'jkje',1043,'decimal(15,2)','1',3,0,'','1',0,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'jksy',127066,'text','2',1,0,'','1',4,9.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1jklx',22138,'int','5',1,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1jkje',1043,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tzmx',83190,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1jksm',83354,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1xghk',84626,'varchar(500)','1',1,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2skfs',83192,'int','5',1,1,'"+formtable_main+"_dt2','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2skje',17176,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2khyh',17084,'varchar(300)','1',1,1,'"+formtable_main+"_dt2','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2hm',19804,'varchar(200)','1',1,1,'"+formtable_main+"_dt2','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2skzh',83191,'varchar(100)','1',1,1,'"+formtable_main+"_dt2','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  					
  				}
  				
  			}else if("repayment".equals(creatType)){//还款流程
				detailtable_array.add(formtable_main+"_dt1");
				detailtable_array.add(formtable_main+"_dt2");
  				if(isoracle){
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar2(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add hkje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add hksm clob");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id integer primary key not null, mainid integer, "+
  							"mx1hkfs integer, mx1hkje decimal(15, 2), mx1tzmx varchar2(900), mx1tzsm varchar2(600))");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt2"+" (id integer primary key not null, mainid integer, "+
  							"mx2jklc integer, mx2jkdh varchar2(200), mx2dnxh integer, "+
  							"mx2jkje decimal(15, 2), mx2yhje decimal(15, 2), mx2spzdhje decimal(15, 2), mx2whje decimal(15, 2), mx2bccxje decimal(15, 2), mx2cxsm varchar2(900))");

  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt1_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");
  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt2_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");

  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt1_ID_TR " +
  							" before insert on "+formtable_main+"_dt1 for each row " + 
  							" begin " + 
  							"   select "+formtable_main_fm+"_dt1_ID.nextval into :new.id from dual; " + 
  							" end;");
  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt2_ID_TR " +
  							" before insert on "+formtable_main+"_dt2 for each row " + 
  							" begin " + 
  							"   select "+formtable_main_fm+"_dt2_ID.nextval into :new.id from dual; " + 
  							" end;");

  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1hkfs)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_1 on "+formtable_main+"_dt2 (mx2jklc)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_2 on "+formtable_main+"_dt2 (mx2jkdh)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_3 on "+formtable_main+"_dt2 (mx2dnxh)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar2(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'integer','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'integer','3',1,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'integer','3',4,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'integer','3',164,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'hkje',22098,'decimal(15,2)','1',3,0,'','1',0,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'hksm',127068,'clob','2',1,0,'','1',4,9.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1hkfs',22097,'integer','5',1,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1hkje',22098,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tzmx',83190,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tzsm',83241,'varchar2(600)','1',1,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2jklc',83182,'integer','3',16,1,'"+formtable_main+"_dt2','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2jkdh',23884,'varchar2(200)','1',1,1,'"+formtable_main+"_dt2','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2dnxh',83285,'integer','1',2,1,'"+formtable_main+"_dt2','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2jkje',127070,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,4.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2yhje',83286,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2spzdhje',83287,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,6.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2whje',83288,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,7.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2bccxje',83289,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,8.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2cxsm',127069,'varchar2(900)','1',1,1,'"+formtable_main+"_dt2','1',0,9.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					
  				}else{
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add hkje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add hksm text");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
  							"mx1hkfs int, mx1hkje decimal(15, 2), mx1tzmx varchar(900), mx1tzsm varchar(600))");
  					tableCreateSql_array.add("create table "+formtable_main+"_dt2"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
  							"mx2jklc int, mx2jkdh varchar(200), mx2dnxh int, "+
  							"mx2jkje decimal(15, 2), mx2yhje decimal(15, 2), mx2spzdhje decimal(15, 2), mx2whje decimal(15, 2), mx2bccxje decimal(15, 2), mx2cxsm varchar(900))");

  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1hkfs)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_1 on "+formtable_main+"_dt2 (mx2jklc)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_2 on "+formtable_main+"_dt2 (mx2jkdh)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_3 on "+formtable_main+"_dt2 (mx2dnxh)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'int','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'int','3',1,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'int','3',4,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'int','3',164,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'hkje',22098,'decimal(15,2)','1',3,0,'','1',0,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'hksm',127068,'text','2',1,0,'','1',4,9.00,0,100,100,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1hkfs',22097,'int','5',1,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1hkje',22098,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tzmx',83190,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tzsm',83241,'varchar(600)','1',1,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
  						
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2jklc',83182,'int','3',16,1,'"+formtable_main+"_dt2','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2jkdh',23884,'varchar(200)','1',1,1,'"+formtable_main+"_dt2','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2dnxh',83285,'int','1',2,1,'"+formtable_main+"_dt2','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2jkje',127070,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,4.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2yhje',83286,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2spzdhje',83287,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,6.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2whje',83288,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,7.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2bccxje',83289,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,8.00,0,50,50,0,'2','',0,0,'0',0,0,0,null)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx2cxsm',127069,'varchar(900)','1',1,1,'"+formtable_main+"_dt2','1',0,9.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					
  				}
  				
			}else if("fnaFeeWf".equals(creatType)){//费用报销流程
				if(isFnaFeeDtl==1){
					detailtable_array.add(formtable_main+"_dt1");
				}
				if(enableRepayment==1){
					detailtable_array.add(formtable_main+"_dt2");
					detailtable_array.add(formtable_main+"_dt3");
				}
  				if(isoracle){
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar2(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs integer");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxsm clob");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ysqlc clob");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxwc integer");
  					if(isFnaFeeDtl==1){
  	  					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id integer primary key not null, mainid integer, "+
							"mx1fykm integer, mx1fyrq char(10), mx1cdlx integer, mx1cdzt integer, mx1bxje decimal(15, 2), mx1ysxx varchar2(900))");

  	  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt1_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");

  	  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt1_ID_TR " +
  	  							" before insert on "+formtable_main+"_dt1 for each row " + 
  	  							" begin " + 
  	  							"   select "+formtable_main_fm+"_dt1_ID.nextval into :new.id from dual; " + 
  	  							" end;");
  					}else{
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1fykm integer");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1fyrq char(10)");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1cdlx integer");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1cdzt integer");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1bxje decimal(15, 2)");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1ysxx varchar2(900)");
  					}
  					if(enableRepayment==1){
	  					tableCreateSql_array.add("create table "+formtable_main+"_dt2"+" (id integer primary key not null, mainid integer, "+
	  							"mx2jklc integer, mx2jkdh varchar2(200), mx2dnxh integer, "+
	  							"mx2jkje decimal(15, 2), mx2yhje decimal(15, 2), mx2spzdhje decimal(15, 2), mx2whje decimal(15, 2), mx2bccxje decimal(15, 2), mx2cxsm varchar2(900))");
	  					tableCreateSql_array.add("create table "+formtable_main+"_dt3"+" (id integer primary key not null, mainid integer, "+
	  							"mx3skfs integer, mx3skje decimal(15, 2), mx3khyh varchar2(300), mx3hm varchar2(200), mx3skzh varchar2(100))");

	  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt2_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");
	  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt3_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");

	  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt2_ID_TR " +
	  							" before insert on "+formtable_main+"_dt2 for each row " + 
	  							" begin " + 
	  							"   select "+formtable_main_fm+"_dt2_ID.nextval into :new.id from dual; " + 
	  							" end;");
	  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt3_ID_TR " +
	  							" before insert on "+formtable_main+"_dt3 for each row " + 
	  							" begin " + 
	  							"   select "+formtable_main_fm+"_dt3_ID.nextval into :new.id from dual; " + 
	  							" end;");
  					}

  					if(isFnaFeeDtl==1){
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1fykm)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_2 on "+formtable_main+"_dt1 (mx1fyrq)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_3 on "+formtable_main+"_dt1 (mx1cdlx)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_4 on "+formtable_main+"_dt1 (mx1cdzt)");
  					}else{
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_1 on "+formtable_main+" (mx1fykm)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_2 on "+formtable_main+" (mx1fyrq)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_3 on "+formtable_main+" (mx1cdlx)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_4 on "+formtable_main+" (mx1cdzt)");
  					}
  					if(enableRepayment==1){
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_1 on "+formtable_main+"_dt2 (mx2jklc)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_2 on "+formtable_main+"_dt2 (mx2jkdh)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_3 on "+formtable_main+"_dt2 (mx2dnxh)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_1 on "+formtable_main+"_dt3 (mx3skfs)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_2 on "+formtable_main+"_dt3 (mx3khyh)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_3 on "+formtable_main+"_dt3 (mx3hm)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_4 on "+formtable_main+"_dt3 (mx3skzh)");
  					}
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar2(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'integer','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'integer','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'integer','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'integer','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ysqlc',127072,'clob','3',152,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxwc',127073,'integer','5',1,0,'','1',0,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxje',127071,'decimal(15,2)','1',3,0,'','1',0,9.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxsm',16966,'clob','2',1,0,'','1',4,10.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");

  					if(isFnaFeeDtl==1){
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fyrq',27767,'char(10)','3',2,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdlx',127075,'integer','5',1,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdzt',83371,'integer','3',4,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fykm',27766,'integer','3',22,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1bxje',127071,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1ysxx',33045,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,6.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					}else{
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fyrq',27767,'char(10)','3',2,0,'','1',0,11.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdlx',127075,'integer','5',1,0,'','1',0,12.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdzt',83371,'integer','3',4,0,'','1',0,13.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fykm',27766,'integer','3',22,0,'','1',0,14.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1bxje',127071,'decimal(15,2)','1',3,0,'','1',0,15.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1ysxx',33045,'varchar2(900)','1',1,0,'','1',0,16.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					}
  					
  					if(enableRepayment==1){
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2jklc',83182,'integer','3',16,1,'"+formtable_main+"_dt2','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2jkdh',23884,'varchar2(200)','1',1,1,'"+formtable_main+"_dt2','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2dnxh',83285,'integer','1',2,1,'"+formtable_main+"_dt2','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2jkje',127070,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,4.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2yhje',83286,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2spzdhje',83287,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,6.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2whje',83288,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,7.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2bccxje',83289,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,8.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2cxsm',127069,'varchar2(900)','1',1,1,'"+formtable_main+"_dt2','1',0,9.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
	  						
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3skfs',83192,'integer','5',1,1,'"+formtable_main+"_dt3','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3skje',17176,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt3','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3khyh',17084,'varchar2(300)','1',1,1,'"+formtable_main+"_dt3','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3hm',19804,'varchar2(200)','1',1,1,'"+formtable_main+"_dt3','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3skzh',83191,'varchar2(100)','1',1,1,'"+formtable_main+"_dt3','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,' ')");
  					}
  					
  				}else{
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxsm text");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ysqlc text");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxwc int");
  					if(isFnaFeeDtl==1){
  	  					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
							"mx1fykm int, mx1fyrq char(10), mx1cdlx int, mx1cdzt int, mx1bxje decimal(15, 2), mx1ysxx varchar(900))");
  					}else{
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1fykm int");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1fyrq char(10)");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1cdlx int");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1cdzt int");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1bxje decimal(15, 2)");
  	  					tableCreateSql_array.add("alter table "+formtable_main+" add mx1ysxx varchar(900)");
  					}
  					if(enableRepayment==1){
	  					tableCreateSql_array.add("create table "+formtable_main+"_dt2"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
	  							"mx2jklc int, mx2jkdh varchar(200), mx2dnxh int, "+
	  							"mx2jkje decimal(15, 2), mx2yhje decimal(15, 2), mx2spzdhje decimal(15, 2), mx2whje decimal(15, 2), mx2bccxje decimal(15, 2), mx2cxsm varchar(900))");
	  					tableCreateSql_array.add("create table "+formtable_main+"_dt3"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
	  							"mx3skfs int, mx3skje decimal(15, 2), mx3khyh varchar(300), mx3hm varchar(200), mx3skzh varchar(100))");
  					}

  					if(isFnaFeeDtl==1){
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1fykm)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_2 on "+formtable_main+"_dt1 (mx1fyrq)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_3 on "+formtable_main+"_dt1 (mx1cdlx)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_4 on "+formtable_main+"_dt1 (mx1cdzt)");
  					}else{
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_1 on "+formtable_main+" (mx1fykm)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_2 on "+formtable_main+" (mx1fyrq)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_3 on "+formtable_main+" (mx1cdlx)");
	  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_m_4 on "+formtable_main+" (mx1cdzt)");
  					}
  					if(enableRepayment==1){
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_1 on "+formtable_main+"_dt2 (mx2jklc)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_2 on "+formtable_main+"_dt2 (mx2jkdh)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt2_3 on "+formtable_main+"_dt2 (mx2dnxh)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_1 on "+formtable_main+"_dt3 (mx3skfs)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_2 on "+formtable_main+"_dt3 (mx3khyh)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_3 on "+formtable_main+"_dt3 (mx3hm)");
  						tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt3_4 on "+formtable_main+"_dt3 (mx3skzh)");
  					}
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'int','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'int','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'int','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'int','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ysqlc',127072,'text','3',152,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxwc',127073,'int','5',1,0,'','1',0,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxje',127071,'decimal(15,2)','1',3,0,'','1',0,9.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxsm',16966,'text','2',1,0,'','1',4,10.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");

  					if(isFnaFeeDtl==1){
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fyrq',27767,'char(10)','3',2,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdlx',127075,'int','5',1,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdzt',83371,'int','3',4,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fykm',27766,'int','3',22,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1bxje',127071,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1ysxx',33045,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,6.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					}else{
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fyrq',27767,'char(10)','3',2,0,'','1',0,11.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdlx',127075,'int','5',1,0,'','1',0,12.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1cdzt',83371,'int','3',4,0,'','1',0,13.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1fykm',27766,'int','3',22,0,'','1',0,14.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1bxje',127071,'decimal(15,2)','1',3,0,'','1',0,15.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx1ysxx',33045,'varchar(900)','1',1,0,'','1',0,16.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					}
  					if(enableRepayment==1){
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2jklc',83182,'int','3',16,1,'"+formtable_main+"_dt2','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2jkdh',23884,'varchar(200)','1',1,1,'"+formtable_main+"_dt2','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2dnxh',83285,'int','1',2,1,'"+formtable_main+"_dt2','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2jkje',127070,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,4.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2yhje',83286,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2spzdhje',83287,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,6.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2whje',83288,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,7.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2bccxje',83289,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt2','1',0,8.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx2cxsm',127069,'varchar(900)','1',1,1,'"+formtable_main+"_dt2','1',0,9.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
	  						
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3skfs',83192,'int','5',1,1,'"+formtable_main+"_dt3','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3skje',17176,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt3','1',0,2.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3khyh',17084,'varchar(300)','1',1,1,'"+formtable_main+"_dt3','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3hm',19804,'varchar(200)','1',1,1,'"+formtable_main+"_dt3','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
						tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  						"values("+formid+",'mx3skzh',83191,'varchar(100)','1',1,1,'"+formtable_main+"_dt3','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,' ')");
  					}
  				}
  				
  			}else if("change".equals(creatType)){//预算变更流程
				detailtable_array.add(formtable_main+"_dt1");
				if(isoracle){
					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar2(50)");
					tableCreateSql_array.add("alter table "+formtable_main+" add sqr integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add tdr integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
					tableCreateSql_array.add("alter table "+formtable_main+" add bxje decimal(15, 2)");
					tableCreateSql_array.add("alter table "+formtable_main+" add bxsm clob");
					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id integer primary key not null, mainid integer, "+
						"mx1fykm integer, mx1fyrq char(10), mx1cdlx integer, mx1cdzt integer, mx1bxje decimal(15, 2), mx1ysxx varchar2(900))");

  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt1_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");

  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt1_ID_TR " +
  							" before insert on "+formtable_main+"_dt1 for each row " + 
  							" begin " + 
  							"   select "+formtable_main_fm+"_dt1_ID.nextval into :new.id from dual; " + 
  							" end;");

					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1fykm)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_2 on "+formtable_main+"_dt1 (mx1fyrq)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_3 on "+formtable_main+"_dt1 (mx1cdlx)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_4 on "+formtable_main+"_dt1 (mx1cdzt)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
						"values("+formid+",'djbh',127062,'varchar2(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
						"values("+formid+",'sqr',368,'integer','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'integer','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'integer','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'integer','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxje',127071,'decimal(15,2)','1',3,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxsm',16966,'clob','2',1,0,'','1',4,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");

					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1fyrq',27767,'char(10)','3',2,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1cdlx',127075,'integer','5',1,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1cdzt',83371,'integer','3',4,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1fykm',27766,'integer','3',22,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1bxje',127071,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1ysxx',33045,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,6.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
  					
				}else{
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add bxsm text");
					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
						"mx1fykm int, mx1fyrq char(10), mx1cdlx int, mx1cdzt int, mx1bxje decimal(15, 2), mx1ysxx varchar(900))");

  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1fykm)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_2 on "+formtable_main+"_dt1 (mx1fyrq)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_3 on "+formtable_main+"_dt1 (mx1cdlx)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_4 on "+formtable_main+"_dt1 (mx1cdzt)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'int','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'int','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'int','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'int','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxje',127071,'decimal(15,2)','1',3,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'bxsm',16966,'text','2',1,0,'','1',4,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");

					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1fyrq',27767,'char(10)','3',2,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1cdlx',127075,'int','5',1,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1cdzt',83371,'int','3',4,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1fykm',27766,'int','3',22,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1bxje',127071,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1ysxx',33045,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,6.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					
				}
  				
  			}else if("share".equals(creatType)){//费用分摊流程
				detailtable_array.add(formtable_main+"_dt1");
				if(isoracle){
					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar2(50)");
					tableCreateSql_array.add("alter table "+formtable_main+" add sqr integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add tdr integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs integer");
					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
					tableCreateSql_array.add("alter table "+formtable_main+" add ftje decimal(15, 2)");
					tableCreateSql_array.add("alter table "+formtable_main+" add ftsm clob");
					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id integer primary key not null, mainid integer, "+
						"mx1tccdlx integer, mx1tccdzt integer, mx1tcysxx varchar2(900), "+
						"mx1trcdlx integer, mx1trcdzt integer, mx1trysxx varchar2(900), "+
						"mx1trkm integer, mx1trrq char(10), "+
						"mx1ftje decimal(15, 2))");

  					tableCreateIndexSql_array.add("create sequence "+formtable_main_fm+"_dt1_ID minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache ");

  					tableCreateIndexSql_array.add("create or replace trigger "+formtable_main_fm+"_dt1_ID_TR " +
  							" before insert on "+formtable_main+"_dt1 for each row " + 
  							" begin " + 
  							"   select "+formtable_main_fm+"_dt1_ID.nextval into :new.id from dual; " + 
  							" end;");

					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1trkm)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_2 on "+formtable_main+"_dt1 (mx1trrq)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_3 on "+formtable_main+"_dt1 (mx1trcdlx)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_4 on "+formtable_main+"_dt1 (mx1trcdzt)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_5 on "+formtable_main+"_dt1 (mx1tccdlx)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_6 on "+formtable_main+"_dt1 (mx1tccdzt)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
						"values("+formid+",'djbh',127062,'varchar2(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
						"values("+formid+",'sqr',368,'integer','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'integer','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'integer','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'integer','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ftje',127071,'decimal(15,2)','1',3,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ftsm',16966,'clob','2',1,0,'','1',4,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");

					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tccdlx',127083,'integer','5',1,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tccdzt',127084,'integer','3',4,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trcdlx',127086,'integer','5',1,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trcdzt',127087,'integer','3',4,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trkm',127089,'integer','3',22,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trrq',127090,'char(10)','3',2,1,'"+formtable_main+"_dt1','1',0,6.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
		  				"values("+formid+",'mx1tcysxx',127085,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,7.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  					"values("+formid+",'mx1trysxx',127088,'varchar2(900)','1',1,1,'"+formtable_main+"_dt1','1',0,8.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1ftje',127091,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,9.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
  					
				}else{
  					tableCreateSql_array.add("alter table "+formtable_main+" add djbh varchar(50)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add tdr int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssbm int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ssgs int");
  					tableCreateSql_array.add("alter table "+formtable_main+" add sqrq char(10)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ftje decimal(15, 2)");
  					tableCreateSql_array.add("alter table "+formtable_main+" add ftsm text");
					tableCreateSql_array.add("create table "+formtable_main+"_dt1"+" (id int IDENTITY(1,1) primary key CLUSTERED, mainid int, "+
							"mx1tccdlx int, mx1tccdzt int, mx1tcysxx varchar(900), "+
							"mx1trcdlx int, mx1trcdzt int, mx1trysxx varchar(900), "+
							"mx1trkm int, mx1trrq char(10), "+
							"mx1ftje decimal(15, 2))");

  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_1 on "+formtable_main+"_dt1 (mx1trkm)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_2 on "+formtable_main+"_dt1 (mx1trrq)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_3 on "+formtable_main+"_dt1 (mx1trcdlx)");
  					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_4 on "+formtable_main+"_dt1 (mx1trcdzt)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_5 on "+formtable_main+"_dt1 (mx1tccdlx)");
					tableCreateIndexSql_array.add("create index idx_"+formtable_main_fm+"_dt1_6 on "+formtable_main+"_dt1 (mx1tccdzt)");
  					
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'djbh',127062,'varchar(50)','1',1,0,'','1',0,1.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqr',368,'int','3',1,0,'','1',0,2.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'tdr',127063,'int','3',1,0,'','1',0,3.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssbm',127064,'int','3',4,0,'','1',0,4.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ssgs',26113,'int','3',164,0,'','1',0,5.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'sqrq',855,'char(10)','3',2,0,'','1',0,6.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ftje',127071,'decimal(15,2)','1',3,0,'','1',0,7.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'ftsm',16966,'text','2',1,0,'','1',4,8.00,0,100,100,0,'0','',0,0,'0',0,0,0,NULL)");

					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tccdlx',127083,'int','5',1,1,'"+formtable_main+"_dt1','1',0,1.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1tccdzt',127084,'int','3',4,1,'"+formtable_main+"_dt1','1',0,2.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trcdlx',127086,'int','5',1,1,'"+formtable_main+"_dt1','1',0,3.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trcdzt',127087,'int','3',4,1,'"+formtable_main+"_dt1','1',0,4.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trkm',127089,'int','3',22,1,'"+formtable_main+"_dt1','1',0,5.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1trrq',127090,'char(10)','3',2,1,'"+formtable_main+"_dt1','1',0,6.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
		  				"values("+formid+",'mx1tcysxx',127085,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,7.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
	  					"values("+formid+",'mx1trysxx',127088,'varchar(900)','1',1,1,'"+formtable_main+"_dt1','1',0,8.00,0,50,50,0,'0','',0,0,'0',0,0,0,NULL)");
					tableFieldInitSql_array.add("insert into workflow_billfield (billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,places,qfws,textheight_2,selectitem,linkfield,selectItemType,pubchoiceId,pubchilchoiceId,statelev,locatetype)"+
  						"values("+formid+",'mx1ftje',127091,'decimal(15,2)','1',3,1,'"+formtable_main+"_dt1','1',0,9.00,0,50,50,0,'2','',0,0,'0',0,0,0,NULL)");
					
				}
  				
  			}

  	  		//添加主表字段、建明细表
	  		for(int tempi=0;tempi<tableCreateSql_array.size();tempi++){
				String tableCreateSql = tableCreateSql_array.get(tempi);
				rst.executeSql(tableCreateSql);
			}
		  	//建索引
  	  		for(int tempi=0;tempi<tableCreateIndexSql_array.size();tempi++){
				String tableCreateIndexSql = tableCreateIndexSql_array.get(tempi);
				rst.executeSql(tableCreateIndexSql);
			}
		  	//建明细表外键mainid的索引，并且插入明细表主表关系表关系记录
  	  		for(int tempi=0;tempi<detailtable_array.size();tempi++){
				String detailtable = detailtable_array.get(tempi);//明细表名称
				rst.executeSql("create index idx_"+(detailtable.replace("formtable_main_", "fm_"))+"_mainid on "+detailtable+" (mainid)");
				//插入表单明细表信息workflow_billdetailtable
				rst.executeSql("INSERT INTO workflow_billdetailtable(billid,tablename,orderid) values("+formid+",'"+StringEscapeUtils.escapeSql(detailtable)+"',"+(tempi+1)+")");
			}
			//初始化明细表字段信息
  	  		for(int tempi=0;tempi<tableFieldInitSql_array.size();tempi++){
				String tableFieldInitSql = tableFieldInitSql_array.get(tempi);
				//new BaseBean().writeLog(tableFieldInitSql);
				rst.executeSql(tableFieldInitSql);
  	  		}
  	  		
	  	  	if("borrow".equals(creatType)){//借款流程
				rst.executeSql("select id from workflow_billfield where detailtable = '"+formtable_main+"_dt1' and fieldname = 'mx1jklx' and billid = "+formid);
				if(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'个人借款',0,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'公务借款',1,'y',NULL,NULL,'0',NULL,'0',NULL)");
				}
				
	  	  		rst.executeSql("select id from workflow_billfield where detailtable = '"+formtable_main+"_dt2' and fieldname = 'mx2skfs' and billid = "+formid);
				if(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'现金',0,'y',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'银行转账',1,'n',NULL,NULL,'0',NULL,'0',NULL)");
				}
				
	  	  	}else if("repayment".equals(creatType)){//还款流程
				rst.executeSql("select id from workflow_billfield where detailtable = '"+formtable_main+"_dt1' and fieldname = 'mx1hkfs' and billid = "+formid);
				if(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'现金',0,'y',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'银行转账',1,'n',NULL,NULL,'0',NULL,'0',NULL)");
				}

			}else if("fnaFeeWf".equals(creatType)){//费用报销流程
				rst.executeSql("select id from workflow_billfield where (detailtable = '' or detailtable is null) and fieldname = 'bxwc' and billid = "+formid);
				if(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'否',0,'y',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'是',1,'n',NULL,NULL,'0',NULL,'0',NULL)");
				}

				rst.executeSql("select id from workflow_billfield where fieldname = 'mx1cdlx' and billid = "+formid);
				if(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'个人',0,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'部门',1,'y',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,2,'分部',2,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,3,'成本中心',3,'n',NULL,NULL,'0',NULL,'0',NULL)");
				}

				if(enableRepayment==1){
		  	  		rst.executeSql("select id from workflow_billfield where detailtable = '"+formtable_main+"_dt3' and fieldname = 'mx3skfs' and billid = "+formid);
					if(rst.next()){
						int fieldid = rst.getInt("id");
						rst.executeSql("INSERT INTO workflow_SelectItem\n" +
								" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
								" VALUES\n" +
								" ("+fieldid+",1,0,'现金',0,'y',NULL,NULL,'0',NULL,'0',NULL)");
						rst.executeSql("INSERT INTO workflow_SelectItem\n" +
								" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
								" VALUES\n" +
								" ("+fieldid+",1,1,'银行转账',1,'n',NULL,NULL,'0',NULL,'0',NULL)");
					}
				}
				
			}else if("change".equals(creatType)){//预算变更流程
				rst.executeSql("select id from workflow_billfield where fieldname = 'mx1cdlx' and billid = "+formid);
				if(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'个人',0,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'部门',1,'y',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,2,'分部',2,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,3,'成本中心',3,'n',NULL,NULL,'0',NULL,'0',NULL)");
				}

			}else if("share".equals(creatType)){//费用分摊流程
				rst.executeSql("select id from workflow_billfield where fieldname in ('mx1tccdlx', 'mx1trcdlx') and billid = "+formid);
				while(rst.next()){
					int fieldid = rst.getInt("id");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,0,'个人',0,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,1,'部门',1,'y',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,2,'分部',2,'n',NULL,NULL,'0',NULL,'0',NULL)");
					rst.executeSql("INSERT INTO workflow_SelectItem\n" +
							" (fieldid,isbill,selectvalue,selectname,listorder,isdefault,docPath,docCategory,isAccordToSubCom,childitemid,cancel,pubid)\n" +
							" VALUES\n" +
							" ("+fieldid+",1,3,'成本中心',3,'n',NULL,NULL,'0',NULL,'0',NULL)");
				}
				
			}
  	  		
  			rst.commit();
  	  		rst.setChecksql(true);
  			success = true;
  			
  			if(isoracle){//主表id自增长
	  			rs.executeSql("create sequence "+formtable_main_fm+"_Id start with 1 increment by 1 nomaxvalue nocycle nocache ");
	  			rs.setChecksql(false);
	  			rs.executeSql("create or replace trigger "+formtable_main_fm+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main_fm+"_Id.nextval into :new.id from dual; end;");
	  		}
  	  		if(issqlserver){//因为在sql里面detailtable的默认值NULL，显示排序的时候按照detailtable排序，当detailtable有空值和null时，排序会乱
  	  			rs.executeSql("update workflow_billfield set detailtable = '' where detailtable is null");
  	  		}
  			labelComInfo.addLabeInfoCache(""+namelabelid);//往缓存中添加表单名称的标签
  			billComInfo.addBillCache(""+formid);
			WorkflowBillComInfo workflowBillComInfo=new WorkflowBillComInfo();
			workflowBillComInfo.addWorkflowBillCache(String.valueOf(formid));
			
		}catch(Exception exception){
			success = false;
			try{
				rst.rollback();
	  	  		rst.setChecksql(true);
			}catch(Exception ex1){}
			new BaseBean().writeLog(exception);
			out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(exception.getMessage())+"}");//表单名称已存在
			out.flush();
			return;
		}
	}
	
	out.println("{\"flag\":true,\"fnaFeeWfInfoId\":"+fnaFeeWfInfoId+",\"formid\":"+formid+",\"subcompanyid\":"+subcompanyid+"}");//保存成功
	out.flush();
	return;
	
}else if("fnaWfCreatWf_doSave".equals(operation)){//初始化流程
	String creatType = Util.null2String(request.getParameter("creatType")).trim();
	int fnaFeeWfInfoId = Util.getIntValue(request.getParameter("fnaFeeWfInfoId"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), 0);
	String wfName = Util.null2String(request.getParameter("wfName")).trim();
	int wfTypeid = Util.getIntValue(request.getParameter("wfTypeid"), 0);
	int isFnaFeeDtl = Util.getIntValue(request.getParameter("isFnaFeeDtl"), 0);
	int enableRepayment = Util.getIntValue(request.getParameter("enableRepayment"), 0);
	
	int wfid = 0;

	WorkflowBillfieldDao workflowBillfieldDao = new WorkflowBillfieldDao();
  	RecordSetTrans rst = new RecordSetTrans();
  	
	boolean success = false;
	try{
  		String sql = "";
  		
  		HashMap<String, String> wfBillfield_hm = new HashMap<String, String>();
  		rs.executeSql("select id, fieldname from workflow_billfield where billid = "+formid);
  		while(rs.next()){
  			wfBillfield_hm.put(Util.null2String(rs.getString("fieldname")).trim(), rs.getString("id"));
  		}

  		String _guid1 = FnaCommon.getPrimaryKeyGuid1();
  		//新建流程
  		String inserSql_workflow_base = 
  			"insert into workflow_base\n" +
  			"  (workflowname, workflowdesc,\n" + 
  			"  workflowtype, securelevel, formid,\n" + 
  			"  userid, isbill, iscust,\n" + 
  			"  helpdocid, isvalid, needmark,\n" + 
  			"  messagetype, multisubmit, defaultname,\n" + 
  			"  docpath, subcompanyid, mailmessagetype,\n" + 
  			"  docrightbyoperator, doccategory, istemplate,\n" + 
  			"  templateid, catelogtype, selectedcatelog,\n" + 
  			"  docrightbyhrmresource, needaffirmance, isremarks,\n" + 
  			"  isannexupload, annexdoccategory, isshowonreportinput,\n" + 
  			"  titlefieldid, keywordfieldid, isshowchart,\n" + 
  			"  orderbytype, istridiffworkflow, ismodifylog,\n" + 
  			"  ifversion, wfdocpath, wfdocowner,\n" + 
  			"  isedit, editor, editdate,\n" + 
  			"  edittime, showdelbuttonbyreject, wfdocownertype,\n" + 
  			"  wfdocownerfieldid, issignview, showuploadtab,\n" + 
  			"  issigndoc, showdoctab, issignworkflow,\n" + 
  			"  showworkflowtab, candelacc, isforwardrights,\n" + 
  			"  isimportwf, isrejectremind, ischangrejectnode,\n" + 
  			"  newdocpath, keepsign, seccategoryid,\n" + 
  			"  custompage, isselectrejectnode, forbidattdownload,\n" + 
  			"  isimportdetail, specialapproval, frequency,\n" + 
  			"  cycle, nosynfields, isneeddelacc,\n" + 
  			"  sapsource, isfnacontrol, fnanodeid,\n" + 
  			"  fnadepartmentid, smsalertstype, issavecheckform,\n" + 
  			"  archivenomsgalert, archivenomailalert, isfnabudgetwf,\n" + 
  			"  forwardreceivedef, fieldnotimport, isworkflowdoc,\n" + 
  			"  version, activeversionid, versiondescription,\n" + 
  			"  versioncreater, dsporder, isfree,\n" + 
  			"  chatstype, chatsalerttype,\n" + 
  			"  notremindifarchived, officaltype, custompage4emoble,\n" + 
  			"  isupdatetitle, isshared, isoverrb,\n" + 
  			"  isoveriv \n" + 
  			" )values( \n" + 
  			"  '"+StringEscapeUtils.escapeSql(_guid1)+"', '',\n" + 
  			"  "+wfTypeid+", '', "+formid+",\n" + 
  			"  NULL, '1', 0,\n" + 
  			"  0, '1', '',\n" + 
  			"  0, 0, 1,\n" + 
  			"  '', "+subcompanyid+", 0,\n" + 
  			"  0, ',,', '0',\n" + 
  			"  0, 0, 0,\n" + 
  			"  0, '', '',\n" + 
  			"  '', ',,', '',\n" + 
  			"  NULL, NULL, '',\n" + 
  			"  '1', NULL, '',\n" + 
  			"  NULL, '', '',\n" + 
  			"  NULL, NULL, NULL,\n" + 
  			"  NULL, '1', 0,\n" + 
  			"  0, 0, '',\n" + 
  			"  '', '', '',\n" + 
  			"  '', '', '0',\n" + 
  			"  '', '', '',\n" + 
  			"  '', NULL, NULL,\n" + 
  			"  '', '', 0,\n" + 
  			"  '', '', 0,\n" + 
  			"  '', '', '0',\n" + 
  			"  '', NULL, NULL,\n" + 
  			"  NULL, '0', '',\n" + 
  			"  '', '', NULL,\n" + 
  			"  '', '', 0,\n" + 
  			"  NULL, NULL, NULL,\n" + 
  			"  NULL, 0, '0',\n" + 
  			"  0, 0,\n" + 
  			"  0, NULL, NULL,\n" + 
  			"  1, '0', '0',\n" + 
  			"  '0' \n" + 
  			" )";
  		
  		String[] _workflow_nodeName_array = new String[]{
  				"创建",
  				"审批",
  				"归档"
  		};
  		String[] _workflow_nodeId_array = new String[]{
  				"0",//创建
  				"0",//审批
  				"0"//归档
  		};
  		String[] inserSql_workflow_nodebase_array = new String[]{
  				"INSERT INTO workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos,totalgroups,nodeattribute,passnum,IsFreeNode,floworder,Signtype,operators_1,requestid,startnodeid,operators)\n" +
		  		" VALUES ('"+StringEscapeUtils.escapeSql(_guid1)+"','1','0','0','0',-1,-1,0,'0',0,'',NULL,NULL,NULL,NULL,NULL,NULL)",
  				"INSERT INTO workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos,totalgroups,nodeattribute,passnum,IsFreeNode,floworder,Signtype,operators_1,requestid,startnodeid,operators)\n" +
		  		" VALUES ('"+StringEscapeUtils.escapeSql(_guid1)+"','0','1','1','0',-1,-1,0,'0',0,'',NULL,NULL,NULL,NULL,NULL,NULL)",
  				"INSERT INTO workflow_nodebase (nodename,isstart,isreject,isreopen,isend,drawxpos,drawypos,totalgroups,nodeattribute,passnum,IsFreeNode,floworder,Signtype,operators_1,requestid,startnodeid,operators)\n" +
		  		" VALUES ('"+StringEscapeUtils.escapeSql(_guid1)+"','0','0','0','1',-1,-1,0,'0',0,'',NULL,NULL,NULL,NULL,NULL,NULL)"
  		};
  		
  		String[] inserSql_workflow_flownode_array = new String[]{
  				"INSERT INTO workflow_flownode (workflowid, nodeid, nodetype, viewnodeids, "+
  					" viewtypeall, viewdescall, showtype, IsPendingForward, IsSubmitedOpinion, "+
  					" isfeedback, nodeorder, isRemarkLocation)\n" +
		  		" VALUES (1122334455workflowid1122334455, 1122334455nodeid1122334455, '0', '-1', "+
		  			" '1', '1', '0', '1', '1', "+
		  			" '1', 1, 0)",
		  			
  				"INSERT INTO workflow_flownode (workflowid, nodeid, nodetype, viewnodeids, "+
  					" viewtypeall, viewdescall, showtype, IsPendingForward, IsSubmitedOpinion, "+
  					" isfeedback, nodeorder, isRemarkLocation)\n" +
		  		" VALUES (1122334455workflowid1122334455, 1122334455nodeid1122334455, '1', '-1', "+
		  			" '1', '1', '0', '1', '1', "+
		  			" '1', 2, 0)",
		  			
  				"INSERT INTO workflow_flownode (workflowid, nodeid, nodetype, viewnodeids, "+
  					" viewtypeall, viewdescall, showtype, IsPendingForward, IsSubmitedOpinion, "+
  					" isfeedback, nodeorder, isRemarkLocation)\n" +
		  		" VALUES (1122334455workflowid1122334455, 1122334455nodeid1122334455, '3', '-1', "+
		  			" '1', '1', '0', '1', '1', "+
		  			" '1', 3, 0)"
  		};
  		
  		HashMap<String, String> workflow_nodeform_fieldEditType_hm = new HashMap<String, String>();
  		if("borrow".equals(creatType)){//借款流程
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1jklx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1jklx"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1jkje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1jkje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tzmx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tzmx"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1jksm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1jksm"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1xghk"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1xghk"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2skfs"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2skfs"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2skje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2skje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2khyh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2khyh"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2hm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2hm"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2skzh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2skzh"+"_ismandatory", "0");

  		}else if("repayment".equals(creatType)){//还款流程
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1hkfs"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1hkfs"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1hkje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1hkje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tzmx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tzmx"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1tzsm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tzsm"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2jklc"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jklc"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkdh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkdh"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2dnxh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2dnxh"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2yhje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2yhje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2spzdhje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2spzdhje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2whje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2whje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2bccxje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2bccxje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2cxsm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2cxsm"+"_ismandatory", "0");

  		}else if("fnaFeeWf".equals(creatType)){//费用报销流程
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("ysqlc"+"_isview", "0");
  			workflow_nodeform_fieldEditType_hm.put("ysqlc"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("ysqlc"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("bxwc"+"_isview", "0");
  			workflow_nodeform_fieldEditType_hm.put("bxwc"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("bxwc"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1fykm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fykm"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fyrq"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fyrq"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdlx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdlx"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdzt"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdzt"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1bxje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1bxje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1ysxx"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1ysxx"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2jklc"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jklc"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkdh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkdh"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2dnxh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2dnxh"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2jkje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2yhje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2yhje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2spzdhje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2spzdhje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2whje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2whje"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx2bccxje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2bccxje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2cxsm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx2cxsm"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx3skfs"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3skfs"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3skje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3skje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3khyh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3khyh"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx3hm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3hm"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx3skzh"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx3skzh"+"_ismandatory", "0");

  		}else if("change".equals(creatType)){//预算变更流程
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fykm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fykm"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fyrq"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1fyrq"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdlx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdlx"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdzt"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1cdzt"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1bxje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1bxje"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1ysxx"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1ysxx"+"_ismandatory", "0");

  		}else if("share".equals(creatType)){//费用分摊流程
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("sqr"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tccdlx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tccdlx"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tccdzt"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tccdzt"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1tcysxx"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1tcysxx"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1trcdlx"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trcdlx"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trcdzt"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trcdzt"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trysxx"+"_isedit", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1trysxx"+"_ismandatory", "0");
  			workflow_nodeform_fieldEditType_hm.put("mx1trkm"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trkm"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trrq"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1trrq"+"_ismandatory", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1ftje"+"_isedit", "1");
  			workflow_nodeform_fieldEditType_hm.put("mx1ftje"+"_ismandatory", "1");

  		}
  		
  		rst.setAutoCommit(false);
  		
  		rst.executeSql(inserSql_workflow_base);
	  	rst.executeSql("select max(id) maxId from workflow_base where workflowname = '"+StringEscapeUtils.escapeSql(_guid1)+"'");
		if(rst.next()){
			wfid = rst.getInt("maxId");
			rst.executeSql("update workflow_base set workflowname = '"+StringEscapeUtils.escapeSql(wfName)+"' where id = "+wfid);

			rst.executeSql("insert into workflow_versioninfo (wfid, wfversionid) values ("+wfid+", "+wfid+")");
			/*
			rst.executeSql("insert into workflow_versioninfo (wfid, wfversionid) \n" +
					" select a.workflowid wf1, a.workflowid wf2 \n" +
					" from fnaFeeWfInfo a \n" +
					" where not EXISTS (\n" +
					"	select 1 from workflow_versioninfo wv \n" +
					"	where wv.wfid = a.workflowid or wv.wfversionid = a.workflowid \n" +
					" ) ");
			*/
	  		
			for(int i=0;i<_workflow_nodeName_array.length;i++){
				String inserSql_workflow_nodeName = _workflow_nodeName_array[i];
				String inserSql_workflow_nodebase = inserSql_workflow_nodebase_array[i];
				String inserSql_workflow_flownode = inserSql_workflow_flownode_array[i];
				
	  	  		rst.executeSql(inserSql_workflow_nodebase);
	  	  		
	  	  		rst.executeSql("select max(id) maxId from workflow_nodebase where nodename = '"+StringEscapeUtils.escapeSql(_guid1)+"'");
	  	  		if(rst.next()){
	  				int _nodeId = rst.getInt("maxId");
	  				_workflow_nodeId_array[i] = _nodeId+"";
	  				
	  	  	  		rst.executeSql("update workflow_nodebase set nodename = '"+StringEscapeUtils.escapeSql(inserSql_workflow_nodeName)+"' where id = "+_nodeId);

					inserSql_workflow_flownode = inserSql_workflow_flownode
						.replaceAll("1122334455workflowid1122334455", wfid+"")
						.replaceAll("1122334455nodeid1122334455", _nodeId+"");

	  	  	  		rst.executeSql(inserSql_workflow_flownode);
	  	  		}
	  		}


			String inserSql_workflow_nodelink = "INSERT INTO workflow_nodelink (workflowid, nodeid, linkname, destnodeid, directionfrom, directionto, "+
				" nodepasstime, startDirection, endDirection, linkorder )\n" +
				" VALUES ("+wfid+", "+Util.getIntValue(_workflow_nodeId_array[0])+", '提交审批', "+Util.getIntValue(_workflow_nodeId_array[1])+", -1, -1, "+
				" '-1', -1, -1, 1 )";
			rst.executeSql(inserSql_workflow_nodelink);
				
			inserSql_workflow_nodelink = "INSERT INTO workflow_nodelink (workflowid, nodeid, linkname, destnodeid, directionfrom, directionto, "+
				" nodepasstime, startDirection, endDirection, linkorder )\n" +
				" VALUES ("+wfid+", "+Util.getIntValue(_workflow_nodeId_array[1])+", '批准', "+Util.getIntValue(_workflow_nodeId_array[2])+", -1, -1, "+
				" '-1', -1, -1, 2 )";
			rst.executeSql(inserSql_workflow_nodelink);
			
			List<String> _insert_sql_workflow_nodeform_list = new ArrayList<String>();
			for(int i=0;i<_workflow_nodeId_array.length;i++){
				int inserSql_workflow_nodeId = Util.getIntValue(_workflow_nodeId_array[i]);
				if(inserSql_workflow_nodeId > 0){
					String sql_workflow_billfield = "select id, fieldname, dsporder from workflow_billfield where billid = "+formid+" order by dsporder";
					rst.executeSql(sql_workflow_billfield);
		  	  		while(rst.next()){
		  				int _fieldId = rst.getInt("id");
		  				String _fieldname = Util.null2String(rst.getString("fieldname")).trim();
		  				double _dsporder = Util.getDoubleValue(rst.getString("dsporder"), 0);

		  				int isview = Util.getIntValue(workflow_nodeform_fieldEditType_hm.get(_fieldname+"_isview"), 1);
		  				int isedit = Util.getIntValue(workflow_nodeform_fieldEditType_hm.get(_fieldname+"_isedit"), 0);
		  				int ismandatory = Util.getIntValue(workflow_nodeform_fieldEditType_hm.get(_fieldname+"_ismandatory"), 0);
		  	  	  		_insert_sql_workflow_nodeform_list.add("insert into workflow_nodeform (nodeid, fieldid, isview, isedit, ismandatory, orderid) "+
		  	  	  				" values ("+inserSql_workflow_nodeId+", "+_fieldId+", '"+isview+"', '"+isedit+"', '"+ismandatory+"', "+_dsporder+")");
		  	  		}
				}
			}
			
			for(int i=0;i<_insert_sql_workflow_nodeform_list.size();i++){
				rst.executeSql(_insert_sql_workflow_nodeform_list.get(i));
			}
		}
  		
		rst.commit();
		
		WorkflowAllComInfo workflowAllComInfo = new WorkflowAllComInfo();
		workflowAllComInfo.reloadWorkflowInfos();
		WorkflowComInfo workflowComInfo = new WorkflowComInfo();
		workflowComInfo.reloadWorkflowInfos();
  		WorkflowComInfo2 workflowComInfo2 = new WorkflowComInfo2();
  		workflowComInfo2.reloadWorkflowInfos();
  		
  	  	if("borrow".equals(creatType)){//借款流程
  	  		if(fnaFeeWfInfoId <= 0){//生成主信息
	  	  		int enable = 1;
				String templateFile = FnaWfSet.TEMPLATE_BORROW_FILE;
				String templateFileMobile = FnaWfSet.TEMPLATE_BORROW_FILE_MOBILE;
	
				sql = "INSERT INTO fnaFeeWfInfo \n" +
					" (workflowid, enable, lastModifiedDate, templateFile, templateFileMobile, "+
					"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim)\n" +
					" VALUES\n" +
					" ("+wfid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
					" 'borrow', 1, 2, 0, 0 "+
					")";
				rs.executeSql(sql);
	
				sql = "select id from fnaFeeWfInfo where workflowid = "+wfid;
				rs.executeSql(sql);
				if(rs.next()){
					fnaFeeWfInfoId = rs.getInt("id");
				}
	
				String promptSC = "借款金额合计：#amount1# 与 收款金额合计：#amount2# 不一致！";
				
				//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
				FnaWfSet.clearOldFnaFeeWfInfoLogicReverseDataBorrow(wfid);
				
				FnaWfSet.saveOrUpdateFnaWfSetLogicReverse(fnaFeeWfInfoId, 
						1, 2, 
						0, 0, 
						0, 0, 
						0, 0, 
						0, 0, 
						promptSC, "", "");
				
	  	  		if(fnaFeeWfInfoId > 0){//生成字段定义信息
					sql = "update workflow_base \n" +
						" set custompage = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFile)+"', "+
						" custompage4Emoble = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFileMobile)+"' "+
						" where id = "+wfid;
					rs.executeSql(sql);
					
		
		  	  		int main_fieldIdSqr = Util.getIntValue(wfBillfield_hm.get("sqr"), 0);
	
		  	  		int main_showSqr = 0;
	
		  	  		int dt1_fieldIdJklx = Util.getIntValue(wfBillfield_hm.get("mx1jklx"), 0);
		  	  		int dt1_fieldIdJkje = Util.getIntValue(wfBillfield_hm.get("mx1jkje"), 0);
		  	  		int dt1_fieldIdJkmx = Util.getIntValue(wfBillfield_hm.get("mx1tzmx"), 0);
		  	  		int dt1_fieldIdJksm = Util.getIntValue(wfBillfield_hm.get("mx1jksm"), 0);
		  	  		int dt1_fieldIdXghklc = Util.getIntValue(wfBillfield_hm.get("mx1xghk"), 0);
	
		  	  		int dt1_showJklx = 0;
		  	  		int dt1_showJkje = 0;
		  	  		int dt1_showJkmx = 0;
		  	  		int dt1_showJksm = 0;
		  	  		int dt1_showXghklc = 0;
	
	
		  	  		int dt2_fieldIdSkfs = Util.getIntValue(wfBillfield_hm.get("mx2skfs"), 0);
		  	  		int dt2_fieldIdSkje = Util.getIntValue(wfBillfield_hm.get("mx2skje"), 0);
		  	  		int dt2_fieldIdKhyh = Util.getIntValue(wfBillfield_hm.get("mx2khyh"), 0);
		  	  		int dt2_fieldIdHuming = Util.getIntValue(wfBillfield_hm.get("mx2hm"), 0);
		  	  		int dt2_fieldIdSkzh = Util.getIntValue(wfBillfield_hm.get("mx2skzh"), 0);
		  	  		
		  	  		int dt2_showSkfs = 0;
		  	  		int dt2_showSkje = 0;
		  	  		int dt2_showKhyh = 0;
		  	  		int dt2_showHuming = 0;
		  	  		int dt2_showSkzh = 0;
		  	  		
		  	  		
		  	  		int[] fieldTypeArray = new int[]{1, 
		  	  				1, 2, 3, 4, 5,
		  	  				1, 2, 3, 4, 5};
		  	  		int[] fieldIdArray = new int[]{main_fieldIdSqr, 
		  	  				dt1_fieldIdJklx, dt1_fieldIdJkje, dt1_fieldIdJkmx, dt1_fieldIdJksm, dt1_fieldIdXghklc, 
		  	  				dt2_fieldIdSkfs, dt2_fieldIdSkje, dt2_fieldIdKhyh, dt2_fieldIdHuming, dt2_fieldIdSkzh};
		  	  		int[] isDtlArray = new int[]{0, 
		  	  				1, 1, 1, 1, 1,
		  	  				1, 1, 1, 1, 1};
		  	  		int[] showAllTypeArray = new int[]{main_showSqr, 
		  	  				dt1_showJklx, dt1_showJkje, dt1_showJkmx, dt1_showJksm, dt1_showXghklc, 
		  	  				dt2_showSkfs, dt2_showSkje, dt2_showKhyh, dt2_showHuming, dt2_showSkzh};
		  	  		int[] dtlNumberArray = new int[]{0, 
		  	  				1, 1, 1, 1, 1,
		  	  				2, 2, 2, 2, 2};
		  	  		
		  	  		
		  	  		int fieldTypeArrayLen = fieldTypeArray.length;
		  	  		for(int i=0;i<fieldTypeArrayLen;i++){
		  	  			int fieldType = fieldTypeArray[i];
		  	  			int fieldId = fieldIdArray[i];
		  	  			int isDtl = isDtlArray[i];
		  	  			int showAllType = showAllTypeArray[i];
		  	  			int dtlNumber = dtlNumberArray[i];
	
		  	  			sql = "select id from fnaFeeWfInfoField where mainId="+fnaFeeWfInfoId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
		  	  			rs.executeSql(sql);
		  	  			if(rs.next()){
		  	  				int fnaFeeWfInfoFieldId = rs.getInt("id");
		  	  				sql = "update fnaFeeWfInfoField "+
		  	  					" set workflowid="+wfid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+" "+
		  	  					" where id="+fnaFeeWfInfoFieldId;
		  	  				rs.executeSql(sql);
		  	  			}else{
		  	  				sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber) "+
		  	  					" values ("+
		  	  					" "+fnaFeeWfInfoId+", "+wfid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+" "+
		  	  					")";
		  	  				rs.executeSql(sql);
		  	  			}
		  	  		}
		  	  			
	  	  		}
	  	  		if(fnaFeeWfInfoId > 0){//生成动作设置
		  	  		String deductBorrowNode1Ids = "";//扣除-节点前附加操作
		  	  		String deductBorrowNode2Ids = Util.getIntValue(_workflow_nodeId_array[1])+"";//扣除-节点后附加操作
		  	  		String deductBorrowNode3Ids = "";//扣除-出口附加操作
	
		  	  		String releaseBorrowNode1Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//释放-节点前附加操作
		  	  		String releaseBorrowNode2Ids = "";//释放-节点后附加操作
		  	  		String releaseBorrowNode3Ids = "";//释放-出口附加操作
		  	  		
		  	  		FnaWfSet.saveActionSet2WfBorrow(deductBorrowNode1Ids, deductBorrowNode2Ids, deductBorrowNode3Ids, 
		  	  				releaseBorrowNode1Ids, releaseBorrowNode2Ids, releaseBorrowNode3Ids, 
		  	  				wfid);
		  	  		
	  	  		}
  	  		}

  	  	}else if("repayment".equals(creatType)){//还款流程
  	  		if(fnaFeeWfInfoId <= 0){//生成主信息
	  	  		int enable = 1;
				String templateFile = FnaWfSet.TEMPLATE_REPAYMENT_FILE;
				String templateFileMobile = FnaWfSet.TEMPLATE_REPAYMENT_FILE_MOBILE;
		  	  	
	  	  		sql = "INSERT INTO fnaFeeWfInfo \n" +
	  	  			" (workflowid, enable, lastModifiedDate, templateFile, templateFileMobile, "+
	  	  			"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim)\n" +
	  	  			" VALUES\n" +
	  	  			" ("+wfid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
	  	  			" 'repayment', 1, 0, 2, 0 "+
	  	  			")";
	  	  		rs.executeSql(sql);
	
	  	  		sql = "select id from fnaFeeWfInfo where workflowid = "+wfid;
	  	  		rs.executeSql(sql);
	  	  		if(rs.next()){
					fnaFeeWfInfoId = rs.getInt("id");
	  	  		}

	  	  		String promptSC = "本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！";
	  	  		
	  	  		//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
	  	  		FnaWfSet.clearOldFnaFeeWfInfoLogicReverseDataRepayment(wfid);
	  	  		
	  	  		FnaWfSet.saveOrUpdateFnaWfSetLogicReverse(fnaFeeWfInfoId, 
	  	  				1, 2, 
	  	  				1, 2, 
	  	  				0, 0, 
	  	  				0, 0, 
	  	  				0, 0, 
	  	  				promptSC, "", "");
				
	  	  		if(fnaFeeWfInfoId > 0){//生成字段定义信息
					sql = "update workflow_base \n" +
						" set custompage = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFile)+"', "+
						" custompage4Emoble = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFileMobile)+"' "+
						" where id = "+wfid;
					rs.executeSql(sql);
	
					
			  	  	int main_fieldIdSqr = Util.getIntValue(wfBillfield_hm.get("sqr"), 0);
		
			  	  	int main_showSqr = 0;
		
			  	  	int dt1_fieldIdHklx = Util.getIntValue(wfBillfield_hm.get("mx1hkfs"), 0);
			  	  	int dt1_fieldIdHkje = Util.getIntValue(wfBillfield_hm.get("mx1hkje"), 0);
			  	  	int dt1_fieldIdTzmx = Util.getIntValue(wfBillfield_hm.get("mx1tzmx"), 0);
		
			  	  	int dt1_showHklx = 0;
			  	  	int dt1_showHkje = 0;
			  	  	int dt1_showTzmx = 0;
		
			  	  	int dt2_fieldIdJklc = Util.getIntValue(wfBillfield_hm.get("mx2jklc"), 0);
			  	  	int dt2_fieldIdJkdh = Util.getIntValue(wfBillfield_hm.get("mx2jkdh"), 0);
			  	  	int dt2_fieldIdDnxh = Util.getIntValue(wfBillfield_hm.get("mx2dnxh"), 0);
			  	  	int dt2_fieldIdJkje = Util.getIntValue(wfBillfield_hm.get("mx2jkje"), 0);
			  	  	int dt2_fieldIdYhje = Util.getIntValue(wfBillfield_hm.get("mx2yhje"), 0);
			  	  	int dt2_fieldIdSpzje = Util.getIntValue(wfBillfield_hm.get("mx2spzdhje"), 0);
			  	  	int dt2_fieldIdWhje = Util.getIntValue(wfBillfield_hm.get("mx2whje"), 0);
			  	  	int dt2_fieldIdCxje = Util.getIntValue(wfBillfield_hm.get("mx2bccxje"), 0);
			  	  	
			  	  	int dt2_showJklc = 0;
			  	  	int dt2_showJkdh = 0;
			  	  	int dt2_showDnxh = 0;
			  	  	int dt2_showJkje = 0;
			  	  	int dt2_showYhje = 0;
			  	  	int dt2_showSpzje = 0;
			  	  	int dt2_showWhje = 0;
			  	  	int dt2_showCxje = 0;
			  	  	
			  	  	
			  	  	int[] fieldTypeArray = new int[]{1, 
			  	  			1, 2, 3, 
			  	  			1, 2, 3, 4, 5, 6, 7, 8};
			  	  	int[] fieldIdArray = new int[]{main_fieldIdSqr, 
			  	  			dt1_fieldIdHklx, dt1_fieldIdHkje, dt1_fieldIdTzmx, 
			  	  			dt2_fieldIdJklc, dt2_fieldIdJkdh, dt2_fieldIdDnxh, dt2_fieldIdJkje, dt2_fieldIdYhje, dt2_fieldIdSpzje, dt2_fieldIdWhje, dt2_fieldIdCxje};
			  	  	int[] isDtlArray = new int[]{0, 
			  	  			1, 1, 1, 
			  	  			1, 1, 1, 1, 1, 1, 1, 1};
			  	  	int[] showAllTypeArray = new int[]{main_showSqr, 
			  	  			dt1_showHklx, dt1_showHkje, dt1_showTzmx, 
			  	  			dt2_showJklc, dt2_showJkdh, dt2_showDnxh, dt2_showJkje, dt2_showYhje, dt2_showSpzje, dt2_showWhje, dt2_showCxje};
			  	  	int[] dtlNumberArray = new int[]{0, 
			  	  			1, 1, 1, 
			  	  			2, 2, 2, 2, 2, 2, 2, 2};
			  	  	
			  	  	int fieldTypeArrayLen = fieldTypeArray.length;
			  	  	for(int i=0;i<fieldTypeArrayLen;i++){
			  	  		int fieldType = fieldTypeArray[i];
			  	  		int fieldId = fieldIdArray[i];
			  	  		int isDtl = isDtlArray[i];
			  	  		int showAllType = showAllTypeArray[i];
			  	  		int dtlNumber = dtlNumberArray[i];
		
			  	  		sql = "select id from fnaFeeWfInfoField where mainId="+fnaFeeWfInfoId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
			  	  		rs.executeSql(sql);
			  	  		if(rs.next()){
			  	  			int id = rs.getInt("id");
			  	  			sql = "update fnaFeeWfInfoField "+
			  	  				" set workflowid="+wfid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+" "+
			  	  				" where id="+id;
			  	  			rs.executeSql(sql);
			  	  		}else{
			  	  			sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber) "+
			  	  				" values ("+
			  	  				" "+fnaFeeWfInfoId+", "+wfid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+" "+
			  	  				")";
			  	  			rs.executeSql(sql);
			  	  		}
			  	  	}
		  	  		
	  	  		}
	  	  		if(fnaFeeWfInfoId > 0){//生成动作设置
		  	  		String freezeBorrowNode1Ids = "";//冻结借款-节点前附加操作
		  	  		String freezeBorrowNode2Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//冻结借款-节点后附加操作
		  	  		String freezeBorrowNode3Ids = "";//冻结借款-出口附加操作
	
		  	  		String repaymentBorrowNode1Ids = "";//冲销借款-节点前附加操作
		  	  		String repaymentBorrowNode2Ids = Util.getIntValue(_workflow_nodeId_array[1])+"";//冲销借款-节点后附加操作
		  	  		String repaymentBorrowNode3Ids = "";//冲销借款-出口附加操作
	
		  	  		String releaseFreezeBorrowNode1Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//释放冻结借款-节点前附加操作
		  	  		String releaseFreezeBorrowNode2Ids = "";//释放冻结借款-节点后附加操作
		  	  		String releaseFreezeBorrowNode3Ids = "";//释放冻结借款-出口附加操作
		  	  		
		  	  		FnaWfSet.saveActionSet2WfReplayment(freezeBorrowNode1Ids, freezeBorrowNode2Ids, freezeBorrowNode3Ids, 
		  	  				repaymentBorrowNode1Ids, repaymentBorrowNode2Ids, repaymentBorrowNode3Ids, 
		  	  				releaseFreezeBorrowNode1Ids, releaseFreezeBorrowNode2Ids, releaseFreezeBorrowNode3Ids, 
		  	  				wfid);
		  	  		
	  	  		}
	  	  		
	  	  	}

		}else if("fnaFeeWf".equals(creatType)){//费用报销流程
  	  		if(fnaFeeWfInfoId <= 0){//生成主信息
	  	  		int enable = 1;
	  			String templateFile = FnaWfSet.TEMPLATE_FILE;
	  			String templateFileMobile = FnaWfSet.TEMPLATE_FILE_MOBILE;
	  			int fnaWfTypeReverse = 0;
	  			int fnaWfTypeColl = 0;
	  			if(enableRepayment==1){
		  			fnaWfTypeReverse = 2;
		  			fnaWfTypeColl = 3;
	  			}
	  		
	  			sql = "INSERT INTO fnaFeeWfInfo \n" +
	  				" (workflowid, enable, lastModifiedDate, templateFile, templateFileMobile, "+
	  				"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim)\n" +
	  				" VALUES\n" +
	  				" ("+wfid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
	  				" 'fnaFeeWf', 0, "+fnaWfTypeColl+", "+fnaWfTypeReverse+", 1 "+
	  				")";
	  			rs.executeSql(sql);
	
	  			sql = "select id from fnaFeeWfInfo where workflowid = "+wfid;
	  			rs.executeSql(sql);
	  			if(rs.next()){
	  				fnaFeeWfInfoId = rs.getInt("id");
	  			}

	  			if(fnaWfTypeReverse > 0){
	  				String promptSC = "本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！";
	  				
	  				//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
	  				FnaWfSet.clearOldFnaFeeWfInfoLogicReverseData(wfid);
	  				
	  				FnaWfSet.saveOrUpdateFnaWfSetLogicReverse(fnaFeeWfInfoId, 
	  						1, 2, 
	  						1, 2, 
	  						0, 0, 
	  						0, 0, 
	  						0, 0, 
	  						promptSC, "", "");
	  			}
				
	  	  		if(fnaFeeWfInfoId > 0){//生成字段定义信息
					sql = "update workflow_base \n" +
						" set custompage = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFile)+"', "+
						" custompage4Emoble = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFileMobile)+"' "+
						" where id = "+wfid;
					rs.executeSql(sql);
	
					
			  	  	int main_fieldIdSqr = Util.getIntValue(wfBillfield_hm.get("sqr"), 0);
			  	  	int main_fieldIdFysqlc = 0;//Util.getIntValue(wfBillfield_hm.get("ysqlc"), 0);
			  	  	int main_fieldIdSfbxwc = 0;//Util.getIntValue(wfBillfield_hm.get("bxwc"), 0);
		
			  	  	int main_showSqr = 0;
			  	  	int main_showFysqlc = 0;
			  	  	int main_showSfbxwc = 0;
		
			  	  	int fieldIdSubject = Util.getIntValue(wfBillfield_hm.get("mx1fykm"), 0);
			  	  	int fieldIdOrgType = Util.getIntValue(wfBillfield_hm.get("mx1cdlx"), 0);
			  	  	int fieldIdOrgId = Util.getIntValue(wfBillfield_hm.get("mx1cdzt"), 0);
			  	  	int fieldIdOccurdate = Util.getIntValue(wfBillfield_hm.get("mx1fyrq"), 0);
			  	  	int fieldIdAmount = Util.getIntValue(wfBillfield_hm.get("mx1bxje"), 0);
			  	  	int fieldIdHrmInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
			  	  	int fieldIdDepInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
			  	  	int fieldIdSubInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
			  	  	int fieldIdFccInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
		
			  	  	int showAllTypeSubject = 0;
			  	  	int showAllTypeOrgType = 0;
			  	  	int showAllTypeOrgId = 0;
			  	  	int showAllTypeOccurdate = 0;
			  	  	int showAllTypeAmount = 0;
			  	  	int showAllTypeHrmInfo = 0;
			  	  	int showAllTypeDepInfo = 0;
			  	  	int showAllTypeSubInfo = 0;
			  	  	int showAllTypeFccInfo = 0;
		
			  	  	int dt2_fieldIdJklc = Util.getIntValue(wfBillfield_hm.get("mx2jklc"), 0);
			  	  	int dt2_fieldIdJkdh = Util.getIntValue(wfBillfield_hm.get("mx2jkdh"), 0);
			  	  	int dt2_fieldIdDnxh = Util.getIntValue(wfBillfield_hm.get("mx2dnxh"), 0);
			  	  	int dt2_fieldIdJkje = Util.getIntValue(wfBillfield_hm.get("mx2jkje"), 0);
			  	  	int dt2_fieldIdYhje = Util.getIntValue(wfBillfield_hm.get("mx2yhje"), 0);
			  	  	int dt2_fieldIdSpzje = Util.getIntValue(wfBillfield_hm.get("mx2spzdhje"), 0);
			  	  	int dt2_fieldIdWhje = Util.getIntValue(wfBillfield_hm.get("mx2whje"), 0);
			  	  	int dt2_fieldIdCxje = Util.getIntValue(wfBillfield_hm.get("mx2bccxje"), 0);
			  	  	
			  	  	int dt2_showJklc = 0;
			  	  	int dt2_showJkdh = 0;
			  	  	int dt2_showDnxh = 0;
			  	  	int dt2_showJkje = 0;
			  	  	int dt2_showYhje = 0;
			  	  	int dt2_showSpzje = 0;
			  	  	int dt2_showWhje = 0;
			  	  	int dt2_showCxje = 0;
		
		
			  	  	int dt3_fieldIdSkfs = Util.getIntValue(wfBillfield_hm.get("mx3skfs"), 0);
			  	  	int dt3_fieldIdSkje = Util.getIntValue(wfBillfield_hm.get("mx3skje"), 0);
			  	  	int dt3_fieldIdKhyh = Util.getIntValue(wfBillfield_hm.get("mx3khyh"), 0);
			  	  	int dt3_fieldIdHuming = Util.getIntValue(wfBillfield_hm.get("mx3hm"), 0);
			  	  	int dt3_fieldIdSkzh = Util.getIntValue(wfBillfield_hm.get("mx3skzh"), 0);
			  	  	
			  	  	int dt3_showSkfs = 0;
			  	  	int dt3_showSkje = 0;
			  	  	int dt3_showKhyh = 0;
			  	  	int dt3_showHuming = 0;
			  	  	int dt3_showSkzh = 0;
		
			  	  	int fieldIdSubject_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubject, null);
			  	  	int fieldIdOrgType_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgType, null);
			  	  	int fieldIdOrgId_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOrgId, null);
			  	  	int fieldIdOccurdate_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdOccurdate, null);
			  	  	int fieldIdAmount_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdAmount, null);
			  	  	int fieldIdHrmInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdHrmInfo, null);
			  	  	int fieldIdDepInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdDepInfo, null);
			  	  	int fieldIdSubInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdSubInfo, null);
			  	  	int fieldIdFccInfo_isDtl = FnaWfSet.getWfFieldIsDtlByFieldId(fieldIdFccInfo, null);
			  	  	
			  	  	int[] fieldTypeArray = new int[]{1, 2, 3, 
			  	  			1, 2, 3, 4, 5, 6, 7, 8, 9, 
			  	  			1, 2, 3, 4, 5, 6, 7, 8, 
			  	  			1, 2, 3, 4, 5};
			  	  	int[] fieldIdArray = new int[]{main_fieldIdSqr, main_fieldIdFysqlc, main_fieldIdSfbxwc, 
			  	  			fieldIdSubject, fieldIdOrgType, fieldIdOrgId, fieldIdOccurdate, fieldIdAmount, fieldIdHrmInfo, fieldIdDepInfo, fieldIdSubInfo, fieldIdFccInfo, 
			  	  			dt2_fieldIdJklc, dt2_fieldIdJkdh, dt2_fieldIdDnxh, dt2_fieldIdJkje, dt2_fieldIdYhje, dt2_fieldIdSpzje, dt2_fieldIdWhje, dt2_fieldIdCxje, 
			  	  			dt3_fieldIdSkfs, dt3_fieldIdSkje, dt3_fieldIdKhyh, dt3_fieldIdHuming, dt3_fieldIdSkzh};
			  	  	int[] isDtlArray = new int[]{0, 0, 0, 
			  	  			fieldIdSubject_isDtl, fieldIdOrgType_isDtl, fieldIdOrgId_isDtl, fieldIdOccurdate_isDtl, fieldIdAmount_isDtl, fieldIdHrmInfo_isDtl, fieldIdDepInfo_isDtl, fieldIdSubInfo_isDtl, fieldIdFccInfo_isDtl, 
			  	  			1, 1, 1, 1, 1, 1, 1, 1, 
			  	  			1, 1, 1, 1, 1};
			  	  	int[] showAllTypeArray = new int[]{main_showSqr, main_showFysqlc, main_showSfbxwc, 
			  	  			showAllTypeSubject, showAllTypeOrgType, showAllTypeOrgId, showAllTypeOccurdate, showAllTypeAmount, showAllTypeHrmInfo, showAllTypeDepInfo, showAllTypeSubInfo, showAllTypeFccInfo, 
			  	  			dt2_showJklc, dt2_showJkdh, dt2_showDnxh, dt2_showJkje, dt2_showYhje, dt2_showSpzje, dt2_showWhje, dt2_showCxje, 
			  	  			dt3_showSkfs, dt3_showSkje, dt3_showKhyh, dt3_showHuming, dt3_showSkzh};
			  	  	int[] dtlNumberArray = new int[]{0, 0, 0, 
			  	  			1, 1, 1, 1, 1, 1, 1, 1, 1, 
			  	  			2, 2, 2, 2, 2, 2, 2, 2, 
			  	  			3, 3, 3, 3, 3};
			  	  	
			  	  	int fieldTypeArrayLen = fieldTypeArray.length;
			  	  	for(int i=0;i<fieldTypeArrayLen;i++){
			  	  		int fieldType = fieldTypeArray[i];
			  	  		int fieldId = fieldIdArray[i];
			  	  		int isDtl = isDtlArray[i];
			  	  		int showAllType = showAllTypeArray[i];
			  	  		int dtlNumber = dtlNumberArray[i];
		
			  	  		sql = "select id from fnaFeeWfInfoField where mainId="+fnaFeeWfInfoId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
			  	  		rs.executeSql(sql);
			  	  		if(rs.next()){
			  	  			int id = rs.getInt("id");
			  	  			sql = "update fnaFeeWfInfoField "+
			  	  				" set workflowid="+wfid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+" "+
			  	  				" where id="+id;
			  	  			rs.executeSql(sql);
			  	  		}else{
			  	  			sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber) "+
			  	  				" values ("+
			  	  				" "+fnaFeeWfInfoId+", "+wfid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+" "+
			  	  				")";
			  	  			rs.executeSql(sql);
			  	  		}
			  	  	}
			  	  	
	  	  		}
	  	  		if(fnaFeeWfInfoId > 0){//生成动作设置
			  	  	String frozeNode1Ids = "";//冻结-节点前附加操作
			  	  	String frozeNode2Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//冻结-节点后附加操作
			  	  	String frozeNode3Ids = "";//冻结-出口附加操作
			  	  	
			  	  	String deductNode1Ids = "";//扣除-节点前附加操作
			  	  	String deductNode2Ids = Util.getIntValue(_workflow_nodeId_array[1])+"";//扣除-节点后附加操作
			  	  	String deductNode3Ids = "";//扣除-出口附加操作
			  	  	
			  	  	String releaseNode1Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//释放-节点前附加操作
			  	  	String releaseNode2Ids = "";//释放-节点后附加操作
			  	  	String releaseNode3Ids = "";//释放-出口附加操作

			  	  	String freezeBorrowNode1Ids = "";//冻结借款-节点前附加操作
			  	  	String freezeBorrowNode2Ids = "";//冻结借款-节点后附加操作
			  	  	String freezeBorrowNode3Ids = "";//冻结借款-出口附加操作
		
			  	  	String repaymentBorrowNode1Ids = "";//冲销借款-节点前附加操作
			  	  	String repaymentBorrowNode2Ids = "";//冲销借款-节点后附加操作
			  	  	String repaymentBorrowNode3Ids = "";//冲销借款-出口附加操作
		
			  	  	String releaseFreezeBorrowNode1Ids = "";//释放冻结借款-节点前附加操作
			  	  	String releaseFreezeBorrowNode2Ids = "";//释放冻结借款-节点后附加操作
			  	  	String releaseFreezeBorrowNode3Ids = "";//释放冻结借款-出口附加操作

		  			if(enableRepayment==1){
				  	  	freezeBorrowNode2Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//冻结借款-节点后附加操作
				  	  	repaymentBorrowNode2Ids = Util.getIntValue(_workflow_nodeId_array[1])+"";//冲销借款-节点后附加操作
				  	  	releaseFreezeBorrowNode1Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//释放冻结借款-节点前附加操作
		  			}
			  	  	
			  	  	FnaWfSet.saveActionSet2Wf(frozeNode1Ids, frozeNode2Ids, frozeNode3Ids, 
			  	  			deductNode1Ids, deductNode2Ids, deductNode3Ids, 
			  	  			releaseNode1Ids, releaseNode2Ids, releaseNode3Ids, 
			  	  			wfid);
			  	  	
			  	  	FnaWfSet.saveActionSet2WfReplayment(freezeBorrowNode1Ids, freezeBorrowNode2Ids, freezeBorrowNode3Ids, 
			  	  			repaymentBorrowNode1Ids, repaymentBorrowNode2Ids, repaymentBorrowNode3Ids, 
			  	  			releaseFreezeBorrowNode1Ids, releaseFreezeBorrowNode2Ids, releaseFreezeBorrowNode3Ids, 
			  	  			wfid);
		  	  		
	  	  		}
	  	  	}
			
		}else if("change".equals(creatType)){//预算变更流程
  	  		if(fnaFeeWfInfoId <= 0){//生成主信息
				int enable = 1;
	  			String templateFile = FnaWfSet.TEMPLATE_CHANGE_FILE;
	  			String templateFileMobile = FnaWfSet.TEMPLATE_CHANGE_FILE_MOBILE;
	
				sql = "INSERT INTO fnaFeeWfInfo \n" +
					" (workflowid, enable, lastModifiedDate, templateFile, templateFileMobile, "+
					"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim)\n" +
					" VALUES\n" +
					" ("+wfid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
					" 'change', 1, 2, 0, 0 "+
					")";
				rs.executeSql(sql);
	
				sql = "select id from fnaFeeWfInfo where workflowid = "+wfid;
				rs.executeSql(sql);
				if(rs.next()){
					fnaFeeWfInfoId = rs.getInt("id");
				}
				
	  	  		if(fnaFeeWfInfoId > 0){//生成字段定义信息
					sql = "update workflow_base \n" +
						" set custompage = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFile)+"', "+
						" custompage4Emoble = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFileMobile)+"' "+
						" where id = "+wfid;
					rs.executeSql(sql);
		
					
			  	  	int fieldIdSubject = Util.getIntValue(wfBillfield_hm.get("mx1fykm"), 0);
			  	  	int fieldIdOrgType = Util.getIntValue(wfBillfield_hm.get("mx1cdlx"), 0);
			  	  	int fieldIdOrgId = Util.getIntValue(wfBillfield_hm.get("mx1cdzt"), 0);
			  	  	int fieldIdOccurdate = Util.getIntValue(wfBillfield_hm.get("mx1fyrq"), 0);
			  	  	int fieldIdAmount = Util.getIntValue(wfBillfield_hm.get("mx1bxje"), 0);
			  	  	int fieldIdHrmInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
			  	  	int fieldIdDepInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
			  	  	int fieldIdSubInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
			  	  	int fieldIdFccInfo = Util.getIntValue(wfBillfield_hm.get("mx1ysxx"), 0);
		
			  	  	int fieldIdSubject2 = 0;
			  	  	int fieldIdOrgType2 = 0;
			  	  	int fieldIdOrgId2 = 0;
			  	  	int fieldIdOccurdate2 = 0;
			  	  	int fieldIdHrmInfo2 = 0;
			  	  	int fieldIdDepInfo2 = 0;
			  	  	int fieldIdSubInfo2 = 0;
			  	  	int fieldIdFccInfo2 = 0;
		
			  	  	int showAllTypeSubject = 0;
			  	  	int showAllTypeOrgType = 0;
			  	  	int showAllTypeOrgId = 0;
			  	  	int showAllTypeOccurdate = 0;
			  	  	int showAllTypeAmount = 0;
			  	  	int showAllTypeHrmInfo = 0;
			  	  	int showAllTypeDepInfo = 0;
			  	  	int showAllTypeSubInfo = 0;
			  	  	int showAllTypeFccInfo = 0;
		
			  	  	int showAllTypeSubject2 = 0;
			  	  	int showAllTypeOrgType2 = 0;
			  	  	int showAllTypeOrgId2 = 0;
			  	  	int showAllTypeOccurdate2 = 0;
			  	  	int showAllTypeHrmInfo2 = 0;
			  	  	int showAllTypeDepInfo2 = 0;
			  	  	int showAllTypeSubInfo2 = 0;
			  	  	int showAllTypeFccInfo2 = 0;
			  	  	
			  	  	
			  	  	
			  	  	int[] fieldTypeArray = new int[]{1, 2, 3, 4, 5, 6, 7, 8, 9, 
			  	  			10, 11, 12, 13, 14, 15, 16, 17};
			  	  	int[] fieldIdArray = new int[]{fieldIdSubject, fieldIdOrgType, fieldIdOrgId, fieldIdOccurdate, fieldIdAmount, fieldIdHrmInfo, fieldIdDepInfo, fieldIdSubInfo, fieldIdFccInfo, 
			  	  			fieldIdSubject2, fieldIdOrgType2, fieldIdOrgId2, fieldIdOccurdate2, fieldIdHrmInfo2, fieldIdDepInfo2, fieldIdSubInfo2, fieldIdFccInfo2};
			  	  	int[] isDtlArray = new int[]{1, 1, 1, 1, 1, 1, 1, 1, 1, 
			  	  			1, 1, 1, 1, 1, 1, 1, 1};
			  	  	int[] showAllTypeArray = new int[]{showAllTypeSubject, showAllTypeOrgType, showAllTypeOrgId, showAllTypeOccurdate, showAllTypeAmount, showAllTypeHrmInfo, showAllTypeDepInfo, showAllTypeSubInfo, showAllTypeFccInfo, 
			  	  			showAllTypeSubject2, showAllTypeOrgType2, showAllTypeOrgId2, showAllTypeOccurdate2, showAllTypeHrmInfo2, showAllTypeDepInfo2, showAllTypeSubInfo2, showAllTypeFccInfo2};
			  	  	int[] dtlNumberArray = new int[]{1, 1, 1, 1, 1, 1, 1, 1, 1, 
			  	  			1, 1, 1, 1, 1, 1, 1, 1};
			  	  	
			  	  	int fieldTypeArrayLen = fieldTypeArray.length;
			  	  	for(int i=0;i<fieldTypeArrayLen;i++){
			  	  		int fieldType = fieldTypeArray[i];
			  	  		int fieldId = fieldIdArray[i];
			  	  		int isDtl = isDtlArray[i];
			  	  		int showAllType = showAllTypeArray[i];
			  	  		int dtlNumber = dtlNumberArray[i];
		
			  	  		sql = "select id from fnaFeeWfInfoField where mainId="+fnaFeeWfInfoId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
			  	  		rs.executeSql(sql);
			  	  		if(rs.next()){
			  	  			int id = rs.getInt("id");
			  	  			sql = "update fnaFeeWfInfoField "+
			  	  				" set workflowid="+wfid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+" "+
			  	  				" where id="+id;
			  	  			rs.executeSql(sql);
			  	  		}else{
			  	  			sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber) "+
			  	  				" values ("+
			  	  				" "+fnaFeeWfInfoId+", "+wfid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+" "+
			  	  				")";
			  	  			rs.executeSql(sql);
			  	  		}
			  	  	}
			  	  	
	  	  		}
	  	  		if(fnaFeeWfInfoId > 0){//生成动作设置//保存：费控动作
			  	  	String frozeNode1Ids = "";//冻结-节点前附加操作
			  	  	String frozeNode2Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//冻结-节点后附加操作
			  	  	String frozeNode3Ids = "";//冻结-出口附加操作
			  	  	
			  	  	String effectNode1Ids = "";//生效-节点前附加操作
			  	  	String effectNode2Ids = Util.getIntValue(_workflow_nodeId_array[1])+"";//生效-节点后附加操作
			  	  	String effectNode3Ids = "";//生效-出口附加操作
			  	  	
			  	  	String releaseNode1Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//释放-节点前附加操作
			  	  	String releaseNode2Ids = "";//释放-节点后附加操作
			  	  	String releaseNode3Ids = "";//释放-出口附加操作
			  	  	
			  	  	FnaWfSet.saveActionSet2WfChange(frozeNode1Ids, frozeNode2Ids, frozeNode3Ids, 
			  	  			effectNode1Ids, effectNode2Ids, effectNode3Ids, 
			  	  			releaseNode1Ids, releaseNode2Ids, releaseNode3Ids, 
			  	  		wfid);
	  	  		}
  	  		}
			
		}else if("share".equals(creatType)){//费用分摊流程
  	  		if(fnaFeeWfInfoId <= 0){//生成主信息
	  	  		int enable = 1;
	  			String templateFile = FnaWfSet.TEMPLATE_SHARE_FILE;
	  			String templateFileMobile = FnaWfSet.TEMPLATE_SHARE_FILE_MOBILE;
	  	  		
  	  			sql = "INSERT INTO fnaFeeWfInfo \n" +
  	  				" (workflowid, enable, lastModifiedDate, templateFile, templateFileMobile, "+
  	  				"  fnaWfType, fnaWfTypeBorrow, fnaWfTypeColl, fnaWfTypeReverse, fnaWfTypeReim)\n" +
  	  				" VALUES\n" +
  	  				" ("+wfid+", "+enable+", '"+StringEscapeUtils.escapeSql(currentdate)+"', '"+StringEscapeUtils.escapeSql(templateFile)+"', '"+StringEscapeUtils.escapeSql(templateFileMobile)+"', "+
  	  				" 'share', 1, 2, 0, 0 "+
  	  				")";
  	  			rs.executeSql(sql);

  	  			sql = "select id from fnaFeeWfInfo where workflowid = "+wfid;
  	  			rs.executeSql(sql);
  	  			if(rs.next()){
					fnaFeeWfInfoId = rs.getInt("id");
  	  			}
				
	  	  		if(fnaFeeWfInfoId > 0){//生成字段定义信息
					sql = "update workflow_base \n" +
						" set custompage = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFile)+"', "+
						" custompage4Emoble = '"+StringEscapeUtils.escapeSql("/fna/template/"+templateFileMobile)+"' "+
						" where id = "+wfid;
					rs.executeSql(sql);
					
					
		  	  		int fieldIdSubject = Util.getIntValue(wfBillfield_hm.get("mx1trkm"), 0);
		  	  		int fieldIdOrgType = Util.getIntValue(wfBillfield_hm.get("mx1tccdlx"), 0);
		  	  		int fieldIdOrgId = Util.getIntValue(wfBillfield_hm.get("mx1tccdzt"), 0);
		  	  		int fieldIdOccurdate = Util.getIntValue(wfBillfield_hm.get("mx1trrq"), 0);
		  	  		int fieldIdAmount = Util.getIntValue(wfBillfield_hm.get("mx1ftje"), 0);
		  	  		int fieldIdHrmInfo = Util.getIntValue(wfBillfield_hm.get("mx1tcysxx"), 0);
		  	  		int fieldIdDepInfo = Util.getIntValue(wfBillfield_hm.get("mx1tcysxx"), 0);
		  	  		int fieldIdSubInfo = Util.getIntValue(wfBillfield_hm.get("mx1tcysxx"), 0);
		  	  		int fieldIdFccInfo = Util.getIntValue(wfBillfield_hm.get("mx1tcysxx"), 0);
	
		  	  		int fieldIdSubject2 = 0;//Util.getIntValue(wfBillfield_hm.get("mx1trkm"), 0);
		  	  		int fieldIdOrgType2 = Util.getIntValue(wfBillfield_hm.get("mx1trcdlx"), 0);
		  	  		int fieldIdOrgId2 = Util.getIntValue(wfBillfield_hm.get("mx1trcdzt"), 0);
		  	  		int fieldIdOccurdate2 = 0;//Util.getIntValue(wfBillfield_hm.get("mx1trrq"), 0);
		  	  		int fieldIdHrmInfo2 = Util.getIntValue(wfBillfield_hm.get("mx1trysxx"), 0);
		  	  		int fieldIdDepInfo2 = Util.getIntValue(wfBillfield_hm.get("mx1trysxx"), 0);
		  	  		int fieldIdSubInfo2 = Util.getIntValue(wfBillfield_hm.get("mx1trysxx"), 0);
		  	  		int fieldIdFccInfo2 = Util.getIntValue(wfBillfield_hm.get("mx1trysxx"), 0);
	
		  	  		int showAllTypeSubject = 0;
		  	  		int showAllTypeOrgType = 0;
		  	  		int showAllTypeOrgId = 0;
		  	  		int showAllTypeOccurdate = 0;
		  	  		int showAllTypeAmount = 0;
		  	  		int showAllTypeHrmInfo = 0;
		  	  		int showAllTypeDepInfo = 0;
		  	  		int showAllTypeSubInfo = 0;
		  	  		int showAllTypeFccInfo = 0;
	
		  	  		int showAllTypeSubject2 = 0;
		  	  		int showAllTypeOrgType2 = 0;
		  	  		int showAllTypeOrgId2 = 0;
		  	  		int showAllTypeOccurdate2 = 0;
		  	  		int showAllTypeHrmInfo2 = 0;
		  	  		int showAllTypeDepInfo2 = 0;
		  	  		int showAllTypeSubInfo2 = 0;
		  	  		int showAllTypeFccInfo2 = 0;
		  	  		
		  	  		
		  	  		
		  	  		int[] fieldTypeArray = new int[]{1, 2, 3, 4, 5, 6, 7, 8, 9, 
		  	  				10, 11, 12, 13, 14, 15, 16, 17};
		  	  		int[] fieldIdArray = new int[]{fieldIdSubject, fieldIdOrgType, fieldIdOrgId, fieldIdOccurdate, fieldIdAmount, fieldIdHrmInfo, fieldIdDepInfo, fieldIdSubInfo, fieldIdFccInfo, 
		  	  				fieldIdSubject2, fieldIdOrgType2, fieldIdOrgId2, fieldIdOccurdate2, fieldIdHrmInfo2, fieldIdDepInfo2, fieldIdSubInfo2, fieldIdFccInfo2};
		  	  		int[] isDtlArray = new int[]{1, 1, 1, 1, 1, 1, 1, 1, 1, 
		  	  				1, 1, 1, 1, 1, 1, 1, 1};
		  	  		int[] showAllTypeArray = new int[]{showAllTypeSubject, showAllTypeOrgType, showAllTypeOrgId, showAllTypeOccurdate, showAllTypeAmount, showAllTypeHrmInfo, showAllTypeDepInfo, showAllTypeSubInfo, showAllTypeFccInfo, 
		  	  				showAllTypeSubject2, showAllTypeOrgType2, showAllTypeOrgId2, showAllTypeOccurdate2, showAllTypeHrmInfo2, showAllTypeDepInfo2, showAllTypeSubInfo2, showAllTypeFccInfo2};
		  	  		int[] dtlNumberArray = new int[]{1, 1, 1, 1, 1, 1, 1, 1, 1, 
		  	  				1, 1, 1, 1, 1, 1, 1, 1};
		  	  		
		  	  		int fieldTypeArrayLen = fieldTypeArray.length;
		  	  		for(int i=0;i<fieldTypeArrayLen;i++){
		  	  			int fieldType = fieldTypeArray[i];
		  	  			int fieldId = fieldIdArray[i];
		  	  			int isDtl = isDtlArray[i];
		  	  			int showAllType = showAllTypeArray[i];
		  	  			int dtlNumber = dtlNumberArray[i];
	
		  	  			sql = "select id from fnaFeeWfInfoField where mainId="+fnaFeeWfInfoId+" and fieldType="+fieldType+" and dtlNumber = "+dtlNumber;
		  	  			rs.executeSql(sql);
		  	  			if(rs.next()){
		  	  				int id = rs.getInt("id");
		  	  				sql = "update fnaFeeWfInfoField "+
		  	  					" set workflowid="+wfid+", formid="+formid+", fieldId="+fieldId+", isDtl="+isDtl+", showAllType="+showAllType+", dtlNumber = "+dtlNumber+" "+
		  	  					" where id="+id;
		  	  				rs.executeSql(sql);
		  	  			}else{
		  	  				sql = "insert into fnaFeeWfInfoField (mainId, workflowid, formid, fieldType, fieldId, isDtl, showAllType, dtlNumber) "+
		  	  					" values ("+
		  	  					" "+fnaFeeWfInfoId+", "+wfid+", "+formid+", "+fieldType+", "+fieldId+", "+isDtl+", "+showAllType+", "+dtlNumber+" "+
		  	  					")";
		  	  				rs.executeSql(sql);
		  	  			}
		  	  		}

	  	  		}
	  	  		if(fnaFeeWfInfoId > 0){//生成动作设置
			  	  	String frozeNode1Ids = "";//冻结-节点前附加操作
			  	  	String frozeNode2Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//冻结-节点后附加操作
			  	  	String frozeNode3Ids = "";//冻结-出口附加操作
			  	  	
			  	  	String effectNode1Ids = "";//生效-节点前附加操作
			  	  	String effectNode2Ids = Util.getIntValue(_workflow_nodeId_array[1])+"";//生效-节点后附加操作
			  	  	String effectNode3Ids = "";//生效-出口附加操作
			  	  	
			  	  	String releaseNode1Ids = Util.getIntValue(_workflow_nodeId_array[0])+"";//释放-节点前附加操作
			  	  	String releaseNode2Ids = "";//释放-节点后附加操作
			  	  	String releaseNode3Ids = "";//释放-出口附加操作
			  	  	
			  	  	FnaWfSet.saveActionSet2WfShare(frozeNode1Ids, frozeNode2Ids, frozeNode3Ids, 
			  	  			effectNode1Ids, effectNode2Ids, effectNode3Ids, 
			  	  			releaseNode1Ids, releaseNode2Ids, releaseNode3Ids, 
			  	  			wfid);
		  	  		
	  	  		}
  	  		}
			
		}
		
  	  	if(fnaFeeWfInfoId > 0){
			sql = "update fnaFeeWfInfo set isAllNodesControl = 1 where id = " + fnaFeeWfInfoId;
			rs.executeQuery(sql);
  	  	}
		
	}catch(Exception exception){
		success = false;
		try{
			rst.rollback();
		}catch(Exception ex1){}
		new BaseBean().writeLog(exception);
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(exception.getMessage())+"}");
		out.flush();
		return;
	}
	
	out.println("{\"flag\":true,\"fnaFeeWfInfoId\":"+fnaFeeWfInfoId+",\"formid\":"+formid+",\"subcompanyid\":"+subcompanyid+",\"wfid\":"+wfid+"}");//保存成功
	out.flush();
	return;
	
}



























































%>