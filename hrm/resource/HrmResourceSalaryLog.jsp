
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML>
<%
	boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
	String id = Util.null2String(request.getParameter("id"));
	if(id.equals("")) id=String.valueOf(user.getUID());
	Calendar thedate = Calendar.getInstance ();
	//String yearmonth = Util.add0(thedate.get(thedate.YEAR), 4) +"-"+Util.add0(thedate.get(thedate.MONTH) + 1, 2) ;
 String yearmonth="";
 String yearmonthsql="select distinct(max(p.paydate)) yearmonth from Hrmsalarypaydetail d left join Hrmsalarypay p on d.payid=p.id  where hrmid='"+id+"' and sent=1 ";
 rs.executeSql(yearmonthsql);
 if(rs.next()){
 	yearmonth=Util.null2String(rs.getString("yearmonth"));
 }
 	int hrmid = user.getUID();
 	int departmentid = user.getUserDepartment();

 	boolean ishe = (hrmid == Util.getIntValue(id));
 	boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));
	boolean ishasF =HrmUserVarify.checkUserRight("HrmResourceWelfareEdit:Edit",user);
 //if(!ishe&&!ishr ){
 if(!ishe&&!ishasF ){
    response.sendRedirect("/notice/noright.jsp") ;
    return;
	}
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(189,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";


int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
	if(subcompanyid == null || subcompanyid.equals("")){
		subcompanyid = "0";
	}
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
%>
<BODY>
<%if(!request.getParameter("from").equals("psersonalView")){ %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%} %>
<%
boolean show = false;
if(isfromtab){
	if(HrmListValidate.isValidate(61))show= true;
}else{
	show = true;
}
if(show){%>
<TABLE class="ListStyle" cellspacing=1 >
	<thead>
  <tr class="HeaderForXtalbe intervalTR">
   <%
    boolean isLight = false;
    ArrayList itemlist=new ArrayList();
    ArrayList salaryitems = new ArrayList() ;
    ArrayList salarys = new ArrayList() ;
    int payid=0;
		String sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b,hrmsalaryitem c where a.id=b.payid and REPLACE(REPLACE(b.itemid,'_1',''),'_2','')=convert(varchar,c.id) and c.isshow='1' and b.sent=1 and a.paydate='"+yearmonth+"' and b.hrmid = " + id +" order by c.showorder,b.itemid";
		if("oracle".equalsIgnoreCase(rs.getDBType())){
        sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b,hrmsalaryitem c where a.id=b.payid and to_number(REPLACE(REPLACE(b.itemid,'_1',''),'_2',''))=c.id and c.isshow='1' and b.sent=1 and a.paydate='"+yearmonth+"' and b.hrmid = " + id +" order by c.showorder,b.itemid";
    }  
    rs.executeSql(sql);
    while( rs.next() ) {
        if(payid==0) payid=rs.getInt("id");
        String itemid = rs.getString("itemid") ;
        String salary = rs.getString("salary") ;
        if(salaryitems.indexOf(itemid)<0){
            salaryitems.add(itemid) ;
            salarys.add(salary) ;
        }
    }
		sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b where a.id=b.payid and b.sent=1 and a.paydate='"+yearmonth+"'and b.hrmid = " + id +" and REPLACE(REPLACE(b.itemid,'_1',''),'_2','') not in(select convert(varchar,id) from hrmsalaryitem) order by b.itemid";
    if("oracle".equalsIgnoreCase(rs.getDBType())){
        sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b where a.id=b.payid and b.sent=1 and a.paydate='"+yearmonth+"'and b.hrmid = " + id +" and to_number(REPLACE(REPLACE(b.itemid,'_1',''),'_2','')) not in(select id from hrmsalaryitem) order by b.itemid";
    }
    rs.executeSql(sql);
    while( rs.next() ) {
        if(payid==0) payid=rs.getInt("id");
        String itemid = rs.getString("itemid") ;
        String salary = rs.getString("salary") ;
        if(salaryitems.indexOf(itemid)<0){
            salaryitems.add(itemid) ;
            salarys.add(salary) ;
        }
    }
    if(salaryitems.size()<1){
        itemlist=SalaryComInfo.getSubCompanySalary(Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))));
    }else{
        itemlist=salaryitems;
    }
  %>
  <TH style="TEXT-ALIGN:LEFT;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
  <%
    for(int i=0;i<itemlist.size();i++) {
        String itemid=(String)itemlist.get(i);
        if(itemid.indexOf("_")>-1) itemid=itemid.substring(0,itemid.indexOf("_"));
        String itemname = SalaryComInfo.getSalaryname(itemid);
        String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
        if( !itemtype.equals("9") ) {
   %>
   <TH style="TEXT-ALIGN:LEFT;TEXT-VALIGN:middle"><nobr><%=itemname%></TH>
   <%   } else {i++;%>
   <TH style="TEXT-ALIGN:LEFT"><nobr><%=itemname+"("+SystemEnv.getHtmlLabelName(6087,user.getLanguage())+")"%></TH>
   <TH style="TEXT-ALIGN:LEFT"><nobr><%=itemname+"("+SystemEnv.getHtmlLabelName(1851,user.getLanguage())+")"%></TH>
   <%   }
    }
   %>
  </tr>
   </thead>
   <TBODY>
   <%
    if(salaryitems.size()>0){
        isLight = !isLight ;
  %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=yearmonth%></td>
  <%
        for(int j=0;j<itemlist.size();j++){
            String itemid = (String)itemlist.get(j) ;
            String titles="";
            boolean iscaltype=false;

            int salaryindex=salaryitems.indexOf(itemid);
            String salary = "0.00" ;
            if(salaryindex>-1){
                salary=(String)salarys.get(salaryindex);
            }
            if(itemid.indexOf("_")<0){
                if(SalaryComInfo.getSalaryItemtype(itemid).equals("4")){
                    iscaltype=true;
                }
            }else{
                iscaltype=true;
            }
            if(iscaltype){
                titles=SalaryComInfo.getTitles(Util.getIntValue(id),itemid,payid,user.getLanguage(),yearmonth);
            }
   %>
       <td title="<%=titles%>" <%if(!titles.equals("")){%>style="cursor:hand"<%}%>><nobr><%=salary%></td>
<%
        }
   %>
   </tr>
   <%
    }
   %>
  </TBODY>
 </TABLE>
<%}%>
</BODY>
</HTML>