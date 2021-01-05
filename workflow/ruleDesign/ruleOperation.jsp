
<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<%@page import="weaver.workflow.ruleDesign.RuleInterface"%>
<%@page import="java.util.Map"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComminfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
	String testrule = Util.null2String(request.getParameter("testrule"));
	if(testrule.equals("1"))
	{
		RuleInterface ri = new RuleInterface();
		boolean f = ri.compareRuleforWF("45", "8620", "0", RuleInterface.RULESRC_CK);
		//System.out.println(f);
		return;
	}
	User user = HrmUserVarify.getUser(request, response) ;
	if (user == null ) return ;
	int id = Util.getIntValue(request.getParameter("ruleid"), -1);
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	String formid = Util.null2String(request.getParameter("formid"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String condit = Util.null2String(request.getParameter("condit"));
	condit = condit.replace("'","''");
	String rulename = "";
	String ruledesc = "";
	String rulexml = request.getParameter("rulexml");
	String linkname = "";
	String wfid = request.getParameter("wfid");
	String wfname = "";
	String exesql = "";
	int ruleRelationship = 1;
	if(rulesrc.equals("1"))		//鍑哄彛鏉′欢
		exesql = " select workflowid as wfid,linkname as linkname from workflow_nodelink where id="+linkid;
	else if(rulesrc.equals("2"))
		exesql = " select t1.workflowid as wfid,t2.nodename as linkname from workflow_flownode t1,workflow_nodebase t2 where t1.nodeid=t2.id and t2.id="+linkid;
	else if(rulesrc.equals("4"))
	{
		wfid = linkid;
		wfname = WorkflowComminfo.getWorkflowname(wfid);
		linkname = SystemEnv.getHtmlLabelName(21219,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage());
	}else if(rulesrc.equals("5"))
	{
		exesql = "select workflowid as wfid,'"+SystemEnv.getHtmlLabelName(84554, user.getLanguage())+"' as linkname from wfec_indatawfset where id="+linkid;
	}else if(rulesrc.equals("6"))//流程代理条件
    {
        linkname = SystemEnv.getHtmlLabelName(84555,user.getLanguage());
    } else if(rulesrc.equals("7") || rulesrc.equals("8")) { //子流程触发条件（主表）
        linkname = SystemEnv.getHtmlLabelName(126298, user.getLanguage()) + "(" + WorkflowComminfo.getWorkflowname(wfid) + ")";
    }
		
	RecordSet.executeSql(exesql);
	if(RecordSet.first())
	{
		linkname = Util.null2String(RecordSet.getString("linkname"));
		wfid = Util.null2String(RecordSet.getString("wfid"));
		wfname = WorkflowComminfo.getWorkflowname(wfid);
	}
	rulename = wfname + " " +linkname;
	if(rulesrc.equals("3"))
	{
		String ruleid = Util.null2String(request.getParameter("ruleid"));
		exesql = " select rulename from rule_base where id="+ruleid;
		RecordSet.executeSql(exesql);
		if(RecordSet.first())
			rulename = Util.null2String(RecordSet.getString("rulename"));
	}
	RuleBean rb = new RuleBean();
	rb.setRulesrc(rulesrc);
	rb.setFormid(formid);
	rb.setLinkid(linkid);
	rb.setRulename(rulename);
	rb.setId(id);
	rb.setIsbill(isbill);
	rb.setCondit(condit);
	rb.setRuledesc(ruledesc);
    RuleBusiness rulebusiness = new RuleBusiness();
    String ruleid = rulebusiness.persistenceRule2db(rulexml,rb);
    int rownum = Util.getIntValue(request.getParameter("rownum"),0);
    if(Util.getIntValue(ruleid,-1) > 0) 
    {
    	if(!rulesrc.equals("") && !rulesrc.equals("3"))
    	{
	    	RecordSet.executeSql("select count(0) count from rule_maplist where ruleid="+ruleid);
	    	if(RecordSet.first())
	    		if(Util.getIntValue(RecordSet.getString("count"),0) == 0)
	    			RecordSet.executeSql("insert into rule_maplist (linkid,ruleid,wfid,isused,rulesrc,nm,rowidenty) values('"+linkid+"','"+ruleid+"','"+wfid+"',1,'"+rulesrc+"',0,"+rownum+")");
    	}
    }
    String ruleids = "";
    String condits = "";
    String maplistids = "";
    
    if(rulesrc.equals("1"))
    {
    	String sql = "select ruleid from rule_maplist where rulesrc="+rulesrc+" and linkid="+linkid;
    	RecordSet.executeSql(sql);
 		
 		while(RecordSet.next())
 		{
 			ruleids += RecordSet.getString("ruleid")+",";	
 		}
 		if(!ruleids.equals(""))
 			ruleids = ruleids.substring(0,ruleids.lastIndexOf(","));
 		sql = "update workflow_nodelink set newrule='"+ruleids+"' where id="+linkid;
 		RecordSet.executeSql(sql);
    }else if(rulesrc.equals("4") || rulesrc.equals("2")||rulesrc.equals("5")||rulesrc.equals("6"))
    {
    	String sql = "select t1.ruleid,t2.condit,t1.id from rule_maplist t1,rule_base t2 where t1.ruleid=t2.id and t1.rulesrc='"+rulesrc+"' and t1.linkid='"+linkid+"' and t1.rowidenty='"+rownum+"'";
		RecordSet.executeSql(sql);
		int i = 0;
 		while(RecordSet.next())
 		{
 			i++;
 			if(i==RecordSet.getCounts())
 			{
 				maplistids += RecordSet.getString("id");
	 			condits += RecordSet.getString("condit");
	 			ruleids += RecordSet.getString("ruleid");
 			}else
 			{
 				//判断规则关系 and or
 				rs1.executeSql("select ruleRelationship from workflow_flownode where nodeid = " + linkid);
 				if(rs1.next()){
 					ruleRelationship = Util.getIntValue(rs1.getString("ruleRelationship"), 1);
 				}
	 			maplistids += RecordSet.getString("id")+",";
	 			if(ruleRelationship == 1){
	 				condits += RecordSet.getString("condit") + "AND";
	 			}else{
	 				condits += RecordSet.getString("condit") + "OR";
	 			}
	 			ruleids += RecordSet.getString("ruleid")+",";
 			}
 		}
 		
 		//System.out.println("ruleRelationship = "+ruleRelationship);
 		//System.out.println(condits);
    } else if (rulesrc.equals("7") || rulesrc.equals("8")) {
        Map<String, String> ruleinfokv = RuleBusiness.getRuleInfoByRIds(Util.getIntValue(rulesrc), linkid + "");
        ruleids = ruleinfokv.get(RuleBusiness.RULE_ID_KEY);
        condits = ruleinfokv.get(RuleBusiness.RULE_DESC_KEY);
    }
 	//System.out.println("ruleRelationship = "+ruleRelationship);
    String _condit = condit.replaceAll("''","'");
    String data="{\"id\":\""+ruleid+"\",\"name\":\""+_condit+"\",\"src\":\""+rulesrc+"\",\"ruleids\":\""+ruleids+"\",\"condits\":\""+condits+"\",\"maplistids\":\""+maplistids+"\",\"ruleRelationship\":\""+ruleRelationship+"\"}";
    response.getWriter().write(data);
%>


