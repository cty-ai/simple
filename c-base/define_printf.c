/************************************************************
Copyright (C), 1988-1999, Tech. Co., Ltd.
FileName:   test.c
Author:
Version :   0.0.1
Date:       2019.12.5
Description: // 模块描述
Version: // 版本信息
Function List: // 主要函数及其功能
1. -------
History: // 历史修改记录
<author> <time> <version > <desc>
David 96/10/12 1.0 build this moudle
***********************************************************/


/*-----------------------------------------------------------------
 *	@brief	Get usb list of speed tests needed.
 *	@param[in]	
 *	@return		list length
 *-----------------------------------------------------------------*/


#if 1
#define NONE "\033[m"
#define YELLOW "\033[1;33m"
#define DEBUG(format,...) \
        printf(YELLOW"[%s]-->%d:"NONE" "format"\n", __func__, __LINE__, ##__VA_ARGS__) //当arg参数为0个，"##"会丢弃前面的逗号
#else
#define	DEBUG(fmt,...)
#endif