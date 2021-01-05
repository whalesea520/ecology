<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<%
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
  String templetid = Util.fromScreen(request.getParameter("contracttempletid"),user.getLanguage());  
  String saveurl = Util.fromScreen(request.getParameter("saveurl"),user.getLanguage());  
  String ishirecontract = Util.fromScreen(request.getParameter("ishirecontract"),user.getLanguage());
  String remindaheaddate = Util.fromScreen(request.getParameter("remindaheaddate"),user.getLanguage());
  String remindman = Util.fromScreen(request.getParameter("remindman"),user.getLanguage());
  int subcompanyid=Util.getIntValue(request.getParameter("subcompanyid"),-1);
  int subcompanyid1=Util.getIntValue(String.valueOf(session.getAttribute("HrmContractTypeEditDo_")),0);
  if("".equals(remindaheaddate)){
	remindaheaddate = "0";
  }
  
  String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  String para = "";
  char separator = Util.getSeparator() ;
  
if(operation.equalsIgnoreCase("add")){
  para = typename+separator+templetid+separator+saveurl+separator+ishirecontract+separator+remindaheaddate+separator+remindman;  
  rs.executeProc("HrmConType_Insert",para);
    rs.executeSql("Select Max(id) as maxid FROM HrmContractType");
    
    rs.next();
    

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(rs.getInt("maxid"));
      SysMaintenanceLog.setRelatedName(typename);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmConType_Insert,"+para);
      SysMaintenanceLog.setOperateItem("81");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      rs2.executeSql("update HrmContractType set subcompanyid ="+subcompanyid+" where id ="+rs.getInt("maxid")+"");
      rs2.next();
  response.sendRedirect("HrmContractTypeAdd.jsp?isclose=1&subcompanyid1="+subcompanyid);
  return;
}
  
if(operation.equalsIgnoreCase("edit")){
  para = ""+id+separator+typename+separator+templetid+separator+saveurl+separator+ishirecontract+separator+remindaheaddate+separator+remindman;
  
  rs.executeProc("HrmConType_Update",para);
  
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(typename);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmConType_Update,"+para);
      SysMaintenanceLog.setOperateItem("81");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      rs2.executeSql("update HrmContractType set subcompanyid ="+subcompanyid+" where id ="+id+"");
  response.sendRedirect("HrmContractTypeEditDo.jsp?fromHrmDialogTab=1&isclose=1&id="+id+"&subcompanyid="+subcompanyid);
  return;
}

if(operation.equalsIgnoreCase("delete")){

  para = ""+id;
  String _name = ContractTypeComInfo.getContractTypename(id);

  String sql ="Select ID From HRMContract Where contracttypeid = "+id;
  rs.executeSql(sql);
  rs.next();
  if(Util.null2String(rs.getString("ID")).equals("")){
	  rs.executeProc("HrmConType_Delete",para);
  
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(_name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmConType_Delete,"+para);
      SysMaintenanceLog.setOperateItem("81");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
  }
  response.sendRedirect("HrmContractType.jsp?subcompanyid1="+subcompanyid1);
  return;
}
%>