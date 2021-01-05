<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.search.FormModeTransMethod"%>
<%@ page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@	page import="weaver.formmode.dao.BaseDao"%>
<%@	page import="weaver.hrm.*"%>
<%@	page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@	page import="java.io.IOException"%>
<%@	page import="java.net.URLDecoder"%>
<%@ page import="weaver.crm.CrmShareBase"%>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="java.util.regex.*"%>

<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="browserInfoService" class="weaver.formmode.service.BrowserInfoService" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>

<%
String action = Util.null2String(request.getParameter("action"));
if("getListData".equals(action)){
	JSONObject resultObj = new JSONObject();
	try {
		long curr = System.currentTimeMillis();
		User user = MobileUserInit.getUser(request,response);
		
		String browserId = Util.null2String(request.getParameter("browserId"));
		String browserName = Util.null2String(request.getParameter("browserName"));
		
		int pageNo = Util.getIntValue(request.getParameter("pageNo"), 1);
		int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
		
		String searchKey = "";
		try {
			searchKey = URLDecoder.decode(Util.null2String(request.getParameter("searchKey")), "utf-8");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		
		boolean isFromIntegrationCenter = false;/*是否集成中心浏览框*/
		String sqlwhere = "";
		String poolname = "";
		String orderby = "";
		String orderbyField = "";
		String expandfield = "";
		int totalSize = 0;
		boolean single = true;
		JSONArray dataArr = new JSONArray();
		JSONArray selDataArr = new JSONArray();
		
		if(StringHelper.isNotEmpty(browserId)){
			String refsql = "select * from workflow_browserurl where id =" + browserId;
			RecordSet rs = new RecordSet();
			rs.execute(refsql);
			if(rs.next()){
				String reftable = rs.getString("tablename");
				String keyfield = rs.getString("keycolumname");
				String viewfield = rs.getString("columname");
				String fielddbtype = rs.getString("fielddbtype");
				single = (fielddbtype.equalsIgnoreCase("int") || fielddbtype.equalsIgnoreCase("integer")) ? true : false;
				int sortWay = 1;
				String customid = "";
				int norightlist = -1;
				
				if(StringHelper.isEmpty(reftable) && StringHelper.isNotEmpty(browserName)){
					Browser browser = (Browser)StaticObj.getServiceByFullname(browserName, Browser.class);
					poolname = browser.getPoolname();
					customid = StringHelper.null2String(browser.getCustomid());
					String search = StringHelper.null2String(browser.getSearch()).trim();
					
					//nj = $nj$ and bj = $bj$
					String params = Util.null2String(request.getParameter("params"));
					JSONObject paramsJson = JSONObject.fromObject(params);
					Set<String> paramNameSet = paramsJson.keySet();
					for(String paramName : paramNameSet){
						String tmpName = paramName.substring("fieldname_".length());
						String paramValue =  paramsJson.getString(paramName);
						search = search.replace("$"+tmpName+"$", paramValue);
					}
		 
					if(browser.getFrom().equals("2")){//集成中心浏览框
						isFromIntegrationCenter = true;
						BrowserManager browserManager = new BrowserManager();
						search = browserManager.replaceDefaultValue(user.getUID() + "", search);						
						
						Pattern p = Pattern.compile("order\\s+by");
						Matcher m = p.matcher(search);
						if(m.find()){
							String[] searchArray = p.split(search);
							search = searchArray[0];
							orderby = searchArray[1];
						}

						reftable = "(" + search + ")";
						 
						String newtype = browserName.substring("browser.".length());
						String sql = "select keyfield from datashowset where showname='"+newtype+"' and showclass=1 ";
						rs.execute(sql);
						if(rs.next()){
							keyfield = StringHelper.null2String(rs.getString("keyfield"));
						}
						 
						Map showfieldMap = browser.getShowfieldMap();
						Set showfieldSet = showfieldMap.keySet();
						for(Object showfieldObj : showfieldSet){
							viewfield = showfieldObj.toString() ;
							break;
						}
						
					}else{//建模浏览框
					 	String[] fieldArr = search.split(",");
						
						String sql = "select workflow_billfield.fieldname from Mode_CustomBrowser Mode_CustomBrowser "+
						 	"left join mode_custombrowserdspfield mode_custombrowserdspfield on Mode_CustomBrowser.id=mode_custombrowserdspfield.customid "+
						 	"left join workflow_billfield workflow_billfield on workflow_billfield.id=mode_custombrowserdspfield.fieldid "+
						 	"where Mode_CustomBrowser.id="+customid+" and mode_custombrowserdspfield.ispk='1'";
						rs.execute(sql);
						if(rs.next()){
							keyfield = StringHelper.null2String(rs.getString("fieldname"));
						}
						viewfield = fieldArr[1].trim();
						expandfield = fieldArr[2].split("from")[0].trim();
						expandfield = StringHelper.isNotEmpty(expandfield) ? ("," + expandfield + " exp1") : "";
						String tableStr = search.substring(search.toLowerCase().indexOf(" from "));
						tableStr = tableStr.substring(6).trim();
						if(tableStr.indexOf(" ")==-1){
							reftable = tableStr;
						}else{
							reftable = tableStr.substring(0,tableStr.indexOf(" "));
						}
						
						try{
							int wIndex;
							if ((wIndex = search.indexOf("where ")) > -1) {
								String whereSearch = search.substring(wIndex + 6);
								sqlwhere = sqlwhere + " and " + whereSearch;
							}
						}catch(Exception e){
							e.printStackTrace();
						}
					}
					
					if("161".equals(browserId)){
						single = true;
					}else if("162".equals(browserId)){
						single = false;
					}
					
					/**表单建模浏览框固定查询条件**/
					if(StringHelper.isNotEmpty(customid)){
						RecordSet reS = new RecordSet();
						reS.execute("select a.defaultsql,a.searchconditiontype,a.javafilename,a.norightlist from mode_custombrowser a where a.id="+customid);
						if(reS.next()){
							String searchconditiontype = Util.null2String(reS.getString("searchconditiontype"));
							searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
							String sqlCondition = "";
							norightlist = reS.getInt("norightlist");
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
				
				String rightsql = "";
				String sqlfrom = reftable + " t1";
				//sqlwhere = viewfield + " like '%" + searchKey + "%' " + sqlwhere + " ";
				String sqlwhere2 = viewfield + " like '%" + searchKey + "%' ";
				if("HrmDepartment".equalsIgnoreCase(reftable) || "HrmDepartmentallview".equalsIgnoreCase(reftable)){// 部门或者部门视图，要过滤掉封存的数据
					sqlwhere2 += " and (t1.canceled is null or t1.canceled=0) ";
				}else if("hrmsubcompany".equalsIgnoreCase(reftable) || "hrmsubcompanyallview".equalsIgnoreCase(reftable)){// 分部或者分部视图，要过滤掉封存的数据
					sqlwhere2 += " and (t1.canceled is null or t1.canceled=0) ";
				}else if("HrmResource".equalsIgnoreCase(reftable) || "HrmResourceallview".equalsIgnoreCase(reftable)){//人员或者人员视图，要过滤掉离职人员
					sqlwhere2 += " and (t1.status IN (0, 1, 2, 3)) ";
				}
				
				/**BEGIN 系统自定义浏览框权限过滤 BEGIN**/
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
				/**END 系统自定义浏览框权限过滤 END**/
				
				/**BEGIN 表单建模浏览框模块权限过滤 BEGIN**/
				if(StringHelper.isNotEmpty(customid)){
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
					if(!isVirtualForm && norightlist != 1){// 虚拟表单和无权限列表不考虑权限
						
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
				/**END 表单建模浏览框模块权限过滤 END**/
				
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
				if(keyfield.equalsIgnoreCase(viewfield)){
     				spp.setBackFields(viewfield + expandfield + orderbyField);
			    }else{
			     	spp.setBackFields(keyfield + "," + viewfield + expandfield + orderbyField);
			    }
				spp.setSqlWhere(sqlwhere);
				spp.setPoolname(poolname);
				spp.setSqlOrderBy(orderby);
				spp.setSortWay(sortWay);
				SplitPageUtil spu = new SplitPageUtil();
				spu.setSpp(spp);
				totalSize = spu.getRecordCount();
				if(isFromIntegrationCenter && !"".equals(orderby)){//对于集成中心浏览框，此处通过设置PrimaryKey为" "来取消默认对主键字段添加的排序，与表单建模中保持一致不做额外排序处理
					spp.setPrimaryKey(" ");
				}
				RecordSet rs2 = spu.getCurrentPageRs(pageNo,pageSize);
				while(rs2.next()) {
					String objid = rs2.getString(keyfield);
					String objname = rs2.getString(viewfield);
					String objname2 = rs2.getString("exp1");
					
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("id",objid);
					jsonObj.put("objname", Util.formatMultiLang(objname));
					jsonObj.put("objname2", Util.formatMultiLang(objname2));
					dataArr.add(jsonObj);
				}
				
				String selectedIds = Util.null2String(request.getParameter("selectedIds"));
				if(!selectedIds.equals("")){
					String sqlIds = StringHelper.formatMutiIDs(selectedIds);
					String sqlSel = "select " + keyfield + "," + viewfield + expandfield + " from " + reftable + " t1 where t1." + keyfield + " in (" + sqlIds + ")";
					RecordSet rsSel = new RecordSet();
					if (!"".equals(poolname)) {
						rsSel.executeSql(sqlSel, poolname);
					} else {
						rsSel.executeSql(sqlSel);
					}
					
					while(rsSel.next()) {
						String objid = rsSel.getString(keyfield);
						String objname = rsSel.getString(viewfield);
						String objname2 = rsSel.getString("exp1");
						
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("id",objid);
						jsonObj.put("objname", Util.formatMultiLang(objname));
						jsonObj.put("objname2", Util.formatMultiLang(objname2));
						selDataArr.add(jsonObj);
					}
				}
			}
		}

		long curr2 = System.currentTimeMillis() - curr;
		
		resultObj.put("time", curr2);
		resultObj.put("single", single);
		resultObj.put("totalSize", totalSize);
		resultObj.put("datas", dataArr);
		resultObj.put("sel_datas", selDataArr);
		resultObj.put("status", "1");
	} catch (Exception ex) {
		ex.printStackTrace();
		resultObj.put("status", "0");
		resultObj.put("errMsg", ex.getMessage());
	}finally{
		try{
			out.print(resultObj.toString());
			out.flush();
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
}
%>
