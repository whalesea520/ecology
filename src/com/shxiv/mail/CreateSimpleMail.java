package com.shxiv.mail;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Created by Administrator on 2020/6/24.
 */
public class CreateSimpleMail {
    /**
     * @Method: createSimpleMail
     * @Description: 创建一封只包含文本的邮件
     */
    public MimeMessage simpleMail(Session session, String mailfrom, String mailTo, String mailTittle,String mailText) throws Exception {
        // 创建邮件对象
        MimeMessage message = new MimeMessage(session);
        // 指明邮件的发件人
        message.setFrom(new InternetAddress(mailfrom));
        // 指明邮件的收件人，现在发件人和收件人是一样的，那就是自己给自己发
        //不能使用string类型的类型，这样只能发送一个收件人
        String[] bccArray = mailTo.split(",");
        InternetAddress[] address = new InternetAddress[bccArray.length];
        for (int i = 0;i<address.length;i++){
            address[i] = new InternetAddress(bccArray[i]);
        }
        message.setRecipients(Message.RecipientType.TO, address);
        // 邮件的标题
        message.setSubject(mailTittle);
        // 邮件的文本内容
        message.setContent(mailText, "text/html;charset=UTF-8");
        // 返回创建好的邮件对象
        return message;
    }
}
