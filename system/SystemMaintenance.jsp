<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(468,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

int userid=user.getUID();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps>
<%if(!software.equals("ALL")){%>
<%
String mainttype = Util.null2String(request.getParameter("mainttype"));
%>
<TABLE class="Form">
    <TR>
        <TD align=right>
            <SELECT name=mainttype onchange="changetype()">
                <OPTION value=S <%if(mainttype.equals("S")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></OPTION>
                <OPTION value=W <%if(mainttype.equals("W")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></OPTION>
                <OPTION value=D <%if(mainttype.equals("D")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></OPTION>
                <OPTION value=H <%if(mainttype.equals("H")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION>
                <%if(software.equals("ALL") || software.equals("CRM")){%>
                <OPTION value=C <%if(mainttype.equals("C")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></OPTION>
                <OPTION value=R <%if(mainttype.equals("R")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></OPTION>
                <%}%>
                <%if(software.equals("ALL") || software.equals("HRM")){%>
                <OPTION value=I <%if(mainttype.equals("I")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></OPTION>
                <%}%>
                <%if(software.equals("ALL") || software.equals("HRM") || software.equals("CRM")){%>
                <OPTION value=F <%if(mainttype.equals("F")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></OPTION>
                <%}%>
            </SELECT>
            <script language=javascript>
                function changetype(){
                    if(document.all("mainttype").value=="S") location = "/system/SystemMaintenance.jsp?mainttype=S";
                    if(document.all("mainttype").value=="W") location = "/workflow/WFMaintenance.jsp?mainttype=W";
                    if(document.all("mainttype").value=="D") location = "/docs/DocMaintenance.jsp?mainttype=D";
                    if(document.all("mainttype").value=="H") location = "/hrm/HrmMaintenance.jsp?mainttype=H";
                    if(document.all("mainttype").value=="C") location = "/CRM/CRMMaintenance.jsp?mainttype=C";
                    if(document.all("mainttype").value=="R") location = "/proj/ProjMaintenance.jsp?mainttype=R";
                    if(document.all("mainttype").value=="F") location = "/fna/FnaMaintenance.jsp?mainttype=F";
                    if(document.all("mainttype").value=="I") location = "/cpt/CptMaintenance.jsp?mainttype=I";
                }
            </script>
        </TD>
    </TR>
</TABLE>
<%}%>
</DIV>

<TABLE class=Form>
<COLGROUP>
<COL width="48%">
<COL width=20>
<COL width="48%">
<TBODY>
<TR>
    <TD vAlign=top>
    <TABLE class=form>
        <TBODY> 
            <TR class=Section> 
                <TH><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
            </TR>
            <TR class=Separator> 
                <TD class=sep1></TD>
            </TR>
            <!--
            <tr> 
                <td><a     href="/system/EditParametersOfSlogan.jsp"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></a></td>
            </tr>
            -->
            <tr> 
                <td><a href="/hrm/country/HrmCountries.jsp"><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></a></td>
            </tr>
            <tr> 
                <td><a href="/hrm/province/HrmProvince.jsp"><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></a></td>
            </tr>
            <tr> 
                <td><a href="/hrm/city/HrmCity.jsp"><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></a></td>
            </tr>
            <!--
            <tr> 
                <td><a href="/system/Weather.jsp"><%=SystemEnv.getHtmlLabelName(5000,user.getLanguage())%></a></td>
            </tr>
            -->
            <tr> 
                <td><a href="SystemSetEdit.jsp"><%=SystemEnv.getHtmlLabelName(774,user.getLanguage())%></a></td>
            </tr>
            <% if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){ %>
            <TR> 
                <TD><a href="CreateDB.jsp"><%=SystemEnv.getHtmlLabelName(776,user.getLanguage())%></a></TD>
            </TR>
            <%}%>
        </TBODY> 
    </TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top> 
    <table class=form>
        <tbody> 
            <tr class=Section> 
                <th><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%></th>
            </tr>
            <tr class=Separator> 
                <td class=Sep1></td>
            </tr>
            <tr> 
                <td><a href="/systeminfo/systemright/SystemRightGroup.jsp"><%=SystemEnv.getHtmlLabelName(492,user.getLanguage())%></a></td>
            </tr>
            <tr> 
                <td><a href="/hrm/roles/HrmRoles.jsp"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></a></td>
            </tr>
            <tr> 
                <td><a href="/hrm/transfer/HrmRightTransfer.jsp"><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(80,user.getLanguage())%></a></td>
            </tr>
            <!--
            <% if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){ %>
            <tr> 
                <td><a href="/system/basedata/basedata.jsp">基础数据</a></td>
            </tr>
            <%}%>
            -->
            </tbody> 
    </table>          
    </TD>
</TR>
<TR>
    <TD vAlign=top> 
    <table width="100%">
        <tbody> 
            <tr class=Section> 
                <th><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></th>
            </tr>
            <tr class=Separator> 
                <td class=sep1></td>
            </tr>
            <tr> 
                <td><a href="/fna/maintenance/FnaCurrencies.jsp"><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></a>
            </td>
            </tr>
        </tbody> 
    </table>
    </TD>
    <TD></TD>
    <TD vAlign=top> 
        <table width="100%">
            <tbody> 
            <tr class=Section> 
                <th><%=SystemEnv.getHtmlLabelName(15000,user.getLanguage())%></th>
            </tr>
            <tr class=Separator> 
                <td class=sep1></td>
            </tr>
            <tr> 
                <td><a href="/system/othersysinterface/OtherSystemUser.jsp"><%=SystemEnv.getHtmlLabelName(7181,user.getLanguage())%></a>
            </td>
            </tr>
        </tbody> 
    </table>
    </TD>
    <!--TD vAlign=top> 
    <table width="100%">
    <tbody> 
    <tr class=Section> 
    <th>短信服务</th>
    </tr>
    <tr class=Separator> 
    <td class=sep1></td>
    </tr>
    <tr> 
    <td><a href="/sms/SmsMessageEdit.jsp">编写短信</a>
    </td>
    </tr>
    <tr> 
    <td><a href="/sms/SmsManage.jsp">短信管理</a>
    </td>
    </tr>
    </tbody> 
    </table>
    </TD-->
    <TD></TD>
</TR>
<TR>
    <TD vAlign=top> 
    <!-- table class=form>
        <tbody> 
            <tr class=Section> 
                <th><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></th>
            </tr>
            <tr class=Separator> 
                <td class=sep1></td>
            </tr>
            <tr> 
                <td><a href="http://server-weaver/new/docs/SystemReadRecent.asp">读取/已建立 - 近期</a></td>
            </tr>
            <tr> 
                <td><a href="http://server-weaver/new/docs/SystemAppLog.asp">应用程序</a></td>
            </tr>
            <tr> 
                <td><a href="http://server-weaver/new/docs/EPRequestSearchLog.asp">搜索</a></td>
            </tr>
            <tr> 
                <td><a href="http://server-weaver/new/docs/SystemErrorLog.asp">错误</a></td>
            </tr>
        </tbody>
    </table -->
<%if(HrmUserVarify.checkUserRight("LogView:View", user)){%>
    <table width="100%">
        <tbody> 
        <tr class=Section> 
            <th><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></th>
        </tr>
        <tr class=Separator> 
            <td class=sep1></td>
        </tr>
        <tr> 
            <td><a href="/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=60 "><%=SystemEnv.getHtmlLabelName(2059,user.getLanguage())%></a></td>
        </tr>
        <%}%>
        </tbody> 
    </table>
    </TD>
</TR>
 
<TR>
    <TD vAlign=top>
    <!-- TABLE class=form>
        <TBODY>
            <TR class=Section>
                <TH>XML</TH>
             </TR>
            <TR class=Separator>
                <TD class=Sep1></TD>
             </TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/XMLHome.asp">主页</A></TD>
            </TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/XMLLog.asp"><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></A></TD>
            </TR>
        </TBODY>
    </TABLE -->
    </TD>
    <TD></TD>
    <TD vAlign=top>
    <!-- TABLE class=form>
        <TBODY>
            <TR class=Section>
                <TH>许可证</TH>
            </TR>
            <TR class=Separator>
                <TD class=Sep1></TD>
            </TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemLicenseInfo.asp">信息</A></TD>
            </TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemUpdateLicense.asp">更新</A></TD>
            </TR>
        </TBODY>
    </TABLE-->
    </TD>
</TR>
<TR>
    <TD vAlign=top>
    <!-- TABLE class=form>
        <TBODY>
            <TR class=Section>
                <TH>数据库</TH></TR>
            <TR class=Separator>
                <TD class=Sep1></TD></TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemNewDatabase.asp">新</A></TD></TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemSetupCompany.asp">设置公司</A></TD></TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemDatabaseStats.asp?View=1">表</A></TD></TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemQueryTimeouts.asp?View=1">Query timeouts</A></TD>
            </TR>
        </TBODY>
    </TABLE -->
    </TD>
    <TD></TD>
    <TD vAlign=top>
    <!-- TABLE class=form>
        <TBODY>
            <TR class=Section>
                <TH>程序</TH></TR>
            <TR class=Separator>
                <TD class=Sep1></TD></TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/SystemProcessLog.asp"><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></A></TD>
            </TR>
            <TR>
                <TD><A href="http://server-weaver/new/docs/BLProcessTypes.asp">设定</A></TD>
            </TR>
        </TBODY>
    </TABLE -->
    </TD>
</TR>
<TR>
    <TD vAlign=top>
        <!-- TABLE class=form>
            <TBODY>
                <TR class=Section>
                    <TH>Repository</TH></TR>
                <TR class=Separator>
                    <TD class=Sep1></TD></TR>
                <TR>
                    <TD><A href="http://server-weaver/new/docs/ERGroups.asp">Explorer</A></TD></TR>
                <TR>
                    <TD><A href="http://server-weaver/new/docs/SystemRebuildRepository.asp">重建</A></TD></TR>
                <TR>
                    <TD><A href="http://server-weaver/new/docs/SystemScripts.asp">脚本</A></TD>
                </TR>
            </TBODY>
        </TABLE -->
    </TD>
</TR>
</TBODY>
</TABLE>
</BODY>
</HTML>
