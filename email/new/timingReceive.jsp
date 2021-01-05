<%@page import="weaver.general.Util"%>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.email.po.Mailconfigureinfo"%>
<%@page import="weaver.email.MailReciveStatusUtils"%>
<script type="text/javascript">
<%
    Mailconfigureinfo mailconfigureinfo = MailReciveStatusUtils.getMailconfigureinfoFromCache();
    int autoreceive = mailconfigureinfo.getAutoreceive();
    int outterMail = mailconfigureinfo.getOutterMail();
    int timecount = mailconfigureinfo.getTimecount();
    String isTimeOutLogin1 = Prop.getPropValue("Others","isTimeOutLogin");
%>
	<%if(!"2".equals(isTimeOutLogin1) && outterMail == 1 && autoreceive == 1){%>
        var timecount = <%=timecount%>;
        jQuery.post("/email/MailTimingDateReceiveOperation.jsp?"+new Date().getTime());
		window.setInterval(function (){
			jQuery.post("/email/MailTimingDateReceiveOperation.jsp?"+new Date().getTime());
	  	}, timecount);
	<%}%>  	
</script>