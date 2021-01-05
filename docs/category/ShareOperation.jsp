
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String secid = Util.null2String(request.getParameter("secid")); 

String isDialog = Util.null2String(request.getParameter("isdialog"));

if (secid.equals("")) secid=Util.null2o(request.getParameter("docid"));  //1 docid用目录ID   2 docid 为文档ID,根据上个页面的来源
MultiAclManager am = new MultiAclManager();
int parentId = Util.getIntValue(scc.getParentId(""+secid));
boolean hasSecManageRight = false;
if(parentId>0){
	hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
}
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !hasSecManageRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(method.equals("delete"))
{

	RecordSet.executeProc("DocSecCategoryShare_Delete",id);
	response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=1");
	return;
}


if(method.equals("add"))
{   
	String relatedshareids = Util.null2String(request.getParameter("relatedshareid")); 
    String operategroup  = Util.null2String(request.getParameter("operategroup"));  	
    String sharetype = Util.null2String(request.getParameter("sharetype")); 
    String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
    String seclevel = Util.getIntValue(request.getParameter("seclevelmain"),0)+"";
	String seclevelmax = Util.getIntValue(request.getParameter("seclevelmax"),255)+"";
    String sharelevel = Util.null2String(request.getParameter("sharelevel"));
	String downloadlevel = Util.null2String(request.getParameter("downloadlevel"));
	
	String jobids ="0";
	String joblevel = Util.null2String(request.getParameter("joblevel"));
    	String jobdepartment = Util.null2String(request.getParameter("jobdepartment"),"0");
	String jobsubcompany = Util.null2String(request.getParameter("jobsubcompany"),"0");
	
	String orgid ="0";
    String orgGroupId="0";
    String userid = "0" ;
    String departmentid = "0" ;
    String subcompanyid="0";
    String roleid = "0" ;
    String foralluser = "0" ;
    String crmid="0";   
	String relatedshareid="";
	String includesub="0";
	String custype ="";
	String isolddate ="1";
    /** ===/proj/data/AddShare.jsp ;/cpt/cptcapitalAddShare.jsp ;  /CRM/data/AddShare.jsp ========*/
   // String downloadlevel="1";//TD12005(TODO默认可下载)
 
    //System.out.println(downloadlevel);

	if(!operategroup.equals("3")){
        orgid= Util.null2String(request.getParameter("orgid"));	
	  
		ProcPara = secid;
		ProcPara += flag+sharetype;
		ProcPara += flag+seclevel;
		ProcPara += flag+rolelevel;
		ProcPara += flag+sharelevel;
		ProcPara += flag+userid;
		ProcPara += flag+subcompanyid;
		ProcPara += flag+departmentid;
		ProcPara += flag+roleid;
		ProcPara += flag+foralluser;
	    ProcPara += flag+crmid;
	    ProcPara += flag+orgGroupId;
	    ProcPara += flag+downloadlevel;//TD12005
		ProcPara += flag+operategroup;
		ProcPara += flag+orgid;
		ProcPara += flag+seclevelmax;
		ProcPara += flag+includesub;
		ProcPara += flag+custype;
		ProcPara += flag+isolddate;
		ProcPara += flag+"";
		ProcPara += flag+joblevel;
		ProcPara += flag+"";
		ProcPara += flag+"";
	    RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);

	
	}else {	
	 includesub = Util.null2String(request.getParameter("includesub"));
     String[] rsids = relatedshareids.split(",");
     for(int i=0;i<rsids.length;i++){
    	relatedshareid = rsids[i];
    	if(relatedshareid.equals(""))continue;
	    if(sharetype.equals("1")) userid = relatedshareid ;
	    if(sharetype.equals("2")) subcompanyid = relatedshareid ;
	    if(sharetype.equals("3")) departmentid = relatedshareid ;
	    if(sharetype.equals("4")) roleid = relatedshareid ;
	    if(sharetype.equals("5")) foralluser = "1" ;
	    if(sharetype.equals("6")) orgGroupId = relatedshareid ;
		if(sharetype.equals("7")) crmid = relatedshareid ;
		if(sharetype.equals("8")) custype = relatedshareid ;
		if(sharetype.equals("10")) jobids = relatedshareid ;
		
	 	if(sharetype.equals("10"))
	 	{
	 	   if(joblevel.equals("1"))
		 	{
	 	      	ProcPara = secid;
				ProcPara += flag+sharetype;
				ProcPara += flag+seclevel;
				ProcPara += flag+rolelevel;
				ProcPara += flag+sharelevel;
				ProcPara += flag+userid;
				ProcPara += flag+subcompanyid;
				ProcPara += flag+departmentid;
				ProcPara += flag+roleid;
				ProcPara += flag+foralluser;
			    ProcPara += flag+crmid;
			    ProcPara += flag+orgGroupId;
			    ProcPara += flag+downloadlevel;//TD12005
				ProcPara += flag+operategroup;
				ProcPara += flag+orgid;
				ProcPara += flag+seclevelmax;
				ProcPara += flag+includesub;
				ProcPara += flag+custype;
				ProcPara += flag+isolddate;
				ProcPara += flag+jobids;
				ProcPara += flag+joblevel;
				ProcPara += flag+"0";
				ProcPara += flag+"0";
			    RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
		 	}
		 	else if(joblevel.equals("2"))
		 	{
		 	    String[] jobsubcompanyids = jobsubcompany.split(",");
		 	    for(String jobsubcompanyid : jobsubcompanyids)
		 	    {
		 	        ProcPara = secid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userid;
					ProcPara += flag+subcompanyid;
					ProcPara += flag+departmentid;
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
				    ProcPara += flag+crmid;
				    ProcPara += flag+orgGroupId;
				    ProcPara += flag+downloadlevel;//TD12005
					ProcPara += flag+operategroup;
					ProcPara += flag+orgid;
					ProcPara += flag+seclevelmax;
					ProcPara += flag+includesub;
					ProcPara += flag+custype;
					ProcPara += flag+isolddate;
					ProcPara += flag+jobids;
					ProcPara += flag+joblevel;
					ProcPara += flag+"0";
					ProcPara += flag+jobsubcompanyid;
				    RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
		 	    }
		 	}
		 	else if(joblevel.equals("3"))
		 	{
		 	   String[] jobdepartmentids = jobdepartment.split(",");
		 	    for(String jobdepartmentid : jobdepartmentids)
		 	    {
		 	        ProcPara = secid;
					ProcPara += flag+sharetype;
					ProcPara += flag+seclevel;
					ProcPara += flag+rolelevel;
					ProcPara += flag+sharelevel;
					ProcPara += flag+userid;
					ProcPara += flag+subcompanyid;
					ProcPara += flag+departmentid;
					ProcPara += flag+roleid;
					ProcPara += flag+foralluser;
				    ProcPara += flag+crmid;
				    ProcPara += flag+orgGroupId;
				    ProcPara += flag+downloadlevel;//TD12005
					ProcPara += flag+operategroup;
					ProcPara += flag+orgid;
					ProcPara += flag+seclevelmax;
					ProcPara += flag+includesub;
					ProcPara += flag+custype;
					ProcPara += flag+isolddate;
					ProcPara += flag+jobids;
					ProcPara += flag+joblevel;
		 	        ProcPara += flag+jobdepartmentid;
					ProcPara += flag+"0";
				    RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
		 	    }
		 	}
	 	}
	 	else
	 	{
	 	    ProcPara = secid;
			ProcPara += flag+sharetype;
			ProcPara += flag+seclevel;
			ProcPara += flag+rolelevel;
			ProcPara += flag+sharelevel;
			ProcPara += flag+userid;
			ProcPara += flag+subcompanyid;
			ProcPara += flag+departmentid;
			ProcPara += flag+roleid;
			ProcPara += flag+foralluser;
		    ProcPara += flag+crmid;
		    ProcPara += flag+orgGroupId;
		    ProcPara += flag+downloadlevel;//TD12005
			ProcPara += flag+operategroup;
			ProcPara += flag+orgid;
			ProcPara += flag+seclevelmax;
			ProcPara += flag+includesub;
			ProcPara += flag+custype;
			ProcPara += flag+isolddate;
			ProcPara += flag+"";
			ProcPara += flag+"";
	 	    ProcPara += flag+"";
			ProcPara += flag+"";
			RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
	 	}
	 }
	  
	}
	
	return;
}


