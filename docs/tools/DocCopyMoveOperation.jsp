
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.docs.DocUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.docs.ShareManageDocOperation" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="dci" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
    String operation=Util.null2String(request.getParameter("operation"));
    String otype=Util.null2String(request.getParameter("otype"));
    String ifrepeatedname = Util.null2String(request.getParameter("ifrepeatedname"));
	String sharebysec = Util.null2String(request.getParameter("sharebysec"));
	
    int srcmainid=0;
    int srcsubid=0;
    int srcsecid=0;
    int objmainid=0;
    int objsubid=0; 
    int objsecid=0;
    
    String[] selectedPropertyMapping = request.getParameterValues("selectedPropertyMapping");
    
    String docStrs = Util.null2String(request.getParameter("docStrs"));
    String docids[]= Util.TokenizerString2(docStrs,",");
    srcmainid=Util.getIntValue(request.getParameter("srcmainid"),0);
    srcsubid=Util.getIntValue(request.getParameter("srcsubid"),0);
    srcsecid=Util.getIntValue(request.getParameter("srcsecid"),0);
    objmainid=Util.getIntValue(request.getParameter("objmainid"),0);
    objsubid=Util.getIntValue(request.getParameter("objsubid"),0);
    objsecid=Util.getIntValue(request.getParameter("objsecid"),0);
    MultiAclManager am = new MultiAclManager();
	ShareManageDocOperation manager = new ShareManageDocOperation();

	if(operation.equalsIgnoreCase("move") && docids != null){
		if(!HrmUserVarify.checkUserRight("DocCopyMove:Move", user)) {
		    if (!am.hasPermission(srcsecid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_MOVEDOC)) {
    		    response.sendRedirect("/notice/noright.jsp");
    		    return;
    		}
		}
		for(int i=0;i<docids.length;i++){
			int docid=0;
			String subject="";
			docid=Util.getIntValue(docids[i],0);
			subject=Util.null2String(dci.getDocname(docids[i]));
			//如果目标子目录允许文件名重复
			DocUtil docUtil = new DocUtil();
			if("yes".equals(ifrepeatedname) || ("no".equals(ifrepeatedname) && !docUtil.ifRepeatName(objsecid,subject))){
			DocManager.setId(docid);
            DocManager.setUserid(user.getUID());
            DocManager.setUsertype(user.getLogintype());
			DocManager.setDocsubject(subject);
            DocManager.setClientAddress(request.getRemoteAddr());
			DocManager.setMaincategory(objmainid);
			DocManager.setSubcategory(objsubid);
			DocManager.setSeccategory(objsecid);
			
			DocManager.setCustomDataIdMapping(selectedPropertyMapping);
			
			DocManager.moveDoc();
			
			if(sharebysec.equals("1")){
               
				manager.copyMoveDocShareBySec(objsecid,docid);
				
			
			  }
			}
		}
	}
	if(operation.equalsIgnoreCase("copy")  && docids != null){
		if(!HrmUserVarify.checkUserRight("DocCopyMove:Copy", user)) {
		    if (!am.hasPermission(srcsecid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_COPYDOC)) {
    		    response.sendRedirect("/notice/noright.jsp");
    		    return;
    		}
		}
		for(int i=0;i<docids.length;i++){
			int docid=0;
			String subject="";
			docid=Util.getIntValue(docids[i],0);
            subject=Util.null2String(dci.getDocname(docids[i]));
			//如果目标子目录允许文件名重复
			DocUtil docUtil = new DocUtil();
			if("yes".equals(ifrepeatedname) || ("no".equals(ifrepeatedname) && !docUtil.ifRepeatName(objsecid,subject))){
			DocManager.setId(docid);
            DocManager.setUserid(user.getUID());
            DocManager.setUsertype(user.getLogintype());
            DocManager.setDocsubject(subject);
            DocManager.setClientAddress(request.getRemoteAddr());
			DocManager.setMaincategory(objmainid);
			DocManager.setSubcategory(objsubid);
			DocManager.setSeccategory(objsecid);

			DocManager.setCustomDataIdMapping(selectedPropertyMapping);

			DocManager.copyDoc();
			
			if(sharebysec.equals("1")){
				manager.copyMoveDocShareBySec(objsecid,DocManager.getId());//DocManager.getId()获取复制的新文档的id
			
			  }
			}
		}
	}
	response.sendRedirect("DocCopyMove.jsp?hasTab=1&srcmainid="+srcmainid+"&srcsubid="+srcsubid+"&srcsecid="+srcsecid+"&objmainid="+objmainid+"&objsubid="+objsubid+"&objsecid="+objsecid+"&otype="+otype);

%>