
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />

<%
char flag = 2 ;
String ProcPara = "";
String strTemp = "";
String method = request.getParameter("method");
    //System.out.println("method = " + method);
String taskrecordid = request.getParameter("taskrecordid");
String ProjID=Util.null2String(request.getParameter("ProjID"));
String parentid=Util.null2String(request.getParameter("parentid"));
String parentids=Util.null2String(request.getParameter("parentids"));
String parenthrmids=Util.null2String(request.getParameter("parenthrmids"));
String hrmid=Util.null2String(request.getParameter("hrmid"));
String oldhrmid=Util.null2String(request.getParameter("oldhrmid"));
String finish=Util.null2String(request.getParameter("finish"));
String level=Util.null2String(request.getParameter("level"));
String subject=Util.null2String(request.getParameter("subject"));
String begindate=Util.null2String(request.getParameter("begindate"));
String enddate=Util.null2String(request.getParameter("enddate"));
String workday=Util.null2String(request.getParameter("workday"));
String fixedcost=Util.null2String(request.getParameter("fixedcost"));
String islandmark=Util.null2String(request.getParameter("islandmark"));
String realManDays=Util.null2String(request.getParameter("realManDays"));
String pretask=Util.null2String(request.getParameter("taskids02"));
String content=Util.null2String(request.getParameter("content"));

if(begindate.equals("")) begindate = "" ;
if(enddate.equals("")) enddate = "" ;
if(workday.equals("")) workday = "0" ;
if(Util.getDoubleValue(workday)<=0) workday = "0" ;
if(finish.equals("")) finish = "0" ;
if(pretask.equals(""))pretask="0";
if(islandmark.equals("")) islandmark="0";
if(realManDays.equals(""))realManDays="0";
if(fixedcost.equals(""))fixedcost="0";

String taskid = "0" ;
String wbscoding = "0" ;
String version = "0" ;


ArrayList arrayParentids = Util.TokenizerString(parentids,",");

String CurrentUser = ""+user.getUID();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String TaskID="";

if (method.equals("add"))
{
	ProcPara = ProjID ;
	ProcPara += flag + "" + taskid ;
	ProcPara += flag + "" + wbscoding ;
	ProcPara += flag + "" + subject ;
	ProcPara += flag + "" + version ;
	ProcPara += flag + "" + begindate ;
	ProcPara += flag + "" + enddate ;
	ProcPara += flag + "" + workday ;
	ProcPara += flag + "" + content ;
	ProcPara += flag + "" + fixedcost ;
	ProcPara += flag + "" + parentid ;
	ProcPara += flag + "" + parentids ;
	ProcPara += flag + "" + parenthrmids ;
	ProcPara += flag + "" + level ;
	ProcPara += flag + "" + hrmid ;
    ProcPara += flag + "" + pretask ;
	ProcPara += flag + "" + "0" ; // real work days

    RecordSet.executeProc("Prj_TaskProcess_Insert",ProcPara);

    RecordSet.executeProc("Prj_TaskProcess_SMAXID","");
    while(RecordSet.next()){
    TaskID = RecordSet.getString("maxid_1");

    }
    ProcPara = ProjID ;
    ProcPara += flag + "" + TaskID ;
    ProcPara += flag + "np"  ;
    ProcPara += flag + "" + CurrentDate ;
    ProcPara += flag + "" + CurrentTime ;
    ProcPara += flag + "" + CurrentUser ;
    ProcPara += flag + "" + ClientIP ;
    ProcPara += flag + "" + SubmiterType ;
    RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);

	for(int i=arrayParentids.size()-1;i>=0;i--){
		String tmpparentid = ""+arrayParentids.get(i);
		RecordSet.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid);
		//out.print("::::"+tmpparentid+"::::");
	}

	String tmpsql="";

	tmpsql="update Prj_taskprocess set childnum=childnum+1 where id="+parentid;
	RecordSet.executeSql(tmpsql);

	//权限表操作
	tmpsql="select * from PrjShareDetail where prjid="+ProjID+" and usertype=1 and userid="+hrmid;
	RecordSet.executeSql(tmpsql);
	if(RecordSet.next()){
		if(RecordSet.getString("sharelevel").equals("1")){
			tmpsql="update PrjShareDetail set sharelevel='5' where prjid="+ProjID+" and usertype=1 and userid="+hrmid;
			RecordSet.executeSql(tmpsql);
		}
	}else{
		ProcPara = ProjID ;
		ProcPara += flag + hrmid ;
		ProcPara += flag + "1" ;
		ProcPara += flag + "5" ;
        RecordSet.executeProc("PrjShareDetail_Insert",""+ProcPara);
	}

	//PrjViewer.setPrjShareByPrj(""+ProjID);

	response.sendRedirect("/proj/plan/NewPlan.jsp?ProjID="+ProjID);
}

