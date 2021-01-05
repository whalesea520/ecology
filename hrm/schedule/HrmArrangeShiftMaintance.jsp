<%@ page import = "weaver.general.Util" %>
<%@ page import = "java.util.*" %>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id = "ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%!
public ArrayList<Integer> getLsResource(weaver.conn.RecordSet rs,String sqlwhere2)throws Exception{
	ArrayList<Integer> lsReource = new ArrayList<Integer>();
	ArrayList<HrmShareType>  lsHrmShareType = new ArrayList<HrmShareType>();
	HrmShareType hrmShareType = new HrmShareType();
	
	//首先获得范围表中的数据
	rs.executeSql(" SELECT sharetype,relatedId,level_from, level_to FROM hrmarrangeshiftset ");
	while(rs.next()){
		hrmShareType = new HrmShareType();
		hrmShareType.setSharetype(rs.getInt("sharetype"));
		hrmShareType.setRelatedId(rs.getInt("relatedId"));
		hrmShareType.setLevel_from(rs.getInt("level_from"));
		hrmShareType.setLevel_to(rs.getInt("level_to"));
		lsHrmShareType.add(hrmShareType);
	}
	
	for(int i=0;i<lsHrmShareType.size();i++){
		hrmShareType = lsHrmShareType.get(i);
		if(hrmShareType.getSharetype()==5){
			//所有人
			rs.executeSql("select id from hrmresource where  status in(0,1,2,3) " 
										+" and seclevel >= "+hrmShareType.getLevel_from() +" and seclevel >= "+hrmShareType.getLevel_to()
										+ sqlwhere2 + " order by departmentid ");
			while(rs.next()){
				lsReource.add(rs.getInt("id"));
			}
		}else if(hrmShareType.getSharetype()==4){
			//角色
			rs.executeSql("SELECT resourceid FROM HrmRoleMembers WHERE roleid ="+hrmShareType.getRelatedId()
									+" and rolelevel>="+hrmShareType.getLevel_from() +" AND rolelevel<="+hrmShareType.getLevel_to());
			while(rs.next()){
				lsReource.add(rs.getInt("id"));   
			}
		}else if(hrmShareType.getSharetype()==3){
			//人力资源	
			rs.executeSql("SELECT id FROM hrmresource WHERE id="+ hrmShareType.getRelatedId() + sqlwhere2 + " order by departmentid");
			while(rs.next()){
			lsReource.add(rs.getInt("id"));
			}
		}else if(hrmShareType.getSharetype()==2){
			//部门
			rs.executeSql("SELECT id FROM hrmresource WHERE departmentid in ("+DepartmentComInfo.getAllChildDepartId(""+hrmShareType.getRelatedId(),""+hrmShareType.getRelatedId())
								+") and seclevel>="+hrmShareType.getLevel_from() +" AND seclevel<="+hrmShareType.getLevel_to()+ sqlwhere2 + " order by departmentid");
			while(rs.next()){
			lsReource.add(rs.getInt("id"));
			}
		}else if(hrmShareType.getSharetype()==1){
			//分部
			String subComIds = SubCompanyComInfo.getSubCompanyTreeStr(""+hrmShareType.getRelatedId())+hrmShareType.getRelatedId();
			rs.executeSql("SELECT id FROM hrmresource WHERE subcompanyid1 in ("+subComIds
								+") and seclevel>="+hrmShareType.getLevel_from() +" AND seclevel<="+hrmShareType.getLevel_to()+ sqlwhere2 + " order by departmentid");
			while(rs.next()){
				lsReource.add(rs.getInt("id"));
			}
		}
	}
	return lsReource;
}

%>
<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<script language = "javascript" src = "/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16692 , user.getLanguage()) ;  
String needfav = "1" ; 
String needhelp = "" ; 

String rightlevel = HrmUserVarify.getRightLevel("HrmArrangeShiftMaintance:Maintance" , user ) ;

String isself = Util.null2String(request.getParameter("isself"));
String qname = Util.null2String(request.getParameter("flowTitle"));

