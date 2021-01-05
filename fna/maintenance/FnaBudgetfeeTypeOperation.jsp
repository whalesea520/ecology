<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.interfaces.thread.FnaBudgetfeeTypeOperationThread"%>
<%@page import="weaver.fna.interfaces.thread.FnaUpdateBudgetFeetypeInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.fna.general.FnaSynchronized"%><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="org.json.JSONObject"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsSql" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser (request , response) ;

// || HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit",user)
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter(), 0);


BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String operation = Util.null2String(request.getParameter("operation"));
String _guid1 = Util.null2String(request.getParameter("_guid1"));
char flag = Util.getSeparator() ;
String id = Util.null2String(request.getParameter("id"));
String name = Util.null2String(request.getParameter("name")).trim();
String codeName = Util.null2String(request.getParameter("codeName")).trim();
String codeName2 = Util.null2String(request.getParameter("codeName2")).trim();
String feelevel = Util.null2String(request.getParameter("feelevel"));
int feeperiod = Util.getIntValue(request.getParameter("feeperiod"));
String feetype = Util.null2String(request.getParameter("feetype"));
String agreegap = Util.null2String(request.getParameter("agreegap"));
String alertvalue=Util.null2String(request.getParameter("alertvalue"));
String supsubject=Util.null2String(request.getParameter("supsubject"));
String description = Util.null2String(request.getParameter("description"));
int archive=Util.getIntValue(request.getParameter("archive"), 0);
int isEditFeeType=Util.getIntValue(request.getParameter("isEditFeeType"), 0);
int groupCtrl=Util.getIntValue(request.getParameter("groupCtrl"));
String gCtrlException = Util.null2String(request.getParameter("gCtrlException"));
int budgetAutoMove = Util.getIntValue(request.getParameter("budgetAutoMove"), 0);
String feetypeRuleSetZb=Util.null2String(request.getParameter("feetypeRuleSetZb"));
String feetypeRuleSetFb=Util.null2String(request.getParameter("feetypeRuleSetFb"));
String feetypeRuleSetBm=Util.null2String(request.getParameter("feetypeRuleSetBm"));
String feetypeRuleSetCbzx=Util.null2String(request.getParameter("feetypeRuleSetCbzx"));
double displayOrder1 = Util.getDoubleValue(request.getParameter("displayOrder"), 0);
int budgetCanBeNegative = Util.getIntValue(request.getParameter("budgetCanBeNegative"), 0);

BaseBean base = new BaseBean();


String para = "" ;

