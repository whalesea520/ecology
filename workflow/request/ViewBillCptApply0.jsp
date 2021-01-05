<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
ArrayList fieldids = new ArrayList();
ArrayList fieldnames = new ArrayList();
ArrayList fieldvalues = new ArrayList();
ArrayList fieldlabels = new ArrayList();
ArrayList fieldhtmltypes = new ArrayList();
ArrayList fieldtypes = new ArrayList();
ArrayList viewtypes=new ArrayList();
String formid = Util.null2String(request.getParameter("formid"));
String billid = Util.null2String(request.getParameter("billid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
	if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fieldlabels.add(RecordSet.getString("fieldlabel"));
	fieldhtmltypes.add(RecordSet.getString("fieldhtmltype"));
	fieldtypes.add(RecordSet.getString("type"));
	viewtypes.add(RecordSet.getString("viewtype"));
}
RecordSet.executeProc("bill_CptApplyMain_Select",billid+"");
RecordSet.next();
for(int i=0;i<fieldids.size();i++){
	String fieldname=(String)fieldnames.get(i);	
	fieldvalues.add(RecordSet.getString(fieldname));
}

ArrayList isviews = new ArrayList();
ArrayList isedits=new ArrayList();
ArrayList ismands=new ArrayList();
RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
while(RecordSet.next()){
	String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
	int thefieldidindex = fieldids.indexOf( thefieldid ) ;
	if( thefieldidindex == -1 ) continue ;
	isviews.add(RecordSet.getString("isview"));
	isedits.add(RecordSet.getString("isedit"));
	ismands.add(RecordSet.getString("ismandatory"));
}

%>
<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage()) %>'>
		<wea:item attributes="{\"isTableList\":\"true\"}">
<table class="ListStyle" cellspacing=1   cols=10 id="oTable" >
<tr class=header> 
	   <%
String dsptypes="";
int tmpcount = 1;
int viewCount = 0; 
for(int ii=0;ii<fieldids.size();ii++){
String isview1=(String)isviews.get(ii);
if(isview1.equals("1")) viewCount++;
}
for(int i=0;i<fieldids.size();i++){
String fieldname=(String)fieldnames.get(i);
String fieldid=(String)fieldids.get(i);
String isview=(String)isviews.get(i);
String isedit=(String)isedits.get(i);
String ismand=(String)ismands.get(i);
String fieldhtmltype=(String)fieldhtmltypes.get(i);
String fieldtype=(String)fieldtypes.get(i);
String fieldlable=SystemEnv.getHtmlLabelName(Util.getIntValue((String)fieldlabels.get(i),0),user.getLanguage());
String viewtype = (String)viewtypes.get(i);
if(viewtype.equals("0"))
	continue;

dsptypes +=","+tmpcount+"_"+isview;
tmpcount++;

%>
	  
		<td <%if(isview.equals("0")){%> style="display:none" <%}%> width="<%=viewCount==0?0:100/viewCount%>%"><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
</tr>
	   
		<%
		
		   int linecolor=0;  
RecordSet.executeProc("bill_CptApplyDetail_Select",billid+"");
while(RecordSet.next()){
		%>
		<tr <%if(linecolor==0){%> class=DataLight <%} else {%> class=DataDark <%}%> > 
		<td <%if(dsptypes.indexOf(","+"1_0")!=-1){%> style="display:none" <%}%>><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cpttype")),user.getLanguage())%></td>
		<td <%if(dsptypes.indexOf(","+"2_0")!=-1){%> style="display:none" <%}%>><a href="javascript:openFullWindowForXtable('/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("cptid")%>')"><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage())%> </a></td>
		<td <%if(dsptypes.indexOf(","+"3_0")!=-1){%> style="display:none" <%}%>>
		<a href="javascript:openFullWindowForXtable('/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("capitalid")%>')" ><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("capitalid")),user.getLanguage())%> </a></td>
		<td <%if(dsptypes.indexOf(","+"4_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("number_n")%></td>
		<td <%if(dsptypes.indexOf(","+"5_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("unitprice")%></td>
		<td <%if(dsptypes.indexOf(","+"6_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("amount")%></td>
		<td <%if(dsptypes.indexOf(","+"7_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("cptspec")%></td>
		<td <%if(dsptypes.indexOf(","+"8_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("needdate")%></td>
		<td <%if(dsptypes.indexOf(","+"9_0")!=-1){%> style="display:none" <%}%>><%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%></td>
		<td <%if(dsptypes.indexOf(","+"10_0")!=-1){%> style="display:none" <%}%>><%=Util.toScreen(RecordSet.getString("cptdesc"),user.getLanguage())%></td>            
	   </tr>
		<%if(linecolor==0) linecolor=1;
	  else linecolor=0;}%>
</table>
</wea:item>
</wea:group>
</wea:layout>
</body>
</html>
