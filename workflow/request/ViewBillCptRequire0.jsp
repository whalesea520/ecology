<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
ArrayList fieldids=new ArrayList();
ArrayList fieldnames=new ArrayList();
ArrayList fieldvalues=new ArrayList();
ArrayList fieldlabels=new ArrayList();
ArrayList fieldhtmltypes=new ArrayList();
ArrayList fieldtypes=new ArrayList();
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

ArrayList isviews=new ArrayList();
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
 <table class=liststyle cellspacing=1   cols=10 id="oTable" width="100%"><COLGROUP>
<TR class="Title">
    	  <TH colSpan=8 align="left">
    	  <%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%>
    	  </TH>
	</TR>
   <tr class=header> 
    	   <%
String dsptypes="";
int tmpcount = 1;
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
	if(tmpcount<10){
		dsptypes +=",0"+tmpcount+"_"+isview;
	}else{
		
		dsptypes +=","+tmpcount+"_"+isview;
	}
	tmpcount++;
	
%>
    	  
            <td <%if(isview.equals("0")){%> style="display:none" <%}%>><%=Util.toScreen(fieldlable,user.getLanguage())%></td>
<%}%>
            </tr>
    	   
            <%
            
	           int linecolor=0;  
	RecordSet.executeProc("bill_CptRequireDetail_Select",billid+"");
	while(RecordSet.next()){
            %>
            <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> > 
            <td <%if(dsptypes.indexOf("01_0")!=-1){%> style="display:none" <%}%>><%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(RecordSet.getString("cpttype")),user.getLanguage())%></td>
            <td <%if(dsptypes.indexOf("02_0")!=-1){%> style="display:none" <%}%>><a href='/cpt/capital/CptCapital.jsp?id=<%=RecordSet.getString("cptid")%>'><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSet.getString("cptid")),user.getLanguage())%> </a></td>
            <td <%if(dsptypes.indexOf("03_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("number_n")%></td>
            <td <%if(dsptypes.indexOf("04_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("unitprice")%></td>
            <td <%if(dsptypes.indexOf("05_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("needdate")%></td>
            <td <%if(dsptypes.indexOf("06_0")!=-1){%> style="display:none" <%}%>><%=Util.toScreen(RecordSet.getString("purpose"),user.getLanguage())%></td>
            <td <%if(dsptypes.indexOf("07_0")!=-1){%> style="display:none" <%}%>><%=Util.toScreen(RecordSet.getString("cptdesc"),user.getLanguage())%></td>
            <td <%if(dsptypes.indexOf("08_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("buynumber")%></td>
            <td <%if(dsptypes.indexOf("09_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("adjustnumber")%></td>
            <td <%if(dsptypes.indexOf("10_0")!=-1){%> style="display:none" <%}%>><%=RecordSet.getString("fetchnumber")%></td>
           </tr>
            <%if(linecolor==0) linecolor=1;
          else linecolor=0;}%>
  </table>
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>
