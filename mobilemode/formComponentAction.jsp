<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="weaver.formmode.IgnoreCaseHashMap"%>
<%@page import="com.weaver.formmodel.data.model.Formfield"%>
<%@page import="com.weaver.formmodel.data.manager.FormInfoManager"%>
<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.data.types.FormModelType"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.FormData"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileUpload"%>
<%@page import="com.weaver.formmodel.data.manager.BusinessDataManager"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileCommonUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.weaver.formmodel.mobile.MobileFileUpload"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="weaver.formmode.dao.ModelInfoDao"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.setup.CodeBuild"%>
<%@page import="weaver.formmode.setup.ModeRightInfo"%>
<%@page import="weaver.formmode.data.ModeDataManager"%>
<%@page import="weaver.formmode.task.TaskService"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.EntityData"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.BusinessData"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="com.weaver.formmodel.mobile.mec.handler.form.FormExt"%>
<%!
public static String changeToThousands(String value){
	Pattern pattern = Pattern.compile("^[\\d]{1,}(\\.([\\d]{1,}))?$", Pattern.DOTALL | Pattern.CASE_INSENSITIVE);
	Matcher matcher = pattern.matcher(value);
	String formatstr = "#,###";
	if(matcher.find()){
		String temp = matcher.group(2);
		if(temp != null){
			formatstr += ".";
			int size = temp.length();
			for(int i = 0; i < size; i++){
				formatstr += "0";
			}
		}
		BigDecimal b = new BigDecimal(value);
	    DecimalFormat d1 =new DecimalFormat(formatstr);
	  	return d1.format(b);
	}else{
		return value;
	}
}
%>
<%
FileUpload fileUpload = new MobileFileUpload(request,"UTF-8",false);
MobileUpload mobileUpload = new MobileUpload(request);
User user = MobileUserInit.getUser(request, response);
out.clear();

