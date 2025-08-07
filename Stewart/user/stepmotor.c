#include "stepmotor.h"

int xnum,ynum;
void setdir(int motornum,int state)
{	
	if(motornum==0)
	{
		if(state==0)
		HAL_GPIO_WritePin(GPIOD,GPIO_PIN_2,GPIO_PIN_SET);
		else
		HAL_GPIO_WritePin(GPIOD,GPIO_PIN_2,GPIO_PIN_RESET);
	}
	if(motornum==1)
	{
		if(state==0)
		HAL_GPIO_WritePin(GPIOC,GPIO_PIN_12,GPIO_PIN_SET);
		else
		HAL_GPIO_WritePin(GPIOC,GPIO_PIN_12,GPIO_PIN_RESET);
	}
}


void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
	if(xnum>0)
	{
		setdir(0,0);
		HAL_GPIO_TogglePin(GPIOC,GPIO_PIN_7);
		xnum--;
	}
	else if(xnum<0)
	{
		setdir(0,1);
		HAL_GPIO_TogglePin(GPIOC,GPIO_PIN_7);
		xnum++;
	}
	if(ynum>0)
	{
		setdir(1,0);
		HAL_GPIO_TogglePin(GPIOC,GPIO_PIN_6);
		ynum--;
	}
	else if(ynum<0)
	{
		setdir(1,1);
		HAL_GPIO_TogglePin(GPIOC,GPIO_PIN_6);
		ynum++;
	}
	
	
}

