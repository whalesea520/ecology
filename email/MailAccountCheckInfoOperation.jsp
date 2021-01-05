<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.email.EmailEncoder"%>
<%@page import="java.net.Socket"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="weaver.email.Email_Autherticator"%>
<%@page import="java.security.Security"%>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Store"%>
<%@page import="javax.mail.URLName"%>
<%@page import="weaver.email.MailErrorMessageInfo"%>
<%@page import="weaver.email.MailErrorFormat"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.SocketAddress"%>
<%@page import="java.net.InetSocketAddress"%>
<%@include file="/page/maint/common/initNoCache.jsp"%>

<%
    String operation = Util.null2String(request.getParameter("operation"));  //systemset为后台检测(群发邮箱设置); add为账号添加;update为账号编辑
    String accountMailAddress = Util.null2String(request.getParameter("accountMailAddress"));
    String accountId = Util.null2String(request.getParameter("accountId"));
    String accountPassword = Util.null2String(request.getParameter("accountPassword"));
    int serverType = Util.getIntValue(request.getParameter("serverType"));
    String popServer = Util.null2String(request.getParameter("popServer"));
    int popServerPort = Util.getIntValue(request.getParameter("popServerPort"));
    String smtpServer = Util.null2String(request.getParameter("smtpServer"));
    int smtpServerPort = Util.getIntValue(request.getParameter("smtpServerPort"));
    String needCheck = Util.null2String(request.getParameter("needCheck"));
    String getneedSSL = Util.null2String(request.getParameter("getneedSSL"));
    String sendneedSSL = Util.null2String(request.getParameter("sendneedSSL"));
    boolean isStartTls = "1".equals(Util.null2String(request.getParameter("isStartTls")));  //如果服务器支持,就是用starttls加密传输
    //System.out.println("isStartTls=" + isStartTls);

    String info = this.checkMailInfo(operation, accountMailAddress, accountId, accountPassword, serverType, popServer, popServerPort, smtpServer, smtpServerPort, needCheck, getneedSSL, sendneedSSL, isStartTls, user);
    out.print(info);
%>


