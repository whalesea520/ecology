
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CustomFieldTreeManager" class="weaver.hrm.resource.CustomFieldTreeManager" scope="page" />
<html>
<%!
    /**
     * Add by Charoes ,remove the zero behind a Two Digit precision Decimal .
     * @param s
     * @return
     */
    private String trimZero(String s){
        int index = s.indexOf(".");
        if(index !=-1){
            String temp = s.substring(index+1);
            if(temp.equals("00"))
                s = s.substring(0,index);
            else{
                if(temp.substring(temp.length()-1).equals("0") ){
                    s = s.substring(0,s.length()-1)      ;
                }
            }
        }
        return s;
    }

%>
<%
 String id = request.getParameter("id");  
 int hrmid = user.getUID();
 
 int isView = Util.getIntValue(request.getParameter("isView"));
 
 int departmentid = user.getUserDepartment();
  
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid)); 
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(ishr){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(15688,user.getLanguage())+",javascript:viewWorkInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM name=resourcepersonalinfo id=resource action="HrmCareerApplyOperation.jsp" method=post>
 <TABLE class=ViewForm>

	<TBODY> 
    <TR> 
      <TD vAlign=top>
      <TABLE width="100%">
          <COLGROUP> <COL width=20%> <COL width=80%>
	      <TBODY> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px">
            <TD class=Line1 colSpan=2></TD>
          </TR>
  <%
  String sql = "";
  sql = "select * from HrmCareerApply where id = "+id;  
  rs.executeSql(sql);
  while(rs.next()){
    String birthday = Util.null2String(rs.getString("birthday"));
    String folk = Util.null2String(rs.getString("folk"));
    String nativeplace = Util.null2String(rs.getString("nativeplace"));
    String regresidentplace = Util.null2String(rs.getString("regresidentplace"));

    String certificatenum = Util.null2String(rs.getString("certificatenum"));    
    String maritalstatus = Util.null2String(rs.getString("maritalstatus"));
    String policy = Util.null2String(rs.getString("policy"));
    String bememberdate = Util.null2String(rs.getString("bememberdate"));

    String bepartydate = Util.null2String(rs.getString("bepartydate"));
    String islabouunion = Util.null2String(rs.getString("islabouunion"));
    String educationlevel = Util.null2String(rs.getString("educationlevel"));
    String degree = Util.null2String(rs.getString("degree"));

    String healthinfo = Util.null2String(rs.getString("healthinfo"));
    String height = Util.null2String(rs.getString("height"));
    String weight = Util.null2String(rs.getString("weight"));
    String residentplace = Util.null2String(rs.getString("residentplace"));

    String homeaddress = Util.null2String(rs.getString("homeaddress"));
    String tempresidentnumber = Util.null2String(rs.getString("tempresidentnumber"));    
%>        
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=birthday%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=folk%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=nativeplace%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=regresidentplace%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=certificatenum%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
            <TD class=Field>               
                <%if(maritalstatus.equals("0")){%><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%> <%}%>
                <%if(maritalstatus.equals("1")){%><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%> <%}%>
                <%if(maritalstatus.equals("2")){%><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> <%}%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=policy%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=bememberdate%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=bepartydate%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></TD>
            <TD class=Field>
              <%if(islabouunion.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%> 
              <%if(islabouunion.equals("0")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>       
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TD>
            <TD class=Field>
              <%=EduLevelComInfo.getEducationLevelname(educationlevel)%>            
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=degree%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></TD>
            <TD class=Field> 
              <%if(healthinfo.equals("0")){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%><%}%>
              <%if(healthinfo.equals("1")){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
              <%if(healthinfo.equals("2")){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
              <%if(healthinfo.equals("3")){%><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%><%}%>         
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=trimZero(height)%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
       	  <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=trimZero(weight)%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=residentplace%>
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--	      <TR> 
            <TD>家庭联系方式</TD>
            <TD class=Field> 
              <%=homeaddress%>
            </TD>
          </TR>
-->          
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=tempresidentnumber%>
            </TD>
          </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<% }%>        

<%
    int scopeId = 1;
    CustomFieldManager cfm = new CustomFieldManager("CareerCustomFieldByInfoType",scopeId);
    cfm.getCustomFields();
    cfm.getCustomData(Util.getIntValue(id,0));
    while(cfm.next()){
        String fieldvalue = cfm.getData("field"+cfm.getId());
%>
    <tr>
      <td <%if(cfm.getHtmlType().equals("2")){%> valign=top <%}%>> <%=cfm.getLable()%> </td>
      <td class=field >
      <%
        if(cfm.getHtmlType().equals("1")||cfm.getHtmlType().equals("2")){
      %>
      <%=fieldvalue%>
      <%
        }else if(cfm.getHtmlType().equals("3")){

            String fieldtype = String.valueOf(cfm.getType());
		    String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
		    String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
		    String showname = "";                                   // 新建时候默认值显示的名称
		    String showid = "";                                     // 新建时候默认值


            if(fieldtype.equals("2") ||fieldtype.equals("19")){
                showname=fieldvalue; // 日期时间
            }else if(!fieldvalue.equals("")) {
                String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                sql = "";

                HashMap temRes = new HashMap();

                if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                }
                else {
                    sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                }

                RecordSet.executeSql(sql);
                while(RecordSet.next()){
                    showid = Util.null2String(RecordSet.getString(1)) ;
                    String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
                    if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                        temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                    else{
                        //showname += tempshowname ;
                        temRes.put(String.valueOf(showid),tempshowname);
                    }
                }
                StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                String temstkvalue = "";
                while(temstk.hasMoreTokens()){
                    temstkvalue = temstk.nextToken();

                    if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                        showname += temRes.get(temstkvalue);
                    }
                }

            }


      %>
        <span id="customfield<%=cfm.getId()%>span"><%=Util.toScreen(showname,user.getLanguage())%></span>
       <%
        }else if(cfm.getHtmlType().equals("4")){
       %>
        <input type=checkbox value=1 name="customfield<%=cfm.getId()%>" <%=fieldvalue.equals("1")?"checked":""%> disabled >
       <%
        }else if(cfm.getHtmlType().equals("5")){
            cfm.getSelectItem(cfm.getId());
       %>
       <%
            while(cfm.nextSelect()){
                if(cfm.getSelectValue().equals(fieldvalue)){
       %>
            <%=cfm.getSelectName()%>
       <%
                    break;
                }
            }
       %>
       <%
        }
       %>
            </td>
        </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD>
  </TR>
       <%
    }
       %>
 	      </tbody>
       </table>
   </tr>

<%
  sql = "select * from HrmFamilyInfo where resourceid = "+id+" order by ID";  
  rs.executeSql(sql);  
%>
	<TR> 
      <TD vAlign=top> 
        <TABLE width="100%" class=ListStyle cellspacing=1 >
          <COLGROUP> 
		    <COL width=15%> 
			<COL width=10%>
			<COL width=30%>
			<COL width=15%>
			<COL width=30%>
	      <TBODY> 
          <TR class=Header> 
            <TH colSpan=5><%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%></TH>
          </TR>
           <tr class=header>
		    <td><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%>	</td>
			<td><%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%>	</td>
			<td><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>	</td>
		  </tr>

<%
  while(rs.next()){
    String member = Util.null2String(rs.getString("member"));
	String title = Util.null2String(rs.getString("title"));
	String company = Util.null2String(rs.getString("company"));
	String jobtitle = Util.null2String(rs.getString("jobtitle"));
	String address = Util.null2String(rs.getString("address"));
%>
	      <tr>
	        <TD class=Field> 
              <%=member%>
            </TD>
	        <TD class=Field> 
              <%=title%>
            </TD>
	        <TD class=Field> 
              <%=company%>
            </TD>
	        <TD class=Field> 
              <%=jobtitle%>
            </TD>
	        <TD class=Field> 
              <%=address%>
            </TD>
	      </tr> 
<%}%>
<%----------------------------自定义明细字段 begin--------------------------------------------%>

	 <%

         RecordSet.executeSql("select id, formlabel from cus_treeform where parentid="+scopeId+" order by scopeorder");
         //System.out.println("select id from cus_treeform where parentid="+scopeId);
         int recorderindex = 0 ;
         while(RecordSet.next()){
             recorderindex = 0 ;
             int subId = RecordSet.getInt("id");
             CustomFieldManager cfm2 = new CustomFieldManager("HrmCustomFieldByInfoType",subId);
             cfm2.getCustomFields();
             CustomFieldTreeManager.getMutiCustomData("CareerCustomFieldByInfoType", subId, Util.getIntValue(id,0));
             int colcount1 = cfm2.getSize() ;
             int colwidth1 = 0 ;

             if( colcount1 != 0 ) {
                 colwidth1 = 100/colcount1 ;

     %>
	 <table Class=ListStyle  cellspacing="0" cellpadding="0">
        <tr class=header>

            <td align="left" >
            <b><%=RecordSet.getString("formlabel")%></b>
            </td>
            <td align="right"  >

            </td>
        </tr>

        <tr>
            <td colspan=2>

            <table Class=ListStyle id="oTable_<%=subId%>"  cellspacing="1" cellpadding="0">
            <COLGROUP>
            <tr class=header>
   <%

       while(cfm2.next()){
		  String fieldlable =String.valueOf(cfm2.getLable());

   %>
		 <td width="<%=colwidth1%>%" nowrap><%=fieldlable%></td>
           <%
	   }
       cfm2.beforeFirst();
%>
</tr>
<%

    boolean isttLight = false;
    while(CustomFieldTreeManager.nextMutiData()){
            isttLight = !isttLight ;
%>
            <TR class='<%=( isttLight ? "datalight" : "datadark" )%>'>
        <%
        while(cfm2.next()){
            String fieldid=String.valueOf(cfm2.getId());  //字段id
            String ismand=String.valueOf(cfm2.isMand());   //字段是否必须输入
            String fieldhtmltype = String.valueOf(cfm2.getHtmlType());
            String fieldtype=String.valueOf(cfm2.getType());
            String fieldvalue =  Util.null2String(CustomFieldTreeManager.getMutiData("field"+fieldid)) ;

%>
            <td class=field nowrap style="TEXT-VALIGN: center">
<%
            if(fieldhtmltype.equals("1")||fieldhtmltype.equals("2")){                          // 单行文本框
%>
                <%=Util.toScreenToEdit(fieldvalue,user.getLanguage())%>
<%
            }else if(fieldhtmltype.equals("3")){                         // 浏览按钮 (涉及workflow_broswerurl表)
                String url=BrowserComInfo.getBrowserurl(fieldtype);     // 浏览按钮弹出页面的url
                String linkurl=BrowserComInfo.getLinkurl(fieldtype);    // 浏览值点击的时候链接的url
                String showname = "";                                   // 新建时候默认值显示的名称
                String showid = "";                                     // 新建时候默认值

                String newdocid = Util.null2String(request.getParameter("docid"));

                if( fieldtype.equals("37") && !newdocid.equals("")) {
                    if( ! fieldvalue.equals("") ) fieldvalue += "," ;
                    fieldvalue += newdocid ;
                }

                if(fieldtype.equals("2") ||fieldtype.equals("19")){
                    showname=fieldvalue; // 日期时间
                }else if(!fieldvalue.equals("")) {
                    String tablename=BrowserComInfo.getBrowsertablename(fieldtype); //浏览框对应的表,比如人力资源表
                    String columname=BrowserComInfo.getBrowsercolumname(fieldtype); //浏览框对应的表名称字段
                    String keycolumname=BrowserComInfo.getBrowserkeycolumname(fieldtype);   //浏览框对应的表值字段
                    sql = "";

                    HashMap temRes = new HashMap();

                    if(fieldtype.equals("17")|| fieldtype.equals("18")||fieldtype.equals("27")||fieldtype.equals("37")||fieldtype.equals("56")||fieldtype.equals("57")||fieldtype.equals("65")||fieldtype.equals("168")||fieldtype.equals("194")) {    // 多人力资源,多客户,多会议，多文档
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+" in( "+fieldvalue+")";
                    }
                    else {
                        sql= "select "+keycolumname+","+columname+" from "+tablename+" where "+keycolumname+"="+fieldvalue;
                    }

                    rs.executeSql(sql);
                    while(rs.next()){
                        showid = Util.null2String(rs.getString(1)) ;
                        String tempshowname= Util.toScreen(rs.getString(2),user.getLanguage()) ;
                        if(!linkurl.equals(""))
                        //showname += "<a href='"+linkurl+showid+"'>"+tempshowname+"</a> " ;
                            temRes.put(String.valueOf(showid),"<a href='"+linkurl+showid+"'>"+tempshowname+"</a> ");
                        else{
                            //showname += tempshowname ;
                            temRes.put(String.valueOf(showid),tempshowname);
                        }
                    }
                    StringTokenizer temstk = new StringTokenizer(fieldvalue,",");
                    String temstkvalue = "";
                    while(temstk.hasMoreTokens()){
                        temstkvalue = temstk.nextToken();

                        if(temstkvalue.length()>0&&temRes.get(temstkvalue)!=null){
                            showname += temRes.get(temstkvalue);
                        }
                    }

                }
%>
                    <%=showname%>
<%
            }else if(fieldhtmltype.equals("4")) {                    // check框
%>
                <input type=checkbox disabled value=1 name="customfield<%=fieldid%>_<%=subId%>_<%=recorderindex%>" <%if(fieldvalue.equals("1")){%> checked <%}%> >
<%
            }else if(cfm2.getHtmlType().equals("5")){
                cfm2.getSelectItem(cfm2.getId());
                while(cfm2.nextSelect()){
                    if(cfm2.getSelectValue().equals(fieldvalue)){
%>
            <%=cfm2.getSelectName()%>
<%
                        break;
                    }
                }
            }
%>
            </td>
<%
        }
        cfm2.beforeFirst();
        recorderindex ++ ;
    }

%>
</tr>

        </table>
        </td>
        </tr>
</table>

<%
             }
%>
<br>
<%
         }
%>

<%----------------------------自定义明细字段 end  --------------------------------------------%>
      </tbody>
       </table>
   </tr>
	
   </tbody>
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

 <script language=javascript>
  function edit(){ 
    location = "/hrm/career/HrmCareerApplyPerEdit.jsp?id=<%=id%>";
  }
  function viewWorkInfo(){    
    location = "/hrm/career/HrmCareerApplyWorkView.jsp?id=<%=id%>";
  }  
  function back(){    
    location = "/hrm/career/HrmCareerApplyEdit.jsp?applyid=<%=id%>";
  }  
</script> 
</body>
</html>