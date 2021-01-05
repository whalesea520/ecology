/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._meeting._data;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.meeting.MeetingShareUtil;
import weaver.general.*;
import java.util.*;
import weaver.hrm.User;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.HrmUserVarify;
import weaver.general.IsGovProj;
import java.sql.Timestamp;

public class _ajaxmeetingmember__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet RecordSet2;
      RecordSet2 = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet2");
      if (RecordSet2 == null) {
        RecordSet2 = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet2", RecordSet2);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.MeetingUtil meetingUtil;
      meetingUtil = (weaver.meeting.MeetingUtil) pageContext.getAttribute("meetingUtil");
      if (meetingUtil == null) {
        meetingUtil = new weaver.meeting.MeetingUtil();
        pageContext.setAttribute("meetingUtil", meetingUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.Maint.MeetingSetInfo meetingSetInfo;
      meetingSetInfo = (weaver.meeting.Maint.MeetingSetInfo) pageContext.getAttribute("meetingSetInfo");
      if (meetingSetInfo == null) {
        meetingSetInfo = new weaver.meeting.Maint.MeetingSetInfo();
        pageContext.setAttribute("meetingSetInfo", meetingSetInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.Maint.CustomerInfoComInfo CustomerInfoComInfo;
      CustomerInfoComInfo = (weaver.crm.Maint.CustomerInfoComInfo) pageContext.getAttribute("CustomerInfoComInfo");
      if (CustomerInfoComInfo == null) {
        CustomerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
        pageContext.setAttribute("CustomerInfoComInfo", CustomerInfoComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
User user = HrmUserVarify.getUser(request,response);
String allUser=MeetingShareUtil.getAllUser(user);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:\u975e\u653f\u52a1\u7cfb\u7edf\uff0c1\uff1a\u653f\u52a1\u7cfb\u7edf
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String software = (String)staticobj.getObject("software") ;
if(software == null) software="ALL";

String ProcPara = "";
char flag=Util.getSeparator() ;

String meetingid = Util.null2String(request.getParameter("meetingid"));
boolean canJueyi = Util.str2bool(Util.null2String(request.getParameter("canJueyi")));
String isdecision = Util.null2String(request.getParameter("isdecision"));
String othermembers = Util.null2String(request.getParameter("othermembers"));
boolean ismanager = Util.str2bool(Util.null2String(request.getParameter("ismanager")));

String othersremark = "";
String enddate="";
String endtime="";

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);

String sqlstr="select othersremark,enddate,endtime from meeting where id="+meetingid;
RecordSet.executeSql(sqlstr);
if(RecordSet.next()){
	othersremark = RecordSet.getString("othersremark");
	enddate=RecordSet.getString("enddate");
	endtime=RecordSet.getString("endtime");
}

int hrmnum=0;
int crmnum=0;
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
int reduceCol=7;

      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(2106,user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(2166,user.getLanguage())));
      out.write(' ');
      out.print((RecordSet.getCounts()));
      out.write(' ');
      out.print((SystemEnv.getHtmlLabelName(127,user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(2195,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      if(meetingSetInfo.getRecArrive()==1){reduceCol=reduceCol-1;
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((SystemEnv.getHtmlLabelName(2196,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      } if(meetingSetInfo.getRecBook()==1){reduceCol=reduceCol-2;
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((SystemEnv.getHtmlLabelName(2197,user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(2198,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      }if(meetingSetInfo.getRecReturn()==1){reduceCol=reduceCol-3;
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((SystemEnv.getHtmlLabelName(2199,user.getLanguage())));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((SystemEnv.getHtmlLabelName(2200,user.getLanguage())));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((SystemEnv.getHtmlLabelName(2182,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      }if(meetingSetInfo.getRecRemark()==1){reduceCol=reduceCol-1;
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((SystemEnv.getHtmlLabelName(454,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      } 
      out.write(_jsp_string14, 0, _jsp_string14.length);
      
while(RecordSet.next()){


      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((RecordSet.getString("memberid")));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((ResourceComInfo.getResourcename(RecordSet.getString("memberid"))));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      if(RecordSet.getString("isattend").equals("1")){hrmnum+=1;
      out.print((SystemEnv.getHtmlLabelName(163,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("isattend").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(161,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("isattend").equals("3")){
      out.print((SystemEnv.getHtmlLabelName(2188,user.getLanguage())));
      }
      out.write(_jsp_string19, 0, _jsp_string19.length);
      if(meetingSetInfo.getRecArrive()==1){ 
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((RecordSet.getString("begindate")));
      out.write(' ');
      out.print((RecordSet.getString("begintime")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      } if(meetingSetInfo.getRecBook()==1){
      out.write(_jsp_string20, 0, _jsp_string20.length);
      if(RecordSet.getString("bookroom").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(163,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("bookroom").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(161,user.getLanguage())));
      }
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((RecordSet.getString("roomstander")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }if(meetingSetInfo.getRecReturn()==1){
      out.write(_jsp_string20, 0, _jsp_string20.length);
      if(RecordSet.getString("bookticket").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(163,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("bookticket").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(161,user.getLanguage())));
      }
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((RecordSet.getString("enddate")));
      out.write(' ');
      out.print((RecordSet.getString("endtime")));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      if(RecordSet.getString("ticketstander").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(2201,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(2202,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("3")){
      out.print((SystemEnv.getHtmlLabelName(2203,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("4")){
      out.print((SystemEnv.getHtmlLabelName(2204,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("5")){
      out.print((SystemEnv.getHtmlLabelName(2205,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("6")){
      out.print((SystemEnv.getHtmlLabelName(2206,user.getLanguage())));
      }
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }if(meetingSetInfo.getRecRemark()==1){
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((RecordSet.getString("recRemark")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      } 
      out.write(_jsp_string23, 0, _jsp_string23.length);
       if((canJueyi || MeetingShareUtil.containUser(allUser,RecordSet.getString("membermanager"))) && (!isdecision.equals("1") && !isdecision.equals("2"))&&(enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)>0){
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((RecordSet.getString("id")));
      out.write(',');
      out.print((meetingid));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((SystemEnv.getHtmlLabelName(2108,user.getLanguage())));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      }
      out.write(_jsp_string27, 0, _jsp_string27.length);
      if(!RecordSet.getString("othermember").equals("")){
      out.write(_jsp_string28, 0, _jsp_string28.length);
      
				ArrayList arrayothermember = Util.TokenizerString(RecordSet.getString("othermember"),",");
				for(int i=0;i<arrayothermember.size();i++){
					hrmnum+=1;
			
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print((""+arrayothermember.get(i)));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((ResourceComInfo.getResourcename(""+arrayothermember.get(i))));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      }
      out.write(_jsp_string31, 0, _jsp_string31.length);
      }
      out.write(_jsp_string32, 0, _jsp_string32.length);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      if(software.equals("ALL") || software.equals("CRM")){
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"2");
int cnt = 0;
while(RecordSet.next()){

      out.write(_jsp_string33, 0, _jsp_string33.length);
      if(cnt == 0) {
      out.write(_jsp_string34, 0, _jsp_string34.length);
      out.print((SystemEnv.getHtmlLabelName(2167,user.getLanguage()) ));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(32591,user.getLanguage())));
      out.write(' ');
      out.print((RecordSet.getCounts()));
      out.write(_jsp_string35, 0, _jsp_string35.length);
      out.print((SystemEnv.getHtmlLabelName(2195,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      if(meetingSetInfo.getRecArrive()==1){ 
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(2196,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      }if(meetingSetInfo.getRecBook()==1){ 
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(2197,user.getLanguage())));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      out.print((SystemEnv.getHtmlLabelName(2198,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      }if(meetingSetInfo.getRecReturn()==1){ 
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(2199,user.getLanguage())));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      out.print((SystemEnv.getHtmlLabelName(2200,user.getLanguage())));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      out.print((SystemEnv.getHtmlLabelName(2182,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      }if(meetingSetInfo.getRecRemark()==1){ 
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(454,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      } 
      out.write(_jsp_string39, 0, _jsp_string39.length);
      
		cnt++;
	}
	
      out.write(_jsp_string40, 0, _jsp_string40.length);
      out.print((RecordSet.getString("memberid")));
      out.write(_jsp_string41, 0, _jsp_string41.length);
      out.print((CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("memberid"))));
      out.write(_jsp_string42, 0, _jsp_string42.length);
      out.print((RecordSet.getString("membermanager")));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((ResourceComInfo.getResourcename(RecordSet.getString("membermanager"))));
      out.write(_jsp_string43, 0, _jsp_string43.length);
      if(RecordSet.getString("isattend").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(163,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("isattend").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(161,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("isattend").equals("3")){
      out.print((SystemEnv.getHtmlLabelName(2188,user.getLanguage())));
      }
      out.write(_jsp_string19, 0, _jsp_string19.length);
      if(meetingSetInfo.getRecArrive()==1){ 
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((RecordSet.getString("begindate")));
      out.write(' ');
      out.print((RecordSet.getString("begintime")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }if(meetingSetInfo.getRecBook()==1){ 
      out.write(_jsp_string20, 0, _jsp_string20.length);
      if(RecordSet.getString("bookroom").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(163,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("bookroom").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(161,user.getLanguage())));
      }
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((RecordSet.getString("roomstander")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }if(meetingSetInfo.getRecReturn()==1){ 
      out.write(_jsp_string20, 0, _jsp_string20.length);
      if(RecordSet.getString("bookticket").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(163,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("bookticket").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(161,user.getLanguage())));
      }
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((RecordSet.getString("enddate")));
      out.write(' ');
      out.print((RecordSet.getString("endtime")));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      if(RecordSet.getString("ticketstander").equals("1")){
      out.print((SystemEnv.getHtmlLabelName(2201,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("2")){
      out.print((SystemEnv.getHtmlLabelName(2202,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("3")){
      out.print((SystemEnv.getHtmlLabelName(2203,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("4")){
      out.print((SystemEnv.getHtmlLabelName(2204,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("5")){
      out.print((SystemEnv.getHtmlLabelName(2205,user.getLanguage())));
      }
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(RecordSet.getString("ticketstander").equals("6")){
      out.print((SystemEnv.getHtmlLabelName(2206,user.getLanguage())));
      }
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }if(meetingSetInfo.getRecRemark()==1){ 
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((RecordSet.getString("recRemark")));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      }
      out.write(_jsp_string23, 0, _jsp_string23.length);
      
                //System.out.println("canJueyi:"+canJueyi+"    membermanager:"+RecordSet.getString("membermanager")+"   userid:"+userid);
                if((canJueyi || RecordSet.getString("membermanager").equals(userid)) && (!isdecision.equals("1") && !isdecision.equals("2"))&&(enddate+":"+endtime).compareTo(CurrentDate+":"+CurrentTime)>0){
      out.write(_jsp_string44, 0, _jsp_string44.length);
      out.print((RecordSet.getString("id")));
      out.write(',');
      out.print((meetingid));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((SystemEnv.getHtmlLabelName(2108,user.getLanguage())));
      }
      out.write(_jsp_string45, 0, _jsp_string45.length);
      
	RecordSet2.executeProc("Meeting_MemberCrm_SelectAll",RecordSet.getString("id"));
	if(RecordSet2.getCounts() > 0){
		
      out.write(_jsp_string46, 0, _jsp_string46.length);
      out.print((10-reduceCol ));
      out.write(_jsp_string47, 0, _jsp_string47.length);
      
		while(RecordSet2.next()){
			crmnum+=1;
		
      out.write(_jsp_string48, 0, _jsp_string48.length);
      out.print((meetingUtil.getMeetingOthersMbrDesc(RecordSet2.getString("name"), RecordSet2.getString("sex"), RecordSet2.getString("occupation"), RecordSet2.getString("tel"), RecordSet2.getString("handset"), RecordSet2.getString("desc_n"), user)));
      out.write(_jsp_string49, 0, _jsp_string49.length);
      out.print((RecordSet2.getString("name")));
      out.write(_jsp_string50, 0, _jsp_string50.length);
      }
      out.write(_jsp_string51, 0, _jsp_string51.length);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      }
      out.write(_jsp_string32, 0, _jsp_string32.length);
      }
      out.write(_jsp_string52, 0, _jsp_string52.length);
      out.print((10-reduceCol ));
      out.write(_jsp_string53, 0, _jsp_string53.length);
      out.print((SystemEnv.getHtmlLabelName(2168,user.getLanguage())));
      out.write(':');
      out.print((Util.toScreen(othermembers,user.getLanguage())));
      out.write(_jsp_string54, 0, _jsp_string54.length);
      out.print((8-reduceCol ));
      out.write('>');
      out.print((SystemEnv.getHtmlLabelName(454,user.getLanguage())));
      out.write(':');
      out.print((Util.toScreen(othersremark,user.getLanguage())));
      out.write(_jsp_string55, 0, _jsp_string55.length);
      if(ismanager && !isdecision.equals("1") && !isdecision.equals("2")){
      out.write(_jsp_string56, 0, _jsp_string56.length);
      out.print((meetingid));
      out.write(_jsp_string57, 0, _jsp_string57.length);
      out.print((SystemEnv.getHtmlLabelName(454,user.getLanguage())));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      }
      out.write(_jsp_string58, 0, _jsp_string58.length);
      out.print((10-reduceCol ));
      out.write(_jsp_string59, 0, _jsp_string59.length);
      out.print((SystemEnv.getHtmlLabelName(2207,user.getLanguage())));
      out.write(_jsp_string60, 0, _jsp_string60.length);
      out.print((hrmnum+crmnum));
      out.write(_jsp_string61, 0, _jsp_string61.length);
      out.print((SystemEnv.getHtmlLabelName(127,user.getLanguage())));
      out.write('\uff0c');
      out.print((SystemEnv.getHtmlLabelName(2208,user.getLanguage())));
      out.write(_jsp_string60, 0, _jsp_string60.length);
      out.print((hrmnum));
      out.write(_jsp_string61, 0, _jsp_string61.length);
      out.print((SystemEnv.getHtmlLabelName(127,user.getLanguage())));
      out.write('\uff0c');
      out.print((SystemEnv.getHtmlLabelName(2209,user.getLanguage())));
      out.write(_jsp_string60, 0, _jsp_string60.length);
      out.print((crmnum));
      out.write(_jsp_string61, 0, _jsp_string61.length);
      out.print((SystemEnv.getHtmlLabelName(127,user.getLanguage())));
      out.write(_jsp_string62, 0, _jsp_string62.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    manager.addTaglibFunctions(_jsp_functionMap, "wea", "/WEB-INF/weaver.tld");
    manager.addTaglibFunctions(_jsp_functionMap, "brow", "/browserTag");
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("meeting/data/AjaxMeetingMember.jsp"), -8167132220404668736L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string37;
  private final static char []_jsp_string62;
  private final static char []_jsp_string4;
  private final static char []_jsp_string33;
  private final static char []_jsp_string39;
  private final static char []_jsp_string58;
  private final static char []_jsp_string36;
  private final static char []_jsp_string18;
  private final static char []_jsp_string8;
  private final static char []_jsp_string61;
  private final static char []_jsp_string14;
  private final static char []_jsp_string60;
  private final static char []_jsp_string29;
  private final static char []_jsp_string17;
  private final static char []_jsp_string34;
  private final static char []_jsp_string55;
  private final static char []_jsp_string42;
  private final static char []_jsp_string12;
  private final static char []_jsp_string26;
  private final static char []_jsp_string43;
  private final static char []_jsp_string56;
  private final static char []_jsp_string25;
  private final static char []_jsp_string5;
  private final static char []_jsp_string50;
  private final static char []_jsp_string20;
  private final static char []_jsp_string38;
  private final static char []_jsp_string10;
  private final static char []_jsp_string0;
  private final static char []_jsp_string27;
  private final static char []_jsp_string6;
  private final static char []_jsp_string35;
  private final static char []_jsp_string47;
  private final static char []_jsp_string54;
  private final static char []_jsp_string24;
  private final static char []_jsp_string21;
  private final static char []_jsp_string48;
  private final static char []_jsp_string59;
  private final static char []_jsp_string19;
  private final static char []_jsp_string44;
  private final static char []_jsp_string9;
  private final static char []_jsp_string45;
  private final static char []_jsp_string7;
  private final static char []_jsp_string41;
  private final static char []_jsp_string51;
  private final static char []_jsp_string23;
  private final static char []_jsp_string3;
  private final static char []_jsp_string32;
  private final static char []_jsp_string15;
  private final static char []_jsp_string52;
  private final static char []_jsp_string30;
  private final static char []_jsp_string13;
  private final static char []_jsp_string46;
  private final static char []_jsp_string28;
  private final static char []_jsp_string31;
  private final static char []_jsp_string16;
  private final static char []_jsp_string22;
  private final static char []_jsp_string1;
  private final static char []_jsp_string11;
  private final static char []_jsp_string49;
  private final static char []_jsp_string40;
  private final static char []_jsp_string57;
  private final static char []_jsp_string53;
  private final static char []_jsp_string2;
  static {
    _jsp_string37 = "\r\n			 <TH  align=left>".toCharArray();
    _jsp_string62 = "\r\n			  </TD>\r\n			</TR>\r\n        </TBODY>\r\n	  </TABLE>\r\n".toCharArray();
    _jsp_string4 = " (".toCharArray();
    _jsp_string33 = "\r\n	".toCharArray();
    _jsp_string39 = "\r\n			 <TH  align=left></TH>\r\n		</TR>\r\n	".toCharArray();
    _jsp_string58 = "</td>\r\n            </tr>\r\n			  <TR class=\"DataDark\">\r\n			  <TD class=\"Field\" colspan=".toCharArray();
    _jsp_string36 = "</TH>\r\n			 ".toCharArray();
    _jsp_string18 = "\r\n			".toCharArray();
    _jsp_string8 = "\r\n          <TH  align=left style=\"min-width:30px;\">".toCharArray();
    _jsp_string61 = "</font>".toCharArray();
    _jsp_string14 = "\r\n          <TH  align=left style=\"width:20px;\"></TH>\r\n		</TR>\r\n".toCharArray();
    _jsp_string60 = "<font class=\"fontred\">".toCharArray();
    _jsp_string29 = "\r\n	  <a href=javaScript:openhrm(".toCharArray();
    _jsp_string17 = "</a>\r\n		  </TD>\r\n          <TD class=\"Field\"> \r\n			".toCharArray();
    _jsp_string34 = "\r\n		<TR class=\"header\">\r\n			 <TH  align=left>".toCharArray();
    _jsp_string55 = "</td>\r\n                <td>".toCharArray();
    _jsp_string42 = "</a>(<a href=javaScript:openhrm(".toCharArray();
    _jsp_string12 = "</TH>\r\n          <TH  align=left style=\"min-width:60px;\">".toCharArray();
    _jsp_string26 = "</button>".toCharArray();
    _jsp_string43 = "</a>)\r\n		  </TD>\r\n          <TD class=\"Field\"> \r\n			".toCharArray();
    _jsp_string56 = "<button type=\"button\"  onClick=\"onShowReOthers(".toCharArray();
    _jsp_string25 = ")\" class=e8_btn_cancel  style=\"padding-left:3px !important;padding-right:3px !important;width:60px\">".toCharArray();
    _jsp_string5 = ")</TH>\r\n          <TH  align=left style=\"min-width:30px;\">".toCharArray();
    _jsp_string50 = "</a>&nbsp;\r\n		\r\n				  \r\n		".toCharArray();
    _jsp_string20 = "\r\n          <TD class=\"Field\"> \r\n			".toCharArray();
    _jsp_string38 = "</TH>\r\n			 <TH  align=left>".toCharArray();
    _jsp_string10 = "\r\n          <TH  align=left style=\"min-width:50px;\">".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string27 = "\r\n		  </td>\r\n\r\n        </TR>\r\n		".toCharArray();
    _jsp_string6 = "</TH>\r\n          ".toCharArray();
    _jsp_string35 = ")</TH>\r\n			 <TH  align=left>".toCharArray();
    _jsp_string47 = "> <img border=0 src=\"/images/ArrowRightBlue_wev8.gif\" align=middle />&nbsp;\r\n		".toCharArray();
    _jsp_string54 = "</td>\r\n                <td colspan=".toCharArray();
    _jsp_string24 = "<button type=\"button\" onClick=\"onShowReHrm(".toCharArray();
    _jsp_string21 = "\r\n		  </TD>\r\n          <TD class=\"Field\"> \r\n			".toCharArray();
    _jsp_string48 = "		\r\n			<a id=\"nomal\" href=\"#\" onclick=\"return false;\" title=\"".toCharArray();
    _jsp_string59 = ">\r\n				".toCharArray();
    _jsp_string19 = "\r\n		  </TD>\r\n		  ".toCharArray();
    _jsp_string44 = "<button type=\"button\" onClick=\"onShowReCrm(".toCharArray();
    _jsp_string9 = "</TH>\r\n          <TH  align=left style=\"min-width:50px;\">".toCharArray();
    _jsp_string45 = "\r\n		  </td>\r\n        </TR>\r\n	".toCharArray();
    _jsp_string7 = "\r\n          <TH  align=left style=\"min-width:70px;\">".toCharArray();
    _jsp_string41 = "' target=\\'_blank\\'>".toCharArray();
    _jsp_string51 = "\r\n		</TD>\r\n		</TR>\r\n	".toCharArray();
    _jsp_string23 = "\r\n		  <td class=\"Field\">\r\n			".toCharArray();
    _jsp_string3 = "\r\n	<TABLE  class=\"ListStyle\" cellspacing=1>\r\n        <TBODY>\r\n        <TR class=\"header\">\r\n          <TH  align=left style=\"min-width:140px;\">".toCharArray();
    _jsp_string32 = "	\r\n".toCharArray();
    _jsp_string15 = "\r\n        <TR class=\"DataDark\">\r\n          <TD class=\"Field\"> \r\n			<input class=\"inputstyle\" type=checkbox  checked disabled/>\r\n			<a href=javaScript:openhrm(".toCharArray();
    _jsp_string52 = "\r\n			<tr class=\"DataLight\" style=\"height: 1px\">\r\n				<td style=\"height: 1px\" colspan=".toCharArray();
    _jsp_string30 = "</a>&nbsp;\r\n      ".toCharArray();
    _jsp_string13 = "\r\n          <TH  align=left style=\"min-width:40px;\">".toCharArray();
    _jsp_string46 = "\r\n		<TR class=\"DataLight\">\r\n			<TD class=\"Field\" colspan=".toCharArray();
    _jsp_string28 = "\r\n        <TR class=\"DataLight\">\r\n          \r\n    <TD class=\"Field\" colspan=9> <img border=0 src=\"/images/ArrowRightBlue_wev8.gif\" align=middle />&nbsp;\r\n      ".toCharArray();
    _jsp_string31 = "\r\n    </TD>\r\n		</TR>\r\n		".toCharArray();
    _jsp_string16 = "); onclick='pointerXY(event);'>".toCharArray();
    _jsp_string22 = "\r\n		  <TD class=\"Field\"> \r\n			".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string11 = "</TH>\r\n          <TH  align=left style=\"min-width:70px;\">".toCharArray();
    _jsp_string49 = "\" >".toCharArray();
    _jsp_string40 = "\r\n		  <TR class=\"DataDark\">\r\n          <TD class=\"Field\">\r\n			<input class=\"inputstyle\" type=checkbox  checked disabled><A href='/CRM/data/ViewCustomer.jsp?CustomerID=".toCharArray();
    _jsp_string57 = ")\" class=\"e8_btn_cancel\"  style=\"padding-left:3px !important;padding-right:3px !important;width:60px\">".toCharArray();
    _jsp_string53 = "></td>\r\n			</tr>\r\n			<tr class=\"DataLight\">\r\n                <td>".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}