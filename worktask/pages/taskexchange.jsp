
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,java.util.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />
<jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");

//任务实例id
String requestid = request.getParameter("requestid");
String content = request.getParameter("content");
SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//操作日期
String opdate=format.format(new Date());
String id = UUID.randomUUID().toString();
String docs = Util.null2String(request.getParameter("reldocs"));
String wfs = Util.null2String(request.getParameter("relwfs"));
String custs = Util.null2String(request.getParameter("relcusts"));
String projs = Util.null2String(request.getParameter("relprojs"));
String fileids = Util.null2String(request.getParameter("fileids"));
String atids = Util.null2String(request.getParameter("atids"));
String wtid = Util.null2String(request.getParameter("wtid"));
String cdate = Util.null2String(request.getParameter("cdate"));
String ctime = Util.null2String(request.getParameter("ctime"));
try{
    String sql = "insert into worktask_discuss(id,reqeustid,userid,datetime,content,docs,wfs,custs,projs,attachs)  values(?,?,?,?,?,?,?,?,?,?)";
	cs.setStatementSql(sql);
    cs.setString(1,id);
    cs.setString(2,requestid);
    cs.setString(3,user.getUID()+"");
    cs.setString(4,cdate+" "+ctime);
    cs.setString(5,content);
    cs.setString(6,docs);
    cs.setString(7,wfs);
    cs.setString(8,custs);
    cs.setString(9,projs);
    cs.setString(10,fileids);
    cs.executeUpdate();
    List<String> atids_muti = Util.TokenizerString(atids, ",");
    //处理@存储
    for(String atid : atids_muti){
       sql = "insert into worktask_atinfo(id,userid,requestid)  values(?,?,?)";
       cs.setStatementSql(sql);
       cs.setString(1,UUID.randomUUID().toString());
       cs.setString(2,atid);
       cs.setString(3,requestid);
       cs.executeUpdate();
    }
   //插入共享信息 
    for(String atid : atids_muti){
       //插入的时候先查询下
       sql = "select * from requestshareset where taskid="+wtid+" and requestid="+requestid+ " and sharetype=1 and objid="+atid;
       rs.execute(sql);
       if(!rs.next()){
	       sql = "insert into requestshareset(taskid,requestid,taskstatus,sharelevel,sharetype,seclevel,rolelevel,objid,foralluser,isdefault)  values(?,?,?,?,?,?,?,?,?,?)";
	       cs.setStatementSql(sql);
	       cs.setString(1,wtid);
	       cs.setString(2,requestid);
	       cs.setString(3,"2");
	       cs.setString(4,"0");
	       cs.setString(5,"1");
	       cs.setString(6,"0");
	       cs.setString(7,"0");
	       cs.setString(8,atid);
	       cs.setString(9,"0");
	       cs.setString(10,"0");
	       cs.executeUpdate();
       }
    }
    cs.close();
	out.println("{\"success\":\"1\"}");
}catch(Exception e){
    e.printStackTrace();
	out.println("{\"success\":\"0\"}");
}

%>