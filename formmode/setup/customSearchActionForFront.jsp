<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.common.util.taglib.ShowColUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="weaver.formmode.search.editplugin.AbstractPluginElement"%>
<%@ page import="weaver.formmode.search.editplugin.PluginElementClassName"%>
<%@ page import="weaver.formmode.service.CustomSearchService"%>
<%@ page import="weaver.formmode.search.CustomSearchBatchEditUtil"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.formmode.setup.ModeRightInfo"%>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<%
out.clear();
User user = HrmUserVarify.getUser(request,response);
RecordSet rs =  new RecordSet();
String action = Util.null2String(request.getParameter("action"));
if("cleanColWidthByUser".equalsIgnoreCase(action)){
	String customid = Util.null2String(request.getParameter("customid"));
	boolean isRight = false;
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
	if(rs.next()){  
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(Util.getIntValue(customid),1);
	}else{  						//没有设置任何查看权限数据，则认为有权限查看
		isRight = true;
	}
	if(!isRight){
		response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	if(!"".equals(customid)){
		String pageId = "mode_customsearch:" + customid;
		String sql = "delete from user_default_col where pageid = '"+pageId+"' and userid = "+user.getUID()+"";
		rs.execute(sql);
		sql = "update system_default_col set isdefault=1 where pageid = '"+pageId+"'";//初始化列宽将所有isdefault重置为1
        rs.execute(sql);
		ShowColUtil.reloadCache(pageId);
		ShowColUtil.removeDefaultColsMap(pageId);
	}
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("status", "1");
	out.print(jsonObject.toString());
	return;
}else if("batchEdit".equalsIgnoreCase(action)){
	int customid = Util.getIntValue(Util.null2String(request.getParameter("batcheditCustomid")), 0);
	String modifiedRows = Util.null2String(request.getParameter("modifiedRows"));
	String clientaddress = request.getRemoteAddr();
	boolean isBatchEdit = false;
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=2 and pageid = " + customid);
	if(rs.next()){
		FormModeRightInfo.setUser(user);
		isBatchEdit = FormModeRightInfo.checkUserRight(Util.getIntValue(String.valueOf(customid)),2);
	}
	if(!isBatchEdit){
		response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	int modeid = 0;
	int formid = 0;
	String tablename = "";
	String detailtable = "";
	String detailkeyfield = "";
	String sql = "select a.modeid,a.formid,a.detailtable,b.tablename,b.detailkeyfield from mode_customsearch a left join workflow_bill b on a.formid=b.id where a.id="+customid;
	rs.executeSql(sql);
	if(rs.next()){
		modeid = Util.getIntValue(rs.getString("modeid"), 0);
		formid = Util.getIntValue(rs.getString("formid"), 0);
		tablename = Util.null2String(rs.getString("tablename"));
		detailtable=Util.null2String(rs.getString("detailtable"));
		detailkeyfield = Util.null2String(rs.getString("detailkeyfield"));
	}
	CustomSearchService customSearchService = new CustomSearchService();
	List<Map<String,Object>> editableFields = customSearchService.getEditableFieldsById(customid);
	Map<String,Object> editableFieldMap = new HashMap<String,Object>();
	AbstractPluginElement pluginElement = null;
	for(int i=0;i<editableFields.size();i++){
		Map<String,Object> editableField = editableFields.get(i);
		int fieldId = Util.getIntValue(Util.null2String(editableField.get("id")), 0);
		String fieldhtmltype = Util.null2String(editableField.get("fieldhtmltype"));
		String fieldtype = Util.null2String(editableField.get("type"));
		String elementClassName = PluginElementClassName.getElementClassName(fieldhtmltype,fieldtype);
		pluginElement = (AbstractPluginElement)Class.forName(elementClassName).newInstance();
		String pluginName = pluginElement.getEditPluginName(fieldId);
		editableFieldMap.put(pluginName, editableField);
	}
	boolean batchEditResult = false;
	StringBuffer batchEditMessage = new StringBuffer();
	int dialogW = 300;
	int dialogH = 80;
	CustomSearchBatchEditUtil customSearchBatchEditUtil  = new CustomSearchBatchEditUtil();
	Map<String,Object> promptFieldsMap = customSearchBatchEditUtil.getPromptFields(formid);
	Map<String,Object> needLogFieldsMap = customSearchBatchEditUtil.getNeedLogFields(formid);
	Map<String,Object> modeRightRelatedFieldsMap = new HashMap<String,Object>();
	StringBuffer promptFieldsValidateFail = new StringBuffer();
	String resultStatus = "0";
	JSONObject modifiedRowsObject = JSONObject.fromObject(modifiedRows);
	JSONObject mRows = modifiedRowsObject.getJSONObject("mrows");
	Iterator rowKey = mRows.keys();
	List<String> billList = new ArrayList<String>();
	List<Integer> modeList = new ArrayList<Integer>();
	while(rowKey.hasNext()){
		String rowIndex = Util.null2String(rowKey.next());
		int rowIndexInt = Util.getIntValue(rowIndex.substring(3), 0);
		JSONObject rowObject = mRows.getJSONObject(rowIndex);
		String updateMaintableSql = "";
		String updateDetailtableSql = "";
		boolean ismodifypromptfield = false;
		boolean ismodifyneedlogfield = false;
		boolean ismodifyRelatedField = false;
		customSearchBatchEditUtil.resetPromptFields(promptFieldsMap);
		customSearchBatchEditUtil.resetNeedLogFields(needLogFieldsMap);
		String mainid = Util.null2String(rowObject.get("mainid"));
		String detailid = Util.null2String(rowObject.get("detailid"));
		JSONArray fields = rowObject.getJSONArray("fields");
		rs.executeSql("select formmodeid from " + tablename + " where id = " + mainid);
		if(!rs.next())continue;
		if(modeid==0){
			modeid = Util.getIntValue(rs.getString("formmodeid"), 0);
		}
		if(modeid==0)continue;
		Map<String,Object> rightRelatedFieldsMap = null;
		if(modeRightRelatedFieldsMap.containsKey(String.valueOf(modeid))){
			rightRelatedFieldsMap = (Map<String,Object>)modeRightRelatedFieldsMap.get(String.valueOf(modeid));
		}else{
			rightRelatedFieldsMap = customSearchBatchEditUtil.getRightRelatedFields(modeid);
			modeRightRelatedFieldsMap.put(String.valueOf(modeid), rightRelatedFieldsMap);
		}
		
		Map<String,Object> modifyRightRelatedFieldsMap = new HashMap<String,Object>();
		
		Vector mainV = new Vector();
		Vector detailV = new Vector();
		
		for(int j=0;j<fields.size();j++){
			JSONObject fieldObject = fields.getJSONObject(j);
			String pluginName = Util.null2String(fieldObject.get("pluginname"));
			if(!editableFieldMap.containsKey(pluginName)) continue;
			Map<String,Object> editableField = (Map<String,Object>)editableFieldMap.get(pluginName);
			String fieldId = Util.null2String(editableField.get("id"));
			String fieldName = Util.null2String(editableField.get("fieldname"));
			String fieldHtmlType = Util.null2String(editableField.get("fieldhtmltype"));
			String fieldType = Util.null2String(editableField.get("type"));
			String fieldDbType = Util.null2String(editableField.get("fielddbtype"));
			int viewtype = Util.getIntValue(Util.null2String(editableField.get("viewtype")), 0);
			
			String fieldValue = Util.null2String(fieldObject.get("value"));
			String oldFieldValue = Util.null2String(fieldObject.get("oval"));
			Object realFieldValue = customSearchBatchEditUtil.AnalyzeStorageValue(fieldValue, fieldHtmlType, fieldType, fieldDbType);
			boolean isEqualVal = customSearchBatchEditUtil.judgeEqualFieldValue(fieldHtmlType,fieldType,oldFieldValue, realFieldValue,fieldValue);
			if(isEqualVal) continue;
			//唯一性字段的值
			if(promptFieldsMap.containsKey(fieldId)){
				boolean isEmptyVal = false;
				if(realFieldValue==null || "".equals(realFieldValue)){
					isEmptyVal = true;
				}else if("1".equals(fieldHtmlType) && "2".equals(fieldType)){
					int nValueD = Util.getIntValue(Util.null2String(realFieldValue), 0);
					if(nValueD==0){
						isEmptyVal = true;
					}
				}else if("1".equals(fieldHtmlType)&&("3".equals(fieldType)||"5".equals(fieldType))){
					String tempRealFieldVal = Util.null2String(realFieldValue);
					if("5".equals(fieldType)){
						tempRealFieldVal = tempRealFieldVal.replaceAll(",","");
					}
					double nValueD = Util.getDoubleValue(tempRealFieldVal, 0);
					if(Double.compare(nValueD, 0)==0){
						isEmptyVal = true;
					}
				}
				if(!isEmptyVal){
					JSONObject jsonObject = (JSONObject)promptFieldsMap.get(fieldId);
	            	jsonObject.put("fieldvalue", realFieldValue);
	            	jsonObject.put("pluginName", pluginName+"_"+rowIndexInt);
	            	ismodifypromptfield = true;
				}
            }
            //记录日志字段
            if(needLogFieldsMap.containsKey(fieldId)){
            	JSONObject jsonObject = (JSONObject)needLogFieldsMap.get(fieldId);
            	jsonObject.put("nfieldvalue", realFieldValue);
            	jsonObject.put("ofieldvalue", oldFieldValue);
            	ismodifyneedlogfield = true;
            }
            
            //判断权限关联字段值是否改变
            if(rightRelatedFieldsMap.containsKey(fieldId)){
            	modifyRightRelatedFieldsMap.put(fieldId, rightRelatedFieldsMap.get(fieldId));
            	ismodifyRelatedField = true;
            }
			
			if(viewtype==0){
				updateMaintableSql += ","+fieldName+"=?";
				mainV.addElement(realFieldValue);
			}else{
				if(!"".equals(detailid)){
					updateDetailtableSql += ","+fieldName+"=?";
					detailV.addElement(realFieldValue);
				}else{
					updateDetailtableSql += ","+fieldName+"";
					detailV.addElement(realFieldValue);
				}
			}
		}
		
		if(ismodifypromptfield){
			String fieldTipHtml = customSearchBatchEditUtil.judgePromptField(promptFieldsMap, modeid+"", tablename, mainid);
			if(!"".equals(fieldTipHtml)){
				for(Entry<String, Object> promptField : promptFieldsMap.entrySet()){
					JSONObject jsonObject = (JSONObject)promptField.getValue();
					if(!jsonObject.containsKey("status"))continue;
					String status = Util.null2String(jsonObject.get("status"));
					if(!"1".equals(status))continue;
					String promptFieldValidateFailName = Util.null2String(jsonObject.get("pluginName"));
					if(!"".equals(promptFieldValidateFailName)){
						if(promptFieldsValidateFail.length()>0){
							promptFieldsValidateFail.append(",");
						}
						promptFieldsValidateFail.append(promptFieldValidateFailName);
					}
				}
			
				if(batchEditMessage.length()>0){
					batchEditMessage.append("<br>");
					batchEditMessage.append("<div style=\"height:4px;\"></div>");
					dialogH += 30;
				}
				batchEditMessage.append("第"+(rowIndexInt+1)+"行：您录入的"+fieldTipHtml+"已存在，违反了唯一性验证，请重新录入。");
				resultStatus = "1";
				continue;
			}
		}
		
		if(mainV.size()>0){
			updateMaintableSql = updateMaintableSql.substring(1);
			updateMaintableSql = "update " + tablename + " set " + updateMaintableSql + " where id = " + mainid;
			boolean uResult = rs.executeSql(updateMaintableSql,false,mainV);
			if(uResult && ismodifyneedlogfield){
				customSearchBatchEditUtil.saveLogFieldsModifyInfo(Util.getIntValue(mainid,0), modeid, user, clientaddress, "5", needLogFieldsMap);
			}
		}
		if(detailV.size()>0){
			if(!"".equals(detailid)){
				updateDetailtableSql = updateDetailtableSql.substring(1);
				updateDetailtableSql = "update " + detailtable + " set " + updateDetailtableSql + " where id = " + detailid;
				rs.executeSql(updateDetailtableSql,false,detailV);
			}else{
				updateDetailtableSql = "insert into " + detailtable + " (mainid" + updateDetailtableSql + ") values (" + mainid;
				for(int k=0;k<detailV.size();k++){
					updateDetailtableSql += ",?";
				}
				updateDetailtableSql += ")";
				rs.executeSql(updateDetailtableSql,false,detailV);
			}
		}

		if(!billList.contains(mainid)){
			billList.add(mainid);
			modeList.add(modeid);
		}
	}

	for(int i=0;i<billList.size();i++){
		String bid = billList.get(i);
		int mid = modeList.get(i);
		ModeRightInfo ModeRightInfo = new ModeRightInfo();
		ModeRightInfo.rebuildModeDataShareByEdit(-1,mid,Util.getIntValue(bid,0));
		//批量修改的重构权限
		ModeRightInfo.addDocShare(-1,mid,Util.getIntValue(bid,0));
	}

	if(batchEditMessage.length()==0){
		batchEditMessage.append("更新成功，是否继续修改？");
	}
	JSONObject resultJson = new JSONObject();
	resultJson.put("resultStatus", resultStatus);
	resultJson.put("resultMessage", batchEditMessage.toString());
	resultJson.put("promptFieldsValidateFail", promptFieldsValidateFail.toString());
	out.print("<script>parent.customSearchOperate.batchEditCallbak("+resultJson+","+dialogW+","+dialogH+")</script>");
}
%>