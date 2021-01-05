
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*,weaver.common.StringUtil" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.file.FileManage"%>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="java.math.BigDecimal"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompensationTargetMaint" class="weaver.hrm.finance.compensation.CompensationTargetMaint" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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
String CompensationYear=fu.getParameter("CompensationYear");
String CompensationMonth=fu.getParameter("CompensationMonth");
int targetsize = Util.getIntValue(fu.getParameter("targetsize")) ;
ArrayList targetidlist=new ArrayList();
for(int j=0;j<targetsize;j++){
String targetidstr="targetid"+j;
int Targetid=Util.getIntValue(fu.getParameter(targetidstr)) ;
targetidlist.add(Targetid+"");
}
//System.out.println(subcompanyid+"|"+departmentid+"|"+CompensationYear+"|"+CompensationMonth);
String Excelfilepath="";

int fileid = 0 ;
if(option.equals("loadfile")) {
try {
    fileid = Util.getIntValue(fu.uploadFiles("targetfile"),0);

    String filename = fu.getFileName();

    String sql = "select filerealpath,isaesencrypt,aescode from imagefile where imagefileid = "+fileid;
    RecordSet.executeSql(sql);
    String uploadfilepath="";
    String isaesencrypt="";
    String aescode="";
    if(RecordSet.next()) {
    	uploadfilepath =  RecordSet.getString("filerealpath");
    	isaesencrypt =  RecordSet.getString("isaesencrypt");
      aescode =  RecordSet.getString("aescode");
    }


 if(!uploadfilepath.equals("")){
        Excelfilepath = GCONST.getRootPath()+"hrm/finance/compensation/ExcelToDB"+File.separatorChar+filename ;
        fm.copy(uploadfilepath,Excelfilepath,isaesencrypt,aescode);
    }


String msg="";
String msg1="";
String msg2="";
int    msgsize=0;

CompensationTargetMaint.ExcelToDB(Excelfilepath,subcompanyid,departmentid,Util.getIntValue(CompensationYear),Util.getIntValue(CompensationMonth),targetidlist,user.getLanguage(),user.getUID());
msgsize=CompensationTargetMaint.getMsg1().size();
if(msgsize==0){
    msg="success";
  	String sqldel="delete from imagefile where imagefileid ='"+fileid+"'";
    boolean delflag=rs2.executeSql(sqldel);
    if (delflag) {
			if (!uploadfilepath.equals("")) {
				try {
					File file = new File(new String(uploadfilepath.getBytes("ISO8859_1"), "UTF-8"));
					file.delete();
				} catch (Exception e) {
				}
			}
		}    
    fm.DeleteFile(Excelfilepath);	
    response.sendRedirect("CompensationTargetMaintEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&CompensationYear="+CompensationYear+"&CompensationMonth="+CompensationMonth+"&msg="+msg);
}else{
    for (int i = 0; i <msgsize; i++){
    msg1=msg1+(String)CompensationTargetMaint.getMsg1().elementAt(i)+",";
    msg2=msg2+(String)CompensationTargetMaint.getMsg2().elementAt(i)+",";
    }
    fm.DeleteFile(Excelfilepath);
    request.getSession(true).setAttribute("msg1",msg1);
    request.getSession(true).setAttribute("msg2",msg2);
    response.sendRedirect("CompensationTargetMaintEdit.jsp?isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&CompensationYear="+CompensationYear+"&CompensationMonth="+CompensationMonth+"&msg="+msg+"&msgsize="+msgsize);
}
}
catch(Exception e) {
}
}
if(option.equals("add")) {
    int rownum = Util.getIntValue(fu.getParameter("rownum")) ;

    ConnStatement statement=new ConnStatement();
    try{
        for(int i=0;i<rownum;i++){
            String Userid=Util.fromScreen3(fu.getParameter("Userid_"+i),user.getLanguage());
            String memo=Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage());
            if(!Userid.trim().equals("")){
                //删除有的数据
                String sql="delete from HRM_CompensationTargetDetail where exists(select 1 from HRM_CompensationTargetInfo where HRM_CompensationTargetDetail.CompensationTargetid=id and CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth)+" and Userid="+Util.getIntValue(Userid)+")";
                statement.setStatementSql(sql);
                statement.executeUpdate();
                sql="delete from HRM_CompensationTargetInfo where Userid="+Userid+" and CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth);
                statement.setStatementSql(sql);
                statement.executeUpdate();
                //插入数据库
                sql="INSERT INTO HRM_CompensationTargetInfo(subcompanyid,departmentid,CompensationYear,CompensationMonth,Userid,memo) values(?,?,?,?,?,?)";
                statement.setStatementSql(sql);
                statement.setInt(1,Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(Userid))));
                statement.setInt(2,Util.getIntValue(ResourceComInfo.getDepartmentID(Userid)));
                statement.setInt(3,Util.getIntValue(CompensationYear));
                statement.setInt(4,Util.getIntValue(CompensationMonth));
                statement.setInt(5,Util.getIntValue(Userid));
                statement.setString(6,memo);
                statement.executeUpdate();
                sql="select id from HRM_CompensationTargetInfo where CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth)+" and Userid="+Util.getIntValue(Userid);
                statement.setStatementSql(sql);
                statement.executeQuery();
                if(statement.next()){
                    int id=statement.getInt(1);
                    for(int j=0;j<targetsize;j++){
                        String targetstr="target"+j+"_"+i;
                        String Target=Util.null2String(fu.getParameter(targetstr)) ;
                        if(Target.equals("")) Target="0";
                        int Targetid=Util.getIntValue((String)targetidlist.get(j)) ;
                        sql="INSERT INTO HRM_CompensationTargetDetail(CompensationTargetid,Targetid,Target) values(?,?,?)";
                        statement.setStatementSql(sql);
                        statement.setInt(1,id);
                        statement.setInt(2,Targetid);
                        statement.setString(3,Target);
                        statement.executeUpdate();
                    }
                }
            }
        }
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        statement.close();
    }
    response.sendRedirect("CompensationTargetMaintEdit.jsp?isclose=1&isedit=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&msg3="+msg3+"&msg4="+msg4);
}
if(option.equals("edit")) {
    int rownum = Util.getIntValue(fu.getParameter("rownum")) ;

    ConnStatement statement=new ConnStatement();
    try{
        //删除原来指标数据
        String sql="";
        /*sql="delete from HRM_CompensationTargetDetail where CompensationTargetid in(select id from HRM_CompensationTargetInfo where subcompanyid="+subcompanyid+" and departmentid="+departmentid+" and CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth)+")";
        statement.setStatementSql(sql);
        statement.executeUpdate();
        sql="delete from HRM_CompensationTargetInfo where subcompanyid="+subcompanyid+" and departmentid="+departmentid+" and CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth);
        statement.setStatementSql(sql);
        statement.executeUpdate();
        */
        for(int i=0;i<rownum;i++){
            String Userid=Util.fromScreen3(fu.getParameter("Userid_"+i),user.getLanguage());
            String memo=Util.fromScreen3(fu.getParameter("memo_"+i),user.getLanguage());
            if(!Userid.trim().equals("")){
                //查询数据库是否有有该用户
                sql="select id from HRM_CompensationTargetInfo where CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth)+" and Userid="+Util.getIntValue(Userid);
                statement.setStatementSql(sql);
                statement.executeQuery();
                if(statement.next()){
                    //更新
                    int id=statement.getInt(1);
                    sql="update HRM_CompensationTargetInfo set subcompanyid=?,departmentid=?,memo=? where CompensationYear=? and CompensationMonth=? and Userid=?";
                    statement.setStatementSql(sql);
                    statement.setInt(1,Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(Userid))));
                    statement.setInt(2,Util.getIntValue(ResourceComInfo.getDepartmentID(Userid)));
                    statement.setString(3,memo);
                    statement.setInt(4,Util.getIntValue(CompensationYear));
                    statement.setInt(5,Util.getIntValue(CompensationMonth));
                    statement.setInt(6,Util.getIntValue(Userid));
                    statement.executeUpdate();
                    for(int j=0;j<targetsize;j++){
                        String targetstr="target"+j+"_"+i;
                        String Target=Util.null2String(fu.getParameter(targetstr)) ;
                        if(Target.equals("")) Target="0";
                        int Targetid=Util.getIntValue((String)targetidlist.get(j)) ;
                        sql="select CompensationTargetid from HRM_CompensationTargetDetail where CompensationTargetid=? and Targetid=?";
                        statement.setStatementSql(sql);
                        statement.setInt(1,id);
                        statement.setInt(2,Targetid);
                        statement.executeQuery();
                        if(statement.next()){
                            sql="update HRM_CompensationTargetDetail set Target=? where CompensationTargetid=? and Targetid=?";
                            statement.setStatementSql(sql);
                            statement.setString(1,Target);
                            statement.setInt(2,id);
                            statement.setInt(3,Targetid);
                            statement.executeUpdate();
                        }else{
                            sql="INSERT INTO HRM_CompensationTargetDetail(CompensationTargetid,Targetid,Target) values(?,?,?)";
                            statement.setStatementSql(sql);
                            statement.setInt(1,id);
                            statement.setInt(2,Targetid);
                            statement.setString(3,Target);
                            statement.executeUpdate();
                        }
                    }
                }else{
                    //插入数据库
                    sql="INSERT INTO HRM_CompensationTargetInfo(subcompanyid,departmentid,CompensationYear,CompensationMonth,Userid,memo) values(?,?,?,?,?,?)";
                    statement.setStatementSql(sql);
                    statement.setInt(1,Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(Userid))));
                    statement.setInt(2,Util.getIntValue(ResourceComInfo.getDepartmentID(Userid)));
                    statement.setInt(3,Util.getIntValue(CompensationYear));
                    statement.setInt(4,Util.getIntValue(CompensationMonth));
                    statement.setInt(5,Util.getIntValue(Userid));
                    statement.setString(6,memo);
                    statement.executeUpdate();
                    sql="select id from HRM_CompensationTargetInfo where CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth)+" and Userid="+Util.getIntValue(Userid);
                    statement.setStatementSql(sql);
                    statement.executeQuery();
                    if(statement.next()){
                        int id=statement.getInt(1);
                        for(int j=0;j<targetsize;j++){
                            String targetstr="target"+j+"_"+i;
                            String Target=Util.null2String(fu.getParameter(targetstr)) ;
                            if(Target.equals("")) Target="0";
                            int Targetid=Util.getIntValue((String)targetidlist.get(j)) ;
                            sql="select CompensationTargetid from HRM_CompensationTargetDetail where CompensationTargetid=? and Targetid=?";
                            statement.setStatementSql(sql);
                            statement.setInt(1,id);
                            statement.setInt(2,Targetid);
                            statement.executeQuery();
                            if(statement.next()){
                                sql="update HRM_CompensationTargetDetail set Target=? where CompensationTargetid=? and Targetid=?";
                                statement.setStatementSql(sql);
                                statement.setString(1,Target);
                                statement.setInt(2,id);
                                statement.setInt(3,Targetid);
                                statement.executeUpdate();
                            }else{
                                sql="INSERT INTO HRM_CompensationTargetDetail(CompensationTargetid,Targetid,Target) values(?,?,?)";
                                statement.setStatementSql(sql);
                                statement.setInt(1,id);
                                statement.setInt(2,Targetid);
                                statement.setString(3,Target);
                                statement.executeUpdate();
                            }
                        }
                    }
                }
            }
        }
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        statement.close();
    }
    response.sendRedirect("CompensationTargetMaintEdit.jsp?isedit=1&isclose=1&subCompanyId="+subcompanyid+"&departmentid="+departmentid+"&msg3="+msg3+"&msg4="+msg4);
}
if(option.equals("delete")) {
    ConnStatement statement=new ConnStatement();
    try{
        String subcomidstr="";
        String sql="delete from HRM_CompensationTargetDetail where CompensationTargetid in(select id from HRM_CompensationTargetInfo where CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth);
        String sql1="delete from HRM_CompensationTargetInfo where CompensationYear="+Util.getIntValue(CompensationYear)+" and CompensationMonth="+Util.getIntValue(CompensationMonth);
        if(subcompanyid>0){
            String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance", 0);
            ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
            subcomidstr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
        }
        if(departmentid>0){
            sql+=" and departmentid="+departmentid;
            sql1+=" and departmentid="+departmentid;
        }else if(subcompanyid>0 && StringUtil.isNotNull(subcomidstr)){
            sql+=" and subcompanyid in("+subcomidstr+")";
            sql1+=" and subcompanyid in("+subcomidstr+")";
        } else if(subcompanyid == -1){
			sql+=" and subcompanyid=-1";
            sql1+=" and subcompanyid=-1";
		}
		sql+=")";
        statement.setStatementSql(sql);
        statement.executeUpdate();
        statement.setStatementSql(sql1);
        statement.executeUpdate();
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        statement.close();
    }
    response.sendRedirect("CompensationTargetMaintList.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid);
}
%>
