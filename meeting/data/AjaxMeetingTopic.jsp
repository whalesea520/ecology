
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.defined.MeetingFieldManager"%>
<%@page import="weaver.meeting.util.html.HtmlUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.crm.Maint.CustomerInfoComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>

<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="meetingTransMethod" class="weaver.meeting.Maint.MeetingTransMethod" scope="page"/>
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page"/>
<%!
	private boolean containUser(String allUser,List userids){
		for(int i=0;i<userids.size();i++){
			if("".equals(userids.get(i))) continue;
			if((","+allUser+",").indexOf(","+userids.get(i)+",")>-1){
				return true;
			}
		}
		return false;
	}

%>
<%
User user = HrmUserVarify.getUser(request,response);
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String software = (String)staticobj.getObject("software") ;
if(software == null) software="ALL";
String allUser=MeetingShareUtil.getAllUser(user);
String ProcPara = "";
char flag=Util.getSeparator() ;

int meetingstatus = Util.getIntValue(request.getParameter("meetingstatus"), -1);
boolean ismanager = Util.str2bool(Util.null2String(request.getParameter("ismanager")));

boolean iscontacter = Util.str2bool(Util.null2String(request.getParameter("iscontacter")));;

boolean ismember = Util.str2bool(Util.null2String(request.getParameter("ismember")));

