<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.file.FileUpload"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="fieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="detailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="htmlDateTimeCal" class="weaver.workflow.html.HtmlDateTimeCal" scope="page" />
<%
response.setContentType("text/xml;charset=UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	return ;
}
FileUpload fu = new FileUpload(request);	//支持移动端POST请求，使用FileUpload
int nodeid = Util.getIntValue(fu.getParameter("nodeid"), 0);
int isbill = Util.getIntValue(fu.getParameter("isbill"), 0);
int formid = Util.getIntValue(fu.getParameter("formid"), 0);
int othertype = Util.getIntValue(fu.getParameter("othertype"), 0);
String fieldidAll = Util.null2String(fu.getParameter("fieldid"));
int fieldid = -9;
int thisfieldid = -9;

int pos = fieldidAll.indexOf("_");
if(pos > -1){
	fieldid = Util.getIntValue(fieldidAll.substring(0, pos), 0);
}else{
	fieldid = Util.getIntValue(fieldidAll, 0);
}

String datecontent = Util.null2String(fu.getParameter("datecontent"));
datecontent = URLDecoder.decode(datecontent);
datecontent = datecontent.replaceAll("%2B", "+");
datecontent = datecontent.replaceAll("%26", "&");
//out.println(datecontent + "<br>" );
//out.println(othertype + "<br>");
String name = "";
String key = "";
int htmltype = -1;
int type = -1;
int isdetail = 0;
try{
	String sqlHrmResource = "select locationid from HrmResource where id ="+user.getUID();
	rs.executeSql(sqlHrmResource);
	int locationid = 0;
	if (rs.next()){
	   locationid = Util.getIntValue(rs.getString("locationid"));
	}
	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
	rs.executeSql(sqlHrmLocations);
	String countryId = "";
	if (rs.next()){
	   countryId =  Util.null2String(rs.getString("countryid"));
	}
	user.setCountryid(countryId);
	htmlDateTimeCal.setUser(user);
	//key = htmlDateTimeCal.dohtmlDateTimeCal(datecontent, othertype);
	key = htmlDateTimeCal.dohtmlDateTimeCal(datecontent, othertype, fieldid, isbill);
	name = key;
	//rs.execute(datecontent);

	if(isbill == 0){
		htmltype = Util.getIntValue(fieldComInfo.getFieldhtmltype(""+fieldid), -1);
		type = Util.getIntValue(fieldComInfo.getFieldType(""+fieldid), -1);
		if(htmltype == -1){
			htmltype = Util.getIntValue(detailFieldComInfo.getFieldhtmltype(""+fieldid), -1);
			type = Util.getIntValue(detailFieldComInfo.getFieldType(""+fieldid), -1);
			isdetail = 1;
		}
	}else{
		rs.execute("select viewtype, fieldhtmltype, type from workflow_billfield where id="+fieldid);
		if(rs.next()){
			htmltype = Util.getIntValue(rs.getString("fieldhtmltype"), -1);
			isdetail = Util.getIntValue(rs.getString("viewtype"), 0);
			type = Util.getIntValue(rs.getString("type"), -1);
		}
	}
	if(htmltype==1 && (type==2||type==3||type==4||type==5)){
		if("".equals(key.trim())){
			key = "0";
		}
		if("".equals(name.trim())){
			name = "0";
		}
		if(type == 2){
			int index1 = key.indexOf(".");
			if(index1 > -1){
				key = key.substring(0, index1);
				name = key;
			}
		}
	}
}catch(Exception e){
	//e.printStackTrace();
}

%>


<information>
<name><%=name%></name>
<key><%=key%></key>
<htmltype><%=htmltype%></htmltype>
<isdetail><%=isdetail%></isdetail>
<type><%=type%></type>
</information>