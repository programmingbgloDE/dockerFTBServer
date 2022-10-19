if [ -f "/modserver/start.sh" ]
	then
		cd /modserver/
		bash start.sh
	else
		/tools/serverinstall $PACKID $VERID --path /modserver/ --threads $THREADS --auto
		echo "#!/bin/bash 
		if ! grep -q \"eula=true\" eula.txt; then
			echo \"eula=true\" > eula.txt
			echo
		fi
		echo $MAXRAM
		java -javaagent:log4jfix/Log4jPatcher-1.0.0.jar -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Xmx$MAXRAM -Xms1024M -jar \$JARFILE" > /modserver/start.sh
		chmod +x /modserver/start.sh
fi
