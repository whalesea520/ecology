
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<jsp:useBean id="hpsc" class="weaver.homepage.cominfo.HomepageStyleCominfo" scope="page" />
<%
String styleid =Util.null2String(request.getParameter("styleid"));	
String from =Util.null2String(request.getParameter("from"));	
String hpinfoid =Util.null2String(request.getParameter("hpinfoid"));
String message =Util.null2String(request.getParameter("message"));


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19440,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
	if(!HrmUserVarify.checkUserRight("hompage:stylemaint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if(!"1".equals(styleid)){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(),_self} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }


	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onGoBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>



<%
    String stylename="";
    String styleDesc="";
    String edatemode="";
    String etimemode="";
    String hpbgcolor="";
    String etitlecolor="";
    String ecolor="";
    String ebordercolor="";
    String etitlebgcolor="";
    String ebgcolor ="";
    String hpbgimg="";
    String etitlebgimg="";
    String ebgimg="";
    String elockimg1="";
    String eunlockimg1="";
    String erefreshimg1="";
    String esettingimg1="";
    String ecoloseimg1="";
    String emoreimg1="";
    String esparatorimg="";
    String esymbol="";
	String navbgcolor="";
	String navcolor="";
	String navselectedbgcolor="";
	String navselectedcolor="";
	String navbordercolor="";
	String navbackgroudimg="";
	String navselectedbackgroudimg ="";
    String mimgshowmode ="";
    if(hpsc.isHaveThisHpStyle(styleid)){
        HomepageStyleBean hpsb=hpsu.getHpsb(styleid);
        stylename=hpsb.getStylename();
        styleDesc=hpsb.getStyledesc();
        edatemode=hpsb.getEdatemode();
        etimemode=hpsb.getEtimemode();
        hpbgcolor=hpsb.getHpbgcolor();
        etitlecolor=hpsb.getEtitlecolor();
        ecolor=hpsb.getEcolor();
        ebordercolor=hpsb.getEbordercolor();
        etitlebgcolor=hpsb.getEtitlebgcolor();
        ebgcolor=hpsb.getEbgcolor();
        hpbgimg =hpsb.getHpbgimg();
        etitlebgimg=hpsb.getEtitlebgimg();
        ebgimg=hpsb.getEbgimg();
        elockimg1=hpsb.getElockimg1();
        eunlockimg1=hpsb.getEunlockimg1();
        erefreshimg1=hpsb.getErefreshimg1();
        esettingimg1=hpsb.getEsettingimg1();
        ecoloseimg1=hpsb.getEcoloseimg1();
        emoreimg1=hpsb.getEmoreimg1();
        esparatorimg=hpsb.getEsparatorimg();
        esymbol=hpsb.getEsymbol();
		navbgcolor=hpsc.getNavbgcolor(styleid);
		navcolor=hpsc.getNavcolor(styleid);
		navselectedbgcolor=hpsb.getNavselectedbgcolor();
		navselectedcolor=hpsb.getNavselectedcolor();
		navbordercolor=hpsb.getNavbordercolor();
		navbackgroudimg=hpsb.getNavbackgroudimg();
		navselectedbackgroudimg=hpsb.getNavselectedbackgroudimg();
        mimgshowmode=hpsb.getMimgshowmode();
    } else {
        rs.executeSql("select * from hpstyle where id="+styleid);
        if(rs.next()){
            stylename=Util.null2String(rs.getString("stylename"));
            styleDesc=Util.null2String(rs.getString("styledesc"));
            edatemode=Util.null2String(rs.getString("edatemode"));
            etimemode=Util.null2String(rs.getString("etimemode"));
            hpbgcolor=Util.null2String(rs.getString("hpbgcolor"));
            etitlecolor=Util.null2String(rs.getString("etitlecolor"));
            ecolor=Util.null2String(rs.getString("ecolor"));
            ebordercolor=Util.null2String(rs.getString("ebordercolor"));
            etitlebgcolor=Util.null2String(rs.getString("etitlebgcolor"));
            ebgcolor    =Util.null2String(rs.getString("ebgcolor"));
            hpbgimg =Util.null2String(rs.getString("hpbgimg"));
            etitlebgimg=Util.null2String(rs.getString("etitlebgimg"));                          
            ebgimg=Util.null2String(rs.getString("ebgimg"));                        
            elockimg1=Util.null2String(rs.getString("elockimg1"));                          
            eunlockimg1=Util.null2String(rs.getString("eunlockimg1"));                          
            erefreshimg1=Util.null2String(rs.getString("erefreshimg1"));                            
            esettingimg1=Util.null2String(rs.getString("esettingimg1"));                            
            ecoloseimg1=Util.null2String(rs.getString("ecoloseimg1"));                          
            emoreimg1=Util.null2String(rs.getString("emoreimg1"));                          
            esparatorimg=Util.null2String(rs.getString("esparatorimg"));                            
            esymbol=Util.null2String(rs.getString("esymbol")); 
			navbgcolor=Util.null2String(rs.getString("navbgcolor"));
			navcolor=Util.null2String(rs.getString("navcolor"));
			navselectedbgcolor=Util.null2String(rs.getString("navselectedbgcolor"));
			navselectedcolor=Util.null2String(rs.getString("navselectedcolor"));
			navbordercolor=Util.null2String(rs.getString("navbordercolor"));
			navbackgroudimg=Util.null2String(rs.getString("navbackgroudimg"));
			navselectedbackgroudimg=Util.null2String(rs.getString("navselectedbackgroudimg"));
            mimgshowmode=Util.null2String(rs.getString("mimgshowmode"));
        }
    }	
%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	 <style>
		.colorPicker{vertical-align:middle;margin-left:4px;cursor:hand}
	 </style>

	 <style type="text/css" id="styleMenu">
		.navigate{
			color:<%=navcolor%>;/*前景色*/
			<%
			if("".equals(navbackgroudimg)){
				out.println("background:"+navbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+navbackgroudimg+"');");
			}				
			%>
			
			border:1px solid <%=navbordercolor%>;/*边框颜色*/   
            <%if(!"".equals(navselectedbgcolor)) {
                out.println("border-bottom:3px solid "+navselectedbgcolor+";");
            }%>
            			
			font-size:		12px;
			FONT-FAMILY: 宋体;
			border-left:0;    
		}
		.divMenu {   		
			float:			left;
			padding:		6px 6px 6px 6px;
			border-left:	1px solid <%=navbordercolor%>;
			z-index:		1;
			top:			0;
			position:		relative;
		}
		.divMenuSelected {
			<%
			if("".equals(navselectedbackgroudimg)){
				out.println("background:"+navselectedbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+navselectedbackgroudimg+"');");
			}				
			%>			
			color:<%=navselectedcolor%>;   
		   
			float:			left;
			padding:		6px 6px 6px 6px;
			border-left:	1px solid <%=navbordercolor%>;
			z-index:		1;
			top:			0;
			position:		relative;
		}

		.subNavigate{
			color:<%=navcolor%>;/*前景色*/
			border:1px solid <%=navbordercolor%>;/*边框颜色*/					
			font-size:	12px;
			FONT-FAMILY: 宋体;
			border-bottom:0;  
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=95);
		}
		.divSubMenu {   
            <%
			if("".equals(navbackgroudimg)){
				out.println("background:"+navbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+navbackgroudimg+"');");
			}				
			%>
			cursor:hand;
			float:none;
			padding:3px 1px 1px 1px;
			border-bottom:	1px solid <%=navbordercolor%>;
			
		}
		.divSubMenuSelected {
			<%
			if("".equals(navselectedbackgroudimg)){
				out.println("background:"+navselectedbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+navselectedbackgroudimg+"');");
			}				
			%>	
			color:<%=navselectedcolor%>;  		   
			cursor:hand;
			float:none;
			padding:3px 1px 1px 1px;
			border-bottom:	1px solid <%=navbordercolor%>;
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=80);
		}
		</style>

  </head> 
  
