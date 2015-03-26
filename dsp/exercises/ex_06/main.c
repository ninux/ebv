#include "template.h"
#include <string.h>
#include <sched.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>

/*! @brief This stores all variables needed by the algorithm. */
struct TEMPLATE data;


/*********************************************************************//*!
 * @brief Initialize everything so the application is fully operable
 * after a call to this function.
 * 
 * @return SUCCESS or an appropriate error code.
 *//*********************************************************************/
OscFunction(static Init, const int argc, const char * argv[])

	memset(&data, 0, sizeof(struct TEMPLATE));
	
	/******* Create the framework **********/	
	OscCall( OscCreate, 
		&OscModule_cam, 
		&OscModule_bmp, 
		&OscModule_gpio
		);   
	
	/* Set the camera registers to sane default values. */
	OscCall( OscCamPresetRegs);
	OscCall( OscCamSetupPerspective, OSC_CAM_PERSPECTIVE_DEFAULT);

	/* Set up one frame buffer for maximum image size. Cached memory. */
	OscCall( OscCamSetFrameBuffer, 0, OSC_CAM_MAX_IMAGE_WIDTH*OSC_CAM_MAX_IMAGE_HEIGHT, data.u8FrameBuffer, TRUE);
	
	/* Set correct picture size */
	data.pictureRaw.width = OSC_CAM_MAX_IMAGE_WIDTH;
	data.pictureRaw.height = OSC_CAM_MAX_IMAGE_HEIGHT;
	data.pictureRaw.type = OSC_PICTURE_GREYSCALE;
	
OscFunctionEnd()



OscFunction(mainFunction, const int argc, const char * argv[])

	uint8 *pCurRawImg = NULL;
	OSC_ERR err;
	int Count = 7;
	char FileName[50];
	
	/* Initialize system */
	OscCall( Init, argc, argv);
	
	/* Image acquisation loop for Count steps (till 0)*/
	while( Count--)
	{		
		OscCall( OscCamSetupCapture, 0);	
		OscCall( OscGpioTriggerImage);
		
		/* loop until image was grabbed successfully */
		while( true)
		{
			err = OscCamReadPicture( 0, &pCurRawImg, 0, CAMERA_TIMEOUT);

			if(err == SUCCESS)
			{ 
				break;
			}

		}
		/* Construct Filename and save image (last image makes problems :-( */
		data.pictureRaw.data = pCurRawImg;
		if(Count) 
		{
			sprintf(FileName,"/home/httpd/out%02d.bmp", Count);
			OscCall( OscBmpWrite, &data.pictureRaw, FileName);
		}
		printf("%d\n", Count);
	}	
	return 0;

OscFunctionEnd()




/*********************************************************************//*!
 * @brief Program entry
 *
 * @param argc Command line argument count.
 * @param argv Command line argument strings.
 * @return 0 on success
*//*********************************************************************/
int main(const int argc, const char * argv[]) {
 	if (mainFunction(argc, argv) == SUCCESS)
 		return 0;
	else 
		return 1;
}
