#### kill.sh

```
#!/bin/sh

echo "~~~start~~~"

# 使用默认的对象
kobj=xxx

if [ $# -ne 0 ]; then
  kobj="$1"
  echo "current kobj: $kobj"
else
  echo "use default kobj: $kobj"
fi

pids=`ps -ef | grep -v "grep" | grep $kobj | awk '{print $2}'`
for pid in $pids
do
 echo "kill pid $pid ......";
 kill -9 $pid;
 rlt=$?;
 if [ $rlt -eq 0 ]; then
    echo "stop success pid $pid ......";
 else
    echo "stop failed";
 fi
done

echo "~~~end~~~"

sleep 1
```


#### start.sh

```
nohup ./alertmanager >out.log 2>&1 &
```


#### stop.sh

```
PID=$(ps -ef |grep alertmanager |grep -v grep |awk '{print $2}')
if [ -z "$PID" ]
then
        echo "alertmanager is already stopped"
else
        echo kill $PID
        kill $PID
fi
```