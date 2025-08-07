#include "calculate.h"
#include "string.h"
#include "stdio.h"
#include "math.h"
#include "LobotServoController.h"
#include "usart.h"
#include "tim.h"
//硬件参数

#define ARRAY_SIZE 6
typedef struct {
    float x;
    float y;
    float z;
} Vector3f;
typedef struct {
    float Roll;
    float Pitch;
    float Yaw;
} EulerAngles;

float RadiusofBase=11;
float RadiusofPlatform=11;
float ServoArmLength=8;
float RodLength=8;
float AngleBetween=30*PI/180;
float AngleBetweenPlatform=30*PI/180;
float angles[ARRAY_SIZE];
unsigned char rdata[33];
extern int xnum,ynum;
Vector3f Position={0,0,0};
EulerAngles Gyro={0,0,0};
LobotServo Servos[6]={{.ID = 1,.Position = 500},
					 {.ID = 2,.Position = 500},
					 {.ID = 3,.Position = 500},
					 {.ID = 4,.Position = 500},
					 {.ID = 5,.Position = 500},
					 {.ID = 6,.Position = 500}};
void transMatrix(Vector3f Position,float matrix[3][6]){
	for(int i =0;i<6;i++)
	{
		matrix[0][i]=Position.x;
		matrix[1][i]=Position.y;
		matrix[2][i]=Position.z;
	}
}

void rotXMatrix(float angle, float matrix[3][3]) {
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);

    matrix[0][0] = 1;
    matrix[0][1] = 0;
    matrix[0][2] = 0;
    matrix[1][0] = 0;
    matrix[1][1] = cos_angle;
    matrix[1][2] = -sin_angle;
    matrix[2][0] = 0;
    matrix[2][1] = sin_angle;
    matrix[2][2] = cos_angle;
}


void rotYMatrix(float angle, float matrix[3][3]) {
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);

    matrix[0][0] = cos_angle;
    matrix[0][1] = 0;
    matrix[0][2] = sin_angle;
    matrix[1][0] = 0;
    matrix[1][1] = 1;
    matrix[1][2] = 0;
    matrix[2][0] = -sin_angle;
    matrix[2][1] = 0;
    matrix[2][2] = cos_angle;
}

void rotZMatrix(float angle, float matrix[3][3]) {
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);

    matrix[0][0] = cos_angle;
    matrix[0][1] = -sin_angle;
    matrix[0][2] = 0;
    matrix[1][0] = sin_angle;
    matrix[1][1] = cos_angle;
    matrix[1][2] = 0;
    matrix[2][0] = 0;
    matrix[2][1] = 0;
    matrix[2][2] = 1;
}

