<%@ page buffer="4kb" autoFlush="true"%>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%!
/** 由于这里的参数是用上传组件解析的，所以中文字符的默认编码是ISO-8859-1，需要转换编码至GBK */
	private static String toGBK(String str){
		String s=str;
		try{
			s=new String(str.getBytes("ISO-8859-1"),"GBK");
		}catch(UnsupportedEncodingException uee){	}
		return s;
	}
%>
<jsp:useBean id="ExcelParse" class="weaver.file.ExcelParse" scope="page" />
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="moduleFile" class="weaver.datacenter.InputReportModuleFile" scope="page"/>

<%
FileUploadToPath fu = new FileUploadToPath(request) ;
Hashtable ht = new Hashtable() ;
ArrayList crmids = new ArrayList() ;
ArrayList crmnames = new ArrayList() ;
while(CustomerInfoComInfo.next()) {
    crmids.add(CustomerInfoComInfo.getCustomerInfoid()) ;
    crmnames.add(CustomerInfoComInfo.getCustomerInfoname()) ;
}

String filename = fu.uploadFiles("file1") ;
String inprepid = Util.null2String(fu.getParameter("inprepid"));
String filetype = Util.null2String(fu.getParameter("filetype"));
String fromcheck = Util.null2String(fu.getParameter("fromcheck"));
String reportDates=Util.null2String(fu.getParameter("reportDates"));
String overWriter=Util.null2String(fu.getParameter("isOverWriter"));
boolean isOverWriter=overWriter.equalsIgnoreCase("true")?true:false;
String crmid = ""+user.getUID() ;
String reportuserid = "" + Util.getIntValue(user.getTitle(), 0) ;
String actionpage = "" ;

if(fromcheck.equals("1")) actionpage = "/datacenter/maintenance/reportstatus/ReportDetailStatus.jsp" ;
else actionpage = "InputReportDate.jsp";

int iFileType=Util.getIntValue(filetype,1);

if(!filename.equalsIgnoreCase("")){
	if(iFileType<4 && iFileType>0){
		int iInprepId=Integer.parseInt(inprepid);
		int iCrmid =Integer.parseInt(fu.getParameter("crmid"));
		int reprotHrmId = Integer.parseInt(fu.getParameter("reprotHrmId"));
		
		/** 将指定文件名的$fname文件导入inprepId的报表数据库中 */
		moduleFile.importData(filename,iFileType,iInprepId,reprotHrmId,iCrmid,user.getUID(),reportDates,isOverWriter);
	}
	FileManage.DeleteFile(filename);
}

/*
actionpage="";
String url=actionpage+"?action=redirect&inprepid="+inprepid;
response.sendRedirect(url);
*/

String returnUrl=Util.null2String(fu.getParameter("returnUrl"));

//param:redirectFormString 获取的是转向页面传递所需要的参数。
%>
<form id="frmMain" name="frmMain" action="<%=returnUrl%>" method="post">
<%=toGBK(Util.null2String(fu.getParameter("redirectFormString")))%>
</form>

<script language=javascript>
function doSubmit(){
	document.frmMain.submit();
}

doSubmit();
</script>

<input type="hidden" name="redirect" id="redirect" value="redirect" onclick="doSubmit()" />