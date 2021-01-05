<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="cmtil" class="weaver.workrelate.util.CommonTransUtil" scope="page" />
<jsp:useBean id="sfd" class="weaver.splitepage.operate.SpopForDoc" scope="page" />
<%
		String id = Util.null2String(request.getParameter("id"));
        String taskId = Util.null2String(request.getParameter("taskId"));
        String fileid = Util.null2String(request.getParameter("fileid"));
        String review = Util.null2String(request.getParameter("review"));
		if(!id.equals("") && !taskId.equals("")){
			//判断任务中是否包含此文档
			rs.executeSql("select 1 from TM_TaskInfo where id="+taskId+" and fileids like ',%"+id+"%,'"
					+" union all select 1 from TM_TaskFeedback where taskid="+taskId+" and fileids like ',%"+id+"%,'");
			 
			if(rs.next()){
				if (cmtil.getRight(taskId,user)>0) {//判断是否有权限
					//判断是否有查看此文档权限
					String userInfo=user.getLogintype()+"_"+user.getUID()+"_"+user.getSeclevel()+"_"+user.getLogintype()+"_"+user.getUserDepartment()+"_"+user.getUserSubCompany1();
					ArrayList PdocList = sfd.getDocOpratePopedom(id,userInfo);
					if(!((String)PdocList.get(0)).equals("true")){//无查看权限
					//rs.executeSql("select 1 from DocShare where docid="+id+" and userid="+user.getUID());
					//if(!rs.next()){
						rs.executeSql("insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,downloadlevel) "
								+"values(" + id + ",1,0,0,1," + user.getUID() + ",0,0,0,0,0,1)");
						try{
							DocViewer.setDocShareByDoc(id);
						}
						catch (Exception localException){
						}
					}
					if(fileid.equals("")){
						response.sendRedirect("/docs/docs/DocDsp.jsp?id="+id);
					}else{
						if(review.equals("1")){
							response.sendRedirect("/docview/main.jsp?fileid="+fileid);
						}else{
							response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1");
						}
					}
					return;
				}
			}
		}
%>