
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.servicefiles.ResetXMLFileCache"%>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@page import="weaver.parseBrowser.Field"%>
<%@page import="weaver.parseBrowser.StructField"%>
<%@page import="weaver.parseBrowser.TableField"%>
<%@page import="weaver.parseBrowser.SapBaseBrowser"%>
<%@page import="weaver.parseBrowser.ParseBrowser"%>
<%@ page import="weaver.general.BaseBean" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("SAPBrowserSetting:Manage", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("save")){
	
	String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
	String function = Util.null2String(request.getParameter("function"));
	
	ArrayList import_inputList = new ArrayList();
	ArrayList struct_inputList = new ArrayList();
	ArrayList table_inputList = new ArrayList();
	ArrayList export_outputList = new ArrayList();
	ArrayList struct_outputList = new ArrayList();
	ArrayList table_outputList = new ArrayList();
	ArrayList assignmentList = new ArrayList();
	
	String authFlag = Util.null2String(request.getParameter("authFlag"));
	String wfids = Util.null2String(request.getParameter("wfid"));
	
	SapBaseBrowser sbb = new SapBaseBrowser();
	
	sbb.setSapbrowserid(sapbrowserid);	
	sbb.setFunction(function);
	
	sbb.setImport_input(import_inputList);
	sbb.setStruct_input(struct_inputList);
	sbb.setTable_input(table_inputList);
	sbb.setExport_output(export_outputList);
	sbb.setStruct_output(struct_outputList);
	sbb.setTable_output(table_outputList);
	sbb.setAssignment(assignmentList);
	sbb.setAuthFlag(authFlag);
	sbb.setAuthWorkflowID(wfids);
	

	
	String[] sapfieldname_importparam = request.getParameterValues("sapfieldname_importparam");
	String[] oafieldname_importparam = request.getParameterValues("oafieldname_importparam");
	String[] constant_importparam = request.getParameterValues("constant_importparam");
	if(sapfieldname_importparam != null){
		for(int i = 0; i<sapfieldname_importparam.length; i++){
			String sapfield = Util.null2String(sapfieldname_importparam[i]).trim();
			String oafield = Util.null2String(oafieldname_importparam[i]).trim();
			String constant = Util.null2String(constant_importparam[i]).trim();
			if(sapfield.equals("") || (oafield.equals("")&&constant.equals(""))){
				continue;
			}
			Field field = new Field();
			field.setName(sapfield);
			field.setFromOaField(oafield);
			field.setConstant(constant);
			import_inputList.add(field);
			new BaseBean().writeLog(sapfield + "\t" + oafield + "\t" + constant);
		}
	}
	
	
	
	int inputstructcount = Util.getIntValue(request.getParameter("inputstructcount"),0);
	for(int i = 0; i<inputstructcount; i++){
		String inputstructname = Util.null2String(request.getParameter("inputstructname_"+i));
		if(inputstructname.equals("")){
			continue;
		}
		new BaseBean().writeLog("inputstructname_" + i + "=" + inputstructname);
		
		StructField structField = new StructField();
		ArrayList structFieldList = new ArrayList();
		
		
		String[] sapfieldname_importstructfield = request.getParameterValues("sapfieldname_importstructfield_" + i);
		String[] oafieldname_importstructfield = request.getParameterValues("oafieldname_importstructfield_" + i);
		String[] constant_importstructfield = request.getParameterValues("constant_importstructfield_" + i);
		if(sapfieldname_importstructfield == null || sapfieldname_importstructfield.length == 0){
			continue;
		}
		for(int j = 0; j<sapfieldname_importstructfield.length; j++){
			String sapfield = Util.null2String(sapfieldname_importstructfield[j]).trim();
			String oafield = Util.null2String(oafieldname_importstructfield[j]).trim();
			String constant = Util.null2String(constant_importstructfield[j]).trim();
			if(sapfield.equals("") || (oafield.equals("")&&constant.equals(""))){
				continue;
			}
			Field field = new Field();
			field.setName(sapfield);
			field.setFromOaField(oafield);
			field.setConstant(constant);
			
			structFieldList.add(field);
			
			new BaseBean().writeLog(sapfield + "\t" + oafield + "\t" + constant);
		}
		if(structFieldList.size() == 0){
			continue;
		}
		structField.setStructName(inputstructname);
		structField.setStructFieldList(structFieldList);
		struct_inputList.add(structField);
		
	}
	
	int outputparamcount = Util.getIntValue(request.getParameter("outputparamcount"),0);
	for(int i = 0; i<outputparamcount; i++){
		String sapfield = Util.null2String(request.getParameter("sapfieldname_exportparam_"+i)).trim();
		String desc = Util.null2String(request.getParameter("desc_exportparam_"+i)).trim();
		String display = Util.null2String(request.getParameter("display_exportparam_"+i)).trim();
		if(sapfield.equals("") || desc.equals("")){
			continue;
		}
		Field field = new Field();
		field.setName(sapfield);
		field.setDesc(desc);
		field.setDisplay(display);
		export_outputList.add(field);
		new BaseBean().writeLog(sapfield + "\t" + desc + "\t" + display);
	}
	
	
	
	int outputstructcount = Util.getIntValue(request.getParameter("outputstructcount"));
	for(int i = 0; i<outputstructcount; i++){
		String outputstructname = Util.null2String(request.getParameter("outputstructname_"+i));
		if(outputstructname.equals("")){
			continue;
		}
		new BaseBean().writeLog("outputstructname_" + i + "=" + outputstructname);
		
		StructField structField = new StructField();
		ArrayList structFieldList = new ArrayList();
		
		int outputstructfieldcount = Util.getIntValue(request.getParameter("outputstructfieldcount_"+i),0);
		if(outputstructfieldcount == 0){
			continue;
		}
		for(int j = 0; j<outputstructfieldcount; j++){
			String sapfield = Util.null2String(request.getParameter("sapfieldname_exportstructfield_"+i+"_"+j)).trim();
			String desc = Util.null2String(request.getParameter("desc_exportstructfield_"+i+"_"+j)).trim();
			String display = Util.null2String(request.getParameter("display_exportstructfield_"+i+"_"+j)).trim();
			String search = Util.null2String(request.getParameter("search_exportstructfield_"+i+"_"+j)).trim();
			if(sapfield.equals("") || desc.equals("")){
				continue;
			}
			Field field = new Field();
			field.setName(sapfield);
			field.setDesc(desc);
			field.setDisplay(display);
			field.setSearch(search);
			structFieldList.add(field);
			new BaseBean().writeLog(sapfield + "\t" + desc + "\t" + display + "\t" + search);
		}
		if(structFieldList.size() == 0){
			continue;
		}
		structField.setStructName(outputstructname);
		structField.setStructFieldList(structFieldList);
		struct_outputList.add(structField);
	}
	
	
	
	
	int outputtablecount = Util.getIntValue(request.getParameter("outputtablecount"));
	for(int i = 0; i<outputtablecount; i++){
		String outputtablename = Util.null2String(request.getParameter("outputtablename_"+i));
		if(outputtablename.equals("")){
			continue;
		}
		new BaseBean().writeLog("outputtablename_" + i + "=" + outputtablename);
		
		TableField tableField = new TableField();
		ArrayList tableFieldList = new ArrayList();
		
		int outputtablefieldcount = Util.getIntValue(request.getParameter("outputtablefieldcount_"+i),0);
		if(outputtablefieldcount == 0){
			continue;
		}
		for(int j = 0; j<outputtablefieldcount; j++){
			String sapfield = Util.null2String(request.getParameter("sapfieldname_exporttablefield_"+i+"_"+j)).trim();
			String desc = Util.null2String(request.getParameter("desc_exporttablefield_"+i+"_"+j)).trim();
			String display = Util.null2String(request.getParameter("display_exporttablefield_"+i+"_"+j)).trim();
			String search = Util.null2String(request.getParameter("search_exporttablefield_"+i+"_"+j)).trim();
			String identity = Util.null2String(request.getParameter("identity_exporttablefield_"+i+"_"+j)).trim();
			if(sapfield.equals("") || desc.equals("")){
				continue;
			}
			Field field = new Field();
			field.setName(sapfield);
			field.setDesc(desc);
			field.setDisplay(display);
			field.setSearch(search);
			field.setIdentity(identity.equals("Y") || identity.equals("1"));
			tableFieldList.add(field);
			new BaseBean().writeLog(sapfield + "\t" + desc + "\t" + display + "\t" + search + "\t" + identity);
		}
		if(tableFieldList.size() == 0){
			continue;
		}
		tableField.setTableName(outputtablename);
		tableField.setTableFieldList(tableFieldList);
		table_outputList.add(tableField);
	}
	
	
	String[] oafieldname_assignment = request.getParameterValues("oafieldname_assignment");
	String[] sapfieldname_assignment = request.getParameterValues("sapfieldname_assignment");
	if(oafieldname_assignment != null){
		for(int i = 0; i<oafieldname_assignment.length; i++){
			String oafield = Util.null2String(oafieldname_assignment[i]).trim();
			String sapfield = Util.null2String(sapfieldname_assignment[i]).trim();
			
			if(sapfield.equals("") || oafield.equals("")){
				continue;
			}
			Field field = new Field();
			field.setName(oafield);
			field.setFrom(sapfield);
			assignmentList.add(field);
			new BaseBean().writeLog(oafield + "\t" + sapfield);
		}
	}
	synchronized(this){
		try{
			ParseBrowser parsebrowser = new ParseBrowser();
			parsebrowser.saveSAPBrowser(sbb);
			SapBrowserComInfo sbc = new SapBrowserComInfo();
			sbc.removeSapBrowserComInfo();
			response.sendRedirect("sapbrowsersettingNew.jsp?saveFlag=S&sapbrowserid="+sapbrowserid);
		}catch(Exception e){
			response.sendRedirect("sapbrowsersettingNew.jsp?saveFlag=E&sapbrowserid="+sapbrowserid);
		}
	}
}

if(operation.equals("delete")){
	String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
	synchronized(this){
		try{
			ParseBrowser parsebrowser = new ParseBrowser();
			parsebrowser.deleteSAPBrowser(sapbrowserid);
			SapBrowserComInfo sbc = new SapBrowserComInfo();
			sbc.removeSapBrowserComInfo();
			response.sendRedirect("sapbrowsersetting.jsp");
		}catch(Exception e){
			response.sendRedirect("sapbrowsersettingNew.jsp?deleteFlag=E&sapbrowserid="+sapbrowserid);
		}
	}
	
}


%>