<%!
    BaseBean loggerBean = new BaseBean();
    String emailAccountId = "";
    String emailAccountPassword = "";
    MailErrorMessageInfo errormessinfo = null;

    public String checkMailInfo(String operation, String accountMailAddress, String accountId, String accountPassword, 
            int serverType, String popServer, int popServerPort, String smtpServer, int smtpServerPort,
            String needCheck, String getneedSSL, String sendneedSSL, boolean isStartTls, User user) {
        try {
            int popLoginState = 0;//接收服务器登录状态
            int smtpLoginState = 0;//接收服务器登录状态

            Map popState = null;
            Map smtpState = null;
            if (!"systemset".equals(operation)) {
                //step1: 测试是否能够连上接收地址
                try {
                    Socket popSocket = new Socket();  // 注意：socket默认用不超时
                    popSocket.connect(new InetSocketAddress(popServer, popServerPort), 1000 * 60);  // 一分钟的超时判断
                    if (popSocket.isConnected()) {
                        popSocket.close();
                        popState = setCheckMap(true, null);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    MailErrorMessageInfo merinfo = new MailErrorMessageInfo();
                    merinfo.setErrorString("Unable to connect to the mail server " + popServer + ":" + popServerPort + " " + SystemEnv.getHtmlLabelName(82879, user.getLanguage()) + "," + SystemEnv.getHtmlLabelName(83059, user.getLanguage()));
                    merinfo.setErrorHint(SystemEnv.getHtmlLabelName(83060, user.getLanguage()) + ":" + popServer + ":" + popServerPort);
                    popState = setCheckMap(false, merinfo);
                }
            }

            //step3: 测试是否能够连上发送地址
            try {
                Socket smtpSocket = new Socket();  // 注意：socket默认用不超时
                smtpSocket.connect(new InetSocketAddress(smtpServer, smtpServerPort), 1000 * 60);  // 一分钟的超时判断
                if (smtpSocket.isConnected()) {
                    smtpSocket.close();
                    smtpState = setCheckMap(true, null);
                }
            } catch (Exception e) {
                e.printStackTrace();
                MailErrorMessageInfo merinfo = new MailErrorMessageInfo();
                merinfo.setErrorString("Unable to connect to the mail server " + smtpServer + ":" + smtpServerPort + " " + SystemEnv.getHtmlLabelName(82879, user.getLanguage()) + "," + SystemEnv.getHtmlLabelName(83059, user.getLanguage()));
                merinfo.setErrorHint(SystemEnv.getHtmlLabelName(83060, user.getLanguage()) + ":" + smtpServer + ":" + smtpServerPort);
                smtpState = setCheckMap(false, merinfo);
            }

            JSONObject json = new JSONObject();

            json.put("smtpState", smtpState);
            json.put("popState", popState);
            //step2: 测试登录发送账号是否能够登录
            if (!"systemset".equals(operation)) {
                json.put("popLoginState", checkPopLogin(accountId, accountPassword, serverType, popServer, popServerPort, smtpServer, getneedSSL, isStartTls, user));
            }
            //step4: 测试发送服务器登录状态
            json.put("smtpLoginState", checkSmtpLogin(accountMailAddress, accountId, accountPassword, smtpServer, smtpServerPort, needCheck, sendneedSSL, isStartTls));

            loggerBean.writeLog(json.toString());
            return json.toString();
        } catch (Exception e) {
            loggerBean.writeLog(e);
            e.printStackTrace();
        }
        return null;
    }

    /*
        pop/imap接收功能检测
    */
    private Map checkPopLogin(String accountId, String accountPassword, int serverType, String popServer, int popServerPort, String smtpServer, String getneedSSL, boolean isStartTls, User user) {
        String server = "";
        try {
            String protocol = serverType == 1 ? "pop3" : "imap";
            Store store = null;

            Properties props = new Properties();

            // 收件，建立链接和读取邮件超时设置
            props.setProperty("mail." + protocol + ".connectiontimeout", String.valueOf(1000 * 60));  //POP3/IMAP.ConnectTimeout建立连接超时，1分钟
            props.setProperty("mail." + protocol + ".timeout", String.valueOf(1000 * 60 * 30));  //POP3/IMAP.ReadTimeout 读取超时30分钟

            // 是否启用了starttls加密方式
            /*  邮件收取不需要此支持
            if (isStartTls) {
                props.put("mail." + protocol + ".starttls.enable", "true");
                props.put("mail." + protocol + ".ssl.checkserveridentity", "false");
                props.put("mail." + protocol + ".ssl.trust", popServer);
            }
            */

            if ("1".equals(getneedSSL)) {
                Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
                
                props.setProperty("mail." + protocol + ".socketFactory.class", "javax.net.ssl.SSLSocketFactory");
                props.setProperty("mail." + protocol + ".socketFactory.fallback", "false");
                props.setProperty("mail." + protocol + ".port", String.valueOf(popServerPort));
                props.setProperty("mail." + protocol + ".socketFactory.port", String.valueOf(popServerPort));

                Session popSession = Session.getInstance(props, null);

                //System.out.println(protocol + " ssl -----------------------------------------------------------------");
                //popSession.setDebug(true);

                URLName urln = new URLName(protocol, popServer, popServerPort, null, accountId, accountPassword);
                store = popSession.getStore(urln);
                server = popServer;
                store.connect();
            } else {
                props.put("mail.smtp.smtphost", smtpServer);
                props.put("mail.transport.protocol", "smtp");
                props.put("mail." + protocol + ".port", String.valueOf(popServerPort));
                server = smtpServer;
                Session popSession = Session.getInstance(props, null);

                //System.out.println(protocol + " no ssl -----------------------------------------------------------------");
                //popSession.setDebug(true);

                store = popSession.getStore(protocol);
                store.connect(popServer, accountId, accountPassword);
            }

            if (store.isConnected()) {
                try {
                    store.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return setCheckMap(true, null);
            }
        } catch (Exception e) {
            loggerBean.writeLog(e);
            e.printStackTrace();
            return setCheckMap(false, new MailErrorFormat(e).getMailErrorMessageInfo());
        }
        MailErrorMessageInfo merinfo = new MailErrorMessageInfo();
        merinfo.setErrorString("Unable to connect to the mail server: " + SystemEnv.getHtmlLabelName(82879, user.getLanguage()));
        merinfo.setErrorHint(SystemEnv.getHtmlLabelName(83060, user.getLanguage()) + ":" + server);
        return setCheckMap(false, merinfo);
    }

    /*
        smtp 发送邮件功能检测
    */
    private Map checkSmtpLogin(String accountMailAddress, String accountId, String accountPassword, String smtpServer, int smtpServerPort, String needCheck, String sendneedSSL, boolean isStartTls) {
        try {
            this.emailAccountId = accountId;
            this.emailAccountPassword = accountPassword;

            Session smtpSession = null;

            Properties props = new Properties();

            // 发送邮件建立连接和发送超时设置
            props.setProperty("mail.smtp.connectiontimeout", String.valueOf(1000 * 60)); //ConnectTimeout建立连接超时，1分钟
            props.setProperty("mail.smtp.timeout", String.valueOf(1000 * 60 * 30)); //ReadTimeout 读取超时30分钟

            props.setProperty("mail.smtp.port", String.valueOf(smtpServerPort)); //设置端口信息 
            props.put("mail.smtp.host", smtpServer);
            props.put("mail.transport.protocol", "smtp");
            props.put("mail.smtp.from", accountMailAddress);
            props.put("mail.from", accountMailAddress);

            Authenticator auth = null;

            // 是否需要发件认证
            if ("1".equals(needCheck)) {
                props.put("mail.smtp.auth", "true");
                auth = new Email_Autherticator(accountId, accountPassword);
            }
            
            // SSL链接还是普通链接方式
            if ("1".equals(sendneedSSL)) {
                Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
                
                props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
                props.setProperty("mail.smtp.socketFactory.fallback", "false");
                props.setProperty("mail.smtp.socketFactory.port", String.valueOf(smtpServerPort));
                props.put("mail.smtp.auth", "true");

                smtpSession = Session.getInstance(props, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(emailAccountId, emailAccountPassword);
                    }
                });

                //System.out.println("smtp ssl -----------------------------------------------------------------");
                //smtpSession.setDebug(true);

            } else {
                // 是否启用了starttls方式
                if (isStartTls) {
                    props.put("mail.smtp.starttls.enable", "true");
                    props.put("mail.smtp.ssl.checkserveridentity", "false");
                    props.put("mail.smtp.ssl.trust", smtpServer);
                    
                    props.setProperty("mail.smtp.socketFactory.fallback", "false");
                    props.setProperty("mail.smtp.socketFactory.port", String.valueOf(smtpServerPort));
                    
                    smtpSession = Session.getInstance(props, new Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(emailAccountId, emailAccountPassword);
                        }
                    });
                    
                    //System.out.println("smtp starttls -----------------------------------------------------------------");
                    //smtpSession.setDebug(true);
                } else {
                    smtpSession = Session.getInstance(props, auth);
                    
                    //System.out.println("smtp no ssl -----------------------------------------------------------------");
                    //smtpSession.setDebug(true);
                }
            }

            // 自己给自己发送测试邮件
            MimeMessage msg = new MimeMessage(smtpSession);
            msg.setFrom(new InternetAddress(accountMailAddress));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(accountMailAddress, true));
            msg.setSubject("OA 测试消息");
            msg.setSentDate(new Date());
            msg.setText("在测试您的 SMTP 设置时， OA 会自动发送该电子邮件。");
            msg.setHeader("X-Mailer", "weaver");
            msg.setHeader("X-Priority", "3"); //邮件为普通邮件
            Transport.send(msg);
            
        } catch (Exception e) {
            loggerBean.writeLog(e);
            e.printStackTrace();
            //errormessinfo = new MailErrorFormat(e).getMailErrorMessageInfo();
            return setCheckMap(false, new MailErrorFormat(e).getMailErrorMessageInfo());
        }
        return setCheckMap(true, null);
    }

    private Map setCheckMap(boolean b, MailErrorMessageInfo errinfo) {
        Map checkMap = new HashMap();
        if (b) {
            checkMap.put("state", "1");
        } else {
            checkMap.put("state", "0");
        }
        checkMap.put("ischeck", b);
        checkMap.put("errormess", errinfo);
        return checkMap;
    }%>


