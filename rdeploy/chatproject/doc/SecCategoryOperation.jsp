<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page
	import="weaver.general.Util,weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ page import="weaver.docs.category.*"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocTreelistComInfo"
	class="weaver.docs.category.DocTreelistComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo"
	class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo"
	class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo"
	class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog"
	scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo"
	class="weaver.docs.category.SecCategoryDocPropertiesComInfo"
	scope="page" />
<jsp:useBean id="SecCategoryCustomSearchComInfo"
	class="weaver.docs.category.SecCategoryCustomSearchComInfo"
	scope="page" />
<jsp:useBean id="SecShareableCominfo"
	class="weaver.docs.docs.SecShareableCominfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
//编辑权限验证
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

    //操作类型，添加/删除设置
    String operation = Util.null2String(request.getParameter("operation"));
    //分割符
    char flag = Util.getSeparator();
    //用户ID
    int userid = user.getUID();

    //权限模型
    MultiAclManager am = new MultiAclManager();
    //目录管理类
    CategoryManager cm = new CategoryManager();
    //是否是弹出框
    String isDialog = Util.null2String(request.getParameter("isdialog"));

    if (operation.equalsIgnoreCase("add")) {
        int secid = -1;
        String categoryname = Util.fromScreen(request.getParameter("categoryname"), user.getLanguage()).trim();
        if (!HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) && !am.hasPermission(-1, MultiAclManager.CATEGORYTYPE_SUB, user, MultiAclManager.OPERATION_CREATEDIR)) {
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
        //是否已存在 start
        String checkSql = "select count(id) from DocSecCategory where categoryname = '" + categoryname + "'";
        checkSql = checkSql + " and (parentid is null or parentid<=0) ";
        RecordSet.executeSql(checkSql);
        if (RecordSet.next()) {
            if (RecordSet.getInt(1) > 0) {
                response.sendRedirect("DocSecCategoryAdd.jsp?isdialog=" + isDialog + "&errorcode=10");
                return;
            }
        }
        //end
        //install sql
        String insertSql = "INSERT INTO DocSecCategory (" + "subcategoryid, categoryname, docmouldid, publishable, replyable," + " shareable,cusertype, cuserseclevel, cdepartmentid1, cdepseclevel1," + " cdepartmentid2, cdepseclevel2, croleid1, crolelevel1, croleid2,"
                + " crolelevel2, croleid3, crolelevel3, hasaccessory, accessorynum, hasasset, " + "assetlabel, hasitems, itemlabel, hashrmres, hrmreslabel, hascrm, crmlabel," + " hasproject, projectlabel, hasfinance, financelabel, approveworkflowid, markable,"
                + " markAnonymity, allownModiMShareL, allownModiMShareW, maxUploadFileSize, wordmouldid," + " coder, isSetShare, nodownload, norepeatedname, iscontroledbydir, puboperation, childdocreadremind,"
                + " readoptercanprint, editionIsOpen, editionPrefix, readerCanViewHistoryEdition, isOpenApproveWf, " + "validityApproveWf, invalidityApproveWf, useCustomSearch, appliedTemplateId, defaultDummyCata,"
                + " logviewtype, secorder, appointedWorkflowId, isPrintControl, printApplyWorkflowId, isLogControl," + " maxOfficeDocFileSize, isuser, e8number, parentid, dirid, dirType, subcompanyid)" + " VALUES (0, '" + categoryname
                + "', 0, '0', '0', '0', '0', 0, 0, 0, 0, 0, 0, ' ', 0, ' ', 0, ' ', '0', 0, ' ', '', ' ', '', ' ', " + "'', ' ', '', ' ', '', ' ', '', 0, '0', '0', 0, 0, 10, 0, NULL, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, "
                + "NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, ' ', 8, NULL, NULL, 0, 15, 0, -1)";
        try {
            RecordSet.executeSql(insertSql);
        } catch (Exception e) {
            response.sendRedirect("DocSecCategoryAdd.jsp?isdialog=" + isDialog + "&errorcode=11");
        }

        String selSql = "SELECT id from DocSecCategory where categoryname = '" + categoryname + "' and parentid = 0";
        RecordSet.executeSql(selSql);
        if (!RecordSet.next()) {
            response.sendRedirect("DocSecCategoryAdd.jsp?isdialog=" + isDialog + "&errorcode=11");
            return;
        }
        int id = RecordSet.getInt(1);
        int newid = RecordSet.getInt(1);
        SecShareableCominfo.addSecShareInfoCache("" + id);
        secid = newid;
        cm.addSecidToSuperiorSubCategory(newid);
        log.resetParameter();
        log.setRelatedId(newid);
        log.setRelatedName(categoryname);
        log.setOperateType("1");
        log.setOperateDesc("Doc_SecCategory_Insert");
        log.setOperateItem("3");
        log.setOperateUserid(userid);
        log.setClientAddress(request.getRemoteAddr());
        log.setSysLogInfo();

        //TD2858 新的需求: 添加与文档创建人相关的默认共享  开始  
        /**
        String strSqlInsert ="insert into secCreaterDocPope (secid,PCreater,PCreaterManager,PCreaterJmanager,PCreaterDownOwner,"+
                            "PCreaterSubComp,PCreaterDepart,PCreaterDownOwnerLS,PCreaterSubCompLS,"+
                            "PCreaterDepartLS,PCreaterW,PCreaterManagerW,PCreaterJmanagerW) values ("+newid+","+PCreater+","+PCreaterManager+","+PCreaterJmanager+","+PCreaterDownOwner+","+
                            PCreaterSubComp+","+PCreaterDepart+","+PCreaterDownOwnerLS+","+PCreaterSubCompLS+","+
                            PCreaterDepartLS+","+PDocCreaterW+","+PCreaterManagerW+","+PCreaterJmanagerW+")";
        
        RecordSet.executeSql(strSqlInsert);  
         */
        //添加可见范围
        am.setSeclevelmax("255");
        am.grantDirPermission4(newid, MultiAclManager.CATEGORYTYPE_SEC, MultiAclManager.OPERATION_CREATEDOC, 0, 0);
        //添加所有人为默认共享
        String ProcPara = "" + newid;
        ProcPara += flag + "5";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "1";
        ProcPara += flag + "3";
        ProcPara += flag + "0";
        ProcPara += flag + "255";
        ProcPara += flag + "";
        ProcPara += flag + "";
        ProcPara += flag + "1";
        RecordSet.executeProc("DocSecCategoryShare_Ins_G", ProcPara);

        //创建人本人
        ProcPara = "" + newid;
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "";
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "1";
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "255";
        ProcPara += flag + "";
        ProcPara += flag + "";
        ProcPara += flag + "1";
        RecordSet.executeProc("DocSecCategoryShare_Ins_G", ProcPara);

        //创建人直接上级
        ProcPara = "" + newid;
        ProcPara += flag + "2";
        ProcPara += flag + "0";
        ProcPara += flag + "";
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "0";
        ProcPara += flag + "1";
        ProcPara += flag + "1";
        ProcPara += flag + "0";
        ProcPara += flag + "255";
        ProcPara += flag + "";
        ProcPara += flag + "";
        ProcPara += flag + "1";
        RecordSet.executeProc("DocSecCategoryShare_Ins_G", ProcPara);

        //更新cache
        MainCategoryComInfo.removeMainCategoryCache();
        SubCategoryComInfo.removeMainCategoryCache();
        SecCategoryComInfo.removeMainCategoryCache();
        SecCategoryDocPropertiesComInfo.removeCache();
        SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(secid);
        DocTreelistComInfo.removeGetDocListInfordCache();
        //跳转并刷新列表页面
        response.sendRedirect("DocSecCategoryAdd.jsp?isclose=1&secId=" + secid + "&reftree=1");

    } else if (operation.equalsIgnoreCase("delete")) {
        int id = Util.getIntValue(request.getParameter("id"), 0);
        String categoryname = SecCategoryComInfo.getSecCategoryname("" + id);
        int parentid = Util.getIntValue(SecCategoryComInfo.getParentId("" + id));
        if (!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Delete", user) && !am.hasPermission(parentid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR)) {
            if (isDialog.equals("1")) {
                response.getWriter().print("-1");//无权限
                return;
            } else {
                response.sendRedirect("/notice/noright.jsp");
                return;
            }
        }

        String message = "";

        String checksql = "select id from docdetail where seccategory=" + id;
        RecordSet.executeSql(checksql);
        if (RecordSet.next()) {
            message = "87";
        } else {
            RecordSet.executeSql("SELECT * FROM WorkFlow_SelectItem WHERE docCategory LIKE '%," + id + "'");
            if (RecordSet.next()) {
                message = "87";
            } else {
                RecordSet.executeSql("SELECT * FROM WorkFlow_CreateDoc WHERE defaultView LIKE '%||" + id + "'");
                if (RecordSet.next()) {
                    message = "87";
                } else {//写作区附件上传关联文档目录
                    RecordSet.executeSql("select * from CoworkAccessory where seccategory=" + id);
                    if (RecordSet.next()) {
                        message = "87";
                    }
                    else
                    {
                        RecordSet.executeSql("select id from docseccategory where parentid = " + id);
                        if (RecordSet.next()) {
                            message = "87";
                        } 
                    }
                }

            }
        }
        
        

        if(message.equals("87"))
        {
            Map<String,String> result = new HashMap<String,String>();
        	//未登录或登录超时
        	result.put("error", "87");
            JSONObject jsonObject = JSONObject.fromObject(result);
            out.println(jsonObject.toString());
        }
        else
        {
            cm.deleteSecidFromSuperiorSubCategory(id);
            int dirid = Util.getIntValue(SecCategoryComInfo.getDirId("" + id), 0);
            int dirtype = Util.getIntValue(SecCategoryComInfo.getDirType("" + id), -1);
            if (dirid > 0) {
                if (dirtype == 0) {
                    RecordSet.executeSql("delete from DocMainCategory where id=" + dirid);
                    RecordSet.executeSql("delete from DocMainCatFTPConfig where mainCategoryId=" + dirid);
                    am.clearPermissionOfDir(dirid, MultiAclManager.CATEGORYTYPE_MAIN);
                } else if (dirtype == 1) {
                    RecordSet.executeSql("delete from DocSubCategory where id=" + dirid);
                    RecordSet.executeSql("delete from DocSubCatFTPConfig where subCategoryId=" + dirid);
                    am.clearPermissionOfDir(dirid, MultiAclManager.CATEGORYTYPE_SUB);
                }
            }
            RecordSet.executeProc("Doc_SecCategory_Delete", id + "");
            SecShareableCominfo.deleteDocInfoCache("" + id);

            am.clearPermissionOfDir(id, MultiAclManager.CATEGORYTYPE_SEC);

            CustomFieldManager cfm = new CustomFieldManager("DocCustomFieldBySecCategory", id);
            cfm.delete();

            log.resetParameter();
            log.setRelatedId(id);
            log.setRelatedName(categoryname);
            log.setOperateType("3");
            log.setOperateDesc("Doc_SecCategory_Delete");
            log.setOperateItem("3");
            log.setOperateUserid(userid);
            log.setClientAddress(request.getRemoteAddr());
            log.setSysLogInfo();

            RecordSet.executeSql("delete from DocSecCatFTPConfig where secCategoryId=" + id);

            MainCategoryComInfo.removeMainCategoryCache();
            SubCategoryComInfo.removeMainCategoryCache();
            SecCategoryComInfo.removeMainCategoryCache();
            DocTreelistComInfo.removeGetDocListInfordCache();
            if (isDialog.equals("1")) {
                response.getWriter().print("0");//无权限
                return;
            } else {
                out.println("<script type='text/javascript'>parent.location.href='DocCategoryTab.jsp?_fromURL=3&id=" + parentid + "&refresh=1&reftree=1';</script>");
            }
        } 
    }
%>