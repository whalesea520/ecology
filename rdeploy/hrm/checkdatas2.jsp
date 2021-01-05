<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//校验名称是否存在
 String para ="";
 String  subcom = "5";
                    int supsubcomid =0 ;
                    char separator = Util.getSeparator() ;
                    //更新机构权限数据：新增加的分部默认继承上级分部的所有机构权限。
                    para = String.valueOf(subcom) + separator + String.valueOf(supsubcomid);
                    rs.executeProc("HrmRoleSRT_AddByNewSc",para);

                    //更新左侧菜单，新增的分部继承上级分部的左侧菜单
                    String strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
                    if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
                    String strSql="insert into leftmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+subcom+",2,locked,lockedbyid,usecustomname,customname,customname_e from leftmenuconfig "+strWhere;
                    //System.out.println(strSql);
                    rs.executeSql(strSql);



                    //更新顶部菜单，新增的分部继承上级分部的顶部菜单
                    strWhere=" where resourcetype=2 and resourceid="+supsubcomid; 
                    if(supsubcomid==0) strWhere=" where resourcetype=1  and resourceid=1 "; 
                    strSql="insert into mainmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex,"+subcom+",2,locked,lockedbyid,usecustomname,customname,customname_e from mainmenuconfig "+strWhere;
                    //System.out.println(strSql);
                    rs.executeSql(strSql);
                    
                    SubCompanyComInfo sub = new SubCompanyComInfo();
                    sub.removeCompanyCache();
%>