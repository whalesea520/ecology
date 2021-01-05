
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="weaver.security.util.SecurityMethodUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wbe" class="weaver.admincenter.homepage.WeaverBaseElementCominfo" scope="page" />
<jsp:useBean id="ecc" class="weaver.admincenter.homepage.ElementCustomCominfo" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
String ebaseid = Util.null2String(request.getParameter("ebaseid"));
//校验ebaseid是否是阿拉伯数字和英文字母组成
if(!SecurityMethodUtil.isNumbersAndLetters(ebaseid)){
   return;
}
String operate = Util.null2String(request.getParameter("operate"));
char separator = Util.getSeparator();
String msg = "ERROR";
if("".equals(ebaseid)){
	out.print(msg);
	return;
}
if("onArchive".equals(operate)){//封存
	if(ebaseid.indexOf(",")!=-1){
		ebaseid=ebaseid.substring(0,ebaseid.length()-1);
		ebaseid=ebaseid.replaceAll(",","','");
	}
	ebaseid = "'"+ebaseid+"'";
	if(rs.executeSql("update hpBaseElement set isuse=0 where id in("+ebaseid+")"))
		msg="OK";
	wbe.updateBaseElementCache(ebaseid);
	out.print(msg);
	
}else if("unArchive".equals(operate)){//解封
	
	if(ebaseid.indexOf(",")!=-1){
		ebaseid=ebaseid.substring(0,ebaseid.length()-1);
		ebaseid=ebaseid.replaceAll(",","','");
	}
	ebaseid = "'"+ebaseid+"'";
	if(rs.executeSql("update hpBaseElement set isuse=1 where id in("+ebaseid+")"))
		msg="OK";
	wbe.updateBaseElementCache(ebaseid);
	out.print(msg);
}else if("del".equals(operate)){//删除元素
	String path = request.getSession(true).getServletContext().getRealPath("/");
	File file = new File(path+"page/elementCustom/"+ebaseid);
	if(file.isDirectory())
		FileUtils.deleteDirectory(file);
	file = new File(path+"/page/elementCustom/zip/"+ebaseid+".zip");
	if(file.exists())file.delete();
	if(rs.executeSql("delete from hpBaseElement where id ='"+ebaseid+"'")){
		msg="OK";
		wbe.removeCache(ebaseid);
		ecc.removeCache(ebaseid);
	}
	out.print(msg);
}else if("delReferences".equals(operate)){//删除元素引用
	String hpid = Util.null2String(request.getParameter("hpid"));
	String module = Util.null2String(request.getParameter("module"));
	if("Portal".equals(module)){//处理老数据
		if(hpid.indexOf(",")!=-1)hpid=hpid.substring(0,hpid.length()-1);
		String[] hpids = Util.TokenizerStringNew(hpid,",");
		for(int i=0;i<hpids.length;i++){
			if("oracle".equals(rs.getDBType())){
				rs.executeUpdate("call Hplayout_eid_update(?,?)", new Object[] {hpids[i],ebaseid});
			}else if("sqlserver".equals(rs.getDBType())){
				rs.executeUpdate("exec Hplayout_eid_update ?,?", new Object[] {hpids[i],ebaseid});
			}
		//	rs.executeProc("Hplayout_eid_update",hpids[i]+separator+ebaseid+separator+module);
		}
		msg="OK";
	}
	out.print(msg);
}
wbe.removeBaseElementCache();
%>
