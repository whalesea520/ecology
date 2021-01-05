<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String sysid = Util.fromScreen(request.getParameter("sysid"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String iurl = Util.fromScreen(request.getParameter("iurl"),user.getLanguage());
String ourl = Util.fromScreen(request.getParameter("ourl"),user.getLanguage());

String backto = Util.null2String(request.getParameter("backto"));//返回类型
String isDialog = Util.null2String(request.getParameter("isdialog"));

String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());//单点登录的类型，1：NC
String requesttype = Util.fromScreen(request.getParameter("requesttype"),user.getLanguage());//请求类型
String accountcode = Util.fromScreen(request.getParameter("accountcode"),user.getLanguage());//NC账套
String baseparam1 = Util.fromScreen(request.getParameter("baseparam1"),user.getLanguage());
String urlparaencrypt1 = Util.fromScreen(request.getParameter("urlparaencrypt1"),user.getLanguage());
String encryptcode1 = Util.fromScreen(request.getParameter("encryptcode1"),user.getLanguage());
if(!urlparaencrypt1.equals("1"))
	encryptcode1 = "";
String baseparam2 = Util.fromScreen(request.getParameter("baseparam2"),user.getLanguage());
String urlparaencrypt2 = Util.fromScreen(request.getParameter("urlparaencrypt2"),user.getLanguage());
String encryptcode2 = Util.fromScreen(request.getParameter("encryptcode2"),user.getLanguage());
if(!urlparaencrypt2.equals("1"))
	encryptcode2 = "";
String basetype1 = Util.fromScreen(request.getParameter("basetype1"),user.getLanguage());
String basetype2 = Util.fromScreen(request.getParameter("basetype2"),user.getLanguage());
String urlparaencrypt = Util.fromScreen(request.getParameter("urlparaencrypt"),user.getLanguage());
String encryptcode = Util.fromScreen(request.getParameter("encryptcode"),user.getLanguage());
if(!urlparaencrypt.equals("1"))
	encryptcode = "";
String encrypttype = Util.fromScreen(request.getParameter("encrypttype"),user.getLanguage());
String encryptclass = Util.fromScreen(request.getParameter("encryptclass"),user.getLanguage());
String encryptmethod = Util.fromScreen(request.getParameter("encryptmethod"),user.getLanguage());

String paramnames[] = request.getParameterValues("paramnames");
String paramtypes[] = request.getParameterValues("paramtypes");
String paramvalues[] = request.getParameterValues("paramvalues");
String labelnames[] = request.getParameterValues("labelnames");
String paraencrypts[] = request.getParameterValues("paraencrypts");
String encryptcodes[] = request.getParameterValues("encryptcodes");
if(operation.equals("add")){
	RecordSet.executeSql("select * from outter_sys where sysid='"+sysid+"'");
    if(RecordSet.next()){
    	if("1".equals(isDialog))
	    {
	    %>
	    <script language=javascript >
	    try
	    {
			//var parentWin = parent.getParentWindow(window);
			var parentWin = parent.parent.getParentWindow(parent);
			parentWin.location.href="OutterSysAdd.jsp?msgid=21011";
			parentWin.closeDialog();
		}
		catch(e)
		{
		}
		</script>
	    <%
	    }
	    else
	    {
	    	response.sendRedirect("OutterSysAdd.jsp?msgid=21011");
	    }
    	return;
	}
	RecordSet.executeSql("insert into outter_sys(sysid,name,iurl,ourl,baseparam1,baseparam2,basetype1,basetype2,typename,ncaccountcode,requesttype,urlparaencrypt1,encryptcode1,urlparaencrypt2,encryptcode2,urlparaencrypt,encryptcode,encrypttype,encryptclass,encryptmethod) values('"+sysid+"','"+name+"','"+iurl+"','"+ourl+"','"+baseparam1+"','"+baseparam2+"',"+basetype1+","+basetype2+",'"+typename+"','"+accountcode+"','"+requesttype+"','"+urlparaencrypt1+"','"+encryptcode1+"','"+urlparaencrypt2+"','"+encryptcode2+"','"+urlparaencrypt+"','"+encryptcode+"','"+encrypttype+"','"+encryptclass+"','"+encryptmethod+"')");
	if(paramnames!=null){
		for(int i=0;i<paramnames.length;i++){
			String paramname=paramnames[i];
			String paramvalue=paramvalues[i];
			String paramtype=paramtypes[i];
			String labelname=labelnames[i];
			String tparaencrypt="";
			try
			{
				tparaencrypt=paraencrypts[i];
			}
			catch(Exception e)
			{
				
			}
			String tencryptcode=encryptcodes[i];
			if(!tparaencrypt.equals("1"))
				tencryptcode = "";
			if(!paramname.equals(""))
			RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+",'"+tparaencrypt+"','"+tencryptcode+"')");
		}
	}
	if("1".equals(typename)) { //如果类型是NC，则新增公司名称
		String paramnames_nc = Util.null2String(request.getParameter("paramnames_nc"));
		String paramtypes_nc = Util.null2String(request.getParameter("paramtypes_nc"));
		String labelnames_nc = Util.null2String(request.getParameter("labelnames_nc"));
		String paraencrypt_nc = Util.null2String(request.getParameter("paraencrypt_nc"));
		String encryptcode_nc = Util.null2String(request.getParameter("encryptcode_nc"));
		RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramnames_nc+"','','"+labelnames_nc+"',"+paramtypes_nc+",0,'"+paraencrypt_nc+"','"+encryptcode_nc+"')");
	}
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="OutterSys.jsp?backto=<%=backto%>";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
 		response.sendRedirect("OutterSys.jsp?backto="+backto);
	return;
 }
 