String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String subcompanyid = Util.fromScreen(request.getParameter("subcompanyid") , user.getLanguage()) ; //分部
String departmentid = Util.fromScreen(request.getParameter("departmentid") , user.getLanguage()) ; //部门
String strresourceid = Util.fromScreen(request.getParameter("resourceid") , user.getLanguage()) ; //部门
//if(!subcompanyid.equals("") || !departmentid.equals("")) 
isself = "1";

Calendar thedate = Calendar.getInstance() ; //

String currentdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;   // 当天

// 如果用户选择的开始日期或者结束日期为空，则默认为下周一到下周日
if( fromdate.equals("") || enddate.equals("")) {
    while( thedate.get(Calendar.DAY_OF_WEEK) != 2 ) thedate.add(Calendar.DATE, 1) ; 
    fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
               Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
               Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    thedate.add(Calendar.DATE , 6) ; 
    enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
              Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
              Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
} 

ArrayList selectdates = new ArrayList() ; 
ArrayList selectweekdays = new ArrayList() ; 
ArrayList shiftids = new ArrayList() ; 
ArrayList shiftnames = new ArrayList() ; 
ArrayList reesourceshiftdates = new ArrayList() ; 
ArrayList resouceshiftids = new ArrayList() ; 
//String sql = "" ;
ArrayList<Integer> lsResource = null;
int selectcolcount = 0 ;

