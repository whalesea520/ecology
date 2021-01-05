
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="DocTreeDocFieldManager" class="weaver.docs.category.DocTreeDocFieldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />


<%

String operation=Util.null2String(request.getParameter("operation"));

String treeDocFieldId=Util.null2String(request.getParameter("id"));
String treeDocFieldName = Util.fromScreen(request.getParameter("treeDocFieldName"),user.getLanguage());
String superiorFieldId=Util.null2String(request.getParameter("superiorFieldId"));
String showOrder=Util.null2String(request.getParameter("showOrder"));

String treeDocFieldDesc=Util.null2String(request.getParameter("treeDocFieldDesc"));
String mangerids=Util.null2String(request.getParameter("mangerids"));

String allSuperiorFieldId="";
String level="0";
String isLast="0";

String isDialog = Util.null2String(request.getParameter("isdialog"));
String isEntryDetail = Util.null2String(request.getParameter("isentrydetail"));

if(superiorFieldId.equals("")||superiorFieldId.equals(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID)){
	superiorFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
    allSuperiorFieldId=superiorFieldId;
	level="1";
}else{
    allSuperiorFieldId=DocTreeDocFieldComInfo.getAllSuperiorFieldId(superiorFieldId)+","+superiorFieldId;
	level=String.valueOf(Integer.parseInt(DocTreeDocFieldComInfo.getLevel(superiorFieldId))+1);
}

if(treeDocFieldName!=null){
	treeDocFieldName=treeDocFieldName.trim();
}


