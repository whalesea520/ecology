update wsmethodparamvalue set paramvalue='$'+paramvalue+'$' where paramvalue not like '$%$' and paramvalue is not null and paramvalue!='' and paramvalue not like '{?%}'
GO