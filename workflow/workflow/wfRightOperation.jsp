<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String method = Util.null2String(request.getParameter("method"));
int wftypeid = Integer.parseInt(Util.null2String(request.getParameter("wftypeid")));
int operationcode = Integer.parseInt(Util.null2String(request.getParameter("operationcode")));

String authorityStr="";
WfRightManager wfrm = new WfRightManager();
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !wfrm.hasPermission(wftypeid, 0, user, WfRightManager.OPERATION_CREATEDIR)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
if (method.equals("add")) {
    int permissiontype = Integer.parseInt(Util.null2String(request.getParameter("permissiontype")));
    int seclevel = Integer.parseInt(Util.null2String(request.getParameter("seclevel")));
    
	String hisSecCategoryCreater="";
    switch (permissiontype) {
        case 1:
        int ismutil = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
        if(ismutil!=0) {			
            String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            for(int k=0;k<tempStrs.length;k++){
                int departmentid = Util.getIntValue(Util.null2o(tempStrs[k]));
                if(departmentid>0)
                    wfrm.grantWfPermission1(wftypeid, 0, operationcode, departmentid, seclevel);
            }
            response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
        } else {
            int departmentid = Integer.parseInt(Util.null2String(request.getParameter("departmentid")).split(",")[1]);
            wfrm.grantWfPermission1(wftypeid, 0, operationcode, departmentid, seclevel);
            response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
        }
        break;

        case 6:
            int ismutilsub = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
            if(ismutilsub!=0) {
                String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("subcompanyid")),",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid = Util.getIntValue(Util.null2o(tempStrs[k]));
                    if(subcompanyid>0)
                        wfrm.grantWfPermission6(wftypeid, 0, operationcode, subcompanyid, seclevel);
                }
               response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
            } else {
                int subcompanyid = Integer.parseInt(Util.null2String(request.getParameter("subcompanyid")).split(",")[1]);
                wfrm.grantWfPermission6(wftypeid, 0, operationcode, subcompanyid, seclevel);
                response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
            }
            break;
        
        case 2:        
        int roleid = Integer.parseInt(Util.null2String(request.getParameter("roleid")));
        int rolelevel = Integer.parseInt(Util.null2String(request.getParameter("rolelevel")));
       	wfrm.grantWfPermission2(wftypeid, 0, operationcode, roleid, rolelevel, seclevel);
	    response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
        break;

        case 3:
        wfrm.grantWfPermission3(wftypeid, 0, operationcode, seclevel);
	    response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
        break;

        case 4:
        int usertype = Integer.parseInt(Util.null2String(request.getParameter("usertype")));
        wfrm.grantWfPermission4(wftypeid, 0, operationcode, usertype, seclevel);
	    response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
        break;

        case 5:
        String[] tmpuserid = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
        int userid = 0;
        for(int i=0;tmpuserid!=null&&tmpuserid.length>0&&i<tmpuserid.length;i++){
        	userid = Util.getIntValue(tmpuserid[i]);
        	if(userid>0) wfrm.grantWfPermission5(wftypeid, 0, operationcode, userid);
        }
        response.sendRedirect("wfRightAdd.jsp?isclose=1&wftypeid="+wftypeid+"&operationcode="+operationcode);
        break;
    }
} else if (method.equals("delete")) {
	String mainids = Util.null2String(request.getParameter("mainids"));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
	List dirIdDirTypeOperationCodeList=null;
    if(mainids!=null&&!"".equals(mainids)){
    	String[] tids = Util.TokenizerString2(mainids,",");
    	for(int i=0;tids!=null&&tids.length>0&&i<tids.length;i++){
    		wfrm.depriveDirPermission(tids[i]);
		}
    }
    String url = "/workflow/workflow/wfRightEdit.jsp?id="+wftypeid;
	if(isDialog.equals("1")){
		url+="&isdialog=1";
	}
	response.sendRedirect(url);
	return;
}
%>