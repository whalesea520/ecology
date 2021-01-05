<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    if (!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
        response.sendRedirect("/performance/util/Message.jsp");
        return;
    }

    String sql = "";
    String operation = Util.fromScreen3(request.getParameter("operation"),user.getLanguage());
    String resourceid = Util.fromScreen3(request.getParameter("resourceid"),user.getLanguage());
    String resourcetype = Util.fromScreen3(request.getParameter("resourcetype"),user.getLanguage());
    
    String isfyear = Util.getIntValue(request.getParameter("isfyear"),0)+"";       
    String ishyear = Util.getIntValue(request.getParameter("ishyear"),0)+"";        
    String isquarter = Util.getIntValue(request.getParameter("isquarter"),0)+"";      
    String ismonth = Util.getIntValue(request.getParameter("ismonth"),0)+"";        
    String fstarttype = Util.getIntValue(request.getParameter("fstarttype"),0)+"";     
    String fstartdays = Util.getIntValue(request.getParameter("fstartdays"),0)+"";     
    String fendtype = Util.getIntValue(request.getParameter("fendtype"),0)+"";       
    String fenddays = Util.getIntValue(request.getParameter("fenddays"),0)+"";       
    String hstarttype = Util.getIntValue(request.getParameter("hstarttype"),0)+"";     
    String hstartdays = Util.getIntValue(request.getParameter("hstartdays"),0)+"";     
    String hendtype = Util.getIntValue(request.getParameter("hendtype"),0)+"";       
    String henddays = Util.getIntValue(request.getParameter("henddays"),0)+"";       
    String qstarttype = Util.getIntValue(request.getParameter("qstarttype"),0)+"";     
    String qstartdays = Util.getIntValue(request.getParameter("qstartdays"),0)+"";     
    String qendtype = Util.getIntValue(request.getParameter("qendtype"),0)+"";       
    String qenddays = Util.getIntValue(request.getParameter("qenddays"),0)+"";       
    String mstarttype = Util.getIntValue(request.getParameter("mstarttype"),0)+"";     
    String mstartdays = Util.getIntValue(request.getParameter("mstartdays"),0)+"";     
    String mendtype = Util.getIntValue(request.getParameter("mendtype"),0)+"";       
    String menddays = Util.getIntValue(request.getParameter("menddays"),0)+"";       
    String programcreate = Util.null2String(request.getParameter("programcreate"));  
    if(!programcreate.equals("") && !programcreate.startsWith(",")) programcreate = "," + programcreate;
    if(!programcreate.equals("") && !programcreate.endsWith(",")) programcreate = programcreate + ",";
    String programaudit = Util.null2String(request.getParameter("programaudit"));  
    if(!programaudit.equals("") && !programaudit.startsWith(",")) programaudit = "," + programaudit;
    if(!programaudit.equals("") && !programaudit.endsWith(",")) programaudit = programaudit + ",";
    String manageraudit = Util.getIntValue(request.getParameter("manageraudit"),0)+"";       
    String accessconfirm = Util.null2String(request.getParameter("accessconfirm"));  
    if(!accessconfirm.equals("") && !accessconfirm.startsWith(",")) accessconfirm = "," + accessconfirm;
    if(!accessconfirm.equals("") && !accessconfirm.endsWith(",")) accessconfirm = accessconfirm + ",";
    String accessview = Util.null2String(request.getParameter("accessview"));  
    if(!accessview.equals("") && !accessview.startsWith(",")) accessview = "," + accessview;
    if(!accessview.equals("") && !accessview.endsWith(",")) accessview = accessview + ",";
    String isself = Util.getIntValue(request.getParameter("isself"),0)+"";         
    String ismanager = Util.getIntValue(request.getParameter("ismanager"),0)+""; 
    String docsecid = Util.getIntValue(request.getParameter("docsecid"),0)+"";  
    
    String subcompanyids = Util.fromScreen3(request.getParameter("subcompanyids"),user.getLanguage());
    
    String scoremin = Util.getDoubleValue(request.getParameter("scoremin"),-5)+"";   
    String scoremax = Util.getDoubleValue(request.getParameter("scoremax"),5)+"";   
    String revisemin = Util.getDoubleValue(request.getParameter("revisemin"),-2)+"";    
    String revisemax = Util.getDoubleValue(request.getParameter("revisemax"),2)+"";   
    String scoreSetting = Util.getIntValue(request.getParameter("scoreSetting"),5)+"";  
    
    ArrayList resourceidList = new ArrayList();
    if(operation.equals("del")){
    	String setid = Util.null2String(request.getParameter("setid"));
		rs.executeSql("delete from GP_BaseSetting where id="+setid);
    }else{
    	//保存
        if(operation.equals("save")){
            String resourceids = resourceid;
            if("3".equals(resourcetype)){
    			String departmentids = Util.fromScreen3(request.getParameter("departmentids"),user.getLanguage());
    			if(!departmentids.equals("")){
    				resourceids += ","+departmentids;
    			}
    		}else{
    			if(!subcompanyids.equals("")){
    	            resourceids += ","+subcompanyids;
    	        }
    		}
            resourceidList = Util.TokenizerString(resourceids,",");
        }else if(operation.equals("sync")){
            resourceidList = SubCompanyComInfo.getSubCompanyLists(resourceid,resourceidList);
        }
        
        String rid = "";
        for(int i=0;i<resourceidList.size();i++){
            rid = (String)resourceidList.get(i);
            if(!"".equals(rid)){
                rs.executeSql("delete from GP_BaseSetting where resourcetype="+resourcetype+" and resourceid="+rid);
                sql = "insert into GP_BaseSetting(resourceid,resourcetype,isfyear,ishyear,isquarter,ismonth,fstarttype,fstartdays,fendtype,fenddays"
                    +",hstarttype,hstartdays,hendtype,henddays,qstarttype,qstartdays,qendtype,qenddays,mstarttype,mstartdays,mendtype,menddays"
                    +",programcreate,programaudit,manageraudit,accessconfirm,accessview,isself,ismanager,docsecid,scoremin,scoremax,revisemin,revisemax,scoreSetting)"
                    +" values "
                    +"("+rid+","+resourcetype+","+isfyear+","+ishyear+","+isquarter+","+ismonth+","+fstarttype+","+fstartdays+","+fendtype+","+fenddays
                    +","+hstarttype+","+hstartdays+","+hendtype+","+henddays+","+qstarttype+","+qstartdays+","+qendtype+","+qenddays+","+mstarttype+","+mstartdays+","+mendtype+","+menddays
                    +",'"+programcreate+"','"+programaudit+"',"+manageraudit+",'"+accessconfirm+"','"+accessview+"',"+isself+","+ismanager+","+docsecid+",'"+scoremin+"','"+scoremax+"','"+revisemin+"','"+revisemax+"','"+scoreSetting+"')";
                rs.executeSql(sql);
                OperateUtil.updateScoreBySetting(rid);
            }
        }
    }
    response.sendRedirect("BaseSetting.jsp?resourceid="+resourceid+"&resourcetype="+resourcetype);
%>