if(isself.equals("1")) {

    // 将开始日期到结束日期的每一天及其对应的星期放入缓存
    

    int fromyear = Util.getIntValue(fromdate.substring(0 , 4)) ; 
    int frommonth = Util.getIntValue(fromdate.substring(5 , 7)) ; 
    int fromday = Util.getIntValue(fromdate.substring(8 , 10)) ; 
    String tempdate = fromdate ; 

    thedate.set(fromyear,frommonth - 1 , fromday) ; 

    while( tempdate.compareTo(enddate) <= 0 ) {
        selectdates.add(tempdate) ; 
        selectweekdays.add("" + thedate.get(Calendar.DAY_OF_WEEK)) ; 

        thedate.add(Calendar.DATE , 1) ; 
        tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    }

    selectcolcount = selectdates.size() + 1 ; // 列数


    String sqlwhere1="";
    String sqlwhere2="";

	if(qname.length() > 0){
		sqlwhere1 +=  " and (b.lastname like '%" + qname +"%' or b.departmentid in (select id from hrmdepartment where departmentname like '%"+qname+"%'))"; 
		sqlwhere2 +=  " and (lastname like '%" + qname +"%' or departmentid in (select id from hrmdepartment where departmentname like '%"+qname+"%'))"; 
	}
    if(!fromdate.equals("")) { 
        sqlwhere1 += " and shiftdate >='" + fromdate + "'" ; 
    } 

    if(!enddate.equals("")) { 
        sqlwhere1 += " and shiftdate <='" + enddate + "'" ; 
    } 

    if(!departmentid.equals("")) { 
        sqlwhere1 += " and b.departmentid = " + departmentid ; 
        sqlwhere2 +=  " and departmentid = " + departmentid ; 
    } 

    if(!subcompanyid.equals("")) { 
      sqlwhere1 += " and b.subcompanyid1 = " + subcompanyid ; 
      sqlwhere2 +=  " and subcompanyid1 = " + subcompanyid ; 
    } 
    
    if(!strresourceid.equals("")) { 
      sqlwhere1 += " and b.id = " + strresourceid ; 
      sqlwhere2 +=  " and id = " + strresourceid ; 
    } 
    
    
    if(rightlevel.equals("0") ) {
        sqlwhere1 += " and b.departmentid = " + user.getUserDepartment() ; 
        sqlwhere2 +=  " and departmentid = " + user.getUserDepartment() ; 
    }
    else if(rightlevel.equals("1") ) {
        sqlwhere1 += " and b.subcompanyid1 = " + user.getUserSubCompany1() ; 
        sqlwhere2 +=  " and subcompanyid1 = " + user.getUserSubCompany1() ; 
    }

    lsResource = getLsResource(RecordSet,sqlwhere2);
//System.out.println("sqlwhere2:"+sqlwhere2);
    //sql = " select id from hrmresource where  status in(0,1,2,3) and  id in ( select resourceid from HrmArrangeShiftSet ) " + sqlwhere2 + " order by departmentid " ; 


    // 得到所有当前的排班种类，放入缓存
    RecordSet.executeSql("select id, shiftname from HrmArrangeShift where ishistory='0' order by id ") ; 
    while ( RecordSet.next() ) { 
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String shiftname = Util.toScreen(RecordSet.getString("shiftname") , user.getLanguage()) ; 
        shiftids.add(id) ; 
        shiftnames.add(shiftname) ; 
    } 

    // 得到选定人力资源范围和时间范围内的所有排班信息放入缓存，以人力资源加排班时间作为索引
    String sql = " select a.* from HrmArrangeShiftInfo a , Hrmresource b where a.resourceid = b.id ";
    String tmpWhere = Util.null2String(weaver.hrm.common.Tools.getOracleSQLIn(lsResource,"b.id"));
    if(tmpWhere.length()>0)sql	+= 	"and  " +tmpWhere;
    sql += sqlwhere1 ; 
      RecordSet.executeSql(sql);
    	while( RecordSet.next() ) { 
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ; 
        String shiftdate = Util.null2String(RecordSet.getString("shiftdate")) ; 
        String shiftid = Util.null2String(RecordSet.getString("shiftid")) ; 

        int reesourceshiftdateindex = reesourceshiftdates.indexOf(resourceid+"_"+shiftdate) ;
        if( reesourceshiftdateindex == -1 ) {
            reesourceshiftdates.add(resourceid+"_"+shiftdate) ;
            ArrayList tempshiftids = new ArrayList() ;
            tempshiftids.add(shiftid) ;
            resouceshiftids.add(tempshiftids) ;
        }
        else {
            ArrayList tempshiftids = (ArrayList) resouceshiftids.get(reesourceshiftdateindex) ;
            tempshiftids.add(shiftid) ;
            resouceshiftids.set(reesourceshiftdateindex ,tempshiftids) ;
        }
    } 
}

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32767,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(16749,user.getLanguage())+",javascript:showSet(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id = frmmain name = frmmain method = post action="HrmArrangeShiftMaintance.jsp">
<input class=inputstyle type="hidden" name="operation" value=save>
<input type="hidden" name="isself" value="1">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(32767,user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361 , user.getLanguage())%>'>
		    <wea:item><%=SystemEnv.getHtmlLabelName(1867 , user.getLanguage())%></wea:item>
		    <wea:item>
  				<brow:browser viewType="0" id="resourceid" name="resourceid" browserValue='<%=strresourceid %>' 
           browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
           hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
           completeUrl="/data.jsp" 
           browserSpanValue='<%=Util.toScreen(ResourceComInfo.getLastname(strresourceid),user.getLanguage()) %>'
           ></brow:browser>
		    </wea:item>
		   	<wea:item><%=SystemEnv.getHtmlLabelName(124 , user.getLanguage())%></wea:item>
		    <wea:item>
  				<brow:browser viewType="0" id="departmentid" name="departmentid" browserValue='<%=departmentid %>' 
           browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
           hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
           completeUrl="/data.jsp?type=4"
           browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(departmentid),user.getLanguage()) %>'
           ></brow:browser>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></wea:item>
		    <wea:item>
  				<brow:browser viewType="0" id="subcompanyid" name="subcompanyid" browserValue='<%=subcompanyid %>' 
           browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubCompanyBrowser.jsp?selectedids="
           hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
           completeUrl="/data.jsp?type=164"
           browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid),user.getLanguage()) %>'
           ></brow:browser>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(16694 , user.getLanguage())%></wea:item>
		    <wea:item>
		    <BUTTON class = calendar type="button" id = SelectDate onclick = getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
		    <SPAN id = fromdatespan><%=fromdate%></SPAN>
		    <input class=inputstyle type = "hidden" name = "fromdate" value=<%=fromdate%>>
		    	－&nbsp;&nbsp;<BUTTON class = calendar type="button" id = SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
		    <SPAN id=enddatespan ><%=enddate%></SPAN>
		    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
		    </wea:item>
		   	</wea:group>
				<wea:group context="">
					<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
					</wea:item>
				</wea:group>
	</wea:layout>
