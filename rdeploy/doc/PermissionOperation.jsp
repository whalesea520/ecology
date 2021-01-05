<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String method = Util.null2String(request.getParameter("method"));
int categoryid = Integer.parseInt(Util.null2String(request.getParameter("categoryid")));
int categorytype = Integer.parseInt(Util.null2String(request.getParameter("categorytype")));
int operationcode = Integer.parseInt(Util.null2String(request.getParameter("operationcode")));

//QC61315
String authorityStr="";
MultiAclManager am = new MultiAclManager();
authorityStr=am.getAuthorityStr(categorytype);

int secid = Util.getIntValue(request.getParameter("categoryid"),0);
int parentId = Util.getIntValue(SecCategoryComInfo.getParentId(""+secid));
boolean hasSecManageRight = false;
if(parentId>0){
	hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
}
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !hasSecManageRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
if (method.equals("add")) {
    int permissiontype = Integer.parseInt(Util.null2String(request.getParameter("permissiontype")));
    int seclevel = Util.getIntValue(Util.null2String(request.getParameter("seclevel")),0);
	String seclevelmax = Util.null2String(Util.getIntValue(request.getParameter("seclevelmax"),255));
    am.setSeclevelmax(seclevelmax);
	String hisSecCategoryCreater="";
    switch (permissiontype) {
        case 1:
        int ismutil = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
        if(ismutil!=0) {


            String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            for(int k=0;k<tempStrs.length;k++){
                int departmentid = Util.getIntValue(Util.null2o(tempStrs[k]));            
                    am.grantDirPermission1(categoryid, categorytype, operationcode, departmentid, seclevel);
            }
			
            response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        } else {

            int departmentid = Integer.parseInt(Util.null2String(request.getParameter("departmentid")).split(",")[1]);
            am.grantDirPermission1(categoryid, categorytype, operationcode, departmentid, seclevel);
			
            response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        }
      
        break;

        case 6:
            int ismutilsub = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
            if(ismutilsub!=0) {
    			
                String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("subcompanyid")),",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid = Util.getIntValue(Util.null2o(tempStrs[k]));                  
                        am.grantDirPermission6(categoryid, categorytype, operationcode, subcompanyid, seclevel);
                }
    			
               response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
            } else {

                int subcompanyid = Integer.parseInt(Util.null2String(request.getParameter("subcompanyid")).split(",")[1]);
                am.grantDirPermission6(categoryid, categorytype, operationcode, subcompanyid, seclevel);
    		
                response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid);
            }
            break;
        
        case 2:        
        int roleid = Integer.parseInt(Util.null2String(request.getParameter("roleid")));
        int rolelevel = Integer.parseInt(Util.null2String(request.getParameter("rolelevel")));

        am.grantDirPermission2(categoryid, categorytype, operationcode, roleid, rolelevel, seclevel);
		
	    response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;

        case 3:

        am.grantDirPermission3(categoryid, categorytype, operationcode, seclevel);
		
	    response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;

        case 4:

        int usertype = Integer.parseInt(Util.null2String(request.getParameter("usertype")));
        am.grantDirPermission4(categoryid, categorytype, operationcode, usertype, seclevel);
		
	    response.sendRedirect("/rdeploy/doc/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;

        case 5:

	
        String[] tmpuserid = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
        int userid = 0;
        for(int i=0;tmpuserid!=null&&tmpuserid.length>0&&i<tmpuserid.length;i++){
        	userid = Util.getIntValue(tmpuserid[i]);
        	if(userid>0) am.grantDirPermission5(categoryid, categorytype, operationcode, userid);
        }
      
        response.sendRedirect("/rdeploy/doc/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;
    }
} else if (method.equals("delete")) {
	String mainids = Util.null2String(request.getParameter("mainids"));
    int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
	List dirIdDirTypeOperationCodeList=null;
    if(mainids!=null&&!"".equals(mainids)){
		dirIdDirTypeOperationCodeList=am.getDirIdDirTypeOperationCodeList(mainids);
    	String[] tids = Util.TokenizerString2(mainids,",");
    	for(int i=0;tids!=null&&tids.length>0&&i<tids.length;i++){
    		am.depriveDirPermission(Util.getIntValue(tids[i]));
		}
    } else {
		dirIdDirTypeOperationCodeList=am.getDirIdDirTypeOperationCodeList(""+mainid);
    	am.depriveDirPermission(mainid);
    }
	am.updateDirAccessPermissionData(dirIdDirTypeOperationCodeList);
	
	String url = "DocSecCategoryRightEdit.jsp?id="+categoryid;
	if(isDialog.equals("1")){
		url+="&isdialog=1";
	}
	response.sendRedirect(url);
	return;
}
%>