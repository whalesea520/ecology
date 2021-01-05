
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
    request.setCharacterEncoding("UTF-8") ;
	String operation = Util.fromScreen3(request.getParameter("operation"), user.getLanguage());
	String sql = "";
	StringBuffer restr = new StringBuffer();
	
	String userid = user.getUID()+"";
	if("add".equals(operation)){
		
		String para = "";
		String customerid =  Util.null2String(request.getParameter("customerid"));  
		String discusstype =  Util.null2String(request.getParameter("discusstype"));  
		char flag=Util.getSeparator() ;
		String ContactInfo = Util.fromScreen(request.getParameter("ContactInfo"), user.getLanguage());  //相关交流
        ContactInfo=ContactInfo.replaceAll("<br>","<br />");
		String relateddoc = Util.null2String(request.getParameter("relateddoc"));
		String relatedwf = Util.null2String(request.getParameter("relatedwf"));
		String relatedcrm = Util.null2String(request.getParameter("relatedcrm"));
		String relatedprj = Util.null2String(request.getParameter("relatedprj"));
		String relatedtsk = Util.null2String(request.getParameter("relatedtsk"));
		String relatedacc = Util.null2String(request.getParameter("relatedacc"));
		String creater =""+user.getUID();
		String types =discusstype ; 
		String currentdate=TimeUtil.getCurrentDateString();
		String currenttime=TimeUtil.getOnlyCurrentTimeString();
		
		para = customerid;
		para += flag+"";
		para += flag+ContactInfo;
		para += flag+creater;
		para += flag+currentdate ;
		para += flag+currenttime ;
		para += flag+types ;
		para += flag+relateddoc ;
		para += flag+relatedwf ;
		para += flag+relatedcrm ;
		para += flag+relatedprj ;
		para += flag+relatedtsk ;
		para += flag+relatedacc ;
			
		
		
		rs.executeProc("ExchangeInfo_Insert_PRJ",para);
		
	}
	

	out.print(restr.toString());
	out.close();
%>
