
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,java.util.*" %>
<%@ page import="weaver.systeminfo.role.StructureRightHandler,weaver.systeminfo.role.StructureRightInfo"%>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%

if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
int structureCount=Util.getIntValue(request.getParameter("structureCount"),0);
String roleid=Util.null2String(request.getParameter("roleid"));
String roleLevel = request.getParameter("roleLevel");
boolean isoracle = (rs.getDBType()).equals("oracle") ;
char flag=Util.getSeparator();
String para="";

//删除老数据
para=roleid;
rs.execute("HrmRoleStrRight_Del",para);
StructureRightInfo mSri=null;
StructureRightHandler mSriHander=new StructureRightHandler();
mSriHander.StructureRightInfoDo(Util.getIntValue(roleid,0),user.getUID());
for(int i=0; i<structureCount; i++){
	mSri=mSriHander.get(i);
    int ischecked=Util.getIntValue(request.getParameter("chk1_"+mSri.getParent_list()+"_"),0);
	int _ischecked=Util.getIntValue(request.getParameter("chk_"+i),0);
    if(ischecked == 1 || _ischecked == 1){
        String subid=Util.null2String(request.getParameter("subid_"+i));
		String subcompname = SubCompanyComInfo.getSubCompanyname(subid);
        String sellevel=Util.null2String(request.getParameter("sel_"+i));
		String LevelName ="";
		if(sellevel.equals("2")){
			LevelName = SystemEnv.getHtmlLabelName(17874,user.getLanguage());
		}else if (sellevel.equals("-1")){
			LevelName = SystemEnv.getHtmlLabelName(17875,user.getLanguage());
		}else if(sellevel.equals("0")){
			LevelName = SystemEnv.getHtmlLabelName(17873,user.getLanguage());
		}else if (sellevel.equals("1")){
			LevelName = SystemEnv.getHtmlLabelName(93,user.getLanguage());
		}
        para=roleid+flag+subid+flag+sellevel;
        rs.execute("HrmRoleStrRight_ins",para);

		SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(roleid));
        SysMaintenanceLog.setRelatedName(subcompname+":"+LevelName);
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("HrmRoleStrRight_ins,"+para);
        SysMaintenanceLog.setOperateItem("103");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();

        //CheckUserRight.updateRoleRightdetail(roleid , roleid , roleLevel) ;
        //CheckUserRight.removeRoleRightdetailCache();
    }
}
CheckUserRight.removeRoleRightdetailCache();
response.sendRedirect("/hrm/roles/HrmRolesStrRightSet.jsp?isdialog=1&id="+roleid);

%>
