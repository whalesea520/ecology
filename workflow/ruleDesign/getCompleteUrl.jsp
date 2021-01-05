<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.systeminfo.SystemEnv" %>

<%
	
	User user = HrmUserVarify.getUser(request, response) ;
	if (user == null ) return ;
	String isbill = Util.null2String(request.getParameter("isbill"));
	String formid = Util.null2String(request.getParameter("formid"));
	String fshowname = Util.null2String(request.getParameter("fshowname"));
	String sql = "";
	RecordSet rs = new RecordSet();
	if(isbill.equals("0")){
		sql = " select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder "
			+" from workflow_formfield,workflow_formdict,workflow_fieldlable "
			+" where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid+" ";
		if(!fshowname.equals(""))
		{
			sql+=" and (workflow_fieldlable.fieldlable like '%"+fshowname+"%' ";
			String rexp = "^[a-zA-Z]+$";
			Pattern pat = Pattern.compile(rexp);
			Matcher mat = pat.matcher(fshowname);
			if(mat.find())
			{
				if(rs.getDBType().equals("oracle")){
					sql += " or f_GetPy(workflow_fieldlable.fieldlable) like '%"+fshowname+"%')";
				}else if(rs.getDBType().equalsIgnoreCase("sqlserver")){
					sql += " or [dbo].f_GetPy(workflow_fieldlable.fieldlable) like '%"+fshowname+"%')";
				}
			}else
				sql+=")";
		}
		sql += " order by workflow_formfield.isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder desc";
	}else if(isbill.equals("1")){
		sql = " select t1.id as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder "
			+" from workflow_billfield t1,HtmlLabelInfo t2"
			+" where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "+formid + " and t1.fieldhtmltype!=6 ";
		sql += " and t2.indexid=t1.fieldlabel and t2.languageid="+user.getLanguage()+" ";
		if(!fshowname.equals(""))
		{
			sql += " and (t2.labelname like '%"+fshowname+"%'";
			String rexp = "^[a-zA-Z]+$";
			Pattern pat = Pattern.compile(rexp);
			Matcher mat = pat.matcher(fshowname);
			if(mat.find())
			{
				if(rs.getDBType().equals("oracle")){
					sql += " or f_GetPy(t2.labelname) like '%"+fshowname+"%')";
				}else if(rs.getDBType().equalsIgnoreCase("sqlserver")){
					sql += " or [dbo].f_GetPy(t2.labelname) like '%"+fshowname+"%')";
				}
			}else
				sql+=")";
		}
		sql += " order by t1.viewtype,t1.detailtable,t1.dsporder desc";
	}
	
	rs.executeSql(sql);
	String rejson = "[";
	String weaverSplit = "||~WEAVERSPLIT~||";
	while(rs.next())
	{
		String id = Util.null2String(rs.getString("id"));
		String name = Util.null2String(rs.getString("name"));
		String label = Util.null2String(rs.getString("label"));
		String htmltype = Util.null2String(rs.getString("htmltype"));
		String type = Util.null2String(rs.getString("type"));
		String dbtype = Util.null2String(rs.getString("dbtype"));
		if(htmltype.equals(""))htmltype="0";
		if(type.equals(""))type="0";
		if(dbtype.equals(""))dbtype="-1";
		if(isbill.equals("1"))
			label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
		String pfieldstr = htmltype + weaverSplit + type + weaverSplit + dbtype;
		if ("5".equals(htmltype)) {
			StringBuilder sb = new StringBuilder();
			RecordSet rs1 = new RecordSet();
			rs1.executeSql("SELECT selectname AS label,selectvalue AS value FROM workflow_selectitem WHERE fieldid='" + id + "'");
			while (rs1.next()) {
				sb.append("{\\\"label\\\":\\\"").append(Util.null2String(rs1.getString("label"))).append("\\\"");
				sb.append(",\\\"value\\\":\\\"").append(Util.null2String(rs1.getString("value"))).append("\\\"}").append(",");
			}
			if (sb.length() > 0) {
				sb.setLength(sb.length() - 1);
				pfieldstr += weaverSplit + "[" + sb.toString() + "]";
			}
		}
		rejson +="{\"id\":\""+id+"\",\"name\":\""+label+"\",\"pfiled\":\""+pfieldstr+"\"},";
	}
	if(rejson.contains(","))
		rejson = rejson.substring(0,rejson.lastIndexOf(","));
	rejson+="]";
	out.clear();
	out.print(rejson);
%>
