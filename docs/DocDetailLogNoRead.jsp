
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.*" %>
<%@page import="weaver.hrm.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sptmForDoc" class="weaver.splitepage.transform.SptmForDoc" scope="page"/>
<jsp:useBean id="docLog" class="weaver.docs.DocDetailLogTransMethod" scope="page"/>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String docid = request.getParameter("docid");
String hrmStatusSql = " and a.status in (0,1,2,3,10) ";
int start = Util.getIntValue(request.getParameter("start"),0);
int limit = Util.getIntValue(request.getParameter("limit"),10);


String sharetype = "";
String shareContent = "";
String shareSeclevel = "";

List noreadName = new ArrayList();
List noreadSubject = new ArrayList();

//System.out.println(noreadName.size());

String noreadname = ""; 
String docsubject = "";

String sqlstr = "select id,docsubject from ( select a.id,b.docsubject from hrmresource a,DocDetail b where 1 = 2"+hrmStatusSql;

RecordSet.executeSql("select type,content,seclevel from shareinnerdoc where sourceid ="+docid);
while(RecordSet.next()){
  sharetype = RecordSet.getString("type");
  shareContent = RecordSet.getString("content");
  shareSeclevel = RecordSet.getString("seclevel");
  if("1".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.id="+shareContent+" and b.id="+docid+hrmStatusSql;
  }
  if("2".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where (a.subcompanyid1="+shareContent+" and a.seclevel >= "+shareSeclevel+") and b.id="+docid+hrmStatusSql;
  }
  if("3".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where (a.departmentid="+shareContent+" and a.seclevel >= "+shareSeclevel+") and b.id="+docid+hrmStatusSql;
  }
  if("4".equals(sharetype)){
  
    /**取shareContent最后一位开始**/
    StringBuffer sb = new StringBuffer(shareContent);   
    String  str = (sb.reverse().toString()).trim();
    String fourstr = str.substring(0,1);
    StringBuffer nb = new StringBuffer(fourstr);
    String fanstr = nb.reverse().toString();
    /**取shareContent最后一位结束**/
    
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.id in(select resourceid from hrmrolemembers where roleid ="+shareContent.substring(0,shareContent.length()-1)+" and rolelevel="+fanstr+")  and b.id ="+docid+hrmStatusSql;
  }
  if("5".equals(sharetype)){
    sqlstr += " union select a.id,b.docsubject from hrmresource a,DocDetail b where a.seclevel >= "+shareSeclevel+" and b.id ="+docid+hrmStatusSql;
  }
}
sqlstr += ") t1 where id not in (select operateuserid from docdetaillog where docid ="+docid+")";

String sqlOuter= "select id,docsubject from ( select a.id,b.docsubject from CRM_CustomerInfo a,DocDetail b where 1=2";
int contentOuter = 0;
int seclevelOuter = 0;
String outerName= "";
String outerSubject = "";
rs.executeSql("select content,seclevel from shareouterdoc where sourceid = "+docid);
while(rs.next()){
	contentOuter = Util.getIntValue(rs.getString("content"),0);
  	seclevelOuter = Util.getIntValue(rs.getString("seclevel"),0);
  	sqlOuter += " union select a.id,b.docsubject from CRM_CustomerInfo a,DocDetail b where   b.id="+docid+" and a.type = "+contentOuter+" and a.seclevel>="+seclevelOuter+"";
}
sqlOuter += ") t1 where id not in (select operateuserid from docdetaillog where docid ="+docid+")";

rs.executeSql(sqlOuter);
while(rs.next()){
	outerName = sptmForDoc.getName(rs.getString("id"),"2");
	outerSubject = rs.getString("docsubject");
	noreadName.add(outerName);
  	noreadSubject.add(outerSubject);
}

RecordSet.executeSql(sqlstr);

while(RecordSet.next()){
   noreadname = sptmForDoc.getName(RecordSet.getString("id"),"1");
   docsubject = RecordSet.getString("docsubject");
   noreadName.add(noreadname);
   noreadSubject.add(docsubject);
}
JSONObject oJson= new JSONObject();
JSONArray jsonList= new JSONArray();
int starttemp = 10;
if(noreadName.size()-start <10){
	  starttemp = noreadName.size()-start;
}	
for(int i=start;i<start+starttemp;i++){
	JSONObject tempJson= new JSONObject();
	tempJson.put("operateuserid",noreadName.get(i));
	tempJson.put("subject",noreadSubject.get(i));
	jsonList.put(tempJson);
}
oJson.put("totalCount",noreadName.size());
oJson.put("data",jsonList);
out.print(oJson.toString());
%>

