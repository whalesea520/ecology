
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    User user = HrmUserVarify.getUser (request , response) ;
    if(user == null)  return ;

    String modeId = Util.null2String(request.getParameter("modeId"));
    String fieldid = Util.null2String(request.getParameter("fieldid"));
    
    String returnValue = "";
    if(!modeId.equals("")&&!fieldid.equals("")){
        String isbill = "0";
        String formid = "0";
        String sql = "select 1 isbill,formid from modeinfo where id="+modeId;
        rs.executeSql(sql);
        if(rs.next()){
            isbill = rs.getString("isbill");
            formid = rs.getString("formid");
        }
        if(isbill.equals("0")){
            sql = "select a.fieldid,b.fieldlable from workflow_formfield a, workflow_fieldlable b where a.fieldid=b.fieldid and a.formid=b.formid and b.langurageid = "+user.getLanguage()+" and a.groupid=(select groupid from workflow_formfield where fieldid="+fieldid+" and formid="+formid+") and a.formid="+formid+" order by fieldorder";
            rs.executeSql(sql);
            while(rs.next()){
                returnValue += "<option value="+rs.getString("fieldid")+">"+rs.getString("fieldlable")+"</option>";
            }
        }else{
            sql = "select id,fieldlabel from workflow_billfield where detailtable=(select detailtable from workflow_billfield where id="+fieldid+") and billid="+formid+" order by dsporder";
            rs.executeSql(sql);
            while(rs.next()){
                String tempfieldname = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
                returnValue += "<option value="+rs.getString("id")+">"+tempfieldname+"</option>";
            }
        }
    }
    out.print(returnValue);
%>