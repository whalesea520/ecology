<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/init.jsp" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="session"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>


<%
	DocManager.resetParameter();
  	DocManager.setClientAddress(request.getRemoteAddr());
	DocManager.setUserid(user.getUID());
	DocManager.setLanguageid(user.getLanguage());
  	String message = DocManager.UploadDoc(request);
    String urlfrom = DocManager.getUrlFrom();
    out.println("*******"+urlfrom);
  	DocComInfo.removeDocCache();

    boolean isadd = (message.indexOf("add") == 0) ;
    boolean isedit = (message.indexOf("edit") == 0) ;
    int contractid = 0;
    String sql = "select id from HrmContract where contractdocid = "+DocManager.getId();
    rs.executeSql(sql);
    while(rs.next()){
      contractid = Util.getIntValue(rs.getString("id"));
    }
        
	if(message.equals("delete")){      
	   if(urlfrom.equals("hr")){
	     response.sendRedirect("/hrm/contract/contract/HrmContract.jsp");
	   }else{
  		response.sendRedirect("/web/WebBBSDsp.jsp");
  	   }	
    }else if(message.equals("delete_1")){
        int id=DocManager.getId();
        if(urlfrom.equals("hr")){
	     response.sendRedirect("/hrm/contract/contract/HrmContractEdit.jsp?id="+contractid);
	   }  		
  		response.sendRedirect("DocDsp.jsp?messageid=1&id="+id);
  	}else if(message.equals("delpic")/*||message.endsWith("draft")*/){
  		int id=DocManager.getId();
  		if(urlfrom.equals("hr")){
	     response.sendRedirect("/hrm/contract/contract/HrmContractEdit.jsp?id="+contractid);
	   }
  		response.sendRedirect("DocEdit.jsp?id="+id);
  	}
  	
  else if(isadd || isedit){
        String topage=URLDecoder.decode(Util.null2String(DocManager.getToPage()));
        if(!topage.equals("")){
            if(topage.indexOf("?")!=-1)
    			topage+="&docid=";
            else
    			topage+="?docid=";
    	 }
	    int id=DocManager.getId();
	    int docid=id;
	    int userid=user.getUID();
		//杨国生2003-09-05加用于解决网站传递新闻组的接口begin
		int newsid=DocManager.getNewsId();
		String isreply=DocManager.getIsreply2();
		int replydocid=DocManager.getReplydocid2();
		//杨国生2003-09-05加用于解决网站传递新闻组的接口end
	    int seccategoryid=DocManager.getSeccategory2();
	    String docapprovable = DocManager.getDocapprovable2();
	    String subject =DocManager.getDocsubject2();
        int ownerid=DocManager.getOwnerid2();
        
        if(isadd || ( isedit &&  DocManager.getOwnerid2() != DocManager.getOldownerid() ))
            DocViewer.setDocShareByDoc(""+docid);

        //to new remind  
        String docpublishtype=DocManager.getDocpublishtype2();
        char flag=Util.getSeparator();

        if(isadd){
            if(docpublishtype.equals("2")||docpublishtype.equals("3")){
                while(ResourceComInfo.next()){        
                    String usertype="1";
                    String useridR="";
                    useridR=ResourceComInfo.getResourceid();                    
                   RecordSet.executeProc("NewDocFrontpage_Insert",usertype+flag+useridR+flag+""+docid);
                                                       
                }
                while(CustomerTypeComInfo.next()){
                    String usertypeC="";
                    String useridRC="";
                    usertypeC=CustomerTypeComInfo.getCustomerTypeid(); 
                    RecordSet.executeProc("NewDocFrontpage_Insert","-"+usertypeC+flag+useridRC+flag+docid);
                } 
            }
            }

        if(isedit){
            if((DocManager.getDocpublishtypeold().equals("")||DocManager.getDocpublishtypeold().equals(""))&&(docpublishtype.equals("2")||docpublishtype.equals("3"))){
                while(ResourceComInfo.next()){        
                    String usertype="1";
                    String useridR="";
                    useridR=ResourceComInfo.getResourceid();
                    out.print(usertype+flag+useridR+flag+docid);
                    RecordSet.executeProc("NewDocFrontpage_Insert",usertype+flag+useridR+flag+""+docid);
                                                       
                }
                while(CustomerTypeComInfo.next()){
                    String usertypeC="";
                    String useridRC="";
                    usertypeC=CustomerTypeComInfo.getCustomerTypeid(); 
                    RecordSet.executeProc("NewDocFrontpage_Insert","-"+usertypeC+flag+useridRC+flag+docid);
                }
            }
            if((DocManager.getDocpublishtypeold().equals("2")||DocManager.getDocpublishtypeold().equals("3"))&&(docpublishtype.equals("")||docpublishtype.equals("1"))){
                while(ResourceComInfo.next()){        
                    RecordSet.executeProc("NewDocFrontpage_DeleteByDocId",""+docid);                                      
                }
                while(CustomerTypeComInfo.next()){
                    RecordSet.executeProc("NewDocFrontpage_DeleteByDocId",""+docid);
                }
            }

        }
   
    	//提醒,工作流相关数据
    	if(docapprovable.equals("1") && ( message.equals("addsave") || message.equals("editsave")))  {
    	    String gopage="/docs/docs/DocApprove.jsp";
            String backpage="/docs/docs/DocDsp.jsp?id=";
    	    RecordSet.executeSql("select approveworkflowid from docseccategory where id="+seccategoryid);
    	    RecordSet.next();
    	    int workflowid=RecordSet.getInt(1);

            boolean neednewrequest = true ;
            
            if(message.equals("editsave")) {

                RecordSet.executeSql("select currentnodetype , deleted from workflow_requestbase where workflowid="+workflowid+" and docids like '"+id + "'" );
    	    
                if(RecordSet.next()) {
                    String currentnodetype = Util.null2String(RecordSet.getString("currentnodetype")) ;
                    String deleted = Util.null2String(RecordSet.getString("deleted")) ;

                    if(!currentnodetype.equals("3") && !deleted.equals("1")) neednewrequest = false ;
                }
            }
	    if(!topage.equals("")) backpage=topage;
            if(neednewrequest) {
                ApproveParameter.resetParameter();
                ApproveParameter.setWorkflowid(workflowid);
                ApproveParameter.setNodetype("0");
                ApproveParameter.setApproveid(docid);
                ApproveParameter.setApprovetype("9");
                ApproveParameter.setRequestname(subject);
                ApproveParameter.setGopage(gopage);
                ApproveParameter.setBackpage(backpage);
        	
                
                response.sendRedirect("/workflow/request/BillApproveOperation.jsp?src=submit&iscreate=1");
                return;
            }
        }
    

        if(!topage.equals("")){
	       response.sendRedirect(topage+id);
		  return;
    	 }    
    if(urlfrom.equals("hr")){          
	     response.sendRedirect("/hrm/contract/contract/HrmContractEdit.jsp?id="+contractid);
	   }else{
	if (isreply.equals("1"))  
	response.sendRedirect("/web/WebBBSDetailDsp.jsp?newsid="+newsid+"&secid="+seccategoryid+"&id="+replydocid);//如果是回复的文档回到被回复的文档的显示页
	else
 	response.sendRedirect("/web/WebBBSDetailDsp.jsp?newsid="+newsid+"&secid="+seccategoryid+"&id="+id);	
 	}
  }else{
    int id=DocManager.getId();    
	if(urlfrom.equals("hr")){
	     response.sendRedirect("/hrm/contract/contract/HrmContractEdit.jsp?id="+contractid);
	   }else{   
	out.print(message);
	response.sendRedirect("/web/WebBBSDetailDsp.jsp?id="+id);
	}
  }

%>
