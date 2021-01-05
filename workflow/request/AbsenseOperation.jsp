
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*,java.sql.Timestamp,weaver.system.code.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="flowDocss" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/><%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));

int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
//add by chengfeng.han 2011-7-8 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
//end
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
String remark = Util.null2String(fu.getParameter("remark"));
String method = Util.fromScreen(fu.getParameter("method"),user.getLanguage()); // 作为新建文档时候的参数传递
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));  //返回的页面
String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));
String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));
//String remarkLocation = Util.null2String(fu.getParameter("remarkLocation"));   //签字意见添加位置
int isovertime = Util.getIntValue(fu.getParameter("isovertime"),0);
boolean docFlag=flowDocss.haveDocFiled(""+workflowid,""+nodeid);
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}


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
//add by chengfeng.han 2011-7-8 
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//RequestManager.setRemarkLocation(remarkLocation);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;
//System.out.println("messageType===="+messageType);
RequestManager.setUser(user) ;
boolean havaChage=false;
if(docFlag) 
{
 havaChage=flowDocss.haveChage(""+workflowid,""+requestid,fu);  //如果改变了发文目录
}

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
		out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

/**Save the detail info of the request**/
	//move this part to do in the class of RequestManager
	
/**Save Detail end**/
boolean flowstatus = RequestManager.flowNextNode() ;

//归档特殊操作
if( RequestManager.getNextNodetype().equals("3") )
{
RecordSet.execute("update bill_HrmTime set status='1' where requestid="+requestid);
}

//add by fanggsh 20060718 for TD4531 begin
String triggerStatus=(String)session.getAttribute("triggerStatus"); 
session.removeAttribute("triggerStatus");
if( !flowstatus&&triggerStatus!=null&&triggerStatus.equals("1") ) {
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=3");
    out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=3');</script>");
    return ;
}
//add by fanggsh 20060718 for TD4531 end

if( !flowstatus ) {
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
    out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
    return ;
}
boolean logstatus = RequestManager.saveRequestLog() ;

String fromPDA=Util.null2String((String)session.getAttribute("loginPAD"));
if( method.equals("") ) 
{  if (docFlag) flowDocss.changeDocFiled(""+workflowid,""+requestid,fu,user.getLanguage(),havaChage); 
//如果改变了发文目录
	if(!topage.equals("")){
    	if(topage.indexOf("?")!=-1){
    		//response.sendRedirect(topage+"&requestid="+requestid);
    		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
		}else{
			//response.sendRedirect(topage+"?requestid="+requestid);
			out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
		}
	}
    else {
        if(iscreate.equals("1")){
           
            if (docFlag)
            {%>
			<SCRIPT LANGUAGE="JavaScript">
             parent.document.location.href="/workflow/request/RequestView.jsp";
            </SCRIPT>
			<%}
            else
			{
			
			if (fromPDA.equals("1")){
				//response.sendRedirect("/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid);
				out.print("<script>wfforward('/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid+"');</script>");
			}else{
				 
            	//response.sendRedirect("/workflow/request/RequestView.jsp");
				%>
				<%@ include file="/workflow/request/RedirectPage.jsp" %> 
				<%
			}
			}
        }
        else{
            if("delete".equals(src) && savestatus && flowstatus){%>
            <SCRIPT LANGUAGE="JavaScript">
            alert("<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");
            window.close();
            </SCRIPT>
            <%}
            else{

            //TD4262 增加提示信息  开始
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1");//td3450 xwj 20060207
            String docFlags=(String)session.getAttribute("requestAdd"+requestid);  //流程建文档相关
            
			String isShowPrompt="true";
			if (docFlags.equals("1"))
			{%>
			<SCRIPT LANGUAGE="JavaScript">
             parent.document.location.href="/workflow/request/ViewRequest.jsp?nodetypedoc=<%=nodetype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&isShowPrompt=<%=isShowPrompt%>&src=<%=src%>&isovertime=<%=isovertime%>";
            </SCRIPT>
			<%}
			else
           	{
				
			if (fromPDA.equals("1")){
				//response.sendRedirect("/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid);
				out.print("<script>wfforward('/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid+"');</script>");
			}else{
				//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime);//td3450 xwj 20060207
				%>
				<%@ include file="/workflow/request/RedirectPage.jsp" %> 
				<%
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
     session.setAttribute(userid+"_"+requestid+"status","");
    session.setAttribute(userid+"_"+requestid+"requestname",requestname);
    session.setAttribute(userid+"_"+requestid+"requestlevel",requestlevel);
    session.setAttribute(userid+"_"+requestid+"creater",""+userid);
    session.setAttribute(userid+"_"+requestid+"workflowid",""+workflowid);
    session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
    session.setAttribute(userid+"_"+requestid+"nodetype",nodetype);
    session.setAttribute(userid+"_"+requestid+"workflowtype",workflowtype);
    session.setAttribute(userid+"_"+requestid+"formid",""+formid);
    session.setAttribute(userid+"_"+requestid+"billid",""+billid);
    session.setAttribute(userid+"_"+requestid+"isbill",""+isbill);
  
    //topage = URLEncoder.encode("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&docfileid="+adddocfieldid+"&topage="+topage);
    topage = URLEncoder.encode("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&docfileid="+adddocfieldid+"&fromFlowDoc=1&topage="+topage);
    if (addMethod.equals("docnew_")){
		//response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage);
    	out.print("<script>wfforward('/docs/docs/DocList.jsp?topage="+topage+"');</script>");
    }else{  
		
//add by fanggsh 2007-03-23  for TD6247  调整为：在流程中以TAB页形式打开相关文档时才保存流程与模板对应数据  开始

		if (docFlag) flowDocss.changeDocFiled(""+workflowid,""+requestid,fu,user.getLanguage(),havaChage);  //如果改变了发文目录
		String docCodeForRequestOperation=Util.null2String((String)session.getAttribute("docCodeForRequestOperation"));


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
      String docsubject1="";
      //if (havaChage) docsubject=docCodeForRequestOperation;
      docsubject1=docCodeForRequestOperation;
      if (docsubject1.equals("")){
	      docsubject1=requestname;
      }
      //else
      //{
      // if (havaChage) flowDocss.setCodeToRequest(""+workflowid,""+requestid,docsubject);
      //}
      session.setAttribute("docsubject"+userid,docsubject1);
      session.setAttribute("docCode"+userid,docCodeForRequestOperation);

      out.print("<script>parent.document.weaver.requestIdDoc.value="+requestid+"</script>");
    
      String docView=Util.null2String(fu.getParameter("docView"));

      if (docView.equals("")) docView="0";

      if (docId.equals("")){
		  session.setAttribute("doc_topage",URLDecoder.decode(topage));
		  out.print("<script>parent.location.href=\"/docs/docs/DocAddExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"\"</script>");
		  return;
      }else{
		  if (docView.equals("0")){
			  session.setAttribute("temp_doc_topage",URLDecoder.decode(topage));
			  out.print("<script>parent.location.href=\"/docs/docs/DocDspExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"\"</script>"); 
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
			  out.print("<script>parent.location.href=\"/docs/docs/DocEditExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"\"</script>");
		  }
		  return;
      }
    }
//  showsubmit 为0的时候新建文档将不显示提交按钮  response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage+"&showsubmit=0");
}


%>