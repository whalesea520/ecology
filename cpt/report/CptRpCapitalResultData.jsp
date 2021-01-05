
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ page import="weaver.file.*" %>
<%@page import="java.math.BigDecimal"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
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
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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

String sql = Util.null2String(request.getParameter("datasql"));
//System.out.println("sql=="+sql);
int Language = Util.getIntValue(Util.null2String(request.getParameter("Language")),7);
	
//查询部分
String assortmentid = CptSearchComInfo.getCapitalgroupid();

String tempsearchsql = CptSearchComInfo.FormatSQLSearch();

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

//String sql  = "select id,mark,StockInDate,location,customerid,capitalnum , name, resourceid, capitalspec, startprice, stateid, remark, departmentid, fnamark, capitalgroupid,sptcount,deprestartdate,depreyear,deprerate,selectdate,blongdepartment from CptCapital   where id in ( select distinct t1.id from CptCapital t1  , CptShareDetail  t2 " + tempsearchsql + " and t1.id = t2.cptid and t2.userid=" + CurrentUser + " and t2.usertype = " + logintype + " )  order by mark asc" ;

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

			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
                <!--类别-->
			    <COL width="10%">
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
                <COL width="6%">
                <!--供应商-->
                <COL width="6%">
			  <TBODY>
			  <TR class=header>
				<TH colSpan=<%=1+9%>>
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
				<% if(!searchcounttype.equals("")){%><%=SystemEnv.getHtmlLabelName(63,Language)%>:
				<% if(searchcounttype.equals("3")){%><%=SystemEnv.getHtmlLabelName(747,Language)%><%}%>
				<% if(searchcounttype.equals("1")){%><%=SystemEnv.getHtmlLabelName(15320,Language)%><%}%>
				<% if(searchcounttype.equals("2")){%><%=SystemEnv.getHtmlLabelName(15321,Language)%><%}%>
				<% } %>
				<%if(!searchmark.equals("")){%><%=SystemEnv.getHtmlLabelName(714,Language)%>:<%=Util.toScreen(searchmark,user.getUID())%><%}%>
				<%if(!searchname.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(195,Language)%>:<%=Util.toScreen(searchname,user.getUID())%><%}%>
				<%if(!searchdepartmentid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(124,Language)%>:<%=Util.toScreen(DepartmentComInfo.getDepartmentname(searchdepartmentid),user.getUID())%><%}%>
				<%if(!searchresourceid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(1508,Language)%>:<%=Util.toScreen(ResourceComInfo.getResourcename(searchresourceid),user.getUID())%><%}%>
				<%if(!searchstartdate.equals("")){%>
					&nbsp;<%=SystemEnv.getHtmlLabelName(717,Language)%>:<%=Util.toScreen(searchstartdate,user.getUID())%>
					<%if(!searchstartdate.equals("")){%>
						<%=SystemEnv.getHtmlLabelName(15322,Language)%><%=Util.toScreen(searchstartdateto,user.getUID())%>
				<%	}
				  }
				%>
				<%if(!searchenddate.equals("")){%>
					&nbsp;<%=SystemEnv.getHtmlLabelName(718,Language)%>:<%=Util.toScreen(searchenddate,user.getUID())%>
					<%if(!searchenddateto.equals("")){%>
						<%=SystemEnv.getHtmlLabelName(15322,Language)%><%=Util.toScreen(searchenddateto,user.getUID())%>
				<%	}
				  }
				%>
				<% if(!searchstateid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(602,Language)%>:<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(searchstateid),Language)%><%}%>
				<% if(!searchgroupid.equals("")){%>&nbsp;<%=SystemEnv.getHtmlLabelName(831,Language)%>:<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(searchgroupid),user.getUID())%><%}%>&nbsp;
				</TH>
				<TH colSpan=4 align=right><%=SystemEnv.getHtmlLabelName(15326,Language)%>:<%=Util.toScreen(ResourceComInfo.getResourcename(CurrentUser),user.getUID())%></TH>
				<TH colSpan=3 align=right><%=SystemEnv.getHtmlLabelName(15327,Language)%>:<%=currentdate%></TH>
			  </TR>

			  <TR class=header>
              <!--类别-->
			  <TD nowrap><%=SystemEnv.getHtmlLabelName(178,Language)%></TD>
                <!--编号-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(714,Language)%></TD>
                <!--财务编号-->
                <TD nowrap><%=SystemEnv.getHtmlLabelName(15293,Language)%></TD>
                <!--资产名称-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(1445,Language)%></TD>
                <!--规格型号-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(904,Language)%></TD>
                <!--数量-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(1331,Language)%></TD>
                <!--购置日期-->
                <TD nowrap><%=SystemEnv.getHtmlLabelName(16914,Language)%></TD>
                <!--单价-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(1330,Language)%></TD>
                <!--现值-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(1450,Language)%></TD>  
                <!--总金额-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(1447,Language)%></TD>
                <!--状态-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(602,Language)%></TD>
                <!--使用人-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(1508,Language)%></TD>
                <!--使用部门-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(21030,Language)%></TD>
                <!--入库部门-->
				<TD nowrap><%=SystemEnv.getHtmlLabelName(15393,Language)%></TD>
                <!--存放地点-->
                <TD nowrap><%=SystemEnv.getHtmlLabelName(1387,Language)%></TD>
                <!--入库日期-->
                <TD nowrap><%=SystemEnv.getHtmlLabelName(753,Language)%></TD>
                <!--供应商-->
                <TD nowrap><%=SystemEnv.getHtmlLabelName(138,Language)%></TD>
			  </TR>
			<% 
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
			String tmpsumallprice = "";

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
				 
					//add by 61457 sjh 解决金额达到千万级数据自动转换成科学计数问题
					String temptotal = ""+((Util.getDoubleValue(tempstartprice)*Util.getDoubleValue(tempcapitalnum,0)+0.005)*100)/100.00 ;
					temptotal = Util.getfloatToString(temptotal) ; //用于将科学计数转换成字符串
					BigDecimal bd = new BigDecimal(temptotal);
					bd= bd.setScale(2,BigDecimal.ROUND_DOWN);
					temptotal =bd.toString();
			%>

			<% 
			//统计每大类资产数量和价格
			String tempassortmentid = tempid;
			for(int k=0;k<Util.getIntValue(assortmentstep,0)-1;k++){
			  tempassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(tempassortmentid);
			}
			assortmentname = CapitalAssortmentComInfo.getAssortmentName(lastid);
			if(!tempassortmentid.equals(lastid)&&!flagfirst){
			%>
			  <TR class=<% if(needchange ==0){ needchange=1; %>DataLight<%}else{ needchange=0;%>DataDark<%}%>>
                <!--类别-->
                <TD class=Field></TD>
                <!--编号-->
				<TD class=Field></TD>
                <!--财务编号-->
				<TD class=Field></TD>
				<!--资产名称-->
                <TD class=Field><font color=red><%=assortmentname%><%=SystemEnv.getHtmlLabelName(1823,Language)%>:</font></TD>
                <!--规格型号-->
				<TD class=Field></TD>
				<!--数量-->
                <TD class=Field><font color=red><%=sumassortnum%></font></TD>
                <!--购置日期-->
                <TD class=Field></TD>
                <!--单价-->
				<TD class=Field></TD>
                <!--现值-->
				<TD class=Field><font color=red><%=SystemEnv.getHtmlLabelName(523,Language)%>:</font></TD>
				<%
				String tempsumassortprice = Util.getfloatToString(""+((sumassortprice+0.005)*100)/100.00);
				BigDecimal bd6 = new BigDecimal(tempsumassortprice);
				bd6= bd6.setScale(2,BigDecimal.ROUND_DOWN);
				tempsumassortprice =bd6.toString();
				%>
                <!--总金额-->
				<TD class=Field align=right><font color=red><%=Util.getFloatStr(tempsumassortprice,3)%></font></TD>
                <!--状态-->
				<TD class=Field></TD>
                <!--使用人-->
				<TD class=Field></TD>
                <!--使用部门-->
				<TD class=Field></TD>
				<!--入库部门-->
                <TD class=Field></TD>
                <!--存放地点-->
                <TD class=Field></TD>
                <!--入库日期-->
                <TD class=Field></TD>
                <!--供应商-->
                <TD class=Field></TD>
                <!--备注-->
				<!--TD class=Field></TD-->
			  </TR>
			  <%
					sumallnum += sumassortnum;
					sumallprice += sumassortprice; 
					sumassortnum  = 0;
					sumassortprice = 0;
				} // end if
				flagfirst = false;
				
			%>
               <!--数据展现开始-->
			   <TR class=<% if(needchange ==0){ needchange=1; %>DataLight<%}else{ needchange=0;%>DataDark<%}%>>
				<TD class=Field><nobr>
                <!--类别-->
			   <% 
			   for(int j=1;j<=stepcount;j++){ 
				   tempassortmentid = tempid;
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
				   
				   
				%>
				<% }else{
					 assortmentname="";
					}
					er.addStringValue(assortmentname);%>
			   <% 
				};
			   %>
				<%
				//多级资产组:XX > XX > XX
				String allassortmentid=tempid;
				String allassortmentname="";
				allassortmentname=CapitalAssortmentComInfo.getAssortmentName(allassortmentid);
				while(!"0".equals(allassortmentid=CapitalAssortmentComInfo.getSupAssortmentId(allassortmentid))){
					allassortmentname=CapitalAssortmentComInfo.getAssortmentName(allassortmentid)+" > "+allassortmentname;
				}
				
				%>
				<%=allassortmentname %>
				</TD>
                <!--编号-->
				<TD class=Field><nobr><A href="../capital/CptCapital.jsp?id=<%=cptid%>" target='_blank'><%=tempmark%></A></TD>
                <!--财务编号-->
				<TD class=Field><%=fnamark%></TD>
                <!--资产名称-->
				<TD class=Field><nobr><%=tempname%></TD>
                <!--规格型号-->
			    <TD class=Field><nobr><%=tempcapitalspec%></TD>
                <!--数量-->
				<TD class=Field><nobr><%=(int)(Util.getDoubleValue(tempcapitalnum,0))%></TD>
                <!--购置日期-->
                <TD class=Field><%=SelectDate%></TD>
				<!--单价-->
                <TD class=Field align=right><nobr><%=Util.getFloatStr(tempstartprice,3)%></TD>
				<!--现值-->
                <TD class=Field align=right><nobr><%=Util.getFloatStr(currentprice,3)%></TD>
				<!--总金额-->
                <TD class=Field align=right><nobr><%=Util.getFloatStr(temptotal,3)%></TD>
                <!--状态-->
				<TD class=Field><nobr><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),Language)%></TD>
				<!--使用人-->
                <TD class=Field><nobr><A href="../../hrm/resource/HrmResource.jsp?id=<%=tempresourceid%>">
					<%=Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),Language)%>
					</A>
				</TD>
				<!--使用部门-->
                <TD class=Field><nobr><%=DepartmentComInfo.getDepartmentname(departmentid)%></TD>
                <!--所属部门-->
				<TD class=Field><nobr><%=Util.toScreen(DepartmentComInfo.getDepartmentname(tempblongdepartment),Language)%></TD>
                <!--存放地点-->
                <TD class=Field nowrap><%=location%></TD>
                <!--入库日期-->
                <TD class=Field nowrap><%=StockInDate%></TD>
                <!--供应商-->
                <TD class=Field nowrap><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),Language)%></TD>
                <!--备注-->
				<!--TD class=Field><nobr><%=remark%></TD-->
				  </TR>
			<%  	
						sumnum += Util.getDoubleValue(tempcapitalnum);
						sumprice += Util.getDoubleValue(temptotal);

						tmpsumallprice = Util.getfloatToString(""+(sumprice+0.005)*100/100.00);
						BigDecimal bd2 = new BigDecimal(tmpsumallprice);
						bd2= bd2.setScale(2,BigDecimal.ROUND_DOWN);
						tmpsumallprice =bd2.toString();
			%>

			<% 
			//统计每小类资产数量和总价
			if((i+1)==loopal.size()) {
			%>
			  <TR class=<% if(needchange ==0){ needchange=1; %>DataLight<%}else{ needchange=0;%>DataDark<%}%>>
				<TD class=Field></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <!--资产名称-->
				<TD class=Field><font color=red><%=assortmentname%><%=SystemEnv.getHtmlLabelName(1823,Language)%>:</font></TD>
				<TD class=Field></TD>
				<!--数量-->
                <TD class=Field><font color=red><%=sumnum%></font></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
				<!--现值-->
                <TD class=Field><font color=red><%=SystemEnv.getHtmlLabelName(2019,Language)%>:</font></TD>
				<!--总金额-->
                <TD class=Field  align=right><font color=red><%=Util.getFloatStr(tmpsumallprice,3)%></font></TD>
				<TD class=Field></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
			  </TR>
			  <%
					sumassortnum += sumnum;
					sumassortprice += sumprice; 
					sumnum  = 0;
					sumprice = 0;
					tmpsumallprice = Util.getfloatToString(""+(sumassortprice+0.005)*100/100.00);
					BigDecimal bd3 = new BigDecimal(tmpsumallprice);
					bd3= bd3.setScale(2,BigDecimal.ROUND_DOWN);
					tmpsumallprice =bd3.toString();
				} // end if
			%>
			<%
					}//end for
				 }
			}// end while
			%>
			<% 
			//统计每大类资产数量和价格
			String tempassortmentid = tempid;
			for(int k=0;k<(Util.getIntValue(assortmentstep,0)-1);k++){
			  tempassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(tempassortmentid);
			}
			assortmentname = CapitalAssortmentComInfo.getAssortmentName(lastid);
			if(!flagfirst){
			%>
			  <TR class=<% if(needchange ==0){ needchange=1; %>DataLight<%}else{ needchange=0;%>DataDark<%}%>>
				<TD class=Field></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <!--资产名称-->
				<TD class=Field><font color=red><%=assortmentname%><%=SystemEnv.getHtmlLabelName(1823,Language)%>:</font></TD>
				<TD class=Field></TD>
                <!--数量-->
				<TD class=Field><font color=red><%=sumassortnum%></font></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
                <!--现值-->
				<TD class=Field><font color=red><%=SystemEnv.getHtmlLabelName(2019,Language)%>:</font></TD>
                <!--总金额-->
				<TD class=Field  align=right><font color=red><%=Util.getFloatStr(tmpsumallprice,3)%></font></TD>
				<TD class=Field></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
			  </TR>
			  <%
					sumallnum += sumassortnum;
					sumallprice += sumassortprice; 
					sumassortnum  = 0;
					sumassortprice = 0;
					tmpsumallprice = Util.getfloatToString(""+(sumallprice+0.005)*100/100.00);
					BigDecimal bd4 = new BigDecimal(tmpsumallprice);
					bd4= bd4.setScale(2,BigDecimal.ROUND_DOWN);
					tmpsumallprice =bd4.toString();
				} // end if
			%>
			<% //统计所有资产数量和价格 %>
			  <TR class=<% if(needchange ==0){ needchange=1; %>DataLight<%}else{ needchange=0;%>DataDark<%}%>>
				<TD class=Field></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <!--资产名称-->
				<TD class=Field><font color=red><%=SystemEnv.getHtmlLabelName(523,Language)%>:</font></TD>
				<TD class=Field></TD>
                <!--数量-->
				<TD class=Field><font color=red><%=sumallnum%></font></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
                <!--现值-->
				<TD class=Field><font color=red><%=SystemEnv.getHtmlLabelName(523,Language)%>:</font></TD>
                <!--总金额-->
				<TD class=Field align=right><font color=red><%=Util.getFloatStr(tmpsumallprice,3)%></font></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
                <TD class=Field></TD>
                <TD class=Field></TD>
				<TD class=Field></TD>
			  </TR>
			</TBODY>
			</TABLE>