<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.file.FileType"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.file.FileManage" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.io.File" %>
<%@ page import="javax.xml.bind.JAXBException" %>
<%@ page import="weaver.fna.butils.XmlUtils" %>
<%@ page import="weaver.fna.butils.JSONUtils" %>
<%@ page import="weaver.fna.domain.wfset.Result" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%!
    private String parseFile(FileUpload fu,RecordSet rs,HttpServletRequest request) throws IOException {
        String xmlfilepath = "";
        int fileid = Util.getIntValue(fu.uploadFiles("filename"), 0);
        String filename = fileid+"_"+FnaCommon.getPrimaryKeyGuid1()+".xls";
        List<String> allowTypes = new ArrayList<String>();
        allowTypes.add("xls");
        if(FileType.validateFileExt(fu.getFileName(), allowTypes)){
	        String sql = "select filerealpath, isaesencrypt, aescode from imagefile where imagefileid = " + fileid;
	        rs.executeSql(sql);
	        String uploadfilepath = "";
	        String isaesencrypt = "";
	        String aescode = "";
	        if (rs.next()) {
	            uploadfilepath = rs.getString("filerealpath");
	            isaesencrypt = Util.null2String(rs.getString("isaesencrypt"));
	            aescode = Util.null2String(rs.getString("aescode"));
	        }
	        if (!uploadfilepath.equals("")) {
	            xmlfilepath = request.getRealPath(request.getServletPath().substring(0, request.getServletPath().lastIndexOf("/"))) + "\\" + filename;
	            FileManage.copy(uploadfilepath, xmlfilepath, isaesencrypt, aescode);
	        }
        }
        return xmlfilepath;
    }
%>
<%
    boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add", user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit", user);
    if (!canEdit) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

    FileUpload fu = new FileUpload(request,false);
    String kmVali = Util.null2String(fu.getParameter("kmVali")).trim();//科目验证  0：名称 1编码
    String fkVali = Util.null2String(fu.getParameter("fkVali")).trim();//费控验证  0：名称 1编码
    String operation = Util.null2String(fu.getParameter("operation")).trim();//import
    String _guid1 = Util.null2String(fu.getParameter("_guid1")).trim();
    int keyWord = Util.getIntValue(fu.getParameter("keyWord"), -1);//为0是名称
    int impType = Util.getIntValue(fu.getParameter("impType"), -1);//0添加 1更新

    int workFlowId = Util.getIntValue(fu.getParameter("workflowid"), -1);//0添加 1更新
    request.getSession().removeAttribute("index:"+_guid1);
    request.getSession().removeAttribute("isDone:"+_guid1);

    request.getSession().setAttribute("index:"+_guid1, SystemEnv.getHtmlLabelName(34119,user.getLanguage()));//开始预备数据
    request.getSession().setAttribute("isDone:"+_guid1, "");

    if("import".equals(operation) && keyWord==0 && impType==0) {
        //得到文件
        RecordSet rs = new RecordSet();
        String xmlFilePath = parseFile(fu,rs,request);
        if(StringUtils.isNotBlank(xmlFilePath)) {//如果返回的字符串不为空
            File file = new File(xmlFilePath);
            try {
                Result result = (Result) XmlUtils.parseObject(file,Result.class);
                /**
                 * 我们先对其进行校验，校验通过然后保存
                 */
                List<String> valiResult = result.validate(rs,kmVali,fkVali,user,workFlowId);
                out.clear();
                if(valiResult.size()>0) {
                    Map<String,Object> resultMap = new HashMap<String, Object>();
                    resultMap.put("code","400");
                    resultMap.put("msg",valiResult);
                    request.getSession().setAttribute("FNA_IMPORT_ERROR",valiResult);
                    out.write("<script>parent.callbackBB("+ JSONUtils.parse(resultMap)+")</script>");
                }else {
                    result.save(rs,workFlowId);
                    out.write("<script>parent.callbackBB({\"code\":\"200\",\"msg\":\""+SystemEnv.getHtmlLabelName(25750,user.getLanguage())+"\"})</script>");
                }
            } catch (JAXBException e) {
                out.clear();
                out.write("<script>parent.callbackBB({\"code\":\"400\",\"msg\":\""+SystemEnv.getHtmlLabelName(33971,user.getLanguage())+e.getMessage()+"\"})</script>");
            }finally {
                if(file != null) {
                    file.delete();
                }
            }
        }
    }
%>
