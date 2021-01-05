
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.Timestamp"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.cowork.CoworkDAO"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="csm" class="weaver.cowork.CoworkShareManager" scope="page" />
<%

User user = HrmUserVarify.getUser (request , response) ;

String method = Util.null2String(request.getParameter("method"));
String coworkid = Util.null2String(request.getParameter("coworkid"));
String applyid = Util.null2String(request.getParameter("applyid"));
String status = Util.null2String(request.getParameter("status"));
String ClientIP = request.getRemoteAddr();
String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

if("apply".equals(method)){
	String[] ids = coworkid.split(",");
	for(int i=0; i <ids.length ; i++){
		String sql = "insert into cowork_apply_info(coworkid ,resourceid , status  ,applydate  , ipaddress )"+
			"values ("+ids[i]+" , "+user.getUID()+" , -1 , '"+date+"', '"+ClientIP+"')";
		
		rs.execute(sql);
	}
}

if("approve".equals(method)){
	try{
		
		String sql = "update cowork_apply_info set status = "+status+" , approvedate = '"+date+"', "+
			" approveid = '"+user.getUID()+"' where id in ("+applyid+")";
		RecordSet.execute(sql);
		
		
		if(status.equals("1")){
			rs.execute("select t1.coworkid , t1.resourceid ,t2.principal ,t2.typeid ,t2.creater from cowork_apply_info t1 "+
					"left join cowork_items t2 on t1.coworkid = t2.id  where t1.id in ("+applyid+")");
			while(rs.next()){
				String sourceid = rs.getString("coworkid");
				String resourceid = ","+rs.getString("resourceid")+",";
				sql = "insert into coworkshare (sourceid,type ,content,sharelevel,srcfrom,seclevel,seclevelMax) values"+
					" ("+sourceid+",1,'"+resourceid+"',1,1,10,100)";
				RecordSet.execute(sql);
				
				CoworkDAO dao = new CoworkDAO(Integer.parseInt(sourceid));
			    ArrayList accList=dao.getRelatedAccs();//获得该协作的所有附件id
			    String accStr=accList.toString();
			    accStr=accStr.substring(1,accStr.length()-1);
			    csm.addCoworkDocShare(user.getUID()+"",accStr,rs.getString("typeid"),resourceid,rs.getString("principal"));//添加新的附件权限
			    csm.deleteCache("parter",sourceid);
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		rs.execute("select count(*) from cowork_items  t1  JOIN cowork_apply_info t2 ON t1.id = t2.coworkid where t1.principal = "+user.getUID()+" and t2.status = -1 ");
		rs.next();
		out.print(Util.getIntValue(rs.getString(1),0));
	}
	
	
}

%>
