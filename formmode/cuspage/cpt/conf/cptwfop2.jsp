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
String wftype = Util.null2String(request.getParameter("wftype"));
String wfid = Util.fromScreen(request.getParameter("wfid"), user.getLanguage());
String formid = Util.null2String(request.getParameter("formid"));
String isopen = Util.null2String(request.getParameter("isopen"));



String currentDate=TimeUtil.getCurrentDateString();
String currentTime=TimeUtil.getOnlyCurrentTimeString();

if (method.equals("add")){
	String guid1=UUID.randomUUID().toString();
	RecordSet.executeSql("insert into uf4mode_cptwfconf(wftype,wfid,isopen,creater,createdate,createtime,lastmoddate,lastmodtime,guid1) "
			+ "values('" + wftype + "','" + wfid + "','" + isopen + "','" + user.getUID() + "','" + currentDate + "','" + currentTime + "','" + currentDate + "','" + currentTime + "','" + guid1 + "' ) ");
	RecordSet.execute("select id from uf4mode_cptwfconf where guid1='"+guid1+"' ");
	if(RecordSet.next()){
		String newid=Util.null2String( RecordSet.getString("id"));
		jsonInfo.put("newid", newid);

	}
	

	out.print(jsonInfo.toString());
}
else if (method.equals("edit")){
	String sql="";
	String sql1="select 1 from uf4mode_cptwfconf where formid='"+formid+"' and id="+id+" and wftype='"+wftype+"' ";
	RecordSet.executeSql(sql1);
	if(RecordSet.next()){
		sql="update uf4mode_cptwfconf set isopen='"+isopen+"',wftype='"+wftype+"',wfid='"+wfid+"',lastmoddate='"+currentDate+"',lastmodtime='"+currentTime+"' where id="+id+"  ";
	}else{
		sql="update uf4mode_cptwfconf set isopen='"+isopen+"',wftype='"+wftype+"',wfid='"+wfid+"',lastmoddate='"+currentDate+"',lastmodtime='"+currentTime+"' where id="+id+"  ";
	}
	RecordSet.executeSql(sql);

	out.print(jsonInfo.toString());
}else if (method.equals("delete")){

    String sql="select * from uf4mode_cptwfconf where id="+id;
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        wftype= RecordSet.getString("wftype");
        int delwfid= Util.getIntValue(RecordSet.getString("wfid"),0);
        String actname="";
        if("apply".equals(wftype)){
            actname="Mode4CptApplyAction";
        }else if("fetch".equals(wftype)){
            actname="Mode4CptFetchAction";
        }else if("move".equals(wftype)){
            actname="Mode4CptMoveAction";
        }else if("lend".equals(wftype)){
            actname="Mode4CptLendAction";
        }else if("loss".equals(wftype)){
            actname="Mode4CptLossAction";
        }else if("back".equals(wftype)){
            actname="Mode4CptBackAction";
        }else if("discard".equals(wftype)){
            actname="Mode4CptDiscardAction";
        }else if("mend".equals(wftype)){
            actname="Mode4CptMendAction";
        }
        //清掉action
        PrjWfUtil.clearActionSet(new int[]{delwfid, delwfid, delwfid}, new String[]{actname, "Mode4CptFrozenumAction", "Mode4CptReleasenumAction"});
        RecordSet.executeSql("delete uf4mode_cptwfactset where mainid= "+id);
        RecordSet.executeSql("delete uf4mode_cptwffieldmap where mainid= " + id);
        RecordSet.executeSql("delete uf4mode_cptwfconf where id=" + id);
    }

	out.print(jsonInfo.toString());
}else if (method.equals("batchdelete")){
	
	JSONArray referencedArr = new JSONArray() ;
	
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr= Util.TokenizerString2(ids, ",");
	for(int i=0;i<arr.length;i++){
		String id1 = ""+Util.getIntValue( arr[i]);

        String sql="select * from uf4mode_cptwfconf where id="+id1;
        RecordSet.executeSql(sql);
        if(RecordSet.next()){
            wftype= RecordSet.getString("wftype");
            int delwfid= Util.getIntValue(RecordSet.getString("wfid"),0);
            String actname="";
            if("apply".equals(wftype)){
                actname="Mode4CptApplyAction";
            }else if("fetch".equals(wftype)){
                actname="Mode4CptFetchAction";
            }else if("move".equals(wftype)){
                actname="Mode4CptMoveAction";
            }else if("lend".equals(wftype)){
                actname="Mode4CptLendAction";
            }else if("loss".equals(wftype)){
                actname="Mode4CptLossAction";
            }else if("back".equals(wftype)){
                actname="Mode4CptBackAction";
            }else if("discard".equals(wftype)){
                actname="Mode4CptDiscardAction";
            }else if("mend".equals(wftype)){
                actname="Mode4CptMendAction";
            }
            //清掉action
            PrjWfUtil.clearActionSet(new int[]{delwfid,delwfid,delwfid}, new String[]{actname,"Mode4CptFrozenumAction","Mode4CptReleasenumAction"});
            RecordSet.executeSql("delete uf4mode_cptwfactset where mainid= "+id1);
            RecordSet.executeSql("delete uf4mode_cptwffieldmap where mainid= "+id1);
            RecordSet.executeSql("delete uf4mode_cptwfconf where id=" + id1);
        }
	    
	}
	

	out.print(jsonInfo.toString());
    
}else if("toggleuse".equals(method)){
	String sql="update uf4mode_cptwfconf set isopen='"+isopen+"' where id="+id;
	RecordSet.executeSql(sql);

	out.print(jsonInfo.toString());
}else if("genform".equalsIgnoreCase(method)){
	
	boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
	boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
	boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;
	//新建表单采用与单据相同的模式 TD8730 MYQ修改
  	int formid1 = -1;
	int tmpFormid = formid1;
  	String from = "mode4cptwf";
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
	  		RecordSet.executeSql("update workflow_bill set from_module_='mode4cptwf' where id="+formid1);
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
		TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap(""+wftype);
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
						JSONObject v= (JSONObject)entry.getValue().clone() ;
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
						  if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main+" add "+fieldname+" "+fielddbtype);
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
						JSONObject v= (JSONObject)entry.getValue().clone();
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
						//更新主表结构
						  if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("256")||type.equals("257"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+fielddbtype);
						  }else if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){
						  	  RecordSetTrans.executeSql("alter table "+formtable_main_dt1+" add "+fieldname+" "+fielddbtype);
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
	out.print(jsonInfo.toString());
	
}else if("saveact".equalsIgnoreCase(method)){//保存action
	
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
	RecordSet.executeSql("delete from uf4mode_cptwfactset where id not in("+keepgroupids+") and mainid="+mainid);
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
					sql="update uf4mode_cptwfactset set objid='"+objid+"',customervalue='"+customervalue+"',isnode='"+isnode+"',isTriggerReject='"+isTriggerReject+"' where id="+groupid;
				}else{
					sql="insert into uf4mode_cptwfactset(objid,customervalue,isnode,isTriggerReject,mainid) values('"+objid+"','"+customervalue+"','"+isnode+"','"+isTriggerReject+"','"+mainid+"') ";
				}
				RecordSet.executeSql(sql);

			}
		}
	}
	String actname="";
    if("apply".equals(wftype)){
        actname="Mode4CptApplyAction";
    }else if("fetch".equals(wftype)){
        actname="Mode4CptFetchAction";
    }else if("move".equals(wftype)){
        actname="Mode4CptMoveAction";
    }else if("lend".equals(wftype)){
        actname="Mode4CptLendAction";
    }else if("loss".equals(wftype)){
        actname="Mode4CptLossAction";
    }else if("back".equals(wftype)){
        actname="Mode4CptBackAction";
    }else if("discard".equals(wftype)){
        actname="Mode4CptDiscardAction";
    }else if("mend".equals(wftype)){
        actname="Mode4CptMendAction";
    }

    //清掉action
    int delwfid=Util.getIntValue(wfid,0);
    PrjWfUtil.clearActionSet(new int[]{delwfid,delwfid,delwfid}, new String[]{actname,"Mode4CptFrozenumAction","Mode4CptReleasenumAction"});

	RecordSet.executeSql("select * from uf4mode_cptwfactset where mainid="+mainid);
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
			int cusval=Util.getIntValue(RecordSet.getString("customervalue"),0);
			if(cusval==1){//业务动作
                customervalue[i]=actname;
			}else if(cusval==2){//冻结动作
                customervalue[i]="Mode4CptFrozenumAction";
			}else if(cusval==3){//冻结动作
                customervalue[i]="Mode4CptReleasenumAction";
			}

			i++;
		}
		PrjWfUtil.saveActionSet(nodeIdsArray, workflowid, isnode, ispreadd, customervalue, isTriggerReject);


	}
		
		
		

