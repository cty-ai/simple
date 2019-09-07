#include"chufang.h"
	
int main(void)
{
	
	int fd,na;
	//创建套接字
	if((fd=socket(AF_INET, SOCK_STREAM, 0))<0)
		sys_err("socket failed");

	struct sockaddr_in ser;
	ser.sin_family=AF_INET;
	ser.sin_port=htons(6666);
	ser.sin_addr.s_addr = inet_addr(IP);


	//连接
	 na=connect(fd,(struct sockaddr *)&ser,sizeof(ser));
	if(na<0)
		sys_err("connect");
	if(na==0)
		printf("connect ok!\n");
	
	int ret2;
	pthread_t pth_id;
	
	/*写线程    给服务器发数据*/
	ret2=pthread_create(&pth_id,NULL,functions,(void *)&fd);
	if(ret2!=0)
	{
		printf("pthread_creat failed!\n");
		exit(1);
	}

	char buf[1024];
	int ret;
	while(1)
	{
		//读
		bzero(buf,1024);
		ret=read(fd, buf,1024);
		if(ret<0)	
		sys_err("recv");
		else if(ret==0)
		{
			printf("server exit\n")	;
			exit(1);
		}
		else
		{
			printf("from server : %s\n",buf);

		}
	
	}
			
	close(fd);
	return 0;
}

void sys_err(char *argc)
{
	fprintf(stderr,"%s\n",argc);	
	perror("argc");
	exit(1);
}


//写进程     发数据给服务器
void *functions (void *argc)
{
	int fd=*((int *)argc);
	char buf[100];
	bzero(buf,100);
	while(1)
	{
		printf("输入");
		scanf("%s",buf);
		write(fd,buf,sizeof(buf));
		bzero(buf, 100);
	}
}