</div>


<% if(isself.equals("1")) { %>

<% 
for(int j=0 ; j< selectdates.size() ; j++ ) { 
    String thetempdate = (String) selectdates.get(j) ; 
%>
<input type = hidden name = "selectdate" value="<%=thetempdate%>">
<%}%>

<TABLE class=ListStyle cellspacing=1 >
<TBODY>
  <TR class = HeaderForXtalbe>
    <TH><%=SystemEnv.getHtmlLabelName(413 , user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(124 , user.getLanguage())%></TH>
  <%
    for(int i = 0 ; i < selectdates.size() ; i++ ) { 
        String thetempdate = (String) selectdates.get(i) ; 
        int thetempweekday = Util.getIntValue( (String) selectweekdays.get(i) ) ; 
  %>
    <TH><%=thetempdate%><br>
        <% if( thetempweekday == 1 ) { %><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%>
        <% } else if( thetempweekday == 2 ) { %><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%>
        <% } else if( thetempweekday == 3 ) { %> <%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%>
        <% } else if( thetempweekday == 4 ) { %><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%>
        <% } else if( thetempweekday == 5 ) { %><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%>
        <% } else if( thetempweekday == 6 ) { %><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%>
        <% } else if( thetempweekday == 7 ) { %><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%>
        <% } %>
    </TH>
  <% } %>
    </TR>
  <%
    boolean disablebutton = false  ; // 将今日之前 （包括今日）的排班设置disabled
    int recordecount = 0 ;           // 为每20条显示一个顶部栏来计算条数
    
    //RecordSet.executeSql(sql) ; 
   // while(RecordSet.next()) 	
  	for(int rowIndx=0;lsResource!=null&&rowIndx<lsResource.size();rowIndx++){
        int resourceid = lsResource.get(rowIndx) ; 
        recordecount ++ ;
        if(recordecount>20) {                   // 每20条显示一个顶部栏
            recordecount = 0 ;          
  %> 
        <TR class = HeaderForXtalbe>
            <TH><%=SystemEnv.getHtmlLabelName(413 , user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(124 , user.getLanguage())%></TH>
          <%
            for(int i = 0 ; i < selectdates.size() ; i++ ) { 
                String thetempdate = (String) selectdates.get(i) ; 
                int thetempweekday = Util.getIntValue( (String) selectweekdays.get(i) ) ; 
          %>
            <TH><%=thetempdate%><br>
                <% if( thetempweekday == 1 ) { %><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%>
                <% } else if( thetempweekday == 2 ) { %><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%>
                <% } else if( thetempweekday == 3 ) { %> <%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%>
                <% } else if( thetempweekday == 4 ) { %><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%>
                <% } else if( thetempweekday == 5 ) { %><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%>
                <% } else if( thetempweekday == 6 ) { %><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%>
                <% } else if( thetempweekday == 7 ) { %><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%>
                <% } %>
            </TH>
          <% } %>
            </TR>
 <%       }  %>
       <TR class='DataLight'> 
        <TD><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(""+resourceid) , user.getLanguage())+"/"+Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(""+resourceid)) , user.getLanguage())%>
            <input class=inputstyle type = hidden name = "selectresource" value="<%=resourceid%>" >
        </TD>
  <%
        for(int j = 0 ; j < selectdates.size() ; j++ ) {
            String thetempdate = (String) selectdates.get(j) ; 
            if( Util.dayDiff(currentdate,thetempdate) < -2 ) disablebutton=true ;  // 排班日期小于当天的前一天
            else disablebutton = false ;
  %>
        <TD>
  <%        
            int reesourceshiftdateindex = reesourceshiftdates.indexOf(resourceid+"_"+thetempdate) ;
            String shiftidstr = "" ;
            String shiftnamestr = "" ;
            if( reesourceshiftdateindex != -1 ) {
                ArrayList tempshiftids = (ArrayList) resouceshiftids.get(reesourceshiftdateindex) ;
                for(int k=0 ; k<tempshiftids.size(); k++) {
                    String tempshiftid = (String)tempshiftids.get(k) ;
                    int tempshiftidindex = shiftids.indexOf(tempshiftid) ;
                    if(tempshiftidindex != -1) {
                        if(shiftidstr.equals("")) {
                            shiftidstr = tempshiftid ;
                            shiftnamestr = (String)shiftnames.get(tempshiftidindex) ;
                        }
                        else {
                            shiftidstr += "," + tempshiftid ;
                            shiftnamestr += "," +(String)shiftnames.get(tempshiftidindex) ;
                        }
                    }
                }
            }
  %>
  <%        if(!disablebutton) {%>
      <BUTTON type="button" class=Browser onClick="onShowShift('<%=resourceid%>_<%=thetempdate%>_span','<%=resourceid%>_<%=thetempdate%>')"></BUTTON>
      <input class=inputstyle id="<%=resourceid%>_<%=thetempdate%>" type=hidden name="<%=resourceid%>_<%=thetempdate%>" value="<%=shiftidstr%>">
 <%         } %>
      <span class=inputstyle id="<%=resourceid%>_<%=thetempdate%>_span" name="<%=resourceid%>_<%=thetempdate%>_span"><%=shiftnamestr%></span> 
     </TD>
  <%    } %>
     </TR> 
  <% } %>
  </TBODY>
 </TABLE>
 <%}%>
 </form>