else if(operation.equals("edit")){
    RecordSet.executeSql("update outter_sys set sysid='"+sysid+"',name='"+name+"',iurl='"+iurl+"',ourl='"+ourl+"',baseparam1='"+baseparam1+"',baseparam2='"+baseparam2+"',basetype1="+basetype1+",basetype2="+basetype2+",ncaccountcode='"+accountcode+"',requesttype='"+requesttype+"',urlparaencrypt1='"+urlparaencrypt1+"',encryptcode1='"+encryptcode1+"',urlparaencrypt2='"+urlparaencrypt2+"',encryptcode2='"+encryptcode2+"',urlparaencrypt='"+urlparaencrypt+"',encryptcode='"+encryptcode+"',encrypttype='"+encrypttype+"',encryptclass='"+encryptclass+"',encryptmethod='"+encryptmethod+"' where sysid='"+sysid+"'");
    RecordSet.executeSql("delete from outter_sysparam where sysid='"+sysid+"'");
    //System.out.println(paraencrypts.length);
    if(paramnames!=null){     
		for(int i=0;i<paramnames.length;i++){
			String paramname=paramnames[i];
			String paramvalue=paramvalues[i];
			String paramtype=paramtypes[i];
			String labelname=labelnames[i];
			String tparaencrypt="";
			try
			{
				tparaencrypt=paraencrypts[i];
			}
			catch(Exception e)
			{
				
			}
			String tencryptcode=encryptcodes[i];
			if(!tparaencrypt.equals("1"))
				tencryptcode = "";
			if(!paramname.equals(""))
			{
				RecordSet.executeSql("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+",'"+tparaencrypt+"','"+tencryptcode+"')");
				//System.out.println("insert into outter_sysparam(sysid,paramname,paramvalue,labelname,paramtype,indexid,paraencrypt,encryptcode) values('"+sysid+"','"+paramname+"','"+paramvalue+"','"+labelname+"',"+paramtype+","+i+",'"+tparaencrypt+"','"+tencryptcode+"')");
			}
		}
	}
    if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="OutterSys.jsp?backto=<%=backto%>";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
 		response.sendRedirect("OutterSys.jsp?backto="+backto);
 }
 else if(operation.equals("delete")){
	List ids = Util.TokenizerString(sysid,",");
	if(null!=ids&&ids.size()>0)
	{
		for(int i = 0;i<ids.size();i++)
		{
			String tempsysid = Util.null2String((String)ids.get(i));
			if(!"".equals(tempsysid))
			{
			    RecordSet.executeSql("delete from outter_sys where sysid='"+tempsysid+"'");
				RecordSet.executeSql("delete from outter_sysparam where sysid='"+tempsysid+"'");
				RecordSet.executeSql("delete from outter_account where sysid='"+tempsysid+"'");
				RecordSet.executeSql("delete from outter_params where sysid='"+tempsysid+"'");
			}
		}
	}
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="OutterSys.jsp?backto=<%=backto%>";
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
    else
 		response.sendRedirect("OutterSys.jsp?backto="+backto);
 }
%>