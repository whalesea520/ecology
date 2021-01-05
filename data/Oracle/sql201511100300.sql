update SystemRights set detachable=1 where  id=(select rightid from SystemRightDetail where rightdetail='Car:Maintenance')
/