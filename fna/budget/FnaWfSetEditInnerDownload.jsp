<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.xml.bind.JAXBContext" %>
<%@ page import="javax.xml.bind.Marshaller" %>
<%@ page import="javax.xml.bind.JAXBException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="weaver.fna.domain.wfset.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%!


    private void getData(int id,JspWriter out) throws JAXBException, IOException {
        RecordSet recordSet = new RecordSet();
        //查询相应的信息
        List<FnaFeeWfInfo> infos = FnaFeeWfInfo.queryById(id,recordSet);
        List<FnaFeeWfInfoField> fields = FnaFeeWfInfoField.queryByMainId(id,recordSet);
        List<FnaFeeWfInfoLogic> logins = FnaFeeWfInfoLogic.querySchemeDel(recordSet, id);
        List<FnaFeeWfInfoLogicReverse> reverses = FnaFeeWfInfoLogicReverse.queryByMainId(id,recordSet);
        List<FnaFeeWfInfoNodeCtrl> ctrls = FnaFeeWfInfoNodeCtrl.queryByMainId(id,recordSet);
        List<FnaControlSchemeFeeWfInfo> wfInfos = FnaControlSchemeFeeWfInfo.queryById(id,recordSet);
        if (infos != null) {
            FnaFeeWfInfo info = infos.get(0);
            Result result = new Result();
            result.setInfo(info);
            result.setInfoField(fields);
            result.setLogins(logins);
            result.setReverses(reverses);
            result.setCtrls(ctrls);
            result.setWfInfo(wfInfos);
            render(result, out);
        }
    }

    private void render(Result scheme, JspWriter out) throws JAXBException, IOException {
        JAXBContext context = JAXBContext.newInstance(Result.class);
        Marshaller marshaller = context.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
        ByteArrayOutputStream byteOutputStream = new ByteArrayOutputStream();
        marshaller.marshal(scheme, byteOutputStream);
        out.clear();
        out.write(byteOutputStream.toString("UTF-8"));
        out.flush();
        out.close();
    }

%>
<%
    if(!HrmUserVarify.checkUserRight("CostControlProcedure:set", user)){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }

    /**
     * 得到前台传递的参数
     */
    int id = Util.getIntValue(request.getParameter("id"),-1);
    try {
        response.setContentType("application/vnd.ms-excel;charset=UTF-8");
        response.setHeader("Pragma", "public");
        response.addHeader("Content-Disposition", "attachment;filename=FnaFeeWfInfo.xml");
        getData(id,out);
    } catch (Exception e) {
        e.printStackTrace();
    }

%>