<body  id="myBody"  onbeforeunload="protect()">


<TABLE width=100% height=100% border="0" cellspacing="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    <tr>
      <td height="10" colspan="3"></td>
    </tr>
    <tr>
        <td></td>
        <td valign="top">
			<table class="Shadow">
		<colgroup>
		<col width="1">
		<col width="">
		<col width="10">
	<tr>
		<TD></td>		
		<td valign="top">
        <div id=divMessage></div>
		    <%if("nodel".equals(message)) out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(19640,user.getLanguage())+"</font>");
%>
		    <form name="frmAdd" method="post" action="HomepageStyleOperate.jsp" enctype="multipart/form-data">
			<input type="hidden" name="method" value="edit">
			<input type="hidden" name="styleid" value="<%=styleid%>">
			<input type="hidden" name="from" value="<%=from%>">
			<input type="hidden" name="hpinfoid" value="<%=hpinfoid%>">			
			<input type="hidden" name="delfield">
			<TABLE class="ViewForm">
			<colgroup>
			<col width="20%">
			<col width="10%">
			<col width="70%">			
			<TR>
				<TD colspan=3><B><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></B></TD>				
			</TR>
			<TR><TD class=line1 colspan=3></TD></TR>
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
				<td></td>
				<TD class='field'>
				<INPUT TYPE="text" NAME="stylename" class=inputstyle onChange="checkinput('stylename','stylenamespan')" 
				<%if("list".equals(from)){out.println(" value="+stylename);}%>
				 size=30>
				<span id=stylenamespan name=stylenamespan>
				<%if(!"list".equals(from)){out.println("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");}%>
				</span>
				</TD>
			</TR>
			<TR><TD class=line colspan=3></TD></TR>
			
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				<td></td>
				<TD  class='field'><INPUT TYPE="text" size=60 NAME="styledesc" class=inputstyle  <%if("list".equals(from)){out.println(" value="+styleDesc);}%>  ></TD>
			</TR>

			<TR><TD class=line colspan=3></TD></TR>		

			<TR><TD colspan=3 height=15px></TD></TR>
			<TR>
				<TD colspan=3><B><%=SystemEnv.getHtmlLabelName(2121,user.getLanguage())%></B></TD>				
			</TR>
			<TR><TD class=line1 colspan=3></TD></TR>
			<TR>
			<td colspan=3>
				<TABLE width=100%>
				<TR>
					<TD width=55% valign=top>					  
						<TABLE class="ViewForm" valign="top">
							<colgroup>
							<col width="20%">
							<col width="5%">
							<col width="75%">
							<!--
							</tr><TR valign="top"> <TD class=line colspan=3></TD></TR>
							<TR valign="top"> 

							<TD><%=SystemEnv.getHtmlLabelName(19444,user.getLanguage())%></TD>

							<td></td>

							<TD>
								<SELECT NAME="seleDateMode">
									<option value=0 <%if("0".equals(edatemode)) out.println("selected");%>>---</option>
									<option value=1 <%if("1".equals(edatemode)) out.println("selected");%>>YYYY/MM/DD</option>
									<option value=2 <%if("2".equals(edatemode)) out.println("selected");%>>MM/DD/YYYY</option>
									<option value=3 <%if("3".equals(edatemode)) out.println("selected");%>>YYYY-MM-DD</option>
									<option value=4 <%if("4".equals(edatemode)) out.println("selected");%>>MM-DD-YYYY</option>
								</SELECT>
								&nbsp;
								<SELECT NAME="seleTimeMode">
									<option value=0 <%if("0".equals(etimemode)) out.println("selected");%>>---</option>
									<option value=1 <%if("1".equals(etimemode)) out.println("selected");%>>HH:MM:SS</option>
									<option value=2 <%if("2".equals(etimemode)) out.println("selected");%>>HH/MM/SS</option>
									<option value=3 <%if("3".equals(etimemode)) out.println("selected");%>>HH-MM-SS</option>
								</SELECT>
							</TD>
							<td></td>
						</TR>
						<TR><TD class=line colspan=3></TD></TR>
						-->

							<TR valign="top"> <!--导航栏背景颜色-->								<TD><%=SystemEnv.getHtmlLabelName(20018,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">									<%=hpsu.getColorTable("navbgcolor",navbgcolor,"onChangeBgcolor")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>	
							
							<TR valign="top"> <!--导航栏字体颜色-->								<TD><%=SystemEnv.getHtmlLabelName(20019,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">									<%=hpsu.getColorTable("navcolor",navcolor,"onChangeColor")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>	

							<TR valign="top"> <!--导航栏选中后背景颜色-->								<TD><%=SystemEnv.getHtmlLabelName(20020,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">									<%=hpsu.getColorTable("navselectedbgcolor",navselectedbgcolor,"onChangeSelectedBgcolor")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>	

							<TR valign="top"> <!--导航栏选中后字体颜色-->								<TD><%=SystemEnv.getHtmlLabelName(20021,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">									<%=hpsu.getColorTable("navselectedcolor",navselectedcolor,"onChangeSelectedColor")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>	

							<TR valign="top"> <!--导航栏边框线颜色-->								<TD><%=SystemEnv.getHtmlLabelName(20022,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">									<%=hpsu.getColorTable("navbordercolor",navbordercolor,"onChangeBoderLine")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>	

							<TR valign="top"> <!--导航栏背景图片-->								<TD><%=SystemEnv.getHtmlLabelName(20027,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">	
									<INPUT TYPE="file" style='width:97%' class=inputstyle name="navbackgroudimg" onchange="onChangeBgimg(this.value);changeimg('navbackgroudimg',this.value);">
									<%=hpsu.getDelpicStr(styleid,navbackgroudimg,"navbackgroudimg",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>	
								</TD>							
								
							</tr>
							<TR><TD class=line colspan=3></TD></TR>

							<TR valign="top"> <!--导航栏选中后背景图片-->								<TD><%=SystemEnv.getHtmlLabelName(20028,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">	
									<INPUT TYPE="file" style='width:97%' class=inputstyle name="navselectedbackgroudimg" onchange="onChangeSelectedimg(this.value);changeimg('navselectedbackgroudimg',this.value);">
									<%=hpsu.getDelpicStr(styleid,navselectedbackgroudimg,"navselectedbackgroudimg",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>	
								</TD>							
								
							</tr>
							<TR><TD class=line colspan=3></TD></TR>





							<TR valign="top"> <!--首页背景颜色-->								<TD><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">									<%=hpsu.getColorTable("hpbgcolor",hpbgcolor,"_hpTD.style.backgroundColor=")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>							



							<TR valign="top"> <!--元素标题颜色-->
								<TD  valign="top">					  <%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%>
								</TD>
								<td></td>
								<TD width="100%"  valign="top">
									<%=hpsu.getColorTable("etitlecolor",etitlecolor,"_etitlecolor.color=")%>						
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>

							<TR valign="top"> <!--元素字体颜色-->
								<TD  valign="top">					  <%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2076,user.getLanguage())%>
								</TD>
								<td></td>
								<TD width="100%"  valign="top">
								<%=hpsu.getColorTable("ecolor",ecolor,"_contenttable.style.color=")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>


							<TR valign="top"  valign="top"> <!--元素边框颜色 -->
								<TD>								<%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19445,user.getLanguage())%>
								</TD>

								<td></td>
								<TD width="100%"  valign="top">
									<%=hpsu.getColorTable("ebordercolor",ebordercolor,"_elementTable.style.borderColor=")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>
							


							<TR valign="top"> <!--元素标题背景颜色-->								<TD><%=SystemEnv.getHtmlLabelName(19443,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">										<%=hpsu.getColorTable("etitlebgcolor",etitlebgcolor,"_etitleTR.style.background=")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>

							

							<TR valign="top"> <!--元素背景颜色-->								<TD><%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">										
								<%=hpsu.getColorTable("ebgcolor",ebgcolor,"_elementTable.style.background=")%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>

							<TR valign="top"> <!--首页背景图片-->								<TD><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">	
									<INPUT TYPE="file" style='width:97%' class=inputstyle name="hpbgimg" onchange="changebgimg(_hpTD,this.value);changeimg('hpbgimg',this.value);">
									<%=hpsu.getDelpicStr(styleid,hpbgimg,"hpbgimg",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>


							<TR valign="top"> <!--元素标题背景图片-->								<TD><%=SystemEnv.getHtmlLabelName(19443,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">	
									<INPUT TYPE="file" style='width:97%' class=inputstyle name="etitlebgimg" onchange="changebgimg(_etitleTR,this.value);changeimg('etitlebgimg',this.value);">
									<%=hpsu.getDelpicStr(styleid,etitlebgimg,"etitlebgimg",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>	
								</TD>							
								
							</tr>
							<TR><TD class=line colspan=3></TD></TR>


							<TR valign="top"> <!--元素背景图片-->								<TD><%=SystemEnv.getHtmlLabelName(19408,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">										
								
								<INPUT TYPE="file" style='width:97%' class=inputstyle name="ebgimg" onchange="changebgimg(_elementTable,this.value);changeimg('ebgimg',this.value);">
								<%=hpsu.getDelpicStr(styleid,ebgimg,"ebgimg",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>


							
							<TR valign="top"> <!--锁定图片1-->								<TD><%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>1</TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="elockimg1" class=inputstyle onchange="_elockimg1.src=this.value;changeimg('elockimg1',this.value);">
									<%=hpsu.getDelpicStr(styleid,elockimg1,"elockimg1",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>	
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>

						

							<TR valign="top"> <!--非锁定图片1-->								<TD><%=SystemEnv.getHtmlLabelName(19446,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>1</TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="eunlockimg1" class=inputstyle onchange="changeimg('eunlockimg1',this.value);">
									<%=hpsu.getDelpicStr(styleid,eunlockimg1,"eunlockimg1",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>



							



							<TR valign="top"> <!--刷新按钮图片1-->								<TD><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>1</TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="erefreshimg1" class=inputstyle onchange="_erefreshimg1.src=this.value;changeimg('erefreshimg1',this.value);">
									<%=hpsu.getDelpicStr(styleid,erefreshimg1,"erefreshimg1",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>



						

							<TR valign="top"> <!--设置按钮图片1-->								<TD><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>1</TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="esettingimg1" class=inputstyle onchange="_esettingimg1.src=this.value;changeimg('esettingimg1',this.value);">
									<%=hpsu.getDelpicStr(styleid,esettingimg1,"esettingimg1",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>



							


							<TR valign="top"> <!--关闭按钮图片1-->								<TD><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>1</TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="ecoloseimg1" class=inputstyle onchange="_ecoloseimg1.src=this.value;changeimg('ecoloseimg1',this.value)">
									<%=hpsu.getDelpicStr(styleid,ecoloseimg1,"ecoloseimg1",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>


							


							<TR valign="top"> <!--更多按钮图片1-->								<TD><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>1</TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="emoreimg1" class=inputstyle onchange="_emoreimg1.src=this.value;changeimg('emoreimg1',this.value);">
									<%=hpsu.getDelpicStr(styleid,emoreimg1,"emoreimg1",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>


							
							<TR valign="top"> <!--行分隔符-->								<TD><%=SystemEnv.getHtmlLabelName(19447,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="esparatorimg" class=inputstyle onchange="separatorchange(this.value);changeimg('esparatorimg',this.value);">
									<%=hpsu.getDelpicStr(styleid,esparatorimg,"esparatorimg",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>

							<TR valign="top"> <!--行前图标-->								<TD><%=SystemEnv.getHtmlLabelName(19448,user.getLanguage())%></TD> 
								<td></td>
								<TD width="100%"  valign="top">										
									<INPUT TYPE="file" style='width:97%' NAME="esymbol" class=inputstyle onchange="symbolchange(this.value);changeimg('esymbol',this.value);">
									<%=hpsu.getDelpicStr(styleid,esymbol,"esymbol",SystemEnv.getHtmlLabelName(91,user.getLanguage()))%>
								</TD>							
							</tr>
							<TR><TD class=line colspan=3></TD></TR>
						</TABLE>
                    </TD>

					<TD valign=top>

					<table width="100%" cellspacing="0" cellpadding="0" border=0>
					 <!--导航栏预览-->	

					  <tr> 
						<td width="2%" rowspan="3">&nbsp;</td>
						<td width="90%" height="50px" style="border:1px solid #DBDBDB" valign=top>
							<%=hpsu.getNavgateShape(hpsu.getHpsb(styleid))%>	
						</td>
						<td width="2%" rowspan="3">&nbsp;</td>
					  </tr>
						
					 <tr><td height="5px">&nbsp;</td></tr>
 
					 <!--元素预览-->
					 <%
					    String strStyle="style=\"height:150px;";
						if(!"".equals(hpbgimg)) strStyle+="background:url('"+hpbgimg+"')";
						strStyle+="\"";

						String strBgcolor="";						
						if(!"".equals(hpbgcolor)) strBgcolor+=" bgcolor='"+hpbgcolor+"' ";
					  %>
					  <tr  valign=top> 					 
							<TD width=100% valign*=top <%=strBgcolor%> <%=strStyle%>  id="_hpTD"  style="border:1px solid #DBDBDB"  valign=top>
								<%=hpsu.getElementShape(hpsu.getHpsb(styleid))%>								
							</TD>
					  </tr>

						<%
							String selected1="";
							String selected2="";
							if("1".equals(mimgshowmode)) selected1=" checked ";
							else selected2=" checked ";
						%>
                       
                      <tr><td>&nbsp;</td></tr>
					  <tr> 
						<td width="2%" rowspan="3">&nbsp;</td>
						<td width="90%" height="50px" style="border:1px solid #DBDBDB" valign=top>
							 <table>
                              <tr>
								<td  valign=top><%=SystemEnv.getHtmlLabelName(20150,user.getLanguage())%></td>
                                <td><img src="/images/homepage/imgmode1_wev8.gif"><br><input type=radio value="1" <%=selected1%> name="mimgshowmode"><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%>1</td>
                                <td><img src="/images/homepage/imgmode2_wev8.gif"><br><input type=radio value="2" <%=selected2%> name="mimgshowmode"><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%>2</td>
                              </tr>
                              </table>
						</td>
						<td width="2%" rowspan="3">&nbsp;</td>
					  </tr>
						
					 <tr><td height="5px">&nbsp;</td></tr>	

					  <tr> 
						<td>&nbsp;</td>
					  </tr>

					</table>						
					</TD>
				</TR>
				</TABLE>
			</td>
			</TR>
			</TABLE>
			</form>
		</td>
	</tr><TR><TD class=line colspan=3></TD></TR><tr>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	</table>

	    </td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>



</body>
</html>
<SCRIPT language="javascript" src="/js/xmlextras_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
function onSave(){
	if(check_form(document.frmAdd,'stylename')){
        var xmlHttp = XmlHttp.create(); 
        var strUrl="HomepageCheckname.jsp?method=checkname&styleid=<%=styleid%>&name="+frmAdd.stylename.value
        //document.write(strUrl);
        xmlHttp.open("GET",strUrl, true);
    
        xmlHttp.onreadystatechange = function () {  
            switch (xmlHttp.readyState) {                  
               case 4 :
                    var strTemp=xmlHttp.responseText.replace(/^\s*|\s*$/g,'');
                    //alert(strTemp)
                    if(strTemp!="use"){                   
                     myBody.onbeforeunload=null;
                     frmAdd.submit();
                   } else{
                     divMessage.innerHTML="<font  color=#FF0000><%=SystemEnv.getHtmlLabelName(19641,user.getLanguage())%></font>";
                   }                
                   break;
           } 
        }     
         xmlHttp.send(null);    
	}
}


function delpic(str){
	if(isdel()){
		myBody.onbeforeunload=null;
		frmAdd.method.value="delpic";
		frmAdd.delfield.value=str;
		frmAdd.submit();
    }
}

function onDel(){
   if(isdel()){
        myBody.onbeforeunload=null;
    	frmAdd.method.value="del";
    	frmAdd.submit();
    }
}


function seleChanage(obj1,obj2,obj3Name){
	    // 1. color  2: img
		if(obj1.value==2) {
			document.getElementById(obj3Name+"Img").style.display='none';
			//document.getElementById(obj3Name+"TD2").style.display='none';
			document.getElementById(obj3Name+"TD1").innerHTML="<input type=file class=inputstyle name="+obj3Name+" style='width:100%'>";
			
		} else {
			document.getElementById(obj3Name+"Img").style.display='';
			//document.getElementById(obj3Name+"TD2").style.display='';
			document.getElementById(obj3Name+"TD1").innerHTML="<input type=text class=inputstyle name="+obj3Name+" style='width:100%'>";
			
		}
}


function getColor(o,str2) {
	var dialogObject = new Object() ;
	var colorValue = "";
	colorValue = window.showModalDialog("/systeminfo/template/ColorPicker.jsp", dialogObject, "dialogWidth:330px; dialogHeight:300px; center:yes; help:no; resizable:no; status:no") ;
	document.getElementById(o).value = (colorValue=="") ? "" : colorValue ;
	document.getElementById(o+"TD").style.backgroundColor = colorValue;  
  	if(str2!="")	{
		if(str2=="onChangeBgcolor"||str2=="onChangeColor"||str2=="onChangeSelectedBgcolor"||str2=="onChangeSelectedColor"||str2=="onChangeBoderLine"){
			eval(str2+"('"+colorValue+"')");
		} else {
			eval(str2+"'"+colorValue+"'");
		}


	}
}
function changebgimg(obj,value) {	
	obj.style.background="url('"+value+"')";
}
function symbolchange(imgstr){
	var objs=document.getElementsByName("esymbol");
	for(i=0;i<objs.length;i++){
		objs[i].src=imgstr;
	}
}

function separatorchange(imgstr){
	changebgimg(document.getElementById("_sparatorTR_1"),imgstr)
	changebgimg(document.getElementById("_sparatorTR_2"),imgstr)
	changebgimg(document.getElementById("_sparatorTR_3"),imgstr)
	changebgimg(document.getElementById("_sparatorTR_4"),imgstr)	
}



function changeimg(field,value){
	try{	
		document.getElementById("_img_"+field).src=value;
	}catch(e){
	}
}


 function protect(){ 
	event.returnValue="<%=SystemEnv.getHtmlLabelName(19469,user.getLanguage())%>";      
  }
  
  function onGoBack(){
    window.location='/homepage/style/HomepageStyleList.jsp';
  }
  
  /*首页导航栏设置*/
   var lastestSubDiv;
    /*
       cObj:Current Object
       pObj:Pervious Sibling Object
       sObj:Sub Menu Object
    */
    function onShowSubMenu(cObj,sObj){
       
        if (sObj.style.display=="none")    {
            /*初始化其显示的位置及大小*/
            var pObj=cObj.previousSibling;

            sObj.style.position="absolute";
			sObj.style.width=100;
            sObj.style.posLeft=pObj.offsetLeft;
            sObj.style.posTop=pObj.offsetTop+pObj.offsetHeight;
            
            if(lastestSubDiv!=null) lastestSubDiv.style.display="none";
            lastestSubDiv=sObj;
            sObj.style.display="";
            
        } else {
            sObj.style.display="none";
        }
    }   
    
	var oStyleSheet=document.styleSheets["styleMenu"];
	var oNavigate=oStyleSheet.rules[0]; //导航栏
	var divMenu=oStyleSheet.rules[1];     
	var divMenuSelected=oStyleSheet.rules[2]; //导航栏选中后
	var oSubNavigate=oStyleSheet.rules[3]; //子菜单  
	var divSubMenu=oStyleSheet.rules[4]; 
	var divSubMenuSelected=oStyleSheet.rules[5]; //子菜单选中后

	function onChangeBgcolor(color){  //导航栏背景颜色      		
		oNavigate.style.backgroundColor=color;
		oSubNavigate.style.backgroundColor=color;
	}

	function onChangeColor(color){  //导航栏字体颜色
		oNavigate.style.color=color;
		oSubNavigate.style.color=color;
	}
	function onChangeSelectedBgcolor(color){  //导航栏选中后背景颜色
		divMenuSelected.style.backgroundColor=color;
		divSubMenuSelected.style.backgroundColor=color;
	}
	function onChangeSelectedColor(color){  //导航栏选中后字体颜色
		divMenuSelected.style.color=color;
		divSubMenuSelected.style.color=color;
	}
	function onChangeBoderLine(color){  //导航栏选中后边框颜色
		oNavigate.style.borderColor=color;
		divMenu.style.borderColor=color;
		divMenuSelected.style.borderColor=color;
		oSubNavigate.style.borderColor=color;
		divSubMenu.style.borderColor=color;
		divSubMenuSelected.style.borderColor=color;
	}
	function onChangeBgimg(imgurl){  //导航栏背景图片      
		oNavigate.style.background="url('"+imgurl+"')";
		oSubNavigate.style.background="url('"+imgurl+"')";
	}
	function onChangeSelectedimg(imgurl){  //导航栏选中后背景图片      
		divMenuSelected.style.background="url('"+imgurl+"')";
		divSubMenuSelected.style.background="url('"+imgurl+"')";
	}
	/**Add by Hqf for TD9376 Start **/
	function inspect_Color(strColor){//验证颜色是否有效
		var oSpan = document.createElement("<span style='color:"+strColor+";'></span>");
		if(oSpan.style.color != ""){
			return true;
		}else{
		alert('<%=SystemEnv.getHtmlLabelName(22431,user.getLanguage())%>')
		return false;
		}
		oSpan = null;
	}
	/**Add by Hqf for TD9376 End **/

</SCRIPT>