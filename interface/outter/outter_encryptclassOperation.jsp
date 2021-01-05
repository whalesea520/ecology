<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
FileUpload fu = new FileUpload(request);
String isDialog = Util.null2String(fu.getParameter("isdialog"));
String backto = Util.null2String(fu.getParameter("backto"));//返回类型
String operation = Util.fromScreen(fu.getParameter("operation"),user.getLanguage());
String id = Util.fromScreen(fu.getParameter("id"),user.getLanguage());

String encryptclass = Util.fromScreen(fu.getParameter("encryptclass"),user.getLanguage());
String encryptmethod = Util.fromScreen(fu.getParameter("encryptmethod"),user.getLanguage());
String mode = Util.fromScreen(fu.getParameter("mode"),user.getLanguage());

/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/
String encryptname = Util.fromScreen(fu.getParameter("encryptname"),user.getLanguage());
String oldencryptname = Util.fromScreen(fu.getParameter("oldencryptname"),user.getLanguage());
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/

int userid = user.getUID();
String createdate = TimeUtil.getCurrentTimeString();
char separator = Util.getSeparator() ;
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 start*/
if(operation.equals("add")){
    String sql = "select * from outter_encryptclass where encryptname = '"+encryptname+"'";
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
       response.sendRedirect("outter_encryptclassAdd.jsp?isexist="+"true"+"&backto="
                              +backto+"&isdialog="+isDialog+"&encryptname="+encryptname
                              +"&encryptmethod="+encryptmethod+"&encryptclass="+encryptclass);
	   return;
    }else{
      RecordSet.executeSql("insert into outter_encryptclass(encryptclass,encryptmethod,encryptname) values('"+encryptclass+"','"+encryptmethod+"','"+encryptname+"')");
    }
}
else if(operation.equals("edit")){
    String sql = "select * from outter_encryptclass where encryptname = '"+encryptname+"' and encryptname<>'"+oldencryptname+"'";
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
       response.sendRedirect("outter_encryptclassEdit.jsp?isexist="+"true"+"&id="+id+"&backto="+backto+"&isdialog="+isDialog);
	   return;
    }else{
	  RecordSet.execute("update outter_encryptclass set encryptclass = '"+encryptclass+"',encryptmethod = '"+encryptmethod+"',encryptname='"+encryptname+"' where id= "+id);
    }
}
/*QC308826 [80][优化]集成登录-自定义加密算法设置中增加一个字段【算法名称】，集成登录配置中自定义加密算法选择相应的算法名称 end*/
else if(operation.equals("delete")){
	List ids = Util.TokenizerString(id,",");
	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++)		{
			String tempsysid = Util.null2String((String)ids.get(i));
			
			if(!"".equals(tempsysid))			
			{
				RecordSet.execute("delete from outter_encryptclass where id = "+tempsysid);
			}
		}
	}
}
if("1".equals(isDialog)){
	
	if(!mode.equals("1")){
%>
<script language=javascript >
try{
	//var parentWin = parent.getParentWindow(window);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location.href="/interface/outter/outter_encryptclass.jsp?backto=<%=backto%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}else{
	
	%>
	<script language=javascript >
	try{
		
	var dialog = parent.parent.getDialog(parent);
	 dialog.callback();
     dialog.close();
	
	}
	catch(e){
	}
	</script>
	<%
}
}
else
response.sendRedirect("/interface/outter/outter_encryptclass.jsp?backto="+backto);
%>