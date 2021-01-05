
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="weaver.WorkPlan.WorkPlanExchange" %>
<%@ page import="weaver.discuss.ExchangeHandler" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!
public String saveAccessory(HttpServletRequest request,User user,RecordSet RecordSet, String fieldname)
{
	//附件上传
	String tempAccessory = "";
		String returnarry1 =Util.null2String(request.getParameter(fieldname));
		String[] returnarry = returnarry1.split(",");
		if(returnarry != null){
			for(int j=0;j<returnarry.length;j++){
				if(!returnarry[j].equals("-1") && !returnarry[j].equals("")){
						//新建时赋予创建者对附件文档的权限，而不是对所有参与者赋权。
						RecordSet.executeSql("insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)values("+returnarry[j]+",1,"+user.getUID()+",0,1,1,"+user.getUID()+",1)");
						if(tempAccessory.equals(""))
						{
							tempAccessory = String.valueOf(returnarry[j]);
						}
						else
						{
							tempAccessory += "," + String.valueOf(returnarry[j]);
						}
				}
			}
		}
	return tempAccessory;
}
 %>
<%
FileUpload fu = new FileUpload(request);
String method = Util.null2String(request.getParameter("method1"));
String types = request.getParameter("types"); 
if("".equals(method)){
	method = Util.null2String(fu.getParameter("method1"));
	types = fu.getParameter("types");
}
String sortid =  Util.null2String(request.getParameter("sortid"));  //日程Id
String ExchangeInfo = Util.fromScreen(request.getParameter("ExchangeInfo"), user.getLanguage());  //相关交流

String docids = Util.null2String(request.getParameter("docids"));
String para = "";
String CustomerID ="";
String creater =""+user.getUID();
String isfromtab = Util.null2o(request.getParameter("isfromtab"));
if(user.getLogintype().equals("2"))
{
	creater="-"+user.getUID();
}

char flag=Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

if (method.equals("add")&& types.equals("CS"))
//销售机会交流的添加
{
    CustomerID = Util.null2String(request.getParameter("CustomerID"));
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/sellchance/ViewSellChanceMessage.jsp?isfromtab="+isfromtab+"&id="+sortid);
}

if (method.equals("add")&& types.equals("CC"))
//客户交流的添加
{
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+sortid);
}

if (method.equals("add")&& types.equals("CT"))
//客户联系交流的添加
{

	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/data/ViewContactLogDetail.jsp?CLogID="+sortid);
}

if (method.equals("add")&& types.equals("CH"))
//合同交流的添加
{
    CustomerID = request.getParameter("CustomerID");
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	
	
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/CRM/data/ContractViewMessage.jsp?CustomerID="+CustomerID+"&id="+sortid);
}

if (method.equals("add")&& types.equals("PP"))
//项目交流的添加
{	

	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
	para += flag+"" ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
    
	response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+sortid);
}

if (method.equals("add")&& types.equals("PT")) 
//任务交流的添加
{	
	String sign=request.getParameter("sign");
	String relatedprj = Util.null2String(request.getParameter("relatedprj"));
	String relatedcus = Util.null2String(request.getParameter("relatedcus"));
	String relatedwf = Util.null2String(request.getParameter("relatedwf"));
	String relateddoc = Util.null2String(request.getParameter("relateddoc"));
	para = sortid;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+creater;
	para += flag+currentdate ;
	para += flag+currenttime ;
	para += flag+types ;
	para += flag+docids ;
	para += flag+relatedprj ;
	para += flag+relatedcus ;
	para += flag+relatedwf ;
	para += flag+relateddoc ;
		
	RecordSet.executeProc("ExchangeInfo_Insert",para);
	if(sign.equals("process")) 
	{    
		response.sendRedirect("/proj/process/ViewTask.jsp?taskrecordid="+sortid);
	}
	else
	{
		response.sendRedirect("/proj/plan/ViewTask.jsp?taskrecordid="+sortid);
	}
}