String action=StringHelper.null2String(fileUpload.getParameter("action"));
if("savedata".equalsIgnoreCase(action)){
	JSONObject result = new JSONObject();
	try{
		String datasource = StringHelper.null2String(fileUpload.getParameter("datasource"));
		String tablename = StringHelper.null2String(fileUpload.getParameter("tablename"));
		String keyname = StringHelper.null2String(fileUpload.getParameter("keyname"));
		String actiontype = StringHelper.null2String(fileUpload.getParameter("actiontype"));
		String billid = StringHelper.null2String(fileUpload.getParameter("billid"));
		int tableformid = Util.getIntValue(fileUpload.getParameter("formid"));
		FormInfoManager formInfoManager = FormInfoManager.getInstance();
		List<Formfield> fieldList = formInfoManager.getAllField(tableformid);
		Map<String, Object> fieldMap = new IgnoreCaseHashMap<String, Object>();
		if(fieldList != null){
			for(Formfield field : fieldList){
				String fieldname = field.getFieldname();
				String detailtable = field.getDetailtable();
				String mapkey = StringHelper.isEmpty(detailtable) ? fieldname : detailtable + "_" + fieldname;
				fieldMap.put(mapkey, field);
			}
		}
		
		BusinessData businessData = new BusinessData();
		businessData.setBusinessId(billid);
		businessData.setDatasource(datasource);
		
		FormData formData = new FormData();
		formData.setFormType(FormModelType.FORM_TYPE_MAIN);
		formData.setDatasource(datasource);
		formData.setTablename(tablename);
		formData.setPrimkey(keyname);
		formData.setBillid(billid);
		formData.setActiontype(actiontype);
		Map<String, Object> dataMap = formData.getDataMap();
		
		List<String> detailTableList = new ArrayList<String>();
		List<String> keySet = new ArrayList<String>();
		String detailtableFlag = "detailtablename_";
		
		Map<String, String> uploadFileMap = MobileCommonUtil.uploadFileToDoc(fileUpload, user);
		
		Enumeration paranames = fileUpload.getParameterNames();
		String fieldFlag="fieldname_";
		while(paranames != null && paranames.hasMoreElements()) {
			String key = (String)paranames.nextElement();
			if(key.startsWith(fieldFlag)){	
				String tempKey = key.substring(fieldFlag.length());
				String[] mpcFields = fileUpload.getParameterValues("type_" + tempKey);
				String fieldmecid = Util.null2String(fileUpload.getParameter("fieldmecid_" + tempKey));
				if(mpcFields != null && mpcFields.length > 0){
					if(mpcFields[0].equals("sound")){// 语音
						String soundPath = "";
						String soundContent = Util.null2String(fileUpload.getParameter(key));
						if(!soundContent.trim().equals("")){
							soundPath = mobileUpload.upload("record.mp3", soundContent, "/mobilemode/upload/mpc/sound");
						}
						dataMap.put(key.substring(fieldFlag.length()), soundPath);
					}else if(mpcFields[0].equals("photo")){// 拍照
						String docIdContent = "";
						String keyValue = Util.null2String(fileUpload.getParameter(key));
						if(!keyValue.trim().equals("")){
							String[] keyArr = keyValue.split(";;");
							for(int i = 0; i < keyArr.length; i++){
								String base64Content = keyArr[i];
								if(null == base64Content || base64Content.trim().equals("")){
									continue;
								}else if(base64Content.indexOf("base64") == -1){	//id
									docIdContent += "," + base64Content;
								}else{
									int docId = MobileCommonUtil.convertImageBase64ToDoc(base64Content, fileUpload, user);
									if(docId != -1){
										docIdContent += "," + docId;
									}
								}
							}
						}
						
						docIdContent = StringHelper.isEmpty(docIdContent) ? "" : docIdContent.substring(1);
						dataMap.put(key.substring(fieldFlag.length()), docIdContent);
					}else if(mpcFields[0].equals("file")){// 文件
						String docIdContent = "";
						if(StringHelper.isNotEmpty(fieldmecid) && uploadFileMap.size() > 0){
							for(Entry<String, String> entry : uploadFileMap.entrySet()){
								String entryKey = entry.getKey();
								String entryValue = entry.getValue();
								if(entryKey.indexOf(fieldmecid) != -1){
									docIdContent += ("".equals(docIdContent) ? entryValue : ","+entryValue);
								}
							}
						}
						String keyValue = Util.null2String(fileUpload.getParameter(key));
						if(keyValue.indexOf("#") == -1 && !keyValue.equals("")){
							if(!docIdContent.equals("")){
								docIdContent += "," + keyValue;
							}else{
								docIdContent = keyValue;
							}
						}
						dataMap.put(key.substring(fieldFlag.length()), docIdContent);
					}else if(mpcFields[0].indexOf("textarea") != -1){
						String htmlType = mpcFields[0].split("_").length > 1 ? mpcFields[0].split("_")[1] : "1";
						String value = StringHelper.null2String(fileUpload.getParameter(key));
						if("1".equals(htmlType)){
							value = StringHelper.null2String(fileUpload.getParameter(key)).replaceAll("[ ]", "&nbsp;").replaceAll("\n", "<br>");
						}
						dataMap.put(key.substring(fieldFlag.length()), value);
					}
				}else{
					String value = StringHelper.null2String(fileUpload.getParameter(key));
					String fieldkey = key.substring(fieldFlag.length()).toLowerCase();
					if(fieldMap.containsKey(fieldkey)){
						Formfield field = (Formfield)fieldMap.get(fieldkey);
						if("1".equals(field.getFieldhtmltype()) && field.getType() == 5){
							value = changeToThousands(value);
						}
					}
					dataMap.put(key.substring(fieldFlag.length()), value);
				}
			}
			
			//明细表
			keySet.add(key);
			if(key.startsWith(detailtableFlag)){
				String detailtableName = Util.null2String(fileUpload.getParameter(key));
				detailTableList.add(detailtableName);
			}
		}
		//添加主表数据
		businessData.addModel(formData);
		
		//处理明细表数据开始
		for(String detailtableName : detailTableList){
			Map<Integer, EntityData> entityMap = new HashMap<Integer, EntityData>();
			String tableprefix = detailtableName + "_";
			String dtablekey = Util.null2String(fileUpload.getParameter(detailtableName + "_keyname"));
			String relatekey = Util.null2String(fileUpload.getParameter(detailtableName + "_relatekey"));
			for(String key : keySet){
				if(key.startsWith(tableprefix)){
					String subKey = key.substring(tableprefix.length());
					String[] keys = subKey.split("_rowindex_");
					if(keys.length > 1){
						String fieldname = keys[0];
						if(dtablekey.equalsIgnoreCase(fieldname)){
							continue;
						}
						Integer rowindex = NumberHelper.getIntegerValue(keys[1], 0);
						EntityData entityData = entityMap.get(rowindex);
						if(entityData == null) {
							entityData = new EntityData();
							entityMap.put(rowindex, entityData);
						}
						String[] mpcFields = fileUpload.getParameterValues("type_" + detailtableName + "_" + fieldname + "_" + rowindex);
						String fieldmecid = Util.null2String(fileUpload.getParameter("fieldmecid_" + detailtableName + "_" + fieldname + "_" + rowindex));
						if(mpcFields != null && mpcFields.length > 0){
							if(mpcFields[0].equals("photo")){// 拍照
								String docIdContent = "";
								String keyValue = Util.null2String(fileUpload.getParameter(key));
								if(!keyValue.trim().equals("")){
									String[] keyArr = keyValue.split(";;");
									for(int i = 0; i < keyArr.length; i++){
										String base64Content = keyArr[i];
										if(null == base64Content || base64Content.trim().equals("")){
											continue;
										}else if(base64Content.indexOf("base64") == -1){	//id
											docIdContent += "," + base64Content;
										}else{
											int docId = MobileCommonUtil.convertImageBase64ToDoc(base64Content, fileUpload, user);
											if(docId != -1){
												docIdContent += "," + docId;
											}
										}
									}
								}
								docIdContent = StringHelper.isEmpty(docIdContent) ? "" : docIdContent.substring(1);
								entityData.add(fieldname, docIdContent);
							}else if(mpcFields[0].equals("file")){// 文件
								String docIdContent = "";
								if(StringHelper.isNotEmpty(fieldmecid) && uploadFileMap.size() > 0){
									for(Entry<String, String> entry : uploadFileMap.entrySet()){
										String entryKey = entry.getKey();
										String entryValue = entry.getValue();
										if(entryKey.indexOf(fieldmecid) != -1){
											docIdContent += ("".equals(docIdContent) ? entryValue : ","+entryValue);
										}
									}
								}
								String keyValue = Util.null2String(fileUpload.getParameter(key));
								if(keyValue.indexOf("#") == -1 && !keyValue.equals("")){
									if(!docIdContent.equals("")){
										docIdContent += "," + keyValue;
									}else{
										docIdContent = keyValue;
									}
								}
								entityData.add(fieldname, docIdContent);
							}else if(mpcFields[0].equals("textarea")){
								String value = StringHelper.null2String(fileUpload.getParameter(key))
										.replaceAll("&nnbbsspp;", "&nbsp;")
										.replaceAll("[ ]", "&nbsp;")
										.replaceAll("\n", "<br>");
								entityData.add(fieldname, value);
							}
						}else{
							String value = StringHelper.null2String(fileUpload.getParameter(key));
							String fieldkey = detailtableName.toLowerCase() + "_" + fieldname.toLowerCase();
							if(fieldMap.containsKey(fieldkey)){
								Formfield field = (Formfield)fieldMap.get(fieldkey);
								if("1".equals(field.getFieldhtmltype()) && field.getType() == 5){
									value = changeToThousands(value);
								}
							}
							entityData.add(fieldname, value);
						}
					}
				}
			}
			
			FormData detailData = new FormData();
			detailData.setFormType(FormModelType.FORM_TYPE_DETAIL);
			detailData.setTablename(detailtableName);
			detailData.setPrimkey(dtablekey);
			detailData.setRelatekey(relatekey);
			detailData.setBillid(billid);
			for(Map.Entry<Integer, EntityData> entry : entityMap.entrySet()){
				Integer indexid = entry.getKey();
				EntityData data = entry.getValue();
				data.setIndexid(indexid);
				String indexkey = detailtableName + "_"+dtablekey+"_rowindex_" + indexid;
				String dtablekeyValue = Util.null2String(fileUpload.getParameter(indexkey));
				data.setKeyvalue(dtablekeyValue);
				detailData.addEntity(data);
			}
			
			//待删除明细数据
			String deleteidkeyname = detailtableName + "_delids";
			String deleteidkeyvalue = Util.null2String(fileUpload.getParameter(deleteidkeyname));
			if(!StringHelper.isEmpty(deleteidkeyvalue)) {
				String ids[] = StringHelper.string2Array(deleteidkeyvalue, ",");
				for(String delid : ids) {
					EntityData delData = new EntityData();
					delData.setFormName(detailtableName);
					delData.setIsdelete(1);
					delData.setKeyvalue(delid);
					detailData.addEntity(delData);
				}
			}
			
			businessData.addModel(detailData);
		}
		//处理明细表数据结束
		
		int modelid = NumberHelper.getIntegerValue(fileUpload.getParameter("modelid"), -1);
		int formid = Integer.MIN_VALUE;
		boolean isVirtualForm = false;
		if(modelid != -1){
			ModelInfoDao modelInfoDao = new ModelInfoDao();
			formid = modelInfoDao.getFormInfoIdByModelId(modelid);
			isVirtualForm = VirtualFormHandler.isVirtualForm(formid);
		}
		
		boolean isCreate = formData.getActiontype().equals("0");
		
		if(isCreate){
			if(modelid != -1 && !isVirtualForm){
				int userid = user.getUID();
				
				dataMap.put("formmodeid", modelid);
				dataMap.put("modedatacreater", userid);
				dataMap.put("modedatacreatedate", DateHelper.getCurrentDate());
				dataMap.put("modedatacreatetime", DateHelper.getCurrentTime());
			}
			
		}
		//保存表单数据
		JSONObject saveResult = businessData.saveBusinessData(isCreate);
		Object id = saveResult.get("billid");
		if(modelid != -1){//支持页面扩展
			//去验证新建保存或者编辑保存是否有action动作
			int expandid = 0;
			boolean hasInterfaceAction = false;
			RecordSet rs = new RecordSet();
			if(billid.equals("")){
				rs.executeSql("select * from mode_pageexpand where issystem=1 and issystemflag = 1 and modeid =" + modelid);//默认保存（新建）扩展按钮
			}else{
				rs.executeSql("select * from mode_pageexpand where issystem=1 and issystemflag = 2 and modeid =" + modelid);//默认保存（编辑）扩展按钮
			}
			
			if(rs.next()){
				expandid = rs.getInt("id");
			}
			
			if(expandid > 0){
				//其他接口动作
				rs.executeSql("select * from mode_actionview where expandid = " + expandid);
				while(rs.next()){
					hasInterfaceAction = true;
					break;
				}
				
				//是否触发审批工作流1,外部接口动作2,自定义java接口3
				rs.executeSql("select * from mode_pageexpanddetail where mainid = " + expandid);
				while(rs.next()){
					hasInterfaceAction = true;
					break;
				}
			}
			
			if(hasInterfaceAction){
				//执行DML接口
				ModeDataManager modeDataManager = new ModeDataManager(NumberHelper.getIntegerValue(id),modelid);
				modeDataManager.setFormid(formid);
				modeDataManager.setUser(user);
				modeDataManager.doInterface(expandid);
			}
		}
		
		if(modelid != -1 && !isVirtualForm){
			int billidInt = NumberHelper.getIntegerValue(id);
			if(billidInt > 0){
				
				//-----------提醒功能-----------
				TaskService taskService = new TaskService();
				taskService.setModeid(modelid);
				taskService.setBillid(billidInt);
				if(isCreate){
					taskService.setAction("create");
				}else {
					taskService.setAction("save");
				}
				Thread task = new Thread(taskService);
				task.start();
				
				//选择的文档目录，需要保存数据后，再次更新文档目录
				ModeDataManager modeDataManager = new ModeDataManager();
				modeDataManager.changeDocFiled(modelid,billidInt,tablename);
				
				int userid = user.getUID();

				ModeRightInfo modeRightInfo = new ModeRightInfo();

				if(isCreate){
					CodeBuild cbuild = new CodeBuild(modelid);
					cbuild.getModeCodeStr(formid, billidInt);//生成编号
					modeRightInfo.setNewRight(true);
					modeRightInfo.editModeDataShare(userid, modelid, billidInt);//新建的时候添加共享
				}else{
					//编辑的时候，修改建模主字段权限
					modeRightInfo.editModeDataShareForModeField(userid, modelid, billidInt);
				}

				//--------------给文档赋权------------------------
				modeRightInfo.addDocShare(userid, modelid, billidInt);
			}
		}
		
		result.put("status", "1");
		result.put("id", id);
		result.put("detailidsList", saveResult.get("detailidsList"));
	}catch(Exception ex){
		ex.printStackTrace();
		result.put("status", "0");
		String errMsg = Util.null2String(ex.getMessage());
		errMsg = URLEncoder.encode(errMsg, "UTF-8");
		errMsg = errMsg.replaceAll("\\+","%20");
		result.put("errMsg", errMsg);
	}
	out.print(result.toString());
}else if("deletedata".equalsIgnoreCase(action)){
	JSONObject result = new JSONObject();
	try{
		String billid = StringHelper.null2String(fileUpload.getParameter("billid"));
		if(!billid.equals("")){
			int modelid = NumberHelper.getIntegerValue(fileUpload.getParameter("modelid"), -1);
			BusinessDataManager.getInstance().deleteBusinessData(modelid, billid);
		}
		result.put("status", "2");
	}catch(Exception e){
		e.printStackTrace();
		result.put("status", "-1");
		result.put("errMsg", e.getMessage());
	}
	
	out.print(result.toString());
}else if("verifyFieldDataRepeat".equalsIgnoreCase(action)){
	Object obj = FormExt.verifyFieldDataRepeat(fileUpload, user);
	out.print(obj.toString());
}
out.flush();
out.close();
%>