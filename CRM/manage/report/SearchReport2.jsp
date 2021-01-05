
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util,weaver.file.ExcelSheet,weaver.file.ExcelRow,weaver.secondary.file.ExcelStyle" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SecExcelFile" class="weaver.secondary.file.ExcelFile" scope="session" />

<%
	rs.executeSql("select hasrightids,excludeids from CRM_ReportSetting");
	String titlename = "泛微营销部军规执行情况";
	
	List data = new ArrayList();
	data.add(new String[]{"北方大区","126"});
	data.add(new String[]{"上海大区","56"});
	data.add(new String[]{"华南大区","305"});
	data.add(new String[]{"苏皖大区","228"});
	data.add(new String[]{"浙闽大区","256"});
	data.add(new String[]{"西南大区","38"});
	data.add(new String[]{"新疆大区","174"});
	data.add(new String[]{"广州大区","32"});
	data.add(new String[]{"山西大区","1080"});
	data.add(new String[]{"山东大区","161"});
	data.add(new String[]{"青岛机构","447"});
	data.add(new String[]{"湖北机构","1244"});
	data.add(new String[]{"湖南机构","768"});
	data.add(new String[]{"衡阳机构","928"});
	data.add(new String[]{"江西机构","440"});
	data.add(new String[]{"河南机构","698"});
	data.add(new String[]{"陕西机构","364"});
	data.add(new String[]{"重庆机构","675"});
	data.add(new String[]{"银川机构","1634"});
	
	String datefrom1 = Util.null2String(request.getParameter("datefrom1"));
	String dateto1 = Util.null2String(request.getParameter("dateto1"));
	String datefrom2 = Util.null2String(request.getParameter("datefrom2"));
	String dateto2 = Util.null2String(request.getParameter("dateto2"));
	
	boolean cansearch = false;
	if(!datefrom1.equals("") && !dateto1.equals("") && !datefrom2.equals("") && !dateto2.equals("")){
		cansearch = true;
	}
	
	String currentdate = TimeUtil.getCurrentDateString();
	if(datefrom1.equals("")) datefrom1 = TimeUtil.dateAdd(currentdate,-7);
	if(dateto1.equals("")) dateto1 = TimeUtil.dateAdd(currentdate,-1);
	if(datefrom2.equals("")) datefrom2 = currentdate.substring(0,7)+"-01";
	if(dateto2.equals("")) dateto2 = currentdate;
	//System.out.println(provincename);
