<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="javax.xml.bind.JAXBContext" %>
<%@ page import="javax.xml.bind.Marshaller" %>
<%@ page import="javax.xml.bind.JAXBException" %>
<%@ page import="weaver.fna.domain.FnaControlScheme" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="weaver.fna.domain.FnaControlSchemeDtl" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="weaver.fna.domain.Result" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%!
    private Result execute(String ids) {
        RecordSet rs = new RecordSet();
        List<FnaControlScheme> fnaControlSchemeList = queryScheme(rs, ids);
        List<FnaControlSchemeDtl> fnaControlSchemeDtlList = querySchemeDel(rs, ids);
        Result scheme = new Result();
        scheme.setSchemes(fnaControlSchemeList);
        scheme.setSchemeDetails(fnaControlSchemeDtlList);
        return scheme;
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

    private List<FnaControlSchemeDtl> querySchemeDel(RecordSet rs, String ids) {
        RecordSet rs1 = new RecordSet();
        String msg = "SELECT ID,MAINID,KMIDSCONDITION,KMIDS,ORGTYPE,ORGIDSCONDITION,ORGIDS,INTENSITY,PROMPTSC,PROMPTTC,PROMPTEN FROM  FnaControlSchemeDtl WHERE 1=1 ";
        if (StringUtils.isNotBlank(ids)) {
            msg += " AND mainID IN(" + StringEscapeUtils.escapeSql(ids) + ")";
        }
        new BaseBean().writeLog(msg);
        List<FnaControlSchemeDtl> fnaControlSchemeDtlList = new ArrayList<FnaControlSchemeDtl>();
        rs.executeQuery(msg);
        while (rs.next()) {
            FnaControlSchemeDtl fnaControlSchemeDtl = new FnaControlSchemeDtl();
            fnaControlSchemeDtl.setId(rs.getInt("ID"));
            fnaControlSchemeDtl.setMainId(rs.getInt("MAINID"));
            fnaControlSchemeDtl.setKmIdsCondition(rs.getInt("KMIDSCONDITION"));
            /**
             * 如果kmid不为空的话，那么我们就去数据库中查询该id对应的科目的名称和编码，然后将其存入我们的对象中。
             */
            String kmids = rs.getString("KMIDS");
            if(StringUtils.isNotBlank(kmids)) {
                kmids = kmids.replaceAll("^,","");
                fnaControlSchemeDtl.queryKmCodeAndName(kmids,rs1);
            }
            fnaControlSchemeDtl.setOrgType(rs.getInt("ORGTYPE"));
            fnaControlSchemeDtl.setOrgIdsCondition(rs.getInt("ORGIDSCONDITION"));
            /**
             * 如果orgIds不为空的话，那么我们就去数据库中查询该id对应的费用单位的名称和编码，然后将其存入我们的对象中。
             */
            String orgIds = rs.getString("ORGIDS");
            if(StringUtils.isNotBlank(orgIds)) {
                orgIds = orgIds.replaceAll("^,","");
                fnaControlSchemeDtl.queryOrgCodeAndName(orgIds,rs1);
            }
            fnaControlSchemeDtl.setIntensity(rs.getInt("INTENSITY"));
            fnaControlSchemeDtl.setPromptSC(rs.getString("PROMPTSC"));
            fnaControlSchemeDtl.setPromptTC(rs.getString("PROMPTTC"));
            fnaControlSchemeDtl.setPromptEN(rs.getString("PROMPTEN"));
            fnaControlSchemeDtlList.add(fnaControlSchemeDtl);
        }
        return fnaControlSchemeDtlList;
    }

    private List<FnaControlScheme> queryScheme(RecordSet rs, String ids) {
        String msg = "SELECT ID,NAME,CODE,FNAYEARID,FNAYEARIDEND,ENABLED FROM  FnaControlScheme WHERE 1=1 ";
        if (StringUtils.isNotBlank(ids)) {
            msg += " AND ID IN(" + StringEscapeUtils.escapeSql(ids) + ")";
        }
        List<FnaControlScheme> fnaControlSchemeList = new ArrayList<FnaControlScheme>();
        rs.executeQuery(msg);
        while (rs.next()) {
            FnaControlScheme fnaControlScheme = new FnaControlScheme();
            fnaControlScheme.setId(rs.getInt("ID"));
            fnaControlScheme.setName(rs.getString("NAME"));
            fnaControlScheme.setCode(rs.getString("CODE"));
            fnaControlScheme.setFnaYearId(rs.getInt("FNAYEARID"));
            fnaControlScheme.setFnaYearIdEnd(rs.getInt("FNAYEARIDEND"));
            fnaControlScheme.setEnabled(rs.getInt("ENABLED"));
            fnaControlSchemeList.add(fnaControlScheme);
        }
        return fnaControlSchemeList;
    }
%>
<%
    boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add", user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit", user);
    if (!canEdit) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

    /**
     * 得到前台传递的参数
     */
    String type = request.getParameter("type");
    String ids = "";
    if (type != null && type.equalsIgnoreCase("select")) {
        ids = request.getParameter("ids");
        /**
         * 对ids进行处理
         */
        ids = ids.substring(0, ids.length() - 1);
    }
    Result scheme = execute(ids);
    try {
        response.setContentType("application/vnd.ms-excel;charset=UTF-8");
        response.setHeader("Pragma", "public");
        response.addHeader("Content-Disposition", "attachment;filename=controlScheme.xml");
        render(scheme, out);
    } catch (Exception e) {
        e.printStackTrace();
    }

%>
