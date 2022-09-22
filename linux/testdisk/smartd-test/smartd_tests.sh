#!/bin/bash

# smartd_tests.sh - устанавливает smartmontools, настраивает и проверяет правильность настроек
# v. 0.90 от 11.03.2020


echo "apt-get install smartmontools"
echo
apt-get install smartmontools -y


# Заливаем конфиги в папку /etc/
# Описание конфигов:
# smartd.conf.proverka – конфиг для проверки, чтобы на почту пришло письмо
# smartd.conf.rabochii_config – рабочий конфиг. Идентичный проверочному, но без тестовых строк
echo
echo
echo
cp /etc/smartd.conf.proverka /etc/smartd.conf

echo "Тестируем конфиг для проверки, на alerts@ztime.ru должно прийти тестовое письмо(а)"
echo
echo "smartd -c /etc/smartd.conf -q onecheck"
smartd -c /etc/smartd.conf -q onecheck
echo
service smartd restart


# Тестовые письма пришли? Если да, то все настроено верно. 
# На ВМ smartmontools не работает

# Меняем на рабочий конфиг
echo
echo
echo
cp /etc/smartd.conf.rabochii_config /etc/smartd.conf

echo "Тестируем рабочий конфиг"
echo
echo "smartd -c /etc/smartd.conf -q onecheck"
smartd -c /etc/smartd.conf -q onecheck
echo
service smartd restart


echo
echo
echo
echo "Тестовые письма на alerts@ztime.ru пришли? Если да, то все настроено верно!"
echo "На ВМ smartmontools не работает, письма не придут"
echo
echo
echo


# Настройка завершена!