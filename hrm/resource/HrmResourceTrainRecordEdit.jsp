<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
</script>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceTrainRecordEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;//培训记录ID
String id = Util.null2String(request.getParameter("resourceid")) ;//培训人员ID
String trainrecordid = paraid ;
String traintypeid = Util.null2String(request.getParameter("traintypeid")) ;//培训内容ID

RecordSet.executeProc("HrmTrainRecord_SelectByID",trainrecordid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String trainstartdate = Util.toScreen(RecordSet.getString("trainstartdate"),user.getLanguage());
String trainenddate = Util.toScreen(RecordSet.getString("trainenddate"),user.getLanguage());
String traintype = Util.null2String(RecordSet.getString("traintype"));
int trainrecord = Util.getIntValue(RecordSet.getString("trainrecord"));
int trainhour = (int)RecordSet.getFloat("trainhour");
String trainunit = Util.toScreenToEdit(RecordSet.getString("trainunit"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(816,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=frmain action=HrmResourceTrainRecordOperation.jsp? method=post>
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="trainrecordid" value="<%=trainrecordid%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></wea:item>
      <wea:item>         
        <%=trainstartdate%>        
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></wea:item>
      <wea:item> 
        <%=trainenddate%>        
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></wea:item>
      <wea:item> 
        <%=Util.toScreen(TrainComInfo.getTrainname(traintype),user.getLanguage())%>         
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></wea:item>
      <wea:item>         
        <%if(trainhour==0){%><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%> <%}%>
        <%if(trainhour==1){%> <%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%>  <%}%>
        <%if(trainhour==2){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%>   <%}%>
        <%if(trainhour==3){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%>   <%}%>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></wea:item>
      <wea:item>         
        <%=TrainResourceComInfo.getResourcename(trainunit)%>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></wea:item>
      <wea:item>        
        <%if(trainrecord==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(trainrecord==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(trainrecord==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(trainrecord==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(trainrecord==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
      </wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16133,user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'full','isTableList':'true'}">
		<table class=ListStyle cellspacing=1 >
	  <COLGROUP> 
	    <COL width="15%">
	    <COL width="70%">
	    <COL width="15%">
	  <tbody>
	    <tr class=header>
	    <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>    
	    <th><%=SystemEnv.getHtmlLabelName(16134,user.getLanguage())%></th>   
	    <th><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></th>     
	  </tr> 
	   
	<%
	  int line = 0;
	  String sql = "select * from HrmTrainDay where trainid="+traintypeid+" order by id asc";//trainid:培训活动id
	  RecordSet.executeSql(sql);
	  while(RecordSet.next()){
	    String dayid = RecordSet.getString("id");
	    String data = RecordSet.getString("traindate");
	    String content = RecordSet.getString("daytraincontent");
	    sql = "select isattend from HrmTrainActor where traindayid="+dayid+" and resourceid = "+id;//isattend:是否参与
	    rs.executeSql(sql);
	    rs.next();
	    int isattend = Util.getIntValue(rs.getString("isattend"));
	    if(line%2 ==0){
	%>
	   <tr class=datalight>
	<%    
	    }else{
	%>
	   <tr class=datadark>
	<%    
	    }
	%>
	   <td><%=data%></td>
	   <td><%=content%></td>
	   <td> 
	     <%if(isattend==1){%><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage())%><%}%>
	     <%if(isattend==0){%><%=SystemEnv.getHtmlLabelName(16135,user.getLanguage())%><%}%>
	   </td>
	<%    
	  }
	%>   
	</tbody>
</table>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
 <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY>
</HTML>