//	PrjWfConfComInfo.removeCache();
	out.println(jsonInfo.toString());
}else if("fieldmap".equalsIgnoreCase(method)){//字段配置
	int sqr=0;
	int zczl=0;
	int zc=0;
	int sl=0;
	int jg=0;
	int rq=0;
	int ggxh=0;
	int cfdd=0;
	int bz=0;
	int wxqx=0;
	int wxdw=0;

	if("apply".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("apply_sqr"),0);
		zczl=Util.getIntValue(request.getParameter("apply_zczl"),0);
		sl=Util.getIntValue(request.getParameter("apply_sl"),0);
		jg=Util.getIntValue(request.getParameter("apply_jg"),0);
		rq=Util.getIntValue(request.getParameter("apply_rq"),0);
		ggxh=Util.getIntValue(request.getParameter("apply_ggxh"),0);
		cfdd=Util.getIntValue(request.getParameter("apply_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("apply_bz"),0);
	}else if("fetch".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("fetch_sqr"),0);
		zc=Util.getIntValue(request.getParameter("fetch_zc"),0);
		sl=Util.getIntValue(request.getParameter("fetch_sl"),0);
		rq=Util.getIntValue(request.getParameter("fetch_rq"),0);
		cfdd=Util.getIntValue(request.getParameter("fetch_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("fetch_bz"),0);
	}else if("move".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("move_sqr"),0);
		zc=Util.getIntValue(request.getParameter("move_zc"),0);
		rq=Util.getIntValue(request.getParameter("move_rq"),0);
		cfdd=Util.getIntValue(request.getParameter("move_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("move_bz"),0);
	}else if("lend".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("lend_sqr"),0);
		zc=Util.getIntValue(request.getParameter("lend_zc"),0);
		rq=Util.getIntValue(request.getParameter("lend_rq"),0);
		cfdd=Util.getIntValue(request.getParameter("lend_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("lend_bz"),0);
	}else if("loss".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("loss_sqr"),0);
		zc=Util.getIntValue(request.getParameter("loss_zc"),0);
		sl=Util.getIntValue(request.getParameter("loss_sl"),0);
		jg=Util.getIntValue(request.getParameter("loss_jg"),0);
		rq=Util.getIntValue(request.getParameter("loss_rq"),0);
		cfdd=Util.getIntValue(request.getParameter("loss_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("loss_bz"),0);
	}else if("back".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("back_sqr"),0);
		zc=Util.getIntValue(request.getParameter("back_zc"),0);
		rq=Util.getIntValue(request.getParameter("back_rq"),0);
		cfdd=Util.getIntValue(request.getParameter("back_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("back_bz"),0);
	}else if("discard".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("discard_sqr"),0);
		zc=Util.getIntValue(request.getParameter("discard_zc"),0);
		sl=Util.getIntValue(request.getParameter("discard_sl"),0);
		jg=Util.getIntValue(request.getParameter("discard_jg"),0);
		rq=Util.getIntValue(request.getParameter("discard_rq"),0);
		cfdd=Util.getIntValue(request.getParameter("discard_cfdd"),0);
		bz=Util.getIntValue(request.getParameter("discard_bz"),0);
	}else if("mend".equals(wftype)){
		sqr=Util.getIntValue(request.getParameter("mend_sqr"),0);
		zc=Util.getIntValue(request.getParameter("mend_zc"),0);
		jg=Util.getIntValue(request.getParameter("mend_jg"),0);
		rq=Util.getIntValue(request.getParameter("mend_rq"),0);
		bz=Util.getIntValue(request.getParameter("mend_bz"),0);
		wxqx=Util.getIntValue(request.getParameter("mend_wxqx"),0);
		wxdw=Util.getIntValue(request.getParameter("mend_wxdw"),0);
	}
	RecordSet.executeSql("update uf4mode_cptwfconf set "+
			" sqr='"+sqr+"' "+
			", zczl='"+zczl+"' "+
			", zc='"+zc+"' "+
			", sl='"+sl+"' "+
			", jg='"+jg+"' "+
			", rq='"+rq+"' "+
			", ggxh='"+ggxh+"' "+
			", cfdd='"+cfdd+"' "+
			", bz='"+bz+"' "+
			", wxqx='"+wxqx+"' "+
			", wxdw='"+wxdw+"' "+
			" where id="+id);


	out.println(jsonInfo.toString());
}else if("checkwfexists".equalsIgnoreCase(method)){//检查重复流程配置
	RecordSet.executeSql("select 1 from uf4mode_cptwfconf t where t.wfid="+wfid+" and t.wftype="+wftype+" and id not in("+Util.getIntValue(id,0)+")");
	if(RecordSet.next()){
		jsonInfo.put("errmsg", ""+SystemEnv.getHtmlLabelNames("83795",user.getLanguage()));
	}
	out.println(jsonInfo.toString());
}

else {
	
	out.println(jsonInfo.toString());
}

%>
