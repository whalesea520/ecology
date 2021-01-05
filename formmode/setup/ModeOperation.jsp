
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.log.LogType"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.formmode.service.FormInfoService"%>
<%!
// qc353015 创建模块的时候，需要把自定义表单的formmodeid字段增加索引
private void createFormmodeidIndex(String formId){
	//查询是否已存在formmodeid索引
  	boolean isHaveFormmodeidIndex = false;
  	FormInfoService formInfoService = new FormInfoService();
  	if(formInfoService.isVirtualForm(Util.getIntValue(formId))){
  		return;
  	}
  	List<Map<String, Object>> tableIndexList = formInfoService.getFormTableIndexes(Util.getIntValue(formId));
  	for(Map<String, Object> tableIndexMap : tableIndexList){
  		List<Map<String, Object>> fieldList = (List<Map<String, Object>>)tableIndexMap.get("fieldList");
  		if(fieldList != null && fieldList.size() == 1){
  			Map<String, Object> fieldMap = fieldList.get(0);
  			String indexfieldname = Util.null2String(fieldMap.get("indexfieldname"));
  			if(indexfieldname.equalsIgnoreCase("formmodeid")){
  				isHaveFormmodeidIndex = true;
  				break;
  			}
  		}
  	}
  	if(!isHaveFormmodeidIndex){
		String tablename = formInfoService.getTablenameByFormid(Util.getIntValue(formId,-1));
		String indexName = "uf_formmodeid_" + System.currentTimeMillis();
		String createIndexSql = "create index "+indexName+" on "+tablename+" (formmodeid)";
		RecordSetTrans rsTrans = new RecordSetTrans();
		try{
			rsTrans.setAutoCommit(false);
			rsTrans.execute(createIndexSql);
			rsTrans.commit();
		}catch(Exception ep){
			rsTrans.rollback();
		}
  	}
}
 %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<html>
  <head>
  </head>
  <body>
  <%
  	User user = HrmUserVarify.getUser (request , response) ;
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
  %>
  <%
  response.reset();
  String operate = Util.null2String(request.getParameter("operate"));
  String modeId = Util.null2String(request.getParameter("modeId"));
  String modeName = Util.null2String(request.getParameter("modeName"));
  String modeDesc = Util.null2String(request.getParameter("modeDesc"));
  String typeId = Util.null2String(request.getParameter("typeId"));
  String formId = Util.null2String(request.getParameter("formId"));
  String maincategory = Util.null2String(request.getParameter("maincategory"));
  String subcategory = Util.null2String(request.getParameter("subcategory"));
  String seccategory = Util.null2String(request.getParameter("seccategory"));
  String isImportDetail = Util.null2String(request.getParameter("isImportDetail"));
  String DefaultShared = Util.null2String(request.getParameter("DefaultShared"));
  String NonDefaultShared = Util.null2String(request.getParameter("NonDefaultShared"));
  double dsporder = Util.getDoubleValue(request.getParameter("dsporder"));
  int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
  int isAllowReply = Util.getIntValue(request.getParameter("isAllowReply"),0);
  String customerValue = Util.null2String(request.getParameter("customerValue"));
  
  int selectcategory = Util.getIntValue(request.getParameter("selectcategory"),0);
  int categorytype = Util.getIntValue(request.getParameter("categorytype"),0);
  int isAddRightByWorkFlow = Util.getIntValue(request.getParameter("isAddRightByWorkFlow"),0);
  String oldFormId = Util.null2String(request.getParameter("oldFormId"));
  if(categorytype==0){
  	selectcategory=0;
  }
  String isloadleft = "0";
  String sql = "";
  
  LogService logService = new LogService();
  logService.setUser(user);
  if(operate.equals("AddMode")){	//新增模板
	  
	  if(subCompanyId==-1||subCompanyId==0){//分权分部的取得。如果页面没有，则首先从分权设置的默认机构取得，如果默认机构没有设置则取所有分部中id最小的那个分部。
	  		RecordSetTrans.executeSql("select fmdetachable,fmdftsubcomid,dftsubcomid from SystemSet");
	  		if(RecordSetTrans.next()){
	  			int fmdetachable = Util.getIntValue(RecordSetTrans.getString("fmdetachable"),0);
	  			if(fmdetachable == 1){
		  			subCompanyId = Util.getIntValue(RecordSetTrans.getString("fmdftsubcomid"),-1);
		  			if(subCompanyId==-1||subCompanyId==0){
			  			subCompanyId = Util.getIntValue(RecordSetTrans.getString("dftsubcomid"),-1);
		  			}
		  			if(subCompanyId==-1||subCompanyId==0){
			  			RecordSetTrans.executeSql("select min(id) as id from HrmSubCompany");
			  			if(RecordSetTrans.next()) subCompanyId = RecordSetTrans.getInt("id");
			  		}
	  			}
	  		}
	  	}
  
	  ModeSetUtil.setFormId(Util.getIntValue(formId,0));
	  ModeSetUtil.setTypeId(typeId);
	  ModeSetUtil.setModeName(modeName);
	  ModeSetUtil.setModeDesc(modeDesc);
	  ModeSetUtil.setMaincategory(maincategory);
	  ModeSetUtil.setSubcategory(subcategory);
	  ModeSetUtil.setSeccategory(seccategory);
	  ModeSetUtil.setIsImportDetail(isImportDetail);
	  ModeSetUtil.setDefaultShared(DefaultShared);
	  ModeSetUtil.setNonDefaultShared(NonDefaultShared);
	  ModeSetUtil.setDsporder(dsporder);
	  ModeSetUtil.setUser(user);
	  ModeSetUtil.setSubCompanyId(subCompanyId);
	  ModeSetUtil.setCategorytype(categorytype);
	  ModeSetUtil.setSelectcategory(selectcategory);
	  ModeSetUtil.setIsAddRightByWorkFlow(isAddRightByWorkFlow);
	  ModeSetUtil.addMode();
	  
	  createFormmodeidIndex(formId); //frommodeid建索引
	  
	  modeId = String.valueOf(ModeSetUtil.getModeId());
	  isloadleft = "1";
	  response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshModeOperation("+modeId+");</script>");
	  return;
	  
  }else if(operate.equals("EditMode")){	//编辑模板
      ModeSetUtil.setOldFormId(Util.getIntValue(oldFormId,0));//用于判断是否修改表单
	  ModeSetUtil.setFormId(Util.getIntValue(formId,0));
	  ModeSetUtil.setModeName(modeName);
	  ModeSetUtil.setModeDesc(modeDesc);
	  ModeSetUtil.setTypeId(typeId);
	  ModeSetUtil.setModeId(Util.getIntValue(modeId,0));
	  ModeSetUtil.setMaincategory(maincategory);
	  ModeSetUtil.setSubcategory(subcategory);
	  ModeSetUtil.setSeccategory(seccategory);
	  ModeSetUtil.setIsImportDetail(isImportDetail);
	  ModeSetUtil.setDefaultShared(DefaultShared);
	  ModeSetUtil.setNonDefaultShared(NonDefaultShared);
	  ModeSetUtil.setDsporder(dsporder);
	  ModeSetUtil.setIsAllowReply(isAllowReply);
	  ModeSetUtil.setSubCompanyId(subCompanyId);
	  ModeSetUtil.setCategorytype(categorytype);
	  ModeSetUtil.setSelectcategory(selectcategory);
	  ModeSetUtil.setIsAddRightByWorkFlow(isAddRightByWorkFlow);
	  ModeSetUtil.editMode();
	  
	  createFormmodeidIndex(formId); //frommodeid建索引
	  
	  ModeSetUtil.setRequest(request);
	  ModeSetUtil.setUser(user);
	  ModeSetUtil.saveModesHtml();
	  
	  isloadleft = "1";
	  logService.log(modeId, Module.MODEL, LogType.EDIT);
	  response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshModeOperation("+modeId+");</script>");
	  return;
  }else if(operate.equals("DefaultValue")){
	  String selfieldId[] = Util.null2String(request.getParameter("fieldid")).split("_");
	  int fieldId = 0;
	  if(selfieldId.length>1) fieldId = Util.getIntValue(selfieldId[1],0);
	  
	  ModeSetUtil.setModeId(Util.getIntValue(modeId,0));
	  ModeSetUtil.setFormId(Util.getIntValue(formId,0));
	  ModeSetUtil.setFieldId(fieldId);
	  ModeSetUtil.setCustomerValue(customerValue);
	  ModeSetUtil.saveDefualtValue();
	  response.sendRedirect("/formmode/setup/modelDefaultValue.jsp?ajax=1&modeId="+modeId);
	  return;
  }else if(operate.equals("delDefaultValue")){
	  String selfieldId[] = request.getParameterValues("check_mode");
	  ModeSetUtil.setDefaultValueId(selfieldId);
	  ModeSetUtil.deleteDefualtValue();
	  response.sendRedirect("/formmode/setup/modelDefaultValue.jsp?ajax=1&modeId="+modeId);
	  return;
  }else if(operate.equals("linkageattr")){
	 
	  modeLinkageInfo.setModeId(Util.getIntValue(modeId,0));
	 
	  boolean fly = modeLinkageInfo.LinkageSave(request);
	  
	  response.sendRedirect("/formmode/setup/modelLinkage.jsp?ajax=1&modeId="+modeId);
	  return;
  }else if(operate.equals("deleteMode")){ //废弃模块
 
	  ModeSetUtil.setModeId(Util.getIntValue(modeId,0));
	  ModeSetUtil.setUser(user);
	  
	  ModeSetUtil.deleteMode();
	  //调用updateEnable方法，使isenable为0。
      ModeSetUtil.updateEnable(Util.getIntValue(modeId,0));
	  
	  
	  response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshModeOperation();</script>");
	  return;
  }
  response.sendRedirect("/formmode/setup/modelAdd.jsp?ajax=1&modeId="+modeId+"&typeId="+typeId+"&isloadleft="+isloadleft);
  %>
  </body>
</html>