if (method.equals("add")&& types.equals("WP")) 
//工作计划交流的添加
{
	String createrType = user.getLogintype();
    ExchangeInfo = Util.fromScreen(URLDecoder.decode(request.getParameter("ExchangeInfo"),"utf-8"), user.getLanguage());  //相关交流
	String crmIds = Util.null2String(request.getParameter("excrmIDs"));
	String projectIds = Util.null2String(request.getParameter("exPrjIDs"));
	String requestIds = Util.null2String(request.getParameter("exReqeustIDs"));
	
	docids = Util.null2String(request.getParameter("docids"));
	String relatedcus = Util.null2String(request.getParameter("relatedcus"));//相关客户
	String relatedwf = Util.null2String(request.getParameter("relatedwf"));//相关流程
	String projectIDs = Util.null2String(request.getParameter("projectIDs"));//相关项目
	String relateddoc = saveAccessory(request,user,RecordSet,"relateddoc");//相关附件
	if(!"".equals(relatedcus)){
		crmIds = relatedcus;
	}
	if(!"".equals(relatedwf)){
		requestIds = relatedwf;
	}
	if(!"".equals(projectIDs)){
		projectIds = projectIDs;
	}

	String[] params = new String[] {sortid, "", ExchangeInfo, creater, createrType, 
								docids, crmIds, projectIds, requestIds};
	
	String sql = "INSERT INTO Exchange_Info( sortid , name , remark , creater , createDate , createTime, type_n, docids, crmIds, requestIds, relateddoc, projectIds,createrType) "
        +" VALUES( "+sortid+" , '', '"+ExchangeInfo+"',"+user.getUID()+", '"+currentdate+"' , '"+currenttime+"', '"+types+"','"+docids+"','"+relatedcus+"','"+relatedwf+"','"+relateddoc+"','"+projectIDs+"','"+user.getLogintype()+"')";
		
	RecordSet.executeSql(sql);


	//added by lupeng 2004-07-05 for myplan part.
	WorkPlanExchange exchange = new WorkPlanExchange();
	exchange.exchangeAdd(Integer.parseInt(sortid), creater, createrType);  //更改日程交流统计表
	//end
    
	response.sendRedirect("/workplan/data/WorkPlanDetail.jsp?workid="+sortid);
}
if (method.equals("edit")&& types.equals("WP")) 
//工作计划交流的添加
{
	String createrType = user.getLogintype();

	String discussId = Util.null2String(request.getParameter("discussid"));
	docids = Util.null2String(request.getParameter("docids"));
	String relatedcus = Util.null2String(request.getParameter("relatedcus"));//相关客户
	String relatedwf = Util.null2String(request.getParameter("relatedwf"));//相关流程
	String projectIDs = Util.null2String(request.getParameter("projectIDs"));//相关项目
	String relateddoc = saveAccessory(request,user,RecordSet,"relateddoc");//相关附件

	String delrelatedacc =Util.fromScreen(request.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
	String edit_relatedacc =Util.fromScreen(request.getParameter("edit_relatedacc"),user.getLanguage());  //删除相关附件id
	//删除相关附件
		if(!"".equals(delrelatedacc)) 
  		RecordSet.executeSql("delete DocDetail where id in ("+delrelatedacc.substring(0,delrelatedacc.length()-1)+")" );
  	if(!"".equals(relateddoc)){
  		relateddoc += "," + edit_relatedacc;
  	} else {
  		relateddoc =  edit_relatedacc;
  	}
  	
    ExchangeInfo = Util.fromScreen(URLDecoder.decode(request.getParameter("ExchangeInfo"),"utf-8"), user.getLanguage());  //相关交流
	String sql ="update Exchange_Info set "
				+ " remark = '"+ExchangeInfo+"'"
				+ ", docids = '"+docids+"'"
				+ ", crmIds = '"+relatedcus+"'"
				+ ", requestIds = '"+relatedwf+"'"
				+ ", projectIDs = '"+projectIDs+"'"
				+ ", createDate = '"+currentdate+"'"
				+ ", createTime = '"+currenttime+"'"
				+ ", relateddoc = '"+relateddoc+"'"
				+ " where id =" + discussId;
	RecordSet.executeSql(sql);
	response.sendRedirect("/workplan/data/WorkPlanDetail.jsp?workid="+sortid);
}

if (method.equals("add")&& types.equals("MP"))
//会议的相关交流
{
	sortid =  Util.null2String(request.getParameter("sortid"));  //会议Id
	ExchangeInfo = Util.fromScreen(URLDecoder.decode(request.getParameter("ExchangeInfo"),"utf-8"), user.getLanguage());  //相关交流
	//System.out.println("ExchangeInfo["+request.getParameter("ExchangeInfo")+"]");
	//System.out.println("ExchangeInfo["+ExchangeInfo+"]");
	docids = Util.null2String(request.getParameter("docids"));
    String relatedprj = Util.null2String(request.getParameter("relatedprj"));//相关任务
	String relatedcus = Util.null2String(request.getParameter("relatedcus"));//相关客户
	String relatedwf = Util.null2String(request.getParameter("relatedwf"));//相关流程
	String relateddoc = saveAccessory(request,user,RecordSet,"relateddoc");//相关附件
	String projectIDs = Util.null2String(request.getParameter("projectIDs"));//相关项目

	String sql = "INSERT INTO Exchange_Info( sortid , name , remark , creater , createDate , createTime, type_n, docids, relatedprj, relatedcus, relatedwf, relateddoc, projectIds,createrType) "
           +" VALUES( "+sortid+" , '', '"+ExchangeInfo+"',"+user.getUID()+", '"+currentdate+"' , '"+currenttime+"', '"+types+"','"+docids+"','"+relatedprj+"', '"+relatedcus+"','"+relatedwf+"','"+relateddoc+"','"+projectIDs+"','"+user.getLogintype()+"')";
		
	RecordSet.executeSql(sql);
    
	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?tab=1&showdiv=discussDiv&meetingid="+sortid);
}

if (method.equals("edit")&& types.equals("MP"))
//会议的相关交流
{
	sortid =  Util.null2String(request.getParameter("sortid"));  //会议Id
	String discussId = Util.null2String(request.getParameter("discussid"));
	if(!"".equals(discussId)){
		ExchangeInfo = Util.fromScreen(URLDecoder.decode(request.getParameter("ExchangeInfo"),"utf-8"), user.getLanguage());  //相关交流
	
		docids = Util.null2String(request.getParameter("docids"));
	    String relatedprj = Util.null2String(request.getParameter("relatedprj"));//相关任务
		String relatedcus = Util.null2String(request.getParameter("relatedcus"));//相关客户
		String relatedwf = Util.null2String(request.getParameter("relatedwf"));//相关流程
		String relateddoc = saveAccessory(request,user,RecordSet,"relateddoc");//相关附件
		String projectIDs = Util.null2String(request.getParameter("projectIDs"));//相关项目
		
		String delrelatedacc =Util.fromScreen(request.getParameter("delrelatedacc"),user.getLanguage());  //删除相关附件id
		String edit_relatedacc =Util.fromScreen(request.getParameter("edit_relatedacc"),user.getLanguage());  //删除相关附件id
		//删除相关附件
   		if(!"".equals(delrelatedacc)) 
      		RecordSet.executeSql("delete DocDetail where id in ("+delrelatedacc.substring(0,delrelatedacc.length()-1)+")" );
      	if(!"".equals(relateddoc)){
      		relateddoc += "," + edit_relatedacc;
      	} else {
      		relateddoc =  edit_relatedacc;
      	}
		String sql ="update Exchange_Info set "
				+ " remark = '"+ExchangeInfo+"'"
				+ ", relateddoc = '"+relateddoc+"'"
				+ ", docids = '"+docids+"'"
				+ ", relatedprj = '"+relatedprj+"'"
				+ ", relatedcus = '"+relatedcus+"'"
				+ ", relatedwf = '"+relatedwf+"'"
				+ ", projectIDs = '"+projectIDs+"'"
				+ ", createDate = '"+currentdate+"'"
				+ ", createTime = '"+currenttime+"'"
				+ " where id =" + discussId;
		RecordSet.executeSql(sql);
	}
	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?tab=1&showdiv=discussDiv&meetingid="+sortid);
}
if (method.equals("delete")&& (types.equals("MP")||types.equals("WP")))
//相关交流
{
	sortid =  Util.null2String(fu.getParameter("sortid"));  //会议Id
	String discussId = Util.null2String(fu.getParameter("discussid"));
	if(!"".equals(discussId)){
		
		String sql ="delete from  Exchange_Info where id =" + discussId;
		RecordSet.executeSql(sql);
	}
	//response.sendRedirect("/meeting/data/ProcessMeeting.jsp?tab=1&showdiv=discussDiv&meetingid="+sortid);
}
%>