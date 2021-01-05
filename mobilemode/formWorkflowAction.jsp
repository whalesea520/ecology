<%@page import="com.weaver.formmodel.mobile.workflow.WorkflowService"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.formmode.IgnoreCaseHashMap"%>
<%@page import="com.weaver.formmodel.data.model.Formfield"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.BusinessData"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.EntityData"%>
<%@page import="java.net.URLDecoder"%>
<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.data.manager.FormInfoManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page import="com.weaver.formmodel.data.types.FormModelType"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.FormData"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>

<%@page import="weaver.file.FileUpload"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileUpload"%>

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
User user= MobileUserInit.getUser(request, response);
out.clear();

String action=StringHelper.null2String(fileUpload.getParameter("action"));
if("createWorkflow".equalsIgnoreCase(action)){
	JSONObject result = new JSONObject();
	try{
		String datasource = StringHelper.null2String(fileUpload.getParameter("datasource"));
		String tablename = StringHelper.null2String(fileUpload.getParameter("tablename"));
		String keyname = StringHelper.null2String(fileUpload.getParameter("keyname"));
		String workflowid = StringHelper.null2String(fileUpload.getParameter("workflowid"));
		String workflowtitle = URLDecoder.decode(StringHelper.null2String(fileUpload.getParameter("workflowtitle")), "UTF-8");
		
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
		FormData formData = new FormData();
		formData.setDatasource(datasource);
		formData.setTablename(tablename);
		formData.setPrimkey(keyname);
		formData.setFormType(FormModelType.FORM_TYPE_MAIN);
		
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
				
		
		WorkflowService workflowService = new WorkflowService();
		int createid = Util.getIntValue(workflowService.createWorkflow(workflowid, workflowtitle, user, businessData));
		if(createid > -1){
			ModeDataManager modeDataManager = new ModeDataManager();
			modeDataManager.changeDocFiledWorkflow(Util.getIntValue(workflowid),0);
			
			result.put("status", "1");
			result.put("createid", createid);
		}else{
			result.put("status", "0");
			String message = "未知错误，请联系管理员";
			if(createid == -1){
				message = "创建流程基本信息失败";
			}else if(createid == -2){
				message = "无流程创建权限";
			}else if(createid == -3){
				message = "创建流程基本信息失败";
			}else if(createid == -4){
				message = "更新表单主表信息失败";
			}else if(createid == -5){
				message = "更新流程紧急程度失败";
			}else if(createid == -6){
				message = "创建人插入操作者表数据失败";
			}else if(createid == -7){
				message = "流程流转至下一节点出错";
			}else if(createid == -8){
				message = "流程节点自动赋值操作错误";
			}else if(createid == -9){
				message = "未设置附件上传目录";
			}
			result.put("errMsg", "流程创建失败，错误代码("+createid+"，"+message+")");
		}
	}catch(Exception ex){
		ex.printStackTrace();
		result.put("status", "0");
		String errMsg = Util.null2String(ex.getMessage());
		errMsg = URLEncoder.encode(errMsg, "UTF-8");
		errMsg = errMsg.replaceAll("\\+","%20");
		result.put("errMsg", errMsg);
	}
	out.print(result.toString());
}
out.flush();
out.close();
%>