
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.workflow.request.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
<jsp:useBean id="HomepageSetting" class="weaver.homepage.HomepageSetting" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ include file="/homepage/element/content/Common.jsp" %>
<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		strsqlwhere 格式为 条件1^,^条件2...
		perpage  显示页数
		linkmode 查看方式  1:当前页 2:弹出页

		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList
	*/
	String imgSymbol="";
    if (!"".equals(hpsb.getEsymbol())) imgSymbol="<img name='esymbol' src='"+hpsb.getEsymbol()+"'>&nbsp;";
    
    StaticObj staticobj = null;
    staticobj = StaticObj.getInstance();
    ArrayList onlineuserids = (ArrayList)staticobj.getObject("onlineuserids") ;
    if(onlineuserids.indexOf("1")!=-1) onlineuserids.remove("1");

%>	
  <TABLE  style="color:<%=hpsb.getEcolor()%>" id="_contenttable_<%=eid%>" class=Econtent  width="100%" cellPadding='0' cellSpacing='0'>
   <TR>	
	 <TD width=6px></TD>
	 <TD width='*' valign="top">

		<TABLE width="100%">   	
		 <%
		 RecordSet rsSys=new RecordSet();
		 rsSys.executeSql("select distinct h1.id,h1.eid,h1.orderid,h2.title,h2.hpid,h3.viewtype,h3.typeids,h3.flowids,h3.nodeids from hpsysremind h1, hpelement h2 ,hpsetting_wfcenter h3 where h1.eid=h2.id and h1.eid=h3.eid   order by h1.orderid,h1.id");
		 while(rsSys.next()){
			
			 
			String remindId=Util.null2String(rsSys.getString("id"));			
			String orderid=Util.null2String(rsSys.getString("orderid"));
			
			String eidData=Util.null2String(rsSys.getString("eid"));
			String eidTitle=Util.null2String(rsSys.getString("title"));
			String viewType=Util.null2String(rsSys.getString("viewtype"));
			String wftypeSetting=Util.null2String(rsSys.getString("typeids"));
			String wflowSetting=Util.null2String(rsSys.getString("flowids"));
			String wfNodeSetting=Util.null2String(rsSys.getString("nodeids"));
			
			String eidHpid=Util.null2String(rsSys.getString("hpid"));
			if(!hpid.equals(eidHpid)) continue;
			RecordSet rsIn=new RecordSet();
			
			int viewUserId=hpu.getHpUserId(hpid,""+subCompanyId,user);
			int viewUserType=hpu.getHpUserType(hpid,""+subCompanyId,user);
			if(hpc.getIsLocked(hpid).equals("1")) {
		         viewUserId=Util.getIntValue(hpc.getCreatorid(hpid));
		         viewUserType=Util.getIntValue(hpc.getCreatortype(hpid));
		    }
			
			String strInSql="select count(*) from hpElementSettingDetail where hpid="+hpid+" and eid="+eidData+" and userid="+viewUserId+" and usertype="+viewUserType;
			//out.println(strInSql);
			rsIn.executeSql(strInSql);			
			
			if(rsIn.next()) {
				if(rsIn.getInt(1)<=0) continue;
			}
				
			//System.out.println("wftypeSetting:"+wftypeSetting);
			String backFields="";
			String sqlFrom="";
			String sqlWhere="";
			String sqlWhere2="";
			if(Util.getIntValue(viewType)==1){ //1:待办事宜
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3";
			
				sqlWhere="where t1.requestid = t2.requestid and t1.workflowid=t3.id  and (t3.isvalid='1' or t3.isvalid='3') and (t2.isremark='0' or  t2.isremark='1' or  t2.isremark='5' or  t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7') and t2.islasttimes=1 " +
						" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);

				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				if(!"".equals(wfNodeSetting)) sqlWhere+=" and t2.nodeid in("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(wfNodeSetting)+")";
				
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";
			} else if (Util.getIntValue(viewType)==2){//2:已办事宜
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3";
			
				sqlWhere="where t1.requestid = t2.requestid and t1.workflowid=t3.id  and (t3.isvalid='1' or t3.isvalid='3') and t2.isremark=2 and  t2.iscomplete=0  and t2.islasttimes=1 " +
						" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";

			} else if (Util.getIntValue(viewType)==3){// 3:办结事宜
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3";
			
				sqlWhere="where t1.requestid = t2.requestid and t1.workflowid=t3.id  and (t3.isvalid='1' or t3.isvalid='3') and t2.isremark in('2','4')  and t1.currentnodetype = '3'  and t2.islasttimes=1 " +
						" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";
			} else if (Util.getIntValue(viewType)==4){//4:我的请求
				
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3";
			
				sqlWhere="where t1.requestid = t2.requestid and t1.workflowid=t3.id  and (t3.isvalid='1' or t3.isvalid='3') and t1.creater = "+user.getUID()+" and t1.creatertype = "+(Util.getIntValue(user.getLogintype())-1)+" and t2.islasttimes=1 " +
						" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);
				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";

			}else if (Util.getIntValue(viewType)==5){//5:抄送事宜
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3";
			
				sqlWhere="where t1.requestid = t2.requestid and t1.workflowid=t3.id  and (t3.isvalid='1' or t3.isvalid='3') and ( t2.isremark='8' or  t2.isremark='9' or  t2.isremark='7') and t2.islasttimes=1 " +
						" and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1);

				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";
				
			}else if (Util.getIntValue(viewType)==6){//6:督办事宜 
				ArrayList  flowList=Util.TokenizerString(wflowSetting,",");	
				int logintype = Util.getIntValue(user.getLogintype());
			    int userID = user.getUID();
			    WFUrgerManager.setLogintype(logintype);
			    WFUrgerManager.setUserid(userID);
			    ArrayList wftypes=WFUrgerManager.getWrokflowTree();
			    String requestids="";
			    for(int i=0;i<wftypes.size();i++){
			    	WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
			    	ArrayList workflows=wftype.getWorkflows();
			    	
			    	for (int j=0;j<workflows.size();j++){
			    		WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);	    		
			    		String tempWorkflow=wfworkflow.getWorkflowid()+"";
			    		if("".equals(wflowSetting)||flowList.contains(tempWorkflow)) {
				            ArrayList requests=wfworkflow.getReqeustids();
				            for(int k=0;k<requests.size();k++){
				                if(requestids.equals("")){
				                    requestids=(String)requests.get(k);
				                }else{
				                    requestids+=","+requests.get(k);
				                }
				            }
			    		}
			    	}
			    }
			    
			    
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t1.requestlevel ";
				if(rsSys.getDBType().equals("oracle")){
					sqlFrom = " from (select requestid,max(receivedate||' '||receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
                }else{
					sqlFrom = " from (select requestid,max(receivedate+' '+receivetime) as receivedate,'' as receivetime from workflow_currentoperator group by requestid) t2,workflow_requestbase t1 ";
				}
				sqlWhere="where t1.requestid = t2.requestid " ;
				if(!"".equals(requestids)) sqlWhere+=" and t1.requestid in("+requestids+")";	
				else sqlWhere+=" and 1=2";	
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";
			}else if (Util.getIntValue(viewType)==7){//7:超时事宜
				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				sqlFrom=" from workflow_requestbase t1,workflow_currentoperator t2 ,workflow_base t3";
			
				sqlWhere="where t1.requestid = t2.requestid and t1.workflowid=t3.id  and t2.userid = "+user.getUID()+" and t2.usertype="+(Util.getIntValue(user.getLogintype())-1)+" and  ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') "+
						" and t1.currentnodetype <> 3";

				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				if(!"".equals(wfNodeSetting)) sqlWhere+=" and t2.nodeid in("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(wfNodeSetting)+")";
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";
			}else if (Util.getIntValue(viewType)==8){//8:反馈事宜

				backFields="t1.requestid, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t2.receivedate,t2.receivetime,t2.viewtype,t2.isreminded,t3.workflowtype,t2.nodeid,t1.requestlevel,t2.isremark ";
				
				sqlFrom=" from workflow_requestbase t1, ( select  receivedate,receivetime,requestid,viewtype,isreminded,nodeid,isremark,isprocessed from workflow_currentoperator where "+
							" needwfback = 1 and viewtype=-1 and isremark in('2','4') and userid ="+user.getUID()+" and usertype="+(Util.getIntValue(user.getLogintype())-1)+
							") t2,workflow_base t3 ";
				
				
				
				sqlWhere=" t1.requestid = t2.requestid and t1.workflowid=t3.id ";

				if(!"".equals(wftypeSetting)) sqlWhere+=" and t3.workflowtype in("+wftypeSetting+")";
				if(!"".equals(wflowSetting)) sqlWhere+=" and t3.id in("+WorkflowVersion.getAllVersionStringByWFIDs(wflowSetting)+")";
				if(!"".equals(wfNodeSetting)) sqlWhere+=" and t2.nodeid in("+WorkflowVersion.getAllRelationNodeStringByNodeIDs(wfNodeSetting)+")";
				
				sqlWhere2=sqlWhere+" and t2.viewtype=0 ";				
			}
			
			//out.println("viewType:"+viewType);
			//System.out.println("sqlWhere:"+sqlWhere);
			SplitPageParaBean sppb=new SplitPageParaBean();
			sppb.setBackFields(backFields);
			sppb.setPrimaryKey("t1.requestid");
			sppb.setDistinct(true);
			sppb.setSqlFrom(sqlFrom);
			sppb.setSqlWhere(sqlWhere); 
			sppb.setSqlOrderBy("t2.receivedate ,t2.receivetime");
			sppb.setSortWay(sppb.DESC);
			
			SplitPageUtil spu=new SplitPageUtil();
			spu.setSpp(sppb);
			
			SplitPageParaBean sppb1=new SplitPageParaBean();
			sppb1.setBackFields(backFields);
			sppb1.setPrimaryKey("t1.requestid");
			sppb1.setDistinct(true);
			sppb1.setSqlFrom(sqlFrom);
			sppb1.setSqlWhere(sqlWhere2); 
			sppb1.setSqlOrderBy("t2.receivedate ,t2.receivetime");
			sppb1.setSortWay(sppb.DESC);
			
			SplitPageUtil spu1=new SplitPageUtil();
			spu1.setSpp(sppb1);
					
		 %>
		  <TR  height=18px>
 			<TD width="8px"><%=imgSymbol%></TD>
			<TD width="*"><%=eidTitle%></TD>
			<TD  width="80px" ><%=hpu.getLinkStr("/homepage/element/more/wfCenterMore.jsp?eid="+eidData+"&viewtype=0",SystemEnv.getHtmlLabelName(83697,user.getLanguage())+"（"+spu1.getRecordCount()+"）",linkmode)%></TD>
			<TD  width="80px" align="right"><%=hpu.getLinkStr("/homepage/element/more/wfCenterMore.jsp?eid="+eidData+"",SystemEnv.getHtmlLabelName(83698,user.getLanguage())+"（"+spu.getRecordCount()+"）",linkmode)%></TD>
		  </TR>         
          <TR style="background:url('<%=hpsb.getEsparatorimg()%>')" height=1px><td colspan=4></td></TR>
		<%}%>
		  <TR  height=18px>
 			<TD width="8px"><%=imgSymbol%></TD>
			<TD width="*"><%=SystemEnv.getHtmlLabelName(83699,user.getLanguage())%></TD>
			<TD  width="80px" ><%=hpu.getLinkStr("/hrm/resource/OnlineUser.jsp",SystemEnv.getHtmlLabelName(83698,user.getLanguage())+"("+onlineuserids.size()+")",linkmode)%></TD>
			<TD  width="80px" align="right">&nbsp;</TD>
		  </TR>
		 </table>
    
	</TD>    
	<TD width=6px></TD>
  </TR>
</TABLE>
		  