
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCL" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />

<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<% /*取出页面上的选定的各元素的值*/
String types="";  //“类型”Sql的初始化
String CustomerTypes[]=request.getParameterValues("CustomerTypes");//Types是一个数组
CRMSearchComInfo.resetSearchInfo();//对CRMSearchComInfo.set~()初始化
if(CustomerTypes != null)
{
	for(int i=0;i<CustomerTypes.length;i++)
	{
		CRMSearchComInfo.addCustomerType(CustomerTypes[i]);//把“类型”值传入到CRMSearchComInfo
		if(!types.equals("")){
			types=types+","+CustomerTypes[i];
		}else{
			types+=CustomerTypes[i];
		}
	}
}
String sector=Util.null2String(request.getParameter("CustomerSector"));
String desc=Util.null2String(request.getParameter("CustomerDesc"));
String status=Util.null2String(request.getParameter("CustomerStatus"));
String size=Util.null2String(request.getParameter("CustomerSize"));
//把值传入到CRMSearchComInfo
CRMSearchComInfo.setCustomerSector(sector);
CRMSearchComInfo.setCustomerDesc(desc);
CRMSearchComInfo.setCustomerStatus(status);
CRMSearchComInfo.setCustomerSize(size);


String sqlwhere = "";

int ishead = 0;//ishead = 0表示前无条件，ishead = 1表前已有条件
if(!sector.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.sector = "+ sector + " ";
	}else{
		sqlwhere += " and t1.sector = "+ sector + " ";
		}
}
if(!desc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description = "+ desc + " ";
	}else{
		sqlwhere += " and t1.description = "+ desc + " ";
		}
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status = "+ status + " ";
	}else{
		sqlwhere += " and t1.status = "+ status + " ";
		}

}
if(!size.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.size_n = "+ size + " ";
	}else{
		sqlwhere += " and t1.size_n = "+ size + " ";
		}

}
if(!types.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.type in ("+ types + ") ";// “类型”值可为多个，故用in( )
	}
	else
		sqlwhere += " and t1.type in ("+ types + ") ";
}

if(ishead==0){
	//注意此处不要ishead=1
		sqlwhere += " where t1.city <>0 ";//排除city值为0的情况
	}
	else
		sqlwhere += " and t1.city <>0 ";



/*得出全句Sql,执行，得出一个满足条件的所有city集合Sql语句*/
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String sqlstr = "";
if(user.getLogintype().equals("1")){
	 sqlstr = "select t1.city,t1.type,count(distinct t1.id) as toutalcount from CRM_CustomerInfo  t1,"+leftjointable+"  t2 "+ sqlwhere +"  and t1.id = t2.relateditemid and t1.deleted = 0 group by t1.city,t1.type order by t1.city";
}else{
	 sqlstr = "select t1.city,t1.type,count(t1.id) as toutalcount from CRM_CustomerInfo  t1 "+ sqlwhere +" and t1.agent="+user.getUID() + "  and t1.deleted = 0 group by t1.city,t1.type order by t1.city";
}

RecordSet.executeSql(sqlstr);
ArrayList cityids = new ArrayList();
ArrayList dspstrings = new ArrayList();
int lastcity = 0;
int curcity = 0;
String strTemp = "";
while(RecordSet.next()){
	if((curcity=Util.getIntValue(RecordSet.getString(1),0))==0){
		continue;
	}
	if(curcity==lastcity){
		strTemp += CustomerTypeComInfo.getCustomerTypename(RecordSet.getString(2))+":"+RecordSet.getString(3)+" ";
	}else{
		if(lastcity!=0){
			cityids.add(""+lastcity);
			dspstrings.add(strTemp);
		}
		lastcity=curcity;
		strTemp = CustomerTypeComInfo.getCustomerTypename(RecordSet.getString(2))+":"+RecordSet.getString(3)+" ";
	}
}

if(lastcity!=0){//最后一组数据
	cityids.add(""+lastcity);
	dspstrings.add(strTemp);
}


