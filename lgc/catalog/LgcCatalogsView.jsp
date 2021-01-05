<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LgcSearchComInfo" class="weaver.lgc.search.LgcSearchComInfo" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<jsp:useBean id="AssetAssortmentList" class="weaver.lgc.maintenance.AssetAssortmentList" scope="page" />

<%
String id = Util.null2String(request.getParameter("id"));
String userseclevel = user.getSeclevel() ;
if(id.equals("")) {
	RecordSet.executeProc("LgcCatalogs_SDefaultByUser",userseclevel);
	if(RecordSet.next()) id = Util.null2String(RecordSet.getString(1));
}

RecordSet.executeProc("LgcCatalogs_SelectByID",id);
if(!RecordSet.next()) {
	 response.sendRedirect("/lgc/search/LgcSearch.jsp");
	 return ;
}
	
String catalogname = Util.toScreen(RecordSet.getString("catalogname"),user.getLanguage()) ;
String catalogdesc = Util.toScreen(RecordSet.getString("catalogdesc"),user.getLanguage()) ;
String catalogorder = Util.null2String(RecordSet.getString("catalogorder")) ;
int perpage = Util.getIntValue(RecordSet.getString("perpage"),0) ;
if(perpage<=1 )	perpage=10;
String seclevelfrom = Util.null2String(RecordSet.getString("seclevelfrom")) ;
String seclevelto = Util.null2String(RecordSet.getString("seclevelto")) ;
String navibardsp = Util.null2String(RecordSet.getString("navibardsp")) ;
String navibarbgcolor = Util.null2String(RecordSet.getString("navibarbgcolor")) ;
String navibarfontcolor = Util.null2String(RecordSet.getString("navibarfontcolor")) ;
String navibarfontsize = Util.null2String(RecordSet.getString("navibarfontsize")) ;
String navibarfonttype = Util.null2String(RecordSet.getString("navibarfonttype")) ;
String toolbardsp = Util.null2String(RecordSet.getString("toolbardsp")) ;
String toolbarwidth = Util.null2String(RecordSet.getString("toolbarwidth")) ;
String toolbarbgcolor = Util.null2String(RecordSet.getString("toolbarbgcolor")) ;
String toolbarfontcolor = Util.null2String(RecordSet.getString("toolbarfontcolor")) ;
String toolbarlinkbgcolor = Util.null2String(RecordSet.getString("toolbarlinkbgcolor")) ;
String toolbarlinkfontcolor = Util.null2String(RecordSet.getString("toolbarlinkfontcolor")) ;
String toolbarfontsize = Util.null2String(RecordSet.getString("toolbarfontsize")) ;
String toolbarfonttype = Util.null2String(RecordSet.getString("toolbarfonttype")) ;
String countrydsp = Util.null2String(RecordSet.getString("countrydsp")) ;
String countrydeftype = Util.null2String(RecordSet.getString("countrydeftype")) ;
String countryid = Util.null2String(RecordSet.getString("countryid")) ;
String searchbyname = Util.null2String(RecordSet.getString("searchbyname")) ;
String searchbycrm = Util.null2String(RecordSet.getString("searchbycrm")) ;
String searchadv = Util.null2String(RecordSet.getString("searchadv")) ;
String assortmentdsp = Util.null2String(RecordSet.getString("assortmentdsp")) ;
String assortmentname = Util.toScreen(RecordSet.getString("assortmentname"),user.getLanguage()) ;
String assortmentsql = Util.toScreen(RecordSet.getString("assortmentsql"),user.getLanguage()) ;
String attributedsp = Util.null2String(RecordSet.getString("attributedsp")) ;
String attributecol = Util.null2String(RecordSet.getString("attributecol")) ;
String attributefontsize = Util.null2String(RecordSet.getString("attributefontsize")) ;
String attributefonttype = Util.null2String(RecordSet.getString("attributefonttype")) ;
String assetsql = Util.toScreen(RecordSet.getString("assetsql"),user.getLanguage()) ;
String assetcolname[] = new String[6] ;
String assetcolvalue[] = new String[6] ;
for(int i=1 ; i<7 ; i++) {
String tempstr = Util.null2String(RecordSet.getString("assetcol"+i));
if(tempstr.equals("")) {
	assetcolname[i-1]="";
	assetcolvalue[i-1]="";
	continue ;
}
String tempcol[] = Util.TokenizerString2(tempstr,"|");
assetcolname[i-1] = tempcol[0] ;
assetcolvalue[i-1] = tempcol[1] ;
}
String assetfontsize = Util.null2String(RecordSet.getString("assetfontsize")) ;
String assetfonttype = Util.null2String(RecordSet.getString("assetfonttype")) ;
String webshopdap = Util.null2String(RecordSet.getString("webshopdap")) ;
String webshoptype = Util.null2String(RecordSet.getString("webshoptype")) ;
String webshopreturn = Util.null2String(RecordSet.getString("webshopreturn")) ;
String webshopmanageid = Util.null2String(RecordSet.getString("webshopmanageid")) ;
String createrid = Util.toScreenToEdit(RecordSet.getString("createrid"),user.getLanguage()) ;					/*创建人id*/
String createdate = Util.toScreenToEdit(RecordSet.getString("createdate"),user.getLanguage()) ;					/*创建日期*/
String lastmodid = Util.toScreenToEdit(RecordSet.getString("lastmoderid"),user.getLanguage()) ;					/*最后修改人id*/
String lastmoddate = Util.toScreenToEdit(RecordSet.getString("lastmoddate"),user.getLanguage()) ;

