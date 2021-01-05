<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.file.FileUpload"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.gp.util.RightUtil" scope="page" />
<jsp:useBean id="sfd" class="weaver.splitepage.operate.SpopForDoc" scope="page" />
<%
		FileUpload fu = new FileUpload(request);
        String currentuserid = user.getUID()+"";
		String id = Util.null2String(fu.getParameter("id"));
        String scoreid = Util.null2String(fu.getParameter("scoreid"));
        String fileid = Util.null2String(fu.getParameter("fileid"));
        String review = Util.null2String(fu.getParameter("review"));
        boolean addshare = false;
		if(!id.equals("")){
			//判断是否有查看此文档权限
			String userInfo=user.getLogintype()+"_"+user.getUID()+"_"+user.getSeclevel()+"_"+user.getLogintype()+"_"+user.getUserDepartment()+"_"+user.getUserSubCompany1();
			ArrayList PdocList = sfd.getDocOpratePopedom(id,userInfo);
			if(!((String)PdocList.get(0)).equals("true")){//无查看权限
			//rs.executeSql("select 1 from DocShare where docid="+id+" and userid="+user.getUID());
			//if(!rs.next()){//无查看权限
				if(!scoreid.equals("")){
					//判断是否可查看此考核结果
					boolean canview = RightUtil.isCanViewScore(scoreid,currentuserid);
					if(canview){
						//判断考核结果中是否包含此文档
						rs.executeSql("select count(id) as amount from GP_AccessScoreCheck where scoreid="+scoreid+" and fileids like ',%"+id+"%,'");
						if(rs.next()){
							if(rs.getCounts()>0){
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
%>