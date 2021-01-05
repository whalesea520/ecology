<!--半年预算 开始-->
<%
isFirst = false;
isSecond = false;
isThird = false;

subject1id = new ArrayList();
subject1name = new ArrayList();
subject1rowcount = new ArrayList();

subject2id = new ArrayList();
subject2name = new ArrayList();
subject2sup = new ArrayList();
subject2rowcount = new ArrayList();

subject3id = new ArrayList();
subject3name = new ArrayList();
subject3sup = new ArrayList();

sup1idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("1")){
        if(tfeeperiod.equals("3")){
    	    subject1id.add(tid);
		    subject1name.add(tname);
		    subject1rowcount.add("0");
		    sup1idstr += ","+tid;
        }
	}
}
sup1idstr += ",";

sup2idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("2")){
        if(sup1idstr.indexOf(","+tsup+",")>-1){
    	    subject2id.add(tid);
    		subject2name.add(tname);
    		subject2sup.add(tsup);
    	    subject2rowcount.add("0");
    		sup2idstr += ","+tid;
        }
	}
}
sup2idstr += ",";
	
recordcount = 0;
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("3")){
        if(sup2idstr.indexOf(","+tsup+",")>-1){
   			recordcount++;
    		if(recordcount>=(topage-1)*pagesize+1&&recordcount<=topage*pagesize){
	    	    subject3id.add(tid);
	    		subject3name.add(tname);
	    		subject3sup.add(tsup);
    		}
        }
	}
}

for(int l1=0;l1<subject1id.size();l1++) {
    int count1 = 0;
    for(int l2=0;l2<subject2id.size();l2++) {
        int count2 = 0;
        if(subject2sup.get(l2).toString().equals(subject1id.get(l1).toString())){
            for(int l3=0;l3<subject3id.size();l3++) {
                if(subject3sup.get(l3).toString().equals(subject2id.get(l2).toString()))
                    count2++;
            }
            subject2rowcount.set(l2,count2+"");
            count1+=count2;
        }
    }
    subject1rowcount.set(l1,count1+"");
}

pagecount = (recordcount % pagesize == 0)?(recordcount / pagesize):(recordcount / pagesize + 1);
%>
<div id="halfyearbudgetlisttable" style="display:<% if(showtab==3){ %>block<%}else{%>none<%}%>">