String selectallvalue = Util.null2String(request.getParameter("selectallvalue"));
String theattribute = Util.null2String(request.getParameter("theattributes"));
if(theattribute.equals("")) {
	if(selectallvalue.equals("0")) {
		String theattributes[] = request.getParameterValues("theattribute") ;
		if(theattributes != null) {
			for(int i=0 ; i<theattributes.length ; i++) {
				if( theattributes[i] != null) theattribute += theattributes[i] + "|" ;
			}
		}
	}
}

String thecountry = Util.null2String(request.getParameter("thecountry"));
if(thecountry.equals("")) {
	if(countrydeftype.equals("0")) thecountry = user.getCountryid() ;
	else thecountry = countryid ;
}
if(thecountry.equals("")) thecountry="0" ;
String theassortment = Util.null2String(request.getParameter("theassortment"));
String theassetname = Util.null2String(request.getParameter("theassetname"));
String thecrmid = Util.null2String(request.getParameter("thecrmid"));
String isthenew = Util.null2String(request.getParameter("isthenew"));


String selectedid ="" ;
String oldselectedid = Util.null2String(request.getParameter("selectedid"));
String newselectedid = Util.null2String(request.getParameter("newselectedid"));
String addorsub = Util.null2String(request.getParameter("addorsub"));
if(!newselectedid.equals("")) {
	if(addorsub.equals("1")) selectedid = oldselectedid+newselectedid+"|" ;
	else selectedid = Util.StringReplace(oldselectedid,newselectedid+"|" , "") ;
}
else selectedid = oldselectedid ;
AssetAssortmentList.initAssetAssortmentList(selectedid);
		
int start = Util.getIntValue(request.getParameter("start") , 1) ;
String linkstr = "LgcCatalogsView.jsp?id="+id+"&isthenew=0&selectedid="+selectedid+"&theassortment="+theassortment+
				 "&theattributes="+theattribute+"&thecountry="+thecountry ;

String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = catalogname ;
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>
TR.DataDark {
	BACKGROUND-COLOR: #f2f2f2
}
TR.DataLight {
	BACKGROUND-COLOR: #ffffff
}
TD.DataDark {
	BACKGROUND-COLOR: #f2f2f2
}
TD.DataLight {
	BACKGROUND-COLOR: #ffffff
}
.NavBar {
	FONT-WEIGHT: <%=navibarfonttype%>; FONT-SIZE: <%=navibarfontsize%> ; COLOR: #<%=navibarfontcolor%>
}
.NavBarSelected {
	FONT-WEIGHT: <%=navibarfonttype%>; FONT-SIZE: <%=navibarfontsize%>
}

.SideBarText {
	FONT-WEIGHT: <%=toolbarfonttype%>; FONT-SIZE: <%=toolbarfontsize%> ; COLOR: #<%=toolbarfontcolor%>
}
.SideBarLink {
	FONT-WEIGHT: <%=toolbarfonttype%>; FONT-SIZE: <%=toolbarfontsize%>; COLOR: #<%=toolbarlinkfontcolor%>
}

.ProductHeading {
	FONT-WEIGHT: <%=assetfonttype%>; FONT-SIZE: <%=assetfontsize%>
}
.ProductText {
	FONT-WEIGHT: <%=assetfonttype%>; FONT-SIZE: <%=assetfontsize%>
}

.FilterText {
	FONT-WEIGHT: <%=attributefonttype%>; FONT-SIZE: <%=attributefontsize%>
}

FORM {
	MARGIN: 0px
}
</STYLE>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>

