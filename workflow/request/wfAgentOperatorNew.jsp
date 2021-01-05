<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.request.wfAgentCondition"%>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.workflow.request.RequestAddShareInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs6" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs7" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs8" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />

<%
/*
* last modified by cyril on 2008-08-25 for td:9236
* 流程代理的优化

*/
int agentId = 0;
boolean flag = true; 
String method=request.getParameter("method");
String beagenterId2=request.getParameter("beagenterId");
String haveAgentAllRight = request.getParameter("haveAgentAllRight");
String isformmobile = request.getParameter("isformmobile");
String sql = "";
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
String[] value;
String[] value1;
String isCountermandRunning="";
String beaid="";
String aid="";
String wfid="";
char separ = Util.getSeparator();
String Procpara = "";
/*-----------------  流程代理设置 ---[老的代理目前暂时不用]-------------------- */
/*----------- td2551 xwj 20050902 begin ----*/
int isPendThing=Util.getIntValue(request.getParameter("isPendThing"),0);
int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
//e8 新改造后收回代理的逻辑
 if(method.equals("backAgent"))
{
	String agented = Util.null2String(request.getParameter("agented"));
	String agentFlag = Util.null2String(request.getParameter("agentFlag"));
	String agenttype = Util.null2String(request.getParameter("agenttype"));
	isCountermandRunning=Util.null2String(request.getParameter("isCountermandRunning"));
	String agentids = Util.null2String(request.getParameter("agentid"));
	if(agenttype.equals("mt") && StringUtils.isNotBlank(agentids)){
		agentids = agentids.substring(0,agentids.length()-1);
	}
	String agentid = "";
	agentids = "'"+StringUtils.replace(agentids, ",", "','")+"'";
	//System.out.println("====agenttype:"+agenttype);
	//单条代理收回
	if(agenttype.equals("it") || agenttype.equals("mt"))
	{
		rs7.executeSql("select * from workflow_agent where agentid in (" + agentids+")");
		while(rs7.next()){
			beaid = rs7.getString("beagenterid");
			aid = rs7.getString("agenterid");
			wfid= rs7.getString("workflowid");
			agentid = rs7.getString("agentid");
		 
			try{
				 String sqlconditset="update workflow_agentConditionSet set agenttype = '0' ,backDate='"+currentDate+"',backTime='"+currentTime+"' where agentid ='"+agentid+"'";
				 rs5.executeSql(sqlconditset);
				 
				//设置无效状态

				rs5.executeSql("update workflow_agent set agenttype = '0',backDate='"+currentDate+"',backTime='"+currentTime+"' where agentid = " + agentid);
				//modify by mackjoe at 2005-09-14 创建权限移至新建流程页面处理
				//收回流转中的代理 //对于老数据不做处理, 当一个代理人又是操作者本身时很难区分 TODO
				if("y".equals(isCountermandRunning)){
					rs6.executeSql("select agentuid from workflow_agentConditionSet where agentid in (" + agentid+")  ");
					//将所有收回

				    while(rs6.next()){
				    	aid=Util.getIntValues(rs6.getString("agentuid"));
					 	String updateSQL = "";
					 	String versionsIds =  WorkflowVersion.getAllVersionStringByWFIDs("" + wfid);
					 	sql= "select * from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='2' and preisremark='1' and takisremark=2 and exists(select 1 from workflow_currentoperator t where t.isremark='1' and t.takisremark = 2 and t.id = workflow_currentoperator.id and t.requestid = workflow_currentoperator.requestid and t.nodeid = workflow_currentoperator.nodeid))) and userid = " + aid + " and agentorbyagentid = " + beaid + " and agenttype = '2' and workflowid in (" + versionsIds + ")";//td2302 xwj
					 	rs1.executeSql(sql);//td2302 xwj
					 	while(rs1.next()){
							int wfcoid = Util.getIntValue(rs1.getString("id"));
					   		String tmprequestid=rs1.getString("requestid");
					   		String tmpisremark=rs1.getString("isremark");
					   		int tmpgroupid=rs1.getInt("groupid");
					   		int currentnodeid = rs1.getInt("nodeid");//流程当前所在节点

					   		int tmpuserid=rs1.getInt("userid");
					  		String tmpusertype=rs1.getString("usertype");
					   		int tmppreisremark=Util.getIntValue(rs1.getString("preisremark"),0);
							int upcoid = 0;
							rs2.execute("select id from workflow_currentoperator where requestid = " + tmprequestid + " and isremark = '2' and userid = " + rs1.getString("agentorbyagentid") + " and agenttype = '1'  and agentorbyagentid = " + tmpuserid+" and usertype=0 and nodeid="+currentnodeid);
							//rs2.execute("select id from workflow_currentoperator where requestid = " + tmprequestid + " and isremark = '2' and userid = " + rs1.getString("agentorbyagentid") + " and agenttype = '1'  and agentorbyagentid = " + tmpuserid+" and usertype=0 and groupid="+tmpgroupid+" and nodeid="+currentnodeid);
							if(rs2.next()){
								upcoid = Util.getIntValue(rs2.getString("id"), 0);
								updateSQL = "update workflow_currentoperator set isremark = '" + tmpisremark + "',preisremark='"+tmppreisremark+"', agenttype ='0', agentorbyagentid = -1  where id = " + upcoid;
								//应该只更新当前节点的代理关系，已经经过的节点不用更新
								rs2.executeSql(updateSQL);  //被代理人重新获得任务
								//失效的代理人删除
								rs2.executeSql("delete workflow_currentoperator where id="+wfcoid);//td2302 xwj
								/**
								*
								*修复当流程代理收回的时候，如果代理的是流程操作者，则会导致收回时，代理人代办已办都找不到该流程
								*
								**/
								String sql1="select userid,nodeid  from workflow_currentoperator where requestid="+tmprequestid+" and userid="+tmpuserid+" group by userid,nodeid";
                                rs2.executeSql(sql1);
                                while(rs2.next()){
                                    String tnodeid=rs2.getString("nodeid");
                                    String temp_uid="";
                                    int a=0;
                                    int b=0;
                                    String sql2="select id,islasttimes from workflow_currentoperator where userid="+tmpuserid+" and nodeid="+tnodeid+" and requestid="+tmprequestid+" ";  
                                    rs2.executeSql(sql2);     
                                    while(rs2.next()){
                                        String cuid=rs2.getString("id");
                                        String tislasttimes=rs2.getString("islasttimes");                                    
                                        if("1".equals(tislasttimes)){
                                            a++;
                                        }else if("0".equals(tislasttimes)){
                                            b++;
                                            temp_uid = cuid;
                                        }
                                    }
                                    if(a == 0 && b > 0){
                                        rs2.executeSql("update workflow_currentoperator set islasttimes=1 where requestid=" +tmprequestid + " and userid=" + tmpuserid + " and id = "+temp_uid);
                                    }
                                }

	                            //流程代理收回操作人需要查看到流程
	                            
	                            rs2.executeSql("select id from workflow_currentoperator where requestid ="+tmprequestid+" and userid="+beaid+" and usertype="+tmpusertype+" order by id desc ");
	                            if(rs2.next()){
	                                String agentcurrid = rs2.getString("id");
	                                rs2.executeSql("update workflow_currentoperator set islasttimes=0 where requestid=" +tmprequestid + " and userid=" + beaid);
	                                rs2.executeSql("update workflow_currentoperator set islasttimes=1 where requestid=" +tmprequestid + " and userid=" + beaid + " and id = " + agentcurrid);
	                            }

								
								rs2.executeSql("update workflow_forward set beforwardid = " + upcoid + " where requestid="+tmprequestid+" and beforwardid="+wfcoid);
								rs2.executeSql("update workflow_forward set forwardid = " + upcoid + " where requestid="+tmprequestid+" and forwardid="+wfcoid);
								
								//判断是否有意见征询，有且有未提交的则
								//rs2.executeQuery("select id from workflow_currentoperator a where exists (select 1 from workflow_forward b  where b.forwardid = ? and a.id = b.beforwardid) and a.isremark = '1' and  a.takisremark = '0'",upcoid);
								rs2.executeQuery("select id from workflow_currentoperator a where exists (select 1 from workflow_forward b  where  a.id = b.beforwardid) and a.isremark = '1' and  a.takisremark = '2' AND requestid= "+tmprequestid);
								if(rs2.next()){
								    //rs2.executeUpdate("update workflow_currentoperator set takisremark = '-2' where id = ?",upcoid);
									rs2.executeUpdate("update workflow_currentoperator set takisremark = '-2' where not exists(select 1 from workflow_currentoperator t where t.isremark = '1' and t.takisremark = 2 and t.requestid = workflow_currentoperator.requestid and t.nodeid = workflow_currentoperator.nodeid) and id = ?",upcoid);
								}
								
								//判断当前节点是否意见征询，并判断是否全部提交，若全部提交则修改该节点takisremark = 0
								//rs2.executeUpdate("update workflow_currentoperator a set takisremark = '0' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where a.id = b.forwardid  and c.isremark = '1') and a.takisremark = '-2' and a.id = ?",upcoid);
								//rs2.writeLog("update workflow_currentoperator set takisremark = '0' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where workflow_currentoperator.id = b.forwardid  and c.isremark = '1') and takisremark = '-2' and id = "+upcoid);
								//rs2.executeUpdate("update workflow_currentoperator set takisremark = '2' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where workflow_currentoperator.id = b.forwardid  and c.isremark = '1') and takisremark = '-2' and id = ?",upcoid);
								rs2.executeUpdate("update workflow_currentoperator a set takisremark = '2' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where a.id = b.forwardid  and (c.isremark = '1' or (c.isremark='2' and c.preisremark='1' and c.takisremark=2 and exists(select 1 from workflow_currentoperator t where t.isremark='1' and t.takisremark = 2 and t.requestid = c.requestid and t.nodeid = c.nodeid)))) and a.takisremark = '-2' and a.id = ?",upcoid);
								
								
							}

							//单条收回成功后，在这个地方来处理未操作流程的代理人的审批意见。 //当前节点
							//取消代理，更新被代理人未操作   2017-02-24
							String zdlsql00 = "select max(LOGID) logid from workflow_requestLog where requestid = " + tmprequestid +" and destnodeid= "+currentnodeid;
							rs8.executeSql(zdlsql00);
                            wfAgentCondition.wfCancleOperatorAgent(rs8,Integer.valueOf(tmprequestid),currentnodeid,tmpusertype, beaid,true);
							

					   		PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,10,tmpusertype,Util.getIntValue(tmprequestid));
					   		PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,0,tmpusertype,Util.getIntValue(tmprequestid));
					   		//add by fanggsh 20060519 TD4346 begin 流程代理收回导致操作人查不到流程
					   		rs3.executeSql("select id from workflow_currentoperator where isremark in ('0','1','5','7','8','9') and requestid ="+tmprequestid+" and userid="+tmpuserid+" and usertype="+usertype+" order by id desc ");
					   		if(rs3.next()){
					       		rs2.executeSql("update workflow_currentoperator set islasttimes=1 where requestid=" +tmprequestid + " and userid=" + tmpuserid + " and id = " + rs3.getString("id"));
					   		}
					   		//add by fanggsh 20060519 TD4346 end
		
					   		//回收代理人文档权限

					   		rs2.executeSql("select distinct docid,sharelevel from Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
					   		boolean hasrow=false;
					   		ArrayList docslist=new ArrayList();
					   		ArrayList sharlevellist=new ArrayList();
					   		while(rs2.next()){
					       		hasrow=true;
					       		docslist.add(rs2.getString("docid"));
					       		sharlevellist.add(rs2.getString("sharelevel"));
					   		}
					   		if(hasrow){
					       		rs2.executeSql("delete Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
					   		}
					   		for(int j=0;j<docslist.size();j++){
					       		rs3.executeSql("select Max(sharelevel) sharelevel from Workflow_DocShareInfo where docid="+docslist.get(j)+" and userid="+aid);
					       		if(rs3.next()){
					          		int sharelevel=Util.getIntValue(rs3.getString("sharelevel"),0);
					          		if(sharelevel>0){
					              		rs.executeSql("update DocShare set sharelevel="+sharelevel+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid+" and sharelevel>"+sharelevel);
					          		}else{
					              		rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
					          		}
					       		}else{
					          		rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
					       		}
					       		//重新赋予被代理人文档权限
					       		rs.executeSql("update DocShare set sharelevel="+sharlevellist.get(j)+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+beaid);
					       		DocViewer.setDocShareByDoc((String)docslist.get(j));
					   		}   
					   		//end by mackjoe
					  	}
				    }
				}
				//通过默认的工作流提醒 
				//TODO
			}catch(Exception e){
				flag = false;
			}
		}
		if(flag){
			if(!"1".equals(isformmobile)){
			  response.sendRedirect("/workflow/request/wfAgentGetBackConfirm.jsp?agented="+agented+"&agentFlage="+agentFlag+"&infoKey=3&isclose=1");
			  return;  //xwj for td3218 20051201
		    }else{
			    %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(78,user.getLanguage())%>");
					        parent.location.href="/mobile/plugin/1/agent/agentlist.jsp";
					  </script>
				    <%
			}
		}else{
		  	if(!"1".equals(isformmobile)){
			  response.sendRedirect("/workflow/request/wfAgentGetBackConfirm.jsp?agented="+agented+"&agentFlage="+agentFlag+"&infoKey=4&isclose=1");
			  return;  //xwj for td3218 20051201
			}else{
			     %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(79,user.getLanguage())%>");
					        parent.location.href="/mobile/plugin/1/agent/agentlist.jsp";
					  </script>
				    <%
			}
		}
	}
	//全部收回逻辑
	else if(agenttype.equals("pt"))
	{
		isCountermandRunning=request.getParameter("isCountermandRunning");
		beaid=request.getParameter("beaid");
		aid=request.getParameter("aid");
		try{
			//收回流转中的代理 对于老数据不做处理, 当一个代理人又是操作者本身时很难区分
			if("y".equals(isCountermandRunning)){
				rs6.executeSql("select agentuid from workflow_agentConditionSet where bagentuid='"+beaid+"'  and  agentuid='"+aid+"' and agenttype=1 ");
				//将所有收回

				 while(rs6.next()){
			  		aid=Util.getIntValues(rs6.getString("agentuid"));
		 			String updateSQL = "";
		 			rs1.executeSql("select * from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='2' and preisremark='1' and takisremark=2 and exists(select 1 from workflow_currentoperator t where t.isremark='1' and t.takisremark = 2 and t.id = workflow_currentoperator.id and t.requestid = workflow_currentoperator.requestid and t.nodeid = workflow_currentoperator.nodeid)))  and userid = " + aid + " and agentorbyagentid = " + beaid + " and agenttype = '2'");//td2302 xwj
				 		while(rs1.next()){
				   			int wfcoid = Util.getIntValue(rs1.getString("id"));
				   			String tmprequestid=rs1.getString("requestid");
				   			String tmpisremark=rs1.getString("isremark");
				   			int tmpgroupid=rs1.getInt("groupid");
				   			int currentnodeid = rs1.getInt("nodeid");//流程当前所在节点

				   			int tmpuserid=rs1.getInt("userid");
				   			String tmpusertype=rs1.getString("usertype");
				   			int tmppreisremark=Util.getIntValue(rs1.getString("preisremark"),0);
							int upcoid = 0;
							//rs2.execute("select id from workflow_currentoperator where requestid = " + tmprequestid + " and isremark = '2' and userid = " + rs1.getString("agentorbyagentid") + " and agenttype = '1' and agentorbyagentid = " + tmpuserid +" and usertype=0 and groupid="+tmpgroupid+" and nodeid="+currentnodeid);
							rs2.execute("select id from workflow_currentoperator where requestid = " + tmprequestid + " and isremark = '2' and userid = " + rs1.getString("agentorbyagentid") + " and agenttype = '1' and agentorbyagentid = " + tmpuserid +" and usertype=0 and nodeid="+currentnodeid);
							if(rs2.next()){
								upcoid = Util.getIntValue(rs2.getString("id"));
								updateSQL = "update workflow_currentoperator set isremark = '" + tmpisremark + "',preisremark='"+tmppreisremark+"', agenttype ='0', agentorbyagentid = -1  where id="+upcoid;
								//应该只更新当前节点的代理关系，已经经过的节点不用更新
								rs2.executeSql(updateSQL);  //被代理人重新获得任务
								//失效的代理人删除
								rs2.executeSql("delete workflow_currentoperator where id="+wfcoid);//td2302 xwj
				                //QC152344,防止代理抄送引起的问题
				                wfAgentCondition.wfCurrentOperatorAgent(rs2,Integer.valueOf(tmprequestid),currentnodeid, tmpusertype, beaid,true);
								
								rs2.executeSql("update workflow_forward set beforwardid = " + upcoid + " where requestid="+tmprequestid+" and beforwardid="+wfcoid);
								rs2.executeSql("update workflow_forward set forwardid = " + upcoid + " where requestid="+tmprequestid+" and forwardid="+wfcoid);
								
								rs2.executeQuery("select id from workflow_currentoperator a where exists (select 1 from workflow_forward b  where  a.id = b.beforwardid) and a.isremark = '1' and  a.takisremark = '2' AND requestid= "+tmprequestid);
								
								if(rs2.next()){
								    //rs2.executeUpdate("update workflow_currentoperator set takisremark = '-2' where id = ?",upcoid);
								    rs2.executeUpdate("update workflow_currentoperator set takisremark = '-2' where not exists(select 1 from workflow_currentoperator t where t.isremark = '1' and t.takisremark = 2 and t.requestid = workflow_currentoperator.requestid and t.nodeid = workflow_currentoperator.nodeid) and id = ?",upcoid);
								}
								
								//判断当前节点是否意见征询，并判断是否全部提交，若全部提交则修改该节点takisremark = 0
								//rs2.executeUpdate("update workflow_currentoperator a set takisremark = '0' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where a.id = b.forwardid  and c.isremark = '1') and a.takisremark = '-2' and a.id = ?",upcoid);
								//rs2.writeLog("update workflow_currentoperator set takisremark = '0' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where workflow_currentoperator.id = b.forwardid  and c.isremark = '1') and takisremark = '-2' and id = "+upcoid);
								//rs2.executeUpdate("update workflow_currentoperator set takisremark = '2' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where workflow_currentoperator.id = b.forwardid  and c.isremark = '1') and takisremark = '-2' and id = ?",upcoid);
								rs2.executeUpdate("update workflow_currentoperator a set takisremark = '2' where not exists (select 1 from workflow_forward b left join workflow_currentoperator c on b.beforwardid = c.id where a.id = b.forwardid  and (c.isremark = '1' or (c.isremark='2' and c.preisremark='1' and c.takisremark=2 and exists(select 1 from workflow_currentoperator t where t.isremark='1' and t.takisremark = 2 and t.requestid = c.requestid and t.nodeid = c.nodeid)))) and a.takisremark = '-2' and a.id = ?",upcoid);
							}
							//单条收回成功后，在这个地方来处理未操作流程的代理人的审批意见。 //当前节点
							//取消代理，更新被代理人未操作   2017-02-24
                            String zdlsql00 = "select max(LOGID) logid from workflow_requestLog where requestid = " + tmprequestid +" and destnodeid= "+currentnodeid;
                            rs8.executeSql(zdlsql00);
                            wfAgentCondition.wfCancleOperatorAgent(rs8,Integer.valueOf(tmprequestid),currentnodeid,tmpusertype, beaid,true);
                           
					   		PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,10,tmpusertype,Util.getIntValue(tmprequestid));
					   		PoppupRemindInfoUtil.updatePoppupRemindInfo(tmpuserid,0,tmpusertype,Util.getIntValue(tmprequestid));
					   		//add by fanggsh 20060519 TD4346 begin 流程代理收回导致操作人查不到流程
					   		rs3.executeSql("select id from workflow_currentoperator where requestid ="+tmprequestid+" and userid="+tmpuserid+" and usertype="+usertype+" order by id desc ");
					   		if(rs3.next()){
					       		rs2.executeSql("update workflow_currentoperator set islasttimes=1 where requestid=" +tmprequestid + " and userid=" + tmpuserid + " and id = " + rs3.getString("id"));
					   		}
					   		//add by fanggsh 20060519 TD4346 end
			
					   		//回收代理人文档权限

					   		rs2.executeSql("select distinct docid,sharelevel from Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
					   		boolean hasrow=false;
					   		ArrayList docslist=new ArrayList();
					   		ArrayList sharlevellist=new ArrayList();
					   		while(rs2.next()){
					       		hasrow=true;
					       		docslist.add(rs2.getString("docid"));
					       		sharlevellist.add(rs2.getString("sharelevel"));
					   		}
					   		if(hasrow){
					       		rs2.executeSql("delete Workflow_DocShareInfo where requestid="+tmprequestid+" and userid="+aid+" and beAgentid="+beaid);
					   		}
					   		for(int j=0;j<docslist.size();j++){
					       		rs3.executeSql("select Max(sharelevel) sharelevel from Workflow_DocShareInfo where docid="+docslist.get(j)+" and userid="+aid);
					       		if(rs3.next()){
					          		int sharelevel=Util.getIntValue(rs3.getString("sharelevel"),0);
					          		if(sharelevel>0){
					              		rs.executeSql("update DocShare set sharelevel="+sharelevel+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid+" and sharelevel>"+sharelevel);
					          		}else{
					              		rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
					          		}
					       		}else{
					          		rs.executeSql("delete DocShare where sharesource=1 and docid="+docslist.get(j)+" and userid="+aid);
					       		}
					       		//重新赋予被代理人文档权限
					       		rs.executeSql("update DocShare set sharelevel="+sharlevellist.get(j)+" where sharesource=1 and docid="+docslist.get(j)+" and userid="+beaid);
					       		DocViewer.setDocShareByDoc((String)docslist.get(j));
					   		}   
					   		//end by mackjoe
				  		}
		 		}
			}
			 
			//设置无效状态

		 wfAgentCondition.SetbackAgent(""+beaid,""+aid);
			
		//通过默认的工作流提醒 
		//TODO
		}catch(Exception e){
			flag = false;
		}
		if(flag){
		  if(!"1".equals(isformmobile)){
			 response.sendRedirect("/workflow/request/wfAgentGetBackConfirm.jsp?agented="+agented+"&agentFlage="+agentFlag+"&infoKey=3&isclose=1");
			 return;  //xwj for td3218 20051201
		  }else{
              %>
				  <script>
					     parent.alert("<%=SystemEnv.getHtmlNoteName(78,user.getLanguage())%>");
					      parent.location.href="/mobile/plugin/1/agent/agentlist.jsp";
			      </script>
			<%  
			}
		}else{
		  if(!"1".equals(isformmobile)){
			response.sendRedirect("/workflow/request/wfAgentGetBackConfirm.jsp?agented="+agented+"&agentFlage="+agentFlag+"&infoKey=4&isclose=1");
			return;  //xwj for td3218 20051201
		  }else{
				%>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(79,user.getLanguage())%>");
					        parent.location.href="/mobile/plugin/1/agent/agentlist.jsp";
					  </script>
				    <%

			}
		}
	}
}
//e8 改造新增流程代理逻辑
else if(method.equals("addAgent")){
String beagenterIdAll=Util.fromScreen(request.getParameter("beagenterId"),user.getLanguage());
//防篡改
List<String> userRange = new ArrayList<String>();
userRange.add(user.getUID()+"");
rs.executeQuery("select * from HrmUserSetting where resourceId = "+user.getUID());
if(rs.next() && "1".equals(rs.getString("belongtoshow"))){
	String[] arr = Util.null2String(user.getBelongtoids()).split(",");
	for(String userstr : arr){
		userRange.add(userstr);
	}
}
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
if(!"".equals(beagenterIdAll)){
arr2 = beagenterIdAll.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
for(int k=0;k<userlist.size();k++){
	int j=k+1;
	  int beagenterId = Util.getIntValue((String)userlist.get(k),0);
	if(!HrmUserVarify.checkUserRight("WorkflowAgent:All", user) && userRange.indexOf(beagenterId+"") == -1)
		continue;	//防篡改
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    String agentrange = Util.fromScreen(request.getParameter("agentrange"),user.getLanguage());
    String rangetype = Util.fromScreen(request.getParameter("rangetype"),user.getLanguage());
    int isCreateAgenter=Util.getIntValue(request.getParameter("isCreateAgenter"),0);
    int isProxyDeal=Util.getIntValue(request.getParameter("isProxyDeal"),0);
    String overlapAgenttype = Util.fromScreen(request.getParameter("overlapAgenttype"),user.getLanguage());
    String overlapagentstrid = Util.fromScreen(request.getParameter("overlapagentstrid"),user.getLanguage());
    String source=Util.null2String(request.getParameter("source"));//来源【由于目前代理添加业务统一整合到java文件，方便其他地方重用。不同来源返回地址不一样】

    //标示【流程代理时，有重复范围记录特殊处理 1、从新保存的代理设置中去除重复设置内容 2、以新保存的代理设置替换已有重复的代理设置】
	overlapagentstrid = "'"+StringUtils.replace(overlapagentstrid, ",", "','")+"'";
    if(!overlapAgenttype.equals("")){
    	if(overlapAgenttype.equals("1")){//从新保存的代理设置中去除重复设置内容
        String agentretu=wfAgentCondition.agentadd(""+beagenterId,""+agenterId,beginDate,beginTime,endDate,endTime,agentrange,rangetype,""+isCreateAgenter,""+isProxyDeal,""+isPendThing,usertype,user,"1","");  
    	if(agentretu.equals("1")){
			    if(!"1".equals(isformmobile)){
    	    	    response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=1");
    	            return;  //xwj for td3218 20051201
				 }else{
					  %>
					<script>
						parent.alert("<%=SystemEnv.getHtmlNoteName(76,user.getLanguage())%>");
						parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
				    </script>
					<%
				}
    	     }else if(agentretu.equals("2")){//流程不能重复被代理，请收回后再代理！
				 if(!"1".equals(isformmobile)){
    	    	 	response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=5");
    	            return;
				 }else{
				 %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlLabelName(26802,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				<%
				}
    	     }else if(agentretu.equals("3")){//代理失败出现异常
			   if(!"1".equals(isformmobile)){
    	    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=2");
    		     return;  //xwj for td3218 20051201
			   }else{
			   %>
				  <script>
					   parent.alert("<%=SystemEnv.getHtmlNoteName(77,user.getLanguage())%>");
					   parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
			     </script>
			 <%
		      }
    		 }else if(j==userlist.size()){//代理成功
    			// System.out.println("--sucess---------");     
    			 //response.sendRedirect("/workflow/request/wfAgentCDBackConfirm1.jsp?infoKey=1&isclose=1");
    			// return;  //xwj for td3218 20051201
				 if(!"1".equals(isformmobile)){
    				%> 
    	    	       <script language=javascript >
    				    try
    				    {
    				    	var dialog =parent.getDialog(window);
    						var parentWin = parent.getParentWindow(window);
    						parentWin.location.href="/workflow/request/wfAgentAdd.jsp?isclose=1";
    						//parentWin.closeDialog();
    						dialog.close();
    					}
    					catch(e)
    					{
    					}
    					</script>
    	    		<% 
				    }else{
                   %>
				      <script>
					        parent.alert("设置代理成功!");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				   <%

				}
    			
    		 }
    	 }else{
    	 
    		 //以新保存的代理设置替换已有重复的代理设置
    		 //首先将重复的代理给收回来，然后再重新代理{指收回重复}
			 
			 String strSubClause="  and (" + Util.getSubINClause(overlapagentstrid, "agentid", "IN") + ") " ;
    		 rs4.executeSql("select workflowid,agentid,bagentuid from workflow_agentConditionSet where agenttype='1' "+strSubClause);
    		 while(rs4.next()){
    			 String workflowidold=Util.null2String(rs4.getString("workflowid"));
    			 String agentidold=Util.null2String(rs4.getString("agentid"));
    		 	 String bagentuidold=Util.null2String(rs4.getString("bagentuid"));
    		 	 wfAgentCondition.Agent_to_recover(bagentuidold,workflowidold,agentidold,"agentrecoverold",""+agenterId);//收回代理
    		 }	
    		 
    		 //添加代理
			 String agentretu=wfAgentCondition.agentadd(""+beagenterId,""+agenterId,beginDate,beginTime,endDate,endTime,agentrange,rangetype,""+isCreateAgenter,""+isProxyDeal,""+isPendThing,usertype,user,"2","");
			 
			  if(agentretu.equals("1")){
				 if(!"1".equals(isformmobile)){
			    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=1");
			         return;  //xwj for td3218 20051201
			  }else{
				    %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(76,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				    <%
				  }
			  }else if(agentretu.equals("2")){//流程不能重复被代理，请收回后再代理！
				  if(!"1".equals(isformmobile)){
			    	 	response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=5");
			            return;
				  }else{
				     %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlLabelName(26802,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				    <%
				  }
			  }else if(agentretu.equals("3")){//代理失败出现异常
				  if(!"1".equals(isformmobile)){
			    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=2");
	    		     return;  //xwj for td3218 20051201
				 }else{
				    %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(77,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				   <%
				 }
	    	  }else if(j==userlist.size()){
    			 //	response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=1&isclose=1");
    			// return;  //xwj for td3218 20051201
				  if(!"1".equals(isformmobile)){
	    			%> 
	     	       <script language=javascript >
	 			    try
	 			    {
	 			    	var dialog =parent.getDialog(window);
	 					var parentWin = parent.getParentWindow(window);
	 					parentWin.location.href="/workflow/request/wfAgentAdd.jsp?isclose=1";
	 					//parentWin.closeDialog();
	 					dialog.close();
	 				}
	 				catch(e)
	 				{
	 				}
	 				</script>
	     			 
	     		<% 
					}else{
                 %>
				      <script>
					        parent.alert("设置代理成功!");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				   <%
				}
    			
	    	 }
    	 }
    }else{
    	//添加代理设置
    	String agentretu=wfAgentCondition.agentadd(""+beagenterId,""+agenterId,beginDate,beginTime,endDate,endTime,agentrange,rangetype,""+isCreateAgenter,""+isProxyDeal,""+isPendThing,usertype,user,"3","");
			
	     if(agentretu.equals("1")){
			  if(!"1".equals(isformmobile)){
	    	   response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=1");
	           return;  //xwj for td3218 20051201
			 }else{
				     %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(76,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				    <%
			 }
	     }else if(agentretu.equals("2")){//流程不能重复被代理，请收回后再代理！
			if(!"1".equals(isformmobile)){
	    	 	response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=5");
	            return;
		    }else{
				   %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlLabelName(26802,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				    <%
			 }
	     }else if(agentretu.equals("3")){//代理失败出现异常
			if(!"1".equals(isformmobile)){
	    	 response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=2");
		     return;  //xwj for td3218 20051201
			}else{
				    %>
				      <script>
					        parent.alert("<%=SystemEnv.getHtmlNoteName(77,user.getLanguage())%>");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				    <%
			 }
		 }else  if(j==userlist.size()){//代理成功
			if(!"1".equals(isformmobile)){
			 response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=1&isclose=1");
    			 return;  //xwj for td3218 20051201	
			}else{
			     %>
				      <script>
					        parent.alert("设置代理成功!");
					        parent.location.href=("/mobile/plugin/1/agent/agentlist.jsp");
					  </script>
				<%  
			 }
		 }	 
    }
} 
}else if(method.equals("editAgent")){//编辑代理日期时间
    int agentid = Util.getIntValue(request.getParameter("agentid"),0); 
    int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
    int agenttype = Util.getIntValue(request.getParameter("agenttype"),0);
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    String workflowid = Util.fromScreen(request.getParameter("workflowid"),user.getLanguage());
    String overlapAgenttype = Util.fromScreen(request.getParameter("overlapAgenttype"),user.getLanguage());
    String overlapagentstrid = Util.fromScreen(request.getParameter("overlapagentstrid"),user.getLanguage());
    overlapagentstrid = "'"+StringUtils.replace(overlapagentstrid, ",", "','")+"'";
   
    try{
    	  if(!overlapAgenttype.equals("")){
   		  	   if(overlapAgenttype.equals("1")){//从新保存的代理设置中去除重复设置内容
    		          //编辑代理日期 既然之前已经存在，本次修改日期之后过滤掉哪么就可以不用处理。编辑本身就是单条的流程
    		          response.sendRedirect("wfAgentEditCondition.jsp?infoKey=3&agentid="+agentid);
    		          return;  //xwj for td3218 20051201
    		 	}else{
    		 		if(agenttype==0){
    		 			wfAgentCondition.SetUpdateagent(beginDate,beginTime,endDate,endTime,""+agentid,overlapagentstrid,""+beagenterId,workflowid,user);
    		 		    //response.sendRedirect("wfAgentEditCondition.jsp?infoKey=4&agentid="+agentid);
    		 		}else{
	   		    		 //以新保存的代理设置替换已有重复的代理设置
	   		    		 //首先将重复的代理给收回来，然后再重新代理
	   		    		 rs4.executeSql("select workflowid,agentid,bagentuid from workflow_agentConditionSet where agentid in("+overlapagentstrid+") and agenttype='1' ");
	   		    		 while(rs4.next()){
	   		    			 String workflowidold=Util.null2String(rs4.getString("workflowid"));
	   		    			 String agentidold=Util.null2String(rs4.getString("agentid"));
	   		    		 	 String bagentuidold=Util.null2String(rs4.getString("bagentuid"));
	   		    		     wfAgentCondition.Agent_to_recover(bagentuidold,workflowidold,agentidold,"editAgent_cf",""+agenterId);//收回代理
	   		    		 }	
	   		    		 //根据新的代理日期重新代理
	   	    	         wfAgentCondition.again_agent_wf(""+beagenterId,workflowid,beginDate,beginTime,endDate,endTime,user,"editAgent",""+agentid);
		 		    
    		 		}  
    		 	}
    	  } else{
    	    	String retustr=wfAgentCondition.getAgentType(""+agentid);
    	    	if(retustr.equals("1")){//代理中[代理中的流程，需要将代理中的先收回 然后再重新代理一下]
    	    		//收回代理操作	
    	         	wfAgentCondition.Agent_to_recover(""+beagenterId,workflowid,""+agentid,"editrecover",""+agenterId);
    	    		//根据新的代理日期重新代理
    	             wfAgentCondition.again_agent_wf(""+beagenterId,workflowid,beginDate,beginTime,endDate,endTime,user,"editAgentNew",""+agentid);
    	    	
    	    	}else {//2已结束

    	    		 
    	    		wfAgentCondition.SetWorkflowAgent(""+agentid,beginDate,beginTime,endDate,endTime,""+beagenterId,""+workflowid,user);
    	    		//收回代理操作	
    	    	}
    	  }
    }
    catch(Exception e){
        flag = false;
    }
    
    if(flag){
    	if(!overlapAgenttype.equals("")){
    		%>
     	 <script language=javascript >
		 try
		    {
		    	var dialog =parent.getDialog(window);
				var parentWin = parent.getParentWindow(window);
				parentWin.location.href="/workflow/request/wfAgentEditCondition.jsp?infoKey=4";
				//parentWin.closeDialog();
				dialog.close();
			}
			catch(e)
			{
			}
		</script>
    		<%
    	}else{
    		 response.sendRedirect("wfAgentEditCondition.jsp?infoKey=1");
    	     return;  //xwj for td3218 20051201
    	}
     
    }else{
        response.sendRedirect("wfAgentEditCondition.jsp?infoKey=2");
        return;  //xwj for td3218 20051201
    }
}
 
%>


<%! //老数据

public boolean isOldData(String requestid){
RecordSet RecordSetOld = new RecordSet();
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}
return isOldWf_;
}

%>