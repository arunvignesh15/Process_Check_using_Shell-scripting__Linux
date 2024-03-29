#!/bin/bash

read -p "Enter the Process Name : " process_name

ps -eo pid,pcpu,pmem,user,args,etime,cmd --sort=start_time | grep $process_name | grep -v grep > ps_sort.txt

cat ps_sort.txt | awk 'length($10) >=8' | awk '//{print $10,$15, $19}' > ps_sort_date_final.txt

input="ps_sort_date_final.txt"
while IFS= read -r line
do
  #echo "$line"
  t=`echo $line |cut -d : -f1`
  
  #time=`cut -d : -f1 $row` 
  #echo $t
  if [ $t -ge 5 ] 
  then 
	#user=`$line[1]`
	time_process=`echo $line | awk '{print $1}'`
	user=`echo $line | awk '{print $2}'`
	echo "User Name using:" $user
	proceess=`echo $line | awk '{print $3}'`
	#echo $proceess
	name=$(basename "$proceess")
	echo $time_process $user $name >> process.txt
  else
   	echo " Process running less than 5 hours"
   	user=`echo $line | awk '{print $2}'`
   	echo "User Name using:" $user
   	proceess=`echo $line | awk '{print $3}'`
	#echo $proceess
   	name=$(basename "$proceess") >> lessthan5hrprocess.txt
  fi  
done < "$input"

process=`cat process.txt`

if [ -s "$process" ] 
then
	BODY="The following flowcharts are running for more than 5hours.
	$process
	Kindly take required actions
	Thanks"
	TO_ADDRESS="@gmail.com"
	FROM_ADDRESS="@gmail.com"
	SUBJECT="Long Running Process"
	echo ${BODY}| mail -s "$SUBJECT" -r $FROM_ADDRESS $TO_ADDRESS
else
	echo "No Long running Process found."
        
fi
