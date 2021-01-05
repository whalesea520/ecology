
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
    int seclevel = Integer.parseInt(Util.null2String(request.getParameter("seclevel")));
	String seclevelmax = Util.null2String(request.getParameter("seclevelmax"));
    am.setSeclevelmax(seclevelmax);
	String hisSecCategoryCreater="";
    switch (permissiontype) {
        case 1:
        /* for TD.4240 edited by wdl(增加多部门) */
        int ismutil = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
		String includesub2 = Util.getIntValue(request.getParameter("includesub2"),0)+"";
    	am.setIncludesub(includesub2);
        if(ismutil!=0) {


			/*if(categorytype==2){
			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
			}*/
			
            String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            for(int k=0;k<tempStrs.length;k++){
                int departmentid = Util.getIntValue(Util.null2o(tempStrs[k]));            
                    am.grantDirPermission1(categoryid, categorytype, operationcode, departmentid, seclevel);
            }
			/*if(categorytype==2){
                UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
			}*/

            //response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
            response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        } else {

			/*if(categorytype==2){
			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
			}*/
            int departmentid = Integer.parseInt(Util.null2String(request.getParameter("departmentid")).split(",")[1]);
            am.grantDirPermission1(categoryid, categorytype, operationcode, departmentid, seclevel);
			/*if(categorytype==2){
                UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
			}*/
            //response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
            response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        }
        /* end */
        break;

        case 6:
            int ismutilsub = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
		    String includesub1 = Util.getIntValue(request.getParameter("includesub1"),0)+"";
    	    am.setIncludesub(includesub1);
            if(ismutilsub!=0) {


            	/*if(categorytype==2){
    			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
    			}*/
    			
                String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("subcompanyid")),",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid = Util.getIntValue(Util.null2o(tempStrs[k]));                  
                        am.grantDirPermission6(categoryid, categorytype, operationcode, subcompanyid, seclevel);
                }
    			/*if(categorytype==2){
                    UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
    			}*/

               // response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
               response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
            } else {

    			/*if(categorytype==2){
    			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
    			}*/
                int subcompanyid = Integer.parseInt(Util.null2String(request.getParameter("subcompanyid")).split(",")[1]);
                am.grantDirPermission6(categoryid, categorytype, operationcode, subcompanyid, seclevel);
    			/*if(categorytype==2){
                    UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
    			}*/
                //response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
                response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid);
            }
            break;
        
        case 2:        
        int roleid = Integer.parseInt(Util.null2String(request.getParameter("roleid")));
        int rolelevel = Integer.parseInt(Util.null2String(request.getParameter("rolelevel")));

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        am.grantDirPermission2(categoryid, categorytype, operationcode, roleid, rolelevel, seclevel);
		/*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
	    //response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
	    response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;

        case 3:

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        am.grantDirPermission3(categoryid, categorytype, operationcode, seclevel);
		/*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
	    //response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
	    response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;

        case 4:

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        int usertype = Integer.parseInt(Util.null2String(request.getParameter("usertype")));
        am.grantDirPermission4(categoryid, categorytype, operationcode, usertype, seclevel);
		/*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
	    //response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
	    response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;

        case 5:

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        String[] tmpuserid = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
        int userid = 0;
        for(int i=0;tmpuserid!=null&&tmpuserid.length>0&&i<tmpuserid.length;i++){
        	userid = Util.getIntValue(tmpuserid[i]);
        	if(userid>0) am.grantDirPermission5(categoryid, categorytype, operationcode, userid);
        }
        response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
        break;
        case 7:
        String jobids=Util.null2String(request.getParameter("jobtitleid"));
        String departmentid1=Util.null2String(request.getParameter("departmentid1"));
        String joblevel=Util.null2String(request.getParameter("createsubtype"));
        String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
        am.grantDirPermission8(categoryid, categorytype, operationcode, jobids, joblevel, departmentid1,subcompanyid1);
        response.sendRedirect("/docs/category/AddCategoryPermission.jsp?isclose=1&categorytype="+categorytype+"&categoryid="+categoryid+"&operationcode="+operationcode);
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
	String url = CategoryUtil.getCategoryEditPageNew(categorytype, categoryid,operationcode);
	if(isDialog.equals("1")){
		url+="&isdialog=1";
	}
	response.sendRedirect(url);
	return;
}
%>