//页面的相关定义
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY style="height:auto">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<form name=frmmain id=weaver method=post action="/CRM/report/AddressRpSumChild.jsp">
<wea:layout type="4Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item attributes="{'colspan':'3'}">
				<%//显示所有类型的及相关值
					RecordSetCT.executeProc("CRM_CustomerType_SelectAll","");
					int nCount = 0;
					while(RecordSetCT.next()){
						nCount++;
						if(CRMSearchComInfo.isCustomerTypeSel(nCount)){%>			
								<INPUT name="CustomerTypes" type="checkbox" value="<%=nCount%>" checked>
									<%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
						<%}else{%>			
								<INPUT name="CustomerTypes" type="checkbox" value="<%=nCount%>">
									<%=Util.toScreen(RecordSetCT.getString("fullname"),user.getLanguage())%>
						<%}
				}%>			
	  </wea:item>
          
      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
      <wea:item>
      	<brow:browser viewType="0" name="CustomerStatus" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
		     browserValue='<%=CRMSearchComInfo.getCustomerStatus()+""%>' 
		     browserSpanValue = '<%=CustomerStatusComInfo.getCustomerStatusname(CRMSearchComInfo.getCustomerStatus())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=customerStatus" width="150px" ></brow:browser>
      </wea:item> 
		
      <wea:item><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></wea:item>
          
      <wea:item>
      	<brow:browser viewType="0" name="CustomerSize" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp"
		     browserValue='<%=CRMSearchComInfo.getCustomerSize()+""%>' 
		     browserSpanValue = '<%=CustomerSizeComInfo.getCustomerSizedesc(CRMSearchComInfo.getCustomerSize())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=customerSize" width="150px" ></brow:browser>
       </wea:item>
          
      <wea:item><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></wea:item>
      <wea:item>
      	<brow:browser viewType="0" name="CustomerSector" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
		     browserValue='<%=CRMSearchComInfo.getCustomerSector()+""%>' 
		     browserSpanValue = '<%=SectorInfoComInfo.getSectorInfoname(CRMSearchComInfo.getCustomerSector())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=sector" width="150px" ></brow:browser>
      </wea:item>
          
      <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
      <wea:item>
      	<brow:browser viewType="0" name="CustomerDesc" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp"
		     browserValue='<%=CRMSearchComInfo.getCustomerDesc()+""%>' 
		     browserSpanValue = '<%=CustomerDescComInfo.getCustomerDescname(CRMSearchComInfo.getCustomerDesc())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=customerDesc" width="150px" ></brow:browser>
      </wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<DIV style="POSITION: relative;margin-top:10%;margin-left:10%;width:745px;height:427px;"><IMG src="/images/chinamap_wev8.gif" width =745 height=427 style="filter: Alpha(Opacity=70)" >
<%
for(int i=0;i<cityids.size();i++){

	 String cityname=CityComInfo.getCityname(cityids.get(i).toString());
     float citylongitude=Util.getFloatValue(CityComInfo.getCitylongitude(cityids.get(i).toString()));//得经度
	 float citylatitude=Util.getFloatValue(CityComInfo.getCitylatitude(cityids.get(i).toString()));//得纬度
	 String cityid=cityids.get(i).toString();
	 String strData=dspstrings.get(i).toString();
%>
<TABLE bgColor=lime border=1 cellPadding=1 cellSpacing=1 height=5 id=txt 
style="BORDER-BOTTOM-COLOR: black; BORDER-LEFT-COLOR: black; BORDER-RIGHT-COLOR: black; BORDER-TOP-COLOR: black; CURSOR: hand; LEFT: <%=(citylongitude-72.5)*745/63.0%>px; POSITION: absolute; TOP:<%=(53.3-citylatitude)*427/35.3%>px;" title="<%=cityname%>:(<%=strData%>)" 
width=5 onclick="showDetailInfo(<%=cityid%>)">		
	<TBODY>  <TR>    <TD></TD></TR><tr><td class=Line colspan=4></td></tr></TBODY>
</TABLE>
<%}%>
</div>
<script type="text/javascript">
$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
  });
  
  function showDetailInfo(cityid){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>";
		dialog.Width = 800;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = "/CRM/search/SearchOperation.jsp?msg=report&settype=customercity&customercity="+cityid;
		dialog.show();
	}
</script>
</BODY>
</HTML>


