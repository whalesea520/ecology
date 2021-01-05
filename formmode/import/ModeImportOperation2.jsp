<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.imports.SessionContextHolder"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_function.jsp"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.formmode.service.*"%>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormmodeDataService" class="weaver.formmode.imports.services.FormmodeDataService" scope="page" />
<%!
String getImportTitle(int type,User user)
{
	String title = "";
	switch(type)
	{
		case 0:
			title = "htmllabel";
			break;
		case 1:
			title = SystemEnv.getHtmlLabelName(82315,user.getLanguage());//表单或单据基本数据
			break;
		case 2:
			title = SystemEnv.getHtmlLabelName(82316,user.getLanguage());//老表单字段
			break;
		case 3:
			title = SystemEnv.getHtmlLabelName(82317,user.getLanguage());//老表单明细字段
			break;
		case 4:
			title = SystemEnv.getHtmlLabelName(82318,user.getLanguage());//表单或单据字段
			break;
		case 5:
			title = "select"+SystemEnv.getHtmlLabelName(15601,user.getLanguage());//字段信息
			break;
		case 6:
			title = SystemEnv.getHtmlLabelName(82319,user.getLanguage());//特殊字段信息
			break;
		case 7:
			title = SystemEnv.getHtmlLabelName(82320,user.getLanguage());//字段规则信息
			break;
		case 8:
			title = SystemEnv.getHtmlLabelName(82321,user.getLanguage());//获取或保存模块类型
			break;
		case 9:
			title = SystemEnv.getHtmlLabelName(82322,user.getLanguage());//保存模块基本信息数据
			break;
		case 10:
			title = SystemEnv.getHtmlLabelName(82323,user.getLanguage());//保存模块扩展信息
			break;
		case 11:
			title = SystemEnv.getHtmlLabelName(82324,user.getLanguage())+"1";//保存html模式字段属性1
			break;
		case 12:
			title = SystemEnv.getHtmlLabelName(82324,user.getLanguage())+"2";//保存html模式字段属性2
			break;
		case 13:
			title = SystemEnv.getHtmlLabelName(82324,user.getLanguage())+"3";//保存html模式字段属性3
			break;
		case 14:
			title = SystemEnv.getHtmlLabelName(82324,user.getLanguage())+"4";//保存html模式字段属性4
			break;
		case 15:
			title = SystemEnv.getHtmlLabelName(82326,user.getLanguage());//保存默认值
			break;
		case 16:
			title = SystemEnv.getHtmlLabelName(82327,user.getLanguage());//保存编码
			break;
		case 17:
			title = SystemEnv.getHtmlLabelName(82329,user.getLanguage());//保存默认值明细
			break;
		case 18:
			title = SystemEnv.getHtmlLabelName(82330,user.getLanguage());//保存显示属性联动
			break;
		case 19:
			title = SystemEnv.getHtmlLabelName(82331,user.getLanguage())+"1";//保存字段联动1
			break;
		case 20:
			title = SystemEnv.getHtmlLabelName(82331,user.getLanguage())+"2";//保存字段联动2
			break;
		case 21:
			title = SystemEnv.getHtmlLabelName(82331,user.getLanguage())+"3";//保存字段联动3
			break;
		case 22:
			title = SystemEnv.getHtmlLabelName(82331,user.getLanguage())+"4";//保存字段联动4
			break;
		case 23:
			title = SystemEnv.getHtmlLabelName(82333,user.getLanguage())+"1";//保存自定义查询1
			break;
		case 24:
			title = SystemEnv.getHtmlLabelName(82334,user.getLanguage());//保存自定义查询明细
			break;
		case 25:
			title = SystemEnv.getHtmlLabelName(82335,user.getLanguage())+"1";//保存自定义报表1
			break;
		case 26:
			title = SystemEnv.getHtmlLabelName(82337,user.getLanguage());//保存自定义报表明细
			break;
		case 27:
			title = SystemEnv.getHtmlLabelName(82338,user.getLanguage())+"1";//保存自定义浏览框1
			break;
		case 28:
			title = SystemEnv.getHtmlLabelName(82334,user.getLanguage());//保存自定义查询明细
			break;
		case 29:
			title = SystemEnv.getHtmlLabelName(82339,user.getLanguage());//保存浏览框标识
			break;
		case 30:
			title = SystemEnv.getHtmlLabelName(82477,user.getLanguage());//公共选择项
			break;
		default:
			title = "";
			break;
	}
	return title;
		
}
%>
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();

if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}


/*
FileUpload fu = new FileUpload(request,false,false);
FileManage fm = new FileManage();

String xmlfilepath="";
int fileid = 0 ;
String remoteAddr = fu.getRemoteAddr();
fileid = Util.getIntValue(fu.uploadFiles("filename"),0);
String filename = fu.getFileName();
String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
RecordSet.executeSql(sql);
String uploadfilepath="";
String isaesencrypt = "";
String aescode = "";
if(RecordSet.next()){
	uploadfilepath =  RecordSet.getString("filerealpath");
	isaesencrypt = Util.null2String(RecordSet.getString("isaesencrypt"));
	aescode = Util.null2String(RecordSet.getString("aescode"));
}
String exceptionMsg ="";
if(!uploadfilepath.equals(""))
{
	try
	{
		xmlfilepath = GCONST.getRootPath()+"formmode"+File.separatorChar+"import"+File.separatorChar+filename ;
		File oldfile = new File(xmlfilepath);
		if(oldfile.exists())
		{
			oldfile.delete();
		}
		fm.copy(uploadfilepath,xmlfilepath);
	}
	catch(Exception e)
	{
	}
}
FormmodeDataService.setRemoteAddr(remoteAddr);
FormmodeDataService.setUser(user);
SessionContextHolder.setSession(session);
int appid=NumberHelper.getIntegerValue(fu.getParameter("appid"),0);
boolean isAppImport=!StringHelper.isEmpty(fu.getParameter("isAppImport"));
*/
String exceptionMsg ="";
String xmlfilepath = StringHelper.null2String(request.getParameter("xmlfilepath"));
int appid = Util.getIntValue(request.getParameter("appid"),0);
boolean isAppImport=!StringHelper.isEmpty(request.getParameter("isAppImport"));
String tabletype = StringHelper.null2String(request.getParameter("tabletype"));
SessionContextHolder.setSession(session);
String remoteAddr = request.getRemoteAddr();
FormmodeDataService.setRemoteAddr(remoteAddr);
FormmodeDataService.setUser(user);

