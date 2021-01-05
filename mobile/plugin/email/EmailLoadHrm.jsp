<%@page import="weaver.hrm.company.DepartmentComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.splitepage.transform.SptmForMail"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.email.WeavermailComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
		FileUpload fu=new FileUpload(request);
		String type=Util.null2String(fu.getParameter("type"));
		String mailid=Util.null2String(fu.getParameter("mailid"));
		
		String isInternal=Util.null2String(fu.getParameter("isInternal"));
		
		if(isInternal.equals("1")){
			mrs.setId(mailid+"");
			mrs.selectMailResource();
			mrs.next();
			
			//[1--表示接收人，2--表示抄送人，3--密送人]
			String all=mrs.getToall();
			String dpids=mrs.getTodpids();
			String ids=mrs.getToids();
			
			String showname = "";
			if("2".equals(type)){
				 all=mrs.getCcall();
				 dpids=mrs.getCcdpids();
				 ids=mrs.getCcids();
			}else if("3".equals(type)){
				 all=mrs.getBccall();
				 dpids=mrs.getBccdpids();
				 ids=mrs.getBccids();
				 //1340
			}
			if("1".equals(all)){
				showname+="所有人";
			}else{
					DepartmentComInfo departmentComInfo=new DepartmentComInfo();
					String dep_ids[] = Util.TokenizerString2(dpids, ",");
			        for(int i=0;i<dep_ids.length;i++){
			        	String hrmid = Util.null2String(dep_ids[i]);
			        	if(!hrmid.equals("")){
			        		showname+="<a onclick=\"openShowNameHref('&internaltodpids="+hrmid+"&isInternal=1',this,1)\" style='cursor: pointer;'>"+departmentComInfo.getDepartmentname(hrmid)+"</a>&nbsp;";
			        	}
			        }	
			       	String hrmids[] = Util.TokenizerString2(ids, ",");
			        for(int i=0;i<hrmids.length;i++){
			        	String hrmid = Util.null2String(hrmids[i]);
			        	if(!hrmid.equals("")){
			        		showname+="<a onclick='openShowNameHref(\"&internalto="+hrmid+"&isInternal=1\",this)' style='cursor: pointer;'>"+hrm.getResourcename(hrmid)+"</a>&nbsp";
			        		showname+="<a class='ico_profileTips' href='javaScript:openhrm("+hrmid+");' onclick='pointerXY(event);'>&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp";
			        	}
			        }       
			}
			showname+="&nbsp;&nbsp;<a href='javascript:void(0)' style='color:#8fa7b3' onclick=\"hideALL(this)\">[收缩]</a>";
	        out.clear();
	        out.println(showname);
		}else{ //获取所有发件人
    		String mailaddress  = Util.null2String(fu.getParameter("mailaddress"));
    		//System.out.println("mailaddress================="+mailaddress);
    		SptmForMail sptmForMail=new SptmForMail();
    		String mailAddressStr=sptmForMail.getNameByEmailTOP(mailaddress,""+user.getUID(),"all");
    		mailAddressStr+="&nbsp;&nbsp;<a href='javascript:void(0)' style='color:blue' onclick=\"hideALL(this)\">[收缩]</a>"; 
    		//System.out.println("mailAddressStr================="+mailAddressStr);
    		out.println(mailAddressStr);
    	}
%>
