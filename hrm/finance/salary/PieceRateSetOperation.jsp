
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLDecoder.*"%>
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
String option=Util.null2String(fu.getParameter("option"));
int subcompanyid=Util.getIntValue(fu.getParameter("subcompanyid"));
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

PieceRateExcelToDB.ExcelToDB1(Excelfilepath,subcompanyid,user.getLanguage());
msgsize=PieceRateExcelToDB.getMsg1().size();
msg3=PieceRateExcelToDB.getMsg3();
if(msgsize==0){
    msg="success";
    response.sendRedirect("PieceRateSettingEdit.jsp?subCompanyId="+subcompanyid+"&msg="+msg+"&msg3="+msg3);
}else{
    for (int i = 0; i <msgsize; i++){
    msg1=msg1+(String)PieceRateExcelToDB.getMsg1().elementAt(i)+",";
    msg2=msg2+(String)PieceRateExcelToDB.getMsg2().elementAt(i)+",";
    }
    fm.DeleteFile(Excelfilepath);
    response.sendRedirect("PieceRateSettingEdit.jsp?subCompanyId="+subcompanyid+"&msg="+msg+"&msg1="+msg1+"&msg2="+msg2+"&msgsize="+msgsize+"&msg3="+msg3);
}
}
catch(Exception e) {
}
}

if(option.equals("edit")) {
    int rownum = Util.getIntValue(fu.getParameter("rownum")) ;
    int indexnum = Util.getIntValue(fu.getParameter("indexnum")) ;
    ConnStatement statement=new ConnStatement();
    //删除原来的计件工资设置
    try{
        statement.setStatementSql("delete from HRM_PieceRateSetting where subcompanyid="+subcompanyid);
        statement.executeUpdate();
        if(rownum>0 && subcompanyid>0){
            String sql="";
            for(int i=0;i<indexnum;i++){
                String PieceRateNo=Util.fromScreen3(fu.getParameter("PieceRateNo_"+i),user.getLanguage());
                String PieceRateName=Util.fromScreen3(fu.getParameter("PieceRateName_"+i),user.getLanguage());
                String workingpro=Util.fromScreen3(fu.getParameter("workingpro_"+i),user.getLanguage());
                String price=Util.null2String(fu.getParameter("price_"+i));
                if(price.equals("")) price="0";
                String memo=Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage());
                if(!PieceRateNo.trim().equals("")){
                    //插入数据库
                  sql="INSERT INTO HRM_PieceRateSetting(subcompanyid,PieceRateNo,PieceRateName,workingpro,price,memo) values(?,?,?,?,?,?)";
                  statement.setStatementSql(sql);
                  statement.setInt(1,subcompanyid);
                  statement.setString(2,PieceRateNo);
                  statement.setString(3,PieceRateName);
                  statement.setString(4,workingpro);
                  statement.setString(5,price);
                  statement.setString(6,memo);
                  statement.executeUpdate();
                }
            }
            //校验计件编号是否重复
          String pieceratenos="";
          sql="select PieceRateNo from (select count(PieceRateNo) nums,PieceRateNo from HRM_PieceRateSetting where subcompanyid="+subcompanyid+" group by PieceRateNo) a where a.nums>1";
          statement.setStatementSql(sql);
          statement.executeQuery();
          while(statement.next()){
              pieceratenos+="'"+statement.getString("PieceRateNo")+"',";
              msg3+=statement.getString("PieceRateNo")+",";
          }
          if(!msg3.trim().equals("")){
              msg3=msg3.substring(0,msg3.length()-1);
              pieceratenos=pieceratenos.substring(0,pieceratenos.length()-1);
              //删除重复的计件编号，保留最后一条记录
              sql="delete from HRM_PieceRateSetting where subcompanyid="+subcompanyid+" and piecerateno in("+pieceratenos+") and id<(select max(id) from HRM_PieceRateSetting where subcompanyid="+subcompanyid+" and piecerateno in("+pieceratenos+"))";
              statement.setStatementSql(sql);
              statement.executeUpdate();
          }
        }
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        statement.close();
    }
    response.sendRedirect("PieceRateSettingEdit.jsp?subCompanyId="+subcompanyid+"&msg3="+msg3);
}
%>
