
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







int init_server_socket()
{
	int fd;
	if((fd = socket(AF_INET,SOCK_STREAM,0)) <0){
		printf("socket failed");
		return -1;
	}
	int on=1;
	setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on));		

	struct sockaddr_in ser;
	bzero(&ser,sizeof(ser));
	ser.sin_family = AF_INET;
	ser.sin_port = htons(PORT);
	ser.sin_addr.s_addr = htonl(INADDR_ANY);
	//ser.sin_addr.s_addr = inet_addr(IP);

	if(bind(fd,(struct sockaddr *)&ser,sizeof(ser)) < 0){
		printf("bind failed");
		close(fd);
		return -2;
	}

	if(listen(fd,5) < 0){
		printf("listen failed");
		close(fd);
		return -3;
	}

	return fd;
}

int main(void)
{	
	int fd;
	char buf[BUFF_SIZE];
	if(0 > (fd = init_server_socket()){
	printf("creat socket failed\n");
		return -1
	}

	int ret,newfd=-1,maxfd=-1;	
	struct sockaddr_in cli;
	int len=sizeof(cli);
	fd_set r_set;//定义一个读集合
	FD_ZERO(&r_set);

	//获取客户端和的数据
	while(1)	
	{
		FD_SET(0,&r_set);//将标准输入加入到读集合中
		FD_SET(fd,&r_set);//将客户端加入到读集合中
		maxfd = fd;				

		if(maxfd < newfd)
		{
			FD_SET(newfd,&r_set);//将接收到的客户端加入读集合
			maxfd = newfd;
		}
		printf("select wait\n");
		ret = select(maxfd+1,&r_set,NULL,NULL,NULL);
		if(ret < 0){
			printf("select failed");
			continue;
		}
		//if(ret == 0)	//超时

		if(ret > 0){//有集合响应
			if(FD_ISSET(0,&r_set)) //监听标准输入
			{
				bzero(buf,BUFF_SIZE);
				read(0,buf,BUFF_SIZE);
				printf("keyboard buf:%s",buf);
			}
			//判断是否有客户端连接
			if(FD_ISSET(fd,&r_set)){
				if((newfd = accept(fd,(struct sockaddr *)&cli,&len))< 0)
					printf("accept failed");
				printf("client ip=%s port=%d\n",inet_ntoa(cli.sin_addr),ntohs(cli.sin_port));
			}
			//再次判断客户端是否发送数据
			if(FD_ISSET(newfd,&r_set))
			{
				bzero(buf,BUFF_SIZE);
				ret = read(newfd,buf,BUFF_SIZE);
				if(ret < 0){
					printf("read failed");
					continue;
				}
				if(ret == 0){
					FD_CLR(newfd,&r_set);
					close(newfd);
					newfd = -1;
				}else{
					printf("client buf:%s",buf);
				}
			}
		}
	}

	close(fd);

	return 0;
}



