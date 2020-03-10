struct timeval timeout = {2, 0};
	fd_set fds;
	FD_ZERO(&fds);
	while(1){
		FD_SET(0, &fds);
		FD_SET(fd, &fds);
		
		ret = select(fd+1,&fds,NULL,NULL, &timeout);
		if(ret < 0){
			perror("select ");
			break;
		}else if(ret > 0){//有集合响应
			if(FD_ISSET(fd, &fds)){
				read(fd, ret_msg, 10);


				printf("dump result1: nread=%d\n",nread);	
				for(i = 0; i<PWR_BOARD_RET_LEN_V03; i++){
						printf("%02X ",ret_msg[i]);
				}
				printf("\n");
			//close(fd);
				break;
			}
		}else{
			printf("tty read time out");

			break;
		}
	}