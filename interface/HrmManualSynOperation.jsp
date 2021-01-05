
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.hrm.resource.HrmSynDAO" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*,javax.servlet.jsp.JspWriter" %>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<HTML><HEAD>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>  
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if (!HrmUserVarify.checkUserRight("intergration:hrsetting", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%!
public void writeMsgList(ArrayList Msglist,boolean islight,String bgcolorvalue,ExcelSheet nces,JspWriter out,User user) throws Exception
{
	for (int i = 0; i < Msglist.size(); i++) {            
        HashMap ItemMap = (HashMap) Msglist.get(i);
        String Successtr = (String) ItemMap.get(HrmSynDAO.Success);
        switch (Util.getIntValue(Successtr, 0)) {
            case 0:
                Successtr = "<font color=red>"+SystemEnv.getHtmlLabelName(498,user.getLanguage())+"</font>";
                break;
            case 1:
                Successtr = SystemEnv.getHtmlLabelName(83326,user.getLanguage());//插入成功
                break;
            case 2:
                Successtr = SystemEnv.getHtmlLabelName(31439,user.getLanguage());//更新成功
                break;
            case 3:
                Successtr = SystemEnv.getHtmlLabelName(20461,user.getLanguage());//删除成功
                break;
            case 4:
                Successtr = SystemEnv.getHtmlLabelName(22155,user.getLanguage());//封存成功
                break;
            case 5:
                Successtr = SystemEnv.getHtmlLabelName(22156,user.getLanguage());//解封成功
                break;
        }
        if(islight){
            bgcolorvalue="#f5f5f5";
            islight=!islight;
        }else{
            bgcolorvalue="#e7e7e7";
            islight=!islight;
        }
        ExcelRow ncessub[] = new ExcelRow[Msglist.size()];
        ncessub[i] = nces.newExcelRow();
        ncessub[i].addStringValue(ItemMap.get(HrmSynDAO.OUTPK).toString());
        ncessub[i].addStringValue(ItemMap.get(HrmSynDAO.PK).toString());
        ncessub[i].addStringValue(ItemMap.get(HrmSynDAO.Memo).toString());
        ncessub[i].addStringValue(Successtr);
        nces.addExcelRow(ncessub[i]);
        out.println("<tr bgcolor="+bgcolorvalue+">");
        out.println("<td>"+ItemMap.get(HrmSynDAO.OUTPK)+"</td>");
        out.println("<td>"+ItemMap.get(HrmSynDAO.PK)+"</td>");
        out.println("<td>"+ItemMap.get(HrmSynDAO.Memo)+"</td>");
        out.println("<td>"+Successtr+"</td>");
        out.println("</tr>");      
    }
}
%>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(83334,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	   <wea:item attributes="{'samePair':'results','isTableList':'true'}">
<%
	Logger log = LoggerFactory.getLogger();
    String id = Util.null2String(request.getParameter("type"));
	HrmSynDAO hrmSynDAO = HrmSynDAO.getInstance();
    HashMap SynMsg = hrmSynDAO.syn(id);
    boolean hasHeader=false;
    boolean islight=false;
    String bgcolorvalue="#f5f5f5";
    ExcelSheet nces = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
    //同步结果table
    
    out.println("<TABLE class=ListStyle><COLGROUP><COL width='25%'><COL width='25%'><COL width='35%'><COL width='15%'>");
    //总部
    ArrayList Msglist = new ArrayList();
    try{
        Msglist=(ArrayList)SynMsg.get("0");
        if(Msglist!=null){
        	if (Msglist.size() > 0) {
                out.println("<tr class=header>");
                out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
                out.println("<td>HR"+SystemEnv.getHtmlLabelName(83336,user.getLanguage())+"</td>");
                out.println("<td>"+SystemEnv.getHtmlLabelName(83337,user.getLanguage())+"</td>");
                out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
                out.println("</tr>");
                hasHeader=true;
                ExcelRow ncersub = nces.newExcelRow () ;  //准备新增EXCEL中的一行
                ncersub.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
                ncersub.addStringValue("HR"+SystemEnv.getHtmlLabelName(83336,user.getLanguage())+"");
                ncersub.addStringValue(""+SystemEnv.getHtmlLabelName(83337,user.getLanguage())+"");
                ncersub.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
                nces.addExcelRow(ncersub);
                writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user);
            }
        }
    }catch(Exception e){
        log.error(e);
    }
    //分部
    try{
        Msglist=(ArrayList)SynMsg.get("1");
        if(Msglist!=null){
	        if (Msglist.size() > 0) {
	            out.println("<tr class=header>");
	            out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
	            out.println("<td>HR"+SystemEnv.getHtmlLabelName(25754,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(1976,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
	            out.println("</tr>");
	            hasHeader=true;
	            ExcelRow ncersub = nces.newExcelRow () ;  //准备新增EXCEL中的一行
	            ncersub.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
	            ncersub.addStringValue("HR"+SystemEnv.getHtmlLabelName(25754,user.getLanguage())+"");
	            ncersub.addStringValue(""+SystemEnv.getHtmlLabelName(1976,user.getLanguage())+"");
	            ncersub.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
	            nces.addExcelRow(ncersub);
	            writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user); 
	        }  
        }
    }catch(Exception e){
        log.error(e);
    }
    //部门
    Msglist = new ArrayList();
    try{
        Msglist=(ArrayList)SynMsg.get("2");
        if(Msglist!=null){
	        if (Msglist.size() > 0) {
	            if(hasHeader){
	                out.println("<TR style='height:1px!important;'><TD class=Line1 style='height:1px!important;' colSpan=4></TD></TR>");
	            }else{
	                hasHeader=true;
	            }
	            out.println("<tr CLASS=header>");
	            out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
	            out.println("<td>HR"+SystemEnv.getHtmlLabelName(22806,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(15390,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
	            out.println("</tr>");
	            ExcelRow ncerdept = nces.newExcelRow () ;  //准备新增EXCEL中的一行
	            ncerdept.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
	            ncerdept.addStringValue("HR"+SystemEnv.getHtmlLabelName(22806,user.getLanguage())+"");
	            ncerdept.addStringValue(""+SystemEnv.getHtmlLabelName(15390,user.getLanguage())+"");
	            ncerdept.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
	            nces.addExcelRow(ncerdept);
	            islight=false;
	            bgcolorvalue="#f5f5f5";
	            writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user);
	        }
        }
        
    }catch(Exception e){
        log.error(e);
    }
    //职务类别
    Msglist = new ArrayList();
    try{
        Msglist=(ArrayList)SynMsg.get("6");
        if(Msglist!=null){
	        if (Msglist.size() > 0) {
	            if(hasHeader){
	                out.println("<TR style='height:1px!important;'><TD class=Line1 style='height:1px!important;' colSpan=4></TD></TR>");
	            }else{
	                hasHeader=true;
	            }
	            out.println("<tr CLASS=header>");
	            out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
	            out.println("<td>HR"+SystemEnv.getHtmlLabelName(83340,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(23051,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
	            out.println("</tr>");
	            ExcelRow ncerrole = nces.newExcelRow () ;  //准备新增EXCEL中的一行
	            ncerrole.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
	            ncerrole.addStringValue("HR"+SystemEnv.getHtmlLabelName(83340,user.getLanguage())+"");
	            ncerrole.addStringValue(""+SystemEnv.getHtmlLabelName(23051,user.getLanguage())+"");
	            ncerrole.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
	            nces.addExcelRow(ncerrole);
	            writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user);
	        }
        }
    }catch(Exception e){
        log.error(e);
    }
    //职务
    Msglist = new ArrayList();
    try{
        Msglist=(ArrayList)SynMsg.get("7");
        if(Msglist!=null){
	        if (Msglist.size() > 0) {
	            if(hasHeader){
	                out.println("<TR style='height:1px!important;'><TD class=Line1 style='height:1px!important;' colSpan=4></TD></TR>");
	            }else{
	                hasHeader=true;
	            }
	            out.println("<tr CLASS=header>");
	            out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
	            out.println("<td>HR"+SystemEnv.getHtmlLabelName(83341,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83342,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
	            out.println("</tr>");
	            ExcelRow ncerrole = nces.newExcelRow () ;  //准备新增EXCEL中的一行
	            ncerrole.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
	            ncerrole.addStringValue("HR"+SystemEnv.getHtmlLabelName(83341,user.getLanguage())+"");
	            ncerrole.addStringValue(""+SystemEnv.getHtmlLabelName(83342,user.getLanguage())+"");
	            ncerrole.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
	            nces.addExcelRow(ncerrole);
	            writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user);
	        }
        }
    }catch(Exception e){
        log.error(e);
    }
    //岗位
    Msglist = new ArrayList();
    try{
        Msglist=(ArrayList)SynMsg.get("3");
        if(Msglist!=null){
	        if (Msglist.size() > 0) {
	            if(hasHeader){
	                out.println("<TR style='height:1px!important;'><TD class=Line1 style='height:1px!important;' colSpan=4></TD></TR>");
	            }else{
	                hasHeader=true;
	            }
	            out.println("<tr CLASS=header>");
	            out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
	            out.println("<td>HR"+SystemEnv.getHtmlLabelName(83343,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(20580,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
	            out.println("</tr>");
	            ExcelRow ncerrole = nces.newExcelRow () ;  //准备新增EXCEL中的一行
	            ncerrole.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
	            ncerrole.addStringValue("HR"+SystemEnv.getHtmlLabelName(83343,user.getLanguage())+"");
	            ncerrole.addStringValue(""+SystemEnv.getHtmlLabelName(20580,user.getLanguage())+"");
	            ncerrole.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
	            nces.addExcelRow(ncerrole);
	            writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user);
	        }
        }
    }catch(Exception e){
        log.error(e);
    }
    //人员及帐号
    Msglist = new ArrayList();
    try{
        Msglist=(ArrayList)SynMsg.get("4");
        if(Msglist!=null){
	        if (Msglist.size() > 0) {
	            if(hasHeader){
	                out.println("<TR style='height:1px!important;'><TD style='height:1px!important;' class=Line1 colSpan=4></TD></TR>");
	            }else{
	                hasHeader=true;
	            }
	            out.println("<tr CLASS=header>");
	            out.println("<td>HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"</td>");
	            out.println("<td>HR"+SystemEnv.getHtmlLabelName(83344,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(27622,user.getLanguage())+"</td>");
	            out.println("<td>"+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"</td>");
	            out.println("</tr>");
	            ExcelRow ncerment = nces.newExcelRow () ;  //准备新增EXCEL中的一行
	            ncerment.addStringValue("HRPK"+SystemEnv.getHtmlLabelName(83335,user.getLanguage())+"");
	            ncerment.addStringValue("HR"+SystemEnv.getHtmlLabelName(83344,user.getLanguage())+"");
	            ncerment.addStringValue(""+SystemEnv.getHtmlLabelName(27622,user.getLanguage())+"");
	            ncerment.addStringValue(""+SystemEnv.getHtmlLabelName(83338,user.getLanguage())+"");
	            nces.addExcelRow(ncerment);
	            writeMsgList(Msglist,islight,bgcolorvalue,nces,out,user);
	        }
        }
    }catch(Exception e){
        log.error(e);
    }
    if(hasHeader){
        out.println("<TR style='height:1px!important;'><TD style='height:1px!important;' class=Line colSpan=4></TD></TR></table>");
    }else {
        out.println("<TR><TD colSpan=4 align='center'><br><font color=red><b>"+SystemEnv.getHtmlLabelName(83345,user.getLanguage())+"</b></font></TD></TR></table>");
        ExcelRow ncernodata = nces.newExcelRow () ;  //准备新增EXCEL中的一行
        ncernodata.addStringValue(""+SystemEnv.getHtmlLabelName(83345,user.getLanguage())+"");
        nces.addExcelRow(ncernodata);
    }
    
    ExcelFile.init() ; 
	ExcelFile.setFilename(""+SystemEnv.getHtmlLabelName(83346,user.getLanguage())+"") ;
	ExcelFile.addSheet("sheet", nces) ; //为EXCEL文件插入一个SHEET
	out.println("<iframe id='HrmExcelOut' name='HrmExcelOut' border=0 frameborder=no noresize=NORESIZE height='0%' width='0%'></iframe>");
%>
		</wea:item>
</wea:group>
</wea:layout>
<BODY>
</BODY>
</HTML>
