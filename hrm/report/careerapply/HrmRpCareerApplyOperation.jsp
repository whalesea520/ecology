
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="session" />

<% 
char separator = Util.getSeparator() ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
int currentyear=today.get(Calendar.YEAR);
String Name=Util.fromScreen(request.getParameter("Name"),user.getLanguage());

String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

HrmCareerApplyComInfo.setFromdateselect(fromdateselect);
HrmCareerApplyComInfo.setFromDate(fromdate);
HrmCareerApplyComInfo.setEndDate(enddate)//应聘日期
;
HrmCareerApplyComInfo.setName(Util.fromScreen(request.getParameter("Name"),user.getLanguage())) ;	/*姓名*/
HrmCareerApplyComInfo.setJobTitle(Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage())) ;/*应聘职位*/

if (!request.getParameter("CareerAgeFrom").equals(""))
{
    String CareerAgeFrom=""+(currentyear-Util.getIntValue(request.getParameter("CareerAgeFrom"),0))+currentdate.substring(4) ;//得最大生日时间
    HrmCareerApplyComInfo.setCareerAgeFrom(CareerAgeFrom);    
}
if (!request.getParameter("CareerAgeTo").equals(""))
{
    String CareerAgeTo =""+(currentyear-Util.getIntValue(request.getParameter("CareerAgeTo"),0))+currentdate.substring(4);//得最小生日时间
    HrmCareerApplyComInfo.setCareerAgeTo(CareerAgeTo);
}

HrmCareerApplyComInfo.setEducationLevel(Util.fromScreen(request.getParameter("EducationLevel"),user.getLanguage())) ;//学历
HrmCareerApplyComInfo.setSex(Util.fromScreen(request.getParameter("Sex"),user.getLanguage())) ;//性别
HrmCareerApplyComInfo.setMaritalStatus(Util.fromScreen(request.getParameter("MaritalStatus"),user.getLanguage())) ;//婚姻
HrmCareerApplyComInfo.setRegResidentPlace(Util.fromScreen(request.getParameter("RegResidentPlace"),user.getLanguage())) ;//户口所在地
HrmCareerApplyComInfo.setCategory(Util.fromScreen(request.getParameter("Category"),user.getLanguage()));//类别
HrmCareerApplyComInfo.setWorkTimeFrom(Util.fromScreen(request.getParameter("WorkTimeFrom"),user.getLanguage()));
HrmCareerApplyComInfo.setWorkTimeTo(Util.fromScreen(request.getParameter("WorkTimeTo"),user.getLanguage())); //工作年限
HrmCareerApplyComInfo.setSalaryNeedFrom(Util.fromScreen(request.getParameter("SalaryNeedFrom"),user.getLanguage())); 
HrmCareerApplyComInfo.setSalaryNeedTo(Util.fromScreen(request.getParameter("SalaryNeedTo"),user.getLanguage())); //年薪低限

String plan = Util.null2String(request.getParameter("plan"));

response.sendRedirect("/hrm/report/careerapply/HrmRpCareerApplySearch.jsp?plan="+plan);
%>