<script language = vbs>  
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if Not isempty(id) then
	if id(0)<> 0 then
        spanname.innerHtml = id(1)
        inputname.value=id(0)
	else
        spanname.innerHtml = ""
        inputname.value=""
	end if
	end if
end sub

sub onShowShift1(spanname , inputname)
    shiftidvalue = document.all(inputname).value 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmMutiArrangeShiftBrowser.jsp?shiftids="&shiftidvalue)
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            document.all(spanname).innerHtml = Mid(id(1),2,len(id(1)))
            document.all(inputname).value=Mid(id(0),2,len(id(0)))
        else 
            document.all(spanname).innerHtml = ""
            document.all(inputname).value=""
	end if
	end if
end sub

</script>

<script language=javascript>
 function doSave(obj) {
    document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
   	document.frmmain.operation.value="save" ;
    obj.disabled = true ;
	document.frmmain.submit() ; 
}
function submitData() {
 frmmain.submit();
}

function onShowShift(spanname , inputname){
    shiftidvalue = $G(inputname).value 
	results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmMutiArrangeShiftBrowser.jsp?shiftids="+shiftidvalue);
	if (results) {
        if (results.id!="") {
            $G(spanname).innerHTML =results.name;
            $G(inputname).value=results.id;
        }else{ 
            $G(spanname).innerHTML = "";
            $G(inputname).value="";
        }    
	}
  }

function openDialog(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmArrangeShiftProcess&isdialog=1"
					+"&departmentid=<%=departmentid%>&subcompanyid1=<%=subcompanyid%>&fromdate=<%=fromdate%>&enddate=<%=enddate%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32767,user.getLanguage())%>";
	dialog.Width = 500;
	dialog.Height = 303;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function showSet(){
	parent.location = "/hrm/HrmTab.jsp?_fromURL=HrmArrangeShiftMaintance&method=HrmArrangeShiftSet&fromdate=<%=fromdate%>&enddate=<%=enddate%>";
}
</script>
</body> 
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
