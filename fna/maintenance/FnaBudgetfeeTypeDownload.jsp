<%@page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="weaver.file.ExcelSheet" %>
<%@ page import="weaver.file.ExcelFile" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.fna.general.ExcelUtils" %>
<%@ page import="weaver.fna.general.IExcelSheet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%!
    private void secondSheet(ExcelUtils excelUtils,RecordSet rs, User user) {
        //把第一行的头放入到excel中去。
        String[] titles = {SystemEnv.getHtmlLabelName(15409,user.getLanguage()),//科目名称
        		SystemEnv.getHtmlLabelName(21108,user.getLanguage()),//科目编码
        		SystemEnv.getHtmlLabelNames("596,15409",user.getLanguage()),//上级科目名称
        		SystemEnv.getHtmlLabelNames("596,21108",user.getLanguage()),//上级科目编码
        		SystemEnv.getHtmlLabelName(15388,user.getLanguage()),//预算周期
        		SystemEnv.getHtmlLabelName(130715,user.getLanguage()),//预算可为负数
        		SystemEnv.getHtmlLabelName(128826,user.getLanguage()),//可编制预算
        		SystemEnv.getHtmlLabelName(32099,user.getLanguage()),//下级统一费控
        		SystemEnv.getHtmlLabelName(30786,user.getLanguage()),//是否结转
        		SystemEnv.getHtmlLabelName(602,user.getLanguage()),//状态
        		SystemEnv.getHtmlLabelName(18429,user.getLanguage()),//科目预警值
        		SystemEnv.getHtmlLabelName(15389,user.getLanguage()),//允许偏差
        		SystemEnv.getHtmlLabelName(15385,user.getLanguage()),//收支类型
        		SystemEnv.getHtmlLabelName(433,user.getLanguage()),//描述
        		SystemEnv.getHtmlLabelName(15513,user.getLanguage()),//显示顺序
        		SystemEnv.getHtmlLabelName(132177,user.getLanguage())//会计科目编码
        		
        	};
        excelUtils.setTitles(titles);
        excelUtils.setDataColumns(new String[]{"name","codeName","pname", "pid", "feeperiod","budgetCanBeNegative", "isEditFeeType", "groupCtrl", "budgetAutoMove", "Archive", "alertvalue", "agreegap", "feetype", "description","displayOrder","codeName2"});
        final String sheetName = "导入科目";
        excelUtils.addSheet(new IExcelSheet() {
            public void init(Map<String, ExcelSheet> sheetMap,ExcelFile excelFile) {
                ExcelSheet sheet = new ExcelSheet();
                excelFile.addSheet(sheetName,sheet);
                sheetMap.put(sheetName,sheet);
            }
        });
        excelUtils.makeSheet(sheetName, rs);
    }

    private void firstSheet(ExcelUtils excelUtils, User user) {
        String[] titles = new String[]{"",
        		SystemEnv.getHtmlLabelName(15409,user.getLanguage()),//科目名称
        		SystemEnv.getHtmlLabelName(21108,user.getLanguage()),//科目编码
        		SystemEnv.getHtmlLabelNames("596,15409",user.getLanguage()),//上级科目名称
        		SystemEnv.getHtmlLabelNames("596,21108",user.getLanguage()),//上级科目编码
        		SystemEnv.getHtmlLabelName(15388,user.getLanguage()),//预算周期
        		SystemEnv.getHtmlLabelName(130715,user.getLanguage()),//预算可为负数
        		SystemEnv.getHtmlLabelName(128826,user.getLanguage()),//可编制预算
        		SystemEnv.getHtmlLabelName(32099,user.getLanguage()),//下级统一费控
        		SystemEnv.getHtmlLabelName(30786,user.getLanguage()),//是否结转
        		SystemEnv.getHtmlLabelName(602,user.getLanguage()),//状态
        		SystemEnv.getHtmlLabelName(18429,user.getLanguage()),//科目预警值
        		SystemEnv.getHtmlLabelName(15389,user.getLanguage()),//允许偏差
        		SystemEnv.getHtmlLabelName(15385,user.getLanguage()),//收支类型
        		SystemEnv.getHtmlLabelName(433,user.getLanguage()),//描述
        		SystemEnv.getHtmlLabelName(15513,user.getLanguage()),//显示顺序
        		SystemEnv.getHtmlLabelName(132177,user.getLanguage())//会计科目编码
        	};
        String[] values = new String[]{
        		SystemEnv.getHtmlLabelName(128884,user.getLanguage()),//"导入说明",
        		SystemEnv.getHtmlLabelName(128885,user.getLanguage()),//"预算科目名称（必填）",
        		SystemEnv.getHtmlLabelName(128886,user.getLanguage()),//"预算科目编码（当科目编码作为重复验证字段时，该字段必填）",
        		SystemEnv.getHtmlLabelName(128887,user.getLanguage()),//"预算科目名称（当科目名称作为重复验证字段时，且该科目非一级科目时，该字段必填）",
        		SystemEnv.getHtmlLabelName(128888,user.getLanguage()),//"预算科目编码（当科目编码作为重复验证字段时，且该科目非一级科目时，该字段必填）",
        		SystemEnv.getHtmlLabelName(128889,user.getLanguage()),//"可选值：每月、每季度、每半年、每年（一级科目必填）",
        		SystemEnv.getHtmlLabelName(130836,user.getLanguage()),//"下级统一费控的科目必填，可选值：是、否。为是时，是否结转必须为否"
        		SystemEnv.getHtmlLabelName(128890,user.getLanguage()),//"同一科目上下级条线中只有一个科目可以开启可编制预算选项",
        		SystemEnv.getHtmlLabelName(128918,user.getLanguage()),//"在开启了可编制预算的科目及其上级科目中，只有一个科目可以开启（且必须有一个开启）下级统一费控选项",
        		SystemEnv.getHtmlLabelName(128950,user.getLanguage()),//"下级统一费控的科目必填，可选值：是、否",
        		SystemEnv.getHtmlLabelName(128892,user.getLanguage()),//"可选值：未封存、已封存（为空表示未封存）",
        		SystemEnv.getHtmlLabelName(128893,user.getLanguage()),//"整数",
        		SystemEnv.getHtmlLabelName(128893,user.getLanguage()),//"整数",
        		SystemEnv.getHtmlLabelName(128894,user.getLanguage()),//"可选值：收入、支出（为空表示支出）",
        		SystemEnv.getHtmlLabelName(128895,user.getLanguage()),//"文本",
        		SystemEnv.getHtmlLabelName(128896,user.getLanguage()),//"整数部分最多三位，小数部分最多三位的数字（可为负数）"
        		SystemEnv.getHtmlLabelName(128895,user.getLanguage())//"文本",
        };
        final String sheetName = SystemEnv.getHtmlLabelName(33803, user.getLanguage());
        excelUtils.addSheet(new IExcelSheet() {
            public void init(Map<String, ExcelSheet> sheetMap,ExcelFile excelFile) {
                ExcelSheet sheet = new ExcelSheet();
                sheet.addColumnwidth(6000);
                sheet.addColumnwidth(30000);
                excelFile.addSheet(sheetName,sheet);
                sheetMap.put(sheetName,sheet);
            }
        });
        excelUtils.makeSheet(sheetName,titles, values);
    }

    public void downloadExcel(ExcelUtils excelUtils,User user,RecordSet rs) {
        firstSheet(excelUtils, user);
        secondSheet(excelUtils,rs, user);
        //设置excel文件的名字
        excelUtils.getExcelFile().setFilename("FnaBudgetTypeBatchImp" );
    }

    public RecordSet query(String ids) {
        String sqlMsg = "SELECT fbt.id,fbt.name,fbt.codeName codeName,fbt.codeName2 codeName2,pfbt.name pname,pfbt.codeName pid,fbt.groupDispalyOrder," +
                "  CASE WHEN fbt.feeperiod=1 and fbt.feelevel=1 THEN '每月' " +
                "  WHEN fbt.feeperiod=2 and fbt.feelevel=1 THEN '每季度' " +
                "  WHEN fbt.feeperiod=3 and fbt.feelevel=1 THEN '每半年' " +
                "  WHEN fbt.feeperiod=4 and fbt.feelevel=1 THEN '每年' " +
                " END feeperiod ," +
                "  CASE  " +
                "  WHEN fbt.budgetCanBeNegative = 1 THEN '是' " +
                "  ELSE '否' END  budgetCanBeNegative, " +//--预算可为负数
                "  CASE  " +
                "  WHEN fbt.isEditFeeType=1 THEN '是' " +
                "  ELSE '否' END  isEditFeeType, " +//--可编制预算
                "  CASE  " +
                "  WHEN fbt.groupCtrl='1' THEN '是' " +
                "  ELSE '否' END  groupCtrl, " +//--下级统一费控
                "  CASE  " +
                "  WHEN fbt.groupCtrl='1' and fbt.budgetAutoMove=1 THEN '是' " +
                "  WHEN fbt.groupCtrl='1' and (fbt.budgetAutoMove is null or fbt.budgetAutoMove=0) THEN '否' END  budgetAutoMove, " +//--是否结转
                "case fbt.Archive when 1 then '已封存' else '未封存'" +
                "end Archive, " +//--状态
                "fbt.alertvalue," +//--科目预警
                "fbt.agreegap," +//--允许偏差
                " case when (fbt.isEditFeeType=1 and fbt.feetype=1) then '支出' when (fbt.isEditFeeType=1 and fbt.feetype=2) then '收入' else '' end feetype, " +//收支类型
                "fbt.description ," +// -- 描述
                "fbt.displayOrder "+//显示顺序
                "FROM FnaBudgetfeeType fbt left join FnaBudgetfeeType pfbt on fbt.supsubject=pfbt.id WHERE 1=1 ";
        if(StringUtils.isNotBlank(ids)) {
            sqlMsg += "AND fbt.id IN("+ StringEscapeUtils.escapeSql(ids)+" )" ;
        }
        sqlMsg += " order by fbt.groupDispalyOrder,fbt.feeperiod,fbt.feelevel,fbt.displayOrder,fbt.codename,fbt.name,fbt.id";
        RecordSet rs = new RecordSet();
        rs.executeQuery(sqlMsg);
        return rs;
    }

%>

<%
    boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
    if(!canEdit){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }

    /**
     * 得到前台传递的参数
     *
     */
    String type = request.getParameter("type");
    RecordSet rs = null;
    if(type !=null && type.equalsIgnoreCase("all")) {
        rs = query("");
    }else if(type != null && type.equalsIgnoreCase("select")) {
        String ids = request.getParameter("ids");
        /**
         * 对ids进行处理
         */
        ids = ids.substring(0,ids.length()-1);
        rs = query(ids);
    }
    ExcelUtils excelUtils = new ExcelUtils();
    excelUtils.setExcelFile(ExcelFile);
    downloadExcel(excelUtils,user,rs);
%>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script type="text/javascript">
    var iframe_ExcelOut = document.getElementById("ExcelOut");
    iframe_ExcelOut.src = "/weaver/weaver.file.ExcelOut";
</script>