
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SelectItemManager" class="weaver.workflow.selectItem.SelectItemManager" scope="page" />
<%
String method = request.getParameter("method");

if (method.equals("delete"))
{ 
    String id = request.getParameter("id");
	SelectItemManager.deleteSelectItem(id,user,request.getRemoteAddr());
}
else if (method.equals("deles"))
{
	String ids = Util.null2String(request.getParameter("ids"));
	SelectItemManager.deleteSelectItem(ids,user,request.getRemoteAddr());
}else if(method.equals("valRepeat")){   //验证名称是否重复
	
}else if(method.equals("saveorupdate")){
	int rowno = Util.getIntValue(request.getParameter("rowno"),0);//行号
	String _id = Util.null2String(request.getParameter("id"));
	String pid = Util.null2String(request.getParameter("pid"));
	String statelev = Util.null2String(request.getParameter("statelev"));
	String noGoChildren = Util.null2String(request.getParameter("noGoChildren"));
	String id = SelectItemManager.saveOrUpdate(request,user);
	
	String sendurl = "";
	if(Util.getIntValue(_id)<1){
		sendurl = "/workflow/selectItem/selectItemEdit.jsp?id="+id+"&pid="+pid+"&statelev="+statelev+"&src=edit&isclose=1";
	}else{
		sendurl = "/workflow/selectItem/selectItemEdit.jsp?id="+id+"&pid="+pid+"&statelev="+statelev+"&src=edit&isclose=1";
	}
	
	String sql = "select id,pid,statelev from mode_selectitempagedetail where mainid = "+id+" and id= "+pid;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		sendurl = "/workflow/selectItem/selectItemEdit.jsp?id="+id+"&pid="+RecordSet.getString("pid")+"&statelev="+RecordSet.getString("statelev")+"&src=edit&isclose=0";
	}
	
	if(noGoChildren.equals("1")){
	    int jump_pid = SelectItemManager.getJump_pid();
	    if(jump_pid>0){
	    	pid=jump_pid+"";
	    	statelev = ""+(Util.getIntValue(statelev)+1);
	    }
	    
	    //System.out.println("-----"+id+"   jump_pid："+jump_pid+"  pid:"+pid+"  statelev:"+statelev);
		sendurl = "/workflow/selectItem/selectItemEdit.jsp?id="+id+"&pid="+pid+"&statelev="+statelev+"&src=edit&isclose=0";
	}
	//response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshSelectItem("+id+","+pid+","+statelev+");</script>");
	
	//System.out.println(sendurl);
	response.sendRedirect(sendurl);
}else if(method.equals("saveselectitem")){

	int rowsum = Util.getIntValue(Util.null2String(request.getParameter("choiceRows_rows")));
	int fieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid")));
	int childfieldid_tmp = Util.getIntValue(request.getParameter("childfieldid"), 0);
	//System.out.println("--------------"+rowsum+"======"+fieldid);
	
	RecordSet.executeSql("update workflow_billfield set childfieldid="+childfieldid_tmp+" where id="+fieldid);
	
	String ids = "";
	for(int temprow=1;temprow<=rowsum;temprow++){
		String id_temp = Util.null2String(request.getParameter("id_"+temprow));
		if(!"".equals(id_temp))
			ids += "," + id_temp;
	}
	String delsql = "delete from workflow_SelectItem where isbill=1 and fieldid="+fieldid;
	if(!"".equals(ids)){
		ids = ids.substring(1);
		delsql += " and id not in ("+ids+")";
	}
	RecordSet.executeSql(delsql);
	
	int curvalue = -1;
	RecordSet.execute("select max(selectvalue) from workflow_SelectItem where isbill = 1 and fieldid="+fieldid);
	if(RecordSet.next())
		curvalue = Util.getIntValue(Util.null2String(RecordSet.getString(1)),-1);
	
	
	for(int temprow=1;temprow<=rowsum;temprow++){
		String id_temp = Util.null2String(request.getParameter("id_"+temprow));
	 	String curname = Util.null2String(request.getParameter("field_name_"+temprow));
	 	if(curname.equals("")) continue;
	 	String curorder = Util.null2String(request.getParameter("field_count_name_"+temprow))+".00";
	 	String isdefault = "n";
	 	String checkValue = Util.null2String(request.getParameter("field_checked_name_"+temprow));
		String childItem = Util.null2String(request.getParameter("childItem"+temprow));
	 	if(checkValue.equals("1")) isdefault="y";
	 	int isAccordToSubCom_tmp = Util.getIntValue(request.getParameter("isAccordToSubCom"+temprow), 0);
		String doccatalog = Util.null2String(request.getParameter("maincategory_"+temprow));
		String docPath = Util.null2String(request.getParameter("pathcategory_"+temprow));
		String cancel = ""+Util.getIntValue(request.getParameter("cancel_"+temprow+"_name"),0);
		char flag=2;
		
		if(childfieldid_tmp==0){
			childItem = "";
		}
		
		if("".equals(id_temp)){
			curvalue++;
			String para=fieldid+""+flag+"1"+flag+""+curvalue+flag+curname+flag+curorder+flag+isdefault+flag+cancel;
			boolean f = RecordSet.executeProc("workflow_selectitem_insert_new",para);//更新表workflow_SelectItem
			RecordSet.executeSql("update workflow_SelectItem set docpath='"+docPath+"', docCategory='"+doccatalog+"', childitemid='"+childItem+"',isAccordToSubCom='"+isAccordToSubCom_tmp+"',cancel='"+cancel+"' where fieldid="+fieldid+" and selectvalue="+curvalue);
		}else{
			String updatesql = "update workflow_selectitem set selectname = '"+curname+"'," +
			"listorder="+curorder+"," +
			"isdefault='"+isdefault+"',"+
			"cancel='"+cancel+"',"+
			"docpath='"+docPath+"',"+
			"docCategory='"+doccatalog+"',"+
			"childitemid='"+childItem+"',"+
			"isAccordToSubCom='"+isAccordToSubCom_tmp+"'"+
			" where  fieldid = " + fieldid + "  and id = " + id_temp;
			RecordSet.execute(updatesql);
		}
	}
	response.sendRedirect("/workflow/selectItem/selectItemEdit0.jsp?fieldid="+fieldid+"&isclose=1");
}

//response.sendRedirect("/workflow/selectItem/selectItemSettings.jsp");
%>