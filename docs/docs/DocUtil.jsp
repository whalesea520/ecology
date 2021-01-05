
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*,java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<div id="totopwin" class="x-hidden">
	<iframe BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE id='ifrmViewType' name='ifrmViewType' width='100%' height='336px' scrolling='NO' src=''></iframe>
</div>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String isAppendTypeField = Util.null2String(request.getParameter("isAppendTypeField"));
int seccategory=Util.getIntValue(request.getParameter("seccategory"),0);
int docid=Util.getIntValue(request.getParameter("docid"),0);
int maindoc=Util.getIntValue(request.getParameter("maindoc"),0);
int ishistory=Util.getIntValue(request.getParameter("ishistory"),0);
int doceditionid=Util.getIntValue(request.getParameter("doceditionid"),0);
int olddocid=Util.getIntValue(request.getParameter("olddocid"),0);
String isrequest = Util.null2String(request.getParameter("isrequest"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc"));
String from = Util.null2String(request.getParameter("from"));
int userCategory=Util.getIntValue(request.getParameter("userCategory"),0);
boolean  blnOsp = "true".equals(request.getParameter("blnOsp")) ;
int isfromcowork=Util.getIntValue(request.getParameter("isfromcowork"),0);
String topageFromOther=Util.null2String(request.getParameter("topageFromOther"));
int meetingid=Util.getIntValue(request.getParameter("meetingid"),0);
String isSetShare=Util.null2String(""+request.getParameter("isSetShare"));
String doc_topage=Util.null2String((String)session.getAttribute("doc_topage")); 
String isfromext=Util.null2String(""+request.getParameter("isfromext"));
String isNoTurnWhenHasToPage=Util.null2String(""+request.getParameter("isNoTurnWhenHasToPage"));
boolean isHasTopage = false;
if(!isNoTurnWhenHasToPage.equals("") && isNoTurnWhenHasToPage.equals("true"))
   isHasTopage = true;
boolean childRemind=true;
RecordSet.executeSql("select * from docdetail where id="+docid);
	while(RecordSet.next()){
		if(Util.null2String(RecordSet.getString("docstatus")).equals("0")){
			childRemind=false;
		}
	}
String docopen = "DocDsp.jsp";
if(isfromext.equals("1"))
{
	docopen = "DocDspExt.jsp";
}
String url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocShareConfirm.jsp?isdialog=1&docid="+docid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
%>
<div style="display:none;">
	<brow:browser name="docsharedialog" browserBtnID="docshareBtn" _callback="afterSetShare" nameKey="result" viewType="0" browserUrl='<%=url %>' isMustInput="1"></brow:browser>
</div>
<%
//===========================================================================
//TD4080
//modified by hubo,2006-04-12
String prjTaskToPage = Util.null2String(request.getParameter("topage"));
if(prjTaskToPage.equals("")){
	//office文档无法返回流程，原因是topage传值失效了。
	prjTaskToPage = Util.null2String(request.getParameter("topage2"));
}
//System.out.println("topage========="+Util.null2String(request.getParameter("topage2")));
//System.out.println("prjTaskToPage = " + prjTaskToPage);
//System.out.println("doc_topage = " + doc_topage);
//System.out.println("===============: " + blnOsp+":"+(isSetShare.equals("1")));
//System.out.println("isSetShare = " + isSetShare);
// 以下用于来弹出共享提醒 
if (blnOsp && isSetShare.equals("1")){      //如果需要共享提醒   
%>
   <script language=javascript>
   	  function afterSetShare(e,datas,name,params){
   	  	var result = datas.result;
   	  	if(result==1){ 		
		  //TD8562 
		  //通过项目卡片或任务信息页面新建文档，提交时要弹出共享设置页面。
			<%if(!prjTaskToPage.equals("") && !prjTaskToPage.equals("null") && prjTaskToPage.indexOf("ViewProject.jsp")==-1){%>
				if(this.opener == undefined || this.opener.__fromRequest){
					window.location = "<%=prjTaskToPage%>&docid=<%=docid%>&pstate=sub";
				}else{
					this.opener.parent.location = "<%=prjTaskToPage%>&docid=<%=docid%>&pstate=sub";
					window.close();
				}
			<%}else{%>
				window.location = "<%=docopen%>?id=<%=docid%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>";
			<%}%>
      	}else {								
      		<%--TD.6077 新建后如果需要弹出共享提醒窗口，而未确定直接关闭，需要将新建文档变回草稿状态--%>
            if("<%=DocComInfo.getDocStatus(docid+"")%>"!="0"){
		        <%--如果直接将弹出的共享提醒窗口关闭，流程未触发，需要将状态3改回0--%>
				var url = 'DocShareOperation.jsp';
				var pars = 'docid=<%=docid%>&method=unfinish';
				/*var myAjax = new Ajax.Request(
					url,
					{method: 'post', parameters: pars, onComplete: doRefresh}
				);*/
				jQuery.ajax({
					url:url,
					type:"post",
					data:{
						docid:<%=docid%>,
						method:"unfinish",
						f_weaver_belongto_userid:"<%=f_weaver_belongto_userid%>",
					    f_weaver_belongto_usertype:"<%=f_weaver_belongto_usertype%>"
					},
					success:function(data){
						doRefresh(data);
					}
				});
			} else {
				<%if(!prjTaskToPage.equals("") && !prjTaskToPage.equals("null")&& prjTaskToPage.indexOf("ViewProject.jsp")==-1&&doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){%>
				if(this.opener == undefined){
					window.location = "<%=prjTaskToPage%>&docid=<%=docid%>&pstate=sub";
				}else{
					this.opener.location = "<%=prjTaskToPage%>&docid=<%=docid%>&pstate=sub";
					window.close();
				}
				<%}else{%>
					window.location = "<%=docopen%>?id=<%=docid%>";
				<%}%>
			}
      	}
      	<%if(!isHasTopage && !prjTaskToPage.equals("") && !prjTaskToPage.equals("null")&& prjTaskToPage.indexOf("ViewProject.jsp")==-1&& (prjTaskToPage.indexOf("ViewTask.jsp")>-1||doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1)){%>
				if(this.opener == undefined || window.opener.__fromRequest){
					window.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
				}else{
					this.opener.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
					window.close();
				}
		<%}
		//子文档阅读提醒
		if(SecCategoryComInfo.isChildDocReadRemind(seccategory)&&docid==maindoc&&ishistory==0&&childRemind){
		    List tmpdoclist = new ArrayList();
		    boolean hassondoc = false;
			RecordSet.executeSql(" select * from DocDetail where maindoc = " + docid + " and (isHistory<>'1'or isHistory is null or isHistory='') and docstatus in (1,2,5) " );
			while(RecordSet.next()){
			    String tmpdocid = Util.null2String(RecordSet.getString("id"));
				if(!"".equals(tmpdocid)&&Util.getIntValue(tmpdocid)!=docid){
				    if(!Util.null2String(RecordSet.getString("invalidationdate")).equals("")){
				        tmpdoclist.add(tmpdocid+"");
					}
				    hassondoc = true;
				}
			}
			for(Iterator it = tmpdoclist.iterator();it.hasNext();){
			    String tmpdocid = (String) it.next();
				%>
				openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=tmpdocid%>');
				<%
			}
			if(hassondoc){
				%>
				openFullWindowForXtable('DocReadRemind.jsp?docid=<%=docid%>');
				<%
			}
		}
		%>
		<%
		//TD.5434 提醒有新版本文档
		if(doceditionid>-1&&ishistory==1){
		    RecordSet.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " order by id desc ");
		    RecordSet.next();
			int newDocId = Util.getIntValue(RecordSet.getString("id"));
			if(newDocId!=docid&&newDocId>0){
			%>
				<script language=javascript>
				if(confirm("<%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
					location="DocDsp.jsp?fromFlowDoc=<%=fromFlowDoc%>&from=<%=from%>&userCategory=<%=userCategory%>&id=<%=newDocId%>&olddocid=<%=olddocid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&blnOsp=<%=blnOsp%>&fromcowork=<%=isfromcowork%>&topage=<%=URLEncoder.encode(topageFromOther)%>&meetingid=<%=meetingid%>&isAppendTypeField=<%=isAppendTypeField%>"
				}
				</script> 
			<%
			}
		}
		%>
   	  }
   	  jQuery("#docshareBtn").trigger("click");
      function doRefresh(req){
	      top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18741,user.getLanguage())%>");
			<%if(!prjTaskToPage.equals("") && !prjTaskToPage.equals("null")&& prjTaskToPage.indexOf("ViewProject.jsp")==-1&& doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1){%>
				if(this.opener == undefined){
					window.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
				}else{
					this.opener.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
					window.close();
				}
			<%}else{%>
				window.location = "<%=docopen%>?id=<%=docid%>";
			<%}%>
      }
    </script> 
<%}else if(prjTaskToPage.indexOf("/proj/process/DocOperation.jsp")>-1){%>
 <script language=javascript>
				if(this.opener == undefined){
					window.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
				}else{
					//this.opener.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
					this.opener.parent.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
					window.close();
				}
 </script>
<%}%>
<%if(!(blnOsp && isSetShare.equals("1"))){ %>
	<%if(!isHasTopage && !prjTaskToPage.equals("") && !prjTaskToPage.equals("null")&& prjTaskToPage.indexOf("ViewProject.jsp")==-1&& (prjTaskToPage.indexOf("ViewTask.jsp")>-1||doc_topage.indexOf("/proj/process/DocOperation.jsp")==-1)){%>
		<script type="text/javascript">
			if(this.opener == undefined||this.opener.__fromRequest){
				window.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
			}else{
				this.opener.location = "<%=prjTaskToPage%>&docid=<%=docid%>";
				window.close();
			}
		</script>
	<%}
	//子文档阅读提醒
	if(SecCategoryComInfo.isChildDocReadRemind(seccategory)&&docid==maindoc&&ishistory==0&&childRemind){
	    List tmpdoclist = new ArrayList();
	    boolean hassondoc = false;
		RecordSet.executeSql(" select * from DocDetail where maindoc = " + docid + " and (isHistory<>'1'or isHistory is null or isHistory='') and docstatus in (1,2,5) " );
		while(RecordSet.next()){
		    String tmpdocid = Util.null2String(RecordSet.getString("id"));
			if(!"".equals(tmpdocid)&&Util.getIntValue(tmpdocid)!=docid){
			    if(!Util.null2String(RecordSet.getString("invalidationdate")).equals("")){
			        tmpdoclist.add(tmpdocid+"");
				}
			    hassondoc = true;
			}
		}
		for(Iterator it = tmpdoclist.iterator();it.hasNext();){
		    String tmpdocid = (String) it.next();
			%>
			<script language=javascript>
				openFullWindowForXtable('/docs/docs/DocDsp.jsp?id=<%=tmpdocid%>');
			</script> 
			<%
		}
		if(hassondoc){
			%>
			<script language=javascript>
				openFullWindowForXtable('DocReadRemind.jsp?docid=<%=docid%>');
			</script> 
			<%
		}
	}
	%>
	<%
	//TD.5434 提醒有新版本文档
	if(doceditionid>-1&&ishistory==1){
	    RecordSet.executeSql(" select id from DocDetail where doceditionid = " + doceditionid + " order by id desc ");
	    RecordSet.next();
		int newDocId = Util.getIntValue(RecordSet.getString("id"));
		if(newDocId!=docid&&newDocId>0){
		%>
			<script language=javascript>
			if(confirm("<%=SystemEnv.getHtmlLabelName(19986,user.getLanguage())%>")) {
				location="DocDsp.jsp?fromFlowDoc=<%=fromFlowDoc%>&from=<%=from%>&userCategory=<%=userCategory%>&id=<%=newDocId%>&olddocid=<%=olddocid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&blnOsp=<%=blnOsp%>&fromcowork=<%=isfromcowork%>&topage=<%=URLEncoder.encode(topageFromOther)%>&meetingid=<%=meetingid%>&isAppendTypeField=<%=isAppendTypeField%>"
			}
			</script> 
		<%
		}
	}
	%>
<%} %>
<script  language="javascript">
function DocToTop(docid,type)
{
	var operation = "";
	if(type==1)
	{
		operation = "top";
		showDocToTopBrowser(docid,operation);
	}
	else
	{
		operation = "notop";
		DocToTopOk(docid,operation);
	}
	
	 
}
function showDocToTopBrowser(docid,operation) 
{
	//document.getElementById("ifrmViewType").src = "DocToTopBrowser.jsp?docid="+docid;
	var forwardurl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocToTopBrowser.jsp?docid="+docid;
	dialog = new window.top.Dialog();
   	dialog.currentWindow = window;
   	dialog.Title = "<%=SystemEnv.getHtmlLabelName(23784,user.getLanguage())%>";
   	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = forwardurl;
	dialog.show();	
}
function DocToTopOk(docid,operation)
{
	var istop = "";
	var topstartdate = "";
	var topenddate = "";
	try
	{
		istop = document.getElementById("ifrmViewType").contentWindow.document.getElementById("istop").value;
		topstartdate = document.getElementById("ifrmViewType").contentWindow.document.getElementById("topstartdate").value;
		topenddate = document.getElementById("ifrmViewType").contentWindow.document.getElementById("topenddate").value;
	}
	catch(e)
	{
	
	}
	var ajax=ajaxinit();
    ajax.open("POST", "/docs/DocDetailLogOperate.jsp", true);
	ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	ajax.send("docid="+docid+"&operation="+operation+"&istop="+istop+"&topstartdate="+topstartdate+"&topenddate="+topenddate);
   	ajax.onreadystatechange = function() 
   	{
		if (ajax.readyState == 4 && ajax.status == 200) 
	  	{
			try
			{
				var reistop = "";
				var reistop = ajax.responseText.replace(/(^\s*)|(\s*$)/g, "");
				
				if(operation == "top"&&istop=="1"&&reistop=="1")
					alert("<%=SystemEnv.getHtmlLabelName(23784,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>!")
				else if(operation == "top"&&istop=="1"&&reistop!="1")
					alert("<%=SystemEnv.getHtmlLabelName(23784,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>!")	  
				else if(operation == "notop"||istop!="1")
					alert("<%=SystemEnv.getHtmlLabelName(24675,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>!")	  
			}
			catch(e)
			{
				return false;
			}
      	}
	}
}
</SCRIPT>
