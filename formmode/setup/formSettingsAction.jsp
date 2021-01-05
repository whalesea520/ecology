
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="weaver.formmode.field.FieldComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.formmode.dao.BaseDao"%>
<%@ page import="weaver.conn.RecordSetTrans"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="weaver.formmode.service.CommonConstant"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.workflow.workflow.BillComInfo"%>
<%@ page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormCacheManager"%>
<%@ page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.log.LogType"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<%@ include file="/formmode/pub_init.jsp"%>
<%
response.reset();
out.clear();
FormInfoService formInfoService = new FormInfoService();
String action = Util.null2String(request.getParameter("action"));
RecordSetTrans rsTrans = new RecordSetTrans();
RecordSet rs = new RecordSet();
LogService logService = new LogService();
if(action.equalsIgnoreCase("saveFormfield")){
	try{
		int formId = Util.getIntValue(request.getParameter("formId"));
		String data = Util.null2String(request.getParameter("data"));
		data = URLDecoder.decode(data, "UTF-8");
		JSONArray dataArr = JSONArray.fromObject(data);
		for(int i = 0; i < dataArr.size(); i++){
			JSONObject jsonObject = (JSONObject)dataArr.get(i);
			int fieldId = Util.getIntValue(Util.null2String(jsonObject.get("id")));
			String fieldname = Util.null2String(jsonObject.get("fieldname"));
			if("id".equals(fieldname)){
				fieldId = -1000;
			}else if("modedatacreater".equals(fieldname)){
				fieldId = -1001;
			}else if("modedatacreatedate".equals(fieldname)){
				fieldId = -1002;
			}
			int needlog = Util.getIntValue(Util.null2String(jsonObject.get("needlog")), 0);
			int needExcel = Util.getIntValue(Util.null2String(jsonObject.get("needExcel")), 0);
			int isprompt = Util.getIntValue(Util.null2String(jsonObject.get("isprompt")), 0);
			String expendattr = Util.null2String(jsonObject.get("expendattr"));
			int impcheck = Util.getIntValue(Util.null2String(jsonObject.get("impcheck")),0);
			String checkexpression = Util.null2String(jsonObject.get("checkexpression"));
			Map<String,	Object> dataMap = new HashMap<String,	Object>();
			dataMap.put("formId", formId);
			dataMap.put("fieldId", fieldId);
			dataMap.put("needlog", needlog);
			dataMap.put("needExcel", needExcel);
			dataMap.put("isprompt", isprompt);
			dataMap.put("expendattr", expendattr);
			dataMap.put("impcheck", impcheck);
			dataMap.put("checkexpression", checkexpression);
			
			formInfoService.saveOrUpdateFieldExtend(dataMap);
		}
		logService.log(formId, Module.FORM, LogType.EDIT);
		out.print("1");
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("0");		
	}
}else if(action.equalsIgnoreCase("saveFormfield2")){
	char flag=2;
	rsTrans.setAutoCommit(false);
	try{
		int formId = Util.getIntValue(request.getParameter("formId"));
		String data = Util.null2String(request.getParameter("data"));
		data = URLDecoder.decode(data, "UTF-8");
		JSONArray dataArr = JSONArray.fromObject(data);
		
		FormManager formManager = new FormManager();
		BrowserComInfo browserComInfo = new BrowserComInfo();
		
		boolean issqlserver = CommonConstant.DB_TYPE.equals("sqlserver");
		boolean isoracle = CommonConstant.DB_TYPE.equals("oracle");
		boolean isdb2 = CommonConstant.DB_TYPE.equals("db2");
		
		String labelidsCache = ",";//更新缓存用
		Map<String,String> field_pubchoice_map = new HashMap<String,String>();
		Map<String,String> field_pubchilchoiceid_map = new HashMap<String,String>();
		List<String> field_selectlist = new ArrayList<String>();
		for(int i = 0; i < dataArr.size(); i++){
			JSONObject jsonObject = (JSONObject)dataArr.get(i);
			String fieldId = Util.null2String(jsonObject.get("id"));
			
			//不为空表示是编辑字段，为空表示新添加字段。
	  		if(!fieldId.equals("")){
				//对编辑字段先删除，再添加
				//字段编辑时不允许修改字段数据库名，不需要重新生成id，避免流程中数据丢失。TD10290
				rsTrans.executeSql("delete from workflow_SelectItem where isbill=1 and fieldid="+fieldId);//删除表workflow_SelectItem中该字段对应数据
				rsTrans.executeSql("delete from workflow_specialfield where isbill=1 and fieldid="+fieldId);//删除表workflow_specialfield中该字段对应数据	
	  		}
			
	  		String fieldname = "";//数据库字段名称
  			int fieldlabel = 0;//字段显示名标签id
  			String fielddbtype = "";//字段数据库类型
			String _fielddbtype = "";//字段数据库类型
  			String fieldhtmltype = "";//字段页面类型
  			String type = "";//字段详细类型
  			String dsporder = "";//显示顺序
  			String viewtype = "0";//viewtype="0"表示主表字段,viewtype="1"表示明细表字段
  			String detailtable = "";//明细表名
  			int textheight = 0;//多行文本框的高度
  			int places = 0;
  			
  			int imgwidth = 100;
            int imgheight = 100;
  			String selectitem = "";
  			String linkfield = "";
  			
  			fieldname = Util.null2String(jsonObject.get("fieldname"));
  			String fieldlabelname = Util.null2String(jsonObject.get("fieldlabelname"));
  			fieldlabelname = Util.StringReplace(fieldlabelname, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
  			fieldlabelname = Util.StringReplace(fieldlabelname, "'", "");//TD31514 表单字段显示名不可以含有半角单引号“'”
  			
  			if(issqlserver){
  				rsTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
  			}else{
  				rsTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+fieldlabelname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
  			}
		  	if(rsTrans.next()){
		  		fieldlabel = rsTrans.getInt("indexid");//如果字段名称在标签库中存在，取得标签id
		  	}else{
		  		fieldlabel = formManager.getNewIndexId(rsTrans);//生成新的标签id
			  	if(fieldlabel!=-1){//更新标签库
			  		labelidsCache+=fieldlabel+",";
			  		rsTrans.executeSql("delete from HtmlLabelIndex where id="+fieldlabel);
			  		rsTrans.executeSql("delete from HtmlLabelInfo where indexid="+fieldlabel);
			  		rsTrans.executeSql("INSERT INTO HtmlLabelIndex values("+fieldlabel+",'"+fieldlabelname+"')");
			  		rsTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',7)");
			  		rsTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',8)");
			  		rsTrans.executeSql("INSERT INTO HtmlLabelInfo values("+fieldlabel+",'"+fieldlabelname+"',9)");
			  	}
			}
		  	//BillComInfo billComInfo = new BillComInfo();
	  		//billComInfo.addBillCache(""+formId,fieldlabel);
		  	fieldhtmltype = Util.null2String(jsonObject.get("htmltype"));
		  	if(fieldhtmltype.equals("1")){	//单行文本
				type = Util.null2String(jsonObject.get("fieldtype"));	
				if(type.equals("1")){
					String strlength = Util.null2String(jsonObject.get("fieldattr"));
				  	if(Util.getIntValue(strlength,1)<=1) strlength = "1";
			    	if(isoracle) fielddbtype="varchar2("+strlength+")";
			    	else fielddbtype="varchar("+strlength+")";
			   	}
				
				if(type.equals("2")){
			   		if(isoracle) fielddbtype="integer";
			   		else fielddbtype="int";
			   	}
				
				if(type.equals("3")){
					int decimaldigits = Util.getIntValue(Util.null2String(jsonObject.get("fieldattr")),2);
					if(isoracle) fielddbtype="number(15,"+decimaldigits+")";
					else fielddbtype="decimal(15,"+decimaldigits+")";
				}
				 	
			   	if(type.equals("4")){
					if(isoracle) fielddbtype="number(15,2)";
			   		else fielddbtype="decimal(15,2)";
				}
			   	
			   	if(type.equals("5")){
			   		int decimaldigits = Util.getIntValue(Util.null2String(jsonObject.get("fieldattr")),2);
					if(isoracle) fielddbtype="varchar2(30)";
					else fielddbtype="varchar(30)";
			   		places=decimaldigits;
				}
			}
		  	
			if(fieldhtmltype.equals("2")){	//多行文本
			  	String htmledit = Util.null2String(jsonObject.get("fieldattr"));
				if(htmledit.equals("")){
					htmledit = "1";
				}
			  	type=htmledit;
			  	
				if(isoracle) fielddbtype="varchar2(4000)";
				else if(isdb2) fielddbtype="varchar(2000)";
				else fielddbtype="text";
				
				textheight = Util.getIntValue(Util.null2String(jsonObject.get("fieldtype")),4);
			}
			
			if(fieldhtmltype.equals("3")){	//浏览按钮
			  	int temptype = Util.getIntValue(Util.null2String(jsonObject.get("fieldtype")),0);
			  	type = ""+temptype;
			  	if(temptype>0){
			  		fielddbtype=browserComInfo.getBrowserdbtype(type+"");
			  	}
			  	
			  	if(temptype==118){
					if(isoracle) fielddbtype="varchar2(200)";
					else fielddbtype="varchar(200)";
				}
			  	
				if(temptype==161||temptype==162){
					fielddbtype=Util.null2String(jsonObject.get("fieldattr"));	//TO DO
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
					fielddbtype=Util.null2String(jsonObject.get("fieldattr"));	//TO DO
					if(isoracle) _fielddbtype="varchar2(1000)";
					else if(isdb2) _fielddbtype="varchar(1000)";
					else _fielddbtype="varchar(1000)";
				}
				
				if(temptype==224||temptype==225){
					fielddbtype=Util.null2String(jsonObject.get("fieldattr"));	//TO DO
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
					fielddbtype=Util.null2String(jsonObject.get("fieldattr"));	//TO DO
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
					
					
				if(temptype==165||temptype==166||temptype==167||temptype==168){
				  	textheight=Util.getIntValue(Util.null2String(jsonObject.get("fieldattr")),0);	//TO DO
				}
			}
			
			if(fieldhtmltype.equals("4")){	//CHECK框
				type = "1";
				fielddbtype="char(1)";
			}
			
			if(fieldhtmltype.equals("5")){	//选择框
			  	type = "1";
			  	if(isoracle) fielddbtype="integer";
			  	else fielddbtype="int";
			  	field_selectlist.add(fieldId);
			}
			
			if(fieldhtmltype.equals("8")){	//选择框
				fieldhtmltype = "5";
			  	type = "1";
			  	if(isoracle) fielddbtype="integer";
			  	else fielddbtype="int";
			  	JSONObject sel_data = (JSONObject)jsonObject.get("sel_data");
			  	selectitem = "" + Util.getIntValue(Util.null2String(sel_data.get("pubselectType")), 0);
				linkfield = "" + Util.getIntValue(Util.null2String(sel_data.get("publinkfield")), 0);
				field_pubchoice_map.put(fieldId, selectitem);
				
				field_pubchilchoiceid_map.put(fieldId,linkfield);
			}
			
			if(fieldhtmltype.equals("6")){	//附件上传
			  	type = "" + Util.getIntValue(Util.null2String(jsonObject.get("fieldtype")), 1);
			    if(isoracle) fielddbtype="varchar2(4000)";
				else if(isdb2) fielddbtype="varchar(2000)";
			    else fielddbtype="text";
                
			    String uploadPicAttr = Util.null2String(jsonObject.get("fieldattr"));
			    
			    String[] vArr = uploadPicAttr.split(";");
	        	String v1 = vArr.length > 0 ? vArr[0] : "5";
	        	String v2 = vArr.length > 1 ? vArr[1] : "100";
	        	String v3 = vArr.length > 2 ? vArr[2] : "100";
	        	
			    textheight = Util.getIntValue(v1, 0);
                imgwidth = Util.getIntValue(v2);
                imgheight = Util.getIntValue(v3);
			}
			
			if(fieldhtmltype.equals("7")){	//特殊字段
			  	type = Util.null2String(jsonObject.get("fieldtype"));
			    if(isoracle) fielddbtype="varchar2(4000)";
				else if(isdb2) fielddbtype="varchar(2000)";
			    else fielddbtype="text";
			}
			
			dsporder = Util.null2String(jsonObject.get("ordernum"));
			dsporder = ""+Util.getFloatValue(dsporder,0);
			
			JSONObject sel_data = (JSONObject)jsonObject.get("sel_data");
			int childfieldid_tmp = Util.getIntValue(Util.null2String(sel_data.get("childfieldid")), 0);
			
			if(!fieldId.equals("")){//不为空表示是编辑字段，为空表示新添加字段。
				rsTrans.executeSql("update workflow_billfield set billid="+formId+",fieldname='"+fieldname+"',fieldlabel="+fieldlabel+",fielddbtype='"+fielddbtype+"',fieldhtmltype="+fieldhtmltype+",type="+type+",dsporder="+dsporder+",viewtype="+viewtype+",detailtable='"+detailtable+"',textheight="+textheight+",childfieldid="+childfieldid_tmp+",imgwidth="+imgwidth+",imgheight="+imgheight+" ,places="+places+",pubchoiceid='"+selectitem+"',pubchilchoiceid='"+linkfield+"',linkfield='"+linkfield+"' where id="+fieldId);
			}
			
			//如果是选择框，更新表workflow_SelectItem
			String curfieldid = "";
			if(fieldId.equals("")){
			    rsTrans.executeSql("select max(id) as id from workflow_billfield");
			    if(rsTrans.next()) curfieldid = rsTrans.getString("id");
			}else{
			    curfieldid = fieldId;
			}
			
			if(fieldhtmltype.equals("5")){
				JSONArray selDetailArr = (JSONArray)sel_data.get("sel_detaildata");
				int rowsum = Util.getIntValue(Util.null2String(sel_data.get("rowsum")));
				int curvalue=0;
			  	for(int temprow=1;temprow<=rowsum;temprow++){
			  		JSONObject selDetailObj = (JSONObject)selDetailArr.get(temprow - 1);
			  		String curname = Util.null2String(selDetailObj.get("field_name"));
			  		if(curname.equals("")) continue;
			  		String curorder = Util.null2String(selDetailObj.get("field_count_name"));
			  		String isdefault = "n";
			  		String checkValue = Util.null2String(selDetailObj.get("field_checked_name"));
			  		String cancel = Util.null2String(selDetailObj.get("cancel_name"));	//TO DO 
			  		if(cancel!=null && !cancel.equals("") && cancel.equals("1")){
						cancel = "1";
					}else{
						cancel = "0";
					}
					if(checkValue.equals("1")){
						isdefault="y";
					}
					
		  			int isAccordToSubCom_tmp = Util.getIntValue(Util.null2String(selDetailObj.get("isAccordToSubCom")), 0);
					String doccatalog = Util.null2String(selDetailObj.get("maincategory"));
					String docPath = Util.null2String(selDetailObj.get("pathcategory"));
					String childItem_tmp = Util.null2String(selDetailObj.get("childItem"));
					String para=curfieldid+flag+"1"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault+flag+cancel; 
					rsTrans.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
					rsTrans.executeSql("update workflow_SelectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"',childitemid='"+childItem_tmp+"',isAccordToSubCom='"+isAccordToSubCom_tmp+"' where fieldid="+curfieldid+" and selectvalue="+curvalue);
                    curvalue++;
				}
			}
			
			if(fieldhtmltype.equals("7")){              
				String specialfield = Util.null2String(jsonObject.get("fieldtype"));//类型
				String fieldattr = Util.null2String(jsonObject.get("fieldattr"));
				String sql = "";
				if(specialfield.equals("1")){
					String[] vArr = fieldattr.split(";");
		        	String v1 = vArr.length > 0 ? vArr[0] : "";
		        	String v2 = vArr.length > 1 ? vArr[1] : "";
					String displayname = v1;//显示名
					String linkaddress = v2;//链接地址
					sql = "insert into workflow_specialfield(fieldid,displayname,linkaddress,isform,isbill) values("+curfieldid+",'"+displayname+"','"+linkaddress+"',0,1)";    
				}else{
					String descriptivetext = fieldattr;//描述性文字
					descriptivetext = Util.spacetoHtml(descriptivetext);
					sql = "insert into workflow_specialfield(fieldid,descriptivetext,isform,isbill) values("+curfieldid+",'"+descriptivetext+"',0,1)";    
				}
				rsTrans.executeSql(sql);
			}
			
			//保存字段扩展属性
			int needlog = Util.getIntValue(Util.null2String(jsonObject.get("needlog")), 0);
			int isprompt = Util.getIntValue(Util.null2String(jsonObject.get("isprompt")), 0);
			String expendattr = Util.null2String(jsonObject.get("expendattr"));
			Map<String,	Object> dataMap = new HashMap<String,	Object>();
			dataMap.put("formId", formId);
			dataMap.put("fieldId", fieldId);
			dataMap.put("needlog", needlog);
			dataMap.put("isprompt", isprompt);
			dataMap.put("expendattr", expendattr);
			formInfoService.saveOrUpdateFieldExtend(dataMap);
			
		}
		for(int i=0;i<field_selectlist.size();i++){
			rsTrans.executeSql("update workflow_billfield set pubchoiceid = null where id="+field_selectlist.get(i));
		}
		rsTrans.commit();
		for(Map.Entry<String, String> entry: field_pubchoice_map.entrySet()){
			    int fieldid = Util.getIntValue(entry.getKey(),0);
			    int pubchoiceId = Util.getIntValue(entry.getValue(),0);
				SelectItemManager.setSelectOpBypubid(formId+"",pubchoiceId,fieldid+"",1,user.getLanguage());
		}
		for(Map.Entry<String, String> entry: field_pubchilchoiceid_map.entrySet()){
			    int fieldid = Util.getIntValue(entry.getKey(),0);
			    int pubchilchoiceid = Util.getIntValue(entry.getValue(),0);
				SelectItemManager.setSuperSelectOp(formId+"",1,pubchilchoiceid,fieldid,user.getLanguage());
		}
		LabelComInfo labelComInfo = new LabelComInfo();
		ArrayList labelidsArray = Util.TokenizerString(labelidsCache,",");
		for(int i=0;i<labelidsArray.size();i++){//添加标签id到缓存
			labelComInfo.addLabeInfoCache((String)labelidsArray.get(i));
		}
		FieldComInfo fieldComInfo = new FieldComInfo();
  		fieldComInfo.removeFieldCache();
		logService.log(formId, Module.FORM, LogType.EDIT);
		
		out.print("1");
	}catch(Exception ep){
		rsTrans.rollback();
		ep.printStackTrace();
		out.print("0");		
	}
}else if(action.equalsIgnoreCase("getFieldLogDetail")){
	int viewlogid = Util.getIntValue(request.getParameter("viewlogid"));
	int modeid = Util.getIntValue(request.getParameter("modeid"));
	List<Map<String, Object>> dataList = formInfoService.getFieldLogDetailByViewlogid(viewlogid,modeid,user.getLanguage());
	//TODO 字段值按照类型转换
	JSONArray result = JSONArray.fromObject(dataList);

	//try{Thread.sleep(2000);}catch(Exception e){}
	response.setCharacterEncoding("UTF-8");
	out.print(result.toString());
}else if(action.equalsIgnoreCase("getPromptField")){
	int formId = Util.getIntValue(request.getParameter("formId"));
	JSONArray promptFieldArr = formInfoService.getPromptFieldWithJSON(formId); //数据提醒的字段信息
	//try{Thread.sleep(2000);}catch(Exception e){}
	response.setCharacterEncoding("UTF-8");
	out.print(promptFieldArr.toString());
}else if(action.equalsIgnoreCase("validatePromptFieldData")){
	int formId = Util.getIntValue(request.getParameter("formId"));
	int dataId = Util.getIntValue(request.getParameter("dataId"));
	String data = Util.null2String(request.getParameter("data"));
	data = data.replace("+", "%2B");
	data = URLDecoder.decode(data, "UTF-8");
	JSONArray dataArr = JSONArray.fromObject(data);
	String sql = "";
	String tablename = formInfoService.getTablenameByFormid(formId);
	ArrayList<String> parmArray = new ArrayList<String>();
	for(int i = 0; i < dataArr.size(); i++){
		JSONObject jsonObject = (JSONObject)dataArr.get(i);
		String fieldid = Util.null2String(jsonObject.get("fieldid"));
		String fieldname = Util.null2String(jsonObject.get("fieldname"));
		String changedValue = Util.null2String(jsonObject.get("changedValue"));
		sql += " select '"+fieldid+"' as fieldid,COUNT(1) as dcount from "+tablename+" where "+fieldname+"=? and id!="+dataId;
		parmArray.add(changedValue);
		if(i != (dataArr.size() - 1)){
			sql += " union all";
		}
	}
	rs.executeQuery(sql, parmArray.toArray());
	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
	while(rs.next()){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fieldid", Util.null2String(rs.getString("fieldid")));
		map.put("dcount", Util.getIntValue(rs.getString("dcount"),0));
		resultList.add(map);
	}
	JSONArray resultArr = JSONArray.fromObject(resultList);
	out.print(resultArr.toString());
}else if(action.equalsIgnoreCase("createIndex")){
	int formId = Util.getIntValue(request.getParameter("formId"));
	
	String tablename = Util.null2String(request.getParameter("tablename"));
	
	String indexName = Util.null2String(request.getParameter("indexName"));
	if(indexName.trim().equals("")){
		indexName = tablename + "_" + System.currentTimeMillis();
	}
	
	String uniqueFlag = Util.null2String(request.getParameter("uniqueFlag"));
	boolean isUnique = uniqueFlag.equals("1");
	String uniqueStr = "";
	if(isUnique){
		uniqueStr = "unique";
	}
	
	String indexColumns = Util.null2String(request.getParameter("indexColumns"));
	
	String errorMsg = "";
	String sql = "create "+uniqueStr+" index "+indexName+" on "+tablename+" ("+indexColumns+")";
	try{
		rsTrans.setAutoCommit(false);
		rsTrans.execute(sql);
		rsTrans.commit();
	}catch(Exception ep){
		rsTrans.rollback();
		errorMsg = ep.getMessage();
		if(rs.getDBType().equalsIgnoreCase("oracle")&&indexName.length()>30){
			errorMsg += ","+SystemEnv.getHtmlLabelName(82126,user.getLanguage())+":"+indexName+","+SystemEnv.getHtmlLabelName(128734,user.getLanguage());
		}
	}
	response.sendRedirect("/formmode/setup/formIndex.jsp?formId="+formId+"&errorMsg="+xssUtil.put(errorMsg));
	return;
}else if(action.equalsIgnoreCase("deleteIndex")){
	String indexName = Util.null2String(request.getParameter("indexName"));
	String tablename = Util.null2String(request.getParameter("tablename"));
	String sql = "drop index ";
	if(CommonConstant.DB_TYPE.equals("sqlserver")){	//单独处理sql server  Oracle删除索引不需要表名
		sql += tablename+".";
	}
	sql += indexName;
	try{
		//rsTrans.execute(sql);
		rs.executeSql(sql);
		out.print("1");
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("0");
	}
}else if(action.equalsIgnoreCase("checkform")){
	String tablename = Util.null2String(request.getParameter("tablename"));
	rs.executeSql("select id from workflow_bill where tablename ='"+tablename+"'");
	if(rs.next()){
		out.print("1");
	}else{
		out.print("0");
	}
}else if(action.equalsIgnoreCase("eidtform")){
	String formname = Util.null2String(request.getParameter("formname"));
	String formid = Util.null2String(request.getParameter("formid"));
  	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
	formname = Util.toHtmlForSplitPage(formname);
	float dsporder  = Util.getFloatValue(request.getParameter("dsporder"));
  	boolean issamename = false;
  	rs.executeSql("select namelabel from workflow_bill where id !="+formid);
    while(rs.next()){//新表单名和单据名
  	    int namelabel = Util.getIntValue(Util.null2String(rs.getString("namelabel")),0);
  	    if(namelabel!=0)
  	    {
  	        if(formname.equals(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
  	rs.executeSql("select formname from workflow_formbase where id !="+formid);
    while(rs.next()){//旧表单名
  	    String tempformname = Util.null2String(rs.getString("formname"));
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
  		//String errorMsg = URLEncoder.encode(SystemEnv.getHtmlLabelName(22750,user.getLanguage()));
  		response.sendRedirect("/formmode/setup/formbase.jsp?id="+formid+"&errorMsg=22750&errorcode=1");
	    return;
  	}
  	int namelabelid = -1;
  	boolean issqlserver = CommonConstant.DB_TYPE.equals("sqlserver") ;
  	if(issqlserver) rs.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
	else rs.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
	if(rs.next()) namelabelid = rs.getInt("indexid");//如果表单名称在标签库中存在，取得标签id
	else{
		FormManager formManager = new FormManager();
		namelabelid = formManager.getNewIndexId(rsTrans);//生成新的标签id
		if(namelabelid!=-1){//更新标签库
			rs.executeSql("delete from HtmlLabelIndex where id="+namelabelid);
			rs.executeSql("delete from HtmlLabelInfo where indexid="+namelabelid);
			rs.executeSql("INSERT INTO HtmlLabelIndex values("+namelabelid+",'"+formname+"')");
			rs.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',7)");
			rs.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',8)");
			rs.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',9)");
		}
	}
	LabelComInfo labelComInfo = new LabelComInfo();
	labelComInfo.addLabeInfoCache(""+namelabelid);//往缓存中添加表单名称的标签
	BillComInfo billComInfo = new BillComInfo();
	billComInfo.addBillCache(formid,namelabelid);
  	String formdes = Util.null2String(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formdes = Util.toHtmlForSplitPage(formdes);
  	
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
  	if(subcompanyid==-1){
		rs.executeSql("select dftsubcomid from SystemSet");
		if(rs.next()) subcompanyid = Util.getIntValue(rs.getString("dftsubcomid"),-1);
		if(subcompanyid==-1){
	  		rs.executeSql("select min(id) as id from HrmSubCompany");
	  		if(rs.next()) subcompanyid = rs.getInt("id");
		}
	}	
  	
  	int subCompanyId3 = Util.getIntValue(request.getParameter("subCompanyId3"),-1);
  	if(subCompanyId3==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
  		rsTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
  		if(rsTrans.next()){
  			subCompanyId3 = Util.getIntValue(rsTrans.getString("fmdftsubcomid"),-1);
  			if(subCompanyId3==-1){
	  			subCompanyId3 = Util.getIntValue(rsTrans.getString("dftsubcomid"),-1);
  			}
  		}
  		if(subCompanyId3==-1){
  			rsTrans.executeSql("select min(id) as id from HrmSubCompany");
  			if(rsTrans.next()) subCompanyId3 = rsTrans.getInt("id");
  		}
  	}
  	rs.executeSql("update workflow_bill set subCompanyId="+subcompanyid+",subCompanyId3="+subCompanyId3+", namelabel="+namelabelid+",formdes='"+formdes+"',dsporder='"+dsporder+"' where id="+formid);
  	
	//更新缓存中的虚拟表单数据
  	String isvirtualform = Util.null2String(request.getParameter("isvirtualform"));
  	if(isvirtualform.equals("true")){
  		String vprimarykey = Util.null2String(request.getParameter("vprimarykey"));
  		String vpkgentype =  Util.null2String(request.getParameter("vpkgentype"));
  		rs.executeSql("update ModeFormExtend set vprimarykey='"+vprimarykey+"' ,vpkgentype='"+vpkgentype+"' where formid='"+formid+"'");
  		VirtualFormCacheManager.updateVFormInCache(formid);
  	}
  	
  	logService.log(formid, Module.FORM, LogType.EDIT);
  	
  	//response.sendRedirect("/formmode/setup/formbase.jsp?id="+formid+"&isRefreshLeftData=1");
  	out.print("<script type=\"text/javascript\">parent.parent.refreshForm("+formid+");</script>");
}else if(action.equalsIgnoreCase("getFormInfoByAppIdWithJSON")){
	int appId = Util.getIntValue(request.getParameter("appId"), 0);
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), 0);
	JSONArray forminfoArr = new JSONArray();
	if(fmdetachable.equals("1")){
		forminfoArr = formInfoService.getFormInfoByAppIdWithJSONDetach(appId,subCompanyId);
	}else{
		forminfoArr = formInfoService.getFormInfoByAppIdWithJSON(appId);
	}
	response.setCharacterEncoding("UTF-8");
	out.print(forminfoArr.toString());
}else if(action.equalsIgnoreCase("getTablesByDS")){
	JSONObject result = new JSONObject();
	try{
		String dsName = Util.null2String(request.getParameter("dsName"));
		List<Map<String, Object>> dataList = formInfoService.getTablesByDS(dsName);
		JSONArray jsonArray = JSONArray.fromObject(dataList);
		result.put("status", "1");
		result.put("data", jsonArray);
	}catch(Exception ep){
		result.put("status", "0");
		//result.put("errorMsg", URLEncoder.encode(Util.null2String(ep.getMessage())));
		result.put("errorMsg",Util.null2String(ep.getMessage()));
		
	}
	response.setCharacterEncoding("UTF-8");
	out.print(result.toString());
}else if(action.equalsIgnoreCase("getFieldsByTable")){
	JSONObject result = new JSONObject();
	try{
		String dsName = Util.null2String(request.getParameter("dsName"));
		String tbName = Util.null2String(request.getParameter("tbName"));
		List<Map<String, Object>> dataList = formInfoService.getFieldsByTable(dsName, tbName);
		JSONArray jsonArray = JSONArray.fromObject(dataList);
		result.put("status", "1");
		result.put("data", jsonArray);
	}catch(Exception ep){
		result.put("status", "0");
		result.put("errorMsg", URLEncoder.encode(Util.null2String(ep.getMessage())));
	}
	response.setCharacterEncoding("UTF-8");
	out.print(result.toString());
}else if(action.equalsIgnoreCase("getFieldsByTables")){
	JSONObject result = new JSONObject();
	try{
		String dsName = Util.null2String(request.getParameter("dsName"));
		String tbArrayString = Util.null2String(request.getParameter("tbArray"));
		String[] tbArray = tbArrayString.split(",");
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
		for(String tbName : tbArray){
			List<Map<String, Object>> dataList = formInfoService.getFieldsByTable(dsName, tbName);
			resultList.addAll(dataList);
		}
		JSONArray jsonArray = JSONArray.fromObject(resultList);
		result.put("status", "1");
		result.put("data", jsonArray);
	}catch(Exception ep){
		result.put("status", "0");
		result.put("errorMsg", URLEncoder.encode(Util.null2String(ep.getMessage())));
	}
	response.setCharacterEncoding("UTF-8");
	out.print(result.toString());
}else if(action.equalsIgnoreCase("addform")){
	int appId = Util.getIntValue(request.getParameter("appId"), 0);
	
	String formname = Util.null2String(request.getParameter("formname"));
  	formname = formname.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formname = Util.toHtmlForSplitPage(formname);
  	
	//同名验证 开始 TD10194
  	boolean issamename = false;
  	rs.executeSql("select namelabel from workflow_bill");
    while(rs.next()){//新表单名和单据名
  	    int namelabel = Util.getIntValue(Util.null2String(rs.getString("namelabel")),0);
  	    if(namelabel!=0)
  	    {
  	        if(formname.equals(SystemEnv.getHtmlLabelName(namelabel,user.getLanguage())))
  	        {
  	            issamename = true;
  	            break;
  	        }
  	    }
  	}
    if(!issamename){	//再验证旧表单
	  	rs.executeSql("select formname from workflow_formbase");
	    while(rs.next()){//旧表单名
	  	    String tempformname = Util.null2String(rs.getString("formname"));
	  	    if(!tempformname.equals(""))
	  	    {
	  	        if(formname.equals(tempformname))
	  	        {
	  	            issamename = true;
	  	            break;
	  	        }
	  	    }
	  	}
    }
  	if(issamename){
  		String errorMsg = SystemEnv.getHtmlLabelName(22750,user.getLanguage());//表单名称已存在
  		response.sendRedirect("/formmode/setup/formAdd.jsp?appId=" + appId + "&errorMsg="+xssUtil.put(errorMsg)+"&errorcode=1");
	    return;
  	}
  	//同名验证 结束 TD10194
  	
  	String formdes = Util.null2String(request.getParameter("formdes"));
  	formdes = formdes.replaceAll("<","＜").replaceAll(">","＞").replaceAll("'","''");
  	formdes = Util.toHtmlForSplitPage(formdes);
  	
  	rsTrans.setAutoCommit(false);
  	try{
  		FormManager formManager = new FormManager();
		int namelabelid = -1;
		boolean issqlserver = CommonConstant.DB_TYPE.equals("sqlserver") ;
		if(issqlserver) rsTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' collate Chinese_PRC_CS_AI and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		else rsTrans.executeSql("select indexid from HtmlLabelInfo where labelname='"+formname+"' and languageid="+Util.getIntValue(""+user.getLanguage(),7));
		if(rsTrans.next()) namelabelid = rsTrans.getInt("indexid");//如果表单名称在标签库中存在，取得标签id
		else{
			namelabelid = formManager.getNewIndexId(rsTrans);//生成新的标签id
		  	if(namelabelid!=-1){//更新标签库
		  		rsTrans.executeSql("delete from HtmlLabelIndex where id="+namelabelid);
		  		rsTrans.executeSql("delete from HtmlLabelInfo where indexid="+namelabelid);
		  		rsTrans.executeSql("INSERT INTO HtmlLabelIndex values("+namelabelid+",'"+formname+"')");
		  		rsTrans.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',7)");
		  		rsTrans.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',8)");
		  		rsTrans.executeSql("INSERT INTO HtmlLabelInfo values("+namelabelid+",'"+formname+"',9)");
		  	}
		}
	  	
	  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),-1);
	  	if(subcompanyid==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
	  		rsTrans.executeSql("select dftsubcomid from SystemSet");
	  		if(rsTrans.next()) subcompanyid = Util.getIntValue(rsTrans.getString("dftsubcomid"),-1);
	  		if(subcompanyid==-1){
	  			rsTrans.executeSql("select min(id) as id from HrmSubCompany");
	  			if(rsTrans.next()) subcompanyid = rsTrans.getInt("id");
	  		}
	  	}
	  	
	  	int subCompanyId3 = Util.getIntValue(request.getParameter("subCompanyId3"),-1);
	  	if(subCompanyId3==-1){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
	  		rsTrans.executeSql("select fmdftsubcomid,dftsubcomid from SystemSet");
	  		if(rsTrans.next()){
	  			subCompanyId3 = Util.getIntValue(rsTrans.getString("fmdftsubcomid"),-1);
	  			if(subCompanyId3==-1){
		  			subCompanyId3 = Util.getIntValue(rsTrans.getString("dftsubcomid"),-1);
	  			}
	  		}
	  		if(subCompanyId3==-1){
	  			rsTrans.executeSql("select min(id) as id from HrmSubCompany");
	  			if(rsTrans.next()) subCompanyId3 = rsTrans.getInt("id");
	  		}
	  	}
	  	
	  	String formtype = Util.null2String(request.getParameter("formtype"));
	  	formtype = "1";	//暂时固定为虚拟表单
	  	
	  	int formid = formManager.getNewFormId();
	  	
	  	if(formtype.equals("0")){	//实际表单
	  		
	  		String formtable_main = "formtable_main_"+formid*(-1);//主表名
	  		rsTrans.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3) values("+formid+","+namelabelid+",'"+formtable_main+"','mainid','"+formdes+"',"+subcompanyid+","+subCompanyId3+")");
	  		
	  		String dbType = CommonConstant.DB_TYPE;
			if("oracle".equals(dbType)){//创建表单主表，明细表的创建在新建字段的时候如果有明细字段则创建明细表
				rsTrans.executeSql("create table " + formtable_main + "(id integer primary key not null, requestId integer)");
	  		}else{
	  			rsTrans.executeSql("create table " + formtable_main + "(id int IDENTITY(1,1) primary key CLUSTERED, requestId integer)");
	  		}
			rsTrans.commit();
			if("oracle".equals(dbType)){//主表id自增长
				rsTrans.executeSql("create sequence "+formtable_main+"_Id start with 1 increment by 1 nomaxvalue nocycle");
				rsTrans.setChecksql(false);
				rsTrans.executeSql("CREATE OR REPLACE TRIGGER "+formtable_main+"_Id_Trigger before insert on "+formtable_main+" for each row begin select "+formtable_main+"_Id.nextval into :new.id from dual; end;");
	  		}
			
	  	}else if(formtype.equals("1")){	//虚拟表单
	  		
	  		String vtableName = Util.null2String(request.getParameter("vtableName"));
	  		vtableName = VirtualFormHandler.getVirtualFormName(vtableName);
	  		rsTrans.executeSql("insert into workflow_bill(id,namelabel,tablename,detailkeyfield,formdes,subcompanyid,subCompanyId3) values("+formid+","+namelabelid+",'"+vtableName+"','mainid','"+formdes+"',"+subcompanyid+","+subCompanyId3+")");

	  		rsTrans.commit();
	  		
	  		String virtualformtype = Util.null2String(request.getParameter("virtualformtype"));	//虚拟表单类型   0为表  1为视图
	  		String vdatasource = Util.null2String(request.getParameter("vdatasource"));
	  		String vprimarykey = Util.null2String(request.getParameter("vprimarykey"));	//主键字段
	  		String vpkgentype = Util.null2String(request.getParameter("vpkgentype"));	//主键生成策略
	  		
	  		//添加扩展表信息
	  		Map<String,	Object> dataMap = new HashMap<String,	Object>();
			dataMap.put("formId", formid);
			dataMap.put("appId", appId);
			dataMap.put("isvirtualform", "1");	//是否虚拟表单   1为虚拟表单，0为实际表单
			dataMap.put("virtualformtype", virtualformtype);
			dataMap.put("vdatasource", vdatasource);
			dataMap.put("vprimarykey", vprimarykey);
			dataMap.put("vpkgentype", vpkgentype);
			formInfoService.saveOrUpdateFormExtend(dataMap);
			vtableName = VirtualFormHandler.getRealFromName(vtableName);
			
			//添加字段
			String[] vfieldNameArr = request.getParameterValues("vfieldName");
			formInfoService.generateVirtualTableColumns(formid, vtableName, vfieldNameArr, vdatasource);
	  	}else{
	  		throw new RuntimeException(SystemEnv.getHtmlLabelName(82142,user.getLanguage()));//未知的表单类型
	  	}
	  	
	  	LabelComInfo labelComInfo = new LabelComInfo();
		labelComInfo.addLabeInfoCache(String.valueOf(namelabelid));//往缓存中添加表单名称的标签
		
		BillComInfo billComInfo = new BillComInfo();
		billComInfo.addBillCache(String.valueOf(formid));
		
		//添加虚拟表单数据到缓存
		if(formtype.equals("1")){
			VirtualFormCacheManager.addVFormInCache(formid);
		}
		
		logService.log(formid, Module.FORM, LogType.ADD);
		
		out.print("<script type=\"text/javascript\">parent.parent.refreshForm("+formid+");</script>");
  	}catch(Exception ep){
  		rsTrans.rollback();
  		String errorMsg = ep.getMessage();
  		response.sendRedirect("/formmode/setup/formAdd.jsp?appId=" + appId + "&errorMsg=" + xssUtil.put(errorMsg));
  	}
}else if(action.equalsIgnoreCase("getDetailTables")){
	JSONObject result = new JSONObject();
	try{
		int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
		List<Map<String, Object>> dataList = formInfoService.getAllDetailTable(formid);
		JSONArray jsonArray = JSONArray.fromObject(dataList);
		result.put("status", "1");
		result.put("data", jsonArray);
	}catch(Exception ep){
		result.put("status", "0");
	}
	response.setCharacterEncoding("UTF-8");
	out.print(result.toString());
}else if(action.equalsIgnoreCase("checktablename")){
	String checkStatus = "-1";	//-1:正常  0:检测表名时出现未知错误   1:表名已存在  2.表名不合法
	String tablename = Util.null2String(request.getParameter("tablename"));
	
	try{
		RecordSet rs1 = new RecordSet();
		rs1.executeSql("select * from workflow_bill where lower(tablename)='"+tablename.toLowerCase()+"'");
		if(rs1.next()){
			checkStatus = "1";
			out.print(checkStatus);
			return;
		}
		FormManager formManager = new FormManager();
		boolean tableISExists = formManager.isHaveSameTableInDB(tablename);
	    if (tableISExists) {
	    	checkStatus = "1";
	    }else{	//检查表名是否合法(模拟创建表)
	    	try{
	    		boolean createTableSuccess = rs.executeSql("create table " + tablename + "(id varchar(10))");
	    		if(!createTableSuccess){
	    			checkStatus = "2";
	    		}else{
	    			try{
	    				rs.executeSql("drop table " + tablename);
	    			}catch(Exception e){}
	    		}
	    	}catch(Exception e){
	    		e.printStackTrace();
	    	}finally{
	    		
	    	}
	    }
	    //Thread.sleep(2000);
	}catch(Exception ep){
		ep.printStackTrace();
		checkStatus = "0";
	}
	out.print(checkStatus);
	return;
}else if(action.equalsIgnoreCase("getDetailTablename")){
	String maintablename = Util.null2String(request.getParameter("maintablename"));
	String detailtablename = "";
	if(maintablename.startsWith("uf_")){
		maintablename = maintablename.substring(3);
	}
	
	int detailEndIndex = Util.getIntValue(request.getParameter("detailEndIndex"), 1);
	String pageNoSaveTablenames = Util.null2String(request.getParameter("pageNoSaveTablenames")).toLowerCase();
	
	FormManager formManager = new FormManager();
	
	for(; detailEndIndex <Integer.MAX_VALUE; detailEndIndex++){
		detailtablename = maintablename + "_dt" + detailEndIndex;
		if(pageNoSaveTablenames.indexOf(detailtablename.toLowerCase() + ",") == -1){
			String testTablename = maintablename.startsWith("uf_") ? ("uf_" + detailtablename) : detailtablename;
			boolean tableISExists = formManager.isHaveSameTableInDB(testTablename);
			if(!tableISExists){
				break;
			}
		}
	}
	out.print(detailtablename);
}else if(action.equalsIgnoreCase("getfirstid")){
	int appId = Util.getIntValue(request.getParameter("appid"), 0);
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), 0);
	JSONArray forminfoArr = new JSONArray();
	if(fmdetachable.equals("1")){
		forminfoArr = formInfoService.getFormInfoByAppIdWithJSONDetach(appId,subCompanyId);
	}else{
		forminfoArr = formInfoService.getFormInfoByAppIdWithJSON(appId);
	}
	String firstId = "";
	if(forminfoArr.size()>0){
		JSONObject jsonObject = forminfoArr.getJSONObject(0);
		firstId = jsonObject.getString("id");
	}
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("id",firstId);
	out.print(jsonObject.toString());
}
out.flush();
out.close();
%>