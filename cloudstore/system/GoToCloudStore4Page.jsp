<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cloudstore.api.process.Process_Sso"%>
<%@ page import="com.cloudstore.api.obj.Sso"%>
<%@ page import="com.cloudstore.api.util.Util_ChangeStr"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="com.alibaba.fastjson.JSON"%>
<%@ page import="com.alibaba.fastjson.JSONObject"%>
<%@ page import="ln.LN"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
<meta name="description" content="">
<meta name="author" content="">
<title>访问云商店</title>
</head>
<body>
<%
User user = HrmUserVarify.getUser(request, response);
Sso rm = new Sso();
LN ln = new LN();
ln.CkHrmnum();
int id = user.getUID();
String loginid =  user.getLoginid();
String lastnamess = user.getLastname();
String dekey = "";
String aas = "1";
if (null != (id+"")) {
	rm.setId(id+"");
	if (("sysadmin").equals(loginid)) {
				rm.setLoginid(loginid);
				rm.setLastname(lastnamess);
	} else {
			String sql = "select s.id,s.lastname,s.loginid,s.mobile,s.sex,s.email,s.workcode,s.jobtitle, t.jobtitlename,s.departmentid,d.departmentname, s.subcompanyid1 as subcompanyid1,c.subcompanyname as subcompanyname,s.managerid,s2.lastname as mamagername from hrmresource s  left join HrmDepartment d on s.departmentid = d.id left join HrmSubCompany c on s.subcompanyid1 = c.id left join HrmResource s2 on s.managerid =s2.id left join HrmJobTitles t on s.jobtitle =t.id where 1=1 and s.id ='"+id+"'";
			RecordSet.execute(sql);
				if(RecordSet.next()){
					rm.setId(RecordSet.getString("id"));
					rm.setLastname(RecordSet.getString("lastname"));
					rm.setLoginid(RecordSet.getString("loginid"));
					rm.setMobile(RecordSet.getString("mobile"));
					rm.setSex(RecordSet.getString("sex"));
					rm.setEmail(RecordSet.getString("email"));
					rm.setWorkcode(RecordSet.getString("workcode"));
					rm.setDepartmentid(RecordSet.getString("departmentid"));
					rm.setJobtitle(RecordSet.getString("jobtitle"));
					rm.setJobtitlename(RecordSet.getString("jobtitlename"));
					rm.setDepartmentname(RecordSet.getString("departmentname"));
					rm.setSubcompanyid1(RecordSet.getString("subcompanyid1"));
					rm.setSubcompanyname(RecordSet.getString("subcompanyname"));
					rm.setManagerid(RecordSet.getString("managerid"));
					rm.setMamagername(RecordSet.getString("mamagername"));
				}
	}
	if (null != rm) {
				String Tokensql = "select token,loginconfig from cloudstore_tocstoken where 1=1";
				RecordSet.execute(Tokensql);
				if(RecordSet.next()){
					 rm.setToken(RecordSet.getString(1));
					 aas = RecordSet.getString(2);
				}
				String bianma = System.getProperty("file.encoding");
				if (!"GBK".equals(bianma)) {
					rm.setCode("1");
				} else {
					rm.setCode("0");
				}
				rm.setLicense(ln.getLicensecode());
				rm.setCompanyname(ln.getCompanyname());
				rm.setLogintimes(System.currentTimeMillis() + "");
				//rm.setIsMobile("1");
				rm.setPath(request.getParameter("path"));
				
				String rms = JSON.toJSONString(rm);//
				//System.out.println("rms is :"+rms);
				Util_ChangeStr UD = new Util_ChangeStr("national");
				dekey = UD.encrypt(rms);
				
				
	}
}



//String ip = request.getParameter("ip");
//if(null == ip ||"".equals(ip)){
// ip = ""+dekey;
//}
//String urls = request.getParameter("url");
String url = "https://e-cloudstore.com/m#/?key="+dekey;

//response.sendRedirect("http://"+ip+"/person?key="+result+"&?");
%>
<form id = "aaa" method ="get" action="<%=url %>">
<input type="hidden" name="key" value="<%=dekey %>" />
</form>
<script type="text/javascript">
function validate(){
 location.href="<%=url %>";
}
if(1==<%=aas %>)
{alert("没有绑定token");
}else{
window.load=validate();
}
</script>
</body>
</html>