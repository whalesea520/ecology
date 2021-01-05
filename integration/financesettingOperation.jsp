<%@page import="java.io.Writer"%>
<%@page import="oracle.sql.CLOB"%>
<%@page import="weaver.conn.ConnStatement"%><%@page import="weaver.fna.encrypt.Des"%>
<%@page import="weaver.fna.fnaVoucher.financesetting.FinanceSet"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.fna.fnaVoucher.FnaVoucherObjInit"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.fnaVoucher.FnaVoucherObj"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fna.fnaVoucher.FinanceSetting"%>
<%@page import="weaver.fna.fnaVoucher.FnaCreateXml"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.action.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%
boolean isDebug = true;
User user = HrmUserVarify.getUser (request , response) ;

if(!HrmUserVarify.checkUserRight("intergration:financesetting", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
Des desObj = new Des();

String operator = Util.null2String(request.getParameter("operator"));

if("save".equals(operator)){
	HashMap<String, String> _inputName_inputVal_hm = new HashMap<String, String>();
	String _inputName_inputVal = Util.null2String(request.getParameter("_inputName_inputVal")).trim();
	if(!"".equals(_inputName_inputVal)){
		String[] _inputName_inputVal_array = _inputName_inputVal.split(",");
		int _inputName_inputVal_arrayLen = _inputName_inputVal_array.length;
		for(int i=0;i<_inputName_inputVal_arrayLen;i++){
			String _inputName_inputVal_1 = _inputName_inputVal_array[i];
			if(!"".equals(_inputName_inputVal_1)){
				String[] _inputName_inputVal_1_array = _inputName_inputVal_1.split("=");
				String _inputName = _inputName_inputVal_1_array[0];
				String _inputVal = "";
				if(_inputName_inputVal_1_array.length==2){
					_inputVal = _inputName_inputVal_1_array[1];
				}
				_inputName_inputVal_hm.put(_inputName+"", _inputVal+"");
			}
		}
	}
	
	int fnaVoucherXmlId = Util.getIntValue(desObj.strDec(Util.null2String(_inputName_inputVal_hm.get("fnaVoucherXmlId")), Des.KEY1, Des.KEY2, Des.KEY3));
	String xmlName = Util.null2String(desObj.strDec(Util.null2String(_inputName_inputVal_hm.get("xmlName")), Des.KEY1, Des.KEY2, Des.KEY3)).trim();
	String typename = Util.null2String(_inputName_inputVal_hm.get("typename")).trim();
	String interfacesAddress = desObj.strDec(Util.null2String(_inputName_inputVal_hm.get("interfacesAddress")).trim(), Des.KEY1, Des.KEY2, Des.KEY3);
	String xmlEncoding = Util.null2String(_inputName_inputVal_hm.get("xmlEncoding")).trim();
	String datasourceid = Util.null2String(_inputName_inputVal_hm.get("datasourceid")).trim();
	int workflowid = Util.getIntValue(desObj.strDec(Util.null2String(_inputName_inputVal_hm.get("workflowid")), Des.KEY1, Des.KEY2, Des.KEY3));

	RecordSet rs = new RecordSet();
	String sql = "";

	//凭证字段校验开始*************************************************
	if(isDebug){new BaseBean().writeLog("凭证字段校验开始");}
	if(true){
		FnaVoucherObjInit fnaVoucherObjInit = new FnaVoucherObjInit();
		for(int fnaVoucherInitType=0;fnaVoucherInitType<=2;fnaVoucherInitType++){
			List<FnaVoucherObj> fieldNameList = new ArrayList<FnaVoucherObj>();
			
			int detailtableNumber_first = -999;
			
			if("K3".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initK3(fnaVoucherInitType);
			}else if("NC".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initNC(fnaVoucherInitType);
			}else if("EAS".equals(typename)){
			}else if("U8".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initU8(fnaVoucherInitType);
			}else if("NC5".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initNC5(fnaVoucherInitType);
			}
	
			int fieldNameListLen = fieldNameList.size();
			for(int i=0;i<fieldNameListLen;i++){
				FnaVoucherObj fnaVoucherObj = fieldNameList.get(i);
				String fieldName = fnaVoucherObj.getFieldName();
				int detailTable = fnaVoucherObj.getDetailTable();
				String fieldDbTbName = fnaVoucherObj.getFieldDbTbName();
				String fieldDbName = fnaVoucherObj.getFieldDbName();
				String fieldDbType = fnaVoucherObj.getFieldDbType();
				String _datasourceid = fnaVoucherObj.getDatasourceid();
				int isNull = fnaVoucherObj.getIsNull();
	
				String _id = "";
				if(fnaVoucherInitType==0){
					_id = "M";
				}else if(fnaVoucherInitType==1){
					_id = "D1";
				}else if(fnaVoucherInitType==2){
					_id = "D2";
				}
				_id = _id+"_"+fieldDbTbName+"_"+fieldDbName;
				if(fnaVoucherXmlId > 0 && isNull==0){//必填
					String fieldValueType1 = Util.null2String(_inputName_inputVal_hm.get(_id));
					String fieldValue = "";
					if("1".equals(fieldValueType1)){
						fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_sel"));
					}else if("3".equals(fieldValueType1)){
						fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_ipt"));
						if(fnaVoucherObj.getInputIsSelect()!=1){
							fieldValue = desObj.strDec(fieldValue, Des.KEY1, Des.KEY2, Des.KEY3);
						}
					}else if("7".equals(fieldValueType1)){
						fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_sql"));
						fieldValue = desObj.strDec(fieldValue, Des.KEY1, Des.KEY2, Des.KEY3);
					}
					if("".equals(fieldValue) && ("1".equals(fieldValueType1)||"3".equals(fieldValueType1)||"7".equals(fieldValueType1))){
						out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(fieldName+"："+SystemEnv.getHtmlLabelName(18019,user.getLanguage())+"！")+"}");//xx：必填！
						out.flush();
						return;
					}
				}
				
				String fieldValueType1 = Util.null2String(_inputName_inputVal_hm.get(_id));
				if("1".equals(fieldValueType1)){
					String fieldValueType2 = "sel";
					String fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_sel"));

					if(Util.getIntValue(fieldValue) > 0){
						sql = "select fieldname, detailtable, billid from workflow_billfield a where a.id = "+Util.getIntValue(fieldValue);
						rs.executeSql(sql);
						if(rs.next()){
							String fieldname = Util.null2String(rs.getString("fieldname")).trim();
							String detailtable = Util.null2String(rs.getString("detailtable")).trim();
							int formid = Util.getIntValue(rs.getString("billid"));
							int formidABS = Math.abs(formid);

							if("".equals(detailtable)){//主表
							}else{//明细表
								if(fnaVoucherInitType==0){
									//凭证主表信息设置：当选择表单字段时，只能选择主表的字段
									out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(126497,user.getLanguage())+"！")+"}");
									out.flush();
									return;
								}else{
									int detailtableNumber = Util.getIntValue(detailtable.replaceAll("formtable_main_"+formidABS+"_dt", ""), 0);
									if(detailtableNumber_first == -999){
										detailtableNumber_first = detailtableNumber;
									}
									if(detailtableNumber_first != detailtableNumber){
										//配置不正确！凭证借方信息设置、凭证贷方信息设置：当选择表单字段时，只能选择主表或者相同明细表的字段！
										out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(fieldName+"："+SystemEnv.getHtmlLabelName(126497,user.getLanguage()))+"}");
										out.flush();
										return;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if(isDebug){new BaseBean().writeLog("凭证字段校验结束");}
	//凭证字段校验结束*************************************************
		

	
	if(fnaVoucherXmlId <= 0){
		sql = "insert into fnaVoucherXml (xmlName, workflowid, typename, datasourceid, xmlVersion, xmlEncoding, interfacesAddress) "+
			" values ('"+StringEscapeUtils.escapeSql(xmlName)+"', "+workflowid+", "+
			" '"+StringEscapeUtils.escapeSql(typename)+"', '"+StringEscapeUtils.escapeSql(datasourceid)+"', "+
			" '1.0', '"+StringEscapeUtils.escapeSql(xmlEncoding)+"', '"+StringEscapeUtils.escapeSql(interfacesAddress)+"')";
		rs.executeSql(sql);
		
		sql = "select max(id) maxId from fnaVoucherXml "+
			" where xmlName = '"+StringEscapeUtils.escapeSql(xmlName)+"' "+
			" and typename = '"+StringEscapeUtils.escapeSql(typename)+"' "+
			" and workflowid = "+workflowid+" ";
		rs.executeSql(sql);
		if(rs.next()){
			fnaVoucherXmlId = rs.getInt("maxId");
		}
		
	}else{
		sql = "update fnaVoucherXml "+
			" set xmlName = '"+StringEscapeUtils.escapeSql(xmlName)+"', "+
			" typename = '"+StringEscapeUtils.escapeSql(typename)+"', "+
			" datasourceid = '"+StringEscapeUtils.escapeSql(datasourceid)+"', "+
			" interfacesAddress = '"+StringEscapeUtils.escapeSql(interfacesAddress)+"', "+
			" xmlEncoding = '"+StringEscapeUtils.escapeSql(xmlEncoding)+"', "+
			" workflowid = "+workflowid+" "+
			" where id = "+fnaVoucherXmlId;
		rs.executeSql(sql);
		
	}
	
	if(fnaVoucherXmlId > 0){	    
		sql = "delete from fnaFinancesetting where fnaVoucherXmlId = "+fnaVoucherXmlId;
		rs.executeSql(sql);
		
		FnaVoucherObjInit fnaVoucherObjInit = new FnaVoucherObjInit();
		for(int fnaVoucherInitType=0;fnaVoucherInitType<=2;fnaVoucherInitType++){
			List<FnaVoucherObj> fieldNameList = new ArrayList<FnaVoucherObj>();
			
			if("K3".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initK3(fnaVoucherInitType);
			}else if("NC".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initNC(fnaVoucherInitType);
			}else if("EAS".equals(typename)){
			}else if("U8".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initU8(fnaVoucherInitType);
			}else if("NC5".equals(typename)){
				fieldNameList = fnaVoucherObjInit.initNC5(fnaVoucherInitType);
			}

			int fieldNameListLen = fieldNameList.size();
			for(int i=0;i<fieldNameListLen;i++){
				FnaVoucherObj fnaVoucherObj = fieldNameList.get(i);
				String fieldName = fnaVoucherObj.getFieldName();
				int detailTable = fnaVoucherObj.getDetailTable();
				String fieldDbTbName = fnaVoucherObj.getFieldDbTbName();
				String fieldDbName = fnaVoucherObj.getFieldDbName();
				String fieldDbType = fnaVoucherObj.getFieldDbType();
				String _datasourceid = fnaVoucherObj.getDatasourceid();

				String _id = "";
				if(fnaVoucherInitType==0){
					_id = "M";
				}else if(fnaVoucherInitType==1){
					_id = "D1";
				}else if(fnaVoucherInitType==2){
					_id = "D2";
				}
				_id = _id+"_"+fieldDbTbName+"_"+fieldDbName;
				
				String fieldValueType1 = Util.null2String(_inputName_inputVal_hm.get(_id));
				String fieldValueType2 = "";
				String fieldValue = "";
				if("1".equals(fieldValueType1)){
					fieldValueType2 = "sel";
					fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_sel"));
				}else if("3".equals(fieldValueType1)){
					fieldValueType2 = "ipt";
					fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_ipt"));
					if(fnaVoucherObj.getInputIsSelect()!=1){
						fieldValue = desObj.strDec(fieldValue, Des.KEY1, Des.KEY2, Des.KEY3);
					}
				}else if("7".equals(fieldValueType1)){
					fieldValueType2 = "sql";
					fieldValue = Util.null2String(_inputName_inputVal_hm.get(_id+"_sql"));
					_datasourceid = Util.null2String(_inputName_inputVal_hm.get(_id+"_datasourceid"));
					fieldValue = desObj.strDec(fieldValue, Des.KEY1, Des.KEY2, Des.KEY3);
				}
				
				String guid1 = FnaCommon.getPrimaryKeyGuid1();
				
				sql = "insert into fnaFinancesetting (guid1, fnaVoucherXmlId, "+
					" fieldName, fieldValueType1, fieldValueType2, "+
					" fieldDbTbName, "+
					" detailTable, fieldDbName, "+
					" fieldDbType, datasourceid) values ("+
					" '"+StringEscapeUtils.escapeSql(guid1)+"', "+fnaVoucherXmlId+", "+
					" '"+StringEscapeUtils.escapeSql(fieldName)+"', '"+StringEscapeUtils.escapeSql(fieldValueType1)+"', '"+StringEscapeUtils.escapeSql(fieldValueType2)+"', "+
					" '"+StringEscapeUtils.escapeSql(fieldDbTbName)+"', "+
					" "+detailTable+", '"+StringEscapeUtils.escapeSql(fieldDbName)+"', "+
					" '"+StringEscapeUtils.escapeSql(fieldDbType)+"', '"+StringEscapeUtils.escapeSql(_datasourceid)+"' )";
				rs.executeSql(sql);
				
				FnaCommon.updateDbClobOrTextFieldValue("fnaFinancesetting", 
						"fieldValue", fieldValue, 
						"guid1", guid1+"", "string");

				if(isDebug){new BaseBean().writeLog("fieldName["+i+"]="+fieldName+";fieldDbName="+fieldDbName+";fieldValue="+fieldValue+";");}
				
			}
			
		}

		
		if(isDebug){new BaseBean().writeLog("saveFnaVoucherXmlInfo开始");}
		
		//new BaseBean().writeLog("----------fnaVoucherXmlId:"+fnaVoucherXmlId);
		
		FinanceSet financeSet = new FinanceSet();
		financeSet.saveFnaVoucherXmlInfo(fnaVoucherXmlId);
		if(isDebug){new BaseBean().writeLog("saveFnaVoucherXmlInfo结束");}

	}

	out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+",\"fnaVoucherXmlId\":"+fnaVoucherXmlId+"}");//保存成功
	out.flush();
	return;
	
}else if("del".equals(operator)){
}


%>