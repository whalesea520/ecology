
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.util.*,java.io.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
String basepath=request.getSession().getServletContext().getRealPath("/");
File file=new File(basepath+"/voting/surveydesign/theme/bgpic");

//System.out.println("目录是否存在==>"+request.getSession().getServletContext().getRealPath(""));
String filebasepath="/voting/surveydesign/theme/bgpic/";
List<String>  items=new ArrayList<String>();
File[] files;
if(file.isDirectory()){
    files=file.listFiles();
    for(File fileitem:files){
    	items.add(filebasepath+fileitem.getName());
    }
}
JSONArray obj=new JSONArray(items);
out.println(obj.toString());
%>