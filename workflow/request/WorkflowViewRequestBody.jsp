
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.meeting.MeetingBrowser"%>
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo_vb" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo1" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo1" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo1" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="SpecialField" class="weaver.workflow.field.SpecialFieldInfo" scope="page" />
<jsp:useBean id="docReceiveUnitComInfo_vb" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="workflowJspBean" class="weaver.workflow.request.WorkflowJspBean" scope="page"/>

<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
 userid=user.getUID();  
HashMap specialfield = SpecialField.getFormSpecialField();//特殊字段的字段信息

int body_intervenorright=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"intervenorright"),0);
ArrayList viewfckfields_body=new ArrayList();
%>
<DIV>
<%if(canactive&&deleted==1){%>
<BUTTON class=btnFlow accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%></button>
<%}%>
</DIV>
<%if (!fromFlowDoc.equals("1") && !isprint) {%>
<BR>
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<title><%=Util.toScreen(workflowname,user.getLanguage())%></title>
<!--请求的标题结束 -->
<%}%>
<%if (isprint) {%>
<BR>
<!--打印的时候显示请求的标题  开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--打印的时候显示请求的标题  结束 -->
<%}%>
<BR>
<TABLE class="ViewForm" >
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <%//xwj for td1834 on 2005-05-22
    String isEdit_ = "-1";
    RecordSet.executeSql("select isedit from workflow_nodeform where nodeid = " + String.valueOf(nodeid) + " and fieldid = -1");
    if(RecordSet.next()){
    isEdit_ = "-1";
    }
   
  %>

  <!--新建的第一行，包括说明和重要性 -->
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=2></TD>
  </TR>
  <TR>
    <td class="fieldnameClass">
     <%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>
    </TD>
    <TD class=fieldvalueClass>
       
         <%if(!"1".equals(isEdit_)){//xwj for td1834 on 2005-05-22%>
       <%=Util.toScreenToEdit(requestname,user.getLanguage())%>
       <input type=hidden name=requestname value="<%=Util.toScreenToEdit(requestname,user.getLanguage())%>">
       <%}
       else{%>
        <input type=text class=Inputstyle  name=requestname onChange="checkinput('requestname','requestnamespan')" size=<%=RequestConstants.RequestName_Size%> maxlength=<%=RequestConstants.RequestName_MaxLength%>  value = "<%=Util.toScreenToEdit(requestname,user.getLanguage())%>" >
        <span id=requestnamespan><%if("".equals(Util.toScreenToEdit(requestname,user.getLanguage()))){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
       <%}%>
    
      &nbsp;&nbsp;&nbsp;&nbsp;
      <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
      <%} else if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
      <%} else if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
     
     
    </TD>
  </TR>
    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>

    	<%
    	int rqMessageType=-1;
    	int wfMessageType=-1;
			String sqlWfMessage = "select a.messagetype,b.docCategory,b.messagetype as wfMessageType from workflow_requestbase a,workflow_base b where a.workflowid=b.id and a.requestid="+requestid ;
			RecordSet.executeSql(sqlWfMessage);
			if (RecordSet.next()) {
				wfMessageType=RecordSet.getInt("wfMessageType");
				rqMessageType=RecordSet.getInt("messagetype");
			}
			if(wfMessageType==1){
			%>
			<TR>
				<td class="fieldnameClass" > <%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></TD>
				<td class=fieldvalueClass>
					<%if(rqMessageType==0){%><%=SystemEnv.getHtmlLabelName(17583,user.getLanguage())%><%}%>
		    	<%if(rqMessageType==1){%><%=SystemEnv.getHtmlLabelName(17584,user.getLanguage())%><%}%>
		    	<%if(rqMessageType==2){%><%=SystemEnv.getHtmlLabelName(17585,user.getLanguage())%><%}%>
		    </td>
	    </TR>
    	<TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
     	<%}%>

  <!--第一行结束 -->

<%

//查询表单或者单据的字段,字段的名称，字段的HTML类型和字段的类型（基于HTML类型的一个扩展）
String remindImmediately = "";
String remindBeforeStart = "";
String remindBeforeEnd = "";
String remindBeforeStartV = "";
String remindBeforeEndV = "";
String remindTimesBeforeStart = "";
String remindTimesBeforeEnd = "";
String repeatdays="";
String repeatweeks="";
String rptWeekDays="";
String repeatmonths="";
String repeatmonthdays="";

int temmhour=0;
int temptinme=0;
int temmhourend=0;
int temptinmeend=0;
ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldvalues=new ArrayList();          //字段的值

ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
ArrayList fielddbtypes=new ArrayList();       
ArrayList fieldimgwidths=new ArrayList();
ArrayList fieldimgheights=new ArrayList();
ArrayList fieldimgnums=new ArrayList();
int view_urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
int view_ismonitor=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0);

