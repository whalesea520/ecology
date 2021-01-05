<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptShare" class="weaver.formmode.cuspage.cpt.CptShare4mode" scope="page" />
<%
char flag = 2;
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String assortid = Util.null2String(request.getParameter("assortid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid = "0" ;
String roleid = "0" ;
String foralluser = "0" ;

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) departmentid = relatedshareid ;
if(sharetype.equals("3")) roleid = relatedshareid ;
if(sharetype.equals("4")) foralluser = "1" ;
if(sharetype.equals("5")) subcompanyid = relatedshareid ;

String name = "";

if(method.equals("delete"))
{
	RecordSet.executeSql("delete from uf4mode_CptAssortmentShare where id="+id);
	
    CptShare.SetAssortShare(assortid);

    String forward=Util.null2String(request.getParameter("forward"));
    if(forward.equals("view")){
       return;
    }else{
	   return;
	}
	
}else if(method.equals("batchdelete")){
	if(id.startsWith(",")){
		id=id.substring(1);
	}
	if(id.endsWith(",")){
		id=id.substring(0,id.length()-1);
	}
	
	RecordSet.executeSql("delete from uf4mode_CptAssortmentShare where id in("+id+")");
    CptShare.SetAssortShare(assortid);
    
    return;
}


else if(method.equals("add"))
{
	ProcPara = assortid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	ProcPara += flag+subcompanyid;
	
	//向CptAssortmentShare里添加一条记录大类的共享信息
	String sql="insert into uf4mode_CptAssortmentShare(assortmentid,sharetype,seclevel,rolelevel,sharelevel,userid,departmentid,roleid,foralluser,subcompanyid) ";
	sql+=" values('"+assortid+"','"+sharetype+"','"+seclevel+"','"+rolelevel+"','"+sharelevel+"','"+userid+"','"+departmentid+"','"+roleid+"','"+foralluser+"','"+subcompanyid+"' ) ";
	RecordSet.executeSql(sql);
	
	
	
		
	response.sendRedirect("/formmode/cuspage/cpt/AssortShareOperation.jsp?assortid="+assortid+"&method=submit");
	return;
}

else if(method.equals("submit"))
{
    CptShare.SetAssortShare(assortid);
	return;
}
%>
