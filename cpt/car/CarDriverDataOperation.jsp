
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarWorkTimeCalculate" class="weaver.cpt.car.CarWorkTimeCalculate" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
char flag = Util.getSeparator() ;
String sql="";
String Procpara="" ;

String driverid = Util.fromScreen(request.getParameter("driverid"),user.getLanguage());

String cartypeid = Util.fromScreen(request.getParameter("cartypeid"),user.getLanguage());
String isreception = Util.fromScreen(request.getParameter("isreception"),user.getLanguage());
/*
String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String starttime = Util.fromScreen(request.getParameter("starttime"),user.getLanguage());
String backdate = Util.fromScreen(request.getParameter("backdate"),user.getLanguage());
String backtime = Util.fromScreen(request.getParameter("backtime"),user.getLanguage());
*/
String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String starttime = Util.fromScreen(request.getParameter("starttime"),user.getLanguage());
String backtime = Util.fromScreen(request.getParameter("backtime"),user.getLanguage());

//String startdate = Util.add0(Util.getIntValue(request.getParameter("year"),0), 4) +"-"+
//                   Util.add0(Util.getIntValue(request.getParameter("month"),0), 2) +"-"+
//                   Util.add0(Util.getIntValue(request.getParameter("day"),0), 2) ;
//String starttime = Util.add0(Util.getIntValue(request.getParameter("starthour"),0), 2) +":"+
//                   Util.add0(Util.getIntValue(request.getParameter("startmin"),0), 2);
//String backtime  = Util.add0(Util.getIntValue(request.getParameter("backhour"),0), 2) +":"+
//                   Util.add0(Util.getIntValue(request.getParameter("backmin"),0), 2);
                                      
