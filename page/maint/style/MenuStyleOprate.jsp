
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.configuration.XMLConfiguration" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.io.File" %>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageManager" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) return;

String styleid = Util.null2String(request.getParameter("styleid"));
String type = Util.null2String(request.getParameter("type"));
String operate = Util.null2String(request.getParameter("operate"));

if("changetype".equals(operate)){
	StringBuffer styleStr = new StringBuffer();
	rs.executeSql("select styleid,menustylename from hpMenuStyle where menustyletype='"+type+"'");
	while(rs.next()){
		styleStr.append("<option value='").append(rs.getString("styleid")).append("'").append(("template".equals(rs.getString("styleid"))?"selected":"")).append(">").append(rs.getString("menustylename")).append("</option>");
	}
	out.print(styleStr.toString());
}else if("delStyle".equals(operate)){
	String path="";
	if("element".equals(type)){
		path=pc.getConfig().getString("style.conf");
	} else if("menuh".equals(type)){
		path=pc.getConfig().getString("menuh.conf");
	} else if("menuv".equals(type)){
		path=pc.getConfig().getString("menuv.conf");
	}
	//删除文件
	File target=new File(pm.getRealPath(path+styleid+".xml"));
	target.delete();
	
	//删除缓存
	if("element".equals(type)){
		esc.clearCominfoCache();
	} else if("menuh".equals(type)){
		mhsc.clearCominfoCache();
	} else if("menuv".equals(type)){
		mvsc.clearCominfoCache();
	}
	rs.executeSql("delete from hpMenuStyle where styleid='"+styleid+"' and menustyletype='"+type+"'");
	out.print("OK");
}else if("delAllStyle".equals(operate)){
	String path="";
	styleid = styleid.substring(0,styleid.length()-1);
	type = type.substring(0,type.length()-1);
	String[] styleids = styleid.split(",");
	String[] types = type.split(",");
	for(int i=0;i<styleids.length;i++){
		if("element".equals(types[i])){
			path=pc.getConfig().getString("style.conf");
		} else if("menuh".equals(types[i])){
			path=pc.getConfig().getString("menuh.conf");
		} else if("menuv".equals(types[i])){
			path=pc.getConfig().getString("menuv.conf");
		}
		//删除文件
		File target=new File(pm.getRealPath(path+styleids[i]+".xml"));
		target.delete();
		
		rs.executeSql("delete from hpMenuStyle where styleid='"+styleids[i]+"' and menustyletype='"+types[i]+"'");
	}
	//删除缓存
	if(type.indexOf("element")!=-1){
		esc.clearCominfoCache();
	}
	if(type.indexOf("menuh")!=-1){
		mhsc.clearCominfoCache();
	} 
	if(type.indexOf("menuv")!=-1){
		mvsc.clearCominfoCache();
	}
	out.print("OK");
}else if("saveNew".equals(operate)){	
	String pageUrl = Util.null2String(request.getParameter("pageUrl"));
	String menucite = Util.null2String(request.getParameter("menustylecite"));
	String menuname = Util.null2String(request.getParameter("menustylename"));
	String menudesc = Util.null2String(request.getParameter("menustyledesc"));
	long now = System.currentTimeMillis();
	String id=""+now;	
	String pageEdit="";
	//copy 文件
	String path="";
	if("element".equals(type)){				
		path=pc.getConfig().getString("style.conf");
	} else if("menuh".equals(type)){
		path=pc.getConfig().getString("menuh.conf");
	} else if("menuv".equals(type)){
		path=pc.getConfig().getString("menuv.conf");
	}
	File src=new File(pm.getRealPath(path+styleid+".xml"));
	File target=new File(pm.getRealPath(path+id+".xml"));
	
	FileUtils.copyFile(src,target);
	//修改新的文件
	XMLConfiguration configStyle=pm.getConfig(path+id+".xml");
	configStyle.setEncoding("UTF-8");
	configStyle.setProperty("id",id);
	configStyle.setProperty("title",menuname);
	configStyle.setProperty("desc",menudesc);
	//configStyle.setSystemID("");
	configStyle.save();
	
	String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
	rs.executeSql("INSERT INTO hpMenuStyle (styleid,menustylename,menustyledesc,menustyletype,menustylecreater,menustylemodifyid,menustylelastdate,menustylelasttime,menustylecite)"
			+"VALUES('"+id+"','"+menuname+"','"+menudesc+"','"+type+"','"+user.getUID()+"','"+user.getUID()+"','"+date+"','"+time+"','"+menucite+"')");
	
	if("element".equals(type)){		
		pageEdit="ElementStyleEdit.jsp";
		esc.clearCominfoCache();
	} else if("menuh".equals(type)){
		pageEdit="MenuStyleEditH.jsp";
		mhsc.clearCominfoCache();
	} else if("menuv".equals(type)){
		pageEdit="MenuStyleEditV.jsp";
		mvsc.clearCominfoCache();
	}
	if(!"".equals(pageUrl))pageEdit=pageUrl;
	response.sendRedirect(pageEdit+"?closeDialog=close&operate=saveNew&type="+type+"&styleid="+id);
}
%>
