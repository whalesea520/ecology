<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="FieldManager" class="weaver.worktask.field.FieldManager" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetPortal" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
	int textheight=Util.getIntValue(request.getParameter("textheight"),4);//xwj for @td2977 20051107
	String src = Util.null2String(request.getParameter("src"));
	int wttype = Util.getIntValue(request.getParameter("wttype"), 1);
	int htmltype=Util.getIntValue(request.getParameter("htmltype"),0);
	int htmledit=Util.getIntValue(request.getParameter("htmledit"),0);
	int strlength=Util.getIntValue(request.getParameter("strlength"),0);
	int wtid = Util.getIntValue(request.getParameter("wtid"),0);
	String cusb = Util.null2String(request.getParameter("cusb"));
	String fieldhtmltype=Util.fromScreen(request.getParameter("fieldhtmltype"),user.getLanguage());
	String description = Util.null2String(request.getParameter("description"));//xwj for td2977 20051107
	String fielddbtype="";
	int showprep=Util.getIntValue(request.getParameter("showprep"),1);  

	String displayname = Util.null2String(request.getParameter("displayname"));//显示名
	String linkaddress = Util.null2String(request.getParameter("linkaddress"));//链接地址
	String descriptivetext = Util.null2String(request.getParameter("descriptivetext"));//描述性文字
	descriptivetext = Util.spacetoHtml(descriptivetext);

	String fieldname = Util.null2String(request.getParameter("fieldname"));
  boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
  boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
  if(fieldhtmltype.equals("1")){
	  if(htmltype==1)	{
		  if(isoracle) fielddbtype="varchar2("+strlength+")";
		  else fielddbtype="varchar("+strlength+")";
	  }
	  if(htmltype==2)	{
		  if(isoracle) fielddbtype="integer";
		  else fielddbtype="int";
	  }
	  if(htmltype==3)	{
		  if(isoracle) fielddbtype="number(15,2)";
		  else fielddbtype="decimal(15,2)";
	  }
	if(htmltype==4)	{//added by xwj for td3131 20051115
		 if(isoracle) fielddbtype="number(15,2)";
		 else fielddbtype="decimal(15,2)";
	}
  }
  if(fieldhtmltype.equals("3")){
  	if(htmltype>0)
  		fielddbtype=BrowserComInfo.getBrowserdbtype(htmltype+"");
  	if(htmltype==118){
  		if(isoracle) fielddbtype="varchar2(200)";
          else fielddbtype="varchar(200)";
  	}
	if(htmltype==161||htmltype==162)
		fielddbtype=cusb;
	if(htmltype==165||htmltype==166||htmltype==167||htmltype==168) textheight=showprep;   
  }
  if(fieldhtmltype.equals("2"))	{
	  if(isoracle) fielddbtype="varchar2(4000)";
	   else if(isdb2) fielddbtype="varchar(2000)";
	  else fielddbtype="text";
	  if (htmledit!=0) htmltype=htmledit;
  }
  if(fieldhtmltype.equals("4")){
	  if(isoracle) fielddbtype="integer";
	  else fielddbtype="int";
  }
  if(fieldhtmltype.equals("5"))	{
	  if(isoracle) fielddbtype="integer";
	  else fielddbtype="int";
  }
  if(fieldhtmltype.equals("6"))	{
	  if(isoracle) fielddbtype="varchar2(4000)";
	  else if(isdb2) fielddbtype="varchar(2000)";
	  else fielddbtype="text";
  }
  if(fieldhtmltype.equals("7"))	{
	  if(isoracle) fielddbtype="varchar2(4000)";
	  else if(isdb2) fielddbtype="varchar(2000)";
	  else fielddbtype="text";
  }

