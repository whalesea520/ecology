<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.*" %>
<%@page import="java.math.BigDecimal"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentList" class="weaver.cpt.maintenance.CapitalAssortmentList" scope="page" />
<jsp:useBean id="CapitalCurPrice" class="weaver.cpt.capital.CapitalCurPrice" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="cptsearch" class="weaver.cpt.search.CapitalSearch" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;

String subcompanyid = Util.fromScreen(request.getParameter("subcompanyid"),user.getLanguage()) ;		
//查询部分
String assortmentid = CptSearchComInfo.getCapitalgroupid();

String tempsearchsql = CptSearchComInfo.FormatSQLSearch();
       tempsearchsql = tempsearchsql.replaceAll("departmentid","t1.departmentid");

//put all capitalid into hashtable
Hashtable ht = new Hashtable();
ArrayList ids = new ArrayList() ;
ArrayList marks = new ArrayList() ;
ArrayList capitalnums = new ArrayList() ;
ArrayList names = new ArrayList() ;
ArrayList resourceids = new ArrayList() ;
ArrayList capitalspecs = new ArrayList() ;
ArrayList startprices = new ArrayList() ;
ArrayList capitalgroupids = new ArrayList() ;
ArrayList stateids = new ArrayList() ;
ArrayList remarks = new ArrayList() ;
ArrayList departmentids = new ArrayList() ;
ArrayList fnamarks = new ArrayList() ;
ArrayList StockInDates = new ArrayList() ;
ArrayList locations = new ArrayList() ;
ArrayList customerids = new ArrayList() ;
ArrayList sptcounts = new ArrayList() ;
ArrayList deprestartdates = new ArrayList() ;
ArrayList depreyears = new ArrayList() ;
ArrayList deprerates = new ArrayList() ;
ArrayList selectdates = new ArrayList() ;
ArrayList blongdepartments = new ArrayList();
CommonShareManager.setAliasTableName("t2");
String sql  = "select id,mark,StockInDate,location,customerid,capitalnum , name, resourceid, capitalspec, startprice, stateid, remark, departmentid, fnamark, capitalgroupid,sptcount,deprestartdate,depreyear,deprerate,selectdate,blongdepartment from CptCapital   where id in ( select distinct t1.id from CptCapital t1  , CptCapitalShareInfo  t2 " + tempsearchsql + " and t1.id = t2.relateditemid and ("+CommonShareManager.getShareWhereByUser("cpt", user)+" ) )  order by mark asc" ;

RecordSet.executeSql(sql);

while(RecordSet.next()){
	String tempid = RecordSet.getString("id");
    String tempmark = RecordSet.getString("mark");
    String tempcapitalnum = RecordSet.getString("capitalnum");
    String tempname = RecordSet.getString("name");
    String tempresourceid = RecordSet.getString("resourceid");
    String tempcapitalspec = RecordSet.getString("capitalspec");
    String tempstartprice = RecordSet.getString("startprice");
    String tempcapitalgroupid = RecordSet.getString("capitalgroupid");
    String tempstateid =  RecordSet.getString("stateid");
    String tempremark  = RecordSet.getString("remark");
    String tempdepartmentid  = RecordSet.getString("departmentid");
    String tempfnamark  = RecordSet.getString("fnamark");
    String tempStockInDate = RecordSet.getString("StockInDate");
    String templocation = RecordSet.getString("location");
    String tempcustomerid = RecordSet.getString("customerid");
    String tempsptcount = RecordSet.getString("sptcount");
    String tempdeprestartdate = RecordSet.getString("deprestartdate");
    String tempdepreyear = RecordSet.getString("depreyear");
    String tempdeprerate = RecordSet.getString("deprerate");
    String tempselectdate = RecordSet.getString("selectdate");
	String tempblongdepartment = RecordSet.getString("blongdepartment");
	
    ArrayList tempal = (ht.get(tempcapitalgroupid)==null)?new ArrayList():(ArrayList)ht.get(tempcapitalgroupid);
	tempal.add(tempid);
	ht.put(tempcapitalgroupid,tempal);

    ids.add(tempid) ;
    marks.add(tempmark) ;
    capitalnums.add(tempcapitalnum) ;
    names.add(tempname) ;
    resourceids.add(tempresourceid) ;
    capitalspecs.add(tempcapitalspec) ;
    startprices.add(tempstartprice) ;
    capitalgroupids.add(tempcapitalgroupid) ;
    stateids.add(tempstateid) ;
    remarks.add(tempremark) ;
    departmentids.add(tempdepartmentid) ;
    fnamarks.add(tempfnamark) ;
    StockInDates.add(tempStockInDate) ;
    locations.add(templocation) ;
    customerids.add(tempcustomerid) ;
    sptcounts.add(tempsptcount) ;
    deprestartdates.add(tempdeprestartdate) ;
    depreyears.add(tempdepreyear) ;
    deprerates.add(tempdeprerate) ;
    selectdates.add(tempselectdate);
	blongdepartments.add(tempblongdepartment);
}

