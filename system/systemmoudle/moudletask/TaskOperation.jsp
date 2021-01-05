<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />


<%
String operation = Util.null2String(request.getParameter("operation"));
String supmoduleid  = Util.null2String(request.getParameter("supmoduleid"));
String moudleid = Util.null2String(request.getParameter("moudleid"));
String inputid = Util.null2String(request.getParameter("inputid"));
String inputsubject = Util.null2String(request.getParameter("inputsubject")) ;
String oldinputstatus = Util.null2String(request.getParameter("oldinputstatus")) ;
String[] checkmoduleids = request.getParameterValues("checkmoduleid") ;

String userid = ""+user.getUID() ;
String moudletablename = "" ;
String isrootmoudle = "" ;
String needconfirm = "" ;
String moudlemaintener = "" ;
String moudleviewer = "" ;
String moudlecreater = "" ;
String moudleconfirmer = "" ;
String moudletasker = "" ;
String moudlesql = "" ;
String inputstatus = "" ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String createdate = "" ;
String confirmdate = "" ;
char separator = Util.getSeparator() ;

ArrayList moudletaskers = new ArrayList() ;

RecordSet.executeProc("SystemMoudle_SByMoudleid",""+moudleid);
if(RecordSet.next()) {
    moudletablename = Util.null2String(RecordSet.getString("moudletablename")) ;
    isrootmoudle = Util.null2String(RecordSet.getString("isrootmoudle")) ;
    needconfirm = Util.null2String(RecordSet.getString("needconfirm")) ;
    moudlemaintener = Util.null2String(RecordSet.getString("moudlemaintener")) ;
    moudleviewer = Util.null2String(RecordSet.getString("moudleviewer")) ;
    moudleconfirmer = Util.null2String(RecordSet.getString("moudleconfirmer")) ;
    moudlesql = Util.toScreen(RecordSet.getString("moudlesql"),user.getLanguage()) ;
}

if( isrootmoudle.equals("0") ) supmoduleid = moudleid ;

