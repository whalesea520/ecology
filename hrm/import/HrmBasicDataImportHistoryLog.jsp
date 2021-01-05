<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.FileReader"%>
<jsp:useBean id="FileSecurityTool" class="weaver.hrm.common.FileSecurityTool" scope="page" ></jsp:useBean>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%!
//读取的日志文件根据修改时间进行排序
class CompratorByLastModified implements Comparator  
{   
 public int compare(Object f1, Object f2) {
  File file1=(File)f1; 
  File file2=(File)f2; 
  long diff = file1.lastModified()-file2.lastModified();  
  if(diff<0)   
    return 1;   
  else if(diff==0)   
    return 0;   
  else  
    return 0;   
  }   
}
%>
<%
	String option=request.getParameter("option");
	if("downLoad".equals(option)){
		out.clear();
		String filePath=request.getParameter("path");
		String securityFilePath = FileSecurityTool.get(filePath);
		filePath = GCONST.getRootPath().replace("\\","/")+securityFilePath;
		if(filePath.indexOf(GCONST.getRootPath().replace("\\","/")+"hrm/import/log/")==-1){
			out.println("system error!");
			return;
		}
	 	File file = new File(filePath); 
	 	if(file.exists() && file.isFile()){ 
		 	try { 
				String fileName=filePath.substring(filePath.lastIndexOf("/")+1);	  
			 	BufferedReader bis=new BufferedReader(new FileReader(filePath));
			 	fileName =URLEncoder.encode(fileName, "UTF-8");// 处理中文文件名的问题 
			 	out.clear();
			 	response.reset(); 
			 	response.setContentType("application/x-msdownload");// 不同类型的文件对应不同的MIME类型 
			 	response.setCharacterEncoding("GBK");
			 	response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			 	OutputStream os = response.getOutputStream();
			 	String str="";
			 	while ((str=bis.readLine())!=null){
					os.write((str+"\r\n").getBytes()); 
			 	} 
		 		bis.close(); 
		 		os.flush();
		 		os.close(); 
		 	} catch (Exception e) { 
		 		e.printStackTrace(); 
		 	} 
		} 
	}else if("delete".equals(option)){
		String filePath=request.getParameter("path");
		String securityFilePath = FileSecurityTool.get(filePath);
		filePath = GCONST.getRootPath().replace("\\","/")+securityFilePath;
		if(filePath.indexOf(GCONST.getRootPath().replace("\\","/")+"hrm/import/log/")==-1){
			out.println("system error!");
			return;
		}
		File file = new File(filePath);
	 	if(file.exists() && file.isFile()){ 
		out.clear();
		out.print(file.delete());
	 	}
	}else{
		String importtype=request.getParameter("importtype");
		if(FileSecurityTool.allowType.indexOf(","+importtype+",") < 0){
			out.println("system error!");
			return;
		}
		String filePath=GCONST.getRootPath().replace("\\","/")+"hrm/import/log/"+importtype+"/";
		String relativePath = "hrm/import/log/"+importtype+"/";
		if(filePath.indexOf(GCONST.getRootPath().replace("\\","/")+"hrm/import/log/")==-1){
			out.println("system error!");
			return;
		}
		File logFile=new File(filePath);
	 	if (!logFile.exists()) {
	 		logFile.mkdirs();
		}
		File logList[]=logFile.listFiles();
		if(logList!=null)Arrays.sort(logList,new CompratorByLastModified());
		SimpleDateFormat  dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	if(!user.getLoginid().toLowerCase().equals("sysadmin")){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">callback('log');</script>
	<script type="text/javascript">
		var dialog = parent.parent.getDialog(parent);
		function downLoadLog(path){
  		jQuery("#downLoad").attr("src","/hrm/import/HrmBasicDataImportHistoryLog.jsp?option=downLoad&path="+encodeURI(path));
		}

		function deleteLog(path,obj){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>",function(){
				jQuery.post("/hrm/import/HrmBasicDataImportHistoryLog.jsp?option=delete&path="+encodeURI(path),function(data){
		     	if(jQuery.trim(data)=="true"){
		      	jQuery(obj).parent().parent().remove();
					}
		 		});
		 	})
		}
	</script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17887, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<div class="zDialog_div_content">
	<TABLE class=ListStyle cellspacing=1 >
		<colgroup>
			<col width="30%">
			<col width="50%">
			<col width="10%">
			<col width="10%">
		</colgroup>
		<TR class=HeaderForXtalbe>
	 		<th><%=SystemEnv.getHtmlLabelName(20515,user.getLanguage())%></th>
	 		<th><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></th>
	 		<th><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></th>
	 	</TR>
		<%for(int i=0;logList!=null&&i<logList.length;i++){
			String oriPath =  relativePath+"/"+logList[i].getName();
			String md5Path = FileSecurityTool.put(oriPath);
		%>
		<TR <%if(i%2==0) out.print("class=datalight"); else out.print("class=datadark");%>>
			<td><%=dateFormat.format(new Date(logList[i].lastModified()))%></td>
			<td><%=logList[i].getName()%></td>
			<td>
				<a href="#" onclick="downLoadLog('<%=md5Path%>')"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>
			</td>
			<td>
			  <a href="#" onclick="deleteLog('<%=md5Path%>',this)"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></a>
			</td>
		</TR>
		<%}%>
	</TABLE>
	<iframe id="downLoad" src="" style="display: none;"></iframe>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</HTML>
<%} %>
