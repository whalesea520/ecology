
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
 user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"),0);
boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;
String logintype = user.getLogintype();
String  isurger = Util.null2String(request.getParameter("isurger"));

String requestname="";
String requestlevel="";
int workflowid=0;
int formid=0;
int isbill=1;
int billid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int creater=0;
int deleted=0;
int isremark=0;
int creatertype = 0;

int usertype = 0;
if(logintype.equals("1"))
	usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
	
char flag=Util.getSeparator() ;
int rqMessageType=-1;
int rqChatsType=-1;//微信提醒（QC:98106）


RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
	creater=RecordSet.getInt("creater");
	deleted=RecordSet.getInt("deleted");
	creatertype = RecordSet.getInt("creatertype");
	requestlevel=RecordSet.getString("requestlevel");	
	rqMessageType=RecordSet.getInt("messagetype");
	rqChatsType=RecordSet.getInt("chatstype");//微信提醒（QC:98106）

}
int wfMessageType=-1;
//微信提醒（QC:98106）

int wfChatsType=-1;
RecordSet.executeSql("select MessageType,chatsType from workflow_base where id="+workflowid);

if(RecordSet.next()){
    wfMessageType = RecordSet.getInt("MessageType");
    wfChatsType = RecordSet.getInt("chatsType");//微信提醒（QC:98106）

}

if(isrequest.equals("1")) canview=true;

if(creater==userid && creatertype==usertype){
	canview=true;
	canactive=true;
}


RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+""+usertype+flag+requestid+"");
if(RecordSet.next())	canview=true;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next()){
	hasright=1;
}

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==1 ||isremark==1||isurger.equals("true")){
	canview=true;
	canactive=true;
}
String isurgerStr = Util.null2String(request.getParameter("isurger"));
boolean isurger1 = false;
if(canview == false){
	if(isurgerStr.equalsIgnoreCase("true")){
		isurger1 = true;
	}
}

boolean wfmonitor=false;  
wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);

if(!canview && isurger1==false && !wfmonitor){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

%>
<div align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(WorkflowComInfo.getWorkflowname(""+workflowid),user.getLanguage())%></font>
</div>
<form name="frmmain" method="post" action="OvertimeOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<input type=hidden name="isbill" value="1">
<div>
<%if((hasright==1||isremark==1)&&deleted==0){%>
<BUTTON class=btnEdit accessKey=E type=button onclick="doEdit()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></button>
<%}%>
<%if(canactive&&deleted==1){%>
<BUTTON class=btn accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%></button>
<%}%>
</div>
  <br>
  <table class="viewform">
    <colgroup> <col width="20%"> <col width="80%">
    <tr class="Spacing"> 
      <td class="Line1" colspan=2></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
      <td class=field colspan=3> 
      <%=Util.toScreen(requestname,user.getLanguage())%>
        <input type=hidden name=name value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">  
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span id=levelspan>
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
      <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
      </span>
      
      <%if(wfMessageType==1){%>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span id=messagespan>
      <%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%> <%}%>
      <%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%> <%}%>
      <%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%> <%}%>
      </span>
      <%}%>
      <!-- 微信提醒（QC:98106） -->
      <%if(wfChatsType==1){%>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <span id=chatsspan>
      <%if(rqChatsType==0){%><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%> <%}%>
      <%if(rqChatsType==1){%><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%> <%}%> 
      </span>
      <%}%>
      <!-- 微信提醒（QC:98106） -->
      </td>
    </tr>
