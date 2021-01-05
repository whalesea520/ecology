<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Hashtable" %>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>	
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsObj" class="weaver.conn.RecordSet" scope="page" />
<%

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
    String returnValues = "";
    String id = "";
    String name = "";
    String descr = "";
    String matrixTmp = Util.null2s(request.getParameter("matrixTmp"), "-100");
    String matrixCfield = Util.null2String(request.getParameter("matrixCfield"));
    String operator = Util.null2String(request.getParameter("operator"));
    String isbill = Util.null2String(request.getParameter("isbill"));
    String formid = Util.null2String(request.getParameter("formid"));
    String j = Util.null2String(request.getParameter("j"));
    String sqlstr = "";
    String sql = "";
    String issystem = "";
    String browsertypeid = "";
    if ("1".equals(operator)) {
        sqlstr = "select id,fieldname as name,displayname as descr from MatrixFieldInfo where fieldtype='1'  and matrixid=" + matrixTmp;
    } else if ("2".equals(operator)) {
        sql = "select * from MatrixInfo where id = " + matrixTmp;
        rsObj.executeSql(sql);
        if (rsObj.next()) {
            issystem = rsObj.getString("issystem");
        }
    } else if ("0".equals(operator)) {
        sqlstr = "select id,fieldname as name,displayname as descr from MatrixFieldInfo where fieldtype='0'  and matrixid=" + matrixTmp;
        sql = "select * from MatrixInfo where id = " + matrixTmp;
        rsObj.executeSql(sql);
        if (rsObj.next()) {
            issystem = rsObj.getString("issystem");
        }
    } else if ("3".equals(operator)) {
        if (isbill.equals("0")) {
            sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="
                    + formid;
        }
        if (isbill.equals("1")) {
            sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "
                    + formid + " and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.fieldhtmltype=3 ";
        }

    } else if ("5".equals(operator)) {
        sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + matrixCfield;

        rsObj.executeSql(sqlstr);
        if (rsObj.next()) {
            browsertypeid = rsObj.getString("browsertypeid");
        }
    } else if ("6".equals(operator)) {
        sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + matrixCfield;

        rsObj.executeSql(sqlstr);
        if (rsObj.next()) {
            browsertypeid = rsObj.getString("browsertypeid");
        }
    } else if ("4".equals(operator)) {
        sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + matrixCfield;

        rsObj.executeSql(sqlstr);
        if (rsObj.next()) {
            browsertypeid = rsObj.getString("browsertypeid");
        }
        
        String typestr = "";
        if ("1".equals(browsertypeid) || "17".equals(browsertypeid)) {
            typestr = "1,17,165,166";
        }
        if ("4".equals(browsertypeid) || "57".equals(browsertypeid)) {
            typestr = "4,57,167,168";
        }
        if ("8".equals(browsertypeid) || "135".equals(browsertypeid)) {
            typestr = "8,135";
        }
        if ("7".equals(browsertypeid) || "18".equals(browsertypeid)) {
            typestr = "7,18";
        }

        if ("164".equals(browsertypeid) || "194".equals(browsertypeid)) {
            typestr = "164,194,169,170";
        }
        if ("24".equals(browsertypeid) || "278".equals(browsertypeid)) {
            typestr = "24,278";
        }

        if ("161".equals(browsertypeid)) {
            typestr = "161,162";
        }

        if ("162".equals(browsertypeid)) {
            typestr = "161";
        }
        
        if (typestr.equals("")) {
            typestr = "-789";
        }
        if (isbill.equals("0")) {
            sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (" + typestr + ") and workflow_formfield.formid="
                    + formid;
        }
        if (isbill.equals("1")) {
            sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "
                    + formid + " and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (" + typestr + ") and t1.fieldhtmltype=3 ";
        }

    }
    
    if (!"2".equals(operator) && !"5".equals(operator)) {
        //System.out.println("-23----22-"+SystemEnv.getHtmlLabelName("-815",user.getLanguage()));
        if ("0".equals(operator) || "3".equals(operator)) {
            if (("1".equals(issystem) || "2".equals(issystem))) {
                returnValues = "";
            } else {
                returnValues = "<option value='0'> </option>";
            }
        }
        rs.executeSql(sqlstr);
        while (rs.next()) {
            id = Util.null2String(rs.getString("id"));
            name = Util.null2String(rs.getString("name"));
            if ("3".equals(operator) || "4".equals(operator)) {
                if (isbill.equals("1")) {
                    descr = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("label")), 7));
                } else {
                    descr = Util.null2String(rs.getString("label"));
                }
            } else {
                descr = Util.null2String(rs.getString("descr"));
            }
            //System.out.println("-55----id-"+id);
            //System.out.println("-55----descr-"+descr);

            returnValues += "<option value=\"" + id + "\">" + descr + "</option>";

        }
        
      //分部
        if ("164".equals(browsertypeid) || "194".equals(browsertypeid)) {
            id = "-13";
            //descr = "创建人分部";
            //创建人分部（系统字段）
            descr = SystemEnv.getHtmlLabelName(22788, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) +  SystemEnv.getHtmlLabelName(28415, user.getLanguage()) + SystemEnv.getHtmlLabelName(82174, user.getLanguage());
            returnValues += "<option value=\"" + id + "\">" + descr + "</option>";
        }
      
        //部门
        if ("4".equals(browsertypeid) || "57".equals(browsertypeid)) {
            id = "-12";
            //descr = "创建人部门";
            //创建人部门（系统字段）
            descr = SystemEnv.getHtmlLabelName(19225, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) +  SystemEnv.getHtmlLabelName(28415, user.getLanguage()) + SystemEnv.getHtmlLabelName(82174, user.getLanguage());
            returnValues += "<option value=\"" + id + "\">" + descr + "</option>";
        }
    }
    if ("2".equals(operator) && ("1".equals(issystem) || "2".equals(issystem))) {
        returnValues = issystem;
    }
    if ("5".equals(operator)) {
        returnValues = browsertypeid;

    }
    if ("6".equals(operator)) {
        returnValues = j + "," + browsertypeid;

    }

    out.print(returnValues);
%>