<DIV align=right>&raquo;&nbsp;
<%=SystemEnv.getHtmlLabelName(18609, user.getLanguage())%><%=recordcount%><%=SystemEnv.getHtmlLabelName(18256, user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(264, user.getLanguage())%>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(265, user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256, user.getLanguage())%>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(18609, user.getLanguage())%><%=pagecount%><%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(524, user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(15323, user.getLanguage())%><%=topage%><%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%>&nbsp;&nbsp;
<SPAN><%if(topage>1){ %><a href="javascript:onPage(1);"><%} %><%=SystemEnv.getHtmlLabelName(18363, user.getLanguage())%><%if(topage>1){ %></a><%} %></SPAN>&nbsp;
<SPAN><%if(topage>1){ %><a href="javascript:onPage(<%=topage-1%>);"><%} %><%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%><%if(topage>1){ %></a><%} %></SPAN>&nbsp;
<SPAN><%if(topage<pagecount){ %><a href="javascript:onPage(<%=topage+1%>);"><%} %><%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%><%if(topage<pagecount){ %></a><%}%></SPAN>&nbsp;
<SPAN><%if(topage<pagecount){ %><a href="javascript:onPage(<%=pagecount%>);"><%} %><%=SystemEnv.getHtmlLabelName(18362, user.getLanguage())%><%if(topage<pagecount){ %></a><%}%></SPAN>&nbsp;
<BUTTON type="button" onclick="onPage(document.getElementById('topage').value);">
<%=SystemEnv.getHtmlLabelName(23162, user.getLanguage())%>
</BUTTON>&nbsp;
<%=SystemEnv.getHtmlLabelName(15323, user.getLanguage())%>
<INPUT class=text id=halfyear_gopage1 style="TEXT-ALIGN: right" size=2 value="<%=topage%>" onChange="document.getElementById('topage').value=this.value;">
<%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%>
</DIV>

<TABLE width=100% class=ListStyle cellspacing=1>
<COLGROUP>
<col width="70">
<col width="70">
<col width="70">
<col width="80">
<col width="17%">
<col width="17%">
<col width="17%">
<THEAD>
    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(18424, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18425, user.getLanguage())%></th>
        <th><input name="halfyear_FnaBudgetfeeTypeIDs" type="checkbox"
                   onClick="onSelectAll(this);"><%=SystemEnv.getHtmlLabelName(18426, user.getLanguage())%></th>
        <th>&nbsp;</th>
        <th>1<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>2<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(1013, user.getLanguage())%></th>
    </tr>

</THEAD>
<%
for(int l1=0;l1<subject1id.size();l1++) {
    String firestlevelid = subject1id.get(l1).toString();
    String firestlevelname = subject1name.get(l1).toString();
    String firestlevelrowcount = subject1rowcount.get(l1).toString();
    isFirst = true;

    for(int l2=0;l2<subject2id.size();l2++) {
        String secondlevelid = subject2id.get(l2).toString();
        String secondlevelname = subject2name.get(l2).toString();
        String secondlevelsup = subject2sup.get(l2).toString();
        String secondlevelrowcount = subject2rowcount.get(l2).toString();
        if(!secondlevelsup.equals(firestlevelid)) continue;
        isSecond = true;

        for(int l3=0;l3<subject3id.size();l3++) {
            String thirdlevelid = subject3id.get(l3).toString();
            String thirdlevelname = subject3name.get(l3).toString();
            String thirdlevelsup = subject3sup.get(l3).toString();
            if(!thirdlevelsup.equals(secondlevelid)) continue;
        	isThird = !isThird;
%>
<TR>
<%
    if (isFirst) {
        isFirst = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=firestlevelrowcount%>"><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=secondlevelrowcount%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF">
    <input name="FnaBudgetfeeTypeIDs" type="hidden" value="<%=thirdlevelid%>">
    <input name="FnaBudgetfeeTypeSaveValueNum" type="hidden" value="2">
    <input name="halfyear_FnaBudgetfeeTypeIDs" type="checkbox" value="<%=thirdlevelid%>"
    ><%if (canLinkTypeView) {%><a
        href="FnaBudgetTypeEdit.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if (canLinkTypeView) {%></a><%}%>
</TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <%if (canShowAvailableBudget) {%>
        <tr height=20 class=datadark><td nowrap><%out.println(SystemEnv.getHtmlLabelName(18604, user.getLanguage()));//上级可用预算%></tr>
        <%}%>
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td
                nowrap><%out.println(SystemEnv.getHtmlLabelName(18568, user.getLanguage()));//已分配下级预算%></td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap><%out.println(SystemEnv.getHtmlLabelName(18569, user.getLanguage()));//原预算额%></td>
        </tr>
        <tr height=20 class=datalight><td nowrap><%out.println(SystemEnv.getHtmlLabelName(18570, user.getLanguage()));//新预算额%></td>
        </tr>
        <tr height=20 class=datadark><td nowrap><%out.println(SystemEnv.getHtmlLabelName(18571, user.getLanguage()));//预算增额%></td>
        </tr>
    </table>
</TD>
<%
    tmpSum1 = 0d;
    tmpSum2 = 0d;
    tmpSum3 = 0d;
    tmpSum4 = 0d;
    tmpSum5 = 0d;
    tmpnum1 = 0d;
    tmpnum2 = 0d;

    Map availableBudgetAmount = FnaBudgetInfoComInfo.getAvailableBudgetAmount(organizationid, organizationtype, budgetperiods, thirdlevelid);
    Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, thirdlevelid);
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(organizationid,organizationtype,budgetperiods,thirdlevelid);
    Map currentBudgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);

    for (int j = 1; j < 3; j++) {
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <%if (canShowAvailableBudget) {%>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                tmpnum = Util.getDoubleValue(Util.null2o((String)availableBudgetAmount.get(""+j)));//FnaBudgetInfoComInfo.getAvailableBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(j)).toString(), thirdlevelid);
                tmpSum1 += tmpnum;
            %>
            <span id="halfyear_<%=thirdlevelid%>_canusedbudget_<%=j%>"
                  style="color:<%=(tmpnum==0?"RED":"BLACK")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        </td></tr>
        <%}%>
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                tmpnum = Util.getDoubleValue(Util.null2o((String)distributiveBudgetAmount.get(""+j)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(j)).toString(), thirdlevelid);
                tmpSum2 += tmpnum;
            %>
            <span id="halfyear_<%=thirdlevelid%>_allottedbudget_<%=j%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                tmpnum = Util.getDoubleValue(Util.null2o((String)budgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(j)).toString(), thirdlevelid);
                tmpnum1 = tmpnum;
                tmpSum3 += tmpnum;
            %>
            <span id="halfyear_<%=thirdlevelid%>_originalbudget_<%=j%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                tmpnum = Util.getDoubleValue(Util.null2o((String)currentBudgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(organizationid,organizationtype,budgetperiods,(new Integer(j)).toString(), thirdlevelid);
                tmpnum2 = tmpnum;
                tmpSum5 += tmpnum;
            %>
            <input type="text" name="halfyear_<%=thirdlevelid%>_newbudget_<%=j%>" onblur='checknumber("halfyear_<%=thirdlevelid%>_newbudget_<%=j%>");onCalculete(this);'
                   class=InputStyle maxlength=20 style="text-align:right;" size=8
                   onKeyPress="ItemNum_KeyPress()" 
                   value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum,false)%>">
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                tmpnum = tmpnum2 - tmpnum1;
                tmpSum4 += tmpnum;
            %>
            <span id="halfyear_<%=thirdlevelid%>_addedbudget_<%=j%>"
                  style="color:<%=(tmpnum<0?"RED":"GREEN")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        </td></tr>
    </table>
</TD>
<%
    }
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <%if (canShowAvailableBudget) {%>
        <tr height=20 class=datadark id="msg_<%=thirdlevelid%>_canusedbudget"><td nowrap align=right>
            <span id="halfyear_<%=thirdlevelid%>_canusedbudget_sum"
                  style="color:<%=(tmpSum1==0?"RED":"BLACK")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1)%></span>
        </td></tr>
        <%}%>
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight id="msg_<%=thirdlevelid%>_allottedbudget"><td nowrap align=right>
            <span id="halfyear_<%=thirdlevelid%>_allottedbudget_sum"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2)%></span>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark id="msg_<%=thirdlevelid%>_originalbudget"><td nowrap align=right>
            <span id="halfyear_<%=thirdlevelid%>_originalbudget_sum"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3)%></span>
        </td></tr>
        <tr height=20 class=datalight id="msg_<%=thirdlevelid%>_newbudget"><td nowrap align=right>
            <input type="text" name="halfyear_<%=thirdlevelid%>_newbudget_sum" onblur="onCalculete(this);"
                   class=InputStyle maxlength=20 style="text-align:right;" size=8
                   value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum5,false)%>">
        </td></tr>
        <tr height=20 class=datadark id="msg_<%=thirdlevelid%>_addedbudget"><td nowrap align=right>
            <span id="halfyear_<%=thirdlevelid%>_addedbudget_sum"
                  style="color:<%=(tmpSum4<0?"RED":"GREEN")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4)%></span>
            <input type="hidden" id="halfyear_<%=thirdlevelid%>_addedbudget_sumhid" name="halfyear_<%=thirdlevelid%>_addedbudget_sumhid" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4)%>"/>
        </td></tr>
    </table>
