conf="~/Documents/conf"
echo "backup:"
read backup
cp $backup $conf/config.json -a -r -v

