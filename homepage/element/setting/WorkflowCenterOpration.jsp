
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.conn.RecordSetTrans"%>
<%@ page import="oracle.sql.CLOB"%>
<%@ page import="java.io.Writer"%>
<%@ page import="java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
int eid=Util.getIntValue(request.getParameter("eid"));
int viewType=Util.getIntValue(request.getParameter("viewType"));
String typeids=Util.null2String(request.getParameter("typeids"));
String flowids=Util.null2String(request.getParameter("flowids"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String tabTitle = Util.null2String(request.getParameter("tabTitle"));
String wfids=Util.null2String(request.getParameter("wfids"));
String tabId = Util.null2String(request.getParameter("tabId"));
String method = Util.null2String(request.getParameter("method"));
int isExclude=Util.getIntValue(request.getParameter("isExclude"),0);
String showCopy = Util.null2String(request.getParameter("showCopy"));
String countFlag = Util.null2o(request.getParameter("countFlag"));
String completeflag = Util.null2String(request.getParameter("completeflag"));
String orders = Util.null2String(request.getParameter("orders"));

if(showCopy.equals("")){
	showCopy = "0";
}
Hashtable tabAddList =null;
ArrayList tabRemoveList = null;


if(session.getAttribute(eid+"_Add")!=null){
	tabAddList = (Hashtable)session.getAttribute(eid+"_Add");
}else{
	tabAddList = new Hashtable();
	
}


if(session.getAttribute(eid+"_Remove")!=null){
	
	tabRemoveList = (ArrayList)session.getAttribute(eid+"_Remove");
}else{
	tabRemoveList = new ArrayList();
}

if(method.equals("add")||method.equals("edit")){
	Hashtable hasTabParam = new Hashtable();	
	hasTabParam.put("eid",eid+"");
	hasTabParam.put("viewType",viewType+"");
	hasTabParam.put("typeids",typeids);
	weaver.workflow.workflow.WorkflowVersion WorkflowVersion = new weaver.workflow.workflow.WorkflowVersion();
	flowids = WorkflowVersion.getAllVersionStringByWFIDs(flowids);
	hasTabParam.put("flowids",flowids);
	hasTabParam.put("nodeids",nodeids);
	hasTabParam.put("isExclude",isExclude+"");
	hasTabParam.put("tabTitle",tabTitle);
	hasTabParam.put("tabId",tabId);
	hasTabParam.put("showCopy",showCopy);
	hasTabParam.put("countFlag",countFlag);
	hasTabParam.put("completeflag",completeflag);
	hasTabParam.put("wfids",wfids);
	tabAddList.put(tabId,hasTabParam);
	session.setAttribute(eid+"_Add",tabAddList);
}else if(method.equals("delete")){
	String[] tabArr = tabId.split(";");
	for(String tmpS : tabArr){
		if(tabAddList.containsKey(tmpS)){
			tabAddList.remove(tmpS);	
		}
		tabRemoveList.add(tmpS);
		session.setAttribute(eid+"_Remove",tabRemoveList);
	}
}else if(method.equals("submit")){
	Enumeration e = tabAddList.elements();
	
//	Hashtable orderMap = new Hashtable();
	while(e.hasMoreElements()){ 
		Hashtable hasParam = (Hashtable)e.nextElement();
	//	hasParam.put("orderNum",orderMap.get(hasParam.get("tabId")));
		submitTabInfo(hasParam,rs);
	} 
	//更新页签序号，如果页面页签仅有拖拽更改，则需专门更新，此处专门更新行序
	if(orders != null && !"".equals(orders)){
		String strSql="update hpsetting_wfcenter set orderNum=? where eid=? and tabId =?";
		RecordSetTrans recordSetTrans = new RecordSetTrans();
		String[] arr = orders.split(";");
		for(String str : arr){
			String[] tmp = str.split("_");
			recordSetTrans.executeUpdate(strSql,new Object[]{tmp[1],eid,tmp[0]});
		}
		recordSetTrans.commit();
	}
	
	for(int i=0;i<tabRemoveList.size();i++){

		rs.execute("delete from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
		rs.execute("delete from workflowcentersettingdetail where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
	}
	session.removeAttribute(eid+"_Add");
	session.removeAttribute(eid+"_Remove");
	session.removeAttribute(eid+"_Edit");
}else if(method.equals("cancel")){
	session.removeAttribute(eid+"_Add");
	session.removeAttribute(eid+"_Remove");
}



%>
<%! 
	public void submitTabInfo(Hashtable hasParam,RecordSet rs){
		int eid = Util.getIntValue((String)hasParam.get("eid"));
		int viewType =Util.getIntValue((String)hasParam.get("viewType"));
		String typeids = (String)hasParam.get("typeids");
		String flowids = (String)hasParam.get("flowids");
		String nodeids = (String)hasParam.get("nodeids"); 
		int isExclude = Util.getIntValue((String)hasParam.get("isExclude")); 
		String tabTitle = (String)hasParam.get("tabTitle");
		String tabId = (String)hasParam.get("tabId");
		String showCopy = (String)hasParam.get("showCopy");
		String countFlag = Util.null2o((String)hasParam.get("countFlag"));
		int completeflag = Util.getIntValue((String)hasParam.get("completeflag"),0);
		rs.executeSql("select count(*) from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabId+"'");
		rs.next();
		
		RecordSetTrans recordSetTrans = new RecordSetTrans();
	
		recordSetTrans.setAutoCommit(false);
		try{
		
			if(rs.getInt(1)==0){
				String strSqlIn = "insert into hpsetting_wfcenter (eid,viewType,isExclude,tabId,tabTitle,showCopy,countflag,completeflag) values(?,?,?,?,?,?,?,?) ";
				//System.out.println("strSqlIn==="+strSqlIn);
				recordSetTrans.executeUpdate(strSqlIn,new Object[]{eid,viewType,isExclude,tabId,tabTitle,showCopy,countFlag,completeflag});
				recordSetTrans.executeSql("select id from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabId+"'");
				recordSetTrans.next();
				String maxid = recordSetTrans.getString("id");
				insertWorkflowCenterSettingDetail(eid,tabId,"typeid",Util.TokenizerString(typeids,","),maxid,recordSetTrans);
				weaver.workflow.workflow.WorkflowVersion WorkflowVersion = new weaver.workflow.workflow.WorkflowVersion();
				flowids = WorkflowVersion.getAllVersionStringByWFIDs(flowids);
				insertWorkflowCenterSettingDetail(eid,tabId,"flowid",Util.TokenizerString(flowids,","),maxid,recordSetTrans);
				nodeids = WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids);
				insertWorkflowCenterSettingDetail(eid,tabId,"nodeid",Util.TokenizerString(nodeids,","),maxid,recordSetTrans);
				recordSetTrans.commit();
				
			}else{
				
				String strSql="update hpsetting_wfcenter set viewType=?,isExclude=?, tabTitle=?, showCopy=?,countflag=?,completeflag=? where eid=? and tabId =?";
				//System.out.println("strSql==="+strSql);
				recordSetTrans.executeUpdate(strSql,new Object[]{viewType,isExclude,tabTitle,showCopy,countFlag,completeflag,eid,tabId});
				recordSetTrans.executeSql("select id from hpsetting_wfcenter  where eid="+eid+" and tabId='"+tabId+"'");
				recordSetTrans.next();
				String maxid = recordSetTrans.getString("id");
				
				strSql = "delete from workflowcentersettingdetail where eid='"+eid+"' and tabid='"+tabId+"'";
				recordSetTrans.executeSql(strSql);
				
				insertWorkflowCenterSettingDetail(eid,tabId,"typeid",Util.TokenizerString(typeids,","),maxid,recordSetTrans);
				weaver.workflow.workflow.WorkflowVersion WorkflowVersion = new weaver.workflow.workflow.WorkflowVersion();
				flowids = WorkflowVersion.getAllVersionStringByWFIDs(flowids);
				insertWorkflowCenterSettingDetail(eid,tabId,"flowid",Util.TokenizerString(flowids,","),maxid,recordSetTrans);
				nodeids = WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids);
				insertWorkflowCenterSettingDetail(eid,tabId,"nodeid",Util.TokenizerString(nodeids,","),maxid,recordSetTrans);
				recordSetTrans.commit();
			}
			insertSywfexinfo(eid,tabId,rs);
		}catch(Exception ex){
			ex.printStackTrace();
			recordSetTrans.rollback();
		}
		
	}

	public void insertWorkflowCenterSettingDetail(int eid,String tabid,String type,ArrayList contentList,String srcfrom,RecordSetTrans recordSetTrans) throws Exception{
		
		for(int i=0;i<contentList.size();i++){
			String content = (String)contentList.get(i);
			
			String sql = "insert into workflowcentersettingdetail (eid,tabid,type,content,srcfrom) values('"+eid+"','"+tabid+"','"+type+"','"+content+"','"+srcfrom+"')";
			recordSetTrans.executeSql(sql);
		}
	}
	
	public void insertSywfexinfo(int eid,String tabid,RecordSet rs){
		rs.executeSql("select id from hpsetting_wfcenter where eid = '"+eid+"' and tabid = '"+tabid+"'");
		if(rs.next()){
		   RecordSet res = new RecordSet();
		   //System.out.println("update sywfexinfo set  sourceid = '"+rs.getString("id")+"' where wfexid like '"+eid+"-"+tabid+"-"+"%'");
		   res.executeSql("update sywfexinfo set  sourceid = '"+rs.getString("id")+"' where wfexid like '"+eid+"-"+tabid+"-"+"%'");
		}
	}
%>
<%


//strSql="update hpelement set strsqlwhere='"+viewType+"' where id="+eid;
//rs.executeSql(strSql);
%>