<%@ page import="weaver.conn.RecordSetTrans" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.datacenter.InputCollect" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Calendar,java.io.File" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.conn.RecordSet" %>
<%!
    private weaver.conn.RecordSet rs = null;
    private HttpServletRequest req = null;

    private final static int REPORT_HRM_ID = 1;//按ID查询
    private final static int REPORT_INPREP_ID = 2;//按inprepId查询

	private static ThreadLocal recordSetLocal = new ThreadLocal();
	private RecordSet getRecordSet(){
		RecordSet rs = (RecordSet)recordSetLocal.get();
		if(rs == null){
			rs = new RecordSet();
			recordSetLocal.set(rs);
		}
		return rs;
	}

    private List getCanInputHrm(int inprepId) {
		RecordSet rs = getRecordSet();
        String sql = null;
        sql = "SELECT id,hrmId FROM T_InputReportHrm WHERE inprepId=" + inprepId;
        rs.executeSql(sql);
        List list1 = new ArrayList();
        Map map1 = null;
        while (rs.next()) {
            map1 = new HashMap();
            map1.put("id", Util.null2String(rs.getString("id")));
            map1.put("hrmId", Util.null2String(rs.getString("hrmId")));
            list1.add(map1);
        }
        return list1;
    }

    //InReportHrmSecurity.jsp
    private int addHrm(String hrmIds, int inprepId) {//添加录入人员
		RecordSet rs = getRecordSet();
        //Table:T_InputReportHrm
//	String[] arId=hrmIds.split(",");
        String oldHrmIds = this.getParam("oldHrmIds");
        List existList = Arrays.asList(Util.TokenizerString2(oldHrmIds, ","));
        List arId = Arrays.asList(Util.TokenizerString2(hrmIds, ","));
        String sql = null;
        int nums = 0;
        int sizes = arId.size();
        List idsList = new ArrayList();
        for (int i = 0; i < sizes; i++) {
            if (!existList.contains(arId.get(i)))
                idsList.add(arId.get(i));
        }
        sizes = idsList.size();
        for (int i = 0; i < sizes; i++) {
            sql = "INSERT INTO T_InputReportHrm(inprepId,hrmId) VALUES(" + inprepId + "," + idsList.get(i) + ")";
            rs.executeSql(sql);
        }
        idsList.clear();
        sizes = existList.size();
        for (int i = 0; i < sizes; i++) {
            if (!arId.contains(existList.get(i)))
                idsList.add(existList.get(i));
        }
        sizes = idsList.size();
        for (int i = 0; i < sizes; i++) {
            this.delHrm(inprepId, idsList.get(i).toString());
        }
        return 0;
    }

    private int delHrm(int inprepId, String hrmId) {//删除录入人员
		RecordSet rs = getRecordSet();
        String sql = null;
        sql = "SELECT id FROM T_InputReportHrm WHERE inprepId=" + inprepId + " AND hrmId=" + hrmId;
        rs.executeSql(sql);
        if (rs.next()) {
            String id = Util.null2String(rs.getString(1));
            this.delHrm(Integer.parseInt(id));
        }
        return 0;
    }

    private int delHrm(int id) {//删除录入人员
		RecordSet rs = getRecordSet();
        String sql = null;
        sql = "DELETE FROM T_InputReportHrm WHERE id=" + id;
        rs.executeSql(sql);
        sql = "DELETE FROM T_InputReportHrmFields WHERE reportHrmId=" + id;
        rs.executeSql(sql);
        sql = "select id from T_CollectSettingInfo where reporthrmid=" + id;
        rs.executeSql(sql);
        ArrayList collectids=new ArrayList();
        while(rs.next()){
            collectids.add(rs.getString("id"));
        }
        for(int i=0;i<collectids.size();i++){
            sql="delete from T_CollectTableInfo where Collectid="+collectids.get(i);
            rs.executeSql(sql);
            sql="delete from T_FieldComparisonInfo where Collectid="+collectids.get(i);
            rs.executeSql(sql);
        }
        sql = "delete from T_CollectSettingInfo where reporthrmid=" + id;
        rs.executeSql(sql);
        return 0;
    }

    public static String replaceStr(String str, String problemStr, String replace) {
        for (int i = str.lastIndexOf(problemStr); i >= 0; i = str.lastIndexOf(problemStr, i - 1)) {
            if (i == 0) str = replace + str.substring(i + 1, str.length());
            else str = str.substring(0, i) + replace + str.substring(i + 1, str.length());
        }//end for.
        return str;
    }

    private static String toSqlString(String str) {
        str = replaceStr(str, "'", "''");
        str = replaceStr(str, "\r\n", "\\r\\n");
        str = replaceStr(str, "\r", "\\r");
        str = replaceStr(str, "\n", "\\n");
        return str;
    }
    private int saveHrmSecurity(int inprepId,int id) {//保存权限信息
		RecordSet rs = getRecordSet();
        //inprepId,crmId,hrmId,workflowId,canViewFields
        String crmIds = this.getParam("crmIds");
        String flowId = this.getParam("flowId");
        flowId = flowId.equalsIgnoreCase("") ? "0" : flowId;
        String templateFname = toSqlString(this.getParam("modulefilename"));
        RecordSetTrans rst = new RecordSetTrans();
        rst.setAutoCommit(false);
        try {
            StringBuffer sql = new StringBuffer("");
            sql.append("UPDATE T_InputReportHrm SET ");
            sql.append("crmId='" + crmIds + "'");
            sql.append(",workflowId=" + flowId);
            sql.append(",moduleFileName='" + templateFname + "'");
            sql.append(" WHERE id=" + id);
            rst.executeSql(sql.toString());

            String sql2 = null;

            sql2 = "DELETE FROM T_InputReportHrmFields WHERE reportHrmId=" + id;
            rst.executeSql(sql2);//先删除原先的字段ID

            String[] fields = req.getParameterValues("fieldIds");

            if (fields != null)
                for (int i = 0; i < fields.length; i++) {//插入新的字段ID
                    sql2 = "INSERT INTO T_InputReportHrmFields(reportHrmId,fieldId) ";
                    sql2 += "VALUES(" + id + "," + fields[i] + ")";
                    rst.executeSql(sql2);
                }

            //汇总设置处理
            //先删除在插入
            sql2 = "select id from T_CollectSettingInfo where reporthrmid=" + id;
            rs.executeSql(sql2);
            while (rs.next()) {
                sql2 = "delete from T_CollectTableInfo where Collectid=" + rs.getInt(1);
                rst.executeSql(sql2);
                sql2 = "delete from T_FieldComparisonInfo where Collectid=" + rs.getInt(1);
                rst.executeSql(sql2);
            }
            sql2 = "delete from T_CollectSettingInfo where reporthrmid=" + id;
            rst.executeSql(sql2);

            int totalrow = Util.getIntValue(req.getParameter("totalvalue"),0);
            for(int i=0;i<totalrow;i++){
                String collectcrmid=Util.null2String(req.getParameter("crmIds_"+i));
                int cycle=Util.getIntValue(req.getParameter("cycle_"+i),0);
                int tablenum=Util.getIntValue(req.getParameter("tablenum_"+i),0);
                int fieldnum=Util.getIntValue(req.getParameter("fieldnum_"+i),0);
                String sortfields=Util.convertInput2DB(Util.null2String(req.getParameter("sortfields_"+i)));
                String sqlwhere_=Util.null2String(req.getParameter("sqlwhere_"+i));
                if(!collectcrmid.trim().equals("")){
                    sql2="insert into T_CollectSettingInfo(reporthrmid,crmids,cycle,sortfields,sqlwhere) values("+id+
                            ",'"+collectcrmid+"','"+cycle+"','"+sortfields+"','"+sqlwhere_+"')";
                    rst.executeSql(sql2);
                    sql2="select max(id) from T_CollectSettingInfo";
                    rst.executeSql(sql2);
                    rst.next();
                    int collectid=rst.getInt(1);
                    for(int j=0;j<tablenum;j++){
                        String tableid=Util.null2String(req.getParameter("tableid_"+i+"_"+j));
                        String tablealia=Util.null2String(req.getParameter("tablealia_"+i+"_"+j));
                        if(!tableid.trim().equals("")){
                            sql2="insert into T_CollectTableInfo(Collectid,inprepid,tablealia) values("+collectid+","+tableid+",'"+tablealia+"')";
                            rst.executeSql(sql2);
                        }
                    }
                    for(int j=0;j<fieldnum;j++){
                        String sourcefield=Util.null2String(req.getParameter("sourcefield"+i+"_"+j));
                        String desfield=Util.null2String(req.getParameter("desfield"+i+"_"+j));
                        if(!sourcefield.trim().equals("") && !desfield.trim().equals("")){
                            sql2="insert into T_FieldComparisonInfo(Collectid,sourcefield,desfield) values("+collectid+",'"+sourcefield+"','"+desfield+"')";
                            rst.executeSql(sql2);
                        }
                    }
                }
            }
            rst.commit();
            weaver.datacenter.InputReportModuleFile moduleFile=new weaver.datacenter.InputReportModuleFile();
            moduleFile.createTextFile(inprepId,id);//生成*.Txt格式模板文件
            moduleFile.createExcelFile(inprepId,id);//生成*.xls格式的模板文件
        } catch (Exception e) {
            rst.rollback();
            return 1;
        }
        return 0;
    }

    private Map readInputReportHrm() {//从RecordSet中读取一行.
		RecordSet rs = getRecordSet();
        Map map1 = new HashMap();
        map1.put("id", Util.null2String(rs.getString(1)));
        map1.put("inprepId", Util.null2String(rs.getString(2)));
        map1.put("crmIds", Util.null2String(rs.getString(3)));
        map1.put("hrmId", Util.null2String(rs.getString(4)));
        map1.put("workflowId", Util.null2String(rs.getString(5)));
        map1.put("moduleFileName", Util.null2String(rs.getString(6)));
        return map1;
    }

    /**
     * @param id //int T_InputReportHrm.id
     */
    private List getReportHrmFields(int id) {
		RecordSet rs = getRecordSet();
        String sql = "SELECT fieldId FROM T_InputReportHrmFields WHERE reportHrmId=" + id;
        List fieldList = new ArrayList();
        rs.executeSql(sql);
        while (rs.next()) fieldList.add(Util.null2String(rs.getString(1)));
        return fieldList;
    }

    private Map getHrmSecurityInfo(int id, int ById) {//获取权限信息
		RecordSet rs = getRecordSet();
        String sWhere = (ById == REPORT_HRM_ID) ? "id=" + id : "inprepId=" + id;
        String sql = "SELECT * FROM T_InputReportHrm WHERE id=" + id;
        rs.executeSql(sql);
        Map map1 = null;
        if (rs.next()) {
            map1 = readInputReportHrm();
        }
        map1.put("fields", this.getReportHrmFields(id));
        return map1;
    }

    private List getFieldList(int inprepId) {
		RecordSet rs = getRecordSet();
        weaver.conn.RecordSet rs1 = new weaver.conn.RecordSet();
        rs.executeProc("T_IRItemtype_SelectByInprepid", "" + inprepId);
        List list1 = new ArrayList();
        List list2 = null;
        Map m0 = null, m1 = null;
        while (rs.next()) {
            String itemtypeid = Util.null2String(rs.getString("itemtypeid"));
            String itemtypeName = Util.null2String(rs.getString("itemtypename"));
            rs1.executeProc("T_IRItem_SelectByItemtypeid", "" + itemtypeid);
            m1 = new HashMap();
            m1.put("itemName", itemtypeName);
            list2 = new ArrayList();
            while (rs1.next()) {
                m0 = new HashMap();
                m0.put("id", Util.null2String(rs1.getString("itemid")));
                m0.put("name", Util.null2String(rs1.getString("itemdspname")));
                m0.put("fieldName", Util.null2String(rs1.getString("itemfieldname")));
                //T_InputReportItem_SelectByItemtypeid
                list2.add(m0);
            }//End while.
            m1.put("fieldList", list2);
            list1.add(m1);
        }//End while.
        return list1;
    }

    private List getAllInputReport(String userId) {
		RecordSet rs = getRecordSet();
        String sql = "SELECT id,inprepId FROM T_InputReportHrm WHERE hrmId=" + userId + " AND crmId IS NOT null";
        rs.executeSql(sql);
        Map idMap = new HashMap();
        while (rs.next())
            idMap.put(Util.null2String(rs.getString(1)),
                    Util.null2String(rs.getString(2)));//获取该用户有权限的输入报表ID.

        rs.executeProc("T_InputReport_SelectAll", "");
        List list1 = new ArrayList();
        Map m = null;
        String inprepId = null;
        while (rs.next()) {
            inprepId = Util.null2String(rs.getString("inprepid"));
            if (idMap.containsValue(inprepId)) {
                m = new HashMap();
                m.put("inprepId", inprepId);
                m.put("inprepName", Util.null2String(rs.getString("inprepname")));
                list1.add(m);
            }
        }
        return list1;
    }

    private Map getHrmSecurityInfoByUserId(int userId, int inprepId) {
		RecordSet rs = getRecordSet();
//Map<...,fields:List<fieldId>>
        String sql = "SELECT * FROM T_InputReportHrm WHERE inprepId=" + inprepId + " AND hrmId=" + userId;
        rs.executeSql(sql);
        Map m0 = null;
        if (rs.next()) m0 = this.readInputReportHrm();
        if (m0 != null) {
            int id = Integer.parseInt(m0.get("id").toString());
            m0.put("fields", this.getReportHrmFields(id));
        }
        return m0;
    }

    private String getCrmNameByCrmIds(weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo, String crmIds) {
        if (crmIds == null || crmIds.equalsIgnoreCase("")) return "";
//	String[] arCrmIds=crmIds.split(",");
        String[] arCrmIds = Util.TokenizerString2(crmIds, ",");
        crmIds = "";
        for (int i = 0; i < arCrmIds.length; i++) {
            String crmName = customerInfoComInfo.getCustomerInfoname(arCrmIds[i]);
            crmIds += "<a href='/CRM/data/ViewCustomer.jsp?CustomerID=" + arCrmIds[i] + "' target='_blank'>" + crmName + "</a>&nbsp;&nbsp;";
        }
        return crmIds;
    }

    private String getParam(String pname) {
        return Util.null2String(req.getParameter(pname));
    }
	
	private String getTableNameByInprepId(int inprepId){
		RecordSet rs = getRecordSet();
		String sql="SELECT inprepId,inprepTableName,isInputMultiLine FROM T_inputReport WHERE inprepId="+inprepId;
		this.rs.executeSql(sql);
		String tmp="";
		if(this.rs.next())
			tmp=Util.null2String(rs.getString("inprepTableName"));
			
		return tmp;
	}
	
	public String getExistUserExcelTemplate(String fname){
		String saveFileName = GCONST.getRootPath()+"datacenter" + File.separatorChar + "inputexcellfile" + File.separatorChar + fname+".xls";
		File f=new File(saveFileName);
		return f.exists()?fname+".xls":null;
	}

%>