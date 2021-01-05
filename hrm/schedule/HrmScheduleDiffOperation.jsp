<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "log" class = "weaver.systeminfo.SysMaintenanceLog" scope = "page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>

<%
String opera = Util.null2String(request.getParameter("operation")) ; //操作类型
char separator = Util.getSeparator() ; 
String procedurepara = "" ; 
int id = Util.getIntValue(request.getParameter("id") , 0) ; //

String diffname = Util.fromScreen(request.getParameter("diffname") , user.getLanguage()) ; //简称
String diffdesc = Util.fromScreen(request.getParameter("diffdesc") , user.getLanguage()) ; //说明
String difftype = Util.fromScreen(request.getParameter("difftype") , user.getLanguage()) ; //变动
String color = Util.fromScreen(request.getParameter("color") , user.getLanguage()) ; //显示颜色

String diffremark = Util.fromScreen(request.getParameter("diffremark") , user.getLanguage()) ; //备注
String salaryable = Util.fromScreen(request.getParameter("salaryable") , user.getLanguage()) ; //薪资计算
String counttype = Util.fromScreen(request.getParameter("counttype") , user.getLanguage()) ; //薪资计算方式
String countnum = Util.fromScreen(request.getParameter("countnum") , user.getLanguage()) ; //计算值

String salaryitem = Util.fromScreen(request.getParameter("salaryitem") , user.getLanguage()) ; //基准工资项
String mindifftime = Util.fromScreen(request.getParameter("mindifftime") , user.getLanguage()) ; //最小计算时间
String difftime = Util.fromScreen(request.getParameter("difftime") , user.getLanguage()) ; //相关时间
String timecounttype = Util.fromScreen(request.getParameter("timecounttype") , user.getLanguage()) ;
String diffscope = Util.fromScreen(request.getParameter("diffscope") , user.getLanguage()) ;  //应用范围
String subcompanyid = Util.fromScreen(request.getParameter("subcompanyid") , user.getLanguage()) ;  //分部id
/* 
时间计算方式 ： 用原有工作流id字段进行存储:
1 :以考勤时间计算
2 :以打卡时间计算
3 :以较大时间计算
4 :以较小时间计算
*/

if(opera.equals("insert")){//新建
	if(!HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user)){ 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} 
	//procedurepara = diffname + separator + diffdesc + separator + difftype + separator + difftime + separator + mindifftime + separator + timecounttype + separator + salaryable + separator + counttype + separator + countnum + separator + salaryitem + separator + diffremark + separator + color ;
	if(mindifftime.equals(""))
    mindifftime="null";
    if(countnum.equals(""))
    countnum="null";
    if(salaryitem.equals(""))
    salaryitem="null";
    if(timecounttype.equals(""))
    timecounttype="5";
    String sql="insert into hrmschedulediff(diffname,diffdesc,difftype,difftime,mindifftime,salaryable,counttype,countnum,diffremark,salaryitem,color,diffscope,workflowid,subcompanyid) values('"+
                diffname+"','"+ diffdesc+"','"+difftype+"','"+ difftime+"',"+ mindifftime+",'"+ salaryable+"','"+ counttype+"',"+countnum+",'"+ diffremark+"',"+ salaryitem+
               ",'"+color+"',"+ diffscope+","+ timecounttype+","+subcompanyid+")";
    //System.out.println(sql);
    RecordSet.executeSql(sql);
    //RecordSet.executeProc("HrmScheduleDiff_Insert" , procedurepara) ;
	RecordSet.next() ; 
	id = RecordSet.getInt(1) ; 
	log.resetParameter() ; 
	log.setRelatedId(id) ; 
    log.setRelatedName(diffname) ; 
    log.setOperateType("1") ; 
//  log.setOperateDesc("HrmScheduleDiff_Insert"); 
   	log.setOperateItem("17") ; 
   	log.setOperateUserid(user.getUID()) ; 
   	log.setClientAddress(request.getRemoteAddr()) ; 
    log.setSysLogInfo() ; 
   	response.sendRedirect("HrmScheduleDiffAdd.jsp?isclose=1&subcompanyid="+subcompanyid) ;
} 

if(opera.equals("save")){ //保存
	if(!HrmUserVarify.checkUserRight("HrmScheduleDiffEdit:Edit" , user)){ 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	}
    if(mindifftime.equals(""))
    mindifftime="null";
    if(countnum.equals(""))
    countnum="null";
    if(salaryitem.equals(""))
    salaryitem="null";
     if(timecounttype.equals(""))
    timecounttype="5";
    String sql="update hrmschedulediff set diffname='"+diffname+"',diffdesc='"+diffdesc+
            "', difftype='"+difftype+"',difftime='"+difftime +"',mindifftime="+mindifftime+",salaryable='"+salaryable+
            "',counttype='"+counttype+"',countnum="+countnum+",diffremark='"+diffremark+"',salaryitem="+salaryitem+
            ",color='"+color+"',diffscope="+diffscope+",workflowid="+timecounttype+",subcompanyid="+subcompanyid+" where id="+id;
    // System.out.println(sql);
    RecordSet.executeSql(sql);
    //procedurepara = id + "" + separator + diffname + separator + diffdesc + separator + difftype  + separator + difftime + separator + mindifftime + separator + timecounttype + separator + salaryable + separator + counttype + separator + countnum + separator + salaryitem + separator + diffremark + separator + color ;
    //out.println(procedurepara) ;
	//out.println(RecordSet.executeProc("HrmScheduleDiff_Update" , procedurepara)) ;
	log.resetParameter() ; 
	log.setRelatedId(id) ; 
    log.setRelatedName(diffname) ; 
  	log.setOperateType("2") ; 
//  log.setOperateDesc("HrmScheduleDiff_Insert") ; 
   	log.setOperateItem("17") ; 
   	log.setOperateUserid(user.getUID()) ; 
   	log.setClientAddress(request.getRemoteAddr()) ; 
   	log.setSysLogInfo() ; 
  	response.sendRedirect("HrmScheduleDiffEdit.jsp?isclose=1&subcompanyid="+subcompanyid) ;
} 

if(opera.equals("delete")){ //删除
	if(!HrmUserVarify.checkUserRight("HrmScheduleDiffEdit:Delete" , user)){ 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} 
	RecordSet.executeSql("select diffname from HrmScheduleDiff where id ="+id);
	if(RecordSet.next()){
		diffname = Util.null2String(RecordSet.getString("diffname"));
	}
	RecordSet.executeProc("HrmScheduleDiff_Delete" , id + "") ;
    RecordSet.executeSql("delete hrmschedulemonth where difftype="+id);
    log.resetParameter() ;
	log.setRelatedId(id) ; 
    log.setRelatedName(diffname) ; 
   	log.setOperateType("3") ; 
//  log.setOperateDesc("HrmScheduleDiff_Insert") ; 
   	log.setOperateItem("17") ; 
   	log.setOperateUserid(user.getUID()) ; 
   	log.setClientAddress(request.getRemoteAddr()) ; 
   	log.setSysLogInfo() ; 
   	response.sendRedirect("HrmScheduleDiff.jsp?subcompanyid="+subcompanyid) ;
} 
%>