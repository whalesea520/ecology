
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="cmtil" class="weaver.workrelate.util.CommonTransUtil" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
		String id = Util.null2String(request.getParameter("id"));
        String sellchanceid = Util.null2String(request.getParameter("sellchanceid"));
        String customerid = Util.null2String(request.getParameter("customerid"));
        String fileid = Util.null2String(request.getParameter("fileid"));
        boolean addshare = false;
		if(!id.equals("")){
			//判断是否有查看此文档权限
			rs.executeSql("select 1 from DocShare where docid="+id+" and userid="+user.getUID());
			if(!rs.next()){//无查看权限
				if(!customerid.equals("")){//来自客户联系记录的附件
					//判断客户联系记录中是否包括此文档
					rs.executeSql("select count(id) as amount from  WorkPlan where type_n=3 and crmid='"+customerid+"' and relateddoc like '%"+id+"%'");
					if(rs.next()){
						if(rs.getCounts()>0){
							addshare = true;
						}
					}
				}else if(!sellchanceid.equals("")){
					//判断销售机会中是否包含此文档
					rs.executeSql("select 1 from CRM_Sellchance where id="+sellchanceid+" and (fileids like ',%"+id+"%,' or fileids2 like ',%"+id+"%,' or fileids3 like ',%"+id+"%,')"
						+" union all select 1 from CRM_SellChance_Other where sellchanceid="+sellchanceid+" and remark like ',%"+id+"%,'");
					if(rs.next()){
						rs.executeSql("select customerid from CRM_SellChance where id="+sellchanceid);
						if(rs.next()) {
							customerid = rs.getString(1);
							addshare = true;
						}
					}
						
				}
				if(addshare && !customerid.equals("")){
					//判断是否有查看该客户商机权限
					int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
					if(sharelevel>0){
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
		}
		if(fileid.equals("")){
			response.sendRedirect("/docs/docs/DocDsp.jsp?id="+id);
		}else{
			response.sendRedirect("/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1");
		}
		return;
%>