else if (method.equals("del"))
{
	//ProcPara = taskrecordid ;
	//RecordSet.executeProc("Prj_TaskProcess_DeleteByID",ProcPara);
	RecordSet.executeSql("DELETE FROM Prj_TaskProcess WHERE prjid="+ProjID+" and id="+taskrecordid);

    ProcPara = ProjID ;
    ProcPara += flag + "" + taskrecordid ;
    ProcPara += flag + "dp"  ;
    ProcPara += flag + "" + CurrentDate ;
    ProcPara += flag + "" + CurrentTime ;
    ProcPara += flag + "" + CurrentUser ;
    ProcPara += flag + "" + ClientIP ;
    ProcPara += flag + "" + SubmiterType ;
    RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);

    int i=arrayParentids.size()-2;
	for(i=arrayParentids.size()-2;i>=0;i--){
		String tmpparentid = ""+arrayParentids.get(i);
		RecordSet.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid);
	}

	String tmpsql="";
    if(i>=0){
	tmpsql="update Prj_taskprocess set childnum=childnum-1 where id="+arrayParentids.get(arrayParentids.size()-2);
	RecordSet.executeSql(tmpsql);
    }

	//PrjViewer.setPrjShareByPrj(""+ProjID);

	response.sendRedirect("/proj/plan/NewPlan.jsp?ProjID="+ProjID);
}

