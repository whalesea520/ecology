
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.Constants" %>

<%@ page import="weaver.domain.workplan.WorkPlanVisitSet" %>
<%@ page import="weaver.viewform.workplan.WorkPlanVisitViewForm" %>

<%
    if(!HrmUserVarify.checkUserRight("WorkPlanReportSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>

<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="jobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>


<HTML>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
    String method = request.getParameter("method");

    if("addWorkPlanSet".equals(method))
    //增添被查看者和查看者关系
    {
        String[] shareValues = request.getParameterValues("txtShareDetail");
        
        List workPlanVisitSetArrayList = new ArrayList();

        if(null != shareValues)
        {
            for(int i = 0 ; i < shareValues.length; i++)
            {
                String shareValue = shareValues[i];
              
                WorkPlanVisitSet workPlanVisitSet = new WorkPlanVisitSet();
                
                String[] parameter = Util.TokenizerString2(shareValue, "_");
                
                workPlanVisitSet.setWorkPlanVisitSetID(Integer.parseInt(parameter[0]));
                
                workPlanVisitSet.setWorkPlanReportType(Integer.parseInt(parameter[1]));
                
                workPlanVisitSet.setWorkPlanReportContentID(parameter[2]);
                
                workPlanVisitSet.setWorkPlanReportSec(Integer.parseInt(parameter[3]));
                
                workPlanVisitSet.setWorkPlanVisitType(Integer.parseInt(parameter[4]));
                
                workPlanVisitSet.setWorkPlanVisitContentID(parameter[5]);
                
                workPlanVisitSet.setWorkPlanVisitSec(Integer.parseInt(parameter[6]));                
                
                workPlanVisitSetArrayList.add(workPlanVisitSet);
            }
        }
        
        workPlanService.saveBatchWorkPlanVisitSet(workPlanVisitSetArrayList);
        
        response.sendRedirect("WorkPlanReportSetOperation.jsp");
    }
    else
    //进入查看者和查看者关系列表显示和编辑页面
    {
        List workPlanVisitSetArrayList = new ArrayList();
        
        List workPlanVisitViewFormArrayList = new ArrayList();
        
        workPlanVisitSetArrayList = workPlanService.getWorkPlanVisitSetList();
        
        for(int i = 0; i < workPlanVisitSetArrayList.size(); i++)
        {                    
            WorkPlanVisitViewForm workPlanVisitViewForm = new WorkPlanVisitViewForm();
        
            WorkPlanVisitSet workPlanVisitSet = (WorkPlanVisitSet)workPlanVisitSetArrayList.get(i);
        
            int workPlanReportType = workPlanVisitSet.getWorkPlanReportType();
            
            int workPlanVisitType =  workPlanVisitSet.getWorkPlanVisitType();
            
            workPlanVisitViewForm.setWorkPlanVisitSetID(workPlanVisitSet.getWorkPlanVisitSetID());

            workPlanVisitViewForm.setWorkPlanReportType(workPlanReportType);
       
            workPlanVisitViewForm.setWorkPlanReportContentID(workPlanVisitSet.getWorkPlanReportContentID());
                           
            workPlanVisitViewForm.setWorkPlanReportSec(workPlanVisitSet.getWorkPlanReportSec());
        
            workPlanVisitViewForm.setWorkPlanVisitType(workPlanVisitType);
                           
            workPlanVisitViewForm.setWorkPlanVisitContentID(workPlanVisitSet.getWorkPlanVisitContentID());
        
            workPlanVisitViewForm.setWorkPlanVisitSec(workPlanVisitSet.getWorkPlanVisitSec());
                        
            if(Constants.Hrm_All_Member == workPlanReportType)
            {
                workPlanVisitViewForm.setWorkPlanReportTypeName(SystemEnv.getHtmlLabelName(235,user.getLanguage()) + SystemEnv.getHtmlLabelName(127,user.getLanguage()));
                                        
                workPlanVisitViewForm.setWorkPlanReportContentName(new Integer(workPlanVisitSet.getWorkPlanReportSec()).toString());
            }
            else if(Constants.Hrm_SubCompany == workPlanReportType)
            {
                workPlanVisitViewForm.setWorkPlanReportTypeName(SystemEnv.getHtmlLabelName(141,user.getLanguage()));
            
                String workPlanReportContentID = workPlanVisitSet.getWorkPlanReportContentID();
                
                String[] parameter = Util.TokenizerString2(workPlanReportContentID, ",");                
                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanReportContentName = subCompanyComInfo.getSubCompanyname(parameter[j]);                    
                    
                    workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " " + workPlanReportContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " / " + workPlanVisitSet.getWorkPlanReportSec());
            }
            else if(Constants.Hrm_Department == workPlanReportType)
            {
                workPlanVisitViewForm.setWorkPlanReportTypeName(SystemEnv.getHtmlLabelName(124,user.getLanguage()));
            
                String workPlanReportContentID = workPlanVisitSet.getWorkPlanReportContentID();
                
                String[] parameter = Util.TokenizerString2(workPlanReportContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanReportContentName = departmentComInfo.getDepartmentname(parameter[j]);
                                    
                    workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " " + workPlanReportContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " / " + workPlanVisitSet.getWorkPlanReportSec());
            }
            else if(Constants.Hrm_Role == workPlanReportType)
            {
                workPlanVisitViewForm.setWorkPlanReportTypeName(SystemEnv.getHtmlLabelName(122,user.getLanguage()));

                String workPlanReportContentID = workPlanVisitSet.getWorkPlanReportContentID();

                String[] parameter = Util.TokenizerString2(workPlanReportContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanReportContentName = rolesComInfo.getRolesname(parameter[j]);
                                    
                    workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " " + workPlanReportContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " / " + workPlanVisitSet.getWorkPlanReportSec());
            }
            else if(Constants.Hrm_Station == workPlanReportType)
            {
                workPlanVisitViewForm.setWorkPlanReportTypeName(SystemEnv.getHtmlLabelName(6086,user.getLanguage()));

                String workPlanReportContentID = workPlanVisitSet.getWorkPlanReportContentID();

                String[] parameter = Util.TokenizerString2(workPlanReportContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanReportContentName = jobTitlesComInfo.getJobTitlesname(parameter[j]);
                                    
                    workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " " + workPlanReportContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " / " + workPlanVisitSet.getWorkPlanReportSec());
            }
            else if(Constants.Hrm_Resource == workPlanReportType)
            {
                workPlanVisitViewForm.setWorkPlanReportTypeName(SystemEnv.getHtmlLabelName(179,user.getLanguage()));

                String workPlanReportContentID = workPlanVisitSet.getWorkPlanReportContentID();

                String[] parameter = Util.TokenizerString2(workPlanReportContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanReportContentName = resourceComInfo.getResourcename(parameter[j]);
                                     
                    workPlanVisitViewForm.setWorkPlanReportContentName(workPlanVisitViewForm.getWorkPlanReportContentName() + " " + workPlanReportContentName);
                }
            }
                        
            if(Constants.Hrm_All_Member == workPlanVisitType)
            {
                workPlanVisitViewForm.setWorkPlanVisitTypeName(SystemEnv.getHtmlLabelName(235,user.getLanguage()) + SystemEnv.getHtmlLabelName(127,user.getLanguage()));
            
                workPlanVisitViewForm.setWorkPlanVisitContentName(new Integer(workPlanVisitSet.getWorkPlanVisitSec()).toString());
            }
            else if(Constants.Hrm_SubCompany == workPlanVisitType)
            {
                workPlanVisitViewForm.setWorkPlanVisitTypeName(SystemEnv.getHtmlLabelName(141,user.getLanguage()));

                String workPlanVisitContentID = workPlanVisitSet.getWorkPlanVisitContentID();

                String[] parameter = Util.TokenizerString2(workPlanVisitContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanVisitContentName = subCompanyComInfo.getSubCompanyname(parameter[j]);
                                     
                    workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " " + workPlanVisitContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " / " + workPlanVisitSet.getWorkPlanVisitSec());
            }
            else if(Constants.Hrm_Department == workPlanVisitType)
            {
                workPlanVisitViewForm.setWorkPlanVisitTypeName(SystemEnv.getHtmlLabelName(124,user.getLanguage()));

                String workPlanVisitContentID = workPlanVisitSet.getWorkPlanVisitContentID();

                String[] parameter = Util.TokenizerString2(workPlanVisitContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanVisitContentName = departmentComInfo.getDepartmentname(parameter[j]);

                    workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " " + workPlanVisitContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " / " + workPlanVisitSet.getWorkPlanVisitSec());
            }
            else if(Constants.Hrm_Role == workPlanVisitType)
            {
                workPlanVisitViewForm.setWorkPlanVisitTypeName(SystemEnv.getHtmlLabelName(122,user.getLanguage()));

                String workPlanVisitContentID = workPlanVisitSet.getWorkPlanVisitContentID();

                String[] parameter = Util.TokenizerString2(workPlanVisitContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanVisitContentName = rolesComInfo.getRolesname(parameter[j]);
                                     
                    workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " " + workPlanVisitContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " / " + workPlanVisitSet.getWorkPlanVisitSec());
            }
            else if(Constants.Hrm_Station == workPlanVisitType)
            {
                workPlanVisitViewForm.setWorkPlanVisitTypeName(SystemEnv.getHtmlLabelName(6086,user.getLanguage()));

                String workPlanVisitContentID = workPlanVisitSet.getWorkPlanVisitContentID();

                String[] parameter = Util.TokenizerString2(workPlanVisitContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanVisitContentName = jobTitlesComInfo.getJobTitlesname(parameter[j]);
                                     
                    workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " " + workPlanVisitContentName);
                }
                
                workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " / " + workPlanVisitSet.getWorkPlanVisitSec());
            }
            else if(Constants.Hrm_Resource == workPlanVisitType)
            {
                workPlanVisitViewForm.setWorkPlanVisitTypeName(SystemEnv.getHtmlLabelName(179,user.getLanguage()));

                String workPlanVisitContentID = workPlanVisitSet.getWorkPlanVisitContentID();

                String[] parameter = Util.TokenizerString2(workPlanVisitContentID, ",");                                
                                
                for(int j = 0; j < parameter.length; j++)
                {
                    String workPlanVisitContentName = resourceComInfo.getResourcename(parameter[j]);
                                     
                    workPlanVisitViewForm.setWorkPlanVisitContentName(workPlanVisitViewForm.getWorkPlanVisitContentName() + " " + workPlanVisitContentName);
                }
            }
            
            workPlanVisitViewFormArrayList.add(workPlanVisitViewForm);
        }
        
        request.setAttribute("workPlanVisitViewFormArrayList", workPlanVisitViewFormArrayList);
%>
        <jsp:forward page = "WorkPlanReportSet.jsp" ></jsp:forward>
<%
    }
%>  
  
  
</HEAD>

<BODY>
</BODY>
</HTML>

