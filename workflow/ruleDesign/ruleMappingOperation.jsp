
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
String  actionKey = Util.null2String(request.getParameter("actionKey"));
	int ruleid = Util.getIntValue(request.getParameter("ruleid"));
	int rulesrc = Util.getIntValue(request.getParameter("rulesrc"));
	
if(!"relationship".equals(actionKey)){
	RecordSet rs = new RecordSet();
	int linkid = Util.getIntValue(request.getParameter("linkid"));
	int formid = Util.getIntValue(request.getParameter("formid"));
	int isbill = Util.getIntValue(request.getParameter("isbill"));
	int wfid = Util.getIntValue(request.getParameter("wfid"));
	int rownum = Util.getIntValue(request.getParameter("rownum"),0);
	int mapid = Util.getIntValue(request.getParameter("mapid"));
	
	int detailid = Util.getIntValue(request.getParameter("detailid"), -1);
	
	boolean linkruleisExists = false;
	rs.executeSql("SELECT count(1) as count from rule_maplist where id=" + mapid);
	if (rs.next()) {
	    if (rs.getInt("count") > 0) {
	        linkruleisExists = true;
	    }
	}

	if (!linkruleisExists) {
		//nm : new-0 or map-1 
		rs.executeSql("insert into rule_maplist(ruleid, linkid,wfid, rulesrc,isused,nm,rowidenty, detailid) values('" + ruleid + "', '"+linkid+"','"+wfid+"', '" + rulesrc + "',1,1,'"+rownum+"', " + detailid + ")");
	} else {
		//不可以修改 规则
	    //rs.executeSql("update rule_mapping set ruleid=" + ruleid + " where id=" + mapid);
	}
	
	/*
	rs.executeSql("select max(id) from  rule_maplist where ruleid="+ruleid+" and linkid="+ linkid +" and wfid="+wfid +" and rulesrc="+ rulesrc+" and isused=1 and nm=1 "+" and rowidenty="+rownum);
	if(rs.next()){
	   mapid= rs.getInt(1);	
	}*/
	
	RuleBusiness rulebusiness = new RuleBusiness();
	rulebusiness.setRuleid(ruleid);
	rulebusiness.setUser(user);
	
	List<Map<String, String>> varlist = rulebusiness.getAllVar();
	
	for (int i=0; i<varlist.size(); i++) {
	    Map<String, String> varbean = varlist.get(i);
	 	String id = varbean.get("id");
	 	int mappingfieldid = Util.getIntValue(request.getParameter("field_" + id), -1);
	 	if (mappingfieldid == -1) continue;
		
	 	int nodeid = Util.getIntValue(request.getParameter("nodeSelect_" + id));
	    int meetCondition = Util.getIntValue(request.getParameter("meetSelect_" + id));
	 	
	 	boolean isExists = false;
	 	//if(nodeid>0){
	 	//	rs.executeSql("SELECT count(1) as count from rule_mapitem where rowidenty='"+rownum+"' and ruleid='" + ruleid + "' and linkid='" + linkid + "' and rulevarid=" + id +" and nodeid=" + nodeid);
	 	//}else{
		rs.executeSql("SELECT count(1) as count from rule_mapitem where rowidenty='"+rownum+"' and ruleid='" + ruleid + "' and linkid='" + linkid + "' and rulesrc='" + rulesrc + "' and rulevarid=" + id);

	 	//}
		if (rs.next()) {
		    if (rs.getInt("count") > 0) {
		        isExists = true;
		    }
		}		
		
		String sql = "";
		if (isExists) {
			//System.out.println("mappingfieldid"+mappingfieldid);
		    sql = "update rule_mapitem set formfieldid='" + mappingfieldid + "' ,nodeid="+nodeid+" ,meetcondition=" + meetCondition  + " where ruleid='" + ruleid + "' and rulesrc='"+rulesrc+"' and linkid='" + linkid 
		    		+"' and rulevarid=" + id ;
		} else {
		    sql = "insert into rule_mapitem(ruleid, linkid,rulesrc, rulevarid, formfieldid,rowidenty,nodeid,meetcondition) values ('" 
		 	       + ruleid + "', '" + linkid + "', '"+rulesrc+"', '" + id + "', '" + mappingfieldid + "','"+rownum+"', "+nodeid+", "+meetCondition +")";
		}
	 	rs.executeSql(sql);

	 	
	}
	String sql = "";
	if(rulesrc == 1)
 	{
 		sql = "select ruleid from rule_maplist where rulesrc='"+rulesrc+"' and linkid="+linkid;
 		rs.executeSql(sql);
 		String ruleids = "";
 		while(rs.next())
 		{
 			ruleids += rs.getString("ruleid")+",";	
 		}
 		if(!ruleids.equals(""))
 			ruleids = ruleids.substring(0,ruleids.lastIndexOf(","));
 		sql = "update workflow_nodelink set newrule='"+ruleids+"' where id="+linkid;
 		rs.executeSql(sql);
 	}else if(rulesrc == 4 || rulesrc == 2 || rulesrc == 5 || rulesrc == 6 || rulesrc == 7 || rulesrc == 8)
 	{
 		sql = "select id from rule_maplist where rowidenty="+rownum+" and rulesrc="+rulesrc+" and linkid="+linkid;
 		rs.executeSql(sql); 		
 		String maplistids = "";
 		while(rs.next())
 		{
 			maplistids += rs.getString("id")+",";	
 		}
 		if(!maplistids.equals(""))
 			maplistids = maplistids.substring(0,maplistids.lastIndexOf(","));
 		//System.out.println(maplistids);
 		response.sendRedirect("/workflow/ruleDesign/ruleMapping.jsp?isclose=1&ruleid="+ruleid+"&rulesrc="+rulesrc+"&linkid="+linkid+"&maplistids="+maplistids);
 		return;
 	}
  
	response.sendRedirect("/workflow/ruleDesign/ruleMapping.jsp?isclose=1&ruleid="+ruleid+"&rulesrc="+rulesrc+"&linkid="+linkid);
	//return;
}else{
	RecordSet rs = new RecordSet();
	String ruleRelationship = Util.null2String(request.getParameter("ruleRelationship"));
	if(rulesrc == 1){
		int linkid = Util.getIntValue(request.getParameter("linkid"));
		//System.out.println("linkid = "+linkid);
		if(linkid != -1){
			String updatesql = "update workflow_nodelink set ruleRelationship = '"+ruleRelationship+"' where id = "+linkid;
			rs.executeSql(updatesql);
		}
	}else if(rulesrc == 2){
		int nodeid = Util.getIntValue(request.getParameter("nodeid"));
		//System.out.println("nodeid = "+nodeid);
		if(nodeid != -1){
			String updatesql = "update workflow_flownode set ruleRelationship = '"+ruleRelationship+"' where nodeid = "+nodeid;
			rs.executeSql(updatesql);
		}
		
		int rownum = Util.getIntValue(request.getParameter("rownum"),0);
		/////
		int ruleRel = 1;
		String condits = "";
		RecordSet condrs = new RecordSet();
		RecordSet relationrs = new RecordSet();
		String condsql = "select t1.ruleid,t2.condit,t1.id from rule_maplist t1,rule_base t2 where t1.ruleid=t2.id and t1.rulesrc='"+rulesrc+"' and t1.linkid='"+nodeid+"' and t1.rowidenty='"+rownum+"'";
		condrs.executeSql(condsql);
		int i = 0;
 		while(condrs.next())
 		{
 			i++;
 			if(i==condrs.getCounts())
 			{
	 			condits += condrs.getString("condit");
 			}else
 			{
 				//判断规则关系 and or
 				relationrs.executeSql("select ruleRelationship from workflow_flownode where nodeid = " + nodeid);
 				if(relationrs.next()){
 					ruleRel = Util.getIntValue(relationrs.getString("ruleRelationship"), 1);
 				}
 				
	 			if(ruleRel == 1){
	 				condits += condrs.getString("condit") + "AND";
	 			}else{
	 				condits += condrs.getString("condit") + "OR";
	 			}
 			}
 		}
	    String data="{\"condits\":\""+condits+"\",\"ruleRelationship\":\""+ruleRelationship+"\"}";
	    response.getWriter().write(data);
		/////
	}else if(rulesrc == 5){
		int linkid = Util.getIntValue(request.getParameter("linkid"));
		if(linkid != -1){
			String updatesql = "update wfec_indatawfset set ruleRelationship = '"+ruleRelationship+"' where id = "+linkid;
			rs.executeSql(updatesql);
		}
	}else if(rulesrc ==6 || rulesrc == 7 || rulesrc == 8){
		int linkid = Util.getIntValue(request.getParameter("linkid"));
		int rownum = Util.getIntValue(request.getParameter("rownum"),0);
		int ruleRel = Util.getIntValue(request.getParameter("ruleRelationship"),1);
		String condits = "";
		RecordSet condrs = new RecordSet();
		RecordSet relationrs = new RecordSet();
		
		String condsql = "select t1.ruleid,t2.condit,t1.id from rule_maplist t1,rule_base t2 where t1.ruleid=t2.id and t1.rulesrc='"+rulesrc+"' and t1.linkid='"+linkid+"' and t1.rowidenty='"+rownum+"'";
		condrs.executeSql(condsql);
		int i = 0;
 		while(condrs.next())
 		{
 			i++;
 			if(i==condrs.getCounts())
 			{
	 			condits += condrs.getString("condit");
 			}else
 			{
	 			if(ruleRel == 1){
	 				condits += condrs.getString("condit") + " AND ";
	 			}else{
	 				condits += condrs.getString("condit") + " OR ";
	 			}
 			}
 		}
 		
 		if (rulesrc == 7) {
            String updatesql = "update Workflow_SubwfSet set ruleRelationship = '"+ruleRel+"', conditioncn=? where id = "+linkid;
            rs.executeUpdate(updatesql, condits);
        } else if (rulesrc == 8) {
            String updatesql = "update Workflow_TriDiffWfDiffField set ruleRelationship = '"+ruleRel+"', conditioncn=? where id = "+linkid;
            rs.executeUpdate(updatesql, condits);
        }
 		
 		
	    String data="{\"condits\":\""+condits+"\",\"ruleRelationship\":\""+ruleRelationship+"\"}";
	    response.getWriter().write(data);
		/////
	}
}
%>

