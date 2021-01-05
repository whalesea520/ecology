<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="htmlDateTimeCal" class="weaver.workflow.html.HtmlDateTimeCal" scope="page" />
<%
response.setContentType("text/xml;charset=UTF-8");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	return ;
}

int othertype = Util.getIntValue(request.getParameter("othertype"), 0);
String fieldidAll = Util.null2String(request.getParameter("fieldid"));
int fieldid = -9;
int thisfieldid = -9;

int pos = fieldidAll.indexOf("_");
if(pos > -1){
	fieldid = Util.getIntValue(fieldidAll.substring(0, pos), 0);
}else{
	fieldid = Util.getIntValue(fieldidAll, 0);
}

String datecontent = Util.null2String(request.getParameter("datecontent"));
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
	key = htmlDateTimeCal.dohtmlDateTimeCal(datecontent, othertype);
	name = key;
	//rs.execute(datecontent);

	rs.execute("select viewtype, fieldhtmltype, type from workflow_billfield where id="+fieldid);
	if(rs.next()){
		htmltype = Util.getIntValue(rs.getString("fieldhtmltype"), -1);
		isdetail = Util.getIntValue(rs.getString("viewtype"), 0);
		type = Util.getIntValue(rs.getString("type"), -1);
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