if( operation.equals("addnew") || operation.equals("adddraft") ) {

    if( operation.equals("addnew") ) {
        if( !isrootmoudle.equals("0")) inputstatus = "1" ;
        else if( needconfirm.equals("1") ) {
            if( moudleconfirmer.equals("0") ) moudleconfirmer = ""+Util.getIntValue(ResourceComInfo.getManagerID(userid),0) ;
            
            if( moudleconfirmer.equals("0") || moudleconfirmer.equals(userid) ) {
                moudleconfirmer = userid ;
                confirmdate = currentdate ;
                inputstatus = "2" ;
            }
            else inputstatus = "1" ;
        }
        else inputstatus = "2" ;
    }
    else inputstatus = "0" ;

    createdate = currentdate ;
    
    String sqlin1 = "" ;
    String sqlin2 = "" ;

    if( isrootmoudle.equals("0") ) {
        sqlin1 = " insert into " + moudletablename + "(inputsubject ,createrid, confirmid , createdate,confirmdate , inputstatus " ;
        
        sqlin2 = " values ('" + Util.fromScreen2(inputsubject,user.getLanguage()) + "'," + userid + "," + moudleconfirmer + ",'" + createdate + "','" + confirmdate + "','" + inputstatus + "' " ;
    }
    else {
        sqlin1 = " insert into " + moudletablename + "(inputid ,createrid, createdate, inputstatus " ;
        
        sqlin2 = " values (" + inputid + "," + userid + ",'" + createdate + "','" + inputstatus + "' " ;
    }

    RecordSet.executeProc("SysModItemDsp_SByModid",""+moudleid);
	while(RecordSet.next()) {
		String itemid = Util.null2String(RecordSet.getString("itemid")) ;
        String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
        String itembroswertype = Util.null2String(RecordSet.getString("itembroswertype")) ;
        
        sqlin1 += ","+itemfieldname ;

        String itemvalue = Util.null2String(request.getParameter("field_"+itemid));

        if(itemfieldtype.equals("2") || itemfieldtype.equals("3") ) {
            if(itemfieldtype.equals("2")) sqlin2 += "," + Util.getIntValue(itemvalue,0) ;
            else sqlin2 += "," + Util.getDoubleValue(itemvalue,0) ;
        }
        else  if(itemfieldtype.equals("5")) {
            if( itembroswertype.equals("2") || itembroswertype.equals("19") )
                sqlin2 += ",'" + itemvalue + "'" ;
            else sqlin2 += "," + Util.getIntValue(itemvalue,0) ;
        }
        else sqlin2 += ",'" + Util.fromScreen2(itemvalue,user.getLanguage()) + "'" ;
    }

    sqlin1 += ")" ;
    sqlin2 += ")" ;

    RecordSet.executeSql(sqlin1 + sqlin2);

    if( isrootmoudle.equals("0") ) {

        RecordSet.executeSql(" select max(inputid) from " + moudletablename );
        if( RecordSet.next() ) inputid = Util.null2String(RecordSet.getString(1)) ;

        // 建立需要执行的子任务和负责人信息 
        RecordSet.executeProc("SysModTaskDetail_Delete",""+inputid); 
        if( checkmoduleids != null ) {
            for( int i=0 ; i<checkmoduleids.length ; i++) {
                String checkmoduleid = Util.null2String(checkmoduleids[i]) ;
                if( checkmoduleid == null ) continue ;
                String checkmoudlecreater = Util.null2String(request.getParameter("checkmoudlecreater_"+checkmoduleid));
                if( checkmoudlecreater == null ) continue ;

                String para = inputid + separator + checkmoduleid + separator + checkmoudlecreater  ;
                RecordSet.executeProc("SysModTaskDetail_Insert",para); 

                moudletaskers.add( checkmoudlecreater ) ;
                if( moudletasker.equals("")) moudletasker = checkmoudlecreater ;
                else moudletasker += "," + checkmoudlecreater ;
            }
        }

        /* 原来选择子任务和负责人的方式去掉 
        RecordSet.executeSql(" select moudlecreater from SystemMoudle where isrootmoudle = " + moudleid );
        while( RecordSet.next() ) {
            moudletaskers.add( Util.null2String(RecordSet.getString(1)) ) ;
            if( moudletasker.equals("")) moudletasker = Util.null2String(RecordSet.getString(1)) ;
            else moudletasker += "," + Util.null2String(RecordSet.getString(1)) ;
        } */

        String para = inputid + separator + inputsubject
            + separator + moudleid + separator + userid + separator + createdate 
            + separator + moudleconfirmer + separator + confirmdate + separator + moudleviewer
            + separator + moudletasker + separator + inputstatus ;

        RecordSet.executeProc("SystemModuleTask_Insert",para);

        // 通知
        if( operation.equals("addnew") ) {
            if( inputstatus.equals("1") )
                SysRemindWorkflow.setPrjSysRemind(
                                inputsubject+Util.toScreen("-等待审批",user.getLanguage(),"0"),
                                0,
                                0,
                                moudleconfirmer,
                                "<a href=/system/systemmoudle/moudletask/TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid+">"+Util.fromScreen2(inputsubject,user.getLanguage())+"</a>");
            else if(inputstatus.equals("2") )   {
                for( int i=0 ; i<moudletaskers.size() ; i++ ) {
                    moudletasker = (String) moudletaskers.get(i) ;
                    SysRemindWorkflow.setPrjSysRemind(
                                inputsubject+Util.toScreen("-等待执行",user.getLanguage(),"0"),
                                0,
                                0,
                                moudletasker,
                                "<a href=/system/systemmoudle/moudletask/TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid+">"+Util.fromScreen2(inputsubject,user.getLanguage())+"</a>");
                }
            }
        }
    }

    // 子任务完成的时候 或者根任务提交的时候 , 执行 SQL 

    if( ( (!isrootmoudle.equals("0") && inputstatus.equals("1")) || inputstatus.equals("2") ) &&  !moudlesql.equals("") ) {
        moudlesql = Util.StringReplace(moudlesql, "$inputid" , inputid ) ;
        RecordSet.executeSql(moudlesql) ;
    }

    response.sendRedirect("TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid);
    
}
else if( operation.equals("editnew") || operation.equals("editdraft") ) {
    
    if( operation.equals("editnew") ) {
        if( !isrootmoudle.equals("0")) inputstatus = "1" ;
        else if( needconfirm.equals("1") ) {
            if( moudleconfirmer.equals("0") ) moudleconfirmer = ""+Util.getIntValue(ResourceComInfo.getManagerID(userid),0) ;
            
            if( moudleconfirmer.equals("0") || moudleconfirmer.equals(userid) ) {
                moudleconfirmer = userid ;
                confirmdate = currentdate ;
                inputstatus = "2" ;
            }
            else inputstatus = "1" ;
        }
        else inputstatus = "2" ;
    }
    else inputstatus = oldinputstatus ;

    String sqlin1 = "" ;

    if( isrootmoudle.equals("0") ) {
        sqlin1 = " update " + moudletablename + " set inputsubject='" +Util.fromScreen2(inputsubject,user.getLanguage()) +"',inputstatus='" + inputstatus + "' " ;
    }
    else {
        sqlin1 = " update " + moudletablename + " set inputstatus='" + inputstatus + "' " ;
    }

    RecordSet.executeProc("SysModItemDsp_SByModid",""+moudleid);
	while(RecordSet.next()) {
		String itemid = Util.null2String(RecordSet.getString("itemid")) ;
        String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
        String itembroswertype = Util.null2String(RecordSet.getString("itembroswertype")) ;
        
        sqlin1 += "," + itemfieldname + "=" ;

        String itemvalue = Util.null2String(request.getParameter("field_"+itemid));

        if(itemfieldtype.equals("2") || itemfieldtype.equals("3") ) {
            if(itemfieldtype.equals("2")) sqlin1 += Util.getIntValue(itemvalue,0) ;
            else sqlin1 += Util.getDoubleValue(itemvalue,0) ;
        }
        else  if(itemfieldtype.equals("5")) {
            if( itembroswertype.equals("2") || itembroswertype.equals("19") )
                sqlin1 += "'" + itemvalue + "'" ;
            else sqlin1 += Util.getIntValue(itemvalue,0) ;
        }
        else sqlin1 += "'" + Util.fromScreen2(itemvalue,user.getLanguage()) + "'" ;
    }

    sqlin1 += " where inputid = " + inputid ;

    RecordSet.executeSql(sqlin1);

    if( isrootmoudle.equals("0") ) {        // 作为提交

        // 建立需要执行的子任务和负责人信息 
        RecordSet.executeProc("SysModTaskDetail_Delete",""+inputid); 
        if( checkmoduleids != null ) {
            for( int i=0 ; i<checkmoduleids.length ; i++) {
                String checkmoduleid = Util.null2String(checkmoduleids[i]) ;
                if( checkmoduleid == null ) continue ;
                String checkmoudlecreater = Util.null2String(request.getParameter("checkmoudlecreater_"+checkmoduleid));
                if( checkmoudlecreater == null ) continue ;

                String para = inputid + separator + checkmoduleid + separator + checkmoudlecreater  ;
                RecordSet.executeProc("SysModTaskDetail_Insert",para); 

                moudletaskers.add( checkmoudlecreater ) ;
                if( moudletasker.equals("")) moudletasker = checkmoudlecreater ;
                else moudletasker += "," + checkmoudlecreater ;
            }
        }
        
        /* 原来选择子任务和负责人的方式去掉 
        RecordSet.executeSql(" select moudlecreater from SystemMoudle where isrootmoudle = " + moudleid );
        while( RecordSet.next() ) moudletaskers.add( Util.null2String(RecordSet.getString(1)) ) ;
        */

        RecordSet.executeSql(" update SystemModuleTask set tasker = '" + moudletasker + "' , taskstatus = '" + inputstatus + "' where inputid = " + inputid);
        
        /* 原来判断状态是否改变再更新 SystemModuleTask 表， 现在由于所选的负责人可能改变，因此必须执行 
        if( !oldinputstatus.equals(inputstatus) ) 
            RecordSet.executeSql(" update SystemModuleTask set taskstatus = '" + inputstatus + "' where inputid = " + inputid);
        */

        // 通知
        if( operation.equals("editnew") ) {
            if( inputstatus.equals("1") )
                SysRemindWorkflow.setPrjSysRemind(
                                inputsubject+Util.toScreen("-等待审批",user.getLanguage(),"0"),
                                0,
                                0,
                                moudleconfirmer,
                                "<a href=/system/systemmoudle/moudletask/TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid+">"+Util.fromScreen2(inputsubject,user.getLanguage())+"</a>");
            else if(inputstatus.equals("2") )   {
                for( int i=0 ; i<moudletaskers.size() ; i++ ) {
                    moudletasker = (String) moudletaskers.get(i) ;
                    SysRemindWorkflow.setPrjSysRemind(
                                inputsubject+Util.toScreen("-等待执行",user.getLanguage(),"0"),
                                0,
                                0,
                                moudletasker,
                                "<a href=/system/systemmoudle/moudletask/TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid+">"+Util.fromScreen2(inputsubject,user.getLanguage())+"</a>");
                }
            }
        }
    }

    // 子任务完成的时候 或者根任务提交的时候 , 执行 SQL 

    if( ( (!isrootmoudle.equals("0") && inputstatus.equals("1")) || inputstatus.equals("2") ) &&  !moudlesql.equals("") ) {
        moudlesql = Util.StringReplace(moudlesql, "$inputid" , inputid ) ;
        RecordSet.executeSql(moudlesql) ;
    }
    response.sendRedirect("TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid);
    
}
else if( operation.equals("deletetask") ) {

    RecordSet.executeSql(" delete " + moudletablename + " where inputid = " + inputid ) ;
    RecordSet.executeSql(" delete SystemModuleTask where inputid = " + inputid) ;
    RecordSet.executeSql(" delete SystemModuleTaskDetail where inputid = " + inputid) ;
    
/*    RecordSet.executeSql(" select moudletablename from SystemMoudle where isrootmoudle = " + moudleid );
    while( RecordSet.next() ) {
        String submoudletablename = Util.null2String(RecordSet.getString(1)) ;
        RecordSet.executeSql(" delete " + submoudletablename + " where inputid = " + inputid ) ;
    }  */
    response.sendRedirect("TaskManage.jsp");

}
else if( operation.equals("confirmtask") ) {

    confirmdate = currentdate ;
    RecordSet.executeSql(" update " + moudletablename + " set confirmdate = '" + confirmdate + "' , inputstatus='2' where inputid = " + inputid ) ;
    RecordSet.executeSql(" update SystemModuleTask set confirmdate = '" + confirmdate + "' , taskstatus='2' where inputid = " + inputid) ;
    
    /* 原有的选择子任务的执行人的方式改变为在创建任务的时候确定 
    RecordSet.executeSql(" select moudlecreater from SystemMoudle where isrootmoudle = " + moudleid );
    */
    RecordSet.executeSql(" select moudlecreater from SystemModuleTaskDetail where inputid = " + inputid );
    while( RecordSet.next() ) moudletaskers.add( Util.null2String(RecordSet.getString(1)) ) ;

    for( int i=0 ; i<moudletaskers.size() ; i++ ) {
        moudletasker = (String) moudletaskers.get(i) ;
        SysRemindWorkflow.setPrjSysRemind(
                    inputsubject+Util.toScreen("-等待执行",user.getLanguage(),"0"),
                    0,
                    0,
                    moudletasker,
                    "<a href=/system/systemmoudle/moudletask/TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid+">"+Util.fromScreen2(inputsubject,user.getLanguage())+"</a>");
    }

    // 根任务提交的时候 , 执行 SQL 

    if( !moudlesql.equals("") ) {
        moudlesql = Util.StringReplace(moudlesql, "$inputid" , inputid ) ;
        RecordSet.executeSql(moudlesql) ;
    }

    response.sendRedirect("TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid);
    
}
else if( operation.equals("returntask") ) {

    RecordSet.executeSql(" update " + moudletablename + " set inputstatus='3' where inputid = " + inputid) ;
    RecordSet.executeSql(" update SystemModuleTask set taskstatus='3' where inputid = " + inputid) ;
    
    RecordSet.executeSql(" select createrid from " + moudletablename + " where inputid = " + inputid );
    if( RecordSet.next() ) moudlecreater = Util.null2String(RecordSet.getString(1)) ;

    SysRemindWorkflow.setPrjSysRemind(
                inputsubject+Util.toScreen("-被退回",user.getLanguage(),"0"),
                0,
                0,
                moudlecreater,
                "<a href=/system/systemmoudle/moudletask/TaskView.jsp?inputid="+inputid+"&moudleid="+supmoduleid+">"+Util.fromScreen2(inputsubject,user.getLanguage())+"</a>");

    response.sendRedirect("TaskManage.jsp");
    
}
else if( operation.equals("closetask") ) {

    RecordSet.executeSql(" update " + moudletablename + " set inputstatus='4' where inputid = " + inputid) ;
    RecordSet.executeSql(" update SystemModuleTask set taskstatus='4' where inputid = " + inputid) ;
    
    response.sendRedirect("TaskManage.jsp");
    
}
%>
