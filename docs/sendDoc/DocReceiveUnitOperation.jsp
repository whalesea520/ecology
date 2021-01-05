<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.senddoc.DocReceiveUnitConstant" %>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page" />
<jsp:useBean id="DocReceiveUnitManager" class="weaver.docs.senddoc.DocReceiveUnitManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("SRDoc:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
    return;
}

String method=Util.null2String(request.getParameter("method"));

String receiveUnitId=Util.null2String(request.getParameter("id"));
//String receiveUnitName=Util.null2String(request.getParameter("receiveUnitName"));
String receiveUnitName = Util.fromScreen(request.getParameter("receiveUnitName"),user.getLanguage());
String superiorUnitId=Util.null2String(request.getParameter("superiorUnitId"));
String receiverIds=Util.null2String(request.getParameter("receiverIds"));
double showOrder_d=Util.getDoubleValue(request.getParameter("showOrder"));
DecimalFormat df = new DecimalFormat("#.00");
String showOrder = df.format(showOrder_d);
String tempsubcompanyid = Util.null2String(request.getParameter("subcompanyid"));
int subcompanyid = 0;
if(tempsubcompanyid.endsWith(",")){
	subcompanyid = Util.getIntValue(tempsubcompanyid.substring(0,tempsubcompanyid.length()-1), 0);
}else{
	subcompanyid = Util.getIntValue(tempsubcompanyid,0);
}
String canStartChildRequest=Util.null2String(request.getParameter("canStartChildRequest"));
if(!"0".equals(canStartChildRequest)){
	canStartChildRequest="1";
}
String changeDir=Util.null2String(request.getParameter("changeDir"));
String companyType=Util.null2String(request.getParameter("companyType"));
String isMain=Util.null2String(request.getParameter("isMain"));
boolean ischeckdir = false;
if(companyType.equals("0")) {
	changeDir = "";
}
else {
	//receiverIds = "";
	ischeckdir = true;//DocReceiveUnitComInfo.checkChangeDir(changeDir);//页面已用DWR检查
	if(!ischeckdir) {
%>
<script>alert('<%=SystemEnv.getHtmlLabelName(22943,user.getLanguage())%>!');history.go(-1);</script>
<%
		return;
	}
}

String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));

String allSuperiorUnitId="";
String level="0";

if(superiorUnitId.equals("")||superiorUnitId.equals(DocReceiveUnitConstant.RECEIVE_UNIT_ROOT_ID)){
	superiorUnitId=DocReceiveUnitConstant.RECEIVE_UNIT_ROOT_ID;
    allSuperiorUnitId=superiorUnitId;
	level="1";
}else{
    allSuperiorUnitId=DocReceiveUnitComInfo.getAllSuperiorUnitId(superiorUnitId)+","+superiorUnitId;
	level=String.valueOf(Integer.parseInt(DocReceiveUnitComInfo.getLevel(superiorUnitId))+1);
}