<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width=2></TD>
	
    <TD vAlign=top>
	
	
	
	<!-- Navigation bar -->
	<% if(navibardsp.equals("1")) {%>
      <DIV>
      <TABLE cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
		<%
			RecordSet.executeProc("LgcCatalogs_SelectByUser",userseclevel);
			while(RecordSet.next()) {
				String theid = Util.null2String(RecordSet.getString("id")) ;
				String thecatalogname = Util.toScreen(RecordSet.getString("catalogname"),user.getLanguage()) ;
				String thenavibarbgcolor = Util.null2String(RecordSet.getString("navibarbgcolor")) ;
		%>
          <TD vAlign=top align=left bgColor="#<%=thenavibarbgcolor%>"><IMG height=8 
            src="/images/bp_tab_left_white_wev8.gif" width=6 border=0></TD>
          <TD bgColor="#<%=thenavibarbgcolor%>">
		  <% if(theid.equals(id)) {%>
		  <span class=NavBar><%=thecatalogname%></span>
		  <%} else {%>
		  <A class=NavBar 
            href="LgcCatalogsView.jsp?id=<%=theid%>"><%=thecatalogname%></A><%}%>&nbsp;</TD>
          <TD vAlign=top align=left bgColor="#<%=thenavibarbgcolor%>"><IMG height=8 
            src="/images/bp_tab_right_white_wev8.gif" width=6 border=0></TD>
      	  <%}%>    
		  </TR>
		 </TBODY>
		</TABLE>
	  </DIV>
      <DIV style="HEIGHT: 5px; BACKGROUND-COLOR: #<%=navibarbgcolor%>"></DIV>
	  <%}%>
      
	  <FORM id=frmmain action=LgcCatalogsView.jsp method=post>
	  	<input type=hidden name=selectedid value="<%=selectedid%>">
		<input type=hidden name=addorsub>
		<input type=hidden name=newselectedid>
		<input type=hidden name=theassortment value="<%=theassortment%>">
        <input type=hidden name=selectallvalue value=0>
        <input type=hidden name=id value=<%=id%>>
        <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 >
        <TBODY>
        <TR><!-- Content area -->
		
		<% if(toolbardsp.equals("1")) {%>
		  <TD vAlign=top width=<%=toolbarwidth%> bgColor=#<%=toolbarbgcolor%>><!-- Sidebar --> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#<%=toolbarbgcolor%> border=0 height="100%">
              <TBODY>
              <TR>
                <TD vAlign=top width=<%=toolbarwidth%>>
                  <TABLE cellSpacing=0 cellPadding=0 width=<%=toolbarwidth%> border=0>
                    <TBODY>
					<% if(countrydsp.equals("1")) {%>
                    <TR>
                      <TD><!-- Country and Search -->
                        <!-- FORM id=frmCountry action=LgcCatalogsView.jsp method=post -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR>
                            <TD><SPAN class=SideBarText>国家</SPAN></TD></TR>
                          <TR>
                            <TD><SELECT style="WIDTH: 100%" onchange=frmmain.submit() name=thecountry> 
                                <OPTION value="0">- 全球 -</OPTION> 
								<%
									while(CountryComInfo.next()) {
										String thecountryid = CountryComInfo.getCountryid() ;
								%>
								<OPTION value="<%=thecountryid%>" <% if(thecountry.equals(thecountryid)) {%> selected <%}%>><%=Util.toScreen(CountryComInfo.getCountrydesc(),user.getLanguage())%></OPTION> 
								<%}%>
								</SELECT> 
                        </TD></TR></TBODY></TABLE><!--/FORM -->
					  </TD>
					</TR>
					<%}%>
					
					<% if(searchbyname.equals("1") || searchbycrm.equals("1") || searchadv.equals("1")) {%>
                    <TR>
                      <TD><!-- Search -->
                        <!-- FORM id=frmSearch 
                        action=BLCatalogue.asp?Catalog=shop&amp;Reload=1&amp;Country=CN&amp;Show=1&amp;Account=&amp;Assortment=1 
                        method=post -->
                          <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                            <TBODY> 
                            <TR> 
                              <TD colSpan=3><SPAN  class=SideBarText>搜索</SPAN></TD>
                            </TR>
                            <% if(searchbyname.equals("1")) {%>
                            <tr> 
                              <td><SPAN  class=SideBarText>关键字</span></td>
                              <td width=180 colspan="2"> 
                                <input style="WIDTH: 100%"  name=theassetname>
                              </td>
                            </tr>
                            <%} if(searchbycrm.equals("1")) {%>
                            <TR> 
                              <td><SPAN  class=SideBarText>CRM</span></td>
                              <td width=180 colspan="2"> <button class=Browser id=SelectCrm onClick="onShowCrmID(crmidspan,thecrmid)"></button> 
                                <span class=InputStyle id=crmidspan></span> 
                                <input type=hidden id=thecrmid name=thecrmid>
                              </td>
                            </tr>
                            <%}%>
                            <TR> 
                              <td></td>
                              <td width=160 align="right"><%if(searchadv.equals("1")) {%><A class=SideBarText href="/lgc/search/LgcSearch.jsp">高级</A><%}%></td>
                              <td width=20><INPUT type=image height=18 alt=Go width=18 src="/images/BacoSearch_wev8.gif" border=0></td>
                            </TR>
                            </TBODY> 
                          </TABLE>
                          <!--/FORM -->
						</TD>
					</TR>
					<%}%>
					
					<% if(navibardsp.equals("2")) {%>
                    <TR>
                      <TD><!-- Categories -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR><TD>&nbsp;</TD></TR>
                          <TR>
                            <TD align=left width="100%"><SPAN class=SideBarText>导航条</SPAN></TD></TR>
                          <TR>
                            <TD vAlign=top>
                              <TABLE cellSpacing=0 cellPadding=1 width="100%" bgColor=<%=toolbarlinkbgcolor%> border=0>
                                <TBODY>
									<%
										RecordSet.executeProc("LgcCatalogs_SelectByUser",userseclevel);
										while(RecordSet.next()) {
											String theid = Util.null2String(RecordSet.getString("id")) ;
											String thecatalogname = Util.toScreen(RecordSet.getString("catalogname"),user.getLanguage()) ;
									%>
									<TR>
									<TD><A class=SideBarLink href="LgcCatalogsView.jsp?id=<%=theid%>"><%=thecatalogname%></A></TD>
									</TR>
									<%}%>
								</TBODY></TABLE>
							    </TD>
							 </TR>
						  </TBODY></TABLE>
					  </TD>
					</TR>
					<%}%>
					
					
					<% if(assortmentdsp.equals("1")) {%>
                    <TR>
                      <TD><!-- Categories -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR><TD>&nbsp;</TD></TR>
                          <TR>
                            <TD align=left width="100%"><SPAN class=SideBarText><%=assortmentname%></SPAN></TD></TR>
                          <TR>
                            <TD vAlign=top>
                              <TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=<%=toolbarlinkbgcolor%> border=0>
                                <TBODY>
								<%
								ArrayList rootids = new ArrayList() ;
								if(assortmentsql.equals("")) rootids.add("0") ;
								else {
									try {
										RecordSet.executeSql("select id from LgcAssetAssortment where " +  assortmentsql) ;
										while(RecordSet.next()) rootids.add(RecordSet.getString(1)) ;
									}catch(Exception ex) {}
								}
								
								for(int rootidindex = 0 ; rootidindex<rootids.size() ; rootidindex++) { %>
								<TR><TD height=8></td></tr>
								<%	AssetAssortmentList.setAssetAssortmentList((String)rootids.get(rootidindex));
									while(AssetAssortmentList.next()){
										String assortmentstep = AssetAssortmentList.getAssortmentStep();
										String assortmentid = AssetAssortmentList.getAssortmentId();
										String assortmentmark = AssetAssortmentList.getAssortmentMark();
										String theassortmentname = AssetAssortmentList.getAssortmentName();
										String assortmentimage = AssetAssortmentList.getAssortmentImage();
										String assetcount =  AssetAssortmentList.getAssetCount();
										String subassortmentcount = AssetAssortmentList.getSubAssortmentCount();
										String supassortmentid = AssetAssortmentList.getSupAssortmentId();
										int tdwidth = Util.getIntValue(assortmentstep)*15 ;
								%>
                                 <TR><TD>
									<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
									<td width="<%=tdwidth%>"><img src="0_wev8.gif" width="<%=tdwidth%>" height="1"></td>
									<td WIDTH="20px" align="left">
									<%if(assortmentimage.equals("1")) {%>
									<IMG SRC="\images\btnDocExpand_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px" onClick="changeassortment('<%=assortmentid%>','1')" style="CURSOR:'HAND'" >
									<%} else if(assortmentimage.equals("2")) {%>
									<IMG SRC="\images\btnDocCollapse_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px" onClick="changeassortment('<%=assortmentid%>','0')" style="CURSOR:'HAND'">
									<% } %>
									</td>
									<td  align="left"><A HREF="LgcCatalogsView.jsp?id=<%=id%>&theassortment=<%=assortmentid%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>"  class=SideBarLink><%=theassortmentname%></a></td>
									</tr></table>
								  </TD></TR>
								<%}}%>
								</TBODY>
								</TABLE>
							  </TD>
							</TR>
						  </TBODY></TABLE>
					  </TD>
					</TR>
					<%}%>
					
					
					<% if(webshopdap.equals("1")) {%>
                    <TR>
                      <TD><!-- Shopping -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR><TD>&nbsp;</TD></TR>
                          <TR>
                            <TD align=left><SPAN class=SideBarText>购物</SPAN></TD></TR>
                          <TR>
                            <TD vAlign=top>
                              <TABLE cellSpacing=0 cellPadding=1 width="100%" bgColor=<%=toolbarlinkbgcolor%> border=0>
                                <TBODY>
                                <TR>
                                <TD>
								<% 
								int buycount = Util.getIntValue(Util.getCookie(request, "CoItemAll_"+user.getUID()),0) ;
								if( buycount !=0) { %>
								<A class=SideBarLink href="LgcAssetBasket.jsp?catalogid=<%=id%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattribute%>&isthenew=0&start=<%=start%>&webshoptype=<%=webshoptype%>&webshopmanageid=<%=webshopmanageid%>"><%} else {%><SPAN class=SideBarLink><%}%>购物车<% if( buycount ==0) { %></span><%}%>
								<% if( buycount !=0) { %>
								(<%=buycount%>) </A><%}%></TD>
								</TR>
								</TBODY></TABLE>
							</TD></TR>
						</TBODY></TABLE>
					  </TD>
					</TR>
					<%}%>
					
                   </TBODY></TABLE></TD></TR></TBODY></TABLE></TD>
			<%}%>  
			
			
			<!-- end toolbar -->
          
		  <TD vAlign=top>
		  
		  <!-- Attribute -->
		  <% if(attributedsp.equals("1")) {
		  		  int theattributecount = 0 ;
				  int theattributecol = Util.getIntValue(attributecol,0) ;
		  %>
            <TABLE class=ListStyle cellSpacing=2 border=0>
              <TBODY>
              <TR class=Spacing>
                <TD class=Line1></TD></TR>
              <TR>
                <TD>
                  <!-- FORM id=frmAttr action=LgcCatalogsView.jsp method=post -->
                  <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
                    <TBODY>
                    <TR>
                      <TD><SPAN class=FilterText>
					  <INPUT style="HEIGHT: 14px" onclick="selectallattr()" type=checkbox <% if(theattribute.equals("")) {%> CHECKED disabled <%}%>
                        name=theattribute value=""><B>--全部--</B></SPAN></TD>
					 <% theattributecount++ ; if(theattributecount==theattributecol) {%>
					 </tr><tr>
					 <%}%>
                      <TD><SPAN class=FilterText><INPUT style="HEIGHT: 14px" 
                        onclick=frmmain.submit() type=checkbox name=theattribute value="1" <% if(theattribute.indexOf("1|") >=0 ) {%> CHECKED <%}%>>销售</SPAN></TD>
                      <% theattributecount++ ; if(theattributecount==theattributecol) {%>
					 </tr><tr>
					 <%}%>
					 <TD><SPAN class=FilterText><INPUT style="HEIGHT: 14px" 
                        onclick=frmmain.submit() type=checkbox name=theattribute value="2" <% if(theattribute.indexOf("2|") >=0 ) {%> CHECKED <%}%>>采购</SPAN></TD>
                      <% theattributecount++ ; if(theattributecount==theattributecol) {%>
					 </tr><tr>
					 <%}%>
					 <TD><SPAN class=FilterText><INPUT style="HEIGHT: 14px" 
                        onclick=frmmain.submit() type=checkbox name=theattribute value="3" <% if(theattribute.indexOf("3|") >=0 ) {%> CHECKED <%}%>>库存</SPAN></TD>
                      <% theattributecount++ ; if(theattributecount==theattributecol) {%>
					 </tr><tr>
					 <%}%>
					 <TD><SPAN class=FilterText><INPUT style="HEIGHT: 14px" 
                        onclick=frmmain.submit() type=checkbox name=theattribute value="4" <% if(theattribute.indexOf("4|") >=0 ) {%> CHECKED <%}%>>网上销售</SPAN></TD>
                      <% theattributecount++ ; if(theattributecount==theattributecol) {%>
					 </tr><tr>
					 <%}%>
					 <TD><SPAN class=FilterText><INPUT style="HEIGHT: 14px" 
                        onclick=frmmain.submit() type=checkbox name=theattribute value="5" <% if(theattribute.indexOf("5|") >=0 ) {%> CHECKED <%}%>>批号</SPAN></TD>
					  </TR>
					</TBODY>
				   </TABLE>
				 <!--/FORM -->
				 </TD>
			    </TR>
			  </TBODY>
			 </TABLE>
			<%}%>
			
			
            <TABLE class=ListStyle cellSpacing=2 border=0>
              <TBODY>
              <TR class=Title>
                  <TH><SPAN class=ListHdr>物品</SPAN></TH>
              </TR>
              <TR class=Spacing>
                <TD class=Line1></TD></TR>
              <TR>
                <TD>
                    <TABLE width="100%" border=0>
                      <TBODY> 
                      <TR class=Header> 
                        <% for(int i=0 ; i<6 ; i++) {
							if(assetcolname[i].equals("")) continue ;
					  %>
                        <td><%=SystemEnv.getHtmlLabelName(Util.getIntValue(assetcolname[i]),user.getLanguage())%></td>
                        <%} if(webshopdap.equals("1")) {%>
                        <TD>购买</TD>
                        <%}%>
                      </TR>
                      <% boolean isLight = false;
					  	if(!isthenew.equals("0")) {
							LgcSearchComInfo.resetSearchInfo() ;
							LgcSearchComInfo.setAssetcountry(thecountry) ;
							if(!assetsql.equals("")) LgcSearchComInfo.setAssetsql(Util.fromScreen2(assetsql,user.getLanguage())) ;
							if(!theassortment.equals("")) LgcSearchComInfo.setAssetassortment(theassortment) ;
							if(webshopdap.equals("1") && theattribute.indexOf("4|") <0 ) theattribute += "4|" ;
							if(!theattribute.equals("")) LgcSearchComInfo.setAssetattribute(theattribute) ;
							if(!theassetname.equals("")) {
								LgcSearchComInfo.setIskeyword("1") ;
								LgcSearchComInfo.setAssetname(Util.fromScreen2(theassetname,user.getLanguage())) ;
							}
							if(!thecrmid.equals(""))  LgcSearchComInfo.setCrmid(thecrmid) ;
						}
						
                        String tablename = "lgccattemptable"+ Util.getRandom() ;

						String theassetsql = LgcSearchComInfo.FormatSQLSearch() ;
                        theassetsql = "select LgcAsset.id,assetmark,barcode,seclevel,assetimageid,assettypeid,"+
						"assetunitid,assetversion,counttypeid,assortmentid,assetname,assetcountyid,"+
						"startdate,enddate,departmentid,resourceid,assetremark,currencyid,"+
						"salesprice,costprice,createrid,createdate,lastmoderid,lastmoddate " +
						"into "+tablename+" from LgcAsset,LgcAssetCountry " + theassetsql ;

						RecordSet.executeSql(theassetsql);
                        RecordSet.executeSql(" select count(id) from "+ tablename );
                        RecordSet.next() ;
                        int recordersize = RecordSet.getInt(1) ;

                        String sqltemp="delete from "+tablename+" where id in(select top "+(start-1)+" id from "+ tablename+ ")";
                        RecordSet.executeSql(sqltemp);
                        sqltemp="select top "+perpage+" * from "+ tablename;
                        RecordSet.executeSql(sqltemp);
                        RecordSet.executeSql("drop table "+ tablename);
						
						while(RecordSet.next()){
							int thefirst = 0 ;
							String theassetid = RecordSet.getString("id") ;
							if(isLight) {%>
                      <TR CLASS=DataLight> 
                        <%} else { %>
					  <TR class=DataDark>
						<%}
								for(int i=0; i<6 ; i++ ) {
									if(assetcolvalue[i].equals("")) continue ;
									String thevalue = Util.toScreen(RecordSet.getString(assetcolvalue[i]),user.getLanguage()) ;
									if(thefirst == 0) 
										thevalue="<a href='/lgc/asset/LgcAsset.jsp?paraid="+theassetid+"&assetcountryid="+thecountry+"'>"+thevalue+"</a>";
									if(assetcolvalue[i].equals("assetimageid")) {
							 			if(!thevalue.equals("0")&&!thevalue.equals("")) thevalue="<img src='/weaver/weaver.file.FileDownload?fileid="+Util.getFileidOut(thevalue)+"'> " ;
										else thevalue= "" ;
									}
									if(assetcolvalue[i].equals("assettypeid")) 
										thevalue= Util.toScreen(AssetTypeComInfo.getAssetTypename(thevalue),user.getLanguage()) ;
									if(assetcolvalue[i].equals("assetunitid")) 
										thevalue= Util.toScreen(AssetUnitComInfo.getAssetUnitname(thevalue),user.getLanguage()) ;
									if(assetcolvalue[i].equals("assortmentid")) 
										thevalue= Util.toScreen(AssetAssortmentComInfo.getAssortmentName(thevalue),user.getLanguage()) ;
									if(assetcolvalue[i].equals("assetcountyid")) 
										thevalue= Util.toScreen(CountryComInfo.getCountrydesc(thevalue),user.getLanguage());
									if(assetcolvalue[i].equals("departmentid")) 
										thevalue= "<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+thevalue+"'>" +
												  Util.toScreen(DepartmentComInfo.getDepartmentname(thevalue),user.getLanguage())+"</a>" ;
									if(assetcolvalue[i].equals("resourceid")) 
										thevalue= "<a href='/hrm/resource/HrmResource.jsp?id="+thevalue+"'>"+
												  Util.toScreen(ResourceComInfo.getResourcename(thevalue),user.getLanguage())+"</a>" ;
									if(assetcolvalue[i].equals("currencyid")) 
										thevalue= Util.toScreen(CurrencyComInfo.getCurrencyname(thevalue),user.getLanguage()) ;
									if(assetcolvalue[i].equals("createrid")) 
										thevalue= "<a href='/hrm/resource/HrmResource.jsp?id="+thevalue+"'>"+
												  Util.toScreen(ResourceComInfo.getResourcename(thevalue),user.getLanguage())+"</a>" ;
									if(assetcolvalue[i].equals("lastmoderid")) 
										thevalue= "<a href='/hrm/resource/HrmResource.jsp?id="+thevalue+"'>"+
												  Util.toScreen(ResourceComInfo.getResourcename(thevalue),user.getLanguage())+"</a>" ;
									thefirst ++ ;	
							%>
                        <TD vAlign=top><SPAN class=ProductText><%=thevalue%></SPAN></TD>
                        <%} if(webshopdap.equals("1")) {%>
                        <TD vAlign=top align=right width=40> 
                          <a href="LgcAssetBasketOperation.jsp?operation=add&catalogid=<%=id%>&assetid=<%=theassetid%>&webshopreturn=<%=webshopreturn%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattribute%>&isthenew=0&start=<%=start%>&webshoptype=<%=webshoptype%>&webshopmanageid=<%=webshopmanageid%>"> 
                          <img src="/images/ShopAddToCart_wev8.gif" title="Add to basket" border=0></a>
                        </TD>
                        <%}%>
                      </tr>
                      <%	
							isLight = !isLight;
						}%>
						
                      </TBODY>
                    </TABLE>
                  </TD>
				 </TR>
              <TR class=Spacing>
                <TD class=Line1></TD></TR>
				<!-- TR >
                <TD><%=theassetsql%></TD></TR -->
				<% if(perpage != 0) {%>
              <TR class=Title>
                        <TD noWrap > <%=Util.makeNavbar(start, recordersize , perpage, linkstr)%></td>
			  </TR>
			  <%}%>
			  </TBODY></TABLE></TD>
          
		  
		  
		  
		  <% if(toolbardsp.equals("2")) {%>
		  <TD vAlign=top width=<%=toolbarwidth%> bgColor=#<%=toolbarbgcolor%>><!-- Sidebar --> 
            <TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#<%=toolbarbgcolor%> border=0 height="100%">
              <TBODY>
              <TR>
                <TD vAlign=top width=<%=toolbarwidth%>>
                  <TABLE cellSpacing=0 cellPadding=0 width=<%=toolbarwidth%> border=0>
                    <TBODY>
					<% if(countrydsp.equals("1")) {%>
                    <TR>
                      <TD><!-- Country and Search -->
                        <!-- FORM id=frmCountry action=LgcCatalogsView.jsp method=post -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR>
                            <TD><SPAN class=SideBarText>国家</SPAN></TD></TR>
                          <TR>
                            <TD><SELECT style="WIDTH: 100%" onchange=frmmain.submit() name=thecountry> 
                                <OPTION value="0">- 全球 -</OPTION> 
								<%
									while(CountryComInfo.next()) {
										String thecountryid = CountryComInfo.getCountryid() ;
								%>
								<OPTION value="<%=thecountryid%>" <% if(thecountry.equals(thecountryid)) {%> selected <%}%>><%=Util.toScreen(CountryComInfo.getCountrydesc(),user.getLanguage())%></OPTION> 
								<%}%>
								</SELECT> 
                        </TD></TR></TBODY></TABLE><!--/FORM -->
					  </TD>
					</TR>
					<%}%>
					
					<% if(searchbyname.equals("1") || searchbycrm.equals("1") || searchadv.equals("1")) {%>
                    <TR>
                      <TD><!-- Search -->
                        <!-- FORM id=frmSearch 
                        action=BLCatalogue.asp?Catalog=shop&amp;Reload=1&amp;Country=CN&amp;Show=1&amp;Account=&amp;Assortment=1 
                        method=post -->
                          <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                            <TBODY> 
                            <TR> 
                              <TD colSpan=3><SPAN  class=SideBarText>搜索</SPAN></TD>
                            </TR>
                            <% if(searchbyname.equals("1")) {%>
                            <tr> 
                              <td><SPAN  class=SideBarText>关键字</span></td>
                              <td width=180 colspan="2"> 
                                <input style="WIDTH: 100%"  name=theassetname>
                              </td>
                            </tr>
                            <%} if(searchbycrm.equals("1")) {%>
                            <TR> 
                              <td><SPAN  class=SideBarText>CRM</span></td>
                              <td width=180 colspan="2"> <button class=Browser id=SelectCrm onClick="onShowCrmID(crmidspan,thecrmid)"></button> 
                                <span class=InputStyle id=crmidspan></span> 
                                <input type=hidden id=thecrmid name=thecrmid>
                              </td>
                            </tr>
                            <%}%>
                            <TR> 
                              <td></td>
                              <td width=160 align="right"><%if(searchadv.equals("1")) {%><A class=SideBarText href="/lgc/search/LgcSearch.jsp">高级</A><%}%></td>
                              <td width=20><INPUT type=image height=18 alt=Go width=18 src="/images/BacoSearch_wev8.gif" border=0></td>
                            </TR>
                            </TBODY> 
                          </TABLE>
                          <!--/FORM -->
						</TD>
					</TR>
					<%}%>
					
					<% if(navibardsp.equals("2")) {%>
                    <TR>
                      <TD><!-- Categories -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR><TD>&nbsp;</TD></TR>
                          <TR>
                            <TD align=left width="100%"><SPAN class=SideBarText>导航条</SPAN></TD></TR>
                          <TR>
                            <TD vAlign=top>
                              <TABLE cellSpacing=0 cellPadding=1 width="100%" bgColor=<%=toolbarlinkbgcolor%> border=0>
                                <TBODY>
									<%
										RecordSet.executeProc("LgcCatalogs_SelectByUser",userseclevel);
										while(RecordSet.next()) {
											String theid = Util.null2String(RecordSet.getString("id")) ;
											String thecatalogname = Util.toScreen(RecordSet.getString("catalogname"),user.getLanguage()) ;
									%>
									<TR>
									<TD><A class=SideBarLink href="LgcCatalogsView.jsp?id=<%=theid%>"><%=thecatalogname%></A></TD>
									</TR>
									<%}%>
								</TBODY></TABLE>
							    </TD>
							 </TR>
						  </TBODY></TABLE>
					  </TD>
					</TR>
					<%}%>
					
					
					<% if(assortmentdsp.equals("1")) {%>
                    <TR>
                      <TD><!-- Categories -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR><TD>&nbsp;</TD></TR>
                          <TR>
                            <TD align=left width="100%"><SPAN class=SideBarText><%=assortmentname%></SPAN></TD></TR>
                          <TR>
                            <TD vAlign=top>
                              <TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=<%=toolbarlinkbgcolor%> border=0>
                                <TBODY>
								<%
								ArrayList rootids = new ArrayList() ;
								if(assortmentsql.equals("")) rootids.add("0") ;
								else {
									try {
										RecordSet.executeSql("select id from LgcAssetAssortment where " +  assortmentsql) ;
										while(RecordSet.next()) rootids.add(RecordSet.getString(1)) ;
									}catch(Exception ex) {}
								}
								
								for(int rootidindex = 0 ; rootidindex<rootids.size() ; rootidindex++) { %>
								<TR><TD height=8></td></tr>
								<%	AssetAssortmentList.setAssetAssortmentList((String)rootids.get(rootidindex));
									while(AssetAssortmentList.next()){
										String assortmentstep = AssetAssortmentList.getAssortmentStep();
										String assortmentid = AssetAssortmentList.getAssortmentId();
										String assortmentmark = AssetAssortmentList.getAssortmentMark();
										String theassortmentname = AssetAssortmentList.getAssortmentName();
										String assortmentimage = AssetAssortmentList.getAssortmentImage();
										String assetcount =  AssetAssortmentList.getAssetCount();
										String subassortmentcount = AssetAssortmentList.getSubAssortmentCount();
										String supassortmentid = AssetAssortmentList.getSupAssortmentId();
										int tdwidth = Util.getIntValue(assortmentstep)*15 ;
								%>
                                 <TR><TD>
									<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
									<td width="<%=tdwidth%>"><img src="0_wev8.gif" width="<%=tdwidth%>" height="1"></td>
									<td WIDTH="20px" align="left">
									<%if(assortmentimage.equals("1")) {%>
									<IMG SRC="\images\btnDocExpand_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px" onClick="changeassortment('<%=assortmentid%>','1')" style="CURSOR:'HAND'"> 
									<%} else if(assortmentimage.equals("2")) {%>
									<IMG SRC="\images\btnDocCollapse_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px" onClick="changeassortment('<%=assortmentid%>','0')" style="CURSOR:'HAND'"> 
									<% } %>
									</td>
									<td  align="left"><A HREF="LgcCatalogsView.jsp?id=<%=id%>&theassortment=<%=assortmentid%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>"  class=SideBarLink><%=theassortmentname%></a></td>
									</tr></table>
								  </TD></TR>
								<%}}%>
								</TBODY>
								</TABLE>
							  </TD>
							</TR>
						  </TBODY></TABLE>
					  </TD>
					</TR>
					<%}%>
					
					
					<% if(webshopdap.equals("1")) {%>
                    <TR>
                      <TD><!-- Shopping -->
                        <TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
                          <TBODY>
                          <TR><TD>&nbsp;</TD></TR>
                          <TR>
                            <TD align=left><SPAN class=SideBarText>购物</SPAN></TD></TR>
                          <TR>
                            <TD vAlign=top>
                              <TABLE cellSpacing=0 cellPadding=1 width="100%" bgColor=<%=toolbarlinkbgcolor%> border=0>
                                <TBODY>
                                <TR>
                                <TD><% 
								int buycount = Util.getIntValue(Util.getCookie(request, "CoItemAll_"+user.getUID()),0) ;
								if( buycount !=0) { %>
								<A class=SideBarLink href="LgcAssetBasket.jsp?catalogid=<%=id%>&theassortment=<%=theassortment%>&selectedid=<%=selectedid%>&thecountry=<%=thecountry%>&theattributes=<%=theattribute%>&isthenew=0&start=<%=start%>&webshoptype=<%=webshoptype%>&webshopmanageid=<%=webshopmanageid%>"><%} else {%><SPAN class=SideBarLink><%}%>购物车<% if( buycount ==0) { %></span><%}%>
								<% if( buycount !=0) { %>
								(<%=buycount%>) </A><%}%></TD>
								</TR>
								</TBODY></TABLE>
							</TD></TR>
						</TBODY></TABLE>
					  </TD>
					</TR>
					<%}%>
                   </TBODY></TABLE></TD></TR></TBODY></TABLE></TD>
			<%}%>  
			
			
			<!-- end toolbar -->
			
			
								
		</TR></TBODY></TABLE>
		
</form>
	</TD>
    <TD width=2></TD>
    </TR>
  </TBODY>
</TABLE>
<script language="vbs">
sub onShowCrmID(spanname,inputname)
id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
if (Not IsEmpty(id)) then
if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
else 
	spanname.innerHtml = ""
	inputname.value=""
end if
end if
end sub
</SCRIPT>
<script language="javascript">
function selectallattr() {
	frmmain.selectallvalue.value="1" ;
	frmmain.submit() ;
}

function changeassortment(thevalue, addorsubval) {
	frmmain.addorsub.value=addorsubval ;
	frmmain.newselectedid.value=thevalue ;
	frmmain.submit() ;
}
</script>
</BODY>
</HTML>