//initial AssortmentList
CapitalAssortmentList.initCapitalAssortmentList("0");
if(assortmentid.equals("")){
	CapitalAssortmentList.setCapitalAssortmentList2("0");
}
else{
	CapitalAssortmentList.setCapitalAssortmentList2(assortmentid);
}

//get max step
int stepcount = 0;
while(CapitalAssortmentList.next()){
	int step = Util.getIntValue(CapitalAssortmentList.getAssortmentStep());
	if(step>stepcount){
		stepcount=step;
	}
}

if(!(CptSearchComInfo.getCountType()).equals("")){
	stepcount = 2;
}

int tdwidth=10;
if (stepcount>0) tdwidth=(int)(10/stepcount);

String strData="";
String strURL="";
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(datasql){
    var ajax=ajaxinit();
    ajax.open("POST", "CptRpCapitalResultData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("datasql="+encodeURIComponent(datasql)+"&Language=<%=user.getLanguage()%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("showdatadiv").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}

function expExcel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1510,user.getLanguage());//TotalCount+" - "+pagenum+" - "+perpage;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("17416",user.getLanguage())+"Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("364",user.getLanguage())%>" onclick="onReSearch();" />
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("17416",user.getLanguage()) %>Excel" onclick="expExcel();" />
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" ></div>



			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <% for(int i=0;i<stepcount;i++){ %>	
                <!--类别-->
			    <COL width="<%=tdwidth%>%">
			  <% } %>
                <!--编号-->
                <COL width="6%">
                <!--财务编号-->
                <COL width="6%">
                <!--资产名称-->
                <COL width="8%">
                <!--规格型号-->
                <COL width="8%">
                <!--数量-->
                <COL width="4%">
                <!--购置日期-->
                <COL width="6%">
                <!--单价-->
                <COL width="4%">
                <!--现值-->
                <COL width="4%">
                <!--总金额-->
                <COL width="4%">
                <!--状态-->
                <COL width="4%">
                <!--使用人-->
                <COL width="4%">
                <!--使用部门-->
                <COL width="6%">
                <!--入库部门-->
                <COL width="6%">
                <!--存放地点-->
                <COL width="10%">
                <!--供应商-->
                <COL width="10%">
                <!--备注-->
                <!--COL width="0%"-->
			  <TBODY>
				<%
				
					ExcelSheet es = new ExcelSheet() ;
					ExcelRow er = es.newExcelRow () ;  
				
					String searchmark = CptSearchComInfo.getMark();
					String searchname =  CptSearchComInfo.getName();   
					String searchdepartmentid =  CptSearchComInfo.getDepartmentid();   
					String searchresourceid =  CptSearchComInfo.getResourceid();   
					String searchstartdate =  CptSearchComInfo.getStartdate();   
					String searchstartdateto =  CptSearchComInfo.getStartdate1();   
					String searchenddate =  CptSearchComInfo.getEnddate();   
					String searchenddateto =  CptSearchComInfo.getEnddate1();   
					String searchstateid =  CptSearchComInfo.getStateid();   
					String searchgroupid =  CptSearchComInfo.getCapitalgroupid();  
					String searchcounttype = CptSearchComInfo.getCountType();  
				%>
			  
			  <% 
				for(int i=1;i<=stepcount;i++){
                 //<!--类别-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(178,user.getLanguage())+i) ;
			  %>	
              <!--类别-->
			  
			  <% } %>
			  <TR><TD colspan=<%=stepcount+16%>>
			  	<div id="showdatadiv" style="margin-left:-10px!important;margin-right:-5px!important;"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
			  		<script>showdata("<%=xssUtil.put(sql)%>");</script>
			  	</div>
			  </TD></TR>
			<% 
                 //<!--编号-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(714,user.getLanguage())) ;
                 //<!--财务编号-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(15293,user.getLanguage())) ;
                 //<!--资产名称-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(1445,user.getLanguage())) ;
				 //<!--规格型号-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(904,user.getLanguage())) ;
                 //<!--数量-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(1331,user.getLanguage())) ;
                 //<!--购置日期-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(16914,user.getLanguage())) ;
                 //<!--单价-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(1330,user.getLanguage())) ;
                 //<!--现值-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(1450,user.getLanguage())) ;
                 //<!--总金额-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(1447,user.getLanguage())) ;
				 //<!--状态-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage())) ;
				 //<!--使用人-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(1508,user.getLanguage())) ;
                 //<!--使用部门-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(21030,user.getLanguage())) ;
                 //<!--入库部门-->
				 er.addStringValue(SystemEnv.getHtmlLabelName(15393,user.getLanguage())) ;
                 //<!--存放地点-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(1387,user.getLanguage())) ; ;
                 //<!--入库日期-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(753,user.getLanguage())) ;
                 //<!--供应商-->
                 er.addStringValue(SystemEnv.getHtmlLabelName(138,user.getLanguage())) ;
				 //<!--备注-->
                 //er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage())) ;
				 es.addExcelRow(er) ;

			int needchange = 0;
			int totalline=1;

			ArrayList loopal;

			//get all assortment
			int sumnum = 0;
			double sumprice = 0;
			int sumassortnum = 0;
			double sumassortprice = 0;
			int sumallnum = 0;
			double sumallprice = 0;
			String lastid = "";
			boolean flagfirst = true;
			String tempid = "";
			String assortmentstep = "";
			String assortmentname = "";

			//主循环
			while(CapitalAssortmentList.next()){
					tempid = CapitalAssortmentList.getAssortmentId();
					assortmentstep = CapitalAssortmentList.getAssortmentStep();
					assortmentname = CapitalAssortmentList.getAssortmentName();
			//		out.print("assortmentname:"+assortmentname);
					loopal = (ArrayList)ht.get(tempid);
					//do capital in each assortment
					//从循环
				 if(loopal!=null){
					for(int i=0;i<loopal.size();i++){
					String cptid = (String)loopal.get(i);
					int theindex = ids.indexOf(cptid) ;
					if( theindex == -1 ) continue ;
					
					String tempmark = (String)marks.get(theindex) ;
					String tempcapitalnum = (String)capitalnums.get(theindex) ;
					String tempname = (String)names.get(theindex) ;
					String tempresourceid = (String)resourceids.get(theindex) ;
					String tempcapitalspec = (String)capitalspecs.get(theindex) ;
					String tempstartprice = (String)startprices.get(theindex) ;
					String tempcapitalgroupid = (String)capitalgroupids.get(theindex) ;
					String tempstateid =  (String)stateids.get(theindex) ;
					String remark  = (String)remarks.get(theindex) ;
					String departmentid  = (String)departmentids.get(theindex) ;
					String fnamark  = (String)fnamarks.get(theindex) ;
                    String StockInDate  = (String)StockInDates.get(theindex) ;
                    String location  = (String)locations.get(theindex) ;
                    String customerid  = (String)customerids.get(theindex) ;
					String currentprice  = "";
                    String tempsptcount  = (String)sptcounts.get(theindex) ;
                    String tempdeprestartdate  = (String)deprestartdates.get(theindex) ;
                    String tempdepreyear  = (String)depreyears.get(theindex) ;
                    String tempdeprerate  = (String)deprerates.get(theindex) ;
                    String SelectDate  = (String)selectdates.get(theindex) ;
					String tempblongdepartment = (String)blongdepartments.get(theindex) ;

					ids.remove(theindex) ;
					marks.remove(theindex) ;
					capitalnums.remove(theindex) ;
					names.remove(theindex) ;
					resourceids.remove(theindex) ;
					capitalspecs.remove(theindex) ;
					startprices.remove(theindex) ;
					capitalgroupids.remove(theindex) ;
					stateids.remove(theindex) ;
					remarks.remove(theindex) ;
					departmentids.remove(theindex) ;
					fnamarks.remove(theindex) ;
                    StockInDates.remove(theindex) ;
                    locations.remove(theindex) ;
                    customerids.remove(theindex) ;
                    sptcounts.remove(theindex) ;
                    deprestartdates.remove(theindex) ;
                    depreyears.remove(theindex) ;
                    deprerates.remove(theindex) ;
					selectdates.remove(theindex);
					blongdepartments.remove(theindex);
					
					
					/*计算当前价值*/
                    CapitalCurPrice.setSptcount(tempsptcount);
                    CapitalCurPrice.setStartprice(tempstartprice);
                    CapitalCurPrice.setCapitalnum(tempcapitalnum);
                    CapitalCurPrice.setDeprestartdate(tempdeprestartdate);
                    CapitalCurPrice.setDepreyear(tempdepreyear);
                    CapitalCurPrice.setDeprerate(tempdeprerate);

                    currentprice=CapitalCurPrice.getCurPrice();
				 
					
		String temptotal = ""+((Util.getDoubleValue(tempstartprice)*Util.getDoubleValue(tempcapitalnum,0)+0.005)*100)/100.00 ;
					temptotal = Util.getfloatToString(temptotal) ; //用于将科学计数转换成字符串
					BigDecimal bd = new BigDecimal(temptotal);
					bd= bd.setScale(2,BigDecimal.ROUND_DOWN);
					temptotal =bd.toString();
					
			%>

			<% 
			
				er = es.newExcelRow () ;
			%>
               <!--数据展现开始-->
			  <% for(int j=1;j<=stepcount;j++){ %>	
                <!--类别-->
				<% //get assortmentid and name of current level
				   String tempassortmentid = tempid;
				   if(Util.getIntValue(assortmentstep,0)>=j){
					   if(Util.getIntValue(assortmentstep,0)!=j){   
						  int t = Util.getIntValue(assortmentstep,0)-j;
						  for(int k=0;k<t;k++){
							tempassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(tempassortmentid);
						  }
						  assortmentname = 	CapitalAssortmentComInfo.getAssortmentName(tempassortmentid);
					   }
					   else{
						  assortmentname = CapitalAssortmentList.getAssortmentName();
					   }// end if
				   if(j==1){
						lastid=tempassortmentid;
				   }
				 }else{
					 assortmentname="";
					}
					er.addStringValue(assortmentname);%>
			   <% 
				};//end for   		
						
                        //<!--编号-->
						er.addStringValue(tempmark);
                        //<!--财务编号-->
                        er.addStringValue(fnamark);
                        //<!--资产名称-->
                        er.addStringValue(tempname);
						//<!--规格型号-->
                        er.addStringValue(tempcapitalspec);
                        //<!--数量-->
                        er.addValue(tempcapitalnum);
                        //<!--购置日期-->
                        er.addStringValue(SelectDate);
                        //<!--单价-->
                        er.addValue(Util.getFloatStr(tempstartprice,3));
                        //<!--现值-->
                        er.addValue(Util.getFloatStr(currentprice,3));
                        //<!--总金额-->
                        er.addValue(Util.getFloatStr(temptotal,3));
                        //<!--状态-->
                        er.addStringValue(Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),user.getLanguage()));
                        //<!--使用人-->
                        er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage()));
                        //<!--使用部门-->
                        er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
                        //<!--所属部门-->
                        er.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(tempblongdepartment),user.getLanguage()));
                        //<!--存放地点-->
                        er.addStringValue(location);
                        //<!--入库日期-->
                        er.addStringValue(StockInDate);
                        //<!--供应商-->
                        er.addStringValue(Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage()));
                        //<!--备注-->
                        //er.addStringValue(Util.toScreenToEdit(remark,user.getLanguage()));
						
						es.addExcelRow(er) ;
						
			%>

			<%
					}//end for
				 }
			}// end while
			%>
			  
			</TBODY>
			</TABLE>
<%
 ExcelFile.init() ;
 ExcelFile.setFilename(SystemEnv.getHtmlLabelName(1510,user.getLanguage())) ;
 ExcelFile.addSheet(SystemEnv.getHtmlLabelName(1510,user.getLanguage()), es) ;
 %>
<script>
function onReSearch(){
	parent.location.href="/cpt/report/CptRpCapital.jsp?subcompanyid1=<%=subcompanyid%>";
}
</script>

</body>
</html>