String fieldViewName = description;
if("".equals(fieldViewName.trim())){
	fieldViewName = fieldname;
}
int fieldLabelId = 0;
String sql = "";
if(wttype == 1){
	sql = "select id from HtmlLabelIndex where indexdesc='"+fieldViewName+"'";
	RecordSet.execute(sql);
	if(RecordSet.next()){
		fieldLabelId = Util.getIntValue(RecordSet.getString("id"),0);
	}else{
		sql="select min(id) id from HtmlLabelIndex";
		RecordSet.execute(sql);
		if(RecordSet.next()){
			fieldLabelId = Util.getIntValue(RecordSet.getString("id"),0);
		}
		if(fieldLabelId>0){
			fieldLabelId = -1;
		}
		fieldLabelId-=1;		    	
		sql="INSERT INTO HtmlLabelIndex values("+fieldLabelId+",'"+fieldViewName+"')"; 
		RecordSet.execute(sql);
		sql="INSERT INTO HtmlLabelInfo VALUES("+fieldLabelId+",'"+fieldViewName+"',7)";
		RecordSet.execute(sql);		
		LabelComInfo.addLabeInfoCache(String.valueOf(fieldLabelId));
	}
}
////得到标记信息
if(src.equalsIgnoreCase("addfield")){
	FieldManager.reset();
	FieldManager.setAction("addfield");
	FieldManager.setFieldname(fieldname);
	FieldManager.setFielddbtype(fielddbtype);
	FieldManager.setFieldhtmltype(fieldhtmltype);
	FieldManager.setType(htmltype);
	FieldManager.setDescription(description);
	FieldManager.setTextheight(textheight);
	FieldManager.setWttype(wttype);
	FieldManager.setIssystem(0);
	//String sql1 = "insert into worktask_fielddict (fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('important', '重要性', 'int', 5, 0, 0, 1, 0)";
	//RecordSet.execute("insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('important', '重要性', 'int', 5, 0, 0, 1, 0)");
	String message = "";
	message = FieldManager.setFieldInfo();
	if(message.equals("1")){
		response.sendRedirect("fieldAdd.jsp?wttype="+wttype+"&message=1");
		return;
	}
	String sql2 = "insert into worktask_taskfield (taskid, fieldid, crmname, isshow, isedit, ismand, orderid) select "+wtid+", max(id), '', 0, 0, 0, 0 from worktask_fielddict";
	RecordSet.execute(sql2);
	if(wttype == 1){
		sql2 = "INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,fromUser) select 207, '"+fieldname+"',"+fieldLabelId+",'"+fielddbtype+"',"+fieldhtmltype+","+htmltype+", max(dsporder)+1, 0,'0' from workflow_billfield where billid=207";
		RecordSet.execute(sql2);
	}
	//操作workflow_selectitem表
	if(fieldhtmltype.equals("5")){
		int fieldId = 0;
		RecordSet.execute("select id from workflow_billfield where billid=207 and fieldname='"+fieldname+"'");
		if(RecordSet.next()){
			fieldId = Util.getIntValue(RecordSet.getString("id"));
		}
		int i=0;
		int curvalue=0;
		int rowsum = Util.getIntValue(Util.null2String(request.getParameter("selectsnum")));
		//System.out.println("rowsum ="+rowsum);
		sql = "select max(id) from worktask_fielddict";
		RecordSet.executeSql(sql);
		RecordSet.next();
		String curfieldid=RecordSet.getString(1);
		for(i=0;i<rowsum;i++){
			int curorder = Util.getIntValue(request.getParameter("field_count_"+i+"_name"), curvalue);
			String curname=Util.fromScreen(request.getParameter("field_"+i+"_name"),user.getLanguage());
			char flag=2;
			if(!curname.equals("")){
				sql = "insert into worktask_selectItem (fieldid, selectvalue, selectname, orderid) values ("+curfieldid+", "+curvalue+", '"+curname+"', "+curorder+")";
				RecordSet.execute(sql);
				if(wttype == 1){
					String para=""+fieldId+flag+"1"+flag+""+curvalue+flag+curname+flag+0+flag+"n";//xwj for td3399 20060303
					RecordSet.executeProc("workflow_SelectItem_Insert",para);
				}
				curvalue++;
			}
		}
	}
	//response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
	return;
  }else if(src.equalsIgnoreCase("editfield")){
		int fieldid=Util.getIntValue(Util.null2String(request.getParameter("fieldid")),0);
		RecordSet.executeSql("select fieldname from worktask_fielddict where id = " + fieldid);
		String oldFieldName = "";
		if(RecordSet.next()){
			oldFieldName = RecordSet.getString("fieldname");
		}
		String isused=Util.null2String(request.getParameter("isused"));
		FieldManager.reset();
		FieldManager.setAction("editfield");
		FieldManager.setFieldid(fieldid);
		FieldManager.setLanguageid(user.getLanguage());
		FieldManager.setFieldname(Util.null2String(request.getParameter("fieldname")));
		FieldManager.setFielddbtype(fielddbtype);
		FieldManager.setFieldhtmltype(fieldhtmltype);
		FieldManager.setType(htmltype);
		FieldManager.setDescription(description);
		FieldManager.setTextheight(textheight);
		FieldManager.setWttype(wttype);
		FieldManager.setIssystem(0);
		String message ="";
		message = FieldManager.setFieldInfo();

	  //System.out.println("message = " + message);
		if(message.equals("1")){
			response.sendRedirect("fieldAdd.jsp?wttype="+wttype+"&src=editfield&fieldid="+fieldid+"&message="+message+"&isused="+isused);
		}else if(message.equals("2")){
			response.sendRedirect("fieldAdd.jsp?wttype="+wttype+"&src=editfield&fieldid="+fieldid+"&message="+message+"&isused="+isused);
		}

	//操作workflow_selectitem表
	if(fieldhtmltype.equals("5")){
		int wffieldid = 0;
		if(wttype == 1){
			RecordSet.execute("select id from workflow_billfield where billid=207 and fieldname='"+fieldname+"'");
			if(RecordSet.next()){
				wffieldid = Util.getIntValue(RecordSet.getString("id"));
			}
			sql = "delete from workflow_SelectItem where fieldid="+wffieldid;
			RecordSet.execute(sql);
		}
		sql = "delete from worktask_selectitem where fieldid="+fieldid;
		RecordSet.execute(sql);
		char flag=2;
		String para="";

		int rowsum = Util.getIntValue(Util.null2String(request.getParameter("selectsnum")));
		int i=0;
		int curvalue=0;
		String curname="";
		int curorder = 0;

		for(i=0;i<rowsum;i++){
			curname = Util.fromScreen(request.getParameter("field_"+i+"_name"),user.getLanguage());
			curorder = Util.getIntValue(request.getParameter("field_count_"+i+"_name"), curvalue);
			if(!curname.equals("")){
				sql = "insert into worktask_selectItem (fieldid, selectvalue, selectname, orderid) values ("+fieldid+", "+curvalue+", '"+curname+"', "+curorder+")";
				//System.out.println(sql);
				RecordSet.execute(sql);
				if(wttype == 1){
					para=""+wffieldid+flag+"1"+flag+""+curvalue+flag+curname+flag+0+flag+"n";//xwj for td3399 20060303
					RecordSet.executeProc("workflow_SelectItem_Insert",para);
				}
				curvalue++;
			}
		}
	}
	//response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
	out.println("<script>parent.getParentWindow(window).MainCallback();</script>");
	return;
  }
  response.sendRedirect("worktaskFieldEdit.jsp?wtid="+wtid);
%>