String forbidAttDownload="";
RecordSet.execute("select forbidAttDownload from workflow_base where id="+workflowid);
if(RecordSet.next()){
   forbidAttDownload = Util.null2String(RecordSet.getString("forbidAttDownload"));
}

if(isbill.equals("0")) {
    RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null) and   t1.langurageid="+user.getLanguage()+" and t2.formid="+formid+" order by t2.fieldorder");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
        fieldorders.add(Util.null2String(RecordSet.getString("fieldorder")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("langurageid")));
    }
    /*
    RecordSet.executeProc("workflow_FieldID_Select",formid+"");

    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString(1)));
        fieldorders.add(Util.null2String(RecordSet.getString(2)));
    }

    RecordSet.executeProc("workflow_FieldLabel_Select",formid+"");
    while(RecordSet.next()){
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
        languageids.add(Util.null2String(RecordSet.getString("languageid")));
    }
    */
}
else {
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
        fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
        fieldtypes.add(Util.null2String(RecordSet.getString("type")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fielddbtypes.add(Util.null2String(RecordSet.getString("fielddbtype")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
        fieldimgwidths.add(Util.null2String(RecordSet.getString("imgwidth")));
        fieldimgheights.add(Util.null2String(RecordSet.getString("imgheight")));
        fieldimgnums.add(Util.null2String(RecordSet.getString("textheight")));
    }
}

// 查询每一个字段的值

if( !isbill.equals("1")) {
    RecordSet.executeProc("workflow_FieldValue_Select",requestid+"");       // 从workflow_form表中查

    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=FieldComInfo.getFieldname((String)fieldids.get(i));
        fieldvalues.add(Util.null2String(RecordSet.getString(fieldname)));
    }
}
else {
    RecordSet.executeSql("select tablename from workflow_bill where id = " + formid) ; // 查询工作流单据表的信息

    RecordSet.next();
    String tablename = RecordSet.getString("tablename") ;
    RecordSet.executeSql("select * from " + tablename + " where id = " + billid) ; // 对于默认的单据表,必须以id作为自增长的Primary key, billid的值就是id. 如果不是,则需要改写这个部分. 另外,默认的单据表必须有 requestid 的字段


    RecordSet.next();
    for(int i=0;i<fieldids.size();i++){
        String fieldname=(String)fieldnames.get(i);
        String tfieldvalue = Util.null2String(RecordSet.getString(fieldname));
        if("repeatType".equalsIgnoreCase(fieldname))
        {
        	tfieldvalue=""+Util.getIntValue(tfieldvalue,0);
        }
        fieldvalues.add(tfieldvalue);
        if("remindImmediately".equals(fieldname))
        {
        	remindImmediately = tfieldvalue;
        }
        if("remindBeforeStart".equals(fieldname))
        {
        	remindBeforeStartV = tfieldvalue;
        }
        if("remindBeforeEnd".equals(fieldname))
        {
        	remindBeforeEndV = tfieldvalue;
        }
        if("remindTimesBeforeStart".equals(fieldname))
        {
    		temptinme=Util.getIntValue(tfieldvalue,0);
        }
        if("remindHoursBeforeStart".equals(fieldname))
        {
        	temmhour=Util.getIntValue(tfieldvalue,0);
        }
        if("remindTimesBeforeEnd".equals(fieldname))
        {
    		temptinmeend=Util.getIntValue(tfieldvalue,0);
        }
        if("remindHoursBeforeEnd".equals(fieldname))
        {
        	temmhourend=Util.getIntValue(tfieldvalue,0);
        }
        if("repeatdays".equalsIgnoreCase(fieldname))
        {
        	repeatdays=tfieldvalue;
        }
        if("repeatweeks".equalsIgnoreCase(fieldname))
        {
        	repeatweeks=tfieldvalue;
        }
        if("rptWeekDays".equalsIgnoreCase(fieldname))
        {
        	rptWeekDays=tfieldvalue;
        }
        if("repeatmonths".equalsIgnoreCase(fieldname))
        {
        	repeatmonths=tfieldvalue;
        }
        if("repeatmonthdays".equalsIgnoreCase(fieldname))
        {
        	repeatmonthdays=tfieldvalue;
        }
    }
}


// 确定字段是否显示
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列

RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");

while(RecordSet.next()){
    isfieldids.add(Util.null2String(RecordSet.getString("fieldid")));
    isviews.add(RecordSet.getString("isview"));
}

String docFlags=(String)session.getAttribute("requestAdd"+requestid);
// 得到每个字段的信息并在页面显示

if(body_intervenorright!=1){
for(int i=0;i<fieldids.size();i++){         // 循环开始

    int tmpindex = i ;
    if(isbill.equals("0")) tmpindex = fieldorders.indexOf(""+i);     // 如果是表单, 得到表单顺序对应的 i

    String fieldid=(String)fieldids.get(tmpindex);  //字段id

    if( isbill.equals("1")) {
        String viewtype = (String)fieldviewtypes.get(tmpindex) ;   // 如果是单据的从表字段,不显示

        if( viewtype.equals("1") ) continue ;
    }

    String isview="0" ;    //字段是否显示
    int isfieldidindex = isfieldids.indexOf(fieldid) ;
    if( isfieldidindex != -1 ) isview=(String)isviews.get(isfieldidindex);    //字段是否显示
    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环


    String fieldname = "" ;                         //字段数据库表中的字段名

    String fieldhtmltype = "" ;                     //字段的页面类型

    String fieldtype = "" ;                         //字段的类型

    String fieldlable = "" ;                        //字段显示名

	String fielddbtype = "";
    int fieldimgwidth=0;                            //图片字段宽度
    int fieldimgheight=0;                           //图片字段高度
    int fieldimgnum=0;                              //每行显示图片个数
    int languageid = 0 ;

    if(isbill.equals("0")) {
        languageid= Util.getIntValue( (String)languageids.get(tmpindex), 0 ) ;    //需要更新

        fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
        fieldtype=FieldComInfo.getFieldType(fieldid);
        fieldlable=(String)fieldlabels.get(tmpindex);
        fieldname=FieldComInfo.getFieldname(fieldid);
        fielddbtype=FieldComInfo.getFielddbtype(fieldid);
		fieldimgwidth=FieldComInfo.getImgWidth(fieldid);
		fieldimgheight=FieldComInfo.getImgHeight(fieldid);
		fieldimgnum=FieldComInfo.getImgNumPreRow(fieldid);
    }
    else {
        languageid = user.getLanguage() ;
        fieldname=(String)fieldnames.get(tmpindex);
        fieldhtmltype=(String)fieldhtmltypes.get(tmpindex);
        fieldtype=(String)fieldtypes.get(tmpindex);
        fielddbtype=(String)fielddbtypes.get(tmpindex);
		fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(tmpindex),0),languageid );
        fieldimgwidth=Util.getIntValue((String)fieldimgwidths.get(tmpindex),0);
		fieldimgheight=Util.getIntValue((String)fieldimgheights.get(tmpindex),0);
		fieldimgnum=Util.getIntValue((String)fieldimgnums.get(tmpindex),0);
    }

    String fieldvalue=(String)fieldvalues.get(tmpindex);

    // 下面开始逐行显示字段  formid=85 会议表单特殊处理
    if(fieldname.equalsIgnoreCase("remindImmediately")||fieldname.equalsIgnoreCase("remindHoursBeforeStart")||fieldname.equalsIgnoreCase("remindHoursBeforeEnd")||
    		fieldname.equalsIgnoreCase("remindBeforeStart")||fieldname.equalsIgnoreCase("remindBeforeEnd")||fieldname.equalsIgnoreCase("remindTimesBeforeStart")||fieldname.equalsIgnoreCase("remindTimesBeforeEnd")
    		||(formid==85&&("repeatdays".equalsIgnoreCase(fieldname)||"repeatweeks".equalsIgnoreCase(fieldname)
    		||"rptWeekDays".equalsIgnoreCase(fieldname)||"repeatmonths".equalsIgnoreCase(fieldname)||"repeatmonthdays".equalsIgnoreCase(fieldname))))
	{
    	//out.println("<input type=hidden name=field"+fieldid+" value='"+fieldvalue+"'>");
    	//System.out.println("<input type=hidden name=field"+fieldid+" value='"+fieldvalue+"'>");
    	continue;
	}
%>
    <tr>
      <td class="fieldnameClass" <%if(fieldhtmltype.equals("2")){%> valign=top <%}%>> <%=Util.toScreen(fieldlable,languageid)%> </td>
      <td class=fieldvalueClass style="word-wrap:break-word;word-break:break-all;">
		
      <%
	 //add by dongping 
		//永乐要求在审批会议的流程中增加会议室报表链接，点击后在新窗口显示会议室报表

		if (fieldtype.equals("118")) { %>           
    <!-- modify by xhheng @20050304 for TD 1691 -->
    <%if(isprint==false){%>
			<a href="/meeting/report/MeetingRoomPlan.jsp" target=blank><%=SystemEnv.getHtmlLabelName(2193,user.getLanguage())%></a>		
    <%}%>
		<% }
        if(fieldhtmltype.equals("1") || fieldhtmltype.equals("2") ){  // 单行,多行文本框

      /*------xwj for td3131 20051116 begin--------*/
      if(fieldhtmltype.equals("1") && fieldtype.equals("4")){
      %>
            <TABLE cols=2 id="field<%=fieldid%>_tab">
                <tr><td>
                    <script language="javascript">
                     window.document.write(milfloatFormat(floatFormat(<%=fieldvalue%>)));
                    </script>
                </td></tr>
                <tr><td>
                    <script language="javascript">
                     window.document.write(numberChangeToChinese(<%=fieldvalue%>));
                    </script>
                </td></tr>
            </table>
      <%}else{%>
      <%
	          if(fieldhtmltype.equals("2") && fieldtype.equals("2")){
	        	if(isprint == true){
%>
	        		  		<span style="word-wrap:break-word"><%=fieldvalue%></span>
<%
	        	}else{
                  session.setAttribute("FCKEDDesc_"+requestid+"_"+user.getUID()+"_"+fieldid+"_-1",fieldvalue);
                  viewfckfields_body.add("FCKiframe"+fieldid);
%>
<input type="hidden" id="FCKiframefieldid" value="FCKiframe<%=fieldid%>"/>
      <iframe id="FCKiframe<%=fieldid%>" name="FCKiframe<%=fieldid%>" src="/workflow/request/ShowFckEditorDesc.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&userid=<%=user.getUID()%>&fieldid=<%=fieldid%>&rowno=-1"  width="100%" height="100%" marginheight="0" marginwidth="0" allowTransparency="true" frameborder="0"></iframe>
<%
	        	}
	          }else{
%>
        <span style="word-break:break-all;word-wrap:break-word"><%=fieldvalue%></span>
      <%}
      }
      /*------xwj for td3131 20051116 end--------*/
        }                                                           // 单行,多行文本框条件结束

        else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
            if(fieldtype.equals("2") || fieldtype.equals("19")){    // 日期和时间

      %>
        <%=fieldvalue%>
      <%
            } else if(!fieldvalue.equals("")) {
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                                   // 值显示的名称
                String showid = "";                                                     // 值


                ArrayList tempshowidlist=Util.TokenizerString(fieldvalue,",");
                if(fieldtype.equals("8") || fieldtype.equals("135")){
                    //项目，多项目
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ProjectInfoComInfo1.getProjectInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("17")){//打印的时候还是按老样子显示

                    weaver.workflow.request.WorkflowJspBean workflowJspBean2 = new weaver.workflow.request.WorkflowJspBean();
				  	workflowJspBean2.setRequestid(requestid);
                	StringBuffer sbf = new StringBuffer(fieldvalue);
                	showname=workflowJspBean2.getMultiResourceShowName(sbf, linkurl,fieldid, user.getLanguage());
                	
                	String[]fieldvalarray = fieldvalue.split(",");
                	List<String> fieldvalList = new ArrayList<String>();
                	for (int z=0; z<fieldvalarray.length; z++) {
                	    if (!fieldvalList.contains(fieldvalarray[z])) {
                	        fieldvalList.add(fieldvalarray[z]);
                	    }
                	}
                	
                	boolean hasGroup = workflowJspBean2.isHasGroup();
                	if (fieldvalList.size() > 0 && hasGroup) {
                	    showname += "&nbsp;<span style='color:#bfbfc0;'>（"+SystemEnv.getHtmlLabelName(83698,user.getLanguage()) + fieldvalList.size() + SystemEnv.getHtmlLabelName(84097,user.getLanguage())+"）</span>";       
                	}
                }else if(fieldtype.equals("1") || fieldtype.equals("17") ||fieldtype.equals("160")||fieldtype.equals("165")||fieldtype.equals("166")){
                    //人员，多人员
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                        	if("/hrm/resource/HrmResource.jsp?id=".equals(linkurl))
                          	{
                        		showname+="<a href='javaScript:openhrm("+tempshowidlist.get(k)+");' onclick='pointerXY(event);'>"+ResourceComInfo1.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                          	}
                        	else
                            	showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+ResourceComInfo1.getResourcename((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=ResourceComInfo1.getResourcename((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("142")){
                    //收发文单位

                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("")){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+docReceiveUnitComInfo_vb.getReceiveUnitName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=docReceiveUnitComInfo_vb.getReceiveUnitName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }
				else if(fieldtype.equals("7") || fieldtype.equals("18")){
                    //客户，多客户
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CustomerInfoComInfo1.getCustomerInfoname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CustomerInfoComInfo1.getCustomerInfoname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("4") || fieldtype.equals("57")|| fieldtype.equals("167")|| fieldtype.equals("168")){
                    //部门，多部门
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"' target='_new'>"+DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DepartmentComInfo1.getDepartmentname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("9") || fieldtype.equals("37")){
                    //文档，多文档
                    for(int k=0;k<tempshowidlist.size();k++){
                        
                        if (fieldtype.equals("9")&&docFlags.equals("1"))
                        {
                        //linkurl="WorkflowEditDoc.jsp?docId=";//????
                       String tempDoc=""+tempshowidlist.get(k);
                       showname+="<a href='javascript:createDoc("+fieldid+","+tempDoc+")'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp<button id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc("+fieldid+","+tempDoc+")></button>";
                       
                        }
                        else
                        {
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"&desrequestid="+desrequestid+"' target='_blank'>"+DocComInfo1.getDocname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=DocComInfo1.getDocname((String)tempshowidlist.get(k))+" ";
                        }
                        }
                    }
                }else if(fieldtype.equals("23")){
                    //资产
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&requestid="+requestid+"' target='_new'>"+CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=CapitalComInfo1.getCapitalname((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("16") || fieldtype.equals("152") || fieldtype.equals("171")){
                    //相关请求
                    for(int k=0;k<tempshowidlist.size();k++){
                        if(!linkurl.equals("") && !isprint){
                            int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                            tempnum++;
                            session.setAttribute("resrequestid"+tempnum,""+tempshowidlist.get(k));
                            session.setAttribute("slinkwfnum",""+tempnum);
                            session.setAttribute("haslinkworkflow","1");
                            showname+="<a href='"+linkurl+tempshowidlist.get(k)+"&wflinkno="+tempnum+"' target='_new'>"+WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+"</a>&nbsp";
                        }else{
                        showname+=WorkflowRequestComInfo1.getRequestName((String)tempshowidlist.get(k))+" ";
                        }
                    }
                }else if(fieldtype.equals("269")){
                    
                	showname = Util.toScreen(MeetingBrowser.getRemindNames(fieldvalue, user.getLanguage()),user.getLanguage());
                    
                }else if(fieldtype.equals("161") || fieldtype.equals("162")){
                    //自定义单选浏览框，自定义多选浏览框
					Browser browser=(Browser)StaticObj.getServiceByFullname(fielddbtype, Browser.class);
                    for(int k=0;k<tempshowidlist.size();k++){
						try{
                            BrowserBean bb=browser.searchById((String)tempshowidlist.get(k));
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
                }else{
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表

                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段

                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段


                    if(fieldvalue.indexOf(",")!=-1){
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }
                    RecordSet.executeSql(sql);
                    while(RecordSet.next()){
					   if(fieldtype.equals("263")){
							 showname +=Util.toScreen(RecordSet.getString(2),user.getLanguage())+" ";
					   }else{
                          if(!linkurl.equals("") && !isprint){
                            showname += "<a href='"+linkurl+RecordSet.getString(1)+"' target='_new'>"+Util.toScreen(RecordSet.getString(2),user.getLanguage())+"</a>&nbsp";
                          }else{
                            showname +=Util.toScreen(RecordSet.getString(2),user.getLanguage())+" ";
                          }
					   }
                    }    // end of while
                }
            %>
                    <%=showname%>
                    
          <%	
            }
        
            
 	       if("remindTypeNew".equals(fieldname))
 	       {
 	    	  if("".equals(fieldvalue)){
 	    		  out.println(SystemEnv.getHtmlLabelName(19782,user.getLanguage()));
 	    	  }else{
 	       %>
 	       <TR style="height:1px;" id="remindTimeLine1" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>>
 				<TD class="Line2" colSpan="2"></TD>
 			</TR>
 	       <TR id="remindTime1" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>>
 				<td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(81917,user.getLanguage())%></TD>
 				<TD class=fieldvalueClass>
 					<INPUT type="checkbox" name="remindImmediately" value="1" <% if("1".equals(remindImmediately)) { %>checked<% } %> DISABLED>
 				</TD>
 			</TR>
 	       <TR style="height:1px;" id="remindTimeLine" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>>
 				<TD class="Line2" colSpan="2"></TD>
 			</TR>
 	       <TR id="remindTime" <% if("".equals(fieldvalue)) {%> style="display:none" <% } %>>
 				<td class="fieldnameClass"><%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%></TD>
 				<TD class=fieldvalueClass>
 					<INPUT type="checkbox" name="remindBeforeStart" value="1" <% if("1".equals(remindBeforeStartV)) { %>checked<% } %> DISABLED>
 						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
 						<INPUT class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=5 value="<%= temmhour %> " DISABLED>
 						<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
 						<INPUT class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="<%= temptinme %>" DISABLED>
 						<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
 					<br>
 					<INPUT type="checkbox" name="remindBeforeEnd" value="1" <% if("1".equals(remindBeforeEndV)) { %>checked<% } %> DISABLED>
 	
 						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
 						<INPUT class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%= temmhourend%>" DISABLED>
 						<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
 						<INPUT class="InputStyle" type="input" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size=5 value="<%= temptinmeend %>" DISABLED>
 						<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
 				</TD>
 			</TR>
 	      <% } 
 	    	}
        }                                                       // 浏览按钮条件结束
        else if(fieldhtmltype.equals("4")) {                    // check框

       %>
        <input type=checkbox value=1 name="field<%=fieldid%>" DISABLED <%if(fieldvalue.equals("1")){%> checked <%}%>>
       <%
        }                                                       // check框条件结束

        else if(fieldhtmltype.equals("5")){                     // 选择框   select
       %>
         <select name="field<%=fieldid%>" DISABLED ><%
		   //如果是编辑状态就出现一个空白选项.不是编辑状态就是已办,办结等页面,不显示空白...
		if("1".equals(isEdit_)||"".equals(fieldvalue)){%>
		<option value=""></option> <!--added by xwj for td3297 20051130 --> 
       <%}  
            // 查询选择框的所有可以选择的值

            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+isbill);
            while(rs.next()){
                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
       %>
        <option value="<%=tmpselectvalue%>"  <%if(fieldvalue.equals(tmpselectvalue)){%> selected <%}%>><%=tmpselectname%></option>
       <%
            }
       %>
        </select>
       <%
       	
       if("repeatType".equalsIgnoreCase(fieldname)&&formid==85&&!"0".equals(fieldvalue))
	    {
   	   %> 
   	   <TR id="repeattr" <% if(!"1".equals(fieldvalue) && !"2".equals(fieldvalue) && !"3".equals(fieldvalue)) {%> style="display:none" <% } %>  class="Spacing" style="height:1px;">
			<TD class="Line2" colSpan="6"></TD>
		</TR>
		<TR id="dayrepeat" <% if(!"1".equals(fieldvalue) ) {%> style="display:none" <% } %>>
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
			<%=repeatdays%><span name="repeatdaysSpan" id="repeatdaysSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
		  </TD>
		</TR>

		<TR id="weekrepeat" <% if(!"2".equals(fieldvalue) ) {%> style="display:none" <% } %>>
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
			<%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
			<span name="repeatweeksSpan" id="repeatweeksSpan"><%=repeatweeks %></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%><br>
			<% rptWeekDays = ","+rptWeekDays+",";
				String remindTypeStatus = " disabled";%>
			<INPUT id="rptWeekDay" type="checkbox"  name="rptWeekDay" value="1" <%if(rptWeekDays.indexOf(",1,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16100,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox" name="rptWeekDay" value="2" <%if(rptWeekDays.indexOf(",2,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16101,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox" name="rptWeekDay" value="3" <%if(rptWeekDays.indexOf(",3,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16102,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox" name="rptWeekDay" value="4" <%if(rptWeekDays.indexOf(",4,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16103,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox" name="rptWeekDay" value="5" <%if(rptWeekDays.indexOf(",5,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16104,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox" name="rptWeekDay" value="6" <%if(rptWeekDays.indexOf(",6,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16105,user.getLanguage())%>
			<INPUT id="rptWeekDay" type="checkbox" name="rptWeekDay" value="7" <%if(rptWeekDays.indexOf(",7,")!=-1){%>checked<%}%> <%=remindTypeStatus %>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(16106,user.getLanguage())%>
			
		  </TD>
		</TR>
		<TR id="monthrepeat"  <% if(!"3".equals(fieldvalue) ) {%> style="display:none" <% } %>>
		  <TD class="fieldnameClass"> 
			<!--重复间隔 -->
			<%=SystemEnv.getHtmlLabelName(25898,user.getLanguage())%>
		  </TD>
		  <TD class="fieldvalueClass"> 
		    <%=SystemEnv.getHtmlLabelName(21977,user.getLanguage())%>&nbsp;
		    <%=repeatmonths%>
			<span name="repeatmonthsSpan" id="repeatmonthsSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(25901,user.getLanguage())%>&nbsp;
			<%=repeatmonthdays%>
			<span name="repeatmonthdaysSpan" id="repeatmonthdaysSpan"></span>&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
	     <%}
        //add by xhheng @20050318 for 附件上传
        }else if(fieldhtmltype.equals("6")){
        %>
          <%
          if(!fieldvalue.equals("")) {
        	  boolean nodownloadnew = true;
       		  int AttachmentCountsnew = 0;
       		  int linknumnew= -1;  
          //modify by xhheng @20050512 for 1803
          %>
          <TABLE cols=3 id="field<%=fieldid%>_tab">
            <TBODY >
            <COL width="70%" >
            <COL width="17%" >
            <COL width="13%">
            <%
			  if("-2".equals(fieldvalue)){%>
			<tr>
				<td colSpan=3><font color="red">
				<%=SystemEnv.getHtmlLabelName(21710,user.getLanguage())%></font>
				</td>
			</tr>
			  <%}else{
            sql="select id,docsubject,accessorycount,SecCategory from docdetail where id in("+fieldvalue+") order by id asc";
            int linknum=-1;
            int imgnum= fieldimgnum;
            boolean isfrist=false;
            RecordSet.executeSql(sql);
            int AttachmentCounts=RecordSet.getCounts();
            AttachmentCountsnew = AttachmentCounts;
            while(RecordSet.next()){
              isfrist=false;
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);
              String SecCategory=Util.null2String(RecordSet.getString(4));
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
              boolean nodownload=SecCategoryComInfo_vb.getNoDownload(SecCategory).equals("1")?true:false;
              nodownloadnew = nodownload;
              String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              if(fieldtype.equals("2")){
              if(linknum==0){
                  isfrist=true;
              %>
           <% 
           if(!"1".equals(forbidAttDownload) && !nodownload && AttachmentCounts>1 && !isprint && view_urger==0 && view_ismonitor==0){
           %>
            <tr> 
              <td colSpan=3><nobr>
                  <button style="color:#123885;border:0px;line-height:20px;font-size:12px;padding:3px;background: #fff" class=wffbtn type=button accessKey=1  onclick="top.location='/weaver/weaver.file.FileDownload?fieldvalue=<%=fieldvalue%>&download=1&downloadBatch=1&requestid=<%=requestid%>&fromrequest=1'">
                    [<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>]
                  </button>             
              </td>
            </tr>
            <%}%>
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
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
                                  if (!nodownload&& !isprint && view_urger==0 && view_ismonitor==0) {
                              %>
                              <td align="center"><nobr><a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag(<%=showid%>);top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1';return false;"><span style="cursor:hand;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a></td>
                              <%
                                  }
                              %>
                      </tr>
                        </table>
                    </td>
              <%}else{
              %>
              <tr style="border-bottom:1px solid #e6e6e6;height: 40px;">
              <td class="fieldvalueClass" valign="middle" style="word-break:normal;word-wrap:normal;">
              <div style="float:left;height:40px; line-height:38px;width:270px;" class="fieldClassChange">
              <div style="float:left;width:20px;height:40px; line-height:38px;">
              <span style="display:inline-block;vertical-align: middle;">
              <%=imgSrc%>
              </span>
              </div>
              <div style="float:left;padding-left:5px;">
              <%if(isprint){%>
            	  <span style="display:inline-block;width:245px;height:30px;padding-bottom:10px;vertical-align: middle;">
              <%=tempshowname%>
              <%}else{ %>
              	  <span style="display:inline-block;width:245px;height:30px;padding-bottom:10px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;vertical-align: middle;">
            	  <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
              
                <a style="cursor:pointer;color:#8b8b8b!important;margin-top:1px;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <!--<a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp-->
                <a style="cursor:pointer;color:#8b8b8b!important;margin-top:1px;" onmouseover="changefileaon(this)" onmouseout="changefileaout(this)" href="javascript:addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp
              <%}}%>
              </span>
              </div>
              </div>
              </td>
              <%if(((!fileExtendName.equalsIgnoreCase("xls")&&!fileExtendName.equalsIgnoreCase("doc")&&!fileExtendName.equalsIgnoreCase("xlsx")&&!fileExtendName.equalsIgnoreCase("docx"))||!nodownload) && !isprint && view_urger==0 && view_ismonitor==0){%>
              <td >
              <div style="float:left;height:40px; line-height:38px;width:70px;padding-left:10px;" class="fieldClassChange">
                <span id = "selectDownload">
                
                <span style="width:45px;display:inline-block;color:#898989;margin-top:1px;"><%=docImagefileSize / 1000%>K</span>
				 <a style="display:inline-block;cursor:pointer;vertical-align:middle;width:20px;height:20px;background-image:url('/images/ecology8/workflow/fileupload/upload_wev8.png');" onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1'" title="<%=SystemEnv.getHtmlLabelName(31156,user.getLanguage())%>"></a>
                </span>
                </div>
              </td>
              <%}%>
              <td>&nbsp;</td>
              </tr>
              <%}}
              linknumnew = linknum;
            if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}}%>
            
            <tr>
            <td class="fieldvalueClass" valign="middle" colSpan=3> 
            	<% 
                   //if(isDownloadAll && AttachmentCounts>1 && (linknum+1)==AttachmentCounts){
                   if(!"1".equals(forbidAttDownload) && !nodownloadnew && AttachmentCountsnew>1 && linknumnew>=0){
                 %>
                 <span onclick="top.location='/weaver/weaver.file.FileDownload?fieldvalue=<%=fieldvalue%>&download=1&downloadBatch=1&requestid=<%=requestid%>&fromrequest=1'" style="display:inline-block;height:25px;cursor:pointer;text-align:center;vertical-align:middle;line-height:25px;background-color: #6bcc44;color:#ffffff;padding:0 20px 0 14px;" onmouseover="uploadbuttonon(this)" onmouseout="uploadbuttonout(this)"><img src='/images/ecology8/workflow/fileupload/uploadall_wev8.png' style="width:20px;height:20px;padding-bottom:2px;" align=absMiddle><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>
                 <%}%>
	         </td>
            </tr>
              </tbody>
              </table>
              <%
            }
        }     // 选择框条件结束 所有条件判定结束

       else if(fieldhtmltype.equals("7")){//特殊字段
           if(isbill.equals("0")) out.println(Util.null2String((String)specialfield.get(fieldid+"_0")));
           else out.println(Util.null2String((String)specialfield.get(fieldid+"_1")));
       } 
	   else if(fieldhtmltype.equals("9")){	//位置字段
			String locateData = LocateUtil.joinLoctionsField(workflowid,requestid,fieldname,fieldid,fieldvalue,user);
			String[] htmljs = locateData.split(LocateUtil.SPLIT_HTMLJS);
			out.println(htmljs[0]);
			out.println("<script language='javascript'>\n"+htmljs[1] + "</script>\n");
	   }
       %>
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
<%
}       // 循环结束
}
%>

</TABLE>

<%
//add by mackjoe at 2006-06-07 td4491 有明细时才加载

boolean  hasdetailb=false;
if(!(isbill.equals("1")&&(formid==7||formid==156||formid==157||formid==158||formid==159||formid==19||formid==18||formid==224||formid==201||formid==220))){
if(isbill.equals("0")) {
    RecordSet.executeSql("select count(*) from workflow_formfield  where isdetail='1' and formid="+formid);
}else{
    RecordSet.executeSql("select count(*) from workflow_billfield  where viewtype=1 and billid="+formid);
}
if(RecordSet.next()){
    if(RecordSet.getInt(1)>0) hasdetailb=true;
}
}
if(hasdetailb){
%>

<%@ include file="/workflow/request/WorkflowViewRequestDetailBody.jsp" %>

<%}%>
<script>
function createDoc(fieldbodyid,docVlaue)
{
	
   /*
   for(i=0;i<=1;i++){
  		parent.document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.document.all("oTDtype_"+i).className="cycleTD";
  	}
  	parent.document.all("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.document.all("oTDtype_1").className="cycleTDCurrent";
  	*/
  	frmmain.action = "RequestDocView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
      	if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "1";//标识点正文

        document.frmmain.src.value='save';
        //附件上传
        StartUploadAll();
        checkuploadcomplet();
		parent.clicktext();//切换当前tab页到正文页面 
		if(document.getElementById("needoutprint")) document.getElementById("needoutprint").value = "";//标识点正文   
    }


}

function openAccessory(fileId){ 
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&fromrequest=1");
}
//** iframe自动适应页面 **//

    function dyniframesize()
    {
    var dyniframe;
    <%
    for (int i=0; i<viewfckfields_body.size(); i++)
    {%>
    if (document.getElementById)
    {
        //自动调整iframe高度
        dyniframe = document.getElementById("<%=viewfckfields_body.get(i)%>");
        if (dyniframe && !window.opera)
        {
            if (dyniframe.contentDocument && dyniframe.contentDocument.body.offsetHeight){ //如果用户的浏览器是NetScape
                dyniframe.height = dyniframe.contentDocument.body.offsetHeight+20;
            }else if (dyniframe.Document && dyniframe.Document.body.scrollHeight){ //如果用户的浏览器是IE
                //alert(dyniframe.name+"|"+dyniframe.Document.body.scrollHeight);
                dyniframe.Document.body.bgColor="transparent";
                dyniframe.height = dyniframe.Document.body.scrollHeight+20;
            }
        }
    }
    <%}%>
    <%if(fieldids.size()<1){%>
    alert("<%=SystemEnv.getHtmlLabelName(22577,user.getLanguage())%>");
    <%}%>    
    }
    if (window.addEventListener)
    window.addEventListener("load", dyniframesize, false);
    else if (window.attachEvent)
    window.attachEvent("onload", dyniframesize);
    else
    window.onload=dyniframesize;
</script>
<input type=hidden name="desrequestid" value="<%=desrequestid%>">           <!--父流程id-->
<input type=hidden name="requestid" value="<%=requestid%>">           <!--请求id-->
<input type=hidden name="workflowid" value="<%=workflowid%>">       <!--工作流id-->
<input type=hidden name="nodeid" value="<%=nodeid%>">               <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">           <!--当前节点类型-->
<input type=hidden name="src" value="active">                       <!--操作类型 save和submit,reject,delete,active-->
<input type=hidden name="iscreate" value="0">                     <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">               <!--表单的id-->
<input type=hidden name ="isbill" value="<%=isbill%>">            <!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">             <!--单据id-->

<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>