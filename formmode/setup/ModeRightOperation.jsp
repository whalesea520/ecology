<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.formmode.setup.ModeRightInfoThread"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<%
String MaxShare = Util.null2String(request.getParameter("MaxShare"));
if(MaxShare.equals("")){
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
}
%>
<%
String method = Util.null2String(request.getParameter("method"));
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);

if(method.equals("addNew")){//新增权限
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	String isEditAllData = Util.null2String(request.getParameter("isEditAllData"));
	if(txtShareDetail != null){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];
			ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
			modeRightInfo.init();
			modeRightInfo.setModeId(modeId);
			modeRightInfo.setSharetype(Util.getIntValue((String)txtSDList.get(0),0));
			modeRightInfo.setRelatedids(Util.null2String((String)txtSDList.get(1)));
			modeRightInfo.setRolelevel(Util.getIntValue((String)txtSDList.get(2),0));
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
			modeRightInfo.setShowlevel(showlevel);
			modeRightInfo.setShowlevel2(showlevel2);
			modeRightInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			modeRightInfo.setLayoutid(Util.getIntValue((String)txtSDList.get(6),0));
			modeRightInfo.setLayoutid1(Util.getIntValue((String)txtSDList.get(7),0));
			modeRightInfo.setLayoutorder(Util.getIntValue((String)txtSDList.get(8),0));
			if(txtSDList.size()>9){
				String Javafilename = Util.null2String((String)txtSDList.get(9));
				if(!Javafilename.equals("0")){
					modeRightInfo.setJavafilename(Util.null2String((String)txtSDList.get(9)).replaceAll("#", "_"));
				}
			}
			//上级关系 1, 当前人员  2,直接上级  3,所有上级 [0,无效]
			modeRightInfo.setHigherlevel(Util.getIntValue((String)txtSDList.get(10),0));
			//导入类型
			modeRightInfo.setImporttype(Util.getIntValue((String)txtSDList.get(11),0));
			//多维组织类型
			modeRightInfo.setHrmCompanyVirtualType(Util.null2String((String)txtSDList.get(12)));
			//组织关系  所有上级/所有下级
			modeRightInfo.setOrgrelation(Util.getIntValue((String)txtSDList.get(13),0));
			
			modeRightInfo.setJoblevel(Util.getIntValue((String)txtSDList.get(14),0));
			modeRightInfo.setJobleveltext(Util.null2String((String)txtSDList.get(15)));
			
			int sharetype = Util.getIntValue((String)txtSDList.get(0),0);
			if(sharetype==4){//角色
				if(txtSDList.size()>16){
					int isRoleLimited = Util.getIntValue((String)txtSDList.get(16),0);
					modeRightInfo.setIsRoleLimited(isRoleLimited);
					if(isRoleLimited==1){
						int rolefieldtype = Util.getIntValue((String)txtSDList.get(17));
						String rolefield = Util.null2String((String)txtSDList.get(18));
						modeRightInfo.setRolefieldtype(rolefieldtype);
						modeRightInfo.setRolefield(rolefield);
					}
				}else{
					modeRightInfo.setIsRoleLimited(0);
				}
			}else{
				modeRightInfo.setIsRoleLimited(0);
			}
			if(txtSDList.size()==17){
			    String JavafileAddress = Util.null2String((String)txtSDList.get(16));
                if(!JavafileAddress.equals("0")){
                    modeRightInfo.setJavafileAddress(Util.null2String((String)txtSDList.get(16)).replaceAll("#", "_"));
                }
            }
			modeRightInfo.setIsEditAllData(isEditAllData);
			modeRightInfo.insertAddRight();
		}
	}
}else if(method.equals("delete")){//删除权限
	String mainids = Util.null2String(request.getParameter("mainids"));
	if(!mainids.equals("")){
		modeRightInfo.init();
		modeRightInfo.setModeId(modeId);
		modeRightInfo.delShareByIds(mainids);
	}
}else if(method.equals("deleteDataRight")){//删除权限并删除数据对应的权限
	String mainids = Util.null2String(request.getParameter("mainids"));
	if(!mainids.equals("")){
		modeRightInfo.init();
		modeRightInfo.setModeId(modeId);
		modeRightInfo.delDataByRightId(mainids);
	}
}else if(method.equals("saveForCreator")){//保存默认权限(创建人相关)
		int creator = Util.getIntValue(request.getParameter("creator"),99);
	int creatorlayoutid = Util.getIntValue(request.getParameter("creatorlayoutid"),0);	
	int creatorlayoutid1 = Util.getIntValue(request.getParameter("creatorlayoutid1"),0);
	int creatorlayoutorder = Util.getIntValue(request.getParameter("creatorlayoutorder"),0);
	int resetModeShareBycreteor = Util.getIntValue(request.getParameter("resetModeShareBycreteor"),0);
	
	int creatorleader = Util.getIntValue(request.getParameter("creatorleader"),99);
	int creatorleaderlayoutid = Util.getIntValue(request.getParameter("creatorleaderlayoutid"),0);	
	int creatorleaderlayoutid1 = Util.getIntValue(request.getParameter("creatorleaderlayoutid1"),0);
	int creatorleaderlayoutorder = Util.getIntValue(request.getParameter("creatorleaderlayoutorder"),0);
	int resetModeShareByManager = Util.getIntValue(request.getParameter("resetModeShareByManager"),0);
	
	int allcreatorleader = Util.getIntValue(request.getParameter("allcreatorleader"),99);
	int creatorAllLeadersl = Util.getIntValue(request.getParameter("creatorAllLeadersl"),10);
	String creatorAllLeadersl2 = StringHelper.null2String(request.getParameter("creatorAllLeadersl2"));
	if(creatorAllLeadersl2.equals("")){
		creatorAllLeadersl2 = "null";
	}
	int allcreatorleaderlayoutid = Util.getIntValue(request.getParameter("allcreatorleaderlayoutid"),0);	
	int allcreatorleaderlayoutid1 = Util.getIntValue(request.getParameter("allcreatorleaderlayoutid1"),0);
	int allcreatorleaderlayoutorder = Util.getIntValue(request.getParameter("allcreatorleaderlayoutorder"),0);
	int resetModeShareByAllManager = Util.getIntValue(request.getParameter("resetModeShareByAllManager"),0);
	
	int creatorSub = Util.getIntValue(request.getParameter("creatorSub"),99);
	int creatorSubsl = Util.getIntValue(request.getParameter("creatorSubsl"),10);
	String creatorSubsl2 = StringHelper.null2String(request.getParameter("creatorSubsl2"));
	if(creatorSubsl2.equals("")){
		creatorSubsl2 = "null";
	}
	int creatorSublayoutid = Util.getIntValue(request.getParameter("creatorSublayoutid"),0);	
	int creatorSublayoutid1 = Util.getIntValue(request.getParameter("creatorSublayoutid1"),0);
	int creatorSublayoutorder = Util.getIntValue(request.getParameter("creatorSublayoutorder"),0);
	int resetModeShareBySubDept = Util.getIntValue(request.getParameter("resetModeShareBySubDept"),0);
	
	int creatorDept = Util.getIntValue(request.getParameter("creatorDept"),99);
	int creatorDeptsl = Util.getIntValue(request.getParameter("creatorDeptsl"),10);
	String creatorDeptsl2 = StringHelper.null2String(request.getParameter("creatorDeptsl2"));
	if(creatorDeptsl2.equals("")){
		creatorDeptsl2 = "null";
	}
	int creatorDeptlayoutid = Util.getIntValue(request.getParameter("creatorDeptlayoutid"),0);	
	int creatorDeptlayoutid1 = Util.getIntValue(request.getParameter("creatorDeptlayoutid1"),0);
	int creatorDeptlayoutorder = Util.getIntValue(request.getParameter("creatorDeptlayoutorder"),0);
	int resetModeShareByDept = Util.getIntValue(request.getParameter("resetModeShareByDept"),0);
	
	int creatorpost = Util.getIntValue(request.getParameter("creatorpost"),99);
	int creatorpostlayoutid = Util.getIntValue(request.getParameter("creatorpostlayoutid"),0);	
	int creatorpostlayoutid1 = Util.getIntValue(request.getParameter("creatorpostlayoutid1"),0);
	int creatorpostlayoutorder = Util.getIntValue(request.getParameter("creatorpostlayoutorder"),0);
	int resetModeShareBycreteorpost = Util.getIntValue(request.getParameter("resetModeShareBycreteorpost"),0);
	
	
	String creatorleadervirtualtype = Util.null2String(request.getParameter("creatorleadervirtualtype_value"));
	String allcreatorleadervirtualtype = Util.null2String(request.getParameter("allcreatorleadervirtualtype_value"));
	String creatorSubvirtualtype = Util.null2String(request.getParameter("creatorSubvirtualtype_value"));
	String creatorDeptvirtualtype = Util.null2String(request.getParameter("creatorDeptvirtualtype_value"));
	modeRightInfo.init();
	modeRightInfo.setModeId(modeId);
	modeRightInfo.setCreator(creator);
	modeRightInfo.setCreatorleader(creatorleader);
	modeRightInfo.setAllcreatorleader(allcreatorleader);
	modeRightInfo.setCreatorSub(creatorSub);
	modeRightInfo.setCreatorDept(creatorDept);
	modeRightInfo.setHigherlevel(3);
	modeRightInfo.setCreatorJobtitle(creatorpost);
	
	modeRightInfo.setCreatorSubsl(creatorSubsl);
	modeRightInfo.setCreatorDeptsl(creatorDeptsl);
	modeRightInfo.setCreatorAllLeadersl(creatorAllLeadersl);
	modeRightInfo.setCreatorSubsl2(creatorSubsl2);
	modeRightInfo.setCreatorDeptsl2(creatorDeptsl2);
	modeRightInfo.setCreatorAllLeadersl2(creatorAllLeadersl2);
	
	modeRightInfo.setCreatorleadervirtualtype(creatorleadervirtualtype);
	modeRightInfo.setAllcreatorleadervirtualtype(allcreatorleadervirtualtype);
	modeRightInfo.setCreatorDeptvirtualtype(creatorDeptvirtualtype);
	modeRightInfo.setCreatorSubvirtualtype(creatorSubvirtualtype);
	
	modeRightInfo.setCreatorJobtitle(creatorpost);
	
	modeRightInfo.updateShareCreator();
	//更新创建人相关布局
	modeRightInfo.updateShareCreatorLayout(1,creatorlayoutid,creatorlayoutid1,creatorlayoutorder);
	modeRightInfo.updateShareCreatorLayout(2,creatorleaderlayoutid,creatorleaderlayoutid1,creatorleaderlayoutorder);
	modeRightInfo.updateShareCreatorLayout(3,creatorSublayoutid,creatorSublayoutid1,creatorSublayoutorder);
	modeRightInfo.updateShareCreatorLayout(4,creatorDeptlayoutid,creatorDeptlayoutid1,creatorDeptlayoutorder);
	modeRightInfo.updateShareCreatorLayout(5,allcreatorleaderlayoutid,allcreatorleaderlayoutid1,allcreatorleaderlayoutorder);
	modeRightInfo.updateShareCreatorLayout(6,creatorpostlayoutid,creatorpostlayoutid1,creatorpostlayoutorder);
	
	if(1==resetModeShareBycreteor){//
		modeRightInfo.updateRestModeShare(1);
	}
	if(1==resetModeShareByManager){
		modeRightInfo.updateRestModeShare(2);
	}
	if(1==resetModeShareByAllManager){
		modeRightInfo.updateRestModeShare(5);
	}
	if(1==resetModeShareBySubDept){
		modeRightInfo.updateRestModeShare(3);
	}
	if(1==resetModeShareByDept){
		modeRightInfo.updateRestModeShare(4);
	}
	if(1==resetModeShareBycreteorpost){
		modeRightInfo.updateRestModeShare(6);
	}
	
}else if(method.equals("addShare")){//前台设置权限
	String oldIds = Util.null2String(request.getParameter("oldIds"));
	String txtShareDetail[] = request.getParameterValues("txtShareDetail");
	int billid  = Util.getIntValue(request.getParameter("billid"),0);
	if(!oldIds.equals(""))
		rs.executeSql("delete from modeDataShare_"+modeId+" where id in ("+oldIds+")");
	if(txtShareDetail != null && txtShareDetail.length >0){
		for(int i=0;i<txtShareDetail.length;i++){
			String txtSD = txtShareDetail[i];
			ArrayList txtSDList = Util.TokenizerString(txtSD,"_");
			modeRightInfo.init();
			modeRightInfo.setModeId(modeId);
			modeRightInfo.setSourceid(billid);
			modeRightInfo.setSharetype(Util.getIntValue((String)txtSDList.get(0),0));
			modeRightInfo.setRelatedids(Util.null2String((String)txtSDList.get(1)));
			modeRightInfo.setRolelevel(Util.getIntValue((String)txtSDList.get(2),0));
			modeRightInfo.setShowlevel(Util.getIntValue((String)txtSDList.get(3),0));
			modeRightInfo.setRighttype(Util.getIntValue((String)txtSDList.get(4),0));
			modeRightInfo.insertAddRightView();
		}
	}
	response.sendRedirect("/formmode/view/ModeShare.jsp?ajax=2&modeId="+modeId+"&formId="+formId+"&billid="+billid+"&MaxShare="+MaxShare);
}
else if(method.equals("resetModeShare")){//权限重构
	String rebulidFlag = Util.null2String(request.getParameter("rebulidFlag"));
	ModeRightInfoThread modeRightInfoThread = new ModeRightInfoThread();
	modeRightInfoThread.setModeId(modeId);
	modeRightInfoThread.setRebulidFlag(rebulidFlag);
	modeRightInfoThread.setSession(session);
	modeRightInfoThread.resetModeRight();
	response.sendRedirect("/formmode/setup/ModeRightRebuildProcess.jsp?rebulidFlag="+rebulidFlag);
	return;
}else if(method.equals("reseDocShare")){//文档权限重构
	modeRightInfo.init();
	modeRightInfo.setModeId(modeId);
	modeRightInfo.resetDocRight();
}else if(method.equals("resetRightSingle")){//单条权限重构
	String resetRightId = Util.null2String(request.getParameter("resetRightId"));
	modeRightInfo.init();
	modeRightInfo.setModeId(modeId);
	modeRightInfo.resetRightSingle(resetRightId);
}

response.sendRedirect("ModeRightEdit.jsp?ajax=1&modeId="+modeId+"&formId="+formId+"&isVirtualForm="+Util.null2String(request.getParameter("isVirtualForm")));
%>