import sys
import os
import time
import platform
import psutil

mem = psutil.virtual_memory()
pcname = platform.node()

def measure_gpu_temp():
	temp = os.popen("vcgencmd measure_temp").readline()
	return (temp.replace("temp=", "").replace('\n', ''))

def measure_cpu_temp():
	with open('/sys/class/thermal/thermal_zone0/temp', 'r') as tempfile:
		temp=tempfile.read().replace('\n', '')
	return str(int(temp)/1000)

def get_memory():
	used = (mem.used / 1024) / 1024
	total = (mem.total / 1024) / 1024
	return str(used) + "M/" + str(total) + "M"


while True:
	sys.stdout.write("\r" + pcname  + " @ CPU=" + str(psutil.cpu_percent()) +"% MEM=" + get_memory() + " | CPU=" + measure_cpu_temp() + "'C GPU=" + measure_gpu_temp())
	sys.stdout.flush()
	time.sleep(1)
