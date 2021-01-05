
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.blog.BlogShareManager"%>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    String userid=""+user.getUID();
    FileUpload fu = new FileUpload(request);
	String operation=Util.null2String(fu.getParameter("operation"));
	BlogShareManager shareManager=new BlogShareManager();
	
	if(operation.equals("add")){           //添加共享条件
	   shareManager.addShare(""+userid,fu);
	   BlogDao blogDao=new BlogDao();
	   blogDao.delUpdateRemind(userid);
	   response.sendRedirect("shareSetting.jsp");
	}else if(operation.equals("delete")){ //删除共享条件
	   String shareid=Util.null2String(fu.getParameter("shareid"));
	   shareManager.deleteShare(userid,shareid); 
	   BlogDao blogDao=new BlogDao();
	   blogDao.delUpdateRemind(userid);
	}else if(operation.equals("edit")){
	   String isReceive=Util.null2String(fu.getParameter("isReceive"));
	   isReceive=isReceive.equals("1")?"1":"0";
	   String isThumbnail=Util.null2String(fu.getParameter("isThumbnail"));
	   isThumbnail=isThumbnail.equals("1")?"1":"0";
	   String maxAttention=Util.null2String(fu.getParameter("maxAttention"));
	   String sqlstr="update blog_setting set isReceive="+isReceive+",maxAttention="+maxAttention+",isThumbnail="+isThumbnail+" where userid="+userid;
	   
	   RecordSet.execute(sqlstr);
	   
	   response.sendRedirect("baseSetting.jsp");
	}else if(operation.equals("editApp")){ //保存微博应用选项 
		String[] appids=fu.getParameterValues("appid"); 
		
		String isActives[]=new String[appids.length];
		for(int i=0;i<appids.length;i++){
			String isActive=fu.getParameter("isActive_"+appids[i]);
			isActive=isActive.equals("1")?"1":"0";
			String sql="update blog_app set isActive="+isActive+" where id="+appids[i];
			RecordSet.execute(sql);
		}
		response.sendRedirect("BlogAppSetting.jsp");
    }else if(operation.equals("editBaseSetting")){ //保存微博应用选项 
		String allowRequest=fu.getParameter("allowRequest");
		allowRequest=allowRequest.equals("1")?"1":"0";
		String isSingRemind=fu.getParameter("isSingRemind");
		isSingRemind=isSingRemind.equals("1")?"1":"0";
		String isManagerScore=fu.getParameter("isManagerScore");
		isManagerScore=isManagerScore.equals("1")?"1":"0";
		String enableDate=fu.getParameter("enableDate"); 
		String attachmentDir=fu.getParameter("attachmentDir");
		String allowExport=fu.getParameter("allowExport").equals("1")?"1":"0";
		String isSendBlogNote=fu.getParameter("isSendBlogNote").equals("1")?"1":"0";
        
        String makeUpTime = fu.getParameter("makeUpTime");
        String canEditTime = fu.getParameter("canEditTime");
        
		String sql="update blog_sysSetting set allowRequest="+allowRequest+",enableDate='"+enableDate+"',isSingRemind="+isSingRemind+",isManagerScore="+isManagerScore
            +",attachmentDir='"+attachmentDir+"' ,allowExport = "+allowExport+" , isSendBlogNote = "+isSendBlogNote + ",makeUpTime='"+ makeUpTime + "',canEditTime='" + canEditTime + "'";
		RecordSet.execute(sql);
		response.sendRedirect("BlogbaseSetting.jsp");
    }else if(operation.equals("addTemp")){ //新建微博模版
    	BlogDao blogDao=new BlogDao();
    	int tempid=Util.getIntValue(fu.getParameter("tempid"),0);
        String tempName=Util.null2String(fu.getParameter("tempName"));
        String tempDesc=Util.null2String(fu.getParameter("tempDesc"));
        String tempContent=Util.null2String(fu.getParameter("tempContent"));
        String isUsed=Util.null2String(fu.getParameter("isUsed"));
        String isSystem = Util.null2String(fu.getParameter("isSystem"),"0");
        isUsed=isUsed.equals("1")?"1":"0";
        if(tempid==0)//新建模版
        {
        	blogDao.addTemp(tempName,tempDesc,isSystem,isUsed,tempContent,user.getUID()+"");
        	//response.sendRedirect("BlogTemplateSetting.jsp");
        	out.println("<script>parent.getParentWindow(window).callback()</script>");
        }else
        {
        	blogDao.updateTemp(""+tempid,tempName,tempDesc,isUsed,tempContent,user.getUID()+"");
        	// response.sendRedirect("BlogTemplateSetting.jsp");
        	out.println("<script>parent.getParentWindow(window).callback()</script>");
        }
    }else if(operation.equals("deleteTemp")){           //删除微博模版
		   String tempid=Util.null2String(fu.getParameter("tempid"));
		   BlogDao blogDao=new BlogDao();
		   blogDao.deleteTemp(""+tempid);
	}else if(operation.equals("addTempShare")){         //添加共享条件
	   int tempid=Util.getIntValue(fu.getParameter("tempid"),0);
	   BlogDao blogDao=new BlogDao();
	   blogDao.addTempShare(""+tempid,fu);
	   out.println("<script>parent.getDialog(window).close()</script>");
	   //response.sendRedirect("blogTemplateShare.jsp?tempid="+tempid);
	}else if(operation.equals("deleteTempShare")){       //删除共享条件
		   int shareid=Util.getIntValue(fu.getParameter("shareid"),0);
		   BlogDao blogDao=new BlogDao();
		   blogDao.deleteTempShare(""+shareid);
	}else if(operation.equals("addSpecified")){         //添加指定共享条件
		   int specifiedid=Util.getIntValue(fu.getParameter("specifiedid"),0);
		   BlogDao blogDao=new BlogDao();
		   blogDao.addSpecifiedShare(""+specifiedid,fu);
		   //response.sendRedirect("/blog/specified/blogSpecifiedShareList.jsp");
		   out.println("<script>parent.getParentWindow(window).closeWin()</script>");
	}else if(operation.equals("deleteSpecifiedShare")){       //删除指定共享条件
		   int shareid=Util.getIntValue(fu.getParameter("shareid"),0);
		   String specifiedid=Util.null2String(fu.getParameter("specifiedid"));
		   BlogDao blogDao=new BlogDao(); 
		   blogDao.deleteSpecifiedShare(specifiedid,""+shareid);
	}else if(operation.equals("deleteSpecified")){            //删除指定共享
		   String specifiedid=Util.null2String(fu.getParameter("specifiedid"));
		   BlogDao blogDao=new BlogDao();
		   blogDao.deleteSpecified(specifiedid);
	}else if(operation.equals("default")){
		String sql = "DELETE FROM blog_templateUser WHERE userId="+user.getUID()+"";
		RecordSet.execute(sql);
		int defaultMailTemplateId = Util.getIntValue(request.getParameter("defaultTemplateId"));
		if(Util.getIntValue(request.getParameter("isclear"))!=1 && defaultMailTemplateId!=-1){
			sql = "INSERT INTO blog_templateUser (userId, templateId) VALUES ("+user.getUID()+", "+defaultMailTemplateId+")";
			RecordSet.execute(sql);
		}

		
	}
%>