<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="SendMail" class="weaver.hrm.resource.SendMail" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />

<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
int id= Util.getIntValue(request.getParameter("id"),0);
int applyid=Util.getIntValue(request.getParameter("applyid"),0);
String issearch = Util.null2String(request.getParameter("issearch"));
int pagenum=Util.getIntValue(request.getParameter("pagenum"),0);  //对员发群件时

int mailid= Util.getIntValue(request.getParameter("mailid"),0);//获得版式id
String selfComment=Util.null2String(request.getParameter("selfComment"));//用户自输入邮件正文内容

String subject = Util.null2String(request.getParameter("subject"));//邮件subject
String from = Util.null2String(request.getParameter("from"));      //发件人地址

/* 分为用户自输入邮件正文和采用版式两种方式,每种方式要虑到来自不同的4种情况*/
if(mailid==0){//不采用版式时而在文本框输入信件内容的情况

	SendMail.setSelfComment(selfComment);
	SendMail.setSubject(subject);
	SendMail.setFrom(from);
	if(issearch.equals("1"))//对某类员工发邮件
		{
			if(!SearchClause.getWhereClause().equals(""))
				RecordSet.executeSql("select id from HrmResource where "+SearchClause.getWhereClause());
			else 
				RecordSet.executeSql("select id from HrmResource");
				while(RecordSet.next())
					{
						SendMail.setHRMId(RecordSet.getInt("id"));
						SendMail.SendHtmlMail2(request);	
					}
		}
	else if(id!=0&&id!=(-1))//对某个员工发邮件
		{
			SendMail.setHRMId(id);
			SendMail.SendHtmlMail2(request);
			response.sendRedirect("HrmResource.jsp?id="+id);
			return;
		}
	else if(pagenum!=0&&pagenum!=(-1))//对一类应聘者发邮件
		{	
			
			if(!SearchClause.getWhereClause().equals("")){
				RecordSet.executeSql("select id from HrmCareerApply "+SearchClause.getWhereClause());
				while(RecordSet.next())
					{
						SendMail.setApplyId(RecordSet.getInt("id"));
						SendMail.SendHtmlMailApply2(request);
						
						
					}
			}
			else{ 
				RecordSet.executeSql("select id from HrmCareerApply");
				while(RecordSet.next())
					{
						SendMail.setApplyId(RecordSet.getInt("id"));
						SendMail.SendHtmlMailApply2(request);				
					}
			}
	        response.sendRedirect("/hrm/career/HrmCareerApplyResult.jsp?pagenum="+pagenum);
			return;
		}
	
    else if(applyid!=0&&applyid!=(-1))//对某个应聘者发邮件
		{   
			SendMail.setApplyId(applyid);
			SendMail.SendHtmlMailApply2(request);
			response.sendRedirect("/hrm/career/HrmCareerApplyEdit.jsp?applyid="+applyid);
			return;
		}

}else//采用版式时情况
{
		SendMail.setMailId(mailid);
		SendMail.setSubject(subject);
		SendMail.setFrom(from);
		if(issearch.equals("1"))//对某类员工发邮件
			{
				if(!SearchClause.getWhereClause().equals(""))
				RecordSet.executeSql("select id from HrmResource where "+SearchClause.getWhereClause());
				else 
				RecordSet.executeSql("select id from HrmResource");
				while(RecordSet.next()){
				SendMail.setHRMId(RecordSet.getInt("id"));
				SendMail.SendHtmlMail(request);	
			}
		}
		else if(id!=0&&id!=(-1))//对某个员工发邮件
			{
				SendMail.setHRMId(id);
				SendMail.SendHtmlMail(request);
				response.sendRedirect("HrmResource.jsp?id="+id);
				return;
			}
		else if(pagenum!=0&&pagenum!=(-1))//对一类应聘者邮件
		{	
			if(!SearchClause.getWhereClause().equals("")){
				RecordSet.executeSql("select id from HrmCareerApply "+SearchClause.getWhereClause());
				while(RecordSet.next())
					{
						SendMail.setApplyId(RecordSet.getInt("id"));
						SendMail.SendHtmlMailApply(request);
					}}
				else{
				RecordSet.executeSql("select id from HrmCareerApply");
				while(RecordSet.next())
					{
						SendMail.setApplyId(RecordSet.getInt("id"));
						SendMail.SendHtmlMailApply(request);
						
					}
			}
			response.sendRedirect("/hrm/career/HrmCareerApplyResult.jsp?pagenum="+pagenum);
			return;
		}
		else if(applyid!=0&&applyid!=(-1))//对某个应聘者发邮件
		{
			SendMail.setApplyId(applyid);
			SendMail.SendHtmlMailApply(request);
			response.sendRedirect("/hrm/career/HrmCareerApplyEdit.jsp?applyid="+applyid);
			return;
		}
}
response.sendRedirect("/hrm/search/HrmResourceSearchResult.jsp?hassql=1");
%>