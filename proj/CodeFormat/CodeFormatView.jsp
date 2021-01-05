
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>
<HTML>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
    </HEAD>

<%
    boolean canEdit = false ;
    //判断是否具有项目编码的维护权限
    if (HrmUserVarify.checkUserRight("ProjCode:Maintenance",user)) {
        canEdit = true ;   
    }

    String imagefilename = "/images/sales_wev8.gif";
    String titlename = "项目编码参数设置";
    String needfav ="1";
    String needhelp ="";//取得相应设置的值
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    if (canEdit) {
        RCMenu += "{编辑,javascript:location='CodeFormatEdit.jsp',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
    ProjCodeParaBean.getCodePara();
    String codePrefix = Util.null2String(ProjCodeParaBean.getCodePrefix());
    boolean isNeedProjTypeCode = ProjCodeParaBean.isNeedProjTypeCode();
    String year= Util.null2String(ProjCodeParaBean.getStrYear());
    String month = Util.null2String(ProjCodeParaBean.getStrMonth());
    String date = Util.null2String(ProjCodeParaBean.getStrDate());
    int glideNum = ProjCodeParaBean.getGlideNum();
    boolean isUseCode = ProjCodeParaBean.isUseCode();
%>
<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
    <TD height="10" colspan="3"></TD>
</TR>
<TR>
    <TD></TD>
    <TD valign="top">
         <TABLE class=Shadow>
            <TR>
                <TD valign="top">
                    <FORM  name=frmPara method=post action="CodeFormatOperation.jsp">
                        <TABLE class=ViewForm>
                            <COLGROUP>
                            <COL width="15%">
                            <COL width="85%">                            
                            <TBODY>
                                <TR class="Title"><TH>项目编号</TH><TD></TD></TR>
                                <TR><TD class=Line1 colSpan=2></TD></TR>
                                <TR>
                                    <TD>前缀</TD>
                                    <TD class="Field"><%if ("".equals(codePrefix)){out.println("无");} else {out.println(codePrefix);}%></TD>
                                </TR>  
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD>是否使用项目类型代号</TD>
                                    <TD class="Field">
                                        <% 
                                            if (isNeedProjTypeCode) out.println("使用");
                                            else  out.println("不使用");
                                        %>
                                    </TD>
                                </TR>                                  
                                <TR><TD class=Line colSpan=2></TD></TR>                            
                                <TR>
                                    <TD>年</TD>
                                    <TD class="Field">
                                         <% 
                                            if ("1".equals(year)) out.println("2-YEAR");
                                            else if ("2".equals(year))  out.println("4-YEAR");
                                            else  out.println("不使用");
                                        %>
                                    </TD>
                                </TR>
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD>月</TD>
                                    <TD class="Field">
                                        <%
                                            if ("1".equals(month)) out.println("使用");
                                            else  out.println("不使用");
                                        %>
                                    </TD>
                                </TR>
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD>日</TD>
                                    <TD class="Field">
                                        <%
                                            if ("1".equals(date)) out.println("使用");
                                            else  out.println("不使用");
                                        %>
                                    </TD>
                                </TR>  
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD>流水号</TD>
                                    <TD class="Field">
                                        <%
                                            if (glideNum==0) 
                                                out.println("无");
                                            else 
                                                out.println(glideNum);
                                        %>
                                    </TD>
                                </TR>                                 
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD>是否启用此设置</TD>
                                    <TD class="Field">
                                        <% 
                                            if (isUseCode) out.println("启用");
                                            else  out.println("不启用");
                                        %>                                    
                                    </TD>
                                </TR> 
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD>预览</TD>
                                    <TD class="Field">
                                        <Span name="spanPreview">
                                        <% 
                                            boolean isHaveSet = false ;     
                                            String strConsist="("; 
                                            if (!"".equals(codePrefix)){                                                                            
	                                            out.println("<font color='#660033'>"+codePrefix+"</font>");
	                                            strConsist+="前缀+";
                                                isHaveSet = true ;
                                            }
                                            if (isNeedProjTypeCode) {
                                                out.println("<font color='#6633CC'>XMLY</font>");
                                                strConsist+="项目类型代号+";
                                                isHaveSet = true ;
                                            }
                                            if ("1".equals(year)) {
                                                out.println("<font color='#FF33CC'>YY</font>");
                                                strConsist+="年+";
                                                isHaveSet = true ;
                                            } else if ("2".equals(year)) {
                                                out.println("<font color='#FF33CC'>YYYY</font>");
                                                strConsist+="年+";
                                                isHaveSet = true ;
                                            }
                                            if ("1".equals(month)){
                                                out.println("<font color='#666633'>MM</font>");
                                                strConsist+="月+";
                                                isHaveSet = true ;
                                             }
                                            if ("1".equals(date)) {
                                                out.println("<font color='#CC00FF'>DD</font>");
                                                strConsist+="日+";
                                                isHaveSet = true ;
                                            }
                                            if (glideNum!=0) {
                                                out.println("<font color='#996666'>"+Util.add0(1,glideNum)+"</font>");  
                                                strConsist+="流水号";
                                                isHaveSet = true ;
                                            }   
                                            strConsist+=")";   
                                            
                                            if (!isHaveSet) strConsist="";                                         
                                        %>                                     
                                        </Span>                                       
                                        &nbsp;&nbsp;&nbsp;&nbsp;<%=strConsist%>
                                    </TD>
                                </TR>                                
                                <TR><TD class=Line colSpan=2></TD></TR>
                                <TR>
                                    <TD valign="top">备注</TD>
                                    <TD>
                                        XMLY(指的是项目类型编号 如:利润型项目类型的代号是 LYX 那此处就是LYX)<BR> 
                                        YYYY (四位数的年 如:1983,1985...) YY(两位数的年 如:83,85...)<BR>
                                        MM(两位数的月 如:10,11...)<BR>
                                        DD(两位数的日 如:08,23...)<BR>
                                             是否启用此设置:指的是在项目类型的编号中,这个编号规则是否使用
                                    </TD>
                                </TR>
                            </TBODY>
                         </TABLE>
                    </FORM>
                </TD>
            </TR>            
         </TABLE>
    </TD>
    <TD></TD>
</TR>
<TR>
    <TD height="10" colspan="3"></TD>
</TR>
</BODY>
</HTML>
