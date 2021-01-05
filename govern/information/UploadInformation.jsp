
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.net.*" %>
<%@ page import="weaver.system.ThreadForAllForNew" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="SendToAllForNew" class="weaver.system.SendToAllForNew" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page"/>
<jsp:useBean id="poppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%--
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="docCoders" class="weaver.docs.docs.DocCoder" scope="page"/>
--%>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocApproveWfManager" class="weaver.docs.docs.DocApproveWfManager" scope="page" />
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%  
    String f_weaver_belongto_userid=Util.null2String((String)session.getAttribute("f_weaver_belongto_userid_doc"));
	String f_weaver_belongto_usertype=Util.null2String((String)session.getAttribute("f_weaver_belongto_usertype_doc"));
	if("".equals(f_weaver_belongto_usertype)){
         f_weaver_belongto_usertype = "0";
    }
    user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
    f_weaver_belongto_userid=""+user.getUID();  
	session.removeAttribute("f_weaver_belongto_userid_doc");
	session.removeAttribute("f_weaver_belongto_usertype_doc");
	String ddip= Util.null2String(request.getParameter("ddip")); 
	String ssid= Util.null2String(request.getParameter("ssid")); 
	String fwid= Util.null2String(request.getParameter("dataId")); 
  	DocManager.resetParameter();
  	DocManager.setClientAddress(request.getRemoteAddr());
    DocManager.setUserid(user.getUID());
    DocManager.setLanguageid(user.getLanguage());
    DocManager.setUsertype(""+user.getLogintype());	 
  	String message = DocManager.UploadDoc(request);

  	
    int docId=DocManager.getId();
    if("addsave".equals(message)){
    	RecordSet.execute("update uf_xxcb_pbInfo set gwid='"+docId+"' where id="+fwid);
    }
	String sendToAll =SendToAllForNew.checkeSendingRightForDocid(docId+"");
	
	//得到文档状态
	String status = DocManager.getDocstatus2();
	
	if ("addsave".equals(message)||"editsave".equals(message)||"invalidate".equals(message)){
		if("-6".equals(status)){
			RecordSet.executeSql("update uf_xxcb_pbInfo set gwstatu='6' where id="+fwid);
		}else{
			RecordSet.executeSql("update uf_xxcb_pbInfo set gwstatu='1' where id="+fwid);
		}
	}
	
    FileUpload fileUpload=DocManager.getFileUpload2();

	String oldStatus=DocManager.getOldstatus();
		
  	if ("".equals(message)) {
  		out.println(SystemEnv.getHtmlLabelName(19139,user.getLanguage()));
  		return ;  	
  	}
    String urlfrom = DocManager.getUrlFrom();

    boolean isadd = (message.indexOf("add") == 0) ;
    boolean isedit = (message.indexOf("edit") == 0) ;   

    // 文档缓存
    if(isadd || isedit || message.equals("delete")) {       
        if(isadd) DocComInfo.addDocInfoCache(""+docId);
        else if(isedit) DocComInfo.updateDocInfoCache(""+docId);
        else DocComInfo.deleteDocInfoCache(""+docId);
    }

    DocViewer.setDocShareByDoc(""+docId);

	response.sendRedirect("/govern/information/InformationAdd.jsp?fwid="+fwid+"&editType=0");	
%>
