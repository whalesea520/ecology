<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@page import="weaver.formmode.customjavacode.CustomJavaCodeRun"%>
<%@page import="weaver.formmode.service.CommonConstant"%>
<%@page import="weaver.formmode.dao.BaseDao"%>

<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.weaver.formmodel.data.dao.FormfieldDao"%>
<%@page import="com.weaver.formmodel.data.model.Formfield"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.formmode.search.FormModeTransMethod"%>
<%@page import="weaver.servicefiles.BrowserXML"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%
out.clear();
JSONObject result = new JSONObject();
String[] btvArray; 
try {
	request.setCharacterEncoding("UTF-8");
	User user = MobileUserInit.getUser(request,response);
	RecordSet recordSet = new RecordSet();
	String method = Util.null2String(request.getParameter("method"));
	String browserId = Util.null2String(request.getParameter("browserId"));
	String showfield = Util.null2String(request.getParameter("showField"));
	String datasourcename = "";
	if(request.getParameter("datasourcename") == null || request.getParameter("datasourcename").equals("")){
		datasourcename = DataSourceXML.SYS_LOCAL_POOLNAME;
	}else{
		datasourcename = request.getParameter("datasourcename");
	}
	String btvArrayString = Util.null2String(request.getParameter("btvArrayString"));
	String beTriggerdetail = "";
	if(StringHelper.isNotEmpty(btvArrayString)){
		if("256".equals(browserId) || "257".equals(browserId)){	//自定义树形单选,多选
			int index = showfield.indexOf("field");
			String fieldId = showfield;
			if(index > -1){
				fieldId = showfield.substring(5);
			}
			String sql = "select fielddbtype from workflow_billfield where fieldhtmltype=3 and id="+fieldId;
			recordSet.executeSql(sql);
			String fielddbtype = "";
			if(recordSet.next()){
				fielddbtype = Util.null2String(recordSet.getString("fielddbtype"));
			}
    		CustomTreeData CustomTreeData = new CustomTreeData();
    		String idstr = btvArrayString.toString().trim();
    		if(idstr.indexOf(",") == 0){
    			idstr = idstr.substring(1);
    		}
			java.util.List<Map> list = CustomTreeData.getSelectedDatas(fielddbtype, idstr);
			java.util.List<String> idList = Util.TokenizerString(idstr,",");
    		for(int i = 0; i < idList.size(); i++){
    			for(Map map :list){
    				String tempid = Util.null2String(map.get("id"));
    				if(tempid.equals(idList.get(i))){
    					beTriggerdetail += "," + Util.null2String(map.get("name"));
    				}
    			}
    		}
    	}else{
    		btvArray = btvArrayString.split(",");
			String workflow_billfield_id="";
			String poolname = "";
			String browserSearch = "";
			String _customid = "";
			
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
			
			String refsql = "select * from workflow_browserurl where id =" + browserId;
			recordSet.execute(refsql);
			String sqlwhere = " where 1=1 ";
			JSONArray jsonarray = new JSONArray();
			
			int totalRecordCount = 0;
			if(recordSet.next()) {
				String reftable = recordSet.getString("tablename");
				String keyfield = recordSet.getString("keycolumname");
				String viewfield = recordSet.getString("columname");
				String fielddbtype = recordSet.getString("fielddbtype");
				     
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
					String search = StringHelper.null2String(browser.getSearch()).toLowerCase().trim();
							 
					if(browser.getFrom().equals("2")){
						reftable = "(" + search + ")";
									 
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
						String[] fieldArr=search.split(",");
						keyfield=fieldArr[0].substring(6).trim();
						viewfield=fieldArr[1].trim();
						String tableStr=search.substring(search.indexOf(" from "));
						tableStr=tableStr.substring(6).trim();
						if(tableStr.indexOf(" ")==-1){
							reftable=tableStr;
						}else{
							reftable=tableStr.substring(0,tableStr.indexOf(" "));
						}
					}
				}
				     
				/**增加browser框查询限定条件**/
				/*if(StringHelper.isNotEmpty(fielddbtype)){
					String pointId = fielddbtype.replaceAll("browser.", "");
					BrowserXML browserXML = new BrowserXML();
					Hashtable dataHST = browserXML.getDataHST();
					Hashtable datadetailHST = (Hashtable)dataHST.get(pointId);
					if(datadetailHST != null){
						String customid = (String)datadetailHST.get("customid");
						if(StringHelper.isNotEmpty(customid)){
							RecordSet reS = new RecordSet();
							reS.execute("select a.defaultsql,a.searchconditiontype,a.javafilename from mode_custombrowser a where a.id="+customid);
							if(reS.next()){
								String searchconditiontype = Util.null2String(reS.getString("searchconditiontype"));
								searchconditiontype = searchconditiontype.equals("") ? "1" : searchconditiontype;
												
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
				}*/
				     
				int wIndex;
				if((wIndex = browserSearch.toLowerCase().lastIndexOf("where ")) > -1){
					String whereSearch = browserSearch.substring(wIndex + 6);
					     	
					String params = Util.null2String(request.getParameter("params"));
					JSONObject paramsJson = JSONObject.fromObject(params);
					//nj = $nj$ and bj = $bj$
					if(whereSearch.indexOf("$")>-1){
						int beginIndex = whereSearch.indexOf("$");
						while(beginIndex>-1){
							int endIndex = whereSearch.indexOf("$",beginIndex+1);
							if(endIndex>-1){
								String parentName = whereSearch.substring(beginIndex+1, endIndex);
								String parentValue = paramsJson.getString("_" + parentName);
								whereSearch = whereSearch.replace("$"+parentName+"$", parentValue);
													
								beginIndex = whereSearch.indexOf("$");
							}else{
								break;
							}
						}
					}
						 	
					sqlwhere = sqlwhere + " and "+ whereSearch;
				}
				     
				BaseDao baseDao = new BaseDao();
				     
				List<Map<String, Object>> selectDataList = new ArrayList<Map<String, Object>>();
				if(StringHelper.isNotEmpty(_customid)){
					selectDataList = baseDao.getResultByList("select selectvalue,selectname from workflow_SelectItem where fieldid in(select b.id from mode_custombrowser a, workflow_billfield b where a.formid=b.billid and a.id="+_customid+" and b.fieldname='"+viewfield+"' and fieldhtmltype=5)");
				}
				     
				List<String> btvList = Arrays.asList(btvArray);
				Map<String, String> triggerdetail = new HashMap<String, String>();
				     
				String sqlw = "select "+keyfield+","+viewfield+" from "+reftable+" t1 "+sqlwhere;
				recordSet.executeSql(sqlw, (poolname=="") ? datasourcename : poolname);
				while(recordSet.next()) {
					String objid = recordSet.getString(keyfield);
					String objname = recordSet.getString(viewfield);
					    	 
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
					    	 
					if(btvList.contains(objid)){
						triggerdetail.put(objid, objname);
					}
				    	 
				}
				
				for (int i = 0; i < btvArray.length; i++) {
					String v = triggerdetail.get(btvArray[i]);
					if(StringHelper.isNotEmpty(v)){
						beTriggerdetail += "," + v;
					}
				}
			}
    	}
	}
	result.put("status", "1");
	result.put("beTriggerdetail", beTriggerdetail);
}catch (Exception e) {
	e.printStackTrace();
	result.put("status", "-1");
	//result.put("status", e);
}
out.print(result.toString());
out.flush();
out.close();
%>