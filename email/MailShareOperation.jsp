
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page" />

<%
String mailgroupname= Util.null2String(request.getParameter("mailgroupname"));
//int canapprove=Util.getIntValue(request.getParameter("canapprove"),0); 
//int doccreaterid=Util.getIntValue(request.getParameter("doccreaterid"),0);
String subcompanyid1="";
	   RecordSet.executeSql("select subcompanyid1 from HrmResource where id="+user.getUID()+"");
	   if(RecordSet.next())
	   {
	    subcompanyid1=RecordSet.getString("subcompanyid1");
	   }

char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String mailgroupid = Util.null2String(request.getParameter("mailgroupid")); 
String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;
int sharecrm=0;

if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;

if(Util.getIntValue(sharetype,0)<0)	{
	sharecrm=Util.getIntValue(sharetype,0);
	sharecrm=-(sharecrm);
	sharetype="6";
}

if(method.equals("delete"))
{
mailgroupname=Util.toScreen(request.getParameter("mailgroupname"),user.getLanguage(),"0");

	RecordSet.executeProc("MailShare_Delete",""+id);
	/***************/
	/*获取子目录下共享*/ 
	ArrayList viewerids=new ArrayList();
RecordSet.executeProc("MailUserShare_DeletebyMailgroupId",""+mailgroupid);

String Sql3="select sharetype,userid,departmentid,seclevel,roleid,rolelevel,subcompanyid from mailshare where mailgroupid="+mailgroupid;//此文档对应文档共享记录
RecordSet.executeSql(Sql3);//此文档对应子目录的共享记录
while(RecordSet.next())
	{
     if(RecordSet.getString("sharetype").equals("1"))
	     {
              String tempid=RecordSet.getString("userid");
			 if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
		  }
    
    // if(RecordSet.getString("sharetype").equals("2"))//分部
    if(RecordSet.getString("sharetype").equals("2"))
		{String Sql4="select id from hrmresource where departmentid="+RecordSet.getString("subcompanyid")+ " and seclevel>="+RecordSet.getString("seclevel");
         Record.executeSql(Sql4);
		while(Record.next()){
			  String tempid=Record.getString("id");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
		}

    if(RecordSet.getString("sharetype").equals("3"))//部门
	    {String Sql4="select id from hrmresource where departmentid="+RecordSet.getString("departmentid")+ " and seclevel>="+RecordSet.getString("seclevel");
	    Record.executeSql(Sql4);
		while(Record.next()){
			  String tempid=Record.getString("id");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
		}

    if(RecordSet.getString("sharetype").equals("4") &&RecordSet.getString("rolelevel").equals("0"))//对角色,部门级
		{
	     String Sql4="select t1.resourceid from hrmrolemembers as t1,hrmresource as t2 where t1.roleid="+RecordSet.getString("roleid")+ 
        " and t1.resourceid=t2.id and t2.seclevel>="+RecordSet.getString("seclevel")+
		" and (t1.rolelevel='2' or (t2.subcompanyid1="+subcompanyid1+
	    " and t1.rolelevel='1') or (t2.departmentid="+departmentid+ " and t1.rolelevel='0'))";
        Record.executeSql(Sql4);
		
		 while(Record.next()){
			  String tempid=Record.getString("resourceid");
			 if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
         }
		}

     if(RecordSet.getString("sharetype").equals("4") && RecordSet.getString("rolelevel").equals("1"))//对角色,分部级
		{ 
			String Sql4="select resourceid from hrmrolemembers as t1,hrmresource as t2 where t1.roleid="+RecordSet.getString("roleid")+ 
		" and t1.resourceid=t2.id and t2.seclevel>="+RecordSet.getString("seclevel")+
		" and (t1.rolelevel=2 or (t2.subcompanyid1="+subcompanyid1+" and t1.rolelevel=1))";
			Record.executeSql(Sql4);
         while(Record.next()){
			  String tempid=Record.getString("resourceid");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
		}

      if(RecordSet.getString("sharetype").equals("4") && RecordSet.getString("rolelevel").equals("2"))//对角色,总部级
		{ 
			String Sql4="select resourceid from hrmrolemembers as t1,hrmresource as t2 where t1.roleid="+RecordSet.getString("roleid")+ 
	   " and t1.resourceid=t2.id and t2.seclevel>="+RecordSet.getString("seclevel");
        Record.executeSql(Sql4);
           while(Record.next()){
			  String tempid=Record.getString("resourceid");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
         }

	   if(RecordSet.getString("sharetype").equals("5")||RecordSet.getString("sharetype").equals("6"))//对所有人或外部用户
	   { Record.executeSql("select id from hrmresource where seclevel>="+RecordSet.getString("seclevel"));
		while(Record.next()){String tempid=Record.getString("id");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
	   }
	}


	/*写temp表或直接写入DocUserView*/
	String userids="";
			for(int m=0;m<viewerids.size();m++){
			userids=(String)viewerids.get(m);
	RecordSet.executeSql("insert into MailUserShare (mailgroupid,userid) values ("+""+mailgroupid+","+userids+")");
			 }
	
response.sendRedirect("MailShare.jsp?mailgroupid="+mailgroupid+"&mailgroupname="+mailgroupname);
	return;
}


if(method.equals("add"))
{
	ProcPara = mailgroupid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+subcompanyid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
	ProcPara += flag+""+sharecrm;
	RecordSet.executeProc("MailShare_Insert",ProcPara);
	/************/

	/*获取子目录下共享*/ 
	ArrayList viewerids=new ArrayList();
RecordSet.executeProc("MailUserShare_DeletebyMailgroupId",""+mailgroupid);

String Sql3="select sharetype,userid,departmentid,seclevel,roleid,rolelevel,subcompanyid from mailshare where mailgroupid="+mailgroupid;//此文档对应文档共享记录
RecordSet.executeSql(Sql3);//此文档对应子目录的共享记录
while(RecordSet.next())
	{
     if(RecordSet.getString("sharetype").equals("1"))
	     {
              String tempid=RecordSet.getString("userid");
			 if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
		  }
    
    // if(RecordSet.getString("sharetype").equals("2"))//分部
    if(RecordSet.getString("sharetype").equals("2"))
		{String Sql4="select id from hrmresource where departmentid="+RecordSet.getString("subcompanyid")+ " and seclevel>="+RecordSet.getString("seclevel");
         Record.executeSql(Sql4);
		while(Record.next()){
			  String tempid=Record.getString("id");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
		}

    if(RecordSet.getString("sharetype").equals("3"))//部门
	    {String Sql4="select id from hrmresource where departmentid="+RecordSet.getString("departmentid")+ " and seclevel>="+RecordSet.getString("seclevel");
	    Record.executeSql(Sql4);
		while(Record.next()){
			  String tempid=Record.getString("id");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
		}

    if(RecordSet.getString("sharetype").equals("4") &&RecordSet.getString("rolelevel").equals("0"))//对角色,部门级
		{
	     String Sql4="select t1.resourceid from hrmrolemembers as t1,hrmresource as t2 where t1.roleid="+RecordSet.getString("roleid")+ 
        " and t1.resourceid=t2.id and t2.seclevel>="+RecordSet.getString("seclevel")+
		" and (t1.rolelevel='2' or (t2.subcompanyid1="+subcompanyid1+
	    " and t1.rolelevel='1') or (t2.departmentid="+departmentid+ " and t1.rolelevel='0'))";
        Record.executeSql(Sql4);
		
		 while(Record.next()){
			  String tempid=Record.getString("resourceid");
			 if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
         }
		}

     if(RecordSet.getString("sharetype").equals("4") && RecordSet.getString("rolelevel").equals("1"))//对角色,分部级
		{ 
			String Sql4="select resourceid from hrmrolemembers as t1,hrmresource as t2 where t1.roleid="+RecordSet.getString("roleid")+ 
		" and t1.resourceid=t2.id and t2.seclevel>="+RecordSet.getString("seclevel")+
		" and (t1.rolelevel=2 or (t2.subcompanyid1="+subcompanyid1+" and t1.rolelevel=1))";
			Record.executeSql(Sql4);
         while(Record.next()){
			  String tempid=Record.getString("resourceid");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
		}

      if(RecordSet.getString("sharetype").equals("4") && RecordSet.getString("rolelevel").equals("2"))//对角色,总部级
		{ 
			String Sql4="select resourceid from hrmrolemembers as t1,hrmresource as t2 where t1.roleid="+RecordSet.getString("roleid")+ 
	   " and t1.resourceid=t2.id and t2.seclevel>="+RecordSet.getString("seclevel");
        Record.executeSql(Sql4);
           while(Record.next()){
			  String tempid=Record.getString("resourceid");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
         }

   if(RecordSet.getString("sharetype").equals("5")||RecordSet.getString("sharetype").equals("6"))//对所有人或外部用户
	{ Record.executeSql("select id from hrmresource where seclevel>="+RecordSet.getString("seclevel"));
		while(Record.next()){
                 String tempid=Record.getString("id");
			  if(viewerids.indexOf(tempid)==-1)
				viewerids.add(tempid);
                             }
	   }
	}


	/*写temp表或直接写入DocUserView*/
	String userids="";
			for(int m=0;m<viewerids.size();m++){
			userids=(String)viewerids.get(m);
	RecordSet.executeSql("insert into MailUserShare (mailgroupid,userid) values ("+""+mailgroupid+","+userids+")");
			 }

	response.sendRedirect("mailshare.jsp?mailgroupid="+mailgroupid+"&mailgroupname="+mailgroupname);
	return;
}
%>