else if (method.equals("edit"))
{

     boolean bNeedUpdate = false;


    ProcPara = taskrecordid ;
    RecordSetM.executeProc("Prj_TaskProcess_SelectByID",ProcPara);
    RecordSetM.next();

    /*修改主题*/
    strTemp = RecordSetM.getString("subject");
    if(!subject.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "subject" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ subject+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType + flag +"0";
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }
    /*修改负责人*/
    strTemp = RecordSetM.getString("hrmid");
    if(!hrmid.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "hrmid" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ hrmid+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    strTemp = RecordSetM.getString("begindate");
    if(!begindate.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "begindate" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ begindate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    //modify dongping for TD735
    //1.找出其子任务中最大的结束时间
    String maxSubTaskEndDate = "" ;
    String strSql= "select max(enddate) as maxEndDate from Prj_TaskProcess where isdelete= 0 and   parentid="+taskrecordid ;
    rs.executeSql(strSql);
    if (rs.next()) {
        maxSubTaskEndDate = Util.null2String(rs.getString("maxEndDate")) ;
    }
    int tempCompare = enddate.compareTo(maxSubTaskEndDate) ;
    //System.out.println("maxSubTaskEndDate is |"+maxSubTaskEndDate+"|");
     //2.其本身任务修改后的结束时间和子任务的最大结束时间做比较
    if (tempCompare<0&&!maxSubTaskEndDate.equals("")) {%>
        <SCRIPT LANGUAGE="JavaScript">
        <!--
            alert("任务完成的最后时间小于其子任务完成的最后时间！");
            window.location='EditTask.jsp?taskrecordid=<%=taskrecordid%>';
        //-->
        </SCRIPT>
    <%    return ;
    } 
    strTemp = RecordSetM.getString("enddate");
    if(!enddate.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "enddate" + flag + CurrentDate +  flag + CurrentTime + flag+ strTemp+flag+ enddate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }


    strTemp = RecordSetM.getString("workday");
    if(!workday.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "workday" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ workday+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    strTemp = RecordSetM.getString("fixedcost");
    if(!fixedcost.equals(strTemp)){
        ProcPara =ProjID+flag + taskrecordid +flag + "fixedcost" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ fixedcost+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
        RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
        bNeedUpdate = true;
    }

    strTemp = Util.null2String(RecordSetM.getString("islandmark"));


    if((!islandmark.equals("")) || (!strTemp.equals(""))){
        if(!islandmark.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "islandmark" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ islandmark+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
        }

    }



    strTemp = Util.null2String(RecordSetM.getString("content"));


    if((!content.equals("")) || (!strTemp.equals(""))){
        if(!content.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "content" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ content+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"0" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
        }

    }


    strTemp = Util.null2String(RecordSetM.getString("prefinish"));


    if((!pretask.equals("")) || (!strTemp.equals(""))){
        if(!pretask.equals(strTemp)){
            ProcPara =ProjID+flag + taskrecordid +flag + "pretask" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ pretask+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"0" ;
            RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
            bNeedUpdate = true;
        }
    }

    if(bNeedUpdate){
        ProcPara = taskrecordid ;
        ProcPara += flag + "" + wbscoding ;
        ProcPara += flag + "" + subject ;
        ProcPara += flag + "" + begindate ;
        ProcPara += flag + "" + enddate ;
		//===================================
		//TD4793
		//modified by hubo, 2006-08-22
		ProcPara += flag + "" + "";
		ProcPara += flag + "" + "";
		//===================================
        ProcPara += flag + "" + workday ;
        ProcPara += flag + "" + content ;
        ProcPara += flag + "" + fixedcost ;
        ProcPara += flag + "" + hrmid ;
        ProcPara += flag + "" + oldhrmid ;
        ProcPara += flag + "" + finish ;
        ProcPara += flag + "" + '0' ;
        ProcPara += flag + "" + islandmark ;
        ProcPara += flag + "" + pretask ;
        ProcPara += flag + "" + realManDays ; 

        RecordSet.executeProc("Prj_TaskProcess_Update",ProcPara);

        //db2 trigger->procedure
        /*
        CREATE PROCEDURE Trigger_Proc_02 
        (
        in begindate char(10),
        in enddate char(10),
        in isdelete smallint ,
        in hrmid integer
        ) 
        */



        if (RecordSetDB.getDBType().equals("db2")){
            ProcPara = begindate ;
            ProcPara += flag + "" + enddate ;
            ProcPara += flag + "" + '0' ;
            ProcPara += flag + "" + hrmid ;
        //  RecordSet.executeProc("Trigger_Proc_02",ProcPara);
        }





    }

    ProcPara = ProjID ;
    ProcPara += flag + "" + taskrecordid ;
    ProcPara += flag + "mp"  ;
    ProcPara += flag + "" + CurrentDate ;
    ProcPara += flag + "" + CurrentTime ;
    ProcPara += flag + "" + CurrentUser ;
    ProcPara += flag + "" + ClientIP ;
    ProcPara += flag + "" + SubmiterType ;
    RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);

	for(int i=arrayParentids.size()-2;i>=0;i--){
		String tmpparentid = ""+arrayParentids.get(i);
		RecordSet.executeProc("Prj_TaskProcess_UpdateParent",tmpparentid);
	}

	if(!hrmid.equals(oldhrmid)){
		//PrjViewer.setPrjShareByPrj(""+ProjID);
	}

	response.sendRedirect("/proj/plan/ViewTask.jsp?taskrecordid="+taskrecordid);
}
else if (method.equals("uporder")) {
    String para = taskrecordid + flag+ "1";
    RecordSet.executeProc("PrjTaskProcess_UOrder",para);
    response.sendRedirect("NewPlan.jsp?ProjID="+ProjID);
}

else if (method.equals("downorder")) {
    String para = taskrecordid + flag+ "2";
    RecordSet.executeProc("PrjTaskProcess_UOrder",para);
    response.sendRedirect("NewPlan.jsp?ProjID="+ProjID);
}
%>