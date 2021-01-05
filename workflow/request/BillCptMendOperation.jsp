
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*,java.sql.Timestamp,weaver.system.code.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />

<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String isFromEditDocument = Util.null2String(fu.getParameter("isFromEditDocument"));
String remark = Util.null2String(fu.getParameter("remark"));
String method = Util.fromScreen(fu.getParameter("method"),user.getLanguage()); // 作为新建文档时候的参数传递
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));  //返回的页面
String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));
String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));
int SignType = Util.getIntValue(fu.getParameter("SignType"),0);
int isovertime = Util.getIntValue(fu.getParameter("isovertime"),0);
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
boolean docFlag=flowDocss.haveDocFiled(""+workflowid,""+nodeid);
int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+""+requestid+"urger"),0);
String isintervenor=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"isintervenor"));
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

String isMultiDoc = Util.null2String(fu.getParameter("isMultiDoc")); //多文档新建

RequestManager.setIsMultiDoc(isMultiDoc) ;
RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setSubmitNodeId(submitNodeId);
RequestManager.setIntervenorid(Intervenorid);
RequestManager.setSignType(SignType);
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;
//System.out.println("messageType===="+messageType);
RequestManager.setIsFromEditDocument(isFromEditDocument) ;
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setBeAgenter(beagenter);
//end
RequestManager.setIsagentCreater(isagentCreater);    
boolean havaChage=false;
if(docFlag) 
{
 havaChage=flowDocss.haveChage(""+workflowid,""+requestid,fu);  //如果改变了发文目录
}
//TD8715 获取工作流信息，是否显示流程图
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
	    	//response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor);
	    	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}
//System.out.println("isShowChart = " + isShowChart);
/**Save the detail info of the request**/
	//move this part to do in the class of RequestManager
	
/**Save Detail end**/
boolean flowstatus = RequestManager.flowNextNode() ;

//add by fanggsh 20060718 for TD4531 begin
String triggerStatus=(String)session.getAttribute("triggerStatus"); 
session.removeAttribute("triggerStatus");
if( !flowstatus&&triggerStatus!=null&&triggerStatus.equals("1") ) {
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=3");
    out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=3');</script>");
    return ;
}
//add by fanggsh 20060718 for TD4531 end

if( !flowstatus ) {
    String message=RequestManager.getMessage();
    if(!message.equals("")){
    	//response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor);
    	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor+"');</script>");

    }else{
    	//response.sendRedirect("/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2");
    	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");

    }
    return ;
}
boolean logstatus = RequestManager.saveRequestLog() ;

session.removeAttribute("workflowidbybrowser");

if (RequestManager.getNextNodetype().equals("3")) //归档处理资产
{
RecordSet.execute("select * from bill_mendCpt where  requestid="+requestid);
if (RecordSet.next())
{

String capitalid =RecordSet.getString("cptMend"); 
String hrmid =RecordSet.getString("mendPerson"); 
String maintaincompany = RecordSet.getString("mendCustomer"); 
String menddate =RecordSet.getString("menddate"); 
String mendperioddate= RecordSet.getString("mendLong"); 
String remarks = RecordSet.getString("remark"); 

char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+menddate;
    para +=separator+"";
    para +=separator+"";
    para +=separator+"1";
    para +=separator+"";
    para +=separator+"0";
    para +=separator+maintaincompany;
    para +=separator+"0";
    para +=separator+"4";
    para +=separator+remark;
    para +=separator+hrmid;
    para +=separator+mendperioddate;

    RecordSet.executeProc("CptUseLogMend_Insert",para);

   CapitalComInfo.removeCapitalCache();


}
}