String startkm = Util.fromScreen(request.getParameter("startkm"),user.getLanguage());
String backkm = Util.fromScreen(request.getParameter("backkm"),user.getLanguage());
String check_paras[] = request.getParameterValues("check_para");
String useperson = Util.fromScreen(request.getParameter("useperson"),user.getLanguage());
String usedepartment = Util.fromScreen(request.getParameter("usedepartment"),user.getLanguage());
String iscarout = Util.fromScreen(request.getParameter("iscarout"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
String backdate=startdate ;
String isholiday = Util.fromScreen(request.getParameter("isholiday"),user.getLanguage());

int tmpyear = Util.getIntValue(startdate.substring(0,4));
int tmpmonth = Util.getIntValue(startdate.substring(5,7));
int tmpday = Util.getIntValue(startdate.substring(8,10));
Calendar today = Calendar.getInstance();
today.set(tmpyear,tmpmonth-1,tmpday) ;
int dayofweek=today.get(Calendar.DAY_OF_WEEK);  

if(dayofweek==1 || dayofweek==7)    isholiday="2" ;
if(isholiday.equals("2"))   dayofweek=1;
if(isholiday.equals("1"))   dayofweek=8 ;
String workstarttime="09:30";
String workendtime="17:30";
float overtimepara=0;
float publicpara=0 ;
sql="select overtimepara,publicpara from CarDriverBasicinfo";
RecordSet.executeSql(sql);
if(RecordSet.next()){
    overtimepara=RecordSet.getFloat("overtimepara");
    publicpara = RecordSet.getFloat("publicpara");
}
if(isholiday.equals("1"))   overtimepara = publicpara ;

if(operation.equals("add")){
    float finalkm = 0 ;
    float finaltime = 0 ;
    
    CarWorkTimeCalculate.resetParameter();
    CarWorkTimeCalculate.setStarttime(starttime);
    CarWorkTimeCalculate.setBacktime(backtime);
    CarWorkTimeCalculate.setWorkstarttime(workstarttime);
    CarWorkTimeCalculate.setWorkendtime(workendtime);
    CarWorkTimeCalculate.setWeekday(dayofweek);
    CarWorkTimeCalculate.timeCalculate();
    
    float totaltime = CarWorkTimeCalculate.getTotaltime();
    float normaltime = CarWorkTimeCalculate.getNormaltime();
    float overtime = CarWorkTimeCalculate.getOvertime();
    normaltime = totaltime - overtime ;
    
    float reallykm = Util.getFloatValue(backkm) - Util.getFloatValue(startkm) ;
    //TD2063 by mackjoe 2005-06-16
    //reallykm = (float) (int)(reallykm*100)/100 ;
    float normalkm = 0 ;
    float overtimekm=0 ;
    if(overtime!=0){
        overtimekm = overtime / totaltime * reallykm ;
        normalkm = reallykm - overtimekm ;
    }
    else
        normalkm = reallykm ;
    
    float initpara = 1 ;
    if(check_paras != null){
        for(int i=0; i<check_paras.length;i++){
            String paraid = check_paras[i] ;
            RecordSet.executeSql("select paravalue from carparameter where id ="+paraid);
            if(RecordSet.next()){
                float tmppara=RecordSet.getFloat(1);
                initpara = initpara * tmppara ;
            }
        }   
    }
    float realkm =0 ;
    float realtime = 0 ;
    realkm = (normalkm + overtimekm * overtimepara) * initpara ;
    //realkm = (float) (int)(realkm*100)/100 ;
    realtime = (normaltime + overtime * overtimepara) * initpara ;
    //realtime = (float) (int)(realtime*100)/100 ;
    Procpara = driverid + flag + cartypeid + flag + isreception + flag + startdate + flag + 
               starttime + flag + backdate + flag + backtime + flag + startkm + flag +
               backkm + flag + reallykm + flag + totaltime + flag + 
               normalkm + flag + overtimekm + flag + normaltime + flag + overtime + flag +
               realkm + flag + realtime + flag + useperson + flag + usedepartment + flag + 
               iscarout + flag + remark + flag + isholiday ;
    RecordSet.executeProc("CarDriverData_Insert",Procpara);
    RecordSet.next();
    String thisid = RecordSet.getString(1);
    
    if(check_paras != null){
        for(int i=0; i<check_paras.length;i++){
            String paraid = check_paras[i] ;
            RecordSet.executeProc("CarDriverDataPara_Insert",thisid+flag+paraid);
        }   
    }
}


if(operation.equals("edit")){
    String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
    float finalkm = 0 ;
    float finaltime = 0 ;
    
    CarWorkTimeCalculate.resetParameter();
    CarWorkTimeCalculate.setStarttime(starttime);
    CarWorkTimeCalculate.setBacktime(backtime);
    CarWorkTimeCalculate.setWorkstarttime(workstarttime);
    CarWorkTimeCalculate.setWorkendtime(workendtime);
    CarWorkTimeCalculate.setWeekday(dayofweek);
    CarWorkTimeCalculate.timeCalculate();
    
    float totaltime = CarWorkTimeCalculate.getTotaltime();
    float normaltime = CarWorkTimeCalculate.getNormaltime();
    float overtime = CarWorkTimeCalculate.getOvertime();
    normaltime = totaltime - overtime ;
    
    float reallykm = Util.getFloatValue(backkm) - Util.getFloatValue(startkm) ;
    //reallykm = (float) (int)(reallykm*100)/100 ;
    float normalkm = 0 ;
    float overtimekm=0 ;
    if(overtime!=0){
        overtimekm = overtime / totaltime * reallykm  ;
        normalkm = reallykm - overtimekm ;
    }
    else
        normalkm = reallykm ;
    
    float initpara = 1 ;
    if(check_paras != null){
        for(int i=0; i<check_paras.length;i++){
            String paraid = check_paras[i] ;
            RecordSet.executeSql("select paravalue from carparameter where id ="+paraid);
            if(RecordSet.next()){
                float tmppara=RecordSet.getFloat(1);
                initpara = initpara * tmppara ;
            }
        }   
    }
    float realkm =0 ;
    float realtime = 0 ;
    realkm = (normalkm + overtimekm * overtimepara) * initpara ;
    //realkm = (float) (int)(realkm*100)/100 ;
    realtime = (normaltime + overtime * overtimepara) * initpara ;
    //realtime = (float) (int)(realtime*100)/100 ;
    
    Procpara = id + flag + driverid + flag + cartypeid + flag + isreception + flag + startdate + flag + 
               starttime + flag + backdate + flag + backtime + flag + startkm + flag + 
               backkm + flag + reallykm + flag + totaltime + flag + 
               normalkm + flag + overtimekm + flag + normaltime + flag + overtime + flag +
               realkm + flag + realtime + flag + useperson + flag + usedepartment + flag +
               iscarout + flag + remark + flag + isholiday ;
    RecordSet.executeProc("CarDriverData_Update",Procpara);
    RecordSet.next();
    
    RecordSet.executeProc("CarDriverDataPara_Delete",id);
    if(check_paras != null){
        for(int i=0; i<check_paras.length;i++){
            String paraid = check_paras[i] ;
            RecordSet.executeProc("CarDriverDataPara_Insert",id+flag+paraid);
        }   
    }
}


if(operation.equals("delete")){
    String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
    RecordSet.executeProc("CarDriverData_Delete",id);
    RecordSet.executeProc("CarDriverDataPara_Delete",id);
}
response.sendRedirect("CarDriverDataList.jsp");
%>
