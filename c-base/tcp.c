#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/types.h>    
#include <sys/socket.h>  
#include <stdio.h>       
#include <stdlib.h>        
#include <poll.h>
#include <string.h>        
#include <pthread.h>


int connet_cloud(void)
{
	int client_socket;
	struct sockaddr_in client_addr;

	client_socket = socket(AF_INET,SOCK_STREAM,0);
	if(client_socket < 0)
	{
		printf("Create Socket Failed!\n");
		return -1;
	}

	bzero(&client_addr,sizeof(client_addr));
	client_addr.sin_family = AF_INET; 
	client_addr.sin_addr.s_addr = htons(INADDR_ANY);
	client_addr.sin_port = htons(0);
	if(bind(client_socket,(struct sockaddr*)&client_addr,sizeof(client_addr)))
	{
		printf("Client Bind Port Failed!\n");
		close(client_socket);
		return -1;
	}

	struct sockaddr_in server_addr;
	bzero(&server_addr,sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	if(inet_aton("127.0.0.1", &server_addr.sin_addr) == 0)/* local PC */
	{
		printf("Server IP Address Error!\n");
		close(client_socket);
		return -1;
	}
	server_addr.sin_port = htons(REAL_TIME_DATA_PORT);/* port the daemon listenning at*/
	socklen_t server_addr_length = sizeof(server_addr);

	if(connect(client_socket,(struct sockaddr*)&server_addr, server_addr_length) < 0){
		printf("Can Not Connect To server!\n");
		close(client_socket);
		return -1;
	}else{
		printf("connected to server OK\n");
	}
	return client_socket;
}