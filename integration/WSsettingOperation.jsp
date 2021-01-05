<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.wsclient.bean.*,net.sf.json.*" %>
<%@page import="weaver.integration.logging.Logger"%>
<%@page import="weaver.integration.logging.LoggerFactory"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WSDLFacade" class="weaver.wsclient.util.WSDLFacade" scope="page" />
<%
User user = HrmUserVarify.getUser(request , response) ;


if(user == null)  return ;

Logger log = LoggerFactory.getLogger();
String operator = Util.fromScreen(request.getParameter("operator"),user.getLanguage());
String isDialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("id"));
String tempmethodid = Util.null2String(request.getParameter("methodid"));
String customname = Util.null2String(request.getParameter("customname"));
String webserviceurl = Util.null2String(request.getParameter("webserviceurl"));
if("save".equals(operator))
{
	if(!HrmUserVarify.checkUserRight("intergration:webserivcesetting", user)){
	 	response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	if(id.equals("")){
		rs.executeSql("select * from wsregiste where customname='"+customname+"'");
	}else{
		rs.executeSql("select * from wsregiste where customname='"+customname+"' and id!='"+id+"'");
	}
	if(rs.getCounts()>0){
		response.sendRedirect("/integration/webserivcesetting.jsp?id="+id+"&isdialog=1&check=1");
		return;
	}
	
	if(Util.getIntValue(id,-1)>0)
	{
		rs.executeSql("update wsregiste set customname='"+customname+"',webserviceurl='"+webserviceurl+"' where id="+id);
	}
	else
	{
		rs.executeSql("insert into wsregiste(customname,webserviceurl) values('"+customname+"','"+webserviceurl+"')");
		rs.executeSql("select max(id) from wsregiste");
		if(rs.next())
		{
			id = rs.getString(1);
		}
	}
	Map methodmap = new HashMap();
	if(Util.getIntValue(id,-1)>0)
	{
		String[] methodids = request.getParameterValues("methodid");
		String[] methodnames = request.getParameterValues("methodname");
		String[] methodreturntypes = request.getParameterValues("methodreturntype");
		String[] methoddescs = request.getParameterValues("methoddesc");

		String methodidstr = "";
		if(null!=methodids)
		{
			for(int i = 0;i<methodids.length;i++)
			{
				
				String methodid = methodids[i];
				
				String methodname = methodnames[i];
				String methoddesc = methoddescs[i];
				String methodreturntype = methodreturntypes[i];

				if(Util.getIntValue(methodid,-1)>0)
				{
					rs.executeSql("update wsregistemethod set methodname='"+methodname+"',methoddesc='"+methoddesc+"',methodreturntype='"+methodreturntype+"' where id="+methodid);
				}
				else
				{
					rs.executeSql("insert into wsregistemethod(mainid,methodname,methoddesc,methodreturntype) values("+id+",'"+methodname+"','"+methoddesc+"','"+methodreturntype+"')");
					rs.executeSql("select max(id) from wsregistemethod");
					if(rs.next())
					{
						methodid = rs.getString(1);
					}
				}
				methodidstr += "".equals(methodidstr)?(methodid):(","+methodid);
				methodmap.put(methodname,methodid);
			}
		}
		if(!"".equals(methodidstr)&&Util.getIntValue(id,-1)>0)
		{
			rs.executeSql("delete from wsregistemethodparam where methodid not in("+methodidstr+") and methodid in(select id from wsregistemethod where mainid in("+id+"))");
			rs.executeSql("delete from wsregistemethod where id not in("+methodidstr+") and mainid="+id);
		}else if("".equals(methodidstr)){
			rs.executeSql("delete from wsregistemethodparam where  methodid in(select id from wsregistemethod where mainid in("+id+"))");
			rs.executeSql("delete from wsregistemethod where  mainid="+id);
		}
		String[] parammethods = request.getParameterValues("parammethod");
		String[] paramnames = request.getParameterValues("paramname");
		String[] paramtypes = request.getParameterValues("paramtype");
		String[] isarrays = request.getParameterValues("isarray");
		if(null!=parammethods)
		{
			for(int i = 0;i<parammethods.length;i++)
			{
				String parammethod = parammethods[i];
				String methodid = Util.null2String((String)methodmap.get(parammethod));
				if(Util.getIntValue(methodid,-1)>0)
				{
					rs.executeSql("delete from wsregistemethodparam where methodid="+methodid);
				}
			}
			for(int i = 0;i<parammethods.length;i++)
			{
				String parammethod = parammethods[i];
				String paramname = paramnames[i];
				String paramtype = paramtypes[i];
				String isarray = isarrays[i];
				String methodid = Util.null2String((String)methodmap.get(parammethod));
				rs.executeSql("insert into wsregistemethodparam(methodid ,paramname,paramtype,isarray) values("+methodid +",'"+paramname+"','"+paramtype+"','"+isarray+"')");
			}
		}
	}
	if("1".equals(isDialog)){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="/integration/webserivcesettingList.jsp";
		parentWin.closeDialog();
	}catch(e){

	}
</script>
<%
    }else{
 		response.sendRedirect("/integration/webserivcesetting.jsp?id="+id);
	}
}
else if("delete".equals(operator))
{
	if(!HrmUserVarify.checkUserRight("intergration:webserivcesetting", user)){
	 	response.sendRedirect("/notice/noright.jsp");
	 	return;
	}
	if(!"".equals(id))
	{
		rs.executeSql("delete from wsregistemethodparam where methodid in(select id from wsregistemethod where mainid in("+id+"))");
		rs.executeSql("delete from wsregistemethod where mainid in("+id+")");
		rs.executeSql("delete from wsregiste where id in("+id+")");
	}
	if("1".equals(isDialog)){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="/integration/webserivcesettingList.jsp";
		parentWin.closeDialog();
	}catch(e){

	}
</script>
<%
    }else{
	response.sendRedirect("/integration/webserivcesettingList.jsp");
	}
}
else if("getregisteinfo".equals(operator))
{
	String result = "";
	if(!"".equals(id))
  	{
  		List<MethodBean> methods = new ArrayList();
	  	String sqlmethod = "SELECT * FROM wsregistemethod where mainid="+id+" order by methodname,id";
	  	rs.executeSql(sqlmethod);
	  	while(rs.next())
	  	{
	  		String methodid = rs.getString("id");
	  		String methodname = rs.getString("methodname");
	  		String methoddesc = rs.getString("methoddesc");
	  		MethodBean mb = new MethodBean();
	  		mb.setId(methodid);
	  		mb.setMethodname(methodname);
	  		mb.setMethoddesc(methoddesc);
	  		methods.add(mb);
	  	}
	  	result = JSONArray.fromObject(methods).toString();
  	}
  	out.println(result);
}
else if("getmethodinfo".equals(operator))
{
	String result = "";
	if(!"".equals(tempmethodid))
  	{
  		List<ParamBean> methods = new ArrayList();
	  	String sqlparam = "SELECT * FROM wsregistemethodparam where methodid="+tempmethodid+" order by paramname,id";
	  	rs.executeSql(sqlparam);
	  	while(rs.next())
	  	{
	  		String paramid = rs.getString("id");
	  		String paramname = rs.getString("paramname");
	  		String paramtype = rs.getString("paramtype");
	  		String isarray = rs.getString("isarray");

	  		ParamBean mb = new ParamBean();
	  		mb.setId(paramid);
	  		mb.setParamname(paramname);
	  		mb.setParamtype(paramtype);
	  		mb.setIsarray(isarray);
	  		methods.add(mb);
	  	}
	  	result = JSONArray.fromObject(methods).toString();
  	}
  	out.println(result);
}
else if("getinfo".equals(operator))
{
	String result = "";
	if(!"".equals(webserviceurl)){
		try{
			result = WSDLFacade.getAllMethod(webserviceurl);
		}catch(Exception e){//异常输出
		    log.error(e);
			result = "exception";
		}
	}
	out.print(result);
}
%>
