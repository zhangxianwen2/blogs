@echo off
:start
echo.
echo	-------------һ������-----------------
echo	0	exit		�˳�
echo	99	all		��������
echo	1	elk		es+logstach+kibana����
echo	2	sourcetree	sourcetree����
echo	3	idea		idea����
echo	4	navicat		navicat���ݿ�
echo	-------------------------------------
set input=
set /p input=���������������ű�:
if /i '%input%'=='0' goto exit
if /i '%input%'=='99' goto all
if /i '%input%'=='1' goto elk
if /i '%input%'=='2' goto sourcetree
if /i '%input%'=='3' goto idea
if /i '%input%'=='4' goto navicat
echo.
:all
start C:\Users\zhangxianwen\AppData\Local\SourceTree\SourceTree.exe
start C:\Program Files\JetBrains\IntelliJ IDEA 2019.1.3\bin\idea64.exe
start C:\Program Files\PremiumSoft\Navicat Premium 12\navicat.exe
cd C:\tools\elk\elasticsearch-7.5.1-master
start bin\elasticsearch.bat
cd C:\tools\elk\kibana-7.5.1-windows-x86_64
start bin\kibana.bat
cd C:\tools\elk\logstash-7.5.1
start bin\logstash -f bin\logstash.config
goto start

:elk
cd C:\tools\elk\elasticsearch-7.5.1-master
start bin\elasticsearch.bat
cd C:\tools\elk\kibana-7.5.1-windows-x86_64
start bin\kibana.bat
cd C:\tools\elk\logstash-7.5.1\bin
start logstash -f logstash.config
goto start

:sourcetree
start C:\Users\zhangxianwen\AppData\Local\SourceTree\SourceTree.exe
goto start

:idea
start C:\Program Files\JetBrains\IntelliJ IDEA 2019.1.3\bin\idea64.exe
goto start

:navicat
start C:\Program Files\PremiumSoft\Navicat Premium 12\navicat.exe
goto start

:exit
exit