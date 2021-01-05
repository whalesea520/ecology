
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.DocDetailLog"%>  
<%@ page import="weaver.general.Util"%>  
<%@ page import="java.io.Writer"%>  
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="spop" class="weaver.splitepage.operate.SpopForDoc" scope="page" />
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocExtUtil" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="docRecycleManager" class="weaver.docs.docs.DocRecycleManager" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="weaver.hrm.*" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String operation =  Util.null2String(request.getParameter("operation"));
String docid =  Util.null2String(request.getParameter("docid"));
String redirectTo =  Util.null2String(request.getParameter("redirectTo"));

String docsubject="";
String doccreaterid="";
String checkOutStatus="";
int checkOutUserId=0;
String checkOutUserType="";
String doccreatertype = "";

String strSql="select docsubject,doccreaterid,doccreatertype,checkOutStatus,checkOutUserId,checkOutUserType from docdetail where id="+docid;
rs.executeSql(strSql);
if (rs.next()){
	docsubject = Util.null2String(rs.getString("docsubject"));
	doccreaterid =  Util.null2String(rs.getString("doccreaterid"));
	checkOutStatus=Util.null2String(rs.getString("checkOutStatus"));
	checkOutUserId=rs.getInt("checkOutUserId");
	checkOutUserType=Util.null2String(rs.getString("checkOutUserType"));
	doccreatertype = Util.null2String(rs.getString("doccreatertype"));
  }
%>

<%
if (!"GetDocContent".equals(operation)){
%>

<% } %>

<%
//求得权限
//userType,userId,userSeclevel
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
String userInfo = user.getLogintype()+"_"+user.getUID()+"_"+user.getSeclevel()+"_"+userType+"_"+userdepartment+"_"+usersubcomany;

// 0:查看 1:编辑 2:删除 3:共享 4:日志 每项中的值 "false":表示无权限  "true":表示有权限
ArrayList popedomList = spop.getDocOpratePopedom(docid,userInfo); 

