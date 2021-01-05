 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.math.*" %>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfobill" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<form name="frmmain" method="post" action="BillExpenseOperation.jsp">
   <jsp:include page="WorkflowViewRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="languageid" value="<%=languageidtemp%>" />
               
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="requestlevel" value="<%=requestlevel%>" />
                <jsp:param name="isbill" value="1" />
                <jsp:param name="billid" value="<%=billid%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="isprint" value="<%=isprint%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="nodetype" value="<%=nodetype%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="desrequestid" value="<%=desrequestid%>" />
                <jsp:param name="isrequest" value="<%=isrequest%>" />
                <jsp:param name="isurger" value="<%=isurger%>" />
                <jsp:param name="wfmonitor" value="<%=wfmonitor%>" />
            </jsp:include>
            
            
            <%
ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldorders = new ArrayList();        //字段显示顺序队列 (单据文件不需要)
ArrayList languageids=new ArrayList();          //字段显示的语言(单据文件不需要)
ArrayList fieldlabels=new ArrayList();          //单据的字段的label队列
ArrayList fieldhtmltypes=new ArrayList();       //单据的字段的html type队列
ArrayList fieldtypes=new ArrayList();           //单据的字段的type队列
ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
ArrayList fieldvalues=new ArrayList();          //字段的值
ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)
            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // 如果是单据的主表字段,不显示

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }
// 确定字段是否显示
ArrayList isfieldids=new ArrayList();              //字段队列
ArrayList isviews=new ArrayList();              //字段是否显示队列

            // 确定字段是否显示，是否可以编辑，是否必须输入
            isfieldids.clear() ;              //字段队列
            isviews.clear() ;              //字段是否显示队列

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
            }

            if( colcount != 0 ) colwidth = 95/colcount ;

            ArrayList viewfieldnames = new ArrayList() ;

            BigDecimal countexpense = new BigDecimal("0") ;
            BigDecimal countrealfeefum = new BigDecimal("0") ;
            int countaccessory = 0 ;
            boolean isttLight = false;
    %>
    

<wea:layout>
	<wea:group attributes="{\"groupOperDisplay\":\"none\"}" context='<%=SystemEnv.getHtmlLabelName(27575,user.getLanguage()) %>'>
		<wea:item type="groupHead">
			&nbsp;
		</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}">
            <table class="ListStyle" cellspacing=1   id="oTable">
              <COLGROUP> 
              <tr class=header> 
              <td width="5%">&nbsp;</td>
   <%
            
            // 得到每个字段的信息并在页面显示

            for(int i=0;i<fieldids.size();i++){         // 循环开始

                String fieldid=(String)fieldids.get(i);  //字段id
                String isview="0" ;    //字段是否显示

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                }
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                
                String fieldname = "" ;                         //字段数据库表中的字段名
                String fieldlable = "" ;                        //字段显示名
                int languageid = 0 ;                                                   
                
                fieldname=(String)fieldnames.get(i);
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
<%          }
%>
			  </tr>
<%          

            RecordSet.executeProc("Bill_ExpenseDetali_SelectByID",billid+"");
            while(RecordSet.next()) {
                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'> 
                <td width="5%">&nbsp;</td>
<%
                for(int i=0;i<fieldids.size();i++){         // 循环开始

                    String fieldid=(String)fieldids.get(i);  //字段id
                    String isview="0" ;    //字段是否显示

                    int isfieldidindex = isfieldids.indexOf(fieldid) ;
                    if( isfieldidindex != -1 ) {
                        isview=(String)isviews.get(isfieldidindex);    //字段是否显示
                    }
                    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                    
                    String fieldname = (String)fieldnames.get(i);   //字段数据库表中的字段名
                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;
                    
                    
                    if( fieldname.equals("feetypeid")){
                    	String key = fieldvalue;
                        fieldvalue = Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(fieldvalue),user.getLanguage()) ;
                        if(!"".equals(fieldvalue)){
                        	//查询父级科目
    						String sqlSet = "select enableDispalyAll,separator from FnaSystemSet";//查询
    						rs.executeSql(sqlSet);
    						int enableDispalyAll=0;
    						String separator ="";
    						while(rs.next()){
    							enableDispalyAll = rs.getInt("enableDispalyAll");
    							separator = Util.null2String(rs.getString("separator"));
    						}
    						if(enableDispalyAll==1){
    							fieldvalue = BudgetfeeTypeComInfo.getSubjectFullName(key, separator);;
    						}
                        }
                    }
                    else if( fieldname.equals("relatedcrm"))
                    fieldvalue =  "<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+fieldvalue+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage())+"</a>";
                    else if( fieldname.equals("relatedproject"))
                        
                    fieldvalue =   "<a href='/proj/data/ViewProject.jsp?ProjID="+fieldvalue+"'>"+Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage())+"</a>";

					else if( fieldname.equals("relaterequest")){
                    int tempnum=Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
                    tempnum++;
                    session.setAttribute("resrequestid"+tempnum,fieldvalue);
                    session.setAttribute("slinkwfnum",""+tempnum);
                    session.setAttribute("haslinkworkflow","1");
                    fieldvalue =   "<a href='/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+fieldvalue+"&wflinkno="+tempnum+"' target='_new'>"+Util.toScreen(WorkflowRequestComInfobill.getRequestName(fieldvalue),user.getLanguage())+"</a>";

                    }else if( fieldname.equals("detailremark"))
                        fieldvalue=Util.toScreen(fieldvalue,user.getLanguage()) ;
                    else if( fieldname.equals("feesum")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else
                            countexpense = countexpense.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }
                    else if( fieldname.equals("realfeesum")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else 
                            countrealfeefum = countrealfeefum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }
                    else if( fieldname.equals("accessory")) {
                        if( Util.getIntValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else countaccessory += Util.getIntValue(fieldvalue,0) ;
                    }
                    else if( fieldname.equals("invoicenum"))
                        fieldvalue=Util.toScreen(fieldvalue,user.getLanguage()) ;
%>
                <td><%=fieldvalue%></td>
<%              }   %>
              </tr>
<%          }   %>
              <tr class="header" style="FONT-WEIGHT: bold; COLOR: red"> 
                <td>合计</td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;
%>
                <td><% if(thefieldname.equals("accessory")) {
                        String countaccessorystr = "" ;
                        if( countaccessory != 0 ) countaccessorystr = ""+ countaccessory ;
                    %><%=countaccessorystr%>
                    <% } else if(thefieldname.equals("feesum")) {
                        countexpense = countexpense.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String countexpensestr = "" ;
                        if( countexpense.doubleValue() != 0 ) countexpensestr = ""+countexpense.toString() ;
                    %><%=countexpensestr%>
                    <% } else if(thefieldname.equals("realfeesum")) {
                        countrealfeefum = countrealfeefum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String countrealfeefumstr = "" ;
                        if( countrealfeefum.doubleValue() != 0 ) countrealfeefumstr = ""+countrealfeefum.toString() ;
                    %><%=countrealfeefumstr%>
                    <% } else { %>&nbsp;<%}%>
                </td>
<%          }
%>                
              </tr>
            </table>
		</wea:item>
	</wea:group>
</wea:layout>
    <br>
    <%@ include file="/workflow/request/BillBudgetExpenseDetail.jsp" %>
    <br>
    <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>