%>
<HTML>
	<HEAD>
		<title><%=titlename %></title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<style type="text/css">
			html,body{-webkit-text-size-adjust: none;}
			body{margin: 0px;}
			.maintable{width: 100%;table-layout: fixed;background: #EBEBEB;}
			.maintable th{line-height: 28px;background: #F6F6F6;width: 100px;padding: 0px;}
			.Header2 th{background: #F9F9F9;}
			.maintable th.th1{background: #EFEFEF;}
			.maintable th.th2{background: #F6F6F6;}
			.maintable th.th3{background: #EFEFEF;}
			.maintable td{line-height: 24px;text-align: center;background: #fff;padding: 2px;}
			.maintable td.title{background: #DDD9C3;}
			.maintable tr.tr_head td{line-height: 28px;background: #F6F6F6;text-align: center;font-weight: bold;}
			tr.dark td{background: #FDFDFD}
 			
			.detailtable{width:100%;table-layout: fixed;border-collapse: collapse;}
			.detailtable td{line-height: 28px;padding-left: 5px !important;background: #fff;border-left: 0px #EBEBEB solid;border-top: 1px #EBEBEB solid;}
			
			.input_txt{width: 180px;height:22px;border: 1px #C1C1C1 solid;margin-left: 10px;background: none;padding-top: 0px;outline:none;}
			.input_focus{border-color: #3BBAD9;}
			.input_blur{color: #C3C3C3;font-style: italic;}
			
			
			.searchtable{width:100%;border-collapse: collapse;margin-bottom:10px;}
			.searchtable td{height:30px;padding-left:4px !important;padding-right:4px !important;background:#fff;border:1px #E9E9E9 solid;}
			.searchtable td.title{background:#F3F3F3;color:#333333;}
			.searchtable td .input{background-image:none !important;padding-top:0px !important;}
			.innertable{width:auto;height:30px;float:left;}
			.innertable td{border:0px;padding:0px !important;}
			
			.tab{float: left;width: 50px;line-height: 28px;text-align: center;cursor: pointer;font-weight: normal;}
			.tab_click{background: #CAE8EA;}
			
			::-webkit-scrollbar-track-piece {
				background-color: #E2E2E2;
				-webkit-border-radius: 0;
			}
			
			::-webkit-scrollbar {
				width: 12px;
				height: 8px;
			}
			
			::-webkit-scrollbar-thumb {
				height: 50px;
				background-color: #CDCDCD;
				-webkit-border-radius: 1px;
				outline: 0px solid #fff;
				outline-offset: -2px;
				border: 0px solid #fff;
			}
			
			::-webkit-scrollbar-thumb:hover {
				height: 50px;
				background-color: #BEBEBE;
				-webkit-border-radius: 1px;
			}
			.scroll2 {
				overflow: auto;
				SCROLLBAR-DARKSHADOW-COLOR: #CDCDCD;
				SCROLLBAR-ARROW-COLOR: #E2E2E2;
				SCROLLBAR-3DLIGHT-COLOR: #CDCDCD;
				SCROLLBAR-SHADOW-COLOR: #CDCDCD;
				SCROLLBAR-HIGHLIGHT-COLOR: #CDCDCD;
				SCROLLBAR-FACE-COLOR: #CDCDCD;
				scrollbar-track-color: #E2E2E2;
			}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.maintable{width:auto;}
		</style>
		<![endif]-->
	</HEAD>
	<BODY style="">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			if(cansearch){
				RCMenu += "{"+"Excel,javascript:exportExcel(),_top} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="frmMain" name="frmMain" action="SearchReport2.jsp" method="post">
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr>
				<td height="5" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<div style="width: 100%;height: 28px;border-bottom:2px #CAE8EA solid;font-size: 14px;font-weight: bold;margin-bottom: 10px;">
									<div style="width: auto;line-height: 28px;float: left;margin-right: 5px;"><%=titlename %></div>
								</div>
								<TABLE id="searchTable" class="searchtable" cellpadding="0" cellspacing="0" border="0">
									<COLGROUP>
										<COL width="15%"/>
										<COL width="35%"/>
										<COL width="15%"/>
										<COL width="35%"/>
									</COLGROUP>
									<TBODY>
										<TR>
											<TD class="title">周日期范围</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(datefrom1,datefrom1Span)"></BUTTON>
												<SPAN id="datefrom1Span"><%=datefrom1%></SPAN>
												<input class=inputstyle type="hidden" name="datefrom1" value="<%=datefrom1%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(dateto1,dateto1Span)"></BUTTON>
												<SPAN id="dateto1Span"><%=dateto1%></SPAN>
												<input class=inputstyle type="hidden" name="dateto1" value="<%=dateto1%>" />
											</TD>
											<TD class="title">月日期范围</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(datefrom2,datefrom2Span)"></BUTTON>
												<SPAN id="datefrom2Span"><%=datefrom2%></SPAN>
												<input class=inputstyle type="hidden" name="datefrom2" value="<%=datefrom2%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(dateto2,dateto2Span)"></BUTTON>
												<SPAN id="dateto2Span"><%=dateto2%></SPAN>
												<input class=inputstyle type="hidden" name="dateto2" value="<%=dateto2%>" />
											</TD>
										</TR>
									</TBODY>
								</TABLE>
								<%if(cansearch){ 
									ExcelSheet es = new ExcelSheet();
									ExcelRow title = es.newExcelRow();
									title.setHight(30);
									
									es.addColumnwidth(3000);
									title.addStringValue("大区", "title");
									es.addColumnwidth(3000);
									title.addStringValue("负责人", "title");
									es.addColumnwidth(4000);
									title.addStringValue("客户增量", "title");
									es.addColumnwidth(4000);
									title.addStringValue("人脉增量", "title");
									es.addColumnwidth(4000);
									title.addStringValue("商机增量", "title");
									es.addColumnwidth(4000);
									title.addStringValue("商机未跟进数量", "title");
									es.addColumnwidth(4000);
									title.addStringValue("商机总量", "title");
									es.addColumnwidth(4000);
									title.addStringValue("商机未跟进比例", "title");
									es.addColumnwidth(4000);
									title.addStringValue("客户滚动率", "title");
								%>
								<div id="divdata" class="scroll2" style="width: 100%;height:auto;overflow: auto;">
								<table class="maintable" cellspacing=1 cellpadding="0" border="0">
									<COLGROUP>
										<COL width="8%"/>
										<COL width="8%"/>
										<COL width="12%"/>
										<COL width="12%"/>
										<COL width="12%"/>
										<COL width="12%"/>
										<COL width="12%"/>
										<COL width="12%"/>
										<COL width="12%"/>
									</COLGROUP>
									<TBODY>
										<tr class="tr_head">
											<td style="">大区</td>
											<td style="">负责人</td>
											<td style="">客户增量</td>
											<td style="">人脉增量</td>
											<td style="">商机增量</td>
											<td style="">商机未联系</td>
											<td style="">商机总量</td>
											<td style="">未联系比例</td>
											<td style="">客户滚动率</td>
										</tr>
										<%
											String[] titles = null;
											String managerid = "";
											String sql = "";
											int count = 0;
											int count2 = 0;
											String rate = "";
											int index = 0;
											String hrmwhere = "h.id and h.loginid<>'' and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3)"
												+" and (h.id=#### or h.managerstr like '%,####,%')";
											for(int i=0;i<data.size();i++){
												titles = (String[])data.get(i);
												managerid = titles[1];
												ExcelRow er = es.newExcelRow();
												er.setHight(20);
												
												er.addStringValue(titles[0], "normal");
												er.addStringValue(ResourceComInfo.getLastname(titles[1]), "normal");
										%>
										<tr <%if(index%2==0){ %>class="dark"<%} %>>
											<td><%=titles[0] %></td>
											<td><%=ResourceComInfo.getLastname(titles[1]) %></td>
										<%
												//计算客户增量
												
												
												sql = "select count(t.id) as amount from CRM_CustomerInfo t,HrmResource h where t.manager="+hrmwhere.replaceAll("####",managerid)+" and (t.deleted=0 or t.deleted is null) "
													+ " and t.type in (1,3,4,5) and t.status<>13"
													+ " and t.createdate >='"+datefrom1+"' and t.createdate<='"+dateto1+"'";
												rs.executeSql(sql);
												//System.out.println(sql);
												rs.next();
												count = Util.getIntValue(rs.getString(1),0);
												er.addValue(count, "normal");
										%>
											<td><%=count %></td>
										<%
												//计算人脉增量
												sql = "select count(t.id) as amount from CRM_CustomerInfo c,CRM_CustomerContacter t,HrmResource h where t.customerid=c.id and t.manager="+hrmwhere.replaceAll("####",managerid)+" and (c.deleted=0 or c.deleted is null) "
													+ " and c.type=26 and c.status<>13"
													+ " and t.createdate>='"+datefrom1+"' and t.createdate<='"+dateto1+"'";
													/**
													+ " and exists (select 1 from CRM_Log t1,CRM_Modify t2"
													+ "  where t1.submitdate=t2.modifydate and t1.submittime=t2.modifytime and t1.customerid=t2.customerid"
													+ "  and t1.logtype='nc' and t1.customerid=c.id and t2.type=t.id"
													+ "  and t1.submitdate>='"+datefrom1+"' and t1.submitdate<='"+dateto1+"')";
													*/
													//+ "  or (c.createdate>='"+datefrom1+"' and c.createdate<='"+dateto1+"'))";
												rs.executeSql(sql);
												//System.out.println(sql);
												rs.next();
												count = Util.getIntValue(rs.getString(1),0);
												er.addValue(count, "normal");
										%>
											<td><%=count %></td>
										<%
												//计算商机增量
												sql = "select count(t.id) as amount from CRM_SellChance t,HrmResource h where t.creater="+hrmwhere.replaceAll("####",managerid)+" "
													+ " and t.endtatusid=0"
													+ " and t.createdate >='"+datefrom2+"' and t.createdate<='"+dateto2+"'";
												//System.out.println(sql);
												rs.executeSql(sql);
												rs.next();
												count = Util.getIntValue(rs.getString(1),0);
												er.addValue(count, "normal");
										%>
											<td><%=count %></td>
										<%
												//计算商机跟进情况
												sql = "select count(t.id) as amount from CRM_SellChance t,HrmResource h where t.creater="+hrmwhere.replaceAll("####",managerid)+" "
													+ " and t.endtatusid=0"
													+ " and not exists (select 1 from WorkPlan w where w.type_n=3 and convert(varchar,w.crmid)=convert(varchar,t.customerid)"
													+ " and (w.sellchanceid=t.id or (w.sellchanceid is null and w.contacterid is null))"
													+ " and w.begindate is not null and w.begindate>='"+datefrom1+"' and w.begindate<='"+dateto1+"')"
													+ " and t.createdate<='"+dateto1+"'";
												rs.executeSql(sql);
												//System.out.println(sql);
												//if(managerid.equals("33")) System.out.println(sql);
												rs.next();
												count = Util.getIntValue(rs.getString(1),0);
												er.addValue(count, "normal");
												//计算商机总量
												sql = "select count(t.id) as amount from CRM_SellChance t,HrmResource h where t.creater="+hrmwhere.replaceAll("####",managerid)+" "
													+ " and t.endtatusid=0";
												//System.out.println(sql);
												rs.executeSql(sql);
												rs.next();
												count2 = Util.getIntValue(rs.getString(1),0);
												er.addValue(count2, "normal");
												if(count2==0){
													rate = "0%";
												}else{
													rate = this.round(count*1.00/count2*100+"",0)+"%";
												}
												er.addStringValue(rate, "normal");
										%>
											<td><%=count %></td>
											<td><%=count2 %></td>
											<td><%=rate %></td>
										<%
												//计算客户滚动率
												//联系数据
												sql = "select count(t.id) as amount from CRM_CustomerInfo t,HrmResource h where t.manager="+hrmwhere.replaceAll("####",managerid)+" and (t.deleted=0 or t.deleted is null) "
													+ " and t.type in (1,3,4,5) and t.status<>13"
													+ " and exists (select 1 from WorkPlan w where w.type_n=3 and convert(varchar,w.crmid)=convert(varchar,t.id) and w.begindate is not null and w.begindate>='"+datefrom2+"' and w.begindate<='"+dateto2+"')";
												rs.executeSql(sql);
												//System.out.println(sql);
												rs.next();
												count = Util.getIntValue(rs.getString(1),0);
												//总量
												sql = "select count(t.id) as amount from CRM_CustomerInfo t,HrmResource h where t.manager="+hrmwhere.replaceAll("####",managerid)+" and (t.deleted=0 or t.deleted is null) "
													+ " and t.type in (1,3,4,5) and t.status<>13";
												rs.executeSql(sql);
												//System.out.println(sql);
												rs.next();
												count2 = Util.getIntValue(rs.getString(1),0);
												if(count2==0){
													rate = "0%";
												}else{
													rate = this.round(count*1.00/count2*100+"",0)+"%";
												}
												er.addStringValue(rate, "normal");
										%>
											<td><%=rate %></td>
										</tr>
										<%
												index++;
											}
										%>
								</TABLE>
								</div>
								<%
									SecExcelFile.init();

									ExcelStyle titleStyle = SecExcelFile.newExcelStyle("title");
									titleStyle.setGroundcolor(ExcelStyle.GREY_25_PERCENT_Color);
									//titleStyle.setFontcolor(ExcelStyle.WHITE_Color);
									titleStyle.setFontbold(ExcelStyle.Strong_Font);
									//titleStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
									titleStyle.setAlign(ExcelStyle.ALIGN_CENTER);
									titleStyle.setWrapText(true);
									
									ExcelStyle normalStyle = SecExcelFile.newExcelStyle("normal");
									normalStyle.setValign(ExcelStyle.VALIGN_CENTER);
									normalStyle.setAlign(ExcelStyle.ALIGN_CENTER);
									
									ExcelStyle detailStyle = SecExcelFile.newExcelStyle("detail");
									detailStyle.setWrapText(true);
									detailStyle.setFontheight(9);
	
									SecExcelFile.setFilename(titlename+TimeUtil.getCurrentTimeString().replaceAll("-","").replaceAll(":","").replaceAll(" ",""));
									SecExcelFile.addSheet(titlename+TimeUtil.getCurrentTimeString().replaceAll("-","").replaceAll(":","").replaceAll(" ",""), es);
								} %>
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
		</form>
		<iframe id="searchexport" style="display:none"></iframe>
		<script type="text/javascript">
			$(document).ready(function() {

				$("div.tab").bind("click",function(){
					$("div.tab").removeClass("tab_click");
					$(this).addClass("tab_click");
					$("td.cond").hide();
					var _index = $(this).attr("_index");
					var _tdclass = $(this).attr("_tdclass");
					$("td."+_tdclass).show();
					$("#stattype").val(_index);
				});
			});
			$(window).resize(function(){
			});
			function onSearch(){
				jQuery("#frmMain").submit();   
			}
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){    
			    	onSearch();   
			    }    
			}
			function setSize(){
				var w = $(window).width()-20;
				var h = $(window).height()-160;
				$("#divdata").width(w).height(h);
			}
			function exportExcel(){
			    jQuery("#searchexport").attr("src","/weaver/weaver.secondary.file.ExcelOut");
			}
		</script>
	</BODY>
</HTML>
<%!
/**
 * 对金额进行四舍五入
 * @param s 金额字符串
 * @param len 小数位数
 * @return
 */
public static String round(String s,int len){
	if (s == null || s.length() < 1) {
		return "";
	}
	NumberFormat formater = null;
	double num = Double.parseDouble(s);
	if (len == 0) {
		formater = new DecimalFormat("##0");
	} else {
		StringBuffer buff = new StringBuffer();
		buff.append("##0.");
		for (int i = 0; i < len; i++) {
			buff.append("0");
		}
		formater = new DecimalFormat(buff.toString());
	}
	return formater.format(num);
}
%>