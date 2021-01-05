
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.request.WFUrgerManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ruleBusiness" class="weaver.workflow.ruleDesign.RuleBusiness" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
  if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
      response.sendRedirect("/notice/noright.jsp") ;
      return ;
  }
  String ajax=Util.null2String(request.getParameter("ajax"));
  String src = Util.null2String(request.getParameter("src"));
////得到标记信息
  if(src.equalsIgnoreCase("editoperatorgroup")){
  	int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
  	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
  	int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
  	String isbill=Util.null2String(request.getParameter("isbill"));
  	String iscust=Util.null2String(request.getParameter("iscust"));
	String oldids=Util.null2String(request.getParameter("oldids"));
  	char flag = 2;
	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
	for(int i=0;i<rowsum;i++) {
		String type = Util.null2String(request.getParameter("group_"+i+"_type"));
		//System.out.println(type);
        int objid = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_id")),0);
        int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
		int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
		String jobobj = Util.null2String(request.getParameter("group_"+i+"_jobobj"));
		String jobfield = Util.null2String(request.getParameter("group_"+i+"_jobfield"));
        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
        String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
		String oldid=Util.null2String(request.getParameter("group_"+i+"_oldid"));
		if(!type.equals("")){
		    if (oldid.equals("")){
                RecordSet.executeSql("Insert into workflow_urgerdetail(workflowid,utype,objid,level_n,level2_n,conditions,conditioncn,jobobj,jobfield) "
                    +"values("+wfid+","+type+","+objid+","+level+","+level2+",'"+conditions+"','"+conditioncn+"','"+jobobj+"','"+jobfield+"')");
		    	RecordSet.executeSql("select max(id) id from workflow_urgerdetail ");
		    	RecordSet.first();
		    	int maxID = Util.getIntValue(RecordSet.getString("id"));
		    	//规则逻辑  ===== START =========
		    	String rulemaplistid = Util.null2String(request.getParameter("group_"+i+"_rulemaplistids"));
		    	if(!rulemaplistid.equals(""))
		    	{
		    		String[] _mlid = Util.TokenizerString2(rulemaplistid,",");
		    		for(int j=0;j<_mlid.length;j++)
		    		{
		    			RecordSet.executeSql(" select * from rule_maplist where id="+_mlid[j]);
		    			String nm = "";
		    			String ruleid = "";
		    			String mapid = "";
		    			if(RecordSet.first())
		    			{
		    				nm = Util.null2String(RecordSet.getString("nm"));
		    				ruleid = Util.null2String(RecordSet.getString("ruleid"));
		    				mapid = Util.null2String(RecordSet.getString("id"));
		    			}
	    				RecordSet.executeSql("update rule_maplist set linkid='"+maxID+"',rowidenty='0' where id='"+mapid+"'");
	    				RecordSet.executeSql("update rule_mapitem set linkid='"+maxID+"',rowidenty='0' where linkid='"+wfid+"' and rulesrc=4 and rowidenty="+i);
		    			if(nm.equals("0"))
		    			{
		    				RecordSet.executeSql(" update rule_base set linkid="+maxID+",rulename='"+WorkflowComInfo.getWorkflowname(wfid+"")+"-"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+"-"+maxID+"' where id="+ruleid);
		    			}
		    		}
		    		RecordSet.executeSql("delete from rule_maplist where  rowidenty<>0 and linkid='"+wfid+"' and rulesrc=4");
		    		
		    	}
		    	//规则逻辑  ===== END =========
		    }else
			{
                RecordSet.executeSql("update workflow_urgerdetail set objid="+objid+" , utype="+type+", level_n="+level+", level2_n="+level2+", conditions='"+conditions+"', conditioncn='"+conditioncn+"', jobobj='"+jobobj+"', jobfield='"+jobfield+"' where id="+oldid);
			    oldids=Util.StringReplace(oldids,","+oldid+",",",-1,");
			}
		}

	}
	//删除
	if (!oldids.equals(",")&&!oldids.equals(""))
	{
	oldids="-1"+oldids+"-1";
    RecordSet.execute("delete from workflow_urgerdetail where id in ("+oldids+") ");
	}
	
	//根据流程id插入督办权限表
	WFUrgerManager wFUrgerManager = new WFUrgerManager();
    wFUrgerManager.insertUrgerByWfid(wfid);
	
	
    response.sendRedirect("WFUrger.jsp?ajax="+ajax+"&wfid="+wfid);
    return;

  }
%>
