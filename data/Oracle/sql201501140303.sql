UPDATE HrmResource set usbstate = NULL
/
update HrmResource set usbstate = passwordstate where (userUsbType in ('4') or needdynapass = 1)
/
update HrmResource set usbstate = 0 where needusb = 1 AND usbstate is null
/
update HrmResource set usbstate = 1 where usbstate is null
/