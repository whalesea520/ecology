package com.shxiv.mail;

import com.weaver.general.BaseBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.RequestInfo;
import weaver.workflow.workflow.WorkflowComInfo;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import java.util.Properties;


/**
 * Created by zsd on 2019/3/4.
 */
public class FkMailbox extends BaseBean implements Action {

    private Log log = LogFactory.getLog(FkMailbox.class.getName());

    private static String mailFrom = "xiangxu.xiao@chinabrandsgroup.com.cn";// 指明邮件的发件人
    private static String password_mailFrom = "Hello1234";// 指明邮件的发件人密码
    private static String mailTo = null;	// 指明邮件的收件人
    private static String mailTittle = "付款签订流程";// 邮件的标题
    private static String mailText ="付款签订流程成功！";	// 邮件的文本内容
    private static String mail_host ="smtp.mxhichina.com";	// 邮件的服务器域名

    @Override
    public String execute(RequestInfo request) {
        /***interface action  start*****/
        this.log.error("######################   付款邮件发送Action     ###########################");
        RecordSet rss = new RecordSet();
        RecordSet rss1 = new RecordSet();
        String tempMessage = "";
        try {
            WorkflowComInfo workflowComInfo = new WorkflowComInfo();
            int requestid = Util.getIntValue(request.getRequestid());//创建一个流程就生成唯一标识的请求ID
            int workflowid = Util.getIntValue(request.getWorkflowid());//流程ID
            int formid = Util.getIntValue(workflowComInfo.getFormId("" + workflowid));//表单ID

            //主表表名
            String mainTable = "formtable_main_" + ((-1) * formid);//获取到当前流程表单的主表表名

            String 	bsqqgs="";//被授权商

            //通过流程生成唯一标识的请求ID获取到该流程对应的主表被授权商
            String sqlMa="select bsqqgs from  "+mainTable+" where requestId='"+requestid+"'  ";
            rss.execute(sqlMa);
            if(rss.next()){
                bsqqgs=rss.getString("bsqqgs");
            }

            String sqlMb="select yx from uf_lxrxx  where sqs='"+bsqqgs+"' ";
            rss1.execute(sqlMb);
            if(rss1.next()){
                mailTo=rss1.getString("yx");// 指明邮件的收件人
            }

            if(mailTo.equals("无") || mailTo!=null || mailTo!=""){
                Properties prop = new Properties();
                prop.setProperty("mail.host", mail_host);
                prop.setProperty("mail.transport.protocol", "smtp");
                prop.put("mail.smtp.port", 465);// 端口号
                prop.setProperty("mail.smtp.auth", "true");
                prop.put("mail.smtp.ssl.enable", "true");//设置是否使用ssl安全连接 ---一般都使用
                prop.put("mail.debug", "true");//设置是否显示debug信息 true 会在控制台显示相关信息

                CreateSimpleMail CreateSimpleMail =new CreateSimpleMail();

                // 1、创建session
                Session session = Session.getInstance(prop);
                // 开启Session的debug模式，这样就可以查看到程序发送Email的运行状态
                session.setDebug(true);
                // 2、通过session得到transport对象
                Transport ts = session.getTransport();
                // 3、使用邮箱的用户名和密码连上邮件服务器，发送邮件时，发件人需要提交邮箱的用户名和密码给smtp服务器，用户名和密码都通过验证之后才能够正常发送邮件给收件人。
                ts.connect(mail_host,mailFrom, password_mailFrom);
                // 4、创建邮件
                Message message = CreateSimpleMail.simpleMail(session,mailFrom,mailTo,mailTittle,mailText);
                // 5、发送邮件
                ts.sendMessage(message, message.getAllRecipients());
                ts.close();
            }

        } catch (Exception e) {
            tempMessage = ""+e;
            this.log.error("发送邮件失败:"+tempMessage);
            return "1";
        }

        this.log.error("######################付款调用邮箱Action end################################################");
        return "1";
    }

}