if(method.equals("addMutil")){   
        secid = Util.null2String(request.getParameter("docid")); 
        //System.out.println("secid::"+secid);
        String[] shareValues = request.getParameterValues("txtShareDetail"); 
        //System.out.println("shareValues::"+shareValues.length);
        if (shareValues!=null) {       
            for (int i=0;i<shareValues.length;i++){
               
                //out.println(shareValues[i]+"<br>");
                String[] paras = Util.TokenizerString2(shareValues[i],"_");
                String sharetype = paras[0];
                String seclevel=paras[3] ;
                String sharelevel=paras[4] ;
                String roleid="0";
                String rolelevel="0";
                 String userid = "0" ;
                String departmentid = "0" ;
                String subcompanyid="0";                
                String foralluser = "0" ;
                String crmid="0";
                String orgGroupId="0";
                String downloadlevel=paras[5];//TD12005
                
                if(sharetype.equals("4")) {
                    roleid = paras[1] ;
                    rolelevel=paras[2] ;
                }
                if(sharetype.equals("5")) foralluser = "1" ;
                // for TD.4240 edit by wdl
                /*
                if(sharetype.equals("2")) { //分部
                    subcompanyid = paras[1] ;
                }*/
                if ("1".equals(sharetype)||"3".equals(sharetype)||"9".equals(sharetype)||sharetype.equals("2")||sharetype.equals("6")){  //1:多人力资源    3:多部门...2:多分部	6:多群组
                    String tempStrs[]=Util.TokenizerString2(paras[1],",");
                    for(int k=0;k<tempStrs.length;k++){
                        
                        String tempStr = tempStrs[k];
                        if ("1".equals(sharetype)) userid=tempStr;
                        if ("3".equals(sharetype)) departmentid=tempStr;
                        if ("9".equals(sharetype)) crmid=tempStr;
                        if ("2".equals(sharetype))  subcompanyid =tempStr;
                        if ("6".equals(sharetype))  orgGroupId =tempStr;
                        // end
                        ProcPara = secid;
                        ProcPara += flag+sharetype;
                        ProcPara += flag+seclevel;
                        ProcPara += flag+rolelevel;
                        ProcPara += flag+sharelevel;
                        ProcPara += flag+userid;
                        ProcPara += flag+subcompanyid;
                        ProcPara += flag+departmentid;
                        ProcPara += flag+roleid;
                        ProcPara += flag+foralluser;     
                        ProcPara += flag+crmid;  
                        ProcPara += flag+orgGroupId;						
                        ProcPara += flag+downloadlevel;//TD12005
                        ProcPara += flag+"";
                	ProcPara += flag+"";
                	ProcPara += flag+"";
                	ProcPara += flag+"";
                        //RecordSet.executeProc("DocSecCategoryShare_Insert",ProcPara);
                        RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
                    }                       
                } else {
                    ProcPara = secid;
                    ProcPara += flag+sharetype;
                    ProcPara += flag+seclevel;
                    ProcPara += flag+rolelevel;
                    ProcPara += flag+sharelevel;
                    ProcPara += flag+userid;
                    ProcPara += flag+subcompanyid;
                    ProcPara += flag+departmentid;
                    ProcPara += flag+roleid;
                    ProcPara += flag+foralluser;                  
                     ProcPara += flag+crmid;  
                     ProcPara += flag+downloadlevel;//TD12005
                    RecordSet.executeProc("DocSecCategoryShare_Insert",ProcPara);
                }

                //for (int j=0;j<paras.length;j++){
                //   out.println(paras[j]+"<br>");
                //}
                //out.println("==========================");
            }
        }
        if(isDialog.equals("1")){
        	String noDownload = Util.null2String(request.getParameter("noDownload"));
        	response.sendRedirect("/docs/docs/DocShareAddBrowser.jsp?isdialog=1&isclose=1&para=1_"+secid+"&noDownload="+noDownload+"&tab=1");
        	return;
        }       
    response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=1");
	return;
}
if(method.equals("delMShare")) {
    //String[] delShareIds = request.getParameterValues("chkInTableTag");
    String[] delShareIds = request.getParameter("shareids").split(",");
    if (delShareIds!=null){
        for (int i=0;i<delShareIds.length;i++){
            RecordSet.executeProc("DocSecCategoryShare_Delete",delShareIds[i]);    
        }
    }
    response.sendRedirect("DocSecCategoryDefaultRightEdit.jsp?isdialog="+isDialog+"&id="+secid+"&tab=1");
    return;
}
%>
