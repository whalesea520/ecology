<%@ page import="java.math.*" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/workflow/request/WorkflowViewRequestTitle.jsp" %>
<%
ArrayList fieldids = (ArrayList) session.getAttribute(requestid+"_fieldids");             //????
ArrayList fieldorders = (ArrayList) session.getAttribute(requestid+"_fieldorders");        //???????? (???????)
ArrayList languageids = (ArrayList) session.getAttribute(requestid+"_languageids");          //???????(???????)
ArrayList fieldlabels = (ArrayList) session.getAttribute(requestid+"_fieldlabels");          //??????label??

ArrayList fieldhtmltypes = (ArrayList) session.getAttribute(requestid+"_fieldhtmltypes");       //??????html type??
ArrayList fieldtypes = (ArrayList) session.getAttribute(requestid+"_fieldtypes");           //??????type??
ArrayList fieldnames = (ArrayList) session.getAttribute(requestid+"_fieldnames");           //????????????
ArrayList fieldvalues = (ArrayList) session.getAttribute(requestid+"_fieldvalues");          //????

ArrayList fieldviewtypes = (ArrayList) session.getAttribute(requestid+"_fieldviewtypes");       //?????detail????1:? 0:?(???,????)
ArrayList isfieldids = (ArrayList) session.getAttribute(requestid+"_isfieldids");              //????
ArrayList isviews = (ArrayList) session.getAttribute(requestid+"_isviews");              //????????

%>

            <%
             String uid=""+creater;
             String uname=ResourceComInfo.getLastname(uid);
             String udept=ResourceComInfo.getDepartmentID(uid);
             String udeptname= DepartmentComInfo.getDepartmentname(udept);
             String usubcom=DepartmentComInfo.getSubcompanyid1(udept);
             weaver.hrm.company.SubCompanyComInfo scci=new weaver.hrm.company.SubCompanyComInfo();
             String usubcomname=scci.getSubCompanyname(usubcom);

            int colcount = 0 ;
            int colwidth = 0 ;
            fieldids.clear() ;
            fieldlabels.clear() ;
            fieldhtmltypes.clear() ;
            fieldtypes.clear() ;
            fieldnames.clear() ;
            fieldviewtypes.clear() ;
            String temporganizationidisview="0";
            String temprogtypeisview="0";

            RecordSet.executeProc("workflow_billfield_Select",formid+"");
            while(RecordSet.next()){
                String theviewtype = Util.null2String(RecordSet.getString("viewtype")) ;
                if( !theviewtype.equals("1") ) continue ;   // ??????????,???

                fieldids.add(Util.null2String(RecordSet.getString("id")));
                fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
                fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
                fieldtypes.add(Util.null2String(RecordSet.getString("type")));
                fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
                fieldviewtypes.add(theviewtype);
            }

            // ??????????????????????
            isfieldids.clear() ;              //????
            isviews.clear() ;              //????????

            RecordSet.executeProc("workflow_FieldForm_Select",nodeid+"");
            while(RecordSet.next()){
                String thefieldid = Util.null2String(RecordSet.getString("fieldid")) ;
                int thefieldidindex = fieldids.indexOf( thefieldid ) ;
                if( thefieldidindex == -1 ) continue ;
                String theisview = Util.null2String(RecordSet.getString("isview")) ;
                String thefieldname=(String)fieldnames.get(thefieldidindex);
                if(thefieldname.equals("organizationid")) temporganizationidisview=theisview;
                if(thefieldname.equals("organizationtype")) temprogtypeisview=theisview;
                if( theisview.equals("1") ) colcount ++ ;
                isfieldids.add(thefieldid);
                isviews.add(theisview);
            }
            if(temporganizationidisview.equals("1")&&temprogtypeisview.equals("0")) colcount++;
            if( colcount != 0 ) colwidth = 95/colcount ;

            ArrayList viewfieldnames = new ArrayList() ;

            BigDecimal amountsum = new BigDecimal("0") ;
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
            // ???????????????

            for(int i=0;i<fieldids.size();i++){         // ????

                String fieldid=(String)fieldids.get(i);  //??id
                String isview="0" ;    //??????

                int isfieldidindex = isfieldids.indexOf(fieldid) ;
                if( isfieldidindex != -1 ) {
                    isview=(String)isviews.get(isfieldidindex);    //??????
                }

                String fieldname = "" ;                         //???????????
                String fieldlable = "" ;                        //?????
                int languageid = 0 ;

                fieldname=(String)fieldnames.get(i);
                if(! isview.equals("1") &&fieldname.equals("organizationtype")) isview=temporganizationidisview;
                if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                languageid = user.getLanguage() ;
                fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue((String)fieldlabels.get(i),0),languageid );

                viewfieldnames.add(fieldname) ;
