#ifndef _SERVER_H_
#define _SERVER_H_

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>
#include<strings.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<netinet/ip.h>
#include<arpa/inet.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include<pthread.h>
#include"sqlite3.h"
#include </usr/local/include/json/json.h>
#include <stddef.h>


#define IP "192.168.7.23"


char *errmsg;//错误信息

void sys_err(char *argc)
{
	fprintf(stderr,"%s\n",argc);	
	perror("argc");
	exit(1);
}



//**********线程函数*****写功能*********************
void *functions (void *argc);
//**********线程函数*****读功能*********************
void *functions1 (void *argc);



#endif

