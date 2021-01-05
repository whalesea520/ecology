<%@page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.fna.general.ExcelUtils" %>
<%@ page import="weaver.fna.domain.Sheet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%!
    private static final String[] SQL_MSG = new String[]{
            "SELECT A.NAME,A.CODE,C.SUBCOMPANYNAME GLNAME,C.SUBCOMPANYCODE GLCODE,C.ID FROM FNACOSTCENTER A JOIN  FNACOSTCENTERDTL B ON A.ID=B.FCCID JOIN HRMSUBCOMPANY C ON C.ID=B.OBJID WHERE B.TYPE=1 ",
            "SELECT A.NAME,A.CODE,C.DEPARTMENTNAME GLNAME,C.DEPARTMENTCODE GLCODE,C.ID FROM FNACOSTCENTER A JOIN  FNACOSTCENTERDTL B ON A.ID=B.FCCID JOIN HRMDEPARTMENT C ON C.ID=B.OBJID WHERE B.TYPE=2 ",
            "SELECT A.NAME,A.CODE,C.LASTNAME GLNAME,C.WORKCODE GLCODE,C.ID FROM FNACOSTCENTER A JOIN  FNACOSTCENTERDTL B ON A.ID=B.FCCID JOIN HRMRESOURCE C ON C.ID=B.OBJID WHERE B.TYPE=3 ",
            "SELECT A.NAME,A.CODE,C.NAME GLNAME,C.CRMCODE GLCODE,C.ID FROM FNACOSTCENTER A JOIN  FNACOSTCENTERDTL B ON A.ID=B.FCCID JOIN CRM_CUSTOMERINFO C ON C.ID=B.OBJID WHERE B.TYPE=4 ",
            "SELECT A.NAME,A.CODE,C.NAME GLNAME,C.PROCODE GLCODE,C.ID FROM FNACOSTCENTER A JOIN  FNACOSTCENTERDTL B ON A.ID=B.FCCID JOIN PRJ_PROJECTINFO C ON C.ID=B.OBJID WHERE B.TYPE=5 "
    };

    private static final String[] SQL_COLUMNS = new String[]{"name","code","glname", "glcode","id"};
    /**
     * 查询成本中心
     */
    private List<String[]> queryCbxz(RecordSet rs) {
        StringBuilder cbzx = new StringBuilder();
        cbzx.append("select a.name,a.code,b.name pname,b.code pcode, ")
                .append("case a.type when 0 then '类别' when 1 then '成本中心' else '' end type, ")
                .append("case a.Archive when 1 then '封存'  else '未封存' end Archive, ")
                .append("a.description  ")
                .append("from fnacostcenter a left join FnaCostCenter b on a.supFccId=b.id WHERE 1=1 ");

        String[] cbzxColumns = {"name", "code", "pname", "pcode", "type", "Archive", "description"};
        List<String[]> cbxzList = execute(cbzx.toString(), rs, cbzxColumns);
        return cbxzList;
    }

    private String ids;

    private void otherSheet(ExcelUtils excelUtils) {
        List<Sheet> sheets = new ArrayList<Sheet>();
        Sheet sheet1 = new Sheet();
        sheet1.setName("导入说明");
        firstSheet(sheet1);
        sheets.add(sheet1);

        RecordSet rs = new RecordSet();
        Sheet sheet2 = new Sheet();
        sheet2.setName("导入成本中心")
                .setTitles(new String[]{"名称", "编码", "上级类别名称", "上级类别编码", "类型", "状态", "描述"})
                .setData(queryCbxz(rs));
        sheets.add(sheet2);

        Sheet sheet3 = new Sheet();
        sheet3.setName("关联对象(分部)")
                .setTitles(new String[]{"成本中心名称", "成本中心编码", "分部名称", "分部编码", "分部ID"})
                .setData(execute(SQL_MSG[0],rs,SQL_COLUMNS));
        sheets.add(sheet3);

        Sheet sheet4 = new Sheet();
        sheet4.setName("关联对象(部门)")
                .setTitles(new String[]{"成本中心名称", "成本中心编码", "部门名称", "部门编码", "部门ID"})
                .setData(execute(SQL_MSG[1], rs, SQL_COLUMNS));
        sheets.add(sheet4);

        Sheet sheet5 = new Sheet();
        sheet5.setName("关联对象(人员)")
                .setTitles(new String[]{"成本中心名称", "成本中心编码", "人员名称", "人员工号", "人员ID"})
                .setData(execute(SQL_MSG[2], rs, SQL_COLUMNS));
        sheets.add(sheet5);

        Sheet sheet6 = new Sheet();
        sheet6.setName("关联对象(客户)")
                .setTitles(new String[]{"成本中心名称", "成本中心编码", "客户名称", "客户编码", "客户ID"})
                .setData(execute(SQL_MSG[3], rs, SQL_COLUMNS));
        sheets.add(sheet6);

        Sheet sheet7 = new Sheet();
        sheet7.setName("关联对象(项目)")
                .setTitles(new String[]{"成本中心名称", "成本中心编码", "项目名称", "项目编码", "项目ID"})
                .setData(execute(SQL_MSG[4],rs,SQL_COLUMNS));
        sheets.add(sheet7);

        excelUtils.makeSheets(sheets);
    }

    private void firstSheet(Sheet sheet) {
        String[] titles = new String[]{"", "名称", "编码", "上级类别名称", "上级类别编码", "类型", "状态", "描述", "关联对象工作表"};
        String[] values = new String[]{
                "导入说明",
                "成本中心、类别名称（必填）",
                "成本中心、类别编码（当编码作为重复验证字段时，该字段必填）",
                "上级类别名称（当名称作为重复验证字段时，且非一级时，该字段必填）",
                "上级类别编码（当编码作为重复验证字段时，且非一级时，该字段必填）",
                "可选值：类别、成本中心（新增时必填，更新时不可填写)",
                "可选值：未封存、已封存（必填）",
                "文本",
                "关联对象（分部）、关联对象（部门）、关联对象（人员）、关联对象（客户）、关联对象（项目）：\n配置成本中心与分部、部门、人员、客户和项目的关联关系\n  当记录类型为类别时：该行记录无效\n"
        };
        List<String[]> list = new ArrayList<String[]>();
        int length = titles.length;
        for (int i = 1; i < length; i++) {
            String[] strs = {titles[i], values[i]};
            list.add(strs);
        }
        sheet.setTitles(new String[]{titles[0], values[0]})
                .setData(list)
                .set(0, 8000)
                .set(1, 30000)
                .setRowHeights(new int[]{40, 35,  35,  35,  35,  35,  35,  35,  35});
    }

    public void downloadExcel(ExcelUtils excelUtils, User user) {
        otherSheet(excelUtils);
        //设置excel文件的名字
        excelUtils.getExcelFile().setFilename("CostCenterBatchImp");
    }


    private List<String[]> execute(String sql, RecordSet rs, String[] columns) {
        if (StringUtils.isNotBlank(this.ids)) {
            sql += " AND a.id in (" + StringEscapeUtils.escapeSql(ids) + ")";
        }
        List<String[]> result = new ArrayList<String[]>();
        rs.executeQuery(sql);
        while (rs.next()) {
            String[] list = new String[columns.length];
            for (int i = 0; i < columns.length; i++) {
                list[i] = Util.null2String(rs.getString(columns[i]));
            }
            result.add(list);
        }
        return result;
    }
%>

<%
    if (!HrmUserVarify.checkUserRight("BudgetCostCenter:maintenance", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }


    /**
     * 得到前台传递的参数
     *
     */
    String type = request.getParameter("type");
    List<Map<String, Object>> dataList = null;
    if (type != null && type.equalsIgnoreCase("all")) {
        /*dataList = query("");*/
        this.ids = "";
    } else if (type != null && type.equalsIgnoreCase("select")) {
        String ids = request.getParameter("ids");
        /**
         * 对ids进行处理
         */
        this.ids = ids.substring(0, ids.length() - 1);
    }
    ExcelUtils excelUtils = new ExcelUtils();
    excelUtils.setExcelFile(ExcelFile);
    downloadExcel(excelUtils, user);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
    var iframe_ExcelOut = document.getElementById("ExcelOut");
    iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>