float* calculate_stewart_platform(
    float r_B,
    float r_P,
    float servo_arm_length,
    float rod_length,
    float alpha_B,
    float alpha_P,
    Vector3f trans,
    EulerAngles orient
) {
    // 定义beta数组，用于存储角度值（弧度制）
    float beta[ARRAY_SIZE] = {
        (float)(PI + PI / 2),
        (float)(PI / 2),
        (float)(2 * PI / 3 + PI + PI / 2),
        (float)(2 * PI / 3 + PI / 2),
        (float)(4 * PI / 3 + PI + PI / 2),
        (float)(4 * PI / 3 + PI / 2)
    };

    // 定义theta_B数组，用于存储角度值（弧度制）
    float theta_B[ARRAY_SIZE];
    theta_B[0] = alpha_B;
    theta_B[1] = alpha_B;
    theta_B[2] = (float)(PI / 3 + alpha_B);
    theta_B[3] = (float)(PI / 3 - alpha_B);
    theta_B[4] = (float)(PI / 3 - alpha_B);
    theta_B[5] = (float)(PI / 3 + alpha_B);

    // 定义theta_P数组，用于存储角度值（弧度制）
    float theta_P[ARRAY_SIZE];
    theta_P[0] = (float)(PI / 3 - alpha_P);
    theta_P[1] = (float)(PI / 3 - alpha_P);
    theta_P[2] = (float)(PI / 3 + alpha_P);
    theta_P[3] = alpha_P;
    theta_P[4] = alpha_P;
    theta_P[5] = (float)(PI / 3 + alpha_P);
    float servo_attach_B[3][ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        
        if (i == 0 || i == 1) 
		{   
			servo_attach_B[0][i] = r_B * cos(theta_B[i]);
        } else 
		{
			servo_attach_B[0][i] = -r_B * cos(theta_B[i]);
        }
		if(i==0||i==4||i==5)
		{
			servo_attach_B[1][i] = -r_B * sin(theta_B[i]);
		}
		else
		{
			servo_attach_B[1][i] = r_B * sin(theta_B[i]);
		}
        servo_attach_B[2][i] = 0;
    }

    float rod_attach_P[3][ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        
		if ( i == 3 || i == 4) 
		{
            rod_attach_P[0][i] = -r_P * cos(theta_P[i]);
        } 
		else 
		{
            rod_attach_P[0][i] = r_P * cos(theta_P[i]);
        }
        if (i == 0 || i == 4 || i == 5) 
		{
            rod_attach_P[1][i] = -r_P * sin(theta_P[i]);
        } 
		else 
		{
            rod_attach_P[1][i] = r_P * sin(theta_P[i]);
        }
        rod_attach_P[2][i] = 0;
    }

    float h[ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        float diff_x_squared = (rod_attach_P[0][i] - servo_attach_B[0][i]) * (rod_attach_P[0][i] - servo_attach_B[0][i]);
        float diff_y_squared = (rod_attach_P[1][i] - servo_attach_B[1][i]) * (rod_attach_P[1][i] - servo_attach_B[1][i]);
        h[i] = (float)sqrt(rod_length * rod_length + servo_arm_length * servo_arm_length - diff_x_squared - diff_y_squared) - rod_attach_P[2][i];
    }

    float home_pos[3][6] = {{0, 0, 0, 0, 0, 0},
							{0, 0, 0, 0, 0, 0},
							{h[0], h[0], h[0], h[0], h[0], h[0]},
							};
	
    float rotX[3][3];
	float rotY[3][3];
	float rotZ[3][3];
	float tempdata[3][3];
	float T_BP[3][3];
    rotXMatrix(orient.Roll, rotX);
    rotYMatrix(orient.Pitch, rotY);
    rotZMatrix(orient.Yaw, rotZ);
	arm_matrix_instance_f32 rotX_matrix;
	arm_matrix_instance_f32 rotY_matrix;
	arm_matrix_instance_f32 rotZ_matrix;
	arm_matrix_instance_f32 temp_matrix;
	arm_matrix_instance_f32 T_BP_matrix;
	arm_mat_init_f32(&rotX_matrix, 3, 3, (float32_t *)rotX);
	arm_mat_init_f32(&rotY_matrix, 3, 3, (float32_t *)rotY);
	arm_mat_init_f32(&rotZ_matrix, 3, 3, (float32_t *)rotZ);
	arm_mat_init_f32(&temp_matrix, 3, 3, (float32_t *)tempdata);
	arm_mat_init_f32(&T_BP_matrix, 3, 3, (float32_t *)T_BP);
	arm_mat_mult_f32(&rotZ_matrix, &rotY_matrix, &temp_matrix);  
	arm_mat_mult_f32(&temp_matrix, &rotX_matrix, &T_BP_matrix);

	float leg_length[ARRAY_SIZE];
	float leg[3][ARRAY_SIZE];
	float transs[3][6],tempdata1[3][6],tempdata2[3][6],tempdata3[3][6];
	transMatrix(trans,transs);
	arm_matrix_instance_f32 temp1_matrix;
	arm_matrix_instance_f32 temp2_matrix;
	arm_matrix_instance_f32 temp3_matrix;
	arm_matrix_instance_f32 leg_matrix;
	arm_matrix_instance_f32 home_matrix;
	arm_matrix_instance_f32 trans_matrix;
	arm_matrix_instance_f32 rod_matrix;
	arm_matrix_instance_f32 servo_matrix;
	
	arm_mat_init_f32(&home_matrix,3,6,(float32_t *)home_pos);
	arm_mat_init_f32(&trans_matrix,3,6,(float32_t *)transs);
	arm_mat_init_f32(&leg_matrix,3,6,(float32_t *)leg);
	arm_mat_init_f32(&rod_matrix,3,6,(float32_t *)rod_attach_P);
	arm_mat_init_f32(&servo_matrix,3,6,(float32_t *)servo_attach_B);
	arm_mat_init_f32(&temp1_matrix,3,6,(float32_t *)tempdata1);
	arm_mat_init_f32(&temp2_matrix,3,6,(float32_t *)tempdata2);
	arm_mat_init_f32(&temp3_matrix,3,6,(float32_t *)tempdata3);
	arm_mat_add_f32(&trans_matrix,&home_matrix,&temp1_matrix);
	arm_mat_mult_f32(&T_BP_matrix,&rod_matrix,&temp2_matrix);
	arm_mat_add_f32(&temp1_matrix,&temp2_matrix,&temp3_matrix);
	arm_mat_sub_f32(&temp3_matrix,&servo_matrix,&leg_matrix);
	
    for (int i = 0; i < ARRAY_SIZE; i++) 
	{    
        leg_length[i] = (float)sqrt(leg[0][i] * leg[0][i] + leg[1][i] * leg[1][i] + leg[2][i] * leg[2][i]);
    }
	
    float x_P[ARRAY_SIZE];
    float y_P[ARRAY_SIZE];
    float z_P[ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        x_P[i] = leg[0][i] + servo_attach_B[0][i];
        y_P[i] = leg[1][i] + servo_attach_B[1][i];
        z_P[i] = leg[2][i] + servo_attach_B[2][i];
    }

    float x_B[ARRAY_SIZE];
    float y_B[ARRAY_SIZE];
    float z_B[ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        x_B[i] = servo_attach_B[0][i];
        y_B[i] = servo_attach_B[1][i];
        z_B[i] = servo_attach_B[2][i];
    }

    float L[ARRAY_SIZE];
    float M[ARRAY_SIZE];
    float N[ARRAY_SIZE];
    for (int i = 0; i < ARRAY_SIZE; i++) {
        L[i] = leg_length[i] * leg_length[i] - rod_length * rod_length + servo_arm_length * servo_arm_length;
        M[i] = 2 * servo_arm_length * (z_P[i] - z_B[i]);
    }

    for (int i = 0; i < ARRAY_SIZE; i++) {
        N[i] = 2 * servo_arm_length * (cos(beta[i]) * (x_P[i] - x_B[i]) + sin(beta[i]) * (y_P[i] - y_B[i]));
        angles[i] = (float)asin(L[i] / (float)sqrt(M[i] * M[i] + N[i] * N[i])) - (float)atan2(N[i], M[i]);
		
    }

    return angles;
}

