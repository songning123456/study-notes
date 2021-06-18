#### nmon16m_helpsystems

1. mkdir nmon

2. tar -zxvf nmon16m_helpsystems.tar.gz -C nmon
	-C: 指定安装目录

3. cat /etc/redhat-release // 查看版本

4. chmod -R 755 nmon/	// 授权

5. ./nmon_x86_64_rhel7 -f -s 5 -c 80
	-f: 生成文件 => 文件名 = 主机名 + 当前时间.nmon
	-s: 每隔多少秒采集一次数据
	-c: 采集多少次数据
	e.g: 每隔5s采集一次数据，一共采集12次，就是1min的数据。
	

#### nmon_analyser_v66

1. Excel无法运行宏
  开启宏设置，避免使用WPS，有可能缺少VB库。