<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,weaver.hrm.pm.domain.*"%>
<%@ page import="weaver.workflow.workflow.WorkflowBillComInfo"%>
<%@ page import="weaver.conn.RecordSetTrans,org.json.JSONObject"%>
<%@ page import="weaver.general.Util,weaver.hrm.User,weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="page"/>
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />
<jsp:useBean id="stateProcFieldsManager" class="weaver.hrm.pm.manager.HrmStateProcFieldsManager" scope="page" />
<%
	User user=HrmUserVarify.getUser(request, response);
	if(user==null) return;
	JSONObject jsonInfo=new JSONObject();
	int field006 = strUtil.parseToInt(request.getParameter("field006"), 0);
	boolean isoracle = rs.getDBType().equals("oracle") ;
	boolean issqlserver = rs.getDBType().equals("sqlserver");
  	String formname = strUtil.vString(request.getParameter("formName"));
  	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formname = Util.toHtmlForSplitPage(formname);
  	rs.executeSql("select COUNT(*) from (select t2.labelname from workflow_bill t left join htmllabelinfo t2 on t.namelabel = t2.indexid where t2.labelname = '"+formname+"' union all select formname from workflow_formbase where formname = '"+formname+"') t");
  	if(rs.next() && rs.getInt(1) > 0){
  		String errorLabel = SystemEnv.getHtmlLabelName(83791, user.getLanguage());
  		jsonInfo.put("errmsg", errorLabel);
  		out.print(jsonInfo.toString());
  		return;
  	}
	
  	String formdes = strUtil.vString(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formdes = Util.toHtmlForSplitPage(formdes);
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
  	int subCompanyId3 = Util.getIntValue(request.getParameter("subcompanyid3"),-1);
  	int formid1 = FormManager.getNewFormId();
  	String formtable_main = "formtable_main_"+formid1*(-1);
  	if(formid1 < -1) {
  		boolean success = false;
  		RecordSetTrans.setAutoCommit(false);
  		try{
		  	int namelabelid = -1;
		  	if(issqlserver) RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' collate Chinese_PRC_CS_AI and languageid="+user.getLanguage());
		  	else RecordSetTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' and languageid="+user.getLanguage());
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
			int minSubId = -1;
		  	if(subcompanyid==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
		  		RecordSetTrans.executeSql("select dftsubcomid from SystemSet");
		  		if(RecordSetTrans.next()) subcompanyid = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
		  		if(subcompanyid==-1){
		  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
		  			if(RecordSetTrans.next()) {
						minSubId = subcompanyid = RecordSetTrans.getInt("id");
					}
		  		}
		  	}
		  	if(subCompanyId3==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
		  		RecordSetTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
		  		if(RecordSetTrans.next()){
		  			subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("fmdftsubcomid"),-1);
		  			if(subCompanyId3 == -1) subCompanyId3 = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
		  		}
		  		if(subCompanyId3 == -1){
					if(minSubId == -1) {
						RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
						if(RecordSetTrans.next()) subCompanyId3 = RecordSetTrans.getInt("id");
					} else {
						subCompanyId3 = minSubId;
					}
		  		}
		  	}
  			RecordSetTrans.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3,from_module_) values("+formid1+",'"+namelabelid+"','"+formtable_main+"','mainid','"+formdes+"','"+subcompanyid+"','"+subCompanyId3+"','hrm_mf')");
  			if(isoracle){//创建表单主表，明细表的创建在新建字段的时候如果有明细字段则创建明细表
	  			RecordSetTrans.executeSql("create table " + formtable_main + "(id integer primary key not null, requestId integer)");
	  		}else{
	  			RecordSetTrans.executeSql("create table " + formtable_main + "(id int IDENTITY(1,1) primary key CLUSTERED, requestId integer)");
	  		}
  			RecordSetTrans.commit();
  			if(isoracle){
	  			rs.executeSql("create sequence "+formtable_main+"_Id start with 1 increment by 1 nomaxvalue nocycle nocache");
	  			rs.setChecksql(false);
	  			rs.executeSql("CREATE OR REPLACE TRIGGER "+formtable_main+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main+"_Id.nextval into :new.id from dual; end;");
	  		}
			LabelComInfo.addLabeInfoCache(String.valueOf(namelabelid));
			BillComInfo.addBillCache(""+formid1);
			WorkflowBillComInfo workflowBillComInfo=new WorkflowBillComInfo();
			workflowBillComInfo.addWorkflowBillCache(String.valueOf(formid1));
			success = true;
  		}catch(Exception exception){
			exception.printStackTrace();
			success = false;
			RecordSetTrans.rollback();
		}
  		//根据已有表单新建表单，需要把原表单的信息复制过来
  		if(success){
	  		int oldformid = Util.getIntValue(request.getParameter("oldformid"), 0);
	  		if(oldformid != 0){
	  			int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	  			FormManager.setFormInfoByTemplate(formid1, oldformid);
	  		}
  		}
	  	RecordSetTrans = new RecordSetTrans();
	  	RecordSetTrans.setAutoCommit(false);		
		HrmStateProcSet setBean = new HrmStateProcSet();
		setBean.setField006(field006);
		List list = stateProcFieldsManager.find("[map]field001:"+setBean.getBillId()+";languageid:"+user.getLanguage());
	  	//生成主表字段
		try{
			HrmStateProcFields bean = null;
			String fieldname = "";
			String fielddbtype = "";
			int height = 0;
			for(int i=0; i<list.size(); i++){
				bean = (HrmStateProcFields)list.get(i);
				fieldname = bean.getField002();
				fielddbtype = bean.getField004();
				if(isoracle){
					if("text".equalsIgnoreCase(fielddbtype)) {
						fielddbtype = "varchar2(4000)";
					} else if(fielddbtype.indexOf("varchar(")!=-1) {
						fielddbtype = fielddbtype.replace("varchar(", "varchar2(");
					}
				}
				RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+fielddbtype);
				if(bean.getField005() == 2){
					height = 4;
				}
				String insertsql="INSERT INTO workflow_billfield(billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,dsporder,viewtype,detailtable,textheight,textheight_2,childfieldid,imgwidth,imgheight) VALUES ("+formid1+",'"+fieldname+"','"+bean.getField003()+"','"+fielddbtype+"','"+bean.getField005()+"','"+bean.getField006()+"','"+bean.getField009()+"',"+0+",'','"+height+"','','','','')";
				RecordSetTrans.executeSql(insertsql);
			}
			RecordSetTrans.commit();
		}catch(Exception e){
			String errorLabel = SystemEnv.getHtmlLabelName(83793, user.getLanguage());
			jsonInfo.put("errmsg", errorLabel);
			out.print(jsonInfo.toString());
			RecordSetTrans.rollback();
			return;
		}
	}
	jsonInfo.put("formId", formid1);
	jsonInfo.put("formName", formname);
	out.print(jsonInfo.toString());
%>
