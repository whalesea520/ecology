
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeRightForPage" class="weaver.formmode.setup.ModeRightForPage" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />

<%

String method = Util.null2String(request.getParameter("method"));
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);//数据id

String batchShare = Util.null2String(request.getParameter("batchShare"));//批量共享

ModeShareManager.setModeId(modeId);
int MaxShare = 0;
List<User> lsUser = ModeRightInfo.getAllUserCountList(user);
for(int i=0;i<lsUser.size();i++){
	User tempUser = lsUser.get(i);
	String rightStr = ModeShareManager.getShareDetailTableByUser("formmode",tempUser);
	rs.executeSql("select * from "+rightStr+" t where sourceid="+billid);
	int tempShare = 0;
	if(rs.next()){
		tempShare = rs.getInt("sharelevel");
	}
	if(tempShare>MaxShare){
		MaxShare = tempShare;
	}
}

if(MaxShare<=1 && !batchShare.equals("1")) {//有编辑权限才有共享权限,不包括批量共享
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(method.equals("delShare")){//保存默认权限(创建人相关)
	String share_set_id[] = request.getParameterValues("share_set_id");
	String delid = "-1";
	String sql = "";
	for(int i=0;i<share_set_id.length;i++){
		delid += "," + Util.null2String(share_set_id[i],"-1");
	}
	ModeRightForPage.delRight(billid,modeId,delid);
	
	//--------删除对应的文档权限---------
	ModeRightInfo.delDocShareWithUser(billid,modeId,delid);
	StringBuffer resultBuffer = new StringBuffer();
	resultBuffer.append("<script>");
	resultBuffer.append("window.location.href = \"/formmode/view/ModeShareIframe.jsp?ajax=2&modeId="+modeId+"&billid="+billid+"&MaxShare="+MaxShare+"\"");
	resultBuffer.append("</script>");
	out.println(resultBuffer);
	return;
	
}else if(method.equals("addShare")){//前台设置权限
	//int billid = Util.getIntValue(request.getParameter("billid"),0);//数据id
	int sharetype = Util.getIntValue(request.getParameter("sharetype"),0);//共享类型
	String relatedid = Util.null2String(request.getParameter("relatedid"));//共享类型的值
	int rolelevel = Util.getIntValue(request.getParameter("rolelevel"),0);//角色级别
	int showlevel = Util.getIntValue(request.getParameter("showlevel"),0);//安全级别
	int showlevel2 = Util.getIntValue(request.getParameter("showlevel2"),0);//安全级别
	int righttype = Util.getIntValue(request.getParameter("righttype"),0);//权限级别
	
	int isRoleLimited = Util.getIntValue(request.getParameter("isRoleLimited"),0);//角色是否受作用域限制
	int rolefieldtype = Util.getIntValue(request.getParameter("rolefieldtype"),0);//作用域字段类型
	int orgrelation = Util.getIntValue(request.getParameter("orgrelation"),0);//
	String rolefield = Util.null2String(request.getParameter("rolefield"));//角色限制字段
	String HrmCompanyVirtual = Util.null2String(request.getParameter("HrmCompanyVirtual"));
	int joblevel = Util.getIntValue(request.getParameter("joblevel"),0);
	String jobleveltext = Util.null2String(request.getParameter("jobleveltext"));
	//处理表单重复提交的新增默认共享
	String token = Util.null2String(request.getParameter("token"));
	String sessionToken = (String)request.getSession().getAttribute("sessionToken");
	request.getSession().removeAttribute("sessionToken");
	if(sessionToken == null || !sessionToken.equals(token)) {
		ModeRightForPage.writeLog(">>>>summit again token=" + token);
	}else {
		//ModeRightForPage.addNewRight(billid,modeId,sharetype,relatedid,rolelevel,showlevel,righttype);
		ModeRightForPage.addNewRight(billid,modeId,sharetype,relatedid,rolelevel,showlevel,righttype,isRoleLimited,rolefieldtype,rolefield,showlevel2,HrmCompanyVirtual,orgrelation,joblevel,jobleveltext);
	}
	//给表单中的文档增加权限
	ModeRightInfo.editDocShareWithUser(billid,modeId,sharetype,0,rolelevel,showlevel,righttype);
	response.sendRedirect("/formmode/view/ModeShareIframe.jsp?ajax=2&modeId="+modeId+"&billid="+billid+"&MaxShare="+MaxShare);
	return;
}else if(method.equals("addShareMore")){//前台批量设置权限

	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	String billids  = Util.null2String(request.getParameter("billids"));
	String customid  = Util.null2String(request.getParameter("customid"));
	
	if(txtShareDetail != null && txtShareDetail.length >0){
		ArrayList billidsList = Util.TokenizerString(billids,",");
		
		for(int j=0;j<billidsList.size();j++){
			int billid2  = Util.getIntValue((String)billidsList.get(j),0);
			
			ModeRightForPage.setUser(user);
			int sharelevel = ModeRightForPage.getUserSharelevel(modeId,billid2);
			
			for(int i=0;i<txtShareDetail.length;i++){
				String txtSD = txtShareDetail[i];

				ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
				
			
				if(sharelevel <=1 || sharelevel < Util.getIntValue((String)txtSDList.get(4),0)){
					continue;
				}
				
				int sharetype = Util.getIntValue((String)txtSDList.get(0),0);//共享类型
				String relatedid = Util.null2String((String)txtSDList.get(1));//共享类型的值
				int rolelevel = Util.getIntValue((String)txtSDList.get(2),0);//角色级别
				String showLevelStr = (String)txtSDList.get(3);
				int showlevel = 0;
				int showlevel2 = -1;
				if(showLevelStr.indexOf("$")!=-1){
					String[] arr = showLevelStr.split("\\$");
					if(arr.length==2){
						showlevel = Util.getIntValue(arr[0],0);
						showlevel2 = Util.getIntValue(arr[1]);
					}else{
						showlevel = Util.getIntValue((String)txtSDList.get(3),0);
					}
				}else{
					showlevel = Util.getIntValue((String)txtSDList.get(3),0);
				}
				int righttype = Util.getIntValue((String)txtSDList.get(4),0);//权限级别
				int hrmCompanyVirtual = Util.getIntValue((String)txtSDList.get(6),0);//权限级别
				
				int orgrelation = Util.getIntValue((String)txtSDList.get(7),0);
				int joblevel = Util.getIntValue((String)txtSDList.get(8),0);
				String jobleveltext = Util.null2String((String)txtSDList.get(9));
				if(txtSDList.size()>10){
					int isRoleLimited = Util.getIntValue((String)txtSDList.get(10),0);//角色是否受作用域限制
					if(isRoleLimited==1){
						int rolefieldtype = Util.getIntValue((String)txtSDList.get(11),0);//作用域字段类型
						String rolefield = Util.null2String((String)txtSDList.get(12));//角色限制字段
						ModeRightForPage.addNewRight(billid2,modeId,sharetype,relatedid,rolelevel,showlevel,righttype,isRoleLimited,rolefieldtype,rolefield,showlevel2,hrmCompanyVirtual+"",orgrelation,joblevel,jobleveltext);
					}else{
						ModeRightForPage.addNewRight(billid2,modeId,sharetype,relatedid,rolelevel,showlevel,righttype,0,0,"",showlevel2,hrmCompanyVirtual+"",orgrelation,joblevel,jobleveltext);
					}
				}else{
					ModeRightForPage.addNewRight(billid2,modeId,sharetype,relatedid,rolelevel,showlevel,righttype,0,0,"",showlevel2,hrmCompanyVirtual+"",orgrelation,joblevel,jobleveltext);
				}
				
				//--------给表单中的文档增加权限--------
				ModeRightInfo.editDocShareWithUser(billid2,modeId,sharetype,0,rolelevel,showlevel,righttype);
			}
		}
		
	}
	response.sendRedirect("/formmode/search/CustomSearchBySimpleIframe.jsp?customid="+customid);
	return ;
}
%>