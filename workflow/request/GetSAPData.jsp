
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.interfaces.sap.SAPSetInfo"%>
<%@page import="java.util.Enumeration"%>
<%@page import="weaver.interfaces.sap.SAPBus"%> 
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.checkUser(request,response);
	if(user == null){
		return;
	}
	String step = Util.null2String(request.getParameter("step"));
	String isdetailstr = Util.null2String(request.getParameter("isdetail"));//取当前明细行数据
	boolean isdetail = isdetailstr.equals("1");
	new weaver.general.BaseBean().writeLog("isdetail:" + isdetail);
	String rowindex = Util.null2String(request.getParameter("rowindex"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String formid = "";
	int attrid = Util.getIntValue(request.getParameter("fieldattrid"),0);
	if(step.equals("1")){
		rs.execute("select * from workflow_nodefieldattr where id=" + attrid);
		new weaver.general.BaseBean().writeLog("select * from workflow_nodefieldattr where id=" + attrid);
		//System.out.println(attrid);
		if(rs.next()){
			formid = rs.getString("formid");
			String attrcontent = Util.null2String(rs.getString("attrcontent"));
			int index = attrcontent.indexOf("doFieldSAP(\"");
			new weaver.general.BaseBean().writeLog("index1:" + index);
			if(index < 0){
				return;
			}
			new weaver.general.BaseBean().writeLog("attrcontent1:" + attrcontent);
			attrcontent = attrcontent.substring(index+12);
			new weaver.general.BaseBean().writeLog("attrcontent2:" + attrcontent);
			index = attrcontent.lastIndexOf("\")");
			new weaver.general.BaseBean().writeLog("index:" + index);
			if(index > -1){
				attrcontent = attrcontent.substring(0, index);
				attrcontent = attrcontent.trim();
			}
			attrcontent = attrcontent.trim();
			new weaver.general.BaseBean().writeLog("attrcontent3:" + attrcontent);
			Map sapInfo = new HashMap();
			try{
				new weaver.general.BaseBean().writeLog("解析配置	start");
				SAPSetInfo SAPSetInfo = new SAPSetInfo();
				sapInfo = SAPSetInfo.parseSAPInvokeInfo(attrcontent);
				new weaver.general.BaseBean().writeLog("解析配置	end");
			}catch(Exception e){
				new weaver.general.BaseBean().writeLog(e);
			}
			new weaver.general.BaseBean().writeLog("sapInfo:" + sapInfo.size());
			Map allFieldInfo = getFieldsInfo(formid);
			new weaver.general.BaseBean().writeLog("allFieldInfo:" + allFieldInfo.size());
			
			StringBuffer fromoafields = new StringBuffer("var querystr = 'step=2&attrid="+attrid+"&isdetail="+isdetailstr+"&rowindex="+rowindex+"&';\n");
			List InputParams = (List)sapInfo.get("InputParams");
			if(InputParams==null){
				InputParams = new ArrayList();
			}
			new weaver.general.BaseBean().writeLog("InputParams.size():" + InputParams.size());
			if(InputParams != null && InputParams.size() > 0){
				for(int i = 0; i<InputParams.size(); i++){
					Map oneparam = (Map)InputParams.get(i);
					String SAPFieldName = (String)oneparam.get("SAPParamName");
					String fromoafield = (String)oneparam.get("FromOAField");
					new weaver.general.BaseBean().writeLog("InputParams		SAPFieldName:"+SAPFieldName+"	fromoafield:"+fromoafield);
					String tmpstr = "";
					if(fromoafield.startsWith("$") && fromoafield.endsWith("$")){
						fromoafield = fromoafield.replaceAll("\\$","");
						String[] tmpfieldinfo = (String[])allFieldInfo.get(fromoafield); 
						int detailtableindex = getDetailTableIndex(allFieldInfo,fromoafield);
						if(tmpfieldinfo != null){
							String viewtype = tmpfieldinfo[2];
							new weaver.general.BaseBean().writeLog("InputParams		viewtype:"+viewtype+"	isdetail:"+isdetail);
							if(viewtype.equals("1")){
								//如果是明细，则把当前明细字段每一行的值都得传递到后台
								tmpstr = " if(jQuery(\"#indexnum"+detailtableindex+"\").length>0){ \n";
								tmpstr += " var indexrownum"+detailtableindex+" = \"\"; \n";
								
								tmpstr += " var indexnum"+detailtableindex+" = jQuery(\"#indexnum"+detailtableindex+"\").val() * 1.0; \n";
								tmpstr += " querystr+='&indexnum"+detailtableindex+"='+jQuery('#indexnum" + detailtableindex + "').val()+'&';\n";
								//tmpstr += " alert(indexnum"+detailtableindex+"); \n";
								
								tmpstr += " for(var index=0;index<indexnum"+detailtableindex+";index++){ \n";
								//拼明细字段
								tmpstr += " if(jQuery(\"#field"+fromoafield+"_\"+index+\"\").length>0){ \n";
								//tmpstr += " alert(jQuery(\"#field"+fromoafield+"_\"+index+\"\").val()); \n";
								tmpstr += " querystr+='&"+fromoafield+"_'+index+'='+jQuery('#field" + fromoafield + "_'+index).val()+'&';\n";
								tmpstr += " indexrownum"+detailtableindex+" += \",\" + index;	\n";
								tmpstr += " } \n";
								tmpstr += "	} \n";
								
								//tmpstr += " alert(indexrownum"+detailtableindex+"); \n";
								tmpstr += " querystr+='&indexrownum"+detailtableindex+"='+indexrownum"+detailtableindex+"+'&';\n";
								
								tmpstr += "} \n";
							}else{
								tmpstr = "querystr+='&"+fromoafield+"='+jQuery('#field" + fromoafield + "').val()+'&';\n";
							}
						}
					}else{
						//tmpstr = "querystr+='InputParam@"+SAPFieldName+"="+fromoafield+"&';\n";
					}
					new weaver.general.BaseBean().writeLog("tmpstr	:"+tmpstr);
					fromoafields.append(tmpstr);
				}
			}
			List InputStructs = (List)sapInfo.get("InputStructs");
			if(InputStructs==null){
				InputStructs = new ArrayList();
			}
			if(InputStructs != null && InputStructs.size() > 0){
				for(int i = 0; i<InputStructs.size(); i++){
					Map structinfo = (Map)InputStructs.get(i);
					String structname = structinfo.get("StructName").toString();
					List fields = (List)structinfo.get("Fields");
					if(fields != null && fields.size() > 0){
						for(int j = 0; j<fields.size(); j++){
							Map oneparam = (Map)fields.get(j);
							String SAPFieldName = (String)oneparam.get("SAPFieldName");
							String fromoafield = (String)oneparam.get("FromOAField");
							new weaver.general.BaseBean().writeLog("InputStructs	structname:"+structname+"	SAPFieldName:"+SAPFieldName+"	fromoafield:"+fromoafield);
							String tmpstr = "";
							if(fromoafield.startsWith("$") && fromoafield.endsWith("$")){
								fromoafield = fromoafield.replaceAll("\\$","");
								String[] tmpfieldinfo = (String[])allFieldInfo.get(fromoafield); 
								int detailtableindex = getDetailTableIndex(allFieldInfo,fromoafield);
								if(tmpfieldinfo != null){
									String viewtype = tmpfieldinfo[2];
									if(viewtype.equals("1")){
										//如果是明细，则把当前明细字段每一行的值都得传递到后台
										tmpstr = " if(jQuery(\"#indexnum"+detailtableindex+"\").length>0){ \n";
										tmpstr += " var indexrownum"+detailtableindex+" = \"\"; \n";
										
										tmpstr += " var indexnum"+detailtableindex+" = jQuery(\"#indexnum"+detailtableindex+"\").val() * 1.0; \n";
										tmpstr += " querystr+='&indexnum"+detailtableindex+"='+jQuery('#indexnum" + detailtableindex + "').val()+'&';\n";
										//tmpstr += " alert(indexnum"+detailtableindex+"); \n";
										
										tmpstr += " for(var index=0;index<indexnum"+detailtableindex+";index++){ \n";
										//拼明细字段
										tmpstr += " if(jQuery(\"#field"+fromoafield+"_\"+index+\"\").length>0){ \n";
										//tmpstr += " alert(jQuery(\"#field"+fromoafield+"_\"+index+\"\").val()); \n";
										tmpstr += " querystr+='&"+fromoafield+"_'+index+'='+jQuery('#field" + fromoafield + "_'+index).val()+'&';\n";
										tmpstr += " indexrownum"+detailtableindex+" += \",\" + index;	\n";
										tmpstr += " } \n";
										tmpstr += "	} \n";
										
										//tmpstr += " alert(indexrownum"+detailtableindex+"); \n";
										tmpstr += " querystr+='&indexrownum"+detailtableindex+"='+indexrownum"+detailtableindex+"+'&';\n";
										
										tmpstr += "} \n";
									}else{
										tmpstr = "querystr+='&"+fromoafield+"='+jQuery('#field" + fromoafield + "').val()+'&';\n";
									}
								}
							}else{
								//tmpstr = "querystr+='InputStruct@"+structname+"@"+SAPFieldName+"="+fromoafield+"&';\n";
							}
							fromoafields.append(tmpstr);
						}
					}
				}
			}
			List InputTables = (List)sapInfo.get("InputTables");
			if(InputTables==null){
				InputTables = new ArrayList();
			}
			if(InputTables != null && InputTables.size() > 0){
				for(int i = 0; i<InputTables.size(); i++){
					Map tableinfo = (Map)InputTables.get(i);
					String tablename = tableinfo.get("TableName").toString();
					List fields = (List)tableinfo.get("Fields");
					if(fields==null){
						fields = new ArrayList();
					}
					if(fields != null && fields.size() > 0){
						for(int j = 0; j<fields.size(); j++){
							Map oneparam = (Map)fields.get(j);
							String SAPFieldName = (String)oneparam.get("SAPFieldName");
							String fromoafield = (String)oneparam.get("FromOAField");
							new weaver.general.BaseBean().writeLog("InputTables		tablename:"+tablename+"		SAPFieldName:"+SAPFieldName+"	fromoafield:"+fromoafield);
							int detailtableindex = getDetailTableIndex(allFieldInfo,fromoafield);
							String tmpstr = "";
							if(fromoafield.startsWith("$") && fromoafield.endsWith("$")){
								fromoafield = fromoafield.replaceAll("\\$","");
								String[] tmpfieldinfo = (String[])allFieldInfo.get(fromoafield); 
								if(tmpfieldinfo != null){
									String viewtype = tmpfieldinfo[2];
									if(viewtype.equals("1")){
										//如果是明细，则把当前明细字段每一行的值都得传递到后台
										tmpstr = " if(jQuery(\"#indexnum"+detailtableindex+"\").length>0){ \n";
										tmpstr += " var indexrownum"+detailtableindex+" = \"\"; \n";
										
										tmpstr += " var indexnum"+detailtableindex+" = jQuery(\"#indexnum"+detailtableindex+"\").val() * 1.0; \n";
										tmpstr += " querystr+='&indexnum"+detailtableindex+"='+jQuery('#indexnum" + detailtableindex + "').val()+'&';\n";
										//tmpstr += " alert(indexnum"+detailtableindex+"); \n";
										
										tmpstr += " for(var index=0;index<indexnum"+detailtableindex+";index++){ \n";
										//拼明细字段
										tmpstr += " if(jQuery(\"#field"+fromoafield+"_\"+index+\"\").length>0){ \n";
										//tmpstr += " alert(jQuery(\"#field"+fromoafield+"_\"+index+\"\").val()); \n";
										tmpstr += " querystr+='&"+fromoafield+"_'+index+'='+jQuery('#field" + fromoafield + "_'+index).val()+'&';\n";
										tmpstr += " indexrownum"+detailtableindex+" += \",\" + index;	\n";
										tmpstr += " } \n";
										tmpstr += "	} \n";
										
										//tmpstr += " alert(indexrownum"+detailtableindex+"); \n";
										tmpstr += " querystr+='&indexrownum"+detailtableindex+"='+indexrownum"+detailtableindex+"+'&';\n";
										
										tmpstr += "} \n";

									}else{
										tmpstr = "querystr+='&"+fromoafield+"='+jQuery('#field" + fromoafield + "').val()+'&';\n";
									}
								}
							}else{
								//tmpstr = "querystr+='InputTable@"+tablename+"@"+SAPFieldName+"="+fromoafield+"&';\n";
							}
							fromoafields.append(tmpstr);
						}
					}
				}
			}

			fromoafields.deleteCharAt(fromoafields.lastIndexOf("&"));
			fromoafields.append("");
			//System.out.println("fromoafields:" + fromoafields);
			session.setAttribute("TempSAPInfoMap",sapInfo);
			session.setAttribute("TempFormFieldInfoMap",allFieldInfo);
			
			new weaver.general.BaseBean().writeLog("fromoafields:"+fromoafields);
			
			if(fromoafields.length() > 0){
			%>
			<%=fromoafields %>
			//alert(querystr);
			jQuery.getScript('GetSAPData.jsp?'+querystr+'&workflowid=<%=workflowid%>');
			<%
			}
		}
	}else if(step.equals("2")){
		//System.out.println("workflowid="+workflowid);
		Map sapInfo = (Map)session.getAttribute("TempSAPInfoMap");
		Map allFieldInfo = (Map)session.getAttribute("TempFormFieldInfoMap");
		
		Enumeration paramnames = request.getParameterNames();
		Map fieldValueMap = new HashMap();
		new weaver.general.BaseBean().writeLog("获得所有参数的值：");
		new weaver.general.BaseBean().writeLog("*********************************************************************");
		while(paramnames.hasMoreElements()){
			String paramname = paramnames.nextElement().toString();
			String paramvalue = Util.null2String(request.getParameter(paramname));
			fieldValueMap.put(paramname,paramvalue);
			new weaver.general.BaseBean().writeLog("paramname:"+paramname+"		paramvalue:"+paramvalue);
		}
		new weaver.general.BaseBean().writeLog("*********************************************************************");
		//System.out.println("fieldValueMap:" + fieldValueMap);
		String sources = "";
		if(!workflowid.equals("")){
			rs.executeSql("select SAPSource from workflow_base where id="+workflowid);
			if(rs.next())
				sources = rs.getString(1);
		}
		SAPBus sapbus = new SAPBus(sources);
		String jsstr = sapbus.getCommJS(sapInfo,allFieldInfo,fieldValueMap);
		session.removeAttribute("TempSAPInfoMap");
		session.removeAttribute("TempFormFieldInfoMap");
		//System.out.println(jsstr);
		%>
		try{
		<%=jsstr %>
		}catch(e){alert(e.message);}
		<%
		
	}
	
%>
<%!
public Map getFieldsInfo(String formid){
	RecordSet rs = new RecordSet();
	Map fieldmap = new HashMap();
	rs.execute("select id,fieldname,fieldhtmltype,viewtype,detailtable,type from workflow_billfield where billid="+formid);
	//new weaver.general.BaseBean().writeLog("select id,fieldname,fieldhtmltype,viewtype,detailtable,type from workflow_billfield where billid="+formid);
	while(rs.next()){
		String id = Util.null2String(rs.getString("id"));
		String fieldname = Util.null2String(rs.getString("fieldname"));
		String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
		String viewtype = Util.null2String(rs.getString("viewtype"));
		String detailtable = Util.null2String(rs.getString("detailtable"));
		String type = Util.null2String(rs.getString("type"));
		fieldmap.put(id,new String[]{fieldname,fieldhtmltype,viewtype,detailtable,type});
		//new weaver.general.BaseBean().writeLog("id:"+id+"	fieldname:"+fieldname+"		fieldhtmltype:"+fieldhtmltype+"		viewtype:"+viewtype+"	detailtable:"+detailtable+"	type:"+type);
	}
	return fieldmap;
}

//获得当前字段的明细表序号
public int getDetailTableIndex(Map map,String fieldid){
	int index = -1;
	fieldid = fieldid.replace("$","");
	String str[] = (String[])map.get(fieldid);
	if(str!=null){
		String detailtable = Util.null2String(str[3]).toLowerCase();
		if(!detailtable.equals("")){
			index = detailtable.indexOf("dt");
			index = Util.getIntValue(detailtable.substring(index+2),-1) - 1;
		}
	}
	return index;
}
%>
