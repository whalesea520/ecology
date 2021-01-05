<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.sms.annotation.AnnotationUtils"%>
<%@page import="java.lang.reflect.Field"%>
<%@page import="weaver.sms.annotation.SmsField"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.rtx.RTXConfig"%>
<%@page import="java.net.Socket"%>
<%@page import="java.net.InetSocketAddress"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

FileUpload fu = new FileUpload(request);
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = fu.getRemoteAddr();


String method = Util.null2String(fu.getParameter("method"));
//获取数据源
if("getDS".equals(method)){

	List datasourceList = DataSourceXML.getPointArrayList();
	JSONArray jarr=new JSONArray();
	for (int i = 0; i < datasourceList.size(); i++)
	{
		String pointid = Util.null2String((String) datasourceList.get(i));
		JSONObject jsn = new JSONObject();
		jsn.put("id", "datasource."+pointid);
		jsn.put("name", pointid);
		jarr.add(jsn);
	}
	out.print(jarr.toString());
}else if("getClass".equals(method)){//获取类接口
	String constructclass = Util.null2String(fu.getParameter("smsClazzName"));
	String justhead = Util.null2String(fu.getParameter("justhead"));
%> 
	   <div class="optiongroup"><div class="optionhead"><div class="optionToolbar"></div></div>
		  <div class="tablecontainer"> 
		  <table class="grouptable">
		  <colgroup>
		  	  <col width='1%'>
			  <col width='20%'>
			  <col width='40%'>
			  <col width='30%'>
		  </colgroup>
		  <thead>
			  <tr class="">
			  	<th></th>
			   	<th><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></th>
 				<th><%=SystemEnv.getHtmlLabelName(19113,user.getLanguage())%></th>
 				<th><%=SystemEnv.getHtmlLabelName(82159,user.getLanguage())%></th>
 		  </tr>
		  </thead>
		  <tbody>
	   <% 
	    if(!"true".equals(justhead)){
	   		Class clazz=null;
		 	try{
	   			clazz=Class.forName(constructclass);
	   		 }catch(Exception e){
	   			
	   		 }  	
			int row=0;
			if(clazz!=null){
				Field[] fields= AnnotationUtils.getFields(clazz);
				for(Field field:fields){
					SmsField smsField=AnnotationUtils.getFieldAnnotations(field);
					if(AnnotationUtils.isHide(smsField)) continue;
				    String nameS = field.getName();
				    String nameDesc = AnnotationUtils.getDesc(smsField);
				    String valueS = AnnotationUtils.getDefValueDesc(smsField);
				    String example = AnnotationUtils.getExample(smsField);								    
				    boolean must=AnnotationUtils.isMust(smsField);
	        		//展示历史数据
       				out.println("<tr  class='contenttr'>\n"); 
           			out.println("<td></td><td><span>"+nameS+(!"".equals(nameDesc)?"&nbsp;&nbsp;("+nameDesc+")":"")+"</span><input class='InputStyle' type='hidden' name='attrP_"+row+"' value='"+nameS+"'></td>\n");
           			out.println("<td><input class='InputStyle' type='text' name='attrV_"+row+"' value='"+valueS+"'></td>\n");
           			out.println("<td><span>"+example+"</span>\n");
       				out.println("</tr>\n"); 
       				out.println("<tr style='height:1px'><td colspan='4' style='height: 1px'><div class='linesplit' ></div></td></tr>\n"); 
       				row++;
	        	}
			}
			out.println("<input type='hidden'  name='clazz_rowcount' id='clazz_rowcount' value='"+row+"' >");
	    }
	   %>
	   </tbody></table></div></div>
<%}else if("checkModem".equals(method)){
	boolean ret=false;
	String smsServer=Util.null2String(fu.getParameter("smsServer"));
	String[] str=smsServer.split(":");
	String ip="";
	int port=8090;
	if(str.length>0){
		ip=str[0];
	}
	if(str.length>1){
		port=Util.getIntValue(str[1],8090);
	}
	Socket socket = new Socket();
	try{
		socket.connect(new InetSocketAddress(ip, port),5000);//连接超时
		socket.setSoTimeout(5000);//读取超时
		DataInputStream is = new DataInputStream(new BufferedInputStream(socket.getInputStream()));
		DataOutputStream os = new DataOutputStream(new BufferedOutputStream(socket.getOutputStream()));
	    String isstr = is.readLine();
	    if (isstr.equalsIgnoreCase("OK")) {
	        ret = true;
	    }
	}catch (Exception e){
		RecordSet.writeLog("短信modem检测不通过："+e);
	}finally{
		socket.close();
	}
	out.clearBuffer();
	out.print(ret);
	out.close();
	return;
}
%>
