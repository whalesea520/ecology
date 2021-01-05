<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@	page import="com.weaver.formmodel.util.StringHelper"%>
<%@	page import="com.weaver.formmodel.data.dao.FormfieldDao"%>
<%@	page import="com.weaver.formmodel.data.model.Formfield"%>
<%@	page import="weaver.interfaces.workflow.browser.Browser"%>
<%@	page import="com.weaver.formmodel.util.NumberHelper"%>
<%@	page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@	page import="weaver.hrm.*"%>
<%@	page import="weaver.formmode.search.FormModeTransMethod"%>
<%@	page import="weaver.servicefiles.BrowserXML"%>
<%@	page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@	page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@	page import="weaver.formmode.dao.BaseDao"%>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.general.browserData.BrowserManager"%>

<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="browserInfoService" class="weaver.formmode.service.BrowserInfoService" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<%
request.setCharacterEncoding("UTF-8");
User user = MobileUserInit.getUser(request,response);
RecordSet recordSet = new RecordSet();
String method = Util.null2String(request.getParameter("method"));
String browserId = request.getParameter("browserId");
String showfield = Util.null2String(request.getParameter("showField"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
String workflow_billfield_id="";
String poolname = "";
String browserSearch = "";
String _customid = "";
String orderby = "";
String orderbyField = "";
String expandfield = "";
if(showfield!=null && !showfield.equals("")){
	int index = showfield.indexOf("field");
	if(index>-1){
		workflow_billfield_id = showfield.substring(5);
		String sql = "select fielddbtype from workflow_billfield where fieldhtmltype=3 and id="+workflow_billfield_id;
		recordSet.executeSql(sql);
		if(recordSet.next()){
			String fielddbtype = Util.null2String(recordSet.getString("fielddbtype"));
			try{
				Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
				poolname =  browser.getPoolname();
				browserSearch = Util.null2String(browser.getSearch());
				_customid = Util.null2String(browser.getCustomid());
			}catch(Exception ex){}
		}
	}
}

int pageNo = Util.getIntValue(request.getParameter("pageno"), 1);
int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
String keyword = Util.null2String(request.getParameter("keyword"));
keyword = java.net.URLDecoder.decode(keyword, "UTF-8");

String refsql = "select * from workflow_browserurl where id =" + browserId;
recordSet.execute(refsql);
String sqlwhere = "";
JSONObject result = new JSONObject();
JSONArray jsonarray = new JSONArray();
boolean single=false;
int totalRecordCount = 0;
if(recordSet.next()) {
	 String reftable = recordSet.getString("tablename");
     String keyfield = recordSet.getString("keycolumname");
     String viewfield = recordSet.getString("columname");
     String fielddbtype = recordSet.getString("fielddbtype");
     single = (fielddbtype.equalsIgnoreCase("int") || fielddbtype.equalsIgnoreCase("integer")) ? true : false;
     int sortWay = 0;
     if("humres".equalsIgnoreCase(reftable)) {
	   		sqlwhere = " and isdelete = 0 and hrstatus = '4028804c16acfbc00116ccba13802935'";
	   	} else if("orgunit".equalsIgnoreCase(reftable)) {
	   		sqlwhere = " and isdelete = 0";
	   	}
     if(StringHelper.isEmpty(reftable)){
    	 String field=showfield.substring(5);
    	 FormfieldDao formfieldDao=new FormfieldDao();
    	 Formfield formfield=formfieldDao.get(NumberHelper.getIntegerValue(field));
    	 fielddbtype=formfield.getFielddbtype();
		 Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
		 browserSearch = StringHelper.null2String(browser.getSearch()).trim();
		 
		 //nj = $nj$ and bj = $bj$
		 String params = Util.null2String(request.getParameter("params"));
		 JSONObject paramsJson = JSONObject.fromObject(params);
		 Set<String> paramNameSet = paramsJson.keySet();
		 for(String paramName : paramNameSet){
		 	String tmpName = paramName.substring(1);
		 	String paramValue =  paramsJson.getString(paramName);
		 	browserSearch = browserSearch.replace("$"+tmpName+"$", paramValue);
		 }
	 	
		  if(browser.getFrom().equals("2")){
		  		
		  	 BrowserManager browserManager = new BrowserManager();
	 		 browserSearch = browserManager.replaceDefaultValue(user.getUID() + "", browserSearch);
	 		 
			 reftable = "(" + browserSearch + ")";
			 
			 String newtype = fielddbtype.substring("browser.".length());
			 String sql = "select keyfield from datashowset where showname='"+newtype+"' and showclass=1 ";
			 recordSet.execute(sql);
			 if(recordSet.next()){
				 keyfield = StringHelper.null2String(recordSet.getString("keyfield"));
			 }
			 
			Map showfieldMap = browser.getShowfieldMap();
			Set showfieldSet = showfieldMap.keySet();
			for(Object showfieldObj : showfieldSet){
				viewfield = showfieldObj.toString() ;
				break;
			}
			
		 }else{
		 	 String[] fieldArr=browserSearch.split(",");
			  //keyfield=fieldArr[0].substring(6).trim();
			 String newtype = fielddbtype.substring("browser.".length());
			String sql = "select customid from datashowset where showname='"+newtype+"' and showclass=1 ";
			recordSet.execute(sql);
			String customid = "";
			if(recordSet.next()){
				customid = StringHelper.null2String(recordSet.getString("customid"));
			}
			sql = "select workflow_billfield.fieldname from Mode_CustomBrowser Mode_CustomBrowser "+
			 	"left join mode_custombrowserdspfield mode_custombrowserdspfield on Mode_CustomBrowser.id=mode_custombrowserdspfield.customid "+
			 	"left join workflow_billfield workflow_billfield on workflow_billfield.id=mode_custombrowserdspfield.fieldid "+
			 	"where Mode_CustomBrowser.id="+customid+" and mode_custombrowserdspfield.ispk='1'";
			recordSet.execute(sql);
			if(recordSet.next()){
				keyfield = StringHelper.null2String(recordSet.getString("fieldname"));
			}
			 viewfield=fieldArr[1].trim();
			 expandfield = fieldArr[2].split("from")[0].trim();
			 expandfield = StringHelper.isNotEmpty(expandfield) ? ("," + expandfield + " exp1") : "";
			 String tableStr=browserSearch.substring(browserSearch.toLowerCase().indexOf(" from "));
			 tableStr=tableStr.substring(6).trim();
			 if(tableStr.indexOf(" ")==-1){
				 reftable=tableStr;
			 }else{
				 reftable=tableStr.substring(0,tableStr.indexOf(" "));
			 }
			 
			 int wIndex;
		     if((wIndex = browserSearch.toLowerCase().lastIndexOf("where ")) > -1){
		     	String whereSearch = browserSearch.substring(wIndex + 6);
			 	sqlwhere = sqlwhere + " and "+ whereSearch;
		     }
		 }
		 
    	 if("161".equals(browserId)){
			 single=true;
		 }else if("162".equals(browserId)){
			 single=false;
		 }
     }
     
     String customid = "0";
     int norightlist = -1;
     /**增加browser框查询限定条件**/
     if(StringHelper.isNotEmpty(fielddbtype)){
     	String pointId = fielddbtype.replaceAll("browser.", "");
     	BrowserXML browserXML = new BrowserXML();
     	Hashtable dataHST = browserXML.getDataHST();
     	Hashtable datadetailHST = (Hashtable)dataHST.get(pointId);
     	if(datadetailHST != null){
     		customid = (String)datadetailHST.get("customid");
     		if(StringHelper.isNotEmpty(customid)){
     			RecordSet reS = new RecordSet();
     			reS.execute("select a.defaultsql,a.searchconditiontype,a.javafilename,a.norightlist from mode_custombrowser a where a.id="+customid);
     			if(reS.next()){
				    String searchconditiontype = Util.null2String(reS.getString("searchconditiontype"));
					searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
					norightlist = reS.getInt("norightlist");
					String sqlCondition = "";
					if(searchconditiontype.equals("2")){	//java file
						String javafilename = Util.null2String(reS.getString("javafilename"));
						if(!javafilename.equals("")){
							Map<String, String> sourceCodePackageNameMap = CommonConstant.SOURCECODE_PACKAGENAME_MAP;
							String sourceCodePackageName = sourceCodePackageNameMap.get("3");
							String classFullName = sourceCodePackageName + "." + javafilename;
							
							Map<String, Object> param = new HashMap<String, Object>();
							param.put("user", user);
							
							Object javaResult = CustomJavaCodeRun.run(classFullName, param);
							sqlCondition = Util.null2String(javaResult);
						}
					}else{
						String defaultsql = Util.toScreenToEdit(reS.getString("defaultsql"),user.getLanguage()).trim();
	     				FormModeTransMethod formModeTransMethod = new FormModeTransMethod();
					    defaultsql = formModeTransMethod.getDefaultSql(user,defaultsql);
						sqlCondition = defaultsql;
					}
					if(!sqlCondition.equals("")){
						sqlwhere = sqlwhere + " and "+sqlCondition;
     				}
     			}
     		}
     	}
     }
     
     String rightsql = "";
    String sqlfrom = reftable + " t1";
    //sqlwhere = viewfield + " like '%" + keyword + "%' " + sqlwhere + " ";
    String sqlwhere2 = viewfield + " like '%" + keyword + "%' ";
	if("HrmDepartment".equalsIgnoreCase(reftable) || "HrmDepartmentallview".equalsIgnoreCase(reftable)){// 部门或者部门视图，要过滤掉封存的数据
		sqlwhere2 += " and (t1.canceled is null or t1.canceled=0) ";
	}else if("hrmsubcompany".equalsIgnoreCase(reftable) || "hrmsubcompanyallview".equalsIgnoreCase(reftable)){// 分部或者分部视图，要过滤掉封存的数据
		sqlwhere2 += " and (t1.canceled is null or t1.canceled=0) ";
	}else if("HrmResource".equalsIgnoreCase(reftable)){// 过滤掉状态异常的人员(0-试用 1-正式 2-临时 3-试用延期 4-解聘 5-离职 6-退休 7-无效)
		sqlwhere2 += " and t1.status in (0,1,2,3) ";
	}
	
	//系统自定义浏览框权限过滤
	if("7".equals(browserId)||"18".equals(browserId)){
		CrmShareBase crmShareBase = new CrmShareBase();
		String leftjointable = crmShareBase.getTempTable(""+user.getUID());
		if(user.getLogintype().equals("1")){
			sqlfrom += " left join "+leftjointable+" t2 on t1.id = t2.relateditemid ";
			sqlwhere2 +=" and t1.id = t2.relateditemid ";
		}else{
			sqlwhere2 +="  and t1.deleted<>1 and t1.agent="+user.getUID();
			sqlwhere2 +="  and CRM_CustomerInfo t1 "+sqlwhere+" and t1.deleted<>1 and t1.agent="+user.getUID();
		}
	}else if("8".equals(browserId)||"135".equals(browserId)){
		sqlwhere2 +=" and ("+CommonShareManager.getPrjShareWhereByUser(user)+") ";
	}else if("9".equals(browserId)||"37".equals(browserId)){
		DocSearchComInfo.resetSearchInfo() ;
		String docstatus[] = new String[]{"1","2","5","7"};
		for(int i = 0;i<docstatus.length;i++){
		   	DocSearchComInfo.addDocstatus(docstatus[i]);
		}
		String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
		tempsqlwhere+=" and (ishistory is null or ishistory = 0) ";
	    tempsqlwhere  += " and t1.id=t2.sourceid  ";
		sqlwhere2 +=" and "+tempsqlwhere;
		sqlfrom += ", "+ShareManager.getShareDetailTableByUser("doc", user) + "  t2 ";
		orderby = "doclastmoddate desc,doclastmodtime desc";
		sortWay = 1;
	}else if("16".equals(browserId)||"152".equals(browserId)||"171".equals(browserId)){
		String belongtoshow = "";		
		int userid=user.getUID();	
		String usertype = "0";
		if ("2".equals(user.getLogintype())) {
			usertype = "1";
		}
		RecordSet rswf = new RecordSet();
		rswf.executeSql("select * from HrmUserSetting where resourceId = "+userid);
		if(rswf.next()){
			belongtoshow = rswf.getString("belongtoshow");
		}
		String tempsqlwhere = " where 1 =1";
		if("171".equals(browserId)){
			tempsqlwhere +=" and workflow_requestbase.currentnodetype = 3";
		}
		if("oracle".equals(rswf.getDBType())){
			tempsqlwhere += " and (nvl(workflow_requestbase.currentstatus,-1) = -1 or (nvl(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+"))";
		} else {
			tempsqlwhere += " and (isnull(workflow_requestbase.currentstatus,-1) = -1 or (isnull(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+"))";
		}

		if("1".equals(belongtoshow)){
			if (rswf.getDBType().equals("oracle") || rswf.getDBType().equals("db2")) {
				sqlfrom=" ("+
				" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate||' '||createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +tempsqlwhere+
				" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid in (" +userid + ") and workflow_currentoperator.usertype="+usertype+
				" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
				" ) t1 ";
			}else{
				sqlfrom="("+
					" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate+' '+createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +tempsqlwhere+
					" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid in (" +userid + ") and workflow_currentoperator.usertype="+usertype+
					" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
					" ) t1 ";
			}
		}else{
			if (rswf.getDBType().equals("oracle") || rswf.getDBType().equals("db2")) {
				sqlfrom="  ("+
				" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate||' '||createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +tempsqlwhere+
				" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+
				" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
				" ) t1 ";
			}else{
				sqlfrom=" ("+
					" select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime,createdate+' '+createtime as createtimes from workflow_requestbase , workflow_currentoperator , workflow_base" +tempsqlwhere+
					" and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+
					" and workflow_requestbase.workflowid = workflow_base.id and (workflow_base.isvalid='1' or workflow_base.isvalid='3') "+
					" ) t1 ";
			}
		}
		orderby  = "createdate desc , createtime desc";
	}else if("137".equals(browserId)){
		RecordSet rscar = new RecordSet();
		rscar.executeSql("select carsdetachable from SystemSet");
		int detachable=0;
		if(rscar.next()){
		    detachable=rscar.getInt(1);
		}
		int userid=user.getUID();
		if(detachable==1){
			if(userid!=1){
				String sqltmp = "";
				String blonsubcomid="";
				char flag=Util.getSeparator();
				rscar.executeProc("HrmRoleSR_SeByURId", ""+userid+flag+"Car:Maintenance");
				while(rscar.next()){
					blonsubcomid=rscar.getString("subcompanyid");
					sqltmp += (", "+blonsubcomid);
				}
				if(!"".equals(sqltmp)){//角色设置的权限
					sqltmp = sqltmp.substring(1);
					sqlwhere2 += " and subcompanyid in ("+sqltmp+") ";
				}else{
					sqlwhere2 += " and subcompanyid="+user.getUserSubCompany1() ;
				}
			}
		}
		sortWay = 1;
		single = true;
	}else if("23".equals(browserId)){
		RecordSet rscap = new RecordSet();
		rscap.executeSql("select cptdetachable from SystemSet");
		int detachable=0;
		if(rscap.next()){
		   detachable=rscap.getInt("cptdetachable");
		}
		int userid=user.getUID();
		int belid = user.getUserSubCompany1();
		char flag=Util.getSeparator();
		String rightStr = "";
		if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
			rightStr = "Capital:Maintenance";
		}

		sqlwhere2 += " and isdata = '2' ";
		if(detachable == 1 && userid!=1){
			String sqltmp = "";
			String blonsubcomid="";
			rscap.executeProc("HrmRoleSR_SeByURId", ""+userid+flag+rightStr);
			while(rscap.next()){
			    blonsubcomid=rscap.getString("subcompanyid");
				sqltmp += (", "+blonsubcomid);
			}
			if(!"".equals(sqltmp)){//角色设置的权限
				sqltmp = sqltmp.substring(1);
				sqlwhere2 += " and blongsubcompany in ("+sqltmp+") ";
			}else{
				sqlwhere2 += " and blongsubcompany in ("+belid+") ";
			}
		}
		CommonShareManager.setAliasTableName("t2");
		sqlwhere2+= " and exists(select 1 from CptCapitalShareInfo t2 where t2.relateditemid=t1.id and ("+CommonShareManager.getShareWhereByUser("cpt", user)+") ) ";
		
		if("oracle".equalsIgnoreCase(rscap.getDBType())){
			sqlwhere2 += " and (nvl(capitalnum,0)-nvl(frozennum,0))>0 ";
		}else{
			sqlwhere2 += " and (isnull(capitalnum,0)-isnull(frozennum,0))>0 ";
		}
	}
				
	sqlwhere = sqlwhere2 + sqlwhere + " ";
	
    if(!"0".equals(customid) && customid != null){
    
    	String formID = "0";
		String formmodeid = "0";
		RecordSet reS = new RecordSet();
		reS.execute("select a.modeid,a.customname,a.customdesc,a.formid from  mode_custombrowser a where  a.id=" + customid);
		if (reS.next()) {
			formID = Util.null2String(reS.getString("formid"));
			formmodeid = Util.null2String(reS.getString("modeid"));
		}
		
		boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formID);
		//虚拟表单需求重新获取主键
		if(isVirtualForm){
			Map<String, Object> vFormInfo = new HashMap<String, Object>();
			vFormInfo = VirtualFormHandler.getVFormInfo(formID);
			keyfield = Util.null2String(vFormInfo.get("vprimarykey"));	//虚拟表单主键列名称
		}
		if (!formmodeid.equals("") && !formmodeid.equals("0") && norightlist == 1) {// 无权限列表设置了模块
			sqlwhere += " and t1.formmodeid="+formmodeid+" ";
		}
		if(!isVirtualForm && norightlist != 1){// 虚拟表单不考虑权限
			
			List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
			
			if (formmodeid.equals("") || formmodeid.equals("0")) {// 浏览框中没有设置模块
				String sqlStr1 = "select id,modename from modeinfo where formid=" + formID + " order by id";
				RecordSet rs1 = new RecordSet();
				rs1.executeSql(sqlStr1);
				while (rs1.next()) {
					String mid = rs1.getString("id");
					ModeShareManager.setModeId(Util.getIntValue(mid, 0));
					for (int i = 0; i < lsUser.size(); i++) {
						User tempUser = lsUser.get(i);
						String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode", tempUser);
						if (rightsql.isEmpty()) {
							rightsql += tempRightStr;
						} else {
							rightsql += " union  all " + tempRightStr;
						}
					}
				}
				if (!rightsql.isEmpty()) {
					rightsql = " (SELECT  sourceid,MAX(sharelevel) AS sharelevel from ( " + rightsql + " ) temptable group by temptable.sourceid) ";
				}
			} else {
				ModeShareManager.setModeId(Util.getIntValue(formmodeid, 0));
				for (int i = 0; i < lsUser.size(); i++) {
					User tempUser = (User) lsUser.get(i);
					String tempRightStr = ModeShareManager.getShareDetailTableByUser("formmode", tempUser);
					if (rightsql.isEmpty()) {
						rightsql += tempRightStr;
					} else {
						rightsql += " union  all " + tempRightStr;
					}
				}
				if (!rightsql.isEmpty()) {
					rightsql = " (SELECT  sourceid,MAX(sharelevel) AS sharelevel from ( " + rightsql + " ) temptable group by temptable.sourceid) ";
				}
			}
		
		}
		
		if (StringHelper.isNotEmpty(rightsql) && norightlist != 1) {
			sqlwhere += " and t1.id in (select sourceid from ("+rightsql+") righttable)";
		}
		orderby = browserInfoService.getOrderSQL(customid);
    }
     
     BaseDao baseDao = new BaseDao();
     
     List<Map<String, Object>> selectDataList = new ArrayList<Map<String, Object>>();
     if(StringHelper.isNotEmpty(_customid)){
     	selectDataList = baseDao.getResultByList("select selectvalue,selectname from workflow_SelectItem where fieldid in(select b.id from mode_custombrowser a, workflow_billfield b where a.formid=b.billid and a.id="+_customid+" and b.fieldname='"+viewfield+"' and fieldhtmltype=5)");
     }
     
     if(StringHelper.isEmpty(keyfield)){
		keyfield = "id";
	 }
     if(!"".equals(orderby)){
    	String orderbyStr = orderby.toLowerCase().replaceAll("t1.","").replaceAll("asc","").replaceAll("desc","");
		List orderbyList = StringHelper.string2ArrayList(orderbyStr,",");
		for(int idx = 0; idx < orderbyList.size(); idx++){
			String orderbyFColumnName = StringHelper.null2String(orderbyList.get(idx)).trim();
			if(!viewfield.toLowerCase().equals(orderbyFColumnName) && !keyfield.toLowerCase().equals(orderbyFColumnName)){
				orderbyField += ","+orderbyFColumnName;
			}
		}
	 }
     
     SplitPageParaBean spp = new SplitPageParaBean();
     spp.setSqlFrom(sqlfrom);
     spp.setPrimaryKey(keyfield);
     String backfields = "";
   	if(keyfield.equalsIgnoreCase(viewfield)){
 		backfields = viewfield + expandfield + orderbyField;
    }else{
     	backfields = keyfield + "," + viewfield + expandfield + orderbyField;
    }
    spp.setBackFields(backfields);
     spp.setSqlWhere(sqlwhere);
     spp.setPoolname(poolname);
     spp.setSqlOrderBy(orderby);
     spp.setSortWay(sortWay);
     //out.println("select "+backfields+" from "+sqlfrom+" where " + sqlwhere);
     SplitPageUtil spu = new SplitPageUtil();
     spu.setSpp(spp);
     recordSet = spu.getCurrentPageRs(pageNo,pageSize);
     totalRecordCount = spu.getRecordCount();
     while(recordSet.next()) {
    	 String objid = recordSet.getString(keyfield);
    	 String objname = recordSet.getString(viewfield);
    	 String objname2 = recordSet.getString("exp1");
    	 
    	 //处理选择项
    	 if(!selectDataList.isEmpty()){
    	 	for(Map<String, Object> map : selectDataList){
    	 		String selectvalue = Util.null2String(map.get("selectvalue"));
    	 		if(objname.equals(selectvalue)){
    	 			objname = Util.null2String(map.get("selectname"));
    	 			break;
    	 		}
    	 	}
    	 }
    	 
    	 JSONObject jsonobj = new JSONObject();
    	 jsonobj.put("objid",objid);
    	 jsonobj.put("objname",Util.formatMultiLang(objname));
    	 jsonobj.put("objname2", Util.formatMultiLang(objname2));
    	 jsonarray.add(jsonobj);
     }
}
%>
    
        <%int size =  jsonarray.size();
      	for(int i= 0 ; i < size ; i ++) {
    	  JSONObject item = jsonarray.getJSONObject(i);
    	  String objid = item.getString("objid");
    	  String objname = StringHelper.null2String(item.getString("objname"));
    	  String objname2 = StringHelper.null2String(item.getString("objname2"));
    	  %>
    	  <li>
    	  <%
    	  if(single){
    		  %>
    		<input type="radio" name="radio" id="radio-<%=objid %>" value="<%=objid %>">
          	<label id="label-<%=objid %>" for="radio-<%=objid %>"><%=objname%></label><br/>
          	<%if(StringHelper.isNotEmpty(objname2) && !objname.equals(objname2)){%>
          	<label style="padding-left: 25px;color: #b2b2b2;"><%=objname2%></label>
    		  <%
    		  }
    	  }else{
    		  %>
    		<input type="checkbox" name="checkbox-<%=objid%>" id="checkbox-<%=objid %>" value="<%=objid %>" onclick="javascript:onbrowserSelect(this)">
          	<label id="label-<%=objid %>" for="checkbox-<%=objid %>"><%=objname%></label><br/>
          	<%if(StringHelper.isNotEmpty(objname2) && !objname.equals(objname2)){%>
          	<label style="padding-left: 25px;color: #b2b2b2;"><%=objname2%></label>
    		  <%
    		  }
    	  }
    	  %>
          </li>
    	  <%
      }
    %>
    
    <%if(pageNo == 1){ %>
    	<input type="hidden" id="single" value="<%=single%>"/>
    	<input type="hidden" id="totalRecordCount" value="<%=totalRecordCount%>"/>
    <%} %>