AppInfoService appInfoService = new AppInfoService();
Map<String, Object> appInfo = appInfoService.getAppInfoById(appid);
String userRightStr = "FORMMODEAPP:ALL";
int subCompanyId = Util.getIntValue(Util.null2String(appInfo.get("subCompanyId")),-1);
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable ,subCompanyId,"",request,response,session);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

FormmodeDataService.importFormmodeByXml2(xmlfilepath,appid,isAppImport,tabletype,subCompanyId);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>  
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelweb_tw_wev8.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelweb_wev8.js"></script>
<%} %>
<script language=javascript>
function displayExcel()
{
	var divs = document.getElementsByTagName("div");
	if(divs)
	{
		divs[0].style.display="none";
	}
}
</script>
</head>
<BODY onload="displayExcel();">
	<%
	//out.println("<TABLE class=liststyle><COLGROUP><COL width='25%'><COL width='25%'><COL width='30%'><COL width='15%'><COL width='5%'><TR class=Title><TH colSpan=5>导入结果</TH></TR><TR class=Spacing><TD class=Line1 colSpan=5></TD></TR>");

	
	exceptionMsg = Util.null2String(FormmodeDataService.getExceptionMsg());
	Map MsgMap = FormmodeDataService.getMsgMap();
	out.println("<TABLE class=liststyle><COLGROUP><COL width='25%'><COL width='25%'><COL width='30%'><COL width='15%'><COL width='5%'>");//导入结果

   	out.println("<tr class=header>");
   	out.println("<td>"+SystemEnv.getHtmlLabelName(31830,user.getLanguage())+"id</td>");//关联
    out.println("<td>"+SystemEnv.getHtmlLabelName(21900,user.getLanguage())+"</td>");//表名
    out.println("<td>"+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"</td>");//操作
    out.println("<td>"+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"</td>");//描述
    out.println("<td>"+SystemEnv.getHtmlLabelName(82342,user.getLanguage())+"</td>");//导入状态
    out.println("</tr>");
    boolean islight=false;
    String bgcolorvalue="#f5f5f5";
    if(MsgMap!=null)
    {
	    if (MsgMap.size() > 0) 
	    {
	    	List MsgList = new ArrayList(); 
	    	Map msg = new HashMap();
	    	String status = "";
	    	String title = "";
	    	for(int i = 0;i<35;i++)
	    	{
	    		MsgList = (List)MsgMap.get(""+i);
	    		if(MsgList!=null)
	    		{
	    			if(MsgList.size()>0)
	    			{
	    				title = getImportTitle(i,user);
	    				out.println("<TR class=Spacing><TD  colSpan=5>&nbsp;</TD></TR><TR class=Title><TH colSpan=5  style=\"text-align: center;\">"+title+"</TH></TR>");
	    				for(int j=0;j<MsgList.size();j++)
		                {
		                	if(islight){
		                        bgcolorvalue="#f5f5f5";
		                        islight=!islight;
		                    }else{
		                        bgcolorvalue="#e7e7e7";
		                        islight=!islight;
		                    }
		                	msg.clear();
		                	msg = (Map)MsgList.get(j);
		                	status = (String)msg.get("status");
		                	if(status.equals("1"))
		                	{
		                		status = SystemEnv.getHtmlLabelName(15242,user.getLanguage());//成功
		                	}
		                	else
		                	{
		                		status = SystemEnv.getHtmlLabelName(498,user.getLanguage());//失败
		                	}
		    	            out.println("<tr bgcolor="+bgcolorvalue+">");
		    	            out.println("<td>"+msg.get("key")+"</td>");
		    	            out.println("<td>"+msg.get("tablename")+"</td>");
		    	            out.println("<td style='word-break:break-all;'>"+msg.get("msgname")+"</td>");
		    	            out.println("<td style='word-break:break-all;'>"+msg.get("desc")+"</td>");
		    	            out.println("<td>"+status+"</td>");
		    	            out.println("</tr>");
		                }
	    			}
	     		
	    		}
	    	}
	    }
    }
    if(islight){
        bgcolorvalue="#f5f5f5";
        islight=!islight;
    }else{
        bgcolorvalue="#e7e7e7";
        islight=!islight;
    }
    if(!exceptionMsg.equals(""))
    {
    	out.println("<tr bgcolor="+bgcolorvalue+">");
        out.println("<td colSpan=5>"+exceptionMsg+"</td>");
        out.println("</tr>");
    }
    out.println("<TR><TD class=Line colSpan=5></TD></TR></table>");
%>
</BODY>
</HTML>