if(operation.equals("RootEditSave")){

	RecordSet.executeSql("update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"'  where id="+treeDocFieldId);
	log.insSysLogInfo(user,Util.getIntValue(treeDocFieldId),treeDocFieldName,"update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"'  where id="+treeDocFieldId,"270","2",0,request.getRemoteAddr());
    DocTreeDocFieldComInfo.updateDocTreeDocFieldInfoCache(treeDocFieldId);
    response.sendRedirect("DocTreeDocFieldRight.jsp?refresh=1");
	return;
 }
 else if(operation.equals("AddSave")){
    //将上级的是否末级改为否
	DocTreeDocFieldManager.updateDataOfNewSuperiorField(superiorFieldId);

    //插入数据
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  begin
	//RecordSet.executeSql("insert into  DocTreeDocField(treeDocFieldName,superiorFieldId,allSuperiorFieldId,level,isLast,showOrder) values('"+treeDocFieldName+"',"+superiorFieldId+",'"+allSuperiorFieldId+"',"+level+",'1',"+showOrder+")");
	RecordSet.executeSql("insert into  DocTreeDocField(treeDocFieldName,superiorFieldId,allSuperiorFieldId,fieldLevel,isLast,showOrder,treeDocFieldDesc,mangerids) values('"+treeDocFieldName+"',"+superiorFieldId+",'"+allSuperiorFieldId+"',"+level+",'1',"+showOrder+",'"+treeDocFieldDesc+"','"+mangerids+"')");
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  end

    //获得记录的id
	RecordSet.executeSql(" select max(id) from DocTreeDocField ");

	if(RecordSet.next()){
		treeDocFieldId=Util.null2String(RecordSet.getString(1));
	}

    //清除缓存中的内容
    DocTreeDocFieldComInfo.removeDocTreeDocFieldCache();
    log.insSysLogInfo(user,Util.getIntValue(treeDocFieldId),treeDocFieldName,"insert into  DocTreeDocField(treeDocFieldName,superiorFieldId,allSuperiorFieldId,fieldLevel,isLast,showOrder,treeDocFieldDesc,mangerids) values('"+treeDocFieldName+"',"+superiorFieldId+",'"+allSuperiorFieldId+"',"+level+",'1',"+showOrder+",'"+treeDocFieldDesc+"','"+mangerids+"')","270","1",0,request.getRemoteAddr());
    if(isDialog.equals("1")){
    	if(isEntryDetail.equals("1")){
    		response.sendRedirect("DocTreeDocFieldAdd.jsp?isclose=1&isentrydetail="+isEntryDetail+"&superiorFieldId="+treeDocFieldId);
    	}else if(isEntryDetail.equals("0")){
    		//查找上级的上级节点
    		RecordSet.executeSql(" select superiorFieldId from DocTreeDocField where id="+superiorFieldId);
    		if(RecordSet.next()){
    			superiorFieldId = Util.null2String(RecordSet.getString(1));
    		}
    		if(superiorFieldId.equals("0")){
    			superiorFieldId = "";
    		}
    		response.sendRedirect("DocTreeDocFieldAdd.jsp?isclose=1&superiorFieldId="+superiorFieldId);
    	}else{
    		 response.sendRedirect("DocTreeDocFieldAdd.jsp?isclose=1&superiorFieldId="+superiorFieldId);
    	}
    	return;
    }
    response.sendRedirect("DocTreeDocFieldEdit.jsp?refresh=1&id="+treeDocFieldId);
	return;
 }
 else if(operation.equals("EditSave")){

    String hisSuperiorFieldId=DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
    //在上级改变的情况下,更新原来的上级的值,所有下级的“级别”和“所有上级”字段的值
    if(!superiorFieldId.equals(hisSuperiorFieldId)){
		DocTreeDocFieldManager.updateDataOfNewSuperiorField(superiorFieldId);//将上级的是否末级改为否
		DocTreeDocFieldManager.updateDataOfHisSuperiorField(treeDocFieldId,hisSuperiorFieldId);
		DocTreeDocFieldManager.updateDataOfAllSubTreeDocField(treeDocFieldId,allSuperiorFieldId,level);
	}

    //更新记录的值
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  begin
	//RecordSet.executeSql("update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"',superiorFieldId="+superiorFieldId+",allSuperiorFieldId='"+allSuperiorFieldId+"',level="+level+",showOrder="+showOrder+" where id="+treeDocFieldId);
	RecordSet.executeSql("update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"',superiorFieldId="+superiorFieldId+",allSuperiorFieldId='"+allSuperiorFieldId+"',fieldLevel="+level+",showOrder="+showOrder+",treeDocFieldDesc='"+treeDocFieldDesc+"',mangerids='"+mangerids+"' where id="+treeDocFieldId);
    //update by fanggsh 20060919 for TD4529  level字段改为fieldLevel  end

    //清除缓存中的内容
    DocTreeDocFieldComInfo.removeDocTreeDocFieldCache();
    log.insSysLogInfo(user,Util.getIntValue(treeDocFieldId),treeDocFieldName,"update DocTreeDocField set treeDocFieldName='"+treeDocFieldName+"',superiorFieldId="+superiorFieldId+",allSuperiorFieldId='"+allSuperiorFieldId+"',fieldLevel="+level+",showOrder="+showOrder+",treeDocFieldDesc='"+treeDocFieldDesc+"',mangerids='"+mangerids+"' where id="+treeDocFieldId,"270","2",0,request.getRemoteAddr());
    if(isDialog.equals("1")){
    	String newSuperiorFieldId = "";
    	if(isEntryDetail.equals("1")){
    		response.sendRedirect("DocTreeDocFieldEdit.jsp?isclose=1&isdialog=1&isentrydetail="+isEntryDetail+"&id="+treeDocFieldId);
    	}else if(isEntryDetail.equals("0")){
    		//查找上级的上级节点
    		RecordSet.executeSql(" select superiorFieldId from DocTreeDocField where id="+superiorFieldId);
    		if(RecordSet.next()){
    			newSuperiorFieldId = superiorFieldId;//Util.null2String(RecordSet.getString(1));
    		}
    		if(newSuperiorFieldId.equals("0")){
    			newSuperiorFieldId = superiorFieldId;
    		}
    		response.sendRedirect("DocTreeDocFieldEdit.jsp?isclose=1&isdialog=1&id="+newSuperiorFieldId);
    	}else{	
    		 response.sendRedirect("DocTreeDocFieldEdit.jsp?isclose=1&isdialog=1&id="+superiorFieldId);
    	}
    	return;
    }
    response.sendRedirect("DocTreeDocFieldEdit.jsp?refresh=1&id="+treeDocFieldId);
	return;
 } else if(operation.equals("Delete")){
 	String[] ids = treeDocFieldId.split(",");
 	for(int i=0;i<ids.length;i++){
 		treeDocFieldId = ids[i];
	    String hisSuperiorFieldId=DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
		DocTreeDocFieldManager.updateDataOfHisSuperiorField(treeDocFieldId,hisSuperiorFieldId);
	
		RecordSet.executeSql("delete from DocTreeDocField where id="+treeDocFieldId);
		
	    superiorFieldId=DocTreeDocFieldComInfo.getSuperiorFieldId(""+treeDocFieldId);
	
	    //清除缓存中的内容
	    DocTreeDocFieldComInfo.removeDocTreeDocFieldCache();
	    log.insSysLogInfo(user,Util.getIntValue(treeDocFieldId),DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldId),"delete from DocTreeDocField where id="+treeDocFieldId,"270","3",0,request.getRemoteAddr());
	}
    response.sendRedirect("DocTreeDocFieldFrame.jsp?treeDocFieldId="+superiorFieldId);
	return;
 }
%>