String isdecision = Util.null2String(request.getParameter("isdecision"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
String creater = Util.null2String(request.getParameter("creater"));
String caller = Util.null2String(request.getParameter("caller"));
String contacter = Util.null2String(request.getParameter("contacter"));

boolean canedit=false;
if(( MeetingShareUtil.containUser(allUser,caller)|| MeetingShareUtil.containUser(allUser,creater) ||  MeetingShareUtil.containUser(allUser,contacter)) && meetingstatus != 2){
	canedit=true;
}

if(ismanager ){
	canedit=true;
}

%>
  <TABLE class="ViewForm">
        <TBODY>
        <%if((ismanager||iscontacter) && !isdecision.equals("1") && !isdecision.equals("2")){%>
		 <TR class="Title">
            <TH></TH>
           
           <td class="Field" align="right" width="5%" nowrap>
           <button type="button" class="e8_btn_cancel" accesskey=Y onClick="onShowTopic(<%=meetingid%>)" style="width:60px"><%=SystemEnv.getHtmlLabelName(2210,user.getLanguage())%></button>
           </td>
          </TR>
         <%}%>
        <TR class="Spacing" style="height:1px!important;">
          <TD class="Line1" colspan=2></TD>
		</TR>
        <tr><td class="Field" colspan=2>
		<%
   		int topicColSize=0;
    	MeetingFieldManager hfm2 = new MeetingFieldManager(2);
    	List<String> groupList=hfm2.getLsGroup();
    	List<String> fieldList=null;
    	Hashtable<String,String> ht=null;
    	for(String groupid:groupList){
    		fieldList= hfm2.getUseField(groupid);
    		topicColSize=fieldList.size();
    		if(fieldList!=null&&fieldList.size()>0){
    			topicColSize=fieldList.size();
    	%>		
    			
    	<TABLE class="ListStyle" cellspacing=1  cols=7 id="oTable">
        <COLGROUP>
        	<%for(int i=0;i<topicColSize;i++){
        		out.println("<COL width='"+(75.0/topicColSize)+"%'>");
        	} %>
    		<COL width="15%">
    		<COL width="10%">
        <TBODY>
		<TR class="HeaderForXtalbe" >
			<% for(String fieldid:fieldList){
					int fieldlabel = Util.getIntValue(MeetingFieldComInfo.getLabel(fieldid));
					out.println("<Th>"+SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"</Th>\n");
    			}
    		%>	
		   <Th><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%></Th>
   		   <Th>&nbsp;</Th>
    	</TR>		
    			
    			
    			
    	<%	
    	RecordSet.executeProc("Meeting_Topic_SelectAll",meetingid);
   		while(RecordSet.next()){
   			ArrayList arrayhrmids = Util.TokenizerString(RecordSet.getString("hrmids"),",");
   			//参会人只能看到正常会议和已删除会议,所以在这里给状态加上<!=4(已取消)>的判断
   			if( (meetingstatus != 2 && meetingstatus !=4) || ismanager || containUser(allUser,arrayhrmids)|| iscontacter || ( RecordSet.getString("isopen").equals("1") && ismember ) ){
	   			out.print("<tr class='DataDark'>\n"); 
	   			for(String fieldid:fieldList){
					String fieldname = MeetingFieldComInfo.getFieldname(fieldid);
					int fieldhtmltype = Integer.parseInt(MeetingFieldComInfo.getFieldhtmltype(fieldid));
					int type = Integer.parseInt(MeetingFieldComInfo.getFieldType(fieldid));
					String fielddbtype = MeetingFieldComInfo.getFielddbtype(fieldid);
					JSONObject cfg= hfm2.getFieldConf(fieldid);
					String fieldValue = RecordSet.getString(fieldname);
					//转成html显示
					if(fieldhtmltype==4){//check框,变成disabled
						cfg.put("disabled","disabled");
						fieldValue=HtmlUtil.getHtmlElementString(fieldValue,cfg,user);
					}else if(fieldhtmltype==3){
						fieldValue=hfm2.getHtmlBrowserFieldvalue(user,Integer.parseInt(fieldid),fieldhtmltype,type,fieldValue,fielddbtype,meetingid);
					}else{
						fieldValue=hfm2.getFieldvalue(user, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue, 0,fielddbtype);
					}
					
					out.println("<td style=\"word-break:break-all;\">"+fieldValue+"</td>");
				}
	   	%>		
	   			<td class="Field"  style="word-break:break-all;">
					<table class="ViewForm">
					<%
					RecordSet2.executeProc("Meeting_TopicDate_SelectAll",meetingid+flag+RecordSet.getString("id"));
					while(RecordSet2.next()){
					%>
						<tr><td class="Field" style="border-bottom: none;">
							<p><%=RecordSet2.getString("begindate")%> <%=RecordSet2.getString("begintime")%> 
							<p>- 
							<p><%=RecordSet2.getString("enddate")%> <%=RecordSet2.getString("endtime")%>
						</td></tr>
				
					<%}%>
					</table>
				</td>
				<td class="Field" valign=center  width="11%" nowrap>
				<%if(!isdecision.equals("1") && !isdecision.equals("2") && meetingstatus == 2 && (ismanager||iscontacter || containUser(allUser,arrayhrmids) )){%>
				<button type="button" accesskey=Y onClick="onShowTopicDoc(<%=RecordSet.getString("id")%>)"  class="e8_btn_cancel"  style="padding-left:3px !important;padding-right:3px !important;width:60px" title="<%=SystemEnv.getHtmlLabelName(82902, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82902, user.getLanguage())%></button>
				<%}%>
				<%if((canedit && !isdecision.equals("1") && !isdecision.equals("2") && meetingstatus!=4)||(meetingstatus==2&&iscontacter)){%><button type="button" class="e8_btn_cancel" accesskey=Y onClick="onShowTopicDate(<%=RecordSet.getString("id")%>)" style="padding-left:3px !important;padding-right:3px !important;width:60px" title="<%=SystemEnv.getHtmlLabelName(82903, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82903, user.getLanguage())%></button><%}%>
				</td>
			
		<%		out.print("\n</tr>\n"); 
		
				if(meetingstatus == 2){
					ProcPara = meetingid + flag + RecordSet.getString("id");
					RecordSet2.executeProc("Meeting_TopicDoc_SelectAll",ProcPara);
					while(RecordSet2.next()){
				%>
				<tr class="DataDark">
		        <td class="Field" colspan=2><img border=0 src="/images/ArrowRightBlue_wev8.gif" align=middle>&nbsp;<a href="/docs/docs/DocDsp.jsp?id=<%=RecordSet2.getString("docid")%>&meetingid=<%=meetingid %>" target="_blank"><%=Util.toScreen(RecordSet2.getString("docsubject"),user.getLanguage())%></a></td>
			    <td class="Field" colspan=<%=topicColSize-1 %>>
				<A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet2.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet2.getString("hrmid"))%></a></td>
				<td class="Field"><%if(!isdecision.equals("1") && !isdecision.equals("2") && (ismanager || iscontacter || userid.equals(RecordSet2.getString("hrmid")))){%><a href="javascript:void(0)"  onclick="deleteTopicDoc(<%=RecordSet2.getString("id")%>)"><img border=0 src="/images/icon_delete_wev8.gif"></a><%}%></td>
				</tr>
				<%}
				}
   			}
   		}
    	
    	
    	
    		}
    	}
        %>
        
        </TBODY>
	  </TABLE>		  
		  
		  </TD>
        </TR>
        </TBODY>
	  </TABLE>
