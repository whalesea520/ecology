
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.systeminfo.menuconfig.CustomLeftMenu" %>
<jsp:useBean id="rsMenu" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsSub" class="weaver.conn.RecordSet" scope="page"/>

<%	
	String method = Util.null2String(request.getParameter("method"));
	if(method.equals("clone")){
		int sInfoid = Util.getIntValue(request.getParameter("sInfoid"));
		int tParentid = Util.getIntValue(request.getParameter("tParentid"),0);
		String subCompanyId = request.getParameter("subCompanyId");

		
		int currentID = CustomLeftMenu.getLeftMenuCurrentId();
		
		int customMenuViewIndex =0;
		String customMenuLink = "";	
		String customMenuName ="";
		String resourceid ="";
		String resourcetype ="";
		int labelid=0;
		String usecustomname="";
		String infoUseCustomName="";
		String infoCustomName="";

		if("0".equals(subCompanyId)){
			resourceid="1";
			resourcetype="1";
		} else {
			resourceid=subCompanyId;
			resourcetype="2";
		}
		

		String sql1="select labelid,useCustomName,customName,linkaddress  from leftmenuinfo where id="+sInfoid;
		rsMenu.executeSql(sql1);
		if(rsMenu.next()) {
			labelid=Util.getIntValue(rsMenu.getString("labelid"),0);
			infoUseCustomName=Util.null2String(rsMenu.getString("useCustomName"));
			infoCustomName=Util.null2String(rsMenu.getString("customName"));
			customMenuLink=Util.null2String(rsMenu.getString("linkaddress"));
		} else {
			return;
		}


		String sql2="select customname,usecustomname from leftmenuconfig where infoid="+sInfoid+" and resourceid="+resourceid+" and resourcetype="+resourcetype;
		rsMenu.executeSql(sql2);
		if(rsMenu.next()) {
			customMenuName=Util.null2String(rsMenu.getString("customname"));
			usecustomname=Util.null2String(rsMenu.getString("usecustomname"));			
		}
			
		String sql3="INSERT INTO LeftMenuInfo											  (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,useCustomName,customName,relatedModuleId,isCustom) "+
		" values "+	"("+currentID+","+labelid+",'/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif','"+customMenuLink+"',2,"+tParentid+","+customMenuViewIndex+",'"+infoUseCustomName+"','"+infoCustomName+"',12,'1')";
		rsMenu.executeSql(sql3);

		String sql4 = " INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) " +
			  " VALUES (0,"+currentID+",'1',0"+","+resourceid+",'"+resourcetype+"','0',0,'"+usecustomname+"','"+customMenuName+"')";
		rsMenu.executeSql(sql4);
		
		//分部添加菜单
		if("1".equals(resourcetype)) {
			rsSub.executeSql("select id from hrmsubcompany where companyid="+resourceid);
			while (rsSub.next()){
				int subid=Util.getIntValue(rsSub.getString("id"),0);
				String sql5=" INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) " +
			  " VALUES (0,"+currentID+",'1',0"+","+subid+",'2','0',0,'"+usecustomname+"','"+customMenuName+"')";
				rsMenu.executeSql(sql5);

			}
		}

		out.println("window.location.reload();");

	} else if(method.equals("move")){		
		int sInfoid = Util.getIntValue(request.getParameter("sInfoid"));
		int tInfoid = Util.getIntValue(request.getParameter("tInfoid"));
		String subCompanyId = request.getParameter("subCompanyId");
		
		String parentId="";
		String viewIndex="";
		
		//get parentid
		String sql1="select parentid from leftmenuinfo where id="+tInfoid;
		rsMenu.executeSql(sql1);
		if(rsMenu.next()){
			 parentId=Util.null2String(rsMenu.getString("parentid"));
		} else {
			 return;
		}
		
		//out.println(sql1+"<br>");		

		//get viewindex
		String sql2="";
		if("0".equals(subCompanyId))
			sql2="select viewindex from leftmenuconfig where infoid="+tInfoid+"  and resourcetype=1";
   		else 
			sql2="select viewindex from leftmenuconfig where infoid="+tInfoid+" and resourceid="+subCompanyId+" and resourcetype=2";
		rsMenu.executeSql(sql2);
		if(rsMenu.next()) viewIndex=Util.null2String(rsMenu.getString("viewindex"));

		//out.println(sql2+"<br>");	

		//update other's viewindex
		String sql4="";
		String strParentId="";
		if("".equals(parentId)) strParentId=" parentid=0 or parentid is null ";
		else strParentId=" parentId="+parentId+"";
		if("0".equals(subCompanyId))			 
		    sql4="update leftmenuconfig set viewindex=viewindex+1 where infoid!="+sInfoid+" and  resourcetype=1 and viewindex>="+viewIndex+" and infoid in( select id from leftmenuinfo where "+strParentId+")";
		else 
			sql4="update leftmenuconfig set viewindex=viewindex+1 where infoid!="+sInfoid+" and resourceid="+subCompanyId+" and resourcetype=2 and viewindex>="+viewIndex+" and infoid in( select id from leftmenuinfo where " +strParentId+ ")";

		//out.println(sql4+"<br>");	
		rsMenu.executeSql(sql4);


		//update src's viewindex
		String sql5="";
		if("0".equals(subCompanyId))
			sql5="update leftmenuconfig set viewindex="+viewIndex+"  where infoid="+sInfoid+" and  resourcetype=1";
		else 
			sql5="update leftmenuconfig set viewindex="+viewIndex+"  where infoid="+sInfoid+" and resourceid="+subCompanyId+" and resourcetype=2";
		rsMenu.executeSql(sql5);
	}
	%>