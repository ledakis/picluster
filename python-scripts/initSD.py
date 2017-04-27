import subprocess, shlex
import sys
import os, pwd

def run(cmd=None):
	if cmd is None:
		sys.exit('wrong/no command given to run')
	answer=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
	out,err=answer.communicate()
	out2=out.decode('ascii').strip()
	if len(out2)>0:
		out2=out2.split("\n")
	else:
		pass
	if err:
		sys.exit('error running command: '+err)
	return out2,answer.returncode

def unmount(drive):
	cmd=None
	if 'linux' in sys.platform:
		cmd='sudo umount /dev/%s*' % drive
	elif 'darwin' in sys.platform:
		# TODO: have not tested this without sudo?
		cmd='diskutil unmount /dev/%s' % drive
	return run(cmd)[0]

def mount(drive,folder=None):
	if folder is None:
		folder="/media/%s/raspimount" % pwd.getpwuid(os.getuid()).pw_name
	cmd=None
	mounted=[]
	if 'linux' in sys.platform:
		for i in range(3):
			try:
				cmd='sudo mkdir %s%s'% (folder,i+1)
				run(cmd)
				cmd='sudo mount /dev/%s%s %s%s' % (drive,i+1,folder,i+1)
				result={'returncode':1}
				result['result'],result['returncode']=run(cmd)
				if result['returncode'] == 0:
					mounted.append(folder+str(i+1))
			except:
				pass
	elif 'darwin' in sys.platform:
		for i in range(3):
			try:
				# TODO: need to add the mounted list here as well.
				cmd='diskutil mount /dev/%ss%s' % (drive,i+1)
				run(cmd)
			except:
				pass
	if len(mounted)<1:
		sys.exit('could not mount')
	else:
		return mounted

drivescmd="ls -al /dev/disk/by-path/*usb*"
findcmd="find -P ~ ! -path '*Trash*' -and -name '*raspbian*.img'"

print()
msg={
	'main':'The list of usb mounted drives follows, please pick the one NOT ending in ',
	'linux':'a number such as sdb1, but instead the one without it e.g: sdb',
	'darwin':'s1/s2 and so on, but instead the one without it, e.g: disk2',
	'main2': '\nIf you make a wrong choice the sd card will not work.'
	}
if not sys.platform in msg.keys():
	sys.exit('platform not supported yet')

safeoptions=list()
for line in run(drivescmd)[0]:
	drive=line.split("/")[-1]
	safeoptions.append(drive)
	print("/dev/"+drive)

if len(safeoptions)<1:
	sys.exit('Error finding a suitable device to write on')

print(msg['main']+msg[sys.platform]+msg['main2'])

print('enter here:')
input1=input("/dev/")
if input1 not in safeoptions:
	sys.exit('choice not in the list, will exit')

# unmount the drive's partitions


# will prepare for dd now
msg="Select the img file you want to write to "+"/dev/"+input1
print(msg)
print()

choices={}
for number,line in enumerate(run(findcmd)[0],start=1):
	choices[number]=line
	print(str(number)+" | "+line)
input2=input("enter the correct number: ")
# print(choices.keys())
try:
	input2=int(input2)
	if input2 not in choices.keys():
		sys.exit('choice not in the list, will exit')
except:
	sys.exit('input was not a number, will exit')

ddcmd='sudo dd if=%s bs=4M of=%s' % (choices[input2],'/dev/'+input1)
print()
print('will run this:')
print(ddcmd)
agreed=input("do you agree? Check the command again and make sure it is correct!\n Proceed? y/N: ")

if agreed =='y':
	print('You might get asked your sudo password:')
	print('The dd command will take a few minutes to finish depending on the size of the image and the SD card speed. You will get a confirmation when finished.')
	print('Unmounting /dev/%s'%input1)
	unmount(input1)
	print()
	run(ddcmd)
	print()
	print('finished')
	print('now reloading the partition table')
	print()
	cmd='sudo blockdev --rereadpt /dev/%s' % input1
	run(cmd)
	print('finished reload, moving on to mount')
	print()
elif agreed=='skip':
	pass
else:
	print('Aborted by user')
	sys.exit(0)


msg='Will now mount the sd card to write the specific scripts'
mounted=[]
mounted=mount(input1)

print('mounted partitions:')
for m in mounted:
	print(m)
