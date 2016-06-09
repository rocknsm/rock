# ROCK resolved Issues  
  
  
## Allocating a ``` /data ``` directory
Hopefully you have two drives when you are installing rock on barebones hardware. This is for two reasons:  
1. You allocate a whole drive to /data and get full control of the size of the directory  
1. When you nuke your build to SimpleRock or something crashes (happens) you don’t lose your dataset

### Checking two drives exist     
First make sure you can see another drive 
``` df -h ``` OR ``` fdisk -l ```  
and you should see a ``` /dev/sd_ (something) ```  
if these don’t return any results, try doing sudo before

### Partitioning the drive
The install scripts create a ``` /data ``` so just ``` mv /data /data2 ```
	
Make a new ``` /data ``` directory using ``` mkdir /data```.  The first one has some SELinux shenanigans that would make this harder.
	
``` disk /dev/sd_ ``` “_” is whatever you found when you did either a ```df -h``` or ```fdisk -l```
```n``` for new partition  
```p``` for primary  
```enter```to accept the default  
```enter ```to say yes start here  
```enter ```to end at the default  
```w``` Writes the changes.

You have now allocated the space. But now that directory needs a file system.

### Making the filesystem
Make filesystem xfs and put it on the partition you just allocated
``` mkfs.xfs /dev/sd_# ``` Where # is the partition number you created   
**Note** - If you have used this drive for something before you may need to force it. It will throw an error and tell  you which switch to use. 
	
Next you need the block id
```blkid /dev/sd_#``` 
Copy the whole ```UUDI=“SOME-String-of-garbage”```
	
### Mounting the Drive
fstab is the file that tells linux about your partitions and your storage so it needs to know about this new partition

``` sudo vim /etc/fstab```  and at the end of the file put:
``` UUDI=“SOME-String-of-garbage”	/data	xfs	defaults	0 0```
*Note* - Those are tabs between each section (except for the 0’s thats a space)


now we mount it with ``` mount /data```

### Copying content and security contexts
One thing remains. I you look into your /data2 directory you will see it still has the data that you need in the /data file but you want the security contexts that are set up during the chef install to be copied over.  
Just do ```rsync -av /data2/ /data/``` 

validate that works with ```ls -lZ data```
```/data/snort``` should have a context like:
```unconfined_u:object_r:snort_log_t:s0```

now do a ```rock_start``` and you (should) be good to go.

## Helpful tips to make your life easier
### Symbolic links
#### Rock_<command>
Rather than having to type ```/usr/local/bin/<rock_command>``` every time you want to do something with rock it would behoove you to make a symbolic link. Using:  
```ln -s /usr/local/bin/ /bin``` 
#### Bro Commands
You might want to create a symbolic link between ```/opt/bro/bin``` and your own ```/bin``` directory. Using:  
```ln -s /opt/bro/bin/ /bin``` 



## Changing the collection interface
### Telling bro what interface to collect on
The last issue I had on collection was that I didn’t have a ```eth0``` interface. Therefore bro won’t run for you at all. If you run a rock_start and it doesn’t work, you should first do some bro troubleshooting first.  So that is done with ```broctl status``` and it should give you some information. if you do a ```broctl start``` it might say something like ```bro stopped immediately after starting ``` you probably have an interface issue. 


To change the interface which is an easily fixed issue just change the node config at ```/opt/bro/etc/node.cfg``` to your collection interface.

### Getting the name of the collection interface
If you don’t know how to get the name of your collection interface just do an ```ifconfig``` and it will give you a list of them. If you have two NICs on your machine then you will probably have two interfaces named similarly. And one of them will have an IP address. 

### Putting the interface into promiscuous mode
The collection interface will also need to be put into promiscuous mode 
just do ``ifconfig IF_NAME promisc```

And for validation just do ```netstat -i``` and look at the Flag part. It should have a ```P``` in it if the interface is in promiscuous mode

## Next Steps
After you have installed and run ROCK on you own, if you encountered any other install issues please submit a pull request to update this document to help others **FFIO** as well.

Contributors: zcatbear




 
		