if(receiveUnitName!=null){
	receiveUnitName=receiveUnitName.trim();
}
String isWfDoc = Util.null2String(request.getParameter("isWfDoc"));
if(method.equals("AddSave")){


	//RecordSet.executeSql("insert into DocReceiveUnit(receiveUnitName,superiorUnitId,receiverIds,allSuperiorUnitId,level,showOrder) values('"+receiveUnitName+"',"+superiorUnitId+",'"+receiverIds+"','"+allSuperiorUnitId+"',"+level+","+showOrder+")");
	//RecordSet.executeSql("insert into DocReceiveUnit(receiveUnitName,superiorUnitId,receiverIds,allSuperiorUnitId,unitLevel,showOrder,subcompanyid) values('"+receiveUnitName+"',"+superiorUnitId+",'"+receiverIds+"','"+allSuperiorUnitId+"',"+level+","+showOrder+","+subcompanyid+")");
	String sql = "insert into DocReceiveUnit(receiveUnitName,superiorUnitId,receiverIds,allSuperiorUnitId,unitLevel,showOrder,subcompanyid,canStartChildRequest,changeDir,companyType,isMain) values('"+receiveUnitName+"',"+superiorUnitId+",'"+receiverIds+"','"+allSuperiorUnitId+"',"+level+","+showOrder+","+subcompanyid+",'"+canStartChildRequest+"','"+changeDir+"','"+companyType+"','"+isMain+"')";
	RecordSet.executeSql(sql);
	RecordSet.executeSql(" select max(id) from DocReceiveUnit ");

	if(RecordSet.next()){
		receiveUnitId=Util.null2String(RecordSet.getString(1));
	}
	log.insSysLogInfo(user, Util.getIntValue(receiveUnitId), receiveUnitName, sql, isWfDoc.equals("1")?"348":"221", "1", 0, request.getRemoteAddr());
    DocReceiveUnitComInfo.removeDocReceiveUnitCache();
    if(isDialog.equals("1")){
    	response.sendRedirect("DocReceiveUnitAdd.jsp?refresh=1&isclose=1&receiveUnitId="+receiveUnitId+"&subcompanyid="+subcompanyid);
    }else{
    	response.sendRedirect("DocReceiveUnitFrame.jsp?refresh=1&receiveUnitId="+receiveUnitId+"&subcompanyid="+subcompanyid);
    }
	return;
 }
 else if(method.equals("EditSave")){

    //在级别改变的情况下,更新所有下级的“级别”和“所有上级”字段的值
    if(!superiorUnitId.equals(DocReceiveUnitComInfo.getSuperiorUnitId(receiveUnitId))){
		DocReceiveUnitManager.updateDataOfAllSubReceiveUnit(receiveUnitId,allSuperiorUnitId,level);
	}
    String logsql = "";
    //修改了分部
    if(subcompanyid != Util.getIntValue(DocReceiveUnitComInfo.getSubcompanyid(receiveUnitId))){
		//更改所有下级的所属分部
		boolean isoracle = RecordSet.getDBType().equals("oracle");
		String sql=null;
		if(isoracle){
			sql = "update DocReceiveUnit set subCompanyId="+subcompanyid+"  where ','||allSuperiorUnitId||',' like '%,"+receiveUnitId+",%'";
		}else{
			sql = "update DocReceiveUnit set subCompanyId="+subcompanyid+"  where ','+allSuperiorUnitId+',' like '%,"+receiveUnitId+",%'";
		}
		logsql = sql;
	    RecordSet.executeSql(sql);
    }
    //update by fanggsh 20060919 for TD4529  level字段改为unitLevel  begin
	//RecordSet.executeSql("update DocReceiveUnit set receiveUnitName='"+receiveUnitName+"',superiorUnitId="+superiorUnitId+",receiverIds='"+receiverIds+"',allSuperiorUnitId='"+allSuperiorUnitId+"',level="+level+",showOrder="+showOrder+"   where id="+receiveUnitId);
	//RecordSet.executeSql("update DocReceiveUnit set receiveUnitName='"+receiveUnitName+"',superiorUnitId="+superiorUnitId+",receiverIds='"+receiverIds+"',allSuperiorUnitId='"+allSuperiorUnitId+"',unitLevel="+level+",showOrder="+showOrder+", subcompanyid="+subcompanyid+"  where id="+receiveUnitId);
	String sql =  "update DocReceiveUnit set receiveUnitName='"+receiveUnitName+"',superiorUnitId="+superiorUnitId+",receiverIds='"+receiverIds+"',allSuperiorUnitId='"+allSuperiorUnitId+"',unitLevel="+level+",showOrder="+showOrder+", subcompanyid="+subcompanyid+",canStartChildRequest='"+canStartChildRequest+"',changeDir='"+changeDir+"',companyType='"+companyType+"',isMain='"+isMain+"'  where id="+receiveUnitId;
	logsql = logsql + ";"+sql;
	RecordSet.executeSql(sql);
    //update by fanggsh 20060919 for TD4529  level字段改为unitLevel  end
	log.insSysLogInfo(user, Util.getIntValue(receiveUnitId), receiveUnitName, logsql, isWfDoc.equals("1")?"348":"221", "2", 0, request.getRemoteAddr());
    DocReceiveUnitComInfo.removeDocReceiveUnitCache();
    if(isDialog.equals("1")){
    	response.sendRedirect("DocReceiveUnitEdit.jsp?isclose=1&id="+receiveUnitId);
    }else{
    	response.sendRedirect("DocReceiveUnitEdit.jsp?refresh=1&id="+receiveUnitId);
    }
	return;
 }
 else if(method.equals("Delete")){
	 String result = DocReceiveUnitManager.getReceiveUnitCheckbox(""+receiveUnitId);
	 String subCompanyId = DocReceiveUnitComInfo.getSubcompanyid(receiveUnitId);
	 superiorUnitId=DocReceiveUnitComInfo.getSuperiorUnitId(""+receiveUnitId);
	 if("0".equalsIgnoreCase(result)){
		String sql = "delete from DocReceiveUnit where id="+receiveUnitId;
		RecordSet.executeSql(sql);
		log.insSysLogInfo(user, Util.getIntValue(receiveUnitId), DocReceiveUnitComInfo.getReceiveUnitName(receiveUnitId), sql,  isWfDoc.equals("1")?"348":"221", "3", 0, request.getRemoteAddr());
	    DocReceiveUnitComInfo.deleteDocReceiveUnitInfoCache(receiveUnitId);
	 }
    if("0".equals(superiorUnitId) || "".equals(superiorUnitId)){
    	response.sendRedirect("DocReceiveUnitRight.jsp?refresh=1&subcompanyid="+subCompanyId);
    }else{
    	response.sendRedirect("DocReceiveUnitEdit.jsp?refresh=1&receiveUnitId="+superiorUnitId);
    }
	return;
 }
%>
