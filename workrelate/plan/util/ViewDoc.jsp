<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.pr.util.RightUtil" scope="page" />
<jsp:useBean id="sfd" class="weaver.splitepage.operate.SpopForDoc" scope="page" />
<%
		String currentuserid = user.getUID()+"";
		String id = Util.null2String(request.getParameter("id"));
		String plandetailid = Util.null2String(request.getParameter("plandetailid"));
        String planid = Util.null2String(request.getParameter("planid"));
        String planid2 = "";
        String fileid = Util.null2String(request.getParameter("fileid"));
        String review = Util.null2String(request.getParameter("review"));
        boolean addshare = false;
		if(!id.equals("")){
			//判断是否有查看此文档权限
			String userInfo=user.getLogintype()+"_"+user.getUID()+"_"+user.getSeclevel()+"_"+user.getLogintype()+"_"+user.getUserDepartment()+"_"+user.getUserSubCompany1();
			ArrayList PdocList = sfd.getDocOpratePopedom(id,userInfo);
			if(!((String)PdocList.get(0)).equals("true")){//无查看权限
				if(!plandetailid.equals("")){
					rs.executeSql("select planid,planid2 from PR_PlanReportDetail where id="+plandetailid);
					if(rs.next()){
						planid = Util.null2String(rs.getString("planid"));
						planid2 = Util.null2String(rs.getString("planid2"));
					}
				}
				if(!planid.equals("") || !planid2.equals("")){
					//判断是否可查看此考核结果
					boolean canview = RightUtil.isCanViewPlan(planid,currentuserid);
					boolean canview2 = RightUtil.isCanViewPlan(planid2,currentuserid);
					if(canview || canview2){
						//判断计划报告中是否包含此文档
						String sql = "";
						if(!plandetailid.equals("")) {
							sql = "select count(id) as amount from PR_PlanReportDetail where id="+plandetailid+" and fileids like ',%"+id+"%,'";
							rs.executeSql(sql);
							if(rs.next() && rs.getInt(1)>0){
								addshare = true;
							}else{
								sql = "select count(id) as amount from PR_PlanFeedback where plandetailid="+plandetailid+" and fileids like ',%"+id+"%,'";
								rs.executeSql(sql);
								if(rs.next() && rs.getInt(1)>0){
									addshare = true;
								}
							}
						}else{
							sql = "select count(id) as amount from PR_PlanReport where id="+planid+" and fileids like ',%"+id+"%,'";
							rs.executeSql(sql);
							if(rs.next() && rs.getInt(1)>0){
								addshare = true;
							}
						}
						
					}
				}
				if(addshare){
					rs.executeSql("insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,downloadlevel) "
							+"values(" + id + ",1,0,0,1," + user.getUID() + ",0,0,0,0,0,1)");
					try{
						DocViewer.setDocShareByDoc(id);
					}
					catch (Exception localException){
					}
				}
				
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
%>