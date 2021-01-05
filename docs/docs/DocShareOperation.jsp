
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.DocComInfo" %>
<%@ page import="weaver.docs.docs.DocInfo" %>
<%@ page import="weaver.system.ThreadForAllForNew" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="page"/>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocApproveWfManager" class="weaver.docs.docs.DocApproveWfManager" scope="page" />
<jsp:useBean id="AppDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page"/>
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>
<jsp:useBean id="SendToAllForNew" class="weaver.system.SendToAllForNew" scope="page"/>
<%@ page import="weaver.docs.networkdisk.server.PublishNetWorkFile" %>
<%
String docsubject= Util.null2String(request.getParameter("docsubject"));


boolean blnOsp = "true".equals(request.getParameter("blnOsp"));  //用于存放共享提醒对话框的设置

char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String shareIds = Util.null2String(request.getParameter("shareIds"));
String docid = Util.null2String(request.getParameter("docid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String seclevelmax = Util.null2String(request.getParameter("seclevelmax"));
String includesub = Util.null2String(request.getParameter("includesub"));
String orgid = Util.null2String(request.getParameter("orgid"));
String allmanagers = Util.null2String(request.getParameter("allmanagers"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");

String jobids="0";

String jobdepartment=Util.null2String(request.getParameter("jobdepartment"));
String jobsubcompany=Util.null2String(request.getParameter("jobsubcompany"));
if(jobdepartment.equals("")){
jobdepartment="0";
}
if(jobsubcompany.equals("")){
jobsubcompany="0";
}
String joblevel=Util.null2String(request.getParameter("joblevel"));



String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;
String crmid="0";
int sharecrm=0;
String orgGroupId="0";
if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;
if(sharetype.equals("6")) orgGroupId = relatedshareid ;
if(sharetype.equals("10")) jobids = relatedshareid ;

//3:共享
//user info
int userid_share=user.getUID();
String logintype_share = user.getLogintype();
String userSeclevel_share = user.getSeclevel();
String userType_share = ""+user.getType();
String userdepartment_share = ""+user.getUserDepartment();
String usersubcomany_share = ""+user.getUserSubCompany1();

boolean canEdit = false;
boolean canShare = false ;
String userInfo=logintype_share+"_"+userid_share+"_"+userSeclevel_share+"_"+userType_share+"_"+userdepartment_share+"_"+usersubcomany_share;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if(canEdit){
    canShare = true;
}

if(method.equals("delete")){
	if(!canShare){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	RecordSet.executeProc("DocShare_Delete",id);
    DocViewer.setDocShareByDoc(docid);
    response.sendRedirect("DocShare.jsp?docid="+docid);
	return;
}
if(method.equals("add")){
	if(!canShare){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}	
	List scopes = AppDetachComInfo.getAppDetachScopes(user.getUID()+"");
	if(sharetype.equals("5")&&scopes!=null&&scopes.size()>0){
		for(int i=0;i<scopes.size();i++) {
			Map scope = (Map) scopes.get(i);
			sharetype = (String)scope.get("type");
			
			userid = "0" ;
			departmentid = "0" ;
			subcompanyid="0";
			roleid = "0" ;
			rolelevel = Util.null2o((String)scope.get("rolelevel"));
			if(sharetype.equals("1")) userid = (String)scope.get("content");
			if(sharetype.equals("2")) subcompanyid = (String)scope.get("content");
			if(sharetype.equals("3")) departmentid = (String)scope.get("content");
			if(sharetype.equals("4")) roleid = (String)scope.get("content");
	
			ProcPara = docid;
			ProcPara += flag+sharetype;
			ProcPara += flag+seclevel;
			ProcPara += flag+rolelevel;
			ProcPara += flag+sharelevel;
			ProcPara += flag+userid;
			ProcPara += flag+subcompanyid;
			ProcPara += flag+departmentid;
			ProcPara += flag+roleid;
			ProcPara += flag+foralluser;
			ProcPara += flag+"0" ;              //  crmid 

			RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
		}
		
	} else {
	ProcPara = docid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+subcompanyid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	ProcPara += flag+"0" ;              //  crmid 
	ProcPara += flag+orgGroupId ;              //  orgGroupId

	//RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
	RecordSet.executeProc("DocShare_IFromDocSecCat_G",ProcPara);
	}
	
	
    response.sendRedirect("DocShare.jsp?docid="+docid); 
	return;
}


if(method.equals("addMutil")){   
	if(!canShare){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}        
        String[] shareValues = request.getParameterValues("txtShareDetail"); 
        if (shareValues!=null) {
			
        	List scopes = AppDetachComInfo.getAppDetachScopes(user.getUID()+"");
		
			
            for (int i=0;i<shareValues.length;i++){

                //out.println(shareValues[i]+"<br>");
                String[] paras = Util.TokenizerString2(shareValues[i],"_");
                sharetype = paras[0];
				if(sharetype.equals("82")){
                 sharetype="81";
				 allmanagers="1";				
				}
                seclevel=paras[3] ;
                sharelevel=paras[4] ;
				String downloadlevel=paras[5];//TD12005
				seclevelmax=paras[6] ;
				includesub=paras[7] ;
				orgid=paras[8] ;
				if(orgid.equals("undefined")){
				orgid="0";
				}
	
				
                if(sharetype.equals("4")) {
                    roleid = paras[1] ;
                    rolelevel=paras[2] ;
                }


                if(sharetype.equals("5")) foralluser = "1" ;
                // for TD.4240 edit by wdl
                /*
                if(sharetype.equals("2")) { //分部
                   subcompanyid = paras[1] ;
                }*/
                if ("1".equals(sharetype)||"3".equals(sharetype)||"9".equals(sharetype)||sharetype.equals("2")||sharetype.equals("6")||sharetype.equals("10")){  //1:多人力资源    3:多部门   9://多客户...2:多分部	6:多群组
                    String tempStrs[]=Util.TokenizerString2(paras[1],",");
                    for(int k=0;k<tempStrs.length;k++){
                        
                        String tempStr = tempStrs[k];
                        if ("1".equals(sharetype)) userid=tempStr;
                        if ("3".equals(sharetype)) departmentid=tempStr;
                        if ("9".equals(sharetype)) crmid=tempStr;
                        if ("2".equals(sharetype)) subcompanyid=tempStr;
                        if ("6".equals(sharetype)) orgGroupId=tempStr;
						if ("10".equals(sharetype)) {
							
							jobids=tempStr;
							if(joblevel.equals("1")){
							  jobdepartment="0";
							  jobsubcompany="0";
							}else if(joblevel.equals("2")){
							  jobdepartment="0";
							}else if(joblevel.equals("3")){
							  jobsubcompany="0";
							}
						
						
						}else{
						    joblevel="0";
							jobdepartment="0";
							jobsubcompany="0";
						
						}
                        // end
                        
                        ProcPara = docid;
                        ProcPara += flag+sharetype;
                        ProcPara += flag+seclevel;
                        ProcPara += flag+rolelevel;
                        ProcPara += flag+sharelevel;
                        ProcPara += flag+userid;
                        ProcPara += flag+subcompanyid;
                        ProcPara += flag+departmentid;
                        ProcPara += flag+roleid;
                        ProcPara += flag+foralluser;
                        ProcPara += flag+crmid ;              //  crmid 
                        ProcPara += flag+orgGroupId ;              //  orgGroupId						
                        ProcPara += flag+downloadlevel;//TD12005
                        //System.out.println(ProcPara);
                        //RecordSet.executeProc("DocShare_IFromDocSecCategory",ProcPara);
                        //RecordSet.executeProc("DocShare_IFromDocSecCat_G",ProcPara);

                
		   if(joblevel.equals("2")){
				 String[] jobsubcompanyids = jobsubcompany.split(",");
		 	    for(String jobsubcompanyid : jobsubcompanyids)
		 	    {
					 String sql = "insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId,downloadlevel,seclevelmax,includesub,orgid,allmanagers,joblevel,jobdepartment,jobsubcompany,jobids ) values ("+
                        			docid+","+sharetype+",'"+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+
                        			userid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+
                        			foralluser+"','"+crmid+"','"+orgGroupId+"','"+downloadlevel+"','"+seclevelmax+"','"+includesub+"','"+orgid+"','"+allmanagers+"','"+joblevel+"','"+jobdepartment+"','"+jobsubcompanyid+"','"+jobids+"')";
		 	              
				   RecordSet.executeSql(sql);
		 	    }
		 	}
		 	else if(joblevel.equals("3"))
		 	{
		 	   String[] jobdepartmentids = jobdepartment.split(",");
			    for(String jobdepartmentid : jobdepartmentids)
		 	    {
		 	          String sql = "insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId,downloadlevel,seclevelmax,includesub,orgid,allmanagers,joblevel,jobdepartment,jobsubcompany,jobids ) values ("+
                        			docid+","+sharetype+",'"+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+
                        			userid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+
                        			foralluser+"','"+crmid+"','"+orgGroupId+"','"+downloadlevel+"','"+seclevelmax+"','"+includesub+"','"+orgid+"','"+allmanagers+"','"+joblevel+"','"+jobdepartmentid+"','"+jobsubcompany+"','"+jobids+"')";
				   RecordSet.executeSql(sql);
		 	    }
			}
		  else{

                        String sql = "insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,orgGroupId,downloadlevel,seclevelmax,includesub,orgid,allmanagers,joblevel,jobdepartment,jobsubcompany,jobids ) values ("+
                        			docid+","+sharetype+",'"+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+
                        			userid+"','"+subcompanyid+"','"+departmentid+"','"+roleid+"','"+
                        			foralluser+"','"+crmid+"','"+orgGroupId+"','"+downloadlevel+"','"+seclevelmax+"','"+includesub+"','"+orgid+"','"+allmanagers+"','"+joblevel+"','"+jobdepartment+"','"+jobsubcompany+"','"+jobids+"')";
              
						RecordSet.executeSql(sql);
		  }
						DocViewer.setDocShareByDoc(docid); 
                    }                       
                } else {    
                   String tempUserId=""+user.getUID();
                   if("80".equals(sharetype)||"81".equals(sharetype)||"84".equals(sharetype)||"85".equals(sharetype)||"-80".equals(sharetype)||"-81".equals(sharetype)){ //文档创建者ID
                     String strSql="select doccreaterid from docdetail where id="+docid;
                     RecordSet.executeSql(strSql);
                     if (RecordSet.next()){
                       tempUserId=Util.null2String(RecordSet.getString(1));
					   userid=tempUserId;
                     }                     
                   }                    

                    ProcPara = docid;
                    ProcPara += flag+sharetype;
                    ProcPara += flag+seclevel;
                    ProcPara += flag+rolelevel;
                    ProcPara += flag+sharelevel;
                    ProcPara += flag+tempUserId;
                    ProcPara += flag+subcompanyid;
                    ProcPara += flag+departmentid;
                    ProcPara += flag+roleid;
                    ProcPara += flag+foralluser;
                    ProcPara += flag+"0" ;              //  crmid 
					ProcPara += flag+downloadlevel;//TD12005
					
                   
                   		String sql = "insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource,downloadlevel,seclevelmax,includesub,orgid,allmanagers) values("+
                   				docid+",'"+sharetype+"','"+seclevel+"','"+rolelevel+"','"+
                   				sharelevel+"','"+userid+"','"+subcompanyid+"','"+departmentid+"','"+
                   				roleid+"','"+foralluser+"','"+crmid+"',0,'"+downloadlevel+"','"+seclevelmax+"','"+includesub+"','"+orgid+"','"+allmanagers+"')";
                   
                   
                    RecordSet.executeSql(sql);
					DocViewer.setDocShareByDoc(docid); 
                }
            
                //for (int j=0;j<paras.length;j++){
                //   out.println(paras[j]+"<br>");
                //}
                //out.println("==========================");
            }
        }	  
        String actionid = Util.null2String(request.getParameter("actionid"));
		String datasourceid = Util.null2String(request.getParameter("datasourceid"));
		if("netdisk".equals(actionid) && datasourceid.contains(",")){//网盘文件发布到系统
			PublishNetWorkFile publishNetWorkFile = new PublishNetWorkFile();
		    boolean b = publishNetWorkFile.recordShare(Util.getIntValue(docid,-1),datasourceid);
		    if(!b){
		        response.sendRedirect("DocShareAddBrowser.jsp?isdialog=1&_para2=2_"+docid + "&actionid=" + actionid + "&datasourceid=" + datasourceid); 
		        return;
		    }
		}
        
       response.sendRedirect("DocShareAddBrowser.jsp?isclose=2&_para2=2_"+docid); 
	   return;
}
if(method.equals("delMShare")) {
	if(!canShare){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}	
    String[] delShareIds = request.getParameterValues("chkShareId");    
    if (delShareIds!=null) {
        for (int i=0;i<delShareIds.length;i++){
            String delShareId = delShareIds[i];
            RecordSet.executeSql("delete docshare where id="+delShareId);
        }
        DocViewer.setDocShareByDoc(docid); 
    }
    response.sendRedirect("DocShare.jsp?docid="+docid+"&blnOsp="+blnOsp); 
	return;
}

if(method.equals("finish")) {
    
    String actionid = Util.null2String(request.getParameter("actionid"));
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
					                    Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
					                    Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
    Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	Util.add0(today.get(Calendar.SECOND), 2) ;
    
    //进行共享
    DocViewer.setDocShareByDoc(docid);
    
    //如果是弹出框将还需做流程的触发//状态已经在DocManager.java中设置
    if (blnOsp&&Util.getIntValue(docid,0)>0){
    	String isdialog = Util.null2String(request.getParameter("isdialog"));
		if("-1".equals(DocComInfo.getDocStatus(docid))){
		    if("netdisk".equals(actionid) && datasourceid.contains(",")){ //网盘文件发布到系统
		        RecordSet.executeSql("update DocDetail set docStatus='1',docvaliddate='"+ currentdate+"',docvalidtime='"+currenttime+"' where id in(" + datasourceid + ")"); 
		    }else{
				 RecordSet.executeSql("update DocDetail set docStatus='1',docvaliddate='"+ currentdate+"',docvalidtime='"+currenttime+"' where id="+docid); 
		    }
		    
		}
		
		if("-6".equals(DocComInfo.getDocStatus(docid))){
		    if("netdisk".equals(actionid) && datasourceid.contains(",")){ //网盘文件发布到系统
		        RecordSet.executeSql("update DocDetail set docStatus='6' where id in(" + datasourceid + ")"); 
		    }else{
				RecordSet.executeSql("update DocDetail set docStatus='6' where id="+docid);
		    }
		}
    	
        if (("-3".equals(DocComInfo.getDocStatus(docid))||"3".equals(DocComInfo.getDocStatus(docid)))&&SecCategoryComInfo.needApprove(DocComInfo.getDocSecCategory(docid))){//需要审批
        	
        	if("-3".equals(DocComInfo.getDocStatus(docid)))
      			RecordSet.executeSql("update DocDetail set docStatus='3' where id="+docid);
        	
                    String approveType="1";
					int intDocId=0;
					if(docid!=null&&!docid.equals("")){
						intDocId=Integer.parseInt(docid);
					}
                    //DocApproveWfManager.approveWf(intDocId,approveType,user);


//          
                    int workflowId=-1;
					String isOpenApproveWf="";/*isOpenApproveWf为1表示启用文档生效审批和文档失效审批 ，isOpenApproveWf为2表示启用批准工作流，即文档需求变更前使用的批准工作流。 fanggsh 20060928 fot TD5032*/

                    RecordSet.executeSql("select approveWorkflowId,isOpenApproveWf from DocSecCategory where id="+DocComInfo.getDocSecCategory(docid));
                    if(RecordSet.next()) {
						workflowId=RecordSet.getInt("approveWorkflowId");
						isOpenApproveWf=Util.null2String(RecordSet.getString("isOpenApproveWf"));
                    }

					if(isOpenApproveWf.equals("1")){
						DocApproveWfManager.setRequest(request);
						String approveWfStatus=DocApproveWfManager.approveWf(intDocId,approveType,user);
						if("false".equals(approveWfStatus)){
							RecordSet.executeSql("update DocDetail set docStatus='0' where id="+intDocId);
							//RecordSet.executeSql("update DocDetail set isHistory='1',docStatus='7' where id<>"+intDocId+" and docEditionId=(select docEditionId from DocDetail where id="+intDocId+")");
							RecordSet.executeSql(" update docdetail set docstatus = 7,ishistory = 1 where id <> " + intDocId + " and docedition > 0 and docedition < (select docedition from DocDetail where id="+intDocId+") and doceditionid > 0 and doceditionid = (select docEditionId from DocDetail where id="+intDocId+")");
						}
					}
					//System.out.println("workflowId::"+workflowId+"===isOpenApproveWf::"+isOpenApproveWf);
					if(workflowId>0&&isOpenApproveWf.equals("2")){
						//触发流程      
						ApproveParameter.resetParameter();
						ApproveParameter.setWorkflowid(workflowId);
						ApproveParameter.setNodetype("0");
						ApproveParameter.setApproveid(Util.getIntValue(docid));
						ApproveParameter.setApprovetype("9");
						ApproveParameter.setRequestname(docsubject);          
						ApproveParameter.setGopage("/docs/docs/DocApprove.jsp?id=");
						ApproveParameter.setBackpage("/docs/docs/DocApprove.jsp?id="); 						
						//设置推送提醒 start
						String docstatus = DocComInfo.getDocStatus(docid);
						String sendToAll = Util.null2String(request.getParameter("sendToAll"));
						if("1".equals(sendToAll)){
							if("3".equals(docstatus)||"6".equals(docstatus)){
							    if("-1".equals(SendToAllForNew.checkIsExist(docid))){
							        RecordSet1.executeSql("insert into sendtoalltemp (docid,shareids,status) values ("+docid+",'"+shareIds+"',0)"); 
							    }
							}
						//设置推送提醒 end
						}						
						if(ApproveParameter.getFormid()==67) {
							if(isdialog.equals("1")){
								out.println("<script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/workflow/request/BillInnerSendDocOperation.jsp?docid="+docid+"&src=save&iscreate=1&blnOsp="+blnOsp+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"'</script>");
							}else{
								response.sendRedirect("/workflow/request/BillInnerSendDocOperation.jsp?docid="+docid+"&src=save&iscreate=1&blnOsp="+blnOsp+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
							}
						} else {
							RecordSet.executeSql("select a.requestid,a.requestname from workflow_requestbase a, bill_Approve b where a.workflowid="+workflowId+" and a.currentnodetype=0 and a.requestid=b.requestid and b.approveid="+docid);
								
							if(RecordSet.next()){//该文档对应的审批流程已触发过，并且流程目前处于创建节点
							    String tempRequestid = RecordSet.getString(1);
							    String tempnodeid = ""+ApproveParameter.getNodeid();
							    String temprequestname = RecordSet.getString(2);
							    if(isdialog.equals("1")){
									out.println("<script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/workflow/request/BillApproveOperation.jsp?workflowid="+workflowId+"&requestid="+tempRequestid+"&docid="+docid+"&src=submit&iscreate=0&blnOsp="+blnOsp+"&nodeid="+tempnodeid+"&nodetype=0&isbill=1&formid=28&requestname="+URLEncoder.encode(temprequestname)+"'</script>");
								}else{
							    	response.sendRedirect("/workflow/request/BillApproveOperation.jsp?workflowid="+workflowId+"&requestid="+tempRequestid+"&docid="+docid+"&src=submit&iscreate=0&blnOsp="+blnOsp+"&nodeid="+tempnodeid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&nodetype=0&isbill=1&formid=28&requestname="+URLEncoder.encode(temprequestname));
								}
							}else{
								if(isdialog.equals("1")){
									out.println("<script type='text/javascript'>parent.parent.getParentWindow(parent).location.href='/workflow/request/BillApproveOperation.jsp?docid="+docid+"&src=submit&iscreate=1&blnOsp="+blnOsp+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"'</script>");
								}else{
									response.sendRedirect("/workflow/request/BillApproveOperation.jsp?docid="+docid+"&src=submit&iscreate=1&blnOsp="+blnOsp+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
								}
							}
						}  
						return;
					}




        }
      %>
            <SCRIPT LANGUAGE="JavaScript">
            	var isdialog = "<%=isdialog%>";
            	if(isdialog=="1"){
            		var dialog = parent.parent.getDialog(parent);
            		if(dialog){
            			dialog.callback({result:"1",result:"1"});
            		}else{
            			window.parent.parent.returnValue="1"; 
            		}
            	}else{   
	               window.parent.close(); 
	               window.parent.parent.returnValue="1";   
	            }
            </SCRIPT>
        <% 
		    //设置推送提醒 start
            String docstatus = DocComInfo.getDocStatus(docid);
				String sendToAll = Util.null2String(request.getParameter("sendToAll"));
				if("1".equals(sendToAll)){
					if("3".equals(docstatus)||"6".equals(docstatus)||"9".equals(docstatus)){
					    if("-1".equals(SendToAllForNew.checkIsExist(docid))){
					        RecordSet1.executeSql("insert into sendtoalltemp (docid,shareids,status) values ("+docid+",'"+shareIds+"',0)"); 
					    }
					}else if("1".equals(docstatus) || "2".equals(docstatus)){
					        //ThreadForAllForNew sendToAllfornew = new ThreadForAllForNew(docid,shareIds);
							ThreadForAllForNew sendToAllfornew = new ThreadForAllForNew(docid+"","",user);
					        sendToAllfornew.start();
					}
					//设置推送提醒 end
				}
           return ;                

    }
    //重定向
    response.sendRedirect("DocDsp.jsp?id="+docid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype);
    return ;
}

if(method.equals("unfinish")) {
	//TD.6077 新建后如果需要弹出共享提醒窗口，而未确定直接关闭，需要将新建文档变回草稿状态
    if(("-3".equals(DocComInfo.getDocStatus(docid))||"3".equals(DocComInfo.getDocStatus(docid)))&&SecCategoryComInfo.needApprove(DocComInfo.getDocSecCategory(docid))){
	    RecordSet.executeSql("update docdetail set docstatus = '"+0+"' where id="+docid);
    } else if(!"0".equals(DocComInfo.getDocStatus(docid))&&SecCategoryComInfo.isSetShare(DocComInfo.getDocSecCategory(docid))){
    	RecordSet.executeSql("update docdetail set docstatus = '"+0+"' where id="+docid);
    }
    %>
    <SCRIPT LANGUAGE="JavaScript">
       window.close(); 
       window.parent.returnValue="1";   
    </SCRIPT>
<% 
    return;
}
%>