%>
                <td width="<%=colwidth%>%"><%=fieldlable%></td>
<%          }
%>
			  </tr>
<% 
            sql="select *  from Bill_FnaLoanApplyDetail where id="+billid+" order by dsporder";
            RecordSet.executeSql(sql);
            while(RecordSet.next()) {
                isttLight = !isttLight ;
%>
              <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
                <td width="5%">&nbsp;</td>
<%
                for(int i=0;i<fieldids.size();i++){         // ????

                    String fieldid=(String)fieldids.get(i);  //??id
                    String isview="0" ;    //??????

                    int isfieldidindex = isfieldids.indexOf(fieldid) ;
                    if( isfieldidindex != -1 ) {
                        isview=(String)isviews.get(isfieldidindex);    //??????
                    }

                    String fieldname = (String)fieldnames.get(i);   //???????????
                    if(! isview.equals("1") &&fieldname.equals("organizationtype")) isview=temporganizationidisview;
                    if( ! isview.equals("1") ) continue ;           //不显示即进行下一步循环
                    String fieldvalue =  Util.null2String(RecordSet.getString(fieldname)) ;


                    if( fieldname.equals("organizationtype")){
                        String orgtype=Util.null2String(RecordSet.getString("organizationtype"));
                        if(orgtype.equals("3")){
                        fieldvalue=SystemEnv.getHtmlLabelName(6087,user.getLanguage());
                        }else if(orgtype.equals("2")){
                        fieldvalue=SystemEnv.getHtmlLabelName(124,user.getLanguage());
                        }else if(orgtype.equals("1")){
                        fieldvalue=SystemEnv.getHtmlLabelName(141,user.getLanguage());
                        }

                    }else if( fieldname.equals("organizationid")){
                        String orgtype=Util.null2String(RecordSet.getString("organizationtype"));
                        String orgid=Util.null2String(RecordSet.getString("organizationid"));
                        if(orgtype.equals("3")){
                        fieldvalue="<A href='javaScript:openhrm("+fieldvalue+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getLastname(fieldvalue),user.getLanguage()) +"</A>";
                        if(!orgid.equals(uid)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals("2")){
                        fieldvalue="<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(fieldvalue),user.getLanguage()) +"</A>";
                        if(!orgid.equals(udept)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }else if(orgtype.equals("1")){
                        fieldvalue="<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+fieldvalue+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(fieldvalue),user.getLanguage())+"</A>";
                        if(!orgid.equals(usubcom)) fieldvalue="<div style='background:#ff9999'>"+fieldvalue+"</div>";
                        }

                        }else if( fieldname.equals("relatedprj"))
                        fieldvalue = "<A href='/proj/data/ViewProject.jsp?isrequest=1&ProjID="+fieldvalue+"'>"+Util.toScreen(ProjectInfoComInfo.getProjectInfoname(fieldvalue),user.getLanguage()) +"</A>";
                    else if( fieldname.equals("relatedcrm"))
                        fieldvalue = "<A href='/CRM/data/ViewCustomer.jsp?isrequest=1&CustomerID="+fieldvalue+"'>"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(fieldvalue),user.getLanguage()) +"</A>";
                    else if( fieldname.equals("amount")) {
                        if( Util.getDoubleValue(fieldvalue,0) == 0 ) fieldvalue="" ;
                        else
                            amountsum = amountsum.add(new BigDecimal(Util.getDoubleValue(fieldvalue,0))) ;
                    }



%>
                <td><%=fieldvalue%></td>
<%              }   %>
              </tr>
<%          }   %>
              <tr class="header" style="FONT-WEIGHT: bold; COLOR: red">
                <td><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
<%          for(int i=0;i<viewfieldnames.size();i++){
                String thefieldname = (String)viewfieldnames.get(i) ;

%>
                <td><%  if(thefieldname.equals("amount")) {

                        amountsum = amountsum.divide ( new BigDecimal ( 1 ), 3, BigDecimal.ROUND_HALF_UP ) ;
                        String amountsumstr = "" ;
                        if( amountsum.doubleValue() != 0 ) amountsumstr = ""+amountsum.toString() ;
                    %><%=amountsumstr%>
                    <% }  else { %>&nbsp;<%}%>
                </td>
<%          }
%>
              </tr>
            </table>
		</wea:item>
	</wea:group>
</wea:layout>

    <br>
    <%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
</form>