</TD>
</TR>
<%
            }
        }
    }
%>

</TABLE>

<DIV align=right>&raquo;&nbsp;
<%=SystemEnv.getHtmlLabelName(18609, user.getLanguage())%><%=recordcount%><%=SystemEnv.getHtmlLabelName(18256, user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(264, user.getLanguage())%>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(265, user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256, user.getLanguage())%>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(18609, user.getLanguage())%><%=pagecount%><%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%>&nbsp;&nbsp;&nbsp;
<%=SystemEnv.getHtmlLabelName(524, user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(15323, user.getLanguage())%><%=topage%><%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%>&nbsp;&nbsp;
<SPAN><%if(topage>1){ %><a href="javascript:onPage(1);"><%} %><%=SystemEnv.getHtmlLabelName(18363, user.getLanguage())%><%if(topage>1){ %></a><%} %></SPAN>&nbsp;
<SPAN><%if(topage>1){ %><a href="javascript:onPage(<%=topage-1%>);"><%} %><%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%><%if(topage>1){ %></a><%} %></SPAN>&nbsp;
<SPAN><%if(topage<pagecount){ %><a href="javascript:onPage(<%=topage+1%>);"><%} %><%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%><%if(topage<pagecount){ %></a><%}%></SPAN>&nbsp;
<SPAN><%if(topage<pagecount){ %><a href="javascript:onPage(<%=pagecount%>);"><%} %><%=SystemEnv.getHtmlLabelName(18362, user.getLanguage())%><%if(topage<pagecount){ %></a><%}%></SPAN>&nbsp;
<BUTTON type="button" onclick="onPage(document.getElementById('topage').value);">
<%=SystemEnv.getHtmlLabelName(23162, user.getLanguage())%>
</BUTTON>&nbsp;
<%=SystemEnv.getHtmlLabelName(15323, user.getLanguage())%>
<INPUT class=text id=halfyear_gopage2 style="TEXT-ALIGN: right" size=2 value="<%=topage%>" onChange="document.getElementById('topage').value=this.value;">
<%=SystemEnv.getHtmlLabelName(23161, user.getLanguage())%>
</DIV>

</div>
<!--半年预算 结束-->