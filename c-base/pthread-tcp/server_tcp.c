
#include"server.h"

/*********服务器********/

/************主函数*********/


int main(void)
{	
	
	
	char buf[]="hello";
	int fd,newfd;
	
	//创建套接字
	if((fd=socket(AF_INET, SOCK_STREAM, 0))<0)
		sys_err("socket failed");
	int on=1;
	setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on));

	//绑定
	struct sockaddr_in ser;
	ser.sin_family=AF_INET;
	ser.sin_port=htons(6666);
	ser.sin_addr.s_addr = inet_addr(IP);
	if(bind(fd, (struct sockaddr *)&ser,sizeof(ser))<0)
		sys_err("bind failed!\n");

	//监听
	listen(fd, 5);

	//接收
	struct sockaddr_in cli;
	socklen_t peerlen;
	peerlen=sizeof(cli);

	
	//创建 写功能 创建线程
	int ret2;
	pthread_t pth_id;
	ret2=pthread_create(&pth_id,NULL,functions,(void *)&newfd);/*参数随便给*/
	if(ret2!=0)
	{
		printf("pthread_creat failed!\n");
		exit(1);
	}

	
	printf("服务器上线-------->\n");
	while(1)	
	{
		newfd=accept(fd, (struct sockaddr *)&cli, &peerlen);//接收
		if(newfd<0)
		sys_err("accept");


		int ret3;
		pthread_t pth_id1;
		
		//创建 听功能 创建线程
		ret3=pthread_create(&pth_id1,NULL,functions1,(void *)&newfd);
		if(ret3!=0)
		{
			printf("pthread_creat failed!\n");
			exit(1);
		}
	}
	
	close(fd);
	exit(0);
}




//**********线程函数*****读功能*********************
void *functions1 (void *argc)
{
	
	int newfd=*((int *)argc);
	int ret;
	
	char buf[128];
	bzero(buf,128);

	printf("newfd=%d\n",newfd);
	
	while(1)
	{
		bzero(buf,128);
		ret=read(newfd, buf,128);
		if(ret<0)	
			sys_err("read  failed!\n");
		else if(ret==0)
		{
			printf("newfd=%d exit\n",newfd);
			
		}
		else 
		{
			printf("from newfd=%d, message:%s\n",newfd,buf);
    	}
	}
	
	close(newfd);
}


void *functions (void *argc)
{
	
	char buf[100];
	bzero(buf, 100);
	while(1)
	{
		printf("输入");
		scanf("%s",buf);
		write(*((int *)argc),buf,sizeof(buf));
		bzero(buf, 100);
	}
}









