#include "stdafx.h"
#include "LRDManager.h"
#include "SingleTest.h"
#include "afxdialogex.h"
#include "LRDApi.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <io.h>
#include <time.h>
#include <windows.h>
#include "ListUSB.h"
#define EINVAL 22 /* Invalid argument */
#define ESRCH   3 /* No such process */
#define USB_TEST_FILE_NAME		"test"

void SingleTest::RegMessage()
{
	static const GUID GUID_DEVINTERFACE_LIST[] = {
		// GUID_DEVINTERFACE_USB_DEVICE
		{ 0xA5DCBF10, 0x6530, 0x11D2, 0x90, 0x1F, 0x00, 0xC0, 0x4F, 0xB9, 0x51, 0xED },
		// GUID_DEVINTERFACE_USB_HUB
		//{ 0xf18a0e88, 0xc30c, 0x11d0, 0x88, 0x15, 0x00, 0xa0, 0xc9, 0x06, 0xbe, 0xd8 },
		// GUID_DEVINTERFACE_DISK
		//{ 0x53f56307, 0xb6bf, 0x11d0, { 0x94, 0xf2, 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b } },
		//    // GUID_DEVINTERFACE_HID,
		//    { 0x4D1E55B2, 0xF16F, 0x11CF, { 0x88, 0xCB, 0x00, 0x11, 0x11, 0x00, 0x00, 0x30 } },
		//    // GUID_NDIS_LAN_CLASS
		//    { 0xad498944, 0x762f, 0x11d0, { 0x8d, 0xcb, 0x00, 0xc0, 0x4f, 0xc3, 0x35, 0x8c } },
		//    // GUID_DEVINTERFACE_COMPORT
		//    { 0x86e0d1e0, 0x8089, 0x11d0, { 0x9c, 0xe4, 0x08, 0x00, 0x3e, 0x30, 0x1f, 0x73 } },
		//    // GUID_DEVINTERFACE_SERENUM_BUS_ENUMERATOR
		//    { 0x4D36E978, 0xE325, 0x11CE, { 0xBF, 0xC1, 0x08, 0x00, 0x2B, 0xE1, 0x03, 0x18 } },
		//    // GUID_DEVINTERFACE_PARALLEL
		//    { 0x97F76EF0, 0xF883, 0x11D0, { 0xAF, 0x1F, 0x00, 0x00, 0xF8, 0x00, 0x84, 0x5C } },
		//    // GUID_DEVINTERFACE_PARCLASS//    { 0x811FC6A5, 0xF728, 0x11D0, { 0xA5, 0x37, 0x00, 0x00, 0xF8, 0x75, 0x3E, 0xD1 } },
	};
	HDEVNOTIFY hDevNotify;
	DEV_BROADCAST_DEVICEINTERFACE NotificationFilter;
	ZeroMemory(&NotificationFilter, sizeof(NotificationFilter));
	NotificationFilter.dbcc_size = sizeof(DEV_BROADCAST_DEVICEINTERFACE);
	NotificationFilter.dbcc_devicetype = DBT_DEVTYP_DEVICEINTERFACE;
	for (int i = 0; i<sizeof(GUID_DEVINTERFACE_LIST) / sizeof(GUID); i++) {
		NotificationFilter.dbcc_classguid = GUID_DEVINTERFACE_LIST[i];
		hDevNotify = RegisterDeviceNotification(this->GetSafeHwnd(), &NotificationFilter, DEVICE_NOTIFY_WINDOW_HANDLE);
		if (!hDevNotify) {
			AfxMessageBox(CString("注册USB设备通知失败") + _com_error(GetLastError()).ErrorMessage(), MB_ICONEXCLAMATION);
			return;
		}
	}
}

char SingleTest::FirstDriveFromMask(ULONG unitmask)
{
	char i;

	for (i = 0; i < 26; ++i)
	{
		if (unitmask & 0x1)
			break;
		unitmask = unitmask >> 1;
	}
	return (i + 'A');
}

BOOL SingleTest::OnDeviceChange(UINT nEventType, DWORD dwData)
{
	CString msg;
	CStringArray devPath;
	char *lpTmp = 0;
	PDEV_BROADCAST_HDR lpdb = (PDEV_BROADCAST_HDR)dwData;	
	switch (nEventType)      	{
	case DBT_DEVICEARRIVAL:  
		printf("新设备挂载\n");
		EnumUSBDevice(devPath);
		isNewUSB = true;
		/*
		if (lpdb->dbch_devicetype == DBT_DEVTYP_VOLUME)		
		{
			PDEV_BROADCAST_VOLUME lpdbv = (PDEV_BROADCAST_VOLUME)lpdb;
			if (lpdbv->dbcv_flags == 0)
			{
				PDEV_BROADCAST_VOLUME lpdbv = (PDEV_BROADCAST_VOLUME)lpdb;
				USBArray[USBIndex-1] = FirstDriveFromMask(lpdbv->dbcv_unitmask);//得到u盘盘符	
				
				msg.Format("盘符：%c\n", USBArray[USBIndex - 1]);
				TRACE(traceAppMsg, 0, msg);
			}
			
		}else {	//USB父设备
			//GetTime(time);
			//printf("%s [%3d] USB 插入\n", time, USBTestIndex+1);
			USBCounter++;
			//SetEvent(USBPlugEvent);
			//WaitForSingleObject(USBAddEvent, 10000);
			PDEV_BROADCAST_DEVICEINTERFACE pDevInf = (PDEV_BROADCAST_DEVICEINTERFACE)lpdb;
			CString devicePath = pDevInf->dbcc_name;
			
			if (0 < devicePath.Find("USBSTOR")){
				GetTime(time);
				printf("index：%d, Path : %s\n", USBTestIndex,devicePath.GetString());
				if (0 > devicePath.Find("NISEC")) {
					USBDevicePathList.SetAt(USBTestIndex, devicePath);
					SetEvent(USBPathEvent);
				}
			}
		}
		break;
		*/
		break;
	case DBT_DEVICEREMOVECOMPLETE:
		/*
		PDEV_BROADCAST_HDR                pDevBcastHdr;
		PDEV_BROADCAST_DEVICEINTERFACE    pDevBcastDevIface;
		
		pDevBcastHdr = (PDEV_BROADCAST_HDR)dwData;
		if (!pDevBcastHdr || pDevBcastHdr->dbch_devicetype != DBT_DEVTYP_DEVICEINTERFACE)
			break;
		pDevBcastDevIface = (PDEV_BROADCAST_DEVICEINTERFACE)dwData;

		// Get Vid Pid value
		lpTmp = strchr(pDevBcastDevIface->dbcc_name, 'Vid_');
		if (lpTmp)
		{
			lpTmp += 4;

			msg.Format("lpTmp: %s\n", lpTmp);
			TRACE(traceAppMsg, 0, msg);
		}
		//sscanf ((const char *)lpTmp, "%x", &wVendorId);
		*/
		break;
	default:      		
		break;      	
	}      	
	return FALSE; 
}
