<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<%
    
    String ids = Util.null2String(request.getParameter("ids"));
    int rownum = Util.getIntValue(request.getParameter("weaverTableRows"),0);
    String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
    String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
    user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
    //int userid=user.getUID();     
    String operator=String.valueOf(user.getUID());
    String requestid = "";
    String wfid = "";
    String currentnodeid = "";
    String permissiontype = "" ;
    int iscanread = 0;
    String logintype = user.getLogintype();  
    int usertype = 0;
    if(logintype.equals("1")) usertype = 0;
    if(logintype.equals("2")) usertype = 1;

    StringTokenizer stk = new StringTokenizer(ids,",");
    while(stk.hasMoreTokens()){
        requestid = stk.nextToken();
        if(!requestid.trim().equals("")){
            rs.executeSql("select workflowid,currentnodeid from workflow_requestbase where requestid = " + requestid);
            if(rs.next()){
                wfid=rs.getString("workflowid");
                //currentnodeid=rs.getString("currentnodeid");
            }
            
            /////////////////////////////////////////////
            currentnodeid = String.valueOf(wfLinkInfo.getCurrentNodeid(Integer.parseInt(requestid),Integer.parseInt(operator),Util.getIntValue(logintype,1)));
            String nodetype = wfLinkInfo.getNodeType(Integer.parseInt(currentnodeid));
            String currentnodetype = "";
            RecordSet.executeSql("select currentnodetype from workflow_Requestbase where requestid = " + requestid);
            while(RecordSet.next()) {
                currentnodetype = Util.null2String(RecordSet.getString("currentnodetype"));
                if(nodetype.equals("")) nodetype = currentnodetype;
            }
            /////////////////////////////////////////////
            RecordSet.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid,(CASE WHEN isremark=9 THEN '7.5' ELSE isremark END) orderisremark from workflow_currentoperator where requestid="+requestid+" and userid="+operator+" and usertype="+usertype+" order by orderisremark,id ");
            while(RecordSet.next()) {
                String isremark = Util.null2String(RecordSet.getString("isremark")) ;
                String tmpnodeid = Util.null2String(RecordSet.getString("nodeid"));
                if( isremark.equals("1")||isremark.equals("5") || isremark.equals("7")|| isremark.equals("9") ||(isremark.equals("0")  && !nodetype.equals("3")) ) {
                    currentnodeid=tmpnodeid;
                    break;
                }
            }
            /////////////////////////////////////////////
			int currentid=-1;
			String currentsql = " select id from workflow_currentoperator where requestid="+requestid+" AND nodeid="+currentnodeid+" AND userid ="+operator;
			rs1.executeSql(currentsql);
			if(rs1.next()){
				currentid = rs1.getInt("id");
			}else{
				//如果是监控人添加，if条件就不满足，取当前节点操作者对应currentid
				currentsql = " select id from workflow_currentoperator where requestid="+requestid+" AND nodeid="+currentnodeid;
				rs1.executeSql(currentsql);
				if(rs1.next()){
					currentid = rs1.getInt("id");
				}
			}


            for(int i=0; i<rownum; i++){
                String sharetype = request.getParameter("sharetype_"+i);
                ///////////////////////
                boolean flag = false;
                String sql = "";
                
                ArrayList relatedids = new ArrayList();
                int rt_rolelevel = 0 ;
                int rt_showlevel = 0 ;
                int rt_showlevel2 = 0 ;
                
                permissiontype=Util.null2String(request.getParameter("permissiontype_"+i));
                iscanread = Util.getIntValue(request.getParameter("iscanread_"+i), 0); 
                if("1".equals(permissiontype)){
                    String departmentid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid_"+i)),",");
                    int deptlevel = Util.getIntValue(request.getParameter("seclevel_"+i), 0); 
                    int deptlevelMax = Util.getIntValue(request.getParameter("seclevelMax_"+i), 100);
                    
                    rt_showlevel = deptlevel ;
                    rt_showlevel2 = deptlevelMax ;
                    
                    if(departmentid.length>0){
                        for(String did : departmentid){
                        	relatedids.add(did);
                            sql = "select wfid,requestid,departmentid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and departmentid = "+did+ " and deptlevel = " + deptlevel + " and deptlevelMax = " + deptlevelMax+" and currentid="+currentid;
                            RecordSet.executeSql(sql);
                            if(!RecordSet.next())                 {
                                sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,departmentid,deptlevel,deptlevelMax,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+did+","+deptlevel+","+deptlevelMax+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                                flag = RecordSet.executeSql(sql);
                            }
                        }
                    }
                }  else if("2".equals(permissiontype)){
                    String roleid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("roleid_"+i)),",");
                    int rolelevel = Util.getIntValue(request.getParameter("rolelevel_"+i), 0);
                    int seclevel = Util.getIntValue(request.getParameter("seclevel_"+i), 0); 
                    int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax_"+i), 100);
                    
                    rt_rolelevel = rolelevel ;
                    rt_showlevel = seclevel ;
                    rt_showlevel2 = seclevelMax ;
                    
                    if(roleid.length>0){
                        for(String did : roleid){
                        	relatedids.add(did);
                            sql = "select wfid,roleid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and roleid = "+did+ " and roleseclevel = " + seclevel + " and roleseclevelMax = " + seclevelMax +" and rolelevel = "+rolelevel+" and currentid="+currentid;
                            RecordSet.executeSql(sql);
                            if(!RecordSet.next())                 {
                                sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,roleid,roleseclevel,roleseclevelMax,rolelevel,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+did+","+seclevel+","+seclevelMax+","+rolelevel+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                                flag = RecordSet.executeSql(sql);
                            }
                        }
                    }
                }  else if("3".equals(permissiontype)){
                    int seclevel = Util.getIntValue(request.getParameter("seclevel_"+i), 0); 
                    int seclevelMax = Util.getIntValue(request.getParameter("seclevelMax_"+i), 100);
                    
                    rt_showlevel = seclevel ;
                    rt_showlevel2 = seclevelMax ;
                    
                    sql = "select wfid,permissiontype from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and permissiontype="+permissiontype+ " and seclevel = " + seclevel + " and seclevelMax = " + seclevelMax+" and currentid="+currentid;
                    RecordSet.executeSql(sql);
                    if(!RecordSet.next())                 {
                        sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,seclevel,seclevelMax,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+seclevel+","+seclevelMax+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                        RecordSet.executeSql(sql);
                    }
                }   else if("5".equals(permissiontype)){
                    String userid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("userid_"+i)),",");
                    if(userid.length>0){
                          for(String uid : userid){
                        	  relatedids.add(uid);
                               sql = "select wfid,userid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and userid = "+uid +" and currentid="+currentid;
                              RecordSet.executeSql(sql)   ;
                              if(!RecordSet.next())                 {
                                  sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,userid,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+uid+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                                  RecordSet.executeSql(sql);
                              }
                          }
                    }
                } else if("6".equals(permissiontype)){
                    String subcompanyids[]  = Util.TokenizerString2(Util.null2String(request.getParameter("subids_"+i)),",");
                    int sublevel = Util.getIntValue(request.getParameter("seclevel_"+i), 0); 
                    int sublevelMax = Util.getIntValue(request.getParameter("seclevelMax_"+i), 100);
                    
                    rt_showlevel = sublevel ;
                    rt_showlevel2 = sublevelMax ;
                    
                    if(subcompanyids.length>0){
                        for(String sid : subcompanyids){
                        	relatedids.add(sid);
                            sql = "select wfid,subcompanyid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and subcompanyid = "+sid+ " and sublevel = " + sublevel + " and sublevelMax = " + sublevelMax+" and currentid="+currentid;
                            RecordSet.executeSql(sql);
                            if(!RecordSet.next())                 {
                                sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,subcompanyid,sublevel,sublevelMax,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+sid+","+sublevel+","+sublevelMax+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
                                flag = RecordSet.executeSql(sql);
                            }
                        }
                    }
                }else if("7".equals(permissiontype)){
                    String jobid[]  = Util.TokenizerString2(Util.null2String(request.getParameter("jobid_"+i)),",");
                    int joblevel = Util.getIntValue(request.getParameter("joblevel_"+i), 0); 
                    String jobobj = Util.null2String(request.getParameter("jobobj_"+i));
                    int jobobjid = -1;
                    rt_showlevel = joblevel ;
                    //rt_showlevel2 = sublevelMax ;
                    
                    if(jobid.length>0){
                        for(String sid : jobid){
                        	relatedids.add(sid);
                        	
                        	String[] jobobjids = Util.splitString(jobobj,",");
	    					for(int s=0;s<jobobjids.length;s++){
	    						jobobjid = Util.getIntValue(jobobjids[s], -1);
		    					sql = "select wfid,subcompanyid from Workflow_SharedScope where wfid ="+wfid +" and requestid = "+requestid+" and iscanread = "+iscanread+" and operator = '"+operator+"' and currentnodeid = "+currentnodeid+" and jobid = "+sid+ " and joblevel = " + joblevel + " and jobobjid = " + jobobjid +" and currentid= "+currentid;
	                            RecordSet.executeSql(sql);
	                            if(!RecordSet.next()){
	                                sql = " insert into Workflow_SharedScope (wfid,requestid,permissiontype,jobid,joblevel,jobobjid,iscanread,operator,currentnodeid,currentid) values ("+wfid+","+requestid+","+permissiontype+","+sid+","+joblevel+","+jobobjid+","+iscanread+",'"+operator+"',"+currentnodeid+","+currentid+")"   ;
	                                flag = RecordSet.executeSql(sql);
	                            }
	    					}
                        }
                    }
                }
                ///////////////////////
              //流程共享赋权
              new weaver.workflow.request.RequestAddShareMode().getWfShareUserid(Util.getIntValue(requestid),wfid,permissiontype,relatedids,rt_rolelevel,rt_showlevel,rt_showlevel2);
            }
        }
    }
    response.sendRedirect("AddWorkflowBatchShared.jsp?isclose=1&ids="+ids);
%>