float calculateAngle(unsigned char byte1, unsigned char byte2) {
    short Raw = (byte1 << 8) | byte2; 


    if (Raw & 0x8000) {//根据维特私有协议说明，接收到的数据高位的第一位为符号位，需要判断最高位是否为1，取补码
        Raw -= 65536; 
    }

    float Angle = ((float)Raw / 32768) * 180; //此处为维特的计算公式，数值已经过上位机校验，正确可用
    return Angle;
}
float temp[6];
void anglestosevros(void)
{
	for(int i=0;i<6;i++)
	{
		if(isnan(angles[i]))
			return;
	}
	for(int i=0;i<6;i++)
	{
		
		if(i==0||i==2||i==4)
		{
			temp[i]=(float)(angles[i]*180/PI+75)*1000/240;	//单位°（度） 精度0.24°
		}
		else
		{
			temp[i]=(float)(-angles[i]*180/PI+165)*1000/240;	//单位°（度） 精度0.24°
		}
		if(temp[i]<0)temp[i]=0;
		if(temp[i]>1000)temp[i]=1000;
		Servos[i].Position=temp[i];//500
	}
	moveServosByArray(Servos,6,50);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
void sysInit(void)
{
	//moveServo(1,500,1000);
	
	calculate_stewart_platform(RadiusofBase,RadiusofPlatform,ServoArmLength,RodLength,AngleBetween,AngleBetweenPlatform,Position,Gyro);
	anglestosevros();
	HAL_Delay(1000);
	HAL_UART_Receive_DMA(&huart2,rdata,33);
	HAL_TIM_Base_Start_IT(&htim14);
}

void sysTask(void)
{
	//calculate_stewart_platform(RadiusofBase,RadiusofPlatform,ServoArmLength,RodLength,AngleBetween,AngleBetweenPlatform,Position,Gyro);
	
}
//////////////////////////////////////////////////////////////////////////////////////////////////////



void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
		if(huart->Instance==USART2)
		{
			if(rdata[22]==0x55&&rdata[23]==0x53)
            {
                  Gyro.Roll = -(calculateAngle(rdata[25],rdata[24]))*PI/180;
                  Gyro.Pitch =-(calculateAngle(rdata[27],rdata[26]))*PI/180;
                  //Gyro.Yaw = (calculateAngle(rdata[29],rdata[28]))*PI/180;
            }
			calculate_stewart_platform(RadiusofBase,RadiusofPlatform,ServoArmLength,RodLength,AngleBetween,AngleBetweenPlatform,Position,Gyro);
			anglestosevros();
			HAL_UART_Receive_DMA(&huart2,rdata,33);
		}
}