<tr><td class=Line1 colSpan=2></td></tr>
<%
ArrayList fieldids=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList fieldvalues=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
ArrayList fielddbtypes=new ArrayList();
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
    fielddbtypes.add(Util.null2String(RecordSet.getString("fielddbtype")));
}
RecordSet.executeProc("Bill_HrmTime_SelectByID",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
}

ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}
for(int i=0;i<fieldids.size();i++){
	String fieldid=(String)fieldids.get(i);
	String fieldname=(String)fieldnames.get(i);
	String fieldvalue=(String)fieldvalues.get(i);
	//String isview=(String)isviews.get(i);
	//String isedit=(String)isedits.get(i);
	//String ismand=(String)ismands.get(i);
	String isview="0";
	String isedit="0";
	String ismand="0";
	int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数
    fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(i),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(i),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(i),0);
    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) {
        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
	    isedit=(String)isedits.get(isfieldidindex);    //字段是否可以编辑
	    ismand=(String)ismands.get(isfieldidindex);    //字段是否必须输入
    }
	String fieldhtmltype=(String)fieldhtmltypes.get(i);
	String fieldtype=(String)fieldtypes.get(i);
	String fielddbtype=(String)fielddbtypes.get(i);
	String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
	if(fieldname.equals("manager")) {
	    String tmpmanagerid = ResourceComInfo.getManagerID(creater+"");
	%> <tr>
	      <td <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,user.getLanguage())%> </td>
	      <td class=field>
	      <a href="javaScript:openhrm(<%=tmpmanagerid%>);" onclick='pointerXY(event);'><%=ResourceComInfo.getLastname(tmpmanagerid)%></a>
	      </td>
	   </tr><tr><td class=Line2 colSpan=2></td></tr>
	<%
		continue;
	}
	
	if(isview.equals("1")){
%>
    <tr> 
      <%if(fieldhtmltype.equals("2")){%>
      <td valign=top><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}else{%>
      <td><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
      <%}%>
      <td class=field> 
        <%
	if(fieldhtmltype.equals("1")){%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <%	}		
	else if(fieldhtmltype.equals("2")){%>
        <%=Util.toScreen(fieldvalue,user.getLanguage())%> 
        <%
	}
	else if(fieldhtmltype.equals("3")){
		String showname="" ;
		String showid="" ;
		String sql="";
		String url=BrowserComInfo.getBrowserurl(fieldtype);
		String linkurl = Util.null2String(BrowserComInfo.getLinkurl(fieldtype));
		if(fieldtype.equals("2") || fieldtype.equals("19")){%>
			<%=fieldvalue%>
		<%}
		else if(!fieldtype.equals("161") && !fieldtype.equals("162")){
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			if(fieldvalue.equals(""))
				fieldvalue="0";
			sql="select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				showid = RecordSet.getString(1);
				showname=RecordSet.getString(2);
				if(!linkurl.equals("")){
				%>
			        <a href='<%=linkurl%><%=showid%>'><%}%>
			        <%=Util.toScreen(showname,user.getLanguage())%>
			        <%if(!linkurl.equals("")){%></a><%}
			}
		}else if(fieldtype.equals("161") || fieldtype.equals("162")){
            //自定义单选浏览框，自定义多选浏览框
			Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
			ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
            for(int k=0;k<tempshowidlist.size();k++){
				try{
                    BrowserBean bb=browser.searchById(requestid+"^~^"+(String)tempshowidlist.get(k));
                    String desc=Util.null2String(bb.getDescription());
                    String name=Util.null2String(bb.getName());							
                    String href=Util.null2String(bb.getHref());
                    if(href.equals("")){
                    	showname+="<a title='"+desc+"'>"+name+"</a>&nbsp";
                    }else{
                    	showname+="<a title='"+desc+"' href='"+href+"' target='_blank'>"+name+"</a>&nbsp";
                    }
				}catch (Exception e){
				}
            }
			%>
		        <%=showname%>
			<%
		} else {
			int intfieldvalue=Util.getIntValue(fieldvalue,0);
			String tablename=BrowserComInfo.getBrowsertablename(fieldtype);
			String columname=BrowserComInfo.getBrowsercolumname(fieldtype);
			String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);
			sql="select "+columname+" from "+tablename+" where "+keycolumname+"="+intfieldvalue;
			RecordSet.executeSql(sql);
			RecordSet.next();
			showname=RecordSet.getString(1);
			if(!linkurl.equals("")){
			%>
		        <a href='<%=linkurl%><%=intfieldvalue%>'><%}%><%=Util.toScreen(showname,user.getLanguage())%><%if(!linkurl.equals("")){%></a>
		        <%}
		}
	}
	else if(fieldhtmltype.equals("4")){
	%>
        <input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
        <%}else if(fieldhtmltype.equals("5")){
	%>
	<select class=inputstyle  name="field<%=fieldid%>" DISABLED >
	<%
	rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("selectvalue");
		String tmpselectname = rs.getString("selectname");
	%>
	<option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
	<%}%>
	</select>
        <%}else if(fieldhtmltype.equals("6")){
        %>
          <%
          if(!fieldvalue.equals("")) {
          //modify by xhheng @20050512 for 1803
          %>
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="50%" >
            <COL width="25%" >
            <COL width="25%">
            <%
			String sql=null;
		    int languageidfromrequest=user.getLanguage();

            sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            int imgnum=fieldimgnum;
            boolean isfrist=false;
            RecordSet.executeSql(sql);
            while(RecordSet.next()){
              isfrist=false;  
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),languageidfromrequest) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Integer.parseInt(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
                  isfrist=true;
              %>
            <tr>
                <td colSpan=3>
                    <table cellpadding="0" cellspacing="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="field<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="field<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table>
                      <tr>
                          <td align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>" style="cursor:hand" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                                  if (!isprint) {
                              %>
                              <td align="center"><nobr><a href="#" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1';return false;" style="text-decoration:underline">[<span  style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%></span>]</a></td>
                              <%}%>
                      </tr>
                        </table>
                    </td>
              <%}else{%>
              <tr>
              <td>
              <%=imgSrc%>
              <%if(isprint){%>
              <%=tempshowname%>
              <%}else{ if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&versionId=<%=versionId%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>')"><%=tempshowname%></a>&nbsp
              <%}}%>
              </td>
              <%if(accessoryCount==1 && !isprint){%>
              <td >
                <span id = "selectDownload">
                  <BUTTON class=btn accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1'">
                    <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,languageidfromrequest)%>	(<%=docImagefileSize/1000%>K)
                  </BUTTON>
                </span>
              </td>
              <%}%>
              <td>&nbsp;</td>
              </tr>
              <%}}
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
              </tbody>
              </table>
              <%
            }
        }     // 所有条件判定结束

%>
      </td>
    </tr><tr><td class=Line2 colSpan=2></td></tr>
    <%
   }
}
%>
  </table>
  
  <br>
  <br>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>
 
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
function openAccessory(fileId){
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>");
}    
</script>
</body>
</html>