String fromPDA=Util.null2String((String)session.getAttribute("loginPAD"));
if(method.equals("")){  
	
	if (docFlag){
        DocCheckInOutUtil.docCheckInWhenRequestOperation(user,requestid,request);
		flowDocss.changeDocFiled(""+workflowid,""+requestid,fu,user.getLanguage(),havaChage); //如果改变了发文目录
	}
	if(!topage.equals("")){
        	if(topage.indexOf("?")!=-1)
        	{
        		//response.sendRedirect(topage+"&requestid="+requestid);
        		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
        		return;
        	}
        	else
        	{
				//response.sendRedirect(topage+"?requestid="+requestid);
        		out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
        		return;
        	}
		}
    else {
        if(iscreate.equals("1")){
           
            if (docFlag)
            {%>
			<SCRIPT LANGUAGE="JavaScript">
				<%if("1".equals(isShowChart)){%>
             parent.document.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
			 <%}else{%>
				parent.document.location.href="/workflow/request/RequestView.jsp";
				 <%}%>
            </SCRIPT>
			<%}
            else
			{
			
			if (fromPDA.equals("1")){
				//response.sendRedirect("/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid);
				out.print("<script>wfforward('/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid+"');</script>");
			}else{
				if("1".equals(isShowChart)){
            		//response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid);
            		//out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid+"');</script>");
            		out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid+"');try{	window.parent.opener.btnWfCenterReload.onclick(); }catch(e){}try{window.parent.opener._table.reLoad();}catch(e){}</script>");
				}else{
					//response.sendRedirect("/workflow/request/RequestView.jsp");
					%>
					<%@ include file="/workflow/request/RedirectPage.jsp" %> 
					<%
					 
				}
			}
			}
        }
        else{
            if("delete".equals(src) && savestatus && flowstatus){%>
            <SCRIPT LANGUAGE="JavaScript">
            alert("<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");
            //window.close();
<%if(docFlag){%>
            parent.window.close();
<%}else{%>
            window.close();
<%}%>
            </SCRIPT>
            <%}
            else{

            //TD4262 增加提示信息  开始
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1");//td3450 xwj 20060207
            String docFlags=(String)session.getAttribute("requestAdd"+requestid);  //流程建文档相关
            
			String isShowPrompt="true";
			if (docFlags.equals("1"))
			{%>
			<SCRIPT LANGUAGE="JavaScript">
             parent.document.location.href="/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&nodetypedoc=<%=nodetype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&isShowPrompt=<%=isShowPrompt%>&src=<%=src%>&isovertime=<%=isovertime%>&urger=<%=urger%>&isintervenor=<%=isintervenor%>";
            </SCRIPT>
			<%}
			else
           	{
				
			if (fromPDA.equals("1")){
				//response.sendRedirect("/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid);
				out.print("<script>wfforward('/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid+"');</script>");
			}else{
				
				if("1".equals(isShowChart)){
            		//response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid);
					out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid+"');try{	window.parent.opener.btnWfCenterReload.onclick(); }catch(e){}try{window.parent.opener._table.reLoad();}catch(e){}</script>");
				}else{
					//response.sendRedirect("/workflow/request/RequestView.jsp");
					%>
					<%@ include file="/workflow/request/RedirectPage.jsp" %> 
					<%
					 
				}
				
				//out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime+"&urger="+urger+"&isintervenor="+isintervenor+"');</script>");
				//response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime+"&urger="+urger+"&isintervenor="+isintervenor);//td3450 xwj 20060207
				//out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime+"&urger="+urger+"&isintervenor="+isintervenor+"');</script>");
			}
            //TD4262 增加提示信息  结束
             }
            }
        }
    }
}
else {
    String adddocfieldid = method.substring(7) ;
    String addMethod=method.substring(0,7) ;

    //新建流程的时候创建文档要返回流程页面，所以此处要设置SESSION
    String userid=""+user.getUID();
     session.setAttribute(userid+""+requestid+"status","");
    session.setAttribute(userid+""+requestid+"requestname",requestname);
    session.setAttribute(userid+""+requestid+"requestlevel",requestlevel);
    session.setAttribute(userid+""+requestid+"creater",""+userid);
    session.setAttribute(userid+""+requestid+"workflowid",""+workflowid);
    session.setAttribute(userid+""+requestid+"nodeid",""+nodeid);
    session.setAttribute(userid+""+requestid+"nodetype",nodetype);
    session.setAttribute(userid+""+requestid+"workflowtype",workflowtype);
    session.setAttribute(userid+""+requestid+"formid",""+formid);
    session.setAttribute(userid+""+requestid+"billid",""+billid);
    session.setAttribute(userid+""+requestid+"isbill",""+isbill);
  
    //topage = URLEncoder.encode("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&docfileid="+adddocfieldid+"&topage="+topage);
    topage = URLEncoder.encode("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&docfileid="+adddocfieldid+"&fromFlowDoc=1&topage="+topage+"&urger="+urger+"&isintervenor="+isintervenor);
    if (addMethod.equals("docnew_")){
		//response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage);
		//response.sendRedirect("/docs/docs/DocList.jsp?isOpenNewWind=0&topage="+topage);
		out.print("<script>wfforward('/docs/docs/DocList.jsp?isOpenNewWind=0&topage="+topage+"');</script>");
    }else{  
		
//add by fanggsh 2007-03-23  for TD6247  调整为：在流程中以TAB页形式打开相关文档时才保存流程与模板对应数据  开始

		if (docFlag) flowDocss.changeDocFiled(""+workflowid,""+requestid,fu,user.getLanguage(),havaChage);  //如果改变了发文目录
		String docCodeForRequestOperation=Util.null2String((String)session.getAttribute("docCodeForRequestOperation"));
		String docSubjectForRequestOperation=Util.null2String((String)session.getAttribute("docSubjectForRequestOperation"));
		session.removeAttribute("docCodeForRequestOperation");
		session.removeAttribute("docSubjectForRequestOperation");

//add by fanggsh 2007-03-23  for TD6247  调整为：在流程中以TAB页形式打开相关文档时才保存流程与模板对应数据  结束

		session.removeAttribute("doc_topage"); 
		String docId=Util.null2String(fu.getParameter("docValue"));
		ArrayList flowDocs=flowDocss.getDocFiled(""+workflowid);
		//flowDocss.setRequestToModul(""+workflowid,""+requestid,user.getLanguage());
		String mainid="";
		String secid="";
		String subid="";
		ArrayList flowViewDocs=flowDocss.getSelectItemValue(""+workflowid,""+requestid);
		if (flowDocs!=null&&flowDocs.size()>0){    
			ArrayList   TempAyyay=Util.TokenizerString(""+flowDocs.get(2),"||");
			//String codeFiled=""+flowDocs.get(0);
           //String fieldName="x";
           //RecordSet.execute("select fieldname from workflow_formdict where id="+codeFiled);
           //if(RecordSet.next()){
               //fieldName=RecordSet.getString(1);
               //RecordSet.execute("select "+fieldName+" from workflow_form where requestid="+requestid);
               //if(RecordSet.next()){
			   //}
           //}
           
           if (TempAyyay!=null&&TempAyyay.size()>0)
              {
                 mainid=""+TempAyyay.get(0);
                 subid=""+TempAyyay.get(1);
                 secid=""+TempAyyay.get(2);
              }
      }
      if(flowViewDocs!=null&&flowViewDocs.size()>0){
	             mainid=""+flowViewDocs.get(0);
                 subid=""+flowViewDocs.get(1);
                 secid=""+flowViewDocs.get(2);
      }
      //session.setAttribute("requestname"+userid,requestname);
      //String docsubject="";
      //String docsubject1="";
      String docsubject1=docSubjectForRequestOperation;
      //if (havaChage) docsubject=docCodeForRequestOperation;
      //docsubject1=docCodeForRequestOperation;
      if (docsubject1.equals("")){
	      docsubject1=docCodeForRequestOperation;
      }
      if (docsubject1.equals("")){
	      docsubject1=requestname;
      }
      //else
      //{
      // if (havaChage) flowDocss.setCodeToRequest(""+workflowid,""+requestid,docsubject);
      //}
      session.setAttribute("docsubject"+userid,docsubject1);
      session.setAttribute("docCode"+userid,docCodeForRequestOperation);

      out.print("<script>try{parent.document.weaver.requestIdDoc.value="+requestid+";}catch(e){}</script>");
    
      String docView=Util.null2String(fu.getParameter("docView"));

      if (docView.equals("")) docView="0";

      if (docId.equals("")){
		  session.setAttribute("doc_topage",URLDecoder.decode(topage));
		  //out.print("<script>location.href=\"/docs/docs/DocAddExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"\"</script>");
		  out.print("<script>parent.location.href=\"ViewRequest.jsp?seeflowdoc=1&requestid="+requestid+"&isintervenor="+isintervenor+"\"</script>");
		  session.setAttribute(requestid + "_wfdoc","/docs/docs/DocAddExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor);
		  return;
          
      }else{
		  if (docView.equals("0")){
			  session.setAttribute("temp_doc_topage",URLDecoder.decode(topage));
			  //out.print("<script>location.href=\"/docs/docs/DocDspExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"\"</script>");
			  //out.print("<script>location.href=\"/docs/docs/DocDspExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isNoTurnWhenHasToPage=true\"</script>");			  
			  out.print("<script>parent.location.href=\"ViewRequest.jsp?seeflowdoc=1&requestid="+requestid+"&isintervenor="+isintervenor+"\"</script>");
			  session.setAttribute(requestid+"_wfdoc","/docs/docs/DocDspExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isNoTurnWhenHasToPage=true&isintervenor="+isintervenor);
		  }else{
			  session.setAttribute("doc_topage",URLDecoder.decode(topage));
/*            if (havaChage) {
			  if (docsubject.equals("")){
				  RecordSet.execute("update docdetail set maincategory="+mainid+",subcategory="+subid+" ,seccategory="+secid+" where id="+docId);
			  }else{
				  RecordSet.execute("update docdetail set docsubject='"+docsubject+"',maincategory="+mainid+",subcategory="+subid+" ,seccategory="+secid+" where id="+docId);
			  }
			  DocComInfo.updateDocInfoCache(""+docId);
			  }*/
			  if(iscreate.equals("1")&&!docId.equals("")){//在创建节点选择了文档，则将文档编号赋给流程字段
			      String docCodeForDocId="";
                  RecordSet.execute("select docCode from DocDetail where id="+Util.getIntValue(docId,-1));
                  if(RecordSet.next()){
					  docCodeForDocId=Util.null2String(RecordSet.getString("docCode"));
                  }
                  if(!docCodeForDocId.equals("")){
					  flowDocss.setCodeToRequest(""+workflowid,""+requestid,docCodeForDocId);	
                  }
			  }
			  //out.print("<script>location.href=\"/docs/docs/DocEditExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"\"</script>");
			  out.print("<script>parent.location.href=\"ViewRequest.jsp?seeflowdoc=1&requestid="+requestid+"&isintervenor="+isintervenor+"\"</script>");
			  session.setAttribute(requestid+"_wfdoc","/docs/docs/DocEditExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor);
		  }
		  return;
      }
    }
//  showsubmit 为0的时候新建文档将不显示提交按钮  response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage+"&showsubmit=0");
}


%>