<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="WFManagerCheckright" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="SubCompanyComInfoCheckright" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfoCheckright" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRightCheckright" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<jsp:useBean id="RecordSetCheckright" class="weaver.conn.RecordSet" scope="page" />
<%

int wfidCheckright=0;
wfidCheckright=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int detachableCheckright =Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subCompanyId2Checkright = -1;
int operatelevelCheckright=0;
String typeCheckright = Util.null2String(request.getParameter("src"));
String[] subCompanyArrayCheckright = null;
User userCheckright = HrmUserVarify.getUser (request , response) ;
WfRightManager wfrmCheckright = new WfRightManager();
int templateidCheckright=Util.getIntValue(request.getParameter("templateid"),0);
wfidCheckright = (wfidCheckright==0)?templateidCheckright:wfidCheckright;
boolean haspermissionCheckright = wfrmCheckright.hasPermission3(wfidCheckright, 0, userCheckright, WfRightManager.OPERATION_CREATEDIR);
if(detachableCheckright==1){  
    //如果开启分权，管理员
    int subCompanyIdCheckright=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId2")),-1);
    subCompanyId2Checkright = subCompanyIdCheckright;
    String hasRightSub = SubCompanyComInfoCheckright.getRightSubCompany(userCheckright.getUID(),"WorkflowManage:All",0);
    if(!"".equals(hasRightSub)){
        subCompanyArrayCheckright = hasRightSub.split(",");    
    }
    if(subCompanyIdCheckright == -1){
        //系统管理员
        if(userCheckright.getUID() == 1 ){
            RecordSetCheckright.executeProc("SystemSet_Select","");
             if(RecordSetCheckright.next()){
                 subCompanyId2Checkright = Util.getIntValue(RecordSetCheckright.getString("wfdftsubcomid"),0);
             }
       }else{
           if(subCompanyArrayCheckright != null){
               subCompanyId2Checkright = Util.getIntValue(subCompanyArrayCheckright[0]);  
           }
       }
    }
    if(userCheckright.getUID() == 1){
        operatelevelCheckright = 2;
    }else{
        String subCompanyIds = manageDetachComInfoCheckright.getDetachableSubcompanyIds(userCheckright);
        if (subCompanyIdCheckright == 0 || subCompanyIdCheckright == -1 ) {
            if (subCompanyIds != null && !"".equals(subCompanyIds)) {
                String [] subCompanyIdArray = subCompanyIds.split(",");
                for (int tempi=0; tempi<subCompanyIdArray.length; tempi++) {
                    subCompanyIdCheckright = Util.getIntValue(subCompanyIdArray[tempi]);
                    operatelevelCheckright= CheckSubCompanyRightCheckright.ChkComRightByUserRightCompanyId(userCheckright.getUID(),"WorkflowManage:All",subCompanyIdCheckright);
                    if (operatelevelCheckright > 0) {
                        break;
                    }
                }
            }
        } else {
            operatelevelCheckright= CheckSubCompanyRightCheckright.ChkComRightByUserRightCompanyId(userCheckright.getUID(),"WorkflowManage:All",subCompanyIdCheckright);
        }            
    }
    if(!typeCheckright.equals("addwf")){
        WFManagerCheckright.setWfid(wfidCheckright);
        WFManagerCheckright.getWfInfo();
        subCompanyId2Checkright = WFManagerCheckright.getSubCompanyId2() ;
    }
    if(subCompanyId2Checkright != -1 && subCompanyId2Checkright != 0 && detachableCheckright == 1){
        if(!haspermissionCheckright){
            operatelevelCheckright= CheckSubCompanyRightCheckright.ChkComRightByUserRightCompanyId(userCheckright.getUID(),"WorkflowManage:All",subCompanyId2Checkright);    
        }
    }
    if(operatelevelCheckright < 0){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
}

%>
