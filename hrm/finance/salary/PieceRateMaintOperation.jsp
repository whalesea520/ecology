
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.conn.ConnStatement"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PieceRateExcelToDB" class="weaver.hrm.finance.ExcelToDB.PieceRateExcelToDB" scope="page" />

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

FileUpload fu = new FileUpload(request,false);
FileManage fm = new FileManage();
String msg3="";
String msg4="";
String option=Util.null2String(fu.getParameter("option"));
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
int subcompanyid=Util.getIntValue(fu.getParameter("subcompanyid"));
int departmentid=Util.getIntValue(fu.getParameter("departmentid"));
String PieceYear=fu.getParameter("PieceYear");
String PieceMonth=fu.getParameter("PieceMonth");
//System.out.println(subcompanyid+"|"+departmentid+"|"+PieceYear+"|"+PieceMonth);
String Excelfilepath="";

int fileid = 0 ;
if(option.equals("loadfile")) {
try {
    fileid = Util.getIntValue(fu.uploadFiles("pieceratefile"),0);

    String filename = fu.getFileName();


    String sql = "select filerealpath from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    if(RecordSet.next()) uploadfilepath =  RecordSet.getString("filerealpath");


 if(!uploadfilepath.equals("")){

        Excelfilepath = GCONST.getRootPath()+"hrm/finance/salary/ExcelToDB"+File.separatorChar+filename ;
        fm.copy(uploadfilepath,Excelfilepath);
    }


String msg="";
String msg1="";
String msg2="";
int    msgsize=0;

PieceRateExcelToDB.ExcelToDB2(Excelfilepath,subcompanyid,Util.getIntValue(PieceYear),Util.getIntValue(PieceMonth),user.getLanguage());
msgsize=PieceRateExcelToDB.getMsg1().size();
if(msgsize==0){
    msg="success";
    response.sendRedirect("PieceRateMaintenanceEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&PieceYear="+PieceYear+"&PieceMonth="+PieceMonth+"&msg="+msg);
}else{
    for (int i = 0; i <msgsize; i++){
    msg1=msg1+(String)PieceRateExcelToDB.getMsg1().elementAt(i)+",";
    msg2=msg2+(String)PieceRateExcelToDB.getMsg2().elementAt(i)+",";
    }
    fm.DeleteFile(Excelfilepath);
    response.sendRedirect("PieceRateMaintenanceEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&PieceYear="+PieceYear+"&PieceMonth="+PieceMonth+"&msg="+msg+"&msg1="+msg1+"&msg2="+msg2+"&msgsize="+msgsize);
}
}
catch(Exception e) {
}
}
if(option.equals("add")) {
    int rownum = Util.getIntValue(fu.getParameter("rownum")) ;
    int indexnum = Util.getIntValue(fu.getParameter("indexnum")) ;
    ConnStatement statement=new ConnStatement();
    try{
        //获得该分部下的员工编号
        if(departmentid>0){
            statement.setStatementSql("select workcode,departmentid from HrmResource where subcompanyid1="+subcompanyid+" and departmentid="+departmentid+" group by workcode,departmentid");
        }else{
            statement.setStatementSql("select workcode,departmentid from HrmResource where subcompanyid1="+subcompanyid+" group by workcode,departmentid");
        }
        statement.executeQuery();
        ArrayList usercodelist=new ArrayList();
        ArrayList departmentlist=new ArrayList();
        while(statement.next()){
            usercodelist.add(statement.getString("workcode"));
            departmentlist.add(statement.getString("departmentid"));
        }
        //获得该分部下的计件编号
        statement.setStatementSql("select PieceRateNo from HRM_PieceRateSetting where subcompanyid="+subcompanyid);
        statement.executeQuery();
        ArrayList PieceRateNolist=new ArrayList();
        while(statement.next()){
            PieceRateNolist.add(statement.getString("PieceRateNo"));
        }
        if(rownum>0 && subcompanyid>0){
            String sql="";
            for(int i=0;i<indexnum;i++){
                boolean checkcode=true;
                int tempdeptid=-1;
                String UserCode=Util.fromScreen3(fu.getParameter("UserCode_"+i),user.getLanguage());
                String PieceRateNo=Util.fromScreen3(fu.getParameter("PieceRateNo_"+i),user.getLanguage());
                if(!UserCode.trim().equals("")){
                    int indx=usercodelist.indexOf(UserCode.trim());
                    if(indx<0){
                    checkcode=false;
                    msg3+=UserCode+",";
                    }else{
                        tempdeptid=Util.getIntValue((String)departmentlist.get(indx));
                    }
                }
                if(!PieceRateNo.trim().equals("")&&PieceRateNolist.indexOf(PieceRateNo.trim())<0){
                    checkcode=false;
                    msg4+=PieceRateNo+",";
                }
                String PieceRateDate=Util.fromScreen3(fu.getParameter("PieceRateDate_"+i),user.getLanguage());
                String PieceNum=Util.null2String(fu.getParameter("PieceNum_"+i));
                if(PieceNum.equals("")) PieceNum="0";
                String memo=Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage());
                if(!UserCode.trim().equals("")&&!PieceRateNo.trim().equals("")&&checkcode){
                    //插入数据库
                  sql="INSERT INTO HRM_PieceRateInfo(subcompanyid,departmentid,PieceYear,PieceMonth,UserCode,PieceRateNo,PieceRateDate,PieceNum,memo) values(?,?,?,?,?,?,?,?,?)";
                  statement.setStatementSql(sql);
                  statement.setInt(1,subcompanyid);
                  statement.setInt(2,tempdeptid);
                  statement.setInt(3,Util.getIntValue(PieceYear));
                  statement.setInt(4,Util.getIntValue(PieceMonth));
                  statement.setString(5,UserCode);
                  statement.setString(6,PieceRateNo);
                  statement.setString(7,PieceRateDate);
                  statement.setString(8,PieceNum);
                  statement.setString(9,memo);
                  statement.executeUpdate();
                }
            }
        }
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        statement.close();
    }
    response.sendRedirect("PieceRateMaintenanceEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&PieceYear="+PieceYear+"&PieceMonth="+PieceMonth+"&msg3="+msg3+"&msg4="+msg4);
}
if(option.equals("edit")) {
    int rownum = Util.getIntValue(fu.getParameter("rownum")) ;
    int indexnum = Util.getIntValue(fu.getParameter("indexnum")) ;
    ConnStatement statement=new ConnStatement();
    try{
        //删除原来的计件数据
        if(departmentid>0){
            statement.setStatementSql("delete from HRM_PieceRateInfo where subcompanyid="+subcompanyid+" and departmentid="+departmentid+" and PieceYear="+PieceYear+" and PieceMonth="+PieceMonth);
        }else{
            statement.setStatementSql("delete from HRM_PieceRateInfo where subcompanyid="+subcompanyid+" and PieceYear="+PieceYear+" and PieceMonth="+PieceMonth);
        }
        statement.executeUpdate();
        //获得该分部下的员工编号
        if(departmentid>0){
            statement.setStatementSql("select workcode,departmentid from HrmResource where subcompanyid1="+subcompanyid+" and departmentid="+departmentid+" group by workcode,departmentid");
        }else{
            statement.setStatementSql("select workcode,departmentid from HrmResource where subcompanyid1="+subcompanyid+" group by workcode,departmentid");
        }
        statement.executeQuery();
        ArrayList usercodelist=new ArrayList();
        ArrayList departmentlist=new ArrayList();
        while(statement.next()){
            usercodelist.add(statement.getString("workcode"));
            departmentlist.add(statement.getString("departmentid"));
        }
        //获得该分部下的计件编号
        statement.setStatementSql("select PieceRateNo from HRM_PieceRateSetting where subcompanyid="+subcompanyid);
        statement.executeQuery();
        ArrayList PieceRateNolist=new ArrayList();
        while(statement.next()){
            PieceRateNolist.add(statement.getString("PieceRateNo"));
        }
        if(rownum>0 && subcompanyid>0){
            String sql="";
            for(int i=0;i<indexnum;i++){
                boolean checkcode=true;
                String UserCode=Util.fromScreen3(fu.getParameter("UserCode_"+i),user.getLanguage());
                String PieceRateNo=Util.fromScreen3(fu.getParameter("PieceRateNo_"+i),user.getLanguage());
                int tempdeptid=-1;
                if(!UserCode.trim().equals("")){
                    int indx=usercodelist.indexOf(UserCode.trim());
                    if(indx<0){
                    checkcode=false;
                    msg3+=UserCode+",";
                    }else{
                        tempdeptid=Util.getIntValue((String)departmentlist.get(indx));
                    }
                }
                if(!PieceRateNo.trim().equals("")&&PieceRateNolist.indexOf(PieceRateNo.trim())<0){
                    checkcode=false;
                    msg4+=PieceRateNo+",";
                }
                String PieceRateDate=Util.fromScreen3(fu.getParameter("PieceRateDate_"+i),user.getLanguage());
                String PieceNum=Util.null2String(fu.getParameter("PieceNum_"+i));
                if(PieceNum.equals("")) PieceNum="0";
                String memo=Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage());
                if(!UserCode.trim().equals("")&&!PieceRateNo.trim().equals("")&&checkcode){
                    //插入数据库
                  sql="INSERT INTO HRM_PieceRateInfo(subcompanyid,departmentid,PieceYear,PieceMonth,UserCode,PieceRateNo,PieceRateDate,PieceNum,memo) values(?,?,?,?,?,?,?,?,?)";
                  statement.setStatementSql(sql);
                  statement.setInt(1,subcompanyid);
                  statement.setInt(2,tempdeptid);
                  statement.setInt(3,Util.getIntValue(PieceYear));
                  statement.setInt(4,Util.getIntValue(PieceMonth));
                  statement.setString(5,UserCode);
                  statement.setString(6,PieceRateNo);
                  statement.setString(7,PieceRateDate);
                  statement.setString(8,PieceNum);
                  statement.setString(9,memo);
                  statement.executeUpdate();
                }
            }
        }
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        statement.close();
    }
    response.sendRedirect("PieceRateMaintenanceEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&PieceYear="+PieceYear+"&PieceMonth="+PieceMonth+"&msg3="+msg3+"&msg4="+msg4);
}
%>