if(operation.equals("add") || operation.equals("edit")){
	
	FnaBudgetfeeTypeOperationThread fnaBudgetfeeTypeOperationThread = new FnaBudgetfeeTypeOperationThread();

	fnaBudgetfeeTypeOperationThread.setUser(user);
	fnaBudgetfeeTypeOperationThread.setGuid(_guid1);


	fnaBudgetfeeTypeOperationThread.setOperation(operation);
	fnaBudgetfeeTypeOperationThread.setId(id);
	fnaBudgetfeeTypeOperationThread.setName(name);
	fnaBudgetfeeTypeOperationThread.setCodeName(codeName);
	fnaBudgetfeeTypeOperationThread.setCodeName2(codeName2);
	fnaBudgetfeeTypeOperationThread.setFeelevel(feelevel);

	fnaBudgetfeeTypeOperationThread.setFeeperiod(feeperiod);
	fnaBudgetfeeTypeOperationThread.setFeetype(feetype);
	fnaBudgetfeeTypeOperationThread.setAgreegap(agreegap);
	fnaBudgetfeeTypeOperationThread.setAlertvalue(alertvalue);
	fnaBudgetfeeTypeOperationThread.setSupsubject(supsubject);

	fnaBudgetfeeTypeOperationThread.setDescription(description);
	fnaBudgetfeeTypeOperationThread.setArchive(archive);
	fnaBudgetfeeTypeOperationThread.setIsEditFeeType(isEditFeeType);
	fnaBudgetfeeTypeOperationThread.setGroupCtrl(groupCtrl);
	fnaBudgetfeeTypeOperationThread.setBudgetAutoMove(budgetAutoMove);

	fnaBudgetfeeTypeOperationThread.setFeetypeRuleSetZb(feetypeRuleSetZb);
	fnaBudgetfeeTypeOperationThread.setFeetypeRuleSetFb(feetypeRuleSetFb);
	fnaBudgetfeeTypeOperationThread.setFeetypeRuleSetBm(feetypeRuleSetBm);
	fnaBudgetfeeTypeOperationThread.setFeetypeRuleSetCbzx(feetypeRuleSetCbzx);
	fnaBudgetfeeTypeOperationThread.setDisplayOrder1(displayOrder1);

	fnaBudgetfeeTypeOperationThread.setBudgetCanBeNegative(budgetCanBeNegative);
	fnaBudgetfeeTypeOperationThread.setgCtrlException(gCtrlException);

	fnaBudgetfeeTypeOperationThread.setIsprint(false);


	Thread thread_1 = new Thread(fnaBudgetfeeTypeOperationThread);
	thread_1.start();
	
}else if(operation.equals("delete") || operation.equals("batchDel")){

	String batchDelIds = Util.null2String(request.getParameter("batchDelIds"));
	if(operation.equals("delete")){
		batchDelIds = id;
	}
	
	String[] batchDelIdsArray = batchDelIds.split(",");
	FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
	
	StringBuffer batchDelIds2 = new StringBuffer();
	List<String> batchDelIdsList = new ArrayList<String>();
	for(int i=0;i<batchDelIdsArray.length;i++){
		int _delId = Util.getIntValue(batchDelIdsArray[i], 0);
		if(_delId > 0){
			String errorFlag = (String)fnaSplitPageTransmethod.getFnaBudgetfeeTypeViewInner_popedom(_delId+"", "1").get(3);
			if("false".equals(errorFlag)){
				if(operation.equals("batchDel")){
					continue;
				}else{
					out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(33031,user.getLanguage()))+"}");//科目正在被使用不能删除
					out.flush();
					return;
				}
			}
			if(batchDelIds2.length() > 0){
				batchDelIds2.append(",");
			}
			batchDelIds2.append(_delId);
			batchDelIdsList.add(_delId+"");
		}
	}
	
	int delSupsubject_last = 0;
	int delFeelevel_last = 0;
	for(int i=0;i<batchDelIdsList.size();i++){
		int _delId = Util.getIntValue(batchDelIdsList.get(i), 0);

		if((i+1)==batchDelIdsList.size()){
			RecordSet.executeSql("select supsubject, feelevel from fnabudgetfeetype where id = "+_delId);
			if(RecordSet.next()){
				delSupsubject_last = RecordSet.getInt("supsubject");
				delFeelevel_last = RecordSet.getInt("feelevel");
			}
		}
		
		RecordSet.executeSql("select id, budgetinfoid from FnaBudgetInfoDetail where budgettypeid="+_delId);
		while(RecordSet.next()){
			int budgetinfoid = RecordSet.getInt("budgetinfoid");
			int fnaBudgetInfoDetailId = RecordSet.getInt("id");
			rs.executeSql("select id from FnaBudgetInfo b where status = 0 and b.id = "+budgetinfoid);
			if(rs.next()){
				rs1.executeSql("delete from FnaBudgetInfoDetail where budgettypeid = "+budgetinfoid+" and id = "+fnaBudgetInfoDetailId);
			}
		}

		RecordSet.executeSql("delete from FnabudgetfeetypeCGE where (subjectId = "+_delId+" or mainSubjectId = "+_delId+")");
		RecordSet.executeSql("delete from FnabudgetfeetypeRuleSet where mainid = "+_delId);
		RecordSet.executeSql("delete from fnabudgetfeetype where id = "+_delId);
	}
	
	budgetfeeTypeComInfo.removeBudgetfeeTypeCache();
	out.println("{\"flag\":true,\"delSupsubject_last\":"+delSupsubject_last+",\"delFeelevel_last\":"+delFeelevel_last+"}");//删除成功
	out.flush();
	return;
	
}else if(operation.equals("archive")){//1：封存；
	String checkid=Util.null2String(request.getParameter("checkid")).trim();
	checkid +=-1;

	List<String> _subjectList1 = BudgetfeeTypeComInfo.recursiveSuperior(checkid);
	int _subjectList1_len = _subjectList1.size();
	List<String> _subjectList2 = BudgetfeeTypeComInfo.recursiveSubordinate(checkid);
	int _subjectList2_len = _subjectList2.size();
	List<String> _subjectListAll = new ArrayList<String>();
	StringBuffer _subjectListAllStr = new StringBuffer();
	for(int i=0;i<_subjectList1_len;i++){
		String _id = _subjectList1.get(i);
		if(!_subjectListAll.contains(_id)){
			_subjectListAll.add(_id);
			if(_subjectListAllStr.length() > 0){
				_subjectListAllStr.append(",");
			}
			_subjectListAllStr.append(_id);
		}
	}
	for(int i=0;i<_subjectList2_len;i++){
		String _id = _subjectList2.get(i);
		if(!_subjectListAll.contains(_id)){
			_subjectListAll.add(_id);
			if(_subjectListAllStr.length() > 0){
				_subjectListAllStr.append(",");
			}
			_subjectListAllStr.append(_id);
		}
	}

	budgetfeeTypeComInfo.changeArchive(1, checkid, _subjectListAllStr.toString());

	budgetfeeTypeComInfo.removeBudgetfeeTypeCache();
	
	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
	
}else if(operation.equals("lifted")){//0、NULL：未封存；
	String checkid=Util.null2String(request.getParameter("checkid")).trim();
	checkid +=-1;

	List<String> _subjectList1 = BudgetfeeTypeComInfo.recursiveSuperior(checkid);
	int _subjectList1_len = _subjectList1.size();
	List<String> _subjectList2 = BudgetfeeTypeComInfo.recursiveSubordinate(checkid);
	int _subjectList2_len = _subjectList2.size();
	List<String> _subjectListAll = new ArrayList<String>();
	StringBuffer _subjectListAllStr = new StringBuffer();
	for(int i=0;i<_subjectList1_len;i++){
		String _id = _subjectList1.get(i);
		if(!_subjectListAll.contains(_id)){
			_subjectListAll.add(_id);
			if(_subjectListAllStr.length() > 0){
				_subjectListAllStr.append(",");
			}
			_subjectListAllStr.append(_id);
		}
	}
	for(int i=0;i<_subjectList2_len;i++){
		String _id = _subjectList2.get(i);
		if(!_subjectListAll.contains(_id)){
			_subjectListAll.add(_id);
			if(_subjectListAllStr.length() > 0){
				_subjectListAllStr.append(",");
			}
			_subjectListAllStr.append(_id);
		}
	}

	budgetfeeTypeComInfo.changeArchive(0, checkid, _subjectListAllStr.toString());

	budgetfeeTypeComInfo.removeBudgetfeeTypeCache();
	
	out.println("{\"flag\":true}");//成功
	out.flush();
	return;
	
}else if(operation.equals("ruleSetOp")){//设置预算科目应用范围
	try{
		String ids = Util.null2String(request.getParameter("ids"));
		if(!"".equals(ids)){
			String[] checkidArray = Util.splitString(ids, ",");
			if(checkidArray.length>0){
				List<String> list = Arrays.asList(checkidArray);
				budgetfeeTypeComInfo.updateFeetypeRuleSet(list, true, feetypeRuleSetZb, feetypeRuleSetFb, feetypeRuleSetBm, feetypeRuleSetCbzx);
			}
		}
		
		out.println("{\"flag\":true,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(18758,user.getLanguage()))+"}");
		out.flush();
		return;
		
	}catch(Exception e){
		out.println("{\"flag\":false,\"msg\":"+JSONObject.quote(SystemEnv.getHtmlLabelName(83280,user.getLanguage())+"："+e.getMessage())+"}");
		out.flush();
		return;
		
	}
}
%>