if ("delete".equals(operation)){
    //权限断定
    if ("false".equals((String)popedomList.get(2))) {
        response.sendRedirect("/notice/noright.jsp");
	    return;
    }

	String promptInfo="";
    
    //rs.executeSql("select count(0) from docdetail where doceditionid > 0 and id<>"+docid+" and doceditionid = (select doceditionid from docdetail where id = " + docid + ") and (docstatus <= 0 or docstatus in (3,4,6)) ");
    rs.executeSql("select count(0) from docdetail where doceditionid > 0 and id>"+docid+" and doceditionid = (select doceditionid from docdetail where id = " + docid + ") and (docstatus <= 0 or docstatus in (3,4,6)) ");
    if(rs.next()&&rs.getInt(1)>0){
    	promptInfo=SystemEnv.getHtmlLabelName(20411,user.getLanguage());		
    } else {    
		if(checkOutStatus.equals("1")
	             &&(checkOutUserId!=user.getUID()||!checkOutUserType.equals(user.getLogintype()))){//如果被其他人签出
	
	                String checkOutUserName="";
	            	if(checkOutUserType.equals("2")){
	            		checkOutUserName=CustomerInfoComInfo.getCustomerInfoname(""+checkOutUserId);
	            	}else{
	            		checkOutUserName=ResourceComInfo.getResourcename(""+checkOutUserId);
	            	}
	
	            	promptInfo=SystemEnv.getHtmlLabelName(19786,user.getLanguage())+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+":"+checkOutUserName;
	
		}else{//否则,即没有被其他人签出
			RecordSet.executeSql("select propvalue from   doc_prop  where propkey='docsrecycle'");
			RecordSet.next();
			int docsrecycle=Util.getIntValue(RecordSet.getString("propvalue"),0);
			if(docsrecycle==1&&!(user.getLogintype().equals("2"))){//开启回收站
				docRecycleManager.moveDocToRecycle(user.getUID(), user.getLogintype(), Util.getIntValue(docid), request.getRemoteAddr());
			}else{
            int doceditionid=-1;
			int docedition=-1;
			rs.executeSql("select doceditionid,docedition from DocDetail where id = " + docid);
			if(rs.next()){
				doceditionid = Util.getIntValue(Util.null2String(rs.getString("doceditionid")));
				docedition = Util.getIntValue(Util.null2String(rs.getString("docedition")));
			}
		    if(doceditionid>0){
			    rs.executeSql("select * from DocDetail where doceditionid = " + doceditionid + " order by docEdition asc ");
			    while(rs.next()) {
					docid = Util.null2String(rs.getString("id"));
					docsubject = Util.null2String(rs.getString("docsubject"));
					doccreaterid =  Util.null2String(rs.getString("doccreaterid"));
					doccreatertype = Util.null2String(rs.getString("doccreatertype"));

					DocExtUtil.deleteDoc(Util.getIntValue(docid));
					//TD10931 chujun
					docDetailLog.resetParameter();
					docDetailLog.setDocId(Util.getIntValue(docid));
					docDetailLog.setDocSubject(docsubject);
					docDetailLog.setOperateType("3");           
					docDetailLog.setOperateUserid(user.getUID());
					docDetailLog.setUsertype(user.getLogintype());
					docDetailLog.setClientAddress(request.getRemoteAddr());
					docDetailLog.setDocCreater(Util.getIntValue(doccreaterid,0));
					docDetailLog.setCreatertype(doccreatertype);
					docDetailLog.setDocLogInfo();

			    }
		    }else{
			    DocExtUtil.deleteDoc(Util.getIntValue(docid));
			    //TD10931 chujun
			    docDetailLog.resetParameter();
			    docDetailLog.setDocId(Util.getIntValue(docid));
			    docDetailLog.setDocSubject(docsubject);
			    docDetailLog.setOperateType("3");           
			    docDetailLog.setOperateUserid(user.getUID());
			    docDetailLog.setUsertype(user.getLogintype());
			    docDetailLog.setClientAddress(request.getRemoteAddr());
			    docDetailLog.setDocCreater(Util.getIntValue(doccreaterid,0));
			    docDetailLog.setCreatertype(doccreatertype);
			    docDetailLog.setDocLogInfo();
			}
			}
			promptInfo=SystemEnv.getHtmlLabelName(19791,user.getLanguage());
		}

    }    
    %>
	<%=promptInfo%>
<%} else if("share".equals(operation)) {
     //权限断定
    if ("false".equals((String)popedomList.get(3))) {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
    //具体操作
    %>
	<FORM id=docShareLog name=docShareLog method=post>
	    <input type=hidden name=docid value="<%=docid%>">
	    <input type=hidden name=docsubject value="<%=docsubject%>">
	    <input type=hidden name=doccreaterid value="<%=doccreaterid%>">
	    <input type=hidden name=sqlwhere value="<%=xssUtil.put("where docid="+docid)%>">
	</FORM>

    <script language="javaScript">
        document.docShareLog.action="/docs/docs/DocShare.jsp" ;
        document.docShareLog.submit() ;
    </script>  
<%} else if("viewLog".equals(operation)) {
     //权限断定
    if ("false".equals((String)popedomList.get(4))) {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }    
    //具体操作
    %>

	<FORM id=docShareLog name=docShareLog method=post>
	    <input type=hidden name=docid value="<%=docid%>">
	    <input type=hidden name=docsubject value="<%=docsubject%>">
	    <input type=hidden name=doccreaterid value="<%=doccreaterid%>">
	    <input type=hidden name=sqlwhere value="<%=xssUtil.put("where docid="+docid)%>">
	</FORM>

    <script language="javaScript">
        document.docShareLog.action="/docs/DocDetailLog.jsp" ;
        document.docShareLog.submit() ;
    </script> 
<%} else if ("GetDocContent".equals(operation)){ 
        
        
        //其它操作        
        String tempsql="";
        String parentids="";
        String docContent = "";
        String docReplyId = "" ;
        String returnStr = "";
        String viewStr=SystemEnv.getHtmlLabelName(367,user.getLanguage());
        String editStr=SystemEnv.getHtmlLabelName(93,user.getLanguage());      
        String deleteStr=SystemEnv.getHtmlLabelName(91,user.getLanguage());         
        if(!"oracle".equals(rs.getDBType())){ 
            tempsql="select replydocid,doccontent,parentids,docsubject,doccreaterid,usertype from docdetail where  id="+docid;
        }else {
            tempsql="select replydocid,parentids,docsubject,doccreaterid,usertype from docdetail where  id="+docid;
        }
         String docsubject1="";
        rs.executeSql(tempsql);
        if(rs.next()){
            docReplyId= Util.null2String(rs.getString("replydocid"));            
             if("oracle".equals(rs.getDBType())){   
                String sqltemporalce="select doccontent from DocDetailContent where docid="+docid;                         
                ConnStatement statement=new ConnStatement();
                
                statement.setStatementSql(sqltemporalce, false);
                statement.executeQuery();
                //System.out.println(statement.next());  
                if(statement.next()){                    
                    CLOB theclob = statement.getClob("doccontent");
           
                    String readline = "";
                    StringBuffer clobStrBuff = new StringBuffer("");
                    BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                    while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
                    clobin.close() ;
                    docContent = clobStrBuff.toString();
                }
        
                //System.out.println("docContent is "+docContent);                
                statement.close();
             } else {
                docContent= Util.null2String(rs.getString("doccontent"));
             }
            parentids= Util.null2String(rs.getString("parentids"));
            docsubject1= Util.null2String(rs.getString("docsubject"));
            String doccreaterid1= Util.null2String(rs.getString("doccreaterid"));
            String usertype= Util.null2String(rs.getString("usertype"));
            
            //记日志        
            DocDetailLog log = new DocDetailLog();
           
            log.setDocId(Util.getIntValue(docid));
            log.setDocSubject(docsubject1);
            log.setOperateType("0");
            log.setOperateUserid(user.getUID());
            log.setUsertype(""+user.getLogintype());
            log.setCreatertype(usertype);
            log.setClientAddress(request.getRemoteHost());
            log.setDocCreater(Util.getIntValue(doccreaterid1));
            log.setDocLogInfo();
            
            /**********************向阅读标记表中插入阅读记录，修改阅读次数(只有当浏览者不是创建者时)********************/
            if( user.getUID() != Util.getIntValue(doccreaterid1) || !user.getLogintype().equals(usertype) ){
                char flag=Util.getSeparator() ;
                String procStr =docid+flag+(""+user.getUID())+flag+user.getLogintype();
                rs.executeProc("docReadTag_AddByUser",""+docid+flag+""+user.getUID()+flag+""+user.getLogintype());  // 他人                           
                //System.out.println(procStr);
            }
        }  
        
        if ("true".equals((String)popedomList.get(0))) viewStr="/docs/docs/DocDsp.jsp?id="+docid;
        if ("true".equals((String)popedomList.get(1))) editStr="/docs/docs/DocEdit.jsp?id="+docid;
        if ("true".equals((String)popedomList.get(2))) deleteStr="/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
        String replyStr="/docs/docs/DocReply.jsp?id="+docReplyId+"&parentids="+parentids;   
        //System.out.println(docContent);
        //if (docContent.length()<=36) docContent+="";
        
        //returnStr = "<div align=right>["+viewStr+"]&nbsp;&nbsp;["+editStr+"]&nbsp;&nbsp;["+replyStr+"]&nbsp;&nbsp;["+deleteStr+"]</div><hr>";
        //returnStr+=docContent;
        returnStr="var jsonReply={docsubject:\""+docsubject1+"\","+
							     "viewStr:\""+viewStr+"\","+
							     "editStr:\""+editStr+"\","+
							     "deleteStr:\""+deleteStr+"\","+
							     "replyStr:\""+replyStr+"\","+
							     "docContent:\""+docContent+"\""+
							     "};";
        
        out.println(returnStr);
    }
    %>

